Return-Path: <kvm+bounces-11943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E9687D69F
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F389E1C2145A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 22:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E974059B5C;
	Fri, 15 Mar 2024 22:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJoRpAcH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D44058233
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 22:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710541731; cv=none; b=QItMfjewcqqT3JJXPz6NPkfhupWTa1mg5p39URzFYl/eAQ9FgOr/noBwJFffAD8yI0ayC62gEu/hnKST3PUDbG6CAg2RiNvNOfa+pIl5EAhraONrEcF89ZDibQvajdnl4bGhgM9hRtry2c+PiqmSuex2LaNeW/spfPRkyfX5ZbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710541731; c=relaxed/simple;
	bh=p6YA2ZEKShNxBk5y1IkrSjEYXZxVmLi9Hpcct3E+Pps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bPrv36P49XY6XDt/soTjaVXKBX4OZaGpSuLv3SZZAggCTkncW5KGLv8iiLP8NRVRkncfYpSDFvPpKJaaGEnT5vpvNt85adt8BwSJjDDw2MYHC0QjBM/pGyokdvsYmhDGZLrwjCoT6w7ktcaTEpw74O4B/88Dws46Slwg/ExIFR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJoRpAcH; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-513d23be0b6so2524665e87.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 15:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710541727; x=1711146527; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7YUeFqqtIuPT4RgHb/ci6iuEBarWfDLjpf3yXBTu85U=;
        b=cJoRpAcHudTQm7fiGXz2ccygWmzRWr/86/OcNeS766aLwlDLWBtu0JWikgqeOPCAta
         Q5Szlwiu5ms8SbcBde0nsq3FPEZsbOzxKmd4+AEZudOLGBMtqDT4TuPmitkvkaIXxx26
         mY9vz1GeoboyZYLfY2fvwU+HEVXCn5GWoQl+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710541727; x=1711146527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7YUeFqqtIuPT4RgHb/ci6iuEBarWfDLjpf3yXBTu85U=;
        b=jXyVcOUhP3a6Rmmyns2KQ/MVTv7F71+xhLt4wyyTPuWcx0VMzwdqgMUvpsqN+d5y7K
         okjU964c5BdQ3O+vCehS7X6omlYWX6onvgDBy/4j2qXQtQlwKFKIdvURGFT4Q4dfdTid
         OyvTh9+46woKplJwfLz8he05S+FreuMPKOGRVjcgIVVvN4xbX2iz+lj2deSiCYkn0VmX
         s4MWDRF95xHaeKRruJ62hEY2Ae8/uXlfkldVK74jEJQYC4sjtOmxEYMWFGzEGm5sAW1b
         JoDUavT7vzCPs6H4i0hlqmXQpdcOPXdrtQUJmNCgRWYMtj+uT4kcRuFE+ZY64pFdNadM
         D6QA==
X-Forwarded-Encrypted: i=1; AJvYcCXTSBLDJGKdOx5R7nKlA3WSoe3rsB2HniSoBc4sc5DdLrqzhPOrGYrQ1Ao6C/doGrX4LwfTuKtQWpIUEEb+vTk0Z17c
X-Gm-Message-State: AOJu0Yz2GD/QvxNJ0Q20z09v56pSYjX/xyJBuz8E2oG9opqLstitPFCv
	myqy4R6ULuMirH4x/l4VOOeos67Mu1Pc+d5MZ6i1dxOFluCa/OSGMw/TbZIBB2Wv1x7x+a4mFlD
	hhtqXVg==
X-Google-Smtp-Source: AGHT+IHAHdfLYZ66N2Q8DqY2xicmWaTj7FhSwzsp25+qsKjXzI09cNXZlZdb+Vhk/YB9T7AZlckgUg==
X-Received: by 2002:a19:5e53:0:b0:513:5ec6:348b with SMTP id z19-20020a195e53000000b005135ec6348bmr4265965lfi.6.1710541727303;
        Fri, 15 Mar 2024 15:28:47 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id u15-20020a05651220cf00b00513c54ba806sm770819lfr.96.2024.03.15.15.28.45
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 15:28:45 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-513d4559fb4so2759151e87.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 15:28:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWC8syqKxX1UoFby7gW0JB1Jna4n5yz8n766d0d5ZvlQSQ/lwKfJ048q09EwGlAVVtZTu95e5455vn0qgyPTUUMM7Ve
X-Received: by 2002:a05:6512:3293:b0:513:ba0c:cb6 with SMTP id
 p19-20020a056512329300b00513ba0c0cb6mr3803414lfe.2.1710541725253; Fri, 15 Mar
 2024 15:28:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315174939.2530483-1-pbonzini@redhat.com>
In-Reply-To: <20240315174939.2530483-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Mar 2024 15:28:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
Message-ID: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 15 Mar 2024 at 10:49, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

Argh.

This causes my arm64 build to fail, but since I don't do that between
every pull, I didn't notice until after I had already pushed things
out.

I get a failure on arch/arm64/kvm/check-res-bits.h (line 60):

        BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0       != (GENMASK_ULL(63, 0)));

and at least in my build, the generated sysreg-defs.h file has

 #define ID_AA64DFR1_EL1_RES0 (UL(0))

so yeah, it most definitely doesn't match that GENMASK_ULL(63, 0).

I did *not* go delve into how arch/arm64/tools/gen-sysreg.awk works. I
don't really do awk any more.

The immediate cause of the failure is commit b80b701d5a67 ("KVM:
arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later
checking") but I hope it worked at *some* point. I can't see how.

I would guess / assume that commit cfc680bb04c5 ("arm64: sysreg: Add
layout for ID_AA64MMFR4_EL1") is also involved, but having recoiled in
horror from the awk script, I really can't even begin to guess at what
is going on.

Bringing in other people who hopefully can sort this out.

                   Linus

