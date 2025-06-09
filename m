Return-Path: <kvm+bounces-48724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E935BAD1926
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2191B188BF57
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 07:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC1F280CFC;
	Mon,  9 Jun 2025 07:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVi284ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4D4155342;
	Mon,  9 Jun 2025 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749454857; cv=none; b=UDOrlf8JzPeimxjfg0ai27/iOtSibJtWz3by/ZuHH8zd1TpuHUoRZ+vWldL7MFAOhG1s2JWewFRRKvu5GXjuT1roSjdq2nlycLlno97xx4VwzT490KE8q6/CZJTcGOM0nurNN8TvpCUnCkZOXrfncKoFOfu1WhaxWKugjBmbFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749454857; c=relaxed/simple;
	bh=KqiCwPI+FSPcNo01A6kecalaBBX0hvVlFdxywS3rLdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YXgskU+hu/2Bmbveh4x4MDQTN4D0MiiXEphmgZpG4MtmW9ZXzBRrYOZGwyM2zN3xCPFtRflp5hn/4ArcPGekIWvUtuHyN9E1hmbMkpPalpgvxOvkB29OWl6q0EONjak7kjfbUZ2E+DNtao2Zwhe7Ia8/ihGpt6O8ps7/sPPMTfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVi284ls; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b26f7d2c1f1so3682165a12.0;
        Mon, 09 Jun 2025 00:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749454855; x=1750059655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqiCwPI+FSPcNo01A6kecalaBBX0hvVlFdxywS3rLdU=;
        b=mVi284lsoKwheGKBwMEyP/vwa/6SIQGl7nfQgPZD1KQjTmMuqjSylmFzkk96uTAfGc
         paUHxjESqggW1HqXGzvmt/iip4SZBfa4cAR9ix+cZ/QtfPozUz77XJYVFfCcQuCV06WY
         YujuQV3q2vvDi66hH2/V+jBVZ7p6f3PnPKUneQSQYpTnOMmTgWqab72mlmzAQ0FBHha6
         EBbSmmydOtNns91UhTIsq59zalLkAco9DGGgtBhR6LZRBC+bf1gUuftSODybtyWY1m1a
         hjNujy1jEZkjNj6U3c8X/hc0VWbmwpb4PK71vgbxNOGqN3y0UtTH+3xbAB4qiqxOY9Mq
         b4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749454855; x=1750059655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqiCwPI+FSPcNo01A6kecalaBBX0hvVlFdxywS3rLdU=;
        b=cYP8QG6wqh5HbeNBUzUYxelxmyzz6l8J+l38tBDlh+zbhN9vrbWY69eEjd/HbnFzcQ
         tluf54KC+BZmxfCw7ToyrRadc7sdX40D2pmCbiekWUh7GymIwyzvAYDU+hjy48joqtMf
         7wplasU3X6rBeL6DBXubNqfo6TKWPpIxThrfxbZHMaNd06lBtn+fU25gYmWqVpvGeU5e
         gHO4lxZUtBYBRjDaUt5Tn8SH/OpyXsbo4jPxnquBkg1On8VwMpdie9mPQO2HCkGrBU1j
         yio+J7P//rHZfyaykrwRTDireGb0kFiXv5vf8TXBgxU4tRylI4y2TmDtSawx6yM2rYDc
         G5aA==
X-Forwarded-Encrypted: i=1; AJvYcCXcA8wDGVnHdqJi2GXqeRGJZjnSX3m+o1ARYu1nK5YWo0YvvV5tHQuWRaYONQc12kYVR2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP0gKPKrvzkHTTYr8v9V4SjyjwKkRSEkV9VrRSDXOusYa9n8wP
	fUk/Wiv80MTeq2yz9wV9Ap5DnPXu2KB+KGT26DPDU8Em5/FpByy/HDu3+uF3Z9kazb/sOO9/C0y
	hAHOlU1dd/rocu6WLkYrgL89CO9lubsk=
X-Gm-Gg: ASbGncvTTVBKsphzFokg7PNlSWsi5aZv0d9IqP1Kli/didSZ0UeR+Bir1TaffpOo/ow
	dqiJhQSUL8KQzaG/FSZ3HN+XOwMH2OkXz4v8UwQ8paKfXk8ykvhJIYgAuAj5PCslJ6lKiAKnWv2
	hQxR6pp4pUHYCZ1BzHnCMOjivyQmxrRWRvwLPl+268TnUFBA8Oiqh73cumFqLIXQ==
X-Google-Smtp-Source: AGHT+IGbFNXPkYqjZQqn09iVOchn6k5QUdAnNSlPs/XMUCroRdwdeP0hZZnbbuyNPdHKkr8WmeI3Qu5L264jB2MsXOA=
X-Received: by 2002:a17:90b:2ecc:b0:311:e5b2:356b with SMTP id
 98e67ed59e1d1-313472e9005mr18838455a91.11.1749454855433; Mon, 09 Jun 2025
 00:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com> <20250514071803.209166-32-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250514071803.209166-32-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Mon, 9 Jun 2025 15:40:19 +0800
X-Gm-Features: AX0GCFuisu29_xcex8CdM2Yk411ctfB6p7VWrMziyFkU93Q6Yrxgj1z1d3n-g9A
Message-ID: <CAMvTesCSX1g8Ttzjn4PhfcWSYUdAcCUV9hfJd_TPQzek24K1LA@mail.gmail.com>
Subject: Re: [RFC PATCH v6 31/32] x86/sev: Prevent SECURE_AVIC_CONTROL MSR
 interception for Secure AVIC guests
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 3:33=E2=80=AFPM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
> page and bitfields to control enablement of Secure AVIC and NMI by
> guest vCPUs. This MSR is populated by the guest and the hypervisor
> should not intercept it. A #VC exception will be generated otherwise.
> If this occurs and Secure AVIC is enabled, terminate guest execution.
>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--=20
Thanks
Tianyu Lan

