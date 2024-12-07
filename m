Return-Path: <kvm+bounces-33238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E7E9E7D7B
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 01:28:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49A6A16D829
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 00:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770184C79;
	Sat,  7 Dec 2024 00:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGC9+vZB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1034E22C6CF
	for <kvm@vger.kernel.org>; Sat,  7 Dec 2024 00:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531275; cv=none; b=gHqi+pFetf3NsS9+9JM6I6oains4rtuWjJBmaPSIaGeOqD1GZu/HUm2d33hClvo+IPs7P0Aja6ahduGAvLVIjxlSYC1v0bZwfZlFb5H+EKRva78oIW+Lo9/llAcBLZKaXRnuejj9KxjQpNMsKZ/eHtyQWmrdByjTKXopmpDC/9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531275; c=relaxed/simple;
	bh=HDiTD71cqWDmXF0EB3u4x3BdN5QWqMcnruc9oR5hxjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yv+RFBAXsRjBedYnUBq1m1lKUEWXqLwdJpOcAffzTP8285yCmPGxeQSV6MEbgmBFJ5YD5wfzY7kUc5vYag8OR+htFXWDFLmoPxQD5DLLTWiyoB0lKRab8frwCDduNIcUvhvgtpcFGeViaSdOlPAd5fYwn3M3rGoZzNu0CMDXJWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGC9+vZB; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa62f1d2b21so298265566b.1
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 16:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733531272; x=1734136072; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RTfrwgPcpoHCXEKAVJ5Gd9meGKlJ3WwJtdjkvqdBBtc=;
        b=vGC9+vZBxv/Gtj0Y3DrdJgVccxR1ixxfvl+x50HuplKr0kQtgX11EM9JfnloQdFRCf
         sl7OUgxzYJibs7hVJTxWXPk1we9I5iIa73r2NCBrhIJU97W1S4v9MW1TGNwsOvkuvhTX
         HT8j/7QUB0yuf/AFXt61pKkzrALUxynoTBGgZwSkL/alW6Bjn7CAxr9+hyzn4qY22Dgy
         NFpJBMASaqS6395HD8MTZe+q417tn8ifD5T9mmherEqK/se1RkqiT99cp1nxxKcyfsgQ
         8XX5ARcNVN4kSMaeA9ZWgIrroHqvl/uIFb7GKY33zwphk/nAQA0dXm35y/+QibaOGpRo
         q4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733531272; x=1734136072;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RTfrwgPcpoHCXEKAVJ5Gd9meGKlJ3WwJtdjkvqdBBtc=;
        b=GyJ5v+pnzVwGnamziVG37X5Afeivm3FzS8d9BTra3szQ9NDsmYFrRPnBs3niyV5WtY
         jYyU3ZYHV4bBe3UbZvnfA8bxAQzQy9puPEA79/NMliwwBRFavHlz8v6UvezyGksQaUUD
         DtoCxiRB3vR9v8HLH2Dr3PGaumwobUvtPijNlERQYnIlVAq4GEBiXPVcqVmhyppmJ/0p
         Um0XybDefrcIoltGHDSwz9AYwV5bWFD8D1fO6eDhp5LEUNOl76QoIEO+q3gBhdJCI1s0
         Wzi3h+VuLt8TiFducS5ABGoPSvnWP5xtkJucM+LBru5lAg5nZLFP7HW1a3p1wO4RgHYM
         j4aA==
X-Forwarded-Encrypted: i=1; AJvYcCWXURcrvo2D6nZO8tcmSQLasDq8Y2WcHHOsLG73ABZ0ah5elL3+fleTUd5sw/7dgfM96Gw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFzZtTyBj6gQFFgjhJIJy/HVpZUmcDd60HmOw5KoFiMYgGzxI0
	ZDor6kfQZDrJ45OHAULz+HGpRSXL/J4Lzy1pM26sMqKAWUn7uhL7TEA/CUcmaZnO51XmJ5NrOSL
	/DDHU/dsbI4sSuXVJfzvoifUE008DyKPCm423
X-Gm-Gg: ASbGncugQOaLJz9hqQ27N+Ai1esdXrp5NlVbWooxEUJVJM6oXWWjLql0Ka0VqTsKo1K
	jiyEkxTkaM8BVVi62x3v4YNUsWQ6SKVo=
X-Google-Smtp-Source: AGHT+IGzJ5Ke/Qt6cMillUqq3xL/DpUwLfu70bGkQYSeVqx4Updorm9nDhkBlTBwgTkSILEBYgCY+kqHOfJEu1fAU50=
X-Received: by 2002:a17:907:774b:b0:aa5:2ef2:58bb with SMTP id
 a640c23a62f3a-aa639bf9d65mr352823466b.0.1733531272316; Fri, 06 Dec 2024
 16:27:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203090045.942078-1-nikunj@amd.com> <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local> <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local> <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
 <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
In-Reply-To: <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 6 Dec 2024 16:27:40 -0800
X-Gm-Features: AZHOrDl3SpW2yUOE4NnqTw6drUgFtOkKUmQITX9vdhNNtxkNKTbrn8zbUmF7UeE
Message-ID: <CAAH4kHb-qoBtUxPiNtFsBFFQdh+5mx2z0F32KrkFycgc-S45Rg@mail.gmail.com>
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

>
> Well, it is unlocked_ioctl() and snp_guest_ioctl() is not taking any locks.
> What's stopping anyone from writing a nasty little program which hammers the
> sev-guest on the ioctl interface until the OOM killer activates?
>

Given sev-guest requires heightened privileges, can we not assume a
reasonable user space? I thought that was an organizing principle.

> IOW, this should probably remain _ACCOUNT AFAICT.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
>


-- 
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

