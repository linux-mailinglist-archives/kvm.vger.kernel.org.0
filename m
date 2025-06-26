Return-Path: <kvm+bounces-50853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 044B4AEA340
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83C634E471E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 16:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21466202C44;
	Thu, 26 Jun 2025 16:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3eEgvsE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063B1EA7CC
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750954127; cv=none; b=A8VQHne8HW5sKpZ04C1U8q26wx4/LCiOhCR2102B+/8oiBsVTdYdKyugVaJFgkXTZI3IRoqJ7/KStHEMsYqiRjxvtqZWmCyZC5mpBl5TGiHb5k5WPrEyXjml0K1vvHEesDXKE2oiY9zautD8yyr4Jo72viz1IJN8ChPZrtyOeuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750954127; c=relaxed/simple;
	bh=25rcnHrGAd6jyBjad9VkriANs0eN1jgdnIwuMPPx2Z4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p4KTUIeb+x3VwN3KIstdnC/IbSMkyJPzLn3GFNmYKD9SfbAC0eb8Rp14ioNNuZRnAvfryb7zLcxajoH9qcO2IU6u1Jd4BWKUxc8At8KO4ltOVIBstcljPOqlgH7Brpo6pPp70tewx0n4l1nZtG3OWH0ueR1fsnz4LsTJ/rtYzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n3eEgvsE; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so12363a12.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 09:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750954124; x=1751558924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DfDY3q/RuaDFoPam7Snloe52g2QKGAUoB/zqQm94AJI=;
        b=n3eEgvsE7Yz33h1QXbsNYrqnFNlozC/Clb6jvOh137n5K4Z+9OchtITg7QdPz6ByOu
         YsR0wnFe5wfq2aWSob8A8NkPRLe3ajBA/38ECzgtyN6Fyx1plYn6BRXdEk25N9HQ0LLH
         QiuMlgGVKpso3uJnXOVxROCny8i5U2UVwK0KF3lfyFKsI4dzG/3Ve3YlANO60gSWHk2X
         9/9M8PFa8YdvwhDZ0unwAKrL2iGmwjg+FgltDTIlqrYHpeXqC7Y1N0IO6dLrx5db8LtX
         OjDpRrA82fOTaEQiO3NWNe4YHdYIWzkP3l21Rw2CMMQSm2x6GaB3trPo2kaRSTA2tTYS
         jBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750954124; x=1751558924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfDY3q/RuaDFoPam7Snloe52g2QKGAUoB/zqQm94AJI=;
        b=u7SBybdDg2ojggwMNRMTQBQIZfd/ac7mvpe/rHR6IpZyOmMIB6Uib5hScAgwrkxg4/
         PDP6B6U/zcWwd3B3O4mu+Qu2aVSsVf5MPCvpfXLXfTjPtCZ/SnzzmWmkM+HECYTZBLPg
         A3/f04vl4IMYPTkY0LcDxoV6/uCcsYPQd4ar1wBH8pqRbGo0GkeilLBv2x4WVr5wh2e0
         sMR1j1z0pL+NKN7L9ylET3AmwGxO5mjzRqzz5oQS+raqfGhQPebstGQYAsFYVsuk4qlQ
         TbDx4tSPj8ZIF6BfNoHNE2a+UJOzDZ/qvJA3ZbL32WQHigRa1svS/Ci1JA7rm4PdZIFG
         xIXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWceG5nSww+lDx5sNRuSHBKWz57NhJaAKLmSEGbYWU9yLj+G4GjvfK4xJQemaGLRnpAhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOF+GhSuhRUqHu+tbpYtf7nN5sP7wifVBoCX4betupBByancZ1
	7xjVDKJYO2XC95t2k5XtE7dQZ004an1sPMPn95G9RLbZJPtMJdiu4+6Bl7cu5weLkrDUbWohJdt
	esjNQiMxusdDrN8DFyj5IAgS+xrV0SLR5T9VlQh0y
X-Gm-Gg: ASbGncsmH+8MysAIA1FxhGRkMrsnqB6veXhcs40h30AAeNvlLLpfqrXdnlE2hA/UKJS
	k1guON2wo6vof5N3hRU9NnBh6qjCdZBf9WhYBZ3/6o1aB/VIfe1pG7efj94CZCePZz/FFbp1AQ1
	ax2uEizPRNUJmajL9Sx+QieMaWZGKAKOHLS2iJlvzyLa4=
X-Google-Smtp-Source: AGHT+IE720RjzTvcYQIe5ayorOJ+4B+pX+uR5Q71uQgifMD5UGWiBsgqrg4xzUqgd96gIG4zVplUEEf/vAhAr1oDEas=
X-Received: by 2002:a05:6402:2888:b0:609:b4b1:514b with SMTP id
 4fb4d7f45d1cf-60c865db901mr295a12.3.1750954123712; Thu, 26 Jun 2025 09:08:43
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com> <aF1S2EIJWN47zLDG@google.com>
In-Reply-To: <aF1S2EIJWN47zLDG@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 26 Jun 2025 09:08:32 -0700
X-Gm-Features: Ac12FXxI4E7VzrdrXP4rTj-hWh_ZYuicrnJPU7mpg7k0GFjNvJZ8JcRsUVG1DUM
Message-ID: <CALMp9eRjDczhSirSismObZnzimxq4m+3s6Ka7OxwPj5Qj6X=BA@mail.gmail.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on AMD
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com, 
	x86@kernel.org, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 7:02=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> I don't necessarily disagree about emulating ARCH_CAPABILITIES being poin=
tless,
> but Paolo's point about not changing ABI for existing setups still stands=
.  This
> has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86=
: Emulate
> MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when=
 KVM
> enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: =
x86:
> IA32_ARCH_CAPABILITIES is always supported").

FWIW, commit 1eaafe91a0df ("kvm: x86: IA32_ARCH_CAPABILITIES is always
supported") was intended to deal with live migration issues across
Intel microarchitectures. I probably just forgot about AMD at the
time, since it wasn't on my radar. I blew it. :(

