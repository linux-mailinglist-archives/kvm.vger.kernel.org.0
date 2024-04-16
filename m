Return-Path: <kvm+bounces-14810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3898A7295
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F88E1F21B25
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FC0134405;
	Tue, 16 Apr 2024 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xS9ZbcQH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E6B13342A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289463; cv=none; b=krdebzJfex8QvE3deqa0s0etsHQwAatDp4n6MwQQhzLqbhy86ZIhco4trDfaxUVXebGz+5trv8fz52DTIp+9nOGL5KYDKQmgUjzq5iZ33eqcHhJVTKyNEv7BEBTB9ZbE0Quo3bv/oaOX786cGrM8OT43pt1+y4SPeD4jdrZZFgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289463; c=relaxed/simple;
	bh=Dym9eq3v37teJ3rTHxRK8yuZenwXYaPUyhd8kQw1XTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o1pEqzbMqsdhIFebg5pVvbduiYwycvV/P/ee5Dar7qnwo7xcMO1HWsRFXFpshfGw14hOj0LiCLCFEAHY1mh9xLC567UUZODeZPW4bxz8ysGRk4YJSPVP8Fshmus0WRf1RNzUXJCj9KYDw/yZayifMMh6mDnTyEDDRwLJeanWGjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xS9ZbcQH; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so6489932276.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713289459; x=1713894259; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yh/tz275QmTuxwd5vfM4NiA3NVZBnBi0b/kj0pimryM=;
        b=xS9ZbcQH6mI7cJyeO/adz54IA31MjRWl7E4nwXT5R3kLzJPFbMkvb5ESrwnn0i5XTj
         2wickrP46YiPYo/O5wzyWcP497KFOL0stpekUYJhvQinCRwmYGJy9yhbou4/8g+RZ63O
         CyNVF7u1liv19R0CqdUb1DfYtLm6j7HmOujQ5WkdVB1/tPefvF3DkiFuhpa5Ifcp5Qh3
         hsAdJocFSObju6F5b4KfTH1EEYo22+k82ZmsxqUi2BFnYZ2oAKw2c6I1k9lXsMkzOR3s
         JxFKem6FwZu8Sd+O7V1x1b2iLEJOXjqpxr8slSQwVjXttHTYCnI8+WJGqo8PzWwt3wd+
         88ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713289459; x=1713894259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yh/tz275QmTuxwd5vfM4NiA3NVZBnBi0b/kj0pimryM=;
        b=AeWMSDk6RoHRk6rhwy0iWgPjpswcGbJBj0HbBbQSPmHDXXOnGNri9E9WIYIg6oqwCG
         6Vc+cGsCpGRv9WmSoGe7YeBGI21Mg6YGfVr/l/O/fW0seye5c7w+LEnz5BfQhd92Y0NC
         Y2SkAPpRrjaGnXY0VArBskzTNvM2c1Oiov5/djViFOW6M+zT6wm6qeHUMqSlG0PISA7F
         SJy/9jdt0iix8f3avLeUh0v5yTUb3MpTztrzOwUaMLA/zmAo4i3MqQIdbZDSRmpDmaOL
         IqHq7qiAWSgIcvTIZ6CiCOs9ZsIx9+9gCmcDtjebuNsonqpfIw7VCM2VwIPq0wlyXnci
         i6rA==
X-Forwarded-Encrypted: i=1; AJvYcCX3XNoGu7A8PVo7SEKtDlcAlqiCX00V6Z723x3tjvqUB80Eys1BHt+VzlTGpUBn00QyenKrvtoHE7LQMpw01JNGHzW7
X-Gm-Message-State: AOJu0Yyi8JC4RPSBnkl0kZI0NzPFOvbYX0qSL1PypulThFsMT8oH43vJ
	ttaGDjEUizJ02gIducpDc8uPpV8PtmhSv7csYisU/e8lNMR/Q4K5tmT66YxFPn1JCsJl/Czpapk
	eHw==
X-Google-Smtp-Source: AGHT+IG+hIp9DQ0jg4Znl4ykGAX8hWvhcF3AdGm9JwsUyK+6Lr50G1ZDc9CBIp9xlgeXBVHUh5OL8tJiDfI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad23:0:b0:de1:2203:2031 with SMTP id
 y35-20020a25ad23000000b00de122032031mr772849ybi.6.1713289459585; Tue, 16 Apr
 2024 10:44:19 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:44:18 -0700
In-Reply-To: <20240221195125.102479-3-shivam.kumar1@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com> <20240221195125.102479-3-shivam.kumar1@nutanix.com>
Message-ID: <Zh648kuOwZMucG0h@google.com>
Subject: Re: [PATCH v10 2/3] KVM: x86: Dirty quota-based throttling of vcpus
From: Sean Christopherson <seanjc@google.com>
To: Shivam Kumar <shivam.kumar1@nutanix.com>
Cc: maz@kernel.org, pbonzini@redhat.com, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, aravind.retnakaran@nutanix.com, 
	carl.waldspurger@nutanix.com, david.vrabel@nutanix.com, david@redhat.com, 
	will@kernel.org, kvm@vger.kernel.org, 
	Shaju Abraham <shaju.abraham@nutanix.com>, Manish Mishra <manish.mishra@nutanix.com>, 
	Anurag Madnawat <anurag.madnawat@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, Shivam Kumar wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2d6cdeab1f8a..fa0b3853ee31 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3397,8 +3397,12 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
>  	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
>  		return false;
>  
> -	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> +	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> +		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +
> +		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(sp->role.level)));
>  		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);

Forcing KVM to manually call update_dirty_quota() whenever mark_page_dirty_in_slot()
is invoked is not maintainable, as we inevitably will forget to update the quota
and probably not notice.  We've already had bugs escape where KVM fails to mark
gfns dirty, and those flows are much more testable.

Stepping back, I feel like this series has gone off the rails a bit.
 
I understand Marc's objections to the uAPI not differentiating between page sizes,
but simply updating the quota based on KVM's page size is also flawed.  E.g. if
the guest is backed with 1GiB pages, odds are very good that the dirty quotas are
going to be completely out of whack due to the first vCPU that writes a given 1GiB
region being charged with the entire 1GiB page.

And without a way to trigger detection of writes, e.g. by enabling PML or write-
protecting memory, I don't see how userspace can build anything on the "bytes
dirtied" information.

From v7[*], Marc was specifically objecting to the proposed API effectively being
presented as a general purpose API, but in reality the API was heavily reliant
on dirty logging being enabled.

 : My earlier comments still stand: the proposed API is not usable as a
 : general purpose memory-tracking API because it counts faults instead
 : of memory, making it inadequate except for the most trivial cases.
 : And I cannot believe you were serious when you mentioned that you were
 : happy to make that the API.

To avoid going in circles, I think we need to first agree on the scope of the uAPI.
Specifically, do we want to shoot for a generic write-tracking API, or do we want
something that is explicitly tied to dirty logging?


Marc,

If we figured out a clean-ish way to tie the "gfns dirtied" information to
dirty logging, i.e. didn't misconstrue the counts as generally useful data, would
that be acceptable?  While I like the idea of a generic solution, I don't see a
path to an implementation that isn't deeply flawed without basically doing dirty
logging, i.e. without forcing the use of non-huge pages and write-protecting memory
to intercept "new" writes based on input from userspace.

[*] https://lore.kernel.org/all/20221113170507.208810-2-shivam.kumar1@nutanix.com

