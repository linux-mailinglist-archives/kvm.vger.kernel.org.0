Return-Path: <kvm+bounces-51773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD0DAFCDD4
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED112188C4A3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F032E0402;
	Tue,  8 Jul 2025 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkKg3Roj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5854289E2C
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985288; cv=none; b=i5PODdagkGW6svJ3TOQYeltmLFtjWZc9u6I2sf1Ep/dvVQLgpt0CTrxXL0fCZbQ3wAg7Dw3FrDp6MJVNcQPMS7KmILK+XZ5FAmhG5lHcAxseO9zj8Veo9NDn3x5qIc9NcBBIq+AZllSeiRyT2+yczFh4a3y50xjtd4F648/rfpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985288; c=relaxed/simple;
	bh=zNNTYub1LBWBxToEOByS4zI8ysTOZBQ68gSlPTu/0rI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MHIjnYbxfVHLg0JHF39tBhUpOWJHmc9M/5fCvdyzuNSJ76hS27OnD0i/lvNWDwgimxOHQdLyiUG+QVPo/mB4h769TTB5fgBCGTJYOQa/02UZ02Ohhobc31SA5FDRWAnlqw75lp4omVxpimWa0eSmcbMO+JABWj7VVKfSmV6U/ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UkKg3Roj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e671316so3196935a91.0
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751985286; x=1752590086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NHeTUgQiJSL6I9kZClKBhGQHekNKhAkEzxlHi9ONmlk=;
        b=UkKg3Roj9HJZLBDeg3+AILqN/aJrRrMvSMwdLfkhgDC+cl4/mNapmCWYVI0UYgA0kw
         5XoK5qNXOcvQFsMEgGiLbN1k5y703c5xwNJdwNToMyLSWQLxR3A3/PKQHRvR6rOg4Bjj
         l52rmJJp5bqEHkemSTGJp/ytm/A8M2Meb4lyPcl9oNR9Ubeo8eFyjhqGKjPMoVjw9XgT
         HYl4VBJkCthOLZoK/0R3IXZuXViruGhCv99d2tIlqex/kJvYVH6hMC7LnUDSwWDbIXhO
         c4RWGfMN2uNz65eGi2UKznHQnqroo2p3y34ekDrbJgzxa6M9/5v1Hz2hrRwc+z9Ixzn6
         8nxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985286; x=1752590086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NHeTUgQiJSL6I9kZClKBhGQHekNKhAkEzxlHi9ONmlk=;
        b=Pm1/Oqa7c0AxtuJSnMor8ONJu6YM7s0RckmpU2mvKnrt6tFgYH3HA5wlkSB05FJkNH
         ucreFW5K/nxD8ODqAoUqg/+JT/PL86/3sEV9oSUS3cVQhAtsS3ulEAQgr9UbyUuUN5q1
         i4T6+Wq9cYX480pTVtA+GhDjUQc1S3n9NfNqCS3vvb6rBLjeAFX+fC1XY7eYVxTwS0zu
         7rDX0pA+cB+HMwgoxfZEzaVq1owOK55tLMTRegf1vQAbea6JfqD8Osqi2O5SSRCEVTKU
         sXHjmjHClpG7ahoCYWkjjBVTOMaAwEX5nAVPW1Fm6ligHApxbaZUL52TzVSlcfXSw5Dk
         757A==
X-Gm-Message-State: AOJu0YxO5qFPizJg24zxP6c29t6AuZDMuW273ztRm6buwB1lDoF5owvm
	cJpDkwXCV7H7ReM8HESHLDGbxGa84rtDcout456EI+GwhwCWPRB/Nzu+avP+aC9BK5aCZ9zFr4D
	MKqcXTA==
X-Google-Smtp-Source: AGHT+IHMD0r6vADbqCw4cc6kvAhhrWsl4CK1WBcQ8T8RjhsNQ5AtNWhQIU4yjvmqk6PB01PqRfdbLZl7BmM=
X-Received: from pjbdb5.prod.google.com ([2002:a17:90a:d645:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b8e:b0:30e:9b31:9495
 with SMTP id 98e67ed59e1d1-31c2274c9d3mr3867055a91.9.1751985285917; Tue, 08
 Jul 2025 07:34:45 -0700 (PDT)
Date: Tue, 8 Jul 2025 07:34:44 -0700
In-Reply-To: <fec4e8dd2d015ec6a37a852f6d7bcf815d538fdc.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
 <57a2933e-34c3-4313-b75a-68659d117b14@amd.com> <fec4e8dd2d015ec6a37a852f6d7bcf815d538fdc.camel@intel.com>
Message-ID: <aG0shOcWprrZmiH3@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 08, 2025, Kai Huang wrote:
> > > Even some bug results in the default_tsc_khz being 0, will the
> > > SNP_LAUNCH_START command catch this and return error?
> > 
> > No, that is an invalid configuration, desired_tsc_khz is set to 0 when
> > SecureTSC is disabled. If SecureTSC is enabled, desired_tsc_khz should
> > have correct value.
> 
> So it's an invalid configuration that when Secure TSC is enabled and
> desired_tsc_khz is 0.  Assuming the SNP_LAUNCH_START will return an error
> if such configuration is used, wouldn't it be simpler if you remove the
> above check and depend on the SNP_LAUNCH_START command to catch the
> invalid configuration?

Support for secure TSC should depend on tsc_khz being non-zero.  That way it'll
be impossible for arch.default_tsc_khz to be zero at runtime.  Then KVM can WARN
on arch.default_tsc_khz being zero during SNP_LAUNCH_START.

I.e.

	if (sev_snp_enabled && tsc_khz &&
	    cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;

