Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B260C5A99C5
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 16:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbiIAONF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiIAONE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 10:13:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5055C65255
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 07:13:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o4so17286036pjp.4
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 07:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ykCshDeZ61ZZ/vkL3R+EuwdKCNbdXXwsdoUEjEdbwdQ=;
        b=qmqwyM6QLvOyy/NksQ/znaqhrjGktO4iWyd/wg/8Y/ejpkNQ+vMG8ssvLbwA75HiBJ
         9t0d93vgiaUAwdRl+JsGmX6oiVa5JXacgjvVtH/i5iHHGiAGhROybji/gNddGgwemhZx
         sBeJPleTlX9s25Z1w8LnoAqjmY26Q1kKqkN6esZ4a3WHqnUJMPOLPx4NX9iGJUE3vYOa
         +75n45CQS5lVZ3DTKaLCgwMdCKfFBW5QSKKdAk6mkk2y4fNZVg9Fr2tqHixMicek2cNg
         NCMYwycAPtoyJ5lXZuyN+W0ywNtQada2rdQJgabHnh1mO2qxXxQkbCBsHz//cUBBmG3K
         GECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ykCshDeZ61ZZ/vkL3R+EuwdKCNbdXXwsdoUEjEdbwdQ=;
        b=EygUErRbDmeJR5vndvSnx5tKD+eTe04WGDyRA4lwBY6pftsvtatjWjSlXkWZLvmYUy
         rvwDAJj2Ul1eG1AfAJ2cOEkw8m0NGqEyvPIsB5aYRtX1SUF59qIUlam47S7JAcH0AzB+
         5JbTIaEFuGxTH5JcD5NJYJvQTcgBXDoB1GykaLlwWU0dTjjidaYgE5mx7exNq4gT0WTr
         2MHq8AzAA5w5ZQuSW1krCzMpiWiY2sHg3Pfm3jeq5bfyyWa1wpLpsN3fM0CmgmojLT8U
         kERlpjjhoMO/fq+ZGdZAECoPXD7S/dQoRN6ZP8HvN48aF1tBsdzYvgO9c3OBoF80U7TG
         QDwA==
X-Gm-Message-State: ACgBeo0iAFjAiJvrqc4c1c4OljRAh/+g0QDjwY9tkyJR5yQ7ORmLsv2F
        gCRlmUMj2C0neHCdUU0hpYSUJg==
X-Google-Smtp-Source: AA6agR4IKVSL3I0rYJ8tB774zV5DQozPt2MlXv410VyIq1cId6sZyhuvW4hQkZSzRPbXjsQrsQVE3A==
X-Received: by 2002:a17:903:2102:b0:174:4d5f:8abf with SMTP id o2-20020a170903210200b001744d5f8abfmr28211096ple.11.1662041580361;
        Thu, 01 Sep 2022 07:13:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902e5c700b0017550eaa3eesm2661099plf.71.2022.09.01.07.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 07:12:59 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:12:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 01/19] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Message-ID: <YxC96HujrBAwlgK0@google.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <f63a395ead4204d44cab3b734c99b07f54c38463.1661860550.git.isaku.yamahata@intel.com>
 <YxBDRaAyRpyz/5Q+@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxBDRaAyRpyz/5Q+@gao-cwp>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022, Chao Gao wrote:
> On Tue, Aug 30, 2022 at 05:01:16AM -0700, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >KVM/X86 uses user return notifier to switch MSR for guest or user space.
> >Snapshot host values on CPU online, change MSR values for guest, and
> >restore them on returning to user space.  The current code abuses
> >kvm_arch_hardware_enable() which is called on kvm module initialization or
> >CPU online.
> >
> >Remove such the abuse of kvm_arch_hardware_enable by capturing the host
> >value on the first change of the MSR value to guest VM instead of CPU
> >online.
> >
> >Suggested-by: Sean Christopherson <seanjc@google.com>
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> > arch/x86/kvm/x86.c | 43 ++++++++++++++++++++++++-------------------
> > 1 file changed, 24 insertions(+), 19 deletions(-)
> >
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 205ebdc2b11b..16104a2f7d8e 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -200,6 +200,7 @@ struct kvm_user_return_msrs {
> > 	struct kvm_user_return_msr_values {
> > 		u64 host;
> > 		u64 curr;
> >+		bool initialized;
> > 	} values[KVM_MAX_NR_USER_RETURN_MSRS];
> 
> The benefit of having an "initialized" state for each user return MSR on
> each CPU is small. A per-cpu state looks suffice. With it, you can keep
> kvm_user_return_msr_cpu_online() and simply call the function from
> kvm_set_user_return_msr() if initialized is false on current CPU.

Yep, a per-CPU flag is I intended.  This is the completely untested patch that's
sitting in a development branch of mine.

---
 arch/x86/kvm/x86.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca76f187e4b..1328326acfae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -194,6 +194,7 @@ module_param(eager_page_split, bool, 0644);
 
 struct kvm_user_return_msrs {
 	struct user_return_notifier urn;
+	bool initialized;
 	bool registered;
 	struct kvm_user_return_msr_values {
 		u64 host;
@@ -400,18 +401,20 @@ int kvm_find_user_return_msr(u32 msr)
 	return -1;
 }
 
-static void kvm_user_return_msr_cpu_online(void)
+static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 	u64 value;
 	int i;
 
+	if (msrs->initialized)
+		return;
+
 	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
 		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
 		msrs->values[i].host = value;
 		msrs->values[i].curr = value;
 	}
+	msrs->initialized = true;
 }
 
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
@@ -420,6 +423,8 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 	int err;
 
+	kvm_user_return_msr_init_cpu(msrs);
+
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
 	if (value == msrs->values[slot].curr)
 		return 0;
@@ -11740,7 +11745,6 @@ int kvm_arch_hardware_enable(void)
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	kvm_user_return_msr_cpu_online();
 	ret = static_call(kvm_x86_hardware_enable)();
 	if (ret != 0)
 		return ret;

base-commit: a8f21d1980fbd7e877ed174142f7f572d547e611
-- 

