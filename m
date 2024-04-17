Return-Path: <kvm+bounces-14992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3988A88D1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43CF7B21196
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C517148FE8;
	Wed, 17 Apr 2024 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ykax38AL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A1F147C9D
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713371203; cv=none; b=Ego2vOshfoYC/OGcYYuBAL5+FY1MhCxqNL95n6BUIahzUz4haQt8a0W8H/X9p7lIeAZEezR4zDX3U9UYhTX1PoKJX1cZ6DZvq4UdsBpwgAPUV86SPcZANCO6g6y4qiA0HczfQj6zq4qaqv5O2Rz3D2XbJiPuHGFHmRuKjaPgSL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713371203; c=relaxed/simple;
	bh=vi6PLLS71URuA1xjxaHf5U6NQwm7wUQpu9Kos5MHRGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fGyu1FsZ+K7nn4ny9J8z46QLph6aqL/LmM7gTc4gi7fPataTy11cBR8+IEXyOp27r5g4Z5ZkQn1ikV2QBwrZSnvPMg0CrPjjLsKtTzdvc6vW4dmtd4du9bDPO2R+3XoszIhS7ii8f/9uWPalmwI6779qs/6R9nJJuw7d9m+g9sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ykax38AL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ece02cfbf2so5703115b3a.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713371201; x=1713976001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UpiYLbF9nUsOKheKQ/CBFa6Q1CQe56BfIxvZY8oF++s=;
        b=Ykax38ALumt/Xm1h3Bhap6GXwBAAktte8367HPqLhzzjIjVh9aawCLXTuZ3OKtLkCr
         9dFhCIxl6arGdqQxMPTm2CooUD65TN0tppo6WIRamjCzgpmxQQ0nG8ckgyWo429DlfaS
         qRyo7ZUdZGfGeyiYGjAe6KEwCVuXy34xm9lD7jff25w9ejHdnV6Lt2ASumj3kao1ipk6
         WBJjKU3ul1cfCjAorBVOtflLG7JC9aXECBFbURX4bhratmx0/VM/GUJbubpRBpjjXDBH
         zVCZxusvstjBCVqFhB4+O/b3vipDwR4xN0vYuRvWYMElNPX2uo2XVejosLwjP8sPhj+C
         Tl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713371201; x=1713976001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpiYLbF9nUsOKheKQ/CBFa6Q1CQe56BfIxvZY8oF++s=;
        b=LHjz8HWuc+OSXRaY844KxXXiGgP62EZBcAV4cxYPLyWMPc26rYJf1TPX1AOzF1DUoN
         EgVc24BNqbZbVU3PKv9cCqiUvRHqqCGlyDXqIza1PvEudZ4WmoDZq1ezJRtNPPfMepHr
         qI9qmaVYy5X9ejlw9cEpH+QJ8Qt15GDP0NgZ2D4E9oCDcfDlA1y/aEMaXe8TRlRIxiVs
         A+drkRQxuWhxbxpd5DkggHbid6oBWiQeaQSlFyNl69EXKz6qeOh8NayCJj5ITa7yL0Fw
         qvmeJ+GrabeYGAC7sbZdGb1EM2kVAlqjd8uCQMFdcCtNiXYCT729JSkOJJrTiH7J/Gj5
         50xw==
X-Forwarded-Encrypted: i=1; AJvYcCXreXSKn+lML/5X3bqDnZMEHC1Y8OpWAhbI18ZC0EUm9MKotWGwdK32sHn9AbNqq+0UpLuNUbKjG1GwSvHBA2V9/NWQ
X-Gm-Message-State: AOJu0YywMZS9YeWtE1pBxA1qZ35bqS4I5k1001FpGStxkhCB/THDGGW/
	utFRdXOYbIn8fS9TidYhYe+NzGT6ttt6WcrK2KQLbjfqw12U51kwWlWBNEau4F0GL8cUPgg7nly
	50g==
X-Google-Smtp-Source: AGHT+IERnb03u6LmnQ9yqPOnlXPGVvYun4H4EARUMiuwyKcMVtvlu3qZHrTcAj52uQytg3lQObKKttzKB8w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:17a4:b0:6ec:f5d2:f7f8 with SMTP id
 s36-20020a056a0017a400b006ecf5d2f7f8mr359pfg.2.1713371201431; Wed, 17 Apr
 2024 09:26:41 -0700 (PDT)
Date: Wed, 17 Apr 2024 09:26:40 -0700
In-Reply-To: <20240417150354.275353-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417150354.275353-1-wei.w.wang@intel.com>
Message-ID: <Zh_4QN7eFxyu9hgA@google.com>
Subject: Re: [RFC PATCH v1] KVM: x86: Introduce macros to simplify KVM_X86_OPS
 static calls
From: Sean Christopherson <seanjc@google.com>
To: Wei Wang <wei.w.wang@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 17, 2024, Wei Wang wrote:
> Introduces two new macros, KVM_X86_SC() and KVM_X86_SCC(), to streamline
> the usage of KVM_X86_OPS static calls. The current implementation of these
> calls is verbose and can lead to alignment challenges due to the two pairs
> of parentheses. This makes the code susceptible to exceeding the "80
> columns per single line of code" limit as defined in the coding-style
> document. The two macros are added to improve code readability and
> maintainability, while adhering to the coding style guidelines.

Heh, I've considered something similar on multiple occasionsi.  Not because
the verbosity bothers me, but because I often search for exact "word" matches
when looking for function usage and the kvm_x86_ prefix trips me up.
 
> Please note that this RFC only updated a few callsites for demonstration
> purposes. If the approach looks good, all callsites will be updated in
> the next version.
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/lapic.c            | 15 ++++++++-------
>  arch/x86/kvm/trace.h            |  3 ++-
>  arch/x86/kvm/x86.c              |  8 ++++----
>  4 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6efd1497b026..42f6450c10ec 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1856,6 +1856,9 @@ extern struct kvm_x86_ops kvm_x86_ops;
>  	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
>  #define KVM_X86_OP_OPTIONAL KVM_X86_OP
>  #define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
> +
> +#define KVM_X86_SC(func, ...) static_call(kvm_x86_##func)(__VA_ARGS__)
> +#define KVM_X86_SCC(func, ...) static_call_cond(kvm_x86_##func)(__VA_ARGS__)

IIRC, static_call_cond() is essentially dead code, i.e. it's the exact same as
static_call().  I believe there's details buried in a proposed series to remove
it[*].  And to not lead things astray, I verified that invoking a NULL kvm_x86_op
with static_call() does no harm (well, doesn't explode at least).

So if we add wrapper macros, I would be in favor in removing all static_call_cond()
as a prep patch so that we can have a single macro.  kvm_ops_update() already WARNs
if a mandatory hook isn't defined, so doing more checks at runtime wouldn't provide
any value.

As for the name, what about KVM_X86_CALL() instead of KVM_X86_SC()?  Two extra
characters, but should make it much more obvious what's going on for readers that
aren't familiar with the infrastructure.

And I bet we can get away with KVM_PMU_CALL() for the PMU hooks.

[*] https://lore.kernel.org/all/cover.1679456900.git.jpoimboe@kernel.org

