Return-Path: <kvm+bounces-40388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C923A5711E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85FF33B8CB6
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C6124E4B7;
	Fri,  7 Mar 2025 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ocoog27G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D65E21C198
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374612; cv=none; b=tUm0c1YTHEGSDXMCB2SH1TfCfVcO+rSoLdGkhLa6iRXsKJLZP4coaRgkzPQuBCcRJiFmPlHfaZZeZO2RUsIBBMTaPxboWYqs6x9QM3474xpjG3tqdlTN7W978272M6gn8xKoaLyssnNkoXS4t7GqYejkMJOdWkKZ3BFQPLUyqMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374612; c=relaxed/simple;
	bh=ONnsblcmxaZYUjElGGhA+pC+7SIqeEFJ+Lg1pNGu//s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bPgvWBBDPmDZIixO68ELNSkWEV9ux4ImME+xqo8AjlbvpARjhdP9TxbuF4KJAxmYGLRAOI+QNb2Y8D1WLuNDCYL+c96JVuJSXL4JK6ccu37dGj+62q+c6FPkUN7LIviLy+upd2NlWylwWfhOd9w3FUAu8lA4PTQhk17xJqjInxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ocoog27G; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22337bc9ac3so47628875ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374610; x=1741979410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8fmW+9iS3PmT2XAAZO5m9vMY0XGD6LHO6SASf0iJxOY=;
        b=Ocoog27G97nVxVe/FlfhLAfgm+n6iR+zl2Tk8v5U758D2D6AXCSIZsaD6lgvNAJhYR
         k5nyyS4IxVaemyzEdZWKzzUCQXu6ejKMOgJLEeTvqXZRoBAbpSATfKlNq0Ef7colESHi
         LvXfl3lLENM2eocYsMEBVGgQdvU30Uhf6KVESEPhafNBVQiQRIvrQm6KtbLmuGWf9Q8E
         XXl2xCqZPrJEFsXlM8L2qQ8aLT6FXqE8aRLJrbd57FFhtn0Aoz1Wx/zZD1o1uauBn3mm
         Vm5wUGKReOqdXf14VktzS2Qv+V+JEQXgDK55ZfV/HK4RaDt9DExH3OTVvmgwIbccCQ1x
         k6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374610; x=1741979410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fmW+9iS3PmT2XAAZO5m9vMY0XGD6LHO6SASf0iJxOY=;
        b=A7u6Y6NA5pAxQtvH/jcJeGa4tsQ3vbeAKSeWgMJCGugk+/kpq7MBhbtd+0esWVsZi1
         4lrqVK54ykZdU6PXK7DpdzEpW0YjkdlZdTwdYiu+co+CI07JNZrPLzAjcF6DF/JvXafi
         C0rpl081N/EtP61RdzD3AAimuvxzvqYXwaCUh32uSZKJxS2wRWGJxygNa6bcwrgMJJO8
         W6yjbnemtTy3sCSv5x8igvFSsTK5eMaTAv57rYnKyMzzm2/0dUgUoOzSteTS5mRheFCN
         sRmciaVkvNq4C1oQfBvNIYRgdoRiySkzPP/EIURF7pqDmcHMPoKn4LVZdYqdbAavGRxY
         Se2g==
X-Forwarded-Encrypted: i=1; AJvYcCVHutMg0CpnJKlkMg5PwdUNyhmXk4scd3s+qrnVqHdl5oaw8H0OeunZxn7NySAUnJHWv5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvMtmCHL1LInks1XaFd/YbIW+Ch6GHJlkC8L2zYfVH7m3T9+0T
	L0heHUVPyGFD2ggQSdjYYNLpNoZ0FKqb2wiHy9rgn6ZcguKd/mr4r8u2n+ry8cw=
X-Gm-Gg: ASbGncu9aOifeQwPnnTfuS48V1nO78J21fcK68dF5u2YjKDXvT7G4mzxLVzIwwtQEUc
	6O8XR5P2YKfxFajep77G5ulMT68C7sx/Sr6SF8XnmgX4OdBrRNayDBkZhqFUTBQtBE4RYB0WQBa
	1pF4R78iENM0PK1sJxFCPexacbuVeZuf0Y6Qt9Vdh8odbTFScSkrQ9GV+GpkxDtJZ6kM4/OeqDe
	HAKGJIN1cUPvUhhRxB+wgO03ZiuJqqK7KL5KJA2wuSiQXQnA45GC7p3ck7M0luoPV5zbbAHDfaM
	UISc4GxHI6FnzSR4WH2efgJHGKj5UoevKrkVYFTY7RTF
X-Google-Smtp-Source: AGHT+IECxrDCFtIdTWnSb1B3IJubkBg7Oin2BPr4sIgfjEKC9LVYl+fNe3gSQDbgmFBFaHBFR75q4Q==
X-Received: by 2002:a17:902:da81:b0:224:c46:d167 with SMTP id d9443c01a7336-22428887604mr58984615ad.16.1741374610024;
        Fri, 07 Mar 2025 11:10:10 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:09 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	pierrick.bouvier@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v2 0/7] hw/hyperv: remove duplication compilation units
Date: Fri,  7 Mar 2025 11:09:56 -0800
Message-Id: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Work towards having a single binary, by removing duplicated object files.

hw/hyperv/hyperv.c was excluded at this time, because it depends on target
dependent symbols:
- from system/kvm.h
    - kvm_check_extension
    - kvm_vm_ioctl
- from exec/cpu-all.h | memory_ldst_phys.h.inc
    - ldq_phys

v2
- remove osdep from header
- use hardcoded buffer size for syndbg, assuming page size is always 4Kb.

Pierrick Bouvier (7):
  hw/hyperv/hv-balloon-stub: common compilation unit
  hw/hyperv/hyperv.h: header cleanup
  hw/hyperv/vmbus: common compilation unit
  hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
  hw/hyperv/syndbg: common compilation unit
  hw/hyperv/balloon: common balloon compilation units
  hw/hyperv/hyperv_testdev: common compilation unit

 include/hw/hyperv/hyperv-proto.h | 12 ++++++++
 include/hw/hyperv/hyperv.h       |  3 +-
 target/i386/kvm/hyperv-proto.h   | 12 --------
 hw/hyperv/syndbg.c               | 10 +++++--
 hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
 hw/hyperv/meson.build            |  9 +++---
 6 files changed, 51 insertions(+), 45 deletions(-)

-- 
2.39.5


