Return-Path: <kvm+bounces-11944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A743F87D722
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1483E284269
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B595A4DC;
	Fri, 15 Mar 2024 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HqQng2Kt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C73101E6
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543948; cv=none; b=MclBc4W5JwP5gNJiIf2G4vIwoBMq7b0Y1hr2K+nMPoQjkxGFphqfhgxhZ2P5awM1l3UGyFdIG5ytY9qJt4lInET4N4aCnATD0Cr9AsfDxqi4XjU/pO4cGHVc83h90b9zSI1RkiaNKJVz2+YES04Cb0T0nIcSazd88/0v7u1JmVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543948; c=relaxed/simple;
	bh=noYgsS7+8n1T1/4BmPI/YBaxNXvKz7eMKthbLcKhVDM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PbF7RpYAlcTF3bdCcNGjgrz3+tsl7E10oUPRmPW6my5oHeXa4Wuw1M9Bj0aU4oTRQd0wVWsoubg1a2kUdxQe2COos6DAL3Y46c30wn/JbPo6f3wrJ1SXhFNPk4EE3B7UlaFeseigFwq+cYeMjJtpYDwSW6l3LQQfOj25xfPN8Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HqQng2Kt; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cd62fa20fso33482677b3.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710543946; x=1711148746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V9wHrfh0sU6yTCkGXxBlbrUc1jox/MWoCo+u5CL0Xlg=;
        b=HqQng2KtJqRWvR4zVD7JuCWjanbO2nuYdjdDpHDyYuqssed0gxepbaaUmabrnfkdcy
         eGcC9B9cZUfuMUw3u302Url9VQ9qamgVSq1C/+A4iIePwWQjLtiCzjx03bo6g5HRP9vF
         nhmOztr73fxgtaobb5C3byBXATdWYgObzgEH+yZdmRukHgXE/3+iSFIxdIOPv53CjE4O
         ZmVc/qWNhYE82yn3YsxrwD7pN3IfPxbISbD5wzoPvgIA/Ut5CnSDp7fXtwhn5L6MC1Oz
         E0mlygjYRsfxc+6tDi3VFAnU4io1bMYMikF1K0FRNhQ8pR2Tw6Cxq78aU8zmgN8i85lL
         yjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543946; x=1711148746;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V9wHrfh0sU6yTCkGXxBlbrUc1jox/MWoCo+u5CL0Xlg=;
        b=R/SraqtF4nV4FuBTOBrZfifNKBE9x9pEBKVvTHEmKOTBsiD9QTQX0cL04i35vOMIL9
         7GppkIoQw+TpADBtoGPrdnNLAy1TlJayJ6eu2LGDtnqfyq0pggy4bDgz+nlm9s7gqBQp
         DyFs4RtaURq5QRzZY69SL51TmYuKEtcWaIVyV3dTOUcuh6UUJ5gsQlLLF4FPK/99gpOm
         T3rbHOQ9cF/l7zjuwLj8sajfODHfDsEPc8V81Ua96M7XNHEvUYP7Pdl+I03dX6WQDxy0
         SbkYd8q1RTXjX2oEJ8EloZ768yix5IMp3SoC8Gd+4hhluk7pqKWQjmJT62+Muhy4FDbI
         f0ng==
X-Forwarded-Encrypted: i=1; AJvYcCWld1cM5GE7z1JKrMjrcz/zxjYSuidXqGcFynFPr4jjiqi0irf69nWdGO7vjvPD765OHefibun6FX4hjkQGYySRFge6
X-Gm-Message-State: AOJu0Yw25hoAWuVunASW7/y18fhzhjAkeGXNk//kgu9K2dXd86gw2lP1
	0DEZ3STSisZ622LEc+Y+XcDwc5N8WqSFThY8GsERvOdstKJHKI4Y6h7aR21QxyfX8tnhpom/5Xe
	3Fe6TlUAp2g==
X-Google-Smtp-Source: AGHT+IHs4mAhSuWROQ8hK8DulFT044L6s5breeXloPDP3+vYUvtldVQ2d9vVakvoKAw4e99dPNgsV89rqdptQA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1004:b0:dc6:44d4:bee0 with SMTP
 id w4-20020a056902100400b00dc644d4bee0mr234748ybt.7.1710543946007; Fri, 15
 Mar 2024 16:05:46 -0700 (PDT)
Date: Fri, 15 Mar 2024 16:05:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240315230541.1635322-1-dmatlack@google.com>
Subject: [PATCH 0/4] KVM: x86/mmu: Fix TDP MMU dirty logging bug L2 running
 with EPT disabled
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug in the TDP MMU caught by syzkaller and CONFIG_KVM_PROVE_MMU
that causes writes made by L2 to no be reflected in the dirty log when
L1 has disabled EPT.

Patch 1 contains the fix. Patch 2 and 3 fix comments related to clearing
dirty bits in the TDP MMU. Patch 4 adds selftests coverage of dirty
logging of L2 when L1 has disabled EPT. i.e.  a regression test for this
bug.

David Matlack (4):
  KVM: x86/mmu: Check kvm_mmu_page_ad_need_write_protect() when clearing
    TDP MMU dirty bits
  KVM: x86/mmu: Remove function comments above
    clear_dirty_{gfn_range,pt_masked}()
  KVM: x86/mmu: Fix and clarify comments about clearing D-bit vs.
    write-protecting
  KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test

 arch/x86/kvm/mmu/tdp_mmu.c                    | 51 +++++++---------
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 60 ++++++++++++++-----
 2 files changed, 68 insertions(+), 43 deletions(-)


base-commit: 687d8f4c3dea0758afd748968d91288220bbe7e3
-- 
2.44.0.291.gc1ea87d7ee-goog


