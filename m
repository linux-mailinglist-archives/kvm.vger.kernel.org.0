Return-Path: <kvm+bounces-62052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57088C35EE9
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 14:55:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B22F518C7992
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 13:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF2A3254AB;
	Wed,  5 Nov 2025 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LF1M03Aj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D73320CB3
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762350911; cv=none; b=ioMJDMWao709TlXmQJTPpuH2DDJKZKvf925oDEvfGkVPdcSU3ZR8sFa8Lw+1eTrsRFnZbATvFmNvfkRt/qEjT5fI7v7KGeHp6gMan8V+ZQGA6EgL9WWl9ZQ3U6zZY7adDoGpDl+MUOGCdSBJDJyb4i29WeOvLCgnn0E/0UZJEYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762350911; c=relaxed/simple;
	bh=SPXdnNRcrMHhEFoAZ0SK2hGx2kpGzR+ek6KvyCQYrCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fg3+IUlPGqByP2nFNQt5DgGv4OAHO8ZZmlGRzo5ae1ncYv4VumSyq7szsE/yOSactHqfS0lmEs4AGezwtfp1C32nGPdz5SDvS0ttAbQdO4/XgGgKEimowfn6wX47Bk283aApO8JRpKfhnov0Frbm7To8G7iMB5LY8XneE89Ymsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LF1M03Aj; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7aea19fd91cso653317b3a.0
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 05:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762350909; x=1762955709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OJlKW/m6trI8y99S9SvdMNz+LWIPmPAKJyUL1bEks0k=;
        b=LF1M03AjRI3jiTOMvbiaLNBX60oB5Hiw/JkYCwBB+F4i+UMWZM+T6h9oq0SEvaiVpx
         FNOQhE3RJ/qu47SgqlaYfyZHOns4GLmx77JZwCDBYxnJgx1FyooI4zB8AgTvk7IzmJAn
         6LFn2u+TGYpu+drinbIgtNnzKrlHZ3rlwr0qLNt6h8nryuNDFCVR9irF5Lh1Kksp/lul
         k4vrcK51T74imaLAnRxBnYSdsUyboktpTwIn/JB/UMbjp6gbtAiM738d69otf+8Gc5yR
         yxvE9aajHQyC1sTAZQbqRlFEapP4LW1dBuPZPUh+UMQk7ITcVbjfXwsu9GX+LJTr7Qh/
         zwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762350909; x=1762955709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OJlKW/m6trI8y99S9SvdMNz+LWIPmPAKJyUL1bEks0k=;
        b=k2C3htPE08ZgyJhmv8j9jweM98g8x+T+8f4e8N44u4xfJwkG6v88kPWpHiHnIK2JU4
         cgipd7lEOtgaWiGq7eAN3dOdn9OOnXXs0bczW6xh+E8KdQKCQdxI3/pYq88aruZLGe1Y
         VrGi08EJ+MyAxWcBKn9dJpNwpe4PUqaEpjsG9P05wsn+oFiZq4q4kF7KbBu7fvWkkldA
         OEn89xKVj9sPnCl6I5cWA8lc490KB8dFYbpKtkQy4pLJji0NRUrsXKrtqH04bkx61uez
         l5gKyB1V9YTwmd7o8Dc75Of3/0SdLs0ZrObyzGkOyEXx9WFqHVn/uNpWYmdER9u297zj
         jPzg==
X-Forwarded-Encrypted: i=1; AJvYcCX9Zc/crhX0s98cSfkv6AG0y+opzLVdbymmM9q+5nICyWtO+WBo1HbR4d7cm9/TtWFDkPw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7tc+J25/1gEjZpomHzSxB5iV4W0pfWf9p53QOCr1sqSSo/Z7Q
	n8+s982Wc9D5GXmdr3IHM08ZjBrwMNWAKqBjqiEF1QUPQSZekkfVfqx4
X-Gm-Gg: ASbGnculqCkmNI8epuayFytzt4K77N7joT6FLhBNaJsFc3+zA0/FZWGquYCzzhL1Avk
	wEowHGgmWMxvEkRlhjXafRW07av0tUZeR6xLZu9S7yWA1e5pU5VlBR22h+Ocs5919L9G0DdMrJ7
	fXORdP3w6PQX+SB1vABXZXv7aLeA4VTAjvXqMH660cR53q3MR2a1YNRohDkqmTvzMb2iOY/iZAq
	KtQriAYRLDvHYTRLf40Q46LtO1nw28w3qEn6VMUq6G4c0NhwO/0Zj1YQ76fe/7fqUPIKLPCyhPF
	ty6gXlOveRP3PKtjO9PLgsTbNRxAEfXRqbeWidog7eS2pgSSbNtuF6xzFSDW2P8wUvNUUHYbHGG
	uVkGFd7wsuI/632hh1EcVt48JJE1QNdBvzNOdAU/sGmylsH79QsK0AoUCLMpcIS9Xywxougci7d
	2n1quK3R0MZAZoVA==
X-Google-Smtp-Source: AGHT+IGvBZtGexCqPRCEXHwELt+N8SgQVO5WlxnDkfj6ON9Mo7Xjf5egZdjImwAsnQkJ/f2ooOccWA==
X-Received: by 2002:a05:6a21:338d:b0:33f:4e3d:b004 with SMTP id adf61e73a8af0-34f8601d2c6mr3941581637.47.1762350909040;
        Wed, 05 Nov 2025 05:55:09 -0800 (PST)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd3246d33sm6467321b3a.13.2025.11.05.05.55.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Nov 2025 05:55:08 -0800 (PST)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	yu chen <yuchen33988979@163.com>,
	dongxu zhang <dongxuzhangxu910121@sina.com>
Subject: [PATCH v4 0/1] KVM: x86: fix some kvm period timer BUG
Date: Wed,  5 Nov 2025 21:53:37 +0800
Message-ID: <20251105135340.33335-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

This patch fixes two issues with the period timer:

=======
issue 1
=======

If the next period has already expired, e.g. due to the period being
smaller than the delay in processing the timer, the hv timer will switch to
the software timer and never switch back.

=======
issue 2
=======

Resuming a virtual machine after it has been suspended for a long time may
trigger a hard lockup. 

Marcelo also talks about this issue in link [2], but I don't think it can
actually reproduce the problem. Because of commit [3], as long as the KVM
timer is running, target_expiration will keep catching up to now (unless
every single delay from timer virtualization is longer than the period,
which is a pretty extreme case). Also, this patch is based on the patch of
link [2], but with some differences: In link [2], target_expiration is
updated to "now - period"(I'm not sure why it doesn't just catch up to now
-- maybe I'm missing something?). In this patch, I set target_expiration to
catch up to now.

=========================================================================
other questions -- Should the two issues be fixed together or separately?
=========================================================================

In the v3 version, I split it into two patches, but since in this patch, if
it is found that the advanced target_expiration is still less than the
current time, target_expiration is updated to now.(If target_expiration is
updated to 'now - period', splitting it into two patches would look better)
This would cause a reversion of the code in patch 1, so in this version of
the patch, the two patches are merged into one.

But keeping them separate helps clearly show the two different problems
we're fixing. So, I still don’t know what the best approach is. Please give
me some advice.

Changes in v4:
- merge two patch into one

Changes in v3:
- Fix: advanced SW timer (hrtimer) expiration does not catch up to current
  time.
- optimize the commit message of patch 2
- link to v2: https://lore.kernel.org/all/20251021154052.17132-1-fuqiang.wng@gmail.com/

Changes in v2:
- Added a bugfix for hardlockup in v2
- link to v1: https://lore.kernel.org/all/20251013125117.87739-1-fuqiang.wng@gmail.com/

[1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test
[2]: https://lore.kernel.org/kvm/YgahsSubOgFtyorl@fuller.cnet/
[3]: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
[4]: https://github.com/cai-fuqiang/md/tree/master/case/intel_kvm_period_timer

fuqiang wang (1):
  fix hardlockup when waking VM after long suspend

 arch/x86/kvm/lapic.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--
2.47.0

