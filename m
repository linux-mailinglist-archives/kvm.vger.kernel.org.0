Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17B75A5339
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiH2Rdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiH2Rdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:33:51 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1F998378
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:33:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bh13so8309441pgb.4
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=88XtoZzbZveGIe6W4F/YHkUpeXUSRoxhWtsQ1gJLO0Y=;
        b=LJaqQyLKxs3mDeGI+elBZm8fcrM3+d/GXgdgigp63emskLM21WywFzIxpfkbNzbC3o
         FRzay+TVzn8Cjiy4vOeVRnbGm1Gzfol1Ot+N1DHPmmcXwiPMhujmj2t1pHgn59u6TCeV
         xSeIdUN0aD0RSqbzf+I3Zu1jGphrLU3Jltrr08erMtzDVSQk9eVn3YZCpmZ8Wq2nmLjC
         HWo2WyeWeREOYPY4AnAhy7IHESg8Bb4YMydbQENy9XLXjSA+UvZxl3lL9aLxbJjhq/bU
         sc7A4wHo/Z3npb0nGdYKfPWUKi3yqO1DOEFaleDRCqhWnMuLLMsXSBV0bGKa5Ywgts0d
         IBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=88XtoZzbZveGIe6W4F/YHkUpeXUSRoxhWtsQ1gJLO0Y=;
        b=ngaWZfqlFaA2HszDNFslZPtcyw1zOTaEs8CUKp7JDp8mWKlxoiS2N+Iy0MEkPIrOv2
         HyaxKUaK9mzPyVcgwDPJzvI4qknf3v6RNIpKlx/p9D4z981hdQqkCbvGeWcth+gBavWh
         XG7Na1Gqw59hNCGFCYrtCSQD+wfDbKgUB0avU2v/mghy7ZjIx+03MiSIxOtfyKO9qadi
         K0V/cTFndEDw7BFiMIpI02Wlu1MM4Q6uMN0o4sDDNNMctFqhSE0OE8eM0FG6diJ7C/vd
         G1tXiMb7/lvw4n6N4oNtk3HM6tKEZibTbr5M023njmZq/shsODsdz/j4Oi/tdONhTwGn
         Tz7A==
X-Gm-Message-State: ACgBeo0c4GWgMljnSiAYOFlkv7DL5w8UOOpeAMLRlWooOfIs9V6lwYeb
        NeDi7k2MDFJxUZ1A4hiwBaLaZA==
X-Google-Smtp-Source: AA6agR7q8oP/7KryicESNNPbuoFC/Z6Q/8/57egou/NQwmyr6L/ZlgPZUyO3Dw4sca0Zgib8B5HGVg==
X-Received: by 2002:a65:4c07:0:b0:427:bbde:99c with SMTP id u7-20020a654c07000000b00427bbde099cmr14892722pgq.390.1661794426448;
        Mon, 29 Aug 2022 10:33:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001fd7e56da4csm5201876pjb.39.2022.08.29.10.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 10:33:46 -0700 (PDT)
Date:   Mon, 29 Aug 2022 17:33:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Message-ID: <Ywz4diMZBB7DdITb@google.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022, Wang, Wei W wrote:
> On Thursday, August 25, 2022 4:56 PM, Xiaoyao Li wrote:
>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7f8331d6f7e..195debc1bff1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1125,37 +1125,29 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
> 
>  static void pt_guest_enter(struct vcpu_vmx *vmx)
>  {
> -       if (vmx_pt_mode_is_system())
> +       struct perf_event *event;
> +
> +       if (vmx_pt_mode_is_system() ||
> +           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))

I don't think the host should trace the guest in the host/guest mode just because
the guest isn't tracing itself.  I.e. the host still needs to turn off it's own
tracing.

>                 return;
> 
> -       /*
> -        * GUEST_IA32_RTIT_CTL is already set in the VMCS.
> -        * Save host state before VM entry.
> -        */
> -       rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> -       if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> -               wrmsrl(MSR_IA32_RTIT_CTL, 0);
> -               pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
> -               pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> -       }
> +       event = pt_get_curr_event();
> +       perf_event_disable(event);
> +       vmx->pt_desc.host_event = event;

This is effectively what I suggested[*], the main difference being that my version
adds dedicated enter/exit helpers so that perf can skip save/restore of the other
MSRs.  It's easy to extend if perf needs to hand back an event to complete the "exit.

	bool guest_trace_enabled = vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN;
	
	vmx->pt_desc.host_event = intel_pt_guest_enter(guest_trace_enabled);


and then on exit

	bool guest_trace_enabled = vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN;

	intel_pt_guest_exit(vmx->pt_desc.host_event, guest_trace_enabled);

[*] https://lore.kernel.org/all/YwecducnM%2FU6tqJT@google.com

> +       pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> }
