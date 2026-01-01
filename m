Return-Path: <kvm+bounces-66912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39494CECEB8
	for <lists+kvm@lfdr.de>; Thu, 01 Jan 2026 10:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1915300CA1A
	for <lists+kvm@lfdr.de>; Thu,  1 Jan 2026 09:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872A528CF42;
	Thu,  1 Jan 2026 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itPhK1UM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rxA+j7IE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4F289376
	for <kvm@vger.kernel.org>; Thu,  1 Jan 2026 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767258325; cv=none; b=C1tzlrhOogy8rG2CyieF/kmpZI4Tl0oJBRAfDNmTqvSCmn5XxE5BNvZnWv4GfNs+p0oaWlBR3xhYllNYqCnwsk7EFiMb0BMOnBz8gUMp7yM7bthbsZdlmn1G1rMbVYs34awSMKusuBri7/aLnXACModqWm+6WcY8p2DvN5qK80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767258325; c=relaxed/simple;
	bh=QecIbI8ayv5frn1nCSUZ1SrVTu0TcbdLc3zmHPbFHJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E29unQU09oz6wlOGjglyD8dh4jkNQL+BTDmFa0SGATeC0sJLOTiXU5xAWC23EjsXvKV5rwmypWj66A+lb/MTNyUvtmST09BSYVsuAyEftLgp37V1rPwYEI49AlY8yX6AGmyOUPDLjl6mVWzffi9LNj4zeWc0GQWmPnCemBekIz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itPhK1UM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rxA+j7IE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767258321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UlAEzcPXR845UamWej3hkdwwZvPd+P/8Ht0alhVeA1k=;
	b=itPhK1UMG7Pfmog2GCKoZ2RW/ecL0ze0f3AqdLIMvMqEhIvoKALnO7ebFdPBZBQ13IzCma
	OaVqiLo0BKmWaRo3UlV7BQLGb8ogcIu723DTJrb5xH7sVX1Rb1+KDxoGfiXi/gsiNYQWBo
	32+lF/hVfCJfWLENIDaj7dBWAVEhuYQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-HCNweomANPinu2t-Dsy4-A-1; Thu, 01 Jan 2026 04:05:19 -0500
X-MC-Unique: HCNweomANPinu2t-Dsy4-A-1
X-Mimecast-MFC-AGG-ID: HCNweomANPinu2t-Dsy4-A_1767258319
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso41620355e9.2
        for <kvm@vger.kernel.org>; Thu, 01 Jan 2026 01:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767258318; x=1767863118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UlAEzcPXR845UamWej3hkdwwZvPd+P/8Ht0alhVeA1k=;
        b=rxA+j7IEW/82sHOtLfrjpGwbuE78voI36ix4GlAyCqaNRPg5zN4W0fiHXuAdMmESeU
         HPTJ/nl4c97P4HeN0QbSH7S3yAowyIkKeYaCz42wY9Fp+fNFpacr3ERKECszRmKnsZxw
         9J9T4eFAnQVWlhDqiFnXHqnBT+XXKm0OUM5Qrm2wb9sfQs3+XcyF4B7cFuqxXDydBYpW
         rzFxa3U2pox7A4JGM4EFKpf6Zw+UEqLYIMSCye4lgVoQKDsSSy5Bc9MocD+uCkuRbQpf
         vHQn63usM67jbQeaX+Jl/to4RelpqRgOZ385pxXlBX+EbAUBCoww34u4FayTc1JdP+Oh
         6xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767258318; x=1767863118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UlAEzcPXR845UamWej3hkdwwZvPd+P/8Ht0alhVeA1k=;
        b=VtLvzwe8PzaYp/V8MAUFNA/LkMB07pT/n3Vh+cbWqqITvKCY9rDsLSTquLr3DxmDHA
         4exn1BLG6PukHT9bA1Zzz20zzUwLGyrGDsnNxpPIMUL4pMfizc3ANuyQAnsTjwWaKoHo
         lXk/yzXejgqNir8Ryb1m/i2AbS2rRtDAfXfzjDp6r3/ZJJ5URoEHLJE3U4Nycr5vl8VG
         Jw+aFWq9pg2Q7AXIbAL0FG6aV7AjM3sic7w5zKySEsYrCc6rPNO0D/3LTILgkNhDWVdg
         nHe6KSQ6U45bxHtv+CtDRGb8VV2jlj42JQU+Qzb13g2uIXGoNEw265LOM+XX6yOOnGXS
         R85g==
X-Forwarded-Encrypted: i=1; AJvYcCWmKlBE5VaG5ZXhzg4QewQwJ92ftS/ppEyIXroMs3MiAkumwelak1ejaghHNFkaIP1C1ww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/n5QXhPo2NnTQWUd9O1VzB5vwnVfx2uzeHtxtUYNA1wLjRL9W
	3xSp0zV/GgPZsyC08dEvpskr1AEINMcO+LTbqCJtugMGoo+7dkUcQTXqNKIBU4N1+leTc/bFPvw
	u9NO4p+ubGHMcjjfEH8D4PFgn7KfQOj+Ew+VP3jobcsBeBtVHDwU8OQ==
X-Gm-Gg: AY/fxX4P3rvINplXVLJXMTyCsMwbw4QRjQhcccF+qmbIWQFhBeGTGksESVuKwmTQHus
	90UnJXqqYpUKFCVqD0a88pT5DUCduzv61QBk2iUc45YOgWF1bLARLEPk0Ikx62aedlMCDgQ6cFD
	kBfkR3OGMsrCuF8zrf9tNyqU+KQciltDWVTACpoMpHEoA9WXdK1a+GBYQIYi7TouCciPJg2yixV
	ir9vfABpO6uveJZNGavo7cxzcZLyBJOr4/qfmwzTwv49sqal5r9ZAY30ZgYQ/Zswokp0QaqNqtb
	48WSlF3cHIZw/PmNG2ZorhjIl4LgOZAxLbfWyOf/mgg5Q7VzlpWZLEV7Z+Tjscpmv6gE+EIkmaj
	Df24TZIG6D/atWjFzrp7MdeVjzPYBU3VpYBHzbYfEFzunIuy9wlp6CE72VTldyd25GtMLIKImFh
	R35GMRSDW0UQ76Ug==
X-Received: by 2002:a05:600c:1d1d:b0:471:d2f:7987 with SMTP id 5b1f17b1804b1-47d1958f9c5mr445504445e9.26.1767258318517;
        Thu, 01 Jan 2026 01:05:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnRKxVGahaGqq0YTZ2CUKQ2TtfV42YjByKztYMXCFLLp/SOg/1JjoMPjiKkrkVYXp6l52M0w==
X-Received: by 2002:a05:600c:1d1d:b0:471:d2f:7987 with SMTP id 5b1f17b1804b1-47d1958f9c5mr445504105e9.26.1767258318083;
        Thu, 01 Jan 2026 01:05:18 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3aac6d9sm306477025e9.4.2026.01.01.01.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 01:05:17 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org
Subject: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
Date: Thu,  1 Jan 2026 10:05:12 +0100
Message-ID: <20260101090516.316883-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a possible host panic, due to an unexpected #NM, when a KVM guest
is using AMX features.

The guest's XFD value, which is stored in fpstate->xfd, is used for both
guest execution and host XSAVE operations.  However, the guest-configured
XFD setting can disable features that were enabled when the guest executed
XSAVE, and this causes a #NM when executing XRSTOR on the guest FPU state.

This can happen in two cases: due to a KVM_SET_XSAVE that includes a
disabled component, or if an interrupt causes XSAVE to be executed
before the call to fpu_update_guest_xfd().

The first patch fixes both cases, the rest is improvements to selftests
in order to cover this test and also verify that #NM faults are injected
corectly.

v1 had extra patches to export higher-level functions for KVM in place
of switch_fpu_return() and fpregs_assert_state_consistent().  Those
were part of refactoring how KVM loaded guest state when KVM_RUN is
issued, but are not needed anymore with this v2 fix and I will submit
them separately.

Tested on a Sapphire Rapids machine, reviews and acks are welcome so
that I can submit it to Linus via the KVM tree.

Paolo



Paolo Bonzini (2):
  selftests: kvm: replace numbered sync points with actions
  selftests: kvm: try getting XFD and XSAVE state out of sync

Sean Christopherson (2):
  x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
  selftests: kvm: Verify TILELOADD actually #NM faults when XFD[18]=1

 arch/x86/kernel/fpu/core.c                 |  32 ++++-
 arch/x86/kvm/x86.c                         |   9 ++
 tools/testing/selftests/kvm/x86/amx_test.c | 144 ++++++++++++---------
 3 files changed, 123 insertions(+), 62 deletions(-)

-- 
2.52.0


