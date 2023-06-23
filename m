Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C365173BF4C
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 22:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjFWUPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 16:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjFWUPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 16:15:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E142976
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:15:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b5465a79edso5946075ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687551322; x=1690143322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=70ZfEI8a2M09RBYYQwke8NZZ3VNklBFCLgKlCnF88SM=;
        b=rL4H+NA02UlMXD1hW1Ab2Il2DwfUxUySGqZjfluyuilula6C4+hh1idRsQBC2VyXLG
         ZqLeT4rsFvCJXf30bPDw8DIL2mll1UA5Qkzd/Zs2fOB3map/hyraD34YJfAxgAnzjECy
         A9lxGseEk7jdnI+PjAIdWXTVvYyLJim7zAeA0ExxG09/+x6MzCz2bd2qWNGkCRoJ6Stw
         13aBRpBMHQMz2fjOASin93UwwuBR9lUBhYGr87g24sV5/kedXlh4Fg/yecdEURjVFTjq
         eCQpzB0KSY0uUOqY1EkdlfqBLdlDC786FZyMHiFOWNfoD7jMHSNjYHnah/yMqT0TzGfA
         Es5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687551322; x=1690143322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70ZfEI8a2M09RBYYQwke8NZZ3VNklBFCLgKlCnF88SM=;
        b=AxfF2x5fjSePHm9SOrIIkdVF8oxpQfnX+yyeMsgYykOQdRMJD8TzLsqVScxwvLsnp+
         z5nMQPLzf4AsOu5uQew6b00Sz3iU2eYeFjsew3ZIKZKdSRaZ1alKg/l+PJs/EAS0lyvZ
         kZTXtEZizCkxFfb1R/F94V2oqmcF5tZ5uqIt2UgGQ7KvizXc7JE/05suBb/7MdF3WgOR
         LICX0kSJZMFGfBrTxs7SPOrSQhyVk17/hEPQz/0oi4i/DWMjvYac97c9UaFIyvzR0ReV
         Ov87UtPE2rat4/GQnVifoCvqrukfPCiMqVJhN8UKhyJVriT1ZMuQiO4eS83MS5u3gORI
         nzwg==
X-Gm-Message-State: AC+VfDwJM7N7z5hNaIMkUBwuOuTvL9mc3rPnGtMXZORcGS8wYpJqi9aX
        y2e3jn3ixpsgTnkP+wsA61foT/kjwkU=
X-Google-Smtp-Source: ACHHUZ6IVfy4CB7jZj+9RHdPho3mt4NHvkwGRcJXGSQRfyQAO/+wXZZtHfvg27XlZc8Y5VNaR+f518bFkgY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b288:b0:1b3:edae:882b with SMTP id
 u8-20020a170902b28800b001b3edae882bmr18939plr.12.1687551322098; Fri, 23 Jun
 2023 13:15:22 -0700 (PDT)
Date:   Fri, 23 Jun 2023 13:15:20 -0700
In-Reply-To: <20230616113353.45202-3-xiong.y.zhang@intel.com>
Mime-Version: 1.0
References: <20230616113353.45202-1-xiong.y.zhang@intel.com> <20230616113353.45202-3-xiong.y.zhang@intel.com>
Message-ID: <ZJX9WHFPdEVjRtC+@google.com>
Subject: Re: [PATCH 2/4] KVM: VMX/pmu: Save host debugctlmsr just before vm entry
From:   Sean Christopherson <seanjc@google.com>
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Xiong Zhang wrote:
> Perf defines four types of perf event: per cpu pinned event, per process
> pinned event, per cpu event, per process event, their prioirity are from
> high to low. vLBR event is per process pinned event. So durng vm exit
> handler, if vLBR event preempts perf low priority LBR event, perf will
> disable LBR and let guest control LBR, or if vLBR event is preempted by
> perf high priority LBR event, perf will enable LBR. In a word LBR status
> may be changed during vm exit handler.
> 
> MSR_IA32_DEBUGCTLMSR[0] controls LBR enabling, kvm saves its value into
> vmx->host_debugctlmsr in vcpu_load(), and kvm restores its value from
> vmx->host_debugctlmsr after vm exit immediately. Since
> MSR_IA32_DEBUGCTLMSR[0] could be changed during vm exit handler, the
> saved value vmx->host_debugctlmsr could be wrong. So this commit saves
> MSR_IA32_DEBUGCTLMSR into vmx->host_debugctlmsr just before vm entry to
> reflect the real hardware value.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 44fb619803b8..5ca61a26d0d7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1459,13 +1459,9 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>   */
>  static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
>  	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
>  
>  	vmx_vcpu_pi_load(vcpu, cpu);
> -
> -	vmx->host_debugctlmsr = get_debugctlmsr();
>  }
>  
>  static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -7273,6 +7269,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	atomic_switch_perf_msrs(vmx);
>  	if (intel_pmu_lbr_is_enabled(vcpu))
>  		vmx_passthrough_lbr_msrs(vcpu);
> +	vmx->host_debugctlmsr = get_debugctlmsr();

Reading DEBUG_CTL on every VM-Entry is either unnecessary or insufficient.  If
the DEBUG_CTL value is being changed synchronously, then just fix whatever KVM
path leads to a change in the host avlue.  If DEBUG_CTL is being changed
asynchronously, then I'm guessing the change is coming from NMI context, which
means that KVM is buggy no matter how close we put this to VM-Enter.
