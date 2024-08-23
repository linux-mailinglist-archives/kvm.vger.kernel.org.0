Return-Path: <kvm+bounces-24937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DED95D5E7
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 21:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 458CB1C22599
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5454E19258F;
	Fri, 23 Aug 2024 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jVodPhAl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42893191499
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724440439; cv=none; b=mVMQHmJBTEY1SbdPQMjeMz04bxf7gQqEySZXd9FqIjxHyZM/elWftpyY9Y7OM+989nAAM/5KSxWp7m1KKuRzhw7SBVONSYV8wlHBjznRhno40Det8dDfATpZVX41V59tJIQVyFN57e9FJzboTTfO4I01w35CQEHwDLT6WGsu/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724440439; c=relaxed/simple;
	bh=h6MmzQZ+Q4pIa1u5FgXSfED7FfGxALfn2toMjPtt/mA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SFJJkcQDPmOSTmNEdpD+DG4s4xM6eAPb+b80FPsxFx/rdCEdCR0WBYum/KJGM1hpIGPgngps75DL2yN3TCBaIac7DJYLdNcpovSh957a2JL6arIuZAYFkn3mt0BSZN/+LXV0/kE6ewaDqU+J7dq/5CNEjyKAgRPl/wAXhJWboME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jVodPhAl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7142fc79985so2390311b3a.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 12:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724440437; x=1725045237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3t1dUkJeUSV+3qq06ORSFrmDhowUhY/J12I+j1i5R8M=;
        b=jVodPhAlR5iQOVcRx2uo3L7MPzA6ddJYki4qJbps94/gahtcuM30ymTUUoex3iP6qD
         nBpKVSV4KFNIYBU2Rc/VSB01GnVxJmOpcvnwSnaCCQSWf2EsKo+oOWa6xG/CZSpz/XTR
         GG3ztCdNvmDQPamw+1rfMxPS7Gbi17l+PgBXmVZUISA9yxR1W4keI5sgxMgqKS7vtyxQ
         0uhZeHP8DlfQxOUqu9ux8FEF8hJm5Ge9JgGOSbJD9B/bUvMEtKHZjnyDq77MqG4cFGYL
         cQ8nJak+Wi+iEkQVbZvuat8EWWh4fxgJKwGIM4BlVb2DiORGWFMA0aHiP72b2wOEsTBb
         ypTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724440437; x=1725045237;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3t1dUkJeUSV+3qq06ORSFrmDhowUhY/J12I+j1i5R8M=;
        b=XQnMchsX671Vs7U6YGm+jMe1YAjLEMYUXtTiC3Si8f3qc6DORQYtSy32YwgoNPiQRm
         myJo1rRvCFlBlfvJhfORX6fvfASkazqAylRhQRSkxNuG/tP9wkdRZDbo+YJI0DmIkovh
         CXBCtHvBoNBGO5wUKSic/NCmY3REwsNKMzaY2avey5sRtI0DCY2V5YqF/84O07O9/1/n
         Y5Hw1abboK4SPva+XDKM3GIii+51CfawI2mqONRdCOQB/RQueEO1EVsjYKVXRwHd+zh9
         l62a7ywP20RBbwYlIKkzHHUD9onAj7SAO9Ef12rbeBTtqDlyWaFp9GocaCPWbu6ZDQ6q
         vKGA==
X-Gm-Message-State: AOJu0YxX2JvNASXuwUqqrNCvw2TqJ63NkTFlsf6fKnCAyagUIfibrYgW
	oqMdj4SgY6NR7Ghjy/MThTqg20MH3W7SuL6OjmWt3cBo6I7PaCqy+1AFq0Oa/c7uL7UpOC5X2JD
	iHA==
X-Google-Smtp-Source: AGHT+IFa4eVeYlZTkeZeaU1ds/tSY8A2mDkMlBOpXGWUY58qHdlifZGblM42xWXi0Geg7QTcr7Dcw35OvLE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6013:b0:70d:3548:bb59 with SMTP id
 d2e1a72fcca58-71445abd3d4mr15310b3a.4.1724440437097; Fri, 23 Aug 2024
 12:13:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Aug 2024 12:13:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823191354.4141950-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Coalesced IO cleanup and test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilias Stamatis <ilstam@amazon.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Sean Christopherson <seanjc@google.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Add a regression test for the bug fixed by commit 92f6d4130497 ("KVM:
Fix coalesced_mmio_has_room() to avoid premature userspace exit"), and
then do additional clean up on the offending KVM code.  I wrote the test
mainly so that I was confident I actually understood Ilias' fix.

This applies on the aforementioned commit, which is sitting in
kvm-x86/generic.

Fully tested on x86 and arm64, compile tested on RISC-V.

Sean Christopherson (2):
  KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
  KVM: Clean up coalesced MMIO ring full check

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/coalesced_io_test.c | 202 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |  26 +++
 virt/kvm/coalesced_mmio.c                     |  29 +--
 4 files changed, 239 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/coalesced_io_test.c


base-commit: 728d17c2cb8cc5f9ac899173d0e9a67fb8887622
-- 
2.46.0.295.g3b9ea8a38a-goog


