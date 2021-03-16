Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A533D739
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhCPPU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhCPPUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:20:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D230C06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 08:20:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 16so9044735pfn.5
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 08:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bTUeTwvWWTS0pXJGnTKnxeRzWQjsefOAaSTUNoKXHRk=;
        b=DeeG+lMpNh8IVk3kKHOVhbJhhbCihxLnJqt7Z/v48bjihND6O7gZ00DDWClctnNOY5
         5/m9L9oAg8S/ibySSqKEXerRkkpwS9KB13r/u11FuXUjO8EuHC1j2BSJeQfv2ATHPcyX
         FYPGLUolForW5Ld136qvS1c6Lz0FMfYqoFY+mSgkJsomOnyFU6p9fZGzPNIDXs76bFQP
         kc9zAjU9GLOE4kBaKSBZILKVi/oTxEyxR5aoS5H+oP3DTDSKyZslXA6SeK96TZK4RtIw
         6g/9EM0lS9V5wrkxP7e4/SP74rwPTDbgXBCjhdacjEWWJQlp32j/kr9qIYEyQbf7wyER
         nKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bTUeTwvWWTS0pXJGnTKnxeRzWQjsefOAaSTUNoKXHRk=;
        b=EOXClEoYkcMEY21hidft1ua9goOY/9J/iu2zXspxe0/ag+3SfH4F5YxgDTNkyuugAy
         ADQ/L/ndvHea7jdUVXaXLiI8OKCCgY+7yY5DjNEEtg+nWKlo3NYigPgfHksGpUJ5jn1q
         KyvGx2+IAAylgNCmOBdcmtAQU5BIvrr93u71VNfzRGY4SnWDzIFHVKk1K75/qlBC5rfc
         Acwn3MviG6ZuGqm0h74QegEcxYyy6DtXfEoYBzZVTCQf5/sfO6OLMV5yERzn86OGXieX
         SlLjPoPqyY67xByccaJU4ybmSZDq2FkcTT3J/qzJ7Jzl7/MeOfv5fNK8Dak7/rVxEkB8
         ClDg==
X-Gm-Message-State: AOAM532gyDV8nxYRXQfPL/qX7+pCY5QTYPCGROO/oLKb5sYO+KOwznR5
        MKoUMHC0Rny1uhq3R8MAu9efuRUBzSaovQ==
X-Google-Smtp-Source: ABdhPJxB39gYX3WKctGs3ENW5BLvoBVhwptscXrfl7Jh9tmGobppn/AMMm/MUoCxEWFPDRXWhYx/dw==
X-Received: by 2002:a63:e715:: with SMTP id b21mr178219pgi.300.1615908050640;
        Tue, 16 Mar 2021 08:20:50 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id 142sm17237301pfz.196.2021.03.16.08.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 08:20:49 -0700 (PDT)
Date:   Tue, 16 Mar 2021 08:20:43 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
Message-ID: <YFDMy9ghurF4pwuh@google.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-4-vkuznets@redhat.com>
 <YE96DDyEZ3zVgb8p@google.com>
 <87lfao8m7s.fsf@vitty.brq.redhat.com>
 <87a6r38exq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6r38exq.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Sean Christopherson <seanjc@google.com> writes:
> >
> >> On Mon, Mar 15, 2021, Vitaly Kuznetsov wrote:
> >>> @@ -1193,8 +1199,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
> >>>  	}
> >>>  	case HV_X64_MSR_REFERENCE_TSC:
> >>>  		hv->hv_tsc_page = data;
> >>> -		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE)
> >>> +		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
> >>> +			if (!host)
> >>> +				hv->hv_tsc_page_status = HV_TSC_PAGE_GUEST_CHANGED;
> >>> +			else
> >>> +				hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;
> >>
> >> Writing the status without taking hv->hv_lock could cause the update to be lost,
> >> e.g. if a different vCPU fails kvm_hv_setup_tsc_page() at the same time, its
> >> write to set status to HV_TSC_PAGE_BROKEN would race with this write.
> >>
> >
> > Oh, right you are, the lock was somewhere in my brain :-) Will do in
> > v2.
> 
> Actually no, kvm_hv_set_msr_pw() is only called from
> kvm_hv_set_msr_common() with hv->hv_lock held so we're already
> synchronized.
> 
> ... and of course I figured that our by putting another
> mutex_lock()/mutex_unlock() here and then wondering why everything hangs
> :-)

Doh, sorry :-/
