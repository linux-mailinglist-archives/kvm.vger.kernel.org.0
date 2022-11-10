Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D5E62469E
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiKJQIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiKJQIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:08:12 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE443FBA7
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:08:11 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i3so2576944pfc.11
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5i9am9ZGIzhHBarQ4CVKXjQOqS5CsjqHtn91r9AuZdM=;
        b=rCHlxMoi045zIPTBFTR5wOetTaNeBOkVIuuuu8r14JHPul4Mn37vCh8rF7AYkCs3IM
         MbhDXpEZxluZZuY3NPEmdGoBbTDk1V/4Is3bH4ebP/hirSBmgsk4RkaOWVJxhPaurltx
         Zw9XMPzoWhoCVwnQEa47lD1Xf2ySe2wodHGn7w3Z7gPKlrLegbotd84q13oxLWS8Cwg2
         u00trBRVWphIUtiHj3i6uHvO0gA5hqC+OEmkvPsf3QMNkedG9iAUyQgK0yJFbqBA383K
         J5qeiO8jhOunJisxT/Qb4CRujMm15qsTkU/EK/gqyukOSC3aDd3j7jgBdewDsmhGeZ6/
         /9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5i9am9ZGIzhHBarQ4CVKXjQOqS5CsjqHtn91r9AuZdM=;
        b=ZiS8IsJbX5gPec4XVT+ymKfGEDd613jxJ7PHKNK+32NTXhCSaflNsYIySLY+eEuOua
         aTXmAfzfIE5e4ZSTHxHPz1XbOK0hFQqbappYMU6Ry5WmElr+d2DfI9jNPCgDEJeM6MH5
         jMiCT733hlugzIR44tYEtiICVvZNHIG1SgyQoo2jTo4S5tCae4nYauPfaAhVeHjVG4gw
         PLTDf1ghu8gv/lmmy6cOIsV/ur8AzRI3SuOI63MG/ViIAsizBHD8FLbpzZeQJHVorNsb
         QJmGDrGIaiEidq/oJAKBwV9iIm2JjXP3qkqOJg4iZVf53+USiU8Q94X3BsX9WRXFZOyi
         mTZQ==
X-Gm-Message-State: ACrzQf1ynSSkDzNh35J8E70GpNYq78uxp5Oo0IcxPwArZoL/YIoGLySu
        WXzd59gDDGdxFw5MWrc8hGq+Ng==
X-Google-Smtp-Source: AMsMyM6Z1FpgZndN99IbDJkphFvBsDJk1hvm3Ux8V482SqALWj3/9wXjHDDHXuHSo9fVAqGpdujT9Q==
X-Received: by 2002:a63:1110:0:b0:46f:b040:f5a with SMTP id g16-20020a631110000000b0046fb0400f5amr48941469pgl.84.1668096490460;
        Thu, 10 Nov 2022 08:08:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a19-20020aa794b3000000b0056c2e497ad6sm10676455pfl.93.2022.11.10.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:08:09 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:08:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Liu Jingqi <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <Y20h5aynYP1DatVg@google.com>
References: <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
 <Y2Px90RQydMUoiRH@google.com>
 <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
 <Y2kfCz02tQSUkMKS@google.com>
 <20221108102120.qdlgqlgvdi6wi22u@linux.intel.com>
 <Y2qhaSr/d2ds+nqD@google.com>
 <20221110084418.t7iv5zlfgiu77gfn@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110084418.t7iv5zlfgiu77gfn@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022, Yu Zhang wrote:
> > > BTW, I found my previous understanding of what vmx_adjust_secondary_exec_control()
> > > currently does was also wrong. It could also be used for EXITING controls. And
> > > for such flags(e.g., SECONDARY_EXEC_RDRAND_EXITING), values for the nested settings
> > > (vmx->nested.msrs.secondary_ctls_high) and for the L1 execution controls(*exec_control)
> > > could be opposite. So the statement:
> > > 	"1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
> > > 	 disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes."
> > > is wrong.
> > 
> > No, it's correct.  The EXITING controls are just inverted feature flags.  E.g. if
> > RDRAND is disabled in CPUID, KVM sets the EXITING control so that KVM intercepts
> > RDRAND in order to inject #UD.
> > 
> > 	[EXIT_REASON_RDRAND]                  = kvm_handle_invalid_op,
> > 
> 
> Well, suppose
> - cpu_has_vmx_rdrand() is true;
> - meanwhile guest_cpuid_has(vcpu, X86_FEATURE_RDRAND) is false.
> 
> And then, what vmx_adjust_secondary_exec_control() currently does is:
> 1> keep the SECONDARY_EXEC_RDRAND_EXITING set in L1 secondary proc-
> based execution control.
> 2> and then clear the SECONDARY_EXEC_RDRAND_EXITING in the high bits
> of IA32_VMX_PROCBASED_CTLS2 MSR for nested by
>         vmx->nested.msrs.secondary_ctls_high &= ~control;
> That means for L1 VMM, SECONDARY_EXEC_RDRAND_EXITING must be cleared
> in its(VMCS12's) secondary proc-based VM-execution control, even when
> rdrand is disabled in L1's and L2's CPUID.

Again, it is _userspace's_ responsibility to provide a sane, consistent CPU model
to the guest.

> I wonder, for native environment, if an instruction is not supported,
> will the allowed 1-setting for its corresponding exiting feature in
> IA32_VMX_PROCBASED_CTLS2 MSR be set, or be cleared? Maybe it should
> be cleared, and executing such instruction in non-root will just get
> a #UD directly instead of triggering a VM-Exit?

For any reasonable interpretation of the SDM, it's a moot point.  The SDM doesn't
call out these scenarios for instructions like RDTSCP because they're nonsensical,
but for other instructions that can be trapped by the hypervisor and can take a
#UD when they're supported, the #UD is prioritized of the VM-Exit.  E.g. VMX
instructions have pseudocode like:

  IF not in VMX operation
    THEN #UD;
  ELSIF in VMX non-root operation
    THEN VM exit;

In other words, if the CPU doesn't recognize an instruction, it will generate a
#UD without getting to the (presumed) microcode flow that checks for VM-Exit.
