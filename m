Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38A04E68C3
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 19:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiCXSiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346271AbiCXShw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 14:37:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF66B8213;
        Thu, 24 Mar 2022 11:36:19 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8D8171EC064F;
        Thu, 24 Mar 2022 19:36:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1648146978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wfT4qGrQwx2hfzVPs3pjnTLNsfyPOU9+w/XLbsoJcyc=;
        b=AnvFSo7qHBKE8Lir2/yiBZMNvznDG5kkwV9CXLQqyGibSBy8i1FCyZRtXQTEfrbAmdvbIo
        DKGP6T537uf3K/NqE70oBQOS3sdhBo/M056YQg3iIGY7SXu8cqPvG06AHoQIC7V3CUIup2
        cmQNSOqRbk8d2PiT/hQbBl7Ufaf4B7k=
From:   Borislav Petkov <bp@alien8.de>
To:     X86 ML <x86@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 2/3] x86/kvm/svm: Force-inline GHCB accessors
Date:   Thu, 24 Mar 2022 19:36:06 +0100
Message-Id: <20220324183607.31717-3-bp@alien8.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324183607.31717-1-bp@alien8.de>
References: <20220324183607.31717-1-bp@alien8.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

In order to fix:

  vmlinux.o: warning: objtool: __sev_es_nmi_complete()+0x4c: call to ghcb_set_sw_exit_code() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/svm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index bb2fb78523ce..eab0749262b7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -436,23 +436,23 @@ struct vmcb {
 	(offsetof(struct vmcb_save_area, field) / sizeof(u64))
 
 #define DEFINE_GHCB_ACCESSORS(field)						\
-	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
+	static __always_inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb) \
 	{									\
 		return test_bit(GHCB_BITMAP_IDX(field),				\
 				(unsigned long *)&ghcb->save.valid_bitmap);	\
 	}									\
 										\
-	static inline u64 ghcb_get_##field(struct ghcb *ghcb)			\
+	static __always_inline u64 ghcb_get_##field(struct ghcb *ghcb)		\
 	{									\
 		return ghcb->save.field;					\
 	}									\
 										\
-	static inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb)	\
+	static __always_inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb) \
 	{									\
 		return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;	\
 	}									\
 										\
-	static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)	\
+	static __always_inline void ghcb_set_##field(struct ghcb *ghcb, u64 value) \
 	{									\
 		__set_bit(GHCB_BITMAP_IDX(field),				\
 			  (unsigned long *)&ghcb->save.valid_bitmap);		\
-- 
2.35.1

