Return-Path: <kvm+bounces-3596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641DD805A88
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:54:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD97281967
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6608A61FD9;
	Tue,  5 Dec 2023 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKUL6Pb2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6090B1712
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 08:53:50 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d08acaab7fso15364075ad.1
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 08:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701795230; x=1702400030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XMQYF2quagt/GPGUodoc4MiIW5ZQeF7Y4GziD01rWxY=;
        b=jKUL6Pb2ELt3dBIcP8SfhUzC2eRufsrPX+BPDTaA6tkwYPYCQJEAQHDG11BWQS9xME
         KBaPHlUeak7SGC/WHLeCJ2WRLzgTDsKROnHd2r2O7UxR66/i2tAwB2CiwYo72gOuG0l0
         8kSdblTIhXmsAjNdAXCejlwHNbozSfjUu6VO28TFyl1Oue3+fPMss2cNDsmHBUvSTATO
         YK3T0G+qzrPlnrPIHfnkQtZC4GNHGy0Dzvq536Q9nPqUJC85/R/k0y0fpaib/tS3YlZr
         MHIfI4y/FAFPWOA5CX/enymHMqpEdzur0J8JMl3nZipCYDwgt/Vu8MQaWZu2yuoWI5mZ
         QmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701795230; x=1702400030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMQYF2quagt/GPGUodoc4MiIW5ZQeF7Y4GziD01rWxY=;
        b=fPN11Zus6u0aHdUNYdwkk2Hb1SrQaZBOGIXBnWWMDRibUezkn059olWluTwcTkDeNh
         DYlMPS0dNBJyQbXBvUSXs3o0mTv2XyyWCfrCzb5esh458FNcs/Z+naSCo2ybs5tMSeMu
         /MJcJiaOjBPQVTl2h+xvBkqnbUSf68/r0QwG6C1lGuzZ1Yq4G4i5wczA18veiaSoJJJL
         AT8iyqi1Aj8DGPNqtuvwyHUZiwsS1ix5nFeFYOeuH1UIVusQXQ3JfSSXuyte9ODSFssG
         49iof8tiDZjHPuSq94wJnoWewX1CZkvKCzihZ9RA737waoBl6MBaM4h1wn6xj8YCEhQ5
         WNjw==
X-Gm-Message-State: AOJu0YzvxVSbfKc2jBWip6hOzpPCcK4py7ZZMVwYa5C9lcXjNILtEWEd
	E7OPdTjhtFJ2tgm/3UivciQq1KlhaTc=
X-Google-Smtp-Source: AGHT+IEkDPF5kg0eFiaPieQqBbhN1nYVZJAxhuI3lfBP6e8BzlpfCIUB7mriD7s7nOD1m+hVQsJUWt4xndE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8504:b0:1d0:96b7:7f4 with SMTP id
 bj4-20020a170902850400b001d096b707f4mr104464plb.12.1701795229655; Tue, 05 Dec
 2023 08:53:49 -0800 (PST)
Date: Tue, 5 Dec 2023 08:53:48 -0800
In-Reply-To: <ae972860-cc45-48b0-ba3e-bb2fbad5856a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com> <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com> <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
 <9b221937-42df-4381-b79f-05fb41155f7a@intel.com> <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
 <1a5b18b2-3072-46d9-9d44-38589cb54e40@intel.com> <ZW6FRBnOwYV-UCkY@google.com>
 <ae972860-cc45-48b0-ba3e-bb2fbad5856a@intel.com>
Message-ID: <ZW9VnKLSMGh9PAJy@google.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	Chao Gao <chao.gao@intel.com>, Tony Luck <tony.luck@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "bagasdotme@gmail.com" <bagasdotme@gmail.com>, 
	"ak@linux.intel.com" <ak@linux.intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>, 
	"imammedo@redhat.com" <imammedo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"bp@alien8.de" <bp@alien8.de>, Len Brown <len.brown@intel.com>, 
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Ying Huang <ying.huang@intel.com>, Dan J Williams <dan.j.williams@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 05, 2023, Dave Hansen wrote:
> On 12/4/23 18:04, Sean Christopherson wrote:
> > Joking aside, why shove TDX module ownership into KVM?  It honestly sounds like
> > a terrible fit, even without the whole TDX-IO mess.  KVM state is largely ephemeral,
> > in the sense that loading and unloading kvm.ko doesn't allocate/free much memory
> > or do all that much initialization or teardown.
> 
> Yeah, you have a good point there.  We really do need some core code to
> manage VMXON/OFF now that there is increased interest outside of
> _purely_ running VMs.
> 
> For the purposes of _this_ patch, I think I'm happy to leave open the
> possibility that SEAMCALL can simply fail due to VMXOFF.  For now, it
> means that we can't attribute #MC's to the PAMT unless a VM is running
> but that seems like a reasonable compromise for the moment.

+1

> Once TDX gains the ability to "pin" VMXON, the added precision here will
> be appreciated.

