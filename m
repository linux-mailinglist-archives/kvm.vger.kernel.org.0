Return-Path: <kvm+bounces-55400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C730B3080A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 732F71D049AF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B785296BB7;
	Thu, 21 Aug 2025 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QoxKzoxX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AE01AE844
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810251; cv=none; b=LWTI2qRDEq1ivznsA+EwupDJ721f5KfI0lboiaoKZ7T1896yJ/D+M0b3aksdRaH4suyzCK+H9aHVc549hS9c3prGapwQDuYYFvmd+RJrqsr+RsOvXBesh6frpq/JWPQFRmNGrdLazvIoD1GGy2ndR9HK+m1a6FU4hscSylq6Gbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810251; c=relaxed/simple;
	bh=Ax/5M9fNgiaUpM60gNgoLr7S2/wLwZqWm5F2SXmLfG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CVlRugupiDlqcCRqUtgX7rCMOY+cV5fFkxAiYz4U5n6NQncQoNvHFeNqEqvo6ZpgVC3D5DhGVhZzwPlOXqE92Rlb7DaygXH0HYtS52CLvoIeIv2LzI0CaTTfrnaXgv3MU9FSWxv0zmF3uabWb/t7ToU16M4RjlBRgKeIZk1Wcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QoxKzoxX; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-8921eb4be94so650997241.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810248; x=1756415048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiHzVX3qqPLSsGwTYsNg14BwO9f8YSWJkk7KXDdCW6Q=;
        b=QoxKzoxXs4JFDqpMIofYQsgGMSLkQxghekIWh1b/d8RwUYmcoBOL1wlZ3bKCSikNC7
         5rDMSQJDTsbUZjTxs62THojZGcKY1j4zn8u8cJLCtDOltClY9zKaEBPBWdVT/F+O1qNs
         wo8C0LNTG0gKmd8471cSCATxj9AX7LHCRZP7qTKaJgEv0jI3izQeVncFuwMj39U1EC5l
         AvZMUty0OEk/a7Cu3/8a0MlsjeVJz0eJ/6pFQlVbUCNOQvlmCxsF40tOMtdR9k6FZwHC
         HT4CWf1WdeKJh7r8+4bDJroO1bH/Td8TPMnAlugfMj/xko4iU0NETDN0cJtlMALWTH3U
         1X2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810248; x=1756415048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DiHzVX3qqPLSsGwTYsNg14BwO9f8YSWJkk7KXDdCW6Q=;
        b=s4uoGZ0+9YotrqIDp/JxKq9xB6SJqdcnjvBo0UFdd2whsSHcsu38ee5Tx1F/89kMfW
         rYgGQMn5APH3b9syVE+eKzOvg1vIz0VZTPnmoDiK6SkTDsUqz+iZ1ejtmzUyzptf1nvD
         o/30kqSvVGLjFTXHD+pmb/IqIS/0lyIHreKzNIQYtRNWOqxAufJuhVMI9LsYRCV1D01f
         keE/Dyv7oxxIE/VtMwR/dg3sZXrzpXNVTWvLHOmg5cFm7eC3mYCSb96F4LFSTDRK4IHK
         XIDXyxArpa4qCplOX1Qxte95SqvG5HO0t5V6SaHuZSc7UM+TC6xSYSEEjesCnWGGJ3qu
         /KqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK3mQJueT8vrTVcWoFgya4t7keaPkJWhuBB3lJWBiUGi0NaFSbr6aGZMsXBtRXNRzHupQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9D8OGWwfsb248djW8dN3+FtVO2OfqjX+BKS+Hed3ce9+KMXDd
	21BsRKQC0lqVGRwwr3SLgLGbxw2PgMotMs3TqsfAhhXlfeD2FhTvLflqjN1TNGHEQq6bUaXwea4
	IZEzTtA073+6+unPGr1YtWHa0MbCeYt8+Q2QMpQ1s
X-Gm-Gg: ASbGncthxh+z5cPNIPNn9zrLhBbBBn3gpcKOHawX5BFvTBaeIaqG+J1l3tsjsWcBdGn
	tZjrRt02qa+HMR8QOXVPqdzQaDlMV5f+ioX7sGnfw9wm6CxnzEsyV3mt1NJlbRwrhHEUX5mh9tW
	9jGB1A98rrR4ME0NooP2jyfNZh0zHSVq5e2YngTyJFLueOD7d01p34OW9RlMNPyGFS/Y8RSlyCV
	uj48urBNIgf95ett8VIopxdiLGLFN8Sfteog5UhXggXKqRHDmoiz92e
X-Google-Smtp-Source: AGHT+IH8BmhwAV5TMq5jtuv5CcD52sEM4hDAtFzPHkyrC5f4RE9vRJicCBjwB0j/euUZjYyXAYbjQQDm0mf50m9A4Hw=
X-Received: by 2002:a05:6102:3714:b0:4fa:d2c:4ff with SMTP id
 ada2fe7eead31-51d0f2ea55dmr219355137.27.1755810248226; Thu, 21 Aug 2025
 14:04:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com> <CALzav=dVYqS8oQNbygVjgA69EQMBBP4CyzydyUoAjnN2mb_yUQ@mail.gmail.com>
 <20250728102737.5b51e9da.alex.williamson@redhat.com> <20250729222635.GU36037@nvidia.com>
 <CALzav=d0vPMw26f-vzCJnjRFL+Uc6sObihqJ0jnJRpi-SxtSSw@mail.gmail.com>
 <CALzav=fdT+NJDO+jWyty+tKqxqum4RVkHZmUocz4MDQkPgG4Bg@mail.gmail.com>
 <20250818133721.32b660e3.alex.williamson@redhat.com> <CALzav=eOz+Gf8XawvaSSBHj=8gQg3O9T9dJcN6q4eqh7_MEPDw@mail.gmail.com>
 <20250821141048.6e16e546.alex.williamson@redhat.com>
In-Reply-To: <20250821141048.6e16e546.alex.williamson@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 21 Aug 2025 14:03:39 -0700
X-Gm-Features: Ac12FXx-07ysjjhbXcW1d6QGdWIOYK7REtcOvofZDmLrqHjrbC9iI7jgWdySeG8
Message-ID: <CALzav=f=tg_oz1pEOKFiswBKnTCbrPOJR-DgAK_--jmSkxbCWw@mail.gmail.com>
Subject: Re: [PATCH 00/33] vfio: Introduce selftests for VFIO
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Joel Granados <joel.granados@kernel.org>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 1:10=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> I think we have all the required acks now and reviews just suggest some
> minor patch shuffling, right?.  You were also going to switch from
> reviewer to maintainer of the selftests in MAINTAINERS ;)
>
> Are you planning to collect those acks, add the minor changes, drop the
> trailing KVM changes to come in through the existing kvm selftests and
> repost?
>
> With KVM Forum coming up, I'd like to try to get this squared away and
> into the vfio next branch by next week.  Thanks,

Heh, I was just going to send a similar email to you :)

That plan sounds good to me. I will prep a new series with those
changes and send it out at the beginning of next week (fingers
crossed).

Thanks.

