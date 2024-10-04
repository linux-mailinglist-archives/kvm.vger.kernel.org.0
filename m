Return-Path: <kvm+bounces-27995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 562A09910D8
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F26DCB21F56
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 20:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A8B1DDA28;
	Fri,  4 Oct 2024 20:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K6t8SUl3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72B1ADFEC
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728072221; cv=none; b=FnPoFF/elwbWC6hrnH7Kf6fVHLjLlBgcPIlH72lbb4pBuHto5j9FeuZlFVnp9FbWp8IA4gWmOa0MheWzUoe363utcGwtSJUJItk1SqMCC0Q+VYkRoyeLR+W78eVewOHuPKsK0TGh4ixZKacFtBFDDamQloSx6sRO36Oqa00Ya1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728072221; c=relaxed/simple;
	bh=2btrnAlR7xZ2puAYYbg3DgCKDeMLprXOA3KKEld0BuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6YnEcY4UQaA+4GJmdhGt1uDhs0j62aauCFJIydFu2X8gYE9Yo9IUXKQaUSKilqlXADGSFjLDTqRFYxvwgvZTF7tVwpibN3dflkMXFopSP19D5Ntp4NLc/adRveNU6vO6C0Rtk1b7ChcbJkigJXpA6LMSRzjBMLMknLX/ok2hRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K6t8SUl3; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c87aebabd7so6329a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 13:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728072218; x=1728677018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2btrnAlR7xZ2puAYYbg3DgCKDeMLprXOA3KKEld0BuA=;
        b=K6t8SUl3MoS1Sukop3aNKWk6rnf1s1LiEeyP7uBikBGWUPBOwZ888VKigAa7NXIpE2
         3TsC9XmH/ab0sfCVhbeMBxJoyUfiN5yshdpoOTc60I8kyILvTNymVnYYtpxXY3EBJ6UC
         3ZDF/i3Dk/QwLHBOa0a/GubGmPwXXAiVxuHAVGdpVNwkziiYaJFe2oTUs3ZWsk+8sTlB
         lku3tnU60B6ZrB2qKRxEYnRuYJvlcdqUpuf0jgUbQqBZAOFyStlsczCFKl61tqaM1WJK
         w+HUg9YVo2aL6g5xMYLYJlL4xGVLkVFCG3ElFEIVveBt6vYiFJkYKaTjY/UQAffpfSyY
         mMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728072218; x=1728677018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2btrnAlR7xZ2puAYYbg3DgCKDeMLprXOA3KKEld0BuA=;
        b=KdE4vaTGmWwwqMNR3jvQIYiGBuwrNh6vT2A9734n+xHEv9oOcMH9VUR/ln9rO1z+3A
         7iom6SXZLVz95Qm28HT1UChVS68m+0QliPovn82xuiNkXXTRVHiJa5jeV9TodZ+BhYtc
         dpttFswptPW2lYnqi4hb4ixezT+olvXdt4fUS9D4BOIYLAczpsd+fCy1K8JBIQeQNakE
         5WiSsTFdA+2bJjvet8fZdwGF5ZO4tUlqhxrtVcVSHkxdE+TsZX5e+ZczRSciJ0510W5h
         05wTIpAng0pi9FWKK30pnKdNUTNBUdqoDmzAjlkKbiuiPHr0iTatyKK3/CfhZmlB5eOh
         C8zg==
X-Forwarded-Encrypted: i=1; AJvYcCWv3D1NLDVTARDWb03gDkR9S7oVzya/C9TWy0dXsowQMPq2zMu5MuwQjRYg5jVxLwhegtE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywec0Ui0BxSRnzEyEaCphiLDPtSOyQdDk0GmOwAJ/N8AY1aHoka
	2r5nC5FQp/Jdu63v9EYXKv0dwoYRLQg83Rr4szqWj/rCktXV7mbg0+5ZfQjiI4FQXBgpgIcYstp
	8Me4FGNCDKkVh2E5kbcNOcjyu5oNnA7nkTuL6
X-Google-Smtp-Source: AGHT+IHXL38ypg3TXpmxDO26FWCwJ582lcXdB2ADTWBWdqqaNBOckf8oasaoG7TglB4IhLt91PUci9wdxMeyLcAQavM=
X-Received: by 2002:a05:6402:3489:b0:5c8:aefb:7449 with SMTP id
 4fb4d7f45d1cf-5c8e1194615mr71139a12.1.1728072217913; Fri, 04 Oct 2024
 13:03:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241004195540.210396-1-vipinsh@google.com> <20241004195540.210396-4-vipinsh@google.com>
In-Reply-To: <20241004195540.210396-4-vipinsh@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 4 Oct 2024 13:03:00 -0700
Message-ID: <CAHVum0f-3OMnLj5DNnmBZM-f-fP6ApeO8UzaVk0MDyVMnnifYg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Add a test to invoke MMU shrinker
 on KVM VMs
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 4, 2024 at 12:55=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:

> diff --git a/tools/testing/selftests/kvm/x86_64/mmu_shrinker_test.c b/too=
ls/testing/selftests/kvm/x86_64/mmu_shrinker_test.c
> new file mode 100644
> index 0000000000000..81dd745bcebdb
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/mmu_shrinker_test.c
> @@ -0,0 +1,269 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * MMU shrinker test
> + *
> + * Test MMU shrinker invocation on VMs. This test needs kernel built wit=
h
> + * shrinker debugfs and mounted. Generally that location is
> + * /sys/debug/kernel/shrinker.
> + *
> + * Test will keep adding and removing memslots while guest is accessing =
memory
> + * so that vCPUs will keep taking fault and filling up caches to process=
 the
> + * page faults. It will also invoke shrinker after memslot changes which=
 will
> + * race with vCPUs to empty caches.
> + *
> + * Copyright 2010 Google LLC

Oops! This should have been 2024. I clearly live in the past.
Should I send v3 or can it be updated when this is merged?

