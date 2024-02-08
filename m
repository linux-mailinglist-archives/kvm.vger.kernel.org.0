Return-Path: <kvm+bounces-8322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 240AA84DC5E
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 10:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4107E1C21E95
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 09:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DD76BB27;
	Thu,  8 Feb 2024 09:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYiKt6GG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7821B6A8A1;
	Thu,  8 Feb 2024 09:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707383187; cv=none; b=FuiyFsF2rysA08PRzsHSZXZVvMmpbf1VvQQmuO3OKC5Bj6WhEqzvHLMpq2+RLKMLcW+NpqnzfgsDdlkF085vSCK3q8wigHzkRORsXuzKo4GhHPZaKs6aHTvDgmp1vGk5jKYgmZ5a2cl8ZUx09l7uV/6YEqk7ato5r+hB0ar4NXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707383187; c=relaxed/simple;
	bh=xgrMbTyn4QZKGJFe7U6mMKY27jAxgHscKroJQ/+4+f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=CF25HF1lelf1L0JUPymTh/XeR4SQI4s5l3sLAlXfL0oOHXPgoMWQ6JTJu9f2fbaEfqmB5Z/m3C9u7Z2PCmQauUCk4KmIto8GVLUNTz7Kfs45fWVsEYCv3aE6qOWcp5CGrjrN6AmO4iXejea514cutciTd+avPMfJ4Eq96YEmlBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kYiKt6GG; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dc25e12cc63so607985276.0;
        Thu, 08 Feb 2024 01:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707383185; x=1707987985; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIfLstH2bInbnUGFM06U0tyVvrNVRjaEQPJXMQ0zU7I=;
        b=kYiKt6GGdFdEVR/iH/06gFTb//uyPeKekRURJ8huR8aE9LpWUNgoAhL/JyjKFk2cJs
         OGQZpUYa6SzonzGovjcRRlWmz0gzwux2RNv9RDBH5ZX4/hrYpQyOEza4T79BmVSkuvyp
         e1s+4HfjWiaiCQw1BnY16DZDaL6KKpfbgWhXy/64rfbo02bqdI39f3gdlzzFV+XbsBiM
         l7JFYNZM0Sd2j6djwBDVBhz2zIUMZ0naj2Sz+2M3AxdEhpVs7PxateWpwa3vJ119/R27
         tRGVNLYi2+O8Q9yW5rMi3hUPwX67BCulHsYWERv+4+BA4Kcsu88INYVKKjlbMc41ZWGh
         U4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707383185; x=1707987985;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIfLstH2bInbnUGFM06U0tyVvrNVRjaEQPJXMQ0zU7I=;
        b=tII0/uHNt8j5vLKLEG2Lm/zYTlZYiETFMI2YtjT9BMhHB67v/8K6LK8M7+zQns5F2E
         QnJ+8Lo5FOYtHiV3W6fNxBmius+iQIL2nLGGb8obJaaalvG52JQsDGk7dYFJJuxez4O2
         jeuAkcf0klKygrIFwV4OusJSu9okbujwbqTi2rHd4etwf6MCAe+bogmUbe11/B9MKIiQ
         2qFeFBEXSzzxjVFXpEADG3jXS71p8OvhnPPp2M1gL/p+DPojkcOTjsA9cfZO+ZCCMnJ8
         Y6AuBQce9tvUNlXPio2DvOVtmkOzTGagYJr2HXAHJ4mjY4RBijz4GZWqSS/kln79NMwc
         5kew==
X-Gm-Message-State: AOJu0Yxxwl/D/QvfXIWhB2tlfBfnL6jFnGzq2vcgUxIQWqbsPvcDXOIl
	B7H/T+zxxETDNSpXft6I0e5ydo6lJAmSFsNKx1/1RkKGlOxSo9EbLdwt5gGnE45KH268Q0KIiLO
	s5XunAMHH16nPaxX1NQ96ALd+vFU=
X-Google-Smtp-Source: AGHT+IHJ6nBZOribaKkyCvEWjHLwNPf8W7dYU1kXj55UZSlkAQDTCH8aExIT18Sfm/a6Srmwoj5DzVdHMRXUdXamy6c=
X-Received: by 2002:a25:7483:0:b0:dc6:c2ec:ff4c with SMTP id
 p125-20020a257483000000b00dc6c2ecff4cmr1470470ybc.6.1707383185345; Thu, 08
 Feb 2024 01:06:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124113446.2977003-1-foxywang@tencent.com>
In-Reply-To: <20240124113446.2977003-1-foxywang@tencent.com>
From: Yi Wang <up2wing@gmail.com>
Date: Thu, 8 Feb 2024 17:06:13 +0800
Message-ID: <CAN35MuQmKfhbo0M-O88-Q-s1kXf0TOqoHcUJcsMg4tW+fse=Rg@mail.gmail.com>
Subject: Re: [v3 0/3] KVM: irqchip: synchronize srcu only if needed
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev, 
	maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Gentle ping :)

On Wed, Jan 24, 2024 at 7:35=E2=80=AFPM Yi Wang <up2wing@gmail.com> wrote:
>
> From: Yi Wang <foxywang@tencent.com>
>
> We found that it may cost more than 20 milliseconds very accidentally
> to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> already.
>
> The reason is that when vmm(qemu/CloudHypervisor) invokes
> KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> might_sleep and kworker of srcu may cost some delay during this period.
> One way makes sence is setup empty irq routing when creating vm and
> so that x86/s390 don't need to setup empty/dummy irq routing.
>
> Note: I have no s390 machine so the s390 patch has not been tested.
>
> Changelog:
> ----------
> v3:
>   - squash setup empty routing function and use of that into one commit
>   - drop the comment in s390 part
>
> v2:
>   - setup empty irq routing in kvm_create_vm
>   - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
>   - don't setup irq routing in s390 KVM_CREATE_IRQCHIP
>
> v1: https://lore.kernel.org/kvm/20240112091128.3868059-1-foxywang@tencent=
.com/
>
> Yi Wang (3):
>   KVM: setup empty irq routing when create vm
>   KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
>   KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
>
>  arch/s390/kvm/kvm-s390.c |  9 +--------
>  arch/x86/kvm/irq.h       |  1 -
>  arch/x86/kvm/irq_comm.c  |  5 -----
>  arch/x86/kvm/x86.c       |  3 ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/irqchip.c       | 19 +++++++++++++++++++
>  virt/kvm/kvm_main.c      |  4 ++++
>  7 files changed, 25 insertions(+), 17 deletions(-)
>
> --
> 2.39.3
>


--=20
---
Best wishes
Yi Wang

