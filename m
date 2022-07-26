Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA47581626
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiGZPMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiGZPMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:12:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 770302F02A
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658848358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vehArfK5T2n7JAf+khB4WlDidxMKRqvL7hvM6jmkdx4=;
        b=HSL6EeblUpNeWJJ7Nu/8UaAQCwAyAkfNu+HrgaiFzeKke6sxYLc3Nulqq6qN5wrLChxMwO
        yIcs3FET9RSUE0whlc6dJG+E9VH9z08niuU9OJXVSbqqRAf+xdAAPkdpfd2tXiQM7zm+nD
        9xiQw1L0CYQ0dT+vKfWLE0Drsy0qPKI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-PZ_lcczGNaG7VcDcAKaI9g-1; Tue, 26 Jul 2022 11:12:35 -0400
X-MC-Unique: PZ_lcczGNaG7VcDcAKaI9g-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a056402268f00b0043be4012ea9so4777941edd.4
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vehArfK5T2n7JAf+khB4WlDidxMKRqvL7hvM6jmkdx4=;
        b=Kj99neFDYnXXoiE1DB3CEaxKCWg//bw38dyuIX68UEKfSXWeDLTXUhFLz2Y35pLrQt
         B4zrPxBnQgX4ClFLBDVZ88mWVKH6u0vCmvmyjXDC6YDj0w9GcLhWZ4bomZz+UvLuNjg2
         HPNbOP3rA3EAxBNZcPRkeW2GHtZmBLbqKiMt3Y9qMykvQFdBNimDRtV3zUQ6yus2985r
         oYbN6ZTirgTzRT9Ukytkmhm7aM4HzPon8Qf9ck/Xyw766tnT2Y2/bFDNHJMGefvh13i2
         4Hr9TTUraUa1tfpo9iErG+aV61aAaJATtY9q2Juic0NTXDV71hgROE3/k9vOOjefK2Xy
         S9Bg==
X-Gm-Message-State: AJIora++T6cQ/gpYuJHoElV9UxT0Mq1hOywfsFSt0PGxqwKpTe4yZYhw
        2690AETLyZOzfGHG1izk/LALdp5+Hsv4c8+ku0VfyqHYqwiIycamcB/HgtputvfV81hjcM9k096
        8ZhygY6pAmsVS2RPswGOs0If0m1fic3s8Us9wcn6kFazKxaHmLEYKJr9L1/CZFXRE
X-Received: by 2002:a17:906:5a49:b0:72b:1432:25fc with SMTP id my9-20020a1709065a4900b0072b143225fcmr14308825ejc.405.1658848354461;
        Tue, 26 Jul 2022 08:12:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sVxBiyBcdz+lke561s4NlvwSvRDOSLyHZtx5PVQgO9Hev8f0XvlvMB9RdVGyPJTO89Iktsjw==
X-Received: by 2002:a17:906:5a49:b0:72b:1432:25fc with SMTP id my9-20020a1709065a4900b0072b143225fcmr14308793ejc.405.1658848353820;
        Tue, 26 Jul 2022 08:12:33 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.184])
        by smtp.gmail.com with ESMTPSA id kx20-20020a170907775400b0072aa014e852sm6498820ejc.87.2022.07.26.08.12.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 08:12:33 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: add and use *_BIT constants for CR0, CR4, EFLAGS
Date:   Tue, 26 Jul 2022 17:12:32 +0200
Message-Id: <20220726151232.92584-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "BIT" macro cannot be used in top-level assembly statements
(it can be used in functions through the "i" constraint).  To
avoid having to hard-code EFLAGS.AC being bit 18, define the
constants for CR0, CR4 and EFLAGS bits in terms of new macros
for just the bit number.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/processor.h | 164 +++++++++++++++++++++++++++++---------------
 x86/smap.c          |   2 +-
 2 files changed, 109 insertions(+), 57 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index fb87198..0324220 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -31,67 +31,119 @@
 #define AC_VECTOR 17
 #define CP_VECTOR 21
 
-#define X86_CR0_PE	BIT(0)
-#define X86_CR0_MP	BIT(1)
-#define X86_CR0_EM	BIT(2)
-#define X86_CR0_TS	BIT(3)
-#define X86_CR0_ET	BIT(4)
-#define X86_CR0_NE	BIT(5)
-#define X86_CR0_WP	BIT(16)
-#define X86_CR0_AM	BIT(18)
-#define X86_CR0_NW	BIT(29)
-#define X86_CR0_CD	BIT(30)
-#define X86_CR0_PG	BIT(31)
+#define X86_CR0_PE_BIT		(0)
+#define X86_CR0_PE		BIT(X86_CR0_PE_BIT)
+#define X86_CR0_MP_BIT		(1)
+#define X86_CR0_MP		BIT(X86_CR0_MP_BIT)
+#define X86_CR0_EM_BIT		(2)
+#define X86_CR0_EM		BIT(X86_CR0_EM_BIT)
+#define X86_CR0_TS_BIT		(3)
+#define X86_CR0_TS		BIT(X86_CR0_TS_BIT)
+#define X86_CR0_ET_BIT		(4)
+#define X86_CR0_ET		BIT(X86_CR0_ET_BIT)
+#define X86_CR0_NE_BIT		(5)
+#define X86_CR0_NE		BIT(X86_CR0_NE_BIT)
+#define X86_CR0_WP_BIT		(16)
+#define X86_CR0_WP		BIT(X86_CR0_WP_BIT)
+#define X86_CR0_AM_BIT		(18)
+#define X86_CR0_AM		BIT(X86_CR0_AM_BIT)
+#define X86_CR0_NW_BIT		(29)
+#define X86_CR0_NW		BIT(X86_CR0_NW_BIT)
+#define X86_CR0_CD_BIT		(30)
+#define X86_CR0_CD		BIT(X86_CR0_CD_BIT)
+#define X86_CR0_PG_BIT		(31)
+#define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
 
-#define X86_CR4_VME		BIT(0)
-#define X86_CR4_PVI		BIT(1)
-#define X86_CR4_TSD		BIT(2)
-#define X86_CR4_DE		BIT(3)
-#define X86_CR4_PSE		BIT(4)
-#define X86_CR4_PAE		BIT(5)
-#define X86_CR4_MCE		BIT(6)
-#define X86_CR4_PGE		BIT(7)
-#define X86_CR4_PCE		BIT(8)
-#define X86_CR4_OSFXSR		BIT(9)
-#define X86_CR4_OSXMMEXCPT	BIT(10)
-#define X86_CR4_UMIP		BIT(11)
-#define X86_CR4_LA57		BIT(12)
-#define X86_CR4_VMXE		BIT(13)
-#define X86_CR4_SMXE		BIT(14)
-/* UNUSED			BIT(15) */
-#define X86_CR4_FSGSBASE	BIT(16)
-#define X86_CR4_PCIDE		BIT(17)
-#define X86_CR4_OSXSAVE		BIT(18)
-#define X86_CR4_KL		BIT(19)
-#define X86_CR4_SMEP		BIT(20)
-#define X86_CR4_SMAP		BIT(21)
-#define X86_CR4_PKE		BIT(22)
-#define X86_CR4_CET		BIT(23)
-#define X86_CR4_PKS		BIT(24)
+#define X86_CR4_VME_BIT		(0)
+#define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
+#define X86_CR4_PVI_BIT		(1)
+#define X86_CR4_PVI		BIT(X86_CR4_PVI_BIT)
+#define X86_CR4_TSD_BIT		(2)
+#define X86_CR4_TSD		BIT(X86_CR4_TSD_BIT)
+#define X86_CR4_DE_BIT		(3)
+#define X86_CR4_DE		BIT(X86_CR4_DE_BIT)
+#define X86_CR4_PSE_BIT		(4)
+#define X86_CR4_PSE		BIT(X86_CR4_PSE_BIT)
+#define X86_CR4_PAE_BIT		(5)
+#define X86_CR4_PAE		BIT(X86_CR4_PAE_BIT)
+#define X86_CR4_MCE_BIT		(6)
+#define X86_CR4_MCE		BIT(X86_CR4_MCE_BIT)
+#define X86_CR4_PGE_BIT		(7)
+#define X86_CR4_PGE		BIT(X86_CR4_PGE_BIT)
+#define X86_CR4_PCE_BIT		(8)
+#define X86_CR4_PCE		BIT(X86_CR4_PCE_BIT)
+#define X86_CR4_OSFXSR_BIT	(9)
+#define X86_CR4_OSFXSR		BIT(X86_CR4_OSFXSR_BIT)
+#define X86_CR4_OSXMMEXCPT_BIT	(10)
+#define X86_CR4_OSXMMEXCPT	BIT(X86_CR4_OSXMMEXCPT_BIT)
+#define X86_CR4_UMIP_BIT	(11)
+#define X86_CR4_UMIP		BIT(X86_CR4_UMIP_BIT)
+#define X86_CR4_LA57_BIT	(12)
+#define X86_CR4_LA57		BIT(X86_CR4_LA57_BIT)
+#define X86_CR4_VMXE_BIT	(13)
+#define X86_CR4_VMXE		BIT(X86_CR4_VMXE_BIT)
+#define X86_CR4_SMXE_BIT	(14)
+#define X86_CR4_SMXE		BIT(X86_CR4_SMXE_BIT)
+/* UNUSED			(15) */
+#define X86_CR4_FSGSBASE_BIT	(16)
+#define X86_CR4_FSGSBASE	BIT(X86_CR4_FSGSBASE_BIT)
+#define X86_CR4_PCIDE_BIT	(17)
+#define X86_CR4_PCIDE		BIT(X86_CR4_PCIDE_BIT)
+#define X86_CR4_OSXSAVE_BIT	(18)
+#define X86_CR4_OSXSAVE		BIT(X86_CR4_OSXSAVE_BIT)
+#define X86_CR4_KL_BIT		(19)
+#define X86_CR4_KL		BIT(X86_CR4_KL_BIT)
+#define X86_CR4_SMEP_BIT	(20)
+#define X86_CR4_SMEP		BIT(X86_CR4_SMEP_BIT)
+#define X86_CR4_SMAP_BIT	(21)
+#define X86_CR4_SMAP		BIT(X86_CR4_SMAP_BIT)
+#define X86_CR4_PKE_BIT		(22)
+#define X86_CR4_PKE		BIT(X86_CR4_PKE_BIT)
+#define X86_CR4_CET_BIT		(23)
+#define X86_CR4_CET		BIT(X86_CR4_CET_BIT)
+#define X86_CR4_PKS_BIT		(24)
+#define X86_CR4_PKS		BIT(X86_CR4_PKS_BIT)
 
-#define X86_EFLAGS_CF		BIT(0)
-#define X86_EFLAGS_FIXED	BIT(1)
-#define X86_EFLAGS_PF		BIT(2)
-/* RESERVED 0			BIT(3) */
-#define X86_EFLAGS_AF		BIT(4)
-/* RESERVED 0			BIT(5) */
-#define X86_EFLAGS_ZF		BIT(6)
-#define X86_EFLAGS_SF		BIT(7)
-#define X86_EFLAGS_TF		BIT(8)
-#define X86_EFLAGS_IF		BIT(9)
-#define X86_EFLAGS_DF		BIT(10)
-#define X86_EFLAGS_OF		BIT(11)
+#define X86_EFLAGS_CF_BIT	(0)
+#define X86_EFLAGS_CF		BIT(X86_EFLAGS_CF_BIT)
+#define X86_EFLAGS_FIXED_BIT	(1)
+#define X86_EFLAGS_FIXED	BIT(X86_EFLAGS_FIXED_BIT)
+#define X86_EFLAGS_PF_BIT	(2)
+#define X86_EFLAGS_PF		BIT(X86_EFLAGS_PF_BIT)
+/* RESERVED 0			(3) */
+#define X86_EFLAGS_AF_BIT	(4)
+#define X86_EFLAGS_AF		BIT(X86_EFLAGS_AF_BIT)
+/* RESERVED 0			(5) */
+#define X86_EFLAGS_ZF_BIT	(6)
+#define X86_EFLAGS_ZF		BIT(X86_EFLAGS_ZF_BIT)
+#define X86_EFLAGS_SF_BIT	(7)
+#define X86_EFLAGS_SF		BIT(X86_EFLAGS_SF_BIT)
+#define X86_EFLAGS_TF_BIT	(8)
+#define X86_EFLAGS_TF		BIT(X86_EFLAGS_TF_BIT)
+#define X86_EFLAGS_IF_BIT	(9)
+#define X86_EFLAGS_IF		BIT(X86_EFLAGS_IF_BIT)
+#define X86_EFLAGS_DF_BIT	(10)
+#define X86_EFLAGS_DF		BIT(X86_EFLAGS_DF_BIT)
+#define X86_EFLAGS_OF_BIT	(11)
+#define X86_EFLAGS_OF		BIT(X86_EFLAGS_OF_BIT)
 #define X86_EFLAGS_IOPL		GENMASK(13, 12)
-#define X86_EFLAGS_NT		BIT(14)
-/* RESERVED 0			BIT(15) */
-#define X86_EFLAGS_RF		BIT(16)
-#define X86_EFLAGS_VM		BIT(17)
-#define X86_EFLAGS_AC		BIT(18)
-#define X86_EFLAGS_VIF		BIT(19)
-#define X86_EFLAGS_VIP		BIT(20)
-#define X86_EFLAGS_ID		BIT(21)
+#define X86_EFLAGS_NT_BIT	(14)
+#define X86_EFLAGS_NT		BIT(X86_EFLAGS_NT_BIT)
+/* RESERVED 0			(15) */
+#define X86_EFLAGS_RF_BIT	(16)
+#define X86_EFLAGS_RF		BIT(X86_EFLAGS_RF_BIT)
+#define X86_EFLAGS_VM_BIT	(17)
+#define X86_EFLAGS_VM		BIT(X86_EFLAGS_VM_BIT)
+#define X86_EFLAGS_AC_BIT	(18)
+#define X86_EFLAGS_AC		BIT(X86_EFLAGS_AC_BIT)
+#define X86_EFLAGS_VIF_BIT	(19)
+#define X86_EFLAGS_VIF		BIT(X86_EFLAGS_VIF_BIT)
+#define X86_EFLAGS_VIP_BIT	(20)
+#define X86_EFLAGS_VIP		BIT(X86_EFLAGS_VIP_BIT)
+#define X86_EFLAGS_ID_BIT	(21)
+#define X86_EFLAGS_ID		BIT(X86_EFLAGS_ID_BIT)
 
 #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
 			X86_EFLAGS_ZF | X86_EFLAGS_SF | X86_EFLAGS_OF)
diff --git a/x86/smap.c b/x86/smap.c
index 0994c29..3f63ee1 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -39,7 +39,7 @@ asm ("pf_tss:\n"
 #endif
 	"add $"S", %"R "sp\n"
 #ifdef __x86_64__
-	"orl $" xstr(X86_EFLAGS_AC) ", 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry
+	"orl $(1<<" xstr(X86_EFLAGS_AC_BIT) "), 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry
 #endif
         "iret"W" \n\t"
         "jmp pf_tss\n\t");
-- 
2.36.1

