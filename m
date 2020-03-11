Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6A3181D16
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 17:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgCKQB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 12:01:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729841AbgCKQB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 12:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583942484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C2BHMsicmBBiwdBuJ2lMQ+3Hcfkiz/XVewH9U5MKYBc=;
        b=ExmYJ0xJaUPmT/z6mLUGKp23HjHtCjAxZoNNGTBYcHrdDRAX7sf+08TtxDgobTZ4U7CYog
        Zf54giaFB4qp+V9EhFmvok0udN4pKW72toD8CJJB1+tV6hQKn4gGNsYnRdLu92JL5lcPv7
        sau0STqvlsN6leYKSHNFzI7QRoK/2y8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-bhbbwQQIPP2HNuH2tSq2NA-1; Wed, 11 Mar 2020 12:01:22 -0400
X-MC-Unique: bhbbwQQIPP2HNuH2tSq2NA-1
Received: by mail-qk1-f199.google.com with SMTP id c1so1748428qkm.16
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 09:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C2BHMsicmBBiwdBuJ2lMQ+3Hcfkiz/XVewH9U5MKYBc=;
        b=iG0RLdulOsvef6uFD78DUWTWsqttwJfXba8wSMRIh9VHGMuit0rNz9tJKv+bfiD6b3
         bJhh2Bz8N/6PcWcLcWpMlhC4LJfjQshPmqiBDoetAsgQuLvxNNz+swaA84olJCkTSJRH
         rsUFgjO0RFA/0vRVo44oiKBPOeEkcYLdJLPrrepWpNe24WCDQ342Kz0pSJPpVgK0GiZr
         DsxPYaaBidFF5lvNd2b7XqC5cLr6hyyphDT267D2J5OICYzyolneOy/wSQqsa9vnisN4
         BAMek8wM0e2e4zX2oNhe9S7XSo428bzwmCYLRlyyzr3iNjB3YKO+Q3U+YPON65TjtwMb
         Is+Q==
X-Gm-Message-State: ANhLgQ2BFR5vO/z3g1n7k30Sdzx7BrM0mUxP+EEiK4Frx39RUOYRpto9
        cH1BBfAyuZh8plzRLQMaplpd0AswlQ+Va9IZkqgsMwaRC2fIhr+EMe+DNSYnEallYeinZPMQCbV
        FlROhApVlG1Vu
X-Received: by 2002:ad4:49b2:: with SMTP id u18mr3531868qvx.102.1583942482216;
        Wed, 11 Mar 2020 09:01:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsOmAzv2bmE8lfSFbahE0PflJ7WD1T9y24kNWIrUIYt5pgkfMumAg+oBsjtIzahNyH+0Rxn+A==
X-Received: by 2002:ad4:49b2:: with SMTP id u18mr3531826qvx.102.1583942481913;
        Wed, 11 Mar 2020 09:01:21 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h5sm9018726qkc.118.2020.03.11.09.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 09:01:21 -0700 (PDT)
Date:   Wed, 11 Mar 2020 12:01:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200311160119.GF479302@xz-x1>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309214424.330363-4-peterx@redhat.com>
 <20200310150637.GB7600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310150637.GB7600@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 08:06:37AM -0700, Sean Christopherson wrote:
> On Mon, Mar 09, 2020 at 05:44:13PM -0400, Peter Xu wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 40b1e6138cd5..fc638a164e03 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3467,34 +3467,26 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
> >  	return true;
> >  }
> >  
> > -static int init_rmode_tss(struct kvm *kvm)
> > +static int init_rmode_tss(struct kvm *kvm, void __user *ua)
> >  {
> > -	gfn_t fn;
> > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> >  	u16 data = 0;
> 
> "data" doesn't need to be intialized to zero, it's set below before it's used.

Yeah I didn't touch it because this change is irrelevant to the rest.
But I can remove it altogether.

> 
> >  	int idx, r;
> 
> nit: I'd prefer to rename "idx" to "i" to make it more obvious it's a plain
> ole loop counter.  Reusing the srcu index made me do a double take :-)

Another irrelevant change, but ok.

> 
> >  
> > -	idx = srcu_read_lock(&kvm->srcu);
> > -	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
> > -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> > -	if (r < 0)
> > -		goto out;
> > +	for (idx = 0; idx < 3; idx++) {
> > +		r = __copy_to_user(ua + PAGE_SIZE * idx, zero_page, PAGE_SIZE);
> > +		if (r)
> > +			return -EFAULT;
> > +	}
> 
> Can this be done in a single __copy_to_user(), or do those helpers not like
> crossing page boundaries?

Maybe because the zero_page is only PAGE_SIZE long? :)

[...]

> > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > +/**
> > + * __x86_set_memory_region: Setup KVM internal memory slot
> > + *
> > + * @kvm: the kvm pointer to the VM.
> > + * @id: the slot ID to setup.
> > + * @gpa: the GPA to install the slot (unused when @size == 0).
> > + * @size: the size of the slot. Set to zero to uninstall a slot.
> > + *
> > + * This function helps to setup a KVM internal memory slot.  Specify
> > + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> > + * slot.  The return code can be one of the following:
> > + *
> > + *   - An error number if error happened, or,
> > + *   - For installation: the HVA of the newly mapped memory slot, or,
> > + *   - For uninstallation: zero if we successfully uninstall a slot.
> 
> Maybe tweak this so the return it stands out?  And returning zero on
> uninstallation is no longer true in kvm/queue, at least not without further
> modifications (as is it'll return 0xdead000000000000 on 64-bit).  The
> 0xdead shenanigans won't trigger IS_ERR(), so I think this can simply be:
> 
>  * Returns:
>  *   hva:    on success
>  *   -errno: on error
> 
> With the blurb below calling out that hva is bogus uninstallation.

Sure, I'll rebase to kvm/queue for the next version with the
suggestion.

Thanks,

-- 
Peter Xu

