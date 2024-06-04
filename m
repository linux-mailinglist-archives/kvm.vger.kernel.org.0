Return-Path: <kvm+bounces-18826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0618D8FC006
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6173284FA3
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753F814F107;
	Tue,  4 Jun 2024 23:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kTd736y1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5752714EC7A
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544347; cv=none; b=ceTVcoaCaoywlh6Yh8mcmsPrVloDXEW/i3keo5HNKmzRvgSEdroyB8NZRaHxNRuD/V4yzPABc9OmkvLDIItmc6ruXEoIe31NZtDf+czKwCo5yjW3N6Ig7Nflaj6AfnoxPkRvATVPbaceIAyP8r096UD1Qq3rBjhJ9F+BQUjZqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544347; c=relaxed/simple;
	bh=I2egkBqGKFXAPIMQvfXv9SB/zwwKkt5s9K88t6AYrIc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bm4zRUktUb98aG/YjA4lt/KpnvWLpcKqGKsRmPyJdgByUGDjrsrICpzvpU4v/oFzFAK6GGmq/3IMfhZ57MgK5af1msr/HrL8XMR6rIC3OaCzU8nH9FW0PMqeTVKKuHWgQnQesRZ2BjwtfSv9QaK1Jo48FFie2POhQUN9wNH91a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kTd736y1; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfab38b7f6bso2950681276.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544345; x=1718149145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WHOKnJifZW4GIDO6l+Kd5CbPmTJfeJ7PjJotfOF9j+g=;
        b=kTd736y1eJrgEjxBATdy35a2tf5HGbfWh6l/ac7J/zhCfLZo4H/Eum1yi4JAd7Isiz
         AWitL61bKtkeT3FshSTKm9pKAZr5VAunLzQLHu3tCRHEoeow6WdHt/NVvm8xNN4/6km4
         zXKD1R2QHAigFBj6eV+fdulH6xj6qw5+2ZtVWoCJ8ge64vOLgDldO1qUDas3eZQU7pKS
         PRe6F1qxabRixeWkBlubDf58sZ+VrG0Ki0rKukV9ZsbXdsaAc4y1Sbwtpmsg0FKR8WXr
         GoNcJkrNphl5BDW1Xq0MiVt71n2b0Fv/dsUiUwWl2aP9vNpUJvIC/m0aDInBIfFu6Pva
         ljLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544345; x=1718149145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WHOKnJifZW4GIDO6l+Kd5CbPmTJfeJ7PjJotfOF9j+g=;
        b=t6+HwHFjGfOxrewjNPiPmcDjbPPDi00w3orrF3kYHCkzhPAeBCFNVKrARP6mTVbIw+
         yv7lNcIHrSjYoq3KzJkg5JFW75WTOs4JhQRX3g7OuhNRhFxl7ZKjW2leuMTeqI1cf2Z0
         zB3GnI0g5X/S9TkTlCBaLbyXn9jqTAHj7uvcHhnckZ4rtG+fP35e3kIqqAxT/4DmJOF2
         f43MJp2im3Db65+jhSiByE+ef7TGuFH+AnyyJwSQrbrwWuNJzzq7H4KXpqc+d9f5sjBy
         b9Qx5e+AirDebnE5cbqJ/WRByKY8hZIIZto5wMlh4uUpTd1WEoIWksjy/0tI297gNHiD
         H9QQ==
X-Gm-Message-State: AOJu0YzwgzAaW4F/GhZcurpeltJgLwGYQXudT51HCjMWwGjpJ6Rb2my+
	MeU+t7f5SOHutOcUoqwEq9vxcedPRoVndS4VK2un9EZwO0UUxmafbAUAv4x7pf7hDJiD3ErPxzf
	F3Q==
X-Google-Smtp-Source: AGHT+IGKgd2+XqBgcC8fAHGEB7U8aN8Ocvwbqm2fBTnu5hLsEo+mOx22o9d/NqAxKcZ6eH2JY/HmwOaG0YE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b8f:b0:df7:6584:5d6f with SMTP id
 3f1490d57ef6-dfacad1c386mr221837276.13.1717544345459; Tue, 04 Jun 2024
 16:39:05 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:43 -0700
In-Reply-To: <20240509044710.18788-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509044710.18788-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754371158.2780574.8996213522248113234.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: invalid_list not used anymore in mmu_shrink_scan
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Liang Chen <liangchen.linux@gmail.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 09 May 2024 12:47:10 +0800, Liang Chen wrote:
> 'invalid_list' is now gathered in KVM_MMU_ZAP_OLDEST_MMU_PAGES.
> 
> 

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86: invalid_list not used anymore in mmu_shrink_scan
      https://github.com/kvm-x86/linux/commit/4f8973e65fcd

--
https://github.com/kvm-x86/linux/tree/next

