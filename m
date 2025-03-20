Return-Path: <kvm+bounces-41577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2D7A6AA94
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCA147B39F0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF96224224;
	Thu, 20 Mar 2025 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a/9DH1va"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652EB221F25
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742486551; cv=none; b=IaqJT5hvc9HJtWQllzWZfN2sAdlmJRszxURNIZAshGGBcCvP8ERba4QCEkk+nufaXhLUyLSLfCMifkz7kmusHA91tdujFIUl7rYWDisVyvaY0oIaxESJRK9u9bl16mdTaDXG77Mg0iaUK6lxtIc7xPOXMZY3pGCniw7AxPSDX8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742486551; c=relaxed/simple;
	bh=u1Hi8rfaHFW2dGSL/G7Kp5UBXH3MGXgX/6flLUzp0k4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+bmmQnMyCDDQ3TfqD1eq8SKyVxJgMeXfBMQtCQTxedYKMYAEshiHcFWwvZljzzbRte8O0+tn3N0LRRy5AedpPby6klWs0hQ7qTf8ito+1iryVdoKBdAKhrH2+p7wGTCJSYfSSUvJiZpx304wah63viRm0yWd8msVNcwL4ooAf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a/9DH1va; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e50bae0f5bso12658a12.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742486547; x=1743091347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1Hi8rfaHFW2dGSL/G7Kp5UBXH3MGXgX/6flLUzp0k4=;
        b=a/9DH1vaEB84rEDQTvOZoYhrzdj2TqXaP03WGqcy1Au2OVQclw0jC+fcWfAWBUDcJI
         ebCuHULRaTFcTYjSlbDXDVR/EduXYHaDgPBHl2WjXFtczVW40m+ANlEe/B6X5JN42qQd
         s9fHqhaGQN4dXBJ8aPAg8ylPvSP106dbIRk+Cbm7+QVhbNaDxtOswLhPd2S7CDmS/55/
         EKMmOYXXvFQp/8FY6dHJkmltkJAIcpBjjsXGjRqB8SKwPFBvxS42c+r9u02rByafrCoH
         8z6PvzkBZ3EWiZao2sapNCPFjdZg0JygNFP4YlNDwB37Vdo6Hpf8/vp6OeowktkScAVx
         afYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742486547; x=1743091347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1Hi8rfaHFW2dGSL/G7Kp5UBXH3MGXgX/6flLUzp0k4=;
        b=F0kCXDq0qM/wLXjW/9nL7GCcRuJtJdWOot4o0YTScwGPcxo1hM1rTGOXoQ/iHYuGNU
         H4Z1FnGpoxIQLoznEEnde95QYRIQ49ErvHU3oHfNQQmAUlg1T+kwxHo4j9p8emws+db3
         73K2ZLmC/uMzV1FhhB2RYljaSUY04hyNRuwzpCHm8peOz6ntnoxLJTUX+mu4MdCymk3d
         e7/fcdhRqLgz1svQ3SU3c2pIw3tXrsxJY8X3aOkFQ5o74qiyImxgEMjxqDyHh5xzqjBz
         zTf+gkr+It0tI7LiHEUOvsat7Pt+ce2QZfbtH6MynR4Vi5JUpQaxh+c+JzGTOJLe8fCY
         ZVcA==
X-Forwarded-Encrypted: i=1; AJvYcCU05ZlAuewQ3YXmgUHrp+pTLQ+XFyUiSX+RYV95qEtgVQm3B7ZD9IYnKasYTIvZ8PGVTIA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq2Ao6r90MquNu3xLDHs8gDNuJxS5ZEjC1huRVJjD/WXn7+HaW
	933k69ihd/W4Waed+Z1RAakXQ/u5n0qOUUv0UbvWvPQeaGEbL5oL/EWOGlpj2ENQfnvmO+LgLq2
	ykkQ4wpqk8UfUpK0tVFiDKOGNFMS5fjdu+Dtv
X-Gm-Gg: ASbGncs+sP/tPlL62zUDTjC8MOFB0NrAzMdfLTwjGKJ5R+6hoBI09JYSRqr37sBbbcO
	RFJ1gTNuGSMfGNR+hDP3cPDjkHiOhEHqu4kHDyKuzUArZw0zH4ZfhKYO0KMEyYGkGTiKYCF3jpr
	fyc54VSyh47rnE9kZkvfW8Ppj0MrB4GUWsGGix
X-Google-Smtp-Source: AGHT+IGJz11VRz1sfjmWPFz8mNeMCvcfaDXFykddyPCtCU+pWu+/Q9NdBfYxM1g/ugC9fyw0rYLc85ohe36zFlrr8FY=
X-Received: by 2002:a05:6402:1495:b0:5e5:b44c:ec8f with SMTP id
 4fb4d7f45d1cf-5ebb56790d3mr99841a12.3.1742486547119; Thu, 20 Mar 2025
 09:02:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com> <20250320142022.766201-4-seanjc@google.com>
In-Reply-To: <20250320142022.766201-4-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 20 Mar 2025 09:02:14 -0700
X-Gm-Features: AQ5f1Jr1nc8mqsq0Nwxb3YT8iNSy7LQyzMmmepYP-6qWP026Rw6NHiUdinwtGD8
Message-ID: <CALMp9eRLfpM4Oev_UeaL-Jc25izkgEqaPqeC41MayPRf6m0AZw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Add a module param to allow disabling device posted interrupts without
> having to sacrifice all of APICv/AVIC, and to also effectively enumerate
> to userspace whether or not KVM may be utilizing device posted IRQs.
> Disabling device posted interrupts is very desirable for testing, and can
> even be desirable for production environments, e.g. if the host kernel
> wants to interpose on device interrupts.

Are you referring to CONFIG_X86_POSTED_MSI, or something else that
doesn't exist yet?

