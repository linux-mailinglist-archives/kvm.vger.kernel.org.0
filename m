Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759AD36864D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhDVSCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 14:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhDVSCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 14:02:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E5C06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 11:01:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g16so7070758plq.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 11:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1FQZb/XfaZdMnBUcsXw4CFDtEy9SntOEhsQqKQNQihM=;
        b=HluPqKSvM4/wAC8Q3OUleDSxGwJ5BXY+CBvVTpPiBsijkj+B9t/aPPSVlltTFiDzZQ
         WPFJW8HXbuYDxSLzDVECRrtq+ecmwenMY9IuNHAy8JR6na8QLpkZyjgSmRykSD1qaXUr
         kuxhRsEj8VsfcxMy5FRuQDgKiPu4oaRZ9LzyrxIXukBnTLKL2tyf2NBIFFnhNvcdbiAS
         i/zxW679WcA256R8F67J1NIEobmd/S+M6Tqh7NhNBtPvz29OVn5IClbF4zS5XtGJPwFH
         n6716DdYCEg2DCMqvEu/5BF6Q+Z2lnn74C5szFQLlExkPDXLVc4bmyqgPIOHojCUuEeA
         o+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1FQZb/XfaZdMnBUcsXw4CFDtEy9SntOEhsQqKQNQihM=;
        b=WTJd94dBkOLlM+veZtwUHYZRUv0bf3TUgin439P8yZ/X7vDD+Ub+1peSi6TUY+dZEg
         o6lFD5H60WKgKxnS4KMllByYsseB5GjhbIrdfUbLUP4RX58zK/2IX7T/GBQ7Gt4IwFD7
         +nsbd3MCGa7MNrk2ZsQQlCQ7IuOziN3KKjWK+H8JXU8j7waxAjPLDUQsSEkTF1LYZ+2z
         RIZpwmj7s2b+ItrzhS+h1JWl6h4Nra5Mf1TLLvWI7+dyKKaiKlaP++TjUq61WHpLwuXU
         4P4V/vyEfi89yJufjbYbNaOjT+Ao8xXFegJnaoh6IiknzYFKYhknvz/R9w16LKBA1BbN
         zDhw==
X-Gm-Message-State: AOAM530h3X7EQ5p+SgeLNHA1HxAeE3WT11gp3hvE0EvamBK9TcGhUf6g
        MLN6JklUC6Bkkk9YHJpN+Yf+QA==
X-Google-Smtp-Source: ABdhPJxvGPg4NBDcjs0gK6H6Hqd8UbOAAe1+LzP/9ZqZU3KmEx3R4nt8wVbTZD/VSfjP/aMd3E9ysA==
X-Received: by 2002:a17:902:a582:b029:ec:d002:623b with SMTP id az2-20020a170902a582b02900ecd002623bmr66601plb.36.1619114508258;
        Thu, 22 Apr 2021 11:01:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mj13sm2785223pjb.9.2021.04.22.11.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 11:01:47 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:01:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
Message-ID: <YIG6B+LBsRWcpftK@google.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
 <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Krish Sadhukhan wrote:
> 
> On 4/22/21 10:50 AM, Krish Sadhukhan wrote:
> > 
> > On 4/20/21 1:00 PM, Sean Christopherson wrote:
> > > On Mon, Apr 12, 2021, Krish Sadhukhan wrote:
> > > > According to APM vol 2, hardware ignores the low 12 bits in
> > > > MSRPM and IOPM
> > > > bitmaps. Therefore setting/unssetting these bits has no effect
> > > > as far as
> > > > VMRUN is concerned. Also, setting/unsetting these bits prevents
> > > > tests from
> > > > verifying hardware behavior.
> > > > 
> > > > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > > > ---
> > > >   arch/x86/kvm/svm/nested.c | 2 --
> > > >   1 file changed, 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index ae53ae46ebca..fd42c8b7f99a 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -287,8 +287,6 @@ static void
> > > > nested_load_control_from_vmcb12(struct vcpu_svm *svm,
> > > >         /* Copy it here because nested_svm_check_controls will
> > > > check it.  */
> > > >       svm->nested.ctl.asid           = control->asid;
> > > > -    svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
> > > > -    svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
> > > This will break nested_svm_vmrun_msrpm() if L1 passes an unaligned
> > > address.
> > > The shortlog is also wrong, KVM isn't setting bits, it's clearing bits.
> > > 
> > > I also don't think svm->nested.ctl.msrpm_base_pa makes its way to
> > > hardware; IIUC,
> > > it's a copy of vmcs12->control.msrpm_base_pa.  The bitmap that gets
> > > loaded into
> > > the "real" VMCB is vmcb02->control.msrpm_base_pa.
> > 
> > 
> > Not sure if there's a problem with my patch as such, but upon inspecting
> > the code, I see something missing:
> > 
> >     In nested_load_control_from_vmcb12(), we are not really loading
> > msrpm_base_pa from vmcb12 even     though the name of the function
> > suggests so.
> > 
> >     Then nested_vmcb_check_controls() checks msrpm_base_pa from
> > 'nested.ctl' which doesn't have         the copy from vmcb12.
> > 
> >     Then nested_vmcb02_prepare_control() prepares the vmcb02 copy of
> > msrpm_base_pa from vmcb01.ptr->control.msrpm_base_pa.
> > 
> >     Then nested_svm_vmrun_msrpm() uses msrpm_base_pa from 'nested.ctl'.
> > 
> > 
> > Aren't we actually using msrpm_base_pa from vmcb01 instead of vmcb02 ?
> 
> 
> Sorry, I meant to say,  "from vmcb01 instead of vmcb12"

The bitmap that's shoved into hardware comes from vmcb02, the bitmap that KVM
reads to merge into _that_ bitmap comes from vmcb12.

static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
{
	/*
	 * This function merges the msr permission bitmaps of kvm and the
	 * nested vmcb. It is optimized in that it only merges the parts where
	 * the kvm msr permission bitmap may contain zero bits
	 */
	int i;

	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
		return true;

	for (i = 0; i < MSRPM_OFFSETS; i++) {
		u32 value, p;
		u64 offset;

		if (msrpm_offsets[i] == 0xffffffff)
			break;

		p      = msrpm_offsets[i];
		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);

		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4)) <- This reads vmcb12
			return false;

		svm->nested.msrpm[p] = svm->msrpm[p] | value; <- Merge vmcb12's bitmap to KVM's bitmap for L2
	}

	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm)); <- This is vmcb02

	return true;
}
