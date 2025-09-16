Return-Path: <kvm+bounces-57655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 902C5B5895B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40846521F46
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F3C1E5705;
	Tue, 16 Sep 2025 00:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uLsIzofy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF431A8F84
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982503; cv=none; b=Ke1Rnu6W2WWlI8VKkC1DzlaFnFo70UEWHq+p4ugHa9SVzddREUmN7YUz5sHvTh74erxvMmTR5ZpKKuSzS+XSetmlTcsTAe27g4EVm8CDGG77tCDPU91MUr7rmqSh0Bxuy9xgUMKQxAxbLwaNMU3KwucYai969szz3uAlJX5vHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982503; c=relaxed/simple;
	bh=Hzku54Xz8F3o3FaR02WNtbqHu8t/XDsCXNVgraPSj5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mgIyHWhdHSLEafg6vL3WQx+CvA5I5gdjfsSmHHZlczd4PviXoym+GHiUPc+nPGFjGOPEICan+ZAnwfg97Yn60Q02M+NUi2g7RFs0n5ds3qGUy5TwJ3uMsd7RN0zbmQkeiJ4iizDwrw/D2O6+TGYxvTqYDH/EjLMGv4P0yhqf4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uLsIzofy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e3c3e748dso1390176a91.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982501; x=1758587301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7AOkv9hGsWVXFwku0Pf403WUz7STeDqn1uZn/dDK2wQ=;
        b=uLsIzofyDcuExTWu8ZaLXt4dwK8WVlRUKjHb8BCMLT5kqrPVZxN4JQyb1wxG5neC5m
         KzG14cVo9R7DSCgqk7Cy1aU4r8GwXiLpCafc0Do2bdlV+QEufufBAOB+Etsg593HLPOT
         wTPDE7VHvHdd2GY7vxEEmPl4XgovHC7lf8ASM+Y7mr5qF6u1Oh8zQqtwBnhScrzB3OxA
         W9wtRUP+XmdV9lLVdnu6MSalJFe10Pto+z9x8IoCPr+ZyBJOrgsGsB3Aosn2L2zmip5F
         MViWaq8CUvayDKpTY+jfg7arKaTOhzhxc34bCXZEmGyx4J95ZWme+atckTqAvJT2RsoB
         2i5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982501; x=1758587301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7AOkv9hGsWVXFwku0Pf403WUz7STeDqn1uZn/dDK2wQ=;
        b=DfcsVXsQ3CdmfbtlVh8/jWoibCwVSsjzdm0MgmizE/lnd4U1NdAErLqZgJxg3ncUoi
         5CASYFRY7JxWUpO0JgG/5K0vapXpGgeeW+fMMDO6+AVBDEGTDz//ycr81QhtaPjf6Lbs
         q9CVWUQM3v9txV9DBUPxOCIdzb3mJnjgK/bR308qR7MOm6lFiailJrYFiIufpGkCxdo3
         XuKdMsWAmW1oCEbdWsq6IHkxMZDwxDkgzQaB8Kcy1PtgXGD+8FHMGcSzrp/6dhcJCh9o
         UsE94JwuYiqzKs8UUx6Ue8hEGcha+JPMrRnItZbfKw68f60MpbuaOPLXO4byc098AlJL
         ICNg==
X-Forwarded-Encrypted: i=1; AJvYcCUC4U8+lCiIRSLnwrIoEDHxW4tFkJtaR+7SdCCFcE7YQvP/JRvozjrLoIA/AJz1AHzuJGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLZ7vRA2AMtd9syMEpltH1CFGxg0qe4v786cfF6nacPWKcW1fl
	GPFzN9V1aT/shGZUh2yCTQTRXCtfib+Ew/s2/oU7/kqORnFxq1ke044SEwUfHTTKrn+mNjikpUQ
	bNsBz/Q==
X-Google-Smtp-Source: AGHT+IGQDEFWS3Y2K8qFkgjTf02yLfsVnbvTS5K/L5DS3VHz/kmL7yZiceoeOwoC6WZrcEtMLZwCDaXUGjM=
X-Received: from pjbsz5.prod.google.com ([2002:a17:90b:2d45:b0:32b:6136:95b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d06:b0:32d:e780:e9d5
 with SMTP id 98e67ed59e1d1-32de780ec01mr14229784a91.22.1757982500941; Mon, 15
 Sep 2025 17:28:20 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:43 -0700
In-Reply-To: <20250905174736.260694-1-r772577952@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <00378f4c-ac64-459d-a990-6246a29c0ced@infradead.org> <20250905174736.260694-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798208800.624836.165612810420047605.b4-ty@google.com>
Subject: Re: [PATCH v2] Documentation: KVM: Add reference specs for PIT and
 LAPIC ioctls
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, rdunlap@infradead.org, 
	Jiaming Zhang <r772577952@gmail.com>
Cc: corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"

On Sat, 06 Sep 2025 01:47:36 +0800, Jiaming Zhang wrote:
> Thanks for your feedback! I have fixed the grammar and put the full URL on a single line.
> 
> Please let me know if any other changes are needed.
> 
> Thanks,
> Jiaming Zhang
> 
> [...]

Applied to kvm-x86 misc, but only for the PIT documentation update.  The LAPIC
ioctls do muck with state, but unlike the PIT behavior, KVM isn't _just_ strictly
following any spec.  The LDR fixup is arguably KVM honoring the architecture,
but the ID fixups for x2apic_format=false are very much the opposite of what the
architecture says should happen.

I honestly don't know how to document the LAPIC ioctls, or even if it's worth
doing so.  But that's not a reason to hold up the PIT documentations.

[1/1] Documentation: KVM: Add reference specs for PIT and LAPIC ioctls
      https://github.com/kvm-x86/linux/commit/3f0bb03b9db7

--
https://github.com/kvm-x86/linux/tree/next

