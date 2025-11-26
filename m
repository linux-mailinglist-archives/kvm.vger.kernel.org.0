Return-Path: <kvm+bounces-64582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FF2C87BAF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8810D4E1A5A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8E13090F5;
	Wed, 26 Nov 2025 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nc5c9jp/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE7C306B12
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121500; cv=none; b=SZKpwVWjqQyFkWT2fAtDMbftvYUIoUrWHJlJ8AJVHR6hL2Wm8dFJUU0alvl294g8rAE6W4nH4r5tMr19XrY5d1Q4C5+CSuV4aGpIZyVs9IazVQ+4T/i3+Y9tvMT1JbU+7JKVWtaxFmmTY1TeMoC3elOj1M//HrMs0kg97R/KyRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121500; c=relaxed/simple;
	bh=MmKonfXqSWeVg2HxR8ljDxXJsEiygxxN8larUMR7WRU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MVLCF9NeHCkwm1v5Sl8gJQttahArzaH/75eSyNLw5xG+qvhLatT32yVoA07gSG8eqwxQwa9GJWqpxAuoTz33A2ltUtQ6BfY4O0fK+shMs6MDU8jlKtsGzxdXgDZ0KreNhlGMudhFoQNxvJJi9IkH8JbAauF7/eqfFy3jxzmySKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nc5c9jp/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b8973c4608so18914482b3a.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121498; x=1764726298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmuJezlv4XaPdZVSflXTvywfnKbI7jAOEskGd+2v2bU=;
        b=Nc5c9jp/Q1Y+VCmUd2ecu2itdlshd7px6KmWbBe41pUdsSS+Y8LZ/az1WYSGDsn+jv
         ApQwCdP3Dqyp2Sp/+xwq0GbYav8KoaxlbyusYsib9LhArNNgCh9LOCx+pABCrhr9EMTP
         xENeWlDV9ltN1Ansu3WOAFA8dyBM0a1i2DY/xVFQDNfwrnb0xyPlUjLrZAO+NAONWyH6
         I5bmnbA/q48vtxgeq8q5J1RXbOrzPvuJZW28GyCz+0S986KZigMdXh5epe4ibl7TrAz0
         cjTbry3M8YM3qjQGWjfqspp2W5d+KCPWf2YWhEX6qwnSAPjVWAyD66UcW3QJlT4dWRm4
         lYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121498; x=1764726298;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmuJezlv4XaPdZVSflXTvywfnKbI7jAOEskGd+2v2bU=;
        b=vaRiicCiFSf9VS2t+aPCm++KtJrHFdc45QKXf8ckb4nlA95nmIMZgJKDsGGP2anKXH
         GzDnXbBpQ2+ASMrHy7zT0cIwgLHFwoNaGWL9QOf4iuO/71F3IUc9JTTVPdugJu7Og4tu
         CpC6jll9kuuMamYZMws3sQ4/bZgRIEu70AyvPseX5MIRQ9VDaplTRQqn7r2GO+ro5d6Z
         dHwQu1KnCQDWBRAHrieVGkJogInO0VFvaHbh+p3U6Y7wE+4uz2Ksqx0Z/xyIOdeH35V3
         HU24eqdq94sehei47PLzpaPW768n2oV71d8oEISYFIVw9fZC1pesbZdhWQMG5FD1oAAo
         LB7g==
X-Gm-Message-State: AOJu0YxmOXW/06nat/0+ZuApWmkG0EdFd+qVNlIhnhkDQQPHQUcEAEzy
	YpMEmVnh4IcOJe9MMlad6NiJZZ5VGb5pS2AEv7lK/7e1bl8syGjlPJQD3149x3kkU66uyZwumjT
	CjHvVEw==
X-Google-Smtp-Source: AGHT+IFBucnGMMf0buOHJfuB9mLKVMzimmv4dAaHNASQseA+xWr5tZ+PKZxhVYQCUycrrqIGq1WXpq0PAf8=
X-Received: from pgab65.prod.google.com ([2002:a63:3444:0:b0:bc9:5eff:ecab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9f:b0:342:20f9:98b1
 with SMTP id adf61e73a8af0-3637db7978bmr5274677637.21.1764121498196; Tue, 25
 Nov 2025 17:44:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

I don't think there are any notable anomolies this time around?

The guest_memfd,misc, and svm pulls have conflicts.  Details in the guest_memfd
and svm requests (only the guest_memfd one is non-trivial).

