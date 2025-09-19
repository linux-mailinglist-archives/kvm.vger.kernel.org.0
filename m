Return-Path: <kvm+bounces-58118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF99B88331
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 882B816C56D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C2A2D23BC;
	Fri, 19 Sep 2025 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Q5Gux1KW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C52D2C2368
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267451; cv=none; b=QxxPAtisvrj+QLps9qEv3bU4wKnZ3Q7juqqZHi4ABeK1E+ryGuoYK3AKYfd4dZ1QVD+JYQxAsJBqvUYGwjA0nvzeHso2H41wxhGj6JMQsyOWHN85xuC4qXLl+xQN6ZtsFYgnmj0hzKlQb9kQ5UmVzy49TEMmraUKttH21qTnbkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267451; c=relaxed/simple;
	bh=v3TxNmA0pt+Qtmfll9ALOjz7DGAewRAEWKdgH99GYDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNvqkfU7An7W3JOAWG+J6APtTXdB0AmY3TMVth5pYSP3Jt/m+Xhk3McSfuD2ZXaTSc0pgHb8MW4ve8Jp25EjCdMY0/kNZMlApeJeUcsNwrheJKAFXPEYZci/tdctfXXuixEozYyzT3kuifVrnvEI1Ye9LDfMmRn2fLKcexmi/JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Q5Gux1KW; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7724df82cabso2221391b3a.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758267449; x=1758872249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nQi8kkf+E11TPqHviak6Q179Pwf94vhIPRCTAWlGN3c=;
        b=Q5Gux1KW7SwDslGyoFa7nd+K6JD3SQE52hUrRe3t23xylhZS72lTewgKtnLKDQuV+q
         M8/27673o9LgfZREIB1LbcGdicp+9gmk4rn29a70ERVOq8hiveN3wglytXZOndSEBAhZ
         oiVQ0S0X2qpDdS2ouLMD/dQ+4sy2km1v6DiY3DslT7mi7Y0D8THVqo5btMfkuDK5EVOp
         W1UwadLyDyQUVWGMsBahMvJ4ZDdbwkF0EwzPbMHePOFWe984ME4Cj6EllH2SaVduxoSy
         RDe6sV8KbkUo5s7pNzGTqHQ/eosWJr4jGrVBmMxPrKLWsZjiMVOiAM8xv/IRaHmcVeJu
         jG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267449; x=1758872249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQi8kkf+E11TPqHviak6Q179Pwf94vhIPRCTAWlGN3c=;
        b=V7mqY7KQaX0bd363yuNaUjI85FADYxU4kPSjkHMN1qE/4QRZIcr/D1Go9YBVMZCkaG
         1E0qcez8D58WoJqnZtbg7/+lvrplgLSoett3FHGKr4/h1q0n2ZR3FCh/qE6fposv0oqG
         yPme9KfcEDogHi0yL5cUu8MryfdI83VkuCGSi41o7WbW0YRJgdokxYfWSAb2IsZGxTcq
         +nhcoIjXlIi8BDc0gc0dmieMMBqilGf3AgxVFfnFh735O1uIVgQ+Wq0B055oyFQaCJml
         pnumjwVv5SAbg6hSk3ev/hThKWolZcSd4F1kkEwmE7jL3P8e8NM6Spr46HWuhplFtU/V
         PrbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb+QXY+o9vwf17+VaeyvyZW4DVw95dc+BuP6bRvq0ActuJC8ep1u8M5OBstkGUCbN5OG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YydLky1KOdIr4Y+GbjGaSqwu+AcyCKW2PDogEbmHCAJu6xTkfJS
	j+ieO89OqJub8hEDybQDBLJmUIDZ+Iw4DuL4qlJcF2LzNOeqPJtFFTV3YdCGoZmt0cQ=
X-Gm-Gg: ASbGncs23QRZQOBjPhqfk7w2Vijq7rc1O3gSpI5DizDwmBtmOsmApbO5/mhgl2jpHTB
	rVqMPd3rOcjMAGTpBj6jO8h9t8flB0dZKsr/xQZWR7W6iucLj0tREY5u8varJDaHTCAUOFiMjkx
	wIILImF//c8ghm1VCzGl41zhqBUv4Ma0Of228rCRI7bnGdSk69Kc489jApHN7bAwg2i4SchvSY8
	IotrugtpbFsXpaDi/dqHZQbehUA2q3yOjmfjmXkfwJFkoYeiQm2bJ6tSVfZvOhjjcbr0kFjHELE
	b4ECVeP49kkB4LAZnTFPFMP5NG810ycfiK035nOLRnhTKEMwa4YFORBbizBejIAiYvOboHpZLC5
	uipLyPXETcthVH8QfYvuYTNBxZ8RdGBkdBCbb1om9mqzVHL5D5+0sYP1e0A0fLKuf3qgCe0PUsr
	/QgO9+WRoBBgHQqT45jULvR6+BUf9Kq2UmtCbuXwU2Bd+OA8KryWE6
X-Google-Smtp-Source: AGHT+IGt4SFGJptpZ0jrCH0JCo7jlSYHb5iMvq47K6wOnBUV4fZAO0y+jOsnj2fzSLzf3+aWmVng0g==
X-Received: by 2002:a05:6a21:3294:b0:263:7cc6:1c3b with SMTP id adf61e73a8af0-29277cb8e9amr3774594637.60.1758267449202;
        Fri, 19 Sep 2025 00:37:29 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b550fd7ebc7sm2679096a12.19.2025.09.19.00.37.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 00:37:28 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v3 0/8] riscv: Add Zalasr ISA extension support
Date: Fri, 19 Sep 2025 15:37:06 +0800
Message-ID: <20250919073714.83063-1-luxu.kernel@bytedance.com>
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

Xu Lu (8):
  riscv: add ISA extension parsing for Zalasr
  dt-bindings: riscv: Add Zalasr ISA extension description
  riscv: hwprobe: Export Zalasr extension
  riscv: Introduce Zalasr instructions
  riscv: Use Zalasr for smp_load_acquire/smp_store_release
  riscv: Apply acquire/release semantics to arch_xchg/arch_cmpxchg
    operations
  RISC-V: KVM: Allow Zalasr extensions for Guest/VM
  KVM: riscv: selftests: Add Zalasr extensions to get-reg-list test

 Documentation/arch/riscv/hwprobe.rst          |   5 +-
 .../devicetree/bindings/riscv/extensions.yaml |   5 +
 arch/riscv/include/asm/atomic.h               |   6 -
 arch/riscv/include/asm/barrier.h              |  91 ++++++++++--
 arch/riscv/include/asm/cmpxchg.h              | 136 ++++++++----------
 arch/riscv/include/asm/hwcap.h                |   1 +
 arch/riscv/include/asm/insn-def.h             |  79 ++++++++++
 arch/riscv/include/uapi/asm/hwprobe.h         |   1 +
 arch/riscv/include/uapi/asm/kvm.h             |   1 +
 arch/riscv/kernel/cpufeature.c                |   1 +
 arch/riscv/kernel/sys_hwprobe.c               |   1 +
 arch/riscv/kvm/vcpu_onereg.c                  |   2 +
 .../selftests/kvm/riscv/get-reg-list.c        |   4 +
 13 files changed, 242 insertions(+), 91 deletions(-)

-- 
2.20.1


