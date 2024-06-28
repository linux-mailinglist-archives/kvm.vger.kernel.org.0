Return-Path: <kvm+bounces-20657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6706991BB96
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EBB9B22A0C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0D0152E00;
	Fri, 28 Jun 2024 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="kYv2Xqod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A6152530
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567438; cv=none; b=QS7L1gMLkDTDZ4c65N38J9YFwdK4zJ4QI1+6P5wajpwP+NNis4Bbc7/6FTyqilQCQyo0yY3QS0eeU31iCvlGxpQHGpRM7ZCA3zFfYTNGOhWNzH4IoDjpF1ASAJx38JagzS8igUUMh6u8ZX8hcix9D7w2XKvDLYzV+sBss3wBybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567438; c=relaxed/simple;
	bh=ucxeinqz7n0TNihsRKQxcjSWh0oJp4+v1mtowF5/wa4=;
	h=From:To:Cc:Subject:Date:Message-Id; b=QZtWNWOexFH01X4izpKxo+NhP/fgOp0vekAAsuAfRPXXGrznmC2RAOTR38CnhdFHEGKtSiFIURknfkgfvCBLMWXXiyAkp41K36Q0fTOGpXRN4y8DyIjP/sroPXlz1iyxQZ0L5VJrouhGk3eQkteQPqk59kyd7FxXG2mry3ituD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=kYv2Xqod; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-706aab1b7ffso354593b3a.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719567436; x=1720172236; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iT4MS8fZiK5+N1QCp5Ev5H4xY+O19Xuog9jiO1hr3ns=;
        b=kYv2Xqod4fLVWFr80iHfPzPYRiME+YCccjDzCfbLe8l+nZ3YVBaASWNnvIfzwDe78+
         J3JQwKtf8QDsI1U90e7Sf0aGmbmSMfvekcUik4qpfH67keQdHDCl3AubhXtT5SuVD3Dw
         YAjRCORgUkDpPdxt/9khAkKHYDMWHio/MdABz+0RlUBZqBlxmWVumCvTJ/d0mQznBjEl
         h2tCrK+i3tyHrnp90egwAE4Wlb+oIgsacUVV/l5gUPm7IZIdTMJDaXUKOm/sxKqQotuE
         JhODhl/AZyqr9K3cC158NRISc+e7JP8/Cp0SD34fTxMrYtCg3gymk2nN5Pw4jjqw2voY
         bnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719567436; x=1720172236;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iT4MS8fZiK5+N1QCp5Ev5H4xY+O19Xuog9jiO1hr3ns=;
        b=vQfXpP55o+657bJgukvDT/9KRUk1LF/gfAI3+dgue9zkTIHw829V6hKb++z/LoeFSA
         aWSa7qA+GM4e3JEYToGHiIBloS8r4jH4rP7uYoIf3zdYfmjApAOrIdQfustCtwVfDSY+
         yMHUsXokyDEp/pyIg8KivI+Q6BODGPrrqRTaKDB5LAGwez4cuPmQu3rZTdTDc8pdVpFW
         Hk0zRQlWoAz8v8yEaskG0HkjY6ytAv3GEW/XdLXcAT+RvI2H0jBrHUfzmhvK54SW5TLv
         0GHos694B0296DvjcZP9WKqKM04EFBCz2CtNJtjP35qx6LIjUPuM+edfGXuFG3zU6WB/
         6ILQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbSmPbdPrflKfC3EM4e8lG53NZEAR1RFgh1ke7gXC/vEzN8ZWRyCLg9hk+i41d+5qD/zpDKuXNNninysrG528Kdl36
X-Gm-Message-State: AOJu0YymKabhAf5WK6JCo3dMnKhBhhWCbF8kDjeAHPIFsvmCdu9/hW4V
	03w+dSu9bDUsZsMbPDVOX4Rgo1MH61r91hvRAs+NvcxvJffGnydXBEvg8cq5ykk=
X-Google-Smtp-Source: AGHT+IGz1s4UrPEjOUTeURvSc/bsNc9cuyIhSWC3mjXDJgDFtcpe5FBxZlsENps9IITX6WHehehEjQ==
X-Received: by 2002:a05:6a20:3b91:b0:1bd:2a99:2da7 with SMTP id adf61e73a8af0-1bd2a992f06mr7489875637.31.1719567436154;
        Fri, 28 Jun 2024 02:37:16 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac10c6c8dsm11087155ad.26.2024.06.28.02.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 02:37:15 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v6 0/4] Add Svade and Svadu Extensions Support
Date: Fri, 28 Jun 2024 17:37:04 +0800
Message-Id: <20240628093711.11716-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Svade and Svadu extensions represent two schemes for managing the PTE A/D
bit. When the PTE A/D bits need to be set, Svade extension intdicates that
a related page fault will be raised. In contrast, the Svadu extension
supports hardware updating of PTE A/D bits. This series enables Svade and
Svadu extensions for both host and guest OS.

Regrading the mailing thread[1], we have 4 possible combinations of
these extensions in the device tree, the default hardware behavior for
these possibilities are:
1) Neither Svade nor Svadu present in DT => It is technically
   unknown whether the platform uses Svade or Svadu. Supervisor may
   assume Svade to be present and enabled or it can discover based
   on mvendorid, marchid, and mimpid.
2) Only Svade present in DT => Supervisor must assume Svade to be
   always enabled. (Obvious)
3) Only Svadu present in DT => Supervisor must assume Svadu to be
   always enabled. (Obvious)
4) Both Svade and Svadu present in DT => Supervisor must assume
   Svadu turned-off at boot time. To use Svadu, supervisor must
   explicitly enable it using the SBI FWFT extension.

The Svade extension is mandatory and the Svadu extension is optional in
RVA23 profile. Platforms want to take the advantage of Svadu can choose
3. Those are aware of the profile can choose 4, and Linux won't get the
benefit of svadu until the SBI FWFT extension is available.

[1] https://lore.kernel.org/linux-kernel/20240527-e9845c06619bca5cd285098c@orel/T/#m29644eb88e241ec282df4ccd5199514e913b06ee

---
v6:
- reflect the platform's behavior by riscv_isa_extension_available() and
  update the the arch_has_hw_pte_young() in PATCH1 (Conor, Andrew)
- update the dtbinding in PATCH2 (Alexandre, Andrew, Anup, Conor)
- update the henvcfg condition in PATCH3 (Andrew)
- check if Svade is allowed to disabled based on arch_has_hw_pte_young()
  in PATCH3

v5:
- remove all Acked-by and Reviewed-by (Conor, Andrew)
- add Svade support
- update the arch_has_hw_pte_young() in PATCH1
- update the dtbinding in PATCH2 (Alexandre, Andrew)
- check the availibility of Svadu for Guest/VM based on
  arch_has_hw_pte_young() in PATCH3

v4:
- fix 32bit kernel build error in PATCH1 (Conor)
- update the status of Svadu extension to ratified in PATCH2
- add the PATCH4 to suporrt SBI_FWFT_PTE_AD_HW_UPDATING for guest OS
- update the PATCH1 and PATCH3 to integrate with FWFT extension
- rebase PATCH5 on the lastest get-reg-list test (Andrew)

v3:
- fix the control bit name to ADUE in PATCH1 and PATCH3
- update get-reg-list in PATCH4

v2:
- add Co-developed-by: in PATCH1
- use riscv_has_extension_unlikely() to runtime patch the branch in PATCH1
- update dt-binding

Yong-Xuan Wang (4):
  RISC-V: Add Svade and Svadu Extensions Support
  dt-bindings: riscv: Add Svade and Svadu Entries
  RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
  KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
    test

 .../devicetree/bindings/riscv/extensions.yaml | 28 ++++++++++++++++
 arch/riscv/Kconfig                            |  1 +
 arch/riscv/include/asm/csr.h                  |  1 +
 arch/riscv/include/asm/hwcap.h                |  2 ++
 arch/riscv/include/asm/pgtable.h              | 13 +++++++-
 arch/riscv/include/uapi/asm/kvm.h             |  2 ++
 arch/riscv/kernel/cpufeature.c                | 32 +++++++++++++++++++
 arch/riscv/kvm/vcpu.c                         |  3 ++
 arch/riscv/kvm/vcpu_onereg.c                  | 15 +++++++++
 .../selftests/kvm/riscv/get-reg-list.c        |  8 +++++
 10 files changed, 104 insertions(+), 1 deletion(-)

-- 
2.17.1


