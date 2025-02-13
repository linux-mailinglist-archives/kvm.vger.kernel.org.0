Return-Path: <kvm+bounces-38078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E266A34C62
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 18:51:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 877BA3A3F91
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C037623A9B6;
	Thu, 13 Feb 2025 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V1PhRtDJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339E42222D5
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469090; cv=none; b=VKCiqZRpsdhGviaiLLsg8PUFqwUSVNsO9HxZEujvVWBxzrgUaolDA0K+33t3hnd9RjTJl66qqpDBYXZ0Lgo/9NtRlPEL/JZD+jLVVVwrYHVrkCWl97tF32Pc+KYifd3M6fVJXZd1SDhZ7ZyUK0eCWo7U7oFSFamRUO59UATwlt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469090; c=relaxed/simple;
	bh=QJ+YCqNgWAmQUnvwMc9D+esAomTJ65yyPVnESZZWZlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PfCmdhxMbD8xmk+4zi5LGo4yae60dCTq50TBufPH37hrNa4jMsd+JQ7faDNbSVm9nHFRkqvZmiOfZxL8308+/393tuL/5O2G4mlnNlq33oFc7F+RnHJzt8y0pAFGbyjzga3zXn/RMCE2WEdMnNMxJfa7J6I2c3fbzvBF3CuZ9D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V1PhRtDJ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394b8bd4e1so9160175e9.0
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 09:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469087; x=1740073887; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=StLJ8Lv0+CjYYh45JBL2tc2N6KZWn7gX3vfe622hY7g=;
        b=V1PhRtDJle1VANHtj6LvaCTKy7J/fG0b0Kef0yGlOixQL2/kWm6z9xbYCXmUx9hMMq
         QIBmJgQY8c305lQkvpdw4yTdaFLbjP7xz7PqLvRiS71y7384ZOVHd6yRa75AXmftbgqy
         ySW2slPOGncmqCFjQ8iMQ/GP5ob1JdLtlBUZVJVyIqeJunFLv+DNjcQumv1ri5L3/GRf
         yB7Zi5VStP5mVW4QiEzvjvgfBS1txGdfvSqLORd/KKf8Qxn/ER1+h4u6w0r9q/sy6gpL
         tymn3eD4RIqD6Yr9nOfsUh5wUtvM9jO9hpNlDBLTJ6mZ/CEBB+CjR5GUxdayyqH05vTS
         aVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469087; x=1740073887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StLJ8Lv0+CjYYh45JBL2tc2N6KZWn7gX3vfe622hY7g=;
        b=U4mTIJD1uVd51uClOZ8uYHrZDlknf57ZNd0LarFoyAv2Oboty918R4nmxgIWDRb5ua
         dvHO6gUZktYFxv4UCXWe6F7GLu2n7ZCN6QU067B431zwhnxh52TCGnBh6SPLsdQqxTZY
         npVsCcj9g9auorY9+Jym/Sz4vzDZE88tyon+ZG/ga5D1NNrp34Gdz8n1pmhOSpJC3e2/
         7Ej2/H35PHh8T7oqk8ZQ2NXT4IlAifGzKpp7uF/MG8FmvSxGQ/Nk55U/DunkGgu03olg
         fqG/nk8olANyujAWuyENEOI74YQAtasKyt/+NNzsVcfin71jN97ypqx97gCejOKB6WW2
         k99A==
X-Forwarded-Encrypted: i=1; AJvYcCVCCgRDDG0zKE6a4vxw7u4IFM59vWqoC7gbCyLe9MlIDrNY+zhc6sPJVqzPUBtwXV+D4jw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSxvynp2vlNlVGPwk8iY858s6qq4oc1Qyw9D5cZb6is4nh47Cn
	2CfJmabO5XUWdtg/+a8WiymckkYFzGYk4ywzGGNt3P+sJdxgzuBta/llrYo3sc2ZHp1qGD9FvHN
	9H0LF3UD4xA==
X-Google-Smtp-Source: AGHT+IHJQhbZxraXoYW+RerdwbS6IAuVOL8abyk5CD9QxezqCKXS+2bgbUhDIcBF8lD7NKhhG/VsLuytXustyQ==
X-Received: from wmbea8.prod.google.com ([2002:a05:600c:6748:b0:439:65f0:b039])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1908:b0:439:5016:3867 with SMTP id 5b1f17b1804b1-439581be3bdmr81755765e9.23.1739469087554;
 Thu, 13 Feb 2025 09:51:27 -0800 (PST)
Date: Thu, 13 Feb 2025 17:50:57 +0000
In-Reply-To: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213175057.3108031-1-derkling@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Bellasi <derkling@matbug.net>, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

> On Thu, Feb 13, 2025 at 01:44:08PM +0000, Patrick Bellasi wrote:
> > Following (yet another) updated versions accounting for this.
> >
> Here's a tested one. You could've simply waited as I told you I'm working on
> it.

Thanks Borislav, no problems for me, I'm just looking into these SRSO fixes and
what I did was mostly a way to ramp up.

> I'm going to queue this one next week into tip once Patrick's fix becomes part
> of -rc3.

Thanks for all the efforts.

Meanwhile I've a couple of questions about the approach proposed here.

> + * 'Mitigation: Reduced Speculation':
> +
> +   This mitigation gets automatically enabled when the above one "IBPB on
> +   VMEXIT" has been selected and the CPU supports the BpSpecReduce bit.
> +
> +   It gets automatically enabled on machines which have the
> +   SRSO_USER_KERNEL_NO=1 CPUID bit. In that case, the code logic is to switch
> +   to the above =ibpb-vmexit mitigation because the user/kernel boundary is
> +   not affected anymore and thus "safe RET" is not needed.
> +
> +   After enabling the IBPB on VMEXIT mitigation option, the BpSpecReduce bit
> +   is detected (functionality present on all such machines) and that
> +   practically overrides IBPB on VMEXIT as it has a lot less performance
> +   impact and takes care of the guest->host attack vector too.
> +
> +   Currently, the mitigation uses KVM's user_return approach
> +   (kvm_set_user_return_msr()) to set the BpSpecReduce bit when a vCPU runs
> +   a guest and reset it upon return to host userspace or when the KVM module
> +   is unloaded. The intent being, the small perf impact of BpSpecReduce should
> +   be incurred only when really necessary.

According to [1], the AMD Whitepaper on SRSO says:

   Processors which set SRSO_MSR_FIX=1 support an MSR bit which mitigates SRSO
   across guest/host boundaries.  Software may enable this by setting bit 4
   (BpSpecReduce) of MSR C001_102E. This bit can be set once during boot and
   should be set identically across all processors in the system.

The "should be set identically across all processors in the system" makes me
wondering if using the "KVM's user_return approach" proposed here is robust
enough. Could this not lead to the bit being possibly set only on some CPU
but not others?

Am I missing something? Is the MSR used something "shared" across all the cores
of a CPU, i.e. as long a vCPU is running the entire system is still protected?
Maybe there is even just a more recent whitepaper (I did not find) online with
a different recommendation?

Also, setting the MSR bit only while the guest is running, is it sufficient to
prevent both speculation and training?

Think about this scenario:
(a) Guest runs with BpSpecReduce MSR set by KVM and performs training.
(b) We exit into userspace and clear BpSpecReduce.
(c) We go back into the kernel with BpSpecReduce cleared and the guest
    training intact.

If (a) can be done (i.e. the MSR does not prevent training), don't we end up in
a vulnerable state in (c)?

If BpSpecReduce does not prevent training, but only the training from being
used, should not we keep it consistently set after a guest has run, or until an
IBPB is executed?

Best,
Patrick

[1] https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf

