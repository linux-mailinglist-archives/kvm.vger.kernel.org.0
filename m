Return-Path: <kvm+bounces-55080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C56EB2D082
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF423B08BA
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD523274FD0;
	Tue, 19 Aug 2025 23:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fjEG08DR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B43214A94
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647673; cv=none; b=c00/L/mYqxawnK86ngShPPHCzqfn+qAAE2o6BjQQM5dlIBbWxOijjsWKszGoZ/2xAuk/swxlRa8+LjJ8p+zgiZVMVw8cSnXlASAehNd+lj3naxsM7WGoN/YNF8NgO6GXPOnki/rHNWzpmKGUu17DS6EX0XZ38ozb3M2QiEgtQe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647673; c=relaxed/simple;
	bh=7mZ2Rop1MQkRe57iV3p+aBejBXKB1RIJBmZxudX1P4A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iji8u4icaTmYGn8OikBbRjtc9DdEdkr9uPttL+rxy2dOQP2vRyoEpPnnrgZucciC56nA2uRvNfwuansROhwoxDxzpAl+NZixcoKs8B0WwcVjKo0sAOaomaj6YUlMXjR+6CtcfxLCcOm+GI5CG5BFM6LAgVTZleVXxdogvzBG3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fjEG08DR; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47175d5a90so4786593a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647671; x=1756252471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GKJkXuUIpUQUM+xBcUSsl3rt1yGa7xGaxl8d9fCwxo4=;
        b=fjEG08DRkaAJRzM9QVd6jf/kPVrIXZcNdZEaTrtlkje/KGXyuVPf7sbeB22Y5Tn4cg
         x62fpSRcWqB1QpMjO1gTUSaXr2O5Ob+XKt/oto4Z+lhNH9SgPeanGG0fzVAaeOvp36AZ
         dd6dqaTw75SuygyPzcPgl6bcExk3HoSMoSSv6Ed9Uj9JBFGxbEgH9wSavkenkd0PQc3w
         AOec3kZ9BDs7NxiVCQ7yKx7XSgHoz2yckecpDjy9MSbxy7//SYXRbbxr8TjA+RGvrqtL
         aGSJFLQSDdlORLdtzCkSP8KUqjrpzQrpjatC1VetlYiDJiURelQmYe9gk7+ua7WQAHee
         ivYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647671; x=1756252471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GKJkXuUIpUQUM+xBcUSsl3rt1yGa7xGaxl8d9fCwxo4=;
        b=GJnh9OlVFknV2+rCtzrgto40fLRi2VbspnD8Vg9Od0N/E6dm6otrtb1mXYhapTS90t
         wLnigfdfvnPc3GDB5THNKWI0pzvDfBJXgZoXRWWsFdHEILP/eeOu29ag+G6JqWgJ9VOu
         NKB8FSUzQ66mZu7vDQESaTYjoT/TyFcjQv+EHuNDlPABHA5ioQ22S9Ca7vVRozoQgOFV
         tQzmrQIB2KixBcd3RahrkL4GUObBvDz+3MJkoCfXNX0Bi9u3zWur467gI7AIf5oJ6Znr
         jazt4jlQWapzRDe/yqwctjI1U0+FU7qWy1pIul+HBiHs1qEQE0zb9PLjiPbv41KCcUsR
         oqWg==
X-Forwarded-Encrypted: i=1; AJvYcCXKicovaOxKIlDnTjA91Hrgb2dY6YTOTjC/VHnvokMhPHgXPzRmo2T/auVJo/OAQ/6P6gU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZFL/nCfxiM5z/puy39qElpMPs7Txqw0uOLsq88b5ob6ZVLU9F
	/5k5tpxbREniOXbp2bMQjO6MztRA0xHii9mgu/HAN57CVl0PDh9coUuSfFNHrNTOCERWGrK4AIT
	v/Pm4FA==
X-Google-Smtp-Source: AGHT+IFxiQOE+L5bzVLkoj9P4wR69GVqLYrYE/Yp4V5UbrRa24ig1wPqjdPLp+qoI1s6HE43mpFqF5WBBcM=
X-Received: from plbv17.prod.google.com ([2002:a17:903:44d1:b0:235:f4f7:a653])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:246:b0:240:6aad:1c43
 with SMTP id d9443c01a7336-245ef25a2e5mr9368545ad.48.1755647670844; Tue, 19
 Aug 2025 16:54:30 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:54:29 -0700
In-Reply-To: <7cfe68c2-a84a-4416-a9ca-3bf5225190a1@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626145122.2228258-1-naveen@kernel.org> <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
 <aF2VCQyeXULVEl7b@google.com> <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
 <bp7gjrbq2xzgirehv6emtst2kywjgmcee5ktvpiooffhl36stx@bemru6qqrnsf>
 <aGxWkVu5qnWkZxqz@google.com> <3xpfs5m5q6o74z5lx3aujdqub6ref2yypwcbz55ec5iefyqoy7@42g5nbgom637>
 <7cfe68c2-a84a-4416-a9ca-3bf5225190a1@maciej.szmigiero.name>
Message-ID: <aKUOtQvIAN5FC0MC@google.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Naveen N Rao <naveen@kernel.org>, mlevitsk@redhat.com, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Maciej S. Szmigiero wrote:
> On 18.07.2025 10:19, Naveen N Rao wrote:
> As you can see, currently AVIC works there even without force_avic=1 so why
> now hide it behind that parameter if errata #1235 is supposedly not present
> on Zen3?

Yeah, I'm aligned with keeping the current semantics for force_avic (and by
extension for avic), and I'm pretty sure Naveen is as well.

> Also, this platform is apparently confident enough that the AVIC silicon is
> working correctly there to expose it in CPUID - maybe because that's CPU
> stepping 2 instead of the initial 0?

My vote is still to only enable AVIC by default for Zen4+.  The story for Zen3
and earlier is just too messy.

