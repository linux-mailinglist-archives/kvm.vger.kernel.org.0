Return-Path: <kvm+bounces-39431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C74B2A470B8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC0AB16CC49
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDB545038;
	Thu, 27 Feb 2025 01:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="veH0IRC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5088D8BEC
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618807; cv=none; b=GVOHYKhH1YBm2ArelC/LLl73CaMUCLEPA9yrPZW/yW+5HqVA9WdKZbtnd47469fbKFMtjZx98PcnRK4aqxKDeiKHeuHU/qPNQwqnbKF0yB2k8V45icVeiJ3SkbFPEeKjLmCFo63+QUuV5Z3ivyFjWeDJkm/X9kw8xg+wfP+kiUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618807; c=relaxed/simple;
	bh=Lor6SfZp2UjEyAoJzhwqvgbGSJZTBeb4Jom36JXMyHM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hzvL8SPRXWjrM4MLKb2QbkctAVq562jgVp10X5mOl7F2MNp39VJsAUh7mDwAj4N9eHkgeQczcUimRiPrFuIMjN9cUlDT/8F0OdkF22HgQ22bFhP7OMWh9fwpNYDZboG3WFjTSaWu6cgqbuKYSqgc707BIpbzhvG0967JWhBRKMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=veH0IRC7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc4fc93262so882623a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618805; x=1741223605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JjnOSkXxka3TSv8G5RQWCjyM7vwr1n8JaR1Ewf7JVQg=;
        b=veH0IRC7JKA8gbbsEAFBFISxByG32MYaQOpkt1qA1DOjsiu2jt69hGiRAroWvrqR1h
         gFBQInEnQmPP14nXJ1k7XJyqr2a+zRqEJH3iHpovOCl9RfZmKtvN7N2qT83yzA1GETO8
         lS3wxSTIMyWPbAn9LjHY4h6I4nC9sc57pKfZlonXFLS6fpPv1RkQ1H3AqABFGnbID+sA
         1GCuuSL/9HB/Szx683fPqQI+WbgHTjb+eUh05kc+woaiD/lG0jphW3u3IWkQad0SUyzM
         hbrrc+zgQ6hsqxleCJbvf3CrZXUt50owS1cs/J/j/clvCn9HNGPo8qJmKy+UjoN9rc2V
         IO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618805; x=1741223605;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JjnOSkXxka3TSv8G5RQWCjyM7vwr1n8JaR1Ewf7JVQg=;
        b=LThoxZeIVEHBdMAECTNrV5MD1X0wdg+rgUgQuB8GrFmUuW9Eb4GXIPKNywpriYsNPk
         ZFvx7GcnVR8spxXRGl3m3YPPND1ztey8RNjH3cAIYrK6Ie07AQMFWRyY39Oh1XOvZVWr
         p4aXFn/qj+uzkmqalP1oFyAmUzsaiJ6KmB46eH3/NYRnnYUWHnzTcAxGKzR17x9AWd1C
         LnQv/+vW24/URo3GW6ix8ZsWns/gvtatdnaMB27NF6sV3XPW19o2t+GKH+O/01DEw/p7
         dQVTF+it9CcXu7uqnTS0hzd4fqRfDHgwJhEnI/mQGu99NQ7vaoIQ+JyGm4zclhfcDrRt
         CSuw==
X-Gm-Message-State: AOJu0YyIxO2bfdkxtPb8H9NnERB3Uof/++NeIr//mvip3X43qymzXz1A
	K2lzhYHgPeY1wmy45FnAbRC5l74SHn421NY4BuwaDXwvXNE0UJSFuvUue9k4DIMq+ky/S2RUu/r
	5rQ==
X-Google-Smtp-Source: AGHT+IF+SiLDo6I/7KX+GUDAeZrbAeuXqpvDOf7PYTATYP/HNqTRbWNERG9q4U91Ijj8cK+Z0sZXhGwU2PA=
X-Received: from pjh15.prod.google.com ([2002:a17:90b:3f8f:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7895:b0:1ee:8a68:f83e
 with SMTP id adf61e73a8af0-1f10ad7cff7mr8351116637.20.1740618805598; Wed, 26
 Feb 2025 17:13:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:13:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227011321.3229622-1-seanjc@google.com>
Subject: [PATCH v2 0/5] KVM: SVM: Fix DEBUGCTL bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Fix a long-lurking bug in SVM where KVM runs the guest with the host's
DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
context switch DEBUGCTL if and only if LBR virtualization is enabled (not
just supported, but fully enabled).

The bug has gone unnoticed because until recently, the only bits that
KVM would leave set were things like BTF, which are guest visible but
won't cause functional problems unless guest software is being especially
particular about #DBs.

The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
as the resulting #DBs due to split-lock accesses in guest userspace (lol
Steam) get reflected into the guest by KVM.

v2:
 - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
 - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
   unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
 - Collect a review. [Xiaoyao]
 - Make bits 5:3 fully reserved, in a separate not-for-stable patch.

v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com

Sean Christopherson (5):
  KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
  KVM: x86: Snapshot the host's DEBUGCTL in common x86
  KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is
    disabled
  KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
  KVM: SVM: Treat DEBUGCTL[5:2] as reserved

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  8 ++------
 arch/x86/kvm/vmx/vmx.h          |  2 --
 arch/x86/kvm/x86.c              |  2 ++
 6 files changed, 21 insertions(+), 9 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


