Return-Path: <kvm+bounces-3042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7B2800146
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAD1B1C20D53
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF46C17F3;
	Fri,  1 Dec 2023 01:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q/tfciZT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396D9A0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:54:32 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6c415e09b2cso1912068b3a.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395671; x=1702000471; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PKWMAIjcAS8BeI7d93Q2buqUeQzLcxL2KToIl+B67YY=;
        b=q/tfciZTHghwtQGUrzY9MTa1sD0lbKskkEVZRrTsrMkl+ZJX7awZrhHHgmIENLumUz
         hLN9Mv+u8xhAlZhPOHivK4uBrBY8cqIyVrcLV+1EPP66YnPBy8zdAmFEbZcfvi2gLE5N
         d72JySHtLfpQLfAFXa3T9RnUEz3/472AixJyjH3hFWoUTfkk6DbSfmCvKtmykNOGotgq
         vW/OGcoFOTRIN6AqURqvEkbWswVZuK3cbX16PsfbveklJP0X7o7s0MqpaYlN+26nZdAj
         KbJM84m9Fhe5C19IX38jWWaaPrP9dJh8+rHYdUZitg9jvVtPcKcuUffBlzrTHQB7cWH7
         H/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395671; x=1702000471;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PKWMAIjcAS8BeI7d93Q2buqUeQzLcxL2KToIl+B67YY=;
        b=Vaf64o8htwhWiJwO6OlwsVLE45tLgoBhs36u73U7QeKz98vRi+y75HmHBN2IoXvlB4
         RAOyHIBpkNxH4jEn8w9gTBNEOSpLZnoJI9NQiYMOrnmJ1a/A01aRg8u/6/QUFKb1oExn
         Rh46sT9YNBDS3ih/LmL0gxwTy8YkDjUNxqmAK+BfZPm+hOCtwnq/xI19qOUXUTb8cylq
         ySWzo23ZItWN0S8CI6z2t+1yEyjg5ptHpxJbP/kyuW012lzQZnIksQF+5ENlsTN4yvkd
         NGkrMHGAOf7m5uIVcMvk1DHOboKOxn6TX0phvgMmkQYM5Jdx3FKI1FZ1YTEw4v108oFy
         fSvg==
X-Gm-Message-State: AOJu0YxzVYy4gzb9wLntRfLNNxqYsfRpACYYloLXo0Oz8b/Fy42Ld3Yg
	1XNPlLNfGLC9hkupficNc5LhOOKVHnM=
X-Google-Smtp-Source: AGHT+IGDV/0tldeZjg1P5I9SIGsp33yBLfURnsG/MQa2vzkfcUeFecZ6Xi1PNdITyY6nXlZX2Asi72r1Qfs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d29:b0:6cd:f18e:17d with SMTP id
 fa41-20020a056a002d2900b006cdf18e017dmr382231pfb.1.1701395671646; Thu, 30 Nov
 2023 17:54:31 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:10 -0800
In-Reply-To: <20231024001636.890236-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231024001636.890236-1-jmattson@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137622057.658898.161602473001495929.b4-ty@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"'Paolo Bonzini '" <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 23 Oct 2023 17:16:35 -0700, Jim Mattson wrote:
> The low five bits {INTEL_PSFD, IPRED_CTRL, RRSBA_CTRL, DDPD_U, BHI_CTRL}
> advertise the availability of specific bits in IA32_SPEC_CTRL. Since KVM
> dynamically determines the legal IA32_SPEC_CTRL bits for the underlying
> hardware, the hard work has already been done. Just let userspace know
> that a guest can use these IA32_SPEC_CTRL bits.
> 
> The sixth bit (MCDT_NO) states that the processor does not exhibit MXCSR
> Configuration Dependent Timing (MCDT) behavior. This is an inherent
> property of the physical processor that is inherited by the virtual
> CPU. Pass that information on to userspace.
> 
> [...]

Applied to kvm-x86 misc, with macros to make Jim queasy (but they really do
guard against copy+paste errors).

[1/2] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
      https://github.com/kvm-x86/linux/commit/eefe5e668209
[2/2] KVM: x86: Use a switch statement and macros in __feature_translate()
      https://github.com/kvm-x86/linux/commit/80c883db87d9

--
https://github.com/kvm-x86/linux/tree/next

