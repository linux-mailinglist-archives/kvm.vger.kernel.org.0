Return-Path: <kvm+bounces-63044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FEABC5A03F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 269D94E636F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E85320CDF;
	Thu, 13 Nov 2025 20:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bDSSWlBI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711D7320A2C
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 20:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067079; cv=none; b=I45XQ7pWUznqAjfyaYFAj4Xoi97hPuFoEXFng+6FQV8dHYIpMjaaTosoReT2/GC4jW/hsL1pKf7If9xxRJAyP34GX+zMnw58pvinOhWjE9wj4uJU/8EtybsLL/S2m+4RKZVkqCvpF/+vgO4DC97ZF0VL6Ui0Lr+0nGyt70wicwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067079; c=relaxed/simple;
	bh=nVsUbWX55uzgK6J9Yr/ClgQLgZwSXQ/StMxuzBhlwgY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MdVjCNd6c8p8XWx/0kgLgqEFlqc/DpcSJZgaiWtnZH9u4sgiElCsoyC204yWH9V9NtwK2NnX/b4y8zUNDq1YCEoXHV+vhb8XrhXyR0YvkYIJJMpL1OtrqGtY9lhH0czGPQN0XDWW4exJhraFcQ8o3JpHu5LqxS95+MmlQ2sZcGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bDSSWlBI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e1cf9aedso33048605ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763067077; x=1763671877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X7hRy0HCt1Eng7MibclXDrxk+TeuJTxt4V4onb3K574=;
        b=bDSSWlBIggC54kXndDCReuxD2baBwxE3tXejU/TzDdh65q1DnwnR/IO7oXoAgkJcrr
         cjTN6hNHVcbeSQI1jcAyXI8B8ryvtmqAqIimWoGxsZbpYYNw+x1pvlUOZ+BHN/quLArr
         6LhF9VLp0NCF2sj1s79HbhZxCkVzy5eNS/jc7P8LyKUZlHv32uwQA0iw/l0EPfGfsHG5
         MAeQyC5scQzTvd+aDJsjo0sEl0r4V9FboQsuOK5Gn/fZbMhZ4b4JsUo+Le1chEwKtDSk
         GloDrCa2Cxfs0P7OFofCQ5wX+JCyDlioTIWBMLTSEsB4Xo9L+/RLEYfsuV9bF8i/ORBT
         gBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067077; x=1763671877;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7hRy0HCt1Eng7MibclXDrxk+TeuJTxt4V4onb3K574=;
        b=Cemu/0G2i954iCggTRdftysDzZxfc3KxmrOk6XcpmXeb+d57tz58rqoauZ3udjltM0
         BJHGexJZN5hakuqo4RpHKIrE0ZyT6WFsWQ/JcZdAJB9ZT/PSBMgSRH8ksoIUKVHU7f5X
         4cGpBcv03vXhJNWx6wAriKNMrC4oFzfhM6+ct135L69fJvfHssSbmrV0ppEj7JNX4waZ
         BHI4xAeuOJV/4aksyfv5np8setb8yzcSx5m4bEauZfe5Pno9xDFW7Bd2F1P/1ygd+gnO
         jHfGnJNhMhXcCNwmdMjxIqdM3/3hLpvx4nRxqmvtNlhbqm/o4gsCi1p1/4o6UvBFLVbI
         UY7Q==
X-Gm-Message-State: AOJu0YxrJqYNukl3Q2GmiTLtHeCCEBLvXSvGAMC6tPHli5BJ6/T5yETR
	KsBimmCtgng+OxIff72Y/bDYi/28ZZa25v9BxiBOjYD9ZzUzxyAwT0ksDd5QDhVAJdF7XBRG9fi
	OkfRxYw==
X-Google-Smtp-Source: AGHT+IG6geoTDL6Wj81P7NtMvy8iWkplDZ/kI/8hgap463dB9GTsfnlAA5hWB/AQ64zzPBaSgRslbMtOwDI=
X-Received: from pllo10.prod.google.com ([2002:a17:902:778a:b0:296:18d:ea1a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11c6:b0:295:592e:7633
 with SMTP id d9443c01a7336-2986a72e2bcmr4097805ad.29.1763067077362; Thu, 13
 Nov 2025 12:51:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 12:51:10 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113205114.1647493-1-seanjc@google.com>
Subject: [PATCH v6 0/4] KVM: x86: Fix hard lockup with periodic timer in guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuqiang wang <fuqiang.wng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

fuqiang's patch/series to fix a bug in KVM's local APIC timer emulation where
it can trigger a hard lockup due to restarting an hrtimer with an expired
deadline over and over (and over).

v6:
 - Split the apic_timer_fn() change to a separate patch (mainly for a
   bisection point).
 - Handle (and WARN on) period=0 in apic_timer_fn().
 - Add a patch to grab a pointer to the kvm_timer struct locally.
 - Tag the fixes (and prep work) for stable@.

v5:
 - https://lore.kernel.org/all/20251107034802.39763-1-fuqiang.wng@gmail.com
 - Add more details in commit messages and letters.

v4:
 - https://lore.kernel.org/all/20251105135340.33335-1-fuqiang.wng@gmail.com
 - merge two patch into one

v3:
 - https://lore.kernel.org/all/20251022150055.2531-1-fuqiang.wng@gmail.com
 - Fix: advanced SW timer (hrtimer) expiration does not catch up to current
   time.
 - optimize the commit message of patch 2

v2:
 - https://lore.kernel.org/all/20251021154052.17132-1-fuqiang.wng@gmail.com
 - Added a bugfix for hardlockup in v2

v1: https://lore.kernel.org/all/20251013125117.87739-1-fuqiang.wng@gmail.com

Sean Christopherson (2):
  KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with
    period=0
  KVM: x86: Grab lapic_timer in a local variable to cleanup periodic
    code

fuqiang wang (2):
  KVM: x86: Explicitly set new periodic hrtimer expiration in
    apic_timer_fn()
  KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic
    HV timer

 arch/x86/kvm/lapic.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)


base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog


