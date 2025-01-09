Return-Path: <kvm+bounces-34944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A08EA080C9
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:49:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61E913A91CF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C891F4293;
	Thu,  9 Jan 2025 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bIxAaGbs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09D51FC7EE
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452104; cv=none; b=gHMu19xcjo05WtuwlUfmp9S4gIh/fFpdCd+GEOXbgST1pWFutzqPd9sDfZIShtBjOLFdFocUQtBuBqaYGXFf1JWCryLOBW4OQvfNZOrDMWPWJl9gKyradGdP+pwCAKAaSF5pUawl6dwCPY+38/zZnE78w/IZg1TuEUmIQmSm+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452104; c=relaxed/simple;
	bh=i3rDKA0F09JEJTZwLo+zdVEcG4ixuVm35C+F41EWN9U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FBUKYiBO2c5hZwbltoI0n89Qz+MABcuLVNnI7x9ySKEQ7IF0q+rrQ71SOfUJL0p6hM1Tvqonatkj8+wztzJOWv0oz5/QwWliSzwFIeF+kxqYXNCMi3KBAhcvKYpaNygr4vQpb0bThODglmOHAA3p4fOMC/E2VPmn2ZbCELMYzMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bIxAaGbs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21640607349so26823825ad.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452102; x=1737056902; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tEYk3UMg30Ej09kAh2ThRZhDb6n/cWhL70JOK9UY+H0=;
        b=bIxAaGbs91iMVDc3ULgyllXc5jGubLz14coJPVlIF3kWpDs3wOfsBCqh1XHi4GTa6p
         LaWYedZ04fMYYp0SVGzkIEOMXrbd6jM6kpK6zvdmByf6rrNousTo2m/bAPaUrrtxuEQ9
         5WptqLkIyh9YRckG64U8Xe9oaso7eK0q02Ux4Lgp4A1UTTblEUEH1CUfP1SW5Ax923k3
         /d+qufQsvSBc3Q8NLq1OO6lqA+goMl3BRARNDhX6OxyXTCQBzKM7faLkHbMrik2vfEYx
         ABrRB4aKukWZoFIYqLGfDeaslo0vPZBrk8FNL3es6pmvywUDkXl2bq8G7uMnk1aIbksR
         vZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452102; x=1737056902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEYk3UMg30Ej09kAh2ThRZhDb6n/cWhL70JOK9UY+H0=;
        b=CgwGNqQWSx2+zfZBKiiQevRV1/jKlYP6cSeFHiKwtkVdtJ7qbasdfJd92ZLQqREu70
         f9UE63u7obbt5CqsxM71CrN4MQ0IS9GHLKQfdAbcWsf1pU2InDTEw/QUMyLH6x3+jQ0D
         eyPT6fkt7i/p9KcjaS32N5Q0oycXk0Al7WgwbVFhjWnayPvEwEJQuS/fI4U2qqH8a1wK
         RfVhgdAZjMikoJ7cB5AnNSdeUWwgy3taYHk5WZGoWkwJY5LsjFViEXUhgGM8ndlzFuuM
         MV3mKcn/nA87JCAGWeH/P/m61TupwmTHePDjkmp1+KZRgzG8XX/FplRpOJBdBw2Ol3Um
         bgoA==
X-Forwarded-Encrypted: i=1; AJvYcCXt27kBNZ9+XrlQNyAPjbxWO3AGPSsotIPMvIGC6ajZzlyExUWVtoyW4EC95sPDkdvSOO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNLU0lP5TYwjh+iIXJi5k0Q+B+WA7pLGTvmWvDwsO+1wNVM+1P
	EgSwOtYeNobVzkzYMT7D/8dt6VXyZVbiFu1LPiZMZ0Om0JaTsA6U7aJD0SrO0BKuO6pRYiQ6cnw
	3BQ==
X-Google-Smtp-Source: AGHT+IEZS3ENK2nghLtlyDpbzxyRo1u1A41iwyMmacck2Wt5ESSVJoxAMFXh7M0PfZVSXCbHm38vIILs4Ck=
X-Received: from plce17.prod.google.com ([2002:a17:902:f1d1:b0:216:1a56:4a31])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db06:b0:216:725c:a12c
 with SMTP id d9443c01a7336-21a83f46a4dmr119296495ad.9.1736452102127; Thu, 09
 Jan 2025 11:48:22 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:11 -0800
In-Reply-To: <898ec01580f6f4af5655805863239d6dce0d3fb3.1734128510.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <898ec01580f6f4af5655805863239d6dce0d3fb3.1734128510.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645119179.885604.11668508135105687384.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add printf attribute to _no_printf()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, shuah@kernel.org, 
	Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 13 Dec 2024 14:30:00 -0800, Reinette Chatre wrote:
> Annotate the KVM selftests' _no_printf() with the printf format attribute
> so that the compiler can help check parameters provided to pr_debug() and
> pr_info() irrespective of DEBUG and QUIET being defined.
> 
> [reinette: move attribute right after storage class, rework changelog]
> 
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Add printf attribute to _no_printf()
      https://github.com/kvm-x86/linux/commit/bd7791078ac2

--
https://github.com/kvm-x86/linux/tree/next

