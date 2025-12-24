Return-Path: <kvm+bounces-66641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2697ECDAE35
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FC553079704
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327551459FA;
	Wed, 24 Dec 2025 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JtPIc71K";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cF+f/11I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587EB2BAF7
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766535184; cv=none; b=KF3z27NNibLOo9q+pC3VyMMDsgGIrwy4l+Ux+vrnHMrtlZpVBSA2SoFTS2GEI9kzpCEM8zOp9pRKJ6zdQlfHeY8p4NyNh2W9pZA88z68MaUjSBy0b3k/jGfzpU/SjZwPIsmXN58cHeTfnIuDdd1kYw9BdyjD16DUdCyFeE3aWtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766535184; c=relaxed/simple;
	bh=fYaLHYmUCZkuTRnEeWO5eq/4i+YwBbxZKhmvbBJEKAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kI8OCJB3CAyglGxjiwEEm9fvUrxH3klaWc3f1uT1lubud7gefYg+uzhHAs286V0ptXdKlcraEvTAttJHUkkh5HilYiHexPTVzjkdp//vZ2fBaOvG3JPCwHnuBGWImjGTbdsCAwLZ6EopGE+x01948InVzyOFsDvAApHDDRMP9SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JtPIc71K; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cF+f/11I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766535180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D3w8awz61JbT+kpcuwhPMHcwc/CMTSaTS9NVxMEQYnw=;
	b=JtPIc71KqrsRA+bdcrIQPvMl7cwz/4JVrHj9GbARMcP06WWZS9jjJkQnhtspU7N8Ehsex/
	UmtRpmiQgoHdrVBOCfWmrLQ17N0CW3YumLdNpZvJqsdSei1xPkjLcT+7qS618NS23Pi9nD
	tq3/V2SJzGJA525V5wXQXJmQOv017io=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-2X1JAfgFNZCd3ssTfr2sAQ-1; Tue, 23 Dec 2025 19:12:53 -0500
X-MC-Unique: 2X1JAfgFNZCd3ssTfr2sAQ-1
X-Mimecast-MFC-AGG-ID: 2X1JAfgFNZCd3ssTfr2sAQ_1766535172
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47a97b719ccso31115845e9.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766535171; x=1767139971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D3w8awz61JbT+kpcuwhPMHcwc/CMTSaTS9NVxMEQYnw=;
        b=cF+f/11IZgnD/8cGWTh8vGdhfTZKZHMyjSu2ujHd5JC59L21hG2EIlxepqsbOpQCYk
         tafIhemFm/PzEu+SFPg7rktp9UXjGBX8hAArzBtc+rxpfyC0iJtxLz7STnjhVZQc5Loq
         yc6J6sHMrQ2ZUBtYut42Qn+GIZaesRMk3GyrEDriswC2NnUjA+Ejv6mVtlMMoFazrvcR
         DYfHM+TcHWehHK9hcjXQJiSlfyy1MWwiw7if7WX/7WvivYp5hndrbCEmZl3t+8/A4rR8
         R9jos//HhqPlpC0VxrCuJuhdvfUEKH3jAXeErdGkwBCn9rrIFMEA13SrmKUadtif8FbP
         TsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535171; x=1767139971;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3w8awz61JbT+kpcuwhPMHcwc/CMTSaTS9NVxMEQYnw=;
        b=CoHB7JfIqL+kf1olQcFC8MeUlGZgJZLPxgW73FgHsSbfzPRa0hux9V6I0e9s1IvRwC
         gES/tdyquJwpgWTWjpeG8VXMcySWuvU2zvoprUxwiFgSL5/sl062fGdo0yzrrN/9g7Y1
         7oZI01R8VVoMXbjmcPiF4duIgzZrZCug8i9qXozAX3dXdkIaDw5yD4v7NX8pECzx05eq
         SYJJAiRIkO/wbHBjYosZtht3sdSTxZZ3BlVYGpg+T/v8ia1cT63bNUUEZndQKj7wJxse
         gPZpLaesS9ivEpllg/DqUo1pavlo2VlK4YfVZKb7e8mflgWi/Qfk7YHttwv/xWqhs+tL
         qSgg==
X-Forwarded-Encrypted: i=1; AJvYcCXq8wmeCu4wLILyU9UPwaMI4gNEUiqQ33jHcSCeY1cCetqBPy2yI9L+WjaGEF3/NW5/vcA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs4uGZRSHfmsZd7r/ybZst7i8Fo864CyIl2peepbl3Qb73cHm7
	oX1Tnk4jlqdxEN3JEpd5IwVWYRFZ4Yj/faSOqXLqEdaFEK3ix3G+ZgLUBKco/S6yyQtyhbdyDgu
	Lfvp2BtDVHDB4hqesRiNKF1xeYIcwgtA58M8VzXKntnPwiUi8h/fw9g==
X-Gm-Gg: AY/fxX4Gg58A9AiD0SOodk6QPT7kI8pgOgypHK4G++1WptflWB9nQn3uir+9fJm0fy5
	qZl2mOA1g82mC148kYHb+kRnW1dkRXZeO6picLuYR0xQckPzwDwv2UjQnSYtU8RliB/ig+6R7wA
	yOr+SwTT65OU6F8J2VcgGmHbHJV2l+D5LWqmQHEh1tM4LjRen9lJkbjr5qYLpI2YYViPx1IzFZf
	uxotMl5pw2sqHT5WT+uyQtYI/uFm36yp3BcUfWDRJGBzi7vRJk84UQwsHIUNJ4MBXwtkqDIO14O
	EDUQQgo5Lvx8Mlh6Ze5qWS6m2SWXXqS6E4+EIZ2xYd16AE0kq8w+j9RGPpgE5QXnryQRX/bcixx
	DJKCDVmY9K+kfIMzQcrdswefjNG/8Bl0UGGRtlSZ14h1OQbwx0goHqzFVz6g3l92LG8AgGuUORE
	0NHdR2g5AsIQnvpOI=
X-Received: by 2002:a05:600c:1550:b0:477:9fcf:3ff9 with SMTP id 5b1f17b1804b1-47d19589575mr148336045e9.27.1766535171600;
        Tue, 23 Dec 2025 16:12:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQwog6xqznJWl5aO/kzVu6RKVZ5oUdGcQc1rlrp6C+FbHczmkno5KYtI87pYv3rPb69yQ0qQ==
X-Received: by 2002:a05:600c:1550:b0:477:9fcf:3ff9 with SMTP id 5b1f17b1804b1-47d19589575mr148335945e9.27.1766535171234;
        Tue, 23 Dec 2025 16:12:51 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193cbc0bsm267406775e9.11.2025.12.23.16.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:12:50 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org
Subject: [PATCH 0/5] x86, fpu/kvm: fix crash with AMX
Date: Wed, 24 Dec 2025 01:12:44 +0100
Message-ID: <20251224001249.1041934-1-pbonzini@redhat.com>
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
XFD setting can disable features that the host needs enabled to successfully
XRSTOR the guest FPU state.

The first patch replaces inline code in vcpu_enter_guest() with a new
function exported by kernel/fpu.  The new function is similar to
fpregs_lock_and_load() but operates with preemption disabled and
also restores the extra state (currently xfd_err) in struct guest_fpu.

The second patch then introduces a new xfd field in struct guest_fpu,
so that the guest's XFD setting can be swapped while leaving the host
value untouched in fpstate->xfd.

Patches 3 and 4 introduce a test.

Patch 5 makes KVM use fpregs_lock_and_load(), exporting it in place of
two lower-level functions whose other uses are now gone.

Reviews and acks are welcome (this could go in through either
the x86 or KVM trees).

Paolo


Paolo Bonzini (5):
  x86, fpu: introduce fpu_load_guest_fpstate()
  x86, fpu: separate fpstate->xfd and guest XFD
  selftests: kvm: renumber some sync points in amx_test
  selftests, kvm: try getting XFD and XSAVE state out of sync
  KVM: x86: kvm_fpu_get() is fpregs_lock_and_load()

 arch/x86/include/asm/fpu/api.h             |  7 ++--
 arch/x86/include/asm/fpu/types.h           |  7 ++++
 arch/x86/kernel/fpu/core.c                 | 38 ++++++++++-------
 arch/x86/kernel/fpu/xstate.h               | 18 ++++----
 arch/x86/kvm/fpu.h                         |  6 +--
 arch/x86/kvm/x86.c                         | 14 ++-----
 tools/testing/selftests/kvm/x86/amx_test.c | 49 +++++++++++++++-------
 7 files changed, 82 insertions(+), 57 deletions(-)

-- 
2.52.0


