Return-Path: <kvm+bounces-23146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38AEC94649E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8AEB282F58
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A122B6A347;
	Fri,  2 Aug 2024 20:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dsqp/mpO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321F33DF
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631807; cv=none; b=T0dEMSAqE7b+gwaQzG/Q78+ACQEnPgjTy4Ach2FPOfJCD82gjlcMkiV7ipUt3X4CoyL1uatMZ8ECNWIpUzCX1NoYQrvFwpAMXhzsaeG7rMezIrGLcp8IQ0bJ0nTj2BTYSyBkTh6R54EbP3D9ENfgUrvt0vRXm+uRP7gnoieSh4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631807; c=relaxed/simple;
	bh=wI0b9a+N4EQDdg4biJqQ6e5U/D64/KuAZb9/5FYnPo4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X3ZBOdw51U2ewVoyqxDTv+jyasRYcyuEXrQ9UdOADdqbWzo+gqIx5oslD2Vo0TbomkMJZzWSzpJ6NhyHyqAGOoC7PG21ECkfg0V0uUNV4FdAFZXLpygeaycNy3yDRSsxeuBD1t5/PKgIPN3ko4mRFSNNkixsbIwrOO9S6jovo/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dsqp/mpO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-721d20a0807so8648523a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631806; x=1723236606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07pVGfXuSY/XWJzm5rhlT1DEo094h1RSFSYePA0UJWg=;
        b=Dsqp/mpOI45Fug2OC0XgIcCAqxaZwfEy6kpHiMQ8S1VRBauaTyB0ByuzEjn+8E/9lo
         AWcqYvIUln1p/I50cyfZmYiQrNkzaKMOszkAdNlusVvYf4YvKeRJ0/ohb9kgGaqFVOj4
         XboMQlpGP8KcvPyvGTVHWbI8CnlvwF//1Nmir9YVYwk3N28bILl89/RLBtQmuXbKz2vK
         WJxIqprWTM6ag3cMFuIB4scFLea+4GRm+Uv4KBeZ4ROhHICYhY3vK/2xNTjXWGVux0vP
         NJvfTkT4m7Ig0ZIIPRkzaINBPNQ3RptdaFgjquXtFipRly8NEFFodqvMwlGDpgWwbRoL
         EPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631806; x=1723236606;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=07pVGfXuSY/XWJzm5rhlT1DEo094h1RSFSYePA0UJWg=;
        b=NVntJIjYXl3O/2cyZjiPj8e1dWLKJ/RfEfD295m2K3fMQfw4OqHy4cWzdJ8rnjtWa5
         gtyWxUGq5br4E7R/3ku/Iz7Mj5Q9kSv1y6Cv8rNpm2fN684SkHoJLKSW1uQUCi7l6pbI
         ON1VcWt1D2h/LLY0pHP4FfNYfMSqNOQcajRUmUHoqvhmUyUdtOuruPQGq9Ohh3cSVVXA
         a/ZCJ57crA+MJiAbVkaU+6kVJ1+i9MKUQamHYA+36TZ5ZsWnVlfer9+FuGL4oxomN2uG
         2uVx3glZF0BR0TlYUl9jdEScGhjhLQ/CERayu/2Xghtj398DHB43qogblxouX5IJtgzH
         FjAQ==
X-Gm-Message-State: AOJu0YzxKR7UimeQ6Wz03jmLoxnd8fK0YXKy2/vFcSguVxE+m7WFjnat
	7YQRenimOG0WLHYK3gj4Mw8fY5fUF2+7HL1z2HT2d+RrfU9CgojyL7mA6AGN0UfHH+fXWR9oHfc
	eIQ==
X-Google-Smtp-Source: AGHT+IFC5LWLOxwPHvNZWQM436sHNoS4DNX4VcqimA3Hh+i2UkaudAnnMxN3O12dI0UDnUW1eAQ80Xh9W78=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2446:b0:1fb:3474:94fc with SMTP id
 d9443c01a7336-1ff57296e21mr3021555ad.6.1722631805645; Fri, 02 Aug 2024
 13:50:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:49:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802205003.353672-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: kvm_set_memory_region() cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Cleanups related to kvm_set_memory_region(), salvaged from similar patches
that were flying around when we were sorting out KVM_SET_USER_MEMORY_REGION2.

I'm honestly 50/50 on whether this is all worthwhile, but in the end, I
decided I like having kvm_set_internal_memslot().  I think.

Sean Christopherson (6):
  KVM: Open code kvm_set_memory_region() into its sole caller (ioctl()
    API)
  KVM: Assert slots_lock is held in  __kvm_set_memory_region()
  KVM: Add a dedicated API for setting KVM-internal memslots
  KVM: x86: Drop double-underscores from __kvm_set_memory_region()
  KVM: Disallow all flags for KVM-internal memslots
  KVM: Move flags check for user memory regions to the ioctl() specific
    API

 arch/x86/kvm/x86.c       |  4 +-
 include/linux/kvm_host.h |  8 ++--
 virt/kvm/kvm_main.c      | 87 +++++++++++++++++-----------------------
 3 files changed, 41 insertions(+), 58 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


