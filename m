Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD543E065
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 13:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhJ1MCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 08:02:09 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:51733 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbhJ1MCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 08:02:04 -0400
Received: by mail-wm1-f41.google.com with SMTP id z200so4678917wmc.1;
        Thu, 28 Oct 2021 04:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UUZZZRqs2X/yCmG5FpkNKJ3V0/nFoXe7+MUrLvu5RPY=;
        b=6a3fX8oXqGkt/1uk7Bt2CSiRCUvL36J1Kg5prFOpgXuXpOj9euV1ShWX9Bg8GANCy0
         IHX55d5pe3a2B2ss9Y2fMrEk2eEZKPF1T2pgPK0EUfnM5gW4T9ahs8MD/VHAux6I3lKK
         BPWaHTuKXzIj/H9i4pZPPEvTrHLUaxCBVo06Lfx/+CXSvhGKRM15wreXZ9bLNww4G3h9
         aR5044Dqyj9FtbDgN+mpHqRVYmEc230Pcc/r+hjYUl9Ael8oclAWXdFz72wq6N4ywmhE
         rmFUNpvslRvNtkzjIgj+P6brrpWg3XDxyKwL6TeS/J0ahfr34hnD3hlc8OWdbCOR2LvV
         sorQ==
X-Gm-Message-State: AOAM531qqZO0mWpHXiRJVilTxgeZXHkkfbhzD/oiTfXyUMFzqIywERHp
        MfvxZuyIaAS0HpPYlAt1xPE=
X-Google-Smtp-Source: ABdhPJwpMMOf7H0HdBo/7eop+RGS3mt1nTq9UCoVM+ITcPtyWGM2tl0Uo9wcJ4RGOVL2jGC5KUZbig==
X-Received: by 2002:a1c:4306:: with SMTP id q6mr2632176wma.29.1635422375199;
        Thu, 28 Oct 2021 04:59:35 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o23sm2693592wms.18.2021.10.28.04.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 04:59:34 -0700 (PDT)
Date:   Thu, 28 Oct 2021 11:59:33 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH] x86/hyperv: Protect set_hv_tscchange_cb() against
 getting preempted
Message-ID: <20211028115933.ffxaqq6yhdbmvetv@liuwe-devbox-debian-v2>
References: <20211012155005.1613352-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012155005.1613352-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 05:50:05PM +0200, Vitaly Kuznetsov wrote:
> The following issue is observed with CONFIG_DEBUG_PREEMPT when KVM loads:
> 
>  KVM: vmx: using Hyper-V Enlightened VMCS
>  BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/488
>  caller is set_hv_tscchange_cb+0x16/0x80
>  CPU: 1 PID: 488 Comm: systemd-udevd Not tainted 5.15.0-rc5+ #396
>  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0 12/17/2019
>  Call Trace:
>   dump_stack_lvl+0x6a/0x9a
>   check_preemption_disabled+0xde/0xe0
>   ? kvm_gen_update_masterclock+0xd0/0xd0 [kvm]
>   set_hv_tscchange_cb+0x16/0x80
>   kvm_arch_init+0x23f/0x290 [kvm]
>   kvm_init+0x30/0x310 [kvm]
>   vmx_init+0xaf/0x134 [kvm_intel]
>   ...
> 
> set_hv_tscchange_cb() can get preempted in between acquiring
> smp_processor_id() and writing to HV_X64_MSR_REENLIGHTENMENT_CONTROL. This
> is not an issue by itself: HV_X64_MSR_REENLIGHTENMENT_CONTROL is a
> partition-wide MSR and it doesn't matter which particular CPU will be
> used to receive reenlightenment notifications. The only real problem can
> (in theory) be observed if the CPU whose id was acquired with
> smp_processor_id() goes offline before we manage to write to the MSR,
> the logic in hv_cpu_die() won't be able to reassign it correctly.
> 
> Reported-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Applied to hyperv-next.

> ---
>  arch/x86/hyperv/hv_init.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 708a2712a516..179fc173104d 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -139,7 +139,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	struct hv_reenlightenment_control re_ctrl = {
>  		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
>  		.enabled = 1,
> -		.target_vp = hv_vp_index[smp_processor_id()]
>  	};
>  	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
>  
> @@ -153,8 +152,12 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	/* Make sure callback is registered before we write to MSRs */
>  	wmb();
>  
> +	re_ctrl.target_vp = hv_vp_index[get_cpu()];
> +
>  	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
>  	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
> +
> +	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);
>  
> -- 
> 2.31.1
> 
