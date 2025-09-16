Return-Path: <kvm+bounces-57658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1740BB58967
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3F092A017E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029531E32D6;
	Tue, 16 Sep 2025 00:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="05MGnAZw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6AB1AAE28
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982531; cv=none; b=t/5nLo2duFoEY5YJAR5LCygWPM30VfJy/BBhuA9bDILrQv8bUO1sbAOSjNYJbkwpM1qYWvvwlGWf0/2DszoDJElT6KEBc/NsN0lm8C1Poh+UrpdGvcEWMP89pw4K2msxOFPdc+2SbkuFJ9MvlMSW5sQlpwiM2h2Kcv/bT/pODLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982531; c=relaxed/simple;
	bh=4yeYPGN8pSHTwanVQ3V7dK/PcBRy7YVKJP0JkvuBu0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TFqzhax1saVjMMpZu4KYg0TlMwsaohPTehJbJsCkGh+sw5ijEBVyPt++Ch4Hr5WN6ga3zxIxZHOVKKXpmzXoE/Tozs5tS/WNV/tMdbXVq+O22xFNgibP4UNu1Brzid6F+Ubc11sLdRH3qvuE3PXj+B23Ex3limz/AgjwIRcQ4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=05MGnAZw; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-772537d9f4aso3965895b3a.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982529; x=1758587329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mLQhQWWPTEvoPpGjDnptVMA1yifBour/m8dWIjdmwtg=;
        b=05MGnAZwxNxe+8may0keKjZrSKZxaLbb4AEGWd7R93odS1BbK3h/AVBMoBBuXDm0Yv
         hWKCTb4OmtoCug6w6sKTVcm1FHyjMmew9OHS9MQeIjB2yFSMdeF0G8cVrhAO0Ia5CANv
         T4MiBVGMDG2hwXUmH88hHjagj8VWbrBesJLgKHqkqKq6PuSRVhQ6s8COXEKlIo0k06C7
         sOryocKKo0qcNg6sxL/iFxs8Tzi8LXcw4sQAsQeQ+uv44E74v+pCzo2/ulgQ6HBDLxLj
         CVCsrWdBOJRkepWNXPhpHqJvuzY+BxxGllBJ/EGQ9dHCeatqnnN7RX6o5ghU9APzGI2I
         /g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982529; x=1758587329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mLQhQWWPTEvoPpGjDnptVMA1yifBour/m8dWIjdmwtg=;
        b=JhFolJde9GWl0w60O9dC65liM2UUr8jSdvcA6e1Z6vZEBRvjvAyerHsc1CC9oGuJj5
         CvaRkwO4Oe1OkFkmt6+Vkov7PIKkYUEhSYAc0LK2EIIdqlvnXDnqDzBC4yRJoc0tCk99
         b3vttoyt3C9nwIW4w+xMsrs+8fNEzXU1Z06RsLyfZmK/KgqRloFO+FOpNcuqNFf1oqaw
         0p39jDd/mUVI0w+pjnZakN3TAkKGRjXst7m3gutUzaHvapCGsbqyNqW8XpIk7L+V/N9q
         iKKab8v04MH8t51pje5UVZQbxtS8IeOd31RXz0E2J37i9FweMw6P6mEQL2DkGwQo5LM0
         AGxg==
X-Forwarded-Encrypted: i=1; AJvYcCXdfoWJRRYYXIeZnNVxgxO471nV1C2N296Nyu3smulUhxCQRDQgMPNEsviMNbEvnnmbLU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNRYX4pWv2tMNlND/qmAF7qPQ7cUJsgi48zyM968Q3V6pRW8fp
	YeL3PvBXT/MwnodHdWscEnyMd1MqP36NgD1+GA2vebFsvQBsiM2psGgS00wUcKhoOXl2g+xNpvd
	D5PBWuQ==
X-Google-Smtp-Source: AGHT+IGEZLEqi36Po2hL/OtKYWdrIRazCQQYpQ/u1Udr6TP8qicIHenBjNPzJ4WRduhANbjy/ML2E2i0Ces=
X-Received: from pfbcr10.prod.google.com ([2002:a05:6a00:f0a:b0:772:749b:de38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9493:b0:776:1c4c:8d54
 with SMTP id d2e1a72fcca58-7761c4c8f61mr11910277b3a.3.1757982529082; Mon, 15
 Sep 2025 17:28:49 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:49 -0700
In-Reply-To: <20250822070305.26427-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798196007.623278.10358907796048599575.b4-ty@google.com>
Subject: Re: [PATCH v2 0/3] KVM: Fix deadlock for invalid memslots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Yan Zhao <yan.y.zhao@intel.com>
Cc: reinette.chatre@intel.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 22 Aug 2025 15:03:04 +0800, Yan Zhao wrote:
> This series addresses the deadlock issue encountered with invalid memslots
> during prefaulting or TDX private EPT violations.
> 
> Patches 1-2 are the new fixes from Sean.
>             Patch 1 is for the prefaulting case,
>             patch 2 for the TDX private EPT violation case.
> 
> [...]

Applied 1 and 2 to kvm-x86 mmu.  I'll post a proper patch for the selftest once
I figure out what I intended with respect to range.size.

Thanks!

[1/3] KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves memslot during prefault
      https://github.com/kvm-x86/linux/commit/3ccbf6f47098
[2/3] KVM: TDX: Do not retry locally when the retry is caused by invalid memslot
      https://github.com/kvm-x86/linux/commit/2bc2694fe20b

--
https://github.com/kvm-x86/linux/tree/next

