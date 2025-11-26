Return-Path: <kvm+bounces-64583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04173C87BB8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B68553B35BE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB94B30AAD0;
	Wed, 26 Nov 2025 01:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pj6g2/II"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E09307492
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121502; cv=none; b=ARSrPeezUj38nG5qdxTVhhrl9kb9bB63roMC+DS6v2MIVa1mCkNTC0Hu44huDNxqvclOxVhGO5msgqlL4kCKZQU5e1G0UkUrSj1sVOkdLmsVvIOnafP5PPJ0fZbXS6hvPidp6MpleAFvYW7Aj+tpZhwra+snW2UsGda3j4D4E8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121502; c=relaxed/simple;
	bh=OIuiLQy+CK+oinUVLgEepbGZeRhaPhjnctfGBhzdEPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sl6gDQIsmZaF3oqVw8tUE0wmUx8j3e0BeahMDm4ZJwfcRP6AX9c89l01W5/D/lSO1NY9p26/ktlDRi4bCqATvxq8lZxedFpNUe+aPuiVlMcf2V28ZSw80fRknlN3/CKnP0FmneL0EFXYFrrqWLEnCnDWu1UFjPFyW9ybG0QLM70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pj6g2/II; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso6795645a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121500; x=1764726300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dghRoY4D9clXDgqvHWPj5A8PZbI5gyC+LR7Y6CLKL+w=;
        b=Pj6g2/II1zrQ8OR18IWZSQUHy8uvxr15uS5/s5x/BmUVVzS7hAzeTiIzOGdTAZoJGQ
         80VpgXk11RzRTcrhBzveY77lVYZe9cDc/y7iL7HFzD8rWiaTgDoOxd9TmwS3iVKs9WHa
         Ue8bWS+2oqOBS1nyeT0X/6DSaIhxQl1VAThYdC3wQNCc86y+oltere539j5Ee7HV4FTg
         slhQ1f7oZiFBlZdyn+y6uuCLgff3qkFowreQFCKRrPPpY+E9TvY49j0xSBm4BwPq15zd
         FmRZ76SC+Y3BN+yo0QS068KImCFZspCVp3N2UewvGwQWtqnm/nenYr7/2N/8s94S5CwP
         y4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121500; x=1764726300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dghRoY4D9clXDgqvHWPj5A8PZbI5gyC+LR7Y6CLKL+w=;
        b=UUiDb2ZVI2FROwrRQ1RoeAqzlaLYK+Xnj6AGlwEr9p+dt+R9XlUfd2AA33MvBp3D5f
         SN77KVbO2K4w/tX3BvyofXuDWWF9k+r0Wqy7XP9UxHmjdyU0g19VfaOmauCX9XUGUKlO
         JmTWQvOR9YIGTcIcLn6klLOwiRwOdOz+jYHS49quDyXSGhRqwt4SwglRooidMTw5q4dB
         pWzUbbBEsGFNtUQzDSDIhQtxq9lNAwy6As4ebg+fZamPwZ2tKMNYXPvfi7D03eLNLGgo
         CVPG8LfuwphfqnhcFQD/EZGUd5eNzjEyiHYLbPAP4fZK/eSELsXdGlM9Uw8kls8hhwpi
         d8hg==
X-Gm-Message-State: AOJu0Yz1MNCWaBtvpncV9KviWVsBkZYziWtmK88QaW8VMfWYKtPj9mcC
	hqXBgC8QuKoLtOvYFdOA5k5T0ZnnODfOJ3REI/fWZ3TYrIWNDoLI4Kdq5NRsFZRGMTIHhUkWMoj
	pgyU88A==
X-Google-Smtp-Source: AGHT+IFBQYkDAKWBk7r13VAVj/sri4GosqRT1lrwsawbmJYdUIRm9cKK20VXaIfyFZSyFfm7DIAwDXB+Luc=
X-Received: from pjbsd5.prod.google.com ([2002:a17:90b:5145:b0:33b:52d6:e13e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f86:b0:32e:a4d:41cb
 with SMTP id 98e67ed59e1d1-3475ebe6413mr4094453a91.1.1764121500054; Tue, 25
 Nov 2025 17:45:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:48 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Generic changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A tweak to account for an upcoming API change, and a doc fix.

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.19

for you to fetch changes up to 04fd067b770d19fee39759d994c4bfa2fb332d9f:

  KVM: Fix VM exit code for full dirty ring in API documentation (2025-10-14 15:19:05 -0700)

----------------------------------------------------------------
KVM generic changes for 6.19:

 - Use the recently-added WQ_PERCPU when creating the per-CPU workqueue for
   irqfd cleanup.

 - Fix a goof in the dirty ring documentation.

----------------------------------------------------------------
Leonardo Bras (1):
      KVM: Fix VM exit code for full dirty ring in API documentation

Marco Crivellari (1):
      KVM: Explicitly allocate/setup irqfd cleanup as per-CPU workqueue

 Documentation/virt/kvm/api.rst | 2 +-
 virt/kvm/eventfd.c             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

