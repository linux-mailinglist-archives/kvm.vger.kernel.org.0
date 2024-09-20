Return-Path: <kvm+bounces-27200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC6397D22C
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 10:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A33CB2243B
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 08:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA40A7E111;
	Fri, 20 Sep 2024 08:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXDlIzGh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFDA6F06D;
	Fri, 20 Sep 2024 08:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726819255; cv=none; b=hrleDqUP3jh8iBtFhazUNuKew+ElhNg9JZYxj7X/mP2wfuUHSNRgNb6skyR28TmRJlKuZpMT849NumUTmTZAG0XYpERwdfSihTd3j0GAJofg1AUTHC/dzCh1+roT+DC6u2xip71v5flm/vpPhpEqko3NRDnDEvieybLzgY195I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726819255; c=relaxed/simple;
	bh=k4UBv5oM8ZQK9M7hz87ok25yEW72lwpNhD8VMqaimyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h/+sSpV7+VW1ss++tiWYN1RLG2zHBBhL1i1Qazsg+hBLq7xZcT11DmtwWMQQeWrDW0eIS2DrB339jAFXozFN7hDRIJm3+pjMExAnlfLtkg8o50HopROf2aZs9+5vqlB0SltwMeoc463k/p/3wGleV5NeUG9KlBI5y0bHsxhWWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXDlIzGh; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2f7ba97ebaaso15506171fa.2;
        Fri, 20 Sep 2024 01:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726819252; x=1727424052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cKGSAgTHXJwfTJQ4CbnLCIVfjXQKqwfB17w7eFL+kk4=;
        b=RXDlIzGhVBXyhXb1UTOhana4Ilx66Bmke43kI6Fyb7wtP2JBM03beDNgYMnqgi8YvX
         SmG7p+NJmVzDS/xBf8JKKcNT75RVjHsXxiUqgq+zMwPMYkLOdPbrVSsT2gQmKpN2xz2W
         CVc1J6bnpzjQhDpNhUBW2LFY6P2jx9MwDYNMQsAp0JO02yUpJxGN38JGg+QV3m0xyFWu
         ZoZpPhH+3XPZ1ipBLVH3hFbimeUbKWKLcAhTFSQuU6IQnhmJ/k60z3Caq4Vo91dzMz+r
         gcrtigafnANanjkE5ACaq8sLqCWBK4Cy/OEJD/NBRTyxmAniwsnGOy5x1t2GuA6PEF89
         wu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726819252; x=1727424052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cKGSAgTHXJwfTJQ4CbnLCIVfjXQKqwfB17w7eFL+kk4=;
        b=eSTaf7aw/YNHzZ/NRHtYKDsGJ8nhIgVFqu2vNMa/mb1A9GmOojJ2sq0XB454ae9UBs
         e+lgISwnZOiMmMGNJcJlx6lYibpE41nJOt8XY4IQbRpd4rHIup4DhJzskRdWmOez7Itp
         F98W7c9jZC+zCZEnz6arCtKbb/zUy4AXuTzyQzqsxbXBXNBRhZMfA/CLZlcqXOA/z23d
         XwU/yV67+5ukqDtMBPpkGgcVJuQsr9TGy8UFKkBXvOoV71wv8T4SzDn4LEozXdE91RVF
         ToQ4Yz3xnsT42FiQjiqj/wLHW2Py0w3TSFXBE/c36na3Ijeqn6JIw/ZePDX1cyBS41kk
         ubzA==
X-Forwarded-Encrypted: i=1; AJvYcCU1jw9cl0+JbvYhd+Aqa7wzW7RyLHjLM43THonDOIC+bPaFOu3i/2HvpkRMBQ90tJcS80M=@vger.kernel.org, AJvYcCUjRqoppkWi7OVeSxgVKyfGdYu4Od4WD0TLW2EaKY2eI7bkuvMb1rBd0bIg80hE9Mozok12HM1mk/liRa0s@vger.kernel.org
X-Gm-Message-State: AOJu0YzrePPM6GggH7IFxDAaWDCb/NOrBlVS+m+oUApNMkXI7enTRLFv
	Z/NA8urXE4tsGe+LZzJcfB8zLVMRk6OGE4/08Ha9lytX0QGP4pWa
X-Google-Smtp-Source: AGHT+IEi0InguyJTVeAUW05C1ZpK+FrFhyDloEtZI0L5JXbPegVcd85wGsavAsedcuSfsSPmCagR+A==
X-Received: by 2002:a05:6512:3b8c:b0:530:c212:4a5a with SMTP id 2adb3069b0e04-536ad161b33mr1001511e87.22.1726819251762;
        Fri, 20 Sep 2024 01:00:51 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-7262-6300-2e4b-7b61-96a9-b101.rev.dnainternet.fi. [2001:14ba:7262:6300:2e4b:7b61:96a9:b101])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536870c55d1sm2070030e87.305.2024.09.20.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 01:00:51 -0700 (PDT)
From: =?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: mankku@gmail.com,
	janne.karhunen@gmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Date: Fri, 20 Sep 2024 10:59:42 +0300
Message-ID: <20240920080012.74405-1-mankku@gmail.com>
X-Mailer: git-send-email 2.44.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

We experience hanging of the guest when running a hypervisor under KVM on
VMX. The L1 guest hypervisor in this particular case is pKVM for Intel
Architecture [1]. The hang occurs when a second nested guest is launched (the
first being de-privileged host). We observed that external interrupt
vmexit would not be passed to L1, instead L0 would attempt to resume L2.

We isolated the problem to VPPR not being updated on nested vmlaunch/vmresume,
and that causes vmx_has_apicv_interrupt() in nested_vmx_enter_non_root_mode()
to miss interrupts. Updating VPPR in vmx_has_apicv_interrupt() ensures VPPR
to be up-to-date.

We don't fully understand why VPPR problem appears with pKVM-IA as L1, but not
with normal KVM as L1. On pKVM-IA some of the host functionality is moved from
vmx root to non-root, but I would appreciate if someone could clarify why
normal KVM as L1 is seemingly unaffected.

Thanks,
Markku

[1]: https://lore.kernel.org/kvm/20230312180048.1778187-1-jason.cj.chen@intel.com

Markku Ahvenjärvi (1):
  KVM: nVMX: update VPPR on vmlaunch/vmresume

 arch/x86/kvm/lapic.c      | 9 +++++----
 arch/x86/kvm/lapic.h      | 1 +
 arch/x86/kvm/vmx/nested.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.44.1


