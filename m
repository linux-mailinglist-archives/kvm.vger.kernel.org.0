Return-Path: <kvm+bounces-28348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD6999758A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68FAA1F22CD9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACD21E04BF;
	Wed,  9 Oct 2024 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hh4i8twD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16121714A5
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501830; cv=none; b=QCmZqSMQ+g24NvJsgdtLIB03GlIfE6lWlpVIdetPZIAJrxVYFB0LL2wE+Q7KNIgS41/QMIL3BSLSf/IBjVQYSFPNBOAtl3gc9jQ4x7sztvsPVk7enCPe7+U60KMgUkpIr9AZRb1B73ytzgPGAHrTU5LLlY39arKLi+pAbqX/fBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501830; c=relaxed/simple;
	bh=zRN0AvnYY9gusN10idMlGnrvukeWNRhnVFqGitM8r2w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dJTpFQbKtU8XNwSgtWUHw6ge0BSOqsIyDNNZfOqD964nUL4iDX01fUjjKGppnhhBzsGNgliU0CgjTz0ZmwotXGh6Jc9sUdt0/LFQUvGItoxB0vjA33oXZjNxS2pyMO+SelYCHdZNtJUtJKKlhnUFR8dAggUIRLpBf9Ap8Ez6sbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hh4i8twD; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690404fd230so6043357b3.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 12:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728501827; x=1729106627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U2/jiaPKLbEQ3lKof8iVcISjt7IJA/O0dCYOkC0PY2Q=;
        b=Hh4i8twDkfNrUahw7FPSg1fMC1l4+M38iKfUP2ox0Mefy6L2IMCm51D06L69S5yEQf
         ar2Vb9Nv63iq7ugQwl329goP361N10FGReCK2XujVJHU9VRRIWG2P4oCFMnG2MDoB2nH
         z+0C/mHSdAIrtTIhLHSWhXF7R6env/0sGxxaXDaixrT6Q1QmTJpUPBsKlS4FSkw3M40W
         kdZ3EtJbg+6Cl8io18QnpQzz+9iS0ifZiwgac6zPNBwMF4cNfY4uDPeQXKjkyEaHrSd2
         zq7uioLKyGnujyN68WGAum/jq9QUE/S2V7vBUaxI3HGjFPVYZUAWHHbsbiWkfw19QFMX
         xgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728501827; x=1729106627;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U2/jiaPKLbEQ3lKof8iVcISjt7IJA/O0dCYOkC0PY2Q=;
        b=hLUACXchWa6l9BVj2Ew51qTIjdWdewyfyuB5zJ8UxVslmKbDThy/JJ4BaPuJB7UnzM
         3FOXu5rx6c33wPK84dac08K3HPk9r+b8GolYxbh6YFrv7/aeqpiPCwY5xMg4xcdiHNPw
         IJ0Sk9ICrYd37sasvMJNW8zftQO+SfsB1YM41SgDCjTSDizkOOoAzNmr1/VqDCvnAqC+
         bZ2hxC+6xW1D1C7Rqzv82cs3p6PLRmN1Yt0XSykMLCvepSMPM3X1pEWI6MvbsB1Y5RL3
         CX/hDSHgC0tRij9vxir8e5zNiy2a69HunUYrQSLKsKeV3niJirB0kK0tUQOQDzOuonc6
         ZIJA==
X-Gm-Message-State: AOJu0YztRqglvm6h1e2Zi5MAxW3+8wwyxWEKvepWEYNHORsC054vRYCc
	nEo1rfu10kqegO+4NwTSHDpgYavEY8vifz6Bth5UGF3SCs6q0oWLQfEfcQGcU6CmG4e1kTZuBVU
	6rA==
X-Google-Smtp-Source: AGHT+IEnmrOfZkI1ocosgQqc87J79IVqiyjmPhDahKoj479CKd2T/EbC7dQmnLey15tO19jBCPU+3tPAE1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4349:b0:6e2:1713:bdb5 with SMTP id
 00721157ae682-6e32217cfd3mr60727b3.5.1728501827367; Wed, 09 Oct 2024 12:23:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 12:23:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009192345.1148353-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86/mmu: Don't zap "direct" non-leaf SPTEs on
 memslot removal
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

When doing a targeted zap during memslot removal (DELETE or MOVE) zap only
leaf SPTEs and non-leaf SPTEs with gPTEs, as zapping non-leaf SPTEs without
gPTEs is unnecessary and weird because sp->gfn for such SPTEs is rounded,
i.e. night tightly coupled to the memslot.

Massage the related documentation so that KVM doesn't get stuck maintaining
undesirable ABI (again), and opportunistically add a lockdep assertion in
kvm_unmap_gfn_range() (largely because I keep forgetting that memslot updates
are special).

Sean Christopherson (3):
  KVM: x86/mmu: Zap only SPs that shadow gPTEs when deleting memslot
  KVM: x86/mmu: Add lockdep assert to enforce safe usage of
    kvm_unmap_gfn_range()
  KVM: x86: Clean up documentation for KVM_X86_QUIRK_SLOT_ZAP_ALL

 Documentation/virt/kvm/api.rst | 16 +++++++++-------
 arch/x86/kvm/mmu/mmu.c         | 26 ++++++++++++++++----------
 2 files changed, 25 insertions(+), 17 deletions(-)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc1.288.g06298d1525-goog


