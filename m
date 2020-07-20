Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE1226D89
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 19:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbgGTRt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 13:49:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27220 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729757AbgGTRtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 13:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595267363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4JlHwh3SUGPYylkGk+T5UD+lE4YPhqSmyAUTHmFlqd8=;
        b=g08pY9C+DMl0Km+42JFhsZqUK0VvUqJjnytsrhzSEyxHH34RFK6H0y2CBs0r7YodfPcM/V
        2p2HEE5Qyi4U9pt5Wc+64L84m99GITQbalMXrBq1q9cpTLRAVvstv11TKGEVc/2s172dfI
        PQCtKRLuAj+sTtbS7ubgppJWWf2ijl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-n5KZeqc4Obeqjrl-ozYV4w-1; Mon, 20 Jul 2020 13:49:21 -0400
X-MC-Unique: n5KZeqc4Obeqjrl-ozYV4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88814800468;
        Mon, 20 Jul 2020 17:49:20 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-128.rdu2.redhat.com [10.10.115.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A77F860E3E;
        Mon, 20 Jul 2020 17:49:17 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 08429220203; Mon, 20 Jul 2020 13:49:17 -0400 (EDT)
Date:   Mon, 20 Jul 2020 13:49:16 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kvm,x86: Exit to user space in case of page fault
 error
Message-ID: <20200720174916.GE502563@redhat.com>
References: <20200709125442.GA150543@redhat.com>
 <87365qsb2v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87365qsb2v.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 17, 2020 at 12:14:00PM +0200, Vitaly Kuznetsov wrote:

[..]
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6d6a0ae7800c..a0e6283e872d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> >  	if (!async)
> >  		return false; /* *pfn has correct page already */
> >  
> > -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> > +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
> 
> gpa_to_gfn() ?

Will do. I forgot to make this change since last feedback.

> 
> >  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
> >  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
> >  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 88c593f83b28..c4d4dab3ccde 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.apf.gfns[i] = ~0;
> >  }
> >  
> > +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> > +{
> > +	int i;
> > +	for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> > +		vcpu->arch.apf.error_gfns[i] = ~0;
> 
> Nit: I see this is already present in kvm_async_pf_hash_reset() but what
> about defining 
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index a7580f69dda0..9144fde2550e 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -38,6 +38,7 @@ typedef u64            gpa_t;
>  typedef u64            gfn_t;
>  
>  #define GPA_INVALID    (~(gpa_t)0)
> +#define GFN_INVALID    (~(gfn_t)0)

Will do.

[..]
> > +static void kvm_del_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > +
> > +	if (WARN_ON_ONCE(vcpu->arch.apf.error_gfns[key] != gfn))
> > +		return;
> > +
> > +	vcpu->arch.apf.error_gfns[key] = ~0;
> > +}
> > +
> > +static bool kvm_find_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > +
> > +	return vcpu->arch.apf.error_gfns[key] == gfn;
> > +}
> 
> These two functions kvm_del_error_gfn()/kvm_find_error_gfn() come in
> pair and the only usage seems to be
> 
>  if (kvm_find_error_gfn())
>     kvm_del_error_gfn();
> 
> what if we replace it with a single kvm_find_and_remove_error_gfn() and
> drop the WARN_ON_ONCE()?

Ok, I am fine with this as well. Will do.

Thanks
Vivek

