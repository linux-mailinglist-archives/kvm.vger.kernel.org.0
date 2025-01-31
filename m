Return-Path: <kvm+bounces-37005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFEFA242CA
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 19:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86962188754D
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 18:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060C91F239E;
	Fri, 31 Jan 2025 18:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pZpZ67Yb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFF11F1512
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738348497; cv=none; b=uY8fgbkV8j0T72vO/uyJFJqnX0iyq6JaToPwTHG1Pu8UwLWXCCuZbuVMfihgrCgd+5gF+WCaUbuHSjTnEyEgcm0eTgmPNWfLCSu/9JbbpFsXHJhui1jf0CvwmmaRkWF7hAX7CDnhkyyfwPiQlrfNZsR9TrdNh9O6zXudo2LwVDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738348497; c=relaxed/simple;
	bh=fNWXKiXO2P8ivV5RaHwtYShP97cRJPV2kvBURFYp/aA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I5wXcqGZoA5kp5cqZ5IeHAWK2NmydgbgjvDRg/Px5QIeCWdolXmD96jmvGfgRBkJCZZTQik50kqd5wZZNtiG2Pqh/HBXsh3PWHPv0oo2Fk6jfJuJCdfepTRhQ4ibd7D9VB9rcrtg2sSR0I1QZrS91ZHoZftVzOAx3ImeLjkp8yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pZpZ67Yb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso4481024a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 10:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738348495; x=1738953295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OHvxpFXR5lAEIxk+o3Hek4ypvpPcHmc+gKmCjQ+uPaM=;
        b=pZpZ67Yb1PKtqCEYRvpvaUzEAkDkxIVC5BGDYv+RfUPUqgN84fxL0YN/LpFbBjRbvz
         bjUOCmA0c9qVE28o9NEzZxf/88U64Iaq14/6OUxdZyVpm0Kcuc3gON4tryW7LpfNUw8X
         E1RrbK7lDIeZxbNArZCHeA8H50vPIR7QQgiG/TGT/+WfjnYRuIpZ0QCcCTzP5OTU5Y3O
         mam/0Exvlj5Dq9U0ESiZD+ssLFg1HPfAi/Yfy4vS4giMTK0HytEDj/PHFW3MCXBR8pq1
         mgvm9s8ocaTklrRghLwU9pHOvg3rGvzE0Z/sdt5bX/vOlQfTQv0Dcw7kPP9JKo7gedtN
         2GvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738348495; x=1738953295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OHvxpFXR5lAEIxk+o3Hek4ypvpPcHmc+gKmCjQ+uPaM=;
        b=GshlTDf5xP+t7hGLHGJy/PFXzJNnnJbFHxmk986Rb0f5muerHQ1NyOpPjiDGaYQRkx
         3Kg4Ftq2Oort7XmWCqKEiuFSePbkoVLBc29y7UpPOq/QbhvzYfVBd9DLsvqjpIj9M5KO
         FCDt6aKjp3J7lpS6jHeH6li9ugekpEn7L5YAC3Ko6ykiVgaJzCrEuYu6gKfFcRiJUwpd
         cQrEDfdPo0kzJTtK+sJwwi64zSpEpZMXqZaVeBvKb+xiEu9KkBZr1a57A2qlehyWsMxR
         b9B3hniLFBtBehnh3gRdDf3i/shn02sJmak8v7s1sbiD7f8+7RohQlvlhJW7kyE9zVWS
         QJIg==
X-Forwarded-Encrypted: i=1; AJvYcCXi7WPJLIYTKN+M9lYudENn8SGCRFGonadDwISG8+WvylFOU1SMPqJ2VBRgUMjpVUVQqwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyecfHhSEPBM5zFuGPF9gqfBvoON0OZPGYraF86lZrXbERDDh+Z
	MuIm8s4Rw87C9rP2y2uoaDlo3rcedYmzzURuxKgZE2gVhY49QVVf8/jLAmTwMfQhCoJ3aWvo0UZ
	XuA==
X-Google-Smtp-Source: AGHT+IE/oZCUZdCZRJTGm8rMH0vhTkQhVXUs+8QMDWccMmAQAm7pMQvcBwS4gYOfo5ygWQzF5ovfuAe5ry0=
X-Received: from pfaq15.prod.google.com ([2002:a05:6a00:a88f:b0:725:eeaa:65e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6f54:b0:730:1db:80b2
 with SMTP id d2e1a72fcca58-73001db80e2mr418968b3a.17.1738348494797; Fri, 31
 Jan 2025 10:34:54 -0800 (PST)
Date: Fri, 31 Jan 2025 10:34:47 -0800
In-Reply-To: <93e8a84a-d4cc-4dbc-a593-99995b000947@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738274758.git.ashish.kalra@amd.com> <8f73fc5a68f6713ba7ae1cbdbb7418145c4bd190.1738274758.git.ashish.kalra@amd.com>
 <Z5wqN5WSCpJ3OB0A@google.com> <93e8a84a-d4cc-4dbc-a593-99995b000947@amd.com>
Message-ID: <Z50IQyFzuMQRihhF@google.com>
Subject: Re: [PATCH v2 3/4] x86/sev: Fix broken SNP support with KVM module built-in
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com, 
	will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com, 
	dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 30, 2025, Ashish Kalra wrote:
> On 1/30/2025 7:41 PM, Sean Christopherson wrote:
> > On Fri, Jan 31, 2025, Ashish Kalra wrote:
> >> -nosnp:
> >> -	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
> >> -	return -ENOSYS;
> >>  }
> >>  
> >> -/*
> >> - * This must be called after the IOMMU has been initialized.
> >> - */
> >> -device_initcall(snp_rmptable_init);
> > 
> > There's the wee little problem that snp_rmptable_init() is never called as of
> > this patch.  Dropping the device_initcall() needs to happen in the same patch
> > that wires up the IOMMU code to invoke snp_rmptable_init().
> 
> The issue with that is the IOMMU and x86 maintainers are different, so i
> believe that we will need to split the dropping of device_initcall() in
> platform code and the code to wire up the IOMMU driver to invoke
> snp_rmptable_init(), to get the patch merged in different trees ?

No, that's pure insanity and not how patches that touch multiple subsystems are
handled.  This all goes through one tree, with Acks from the necessary parties.

