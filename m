Return-Path: <kvm+bounces-42324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20092A77F67
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D546F16C67F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C7B20D4E1;
	Tue,  1 Apr 2025 15:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QBmiJuC9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B154720C490
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522453; cv=none; b=SXqDHf86OOcyeJ+8onaPor2YtMvWGn8AKYq7t1MViGxLMVJfy1WeYlkjRnt3Ilrn2aDpekL57g5YV4PzELZzbS+4csSNHmdvhxvhU7G2qKA2ZsQRrFwfxDkuu09cJ24XFJGwgDsufsLusWS9z6mkXKiEawwfyuDDfINfdUXknno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522453; c=relaxed/simple;
	bh=/1FktzPU3bQuOUmyYNLHWXEww9RqcH6M+s9ZFxSolVI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uzWDVezccSuyDlAjQtAi94R7UrgWr7LGt86P8FgicYUmi2NIzfArcAvVXezPmSqghY/NQIZwD5dJQ4XSzM1tUUQer+ydCGh/aG78/rYmwxlVn4MzpbIcE+ytNgWB9dxqovYNfr+0DnDwcLhNUfFSBRnNofKLxTGLBDyadmiFstk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QBmiJuC9; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22647ff3cf5so92875305ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743522450; x=1744127250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09ksi7gwePf/rawSt4QCN6SH8sTv7bOhY4udVdTx9rg=;
        b=QBmiJuC9b7vQsPQMyQGAPKTTCQMC8y3dgPoOG/KilG9qnJ+5WvcandWhGe0d8mhQ5q
         o81fIkcNFgvmnCKLambmWUHVbz0kvG3l8I+OP0VfAc7ZzvHN2O67UzbFB4PtdjZVAtxo
         pFSwqOqCLKieLCfepn0Tt/UxQSgU+89eSVuUWyb2e3RuIg3cJuskbaIkWPAWapTvwrwG
         RRILHIexAcnKqMb9p8kw7SG/u4bEM9WUuLJ16oeUUv5uEJn/VbvOhpGlqtiGBgQ9vCKA
         3BygR2jV4Qh9vWpayBR3LXWXxkBKs+y8P9gKKoHbp2r+8oiYVXc1NgSyQPayqsBocPpo
         YtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743522450; x=1744127250;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09ksi7gwePf/rawSt4QCN6SH8sTv7bOhY4udVdTx9rg=;
        b=YZd8eDjUSzL8ma/oHvX7YLfh4i1MAvCBk/BXwQ5Hdw4265dWHByF0iveMJV64RWQ9h
         PvMJtl/IoblXvh/TgA18x2CfQdywc2u8Pz+cUyudACf6afjkY5Sexo1HvFD+1Cf0fV99
         KXf84UP+E5wih6Oq284JJI/QtONtwsvY2Ecj5o7s4tvPldKMzuvLLe4MWBsaAcQmQR4K
         hoG8PPycx9vXir8ZffpkMkCczWGLc1ubeZaNoQDpHjEEEmZQX0+jKkvZyOiS4AkyjeCw
         pRsSKZzAaPbIC0vCkszTwkd2IlBNTFRkXtEDWiVhtRSW1u71HS8nk/PJlV9bVIrUen5G
         uhOQ==
X-Gm-Message-State: AOJu0Yyp+XOyAf5AyfgnzogrbsCI2X6DF9cl709J14B9VVkXdJmVOyxs
	mzCkoGWEzCqwueIY7J2yCP+F125S7we9SHihEczW/WrgftTilUM8d3DMHtqJyguMkLDyV/WMEV1
	qyA==
X-Google-Smtp-Source: AGHT+IFTszSRfFdPMZZteThEtt1L+sfoUeDx+PvRrgFsUk/KhpkpCbvaRWftJnoYSOUFtKvH/pXmcBeiSxE=
X-Received: from pfuj5.prod.google.com ([2002:a05:6a00:1305:b0:737:5ee8:8403])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:13a8:b0:736:47a5:e268
 with SMTP id d2e1a72fcca58-73980350150mr19408650b3a.1.1743522449883; Tue, 01
 Apr 2025 08:47:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:47:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401154727.835231-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: VMX: Fix lockdep false positive on PI wakeup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Yan's fix for the PI wakeup deadlock false positive, plus a prep patch to
make the dependency on IRQs being disabled during sched_out explicit.

Sean Christopherson (1):
  KVM: VMX: Assert that IRQs are disabled when putting vCPU on PI wakeup
    list

Yan Zhao (1):
  KVM: VMX: Use separate subclasses for PI wakeup lock to squash false
    positive

 arch/x86/kvm/vmx/posted_intr.c | 37 +++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog


