Return-Path: <kvm+bounces-29751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 277889B19BB
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 18:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C72801F21E49
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 16:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2826C1D2F67;
	Sat, 26 Oct 2024 16:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcArLYEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D5F1CBE9E
	for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729959507; cv=none; b=jSMxtPR6PfXVlzR+FsJWThGj/ECcb+FRMsXVepwEtMlEcklwcfegmsIp0LdozploesFs3lw5tpF/WNY5ogH+Arl3N7tFE33b/hoVO3k9J4LI8460J5Cu+gzypy60zMQVuTKdCrifki2TEkSSZ0X8I5pvOOa7HWKyF14RuYvyeBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729959507; c=relaxed/simple;
	bh=Li9lg/d4LoObpo0qaotCrvuxuFk+kNls0HsIlEvJO50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ah/57VZaQqK6vrmad1Fadm2RYlEhv+oFJ19ReKkUla6nsBLCm3zxD6BIB0D8UCRPZuVQwP0ePRWNE0CMilpkPliUWi+1mj9rtEnb3815qrg9UeDCR2F26G/v3p2sKEgWMtEWvlehzYHeTLvFc2Pmunwd4kP7p5sqbk+TlN7I848=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcArLYEP; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71e5130832aso2147104b3a.0
        for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 09:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729959504; x=1730564304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5JyZ7yiPmyHL4xk6pJ9JiQBHhf05fIYRMraM7jPw8gw=;
        b=bcArLYEPJ+x/zGAH4lfzqVtkkIX1MvhpfdddSf2upWKudTiqOTT1cAkahyn3I1XJMG
         FFkdSOEdeI0MzvTn/lNqhBvL91f9iiWsr4KiJdJQd9ej19bFNrvHoBdgbAZ2BO0rMv9e
         sBinxG48/TsBQpTslcwmntquG9iuryONJhlpBiqG2q8u6iRtX9rlCM7YTtelAu0BMOjO
         Aiqd7hlZseDAl3NFu84z6ev6tp8a0N6AxABi6kvbKLTRQ1egtxzIW2ZKt9HsS9BHsOD6
         Q22Yq/QfdmJylGbBuiKX0y/ZFeJFPMZEEjgSoH7gpiMXWB9rGCN3b1PG8C1ZOFk9p32c
         o5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729959504; x=1730564304;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5JyZ7yiPmyHL4xk6pJ9JiQBHhf05fIYRMraM7jPw8gw=;
        b=BzWnqed1Drzice6rvFbQPwRGlNtyL6NvNExzKTqTBfGOrjhuOSCooatVfMsfIEfgMC
         WWuEG1qQUGXAdmPVIPEbrieICyrHDHnTks4aJtnbdnKlzxRBa27Tn5QfyZQnm34KDN+v
         PifqljlUcng+a/41tObbDLwYo8ySkGt1jCopCa72pyY/3wYvvz1WNAWCkNbetQWqOLpb
         fLNadwHnpkWLmoTdXdnTXKcdmJpL+Sl5kGVrYx2z/5PVSotmDOMOkxQC/YlSiKp8CsE+
         V8/1rjtNhPVy1/OrQg9G0kDuhkIZrRYJaKjbWXxHaDo02OoeZPFJ04ADw0kJ4Ek8PYTu
         Mhow==
X-Gm-Message-State: AOJu0Yw6iuY3V9KIXL4LKE4ANismebebxWvg5o0RxqVpw03YwnRhixLF
	xSk/JIRwUewJjZvQ4GDqPFomkdyUiVeSI9xT1S5E0BTCY8BR1XVXNhhrZzvI
X-Google-Smtp-Source: AGHT+IFnk4ReoPitP+chgKrxmrGai83F/h9KMccFgK2cqeaFe7mT7GYeGCxehzx1FgOvhA8EjDODtQ==
X-Received: by 2002:a05:6a00:18a8:b0:71d:f64d:ec60 with SMTP id d2e1a72fcca58-72062f83dedmr5553924b3a.7.1729959503771;
        Sat, 26 Oct 2024 09:18:23 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a1fe53sm2904317b3a.162.2024.10.26.09.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 09:18:23 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 0/1] riscv: sbi: Add support to test HSM extension
Date: Sun, 27 Oct 2024 00:18:12 +0800
Message-ID: <20241026161813.17189-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing all 4 functions of the HSM
extension as defined in the RISC-V SBI specification. The only patch in
version 6 of this series adds the actual test for the HSM extension.
The changes are based on the riscv/sbi branch.

v6:
- Rebased on top of the latest commit of the riscv/sbi branch.
- Removed unnecessary cleanup code in the HSM tests after improvements
  to the on-cpus API were made by Andrew.

v5:
- Addressed all of Andrew's comments.
- Added 2 new patches to clear on_cpu_info[cpu].func and to set the
  cpu_started mask, which are used to perform cleanup after running the
  HSM tests.
- Added some new tests to validate suspension on RV64 with the high
  bits set for suspend_type.
- Picked up the hartid_to_cpu rewrite patch from Andrew's branch.
- Moved the variables declared in riscv/sbi.c in patch 2 to group it
  together with the other HSM test variables declared in patch 5.

v4:
- Addressed all of Andrew's comments.
- Included the 2 patches from Andrew's branch that refactored some
  functions.
- Added timers to all of the waiting activities in the HSM tests.

v3:
- Addressed all of Andrew's comments.
- Split the report_prefix_pop patch into its own series.
- Added a new environment variable to specify the maximum number of
  CPUs supported by the SBI implementation.

v2:
- Addressed all of Andrew's comments.
- Added a new patch to add helper routines to clear multiple prefixes.
- Reworked the approach to test the HSM extension by using cpumask and
  on-cpus.

James Raphael Tiovalen (1):
  riscv: sbi: Add tests for HSM extension

 riscv/sbi.c | 663 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 663 insertions(+)

--
2.43.0


