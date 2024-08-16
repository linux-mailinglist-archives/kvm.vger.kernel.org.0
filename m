Return-Path: <kvm+bounces-24394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D445F954C4E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 16:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 933F52828B3
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9F81BD03D;
	Fri, 16 Aug 2024 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UqepiSNE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78711BCA0E
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723818316; cv=none; b=mBd4dx2fZi9YlHuBAimVrYjvP/rABxHNtmd6C0L3WhhoeCm38y0VsTxtAjc3YKc++fcTThmL2GGiczIiy+CuhoiYcQ78I5azo/EdD/gZbF78Mw8H5CIUMxXGTTTc4nvM2TOTVxUT2zoio3lcXa6MC8XjFFieX1Z0zBeSZrQyi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723818316; c=relaxed/simple;
	bh=pQgwU3NbO3jD+NrUyzEISwoqYlpJSOXd4lLO8wLFpEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nPf+CYru7tMCpQW0TXQkjcfd17YJwfq2SjUrTzT3by876IDzodjHCsAd/UXlUN1Pk7LLtV5ffNCc0y7t3u8wU5HFj6D4qYTgJOJDiwH/14VMUsM8LUrNHNA1ZyR3YYdS27SCinnC3XKi4hB7cSkrVCNuKTRoKOMVhAIUyVZ1W70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UqepiSNE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6addeef41a2so37854667b3.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723818314; x=1724423114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+7Wk9OcwZMqzd5E5r+d5EdrzqKc0GN/xmYEHE1y96wE=;
        b=UqepiSNE0y3W+SeEExyOA5CFOXgRFrKF2HnVvNLz8VXZr5viVrVJ+tbs98BOMwBd1d
         zFQkdMrLGuBz3p7K9K/mAgjc6R69Fk+ULbC6/lI5K++AruMY8vGAqTl0RfcVTl084WrV
         Mxmy4GtXOq5/0azTh3agKcTbBDH+UDVclKUGZZW4RjsWoGwMJNl8RStEth+JP9AGO6xZ
         L6szkmy2tea8FbQCQEjKHKfqnIif2wiXxzfqCxAIOD/LJBi1hPGQQtYhBo/M8R/AYPho
         PIMgkBYjHvyE2ikQGNFkCY2+odAa/sQvSeQNTuEuucsRtW7FpSsQhCtoOdOiYrBUhjRF
         pu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723818314; x=1724423114;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+7Wk9OcwZMqzd5E5r+d5EdrzqKc0GN/xmYEHE1y96wE=;
        b=U7RCOLJpsdsCvmTtx2LAVDBYyi2w9HDK0Bh9R2JvM5VVhWMjg9IHa27Afhd7eNBK7Z
         p23MYZsfhwDIARPGUVFHZRh0FkJvAp//vSBkrJTxXOK+oCluArpLd4x43PNepWZ3tLOr
         2alfg/LGMqA5ES1ET/84lCqtr+1FZRgmid5HGChzFCPjyFHpr+I1QOOomZlMRryIU0bZ
         fPYD/iFfunLcrl2E0QcL6Fa4dYoUREtqG5gcazJHr7+rp+33/3G6x7BdxTd6CBeVH7sD
         /SufaAd+b9JwfCFKbVe6NbvrutUY9pfwKg084S5mdArpPVv65d4ruacrtVjSXBi8PyU7
         yz8w==
X-Forwarded-Encrypted: i=1; AJvYcCXseRcvyqAagREHjTpcO3chVxYX+F8biUVWdDPCYcHcJnc41Dx35JbCqNteTTF1R+CofytXSFJ6uxyJRrmnZ2i0WlvU
X-Gm-Message-State: AOJu0Ywqqh3/mQh4wLLqBZJ0EgeEkMW5NwxIQvH8BK8/iT0NIAWoW415
	nX6lLXXIvQE27Imx5j4cADhOYkMd5XcM8Ku8S3cDgCFfckwn7VXOw0FY2OxwkrsvJs+lKV38TT9
	abg==
X-Google-Smtp-Source: AGHT+IHSctE3hsbgibEX3NUUTSgxn3QNZgVHNZq+QwMDiVv5QgsBjUK7o0rfVlLVAL2MYAyhZ8nyqb8lfgI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:460b:b0:6b0:d571:3533 with SMTP id
 00721157ae682-6b1bbb4af15mr582527b3.7.1723818313542; Fri, 16 Aug 2024
 07:25:13 -0700 (PDT)
Date: Fri, 16 Aug 2024 07:25:11 -0700
In-Reply-To: <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com> <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
 <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com>
Message-ID: <Zr9hRydHFvPIMfUp@google.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024, Jim Mattson wrote:
> On Thu, Apr 11, 2024 at 6:32=E2=80=AFPM Venkatesh Srinivas
> <venkateshs@chromium.org> wrote:
> >
> > On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > >
> > > From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > > enumerates support for indirect branch restricted speculation (IBRS)
> > > and the indirect branch predictor barrier (IBPB)." Further, from [2],
> > > "Software that executed before the IBPB command cannot control the
> > > predicted targets of indirect branches (4) executed after the command
> > > on the same logical processor," where footnote 4 reads, "Note that
> > > indirect branches include near call indirect, near jump indirect and
> > > near return instructions. Because it includes near returns, it follow=
s
> > > that **RSB entries created before an IBPB command cannot control the
> > > predicted targets of returns executed after the command on the same
> > > logical processor.**" [emphasis mine]
> > >
> > > On the other hand, AMD's "IBPB may not prevent return branch
> > > predictions from being specified by pre-IBPB branch targets" [3].
> > >
> > > Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AMD
> > > CPUs that implement the weaker version of IBPB, it is incorrect to
> > > infer from this and X86_FEATURE_IBRS that the CPU supports the
> > > stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):EDX[2=
6].
> >
> > AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RET] =
=3D 1.
> > Spot checking, Zen4 sets that bit; and the bulletin doesn't apply there=
.
>=20
> So, with a definition of X86_FEATURE_AMD_IBPB_RET, this could be:
>=20
>        if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> boot_cpu_has(X86_FEATURE_IBRS))
>                kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>=20
> And, in the other direction,
>=20
>     if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
>         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);

Jim, are you planning on sending a v2 with Venkatesh's suggested solution?

