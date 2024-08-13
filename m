Return-Path: <kvm+bounces-24023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D35950915
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CABD9B21EC8
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBA71A071A;
	Tue, 13 Aug 2024 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a2w2yaZH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9191919FA9F
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562866; cv=none; b=j6pCmCgRNVwnbK9DoM1RUDnrFdrW0Yar3wZjy7vP4vn21+kfULUBznc5jJNaY+ne9JzLBUJ7tSrOL66/gtxqaa9CDHlJH7DxywMhKcfI93Zphg/oI+fK/pWZRMjTHF7oZJ9Vzj11tQl9F6ZPEZZX8lSqioMl6d7h/LuFX1PEWuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562866; c=relaxed/simple;
	bh=9iTZYX0IOdViDbeJkPHjoGuAtLhEKo08YiRbSxrLWqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lMu9aCuHSKoKTBcnDhgOC1mJhuvrjCyd5Fe7S+x/mftGNZEg8UvR6IJbpQJrd/8L1xwG/ZeJ9Z5Pa5i8dW6mc1w/cvKybt68aHosyJlZSbem2VdfGpr+BitCsuEnk+FEejIn1TwHs/yWjqcGqOZt1OG+o5XHiI/ZMA4mO5wjJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a2w2yaZH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-690d5456d8aso131270757b3.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 08:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723562862; x=1724167662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgS/CxIk8degf9Ujhn4Jhee8VQkdqlo8w99w+08tpPY=;
        b=a2w2yaZHMmLpQP8kQxh1tQm4t02IZjobXzjA2xjIeMLYKyAxYcBE+XL/WC4k9hiTR3
         56jwEhnRKsdicoFO9LxjdulJPDOKk4TE2V8B45YhN/NQdkH5tJgPC36PrCX+GqzPRnx0
         6Axp1Og8bl1CGZ9VNAt8qYWjIdDuQL44MY6nWIDEsva3cqxamYuw6l8sV5bcj6DGDVpI
         oPzxixDDij4OlHepWfX+RT1F6H03Ooqgd824lmcMVaTeP3OBw0ZfK09bIhmI2suvuuxV
         9P1mxcsH8xumbm0r2uFycNc9owKUvDg9ti58wLBzX5MDqfYABFuebQxYBHTgG9Lrf3+T
         1Uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723562862; x=1724167662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgS/CxIk8degf9Ujhn4Jhee8VQkdqlo8w99w+08tpPY=;
        b=fcxvnjd2pmpWzIY6b5jAJxXfyerUMROgnakytASrNR6x58XHF7QsCJfDUTmnUQ0Bdk
         3iEMq00IRf6yvBVBOBty5UQzHVqjdpFZpLvxwuLeNFwa808f71fj4F9AlnAwIWRafXT1
         gH7dEfs2tawQ2MXz4sRSQUpMJ4ohWprYQz3YRmKvPOqQp/WAQbEU6emFAPskl/K2jY2V
         D2/TmzMIS2qEO3kfPAeBb6GNgcN3RfqjyvcN1YYFhr1WflwmRJAC+dA2sqMQGrwx2ilQ
         gZgg+ZZZRNsnVSnNvlHl7cEKGyvPk3tSnRbjfatReF6LCsLhRPQG61SvE1Lr6+mNitME
         dffQ==
X-Gm-Message-State: AOJu0YxZIhVUqa6hpxzPS6Z2gocr/zlarPHrPFJlR5ykmHQzua9O4A0L
	RbMEDbPgMV2tqQcXn+4HBOacKxpQzkOHj4G5KGEnyntmmBMLOT3Zzy+F6eEnmyjngaEcyLQksRc
	9eQ==
X-Google-Smtp-Source: AGHT+IGN0g/iWJrWmwNOf6QYh3EnGuzEizz0+U/tevvxu9l/FVCnp8wtI05EYtrERSQOTEdtYRcJIz2Rvno=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:fc03:0:b0:64b:5dc3:e4fe with SMTP id
 00721157ae682-6a97151ca3cmr1036657b3.1.1723562862655; Tue, 13 Aug 2024
 08:27:42 -0700 (PDT)
Date: Tue, 13 Aug 2024 08:27:41 -0700
In-Reply-To: <5b32da03-addf-4f34-bcf4-76fbe420b8f5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com>
 <20240710220540.188239-3-pratikrajesh.sampat@amd.com> <ZrY4e39Q2_WxhrkI@google.com>
 <5b32da03-addf-4f34-bcf4-76fbe420b8f5@amd.com>
Message-ID: <Zrt7bRGQJ1C9XZGy@google.com>
Subject: Re: [RFC 2/5] selftests: KVM: Decouple SEV ioctls from asserts
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, shuah@kernel.org, thomas.lendacky@amd.com, 
	michael.roth@amd.com, pbonzini@redhat.com, pgonda@google.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 13, 2024, Pratik R. Sampat wrote:
> On 8/9/2024 10:40 AM, Sean Christopherson wrote:
> > On Wed, Jul 10, 2024, Pratik R. Sampat wrote:
> >> @@ -98,7 +100,7 @@ static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
> >>  	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
> >>  }
> >>  
> >> -static inline void snp_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> >> +static inline int snp_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> >>  					   uint64_t size, uint8_t type)
> >>  {
> >>  	struct kvm_sev_snp_launch_update update_data = {
> >> @@ -108,10 +110,10 @@ static inline void snp_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> >>  		.type = type,
> >>  	};
> >>  
> >> -	vm_sev_ioctl(vm, KVM_SEV_SNP_LAUNCH_UPDATE, &update_data);
> >> +	return __vm_sev_ioctl(vm, KVM_SEV_SNP_LAUNCH_UPDATE, &update_data);
> > 
> > Don't introduce APIs and then immediately rewrite all of the users.  If you want
> > to rework similar APIs, do the rework, then add the new APIs.  Doing things in
> > this order adds a pile of pointless churn.
> > 
> > But that's a moot point, because it's far easier to just add __snp_launch_update_data().
> > And if you look through other APIs in kvm_util.h, you'll see that the strong
> > preference is to let vm_ioctl(), or in this case vm_sev_ioctl(), do the heavy
> > lifting.  Yeah, it requires copy+pasting marshalling parameters into the struct,
> > but that's relatively uninteresting code, _and_ piggybacking the "good" version
> > means you can't do things like pass in a garbage virtual address (because the
> > "good" version always guarantees a good virtual address).
> 
> I am a little confused by this.
> 
> Are you suggesting that I leave the original functions intact with using
> vm_sev_ioctl() and have an additional variant such as
> __snp_launch_update_data() which calls into __vm_sev_ioctl() to decouple
> the ioctl from the assert for negative asserts?

Yes, this one.

> Or, do you suggest that I alter vm_sev_ioctl() to handle both positive
> and negative asserts?
> 
> Thanks!
> -Pratik
> 

