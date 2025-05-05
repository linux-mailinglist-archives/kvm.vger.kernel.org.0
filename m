Return-Path: <kvm+bounces-45478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88704AAA78B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 497F8188A0C1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 00:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057A2293737;
	Mon,  5 May 2025 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mSQ1Jmp2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD0D33AAD3
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484642; cv=none; b=mJKLoQ2Ivp8gSvRalGJwweuHrquA0XaEy4LonHdhAeftzn4qY9MA6TWprmBqa8Ur/FyPjUQ9cGP4fvmPb+6m/2ZN9OIXdOWgKxiokzsdx/APqiodfkwOB4vATwys9vo0RGPxzZ0PSsrsVGdEF66pNT9qr15YbvINV6zBZajPkeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484642; c=relaxed/simple;
	bh=/qnphOBltVIWlURouKPWX5W5cAXR4gvjzHWr9irA4Ek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zkyjmf8G2RQgc3Zq7ajYR8zankm4VAfl09ZfrxaDZvkH7Dx3IgZLOn8a+JF7DuLruKl8eGfdHjwOlbxhL2sv+gLIMjlbik65ifFjLP9Op7Nqz/TH7P7pvbjaLfnRVbj7uW8zUyOXsGbjmZJ6VMKlfaNVlk2mmVSwsfMbosqeJaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mSQ1Jmp2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22e327ff362so2985215ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 15:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746484639; x=1747089439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RFJXsNyYfzZ7+lko8SxLtTDp0cHIk0LkJmukv/W5L18=;
        b=mSQ1Jmp2rgrE5W2OkOthgNRIML4koPjGLgQd+nowIF6/q6bOiL8EAMT+WtQAC92mdG
         41Uqk04TV+rqjL3JKZLFQ/Z7fTe7ShX5JUANwHwfhBTXJFr0y/jppy7NXhSMqVTDRMar
         oDQtMIVu4a3n9JWLSXmv70N8fAz/GuVtzaUkbvTgT6NelRf32KDNtfF30q6qo9NshDmR
         f/jnZpPWUH9+EPQmz5e1c9vWiDVEM25hrSTTxt1DO8Hec50WuyBX75Y8SCch5VdGd1BN
         WUV77HBJVYxZc/Dw6x8g0sf/zWvnbHJoBZ0jKbbsEwWbyeJ4Rjs92Jcw29Mm4ukQd9XH
         FEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746484639; x=1747089439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFJXsNyYfzZ7+lko8SxLtTDp0cHIk0LkJmukv/W5L18=;
        b=IK1HLPRTuUZ1bCoSa9QEJV/aYx1M5Z2PAOu7UJJ9cbtl/pBdEfqts60t2+RlIQFsei
         rjWyzKAU/swRCwXQ6+Tg4l26G680kV68mODnky2/ZvKTgLm8qbDd+nys3Q6ruE7UNf1+
         nFwuWbGAhUzjxlxTqeDk+DNkDWuKiOdidsDB+7dFFznUDZ4/JmJBx2VDuGmnNS3ch6fP
         kE84ZxuT8El4cP+ynb3q892R4gvL23COs0vfdoqDXMKtE7aGoPrgcJjvI1m4qjLSJoVA
         iwRl6i5YqgFKxmolSlB5wIVVr/OEDxehwd3O4pH1Yir6WIElvONo0uaZE6jajyLTlHxA
         cHwg==
X-Forwarded-Encrypted: i=1; AJvYcCWEj/rlWBTUYlqg+GyXCZ5W6DcPTCvPfhDNPPxZ2KJuiH70kwMf/N7X8yg/xfJqOHbiZJM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvgJq1S81RcSyCSs4/Y+zowJi/fiewYEr19QQPVjRFudGf2Tf4
	UTh+snVDWgQXVZ50zdHJwY9V/BRT754aV5cQtOkqEcoDMHkN1ZkFIYrTWBr56IVdkOz4F6zub+e
	CSA==
X-Google-Smtp-Source: AGHT+IF7FvBz2XtjdY1Gwm2snh7AYTh3FwqQtsFxghocXrvK4VvzfqD2ppJPcFtt7H5IcBLLk5+tAerZoio=
X-Received: from plrs9.prod.google.com ([2002:a17:902:b189:b0:223:5416:c809])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f543:b0:224:2a6d:55ae
 with SMTP id d9443c01a7336-22e1eac1872mr163309125ad.48.1746484638786; Mon, 05
 May 2025 15:37:18 -0700 (PDT)
Date: Mon, 5 May 2025 15:37:17 -0700
In-Reply-To: <20250505221419.2672473-317-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250505221419.2672473-1-sashal@kernel.org> <20250505221419.2672473-317-sashal@kernel.org>
Message-ID: <aBk9nVsmHObvxU7o@google.com>
Subject: Re: [PATCH AUTOSEL 6.14 317/642] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, peterz@infradead.org, 
	jpoimboe@kernel.org, corbet@lwn.net, mingo@redhat.com, 
	dave.hansen@linux.intel.com, x86@kernel.org, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, mario.limonciello@amd.com, perry.yuan@amd.com, 
	kai.huang@intel.com, xiaoyao.li@intel.com, tony.luck@intel.com, 
	xin3.li@intel.com, kan.liang@linux.intel.com, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Sasha Levin wrote:
> From: Borislav Petkov <bp@alien8.de>
> 
> [ Upstream commit 8442df2b49ed9bcd67833ad4f091d15ac91efd00 ]
> 
> Add support for
> 
>   CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
>   indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
>   SRSO.
> 
> Enable BpSpecReduce to mitigate SRSO across guest/host boundaries.
> 
> Switch back to enabling the bit when virtualization is enabled and to
> clear the bit when virtualization is disabled because using a MSR slot
> would clear the bit when the guest is exited and any training the guest
> has done, would potentially influence the host kernel when execution
> enters the kernel and hasn't VMRUN the guest yet.
> 
> More detail on the public thread in Link below.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/r/20241202120416.6054-1-bp@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Can we please hold off on this until the fix lands[1]?  This version introduces
a very measurable performance regression[2] for non-KVM use cases.

[1] https://lore.kernel.org/all/20250502223456.887618-1-seanjc@google.com
[2] https://www.phoronix.com/review/linux-615-amd-regression

