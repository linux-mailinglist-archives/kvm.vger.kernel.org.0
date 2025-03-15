Return-Path: <kvm+bounces-41148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 796D3A62968
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 09:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B211B17A59F
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 08:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AC21F3BAC;
	Sat, 15 Mar 2025 08:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L3kqhlWA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B6717579
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 08:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029169; cv=none; b=Bh0KiprnfHJyeyYmw/jswGAvdVHWaC9jYKJlZN+2C7tKRon8JyHIYuZ+a9FPv+DSVdHMnuYygwvm9fpSNyYZRiuUCxop1Ca2SwsTEtddG1SMzx8EmTgzC5M/Ay6vdcRgqJk8rKDlQM6n8f2a8ye2F+t6SCrpJZ7GaaI4Di0nsVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029169; c=relaxed/simple;
	bh=a3UIbOy4QmYY4PfL1I7O69Y9YFwqI1DiMtGnNJVIPVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tv1H85t5OzBR/eW9Y/zI/osoaNjSitVEhPGoSdgjgxqzPe6KFUvioRjSmtLbcroJTJJLnP6QxnSyJPJWyGXQa/+RIZ8Nl4SdIymvpJL7G1y/tpHRwdpEmHxeOYSr+83qhcVVahK7ZSyFnGOlhUOArXHs8DY9eH2bpDiQ2x3qrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L3kqhlWA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e50bae0f5bso5078a12.0
        for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 01:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742029167; x=1742633967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a3UIbOy4QmYY4PfL1I7O69Y9YFwqI1DiMtGnNJVIPVY=;
        b=L3kqhlWApwMCfWv2599N8rZ9NU/Wqdq6MBYVuO5Imf6m0AePuoKm/O8XX7CjLXkNQ+
         gbyJdZuOJQFGPzPvWZtReBTvtGc/iptfeMStZdK1QIYd42gzDsTwKTy8bIoeV1xochh7
         mhVx9CzJzT8iNzrmc3g1ikEW2BVcRXt2E9YpvQPtswOgMCYVgT7PFcCf7Jv/3Lx4Rx3C
         IEIhH9J9lKU4LqNAavXodUU6RPpicfHZPhU/w9VVp0tiAttd+P58e4WFgk/8/QjuNGb0
         MumNUoNSzqWyUB6tG+mN96sRkT/rt02m0o5/7Eu07j7c73ULLZ7njdcE0w91be92XwNo
         a1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029167; x=1742633967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a3UIbOy4QmYY4PfL1I7O69Y9YFwqI1DiMtGnNJVIPVY=;
        b=GdKyUmOqsJcoMrKfG9ERLbz5NFHOsjC35W//UCjs1Arr3eoiOsOPzlbs3kq0y81vql
         cpFzoV4TqO5dkE47TW7MnmUWUELDolS1dsidbmjOkFw+bIMRAsA8WPiZUYsvMNZTDeG/
         rPKPPN47Xsln02qfogSCVWzGtIr49WOMVoCiG2xWLLEfnA9zccpuj7ID5j1emA+agePk
         BFJGoG6AIUAH51qWdt1SqNwTMhSGG8SLey/RfGbsU7lN2AShWErLQVwNs4IgHXHP6Uvc
         dEvYhKKO/X5W1RRXY/RYMY9uzbtXq0v6urkxssP9zn6UEdD3d6+bL4jt/ZsSt4kE4MTD
         yUWg==
X-Forwarded-Encrypted: i=1; AJvYcCWpuGcDavqavx8j24nydeJfhi/be8UpJ/WGfiq4Sbu8ArAe3QAB8/Y5KnBJiYH642Aj/ic=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi/K/6nyKcQ59L1C2dLZmRJB2M9uGv0RFZ+wy5szWVbu3wkTvi
	yHUMNCkjQoal0NTqMEjsmu8zFWn68MmXM0MphmdjNl3OFkbJTZEQm26NVdNWwTjiqiNL1ezKyCb
	Si1IZ+q8rEhcC3Q8JHF/m9Ggqati4gKKlRF5k
X-Gm-Gg: ASbGncu5B4gfesOWgazwCvcMVDC89pSuQu1sexXDM7rpQflvoz7c0uxWB7n5wUwcdog
	YbH7nJSY4k5vuCn7gM5uh0/MP+4zbSPdh/rAmqmb3LunoJHJUQE9OX5fvR86tdXMIK8iFFuk1YO
	ZsneAOQBncBkLZJlzQpNbQzeX/fw==
X-Google-Smtp-Source: AGHT+IE+dXs97/Zsvb6VNnIn4JhvNf3ZmeHugrDF5Oo+TfPvYxKv9MZCmFOCHdsG828AfmKXMwR5QbNXQf4OSyZGGBw=
X-Received: by 2002:aa7:c50c:0:b0:5e4:9ee2:afe1 with SMTP id
 4fb4d7f45d1cf-5e8cf638fadmr48899a12.2.1742029166434; Sat, 15 Mar 2025
 01:59:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250315024102.2361628-1-seanjc@google.com>
In-Reply-To: <20250315024102.2361628-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 15 Mar 2025 01:59:14 -0700
X-Gm-Features: AQ5f1JriodUiWgwMjT6SHrLMF4ZHu49pONF2k89lVnsEELpGG9I9MIer5FlQkY4
Message-ID: <CALMp9eRZpj3UcwhsDrJ8T_BhQytSyaXtpwDMK_w2=-5xDut4qg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Explicitly zero-initialize on-stack CPUID unions
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 7:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Explicitly zero/empty-initialize the unions used for PMU related CPUID
> entries, instead of manually zeroing all fields (hopefully), or in the
> case of 0x80000022, relying on the compiler to clobber the uninitialized
> bitfields.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

