Return-Path: <kvm+bounces-20193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CD1911721
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A62C2B21C23
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 00:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B207EA47;
	Fri, 21 Jun 2024 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Leu36Pp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9A8197
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718928522; cv=none; b=mMu1ylDdNq/2yzURJvVi15ZyAt0j2aBIk+xczjHWPU0Em9Hc0WaXLe2BgZ91p1WlOh/UvfVgCG1iVm4MZNB/ap7Lre49wPRtz2PU+axPJlggc/y85Sx2QLszcAkwHKo5jMjANfuSxXdG3JJ6EkvEIWaMFD/gZgSa7U3tPS388EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718928522; c=relaxed/simple;
	bh=ISBBegW703W66dTNDEhu09uWo2ThDdUCST5ziAh2y3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M63WpjBgj4piUImQ00C+HY8+MM569qD8kuE5LArE7PSv+9SfMXzGXooRFnryZP5OfKXqEclfJtpoRX0UUyqmVN9a7Ec6Y+NImHhg5pzWe761VyEkMakNkh5RPugmceTz/3GkB8AK4qioIapTFotlMi8vB76tb2bG8hsPYAzHd48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Leu36Pp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6e79f0ff303so1254147a12.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 17:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718928521; x=1719533321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b1M0qJ9Mx2uTBhiNLhNcShvhwKtaqNwMToy/ggjAM/w=;
        b=4Leu36PpsFufqH/KMSm69XB/ukO/Ietg1h6Y/tRxm8kq0R3nBFDaSnW/Cn/3ajLuqV
         LHP+1vlmT9nSFw/LfquCZkB1b25EejN0WYiMQxMG3yYSmH+Yms7dSkHvjq1SVLaH3f4E
         y02HGGN/Lwi2EbqbUeBuMfxlyqr4VDhFGys0pVMocRIxNEH/jVQTuV9ZHAamis5f16g3
         7SyfbdGJZ7UUWOIp190tR/HSB8YZrZ48KsA6iOMGd3W5hQSiAi3c9EbMUPiAC30m6pjh
         OMkF1p5PAO7Tw5vEXMFe5q2kbc8Sr9tCanm8rFNYY1XsST3emEd9tCiP4g797swnZCAh
         b37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718928521; x=1719533321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1M0qJ9Mx2uTBhiNLhNcShvhwKtaqNwMToy/ggjAM/w=;
        b=vI305oL4FzqEuJE5+JsNt/iUuyQiyD7S3DVdSFMWbZRDp3npJvpe4rVzyD+6ck9DbX
         3kZG6rKspuVjdO/8lJ8zIs8MYwcroioE8oL6p3mG3KxScDSo/Z3kFkhkaohVseU4M3Dt
         QhiXKdTdASPxM3hZzeVXd2U9zYyxyKGCiPNZWjuNQ7LBmCCVMSrPhLraf+vX52ivLds8
         2pSzevLq/v5Y4zuUvtf4eS4sXVFZ1cyW8FMWo17122HUkFKpJVHmocXOkKKjjIIxHYiM
         c3bO4J3B/x75FPr0uR4PS9LKJomyFYib/JWhB18uY/TLr/edu2x5HyyyRr+r0rq69/oJ
         H92w==
X-Forwarded-Encrypted: i=1; AJvYcCV7ObdB+fk6vcQN7uOMCWAVIwRQsoCzmWkXlnePkEYhZ5gy8LSspbVbhAcqzROJMVciBHsIBZt4+YU+V3vFb2jkv7tD
X-Gm-Message-State: AOJu0YyxQkG1bmjaZHVnXZ0/4ZPFOUqq7QIg/wmeXGkEbLWeXP84PvGI
	CkshK/tJi1j3AmMmVqQVxRA5HPZtnM4yRD9GxAtY5dWO/Ca9QMilnBsKFjl42/ylK3SlVtxL0Ck
	UUw==
X-Google-Smtp-Source: AGHT+IERkxf3MqLsWOQpA9p8rwu/+0akF0lLP5N04RIZQdOzBjFXwegmUeEE1wtq6w6SRKUoxSzmurArdt8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a0:b0:6f9:6bdd:628a with SMTP id
 41be03b00d2f7-710b8610057mr16907a12.9.1718928519519; Thu, 20 Jun 2024
 17:08:39 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:08:37 -0700
In-Reply-To: <20240620193701.374519-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240613060708.11761-1-yan.y.zhao@intel.com> <20240620193701.374519-1-rick.p.edgecombe@intel.com>
Message-ID: <ZnTEhQo2r3Uz9rDY@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: yan.y.zhao@intel.com, dmatlack@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, sagis@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 20, 2024, Rick Edgecombe wrote:
> Force TDX VMs to use the KVM_X86_QUIRK_SLOT_ZAP_ALL behavior.
> 
> TDs cannot use the fast zapping operation to implement memslot deletion for
> a couple reasons:
> 1. KVM cannot zap TDX private PTEs and re-fault them without coordinating

Uber nit, this isn't strictly true, for KVM's definition of "zap" (which is fuzzy
and overloaded).  KVM _could_ zap and re-fault *leaf* PTEs, e.g. BLOCK+UNBLOCK.
It's specifically the full teardown and rebuild of the "fast zap" that doesn't
play nice, as the non-leaf S-EPT entries *must* be preserved due to how the TDX
module does is refcounting.

