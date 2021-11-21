Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC4458383
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 13:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbhKUM6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 07:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbhKUM6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 07:58:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66113C061574;
        Sun, 21 Nov 2021 04:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KJPYZZ7YbxCF8e4lw5Q63h+vhx2Z6IkGAc4ioCPd1zc=; b=cnsJ33e/M7n9LGUfChGbHmhPXq
        NvP9rAJBfMd6kiU/M2u5xxdIvzwLSE9aq8TbPSoZuYLVnNtMKwD7jKuB8uQ6uoT6bTzvQVqmUPFjz
        rY4Il0fBkQ4uEAEnqfd+eGoNE8PeqCgIclYY2YutLJdTXyupVE/MaMxMh+6WNvbExPlA8kV9UH6d6
        bhjTzq2Vajx8OnXyYvEtkYg9YIh57VKVeHAZCMVxEpPD+6S1V1WaTKY+i1QtxYykmegEwC0TZT855
        1ixN0NXtA0lfk1idhqZiDNiraCl1skk4F9vxuybALZEjNnwSzJ88QjCbgDVNuxDrpahOvmjnKpYuj
        QxIlC3Rw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momMw-00C3xx-7P; Sun, 21 Nov 2021 12:54:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momMw-0002WI-CY; Sun, 21 Nov 2021 12:54:54 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v5 06/12] KVM: powerpc: Use Makefile.kvm for common files
Date:   Sun, 21 Nov 2021 12:54:45 +0000
Message-Id: <20211121125451.9489-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211121125451.9489-1-dwmw2@infradead.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

It's all fairly baroque but in the end, I don't think there's any reason
for $(KVM)/irqchip.o to have been handled differently, as they all end
up in $(kvm-y) in the end anyway, regardless of whether they get there
via $(common-objs-y) and the CPU-specific object lists.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
---
 arch/powerpc/kvm/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 583c14ef596e..245f59118413 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -4,11 +4,8 @@
 #
 
 ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
-KVM := ../../../virt/kvm
 
-common-objs-y = $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
-common-objs-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
-common-objs-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
+include $(srctree)/virt/kvm/Makefile.kvm
 
 common-objs-y += powerpc.o emulate_loadstore.o
 obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
@@ -125,7 +122,6 @@ kvm-book3s_32-objs := \
 kvm-objs-$(CONFIG_KVM_BOOK3S_32) := $(kvm-book3s_32-objs)
 
 kvm-objs-$(CONFIG_KVM_MPIC) += mpic.o
-kvm-objs-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 
 kvm-objs := $(kvm-objs-m) $(kvm-objs-y)
 
-- 
2.31.1

