Return-Path: <kvm+bounces-49258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF3FAD6EA8
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 13:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D337C17E830
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 11:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D78123D295;
	Thu, 12 Jun 2025 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q45cTnMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3E23C4E1;
	Thu, 12 Jun 2025 11:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749726655; cv=none; b=Do720y++mDgQKCZ20h1viCijBWY/f1oeuJ4NFTysjspgSHBhkoVnu8dQgUE5cTo9UGnzc9+kMPpQCzEvOOyAT2NCQ+H3RqC35/bAAmQyXBucsWfvsAC1pJPZAea4bu0s59JYryaagMfeqHTHK79LZqOvahC6MrMd5eGCe1ebv38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749726655; c=relaxed/simple;
	bh=9nBrpMK9zZeZHFNOhk7Yg3FOCL/mJbGGTtA0TEp4ISs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWipY7Gj1P0iBai63NVgsByk91TsHi3hYpXJZerApVI/slihpJZFoz8eyzwkllL4GDiw2YUau9gDhutn1otE/YQF+kpKFtK3NnGMsm4bxOAFE9FpAPkmxqhvkHt3vstTmu4XYoB1uDdPj1C1AyVnTghYMD1e+Gv5vNAa6gUZE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q45cTnMW; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-acae7e7587dso124691366b.2;
        Thu, 12 Jun 2025 04:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749726652; x=1750331452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nBrpMK9zZeZHFNOhk7Yg3FOCL/mJbGGTtA0TEp4ISs=;
        b=Q45cTnMW6M14BzyHymT7nYYg4t6x9BGdEF9ruN7/wgYyxXo4Tlylon5otQ4YZQ2Sc9
         g/fsr0NtQvk/Etw0ossoeTHN5Cfeae/FY77K+/hghcbUHaHmOpEZQ0QfIC54ELk89me5
         EBgOWoQq1e94sLb+w6ZhJiPIJqPQkeOe2ZawGAVkKUk0u4IwUvzbs9mvTc+zgI2EEhWV
         PGOLGYDT83nHRbq8q1GqlAQnlaQHiOD0LpzhRwXdqYNIxtoKrSayGXBNK5OhJr55b+79
         SORsFrLhL182smO44kfOdktCOFsoScdh5f38OKEwjH75O4ojvNwuU8hPnzj5H/SmbNCv
         +Lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749726652; x=1750331452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9nBrpMK9zZeZHFNOhk7Yg3FOCL/mJbGGTtA0TEp4ISs=;
        b=bELuWToe0XVxZWlrcTkxavKMdL0MFQyUjScPQ1pg91aQZL3zKvLiKgFqlbm3+4a8As
         WeWXlDIxcqIYIt7UIwIfJ4B+l4C7xmJfKkXq7/R9nUKU35ssrOtVuWMvppQr+Y7Kc2vl
         LekwDtI4vlxtGg3GiOG6va7TloeGu0AdznSLOpwZmokfv75bkcaYqsyntWk/gLLmripo
         jt7dx/p7akRQ0gtX32vSWTFgPxbc7n3pGyRA2WV16f3LOxczeMCBqQUucufUt+aImDS7
         xzWa3bH/CDMc36uZQE0bHPB8bxlhhcTgOPAUl1lEVJH6d2NwPXMlAxtcU/OPL1lhVEN6
         8PIg==
X-Forwarded-Encrypted: i=1; AJvYcCUN2/qpgkwIG246rcWkdFL5deXpx4GCN5qxQHhk/07t20elpOKE8gUso5+yE9DhYTCPKi4BFhMq/DXHWPth@vger.kernel.org, AJvYcCV1GKG+kHsF4n5I2gK90GR6LiYWn39EDXUZekx03xJIV+baxXMprxX07VyobFgCznO7uig=@vger.kernel.org, AJvYcCWGXzs+dFV2GyY3E0yV4zOWR3G/TNaMtqKUrNIbBXAbtI9I4JaH2vctoLgJHUPJ8bJjDZQJjH1x+9vM@vger.kernel.org, AJvYcCXSYtdOMlxqqKl+ZVGHFrfEJMLiTQIJYazh/Sq3vNSVy3mWobMC1QYakv0t0nNK5FNRjpYI7/n4L3Stpw==@vger.kernel.org
X-Gm-Message-State: AOJu0YymOdIutmqtabbKfGQiOrdoLCxolZvrE2ld2Lu2LUmXMj4EJNnq
	mgNOgbSXzNv39WSD4TMmcwQNCr/4XXJs6d+MkM/SpCFOi5QahQNg0UwKGPfawZ2NuQo4410N3Qs
	e8tDPI9zf5RIqEf3d+DfzkPDQS3OFJNc=
X-Gm-Gg: ASbGnctdy4c7+GN+CO8Gy5mG3BMWkNtkjy46cni4wnAOoGi24oqYfju6gBuEE8HP08p
	F/ED+LuyHg4gSAu8nQCI+1QmdWBnbjUjg11kHRS55rvWoMR/lxcTYncc4W1IheVbCGoFt1ubotK
	A/n6e3KmxH90wx0rffNSE2FztOtajAOHWPMTyR8bEwrtc=
X-Google-Smtp-Source: AGHT+IFrX17XfYVkjVnepz8BihCrbdN9elHb1a1FwyoMbX0yLjH2EltV5lWsECJ7oLshTrIE21PMDORFUypei4zXNLs=
X-Received: by 2002:a17:907:980f:b0:ad8:a515:767f with SMTP id
 a640c23a62f3a-adea9464061mr258576566b.51.1749726651742; Thu, 12 Jun 2025
 04:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612093228.7655-1-chengzhenghan@uniontech.com> <84b14425-03e4-42be-8bd5-9bc010ebecda@suse.com>
In-Reply-To: <84b14425-03e4-42be-8bd5-9bc010ebecda@suse.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 12 Jun 2025 14:10:15 +0300
X-Gm-Features: AX0GCFubP_i495cQIkoSGfjK4G9pwjz7TYfQyvgZfj4JA8pwuaopIL7tecp4u7I
Message-ID: <CAHp75Vc7AO_sRgB1Nj6CevbseMFyv5ku8ZS3PwzAuAgysKVxNg@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix build warnings about export.h
To: Juergen Gross <jgross@suse.com>
Cc: Zhenghan Cheng <chengzhenghan@uniontech.com>, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	mario.limonciello@amd.com, yazen.ghannam@amd.com, jpoimboe@kernel.org, 
	tony.luck@intel.com, jarkko@kernel.org, bhelgaas@google.com, 
	pbonzini@redhat.com, oleg@redhat.com, jbaron@akamai.com, ning.sun@intel.com, 
	seanjc@google.com, luto@kernel.org, andy@kernel.org, jim.cromie@gmail.com, 
	kirill.shutemov@linux.intel.com, hpa@zytor.com, 
	pawan.kumar.gupta@linux.intel.com, vkuznets@redhat.com, rostedt@goodmis.org, 
	ardb@kernel.org, thomas.lendacky@amd.com, nikunj@amd.com, 
	ashish.kalra@amd.com, kees@kernel.org, alexandre.chartre@oracle.com, 
	rppt@kernel.org, steve.wahl@hpe.com, jirislaby@kernel.org, 
	apatel@ventanamicro.com, bvanassche@acm.org, ptsm@linux.microsoft.com, 
	Jonathan.Cameron@huawei.com, beata.michalska@arm.com, xin@zytor.com, 
	davydov-max@yandex-team.ru, ravi.bangoria@amd.com, joel.granados@kernel.org, 
	ffmancera@riseup.net, kprateek.nayak@amd.com, akpm@linux-foundation.org, 
	bhe@redhat.com, brgerst@gmail.com, coxu@redhat.com, dmaluka@chromium.org, 
	linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org, 
	linux-sgx@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, tboot-devel@lists.sourceforge.net, 
	nouveau@lists.freedesktop.org, linux-coco@lists.linux.dev, 
	xen-devel@lists.xenproject.org, Huacai Chen <chenhuacai@loongson.cn>, 
	Zhenghan Cheng <your_email@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 1:19=E2=80=AFPM Juergen Gross <jgross@suse.com> wro=
te:
>
> On 12.06.25 11:32, Zhenghan Cheng wrote:
> > After commit a934a57a42f64a4 ("scripts/misc-check:
> > check missing #include <linux/export.h> when W=3D1")
> > and commit 7d95680d64ac8e836c ("scripts/misc-check:
> > check unnecessary #include <linux/export.h> when W=3D1"),
> > we get some build warnings with W=3D1,such as:
> >
> > arch/x86/coco/sev/core.c: warning: EXPORT_SYMBOL() is used, but #includ=
e <linux/export.h> is missing
> > arch/x86/crypto/aria_aesni_avx2_glue.c: warning: EXPORT_SYMBOL() is use=
d, but #include <linux/export.h> is missing
> > arch/x86/kernel/unwind_orc.c: warning: EXPORT_SYMBOL() is used, but #in=
clude <linux/export.h> is missing
> > arch/x86/kvm/hyperv.c: warning: EXPORT_SYMBOL() is used, but #include <=
linux/export.h> is missing
> > arch/x86/events/intel/core.c: warning: EXPORT_SYMBOL() is not used, but=
 #include <linux/export.h> is present
> > arch/x86/events/zhaoxin/core.c: warning: EXPORT_SYMBOL() is not used, b=
ut #include <linux/export.h> is present
> > arch/x86/kernel/crash.c: warning: EXPORT_SYMBOL() is not used, but #inc=
lude <linux/export.h> is present
> > arch/x86/kernel/devicetree.c: warning: EXPORT_SYMBOL() is not used, but=
 #include <linux/export.h> is present
> >
> > so fix these build warnings for x86.
> >
> > Signed-off-by: "Zhenghan Cheng" <chengzhenghan@uniontech.com>
> > Suggested-by: "Huacai Chen" <chenhuacai@loongson.cn>
>
> For Xen and paravirt:
>
> Acked-by: Juergen Gross <jgross@suse.com>
>
> Your patch is looking a little bit strange, as the list of modified files
> is located between the patch hunks, followed by another "Signed-off-by:".

Indeed.
And at bare minimum please split at least to two:
1) adding export.h;
2) removing export.h.


--=20
With Best Regards,
Andy Shevchenko

