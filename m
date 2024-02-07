Return-Path: <kvm+bounces-8200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A5184C385
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 05:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E48CB1C252B5
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 04:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37F312B95;
	Wed,  7 Feb 2024 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ntYdyWVP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2E134B0
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 04:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707279731; cv=none; b=rO+ud+6Qg9ig3jzKmhnvDsYWn3HkpeVkKq4L20FRPCoCFCZuMioW5d51hm5Rc2RlUg4Dm3H0azVdQjcI3OWtDCc+1lLarLlMC54jFNuaTQ3W6EmfkuZEmkJ1SIAF+tjmQWzxFtxvqbqY+mTTUGIBL8/tcBnDRKWLIrj2dMLc0xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707279731; c=relaxed/simple;
	bh=9VS6dX3vejT17HLI0RS4sbhWiyTVkZ69bwjNPvcSZcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ju/SvtvNdheleEhrh2onyaswOV54BnJNPBZHS9yWFJT+IR2WRxnAgkamZkEQ4uF1W+828Uq7CgIF/CyUDOzUSOlJAni/ooAGt8N1QUOJ06NyH2/9M3RYOEe4gwg+IS8ReAznaMFwgbPLUm1aDALUDJhS545K5CUcP/y4/CI+5S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ntYdyWVP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d94eeacec4so2555535ad.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 20:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707279729; x=1707884529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UIV0mbrXPEMDte4kg2qFs+Leb8e4ZrEXg++2dGUvO/A=;
        b=ntYdyWVP1MEfLcLN8EE/MIxLKwMBZqR1xdEHoyGZRtJodODpZhd2iSw/16BBjyumg7
         aA4slRjThGELC5a4VqIJNofYhuthfOhFfUxYDQsleb9N76Ogb8d+WktjY8AY+kMdALuG
         W6862Nwb1w8vIBiHFJmT3Sh/YJDIAre09ukjr4lciSsjma12sAy9ieOK1HFuHGsgOD1u
         uX3jJk4qxqNSx0DG2TdokCR90NuoVGLvbzSIu/gpxUKM1fmm8/jrYNW4HTaAi5oZUwOE
         tAyBLfJjRH7m9pTq3rx3snImAMEEOQcbdNWlHMpN4+PS1OLTuBIxQxmhGnDeJPCtEdhO
         /ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707279729; x=1707884529;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UIV0mbrXPEMDte4kg2qFs+Leb8e4ZrEXg++2dGUvO/A=;
        b=vuthAU40PSh4Bujnyq1hrAj+nihErXhStB02kWfikq4WFHfp+oMLX0v8tYu6/VmbSf
         vP3/9kYd9Wdlaj43qKV94B7iojmC+WLz5VTt6fyXB3L1RrkkkjmzD2+K/puXKAV8eSND
         ESLsVtkbA+0+MRZbIPU9cjkKd+HS8k4Z2rvlBHWeVlq+DybioJucLbm0aqSN5nlKh8VB
         EEYM1dxXvv6QN8NpgI2xqOPHv0xy8GSy9MdSYeszWwNHlBpaEm6jXoAjXYMKKttzqbbU
         3jd5C2VQsW3Pth9KuyCxGa7h8P7InTUq6jPaD3jDLzHF8ncMTJq3DWqH5Yn/JEKmduu1
         kECQ==
X-Gm-Message-State: AOJu0YxCfWOIswajZ884kXXt16iMJ9tDs4+MbOajvJihzk5MzN+AtXNG
	731+1ZkLAuE0r8D8e7kJhEebzVkA0NgiEC5Vlz/hL5IMqIKuHdjuE66RllvwARpHUP/hoaaq9Ej
	yBA==
X-Google-Smtp-Source: AGHT+IF2jG6kLrMaPXZQm1JXIhdeLR4SvrnjVMMzjgLIFlT89OV2ZEWImiADQAmkUtay2rkJDPFqiz5yycw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f90d:b0:1d9:5928:6895 with SMTP id
 kw13-20020a170902f90d00b001d959286895mr9675plb.5.1707279729156; Tue, 06 Feb
 2024 20:22:09 -0800 (PST)
Date: Tue, 6 Feb 2024 20:22:07 -0800
In-Reply-To: <20240115125707.1183-19-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <20240115125707.1183-19-paul@xen.org>
Message-ID: <ZcMFb1epchA7Mbzo@google.com>
Subject: Re: [PATCH v12 18/20] KVM: pfncache: check the need for invalidation
 under read lock first
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 15, 2024, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Taking a write lock on a pfncache will be disruptive if the cache is

*Unnecessarily* taking a write lock.  Please save readers a bit of brain power
and explain that this is beneificial when there are _unrelated_ invalidation.

> heavily used (which only requires a read lock). Hence, in the MMU notifier
> callback, take read locks on caches to check for a match; only taking a
> write lock to actually perform an invalidation (after a another check).

This doesn't have any dependency on this series, does it?  I.e. this should be
posted separately, and preferably with some performance data.  Not having data
isn't a sticking point, but it would be nice to verify that this isn't a
pointless optimization.

