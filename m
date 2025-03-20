Return-Path: <kvm+bounces-41589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1474A6AC85
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7F57188C4D8
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AA9226548;
	Thu, 20 Mar 2025 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="byNzrn0C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B011822577C
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742493274; cv=none; b=j+aFYGet6hRbefsDDVyUkpTiMPRCOKwcwrhuaGqO0dmf+6pOea03oIZ3aYkXzZfaQd8jR1gN6GeejiJf5hoq8ltR9DY6rpVgHWlmyTWBWPpwbT+VeH4tFFcy6ItaqKsH4OgviBFSlrXQqWUSzyr0StUx0kEWgx+2Ftm5MSRO9h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742493274; c=relaxed/simple;
	bh=ycFdkzxtakEGnyZBK6i8pj/Lu02w+pmZ7EzHe02D5xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QsYRWE753CXUcIK80e47qVaHY0dNkym/3xrEm4aS+JAmiaLcG23JmQWBbETEx1rH3RH2PH38f914tKElJ+KzrW2QTgzP2v/qQl3F+62mse+LnfHsl++jQcgZbOjqISZRXaIyx74QI1AEjqO3tkj0Y13uxYLQaRuwP5immqtrESU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=byNzrn0C; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8a2c7912so1664215a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 10:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742493272; x=1743098072; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycFdkzxtakEGnyZBK6i8pj/Lu02w+pmZ7EzHe02D5xc=;
        b=byNzrn0C0Y0qyQo0EnNH+e6auz+bGIHY/LvyABC+B9lv7PpUs2ZnYF5bURd1HLGVPL
         D2koSM2W53Qhptd4w4/yQdTjajqjIVEj8JThsuX+sa8Slu8C19n2nMDdAd8oRX+sNbHN
         sf2Hw7Th6WrNjSQZZUfdklGknc8G01yb4SirDj41lKBRIZz9Cn4UK13JsBqPvIoHj8L2
         wFX6lV6FTT/fwk2VNC+nupkBsgoMCsbgeJcTFHdJGmEJDKFHnXt3rW7EmmYPxlAXigqj
         IHCwNR8E5m6f3rJXNj/9KUCNrlTDObmUlj4BSbGvO9s3OJwDlXc7DpxcSXAiaDfIla9c
         u7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742493272; x=1743098072;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ycFdkzxtakEGnyZBK6i8pj/Lu02w+pmZ7EzHe02D5xc=;
        b=jJTbMYN1t+JW5bt1s01GS6jD5EloC/8jGWJwudWrr+vwNVdrE0qoj8d26rv0nZUKNd
         H+qxAFeF0BJMr5HKwytYhuyiz2qP8l8+5w78f1zN1EjtBcfAjXEDJopZVZbkk+gQtjwp
         xBajqOaMM+VWmSCObwz6Jid65Hot2JWdLt0GvV64BV07tmPnbxRxdNMCjxV7YLai/BvD
         1j/8kpSpzKAfzMksVzqYGQR3wr1HugACYGtwccTu5PgSSe4FctYD5FRJ+X0Ki8AA7boe
         q8dPV1wV6vELkdt7zqsYuOikTkfqiXSktRHfVNqNUfrcwAPbruiLCA8pyR+dPOXx85ur
         IMtg==
X-Forwarded-Encrypted: i=1; AJvYcCXOp7LnaiWBZgAMHljj6orxwGkSG4ovzDRyglbzuupHP9lHRrFWjHHRRgB1vaBYQfYteMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywaxr/AbdmrJUw1bhbdY9kxUcTCy6+BAcdD+lKgV+7M2H3UWvBT
	M6uQNXSM2StHQ4wRvkRC9pU/h/2tlVASMCML9L0yueP9X1IJ+NZtNdBVHYtmMbIlKALYqAOi4S2
	zSg==
X-Google-Smtp-Source: AGHT+IGDSdE1ytyBoBFw7qVwuVm3wbv2xNCX9zlmSDFB9e6T2jpMlLpSaA4AhKeFzgmz0ROgTRp2/3598EM=
X-Received: from pjbpd14.prod.google.com ([2002:a17:90b:1dce:b0:2fa:e9b:33b7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3844:b0:2ff:53d6:2b82
 with SMTP id 98e67ed59e1d1-301d43a2db5mr6626003a91.11.1742493271988; Thu, 20
 Mar 2025 10:54:31 -0700 (PDT)
Date: Thu, 20 Mar 2025 10:54:30 -0700
In-Reply-To: <CALMp9eRLfpM4Oev_UeaL-Jc25izkgEqaPqeC41MayPRf6m0AZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com> <20250320142022.766201-4-seanjc@google.com>
 <CALMp9eRLfpM4Oev_UeaL-Jc25izkgEqaPqeC41MayPRf6m0AZw@mail.gmail.com>
Message-ID: <Z9xWVkDx6hnpFw5Z@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025, Jim Mattson wrote:
> On Thu, Mar 20, 2025 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Add a module param to allow disabling device posted interrupts without
> > having to sacrifice all of APICv/AVIC, and to also effectively enumerat=
e
> > to userspace whether or not KVM may be utilizing device posted IRQs.
> > Disabling device posted interrupts is very desirable for testing, and c=
an
> > even be desirable for production environments, e.g. if the host kernel
> > wants to interpose on device interrupts.
>=20
> Are you referring to CONFIG_X86_POSTED_MSI, or something else that
> doesn't exist yet?

Yeah, that, and/or out-of-tree hackery to do similar coalescing (or ratelim=
iting).

