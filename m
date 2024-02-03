Return-Path: <kvm+bounces-7934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAA7848647
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 13:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 503F81C20DA7
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148BF5D918;
	Sat,  3 Feb 2024 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="NEnhNORj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F395D8F8
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706964360; cv=none; b=K1eAghxmx48NYts919OV2ULXN7UK/Y4YLSjMnPzbzuzNvMcWgWGe9qrzexFjMXiBT9V1wN8u6KwSVtp0csi5PQ36R0WndXP3f3vid0ulQzczbJ7KECF3WLweCBCckUnJfx5wbGlXd0EU53LNSg8a7Bc2e6OAZoUF8IZxRhTMmOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706964360; c=relaxed/simple;
	bh=ZJf8KQPt7iKRQ2S0BBUYxlwdKVD8Rh5AMVtJIL2pO4c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jhccjmbl+Kkgh+6S40GBAIhuybTjNC83eYyaenVG2DrV1WO8Ab+9+TcqUG0H6agqWLVdm/gZeKc8RL+3ReALnYWRhm8NxHeBH9YOigdRSx46BMmTCRow5oxMDbz/BNjc8x5y4ePaS6swHAsmmg8HL2LczrEdj2YWwpeXwtXzFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=NEnhNORj; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a3122b70439so403494766b.3
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 04:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1706964356; x=1707569156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G5xvEGVutL+AKJYRg38ANd8vi9PdCt4vohp4Urt7Nms=;
        b=NEnhNORjmO4zjb4TlMFkg78X3MXPy89Gfl430AiloF9+wFpUmsA0YYkawzCW2j/Pyf
         0QWTr42lKEXGCisDBIhTVoeWP+KISyoqijttUnBr3zBmdPzwg+nrJzd3Qn1gLcH5+O99
         C/q5xB/QMgnavzvzC/ko+5Ml1Req3+shOIRVnx9wb12f4Txi7pkGKO5YgqvV9RD9k0d0
         VbX0HWPMpKR5cDj9GHEVwqYZ6nxwDRiHEtGNvNdzCqkco5+7IR2mF1Du9p7BPkq3WqWl
         +xHiKfMPMD/wXpddwsNKJ0QfiA8Y5nouhPWBqi0M0rx/XtTyv9yfol+JqC2dnyKaOBP+
         QaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706964356; x=1707569156;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G5xvEGVutL+AKJYRg38ANd8vi9PdCt4vohp4Urt7Nms=;
        b=wU823Xc25/Mq+ZJFiNPCo1Ko57ni3xZFHsiu/1bQUJpaJg7VyOFSYvs2ndz2lr4Pyl
         JoA0OHJuhciCZew4+/QcNNEkNmPuiIK9i5EIKGmvUji/YxIAzQszI7LayNuCQW8kQmCl
         AT+4j5FjGZypDy5P9RfoOmw6KEVwLJvU1NYcQ8XDNo9Bp64qw/6+4UWHsD1EgEFR6cf/
         vqhHxe4vFUc9o7WL08dfw0I9LF7CzY1nrrn32JDKmcrtKex0Mmqp+uiCOwr8R52N0vJH
         GsCgs4KKIfWp9gCCBju+IRs/m20yx6q9kjQFxNF3UauphBtI73ZuF0KbgsKkCXAuMbNJ
         KCrA==
X-Gm-Message-State: AOJu0YyNTfagzs5E97xs4kp1ReE/RdQRlOt1vwsF+borxE37JT2Yyl/9
	5Z07zxOnvy2uAUjOj6l2lSmIQ+Zz7gbnHJ5T0vW0/u+VMPrs+XJOKZAiv7ip+scXg4AXdTawi0P
	+
X-Google-Smtp-Source: AGHT+IFU2tUW4IeHTEOd6IhbHHGYBuRtkseCEys834kOSz/C6RYPFv24HsmJ4hcAoRP7dguiU53FmQ==
X-Received: by 2002:a17:906:4714:b0:a36:14e8:290d with SMTP id y20-20020a170906471400b00a3614e8290dmr6848017ejq.46.1706964356403;
        Sat, 03 Feb 2024 04:45:56 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXJBNa5WZceH/RpoBpl88gpE7c8X697X/MvUJAFh+QlzBHjDbz6sBrVQ3GHyGP2k6MZ5ED/mqIkzWmSSaF/A8YR3Ub9g439qr7+ZL0DKJcgQ34IlaKGsWKJ0syz
Received: from x1.fosdem.net ([2001:67c:1810:f051:d51b:7b6:cc25:3002])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906250b00b00a36c58ba621sm1942015ejb.119.2024.02.03.04.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 04:45:56 -0800 (PST)
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 0/3] KVM: x86 - misc fixes
Date: Sat,  3 Feb 2024 13:45:19 +0100
Message-Id: <20240203124522.592778-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of an old patch which gained an info leak fix to make it a
series.

v1 -> v2:
- drop the stable cc, shorten commit log
- split out dr6 change
- add KVM_GET_MSRS stack info leak fix

v1: https://lore.kernel.org/kvm/20230220104050.419438-1-minipli@grsecurity.net/

Please apply!

Thanks,
Mathias

Mathias Krause (3):
  KVM: x86: Fix KVM_GET_MSRS stack info leak
  KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
  KVM: x86: Fix broken debugregs ABI for 32 bit kernels

 arch/x86/kvm/x86.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

-- 
2.39.2


