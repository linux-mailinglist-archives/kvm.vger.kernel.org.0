Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631AACB877
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfJDKix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 06:38:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45301 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbfJDKix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 06:38:53 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 46l5vZ2Hgkz9sNw; Fri,  4 Oct 2019 20:38:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1570185530;
        bh=6ZYAP3kzygIvshHZBkrCIgOhh+ZjXOmnm0g1aJ4p4m8=;
        h=From:To:Cc:Subject:Date:From;
        b=pb1FvXcOt4ClvFpDA07cag6IunhntVyApGw7VA/Srgc7/IJk+7VDMPZ/aZFvMP0cQ
         qY7Dye93O1U0YS/u3RfoXe1htmaUixXK3320U0+MKYxxw9DnOz3EnRdrc4J0zTHoL4
         CddYkk1Gg2ZuGuLLGDHI/kjgZNIdtGcQFv6nk9HQ=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     lvivier@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
Date:   Fri,  4 Oct 2019 20:38:44 +1000
Message-Id: <20191004103844.32590-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to call RTAS functions on powerpc kvm-unit-tests relies on the
RTAS blob supplied by qemu.  But new versions of qemu don't supply an RTAS
blob: since the normal way for guests to get RTAS is to call the guest
firmware's instantiate-rtas function, we now rely on that guest firmware
to provide the RTAS code itself.

But qemu-kvm-tests bypasses the usual guest firmware to just run itself,
so we can't get the rtas blob from SLOF.

But.. in fact the RTAS blob under qemu is a bit of a sham anyway - it's
a tiny wrapper that forwards the RTAS call to a hypercall.  So, we can
just invoke that hypercall directly.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 lib/powerpc/asm/hcall.h |  3 +++
 lib/powerpc/rtas.c      |  6 +++---
 powerpc/cstart64.S      | 20 ++++++++++++++++----
 3 files changed, 22 insertions(+), 7 deletions(-)

So.. "new versions of qemu" in this case means ones that incorporate
the pull request I just sent today.

diff --git a/lib/powerpc/asm/hcall.h b/lib/powerpc/asm/hcall.h
index a8bd7e3..1173fea 100644
--- a/lib/powerpc/asm/hcall.h
+++ b/lib/powerpc/asm/hcall.h
@@ -24,6 +24,9 @@
 #define H_RANDOM		0x300
 #define H_SET_MODE		0x31C
 
+#define KVMPPC_HCALL_BASE	0xf000
+#define KVMPPC_H_RTAS		(KVMPPC_HCALL_BASE + 0x0)
+
 #ifndef __ASSEMBLY__
 /*
  * hcall_have_broken_sc1 checks if we're on a host with a broken sc1.
diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
index 2e7e0da..41c0a24 100644
--- a/lib/powerpc/rtas.c
+++ b/lib/powerpc/rtas.c
@@ -46,9 +46,9 @@ void rtas_init(void)
 	prop = fdt_get_property(dt_fdt(), node,
 				"linux,rtas-entry", &len);
 	if (!prop) {
-		printf("%s: /rtas/linux,rtas-entry: %s\n",
-				__func__, fdt_strerror(len));
-		abort();
+		/* We don't have a qemu provided RTAS blob, enter_rtas
+		 * will use H_RTAS directly */
+		return;
 	}
 	data = (u32 *)prop->data;
 	rtas_entry = (unsigned long)fdt32_to_cpu(*data);
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index ec673b3..972851f 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -121,13 +121,25 @@ halt:
 
 .globl enter_rtas
 enter_rtas:
+	LOAD_REG_ADDR(r11, rtas_entry)
+	ld	r10, 0(r11)
+
+	cmpdi	r10,0
+	bne	external_rtas
+
+	/* Use H_RTAS directly */
+	mr	r4,r3
+	lis	r3,KVMPPC_H_RTAS@h
+	ori	r3,r3,KVMPPC_H_RTAS@l
+	b	hcall
+
+external_rtas:
+	/* Use external RTAS blob */
 	mflr	r0
 	std	r0, 16(r1)
 
-	LOAD_REG_ADDR(r10, rtas_return_loc)
-	mtlr	r10
-	LOAD_REG_ADDR(r11, rtas_entry)
-	ld	r10, 0(r11)
+	LOAD_REG_ADDR(r11, rtas_return_loc)
+	mtlr	r11
 
 	mfmsr	r11
 	LOAD_REG_IMMEDIATE(r9, RTAS_MSR_MASK)
-- 
2.21.0

