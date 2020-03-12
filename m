Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF00183530
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 16:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgCLPn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 11:43:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727240AbgCLPnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 11:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584027804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QgGQR5lmCzHdU2tw8u26Dp0LVz138MaKuXfv7AyzLc=;
        b=jUu7Nr3BveV/v6mTnLnIw7eaJ6PsPAD2b8a7INEs0gvFXjVWOOW1gBLd35P2vcfiiejpap
        nHO+BNrEJN6F2GQLhGKJUKSe++M1lgNmwc/gSTgy8QHMDOkMNsR6aHYPCaVc5NanwvVBO4
        INPcr9S0Gld/h7tWeRpkM7RStx+dVak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-dOckM3WQOfWuveQhk9MwrQ-1; Thu, 12 Mar 2020 11:43:20 -0400
X-MC-Unique: dOckM3WQOfWuveQhk9MwrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E847A100550E;
        Thu, 12 Mar 2020 15:43:17 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4D215C1B5;
        Thu, 12 Mar 2020 15:43:12 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v3 01/12] arm64: Provide read/write_sysreg_s
Date:   Thu, 12 Mar 2020 16:42:50 +0100
Message-Id: <20200312154301.9130-2-eric.auger@redhat.com>
In-Reply-To: <20200312154301.9130-1-eric.auger@redhat.com>
References: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Sometimes we need to test access to system registers which are
missing assembler mnemonics.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/sysreg.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index a03830b..a45eebd 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -38,6 +38,17 @@
 	asm volatile("msr " xstr(r) ", %x0" : : "rZ" (__val));	\
 } while (0)
=20
+#define read_sysreg_s(r) ({					\
+	u64 __val;						\
+	asm volatile("mrs_s %0, " xstr(r) : "=3Dr" (__val));	\
+	__val;							\
+})
+
+#define write_sysreg_s(v, r) do {				\
+	u64 __val =3D (u64)v;					\
+	asm volatile("msr_s " xstr(r) ", %x0" : : "rZ" (__val));\
+} while (0)
+
 asm(
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23=
,24,25,26,27,28,29,30\n"
 "	.equ	.L__reg_num_x\\num, \\num\n"
--=20
2.20.1

