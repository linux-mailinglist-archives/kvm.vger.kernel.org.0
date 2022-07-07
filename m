Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B439D56A7DC
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 18:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbiGGQSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 12:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiGGQSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 12:18:04 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA57715814
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 09:18:03 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w185so16654424pfb.4
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 09:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g4b8V9nVein02SaaRGxSEkwK4bSbPWw2wYDtDzzfHkA=;
        b=S1wqm/1JGuzFumHfm8KgkZ/ZmuKwtDo7fOVy8TDe4S/6DZZF3DOLf/U+gCQWD7X5dW
         mOlMPSMknLjb/VmC2bG7nJf/9Oyzf7DWQ5dfsGmm0+816UKihjMTzDE4R7trWFTzTZeR
         NWvkfug0M9MD2cvqAjyz2cOMPYl1YxrQSj9H5UTOUFTo3AddFXwj+fk6Cw58HSbuADVc
         rmx1tsUG28aI4sdXBlAgR9llS9ESRbYQcIbH3zOCC8h+hIP1vOJGTApjsKon1xSF0J0/
         5MAOO5uFIvqcZ61Yybujt6Q0k/6WH1YWdQIbTnVc2y7815JWlP4Uk2siX41L4Xknj8uj
         ZsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g4b8V9nVein02SaaRGxSEkwK4bSbPWw2wYDtDzzfHkA=;
        b=oti8UT1AfI58G5YwRoHPkuVf8kAz+y/Ln8bUR7NMVIAsbZowOPVwq6jjnJiOUnDf9V
         hLQeJNdyaDrYEzOuxSuwM2o7xs/ALpKTwF+7QDQW8jXrQE0duBOm+53/A7psoNCSv6Cj
         m7woYf+46s9gY5S2rVfElXK00Y3+L9+1Ybsc2OyefeXuAv+KXiBLlKt3lBBnk8Ggk8Va
         cq2PhIQKVdvux3dpvQKbbdHmXqH3X9m/+LhF95UnqcBITLRdRISV1wdOUdMmcC3bWgRC
         tLxhvs7eShNszlqbxI1ZB0hEo35sjnnRgFFWT87UnFH9pxHTfMyKHf3NCrw3HZhVM0F5
         0ccw==
X-Gm-Message-State: AJIora+TrNK3+m1OR6/6D1XnoyD8UNqAWH5loKsqpsAIh1XXAka3fd4/
        AwLfvbHxsVaECnz5E8yTSTS6T/JEoKww2Q==
X-Google-Smtp-Source: AGRyM1uBhqcLgaC/a3j9kzPspaK/sXU9dO4WK60ec34W+P36XvLkfgxxzr991p2xaa3KxJ2iq2PdCg==
X-Received: by 2002:a17:90a:db96:b0:1ef:8c86:eb09 with SMTP id h22-20020a17090adb9600b001ef8c86eb09mr6043973pjv.22.1657210683045;
        Thu, 07 Jul 2022 09:18:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id cq13-20020a056a00330d00b005255489187fsm27060777pfb.135.2022.07.07.09.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 09:18:02 -0700 (PDT)
Date:   Thu, 7 Jul 2022 16:17:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/28] KVM: nVMX: Introduce
 KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
Message-ID: <YscHNur0OsViyyDJ@google.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-7-vkuznets@redhat.com>
 <YsYAPL1UUKJB3/MJ@google.com>
 <87o7y1qm5t.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7y1qm5t.fsf@redhat.com>
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

On Thu, Jul 07, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Jun 29, 2022, Vitaly Kuznetsov wrote:
> >> Turns out Enlightened VMCS can gain new fields without version change
> >> and KVM_CAP_HYPERV_ENLIGHTENED_VMCS which KVM currently has cant's
> >> handle this reliably. In particular, just updating the current definition
> >> of eVMCSv1 with the new fields and adjusting the VMX MSR filtering will
> >> inevitably break live migration to older KVMs. Note: enabling eVMCS and
> >> setting VMX feature MSR can happen in any order.
> >> 
> >> Introduce a notion of KVM internal "Enlightened VMCS revision" and add
> >> a new capability allowing to add fields to Enlightened VMCS while keeping
> >> its version.
> >
> > Bumping a "minor" version number in KVM is going to be a nightmare.  KVM is going
> > to be stuck "supporting" old revisions in perpetuity, and userspace will be forced
> > to keep track of which features are available with which arbitrary revision (is
> > that information even communicated to userspace?).
> 
> My brain is certainly tainted with how we enable this in QEMU but why
> would userspace be interested in which features are actually filtered
> out?

For all the same reasons userspace wants to know what hardware features are
supported by hardware and KVM.

> Currently (again, by QEMU), eVMCS is treated as a purely software
> feature. When enabled, certain controls are filtered out "under the
> hood" as VMX MSRs reported to VMM remain unfiltered (see
> '!msr_info->host_initiated' in vmx_get_msr()). Same stays true with any
> new revision: VMM's job is just to check that a) all hardware features
> are supported on both source and destination and b) the requested 'eVMCS
> revision' is supported by both. No need to know what's filtered out and
> what isn't.

But users will inevitably want to know exactly what features a platform supports
for a given configuration.  E.g. if KVM only supported pre-configured CPU models,
KVM would need to document what features are supported by each model, and userspace
would have very little flexibility in terms of what features are exposed to the
guest.  That's an exaggerated example as there are far more CPUID features than
eVMCS features, but it's the same underlying concept.

> > I think a more maintainable approach would be to expose the "filtered" VMX MSRs to
> > userspace, e.g. add KVM_GET_EVMCS_VMX_MSRS.  Then KVM just needs to document what
> > the "filters" are for KVM versions that don't support KVM_GET_EVMCS_VMX_MSRS.
> > KVM itself doesn't need to maintain version information because it's userspace's
> > responsibility to ensure that userspace doesn't try to migrate to a KVM that doesn't
> > support the desired feature set.
> 
> That would be a reasonable (but complex for VMM) approach too but I
> don't think we need this (and this patch introducing 'eVMCS revisions'
> to this matter):

But userspace already has to deal with that complexity in raw VMX MSRs.  The
filtered values will always be a subset of the unfiltered values, so if eVMCS
will be exposed to the guest, userspace can simply treat the filtered set as the
baseline supported set, i.e. the userspace logic could simply be:

	if (expose_evmcs)
		get_evmcs_vmx_msrs(&msrs);
	else
		get_vmx_msrs(&msrs);


Userspace will need to take on more complexity if userspace wants to expose features
that are supported in hardware but not with eVMCS active, but I don't see the point
in doing so because AFAICT KVM will just override and filter the VMX MSRs anyways
when eVMCS is enabled, i.e. userspace _can't_ expose the unfiltered VMX MSRs to the
guest when eVMCS is enabled.

> luckily, Microsoft added a new PV CPUID feature bit inidicating the support
> for the new features in eVMCSv1 so KVM can just observe whether the bit was
> set by VMM or not and filter accordingly.

If there's a CPUID feature bit, why does KVM need to invent its own revision scheme?

> > That also avoids messes like unnecessarily blocking migration from "incompatible"
> > revisions when running on hardware that doesn't even support the control.
> 
> Well yea, in case the difference between 'eVMCS revisions' is void
> because the hardware doesn't support these, it would still be possible
> to migrate to an older KVM which doesn't support the new revision but
> I'd stay strict: if a newer revision was requested it must be supported,
> no matter the hardware.
