Return-Path: <kvm+bounces-57258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 001DFB52395
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 23:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EE5B1C8017B
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 21:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338153128C1;
	Wed, 10 Sep 2025 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GvSBLOz9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA026B779
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 21:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540307; cv=none; b=HjOMNJYNkbrvXna+/bIMyX0eVxqSLJyhwdX30xSYTxKBjvZEQaLWTsavfSDhCBOOzQzrZSzk/Rd9nVpAeZgaLHVHcm4xO+kFCGl+v+eZSPZKseaDBE7P2o82/Tt7ikmkyNaScTBAJTFknmNcsdtVHgd7woRRsFiUcX8jMCL71TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540307; c=relaxed/simple;
	bh=6DaDvL/XuSmFF6PwAZ0CdJELwsU91MrY1z2UhONW3RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G3V5hHaiUjQWont0QgM+LsdMmZUQmUzWOTMH2Vpi053B9ls7aR5mGwVAv4yzgpzvt6a6TRzKjSzHGqHg3KKDrWUnRI2p7ymt4ylzpea/NuglQTsyNFlGYNuR2DSRa3b8RKGo1BvxrGPmWiEnJgKX4cI35HI3EiM+QmIu50zzUcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GvSBLOz9; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-72e565bf2feso773927b3.3
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 14:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757540305; x=1758145105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MaaI56U+Qkz9tt/DIJEh2ObjQBjcj5gnQOzLQceSgQ=;
        b=GvSBLOz90M1DiBrSOTZuVpHI4n5ZfjC5nbeouyNOW5QJS84CZ+ukj+QW1AAEIcncGc
         S282MNZhywa+YzDQ11YJBZwwZHGxAseEJschx4p1k0WXKRnx891PYeHogC31NZVeL4O6
         br+EUOzqLtcryzC9zMCdKs61s6ElFVUP57R4bAZ9dtpfuTDTr8t6TadhH4XJL17hWhfo
         eoSgeyqtVWxKDbjDFcJXTQLfx2J6mVXuNXK4K8Zff4f/u8hGeSnO5tF3cMsLGmbE4AGX
         EvMNuM7BxiHVCiaw2WIcBhb2zd8OcmGLES920+cqbtaxDG9qn+hfyWAQ6DR3/4QE8HuF
         vM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540305; x=1758145105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MaaI56U+Qkz9tt/DIJEh2ObjQBjcj5gnQOzLQceSgQ=;
        b=URue9yamrD8CtXNrQ7LJcv1J7Q4M9w7e0SkUBj3i6M1GRb5nPhW1y7Flz1hYKPgtGL
         2oyDz28zC79OXYD9xNJYLBkmdi2JSUytTipw5K33UsHFXZd3PRWSKXvc0HpTnTFaUEnZ
         v6NMi9bPZQHe47Q/Q1hTmypPTfbCzc54ffC4FrhEmDDtjEn5Dvqpc57WJRlo/5ueiD2n
         TMtLbGzMyFpxFaNwtwPkGHUDlZjo2iv5IO0wWk9YLCalRAwQ0psQwr1pLoDTqjNt0xWs
         LLwQTG+35BdYTHcP6xWL8ra309HxZOTKTgAc0uG8Shht6qhuQJcdhLchI/He8acFZCCH
         WRKA==
X-Forwarded-Encrypted: i=1; AJvYcCVBl0MqUvh4sltmPT1zh7T/RdUNqC3mxj8CO4b979ahPlpASaUMOt8c6y+PljiratTLNv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvFwCYDLZWFLgDhJ7LZCUUAlYWyRERIUU4ZeASautqVEYObsSe
	3aiKnACi2bDphnzuSyQ2Hi76eK/clTq8uv6oyh2P79X5ah2L6hTDVb+MfMbdiW12pFi9A85jhqe
	LfoSr0r5GjGB4rQCkbLhk6Tkshd+01J4ppYKTRsrny3n3v5WxBSrulhL/
X-Gm-Gg: ASbGnctPRNuIEYCoLtA0APOJqjv+pTWjGZ/4qu3LPnc2iSX+uPMB9bpsEObRAJs13+x
	0gZnJs2uiBvgD6tpPJ1ww6nO4ZUGnSUQ2nU8amrM36spv6MdkOFWN5ARkwFvrICJ2UjeftHucuk
	bNSXIJtPzK09TNyOTtPkDzZ/5twO766vO9EGohZcDolTn3ii8P5peGZ7iFI+AyBaiB/PqoohD0M
	BzKhWIl/IdlX3Q62rcBbhJna8BGx98O/tw1+/pTS6W9SYteLIbU8qY=
X-Google-Smtp-Source: AGHT+IFjiapMVAE+YWMHxZlJO4Ud1KxYzL+3ikt7jridg2d7lUNbKYZUcfty6BWQtgsD9X71GnpbV7xDUb4JUrEqk4c=
X-Received: by 2002:a05:690c:6386:b0:71c:1a46:48d5 with SMTP id
 00721157ae682-727f398b12bmr153355007b3.21.1757540304596; Wed, 10 Sep 2025
 14:38:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902111951.58315-1-kalyazin@amazon.com>
In-Reply-To: <20250902111951.58315-1-kalyazin@amazon.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 10 Sep 2025 14:37:48 -0700
X-Gm-Features: Ac12FXyPcuvcdoqbML0cHm0DtbPsjIcNIYXBwB1dJH4HTbLSLgdFPsEM4rOTfOU
Message-ID: <CADrL8HVEAUdg5eJrU+RveR1+s+9ArdO6wa7EntLQZMu_iwBm-w@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] KVM: guest_memfd: use write for population
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "michael.day@amd.com" <michael.day@amd.com>, 
	"david@redhat.com" <david@redhat.com>, "Roy, Patrick" <roypat@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 4:20=E2=80=AFAM Kalyazin, Nikita <kalyazin@amazon.co=
.uk> wrote:
>
> [ based on kvm/next ]
>
> Implement guest_memfd allocation and population via the write syscall.
> This is useful in non-CoCo use cases where the host can access guest
> memory.  Even though the same can also be achieved via userspace mapping
> and memcpying from userspace, write provides a more performant option
> because it does not need to set page tables and it does not cause a page
> fault for every page like memcpy would.  Note that memcpy cannot be
> accelerated via MADV_POPULATE_WRITE as it is  not supported by
> guest_memfd and relies on GUP.
>
> Populating 512MiB of guest_memfd on a x86 machine:
>  - via memcpy: 436 ms
>  - via write:  202 ms (-54%)

Silly question: can you remind me why this speed-up is important?

Also, I think we can get the same effect as MADV_POPULATE_WRITE just
by making a second VMA for the memory file and reading the first byte
of each page. Is that a viable strategy for your use case?

Seems fine to me to allow write() for guest_memfd anyway. :)

