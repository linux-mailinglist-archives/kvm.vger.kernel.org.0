Return-Path: <kvm+bounces-40770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FCBA5C2D3
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 14:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6938A3B037D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 13:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45721C5F14;
	Tue, 11 Mar 2025 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o8ackYSB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C878F5D
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741700223; cv=none; b=plbZL3YeqTtSTZvn8A/XsBL7vZMA93Sjl9KxjZ2nc9k5dygvxMMOSNQnmUAELTk2WKmqDqrrrLYoMJob2M9kGzC2O0ZHz1V3By5OMCtBBvurg9u43LFdaPQQqMqxukOn+eJ1rRy6bWjTAn1HqZkywZs1V+OTtz6wRhf3kFMCrMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741700223; c=relaxed/simple;
	bh=y/QQH6mqm+8Ho9Aa1K99xXG1QESr4asCjdKr3JIx2Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwJFaOQ1CFwduyzFUoDGHMfxr7nDgAHuopWyztNSiqNK28lzjJVgPk/f4/3CAzTuv7oJ04sCnJwk2SdoujqfxBCoO693pWdvgq0kYJJJviq0jhMkk/t3WpzuWzOyYBZFvPNXWrqltlXufLVUJIZfKy9BiXwHlj/gehQpEhta64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o8ackYSB; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4393ee912e1so43825e9.1
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 06:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741700219; x=1742305019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIICvZUAuF3f8dZklYxLa0v6cPMJSO6jrRsSfDmTFwU=;
        b=o8ackYSBoySwe7rxifFc0DflvVtOpEQHI5aGJhbk4xtqvv41wH8H3JmCxeWUdO0YsT
         6klLwzF9S4qlVeKHOLK45ePhPc0se8QTwAbWytvnWB/7EDIjallMbordAsAEpD+TCqeN
         I87kSHRXB+OG/5H3fxtqIl9NJwGrhz/mq1WQn/NlB5TXl73+3tsUNq7KnqDZsCcyJj4d
         kbOP+usR1/6D5Vmp8dwoRNM38KpNmeDwfMDC1/55zIm0jafqNtepVgWUCvNnn6wARrgV
         7oHm+8LXyJdUaPgS3xPvEblUTtr6bkyTaWBJG1UoeOJL3TbD+O4H7qZi0VntPxkcfqEv
         pdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741700219; x=1742305019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIICvZUAuF3f8dZklYxLa0v6cPMJSO6jrRsSfDmTFwU=;
        b=Z7wKhmBCBM01kaRpD9BXyrFNZGbUw6kRqjNTvhnkkGzUT1Wx0/nEw3ONBo4DVbL+7Z
         t1tRoLnLjylkn57wZhmlX/7PgFoX0LiUK0fUV0lkZGxqBO/pjnjDv6IXUmSAuSfYrVQE
         zx7XC3OUaHxgpEQB9f2Bb9q/OuUpxuxp5SNtPq26q1NJtBvit/KlDRyjzHUo88OComDd
         iz/mdU+UODetxECGzLAef3zFlFTf0ta9FuyJwTIJL7Ju2/XW11CDxUskcQReGL4VZh7F
         +84OH9M9W+9qCuwGB5mlptuAnJhKzUQyhQpAUYzsGMVhpzuDWqZXyEoy98gbPPzh6lRy
         ED0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXK5Nt2y4KLP6Sngj3XdrPtEFasesrDz5kriOMQtHdcHSulWDknY3uiSE3YYcNeG/9rno0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxX4zcs/I6dabpgBnvdbV+IVOXBpSKab4u1i4LMd1bOYXyvKH7
	gKUhAi4CnnM3vXXK+nL15BrjArx+hwxETAvoVCG6/pyqCi3Y+OO3GQrQM3oWvQ==
X-Gm-Gg: ASbGnctJNzeq3pmhPMLI02XTqD32TrngYQLDFbr+VfgaWdJunywQh0AeucA5SndRRs/
	Hoc9BkdBMcohk6+2VwBF2IxLq4/RKFHnnjvkXxizHxk1/z7juuCyNnNCrPnenyYc495RV4+C5nv
	+02bSqv9hQz8U7qeZlH2MoNIxM/RbYoJal+HB0G4jcLvIn6rZmPe0KPXP2BgLuh8lIRnD/MlHpz
	1iHVICOY9l6QYBl4WjcZih52XUn+9oO9/vqZ8c/NfTv26BSXuAS670loEiec7hbOWxlOjkW5UNz
	iVroNx94iDQa13QoVp9w/XgwBrQpJ0VqJCkVApn2vlouuODNnMbiTeKrPUoYOqR2Q6etaTfP3z+
	xD4IZL+g=
X-Google-Smtp-Source: AGHT+IE85f6Sug78tXLPKOdprCo2ei71bex/CBY062wy6JnIWa+O1MeYF2KGYxUN1KWTV+KXujzTgA==
X-Received: by 2002:a05:600c:6002:b0:43b:c744:1b39 with SMTP id 5b1f17b1804b1-43ce90989c3mr4155125e9.1.1741700219431;
        Tue, 11 Mar 2025 06:36:59 -0700 (PDT)
Received: from google.com (158.100.79.34.bc.googleusercontent.com. [34.79.100.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c11e9desm17876951f8f.101.2025.03.11.06.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 06:36:58 -0700 (PDT)
Date: Tue, 11 Mar 2025 13:36:54 +0000
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <Z9A8djMzajTAOawM@google.com>
References: <20250303150557.171528-1-derkling@google.com>
 <20250311120340.GFZ9AmnAcZg-4pXOBv@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311120340.GFZ9AmnAcZg-4pXOBv@fat_crate.local>

On Tue, Mar 11, 2025 at 01:03:40PM +0100, Borislav Petkov wrote:
> On Mon, Mar 03, 2025 at 03:05:56PM +0000, Patrick Bellasi wrote:
> > That's why we are also going to detect this cases and set
> > SRSO_MITIGATION_BP_SPEC_REDUCE_NA, so that we get a:
> > 
> >   "Vulnerable: Reduced Speculation, not available"
> > 
> > from vulnerabilities/spec_rstack_overflow, which should be the only place users
> > look for to assess the effective mitigation posture, ins't it?
> 
> If they even look. The strategy so far has been that the kernel should simply
> DTRT (it being the default) if the user doesn't know anything about
> mitigations etc.
> 
> So I have another idea: how about we upstream enough ASI bits - i.e., the
> function which checks whether ASI is enabled - and use that in the mitigation
> selection?
> 
> IOW:
> 	case SRSO_CMD_BP_SPEC_REDUCE:
> 		if ((boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> 			select it
> 		} else {
> 			if (ASI enabled)
> 				do not fall back to IBPB;
> 			else
> 				fallback to IBPB;
> 		}
> 
> "ASI enabled" will return false upstream - at least initially only, until ASI
> is out-of-tree - and then it'll fall back.
> 
> On your kernels, it'll return true and there it won't fall back.
> 
> We just need to sync with Brendan what "ASI enabled" would be and then it
> should work and your backports would be easy in that respect.
> 
> Until ASI is not upstream, that is.
> 
> Hmmmm?

This seems like a good idea to me, assuming we want ASI in the code
eventually it seems worthwhile to make visible the places where we
know we'll want to update the code when we get it in.

In RFCv2 this would be static_asi_enabled() [1] - I think in the
current implementation it would be fine to use it directly, but in
general we do need to be aware of initializion order.

[0] (first half of)
https://lore.kernel.org/all/DS0PR12MB9273553AE4096FCCBBB4000E94D62@DS0PR12MB9273.namprd12.prod.outlook.com/

[1]
https://lore.kernel.org/linux-mm/20250110-asi-rfc-v2-v2-4-8419288bc805@google.com/

Of course I'm biased here, from my perspective having such mentions of
ASI in the code is unambiguously useful. But if others perceived it as
useless noise I would understand!

