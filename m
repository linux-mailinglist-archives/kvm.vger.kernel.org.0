Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBE048B79D
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 20:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238992AbiAKTsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 14:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiAKTso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 14:48:44 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49324C061748
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:48:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p14so419723plf.3
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7IRa/e6NB6rFT1xeAvBSmwQEwtCIOQPPZwvTFtfT0gc=;
        b=fPaHSQdE3mYpMCRD0r2jIiwqBbCuUNXUK+SmiuCkGo1uYDkdrP4XrRaJuzET6B82GC
         cJaVzeUiT+8uDbOhaVn3hyIRSi5hnLR2Mjae6hQZc7liihRTJMw0XgBaF/+t/3JlL2aw
         bg9eruXJohq2EJMV79RtIhjFiUv2Lr4TKmijfheulkSqXxhtEZuU5k1YcOW9jlP+0wDd
         vWEf6UTOr49OJY+lqzZoRIsfBYe6jRQTEgcM8uM2TzD/oLE7DEypKVzTcko1h+VFigaj
         hb9yjDedHw42DGApOkoSxOB9ueAr/OibAL5TRUGTis+x0l/2DfutaODvKEh7BNdHq+8f
         4BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7IRa/e6NB6rFT1xeAvBSmwQEwtCIOQPPZwvTFtfT0gc=;
        b=5FE6SELsIBJru/I/434E1BxVac1Q8GgIcEUSe7EntRaYj8Y2Ufsb9JymYAu2rBh+hC
         F4z5Jr0xmF6V/oqqJraThPsV+4rZjzjSq7P5TOSlDyOsMkXfihbGM/X/GcnE9BoZLDF1
         xQoqWOI0/5sf6V45MaN5jS73nC3FR1Qtc54+giiZNyR4STtWjCeFiFqCbs4pd6A+ykB1
         ZxzG9i5JeHWxr8GHoOyPaJUL8+mpQ6x7iHnzUZ0HRLIW0wX5V0grtYMEfIqPyBrmfh/P
         ucJTmn0twPScjy2dgzYxhr12HnGmoxz52rdPb5SpZEQd/HFbs6GegD45CKXMEYudDShY
         KIqw==
X-Gm-Message-State: AOAM530vxfHzIM22cTksfQzL07QE5rbRMvtLelHKhL+FViEq0qBK7yKa
        MWJBXDXux4a+vbQFE+ft64KeGuhR3jgXJg==
X-Google-Smtp-Source: ABdhPJzztc3BodKbO8ZutiuVhb0R55InpNbOtbss/Y8nHomiSopp+EdSysJPbYytPupgW8FXq58MvA==
X-Received: by 2002:a63:ab08:: with SMTP id p8mr5348543pgf.617.1641930523609;
        Tue, 11 Jan 2022 11:48:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g5sm12210826pfj.143.2022.01.11.11.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:48:42 -0800 (PST)
Date:   Tue, 11 Jan 2022 19:48:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Gao, Chao" <chao.gao@intel.com>,
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
Message-ID: <Yd3fFxg3IjWPUIqH@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-6-chao.gao@intel.com>
 <Ydy6aIyI3jFQvF0O@google.com>
 <BN9PR11MB5276DEA925C72AF585E7472C8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB5276DEA925C72AF585E7472C8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Tian, Kevin wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > Sent: Tuesday, January 11, 2022 7:00 AM
> > 
> > On Mon, Dec 27, 2021, Chao Gao wrote:
> > > kvm_arch_check_processor_compat() needn't be called with interrupt
> > > disabled, as it only reads some CRs/MSRs which won't be clobbered
> > > by interrupt handlers or softirq.
> > >
> > > What really needed is disabling preemption. No additional check is
> > > added because if CONFIG_DEBUG_PREEMPT is enabled, smp_processor_id()
> > > (right above the WARN_ON()) can help to detect any violation.
> > 
> > Hrm, IIRC, the assertion that IRQs are disabled was more about detecting
> > improper usage with respect to KVM doing hardware enabling than it was
> > about ensuring the current task isn't migrated.  E.g. as exhibited by patch
> > 06, extra protections (disabling of hotplug in that case) are needed if
> > this helper is called outside of the core KVM hardware enabling flow since
> > hardware_enable_all() does its thing via SMP function call.
> 
> Looks the WARN_ON() was added by you. 😊

Yeah, past me owes current me a beer.

> commit f1cdecf5807b1a91829a2dc4f254bfe6bafd4776
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Tue Dec 10 14:44:14 2019 -0800
> 
>     KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
> 
>     Check the current CPU's reserved cr4 bits against the mask calculated
>     for the boot CPU to ensure consistent behavior across all CPUs.
> 
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> But it's unclear to me how this WARN_ON() is related to what the commit
> msg tries to explain.

Ya, the changelog and lack of a comment is awful.

> When I read this code it's more like a sanity check on the assumption that it
> is currently called in SMP function call which runs the said function with
> interrupt disabled.

Yes, and as above, that assertion was more about the helper not really being safe
for general usage as opposed to wanting to detect use from preemptible context.
If we end up keeping the WARN_ON, I'll happily write a comment explaining the
point of the assertion.
