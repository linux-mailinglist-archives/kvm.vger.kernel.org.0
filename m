Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E961530D36E
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 07:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhBCGeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 01:34:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:42562 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhBCGeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 01:34:19 -0500
IronPort-SDR: qkz+W5S9EwP2iEpUM58EJ5eRBsJ47DElMMald6D9AtQVpZzKC7yo/J/dDBcMG0TOxwGSbsL8R+
 iGIbi1nXylAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="168101354"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="168101354"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 22:32:32 -0800
IronPort-SDR: eU+CI7gC0dW+ChJf7Bzr49j/1Fv2RttP1txHA4qUE4G/Y1n1Oy0OP8LuVKGnlia0wXFgHcVRnR
 oWUevTXhedUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="371294394"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 02 Feb 2021 22:32:30 -0800
Message-ID: <8310773354ce83691afae0e463e42ecf5cc572f5.camel@linux.intel.com>
Subject: Re: [RFC PATCH 03/12] kvm/vmx: Introduce the new tertiary
 processor-based VM-execution controls
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Date:   Wed, 03 Feb 2021 14:32:29 +0800
In-Reply-To: <87czxt4amd.fsf@vitty.brq.redhat.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
         <87czxt4amd.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-01-25 at 10:41 +0100, Vitaly Kuznetsov wrote:
> Robert Hoo <robert.hu@linux.intel.com> writes:
> We'll have to do something about Enlightened VMCS I believe. In
> theory,
> when eVMCS is in use, 'CPU_BASED_ACTIVATE_TERTIARY_CONTROLS' should
> not
> be exposed, e.g. when KVM hosts a EVMCS enabled guest the control
> should
> be filtered out. Something like (completely untested):
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 41f24661af04..c44ff05f3235 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -299,6 +299,7 @@ const unsigned int nr_evmcs_1_fields =
> ARRAY_SIZE(vmcs_field_to_evmcs_1);
>  
>  __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>  {
> +       vmcs_conf->cpu_based_exec_ctrl &=
> ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
>         vmcs_conf->pin_based_exec_ctrl &=
> ~EVMCS1_UNSUPPORTED_PINCTRL;
>         vmcs_conf->cpu_based_2nd_exec_ctrl &=
> ~EVMCS1_UNSUPPORTED_2NDEXEC;
>  
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index bd41d9462355..bf2c5e7a4a8f 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -50,6 +50,7 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   */
>  #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
>                                     PIN_BASED_VMX_PREEMPTION_TIMER)
> +#define EVMCS1_UNSUPPORTED_EXEC_CTRL
> (CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
>  #define
> EVMCS1_UNSUPPORTED_2NDEXEC                                     \
>         (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
> |                         \
>          SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> |                      \
> 
> should do the job I think.
> 
Hi Vitaly,

I'm going to incorporate above patch in my next version. Shall I have
it your signed-off-by?
[setup_vmcs_config: filter out tertiary control when using eVMCS]
signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

