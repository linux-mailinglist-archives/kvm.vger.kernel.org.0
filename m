Return-Path: <kvm+bounces-46192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B65EAB3E9D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 19:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CDB616CEAB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B2F29550B;
	Mon, 12 May 2025 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o9E+Ah+B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFBA2185BC
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747069539; cv=none; b=udt/GFj4zn5iBCuaevBmTwbMud0kIh1lfI0luasfA7BUebORKlMgZZdrixpjgcpRC/zIdG9nvgeYRly6UvV0pri7ii+MnHvlT6tpTHvu0nDgN4SPpL27TEXx6kDe87/Ah2nTZUZmzZlN/OdnC5GCUnnqRJ8+s8ddUXS+SJOp2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747069539; c=relaxed/simple;
	bh=8HTNP+Dz9uUBMvSkat76DOjyJL5YwhYIaJa66H/oiLI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kG8JjyepHMEjpV6bYmaI26N7G2M31Wr9mcYumJXyuBI51BvgRpk5wnmqI/EdvEJtT6BUkhP7SW11F5sphw0ebdqV4zlgHc6i+Lk2NhEQ5jD0Can1s/PNAe2WSX+tht45FyTeWDNp/Wzn3QRC2FQznTGRF2Xn05GHCMj9WRetxnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o9E+Ah+B; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70a2d8a8396so37813217b3.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 10:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747069536; x=1747674336; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8HTNP+Dz9uUBMvSkat76DOjyJL5YwhYIaJa66H/oiLI=;
        b=o9E+Ah+B2hEnC0I1PKX7hCG+V0RGXxY8kF/yX4pM/xoiEcQNz0zH0qTUkx5W6j9cNX
         S71UYpI+dNpkPevAXKY4mTAK2QA9OSXPtXBthbeGjXuxFi4RDnSP9Gup6NvIyML6pHmE
         F869dyb+BaIf3whGAmrrI2ARrze9FDS2r+mEf/xcX9PMAHd54MH3EYpggPXS38Qi3cYD
         1+xbc56AgtIKVrsWoPIazniL71POVMvsWmK2/S25uTyobQGYqy8EOBm2EBGskBBrurF5
         qinU6hhntGgiKQSiD8RukBu5rSvBKSbDwERaHgdbTNhCk3D9Fo7zj0PUctqZgebjJNV1
         DtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747069536; x=1747674336;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HTNP+Dz9uUBMvSkat76DOjyJL5YwhYIaJa66H/oiLI=;
        b=oJK30J115VLlxYbFQ/DO3zhT6SJAeB67PPetD+vr53EUiUVy9G7l9wBpxnrx4a3nAa
         /TlZ648XrXm9EBjKAnJXp2KbCiWf/aEiShqLP35Lo5rOB3WdkqYhYDiQ2F/Evr+sw9zL
         L7x5CU8LNl+4CIR5toTeuoiip3Hg+vyrTzHOEa6efofWt9/GecnPtRjZgBdXz/nRhqZl
         5AYHk7lAsHHTMb/gbVtypjktxfEt23CP5pSuEwqTZ77W3j67muU0crIaBW+482/wpBJJ
         lpaCoYvSt1IhiU2RsCYfdkAhfd0vSYPTPuZnQyUAC27o8B873N42hkndMhDPSwRLejQM
         xbhA==
X-Forwarded-Encrypted: i=1; AJvYcCVzFWdwMv7FKFb9fEbrC2ls4QF5VSKgf9hCJkb1vmi7SRw0A4avq8OKHRdPM8VhieKD0kY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgGcrYpJ+Y6SvJ+ek5owby/UncCLP2Dki0cQnVnI/YpfWUpShM
	JulOHZK3cFIpINTkIW0Pq+jXRcWbJCOMoul6aI7I3Nbb1rOT20Az98axCC+J0wqR5vKiCR7EH3e
	DiAAjGIO8dvE8e6y0E0/gdGW6pyeLYS8Tw8dkeg==
X-Gm-Gg: ASbGnct1rDDr4A1J7nsPV+0vMfGrKzRT09nJlWMZdTb0sXOjtNXd6zwrbDXvwmSXo1Z
	g/mCF1jSRLJTm7SqBY3WKVrjvxK3qmFxmA52q4jPCI19x+h6eCZWKNFGlLrVeAFhUjMSgmKu2ld
	xLMb7x/5k74iFyc+GPkr8lRl7jc2XIVmZqvA==
X-Google-Smtp-Source: AGHT+IHJUGXvU7eSQD629soUCAbI1o1OOEKe//YGeeBupCFFNme9TLnTnur0ZOEMcwQ6PGCg+MVCB1198KhwGVBMoSE=
X-Received: by 2002:a05:690c:6181:b0:709:966c:b648 with SMTP id
 00721157ae682-70a3fa1fb5bmr187347917b3.10.1747069536192; Mon, 12 May 2025
 10:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
 <CAFEAcA_NgJw=eu+M5WJty0gsq240b8gK3-ZcJ1znwYZz5WC=wA@mail.gmail.com> <726ecb14-fa2e-4692-93a2-5e6cc277c0c2@linaro.org>
In-Reply-To: <726ecb14-fa2e-4692-93a2-5e6cc277c0c2@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 12 May 2025 18:05:25 +0100
X-Gm-Features: AX0GCFvvctnEj9SSRF9WiDdOiktBdw5JBrK0houKTahMILYX6RROtZ1LUTlNoCA
Message-ID: <CAFEAcA_WtAAba9QBS_zOPUPtjdeDv+0mDJiTEepHS2+61aZERA@mail.gmail.com>
Subject: Re: [PATCH v7 00/49] single-binary: compile target/arm twice
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, anjo@rev.ng, 
	Richard Henderson <richard.henderson@linaro.org>, alex.bennee@linaro.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 May 2025 at 17:53, Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> Hi Peter,
>
> On 5/11/25 6:40 AM, Peter Maydell wrote:
> > On Thu, 8 May 2025 at 00:42, Pierrick Bouvier
> > <pierrick.bouvier@linaro.org> wrote:
> >>
> >> More work toward single-binary.
> >>
> >> Some files have external dependencies for the single-binary:
> >> - target/arm/gdbstub.c: gdbhelpers
> >> - target/arm/arm-qmp-cmds.c: qapi
> >> - target/arm/tcg/translate*: need deep cleanup in include/tcg
> >> - target/arm/tcg/cpu*: need TargetInfo implemented for arm/aarch64
> >> - target/arm/tcg/*-helper*: need deeper split between aarch64 and arm code
> >> They will not be ported in this series.
> >>
> >> Built on {linux, windows, macos} x {x86_64, aarch64}
> >> Fully tested on linux x {x86_64, aarch64}
> >>
> >> Series is now tested and fully reviewed. Thanks for pulling it.
> >
> > Do you/Philippe have a plan for how you want this to go into
> > the tree? I know Philippe has been taking a lot of the
> > single-binary related patches. Let me know if you want me
> > to pick it up via target-arm.
> >
>
> During the release code freeze, we mostly used tcg-next.
> However, now everything is back to normal, we simply work upstream, with
> a simple "first pulled, first in" strategy, fixing the occasional
> conflicts on our respective sides.
>
> So if you could pull this, that would be appreciated.

I had a go, but it seems to depend on some other patch
or series that isn't in upstream git yet. Specifically,
the changes to include/system/hvf.h assume it has an
include of "cpu.h": you can see it in the context in
patch 2:
https://lore.kernel.org/qemu-devel/20250507234241.957746-3-pierrick.bouvier@linaro.org/
but that include isn't there in upstream git yet, so the
patches touching that file eventually fail to apply cleanly.
I assume that's "accel/hvf: Include missing 'hw/core/cpu.h' header",
but is there anything else this series was based on?

thanks
-- PMM

