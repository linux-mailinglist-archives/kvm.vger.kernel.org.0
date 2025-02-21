Return-Path: <kvm+bounces-38894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B48A4013B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 21:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D5FC19C13AC
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D539B205AA7;
	Fri, 21 Feb 2025 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bkOqx0oP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CF41DC985
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 20:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170512; cv=none; b=lnU+qlCWEPS1+NcTsibtt+5hLHxXZjrrJ4tljdBasb9Eg0RvYieY/JhKZTcIJKaw3wEDnY8AjoOAW5a4ri6bGe40s0GLp8fzasc7qYn72jHrkXvZs5fFvWgbMQDTYrQbHGpMSMC93rnEhJDyAN/bUPn0as9eech9bGbJKM/ojKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170512; c=relaxed/simple;
	bh=pf11gTWWMJGUEmUI0lTVDvMbbQ7Vmf4asWaVwfKj4O8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=i7RO8yHyclvdoYM5Ac7iCGZ6SE34vg3DoUjfk/IoEjCjAGZvpYzrGXkVFBGU/yijAkLIU8Tad+HWsFca6c68ycEuw6O97c8ZNCGwOkXShVlSeOpIRTRcRrVfWcj1SjebegdLyJmIL4AiYonrXdmJ1htyZL91UR1NyIanhV5dmNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bkOqx0oP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22126a488d7so58377765ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 12:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740170510; x=1740775310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jjxg0TDYNl6QIQBM7WtTCQGCNbf7lZgPZH2FCeP7ks=;
        b=bkOqx0oPN+gzjRyHASArmlqPknb0pWfrSJw8c1g/suiXzyVhpo/cRzklVzMbAIw2H0
         rvg/zYUtw2J/R2/WPoBURA2ExcOaiNtPuRd+SBVEOl29tLR6RCLUxHQbd7L/q7bMW6ID
         uUjNlQHuRn+0TLvaTl/dX5AXAqO0mriIepxg6zCRHVOPbXPC29S0WeMjjMd5U/gnyLNV
         YdiBwP570W4xSEzaqNv85/s8r+8CZgRVlpy9hibvlyAKsO0zjRP0YN98yL4OnelDULTq
         MGxY8xX1CdHmKZoAJ85MdFbnoxUovnJE5vJfN7BGFm16/XWO8Fwq8yQd+45sD5oqEtJZ
         Erng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740170510; x=1740775310;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jjxg0TDYNl6QIQBM7WtTCQGCNbf7lZgPZH2FCeP7ks=;
        b=kFFD/rkF5XLkq/We194n9nN2EG01LB5UyIm2fkxNQZfCN5ecVyOAoBnQB/TPiXcaE9
         t2GkPCKZD2P1ulpUAIZFWvurt5qzkJ5ty98ru2IEJuIO7TVjJTENtwYH7XIwuU+p/6Ke
         67Lfgzf8TyiKgxqUa668sOaFAk0VcxgwL7Veh5O5BCNlxhCOPa0hTqTdNSuNu6e7Ae3N
         hcECLLLUpYaDFT4KSstPtOyXSgN4xrjTl3uRODTcqIOmpv/DHx4ZFZyjAp//JhwI5U5f
         7+nMCE/FJnrclnZ61dgOX4Nf0+aOL1NdnNoZdQi3i52iY1jKR9iR8K/qvDXsAU4L/O0Z
         iv+g==
X-Gm-Message-State: AOJu0YzWhxrJbCuzgxtFKsK2qEu39FZZh2QARcESKL7vmwbRWJmup91P
	SLy7P8zAAtYctOpZxHq2PPd+DkozjdyGf51KXl3Gerag6RxmZ7cP3JkdInr6bMJfGNWInUVh+WR
	XQw==
X-Google-Smtp-Source: AGHT+IFWdbyr7kJ2T3DwFoshTi+qsxnpn37RecdRPUNtzPpTT6aHUfd2MIjwoF68ZvY4AO/hc6d+dyvtNTg=
X-Received: from pgum13.prod.google.com ([2002:a65:6a0d:0:b0:ad5:4c03:2b16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:62c1:b0:1ee:e808:732c
 with SMTP id adf61e73a8af0-1eef3c889d5mr8947677637.14.1740170509969; Fri, 21
 Feb 2025 12:41:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 12:41:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221204148.2171418-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: Add split/bus lock smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a testcase to verify the guest does NOT get hit with an #AC or #DB
when generating a split-lock access.  Bus Lock Detect, a.k.a. BusLockTrap,
enabling on AMD exposed a bug where KVM incorrectly runs the guest with the
host's DEBUGCTL MSR.

Sean Christopherson (2):
  x86: Include libcflat.h in atomic.h for u64 typedef
  x86/debug: Add a split-lock #AC / bus-lock #DB testcase

 lib/x86/atomic.h |  2 ++
 x86/debug.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)


base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog


