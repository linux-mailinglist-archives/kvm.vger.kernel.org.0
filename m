Return-Path: <kvm+bounces-7599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D2B844833
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 20:43:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 028801F26850
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 19:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B831D3EA90;
	Wed, 31 Jan 2024 19:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wnstmyq6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826863E499
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706730186; cv=none; b=Wl8SlajTNOsQgsKugbr3iwPDD0CIWh6JeLj5UhAasszf7VdEvzYphHwva8Hf5wW8qfF11ajVeU0s7bm7DOjULmnahHGYY7TeHox3IeZHXG+xJiwGHO/XOWMPn0xiAhRJl2UJZ51CbgHZopRCmbQyVuCum2vxvfOVn9uF3wwTjvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706730186; c=relaxed/simple;
	bh=i4zKc6NhXiMSl9AuIN6/Dd9lQJhIilwgHlR+1G0X1UE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUVXvml+X3AiC94qtwfdV4N0Mc/1o2TY7pZ4T2Q5P+VGBPiKdUC8RRKgETrF3FPVuQ87l2MNjLDqrj+1+m+sOABAhnzVGvt4fbNERhAbzViicsC6ORDFpa+TgksRqhmG72yvAIOrUbvjQVodcTp6g5M1YUZ7mHK9oFkyKsq/7wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wnstmyq6; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ce9555d42eso162952a12.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 11:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706730185; x=1707334985; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cr3/DP7XTiupTVnBc4u5yU3Y9Y+FH/h9EKQ8I83CyCY=;
        b=wnstmyq6/yomqAUwPSvsMekgX0N7AtuzgzhJINNIYohbb3+/7XO+LHSeDSbrXcKVu3
         JdkyNbuqECFaqv+Z7SHiEdp20OwFy472hJUV3be43veAreiPW3kbvHgCkLFNyDnLAw10
         LqhaSkxiAgsQPdBkI/ce41sYsAYsaobupY6NJBLlMrpLABPhvthD1dQTlAurVcrduZAR
         4NnqRlY28q4R493yWYkAFqN/Fwm1kGtfwtOhhsxcNtILVALp5bLt+Mvf2cYHZejCrp+2
         OTE1PXiriZVxmAgs7Alh3u5kodkIRuZsFh1dMC7Ge0CgOm/FdCSG1aBtXDSzDYKWpprP
         JO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706730185; x=1707334985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cr3/DP7XTiupTVnBc4u5yU3Y9Y+FH/h9EKQ8I83CyCY=;
        b=rNffdgvMGflYGUPVNFa6uFgCg9owg+tqyAqGi1WWGJ1z9VQts8IdrXXpyIprhjUcpR
         fqu68tkMBez9XSn9edOARuTJhQhgPlFPutcBjPLbB7oZlcStSg0lm7LrMVhXxrbaTsIm
         UAYJ9uKfxytzC5/OIpnfERhYPQYLtPhGpGHZng/ZH0J1SDchWPtnphU36LO6dNbVsAw1
         GK56rLpvkzx/y0Pn1ds2OYuw77yT1LFHIHtAEXBtvO+xBiyucz4Q1TH2XuhFimLqRD43
         JhvvgLHFoUerfBCyrsTGioKHsotxN3iBQstOj9/RMn5O3ko1Hob+Fip852vCKpWGfZOD
         02oA==
X-Gm-Message-State: AOJu0YzAr2snbQZgQi1Y9CB2mpSfLb2JH9DKOnHSFF7S8AgpAMFI+OTt
	dOHxf2MFkAHvTzf2DnBxtodC2IviGxKJEC/Wbbtbo6qF3oyJke0hsL3TOIByKw==
X-Google-Smtp-Source: AGHT+IErewNCzDxtDqxxve/kaGns/6aAXmrX8n0YftYoz4uvZgGJp1nrQ+douz8Gg1swOGne1Q1TpA==
X-Received: by 2002:a05:6a20:ba7:b0:19c:a980:58d6 with SMTP id i39-20020a056a200ba700b0019ca98058d6mr2532369pzh.2.1706730184553;
        Wed, 31 Jan 2024 11:43:04 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW+Pmwekr6pGKH43l8LTrTPx/TDT45wLMdyer8MiHn77z1PbTGEAX/+GPDXwv4AgP1vTdvy17rkOYYaZn6Ea7m559tkEgbSRrADfrrclpVj+PoiJclfnEWeatlWnBp6Lfigo/4OEXNez77qvOL+x4NhYyJqheGkBKZGLHJAyyXokB3u6mOHtpe/oq8yIjgf+VHosCqSZ8Jo05W7AA==
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id nc8-20020a17090b37c800b0028c8a2a9c73sm1926517pjb.25.2024.01.31.11.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 11:43:04 -0800 (PST)
Date: Wed, 31 Jan 2024 19:43:00 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0
 if PDCM is disabled
Message-ID: <ZbqixOTlp61Lp-JV@google.com>
References: <20240124003858.3954822-1-mizhang@google.com>
 <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com>
 <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com>
 <ZbGOK9m6UKkQ38bK@google.com>
 <ZbGUfmn-ZAe4lkiN@google.com>
 <b0b5ba26-505e-4247-b30d-9ba2bb0301c1@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0b5ba26-505e-4247-b30d-9ba2bb0301c1@redhat.com>

On Mon, Jan 29, 2024, Paolo Bonzini wrote:
> On 1/24/24 23:51, Sean Christopherson wrote:
> > > If we follow the suggestion by removing the initial value at vCPU
> > > creation time, then I think it breaks the existing VMM code, since that
> > > requires VMM to explicitly set the MSR, which I am not sure we do today.
> > Yeah, I'm hoping we can squeak by without breaking existing setups.
> > 
> > I'm 99% certain QEMU is ok, as QEMU has explicitly set MSR_IA32_PERF_CAPABILITIES
> > since support for PDCM/PERF_CAPABILITIES was added by commit ea39f9b643
> > ("target/i386: define a new MSR based feature word - FEAT_PERF_CAPABILITIES").
> > 
> > Frankly, if our VMM doesn't do the same, then it's wildly busted.  Relying on
> > KVM to define the vCPU is irresponsible, to put it nicely.
> 
> Yes, I tend to agree.

Discussed with Sean offline. Yes, I also agree that this should be
handled at VMM level. MSR_IA32_PERF_CAPABILITIES should be regarded as
part of the CPUID, or sort of. The diff is that its own
"KVM_GET_SUPPORTED_CPUID" (ie., the default value) should come from
KVM_GET_MSRS of the device ioctl.

Providing the default value for MSR_IA32_PERF_CAPABILITIES is really
making things messed. KVM has to always guard access to the cached guest
value with the checking of X86_FEATURE_PDCM. I believe
guest_cpuid_has(vcpu, X86_FEATURE_PDCM) will take runtime cost.

> 
> What QEMU does goes from the squeaky clean to the very debatable depending
> on the parameters you give it.
> 
> With "-cpu Haswell" and similar, it will provide values for all CPUID and
> MSR bits that match as much as possible values from an actual CPU model.  It
> will complain if there are some values that do not match[1].
> 
> With "-cpu host", it will copy values from KVM_GET_SUPPORTED_CPUID and from
> the feature MSRs, but only for features that it knows about.
> 
> With "-cpu host,migratable=no", it will copy values from
> KVM_GET_SUPPORTED_CPUID and from the feature MSRs, but only for *feature
> words* (CPUID registers, or MSRs) that it knows about.  This is where it
> becomes debatable, because a CPUID bit could be added without QEMU knowing
> the corresponding MSR.  In this case, the user probably expects the MSR to
> have a nonzero.  On one hand I agree that it would be irresponsible, on the
> other hand that's the point of "-cpu host,migratable=no".
> 
> If you want to proceed with the change, I don't have any problem with
> considering it a QEMU bug that it doesn't copy over to the guest any unknown
> leaves or MSRs.
> 
reply from another thread: CrosVM issue is not related to this one. It
might have something to do with KVM_GET_MSR_INDEX_LIST. I will come up
details later.
> Paolo
> 
> [1] Unfortunately it's not fatal because there are way way too many models,
> and also because until recently TCG lacked AVX---and therefore could only
> emulate completely some very old CPU models.  But with "-cpu
> Haswell,enforce" then everything's clean.
> 

