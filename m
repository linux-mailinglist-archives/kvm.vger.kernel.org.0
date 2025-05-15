Return-Path: <kvm+bounces-46701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2CFAB8BA6
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70B11175557
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F26F21C9F1;
	Thu, 15 May 2025 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kXzw4QXH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFC8215198
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747324562; cv=none; b=YHkk2cSQq1tbSOiHRgDe67ZXwgH6qU9UNLksSKgBAAMRsH6gJr1je4G8KhTNHpJCoE0Zsn2cdLbDzB0gTmDWaw5ESIvXe1+CL2AverYvD3FVUd0bLrylfnyZGMTiFbY1rH8Foh+lBObChQ9TIOo5zyMTLj273Cnql/U2V4nNWl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747324562; c=relaxed/simple;
	bh=ZWFaz9G8mCh4fL/ZI8lOzKp4rkTmq+qocrzzt+P6HcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgBxo0xla0s0JOOcxIwI20v8mlRhIqTQmBsTsU+9eOdf1b/dG7LVIhQWqrXlIF8ZV/R5BhlRMxYk1+hNQy38h3MKcPbecGB0PtougC9eThOkkVxhTX8ussiVP3jjDbr5wqFY2MXMYv67JRPtq77leEg4ybStS243i/ymWAyUbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kXzw4QXH; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-47666573242so410271cf.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747324559; x=1747929359; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+K0vt/UsfM3vUNh3n2feDqNw5L/kOjFVTMJKG3X0A0=;
        b=kXzw4QXHdd1AHwFZSMwKWxR0oxF2tifNySjPJRniduID99JI0xjANUKUbllruUZGGV
         zOZHLgHxcQ8fTb/cEHYmyuBjKKp1sDF49FhLRLXf6aM7D790+UbZPWZN5xIDrvWVyYbq
         XMzYbzb0xsk4u45ftTqga+PteOkjuQa8YD8tWj/bibT/cf5FZ4xUBw/lcC+H/6i7Rysc
         9CQLKN0lePV+kbbQ/ghbGI1j9Q/a2HJfMgF8C1udC14oThT0FFfiWlkYuPvJiMjk7t6Q
         owtmmRnoDWwrA2v/4/hWjuMGKFqh0M5HrX45MOX+CoN3d1qSakviGF4+Yo5xJpTZA6gi
         KV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747324559; x=1747929359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+K0vt/UsfM3vUNh3n2feDqNw5L/kOjFVTMJKG3X0A0=;
        b=UVroCF17bK7sbUmnPgG+4a9hHSkpR78aL1eV3RE/efSE5Ry682lwgaajOgMXpq2QDs
         BjcYpXs7iINOO8crjPwFDzcN7uMgi9pU1TRiViDUfdRMfo567MX0OD0qGcD22lq+5Kxq
         HY/V9JT3m9z47jRJkCTqmPL+s0g+i9CNUwaVAABVpoYa5Kwc3WLaswH6zdODO/u+hVgV
         oR26IFj1DvH35Y7EOO4RUxS71qiQe5oAgMCArh8UOfNq8lN2kAFbLrXtCzKzfUa3jT+L
         wCqtTtyIHz368KRzjRveVMoGVozeRQgjMNN9JNHAtnNkkj95T+iq84v/IZLca4ISpdMa
         6Nkg==
X-Forwarded-Encrypted: i=1; AJvYcCXTIXqtPZHFbiGgTfHA8eOXhL3wzOCqKNsmE7LDlglCVq3epqcZsfFVUIJ51yrEGAjNd5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOIzpbInxadwNOZKnhhYIO9TJ3b/8CXG05Qw+Wn4CVMSuxXCuW
	aIJ8WyLjjM+7NDCW5J2EIog67P5WBSELfakZT1icBiLnoDrFAp1RI0tvEXJy1UCTCptiFD2CN8j
	9Dyj7xPkf8B8oP76xEr+Q6qgl5S7tdCMKiYh6ySWuKoGQYAd+na6Q97l7
X-Gm-Gg: ASbGncstz8V2vfza5IPrDoCSiyp1JuQq+DYh71JftSKkRWvNPpHDIMWZjE4k3qKARSd
	jNC3ay0MojSH44SSWC9xdLO6xO5Pgw+C/6oe1hyLcx3qE3yd48+CcrLfN+yHtlD4snyxCeeBiE9
	KVGqksDt3wme/o+rh3OAzAvB2NQnzdl3pYi25wDiB/+JmUgucCv9CEyY8VPGsCTuA=
X-Google-Smtp-Source: AGHT+IGE8aOMfceY42fJdDmnr6JiZyRmyYUbEN4lifv+BrH+R9XF5r2WJo81r1w3ZWlb4E8sxeUCVV5r7958jw/lsCE=
X-Received: by 2002:ac8:7f55:0:b0:47d:9e7:91a4 with SMTP id
 d75a77b69052e-494a339e50cmr3395421cf.27.1747324559128; Thu, 15 May 2025
 08:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514192159.1751538-1-rananta@google.com> <5d204cf7-c6a0-455c-8706-753e1fce3777@arm.com>
In-Reply-To: <5d204cf7-c6a0-455c-8706-753e1fce3777@arm.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 15 May 2025 08:55:47 -0700
X-Gm-Features: AX0GCFtGa6LDhgwrs8UTR4zlPfPiOcKTMSK-2-OfwRKhnoGtsBeWQpI8tPkyL4U
Message-ID: <CAJHc60w1rYc9guoideuKpKaukuCyvxu3S7Fidoy3Lh94+_xDiw@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Allow vGICv4 configuration per VM
To: Ben Horgan <ben.horgan@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2025 at 3:30=E2=80=AFAM Ben Horgan <ben.horgan@arm.com> wro=
te:
>
> Hi,
>
> On 5/14/25 20:21, Raghavendra Rao Ananta wrote:
> > Hello,
> >
> > When kvm-arm.vgic_v4_enable=3D1, KVM adds support for direct interrupt
> > injection by default to all the VMs in the system, aka GICv4. A
> > shortcoming of the GIC architecture is that there's an absolute limit o=
n
> > the number of vPEs that can be tracked by the ITS. It is possible that
> > an operator is running a mix of VMs on a system, only wanting to provid=
e
> > a specific class of VMs with hardware interrupt injection support.
> >
> > To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GIC=
V4,
> > for the userspace to enable or disable vGICv4 for a given VM.
> >
> > The attribute allows the configuration only when vGICv4 is enabled in K=
VM,
> > else it acts a read-only attribute returning
> > KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE as the value.
> What's the reason for the cmdline enable continuing to be absolute in
> the disable case? I wonder if this is unnecessarily restrictive.
>
> Couldn't KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE be reserved for
> hardware that doesn't support vgic_v4 and if kvm-arm.vgic_v4_enable=3D0,
> or omitted, on supporting hardware then default to
> KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE but allow it to be overridden? I
> don't think this changes the behaviour when your new attribute is not use=
d.

KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE is reserved for the exact
situation that you mentioned (no GICv4 h/w support  or if cmdline is
disabled/omitted).
Regarding defaulting to KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE,
wouldn't it change the existing expectations, i.e., vGICv4 is enabled
if available and set by cmdline?

Thank you.
Raghavendra

