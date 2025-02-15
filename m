Return-Path: <kvm+bounces-38216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D20ADA36A58
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B99AB3B25AF
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774367080E;
	Sat, 15 Feb 2025 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zBAJwUPY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EDB2A1BA
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580893; cv=none; b=P3EFLY9JS8Z6oL0qqdliugFjxRwliv1JqcgLYI1o0pVs8Hzg16bJqgN9MnMbe4AW4Z3WiDEteY8ZZ5P6GRql0T8PTNnBckd3jt6Ae9aWx4PHWoVBauewF6nF9Z5VuIrQt7kr7pB3HL9YvPsE1Ex3aqwbBa+4th2WyWXWlNz1RZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580893; c=relaxed/simple;
	bh=Ld9V28OVYt5h0CqgTwDyXF0FEO5Bc0rX6CrK0LgdiPE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=rhAma8nwQaaUWabMmrPt3Gg5qPpIAgSTyiRynccQsdKlz6fesdjoe7fdxJ6LmjHk0eFo41QD9XGMi0DNN8tcA7olaDfv26iGAZJI17EjCuJxqiSaQylZ8v32SgVgS+fbTo8KBijwm+htd79MXi2gEGImygHkMLKDIFSKcf1tEZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zBAJwUPY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fbfa786a1aso8051884a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580891; x=1740185691; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tdybb6g8VDJOKzJ4qzEDd+aH5UCFBgsHud83bYRWvVM=;
        b=zBAJwUPYl0BiZFOJC1c+utlLxPKzFEh4se7zXvsekBJ3EOtQeX4neClloTIes2dO2c
         L81/2GrtLly0Sg+xzz4YpFohuY8SLT2HAMJvxMxJPKeMhcQvi/8J4kU7c3iYW1y2YZau
         xP/zcAEAI/cyZs2PfKwcVcVkC+rO9BVRwkudukzMiYudr+Zv9HJyACtjOPmYpG/FXidH
         2cWzNjfBc3T3rFdw5jfMX5pUpuzl5MJk0B9aiUv9HgPRTe68WN+/p+Ax8K8AFMmERtuh
         wB9JGqIE2lPrz3gABcVkd2lscb7O2viVpr5GViczAxCDCyn/Zg/CyBFeuecEctLeKzYs
         MJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580891; x=1740185691;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tdybb6g8VDJOKzJ4qzEDd+aH5UCFBgsHud83bYRWvVM=;
        b=IAwtFhY3zIMSmMpeDzEr0YytUxI15t6U9afmRRnx/PSMiE6n25W7ATXaABy3bNH8Nk
         tDYbAV2FWvfvHJtrVpb5+or9F5nmRjS/jO8d9JGDkPqsZ50nqZIoXG67qzf1pt92fjp8
         U+A+EB0SDAgB+E1WouyBezoTyoE9BvjEcLgl5kDF97CdGhne6S62ejqEocDz/1p+eTsF
         28OV0PmCdkK11v9iyRetZqOCBI2+xnBuaw04t+9NPWQuGIj+GoGp8Iu/nUIRndVbhhp3
         zR/+K278lF8ciyDKobWhDfz6CM/9u6YWDls1QTl4dsaQ7gM+Xr03KhqYtz9Ny1fys/ZK
         dj/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXiyoGWzKkDvKR28uGynsARQG9kbMDnR/iEIYd1Y9SYSl58APgAjsUne28RuwOTOS8EEmg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwc+4VZUwds2T3P59W89BBl1nKMi0skeLAFAsDeJjJLH9Xvrxs
	0NxVKC0GobAobejQbAp91NE2Y3bFv24ax9pzyx8s/eL8aRuwNwAMn7bS0PWTnIZhVzlA3bweoYI
	i3A==
X-Google-Smtp-Source: AGHT+IEgBaOQO7XElOEof5sTPY8dVs3e8scmEECQVZ6r/dV4MOQ+RqDZkjDxvIck/PSvWpLeP9vqrZuyUDo=
X-Received: from pjbqn11.prod.google.com ([2002:a17:90b:3d4b:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48c3:b0:2f2:a664:df20
 with SMTP id 98e67ed59e1d1-2fc40d124d2mr1998414a91.7.1739580891436; Fri, 14
 Feb 2025 16:54:51 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:16 -0800
In-Reply-To: <20250122073456.2950-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122073456.2950-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958010673.1187825.12076479722640669466.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: use kvfree_rcu to simplify the code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 22 Jan 2025 15:34:56 +0800, lirongqing wrote:
> The callback function of call_rcu() just calls kvfree(), so we can
> use kvfree_rcu() instead of call_rcu() + callback function.

Applied to kvm-x86 misc, with a heavily rewritten changelog to call out the
rcu_barrier() wrinkles (I'm pretty sure it's, very technically, a bug fix).

Thanks!

[1/1] KVM: x86: use kvfree_rcu to simplify the code
      https://github.com/kvm-x86/linux/commit/82c470121c7b

--
https://github.com/kvm-x86/linux/tree/next

