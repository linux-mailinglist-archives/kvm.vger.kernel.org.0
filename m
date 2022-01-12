Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6137448C9C7
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 18:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355733AbiALRfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355777AbiALRfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 12:35:44 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B18C06175B
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:35:17 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id pj2so6427251pjb.2
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fo8lE4QdbYqQTzFRzjlVXZvX5eOpydwag3flw4LmvUQ=;
        b=hgSXLI+T64MChaZ3g/QsQT6pDRbx/AO/5oyE0i0+HJMX7QOahAgDs/EsI/wZ7LkquX
         JlpRwWrjoVEZ/Ab25GjRWyyxhQR8QHfnp5EF0GUBS3/5vHaZWOxoexmvQ04Nrm4MsUJc
         6bFxpkKcTjYOEUb86TJlSNMYLOv7DHtdpKJL8VJC5jH2GUMyKyHz2iyGTS/W15FwMqQ7
         1Bek/j4olfW7oDq3wj05cDeM6YgaCJjpLAfqYJFIESj3C2wEW5KDLetw1oBGECLwsnUy
         FVHC5DRUKLBWBJwY11l3X0YLgQgTQITdY1Xmu0E2fF82mGt1QVQFq4/1OaqLx+YhUrWr
         xwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fo8lE4QdbYqQTzFRzjlVXZvX5eOpydwag3flw4LmvUQ=;
        b=maAVpd2P6tJT8tsYai3m+oLSlTnah7/A1fAkPKdsDyAYoJ2irGOt/a0olDyrDIIOb3
         BuQf5xt5EFhMwMaeXueltE0t4IqxsSnXd+KFqTAp+im3lnFMYyPJtcPeoOoRHAkOLNGc
         5kfd85I7e5JDIEWm8iB0JB9CzOHUGMbG4Zo+/ieUd0hypSqV5mbqXhwY8JEsr0J8txY8
         HorPh/xDog3uI/jnfEKj5DOe40mvFUffrxUdKjXr6lAehKcwsrlP0SLxKwMJgnnuB6XH
         1pM3s8vkrdpV8/HogONSK6g10BT1HFnIqzGA/AzXSA3V+H161dHERY8UqWgA7GcGxFLV
         5tgA==
X-Gm-Message-State: AOAM531whlyILTIxtDr6uZjnjkIsM9PiaXFLzfcCB2bWf16YrrdtCNTC
        Gh7LxYifIU2DkI3npGhp0KZrJg==
X-Google-Smtp-Source: ABdhPJwsQDg9EvIW8Vc0P4egk9mIYuPd23rAnXs6CuXTwoqAjWoKmo9uVoDR2imPlFzCvwOEOoLSPQ==
X-Received: by 2002:a17:903:11cd:b0:149:bf70:2031 with SMTP id q13-20020a17090311cd00b00149bf702031mr717840plh.40.1642008916434;
        Wed, 12 Jan 2022 09:35:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e3sm258219pgm.51.2022.01.12.09.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 09:35:15 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:35:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: x86: Remove WARN_ON in
 kvm_arch_check_processor_compat
Message-ID: <Yd8RUJ6YpQrpe4Zf@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-6-chao.gao@intel.com>
 <Ydy6aIyI3jFQvF0O@google.com>
 <BN9PR11MB5276DEA925C72AF585E7472C8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yd3fFxg3IjWPUIqH@google.com>
 <20220112110000.GA10249@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220112110000.GA10249@gao-cwp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Chao Gao wrote:
> On Tue, Jan 11, 2022 at 07:48:39PM +0000, Sean Christopherson wrote:
> >On Tue, Jan 11, 2022, Tian, Kevin wrote:
> >> > From: Sean Christopherson <seanjc@google.com>
> >> > Sent: Tuesday, January 11, 2022 7:00 AM
> >> > 
> >> > On Mon, Dec 27, 2021, Chao Gao wrote:
> >> > > kvm_arch_check_processor_compat() needn't be called with interrupt
> >> > > disabled, as it only reads some CRs/MSRs which won't be clobbered
> >> > > by interrupt handlers or softirq.
> >> > >
> >> > > What really needed is disabling preemption. No additional check is
> >> > > added because if CONFIG_DEBUG_PREEMPT is enabled, smp_processor_id()
> >> > > (right above the WARN_ON()) can help to detect any violation.
> >> > 
> >> > Hrm, IIRC, the assertion that IRQs are disabled was more about detecting
> >> > improper usage with respect to KVM doing hardware enabling than it was
> >> > about ensuring the current task isn't migrated.  E.g. as exhibited by patch
> >> > 06, extra protections (disabling of hotplug in that case) are needed if
> >> > this helper is called outside of the core KVM hardware enabling flow since
> >> > hardware_enable_all() does its thing via SMP function call.
> >> 
> >> Looks the WARN_ON() was added by you. 😊
> >
> >Yeah, past me owes current me a beer.
> >
> >> commit f1cdecf5807b1a91829a2dc4f254bfe6bafd4776
> >> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> >> Date:   Tue Dec 10 14:44:14 2019 -0800
> >> 
> >>     KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
> >> 
> >>     Check the current CPU's reserved cr4 bits against the mask calculated
> >>     for the boot CPU to ensure consistent behavior across all CPUs.
> >> 
> >>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >> 
> >> But it's unclear to me how this WARN_ON() is related to what the commit
> >> msg tries to explain.
> >
> >Ya, the changelog and lack of a comment is awful.
> >
> >> When I read this code it's more like a sanity check on the assumption that it
> >> is currently called in SMP function call which runs the said function with
> >> interrupt disabled.
> >
> >Yes, and as above, that assertion was more about the helper not really being safe
> >for general usage as opposed to wanting to detect use from preemptible context.
> >If we end up keeping the WARN_ON, I'll happily write a comment explaining the
> >point of the assertion.
> 
> OK. I will do following changes to keep the WARN_ON():
> 1. drop this patch
> 2. disable interrupt before the call site in patch 6.

No, we shouldn't sully other code just to keep this WARN.  Again, the point of
the WARN is/was to highlight that any use outside of the hardware enabling path
is suspect.  That's why I asked if there was a way this code could identify that
the CPU in question is being hotplugged, i.e. to convey that the helper is safe
to use only during hardware enabling _or_ hotplug.  If that's not feasible,
replacing the WARN with a scary comment is better than disabling IRQs.
