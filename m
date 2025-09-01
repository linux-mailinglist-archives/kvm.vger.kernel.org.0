Return-Path: <kvm+bounces-56457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 152F9B3E6D2
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDB3C3BA86D
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F912EFDAB;
	Mon,  1 Sep 2025 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MS4lZk27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3DF17B402;
	Mon,  1 Sep 2025 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756736178; cv=none; b=YFvhXk18dSCV3n7DdPyBMVNYkEl8g4ENjzc0DgmZ768lUPOnHBiTuP1vREZ5SUec52sIOvD36FFpmULB+x7+YQ3mLHW2ZBxN+h7u7dInuQg88IxQp7EuOscvqRRnhnMt4JTPPJcwvtO4NNUAgxOoEBsTiOTnO6vNIhb6ybkUP5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756736178; c=relaxed/simple;
	bh=J6adxaMTbKmeAjhW+nOvDYWFj4xMGaf6efDHsjIWpX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oiqeh5hPuvALmgzpvOf2a50UbP65CZ9IOX3tPU0Ve+jATvty6z8/a4D1zWG4Td11vBhpvfhigyyLRKgA/I4+Z3ix1m58SDjAERxFFR5qUeKY9/432OJjorj+8W6VUgORcn7nb0W5R394BmAIu0wBb/V7vhU8HVznQQ/oLjrHi8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MS4lZk27; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2493798cd83so5333665ad.0;
        Mon, 01 Sep 2025 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756736176; x=1757340976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=olATEhuJ7Rj0q51m0msTdMRcBctLQkkJ/hDbLCgUHPE=;
        b=MS4lZk2771oiwZYLbVz2HlI+WmCk+dD+5+i/SReGFvnkhwWRIUu/5zSRooc9UdSg6S
         One0Ixm6nnn7FqmZItrexbI/u8ZqSwQBw+kXe8HmL3RItSHRIl6Oj8mvJoEZv8zGt1uK
         y/Y13qUvHVzuhIRD/hR5qG5O8Zbfw8gjfyLu/n8pT1cu1C+j/FQ1f0cYQaQk00CuMVF2
         8n28/q6MATDyHAGIHtTM2mcvfDmDt4ulIMB/JYahIXnp5Sx7WscTyydOh+//8BCB0OOs
         vZXtrkP1VqtD3gc5lzMd60lhGEItBoTRNIi3LrF7vCQY4AAphpK7oycCuHsrvRtE+Go9
         wEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756736176; x=1757340976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=olATEhuJ7Rj0q51m0msTdMRcBctLQkkJ/hDbLCgUHPE=;
        b=cmY1ju/AoQHcw6OA4vxucI9QAqtCq0osS9+2QXIxdcxxiJ0enxOPQpI9UzhW1qrCwY
         8y8ua1ZO46eAg+YPIv2SG06ZH6XbtnGab3rz2dU+1cjzJsJ0NJwbLDY9+oSZJ/h+Ma0w
         EhbpVFv6GPZlSwvVDrmWbvwK3Tx3Ises5jTKQUf5AhERZFiD3OUt9Cb3TL7YK+0BvStu
         AnyOHlbQAMWipNDCxu9ZQjbKsqKczbAMYWeUtdwjAtyX1+G6UCNgL4VvLPglWeUo5g30
         g1BfmTJKo3z5jBpFOfvgUS5FO9nroJcmJOFtuO0telTrhJypfPKpbmsylNCHMls4SUt/
         9HUg==
X-Forwarded-Encrypted: i=1; AJvYcCUlTRIO4zR+rnLF714mLC+YbHoutrRG1P5G4RknQPaNGe1OdN6X8PLI8waYogrYV/qL6LsxB3PN@vger.kernel.org, AJvYcCVBv1nu4CSjRQ9L8s3PBw1hp/OCJMwJUSMHDVjQkeHMo5/hHaoCZ1vdUeJgLOCHht2qIZ8=@vger.kernel.org, AJvYcCVMHQ0r5WMGIHnPHe9DwEHEDB2ka9vKo73pu3/KXjE0bhbTndr4fEjnOlYwxQzRzMsnUfG4Jat4eRcpv/qv@vger.kernel.org
X-Gm-Message-State: AOJu0Yya90Xx3XMlV3+vO66ouLuz/8Fs7hMW+4AbjeayH2cHPfykF8gH
	mos3VveKfVIYu2kPGYPX6t7vD8rcrMoiLXoLEHl8v/jbReHwTM/tvIhY
X-Gm-Gg: ASbGncvhMdtpRyfgD2sF43cAFI6xe5Sdt810vAbOIaF+UmmoHjv+aoV9Q726wFgryG0
	oQRFC+1S1qYlaHcPuIFNbsno/d35fjiiSQW8SXSv7k3PuyohiU0gcC/+cNSUG3soLxvSyqiDuQZ
	K/uT88VNSUgc3HNOXimV8mlUSK++R7Jjz9+fSPnWDkicMfN3vvEDKsBhK0ZPWaE5xaH6T3/zLt6
	WYxM/h1ZphC26MJVCbTXnDJLki5UQpAg6fuNAus4uz8MAZNcRTFDuK3ijTX3TkWNZRxDn+IQYYR
	wPzPgpJbZfm5XmJ9TRyrJ+PXcbqun+JpDRQKfS83A0YDB4vmdgfk7Sk8uIKyos4nDgGB8TxacFR
	a7JR/ql1ZG+DcanOLGhM+YRI=
X-Google-Smtp-Source: AGHT+IHf7G+mUAagKO2yJzD5uM1O7o4u98GK3mA53rtvl6kubMMUObA8Y6uYeXML8+HaH3iMeRvPFQ==
X-Received: by 2002:a17:902:e74f:b0:246:ed8f:c63e with SMTP id d9443c01a7336-2491be7d2a2mr85172585ad.0.1756736176486;
        Mon, 01 Sep 2025 07:16:16 -0700 (PDT)
Received: from localhost ([106.101.139.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24905da1b35sm106729755ad.84.2025.09.01.07.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 07:16:16 -0700 (PDT)
From: Gyujeong Jin <wlsrbwjd7232@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wlsrbwjd7232@gmail.com,
	gyutrange <wlsrbwjd643@naver.com>,
	stable@vger.kernel.org,
	DongHa Lee <gap-dev@example.com>,
	Daehyeon Ko <4ncient@example.com>,
	Geonha Lee <leegn4a@example.com>,
	Hyungyu Oh <dqpc_lover@example.com>,
	Jaewon Yang <r4mbb1@example.com>
Subject: [PATCH] KVM: arm64: nested: Fix VA sign extension in VNCR/TLBI paths
Date: Mon,  1 Sep 2025 23:15:51 +0900
Message-ID: <20250901141551.57981-1-wlsrbwjd7232@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: gyutrange <wlsrbwjd643@naver.com>

VNCR/TLBI VA reconstruction currently uses bit 48 as the sign bit,
but for 48-bit virtual addresses the correct sign bit is bit 47.
Using 48 can mis-canonicalize addresses in the negative half and may
cause missed invalidations.

Although VNCR_EL2 encodes other architectural fields (RESS, BADDR;
see Arm ARM D24.2.206), sign_extend64() interprets its second argument
as the index of the sign bit. Passing 48 prevents propagation of the
canonical sign bit for 48-bit VAs.

Impact:
- Incorrect canonicalization of VAs with bit47=1
- Potential stale VNCR pseudo-TLB entries after TLBI or MMU notifier
- Possible incorrect translation/permissions or DoS when combined
  with other issues

Fixes: 667304740537 ("KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation")
Cc: stable@vger.kernel.org
Reported-by: DongHa Lee <gap-dev@example.com>
Reported-by: Gyujeong Jin <wlsrbwjd7232@gmail.com>
Reported-by: Daehyeon Ko <4ncient@example.com>
Reported-by: Geonha Lee <leegn4a@example.com>
Reported-by: Hyungyu Oh <dqpc_lover@example.com>
Reported-by: Jaewon Yang <r4mbb1@example.com>
Signed-off-by: Gyujeong Jin <wlsrbwjd7232@gmail.com>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..eaa6dd9da086 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1169,7 +1169,7 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
 
 static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 {
-	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
+	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 47);
 }
 
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
-- 
2.43.0


