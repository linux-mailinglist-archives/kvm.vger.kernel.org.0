Return-Path: <kvm+bounces-58166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C747B8A9E9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EAA17E0D98
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFA731E0F2;
	Fri, 19 Sep 2025 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y6OBsktj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9606D26E16E
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 16:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758300174; cv=none; b=I6+Q3Wq2EXZ8YtzH5K2CBsvAip+mm9jSv4ENE0oWXRJh9jbfgTxtFyCs4uTonVFCff4UXqMK1Ziw4p3VRw+1CFcSajrpkiQHucM0NCBVLIh4QnbxoHHgaOR3FCqDlIh5jjNrJwhr9zmY1e1nJzFxuSNhVrFK8vMu1nyELspAgtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758300174; c=relaxed/simple;
	bh=9g2fIQ+OFpk7Lg3JarP2LvlyLe5rYR9EVzGRid9/yZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+u8jK3VkTY2iAe8QpwMszPRA0IE6eNr/yJTq10NIXYgKQCSpdjvknX6pXWxdmdQ/CQL7Uu1C0cI8A2u5TUjCRjtVTgGc6IukFiuvjhn1qHKtNmBqVsfMzex4inyQ82sWENbHjpEx80ZwzlIoRi/HE3YHDPjTUwy0JoLYSUGXxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y6OBsktj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329cb4c3f78so2024045a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 09:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758300172; x=1758904972; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3zgCKvyBzGE7zMZD/86Ru8E8ycbpLo3QTwgzItIYQkY=;
        b=y6OBsktjVCxrW67wt2jrtmQlM2pbBHOzLTdYLTNJgUyNm42TaHE9kQNbbDlLacFSVq
         TOsS+fMa96m8EdZIEq6sbPY7a7b8+uzLjtjQQ5rQVUZ2dElctJUJG+kiAhSPT5tJF3AT
         dFvVfPjbbFxKvOjaKXGy82YqtPAE8/8LtVrtfwljBKFWDZNqL6I5FAAxhFmvWVQtSTk0
         Wwkoa35OKJ5TwlMBw4m3vk2H5gUIra3nyLBA3FufpQUTb1slxtKYcRuYjaOkac+mvWcr
         SaHpz3rbrmWRZc54P/MMLUg4Em2ED5MeY1oU1ss33oEXO+D6kfpQv61WHyoTtKSBPbiL
         m/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758300172; x=1758904972;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3zgCKvyBzGE7zMZD/86Ru8E8ycbpLo3QTwgzItIYQkY=;
        b=nXoGKp4LGKZb0qfe9bvYag8kbXZxg0x5Bpfd9v9NFoprZ1D2U1oDwYJDrBg7MDIwz3
         kCB7OsteVzBffpsLVdNHbXn/9VXD8YixXof4jhUigzpxc/cq4jJhVroKwEnH2ok2rLQq
         aVS6munLMlIquT9YuQqpCeJgDme0lsjQU+QG/Pd+INZ3GNgiQMoVZsqJ8Ihf0aL9Zi+W
         9e97XjeH4S0lST3HJv4cEjWN3IQbK8n+VmVoasZOPGz37cgHVWtbSCBsUDy1lqwSefan
         4WcSu5wdFto5vRVikP0huxAUsWb1S+pKUKfrlJA+tL4x5jVijI140Dx1/RZg9EiDfOZz
         AL4A==
X-Forwarded-Encrypted: i=1; AJvYcCXh8FT+zEcmRN1o/BCHtJvtwhfxIhuNlRBdH5850L9YbIMhXz7lT8FwG1zOrqA9KAd2bGo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/buP0Xd1PrE/I953HAx/MVV+QgW/ReMxC2nYBLfsI661USxV5
	iXxpu1h68hO41p4IitbEMnnHYgo+G2HzsNVG8vyj3Iyc3exIq6yYt4NFspa8F0CxYY3aKuCaNxN
	5oK1KkQ==
X-Google-Smtp-Source: AGHT+IHXyf8VM+KPY7bCN9ynVvPY9Q3CFknMXWu4BowlO4hA1C/tN3u/8nQsk9be8dFfpYU9qo1o0XAdoSg=
X-Received: from pjbov14.prod.google.com ([2002:a17:90b:258e:b0:330:82c6:d413])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ccb:b0:32b:9750:10e4
 with SMTP id 98e67ed59e1d1-3309836e684mr4630409a91.27.1758300171553; Fri, 19
 Sep 2025 09:42:51 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:42:50 -0700
In-Reply-To: <aM1uzfweXxoaaLpt@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919004512.1359828-1-seanjc@google.com> <20250919004512.1359828-6-seanjc@google.com>
 <dd2d2e23-083e-46cf-b0bd-7dfb3198d403@linux.intel.com> <aM1uzfweXxoaaLpt@google.com>
Message-ID: <aM2ICvFxB7gWnW0H@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: Handle Intel Atom errata that
 leads to PMU event overcount
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025, Sean Christopherson wrote:
> On Fri, Sep 19, 2025, Dapeng Mi wrote:
> > Or better, directly define INSTRUCTIONS_RETIRED_OVERCOUNT as a bitmap, =
like
> > this.
> >=20
> > diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h
> > b/tools/testing/selftests/kvm/include/x86/pmu.h
> > index 25d2b476daf4..9af448129597 100644
> > --- a/tools/testing/selftests/kvm/include/x86/pmu.h
> > +++ b/tools/testing/selftests/kvm/include/x86/pmu.h
> > @@ -106,8 +106,8 @@ extern const uint64_t intel_pmu_arch_events[];
> > =C2=A0extern const uint64_t amd_pmu_zen_events[];
> >=20
> > =C2=A0enum pmu_errata {
> > -=C2=A0 =C2=A0 =C2=A0 =C2=A0INSTRUCTIONS_RETIRED_OVERCOUNT,
> > -=C2=A0 =C2=A0 =C2=A0 =C2=A0BRANCHES_RETIRED_OVERCOUNT,
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0INSTRUCTIONS_RETIRED_OVERCOUNT =3D (1 << 0)=
,
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0BRANCHES_RETIRED_OVERCOUNT=C2=A0 =C2=A0 =C2=
=A0=3D (1 << 1),
>=20
> I want to utilize the auto-incrementing behavior of enums, without having=
 to
> resort to double-defines or anything.=20

The counter-argument to that is we need to remember to use BIT_ULL() when
generating the mask in get_pmu_errata().  But I think overall I prefer hidi=
ng
the use of a bitmask.

