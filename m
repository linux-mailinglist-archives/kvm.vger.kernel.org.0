Return-Path: <kvm+bounces-11763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3624487B101
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 20:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A7D11C27D87
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 19:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E25D6E2BD;
	Wed, 13 Mar 2024 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ufml1w12"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F7B60B94
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710353921; cv=none; b=sGsqXRuGP6xy0jyKFNUQw1ghMn7TlQxMJ4PIx4BZGadY3PdVWD0QyBLUic+/HEY4a/cnosTIfa8FvDNqFI3GRNoYbQ1+ZTYz1mjR/LUfFTERig2lPQk4HgvICzF+0rq8rFOPMkmnjzfnb88akjO4lJieo9LXD2vmXWLaUWfYC2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710353921; c=relaxed/simple;
	bh=Bda/tnr2Gweo1vW+6mtT16FlcwdOgeaHwK/iuF0gX0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9E/YNtyzwlCWPQPBTc9o4juBCWxMj8dsYiD/A28uk7L1DKcdTfTcET+1zX65OtdhmlkthexlEkGOCZXlNq8PijgeP3sPN5AMxnfXIKL1sB6WafF/2hyN6iQn8l0sXqnW9i13wPn4A2Qmq6E/tK5MUvKByqOwWATDWn/UBhLsx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ufml1w12; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dd8dd198d0so704525ad.3
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 11:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710353919; x=1710958719; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RTPa6mW4skZMTVBISgv1w+QSbNBfwtAG1NsTquu+3lU=;
        b=Ufml1w12HVPXxivP0lU1rKd7wdFNwXCaWW7skbx6G4m+t6SI9MkgLgsDP7CmCVwwDa
         RZ+JEZutR0+Le1rTe57BIrAPwdgSSuXHbAv5atVfnLKZd9Sd3t72hTRlbdxU1rv4pq0+
         FURxrPT88DPw16vYrW28Y7ZO22bcKpvlGJT/4v2txUANoNSCZQvPKMr2uxQnTG2OuVjZ
         qr5Z1zW3Gv58Ao19dumUMoO7YV0c8XmmfgqmCQPcxttFWzqhRT56Hd5YIqx//As6fGAM
         Q+br0Uu+9SnbSmTrYdG1SO+izsF9KYJei5fRD2tHqcWvcQQ4r9ANi4k7ICgrlOAvLIjs
         7DtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710353919; x=1710958719;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTPa6mW4skZMTVBISgv1w+QSbNBfwtAG1NsTquu+3lU=;
        b=cUBimUCyDnkknhxs6pxv40gOTkaqlX1r4cNChKw5oyGXNNxCyIb3yLPt4gmJ2RM7aK
         shSJKOFb/QiYAHYqWuaXyeyg7ID/dIFPdmKpARddgj/Zx4J8RdjM3ujcX4KUwMgz0vsH
         15tNzTeTpULAt0BSwxK4FcJTzjbldtwJ5cG2msPInsvKWwPoqfpkNaaJPvwLKk04kNvZ
         ojpb5a8ov7EZoTHyAwbig/CKKjLyQyF+uR45D4Y01sd21wTfQt9Z21A4MtQ7SJ6gmpxp
         OvOuRGk/jW6icu2QWU7Bnbn3fwB2EvhJTFQw5YuniDgY5SNUJdi2M2dUx1XwDuK26sAH
         8c1g==
X-Forwarded-Encrypted: i=1; AJvYcCUIS0rE59wK6srRwXvxlkD2dQTFbQTUdQsNyrP4rGvOd1kGqARQJ5T1LRt1qkE95dA5IrAKjX+myoXOtmTXBCYfxe4D
X-Gm-Message-State: AOJu0YxZzn7ezVqdpgwwcwTtLSiW7X7GgpGJmTgipj+AIqbos/DzpY3O
	oWm5QAuWXCg3qDn3fciikcb3S1WLpRzGcyoDrRkEc5eGaz39Xua838mDcpF2MA==
X-Google-Smtp-Source: AGHT+IEmI5dfjtwpySpmP5uQqwn0Y6a1ZEgkcPqkn1FgTjPpZVuBpetb7bRagRG+eKtRIr1qMm9j7g==
X-Received: by 2002:a17:903:11c7:b0:1dd:22ec:7b22 with SMTP id q7-20020a17090311c700b001dd22ec7b22mr19318070plh.33.1710353919264;
        Wed, 13 Mar 2024 11:18:39 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902db0400b001dd6ebd88b0sm6828587plx.198.2024.03.13.11.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 11:18:38 -0700 (PDT)
Date: Wed, 13 Mar 2024 18:18:35 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Wei W Wang <wei.w.wang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Aaron Lewis <aaronlewis@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Return correct value of
 IA32_PERF_CAPABILITIES for userspace after vCPU has run
Message-ID: <ZfHt-waLl3mg0Lbx@google.com>
References: <20240313003739.3365845-1-mizhang@google.com>
 <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZfG7SgyqTTtqF3cw@google.com>
 <CABgObfYfAS2DBaW71iUcQgua7K3VY4nz8krGYGxyBt1+7i193A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYfAS2DBaW71iUcQgua7K3VY4nz8krGYGxyBt1+7i193A@mail.gmail.com>

On Wed, Mar 13, 2024, Paolo Bonzini wrote:
> On Wed, Mar 13, 2024 at 3:42 PM Sean Christopherson <seanjc@google.com> wrote:
> > We discussed this whole MSRs mess at PUCK this morning.  I forgot to hit RECORD,
> > but Paolo took notes and will post them soon.
> >
> > Going from memory, the plan is to:
> >
> >   1. Commit to, and document, that userspace must do KVM_SET_CPUID{,2} prior to
> >      KVM_SET_MSRS.
> 
> Correct.

This is clear to me now. Glad to have the direction settled down.

> 
> >   2. Go with roughly what I proposed in the CET thread (for unsupported MSRS,
> >      read 0 and drop writes of '0')[*].
> 
> More precisely, read a sensible default value corresponding to
> "everything disabled", which generally speaking should be 0. And
> generally speaking, commit to:
> - allowing host_initiated reads independent of CPUID
> - allowing host_initiated writes of the same value that was read
> - blocking host_initiated writes of nonzero (or nondefault) values if
> the corresponding guest CPUID bit is clear

>
> Right now some MSRs do not allow host initiated writes, for example
> MSR_KVM_* (check for calls to guest_pv_has), and the VMX MSRs.
> 
> Generally speaking we want to fix them, unless it's an unholy pain
> (for example the VMX capabilities MSRs are good candidates for pain,
> because they have some "must be 1" bits in bits 63:32).
> 
> All this should be covered by selftests.
> 
> >   3. Add a quire for PERF_CAPABILITIES, ARCH_CAPABILITIES, and PLATFORM_INFO
> >      (if quirk==enabled, keep KVM's current behavior; if quirk==disabled, zero-
> >       initialize the MSRs).
> 
> More precisely, even if quirk==enabled we will move the setting of a
> non-zero default value for the MSR from vCPU creation to
> KVM_SET_CPUID2, and only set a non-zero default value if the CPUID bit
> is set.
> 
> Another small thing in my notes was to look at the duplication between
> emulated_msrs and msr_based_features_all_except_vmx. Right now
> MSR_AMD64_DE_CFG is the only one that is not in both and, probably not
> a coincidence, it's also the only one implemented only for one vendor.
> There's probably some opportunity for both cleanups and fixes. It
> looks like svm_has_emulated_msr(MSR_AMD64_DE_CFG) should return true
> for example.
> 
> Paolo
> 

Ack. Thanks.

> > With those pieces in place, KVM can simply check X86_FEATURE_PDCM for both reads
> > and writes to PERF_CAPABILITIES, and the common userspace MSR handling will
> > convert "unsupported" to "success" as appropriate.
> >
> > [*] https://lore.kernel.org/all/ZfDdS8rtVtyEr0UR@google.com
> 

