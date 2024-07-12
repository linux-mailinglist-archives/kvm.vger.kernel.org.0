Return-Path: <kvm+bounces-21479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B8692F681
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 685401C22858
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26FE13F454;
	Fri, 12 Jul 2024 07:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5PHxEpI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A883A18E0E
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 07:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720770633; cv=none; b=RDoMq2biGlVKQ50vI9lbfMTNvAN7Ke8swNQaiuatOCIk9fQRBwDvli/FWeNvJ8Q8UC13RFt3D3WXuXVZonZJlqVin8yk3sCh1QWzi0X6Aqo4yn3eX1lsbaCUgrtvac4t7zrtTC8D0Y/9DaUHxuc7euyKQ5/UxDmqSURB80BFVrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720770633; c=relaxed/simple;
	bh=U7hiKhygyt5buB12CdE7ECBp0jlYEOLz8G7N84g/omE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RHXD2oHnebbGoWwirHapEV0KePk74LVdX+mM4ipJbXubO9jyyFRo9S8FDZfTG2/NXPYRZxd5dqQDOy0cxr+/pbOCvYrvMRiCtrOxU13o1aV1aAmXJdnldDJoIaeltfT4fivaFd5OyoBll/RhHQ/sAz0GTqskIuVfahq6leCqIRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5PHxEpI; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-75e15a48d6aso1048474a12.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 00:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720770630; x=1721375430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gQQqRXYETOZlx6IbnOGm972LdB6CWfM7JLptlb4mN6M=;
        b=M5PHxEpIC8uha4Pez3iAdWH/y81jkf7bod9jUB5C0fEoml9KY/1EQOwQ9IPJCDQuQa
         /SiFIq9jJDmW/zvla0g/kJyUkoYs5621HJKkLeBPz6UVKR+O4jrnMVSJIQ2EJksVtW8L
         jixqog+2XRfkORueCu7wde0J/D+BDnfnYLY+jpVK7QpUNmXP/EiFy9t5nTuShAD+AyI9
         Q62ysqmay9iU2FdapCQN8MXt9T0Ootr3toK0VjdFSl94VEnwX7xGNvv7CkjJ128jRtdV
         ksjHZjUPS43PK0JPF6s/hfnJ1szC21eKaG1DXtk1l0pVBa/yalNArN0FY2vM3B4S/JwI
         kiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720770630; x=1721375430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gQQqRXYETOZlx6IbnOGm972LdB6CWfM7JLptlb4mN6M=;
        b=JZu5XqTjAN5F6V/cYdjNCC11y2Xqi6SM3xXrQLoxZD1AJ12Q0RDwFNRqHeyB5fAwzW
         d8ZzEsRwQ3JABH9wvkvGnMZb7f+pccbhJBqrsn/XIZf0lEOx7pR/W/CudazeG5FbeIX+
         gIW834oIIV4TLN1mzZk3v0uuTU5js/zRoQZghYweCF31kF+eEtXoRLknPWxPvKY8RFnu
         m0geLJ1cKk7LFEIN/Np9sCuy7/AVkNaNPKY+o0hyKsfeKcbRLh09d4gIOWzT/7OtmN7M
         UTmQXKTLyqxCmUmDd4DQ+nCOxg0xDyHPsawqQNBAeT78EAh3ryuDv2IcCTyfT41Sx3Bv
         bbRA==
X-Gm-Message-State: AOJu0YwCicDHEdjkPLcH5id5EOpAepDhJ4GXJFFBNnTB97rXjfXCn2Op
	keSi+IfKHevJjlCnJAdqkDXIAVCnigVOQKIzsxBGH24rK7d7VAXf
X-Google-Smtp-Source: AGHT+IH331XheSXRBMsJVy+rWFLYJ8HLD5xog8djkugJVyXBv7vmT7Bhxi5+rax4y2mVrbbrQmnlXA==
X-Received: by 2002:a05:6a20:914f:b0:1c2:8d16:c683 with SMTP id adf61e73a8af0-1c298243926mr12156646637.32.1720770629903;
        Fri, 12 Jul 2024 00:50:29 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cacd70376asm809934a91.50.2024.07.12.00.50.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jul 2024 00:50:29 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH v2]   KVM/x86: make function emulator_do_task_switch as noinline_for_stack
Date: Fri, 12 Jul 2024 15:50:22 +0800
Message-Id: <20240712075022.48276-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

When KASAN is enabled and built with clang:
clang report
arch/x86/kvm/emulate.c:3022:5: error: stack frame size (2488) exceeds limit (2048) in 'emulator_task_switch' [-Werror,-Wframe-larger-than]
int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
    ^

since emulator_do_task_switch() consumes a lot of stack space, mark it as
noinline_for_stack to prevent it from blowing up emulator_task_switch()'s
stack size.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5d4c86133453..bbc185b9725d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2918,7 +2918,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt, u16 old_tss_sel,
 	return load_state_from_tss32(ctxt, &tss_seg);
 }
 
-static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
+static noinline_for_stack int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 				   u16 tss_selector, int idt_index, int reason,
 				   bool has_error_code, u32 error_code)
 {
-- 
2.27.0


