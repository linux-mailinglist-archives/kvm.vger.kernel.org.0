Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9705F654602
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 19:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiLVScH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 13:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiLVScF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 13:32:05 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BE21A3A9
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 10:32:04 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u7so2765712plq.11
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 10:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=diDXt1oiDTYYx+8T5X5MAg+oSyu87V+IQcU8UuO/bT8=;
        b=Y1DXhnLRuVIKSL/hOJKfvpsDdGQDbEdO5M18e4MXIZPLXvz9VecS07A8CeqU+QzDV0
         h98yaU63vhqQ3gkUN6YTnJc5rP5xMXXKl/pMBb30TRo+lWRCUYupW9uKxWaBUFya42rY
         jwyUiJxU8BAZ0FlPJOHRKyjnHkmNPSS7c7GA6uPuqdU6aSu54Zwp+jVfwPaz93PVrOqx
         w6gYl64rmL4KwTTqvT6iVSCYZP5Q1xzuIkuICJ+jo5Wc54WqehH8TMIn0HcQ+J7RmFU2
         qeg2Q2fOQMOklkZCPOjnrt2bIDRvYiqmflDd1Kl8UEkRPEipw4/SbPwuFu0E0L8w15H0
         lL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diDXt1oiDTYYx+8T5X5MAg+oSyu87V+IQcU8UuO/bT8=;
        b=za1iFR5bmPhFSLn+3cUlpjK9NBt/1X8qmqgdBFz6OrpBHSLNNZz1Uuj82DqpVTqkeo
         jc6lFygcxYSnHnYHsRZbLlYOrCdkmZwXbMhdMP25Msu0KgQLcfs0TDmzDWdm2qS4WC0d
         wtbC1AaynBmfOCdMzk5m5pFGWKMHKovD0YB/Le8xi5GK47hyU9fUFkNb7VhiFh77sEvj
         5ubApjVOR7QRlyY0Qu42r7JX1b1gD9Y+9rJITs01iVkq/aw3ebE7cUA6O+etT6SeDfmN
         iss8udEetbWX7DK8opBwBmj+poJllXP7MfL99ukcrod+VP0PH76JWLcKHKEAPNlsBuVf
         VZRQ==
X-Gm-Message-State: AFqh2kpwvEuedFv/xkOThB/j2fxAvwsa4HH4eaBuo44bzeUQmBTCXZNp
        7tnO/djiGsubxNh2WfWaB/B8myrzYlzludXs
X-Google-Smtp-Source: AMrXdXuHe5bFWv9dlBVk/46Ykx3FR+o21ilS7idgRhcvRxes2Ivb3UoF23cHSQqTaY0zvEbur9DgIQ==
X-Received: by 2002:a05:6a21:339a:b0:a7:891b:3601 with SMTP id yy26-20020a056a21339a00b000a7891b3601mr1406077pzb.1.1671733923687;
        Thu, 22 Dec 2022 10:32:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b00189ac5a2340sm860204plg.124.2022.12.22.10.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 10:32:03 -0800 (PST)
Date:   Thu, 22 Dec 2022 18:31:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zhang Chen <chen.zhang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Message-ID: <Y6Sin1bmLN10yvMw@google.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com>
 <Y5oviY0471JytWPo@google.com>
 <Y6BtcutjgcgE8dsv@gao-cwp>
 <Y6Cb2OrkQ8X3IvW5@google.com>
 <Y6G77CTIk8CvtTLn@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6G77CTIk8CvtTLn@gao-cwp>
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

On Tue, Dec 20, 2022, Chao Gao wrote:
> On Mon, Dec 19, 2022 at 05:14:00PM +0000, Sean Christopherson wrote:
> >On Mon, Dec 19, 2022, Chao Gao wrote:
> >> On Wed, Dec 14, 2022 at 08:18:17PM +0000, Sean Christopherson wrote:
> >> > To me, this looks like Intel is foisting a paravirt interface on KVM and other
> >> > hypervisors without collaborating with said hypervisors' developers and maintainers.
> >> >
> >> >I get that some of the mitigations are vendor specific, but things like RETPOLINE
> >> >aren't vendor specific.  I haven't followed all of the mitigation stuff very
> >> >closely, but I wouldn't be surprised if there are mitigations now or in the future
> >> >that are common across architectures, e.g. arm64 and x86-64.  Intel doing its own
> >> >thing means AMD and arm64 will likely follow suit, and suddenly KVM is supporting
> >> >multiple paravirt interfaces for very similar things, without having any control
> >> >over the APIs.  That's all kinds of backwards.
> >> 
> >> But if the interface is defined by KVM rather than Intel, it will likely end up
> >> with different interfaces for different VMMs, then Linux guest needs to support
> >> all of them. And KVM needs to implement Hyper-V's and Xen's interface to support
> >> Hyper-V enlightened and Xen enlightened guest. This is a _real_ problem and
> >> complicates KVM/Linux in a similar way as multiple paravirt interfaces.
> >
> >I never said the PV interfaces should be defined by KVM.  I 100% agree that any
> >one hypervisor defining its own interface will suffer the same problem.
> 
> I am thinking there are only two options:
> 
> 1. Intel defines the interface.
> 2. Every VMM defines its own interface.
> 
> Any middle ground between the two options?

Work with other x86 hardware vendors to define a common interface?  Ask hypervisor
developers to define a common, extensible interface?

Maybe it turns out that it's impossible to abstract anything away and everything
ends up being vendor-specific anyways, but not even trying to provide a common
interace is extremely frustrating, especially since all this mitigation stuff has
been going on for ~5 years.  There's been plenty of time to establish relationships
and points of contact.

> >I think having a PV interface for coordinating mitigations between host and guest
> >is a great idea.  What I don't like is tying the interface to "hardware" and defining
> 
> Do you think something below is better than the intel-defined interface?

No, KVM doing its own thing would only exacerbate the issue.

> add a new KVM_CAP_* and a KVM_FEATURE_* in hypervisor CPUID leaf to enumerate
> the interface. And add a new virtual MSR 0x4b564dxx for guest to report in-use
> software mitigations and assign one bit for each software mitigation. On MSR
> write emulation, call into vmx code to enable some hardware mitigations if
> the corresponding software mitigations are not effective on host.
> 
> I am afraid it is late to switch to above approach because e.g., if Hyper-V
> decides to support the intel-defined interface, KVM probably needs to support it
> for Hyper-V guests.

Hence my frustration.
