Return-Path: <kvm+bounces-59055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCFEBAAE75
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 03:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78DAB189F66E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 01:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1A81DE3B5;
	Tue, 30 Sep 2025 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qaQSZlu/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1ED7262B
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759196334; cv=none; b=OuBZeVXID0hyiTrEms4pBH3Go4qRgOff+alAKVYUOgOTvmfg2zxV9iYdbR2LVixpWPEyv0hhatKkeD2yjSRjfylImQbYZNuDiS0KZmFdlA14SjsUSQkPN3po1pnetngsfcgsrkZq+2ih7lCKEUhwowW2lj+KYMLR65J6f7s+XYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759196334; c=relaxed/simple;
	bh=nWOQMxALYjZ/81CKpWgB0zw/OiqlRiK/jjvfmMmg9Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RnA4ca8bCeBCy8Rlw88OLAwz/MHK0xLduHiHKFOJKJAtxTczhlzlRBAGAGUxR7nFo42D3vJLSA2wKVEYYKbvmIx8R62fYXXwSdEvp4R36dNWeFsaTJ8bpvnyHaCAuoBJkUP9Q7k1sk3KVGn/3vy9tAwkf6SQ72v8lArDL970kXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qaQSZlu/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2681645b7b6so55595ad.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759196332; x=1759801132; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvsTnrYljJ5JHLWdRhPEvYrX+qVXSGHHyB6OOJomt4w=;
        b=qaQSZlu/hpmZi5BqiVHO6vHlabTEkKxeYGr+mCMDHUzgRkNB/UC2C5Zp4qBcTZhhTT
         +cUfExC3ZArJQg2JhnH73UWE79DB11urUu3wmfEdatO6u3tgHeEJLU6v3RBoQU6OZAW6
         AhU8+d5FmSf95TbbKZsR8dPFtUJCgWw9YopKTMf/j401fl5UV60eC46NjwE3qFBEMMni
         435IVvdoHfZzlA+AUwo2FJhrftf6cfiB1LCtI4Vs/T26YKM66m/TmcJIZcDYe8mxGbps
         n12mRmF10CgubTstNTaZvj2imvJDvnilQSgeoZK1mFAEljJW9ri/jvs6Pv7aGIWC613q
         clbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759196332; x=1759801132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvsTnrYljJ5JHLWdRhPEvYrX+qVXSGHHyB6OOJomt4w=;
        b=VXhdmDYdxJhxo4RLjtGCgcZlsH0CBo/SInT/0Gezis+fcOIyqbtjvg5uYMb1JCdIgU
         FTDUuhc2V+D54f/mvzDPwzBZ8pUBxUjzEQhJWzMWWbXpuS4ZLlbc9kiSJekMRuzB5Jbv
         t87jTLxBhhuHaRz91Nl3tey/1OQljs072pqKhS6LyFr+nSXOEEly79/PWWtbhRUi5u/B
         CgJXYXNy7TRET3nlB3OkvqQgQz1XHme7K4tc+KBLPNUJUSq9pqG++E35nNloxCy1J+Za
         Jsc1PCK535flLyVlhHg0izEj9ciVU3ndtyg53w/ilmvAwS2MJfJWfZvhFw0W3WHQCAiL
         wb8w==
X-Forwarded-Encrypted: i=1; AJvYcCUhHQxqHnjDQgUYe2YWvcQrzACCX5x3+DKGIRNf3MHrRDzPKvbGevcBEw7dFYJlE1n3TWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxasoAhRKZYePBLFxISLHTchfBYHNBRKg1nmotWW871lUm0jsIX
	Y3K0l235sTanzqDABPHeQ6K1/8L9d+Kh3a7FBpLaHPPwzqtPiGnNNGF488nsuICfGLpQyKcobvQ
	5s3pR5Z7eHi4hEtsz0ANoYInzzcYnaZa202UQnxV5
X-Gm-Gg: ASbGncvYGADnvHQfjHSFLBrKTM+RlV+th+rY++NE+LsizSHF58FzXHVU9xgI3ZKF4Vq
	JPEJFJXCMW7jtHKOCvLXCncO22K5zkATVIpDq6rYui5Uw8t7vOj8dFvcK5GDFoqXYe83uB3dkKv
	19yIWy1O5IfIrL3TDfJZX5sehyx9B8b0U8fwiRcEuWn41f02EP8F8JSKWrF2ljjsMMR0oeC//mm
	0B0Eh1mCT5lHB796se+YVSn+xS9ZwM74lepN3XPCORJWTcTW8JjKfnGtmpA1J1x6y6VFS2c4ffX
	fkXPWA==
X-Google-Smtp-Source: AGHT+IFRUnyPhSMPNjI79KwIlrRZjLanCbGDCxLiI481tlToOgQnS27SsZl3/cZlRhV0nT6XIeRduT2LMz8U5zVsfWs=
X-Received: by 2002:a17:903:2c07:b0:264:1805:df20 with SMTP id
 d9443c01a7336-28e147eab98mr2702435ad.4.1759196331453; Mon, 29 Sep 2025
 18:38:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com> <20250901160930.1785244-5-pbonzini@redhat.com>
In-Reply-To: <20250901160930.1785244-5-pbonzini@redhat.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 29 Sep 2025 18:38:38 -0700
X-Gm-Features: AS18NWDptFI2tg5bw6yX--f9wXVSxmOrxFBszvGTpo3cjvwvt-8X4CEfhFCQrHA
Message-ID: <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dave.hansen@intel.com, 
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, 
	hpa@zytor.com, thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, kai.huang@intel.com, 
	seanjc@google.com, reinette.chatre@intel.com, isaku.yamahata@intel.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com, 
	chao.gao@intel.com, sagis@google.com, farrah.chen@intel.com, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 9:11=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Kai Huang <kai.huang@intel.com>
>
> Some early TDX-capable platforms have an erratum: A kernel partial
> write (a write transaction of less than cacheline lands at memory
> controller) to TDX private memory poisons that memory, and a subsequent
> read triggers a machine check.
>
> On those platforms, the old kernel must reset TDX private memory before
> jumping to the new kernel, otherwise the new kernel may see unexpected
> machine check.  Currently the kernel doesn't track which page is a TDX
> private page.  For simplicity just fail kexec/kdump for those platforms.

Google has a usecase that needs host kdump support on SPR/EMR
platforms. Disabling kdump disables the host's ability to dump very
critical information on host crashes altogether. Is Intel working on
enabling kdump support for platforms with the erratum?

