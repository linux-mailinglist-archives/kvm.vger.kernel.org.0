Return-Path: <kvm+bounces-10842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB798711C2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 01:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B2F71F23C03
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 00:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FFE4A1B;
	Tue,  5 Mar 2024 00:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K39hEweP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF347F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 00:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709598947; cv=none; b=F6xTO6ZSSIisMJ05W/573RuUPa9ebjbM2Kpi78fT69/MO3wZCgep0VWcVGMFCEjlygZECgKUHxTv/iPPmKCIxR01YNVf7YAZ0OMIJn+FpkrGcpOKeFfr7ItJnPbLf6k9n9OkZ6JZyVYtGra1YxGI+Tz8VmmJ8qsjpk05JT2uGDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709598947; c=relaxed/simple;
	bh=nz2uwfTR8sf65a1ZD2zIjGYWkZpb+xRs7KEpe80VU1I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cCTg0qpRDch8CMDbZGP2c5avumsDEkAcfrCDgPtpRID1IAmaJCVZpmeVEIzMw+tdNbPpkLUNFcjRczRr7fjg8LXUt9XjeZWhsp3IGfFkDL9U/8d/NYQSoTVxcqcclvlcFZjgZaizB3zDg3wHR6KsWyUXwzwVC8qCu0RUIA/TUNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K39hEweP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bcf739e5so113751a12.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 16:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709598945; x=1710203745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFvdt/4tnpJSxljtGoomCVbep7+Yys+l9WxGlfhAn90=;
        b=K39hEweP0bEh0geEhf6nAI7yaAPhFLcUOIwG4dDBP+j942AAOWLG72pqfEmpePh3Kv
         6wVeDqrIUa1yyh/hRCGpKMQVR8FpaXSC1UXBliYjwbsMLlfUTKZ3zBmvyYjvbs4bCMdA
         zqbJ6iw9TMypwCjVaxdZ/kOYoVJ3YjOy0bQV4WYtykYyaZJWN7Mh+HUoYiAQuxUQpnt6
         ZRo6pio3Y64PtpOCdYvHykySFX7kVX/xHIpCBSWQajwZQj/qftE8nKDxQbP7r70B2f10
         kByUsNkSi9ERicttCt/fHoTzXQ4VhVvVpx9Ma7QvEPYxwQn8vOcMo75XZlNNsjnd6GPu
         hxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709598945; x=1710203745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kFvdt/4tnpJSxljtGoomCVbep7+Yys+l9WxGlfhAn90=;
        b=bk5/0/oioRPhtp1eCwruJ7dh3/NaeobSeONWQliC5rEmnJ1d1IcYnGy3I9jZcfNC5b
         WJXunuiIyTgkLXlBke+/MEd1C1K5VEdxCx9NlwzFIZIjFDJrtCjtLBsQsI1BSxu6x65P
         xgP52T30cYmz77EEV+IKXJNfKWhcBIQn5Irjx9kkjJ1BTx5V9AVhLI4qtHxcuUgNWRSI
         /zimg1IWZGQxTzBVCbhH6ftHNYHljz4q7SXUCpgXlF/gvZ5vcdlaQzpYfEPm9crOQHYd
         +SfUItczQTK0/KhXZH3qrJaILYQ8moAil2VOQJ+4qfwMi5v/34mL165Ws2RuaLEDyYAc
         B08Q==
X-Forwarded-Encrypted: i=1; AJvYcCXTAfFtSuVWPOiqIR1IeIv9tr0cPqs7k8sa69JWn3mwUR33mU5e3Zz/m4X2jL1a+YuiaPGmcKhv2u7Xevil+l7OlZWi
X-Gm-Message-State: AOJu0YzxXJc53qOibXCjXxrwAA5xDysIBc4jxhufxPnxDq+ieKGZhne6
	1Orvuf8KM/6fGQq7H9EWe6PC0FZYqb2MZ/EhnFIvnZqI2tedc4PmNhG8ReSmTJbA7IRep1nYgbz
	FEA==
X-Google-Smtp-Source: AGHT+IFi935yC1blv5rbR4g4qsYXLK/qNY3UJ+evQs8kWTCmFNIEwbILtRtCAfCFK09jqlz1tb13YRaXics=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ef14:0:b0:5d8:be12:fa64 with SMTP id
 u20-20020a63ef14000000b005d8be12fa64mr25264pgh.0.1709598945151; Mon, 04 Mar
 2024 16:35:45 -0800 (PST)
Date: Mon,  4 Mar 2024 16:35:29 -0800
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227115648.3104-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170959827445.241146.17036420374400264270.b4-ty@google.com>
Subject: Re: [PATCH v2 0/8] KVM: x86/xen updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="utf-8"

On Tue, 27 Feb 2024 11:49:14 +0000, David Woodhouse wrote:
> These apply to the kvm-x86/xen tree.
> 
> First, deal with the awful brokenness of the KVM clock, and its systemic
> drift especially when TSC scaling is used. This is a bit of a workaround
> for Xen timers where it hurts *most*, but it's actually easier in this
> case because there is a vCPU (and associated PV clock information) to
> use for the scaling. A better fix for __get_kvmclock() is in the works,
> but there's an enormous yak to shave there because there are so many
> interrelated bugs in the TSC and timekeeping code.
> 
> [...]

Applied 1-5 to kvm-x86 xen.  Please take a look and test the result (patches 1
and 4 in particular).  I didn't _intend_ to make any functional changes outside
of fixing up the unlock goof, but I'd greatly appreciate extra eyeballs,
especially this close to the merge window.

Oh, and can you look at v2[*] of Vitaly's fixes for xen_shinfo_test?  I'd like
to get that applied soonish (I see intermittent failures), but I'm nowhere near
competent enough with clocks to give it a proper review.

Thanks!

[*] https://lore.kernel.org/all/20240206151950.31174-1-vkuznets@redhat.com


[1/8] KVM: x86/xen: improve accuracy of Xen timers
      https://github.com/kvm-x86/linux/commit/451a707813ae
[2/8] KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
      https://github.com/kvm-x86/linux/commit/8e62bf2bfa46
[3/8] KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
      https://github.com/kvm-x86/linux/commit/66e3cf729b1e
[4/8] KVM: pfncache: simplify locking and make more self-contained
      https://github.com/kvm-x86/linux/commit/6addfcf27139
[5/8] KVM: x86/xen: fix recursive deadlock in timer injection
      https://github.com/kvm-x86/linux/commit/7a36d680658b
[6/8] KVM: x86/xen: split up kvm_xen_set_evtchn_fast()
      (not applied)
[7/8] KVM: x86/xen: avoid blocking in hardirq context in kvm_xen_set_evtchn_fast()
      (not applied)
[8/8] KVM: pfncache: clean up rwlock abuse
      (not applied)

--
https://github.com/kvm-x86/linux/tree/next

