Return-Path: <kvm+bounces-50551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D04AE6FF9
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BD671883A28
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D24A2F0C50;
	Tue, 24 Jun 2025 19:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwT4FBKB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606172EFDBE
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794140; cv=none; b=GEaylEt4S1/SDoXP327aQshmbmuqWYPP+H2Kl42xa3qugh/vuzyli8ZEkx7VGDGhqu1zjHOMo/ltvKAuV7ywoNVMKngj9iwvSVxuc7ZPYMpUPRP/BYwVmLK0NOJgLwaeJelh54r8RQoQbE+YYIOaeVP9WnUUcEdv6E+PeCIlFfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794140; c=relaxed/simple;
	bh=7WnHnjZ2Inj8vNFPOPMWn5vUT1QywHWs7gt7IcDZPtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hpI7ZsM7p6Q7SsiPboXQYQU2zzGrG8G35LGZ29JwhtWscrDWhb/LjQdkbMlMXheRRG2UqgTJuMx7VUYhV3YH2uyW7KOEDgIVMIFeVb6MwnFuVR3+O/ZcW6VRU/VaY0d7TkxqL5ynwIW1zK/nK9aRZ54rj5d+smnu1vhJgLvchPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwT4FBKB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so750921a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794138; x=1751398938; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eiZv+Ux8bnoIxxwKrwVqiL0FOPFJvedVqWOdvOf0LcA=;
        b=JwT4FBKB36u+z9iIrpd2CTptQ40I90Qt+oY7IoccOVgCFZUIQYqi1QMwzVSEH6AbRs
         f4Qe2Dor0nWsqwFOH9EPaiBXrCFW7VcQvWiB8bMMqgF5ycIp49m8SJuoKHmJgPlisBNm
         YsX+LBhAVnxDFgc2dPsSvpCrTCsiLBUK2PMf1OPtYmnQFntHolTK6ylJyr5534JobOA8
         nSmxMdMVqOUIs3GCfxaeyO3DP9jeGK4LBc1ZoAtqMMwHla5xwS9C/ed/w/F4qy1Ybizk
         uq3cfVkj67rIkRbhebAronl0XkAL7AdXSJ9Txyss4Q51iuTOj2CdBm/RnsXXh/tFrs7g
         1ESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794138; x=1751398938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eiZv+Ux8bnoIxxwKrwVqiL0FOPFJvedVqWOdvOf0LcA=;
        b=eEZbTXzfXkOULwyL0qt7QmHgHpU6z4Mg2cOGbB5hQSU7Ayr+I6dP6x0oLOxQ8Iy9Wg
         oram2QWPSs5Gv3pm+XfCvERljQ/SYqogHFVHgLk2ma1u+oCg3LlkrJISs9ENFZKDpf1x
         YIYuuTSGZrr7G5x6AaoEuH6I1aE/D3an8efVWItqKYg2XInUWlpSsl6aJxzmCDgGlSd3
         9nmStUw+ZLS97Goj2ZNfqS3wlNoQv92nZ2sv4TrCEeObnUbZ84fFer801bZhEUq9aGbZ
         O/jx6Vvb2xTWhnR90G95tgRq2B1w7CnWlfO/oc2HG4VIronilSOD7QwF9vCzmq5O3B+P
         qO4g==
X-Forwarded-Encrypted: i=1; AJvYcCWMsDpoGTc2TY2eSkOn4R+ODszrC1MPRvehex/MOyFx3SHtl/KVYvDtVO1I+m77jW8KcTs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+GtwW1SkILItOsW76P/iCKeTIdDlaDlMw07i3DnMfjk6p/960
	2aAN7sN5asHfEG3MZ3kFSQImw2tPEdy4NP3n+0q8dIwQ5G26nfJ6VoaNpB6bhB6lMBH/WBrBabK
	aWLFXPA==
X-Google-Smtp-Source: AGHT+IECMFlbef6lDHwuSpgtWmzJM6Kenqel0iDDnhehUo2TFEdmq9e7oOv+NFpDNFQ4sz1U43MsG6xhPwc=
X-Received: from pjboe18.prod.google.com ([2002:a17:90b:3952:b0:312:f88d:25f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5626:b0:312:1dc9:9f67
 with SMTP id 98e67ed59e1d1-315f26132bcmr173645a91.2.1750794137714; Tue, 24
 Jun 2025 12:42:17 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:41 -0700
In-Reply-To: <20250523181606.568320-1-rk0006818@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523181606.568320-1-rk0006818@gmail.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079223746.515152.1077822979652127877.b4-ty@google.com>
Subject: Re: [PATCH] selftests: kvm: Fix spelling of 'occurrences' in
 sparsebit.c comments
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, skhan@linuxfoundation.org, 
	Rahul Kumar <rk0006818@gmail.com>
Cc: pbonzini@redhat.com, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Fri, 23 May 2025 23:43:52 +0530, Rahul Kumar wrote:
> Corrected two instances of the misspelled word 'occurences' to
> 'occurrences' in comments explaining node invariants in sparsebit.c.
> These comments describe core behavior of the data structure and
> should be clear.
 

Applied to kvm-x86 selftests, thanks!

[1/1] selftests: kvm: Fix spelling of 'occurrences' in sparsebit.c comments
      https://github.com/kvm-x86/linux/commit/30142a93b164

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

