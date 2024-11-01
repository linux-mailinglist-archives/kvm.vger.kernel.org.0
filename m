Return-Path: <kvm+bounces-30355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5C69B97EA
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 814C4B215BA
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAD71CF29F;
	Fri,  1 Nov 2024 18:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CVgcqjl7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990BB1CEAA4
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730487038; cv=none; b=n0MAM0lcLaAKBtRjUX0ERBPK99STNYuaDLCPwCYQymKqB4mEashd8WwyBLz55AZvONKogXgP5ICe2B4ow0euus0xQ1il00nP6tZExtmpfzxsBVbVLKaD0KEIGd0FWlJcSG8FC9PmG0RPygvLhSAOdz2xSrH/hZ7ps/z9apTXDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730487038; c=relaxed/simple;
	bh=FXRWG6o0mg3wHP5Y0GOHcde+Dpv3ygRaeRvyXI1QrgM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A+7cuwwOxXylFbmmYRxpqUHKm+fmQgn84y5KDjjB8HiNDNaWhKy31ZkI7jJ816vYsdSNMjvyNMP+XdA+Mpe1+LXh8J23IlOD9HbwubbGPmIPbrnHNNzfi16u/vDLUfyoh2b3OrBY7uVIpL1OYAYwJR+hkN/xxG7ksZkhuiteURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CVgcqjl7; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e33152c8225so676893276.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730487035; x=1731091835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qdZ3ib7R68FsaRnrZtmMP9G3NGB1gcRw7OH9rUl4h7k=;
        b=CVgcqjl7qQTUqw/BT/NNUXr5yG7I0L+uww/nDMxqe/dJ4oU5xtMCVpQ5LiFVbZ/60B
         WCpPm40yGnEXGXTm4wQQ9Uh79iCRr8JX/lw0s3r4SFk5p9DN6G2KMOyOnlR/KUD8+abo
         r+JIMjhbdBKvP4wQ3xhJTyuNF9oh42hwRCkBt32T0B8/eGOwBOH4BL3r7VwKI5xlgLVy
         OQFaxReXSbh0SEsTtFlRqTzSl7/S2FFzD9+z+IOiKhB9PibBBSAxcRS5UoH/KvYeQPyI
         JcMfvH6+ssQgtY1rBaIeR60Tmdb2bUnC+7KZd75jykBpbPKtLVfNMeHIx8twXJsz43Ki
         kFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730487036; x=1731091836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdZ3ib7R68FsaRnrZtmMP9G3NGB1gcRw7OH9rUl4h7k=;
        b=PL5MzUlB68dBvrdiEjueEUgLaiERIDTgtbx74p98Ej9tHFaxoKZPNGXe/li8y1eK5b
         3gY5llAOu26r11ChhJBHfemOSmsxhdT+ewgypp7w3hWk0z6XpTsXYq9wrxGAYs5PSdvJ
         VVS2KZ97QE++fyApjrbUa6JSA+G8oUPFT+rTpiFvE2aBXmxvs6jnt/lAsNlcWiZPsgLS
         gtuHytYnSY5/rUvSvkhaWUxGO4FhBp3S6HRvBfutlRA+skMOCeuD0WsiBp8arCiD8Bw4
         On2CRzxJjRzMij59Gz+78ouiwvbAaf8CMHmo7Ti85ofy1RpHkapJJvlmj/WP4+pMX6io
         APug==
X-Gm-Message-State: AOJu0Yz4u/sgRumAhmcYKp28WvC75yXdKRSwEJZm82vKfpLzCdXNehPt
	tbXEjgInFGihWF0XHBcMayq0Hk163wx6ZHZubBfV0v86eLNi4hMBvvn/4nAPR6THPFYYOV+VcGN
	EDg==
X-Google-Smtp-Source: AGHT+IGRCb4PioR1r+gwT3ZVZ/w8cEHMLugCvv7ve2RmE6Fwsyxp4YjGU/Mk4TgNku3bnUZSD298J4necgw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:2bc9:0:b0:e27:3e6a:345 with SMTP id
 3f1490d57ef6-e33026dcafemr2638276.10.1730487035748; Fri, 01 Nov 2024 11:50:35
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:50:30 -0700
In-Reply-To: <20241101185031.1799556-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101185031.1799556-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101185031.1799556-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: VMX: Bury Intel PT virtualization (guest/host mode)
 behind CONFIG_BROKEN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
myriad bugs in the implementation, some of which are fatal to the guest,
and others which put the stability and health of the host at risk.

For guest fatalities, the most glaring issue is that KVM fails to ensure
tracing is disabled, and *stays* disabled prior to VM-Enter, which is
necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
is enabled (enforced via a VMX consistency check).  Per the SDM:

  If the logical processor is operating with Intel PT enabled (if
  IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
  IA32_RTIT_CTL" VM-entry control must be 0.

On the host side, KVM doesn't validate the guest CPUID configuration
provided by userspace, and even worse, uses the guest configuration to
decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
guest CPUID to enumerate more address ranges than are supported in hardware
will result in KVM trying to passthrough, save, and load non-existent MSRs,
which generates a variety of WARNs, ToPA ERRORs in the host, a potential
deadlock, etc.

Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
Cc: stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ed801ffe33f..087504fb1589 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 0444);
 static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
 module_param(ple_window_max, uint, 0444);
 
-/* Default is SYSTEM mode, 1 for host-guest mode */
+/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
 int __read_mostly pt_mode = PT_MODE_SYSTEM;
+#ifdef CONFIG_BROKEN
 module_param(pt_mode, int, S_IRUGO);
+#endif
 
 struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
 
-- 
2.47.0.163.g1226f6d8fa-goog


