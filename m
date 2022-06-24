Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F05558C15
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 02:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiFXAET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 20:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiFXAES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 20:04:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E946563AC
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:04:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p3-20020a17090a428300b001ec865eb4a2so4133776pjg.3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aR3UMVXNJuFYXHEFaVui3S/bLvpbWl7F9qhTqAkCqU8=;
        b=Hqf/87S0rYc3YO1mmftbe/pRY+U84b5V2ONzOenkIThl1iQOtr+PjeA+R0o4HUhBri
         eBciKAiGzNgeX/2NDv+dn7aksHDalV0whg66lmxPfY415HpmlVhb3iqOduUz1xlFoZQH
         ehVkaaOxKag15ztDOQmEzPJzQfGSpGAcP3szyJpwMW04oc0cC8DIqSfCFCChJlZnIf3t
         UUrQXywbBR25UZjrxLdHYor3yE3VVsuXf1l+Jq+5/J/WcfLXZTTQNCOZh07PVAY8QpLz
         VPnIDUKndZnLssxPkQtTp4SmElMwALEy98cNQ5QoLeZp+dw12TnF8ZoeUNNsHGIqmKdQ
         isxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aR3UMVXNJuFYXHEFaVui3S/bLvpbWl7F9qhTqAkCqU8=;
        b=XVvJSMGI9Xu+7TwKp4hhHNsx0WXoIXzC1rRPrfnftXL+Z1po/UCx2nL9B1l3jAEdzS
         Eg5qCKp8MUqkx1V+CDETbOXMTyDA6o5aISmk0rEQ50M+8Pm5KJHhA1odnIcuxu0qHaaI
         rO6UVyyIMLv6lZ4R8RZSGEePwqS/dvgkEUvCINRd0iwAm16yOjXTZCgF80izcyxtaNX+
         Rn9IttXHZEoKaWsV26QEmUPpbc2BR24XwF37aJKv7823rDMBrNCFACYrLaEjgnD54tN7
         yqiCFnjQUWCGMUzfD9PFlh8cZT7dnp78SVtPRXf5n+dPbPg3+gdCdMTuqjICs6P8fldo
         ejNw==
X-Gm-Message-State: AJIora9SEgliFoh4+MA8+pm2/7VV94vQgBi/c2ieBFcWMuQDJQ9+hyJk
        HvDHRur8xp8MmSMtkQ2wEN098Q==
X-Google-Smtp-Source: AGRyM1tpyr8ete82+M/6LC+zY3ZuFXiGABgTIUa1dsT3jGlH8w1nZYKl2R4L+YalNDc2emkjGkDM9g==
X-Received: by 2002:a17:902:f602:b0:16a:178a:7b0b with SMTP id n2-20020a170902f60200b0016a178a7b0bmr27032003plg.20.1656029056747;
        Thu, 23 Jun 2022 17:04:16 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id x5-20020a17090a1f8500b001e87bd6f6c2sm2513931pja.50.2022.06.23.17.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 17:04:16 -0700 (PDT)
Date:   Fri, 24 Jun 2022 00:04:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 03/10] KVM: VMX: Move
 CPU_BASED_{CR3_LOAD,CR3_STORE,INVLPG}_EXITING filtering out of
 setup_vmcs_config()
Message-ID: <YrT/fHgxKUrsH7fE@google.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
 <20220622164432.194640-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622164432.194640-4-vkuznets@redhat.com>
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

On Wed, Jun 22, 2022, Vitaly Kuznetsov wrote:
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 01294a2fc1c1..4583de7f0324 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4293,6 +4293,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  			  CPU_BASED_MONITOR_TRAP_FLAG |
>  			  CPU_BASED_PAUSE_EXITING);
>  
> +	if (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_EPT) {
> +		/*
> +		 * CR3 accesses and invlpg don't need to cause VM Exits when EPT
> +		 * enabled.
> +		 */
> +		exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
> +				  CPU_BASED_CR3_STORE_EXITING |
> +				  CPU_BASED_INVLPG_EXITING);
> +	}

No need to clear them based on support, just invert the logic so that KVM leaves
them set in the base config and then cleares them if EPT is enabled (instead of
clearing them if EPT is supported and then restoring them if EPT is disabled via
module param).

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 23 Jun 2022 17:00:58 -0700
Subject: [PATCH] KVM: VMX: Clear controls obsoleted by EPT at runtime, not
 setup

Clear the CR3 and INVLPG interception controls at runtime based on
whether or not EPT is being _used_, as opposed to clearing the bits at
setup if EPT is _supported_ in hardware, and then restoring them when EPT
is not used.  Not mucking with the base config will allow using the base
config as the starting point for emulating the VMX capability MSRs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d8f28b5d6ca..f39af86a6c50 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2550,13 +2550,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	rdmsr_safe(MSR_IA32_VMX_EPT_VPID_CAP,
 		&vmx_cap->ept, &vmx_cap->vpid);

-	if (_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) {
-		/* CR3 accesses and invlpg don't need to cause VM Exits when EPT
-		   enabled */
-		_cpu_based_exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
-					     CPU_BASED_CR3_STORE_EXITING |
-					     CPU_BASED_INVLPG_EXITING);
-	} else if (vmx_cap->ept) {
+	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
+	    vmx_cap->ept) {
 		pr_warn_once("EPT CAP should not exist if not support "
 				"1-setting enable EPT VM-execution control\n");

@@ -4320,10 +4315,12 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
 	}
-	if (!enable_ept)
-		exec_control |= CPU_BASED_CR3_STORE_EXITING |
-				CPU_BASED_CR3_LOAD_EXITING  |
-				CPU_BASED_INVLPG_EXITING;
+
+	/* No need to intercept CR3 access or INVPLG when using EPT. */
+	if (enable_ept)
+		exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
+				  CPU_BASED_CR3_STORE_EXITING |
+				  CPU_BASED_INVLPG_EXITING);
 	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
 				CPU_BASED_MONITOR_EXITING);

base-commit: d365a92177bda6629885401d44fbe912106b3df6
--

