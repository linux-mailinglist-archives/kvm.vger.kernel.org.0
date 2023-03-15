Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873C86BA510
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCOCSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCOCSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8792DE64
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-541a39df9f4so77695387b3.20
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vW6rX2Jrools7NRMcNdMGYee4jcJRRUYgvKMGEvobrg=;
        b=Y364NvKuiYHXVPQKv2ilaTlGGB+NYVmBmHEv/WXl3eQD5dVirC/ENEbYCF2+dBvvqo
         YYcfhE0Db/sny+jNPfIJIOjWMZqEylNqlSHyPNLAbMQeOHQ8QOJNBMpOqJxCmfByV4qn
         O52Fuy9+11w45eWdJGEOOWy2qW79uoJv+5pDRbGz1/L2nfVvRDFfnc38PDugsOFHS035
         hudW2n0zSFfjT8wYpoTBgNmg4hRl7JlO3P0QjhUYM5VpOEOho0OD/oMSUfBXEmpjllec
         5id/sLmkxSVSQlGkK6I74/hV8/ECiDafRc/U912nvr1EZ+vydlmnfyU2rP6QWlEIHKL9
         jM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vW6rX2Jrools7NRMcNdMGYee4jcJRRUYgvKMGEvobrg=;
        b=OYcFXNoyPM8Yu/PeisF3LOzAyEU0Cb+YSrYsLg35KQHyYGesdxYabIHWItDu6FT62A
         0MDL0zVAc1gg+LjcjyA0xtKvT2/hRXS74TvxDiQAut+0KZ4noiKSvNBJW2v5zPY/t0t9
         O8ykCU6lj7bP8QtIWvBhSyfjC/PCFyM0SpshN88/M3dhHDuQoSlR5DLE26gk7Sy+jVCp
         lHWTupGMepdfBTz3VaECgAa3yiaPtl50yfHADPvdrLtUAATjrK0eMolV9+sjGMxANVxN
         BluYB1ubjdT0IZtloREVg20OWdYbUY+vFRttpZtsx+B0cubEqaS41wmc/XBjfggExE5z
         mbFg==
X-Gm-Message-State: AO0yUKXqqd9h7yTF8QwhEdfPuUAqjaVMkeE9wCFISMV4gPPpe1eUz3Z/
        1uxE5a3A+y64OKPUW9DdIz+Sb7t6BtqxIg==
X-Google-Smtp-Source: AK7set9oQDiqrEOFbJ03n5ZfdXEanstD3FAVaYyn+fhysTq8Vcu8fGmxP29HhGIiX9noehtkdrmbLADhK9m4Lw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:9c43:0:b0:94a:ebba:cba6 with SMTP id
 x3-20020a259c43000000b0094aebbacba6mr19656011ybo.9.1678846686501; Tue, 14 Mar
 2023 19:18:06 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:30 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-7-amoorthy@google.com>
Subject: [WIP Patch v2 06/14] KVM: x86: Implement memory fault exit for kvm_handle_page_fault
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0b02e2c360c08..5e0140db384f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4375,7 +4375,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 #ifndef CONFIG_X86_64
 	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
 	if (WARN_ON_ONCE(fault_address >> 32))
-		return -EFAULT;
+		return kvm_mefault_exit_or_efault(
+			vcpu, fault_address, PAGE_SIZE,
+			KVM_MEMFAULT_REASON_UNKNOWN);
 #endif
 
 	vcpu->arch.l1tf_flush_l1d = true;
-- 
2.40.0.rc1.284.g88254d51c5-goog

