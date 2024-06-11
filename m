Return-Path: <kvm+bounces-19340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA2C904140
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48C8AB23650
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0654086A;
	Tue, 11 Jun 2024 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ztgaOMwM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537E13BB25
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718123277; cv=none; b=kz9PL6grJrrr3S/cn/ic7v6arOce16V0jidevNAoBxl/sSEk1vDN6HGpjb21hvIzXyqkrbhdmfPrhVe6brOzcTYYaRLKgHctiNv1bBR7AkmFqNDref0V3YLC2fIymyh7C09pzGoUmUAiNet6hWbD0urFhfgZsLdp7XButWm5Vds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718123277; c=relaxed/simple;
	bh=MGp0DQZa5WkAK57TrA5QegfsQz0WdtsMvA+SLqt36t8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eECsjrmsIGTIpUAVJdlD5oXzD24ihDZuqKwFibOtt8O89tRwsz2GpHEQ4RKEfTkIuidKpZSbOMrzpuGR92ziHdW0dyJbCJPL2nkzLx4oSdT6O+Szlp1CVCRWSDuQpKKwL9LkKq06ISlk9PWptop0cYI8O9bfQXrvJuZdvfx3GAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ztgaOMwM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62f3c5f5bf7so4350037b3.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 09:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718123273; x=1718728073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gBtW/SN1QDzI5d7VyA1ik4cNSwUHhHulrBvovSa6A18=;
        b=ztgaOMwMbt0o4QBqLWkG4JkS3Qd9nNuhatvB/h9aC1ShHFelaWEA7iNTBKgcg6zgKz
         mUyawT0kRhuhUuecAdpeHR0Y+z0hi5pFZvAu9BiTj/NOZ99g89BQRdneQf5kIbqA6SYZ
         UTdEMyyO8HIDfb0/me94gLDsTsP92ZVAyQRR6sEjhmo0/XqAiK9PEmO0LN98mtgqQuo8
         QRWWboP8LFE+i1lfA5YfNiCPhIvKsmh6H7imktgEmbSjvRMyyVOM+fQg0U9dPTh62XsL
         EKyLYAYo+oFQNmeD0CibwiRCxnT2hE82heRar6njbCLsLP4iigNC9MwG+3v1Iy8uaC4N
         TKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718123273; x=1718728073;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gBtW/SN1QDzI5d7VyA1ik4cNSwUHhHulrBvovSa6A18=;
        b=xQMQutnPMy1gvVoO9Ch6XtYCaXCblWXD6ADVWc+HGxju5zGLAwXZWkNGQ6mEdc5U0o
         VR9iICxCmz/KKhxCI9JG0WEGN4TR/1iOSB1ujMSjequ4y4IaDuWs/02sNRqpnfG/uUPW
         19aOz+4ucvha64K0hEwkbsEKB+BePrCsgGru7tT3OOk2G1dbymdFB/y7DgN+UybiEACD
         +51oELrgbOWiCIYs5Vtez1nfUW5QI+b4rp6H/wdTN1+PADUiJFUI3+wpK0blrzUf1kLn
         2ydf0ELyHQWPmPm/5X5fNGwrfRzQWyqeFks2T21uLJCil99eFBkfGOfP4I8kmkPmkYNf
         iHbQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0xu6dC4Df2Z9Fms1GEEBL4pVsx5iy0Ot99Y/6W2wguvMInMXGMVYB8Ck4PSBAJPi0BFjPlk5098+V7UAullGw+kor
X-Gm-Message-State: AOJu0YyQaz4uLx2zLB/zrgOTUlGksmwF0nxA5Dj6eTVgAK2jzLMdw3ZA
	tvE3HgnTpW8kvIznvE1IVAZqnVGhvGhSVGp1KvMf5WO3LfcJkMLayEif6LEWtMlSsknMpEyRp6j
	mjA==
X-Google-Smtp-Source: AGHT+IFuhSWhkkj9LM8bxMHFkgYcBA/KjivjCRMjaZYzuBPm7Zi4XO4A5opP2YbmYnoSgdSpD3lgFd2vIpk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6681:b0:62d:48f:30e8 with SMTP id
 00721157ae682-62d048f3220mr19313147b3.1.1718123273373; Tue, 11 Jun 2024
 09:27:53 -0700 (PDT)
Date: Tue, 11 Jun 2024 09:27:51 -0700
In-Reply-To: <171754327022.2778929.14475719898493728460.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231116133628.5976-1-clopez@suse.de> <20240424105616.29596-1-clopez@suse.de>
 <171754327022.2778929.14475719898493728460.b4-ty@google.com>
Message-ID: <Zmh7B4QImxUxMb6F@google.com>
Subject: Re: [PATCH v3] KVM: X86: improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
From: Sean Christopherson <seanjc@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2024, Sean Christopherson wrote:
> On Wed, 24 Apr 2024 12:56:18 +0200, Carlos L=C3=B3pez wrote:
> > Improve the description for the KVM_CAP_X86_BUS_LOCK_EXIT capability,
> > fixing a few typos, grammarm and clarifying the purpose of the ioctl.
> >=20
> >=20
>=20
> Applied to kvm-x86 generic, thanks!
>=20
> [1/1] KVM: X86: improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
>       https://github.com/kvm-x86/linux/commit/d3f673c86c5b

FYI, I moved this to `kvm-x86 misc` to avoid a merge conflict down the road=
.

[1/1] KVM: x86: Improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
      https://github.com/kvm-x86/linux/commit/508f0c7bf6d5

