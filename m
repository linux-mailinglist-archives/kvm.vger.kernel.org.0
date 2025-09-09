Return-Path: <kvm+bounces-57138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD6BB50712
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9C845E3889
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AAB35E4F9;
	Tue,  9 Sep 2025 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m9Rf1TgK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4532A3C3
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 20:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449721; cv=none; b=Ts7YwkgGKslxJM0WDr6sDW78uCcEXSN+l8UcGKBGxRaXE7VjHLMKJ4ZM7DpjA7Bf1ZyC0tp/m9qGHJXBo9Vu8147+1olOxQsGwGLWC3ZxAcoyPsGerazycsVSUKETBSf2Egbbx5IEKXe2mZeEcExt+QzDx1hG6bQDM0nNp5AL/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449721; c=relaxed/simple;
	bh=9o4/IrU94P+QTT9+/4P4GvEBbaeKuvJEepudCTn+3fY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sZ8Ld+bYIwj8A4zZOKBdoPyFzw4oG+Py/ibhWQAF+AcblfWg8aGUu0FfB9BHAS4E6Ql9ZvlpsA4TSlhFbdGf8NCL1e7zPEveTY0oyuyFepxZcbIRBR0kXiyxAzb9IuRoh6l/LX/S7u4emuVbuERVaYkXAsKx1JEZDlczK5YOGzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m9Rf1TgK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329745d6960so6377074a91.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 13:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757449719; x=1758054519; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sWkWVm2ZY47IQUaG/R/khk/AncS2YDkfPCnt2FvXUwc=;
        b=m9Rf1TgK/K3Dr49smgF4DISq0sg0+TUfOveV5eFQa8yzaa8ma324RYSqxvkWoUg9Ut
         HwugaOIMmUxdhbu3VbLg1PgRHHF387EPS58wIgZ3+kIFJeV3XOTtd5xHbl9yDLtSo3v4
         66J/uHQ+7/DnTTNTFPzZ6P2RojdaD9+IJZUPzof8JbHf4DOr2x/DjbAK0uidiBpM3zR/
         izsPWXB1z4H3MebLOlBCX75oOKO0GXFTVZThDr5NJ2RIAqBKM02ftehzqt2y3dZA+QY0
         yvLcfeZzDRKBP4KXrtARkOU/1l3vwhvcwPfe5mcQNB1qFXb3tqDE+R7TvasmKKdYMjW/
         dm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757449719; x=1758054519;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWkWVm2ZY47IQUaG/R/khk/AncS2YDkfPCnt2FvXUwc=;
        b=ECzqVEeEiiaxaaRCfMhqmXBxL8l+q+m4WfUFDY5IYE0eiHfhrLfAGjeesMUBSZ6fOc
         qy3BZ6tgPDhe0yJqd299b9v5whbOwzrMbM4zq5rZGDFtieJ2K09XF6TD2pZXukOZf5Kr
         RJqYw/xxD5usjZNHPKbOFLxd1A/DNSuE6tSC43NNNRNAsKkc/l00yp62KRl7Avi91n3w
         NLWWQoEA1/4Im5YKWpx4CDxk8u/MAyeybf1k7IUmBhu3YOTQeGZiVioXCmnQUnVB2x+T
         ZTM70jCnStFrMOoXR1BhQDrNgruJb1IJbMyUDEsk5B4INQSVl1CbuT6wPkmqUQNNAE4T
         eJ0g==
X-Gm-Message-State: AOJu0YwKW/COGqkMbvgeasFfl096uHPxopJwokDT2LP5m71bxQWkFqSG
	L3NqvWOBKJO3KnsOYjn6c31XZ7SeEENSIIKGGADRcw1q7YQx2bl1h9fsx6bCz13kG906BC3ywr7
	PfNmE0g==
X-Google-Smtp-Source: AGHT+IHWyC5H0/wl7/uAJ1WMzwGj8ebCIrDG0apHqWKhulHzTUDlppDzMpYLzi11i4Vux4a8U4a+XLFnGsU=
X-Received: from pjbst4.prod.google.com ([2002:a17:90b:1fc4:b0:32b:5e07:ca10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f4d:b0:32b:92ac:cfc1
 with SMTP id 98e67ed59e1d1-32d43f0f44amr17654215a91.16.1757449719011; Tue, 09
 Sep 2025 13:28:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Sep 2025 13:28:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909202835.333554-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: selftests: Fastops DIV testcases
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add DIV and IDIV support to the so called fastops test to add coverage for #DE
(the only exception that can occur during fastops execution), which was broken
due to a typo in PeterZ's overhaul[*].

I meant to post this back in July and forgot...

[*] https://lore.kernel.org/all/aIF7ZhWZxlkcpm4y@google.com

Sean Christopherson (4):
  KVM: selftests: Add support for #DE exception fixup
  KVM: selftests: Add coverage for 'b' (byte) sized fastops emulation
  KVM: selftests: Dedup the gnarly constraints of the fastops tests
    (more macros!)
  KVM: selftests: Add support for DIV and IDIV in the fastops test

 .../selftests/kvm/include/x86/processor.h     |  6 ++
 .../testing/selftests/kvm/lib/x86/processor.c |  2 +-
 .../testing/selftests/kvm/x86/fastops_test.c  | 82 ++++++++++++++-----
 3 files changed, 70 insertions(+), 20 deletions(-)


base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
-- 
2.51.0.384.g4c02a37b29-goog


