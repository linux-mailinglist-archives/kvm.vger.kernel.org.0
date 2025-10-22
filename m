Return-Path: <kvm+bounces-60831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4331BFCC30
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D7BB3B1DCC
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75259347BD4;
	Wed, 22 Oct 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWLVuh8e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316EA20298D
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145288; cv=none; b=K0BobnIbdWrsgkJZRCrB41DQSF81yIBoL8nR6JezztOq9OviBg3cRx/F0kwgL/jAqmY8CCNIPJbZ6fWkh44oyuhkOpzT12dhPAbAUtMLGYna2P52CR+0K/i2D4ZJkuoyvCyB7VwwEVi4zE9odFF21ygsZtPU4Pv3V9ZpLYKGSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145288; c=relaxed/simple;
	bh=mEnMsksYyQt5aEAUXre8DN1ukr+yNhOXBpn8bpnEj/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YM4mXdHLImISQwcVLfjPGXIFITCwXCGCKXf/tpq4bpCP/QMDkoWtz/V8Ah1Tquhr3KyLckzG+Ztjb+SAAH39iytTAWYvhNTJXC8a285FDcovP8FoSuTZSrevH48lKShyaYszmM5hfE4JaMzp1mUFXAaQ9427hB0g0WdCJ/+i96w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWLVuh8e; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-78125ed4052so8426938b3a.0
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 08:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761145286; x=1761750086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BKHUhsWN+6UVYafe0YQA/a4l4Z1s6RddT15lV1Hyq7s=;
        b=nWLVuh8eAma3y9WWnEjtJVbN3aS0mmzfH+9zArkBFs5BH/PTFZxANxPc6OnWHLTS5M
         6k15KBVvAbzSzgyGDtk/SJTh8EyHjcGhwG6oHhwvVT32IJFRsIM8bpwFzrqxB58pHp/8
         8mpLuSOeP8n2Qw1MAVSd7AnIBWJw1nzSPjyRXqDqhAkcu75Kmz0H3wcHEg0x/NjFdWlU
         QFlDG/mcMchcAJ20gXWvZ4+haxmSyfRqqayeqoUkqwAeSCV93G/NmvQQZgaXLfOcltKL
         59jdNdy9sfN1+sNvgjyZnwM4n/+UuihyI9mqkMuhiReYZLCsib7Ep2VNkm/gEDP3CV38
         Uo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145286; x=1761750086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BKHUhsWN+6UVYafe0YQA/a4l4Z1s6RddT15lV1Hyq7s=;
        b=FHvdO5X/U9JukgCZKKLEczcwPloQa6OrpDdXVtiQoJ5YcamDpw1Huk1nfTm5XJxOPY
         C3mK+LS4pD+ExFLa+6wZmxXP1nO9lrq4HTupomuti+TNMSVZA4pR3Z/Yona/bEahqEGI
         bypew/kgqHyfz+dd2kLb+KqSVRiqfiQvi1o2L2VNV3B6ZnE96BDGuMzvbVMLU7EGoyfT
         up5TeamYxB63LlauY0A08uxFZ0eddLN5NV+EuoDkZ6nEqzktcA3OkiOnvaZUlC1hWYy8
         tm4bB00CoqXGAzk1/Ywp5+fDk2W8S+OA6AFM7kUcQb//iD8K9eb/xnTVLhFHnqvAp2om
         hUfg==
X-Forwarded-Encrypted: i=1; AJvYcCVzYWaihIpSPkgXTfeUsAMPaSFJzSMxMbzwbWNsVlE07RQQmlReqY0PlQMzCCPzFqdhuxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPCAFokYUD/8LklJX9w+YzLpgnMlsDmgvUrCdJNWS47BtrsmgZ
	pKFPF4OM+u9lerdlxN6vIbIGV4R72NcOSX34c5wihXc+DMOFhpkKRgDN
X-Gm-Gg: ASbGncuBsTI1C4A5nKPXszwuJTQpxta9463QtwFErtmZ2Oei938XyTaiuPfQ9YiJyN2
	QAiain6LDgKDxycgu3mmBzFHAlFntu6Gf2f1LWh/fU1cjl7mz56vvZLEvfUImsYwLguysfiNqMB
	Rkge2ER8W6OqyKeI7qmMRRcMd3Qa0LqxpFD+jtKDSGGBQEVPFG1Q1gz+WI3rREnwJg4klB5d96r
	VkEa611Zl298DoLG2Z1QJdmOoDnbi7gsbiaaNlEaRnnZ6bmk/D11ixc2q7GKeupVsg9/Uwp4j9I
	mrOUrB4oi7/tx9CXWmBzZfpB190PXt4i9tbCn1/GmXjXG16AUk3Rx7S/LkKGtNsSbRTQerlyCN9
	boTxfGrd/dlEAVVNPt2xYkTtnd0l/io5DFKBQlaIWHAbRWQ2FziqG5A/Es4vCa8SLurBr2nW+rs
	bptFpPAiZ8flhB1d2159dDmFyH4RK95CqJPt2Va5bxq2mkVJ0=
X-Google-Smtp-Source: AGHT+IHmIj5wlg+sqbx3TBr4eoLGV97MO266v8/FfvoVdqDwg7vTEnHrGPmGrUsibDIN5GLsYR2TBw==
X-Received: by 2002:a05:6300:210a:b0:32d:a476:7075 with SMTP id adf61e73a8af0-334a856e51amr28088437637.23.1761145286156;
        Wed, 22 Oct 2025 08:01:26 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:8685:174d:2a07:e639])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e3125a3afsm1973624a91.6.2025.10.22.08.01.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 08:01:25 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	yu chen <33988979@163.com>,
	dongxu zhang <xu910121@sina.com>
Subject: [PATCH v3 0/2] KVM: x86: fix some kvm period timer BUG
Date: Wed, 22 Oct 2025 23:00:53 +0800
Message-ID: <20251022150055.2531-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following two patches fix some bugs in the x86 KVM periodic timer.

=======
patch 1
=======

The first patch fixes a problem where, if the next period has already
expired, e.g. due to the period being smaller than the delay in processing
the timer, the hv timer will switch to the software timer and never switch
back. 

The reproduction steps and patch verification results at link [1].

=======
patch 2
=======

The second patch fixes an issue where, if the first patch has not been
applied, resuming a virtual machine after it has been suspended for a long
time may trigger a hard lockup. Link [2] also talks about this issue.

Link [2] also talks about this issue, but I don't think it can actually
reproduce the problem. Because of commit [3], as long as the KVM timer is
running, target_expiration will keep catching up to now (unless every
single delay from timer virtualization is longer than the period, which is
a pretty extreme case). Also, patch 2 is based on the changes in link [2],
but with some differences: In link [2], target_expiration is updated to
"now - period", and I'm not sure why it doesn't just catch up to now-maybe
I'm missing something? In patch 2, I tentatively set target_expiration to
catch up to now.

The reproduction steps and patch verification results at link [4].

=============================================================
other questions -- Should the two patches be merged into one?
=============================================================

If we end up making target_expiration catch up to now, patch 1 and patch 2
could probably be combined, since we wouldn't need the delta > 0 check
anymore. But keeping them separate helps clearly show the two different
problems we're fixing. 

However, the hardlockup issue only occurs when patch 1 is not merged, which
leads to the commit message for the second patch repeatedly mentioning
"...previous patch is merged". I'm not sure if this is appropriate, so I
would like to hear your suggestions.

[1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test
[2]: https://lore.kernel.org/kvm/YgahsSubOgFtyorl@fuller.cnet/
[3]: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
[4]: https://github.com/cai-fuqiang/md/tree/master/case/intel_kvm_period_timer

Changes in v3:
- Fix: advanced SW timer (hrtimer) expiration does not catch up to current
  time.
- optimize the commit message of patch 2
- link to v2: https://lore.kernel.org/all/20251021154052.17132-1-fuqiang.wng@gmail.com/

Changes in v2:
- Added a bugfix for hardlockup in v2
- link to v1: https://lore.kernel.org/all/20251013125117.87739-1-fuqiang.wng@gmail.com/

fuqiang wang (2):
  avoid hv timer fallback to sw timer if delay exceeds period
  fix hardlockup when waking VM after long suspend

 arch/x86/kvm/lapic.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
2.47.0

