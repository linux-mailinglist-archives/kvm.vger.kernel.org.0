Return-Path: <kvm+bounces-18955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5798FD993
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 00:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53FAC1C22765
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 22:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60A915F400;
	Wed,  5 Jun 2024 22:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="HMW85yAd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E71015534B
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625125; cv=none; b=iqrLLy5Z11+ffMBa9Zjk1BmNPfmSdIg4kKhLtD2qfWf/lILPQau1sXamEhH9JAo1ZLxYdjxZq21RY0FgCGwaHk4WsX31+FgGxH1lBfHDsTBS0DAGxDbl7y5SPceQNiAqaaFIFMown6VJvmVuXCJaDfVT/vKVnTRuzKHSA4yDV9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625125; c=relaxed/simple;
	bh=VXiKVO9e4P4N1SnJn5iardF/LKDRgDCRLUDqbkoy9sw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D5e56mS3TSPIqz+6y7df7GwvvCG44P8Qe5TnijHQeeji9uiDECuLBYBvazlQmDD6VpZ/Fwo2jXo0+et5qw3ELKpd0kh/oFC2GKH+U7TTPlF+P9RH78yo3jgCrQ7LCN14Canlmehn8NM9kW+nGvJBmWi3HmFyFOQss6Sv6Pw7lDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=HMW85yAd; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a68c2915d99so27334766b.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1717625122; x=1718229922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NravZHhm0FQ9QhnoX2qMEJGU+bgz7fGWZuB81+3B5uc=;
        b=HMW85yAdWRIokMo6XSlkzSCX3aGuy2xrtPLp9Q92PwF7gCIIHNJAMCDNniWMpWGEVP
         K6To1SwtiYixqu6EIm2wKDi7VYyK4y1nSCpkaEaoMq4uvyfm2ST8Bt+j19l5KPJo1DlA
         WR7lHXyDESZrGT6LcJbAUEW677pQSAFqt5+Trqi1Ui5HZxG/kOL1KeDwffz4gTh+tklu
         JfPMwY2tTwTJXenrsqlBHA1XFzf5vLjftfwgZ3CzgH/tvGq5X50uNKydzXTUX9FI7q/n
         TB2ks15BsMragd++Kl8llDwf3xK8L+2R/gYgwLKzhl65mWe/t7dP38upy/dAmkJNyTCR
         c/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717625122; x=1718229922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NravZHhm0FQ9QhnoX2qMEJGU+bgz7fGWZuB81+3B5uc=;
        b=il7cB8Mlrmf1kgR7IajLmGI6vmCapseSar9h8MhD/d1s9727g00nn+mqz+4nKRWdkF
         qdIzc/RDtyT1mYHEanMPPG1muefUQf5TlNVVYyWhht/U9kcADAHXx2dWbB1ctUp+RlFM
         R8pr++c6+1Z1RYTU0qEVxR5pR+O+a6msOjQ5giXIJCAYtQS1DREItyL4k3R5oYySS8qA
         WKw4DuzaFnM25OwPhLZjue1RB6jPC585caUY27/YF7dWoKeMDiclxmS/ubmvrw0ym/h/
         54ZQpbpWpBnlpjYgKeSHfSv6w5wimBf21pdvX4nM/jqrT48igVQXOUAbUmjBI6q1FyMo
         nJwQ==
X-Gm-Message-State: AOJu0YwsZH5/fjQI7zlTa7TkWefTwX+yeJlbV5GauE7SLtTAGrgaae1f
	6uHiQkRxM2WWOJFeXLMAGq9QwkP0MyPzfD225BokpRMMUUIz4ZsntsId+poCq2E=
X-Google-Smtp-Source: AGHT+IHw7BSLBBAbKRq5inPmxPPiYJ1u1uESgLvDJ0oDfn0OmbUho5AdytUcSybHPpE5KVK7lCrwMQ==
X-Received: by 2002:a17:906:7b87:b0:a68:bb1b:4de2 with SMTP id a640c23a62f3a-a699f3626fdmr253779066b.3.1717625121556;
        Wed, 05 Jun 2024 15:05:21 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af09bc00454dac98c3a8ddbc.dip0.t-ipconnect.de. [2003:f6:af09:bc00:454d:ac98:c3a8:ddbc])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68f56506dcsm574559866b.57.2024.06.05.15.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 15:05:21 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 0/2] KVM: Reject vCPU IDs above 2^32
Date: Thu,  6 Jun 2024 00:05:02 +0200
Message-Id: <20240605220504.2941958-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vCPU IDs above 2^32 are currently not rejected as invalid for
KVM_CREATE_VCPU.

Below patches fix this and add a selftest for it.

Please apply!

Thanks,
Mathias

Mathias Krause (2):
  KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
  KVM: selftests: Test vCPU IDs above 2^32

 .../selftests/kvm/x86_64/max_vcpuid_cap_test.c        | 11 ++++++++++-
 virt/kvm/kvm_main.c                                   |  2 +-
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.30.2


