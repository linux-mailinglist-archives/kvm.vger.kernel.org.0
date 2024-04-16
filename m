Return-Path: <kvm+bounces-14848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 922608A73D7
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C18FF1C2172B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8F913792D;
	Tue, 16 Apr 2024 18:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VV7QYurP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5C0137774
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293423; cv=none; b=bk9+xdLBdumKju7ooPaMXBzqRrHNS3Jy1zpmSY8LcwCCPC4kuI6ixQXCQxXVqusFGlBCTOC1jgNg/y/fpUm9X8k984y1H/Ei7hyGgt5lC4Rjzm2u3WOzmmrK3ZCC+X3HslsNfzEFRSs2IlXZi3Q6xXHqHwkBOe6ET8g4Fe78BbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293423; c=relaxed/simple;
	bh=KrLRBto3JssKwlYjlBIyxafefBjA3IrDNNlM/vJJ9hI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GhxIGtAb3ypKVVXhDywH/xyArH9aWuGu1xKJp0C9nBU0knnJuKxpGYUrjUVI97d+ZjYkl4+gKOgzEIG/rfJyJBHh/qIRx/Vka5KKE5De0Ndjjoail7oYxVRMuZLpVVB8if5u5sTeqr3ACcLNy+l/sQdUu8A0TCtfK9kObX7QML8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VV7QYurP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61ab7fc5651so42961217b3.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713293421; x=1713898221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=71fCbdfH1vAW84WFTiCdLyvSqDYlBpK8GsY+uanrllo=;
        b=VV7QYurPOp5zTg7ny6efPCKGEtrNWZI7feSbb11SZC4ZxHrZ647dEqDP0PmvYgPrCe
         V+XvbGOWpm2/JXVRMM6uWr4AsKw04ODhBIoFBJXEwwhAknQ4Fk8/iZz+lzY4z+s2am0b
         unw70iZR+6DwU34un3OdJZ6qJePX/QcmkBlpVIZO7xAQM+j+2ikzQpCimYhhkSclQMw8
         S0sj9D6DKvGtGAsTShKSMqnzLBrVAC5ipzPrdizdutuVineV4W5CW1ozoBqA8SieoaTi
         x9y7mDoIKLcFBiVoOC4qoqVj3Cz+++E1hYI0y0w0s4jmFoqPbBwNFWB7/bcuTybpLqbX
         lC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293421; x=1713898221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=71fCbdfH1vAW84WFTiCdLyvSqDYlBpK8GsY+uanrllo=;
        b=CLlZ4QyZ5Qm387fLBRbS6wCGWe9xpDMO6q237PfJCE6lsjvmLBrdCervQt+RI3aIV5
         ySAljYo3JLpWebYuLjdgD88VyJZj76MWhZ1Fw2QnN+yTiaGBDimEo/fCf6Qo9CkxQc/+
         WAXNGWedusmblx1mdcA1UA8P1YeH/ldQQ9de0AQPH9UtozYAKDtC97czEQNAko0NKpOf
         1HomHQzXMmQwpM32JgMYI7BAhk3WkI1PWy2rq6vv7V1JKL+grxkQxU2fNqKdohlQPj5Q
         XeMKza5g++/cQoWZjAz0gaBdujsROazMwNjVRMXGl8qw7arLrBwKMkm4OJwUCr3QklBX
         mGhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKSUHqQDOujLpJV5st9LzefQCUEs8R89xCybUbIm/bVAi89XvP08U5ygMoWTL9iUqOZAf/wjoI2VDU2c+mwdL85SJP
X-Gm-Message-State: AOJu0YwRd6Xth61Xu9KYiw9XC+juMEkcaho9mIqSAIpjfNm3nR1b/5+m
	MUsEhbZ4weLsBTL/+vcWOB+7pahLnswCXrEZrCkVRKfWEQq2FpH6rwG74JpBi3nqIFgj80f080F
	UMw==
X-Google-Smtp-Source: AGHT+IHgjpuzWhjz2uabzMwzuba3r3n3pXCUudSHE4FaID0UFJjuojA5qYXAZzXF16Fsmgo1kqxASxbfYuQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1081:b0:dc7:8e30:e2e3 with SMTP id
 v1-20020a056902108100b00dc78e30e2e3mr4217093ybu.2.1713293420969; Tue, 16 Apr
 2024 11:50:20 -0700 (PDT)
Date: Tue, 16 Apr 2024 11:50:19 -0700
In-Reply-To: <Zhz8xNpQoi0wCQgL@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZhkhvtijbhxKKAEk@yzhao56-desk.sh.intel.com> <diqzr0f7jbj6.fsf@ctop-sg.c.googlers.com>
 <Zhz8xNpQoi0wCQgL@yzhao56-desk.sh.intel.com>
Message-ID: <Zh7Iay40VQgNvsFW@google.com>
Subject: Re: [RFC PATCH v5 09/29] KVM: selftests: TDX: Add report_fatal_error test
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, sagis@google.com, 
	linux-kselftest@vger.kernel.org, afranji@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, pbonzini@redhat.com, shuah@kernel.org, 
	pgonda@google.com, haibo1.xu@intel.com, chao.p.peng@linux.intel.com, 
	vannapurve@google.com, runanwang@google.com, vipinsh@google.com, 
	jmattson@google.com, dmatlack@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 15, 2024, Yan Zhao wrote:
> On Mon, Apr 15, 2024 at 08:05:49AM +0000, Ackerley Tng wrote:
> > >> The Intel GHCI Spec says in R12, bit 63 is set if the GPA is valid. As a
> > > But above "__LINE__" is obviously not a valid GPA.
> > >
> > > Do you think it's better to check "data_gpa" is with shared bit on and
> > > aligned in 4K before setting bit 63?
> > >
> > 
> > I read "valid" in the spec to mean that the value in R13 "should be
> > considered as useful" or "should be passed on to the host VMM via the
> > TDX module", and not so much as in "validated".
> > 
> > We could validate the data_gpa as you suggested to check alignment and
> > shared bit, but perhaps that could be a higher-level function that calls
> > tdg_vp_vmcall_report_fatal_error()?
> > 
> > If it helps, shall we rename "data_gpa" to "data" for this lower-level,
> > generic helper function and remove these two lines
> > 
> > if (data_gpa)
> > 	error_code |= 0x8000000000000000;
> > 
> > A higher-level function could perhaps do the validation as you suggested
> > and then set bit 63.
> This could be all right. But I'm not sure if it would be a burden for
> higher-level function to set bit 63 which is of GHCI details.
> 
> What about adding another "data_gpa_valid" parameter and then test
> "data_gpa_valid" rather than test "data_gpa" to set bit 63?

Who cares what the GHCI says about validity?  The GHCI is a spec for getting
random guests to play nice with random hosts.  Selftests own both, and the goal
of selftests is to test that KVM (and KVM's dependencies) adhere to their relevant
specs.  And more importantly, KVM is NOT inheriting the GHCI ABI verbatim[*].

So except for the bits and bobs that *KVM* (or the TDX module) gets involved in,
just ignore the GHCI (or even deliberately abuse it).  To put it differently, use
selftests verify *KVM's* ABI and functionality.

As it pertains to this thread, while I haven't looked at any of this in detail,
I'm guessing that whether or not bit 63 is set is a complete "don't care", i.e.
KVM and the TDX Module should pass it through as-is.

[*] https://lore.kernel.org/all/Zg18ul8Q4PGQMWam@google.com

