Return-Path: <kvm+bounces-26716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB97C976B60
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A04811F24432
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D0A1B12DE;
	Thu, 12 Sep 2024 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2nC27CN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037A61AAE0A
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149531; cv=none; b=oXoPenERJemWy43xBRuaihGPkh5sVdOxxcwMCtSwLERbunSWNsflGfZHMLb5mqaR+EfM1IouyxpWl4FNoTmqfoXKG69Aj3Ra/ih4kJkCwWergi/vG2oWvfb3/Gsz+bWkq/vEczwtzPBCr0dU83qdLWzC58je/own7XPWwwj+qfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149531; c=relaxed/simple;
	bh=SeITqANqh8uS/MwUSMMbpOgql+rfNsYyyshPxmsnKYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bR3uptakTSOzYArnSfpW8tce00lKP6ww5WaOcuKnRwDK1KNUJ7+OFup5hisSVqOq5iBhK2JIC8zc2YsN20ArWKyYgAIdSSSMKMaLc6dIg4x6AN/Rsscd6NyQXHBBMsLTuYXgnnSI0tnng2BLQz8B8aAXNXLmXizUv/pb42lq2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2nC27CN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ff24acb60dso9801365ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 06:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726149529; x=1726754329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZK6HVHZn98Hj1qj5vJmB4zUj1ZfRB7+fu+YXBUGUC+g=;
        b=P2nC27CNjjo+D8hhpSfjI6jvkPYcSuTLvUzo0qwN2s8vz8jWrW5NJOKcCxyqKs1NQ4
         B0w3CdF/qRO3+QmeM8L1sA3DC8Y+EUXQrdeFpp7tV1H4M+xGFKXSh0upLlLufRARZ0bP
         E3R54e4xCJDblKmZb5rEqJnyP7vo7skWIUjZE7fq7OaZlXcQoHRWH0MHrra+tK00DF60
         clBNCmkrPoOPuxCg10YfuqXbZadHm0Ig7ptvyhh71sdj7Jwo/U0khRf+RtlSrlPx/vUo
         2FswaNixXC8hEP2e0D6+bcV+c2rvjRKxbYTgP5ntO4LLkTM8DCu0QaE80MgO21GTnl64
         GJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726149529; x=1726754329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZK6HVHZn98Hj1qj5vJmB4zUj1ZfRB7+fu+YXBUGUC+g=;
        b=b3arpjCuacJ9Ymic6yU4bkhwxqyKAbtJpEWZAybL2a4z0ptpeYay24+hLCwu64Gb2T
         d2IJuzx4Fyj+IRkku1ZETki8kQBBfwLM2BQIoVCKTJXspbdbSSkLNxggltCGwHYmtXVm
         x91d4edvpBVdEyeQSVDj4ISzNTpTV9UcQk68VnRj1p1Lk0GzMMA8g5bBjy7ZquCHuXSM
         rzLgZPW14LgbA1Zg3a6mfsNPMn2zFABDR+6xFzvTvkpAbo0IekQfPipAHiCsnFu8Lah4
         FrADtE6G7ypXg8nfGRKAJB1pA2H8qcJiPPbt0KZcne6f/Hs/70uvBh/Na0usCIVWspFV
         yucA==
X-Forwarded-Encrypted: i=1; AJvYcCXVmvbj87ylfEQdESjJ5XJ9qWb3yN0DX7605QFXQW32rRBi48IMFGvBngGY3i6fpMPmsnM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsuQNYg77bmUWZehy5F16fhVEaqGoVmd1jRbSg/PpuRbgg0LSF
	wPchXhNhwtv1e2tFrR7HQHzTZWcMj7SRGep/D0c71yohitTtM1r1Rdir3R1u7EqK2OfS0zxw5Jl
	V8w==
X-Google-Smtp-Source: AGHT+IFqTdTG4b3Mr7BP/09ZXc+oW/zlXp3T5xgWOLFDE7WfwPK4BdJD+RmItP4d7duZp2TQ8vP7BLIJ0nw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:64e:b0:205:58ee:1567 with SMTP id
 d9443c01a7336-2074c3ae046mr208235ad.0.1726149529086; Thu, 12 Sep 2024
 06:58:49 -0700 (PDT)
Date: Thu, 12 Sep 2024 06:58:47 -0700
In-Reply-To: <8761e1b8-4c65-4837-b152-98be86cf220d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-6-rick.p.edgecombe@intel.com> <8761e1b8-4c65-4837-b152-98be86cf220d@intel.com>
Message-ID: <ZuLzl6reeDH_1fFh@google.com>
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private mem
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dmatlack@google.com, isaku.yamahata@gmail.com, yan.y.zhao@intel.com, 
	nik.borisov@suse.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 12, 2024, Kai Huang wrote:
> > +static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
> > +{
> > +	/* For TDX the direct mask is the shared mask. */
> > +	return !kvm_is_addr_direct(kvm, gpa);
> > +}
> 
> Does this get used in any other places?  If no I think we can open code this
> in the __vmx_handle_ept_violation().
> 
> The reason is I think the name kvm_is_private_gpa() is too generic and this
> is in the header file.

+1, kvm_is_private_gpa() is much too generic.  I knew what the code was *supposed*
to do, but had to look at the implementation to verify that's actually what it did.

> E.g., one can come up with another kvm_is_private_gpa() checking the memory
> attributes to tell whether a GPA is private.
> 
> Or we rename it to something like
> 
> 	__vmx_is_faulting_gpa_private()
> ?
> 
> Which clearly says it is checking the *faulting* GPA.

I don't think that necessarily solves the problem either, because the reader has
to know that the KVM looks at the shared bit.

If open coding is undesirable, maybe a very literal name, e.g. vmx_is_shared_bit_set()?

