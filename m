Return-Path: <kvm+bounces-7773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D6A84644E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 00:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 394741C23565
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 23:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E23F47F4A;
	Thu,  1 Feb 2024 23:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EF5SNwHX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D382647A66
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 23:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706828935; cv=none; b=pAX0IdVo0qXWPv8XFHYQRio6lndknCy1YfExRCMtBFW4R/nOp/nFE6BXD/ZXuT5TfE6GrBHv5ZVbm3kj6/kPX2/c7gsSFdIfKfBjfmIutBQW66U9AsO67BNDIi5thTAmE53k4bklxM2B77ls6TBV9JxBy8qCDrCpBBTKQ/10THE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706828935; c=relaxed/simple;
	bh=M9Rbd1TTFJHpw9s+5sNyKj1m810A0YRxxUYpqz9R2Yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rY9M/AOMCuwakceisFuNUYdxl/JWnbmfRATUecWWkhDGyMHo/ayAJ4vW1OXwhdnyvTmLtpVqKPn4TOHOmxBTMd9WKrHfKC97ARGWlQvvNKSxDZDuSJveEBew77xyyYy4sBLG9zAM07aEI7DJfN6LDhJ33jrJsIGB0fKYm4mqt/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EF5SNwHX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706828932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIys8ywl8dUROimT8NQnX8daI13tCkTHScBncJRrjoE=;
	b=EF5SNwHXsHyj8w1cUWJQfvQTEp+TAlszAGiastjRKxzAl/dozX6Tueab6QmH3w6f28kHLF
	ldnXXshx83lKZsAvuvkba2D6QgfZKR6sxZnYm5KCYIYMvR6aOAZ7z0MPtitQMOXjbmMeWt
	ZlhemX5A1/qP23gcYwLgi+cAQi4eTkQ=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-1C-rObuUN8uIVjaP_aVHFw-1; Thu, 01 Feb 2024 18:08:49 -0500
X-MC-Unique: 1C-rObuUN8uIVjaP_aVHFw-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7cef6c44e40so852686241.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 15:08:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706828929; x=1707433729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIys8ywl8dUROimT8NQnX8daI13tCkTHScBncJRrjoE=;
        b=sz3PUll+Y+6vQZkenfivEA7c2XPy8MLZoRSRV2G+YZxAy2DY2gyGbz8ldQjPnHoY1a
         bqxfbVo8AVHps1AsrvQCYgMUQbt5UE/8wGUXvgf46VPifa8BEMw1e+1CpCiiOJoXGqw3
         pHi/dWXq7tP0vR95JNdcLIWOWEzN/P4Ry317mYaBy3612A+M0gXKETKn5FhFkua7XU4g
         9/DHNA2XbzulDWNauYXOAxtCDIiKsz/NwhoAldvEUDbNMTSp8HljqtdkuZgeaymQLX6A
         pZtcBVd2BwLkVdn6J9oT0SFcJEbEMBj7u3y0RK02rJ7Xh23YFuIMjsNJvW6HDR30aCfO
         vVUg==
X-Gm-Message-State: AOJu0Yztvr26QE5oIxqrA9PWPOOkS+Uep+dqYuZKmXysc83Pl+GsRZ5w
	K9yw26vh/nmQhlPG7TFvdqet2CJxK4s3wyz6gAw7myG738FUu6i0OLLAvTJKrcs8HuZ0bqh5wxF
	3jyF2gsMKlWpcnXMmdGHqyWOqlsB9myOA0wxPsJUvP6LxPDZmbK+RQFzTqs/AX/6XCNX3gFFk6o
	AZmsJBmU8DKFR5CDRYV/xX1WQA
X-Received: by 2002:a05:6102:3bc7:b0:46b:2aa2:a979 with SMTP id a7-20020a0561023bc700b0046b2aa2a979mr5287971vsv.20.1706828929150;
        Thu, 01 Feb 2024 15:08:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH5PMIvH8mlOxCH1g5Ms06GYARDVSWb3KEdt+hQjQ4g1UroC8JkAVJu8a/+TAM7qVlOYKk+QUPlKtsT5+8lyxw=
X-Received: by 2002:a05:6102:3bc7:b0:46b:2aa2:a979 with SMTP id
 a7-20020a0561023bc700b0046b2aa2a979mr5287948vsv.20.1706828928875; Thu, 01 Feb
 2024 15:08:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131230902.1867092-1-pbonzini@redhat.com> <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
In-Reply-To: <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 2 Feb 2024 00:08:36 +0100
Message-ID: <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or TME
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 7:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.com> =
wrote:
> I really wanted get_cpu_address_sizes() to be the one and only spot
> where c->x86_phys_bits is established.  That way, we don't get a bunch
> of code all of the place tweaking it and fighting for who "wins".
> We're not there yet, but the approach in this patch moves it back in the
> wrong direction because it permits the random tweaking of c->x86_phys_bit=
s.

I see your point; one of my earlier attempts added a
->c_detect_mem_encrypt() callback that basically amounted to either
amd_detect_mem_encrypt() or detect_tme(). I bailed out of it mostly
because these functions do more than adjusting phys_bits, and it
seemed arbitrary to call them from get_cpu_address_sizes(). The two
approaches share the idea of centralizing the computation of
x86_phys_bits in get_cpu_address_sizes().

There is unfortunately an important hurdle for your patch, in that
currently the BSP and AP flows are completely different. For the BSP
the flow is ->c_early_init(), then get_cpu_address_sizes(), then again
->c_early_init() called by ->c_init(), then ->c_init(). For APs it is
get_cpu_address_sizes(), then ->c_early_init() called by ->c_init(),
then the rest of ->c_init(). And let's not even look at
->c_identify().

This difference is bad for your patch, because get_cpu_address_sizes()
is called too early to see enc_phys_bits on APs. But it was also
something that fbf6449f84bf didn't take into account, because it left
behind the tentative initialization of x86_*_bits in identify_cpu(),
while removing it from early_identify_cpu().  And

TBH my first reaction after Kirill pointed me to fbf6449f84bf was to
revert it. It's not like the code before was much less of a dumpster
fire, but that commit made the BSP vs. AP mess even worse. But it
fixed a real-world bug and it did remove most of the "first set then
adjust" logic, at least for the BSP, so a revert wasn't on the table
and patch 1 was what came out of it.

I know that in general in Linux we prefer to fix things for good.
Dancing one step behind and two ahead comes with the the risk that you
only do the step behind. But in the end something like this patch 1
would have to be posted for stable branches (and Greg doesn't like
one-off patches), and I am not even sure it's a step behind because it
removes _some_ of the BSP vs. AP differences introduced by
fbf6449f84bf.

In a nutshell: I don't dislike the idea behind your patch, but the
code is just not ready for it.

I can look into cleaning up cpu/common.c though. I'm a natural
procrastinator, it's my kind of thing to embark on a series of 30
patches to clean up 20 years old code...

Paolo

> Could we instead do something more like the (completely untested)
> attached patch?
>
> BTW, I'm pretty sure the WARN_ON() in the patch won't actually work, but
> it'd be nice to work toward a point when it does.
>


