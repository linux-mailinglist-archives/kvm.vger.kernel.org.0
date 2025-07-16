Return-Path: <kvm+bounces-52651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94190B07BAE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 19:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C8C51894CDE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 17:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9586C2F6F86;
	Wed, 16 Jul 2025 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMEXN+oT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BED62F6F8C;
	Wed, 16 Jul 2025 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685178; cv=none; b=liXxnQY/jg9tSThKfsPmGSWFXCYSKuJSq42TY26goWwxShzvezkk+cMoimgIVRSev08Qmw2kZtDtM3dhLgXJGicqmWhHMPcKw1bbxjIitgHXuChlbIdliWQ/kpDvaAEj6Fdy2wU0CpCZLn4l5rAc5sOdd/G8yFYjdqhyFjFtYRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685178; c=relaxed/simple;
	bh=Ue2EyeAUqDPHnyzWjRAybkK0fJice5caV1/hEaqAOyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TNFsTB+CKOCtp7HZA2aVXzJZXTmfjoWuvjkKDkp94dg33QlB7j/waA/Ct4Y9xmiAxRNLJelMR8MhqMc5rfeDE0K8wlQRy7jc/L++HSYC2BhvUVsFgNHgBwKO4U03pboyxw3XsHkFerdJrpGYhm701Q69k3zeWsKO11EyNxwq/Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMEXN+oT; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-234c5b57557so226405ad.3;
        Wed, 16 Jul 2025 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752685173; x=1753289973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pWXltKeailaeCE7O4zeMIE5KwQLx7OFkEcvLJdPrfgE=;
        b=iMEXN+oTVfY2uUsIeD2HneltpVS5ozhD5d4C1BtlH7h/yz0rLLvNmD6ZAKxuzto3fO
         4rEwGmRgZ9NtqP4JU/nEOl2B01kTGAIFELkDvEpRl0XASfNFefFmiiotfxuQguSXQ+rk
         8uYvMWp7XC0G4sZLiNe0GUczmLMoTMAsaZWxyZMiqnh0zB4HspM70Jp3wTOPb+0n+e7I
         E2E1hGm4dY/uRBWyRVWVtT1lFXyRlD5LE/etY1kq40nDzHcrv44X/rSif7GMCYy+3BHT
         1InvxVFBmniAXVUS+HinUW+OYt6ByKRJeVJQvr9VwG0etD15FTuXk62rk3ZmG6ANrsvC
         Zh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685173; x=1753289973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pWXltKeailaeCE7O4zeMIE5KwQLx7OFkEcvLJdPrfgE=;
        b=J+UEzrY1kn9JPKUTyBwJSNfrqu850rR97moz3fujt4ohPxrNGr5b8YKrAqdulnsdu1
         SyjzTmwZQFRyYHkcwYehnakkPX5H4L6RZaEgvuCdw3OyDfHpRVBxdlV2+SHa+StvquSn
         mFZja8jKhhA/J7pR2DasUgiRzbpTvyDC6Eqby+HNIaHjgEaVhi8tfQpiQBnVi/rEWk9C
         eK2m69wZbPy458u880NWdG0oDMDdnu2cAExrVqBFMnaFStP5c1XByrgDIerZdk5CMMeY
         CaF2rccLqGD0EkXaejozoEq0qZj7wNmKZqPjn7z86bkRbt0qyKT6RjjSAYttMphMF+1D
         PSUQ==
X-Forwarded-Encrypted: i=1; AJvYcCULsz96NeKxhHmRvQ68jTLnV9LJz+u1DwRsDT/Qj40BG2Q5BiHRTl956s9eG18DAppdMQ1UnPTq3Ab+wmQt@vger.kernel.org, AJvYcCVlLAPTIoJ65Umgc/mbiYvw6akU8P/lp/ewpcWGCg86i1nGKbqATVrG4JPwjRhd9PBI1SY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpFFwdMLiTlonYAkjz1s+RB/7R2Q29jBVUr9oDtxNJWIy5803P
	bVvN/CVbLkgNUcAfnxIOAziwmeTPjlKHCKyOM2vggFImZXctgu03TNdJ
X-Gm-Gg: ASbGnctVbyaF+mPEQvU1mR6vzTvrpGlsSHBW3HvWIduuwhDnByNYu9UUPnfYdotI4yx
	8+bCCTG8MaDZIu2gWSXVY2Ou71feAaXdhzFkGqc09Mn2PnR03v2TcYnIDd5f3MUzvdGS+Y7b2NJ
	QssCqZis1mgwucZfcuvKfSjZ1bFFimIPVJQc7/4fB4aUfPzFZ2d+Ee/PQEVItJY+zJfNiOxFz4A
	hB5hk9fCSmatlrfaegtNAg+olZXR3k6DOFPGxeOKn0lps0un4NceV2c6mgAUqVgB4+lAMcBi8VN
	hCdmrRjorvRVCpzuubm41YYzHTXXJTirGCAR/3YNvT1PlWKbT+Mt3/iRUxVNHv41GdPo2e542B8
	GvaZelTnpW99TRl2wYd1Lag==
X-Google-Smtp-Source: AGHT+IHqWTXk2BJJVzrTEM0r4STe67WQG+3Gltp+lZVYutv/v33bO1hPVnMLPxR0PO4AQvxpsXFixQ==
X-Received: by 2002:a17:902:d4ca:b0:235:2ac3:51f2 with SMTP id d9443c01a7336-23e2578d93amr47766305ad.45.1752685172773;
        Wed, 16 Jul 2025 09:59:32 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4286da3sm134406665ad.34.2025.07.16.09.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 09:59:32 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 0/2] LoongArch: KVM: simplify KVM routines
Date: Wed, 16 Jul 2025 12:59:25 -0400
Message-ID: <20250716165929.22386-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

Switch KVM functions to use a proper bitmaps API.

Yury Norov (NVIDIA) (2):
  LoongArch: KVM: rework kvm_send_pv_ipi()
  LoongArch: KVM:: simplify kvm_deliver_intr()

 arch/loongarch/kvm/exit.c      | 31 ++++++++++++-------------------
 arch/loongarch/kvm/interrupt.c | 23 +++--------------------
 2 files changed, 15 insertions(+), 39 deletions(-)

-- 
2.43.0


