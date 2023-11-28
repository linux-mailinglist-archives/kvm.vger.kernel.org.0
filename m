Return-Path: <kvm+bounces-2557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8867FB20A
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F10C1C20BBE
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC94411726;
	Tue, 28 Nov 2023 06:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sv1be2va"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AC3197
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701153765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UiaQdwESEYDh0OWSlkZl1xuzNRF7zyPvHRw34kcgm7E=;
	b=Sv1be2vaCJKWqIbkKiyzb/mLTEhoL0Cib05aD0Q7IBuE321zL21q3gn9l51rlGzWwaU5NA
	dqh7hEvZJv6Xmg/yEJF3CaPByoDbyFYvbjrwHzEFPaJSIPwS2CNnNdkGfsf66aqxYO2y7i
	FRH3bWqRTrj8smmDIGmk3OUUBfY2iRk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-brmJFqadPXmVb11sGjt_3A-1; Tue, 28 Nov 2023 01:42:43 -0500
X-MC-Unique: brmJFqadPXmVb11sGjt_3A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b29868c6eso29821795e9.3
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:42:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701153762; x=1701758562;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UiaQdwESEYDh0OWSlkZl1xuzNRF7zyPvHRw34kcgm7E=;
        b=UgDg8vYeJlU+n4fnPGjPziL+tV0JABs1xCljHlNK9X/1OExNqBLA6uJipZDESb7L9M
         VhnjO2Sf07tJ74PowHJr/Z35TGI9u+Di/jrdnNtFayY6vCigkfRufTRRWM22d3wIqtGf
         rZihKBp1VKEVgT8LI6uPAMVX042TC2WzIRvJYm2vbB3FLdCvlF9cYqsrJK/TovyFRJ7t
         uMPgSze2/pa8/B4C4TPjjwfWDqf79pqkkxRbcKh0WYZN3IbQOlcJqDO+3ycbXoQlM/7E
         IB+w3tr7sb+xckC4vrvbFuDf5NjlA49N22tv4Ww8PeR2/txMXCb1KzbgerkE0/gFE9UY
         t4/Q==
X-Gm-Message-State: AOJu0Ywx4YKdFB6DTRDHcbPsxHY+Ypl6a7iOciU2QwC2+Nap7EzvrLC8
	tF27kDVup9RLidvNg/xb1AZYuPtmfzDnYRmHYEyLA7uibG14c344yo5H03z+Q0+iqqsSpf1+Nmf
	wJPBG7SVPtMwB
X-Received: by 2002:adf:da4a:0:b0:333:149:68f1 with SMTP id r10-20020adfda4a000000b00333014968f1mr2844111wrl.70.1701153762659;
        Mon, 27 Nov 2023 22:42:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFzVPae2GApop6eWDvzDCz8sHV2p++din6DOfCUmKc7HNHTvntQTPElvh8JbWiI/6/j61K24A==
X-Received: by 2002:adf:da4a:0:b0:333:149:68f1 with SMTP id r10-20020adfda4a000000b00333014968f1mr2844101wrl.70.1701153762332;
        Mon, 27 Nov 2023 22:42:42 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id w27-20020adf8bdb000000b00332e5624a31sm13384035wra.84.2023.11.27.22.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 22:42:42 -0800 (PST)
Message-ID: <69607670cc11c05658870ae07d1af543a9446fe8.camel@redhat.com>
Subject: Re: [PATCH v3 4/4] KVM: x86: add new nested vmexit tracepoints
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sean Christopherson
	 <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	 <bp@alien8.de>, linux-kernel@vger.kernel.org, x86@kernel.org, Dave Hansen
	 <dave.hansen@linux.intel.com>
Date: Tue, 28 Nov 2023 08:42:40 +0200
In-Reply-To: <a10d3a01-939c-493c-b93c-b3821735e062@redhat.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
	 <20230928103640.78453-5-mlevitsk@redhat.com>
	 <a10d3a01-939c-493c-b93c-b3821735e062@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 17:11 +0100, Paolo Bonzini wrote:
> On 9/28/23 12:36, Maxim Levitsky wrote:
> > Add 3 new tracepoints for nested VM exits which are intended
> > to capture extra information to gain insights about the nested guest
> > behavior.
> > 
> > The new tracepoints are:
> > 
> > - kvm_nested_msr
> > - kvm_nested_hypercall
> > 
> > These tracepoints capture extra register state to be able to know
> > which MSR or which hypercall was done.
> > 
> > - kvm_nested_page_fault
> > 
> > This tracepoint allows to capture extra info about which host pagefault
> > error code caused the nested page fault.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> with just one question below that can be fixed when applying:
> 
> > @@ -1139,6 +1145,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >   				       vmcb12->control.exit_int_info_err,
> >   				       KVM_ISA_SVM);
> >   
> > +	/* Collect some info about nested VM exits */
> > +	switch (vmcb12->control.exit_code) {
> > +	case SVM_EXIT_MSR:
> > +		trace_kvm_nested_msr(vmcb12->control.exit_info_1 == 1,
> > +				     kvm_rcx_read(vcpu),
> > +				     (vmcb12->save.rax & -1u) |
> > +				     (((u64)(kvm_rdx_read(vcpu) & -1u) << 32)));
> 
> Why the second "& -1u"?  (And I also prefer 0xFFFFFFFFull

I think I copied it from somewhere but I can't seem to find where.
I agree with both remarks, will fix.

Thanks,
	Best regards,
		Maxim Levitsky
> 
> Paolo
> 



