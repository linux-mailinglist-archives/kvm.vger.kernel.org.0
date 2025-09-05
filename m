Return-Path: <kvm+bounces-56863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C971B4504C
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D5AAA0610A
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 07:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834C72F066D;
	Fri,  5 Sep 2025 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKzpGvyN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56DA2E92D2;
	Fri,  5 Sep 2025 07:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058719; cv=none; b=SIDm7LonftwEtzNrJJ/wQ3ZSI6m0vgKEI7T93RgOotUCe0dh2mvi0ogxPyA5lW+as9Mn6iKpgUM7h73zhXnYtYlx6JzXhl0IUXD3Tl3US6h1KgABEQ2q7x/cI04sZOpb4dvhHSAk6Oe/bIcqfZByn+krvlAPmSI7xhnYd7v9gn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058719; c=relaxed/simple;
	bh=wnEDbEqupkldvgMSCmGzgTuDsfuXoqTVNqOMp0k9RM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MehbdhXo0ps6swMOAFGfsdhwNYBmq+W/OEk+9JgYnVhPd7HbuApLf5YZiBeXJdAlYMBXpfWWI/bLd/HgBJwjVITuyK49jV+2FtqxMDcWMy/Fv1TK8C/8pWXf7TFvrlRGB87KTo5ghNmVI29/HEQe8W8+21ik2fR/ahO3VtMsOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKzpGvyN; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7723bf02181so1479740b3a.1;
        Fri, 05 Sep 2025 00:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757058717; x=1757663517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D//zcibIIUwpQZGGbW48bB+RJuGF8/HXmWRaYXLQrh4=;
        b=KKzpGvyNF/bzDbXBJVZZD4skCxQr3VIZyFsrnfdwJ9dKn1GklgGxRwjqW4rJL8LP3v
         cXGOSfBrG5eZmdDHKuHQg31J6JXiczTQ6eC74PbjZTpiOnA6aIZtbeOSePQ1W05Zf+qc
         LO9pD0uUKybcZMsxANDqdBvf/VZkv1IAZfDMGVT3ecXcSsNpAV3xFGq87qP58iKXfrGK
         rPnJSlCd8LbewTbjj0OMbwcc820yUbgvmx7Tvl4x4+47J3lDCDli9kl6cK+6Lkm8lnQ/
         rQF9nmsILDzBkS4N5dKSHqWVUCjP7CVs5wyxc+USzunP3TDxdUlHui8nGIvJ9PNTr9EJ
         W73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757058717; x=1757663517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D//zcibIIUwpQZGGbW48bB+RJuGF8/HXmWRaYXLQrh4=;
        b=bmRCS95ivIIiVnNSQX/Lb0QNAh2JCIkpk0Mvjf7Lb8pnwWX17ghXKIXo/3DI2UMWuy
         qSnwuybf7QiD/LjfdF+0T+2ju/EiFNtqzSw6t0xe3d58IXxJ229i5NOLlrwOkyLYpA2C
         ALkI77Z496s0S3TiMtulm6xAz/8vfS1aM6La9ctZ9demjJdqkXejUvgUm+aeu+p95kEg
         z2HdUZkAWEVkQD/eDMFaLu/oHXtv43hfJpA1f1kVuml4BbxvyCObjwbmlXxDXsxvaMIs
         wfJJvniJTRwviL1qEF6cgsFVYQbGuMItiKsKVcyDZtOdz5Q3vVIlbnz53fBTI9oyQBkC
         Q6+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVBkK8I01dMBjFEQomfAaProqRflFHGxJE0HGE2Wm+nSaFwoJzHvSSTFtFiP0W3JPuJLARhekEPnYoW4Gdv@vger.kernel.org, AJvYcCVkjbyTbH4JEMxoOoXxbcw62xNcHTcRtwpoCA4ZTKGhTh+ELOO8cuuM4osg0J4AWJKb0bA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc6tIFnGgPeJY9xATy0WWCxl2hVi6H/53HVRyzup49m8dAZ+No
	4PcucQsFnzKrWEHWMByX8/nLe6A8W1pGf7JdCZigRZpNNnQcpsfV1ye7bt+/OmZdKuo=
X-Gm-Gg: ASbGncu/55x7XIF1rlwAF/HihwIKmj0h7CYdedNKE+ayZQqOt5FRrtA+cjlIM9935UZ
	D72Kro6IZE4hMLSkmBcAtaSSCNUHOAIB2T0pHCX293LO5V7gKXx8OD8/ycOS9WNZU5UP0Tu3N6K
	a9JAwypZVlQRVJXAq6mR3xja7TiZqL3UkOXSrkrSN/AwpUTEfqoMl76orMtK3EFX2C7ltCsTDeu
	Z3719cbaY/wU7rpm3CmoDJv243Y89hMlYlL0mm0BMwbhYrLx9Hbj0b5Eg6+Nkd5mu676OJ/uL/R
	zxaHD8TFFvoJIAdMG4Fy3XdiCCYGGpQ+E5ypK2W1ndhX/v4VKM/lBBQYgvxa6lPli2a238qsYn1
	TfCg00JwouOnFMkvAxoZKAOKa/xM6zU9bid/oaoaNW0UQ
X-Google-Smtp-Source: AGHT+IHqRHN2nCREFIU+7WvTgIgAGT3NHsGXx+k4qM4IQOHTL9he4Tumt/53A3Ee/HS8Ncy48DfPrw==
X-Received: by 2002:a05:6a20:3ca1:b0:24f:53e8:ccb1 with SMTP id adf61e73a8af0-24f53e8ce0bmr2614951637.55.1757058716443;
        Fri, 05 Sep 2025 00:51:56 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([115.25.44.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd347db1fsm18842120a12.47.2025.09.05.00.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 00:51:56 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	corbet@lwn.net,
	kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiaming Zhang <r772577952@gmail.com>
Subject: [PATCH] Documentation: KVM: Add reference specs for PIT and LAPIC ioctls
Date: Fri,  5 Sep 2025 15:51:15 +0800
Message-Id: <20250905075115.779749-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CANypQFZKnwafAFm2v5S_kbgr=p0UBBsmcSVsE2r65cayObaoiA@mail.gmail.com>
References: <CANypQFZKnwafAFm2v5S_kbgr=p0UBBsmcSVsE2r65cayObaoiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The behavior of KVM_SET_PIT2 and KVM_SET_LAPIC conforms to their
respective hardware specifications. Add references to the Intel 8254
PIT datasheet and the Software Developer's Manual (SDM)  to ensure
users can rely on the official datasheets for behavioral details.

Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
 Documentation/virt/kvm/api.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..d21494aa7dc2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2083,6 +2083,11 @@ The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
 regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
 See the note in KVM_GET_LAPIC.
 
+.. Tip::
+  ``KVM_SET_LAPIC`` ioctl strictly adheres to Intel® 64 and IA-32 Architectures
+  Software Developer's Manual (SDM). Refer volume 3A of the `Intel SDM <https://
+  www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html>`_.
+
 
 4.59 KVM_IOEVENTFD
 ------------------
@@ -3075,6 +3080,14 @@ This IOCTL replaces the obsolete KVM_GET_PIT.
 Sets the state of the in-kernel PIT model. Only valid after KVM_CREATE_PIT2.
 See KVM_GET_PIT2 for details on struct kvm_pit_state2.
 
+.. Tip::
+
+  ``KVM_SET_PIT2`` ioctl strictly adheres to the spec of Intel 8254 PIT.
+  For example, a ``count`` value of 0 in ``struct kvm_pit_channel_state`` is
+  interpreted as 65536, which is the maximum count value. Refer `Intel
+  8254 programmable interval timer <https://www.scs.stanford.edu/10wi-cs140/
+  pintos/specs/8254.pdf>`_.
+
 This IOCTL replaces the obsolete KVM_SET_PIT.
 
 
-- 
2.34.1


