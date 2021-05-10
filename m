Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F4B37948D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhEJQvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhEJQve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 12:51:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EE3C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:50:28 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p4so14060189pfo.3
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=olHLGZ48niXGut0XbbxLsqr0rbv3H8VjFmjxIqL68wU=;
        b=brCt+CBq+MmsYtOo49UoEAd8XbftfZYRocY+H8ceTF3EwDGCN2CeI1WQ9eIy3UfxdW
         XyVfkCJcNVJVKj12/M02BdtLR4a1OqoaYg8VFD4AUV8H4YpQQue8q/ib29WgJYgMKbSy
         Je7H5aynTFvuPadhnyzh/dg06wu2Bajchu46UjJxxFmAOm0XGtPbiJCyciWF431x9siw
         j1h9BOIk0ZL2QVW1AfgwxN+E4r5eKw7YZ/KFrj3WPAN50AHbGDp/4x9gWuBICi2ScZFJ
         vJIkAKMXRM5CIdzwa1RoLiQNETmENm8QV3oi7d8GD2BYUzLK8Cao3VcKXD+FGmyoBZsy
         fpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=olHLGZ48niXGut0XbbxLsqr0rbv3H8VjFmjxIqL68wU=;
        b=c4PNFEuE7SgWTn8CQs0pmo9r5cl74U/yecxlOnJiVyRDt5h8GApfESaemXvoggQeUP
         U02EBcEoLlx3Slp4T5HWj7RoIgefRxnovR10yeN6hs0dWIcPCyLBESnXg8WTFUSlc3Y0
         pGAcfMLdIc527YKTMMn1O3wxsmBefHo2vOqgKlIDCyBgkEy9m7iHP37WRvpSW33niAuk
         JB1H9scQZbpbsjMVt9cthk9/RyhOEuH2xv2MDkvkWuV6je561kmV4rTJOn7C3tL4vhw2
         bDgvAUfalPTcp5kFKaBEddER9CxFFrS25c/d/qS8jsHS8QmhVG5mGm3b5iqB3DmhuaFH
         qPiA==
X-Gm-Message-State: AOAM5303+c67p51C4MJG4bqAvUmbADb5YenY8SJ/Be7vNowa1aK0HoaR
        twmUmOWcOfB2niibEl0dV2xrYw==
X-Google-Smtp-Source: ABdhPJw234xk7Bm+twfROI+POMcEoLhFF5jcgYbuwBXgF1NjudkN/ojQY/hp0T/liBO1/h47of8KLg==
X-Received: by 2002:a63:5602:: with SMTP id k2mr25493231pgb.127.1620665427664;
        Mon, 10 May 2021 09:50:27 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k69sm11859203pgc.45.2021.05.10.09.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:50:26 -0700 (PDT)
Date:   Mon, 10 May 2021 16:50:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 14/15] KVM: x86: Tie Intel and AMD behavior for
 MSR_TSC_AUX to guest CPU model
Message-ID: <YJlkT0kJ241gYgVw@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-15-seanjc@google.com>
 <7e75b44c0477a7fb87f83962e4ea2ed7337c37e5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e75b44c0477a7fb87f83962e4ea2ed7337c37e5.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Maxim Levitsky wrote:
> On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index de921935e8de..6c7c6a303cc5 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2663,12 +2663,6 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
> >  		break;
> >  	case MSR_TSC_AUX:
> > -		if (tsc_aux_uret_slot < 0)
> > -			return 1;
> > -		if (!msr_info->host_initiated &&
> Not related to this patch, but I do wonder why do we need
> to always allow writing this msr if done by the host,
> since if neither RDTSPC nor RDPID are supported, the guest
> won't be able to read this msr at all.

It's an ordering thing and not specific to MSR_TSC_AUX.  Exempting host userspace
from guest CPUID checks allows userspace to set MSR state, e.g. during migration,
before setting the guest CPUID model.

> > -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> > -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> > -			return 1;
> >  		msr_info->data = svm->tsc_aux;
> >  		break;
> >  	/*
