Return-Path: <kvm+bounces-39418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7114A46FD5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC60316DD47
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BCEBE4F;
	Thu, 27 Feb 2025 00:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GMzf77rB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2925C2C9
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740614834; cv=none; b=AGsKkX+CUoM3U++EG/3CzXp88301D/NN8HBqppooTJfogq0Jhx6NBIQzOnFAlWJ5G4jNr2cCjlY5Ul/U6/nv03qxer+1e0askQtspIhXDOHVjzxmVoi/WCR8mw/UuxZTw41gTIJThZHpcpniw6SeCNIrv1Va5N5H8U4Bpnx4GU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740614834; c=relaxed/simple;
	bh=D4B6RqVqfuec6aEWqbgto8zrx7weWVjEWYYG8bcKNos=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eMQ7CMAQXL/y2jml/fwPWwBx8x+gXc/a9knmrN/+6nOspRpFBE2LeMasFCWnK03FKR04QYRv8nxAH9adluDtOnkT40XpuPO47+bjq3IXJXcHZ8FAtLO4as56e10NGV+8AYxyVty6vFPCT6UQA2ilYdfXLvEC8hL1781jLErfPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GMzf77rB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1eadf5a8so751907a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740614832; x=1741219632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZB0cspd/5m0HkuC6bg4fvEnYSCPsAZu6TqEcbVgoXbE=;
        b=GMzf77rBfEkBcSVKQXtQNuH8KZbiQSBsjybRyXP8LphTpDUPxpOJAa3Ahu56pNGDua
         E66/zFY4gLb8QdFZqcfwhTHJa/VctgoWITrXBJGvCYsck+7jDBaW9oGIwW36t5yC05gJ
         RDMvmbS8S/YKO40VCbk9KI2k1MuZFRP2cwfBlthXxp/4wc/z72lSO/YhEjC5WOrBIzdL
         P6EegLRGY8eSUrXnlFWfZ6VPeLyNJ1JS4l7Bamb4pLG4XIodk/3Mi25g/OyizFw2lMwQ
         BtkobSK9SSv+wokQvnRrhhfQWsZcOy+MqkjSLsiGnbIxwcXYnE55CYQF9++A5I1sTPQP
         1LTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740614832; x=1741219632;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB0cspd/5m0HkuC6bg4fvEnYSCPsAZu6TqEcbVgoXbE=;
        b=ovLEFh66RJXFdpyrHJUPPUL3x63IQQlRcEyieOZ0z3lnpZT9FUr5bPllY3Y8hIZA7w
         btP4dS34edyRz5fXno4Il1tYHJdGC+UaM6gEwTY6tltBQxVXFO0ImOebd7halLyv5sMq
         DZSiBYf4BKAkd62XYuNZRjaf0YvFiy0xmp0ts3sKbz/IFi2r5SMYyTjLvRauK6IKeqby
         BOvro4xuzVHuMDjEIdHMeivcu74yKjcu+Yxh9w21QMqGdpx7422H95SFXQq6PfmTR7zE
         oxStS0X9aRGTMUnzCxG7AzFA+rBFEvpZWAH8+4xyO+VZ3xSRsxK06awtoG6QHIAZaBry
         GjwA==
X-Gm-Message-State: AOJu0YyxQ/dCFkYE4TQFVGXhozdyKMZmC9ZtOX3rwEa7priB0hIao/q0
	8sbY7R1NdF+cmTBuEUXsfSpPGUJoDxbbjPiRW0E4CV5/v+wlmXJnxgX+QDcx9pZTg459IRbrZ2J
	5EQ==
X-Google-Smtp-Source: AGHT+IFLmTwPjgqOOgNnm8DkijtX7ywqc8kVVhHgVPTQV1bQHt+O4eROdoV+XGiIwMC166yJJ+ovnayfhV4=
X-Received: from pjbpa16.prod.google.com ([2002:a17:90b:2650:b0:2fa:1b0c:4150])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d00f:b0:2fa:f8d:65e7
 with SMTP id 98e67ed59e1d1-2fe7e2e105emr8719705a91.2.1740614832182; Wed, 26
 Feb 2025 16:07:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 16:07:03 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227000705.3199706-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: VMX: Clean up EPT_VIOLATIONS_xxx #defines
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nikolay Borisov <nik.borisov@suse.com>, Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="UTF-8"

Nikolay's patch[v1] to drop the ACC_*_BIT defines, plus another patch to
add proper defines for the protection bits instead of piggybacking the
RWX EPT entry defines.

v1: https://lore.kernel.org/all/20250226074151.312588-1-nik.borisov@suse.com

Nikolay Borisov (1):
  KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines

Sean Christopherson (1):
  KVM: nVMX: Decouple EPT RWX bits from EPT Violation protection bits

 arch/x86/include/asm/vmx.h     | 28 ++++++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 3 files changed, 18 insertions(+), 15 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


