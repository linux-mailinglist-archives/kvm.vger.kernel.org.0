Return-Path: <kvm+bounces-35896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD79DA15A51
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2DD018896E5
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F57CB67F;
	Sat, 18 Jan 2025 00:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GizOGnGl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D003FFD
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737160498; cv=none; b=RuJCiU0ASspZRGuBmD/RrKZydaNc4a+NCPV/JPt/MlrAqnVxJB01XF1HYrsf1m2AI7lB7oj2hYZmzb50AVvdCFviwsJy2QdGxN1SorCVusAEALKAaQAcNAaZpdtfA9w6qg/6K26E5OsjEufGpCGTjpbq+EUWY1/+snze9wSkdmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737160498; c=relaxed/simple;
	bh=cW808BCqdtgev2PbF78Zdv4OWMlvRuDi4veOyGzWzNU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=flhOBzMHVNiX8KowiIwoV3KjkDf5HC8+7UraPDUj65bWQJ6h0Tp8qKVExxM/HB5AU7KIxU1vFNb3U7EKC9PCq4643U2BPwvvUaVeDNKDYqYJgsxpUB14lOMCbyeD/pHbMb19yZxU3w+Pr4zyLtvkLt683xxqb/EhuI6spW2W+EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GizOGnGl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso5237591a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737160496; x=1737765296; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+CieEtMwZCamh7rLQ2Z6X/RWLVIdMiNeUhZ8Yn8RTc=;
        b=GizOGnGlCd8nXLsXOjXEw2J8E0o6nugL6cqacexgVOJ3MpIFXWf7gv7ISUuJERVvM9
         HRe0CJLWpevJX4RwsmNfDDv2KuP24anUppul8x7DK4yDlqsShD3KstLLIOSlz3SxC2Oa
         ulSpT77tEZaw0abz7gM53CdwRUUgB1K506oohEBdGBBATkhSus/i4VTcKipWRyaeFPFT
         9teD7CrOOP6nJDK34mqt+foyXcw9mLkQLaGi3Wsi5668WDkuVMJDzQfUULjDIY772ind
         sdIXfRqZMwnBEaWDKyjVMXKeiG0qhMP/C0wUwDV1cUzMdxJlKgvJJsFZrT1svx4ZacbL
         5nMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737160496; x=1737765296;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+CieEtMwZCamh7rLQ2Z6X/RWLVIdMiNeUhZ8Yn8RTc=;
        b=UnFrl2k3RTJ0jdYgxJYiSa4QC4c9SbdghUo3ZxVS53pa36D3a+Ir80xTQh+jOgOV2A
         F7ySEcCukZPv4AnnQWpXB07CXZXJHkqN9gtYoqIupi0noBqmlZ3agNRjg22wFM/gKw2R
         m5Vx7ajrXTyADlLop3c/NGBUOQOMjYRES/WYeecy5+lskIwYXF8PmylTKJl0GZfI/diP
         mYGWzIhSSSDAfpB5L7HJTm0FG/OOnNoirTaDsG4ggZJD1sbtDl/KzLFJS/Z6rE1Z2bRo
         qvyFIpj4o6e/mYTQNs1Or10l9HkXABB1jR7VOksi8FiFHQijPVTpB10iuEz31ZNpc6aJ
         SNCQ==
X-Gm-Message-State: AOJu0YxUGfVdpWHUUZfqkTLoSI+EGWQf6VLZRyV3dUDcaf5O3Q7Snfk3
	jEGx3R7hNLJpIePiOXIRwgK6f8wBFpy3aXJP8gYXV//0Qc+eOnt8p3EkTF3shurglL+KmSdTQaT
	ZlA==
X-Google-Smtp-Source: AGHT+IGjMBYb/zLbIa4CoE7spBv2Xl++z8HEkjct+m7a3sxg34uQTB+J+n/lfyMVbXXqrVVB0OqvZZD3MNs=
X-Received: from pjbsz8.prod.google.com ([2002:a17:90b:2d48:b0:2e0:9fee:4b86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2d0:b0:2ee:b6c5:1de7
 with SMTP id 98e67ed59e1d1-2f782c4c297mr7113007a91.2.1737160496226; Fri, 17
 Jan 2025 16:34:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:34:50 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118003454.2619573-1-seanjc@google.com>
Subject: [PATCH v2 0/4] KVM: x86: Hyper-V SEND_IPI fix and partial testcase
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Fix a NULL pointer deref due to exposing Hyper-V enlightments to a guest
without an in-kernel local APIC (found by syzkaller, highly unlikely to
affect any "real" VMMs).  Expand the Hyper-V CPUID test to verify that KVM
doesn't incorrectly advertise support.

v2
 - Fix the stable@ email.  Hilariously, I was _this_ close to sending this
   with stable@vger.kernel@kernel.org instead of stable@vger.kernel.org,
   *after* I wrote this exact blurb about fat-fingering the email a second
   time.  Thankfully, git send-email told me I was being stupid :-)
 - Don't free the system-scoped CPUID entries object. [Vitaly]
 - Collect reviews. [Vitaly] 

v1: https://lore.kernel.org/all/20250113222740.1481934-1-seanjc@google.com

Sean Christopherson (4):
  KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't
    in-kernel
  KVM: selftests: Mark test_hv_cpuid_e2big() static in Hyper-V CPUID
    test
  KVM: selftests: Manage CPUID array in Hyper-V CPUID test's core helper
  KVM: selftests: Add CPUID tests for Hyper-V features that need
    in-kernel APIC

 arch/x86/kvm/hyperv.c                         |  6 ++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 47 +++++++++++++------
 2 files changed, 37 insertions(+), 16 deletions(-)


base-commit: a5546c2f0dc4f84727a4bb8a91633917929735f5
-- 
2.48.0.rc2.279.g1de40edade-goog


