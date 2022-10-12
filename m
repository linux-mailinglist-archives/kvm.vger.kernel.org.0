Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E365FCC6A
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJLUvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJLUvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:51:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22207108DDE
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:51:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d24so17360994pls.4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0cESgrw4NedokYkK0txX56iX45B0Apl9vq611IjRsDE=;
        b=K+Xjqt2vlukDMMeiHLsdfv06mGk8nWaTI1Kr4m6+4FmXzj93gH8cVGsN2j6XTdR+/c
         7trslnjLMykFMPY4kIqeVvtE0VP1sOPJffTarfp9EikI4ifjLm8pHDjCp+nqMxqPVi5C
         +cEWsv3qL9Z7TqWLVqVzWCmmJLKwBg7POpN1ia89anixYRAQ9WJG7mpT/THmQaT895oM
         lDdJq8kaUaMYN7z5aIxanDy5VTRmlYFhr9SBtHlNTGmXFUEfjiiFl7wLBGizt0ESbpfc
         VlkZ6x8d/M+SR/WCUnez17A0nLnDsnyjAL1n4ZZ4My1SKV1GhQCbGHkCbNXXifqM5Jdb
         ZYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cESgrw4NedokYkK0txX56iX45B0Apl9vq611IjRsDE=;
        b=aGZzhYyWeiaZm3m0iZGY0PNxn+RQuPJ5MKWZCWplurXqLQWE3cFwhEmHjH+tOLAu+C
         BLAq8ka2Y6HPMcb0+fYpdQ91coJzu2UFMGjNnvTkxY3KS5vbJ7soE6tYQlliq2eNLyrA
         lDUble21XG52YAkGfq/WfSFAu9Beua4W32v1224vkCXUiSFem7L0ST24kSh1rCEY71gB
         Nq9XyUT112QDsEbXVDTDguOX/LtL746NKe/j4eHTLXsbERx/xA4qAlND6sYVv3g6EzcE
         ie5wvKdHpSNA9WDqgbJrvxO8QgD6Et/u1tPjewq6ex/Bm1KewsDLZsWp4Kwd2mA+myg/
         Nxew==
X-Gm-Message-State: ACrzQf3SlVA1C5YVK+gPvOjS2Ff85+MXrlUrOZ+qBVRZzrlwK7OQqGnO
        o6MkGF4DlID/MlRnzTPtNVaMa/tA0pCXbw==
X-Google-Smtp-Source: AMsMyM5F7/JWJh+KGIbMjIBvU2JtLALv7GFFGjyC/yyvTlD72ZQSRbzoPpch/DTrg+m7/k1CxVWCvQ==
X-Received: by 2002:a17:902:9a07:b0:178:8024:1393 with SMTP id v7-20020a1709029a0700b0017880241393mr31435918plp.128.1665607863453;
        Wed, 12 Oct 2022 13:51:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090341c900b0017f7bef8cfasm11201545ple.281.2022.10.12.13.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 13:51:02 -0700 (PDT)
Date:   Wed, 12 Oct 2022 20:50:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 16/30] KVM: Remove
 on_each_cpu(hardware_disable_nolock) in kvm_exit()
Message-ID: <Y0cos+UtxhvKSFIi@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <54c7065fa08a65f1fcd7f47492f1a83e6f7a3746.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c7065fa08a65f1fcd7f47492f1a83e6f7a3746.1663869838.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> hardware_enable/disable_nolock() check if the hardware is already
> enabled/disabled and work as nop when they are called multiple times.
> 
> When VM is created/destroyed, on_each_cpu(hardware_enable/disable_nolock)
> via kvm_arch_add/del_vm() and module_get/put() are called.  It means when
> kvm module is removed, it's guaranteed that there is no vm and that
> hardware_disable_nolock() was called on each cpus.
> 
> Although the module exit function, kvm_exit(), calls
> on_each_cpu(hardware_disable_nolock), it's essentially nop.  Eliminate nop
> call in kvm_exit().

Add a WARN to "prove" that this is a nop, to guard against future bugs, and to
document that it should be impossible for KVM to be unloaded with active VMs.
E.g. do this in addition to dropping the hardware disabling.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1c1a2b0630bc..ca2251d02c77 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5855,6 +5855,8 @@ void kvm_exit(void)
 {
        int cpu;
 
+       WARN_ON_ONCE(kvm_usage_count);
+
        debugfs_remove_recursive(kvm_debugfs_dir);
        misc_deregister(&kvm_dev);
        for_each_possible_cpu(cpu)

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/kvm_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ad9b8b7d21fa..d7c3bc14691f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -6034,7 +6034,6 @@ void kvm_exit(void)
>  	unregister_syscore_ops(&kvm_syscore_ops);
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
> -	on_each_cpu(hardware_disable_nolock, NULL, 1);
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
>  	kvm_irqfd_exit();


