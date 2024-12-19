Return-Path: <kvm+bounces-34104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DA99F72D4
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F924168362
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CCC1917E4;
	Thu, 19 Dec 2024 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hk1BbHPu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90122154BE2
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576158; cv=none; b=G2+tUrLbbewEEGif3JORWxkrcCMU8dWDwmR139QMlc3UepAEooT7Lguxn2zo5X3r9Wager5m23yIzc4BtITMez/SmHj8hAke6dCA7xGQxHZ1v4bVtpzUITuFKc+3mwa155eUI0VG/nSUOHT8szCjd1HQEYI3WpV4J4Hy6d2dZ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576158; c=relaxed/simple;
	bh=mkZ0u6SWTPY4JJoMk8tG5k/89MxFYMTlIJXDxFCVnwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pPJ3bhfhM7jKnocuRZIA8u+2JG8hmzkoosqaPdVj36R4wXyDgeI8MwG1oI20+9CbktUw/j3+VIxJYYqSIa8e3+fx4j4vK2LEsmpakuOPPa24uYmwCRy30mSKIJoAfDosmRQPUelT5ZteuFwtGfgB8N+KFke7/2Tiu50153b7X1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hk1BbHPu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efa0eb9dacso301379a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576156; x=1735180956; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inSo0YN7I3MEExclQBFfb2fLRF5NG8nYlQsqP4zBgBE=;
        b=Hk1BbHPu8JecTpeDUuOr6qzih/g75caWesCQ67KafTh6/vzyFE7XlhAlY2Ga4N4eF1
         3J0xkGmD6jpd4y7BXrR/lgEDehA1C6m4iH0W/WxIqQ2A03RgaVmhKUFwIGmJ/gLx5BV7
         Q4n2SIcNMp+JF04w5XcvJNfr8XSmiPVLoDvVTJCFXj8ryBeS8RZrjUKd1/9MTo3n+V9T
         KYXwpDdM4K4tfuNFycQGd4/h5ImC0FgQiU0h+jpfCdZGiyTMbiiqWf84a7vbsbQr0VHa
         2/quh4B/QvNu0GbkNsuZobBrNse/5MOCPPnS1OZEgrJWYendgo+CC4XCyaInDvgtHIyD
         oZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576156; x=1735180956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inSo0YN7I3MEExclQBFfb2fLRF5NG8nYlQsqP4zBgBE=;
        b=bXl7Uppnb5i/iA7yHUE8qcxz9CxxL3O1fGTkZRlUKWDGxZETqC/mKHIP/55sbFD6vT
         +BOjegNEVVt2d0RtiNLYylDKgTYr46WU0vhxBvZZgVWb11OFeDWMOhIWk4QyYZM4YuoD
         Nj4FnL/T+SxtLW2pJwkedsNN0jIMhFEBrVrNIPHhPzJD16Yuctt6TJXQ/QT6r5My0u74
         ecej2Iw6REl9UH2CCLWu62SazKmz5T/CjonA+IWJPDkdJlrAsAjF/x9kVWVRnCBlRVO0
         YhIr0cSRbgeNMph3arak7qEo2duFagx1o6+t0wESnRcrT1KKhMRO0JBZqOtDv8ef9Aea
         DNGw==
X-Forwarded-Encrypted: i=1; AJvYcCUgNkT/ZR47ULfowo5MkJGKev5w4juLyCwD9JrNs7UYqvOhCdosNWpLjdmywjPHUBb64sM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0gSonIOJu353t/+cwlZkUXe0EPL79R8ZuQldNT9MOaPemDBIQ
	vcalKBZeHNQgcogKLDCltSYQLWJIB+fOKC3UWLCSNyItUTrgzJSHIIGcn9/q/pYZw72cf8fP2Oa
	k6g==
X-Google-Smtp-Source: AGHT+IGgyNI38ZwlgDIAr2ykHt4t2LIXowtCbhwRqS4KVYCtUSwcq0gVcQHnUIgrhoiuCYYboXnKzxkMXug=
X-Received: from pjbph13.prod.google.com ([2002:a17:90b:3bcd:b0:2e0:52d7:183e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:1208:b0:2ee:c457:bf83
 with SMTP id 98e67ed59e1d1-2f2e9303915mr7057098a91.19.1734576155912; Wed, 18
 Dec 2024 18:42:35 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:52 -0800
In-Reply-To: <20241108161416.28552-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108161416.28552-1-jgross@suse.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457548294.3295273.9291225231001445569.b4-ty@google.com>
Subject: Re: [PATCH] KVM/x86: add comment to kvm_mmu_do_page_fault()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, Juergen Gross <jgross@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 08 Nov 2024 17:14:16 +0100, Juergen Gross wrote:
> On a first glance it isn't obvious why calling kvm_tdp_page_fault() in
> kvm_mmu_do_page_fault() is special cased, as the general case of using
> an indirect case would result in calling of kvm_tdp_page_fault()
> anyway.
> 
> Add a comment to explain the reason.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM/x86: add comment to kvm_mmu_do_page_fault()
      https://github.com/kvm-x86/linux/commit/2d5faa6a8402

--
https://github.com/kvm-x86/linux/tree/next

