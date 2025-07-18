Return-Path: <kvm+bounces-52840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9B1B09A04
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 610DC17B8B6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047C31C862C;
	Fri, 18 Jul 2025 02:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnOZvIho"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6E0A923;
	Fri, 18 Jul 2025 02:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752807561; cv=none; b=OHmlIql/WnC5g+yS42lmRfnaA9ato7VGaabEZ2gjrPHB7LBLjvBrgO89k3fB+pDqlafKObRiBHROhi/tBNJJI0MX3MxliTyJG0BZoeIY+PwI2D/9KMVVcfbwaAXnaFEfcMA3wmkyIfYuAnPWc/smCR9Tn7FXeXQk8Zt+TXnnU4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752807561; c=relaxed/simple;
	bh=VZxxef9Q71ysTUH2iir4q27phsjEY4lVarflfhDZ5lc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXVLfoeJFXP315xFJy3b/gpOLYu61EUYwNnmiI8ZaZXu1vjR/horUbD6aUOx83IH+xDhxZclK1+Ouwh33vcbciUltE8XxJn5eS+RIw8UlvTqfAj6Ow8CNHSK2mr5LAe9tPJRZ2zIeKKBhsO5P0gk1maG9/WTKQGI6DfBs9kaybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnOZvIho; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-312e747d2d8so1845732a91.0;
        Thu, 17 Jul 2025 19:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752807559; x=1753412359; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oupdmlmk0FI5rpfXjKWTslxf0TZVNi83420nETYfUK0=;
        b=EnOZvIhodWJNfCRUwD+LNhkgOhYZHhbnYty8ELCjPaEPHXxOfKQSVi1XuGljRttOp8
         HIKJpgHWNpY23xYqpNavBlYmz0JYLTvLRKCDCCgEM7iLA/YTXETIU5ZwP5OB1VEU6juB
         O1ALy2ymlHBNKOyhfopTmaUxpRHrcEHJMFRlAyDvhQN6mkBQOHJSJb0JdysgyLfoZkul
         QuEH4/tQmkLTSn5UI96MQrZA9OKXIcouuvB9+l93eVJKuG476z98EuvsZ7lrGbe7en76
         tiEaV3o7yff4hmKmDrKxHeY3+ZJQeGwhQ4toF+9z6uZ4h8hwbUNEQXNKDU97gihe/8hR
         dpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752807559; x=1753412359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oupdmlmk0FI5rpfXjKWTslxf0TZVNi83420nETYfUK0=;
        b=f1H0pEyVoKrNlL7jFR6BmwaeX51rGeWbpes+VMxSym/wYqrsTEhN2+rrLXJGmLUdrH
         3Gt1Kqm3WBpOc6cUK0jf6uyptUB8LavOg2odQ/BuumDv0/4cZKnGTcEkpWz7DcfjvsOD
         dIFgwxFGJenxr8rwrxrBFvKatdAKKiW+rGEiqYXvHto49u1DuJt/ZmCxj5v9QHNeuw1E
         QUGrxTOlBrs287QNWOMLpIdxtseCxdJQlejyd3snl3ATY6ZAvZ+FXTtR5Al23V96EYz0
         dcpAA6IQi3OsuN9TcGLMaeWivJcTmzcuG0Ok4p2EOP/W341EgHe+urlfKbkce9rYSTHb
         bUug==
X-Forwarded-Encrypted: i=1; AJvYcCVOXSbkBLohJ9h2+RzGHUCsOth1+NT2IAFvB3e7kqHZZR0fveeWaVYIjGnfdKBbvgZNuh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGe7KhTzU7Tm18/pTrimjkH7UofTPvE3G1Pp/HjVB8+sxmo9kK
	C5GjDJve6h8UMMNBYmBIP3s5+EHVahPkygYHYhAeRtuscIeeyg+6KWAgkoOcL7exaFn9A7pOFbb
	WiZhWa7is0Dmmupe2R0UEuhTG3Dl3NXI=
X-Gm-Gg: ASbGnctXHty+bcm32pc+A7aQUbI5ehIL8Ny8hhUeqTMDbb+jFgGuG2J0N/Te/AGHA1T
	ZJ29UoAU8YMWenkhf4rpVstpT6vFjMI0G3eeOy+LAlOr5Hilsv6wJQZbq6dHHWhg/RcG4AnKkSK
	14pEPSy/7j8RAuA7z+R8wvc1dkVYLLAe9e7MJNSO5JefKXPnBuOmpCoFnKpZPJ5X3bENi6i48sY
	MMZ
X-Google-Smtp-Source: AGHT+IESvilf6Yuz3Lhp5nEZTCBHxbO0uRB1bYIPhR90eGgE/0ztvDI7U3X9dcbiKa8BRuxBwqaa6cV9GiztsPzCdqM=
X-Received: by 2002:a17:90b:35c9:b0:311:be43:f09a with SMTP id
 98e67ed59e1d1-31caeb94323mr7049348a91.9.1752807559041; Thu, 17 Jul 2025
 19:59:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-29-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-29-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 10:58:43 +0800
X-Gm-Features: Ac12FXyDD-dejhj5z5YYTvyfd37K6QEwfQ9IjxfRg7i_jXHUhB57KNogCeoD6xQ
Message-ID: <CAMvTesCUCs0G17yvi6FQiLAo4uY-h624BZB3opRaH9jakf0Jqw@mail.gmail.com>
Subject: Re: [RFC PATCH v8 28/35] x86/apic: Allow NMI to be injected from
 hypervisor for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:43=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
> to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
> bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
> from hypervisor.
>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

