Return-Path: <kvm+bounces-20806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F89A91E6F0
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 19:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8207D1C217BB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 17:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A1916EB77;
	Mon,  1 Jul 2024 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WTvT9dmr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2619E16EB6A
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719856345; cv=none; b=FV7I6+9CcCYNvoCHKDbw+ed5y4V06vpfbOVIXGhKgg/UI8QPHviTDQ5dY4LjkhnsVXeKS8Ez7a3VtZkD5Mwq7ufNlTFPc7yUPt0G0Q7Larp5lJS/jwznqgLXAExhYfjNvX/mqeXSRrSxT9x31vpE1thOsMN4+niXqXJKAfHcuSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719856345; c=relaxed/simple;
	bh=wS5TzTy89GmwCCZj/N1TGJuuGTXmLGauqI7XlpF5kjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CHGY1r+5y7J31UQIA9m6mUabFhanzqnl4dzC1lW9LVQr+MkDu+WRTyptWcw2i7br3P+MfeCu4upXF7Q5X1/fTJb4udmTy5KLdXsITvV9mzcR+yyqx3SHe8p4dsBUt9uawgIu8EjmHaNzSb0fgc/Fllucwug8VGDQ4Vyk4I7X4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WTvT9dmr; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4256aee6e4dso24540935e9.1
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2024 10:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719856341; x=1720461141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1/3Mqv5bU7Lm+/6Z/xl/QjEG/rO3YJRZuHHrfT9XMs=;
        b=WTvT9dmrvcmBm8nBE/hEMNsIqrZayfbwUgMuXtbwImfiQUJ5RBqMXz99ViJMmHYszh
         DUd12PAX7gw4DoAvz5MwabVG8QDK/LLFbnsxN/7XHjxqenhyGljWkUISKLHVdQ4kQYrj
         F07JZyWBS3rzs6VNrlVO1Z3CdkY0usemnNXmZfgHzk0k99rSYK3qzMK/DWHUorvA8mhq
         udMAjN+6ojxNgzYVRPkCmpS3gfMLX9DB2F8HKAAMIipEydQpYvbBioD2WIcgkYbUyZ05
         L56wigN12DHB+NgePqqadEVFnShA6+TdDieavq517bzSaW2Gbim76J3S6pb/IYVcg7gW
         H9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719856341; x=1720461141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1/3Mqv5bU7Lm+/6Z/xl/QjEG/rO3YJRZuHHrfT9XMs=;
        b=ePLkhLMFWSSpBCrU6Y15H3chLIp2Co/3jitqTpJKt0JVSvGStiAV9whLmUSRiOg4Ok
         J2hCXiXQ1Fpgfifw9AwN0+aTBVeh/2G9weh/ACXqs7kxHtUKdJflNXU6gyuwaPSV1zDG
         fzxEdQZu5QZuvkdHUhJodP9Crc577DXFpbYrsl0SA+I5B6+Z3lnoLeS2i3WO2gE9CYIL
         wVUU+t/h6mSB5EK/snT+SW2owFbwAVcM6fH7XyWm9RTu0ti4xlekyN0Yr7BwSwRJ+JIj
         tOZkS43eI5zoNPVXQPSTLYjNfO53rulnGRxY/JFHgRUPBH5MzY5741KTOi8oX9mtkY/I
         GFUw==
X-Forwarded-Encrypted: i=1; AJvYcCVGwVCVdWHNVV+dBAaAIdR1nQXZd9VJqcXqT13JWbybHxy9LcxbMG0zNwk6jyR14BE+LavFBslABk4O0T66hkhkfUbN
X-Gm-Message-State: AOJu0YzUfZVxizPMBZ9vaAjaJ3gmvKSrtWxoxB/sHEcEZxVnkjUiPqM4
	YhJ3Pp6K7WFrJvQE1RrdtCN+0cy4odPKJfQdu6JMJJQTJHVdk+wg7oAFuoaLQ3Hj0buN1AaiCwc
	Jp8V3QAr6HzHVaZzWG91Hpzyjpi9+1EQkBEwO
X-Google-Smtp-Source: AGHT+IG7kANdMixnrRX/w/wCL06WRJILCv9aR81l3eU1ucu2os0oVGFSDzYlK6U+a1azCoA3WAsnnYnMeJC+/F+ecm0=
X-Received: by 2002:a5d:49cc:0:b0:366:eade:bfbb with SMTP id
 ffacd0b85a97d-367757200admr5266366f8f.46.1719856341379; Mon, 01 Jul 2024
 10:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com> <171874683295.1901599.10170158200177384059.b4-ty@google.com>
In-Reply-To: <171874683295.1901599.10170158200177384059.b4-ty@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 1 Jul 2024 10:51:53 -0700
Message-ID: <CALzav=cwu3M2nLHwZLCTF=eGWx2Nq+=TuHMuGTfZCNa27mLs1A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Set vcpu->preempted/ready iff scheduled out
 while running
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 2:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, 03 May 2024 11:17:31 -0700, David Matlack wrote:
> > This series changes KVM to mark a vCPU as preempted/ready if-and-only-i=
f
> > it's scheduled out while running. i.e. Do not mark a vCPU
> > preempted/ready if it's scheduled out during a non-KVM_RUN ioctl() or
> > when userspace is doing KVM_RUN with immediate_exit=3Dtrue.
> >
> > This is a logical extension of commit 54aa83c90198 ("KVM: x86: do not
> > set st->preempted when going back to user space"), which  stopped
> > marking a vCPU as preempted when returning to userspace. But if userspa=
ce
> > invokes a KVM vCPU ioctl() that gets preempted, the vCPU will be marked
> > preempted/ready. This is arguably incorrect behavior since the vCPU was
> > not actually preempted while the guest was running, it was preempted
> > while doing something on behalf of userspace.
> >
> > [...]
>
> Applied to kvm-x86 generic, with minor changelog tweaks (me thinks you've=
 been
> away from upstream too long ;-) ).  Thanks!

Thanks for the cleanups. Looks like you replaced "[Tt]his commit"
throughout. Anything else (so I can avoid the same mistakes in the
future)?

>
> [1/3] KVM: Introduce vcpu->wants_to_run
>       https://github.com/kvm-x86/linux/commit/a6816314af57
> [2/3] KVM: Ensure new code that references immediate_exit gets extra scru=
tiny
>       https://github.com/kvm-x86/linux/commit/4b23e0c199b2
> [3/3] KVM: Mark a vCPU as preempted/ready iff it's scheduled out while ru=
nning
>       https://github.com/kvm-x86/linux/commit/118964562969
>
> --
> https://github.com/kvm-x86/linux/tree/next

