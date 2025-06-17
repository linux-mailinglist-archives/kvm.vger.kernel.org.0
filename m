Return-Path: <kvm+bounces-49706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAD5ADCD8D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 378741886F19
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 13:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA53A2C030A;
	Tue, 17 Jun 2025 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x2xryWX9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E2F2E06EE
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167316; cv=none; b=qhk6MEOSDw/CZttLR2jz1Rv80/ocZRh9cfa603qRriAfv1jk8MMrjjQNj4yANXAaU+1GIHqXmjTzCSi0zqnxxAB2d4KIVJE09TorYOHXz8TgpS+4740zomPq8kGeeET4IvffNxYsRchTvSVOrxbU+Uc03zwuGXcLTcf5SB6jnEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167316; c=relaxed/simple;
	bh=3J7LvW5RNqE+39eKEobGL/0umKo2mKcLNR46Sih0jJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ldy4JVREPMovIU0vBGKPoi/2KRPcawg7BAcD0ewRE3M795Cj/dJO0U/yuaCKSlsSyIT7kZGoKcOEIZizaldzvPB661QMSIKK0yNpa1ZbjotYTMN8VVCpOLlNjvh2tw0z3TWXH4xH0sXsqP9V7jgMm+aHrNxXCmbF08hCNIt+Mxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x2xryWX9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748cf01de06so1358226b3a.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 06:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750167314; x=1750772114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uye/GAu8no+PcGbBRYirIpHxbOuu35ESQDvMeTfQe2M=;
        b=x2xryWX9thO0cL1Zb2ZBwabDiMwmHZKAAdW3q1MJcSMeQTKgf9WBuLym9qmIj3dttu
         3+OO70Ls/N2AivX/m+EGzQHjpYTGNfWwNoBbphfpzs8FCE257N2YimciHfTbTBIDZwX9
         UE2PXayRotbeHuIdBS/MHpVb77P8YgB3qr7kNMSTM4hnCDaov+khKqqip+KMqAjMyiL7
         jHFfYqGFh0s4+21y7V4bpv2baQCFt4ULVhnxmBeo/ZlRSmQXaylRsfESkOOcJ40XxflY
         zQfY1SkK8KpOoShenn3OPWz2oPZ0XwrPr71hbN/7Vpq0OLDHvk/+yUt1+GhXAkUw8Gja
         Pygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750167314; x=1750772114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uye/GAu8no+PcGbBRYirIpHxbOuu35ESQDvMeTfQe2M=;
        b=qCvYK6jb5mPKCA0163neYX6Er489PrU+YuTNSNlJqQdS2lphKqcEvaODgP/eZNCIjA
         3+qAO9wP5fgrLEWZMhQk/vKyyKsgeGWiI5ncSbfIzOxOnXvgjRtvsSiJ44ctVGs8E4YC
         9/CoERHcGzKElwCMPYTHQGivBCq36JVJZTouP4XRzyhJzuxsTfTRDYF+aCTVrvbOBGLf
         pvgQqLWkkTaek8RZwSX3H9x5iIglqe+GZnNZFwj6GUt5h9mztx64rkTOnB4ctEe8X+e0
         46Vv/DdGM9fCDa5S/NhrcHDyO8ZKB6uIoznpsyvrE3EeNcKToU4YWD73j8UaEu8HRTYa
         ydAA==
X-Forwarded-Encrypted: i=1; AJvYcCWicBAUHj3oyDpK8HpkyJJWPE5L5lfzO69frrOB55KcxQYL+uKoaYFc27eYGJ4gm2it2zA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZXtl3EuP9O8CESjqssHbbw47XCxaCDMVhAlhWG3ph/MMVh2bA
	J2HjT+UWkngyIIl6ZwTP+zgEEYfVok/X0ZvJWwQiDK+O8lZadQVC4UVz4x4MJ6e2jSJzli4Ki3g
	zvqGbjA==
X-Google-Smtp-Source: AGHT+IHXJ1h76wPXLbi6KROt1OegMIlc8haOhKRalL32tULjTZV4Z0XlghudkokLH2oGGA0km7otLEkOAHI=
X-Received: from pfbef26.prod.google.com ([2002:a05:6a00:2c9a:b0:747:aac7:7c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e8f:b0:740:a879:4f7b
 with SMTP id d2e1a72fcca58-7489d174486mr17495902b3a.18.1750167313834; Tue, 17
 Jun 2025 06:35:13 -0700 (PDT)
Date: Tue, 17 Jun 2025 06:35:12 -0700
In-Reply-To: <20250617073234.1020644-3-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250617073234.1020644-1-xin@zytor.com> <20250617073234.1020644-3-xin@zytor.com>
Message-ID: <aFFvECpO3lBCjo1l@google.com>
Subject: Re: [PATCH v2 2/2] x86/traps: Initialize DR7 by writing its
 architectural reset value
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, pbonzini@redhat.com, peterz@infradead.org, 
	sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com, 
	fenghuay@nvidia.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 17, 2025, Xin Li (Intel) wrote:
> Initialize DR7 by writing its architectural reset value to ensure
> compliance with the specification.

I wouldn't describe this as a "compliance with the specificiation" issue.  To me,
that implies that clearing bit 10 would somehow be in violation of the SDM, and
that's simply not true.  MOV DR7 won't #GP, the CPU (hopefully) won't catch fire,
etc.

The real motiviation is similar to the DR6 fix: if the architecture changes and
the bit is no longer reserved, at which point clearing it could actually have
meaning.  Something like this?

  Always set bit 10, which is reserved to '1', when "clearing" DR7 so as not
  to trigger unanticipated behavior if said bit is ever unreserved, e.g. as
  a feature enabling flag with inverted polarity.

With a tweaked changelog,

Acked-by: Sean Christopherson <seanjc@google.com>

