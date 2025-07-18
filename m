Return-Path: <kvm+bounces-52841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 015E0B09A08
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43D66178CA2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B651C862D;
	Fri, 18 Jul 2025 03:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddJLyyWx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B21400C;
	Fri, 18 Jul 2025 03:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752807664; cv=none; b=nyMNb1BeMhsJVa5pNIXFqCwXLybMt+V0O8yEJb559x7v3PyGOM4/IkHbrCBJ3Wizi1CgvocwiJqYzxCP5qO35OELeM0qaAKzxOBytFXHuHblgPXu6a7XRo4zxJIFiT2tqUyqt5zol1NV98txM5+G1FEN/j3LqJ5nPhVcunNLXZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752807664; c=relaxed/simple;
	bh=Za0zigQw41dhaLna7U8uhwpKysbTlyw5OLA2b/m2NTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rra9NAD1hrx6cOAsWdytSKNB51cLsGbcXS0V6eUZiVG4+roq9yxjPFQMQVrQXJnXRk88QS7WMO87KcwKDqth1sOViJb837RGfZdx3qr4A7H9aZx0W9ZL9PogQLc9WU1z+/Ev0a8Hu8rde/6oxyXlBsXRDnIvh7UoDuxa8aCVxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddJLyyWx; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235ef62066eso21165955ad.3;
        Thu, 17 Jul 2025 20:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752807662; x=1753412462; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dvd6aXGHQkXaHkQ7TKm1HstTmx2BHwwhF0e3QqMyYSA=;
        b=ddJLyyWxu46sqlzcZQLHJYKuLm2QXrI0S6h9bQPZE3IeMqLx443OG0yjmSWKTnJ+P4
         QvKAG+PDsg/W0HjmJc7ccB6uIjiWNDiCWMfcL8m8OfOsyO3R5vAT/RM313pQOwicQXN7
         vWIqbb+cbrhPKbaQ3jYdfStseOCQQ/3cQbg8i2O/Hi5ZxFa74AnwXzfPf2znmD+K7jef
         7v5ncsL7AcMCRqO83G6Dqj/mSpbNYx2/3IH3z9l5tPwVyUWfpOpBf0Y3db5kH4VMOreC
         4MvumpDj4IlW+OLUrEDh6SMplr3uN6icuDhOeQjuoapZoKBdkwD+l+S+CJsziBB05MfG
         pFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752807662; x=1753412462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dvd6aXGHQkXaHkQ7TKm1HstTmx2BHwwhF0e3QqMyYSA=;
        b=In11MRgdu/07wluNQsvqUCK+wK3qHWoyITDY4G990+/MWuLGprcqLs+GlR1PIhNyzS
         tmtbLx0B+kfGL2OkHGHUVJB0ue1QAHFW41JZPP+Y6s/vlxz+VgAmG37qZ+cWTAS7z8XV
         n/GKgoQn1WcpBe8xysz4PZXuaLfHMPEWRasF95E+pY8+bnFaFdRdv+95QmrZUfSzmRrw
         AX5lwslMxgLMEL+4etblFXcPInUkyx5O3qQbbwBQbsKijOTlDNDkIAL+uhggBwcGHMDP
         a9FB0COpSCdZ4ISnZk9OrJF9oixOmj0y68idnmaUNWVWlVQq/qpTVELIcdGYCIjVzdgu
         V/VA==
X-Forwarded-Encrypted: i=1; AJvYcCWrDk+IHbMuRdRl0j/hpa/WbSreyhxMApchRzWLvg5c3EQmxKDy11XNcz/oSIupSsmUpI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlZPmyoT5PbSAd+cqvkRJ0532VQhYnv0JAbyE0PEtWX/nCFVQX
	ih4Fk4IES/CQLea6GAnMJxzK/zef+R2x2DlXlXqo+o8lKtHF5jtWy4cyepPRHeL2rAAHsXBlAvy
	VxX4pWQzliBeAK5b0t779OjGH6Dr9VAc=
X-Gm-Gg: ASbGncvv8JjuIXLVRuBgECctwVwoDu9CY2/HQ3DR9H7KDVL4W/PbgQ+UkHV00oCCK4V
	a0fpZRj80vDX0ZEf9Do4qozPYk0nCSrSF8tMeG2kiK2KiSI43uC1N3MZRB3/XxpMY7QftVMkmG9
	TG5Dt2Fm3wnHIDI6J6qq+NQVnhs2TS2BQpVc4Z5/Ia7xlkbmRtGalDRGTLxsrXgar04LCDP7rCT
	/l8
X-Google-Smtp-Source: AGHT+IEvE8yh3sg/OHvEoFG/uAp4Y0DWzGpfpsXGNyNRJ7ffnqbWWfrKE/MieXHpu89fSVDeFfLkbw73s91SBIl4OCY=
X-Received: by 2002:a17:903:230d:b0:234:e3b7:5ce0 with SMTP id
 d9443c01a7336-23e30384570mr63626075ad.47.1752807662088; Thu, 17 Jul 2025
 20:01:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-30-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-30-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 11:00:26 +0800
X-Gm-Features: Ac12FXxzE_sqppZnZ_H83WBaxjsUusiyVeEqTm7Ac1K9rtfrr9Krd5_Y1_sE2q8
Message-ID: <CAMvTesAspapFco-1Xu+LF=WnMTyp6i1ftF0+R1m1J-WsHGvdPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v8 29/35] x86/sev: Enable NMI support for Secure AVIC
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
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>
> Now that support to send NMI IPI and support to inject NMI from
> the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
> field of VMSA to enable NMI for Secure AVIC guests.
>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--
Thanks
Tianyu Lan

