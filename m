Return-Path: <kvm+bounces-63289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E906FC6039F
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 12:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8BFA14E42BC
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 11:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94650298CC4;
	Sat, 15 Nov 2025 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQk7llZh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5837D27586C
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763204927; cv=none; b=lj0kTVCpFVgaAnAOlgs3gy5z9SyQOY+Drq49ifyyxTBDPlZomCPb53wn5xGmWEW2k/RkRzn/oi6Zm0jW2CMSeTRMwX9rpzQngD3c9E2zLAiyPuomh4G5d95p4QgyFvQjhfvAtGBxxg29LBoJ8yHo3wj6fA26sUmZXhxLwDFRzNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763204927; c=relaxed/simple;
	bh=QtvTn81Ua3FPrkbPOmPO0Brx/q079uamkttCqZ3CW1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cHQ9RJGNYP+g+w0Vk6b8g4XHUF66zfgWXzAIsczA/hE3AZMqvj/IDphmvntL+6s91UgWlVmhYc4K6a3Ba7POLmdGm45b3NRQ3KLF2GC9OUlHuNMTGkJW5TLlaiY6h0aXCpsJ9EbpxZqCXfRt8K3wZ649Kn5MG/9TaSkcEhzSw5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQk7llZh; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-29808a9a96aso27396435ad.1
        for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 03:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763204926; x=1763809726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rDnL4NHaav+5ZUQoJnC9lyriFUqkD8Usoc9H6SDFlGg=;
        b=QQk7llZh8JWGVi90vuDrQ4AFX/S1+4PWCJ32xdlj6yU5W2NDXz/Va/YjvrVzLIAvBh
         zlNN6dtsbdO3rEwkpKiX5VMXwuyhjqcooxiabpYKpKw8BuDsmNq+Mmv3gSmfcSHy59hA
         cM1J9ow0jJgwFtG09bdGVDxaQouzyiO+jd9UCxZm0kOAzXCfb226UN3yIVFJel7Mr8uD
         wIHtLBVQIi32f0hnvY2Er/WrthQ4Ceab6OxVp2rFxtC68PBA4dui+7p5Uffh3fOQlv7f
         Eb8RDcahEU9G0TCDnMNetP4bLXbVnhIPtOMNQJ96d16agZ6JYbd19MTEFSsOGNoWFH5l
         4CgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763204926; x=1763809726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDnL4NHaav+5ZUQoJnC9lyriFUqkD8Usoc9H6SDFlGg=;
        b=VIwlE07BfYVJa9TN3XIbQ+Tc8xNI0aMOqd2FUOTB4ejEekgCNLYw/59gLt9P9xMGqB
         vpIsLUKWzEJujmYj0bMw6ot1XblbIJnsQfZwDz7oZG/t7JSe+ljTOM70S0XQTq+zHUNt
         ENqQK+lsUOl8avAojLTXdRxg4aOLO735ISGN01jwXKYzPDXmtof8RWLabSjr3e3HLpI3
         uF9J6x5HUqq+RIWV0HTea7u2ZvRMBWrHaWRJ5uSJtPyjMbRECJmh9gy2nqieCtGZtZBy
         GF8oKmeBurWLSPb5GetkasY9n8xF74JGa7QeEmIBP7WGaWUyTJGcY+D690rS0DDLE2VH
         GZ2Q==
X-Gm-Message-State: AOJu0YxkCqx002ZWMVRUp+zMSVT8/HJ7X3wvv9LnUj+ngWSgE/NLhvwi
	d+gIYByyKh2PYWm99U5xPQ6BRa195tnqyr9LLujDUkNlXP/7YRAN6Lmg
X-Gm-Gg: ASbGncvP8iRvB/njXqTUnxpV0H28U+eOjQmVVNvrOovh42DXpAMf7DGaAax0uCcpzEm
	zjIQP+MCaj8MXCudZM8sQzykYBw1EUX9oEfN0wTqoMVAh4rP3k5YxmkSb0H9kTL/7dmA9f9f18c
	fS+Sj30gB5dHUcBvfJ8liHPdtawB8PGndCO7rCLpzLQpqZBiNMDKtH4j9nINwzoPCBT2ruFOrKB
	PlN1N64Q+WlHM3YY+9vr1/OrutLQt4HQs8WVgdjIuwP2NCj+qs0o4cWTvLxONYwlqA8Bezwn88W
	okQOhjcZHWiY1phiQxGCOMoMCYOlrzNmB8sz91hcH6K+jKrjN/2fGeKGP3SKt8KWZCHdZTD9i0G
	IQc9cE6q0+EJqj6TkzXo96jbrlj1qKcrl/wiSBH1Nav2sDhBdQm0ieaV/+tWQWC4qE4rzViNJ1x
	jS6fJhdnQhiE7hehrwNDY=
X-Google-Smtp-Source: AGHT+IFIJ8mHDNSkemnB2t7aJI0eDgMICqUE0flQlOmzI1znoGOCkGrq0gi0iwMEPY6C4gHGcgK06A==
X-Received: by 2002:a17:903:196b:b0:267:f7bc:673c with SMTP id d9443c01a7336-2986a752a74mr61755755ad.44.1763204925585;
        Sat, 15 Nov 2025 03:08:45 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bed5asm83839075ad.88.2025.11.15.03.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 03:08:45 -0800 (PST)
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@vger.kernel.org,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: [PATCH] KVM: selftests: Include missing uapi header for *_VECTOR definitions
Date: Sat, 15 Nov 2025 16:38:29 +0530
Message-ID: <20251115110830.26792-1-ankitkhushwaha.linux@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The exception vector constants CP_VECTOR, HV_VECTOR, VC_VECTOR, and
SX_VECTOR are used in ex_str(), but the header that defines
them is not included. Other exception vectors are picked up through
indirect includes, but these four are not, which leads to unresolved
identifiers during selftest builds.

    lib/x86/processor.c: In function ‘ex_str’:
    lib/x86/processor.c:52:17: error: ‘CP_VECTOR’ undeclared
    lib/x86/processor.c:53:17: error: ‘HV_VECTOR’ undeclared
    lib/x86/processor.c:54:17: error: ‘VC_VECTOR’ undeclared
    lib/x86/processor.c:55:17: error: ‘SX_VECTOR’ undeclared

These vector definitions live in:

    tools/arch/x86/include/uapi/asm/kvm.h

Add the missing include the userspace API exception vector constants.

Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b418502c5ecc..fb589f07f2a4 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -4,6 +4,7 @@
  */

 #include "linux/bitmap.h"
+#include "uapi/asm/kvm.h"
 #include "test_util.h"
 #include "kvm_util.h"
 #include "pmu.h"
--
2.51.1


