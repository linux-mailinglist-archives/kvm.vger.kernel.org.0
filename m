Return-Path: <kvm+bounces-51783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 971B3AFCE8A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76F8B1AA33B0
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8CA2DEA78;
	Tue,  8 Jul 2025 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="haMFoYF8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B881A288
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987232; cv=none; b=HwGCEyuRI6q6oZDaTAk5a9qt/nEt20bdA22FVGuGJVON7fHmMzDiyfViO5ehQ1kXjNF9u+ekCsQKICEv5m9fKGhtXOJcDjB6cWoadBW4PmhfQ3lpDt+M1EDre2xT9NOQX7SPkHBxQUiVsC3Aw6P2+sWQ4XYubDLMqX3+WWGsLyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987232; c=relaxed/simple;
	bh=L4J6TXPw0FOSbaDlD1VN8nVmlzL/cOUny7Br7b9Z4dk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mfhpWOoyfySHWmhA4DiiSFs2Qu6KBWpSZnvJrXakmVd9oYSv9Y2w1DqMsj++Uk6ox2TxSNs7sfJOdFo6naKj9Qf7r6AxeYbbBtWH+fQZS2OFiuJO9zeJ2WcQUFV85/PXIHwBof1MMqOzI2c/hyYlfXYlcHhdga3AbOo8aKBAQV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=haMFoYF8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751987228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=94r18JtcI2w8FMRHf7rOCocGFCi0T1gK/0y+u40rPhc=;
	b=haMFoYF8ryUPizF5lN2j2XU59Q59Db+bG9rINZqdZwjFnuun7S4tSlaw2AWG+Tog+iXDfB
	z0Yj+gWc7GB90KdDpCqMt+W2UON90rnOhxtIKUWjdp9aUNJeODWAn0HIs0OxQMEdsFVQaW
	LjCvNAbfaavVlTTxGXwwGx2x0azN6bE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-Na4qDtj4Oymp9q6Lk517uQ-1; Tue, 08 Jul 2025 11:07:07 -0400
X-MC-Unique: Na4qDtj4Oymp9q6Lk517uQ-1
X-Mimecast-MFC-AGG-ID: Na4qDtj4Oymp9q6Lk517uQ_1751987226
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-60c776678edso5142684a12.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 08:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751987225; x=1752592025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=94r18JtcI2w8FMRHf7rOCocGFCi0T1gK/0y+u40rPhc=;
        b=jTh9ebDcgNPTao/1vlI6g4Xw0HE4Npnp9uS+pLGbI+qeify29lyChG3jYeXLsUGgCd
         cJqeTVQvjIJaAaR1EloF2LrlFRodJ9W8d4g23uir592/GRjM0dLPPhyjqK46Ce5w6hHY
         ShBbzuk2STQ65BHMNoCa5uvfOAS7FBw70iAbbqjPBpS0KBIN8Cjk0tC/J1jqRF3eKuyb
         V2HgeYj7IGEPAe0jM+76NnU8W5ZIZ+/koklFJAuf6ox7/KzPT+uXvpDW6nSmEb04DqdQ
         w7VPIU3ceHnOhsPOaEO+5/rCxaamuFpKWiPIAHSXB7KX5A2g3RqC1yOGIeEgF9iikpzL
         clHA==
X-Gm-Message-State: AOJu0Yybq5zss+htea/53hqFkT9xfdOiNKFXqlGH/HuDf6rmmHYHg5P7
	UuOa858LwW1GpRimt270ub6l6xNNOGbjqjJq7xLQ0LY9nskNgRy0f0LxI/9YdDSErVgzbgl3GTg
	jI/pC0WrguKJqreg0LxxUmkNs5GdCresqOqBzQVOIqIr+0CZGYccThv5zev+6K3axLgI2r2LRpa
	zLKscrXaLJ5+8uJiijwebuDieEPxzqxo/q0aOxtw==
X-Gm-Gg: ASbGnctNWv0PFUhoIadzFadXAwl/xM5skt7JKqpEOZHkyRuzZg2y2hTwp27qQwiYDId
	7Mg4uQ1LY9ywAVDPci26uIgxKOlPjohQbNRTOAhd31oY8ifjygLt1yBoQEuYF/4S6ZNhCR7BJZZ
	oHQ+lJ+8MM6yhtVByBuGIhaFMaObEdByZJA6QtTXe664GgSIDzIuqRNQTDviPlSmuA9taipw8rc
	FId5WRQXEAPPmInkdmyszdV/JzLVSDx5g7rjzx91SjfmD5Lj286AS1OLld3AZ+AnKlKCk6jluzT
	DHnnyIjsSYSKsOLaqmWvGbUlwy9cLY231v1DaqH7bB5zjXBrSV1BkuBycw==
X-Received: by 2002:a05:6402:1848:b0:60e:3f7c:deb2 with SMTP id 4fb4d7f45d1cf-6104c07dc44mr2331837a12.12.1751987224687;
        Tue, 08 Jul 2025 08:07:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu6YbuZQdOpAPPiO/DFn+qsSVyR0Asz5aRnoF+qhUCL+EjrsHVM4sAkulQZY7UnfYCUyk+rQ==
X-Received: by 2002:a05:6402:1848:b0:60e:3f7c:deb2 with SMTP id 4fb4d7f45d1cf-6104c07dc44mr2331745a12.12.1751987223423;
        Tue, 08 Jul 2025 08:07:03 -0700 (PDT)
Received: from [10.86.255.123] (93-38-232-92.ip72.fastwebnet.it. [93.38.232.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60ff11c3e83sm5737494a12.66.2025.07.08.08.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:07:00 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	andrew.jones@linux.dev
Subject: [PATCH kvm-unit-tests] x86/run: Specify "-display none" instead of "-vnc none"
Date: Tue,  8 Jul 2025 17:06:58 +0200
Message-ID: <20250708150658.136533-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"-display none" is a more generic option that is always available,
unlike "-vnc none", so use it instead of probing for the existence
of -vnc.

This mostly reverts commit 0f982a8c1e2242483a9bf53b15f825d1ff0bccc6,
"x86/run: Specify "-vnc none" for QEMU if and only if QEMU supports VNC",
though without reintroducing the bug and with some conflicts that
happened in the meanwhile.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/run | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/x86/run b/x86/run
index 2e2afbe0..dd38f14c 100755
--- a/x86/run
+++ b/x86/run
@@ -37,20 +37,12 @@ else
 	pc_testdev="-device testdev,chardev=testlog -chardev file,id=testlog,path=msr.out"
 fi
 
-if
-	${qemu} -vnc '?' 2>&1 | grep -F "vnc options" > /dev/null;
-then
-	vnc_none="-vnc none"
-else
-	vnc_none=""
-fi
-
 # Discard lost ticks from the Programmable Interval Timer (PIT, a.k.a 8254), as
 # enabling KVM's re-injection mode inhibits (x2)AVIC, i.e. prevents validating
 # (x2)AVIC.  Note, the realmode test relies on the PIT, but not re-injection.
 pit="-global kvm-pit.lost_tick_policy=discard"
 
-command="${qemu} --no-reboot -nodefaults $pit $pc_testdev $vnc_none -serial stdio $pci_testdev"
+command="${qemu} --no-reboot -nodefaults $pit $pc_testdev -display none -serial stdio $pci_testdev"
 command+=" -machine accel=$ACCEL$ACCEL_PROPS"
 if [ "${CONFIG_EFI}" != y ]; then
 	command+=" -kernel"
-- 
2.50.0


