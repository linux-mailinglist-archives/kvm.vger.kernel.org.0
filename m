Return-Path: <kvm+bounces-2657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D767FC0F3
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 19:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 615731C20EF2
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 18:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3436341C9A;
	Tue, 28 Nov 2023 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EFDaRbTO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6633ADC
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 10:01:27 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c1f17f0198so5047352a12.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 10:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701194487; x=1701799287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eLq05PNDVda9aScY/SisztbkXwqXqd3sYjTGw5PUJeI=;
        b=EFDaRbTODs3BrLwQvjzLNpQxJURlV70rN4ctLh/5vrYOgTcW20BBhtPEHzoxVPzZtB
         tJ8Nj4QGZoqT0v2D+pNr0GbnzcilrX0TLY6wFgm0HuMYK4TZp5E2bmYfzp6MiycbtZMD
         z6smNynd+a1HNprx8/XMHmqAiDwxJ6y5w0YQ/xRY9BkYN05qg4JdFUCJ7K45NdgylMSC
         8JjDR403Gd6pBeLRjNHFc2JUk3WEs7Blni3P1BvWjneSrJKxS2wRk/CpIgCKavc+MCTX
         1gXOOxIj7RV4Va3fPGirpnH8O2T1wi603kCsBHtNAwQ9NpuUgbdLcIY3kCM8TiLgkkB9
         OVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701194487; x=1701799287;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eLq05PNDVda9aScY/SisztbkXwqXqd3sYjTGw5PUJeI=;
        b=wjAdwHoW0Z6kCbs/0/W4jcafVvcfjK83ckqsV/fEvDYKUhKVQnkVoueaSEpm8KwJL7
         HakNGtVB8wmE1WzJy+HdEeT14OcI/LaovuuJ0KO5esHqM7aVhGgRR3dDYTJaJnCLS3Ei
         VlY86WSinawijhSim9C2jQNfEJ2HFuvHl/U4UJ+q/MbSxywqvbiehzJ8/o4+suQ01qyv
         0WALXfbIPq/Siua7xldRaGu/GMq+dJELp765CBvbzSS08w451/v2y3OeDWAxGzUJMDec
         TBrcEIoVGXe+hDJW1Hd9cvUORL31ZnRoowr6dmcxnS+R+ScIM4UXHtyY0EmKdu2S26EX
         1Ddg==
X-Gm-Message-State: AOJu0YxPSmsaNyGqvMjHwgUdB0yoL08ncofmu3QmM2HzJA5kA2wIkb/+
	tj3qdx9+sCuhsBw5bgMkTDOABkhX8Jg=
X-Google-Smtp-Source: AGHT+IFNpNFIXlxB0zt8OdAQTgvseJ7SAZR+7oHRbWOjuUMCt1O25ZyuOpH9EBjJdRLzVlyQWSuhW+kqEvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4a:0:b0:5bd:bf7a:d167 with SMTP id
 71-20020a63004a000000b005bdbf7ad167mr2483762pga.9.1701194486901; Tue, 28 Nov
 2023 10:01:26 -0800 (PST)
Date: Tue, 28 Nov 2023 10:01:25 -0800
In-Reply-To: <CAJhGHyAiYxyiC+oepgqHofBpKVXLyqOUS=PjXppesx4AS3++-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com> <20231107202002.667900-10-aghulati@google.com>
 <CAJhGHyAiYxyiC+oepgqHofBpKVXLyqOUS=PjXppesx4AS3++-w@mail.gmail.com>
Message-ID: <ZWYq9W3D8JCAPoc8@google.com>
Subject: Re: [RFC PATCH 09/14] KVM: x86: Move shared KVM state into VAC
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Anish Ghulati <aghulati@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	hpa@zytor.com, Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, 
	paulmck@kernel.org, Mark Rutland <mark.rutland@arm.com>, 
	Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 17, 2023, Lai Jiangshan wrote:
> On Wed, Nov 8, 2023 at 4:21=E2=80=AFAM Anish Ghulati <aghulati@google.com=
> wrote:
> >
> > From: Venkatesh Srinivas <venkateshs@chromium.org>
> >
> > Move kcpu_kick_mask and vm_running_vcpu* from arch neutral KVM code int=
o
> > VAC.
>=20
> Hello, Venkatesh, Anish
>=20
> IMO, the allocation code for cpu_kick_mask has to be moved too.

I'm pretty sure this patch should be dropped.  I can't think of any reason =
why
cpu_kick_mask needs to be in VAC, and kvm_running_vcpu definitely needs to =
be
per-KVM.

