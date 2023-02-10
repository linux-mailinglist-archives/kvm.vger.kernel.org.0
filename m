Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A370B691570
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBJAb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBJAby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:31:54 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA76BB9F
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:31:53 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y4-20020a17090a2b4400b002310ecae757so3806482pjc.1
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+fQX1KYX7m+MKDXvC9TpLUvb23KTkcLLlbaBWIUtq+k=;
        b=mrSpI7sLKW8Uif58ICcPWzR9/7fsxF/m4jSPvHSMW+ojCKiCmFJBVZRkFSvzeu8Szn
         yrpBlBlCmcVEKArgHoYpXljxss3+T556owr4o/sEluhUMNoeRN3sHQau0+Nvh1wj7etQ
         wxxWmrTP5e82mSvMaGdWYEZ2Q2vheEoNYM7cGOvxEeaQKNkwNtWwvK0OlR3QFL8XAD6V
         8CDEiuW3eskkKAN+eKZ3ozQMINpDLi/CyI6+8JrkXcFTiLfJRSWB1lK92vTrYbPZMFBr
         57uWzVCaIiXIytusjrVV2JqXeaHkDKIuesgc9/t90OdLlURvO7s6pZI4XJIRz3RH7I/i
         IaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fQX1KYX7m+MKDXvC9TpLUvb23KTkcLLlbaBWIUtq+k=;
        b=eDiI8heTkJRE5t1A5Suixtb6JVY4S4/KTPhNsGaUkSo+d2Ki66OqzaEp5Bek6yVJJt
         YtBCs8KvOtEHQDdrtKZBF2qSJ/shf4phfE20uw7flca0RrOV+Pvj+GaFkr5/sIXZNUpA
         AEvj/Qvn6/O2lBnlM5tbpNqTa5q5YujNAsrarbfSIxuliqe+6/f8etvGUhL0RyQjtm9h
         c3pZwJydj0pQJExfrQdJKaCaYwRk6BcaD5SB4qTXJuqYs3cW0sOLdyY3lNc5fOeAeWDK
         2qiw4jj1kfU1wf2Di4ssqSI9rQKwRwTDECfuY5cYXaRxfobMQJZlHYZ0FaWp3W+dQRzt
         karA==
X-Gm-Message-State: AO0yUKUT3PaCjTnHOMekHlcMAihIP7mZGbq/AZ7j+vgL97wTM4NNHFP/
        T4lOFXcmYfMU4McuA8tttC0YM/tMLBI=
X-Google-Smtp-Source: AK7set/XDIzgJ/wUbZ/JDeptz3169Kgai62OVnoTGZLJBmh5XesLCtPUHinn6BcI6rrusF44ephavhiYAks=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d84:0:b0:4fb:48c8:28fb with SMTP id
 k126-20020a633d84000000b004fb48c828fbmr739276pga.122.1675989112919; Thu, 09
 Feb 2023 16:31:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:28 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-2-seanjc@google.com>
Subject: [PATCH v2 01/21] KVM: x86: Rename kvm_init_msr_list() to clarify it
 inits multiple lists
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename kvm_init_msr_list() to kvm_init_msr_lists() to clarify that it
initializes multiple lists: MSRs to save, emulated MSRs, and feature MSRs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f706621c35b8..7b91f73a837d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7071,7 +7071,7 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 	msrs_to_save[num_msrs_to_save++] = msr_index;
 }
 
-static void kvm_init_msr_list(void)
+static void kvm_init_msr_lists(void)
 {
 	unsigned i;
 
@@ -9450,7 +9450,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_caps.max_guest_tsc_khz = max;
 	}
 	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
-	kvm_init_msr_list();
+	kvm_init_msr_lists();
 	return 0;
 
 out_unwind_ops:
-- 
2.39.1.581.gbfd45094c4-goog

