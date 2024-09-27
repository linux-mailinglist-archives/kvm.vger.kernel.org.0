Return-Path: <kvm+bounces-27619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7887E98866A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 15:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABA70B239B7
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 13:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF99719C579;
	Fri, 27 Sep 2024 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="HZsmwKDC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04E219ABD4
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727444515; cv=none; b=ubaqyMdQdywePV28RUwy0cfemraP2o+quPU2x7xumdFw+bEwM4ZYZxX4LdsvzQ6HFn/qLn2Cfka2ApOs16j7hQEVOkBjBS6cN7BFwpC41rwkdfjn9gbVk1Bo23gNpqAoui4l6FLJQCHdPricNFkdTMxdOB5FyhcynL0ppbrcMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727444515; c=relaxed/simple;
	bh=kXRwG34UI+bturoVzhgeOOxPV0f/Bx4DS5Ky79B+J7c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kfvVXI2HRTP8dXHiAfOxqxhfOrR6BuwbReYgW7Yum2pWmMJ6xy9xEydSgOyR5iZBqiVrk7K4OvGzXOAZ4GV9GGaR6EMoBjVcxf+ROtdjFJIm8WrduhZR78ZKEDGDmQoquKhJP0s5zurCEJMTW0ioGGh5/MSbAPNFR04kiUDiOEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=HZsmwKDC; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-2e0b0142bbfso1029542a91.1
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 06:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1727444513; x=1728049313; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7rJ/O+z7bpxFdhA8Ut3eubNwBQf96yErA3CvXZEpw4=;
        b=HZsmwKDCg5z5iv0oyxA4a1hnmSOBOQ4tDzYy5JS3nUBflIM6SY5gDlhU8MMipvezKk
         Pl0kwE41+4EwSq2oMIZD5sHh6bXxaotMdRDMZw22ONg7gWz4ljU/K5B5Am8gZlZInA4h
         /VCbLUiQhKxqmFWCmEvYyqUg2lxYB06hMMqRvDcA5omIdnegd/VSDWTIiXFjCtjifygd
         H4Yh8vqFDem+c+n5U7SpngkvALh1K6jdv6yp2FfLCpR3A391GfCCYHxT1MvfixOFsu+M
         TJ5x/ptaPASdu2DwuTjBprVLS0Xnd3HAzpOhQNn2eBj9g8k1Y2iISCsN69/I2NASrHyR
         nD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727444513; x=1728049313;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7rJ/O+z7bpxFdhA8Ut3eubNwBQf96yErA3CvXZEpw4=;
        b=UWTPxqpG1Hezl8bGkKOG6qccVy08KwtuYWftcOmw4f4jIOTZs+wJKMSMlsq1ViAWfC
         ZqlHRAtmigjE+O/RuPQFKRVLx5URLGc/nRAqdmm/F3HCLgFlQ7f0rtjOLCrfW9eGYRCS
         8FF+84hChDQP0zQkileyQ9tTuHBrRXWCxJcXFxsMv+dXWmctCR7eB3Yki64Uj5NUQa41
         OyxAp0kgwyIXEed1lu4NxGYc3i2H/jb1WqKOTq+cIgjx+bEwswYigW5jlE0fZU3SucJS
         RNtFM5XaCC618Um9e868HKBB1KAMkuAuwoKG7CNFC+QjzLyk/SQoofYyClevIi6i48vS
         GKBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNJItmVRE79wpzYHAr0wjS4GN4uCmutZ4I1cnrUPOBgdTiasmUvF47jmiLil3reNGxfcY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm/d5fLaWj0q2Pw/p+YZnAGpO8ZNhz8tzVzF5axei+09eqxuy4
	n2RSFLvK83P0fQYhdqL85p1AT3/tvgUsOAweWGWWvA0o++LlSEiixZjGAQ1qyP2FTzP3w98jrDI
	fdHBR9w==
X-Google-Smtp-Source: AGHT+IHd0pjdAibmhIjPPq9egnYivm5hXKu9xdNfijgHfStvVPMb8ZqhOcsLfmCZcJhJm3LSp2aMNg==
X-Received: by 2002:a17:90a:f002:b0:2c9:6abd:ca64 with SMTP id 98e67ed59e1d1-2e0b71be347mr5415189a91.9.1727444513078;
        Fri, 27 Sep 2024 06:41:53 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e06e16d6d2sm5671744a91.2.2024.09.27.06.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 06:41:52 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Subject: [PATCH RFC v2 0/3] riscv: add Svukte extension
Date: Fri, 27 Sep 2024 21:41:42 +0800
Message-Id: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABa29mYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIxMDSyNz3ZTUMt3cxIoM3eKy0uySVN2i1KTE4lRdI13TZJMUI0uzFENLEwM
 loPaCotS0zAqw0dFKQW7OSrG1tQB4a8FLbwAAAA==
X-Change-ID: 20240927-dev-maxh-svukte-rebase-2-5c4d296d1940
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1609; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=kXRwG34UI+bturoVzhgeOOxPV0f/Bx4DS5Ky79B+J7c=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBm9rYeApPCCtbRKlNa0fE1A0kbxZJAywkNuCj78
 NBFhfYWq4mJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZva2HgAKCRDSA/2dB3lA
 vcpOC/0VaRoc0IjaAnv5H9+vh7FVkndqjkCNsVcqxk7vUeC9xBFqJEoAHh5Dl03M8SXUcJ8tph+
 kFnL4hsHgu0u/UtJ6QcJaL+7CCnhKx+7tQFuviIbbm4knj91J+2iFU0cIHheHEn26UHvx1oguar
 gxMGJo+JZMRcVhWae2ABGXQx9YY8kENuIRar1jmm2qFfhvL5hAHp4MuT1XWx3KTzqxwQLNt2VQm
 hbNVCJA0Lb7EXREcgCeKddpxezeHTlJiiUlMFEOWo/waRN/8XRYhddDP3fdSUf5gWc/1Qe9kcW9
 quTNevQGuK0XZM4K3EgGpRN0C3wxIDdHlcxrI3xNihgTxIPbQF9kaHOnUfxLrfbpeGc4qXy9VQC
 b4M2V68cTEUW/+cEe2lz77WnQSGlvWTsOz+tJaIm2NTSASK6jQHC1xWzxDiyCHYMk3v2i58wV7t
 yi4jBX8y+8xIyEZ6Ae4U0cA1xHOQQZlVSqJ+/DZFECCRAmqfnyNjygsleoVQ/eDg2oaU8=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

RISC-V privileged spec will be added with Svukte extension [1]

Svukte introduce senvcfg.UKTE and hstatus.HUKTE bitfield.
which makes user-mode access to supervisor memory raise page faults
in constant time, mitigating attacks that attempt to discover the
supervisor software's address-space layout.

The following patches add
- dt-binding of Svukte ISA string
- CSR bit definition, ISA detection, senvcfg.UKTE enablement in kernel
- KVM ONE_REG support for Svukte extension

Changes in v2:
- rebase on riscv/for-next (riscv-for-linus-6.12-mw1)
- modify the description of dt-binding on Svukte ISA string
- Link to v1: https://lore.kernel.org/all/20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com/

Link: https://github.com/riscv/riscv-isa-manual/pull/1564 [1]

Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
Max Hsu (3):
      dt-bindings: riscv: Add Svukte entry
      riscv: Add Svukte extension support
      riscv: KVM: Add Svukte extension support for Guest/VM

 Documentation/devicetree/bindings/riscv/extensions.yaml | 9 +++++++++
 arch/riscv/include/asm/csr.h                            | 2 ++
 arch/riscv/include/asm/hwcap.h                          | 1 +
 arch/riscv/include/uapi/asm/kvm.h                       | 1 +
 arch/riscv/kernel/cpufeature.c                          | 4 ++++
 arch/riscv/kvm/vcpu_onereg.c                            | 1 +
 6 files changed, 18 insertions(+)
---
base-commit: b3f835cd7339919561866252a11831ead72e7073
change-id: 20240927-dev-maxh-svukte-rebase-2-5c4d296d1940

Best regards,
-- 
Max Hsu <max.hsu@sifive.com>


