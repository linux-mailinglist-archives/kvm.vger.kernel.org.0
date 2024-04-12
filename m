Return-Path: <kvm+bounces-14372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D65B88A240E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 04:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59AA0B2454F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 02:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F3517BCE;
	Fri, 12 Apr 2024 02:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhUQf+B5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5C6175AB
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 02:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712890696; cv=none; b=OMIesk7VaL8eESeKfaxmsa+rg6V51fdsagg4JfB3ae+BSDYiBsDMYSeDHy1CdL1w1txobmg1P3I5bbsDHClyiV0EOOop4qNM6buhVnvzkoanjyijaRqxzgb8rSC18XG5G0Vex8nO/33iRTrsCMMwWwSIrw3gv+uIN2nsIZvGjXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712890696; c=relaxed/simple;
	bh=3CxaFDOCXmJ4jSKLNZ5qxIhMH7cfxfMjix9ZriuuATk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VCUZmYfBkEEjjIMiQzMjwDZjubHzGknX5mSPMpqn1QEPGLGMZrIdTw6I13dFKBFMG2T+n4MLLXBdpzLa+RDbvfmWF0V9OlZruXjsmnkmNBfUGrUru4EtWB3B2cuj1SDv4ZmF/xgiuVy3SXO+FPkuin59aAG6PkYpkZriRi0qRqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhUQf+B5; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56e2e851794so4008a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712890693; x=1713495493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXfRbf/zJHU/DOTCa3Xemga7PSGX/nUeez1rccsZ9ws=;
        b=QhUQf+B5zOrvzWnQgYdeymjPtd9za1jeBfBXW6lN11WYIw8wcLjNVWonUh7pJ1Uxwv
         vcLGGT0kipBvhVCXs+7gst/k/IjR6XYdW0yEJm8jlRjDW9CXA53FbQQM57TKwkl0YAce
         j6hjVBIPSdGA4r0kZzH8F1G3DG3LsD6M5L+LG8uu8c1EuWNMVP1d2/wdeSlVZt1iHkIa
         wAor3RKB9UPLcu+ecN+BnmVUtMe7wvwCHIIEfRLNZeB+goSthepDIDtuzUlj6XZPH81N
         sv1UQ7wBNQCdrBnxGZW2pmjxZDG2SoreBErN4azr4dhXUhq9ww8D5bRYaQNBptEWYExE
         9PXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712890693; x=1713495493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXfRbf/zJHU/DOTCa3Xemga7PSGX/nUeez1rccsZ9ws=;
        b=jjFkNR0L/grvFC7Lj41zDGkpdGtSywa3BGVUa6IiXUWXha6XWV8z8gsdXBOs9X7/G2
         cZ7ATxhU0vu9roTUjxTZ2eqNqDXurHHYQBjilDQhkt7vxXxZ6bZU6BGIj7uaO70lc8P6
         lPIv42vcX8NQ6bqQ7sJtbItAoKreqhcBmbIRXf1WnZ2Ayk3jDDmvOfj/KzNXxfua8Plc
         Cs3xDmfzR7aeMsL6a+Vkgw/VgP41G01f0ZnDgLro8NXV0bSW6vsJ5+uKeGphQsM0vpgo
         cKXw61z2q7ADltyVt5A79jiuOeWBaSh9T/6QN+6dcy/xlnseawkQuLt03Suwk248m4KD
         Y9lw==
X-Gm-Message-State: AOJu0Yz5Y021WRLMA0oSX2jqKJFrk5x5dA6OrbM5HUxE540pugckxWDv
	yHVWkGUth9p+NMDcrbQ+tv8p1vGhVmXHq3d3hRb5GQobSZIb+WH8uHxBFCXIYQob9m5bMR9m7uR
	pl4Om1511AHOEW8PjOJyE+/yFZBFtwaw5Ie9Z
X-Google-Smtp-Source: AGHT+IFQor4Atwei9ocgDDKCRca8PGd2W5wGs7CB32E/FWVX0h83vesueXCnL8aiD94NlKLsigz+oXYNNSGWUQ8UBME=
X-Received: by 2002:aa7:d6d0:0:b0:56e:85ba:cab0 with SMTP id
 x16-20020aa7d6d0000000b0056e85bacab0mr43584edr.7.1712890692423; Thu, 11 Apr
 2024 19:58:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com> <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
In-Reply-To: <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 11 Apr 2024 19:57:58 -0700
Message-ID: <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
To: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 6:32=E2=80=AFPM Venkatesh Srinivas
<venkateshs@chromium.org> wrote:
>
> On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> >
> > From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > enumerates support for indirect branch restricted speculation (IBRS)
> > and the indirect branch predictor barrier (IBPB)." Further, from [2],
> > "Software that executed before the IBPB command cannot control the
> > predicted targets of indirect branches (4) executed after the command
> > on the same logical processor," where footnote 4 reads, "Note that
> > indirect branches include near call indirect, near jump indirect and
> > near return instructions. Because it includes near returns, it follows
> > that **RSB entries created before an IBPB command cannot control the
> > predicted targets of returns executed after the command on the same
> > logical processor.**" [emphasis mine]
> >
> > On the other hand, AMD's "IBPB may not prevent return branch
> > predictions from being specified by pre-IBPB branch targets" [3].
> >
> > Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AMD
> > CPUs that implement the weaker version of IBPB, it is incorrect to
> > infer from this and X86_FEATURE_IBRS that the CPU supports the
> > stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):EDX[26]=
.
>
> AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RET] =3D=
 1.
> Spot checking, Zen4 sets that bit; and the bulletin doesn't apply there.

So, with a definition of X86_FEATURE_AMD_IBPB_RET, this could be:

       if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
boot_cpu_has(X86_FEATURE_IBRS))
               kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);

And, in the other direction,

    if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
        kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);

But, perhaps all of this cross-vendor equivalence logic belongs in user spa=
ce.

> (Also checking - IA32_SPEC_CTRL and IA32_PRED_CMD are both still
> available; is there anything in KVM that keys off just X86_FEATURE_SPEC_C=
TRL?
> I'm not seeing it...)

I hope not. It looks like all of the guest_cpuid checks for SPEC_CTRL
also check for the AMD bits (e.g. guest_has_spec_ctrl_msr()).

