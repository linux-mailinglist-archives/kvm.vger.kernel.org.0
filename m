Return-Path: <kvm+bounces-52983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9FCB0C5BE
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FDF81AA4B97
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5162D9EF1;
	Mon, 21 Jul 2025 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSHW9lod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD3F2D8DD3
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753106453; cv=none; b=er7DZTNR/Lal1cw+yCrrIWh9TGHUDPPUSX/tVhJIveKBuR0/geAp/n/HH8cyE7e8aFaGCvAzkG3SWUgPPZHkP5sF4yV2X25jSYw+1SKzgkfaKgtAmRS81+FbjkK4C6JVC9TRmO9NUQY4/qpIhr3fkCGZB4yZ0NY8qYie53kYkjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753106453; c=relaxed/simple;
	bh=1PQZ5wEHcoCEtER0af1nZDuJAWLlSAlkcq8MdPvmiaA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kB77WwaAMQNsysMR6g1KYnWn73Eq4HrZnH59X+y7e9JuVRfaE97WWoCUDBFSvn8axsMrcnSn3gPdX0r5xArB2280wgrbotZbxu1S3vAgIb+Pi6+GRZp4bQVPc0E4i+TL2u2G/fv9HDgxZSoESv8dcuVeU2Qxtt/sSDlSzmZMOsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSHW9lod; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-455b63bfa52so73805e9.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 07:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753106450; x=1753711250; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r0VWK6cB9v+a0NyyEJgT96YS0NmW+Gj3bVw1g3G7ew4=;
        b=VSHW9lod3L2VsLnNftNp2o2GSJwoLbEqZKGQoXxcv0iAAkmLlZz3Tlo9TtwMmlWQk9
         cyG14GzgGOF56b5c5gh0QkHBVEWCWzaaJ4MeAwFf7uHNUXVjoiYhtYsXQZWaa6/ig2Cs
         eJTDM/kA5/zd2ehkXfIzKYY8mkrLN70eUW3r8E8OdSBgSu/PRuVnG10UdC27Rz3ki080
         1MNwfGcXT9ogTcKUzPmkIMYqWLfIkqI8/PezE889vd0fJhOXVJov7Mcaj9tt8PGsE9c/
         H7HeWjXfRqTo25ubNAYtRe57w6i47q1e+hBTTUEd1PsFzHMe03jNA7qOQKxUFCCAWjh6
         lxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753106450; x=1753711250;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r0VWK6cB9v+a0NyyEJgT96YS0NmW+Gj3bVw1g3G7ew4=;
        b=cjdGdD8uyx9W9XxN8LRA9FzECHnlavkKNK2950I+/iC6opVj5Z/4uaQRJiwMwTF1Nv
         QhuhG+2/V88gV0Y48WXVhpvtCB5ztAO+M7zZqREZZbmQVMyfZGNvomZCNlA++3JHB3FS
         e4RtWF29LOuotUIWwU+klAA8k+HX1Prgp6AlSNj5nz5pzz4I/Yvz7JP9ZzRD0lklKWGG
         Yev5RaYpzpMNz7/6oWWEUqoW/osj17JR/hzi6vzrQfjMsVHh2JPxT3p17tUMO6C+xASa
         b/ggFFBGHWXjflHopxqFt7Ge+1BogbFlfD7vBiFmk9deSYdi4kEbIiEX5FEF0ueRpTZE
         eZQg==
X-Forwarded-Encrypted: i=1; AJvYcCVqr+RcFvKC1wB/KZp4WhI7SwyHFsxkfgZSQriVn7RGUVsXttWwXHoCOgRteYhePLbiZ54=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9czw10uQMBSQP0sucYIBs0/5gvky7QKZHqHDvV62db0UxDNEo
	chsOvOk9XnFXj42x5ItJPfJuEic0g84p8BDX7W3HwGmm7hVMBAQUYG67QtcdGVDJiM9adYt+OHs
	MStKzIROZa0v4l/TCD1xSsTTt2L5QBJDuJQCwTleUFqzkh9z86VZF9a5g
X-Gm-Gg: ASbGncu55DA8CUcs2vstAopHRQDgpHOvAJ3wlsmbWHENlG/bh8zKYWnbhOYtbrTKKp6
	6NfeJOw5ov+dmSap/VnfP2MHj4bjH5OSAR4DT7kEtpJXqGNGBLH6cNB5WZRgBjKy5uYAeArU4+U
	TJ/3OUcTthlpr5d8892iuZm1Wm9McytoMwzYywePDVOX2JWXwNL5GbsCaXXFK7jIdp5QcLD3gCv
	ZB6SbxupZ7XUxvTXPGvLT5k25jUnSQSK7mNpmaH
X-Google-Smtp-Source: AGHT+IHzrPlFuf9cksmZ/Es+Xf1aPI79vfvoqBBLKfiQw3E1U+weKYQAyTKorgpdHvEuDDhSlkSHEj7XF78SYKtS+o4=
X-Received: by 2002:a05:600c:8b81:b0:453:65e6:b4a6 with SMTP id
 5b1f17b1804b1-456428e598fmr3424825e9.6.1753106449459; Mon, 21 Jul 2025
 07:00:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 21 Jul 2025 07:00:00 -0700
X-Gm-Features: Ac12FXxRlhkToUCbXGkOTjf1DAqkBtxHHrS7fMi_NmUO7y_c0p3cGBlWugT0e_w
Message-ID: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
Subject: [Bug Report] external_aborts failure related to efa1368ba9f4 ("KVM:
 arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

I was doing some SEA injection dev work and found
tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
branch 'kvm-arm64/config-masks' into kvmarm/next"):

vobeb33:/export/hda3/tmp/yjq# ./external_aborts
Random seed: 0x6b8b4567
test_mmio_abort <= fail
==== Test Assertion Failure ====
  arm64/external_aborts.c:19: regs->pc == expected_abort_pc
  pid=25675 tid=25675 errno=4 - Interrupted system call
  (stack trace empty)
  0x0 != 0x21ed20 (regs->pc != expected_abort_pc)
vobeb33:/export/hda3/tmp/yjq#
vobeb33:/export/hda3/tmp/yjq#
vobeb33:/export/hda3/tmp/yjq# ./external_aborts
Random seed: 0x6b8b4567
test_mmio_nisv       <= pass
test_mmio_nisv_abort <=fail
==== Test Assertion Failure ====
  arm64/external_aborts.c:19: regs->pc == expected_abort_pc
  pid=26153 tid=26153 errno=4 - Interrupted system call
  (stack trace empty)
  0x0 != 0x21eb18 (regs->pc != expected_abort_pc)

It looks like the PC in the guest register is lost / polluted. I only
tested test_mmio_abort (fail), test_mmio_nisv (pass), and
test_mmio_nisv_abort (fail), but from reading the code of
test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
probably due to some bug in the code kvm injects SEA into guest.

If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
yet figured out the bug tho. Want to report since you are the author
maybe you can (or already) spot something.

Thanks,

Jiaqi

