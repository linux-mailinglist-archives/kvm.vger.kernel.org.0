Return-Path: <kvm+bounces-24404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 367EB954FC9
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4194B24D8A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFB61C2334;
	Fri, 16 Aug 2024 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sGqmNSV4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899E1C688E
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723828368; cv=none; b=CnHvGxGo0FEOdByFNcn6Paeho1Jfdc9m01iS2fQoPz9WtBuBu+4SqcMcAub6ZfEFevlT70Ss5bQ3RJ7yrjpTgATaInSdhwx6hrwVvgLApZP0TR/DTujWlNugN969uXVDVL6Nn/zS+8BrG/aqwNIhXbVMNFFTTLTfsSIAA8LOks4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723828368; c=relaxed/simple;
	bh=8z33o3F5Y6XeaQhLnECYNElCo/2fUd1REfXyOLDd7CQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jF31cN/F1q+CMCj4UYRBsrYta4fP8J3TC/6ITQYK9dWcLXCpdIUVwTEQh4MIvOfOP8fPY66Q/2sPW7vjz8en5bBIBb+7d0uMHA1x2PZ/97iB+fmpyfOd2XNN0TaBsK+7jK7/jy+0QtSClvoeexghyikEULGDfDhrT9vMBZEoyZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sGqmNSV4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-202018541afso2895ad.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723828366; x=1724433166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ir6eje0jsCYBssOPZnnxPt2Wh12Vi3qWaY8S8o8nHcs=;
        b=sGqmNSV48q0LpgbbBw9TiIg3kfQY1t2C542bRsKSfY9rO8Pq3uWbBfkGOHSjI1Vpsk
         oPxO0LfcaU828FTPszjiuXbrGYG51pfUG6+8nSR/NCnYTHDlzYNbQOjPplwdUpX+wXO0
         WWk9belXWH9gk8VjTncKOAQ46slCQwFRFU3hqfYzccYH+B+l1TqLAl3ADJRZMC5/rpNx
         Dl5bzxypqF4keorZVkgwCn0CiyHNPd1DP2KXzXLQKM+4P3RCb9c1xRyP+vCs+uAs3b4x
         L0vX3sbotrUk+Dn/giuYrwSs+27ukDEzk4JvN+zMxAmCSJXTVHuaItuQxhP/f5pr0zSc
         82Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723828366; x=1724433166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ir6eje0jsCYBssOPZnnxPt2Wh12Vi3qWaY8S8o8nHcs=;
        b=ZtGxnRz7UYs5Ma4pzgt2/Ob1V5Wbd3Hi97wyWD/bhml4KzRQSDQAoMYSQ6EChXus7c
         J/V1SQtx879Vk+/SuSzL5Lx5Mlj0ZEcK/M5hN7UrY9JFFlwN7fQBlvYoiWafElXFzsjm
         SncvHZsU9bTXDcVWk76HR3UoFns6FOzQ35vSc5C7XxCO8H8q2i3aqMP00ntn2UA8iaeG
         pVLyM1zMbtaACpr7zy7IqO+0/RJclTZGXa0kwU318vYY5bxAVGlgV4heNIVeBkfVhkQZ
         8p/Q/9Um0Tq1mRy8HsDz827uGpoKb0UrrRS+Iy1OMqjJ+88hwiTyfzfJ0tuH4c46ShRY
         jVrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGGVg4FSJpEek5s3hgIGGRuy02GkL177KRce16Brq/uetiuTeu4CBWbr8mnSscmhWqaKUoP5JMmRz9Hc7laNk+mlXV
X-Gm-Message-State: AOJu0YyeaPKx3bSaOr9LuzSwybwHVq2o/PwFWvgQ/YZZ2m9/S2xdRHCH
	bnKjM57jjdbybmcw9e+LjqWVB0A+i1/5SPnwu0sPoeRn19w6X21EhZvhhnfXRYN4lGEdCg8XDQ2
	4HUt1eKncwhJ2DoCOj3260mA7aj8JE+UTdYbA
X-Google-Smtp-Source: AGHT+IHn0Dx6FjiBWoYRgVRCwgmtYmi1lpJaCbjb8ziezHcF/ZqJH7pFFHyjhk+CaHGHZLn/Hp6C3MURr2OKOa9OxGk=
X-Received: by 2002:a17:902:ecca:b0:201:e646:4ca with SMTP id
 d9443c01a7336-20206010631mr1616355ad.14.1723828365805; Fri, 16 Aug 2024
 10:12:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com> <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
 <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com> <Zr9hRydHFvPIMfUp@google.com>
In-Reply-To: <Zr9hRydHFvPIMfUp@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 16 Aug 2024 10:12:34 -0700
Message-ID: <CALMp9eQ9k+SicmeEFvvyBrJH39HJa-=wP9cMhRRGy21+6ihEew@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
To: Sean Christopherson <seanjc@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 7:25=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Apr 11, 2024, Jim Mattson wrote:
> > On Thu, Apr 11, 2024 at 6:32=E2=80=AFPM Venkatesh Srinivas
> > <venkateshs@chromium.org> wrote:
> > >
> > > On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@google.=
com> wrote:
> > > >
> > > > From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > > > enumerates support for indirect branch restricted speculation (IBRS=
)
> > > > and the indirect branch predictor barrier (IBPB)." Further, from [2=
],
> > > > "Software that executed before the IBPB command cannot control the
> > > > predicted targets of indirect branches (4) executed after the comma=
nd
> > > > on the same logical processor," where footnote 4 reads, "Note that
> > > > indirect branches include near call indirect, near jump indirect an=
d
> > > > near return instructions. Because it includes near returns, it foll=
ows
> > > > that **RSB entries created before an IBPB command cannot control th=
e
> > > > predicted targets of returns executed after the command on the same
> > > > logical processor.**" [emphasis mine]
> > > >
> > > > On the other hand, AMD's "IBPB may not prevent return branch
> > > > predictions from being specified by pre-IBPB branch targets" [3].
> > > >
> > > > Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AM=
D
> > > > CPUs that implement the weaker version of IBPB, it is incorrect to
> > > > infer from this and X86_FEATURE_IBRS that the CPU supports the
> > > > stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):EDX=
[26].
> > >
> > > AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RET]=
 =3D 1.
> > > Spot checking, Zen4 sets that bit; and the bulletin doesn't apply the=
re.
> >
> > So, with a definition of X86_FEATURE_AMD_IBPB_RET, this could be:
> >
> >        if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> > boot_cpu_has(X86_FEATURE_IBRS))
> >                kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
> >
> > And, in the other direction,
> >
> >     if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> >         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
>
> Jim, are you planning on sending a v2 with Venkatesh's suggested solution=
?

I really like the idea of moving all of the cross-vendor capability
settings into userspace, but if we want to keep this in the kernel,
then I'll send V2.

