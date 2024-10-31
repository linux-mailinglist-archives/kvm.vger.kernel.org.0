Return-Path: <kvm+bounces-30208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E09F9B80D6
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 18:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F5C61C21C6F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFF71BDA99;
	Thu, 31 Oct 2024 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lqMqqy5l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D861BD020
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730394399; cv=none; b=GA7wlwjvBGA64adp8t13d/JjQ3x3tmq07bW/2mT+3OSeGxKVmRLNnd8M1iZeTeDp0Fs51sr/MkNQwPdZJzPM0mDS13CGE2Y6B9HEgInvLkr2SiQbRhKopKvm8wzNtAowMH1oOKMLqbRpqDhraJkUXWX+dzKshCXvFoo38Kpr/Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730394399; c=relaxed/simple;
	bh=7LAZLke1czbeE2JjC/YO3KvV3D4Mky7w+Aar8pXIEAU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=d4771l2vxQAKkrpFmp11SprnDPD5WMt3X8TsrmF4sfU18iahg72CXx+R9VlhFb6Pbh1tBpsPkMO+U6WPvo49nzsnk3FEzgYG05X6oSN2pO0wGzEW67FV5zAuGKYJSfqT9LK5aOvBYd+4T8J+i1eTyK0nnvGIXIjhClccVl68188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lqMqqy5l; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e38562155bso21574827b3.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730394397; x=1730999197; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ljy+XgQ36TCDK1VG6TzLmnm9K6SgtgNeYmjuyxm+jM=;
        b=lqMqqy5lBhC/LxFvVe0Kav++vG1nQpgeED4J0NLfyNDrInHQF1YbiCVUzTIn+tdJ/5
         QLxDd0kgxUUQn09Mw4bO+7Yr9koQcomuiqngpCC2CgBEigq5PEfelCHlgiXfugiK9w7F
         fYX/IkqSRKi7EP/0kGb90J5scOhvo/gN6FAHPUz9AnwAb7uv3TySVTVlStJdiWLTpWmb
         I5Dt6KE+s+Zx1B/WECNm+f91DWISMteNCtDQ8ki4lurzRHmnX/36ZQ/UnUj3OZN4uwe2
         jxucCOns7EEcm5dKAGP47pdyBepuzQMzzqNdcatYgYoh1T0hBE4cyu7gNKO7tLNFD2rh
         Jsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730394397; x=1730999197;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ljy+XgQ36TCDK1VG6TzLmnm9K6SgtgNeYmjuyxm+jM=;
        b=BtrpXsKKI0FYWmiSdgDsX9SzwPQnEHrXz2zpYiRDAy9TUE5NawYOVSJeHp665TbN+Z
         LwcqKa7cJ5WqvAEvYaBpg5anNr6sLk5SXnI7X4vPbEuBECPy5w6hyV2SGDdBBu7GIXsT
         zQ9bVqjPhSzlP1B0Oy6K/pXmTsEiHo3VlzawBxirD68iLk/FeoMFzN781Oz7/PYdVL3b
         Xg0eQE6IIHCxPgNlJXoC4/lC130KW45zkGWuehZPNDM12fbMz1HgcdhlJQOmKL2aD0eK
         Jd2InocwceUU22N8VCleNm2TRG3/HVX6gVZKVWmhTOlLSTy36KhCtyu+4Khz058L4NCe
         afwQ==
X-Gm-Message-State: AOJu0YynEoXWYywhc/nvpKQfp1OttnS1CL+RoeiChezLyg5y3WjsczYc
	CB4gn/H9/nbMQVR4WD9OB3NVRqXESKtFEB1d1KBG8PQkGviBbs0IlWQ7jjHp8oPWspRIRW2Dndw
	z9Q==
X-Google-Smtp-Source: AGHT+IFGM0FY3b9u3vGAljWt7YA1j4/ny55DI/U7GX7Nvqx6t6kPUYtFS0toVvzLS00xvk6I72o2qcFsFtw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4b0d:b0:64a:e220:bfb5 with SMTP id
 00721157ae682-6e9d88ad9a3mr8565927b3.1.1730394396661; Thu, 31 Oct 2024
 10:06:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 31 Oct 2024 10:06:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241031170633.1502783-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86/mmu: Micro-optimize TDP MMU cond_resched()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Invert the order of checks in tdp_mmu_iter_cond_resched() so that the common
case (no resched needed) is checked first, and opportunsitically clean up a
wart where the helper would return "yielded" in an error path, even if that
invocation didn't actually yield.  The latter cleanup allows extracting the
base "need resched" logic to a separate helper.

Note, I "speculatively" pushed these patches to kvm-x86 mmu, as they are
effectively needed for David's series to optimize hugepage recovery when
disabling dirty logging.  I'll rework the commits sometime next weeks, e.g.
fix a few changelog typos (I found two, so far), to capture reviews, and
add Links.  And if there are problems, I'll yank you the entire series
(David's and mine).

  012a5c17cba4d165961a4643c5e10a151f003733 KVM: x86/mmu: Demote the WARN on yielded in xxx_cond_resched() to KVM_MMU_WARN_ON
  d400ce271d9c555a93e38fb36ecb2d3bd60b234c KVM: x86/mmu: Check yielded_gfn for forward progress iff resched is needed

Sean Christopherson (2):
  KVM: x86/mmu: Check yielded_gfn for forward progress iff resched is
    needed
  KVM: x86/mmu: Demote the WARN on yielded in xxx_cond_resched() to
    KVM_MMU_WARN_ON

 arch/x86/kvm/mmu/tdp_mmu.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)


base-commit: 5cb1659f412041e4780f2e8ee49b2e03728a2ba6
-- 
2.47.0.163.g1226f6d8fa-goog


