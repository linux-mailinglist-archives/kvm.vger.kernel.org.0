Return-Path: <kvm+bounces-60465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C11DBEF3C7
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2DAC33490BF
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 04:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA872BEFF1;
	Mon, 20 Oct 2025 04:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NzraLz31"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB66A2BE636
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934074; cv=none; b=JCstqK51qI9nFX7ADgrnl28dzeQlw2cEPLHRcugv4flDnFBzWXpZetEUz6R5G4eKjvRM3VVuL18bGnY+pdNnhr9QiMhGmxEaQ1BAw3TYnUqg7rH1dPOmzX6VvhoeI5Z9TGoevWIWHJL+euqW4lxKAlxlRS4/IfW2LTMqMIA76ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934074; c=relaxed/simple;
	bh=KSjoxuwSlFaFq4TJcoW0tRdCftkDMdzYUiOjhUqgUR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XKR1vgX3h/oFsCVvUymDJg+9SQtnb8TVtMhcIQuP//U3UBwC3e9tq6a1Bcsgg+1NId/Z8GzocloeutYBHGdONstYJgI5ZpZwPnNYZ3y2KsaUX8XPxmFR9JA02ktDoU/MuwVnGMX8q0tSomx3FUDpljqFV7zdAinEe0o4urSZ938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NzraLz31; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-33ba38ed94eso4347069a91.1
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760934070; x=1761538870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=conQFyh0ywHaD293wZYZONSgw/GLLJWk5gnj1mP84r4=;
        b=NzraLz3102v6ehlBEAVRV9f1Ok1HDyPK+1tRUW79Wa0oG7FGeo7ruUdMP1CeyBjm8y
         n+0+oPEaUTPef9c6NFgmz4m4MqXFUxhpzQ+Rd+HjvzzA0m1PimfQR2oSTLDkTPyJurkD
         zS0TSjk/KWlXvSnRfN5W1cUH9C0upyQjZ6Sn1DacODGoLgQrM1w5tqvujyFMOPboYv/P
         CIT3qBZJkB+ri82n0Q3szP/QCDewqZ3A0FqMIC2aG4Lp9cumz7a+W3fqKy6SQdCqIi5s
         EHP3M9HW5Gb5shh5r/m6+YtFvn2/unBxzGZhMETpCv24FPAiLTLw7hmJ/i5HSVzcftrT
         oRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934070; x=1761538870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=conQFyh0ywHaD293wZYZONSgw/GLLJWk5gnj1mP84r4=;
        b=AAqqPb7r1j9tc3wX1Z6zONB3srpABgLV66nlbsoFbrQek0sBkqO8wcD3ohGb3v5GKT
         ut38UPXSWqFFQiYk26gMGPLEaHCPL4y0BWOBmT/YTuhFlMIJMdPWDvPSJsYV4Jmckwes
         /aJUDupA9u92NCKBf/uG9s2ClK8IGXU7AJfZDVT2FxAxf4gHa2P4lE5Ygmoql9t4463v
         j5p/rYi+pbeGaiYIzzTTxvzyHrBJifzog5bBo7jKWXOvtS3b/5i+GOtni3ZTOLQeZle7
         +j0G4R2LyOuQ8l7X+OHJYfbIWriDrl4n5omwe8rhr2ROlaw+sLViozOSPjOvQLndPHJq
         1wWQ==
X-Forwarded-Encrypted: i=1; AJvYcCURhCq+4+Di42IF6D9fu1auHwHTet2FI8rf5ENuBg7uLbxWctXETRei6jNL9qa/jgjeDIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1iaXec7WakH+BlkETo8pa+z5Z5psC1dyDMn3FP8s8HIzy/dd0
	rciWAVziUXIEFLVOsufwlUM+jk8QSsPtvF5/I90gAspLJbiVcLmCSjfdhvQhKwcDTJo=
X-Gm-Gg: ASbGncvRNCBV/m18+8M9AIIvEtWiz7slPYU4Sqm5Tz37BWJwE2B3swD2eiGbyFv5P5e
	G3B9YdqaiQE5RQr1GUQcoD+7G1042HgzU2AyUUU6whNZi4asKDCgpelZ4O40mCMkD4U1ezVffRc
	GHDG0GJAWGrEXiFRWAOVm4stABNVGNrGrOWpc9XQlOM0wEJ6xNr3HXiHM0BinIvvXQCojp4VIzS
	sQsidxUJNLTVnd5zh0HJlGy+F4UOHMEGRUJ4yJi4Hf/bJ6CmdmKTkSuQp8MGy+YjIHYGkDEEWDQ
	F3CfExp/Lg9/rZLLGbIgN2uh6XFDO5AMVspGyvbv2ZWwm3Ma5R1igbrWMoYaqJzvCuAXhkA3CiC
	2di0OAZw3gmCy4lS35Pt186HxYHDNwYegb1ZZihpnm5aGrfhUz/qvCMDQgvEtPgJdC6HB5GZENo
	gsmBOtqWmwTeozcDuCanRciSEsfBdlJbYrDGL2PpsB6wrTMK7pIyexe+cBicFQxn1gG5VzRJkXR
	w==
X-Google-Smtp-Source: AGHT+IEdkgCehFcbIRaUApmCfafCEhZVkAa78hZZpBjec5gPS2C5TVHNU0zWNgu3Z2IjgaK3I7rtpw==
X-Received: by 2002:a17:902:f687:b0:26e:49e3:55f1 with SMTP id d9443c01a7336-290c9cbc867mr157233355ad.18.1760934069971;
        Sun, 19 Oct 2025 21:21:09 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ec14e9sm68762035ad.9.2025.10.19.21.21.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 21:21:09 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	guoren@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	lukas.bulwahn@gmail.com,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v4 00/10] riscv: Add Zalasr ISA extension support
Date: Mon, 20 Oct 2025 12:20:46 +0800
Message-ID: <20251020042056.30283-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds support for the Zalasr ISA extension, which supplies the
real load acquire/store release instructions.

The specification can be found here:
https://github.com/riscv/riscv-zalasr/blob/main/chapter2.adoc

This patch seires has been tested with ltp on Qemu with Brensan's zalasr
support patch[1].

Some false positive spacing error happens during patch checking. Thus I
CCed maintainers of checkpatch.pl as well.

[1] https://lore.kernel.org/all/CAGPSXwJEdtqW=nx71oufZp64nK6tK=0rytVEcz4F-gfvCOXk2w@mail.gmail.com/

v4:
 - Apply acquire/release semantics to arch_atomic operations. Thanks
 to Andrea.

v3:
 - Apply acquire/release semantics to arch_xchg/arch_cmpxchg operations
 so as to ensure FENCE.TSO ordering between operations which precede the
 UNLOCK+LOCK sequence and operations which follow the sequence. Thanks
 to Andrea.
 - Support hwprobe of Zalasr.
 - Allow Zalasr extensions for Guest/VM.

v2:
 - Adjust the order of Zalasr and Zalrsc in dt-bindings. Thanks to
 Conor.

Xu Lu (10):
  riscv: Add ISA extension parsing for Zalasr
  dt-bindings: riscv: Add Zalasr ISA extension description
  riscv: hwprobe: Export Zalasr extension
  riscv: Introduce Zalasr instructions
  riscv: Apply Zalasr to smp_load_acquire/smp_store_release
  riscv: Apply acquire/release semantics to arch_xchg/arch_cmpxchg
    operations
  riscv: Apply acquire/release semantics to arch_atomic operations
  riscv: Remove arch specific __atomic_acquire/release_fence
  RISC-V: KVM: Allow Zalasr extensions for Guest/VM
  RISC-V: KVM: selftests: Add Zalasr extensions to get-reg-list test

 Documentation/arch/riscv/hwprobe.rst          |   5 +-
 .../devicetree/bindings/riscv/extensions.yaml |   5 +
 arch/riscv/include/asm/atomic.h               |  70 ++++++++-
 arch/riscv/include/asm/barrier.h              |  91 +++++++++--
 arch/riscv/include/asm/cmpxchg.h              | 144 +++++++++---------
 arch/riscv/include/asm/fence.h                |   4 -
 arch/riscv/include/asm/hwcap.h                |   1 +
 arch/riscv/include/asm/insn-def.h             |  79 ++++++++++
 arch/riscv/include/uapi/asm/hwprobe.h         |   1 +
 arch/riscv/include/uapi/asm/kvm.h             |   1 +
 arch/riscv/kernel/cpufeature.c                |   1 +
 arch/riscv/kernel/sys_hwprobe.c               |   1 +
 arch/riscv/kvm/vcpu_onereg.c                  |   2 +
 .../selftests/kvm/riscv/get-reg-list.c        |   4 +
 14 files changed, 314 insertions(+), 95 deletions(-)

-- 
2.20.1


