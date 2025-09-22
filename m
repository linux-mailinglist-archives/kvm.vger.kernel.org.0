Return-Path: <kvm+bounces-58386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 563E9B92396
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11D9644370F
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACA6311595;
	Mon, 22 Sep 2025 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="InzbI3M0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523920FA9C
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758558586; cv=none; b=hyCsN8p4PGrCMSexZnKBpwtPz17XdeXzfvB3Y94Ac7Wfo+VIODXLvlI2N1hMh4Nh3aHykxpp/ckBWb4I2VWE3yrYOxcww5eRcHhGKZax4Mi0zPgdfWBrODaXjddRCtBHXPVXc0VYzg2AKp0+KIwDo+yak0YvXKTSPJNc4aR368A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758558586; c=relaxed/simple;
	bh=BNpuoWscqWPIQy/ua0d92zBuwrVxwqe7G/MAj/J1buE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rWLEPn+tqTUTEkdzM1HA1fsj+Tq9c4PGGZ4U1M+CbAYzOs4A+mh+ZtIsURYkLQkKjLXaal7Bcf2HgcBPe+WN7f9AdPL9n+Qx3BdnBbz5RPDicXPuT2fLlWQQZmkRpBdaQ/Hx7gdzXvvxCwg9MLxR1D7KYn1Q7EuL4E0IrBK1tQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=InzbI3M0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb45e9d03so4136558a91.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758558584; x=1759163384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4jnnjuKLSYUVDhTiZqC/IzKihdyANGAPDm6V/YZHqys=;
        b=InzbI3M0elXqdcbsPEGd7+biy3Z1aNGZuAm26sSrMdFVuh6miCPi8cnJZNaCos/1Y/
         M+Vr91xsPRl/7vT87dm5aDoSdCJUeZYHO29mQmUY5c8OJuILnAHevq7pwkXRKLF9lSs4
         FyPRMVrDQbwyKMOSjPMshD3jz1Do9D4meSVbVr2RHUkriT5oDQssf8GqhLPhoGoJmkW6
         AtiHwNQbcn6KdzfDPrD5/Ldy9y6AQfe30HW0Wy+t5MgpFo9ibOXAS0yF97Z4GfJh0kg4
         iHkVY4ycgf/FjuVxqR9KORsjtGcvGQTXLcQ9IjCvz8rJ+XzYfH07k6VVzcC3Myn6Y8Vu
         yqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758558584; x=1759163384;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4jnnjuKLSYUVDhTiZqC/IzKihdyANGAPDm6V/YZHqys=;
        b=U1b9ssRyWvTuNSxFw8UoZltBssBQcPhMzvTOm5+weG7zDmZOHh+yqtFoSBM+U5S8ep
         yOZ4J3qm/r3iD64FElIaPAo3iU31yFaSKBJ71Pa/hWlxkEKk2jQIDuhalRCf6KaL4L8F
         xo+qRSjhMSUw7dI8XVZ/Ge3fi/WBwJnof/kSKxLJhSa9tuT9Dxyfix0x5JMeNmPCp73p
         88ExJwoTXYa9cTSr5mwIB5nK2t0k/VmVeDmU0l8/ikxoBalmOUZ/OPef1qXPAI8fOG/T
         /vYXy4EFt49OCfN02KGhhI18qL5TNiwIf9b+E5qMlYwdQn+nyUPrRzhFLFGZfqpoQ+GM
         K0Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXTyk1KklJzq1QI2c5Hx9eGgsXlOwdS3XRPj9At7Tdzs+6k+wWDCL9urpTrWD9KZ63sQQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpqDv760kV9QMuSllRm6IKx6DfO3ZsRqmNRIk3iPKGvlzRNIBj
	O8BYY5UklRnDqbnCon9tFuxHVzyQumqUkoPhHXd2nZFy9i1xRuyNaYDq7VV3m27ZhAqKG2Fw1Uw
	DUM0N28TvM1EhoQ==
X-Google-Smtp-Source: AGHT+IGguMbVp50NCUFx1El/2VL407lzgDW2byc5QrRm4W72G//quMgmHLsbAf9GYPqCvQhEbX/zrATSjVSVSQ==
X-Received: from pji15.prod.google.com ([2002:a17:90b:3fcf:b0:32d:df7e:66c2])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:54c5:b0:32e:dcc6:cd33 with SMTP id 98e67ed59e1d1-33093851a09mr16624962a91.11.1758558584275;
 Mon, 22 Sep 2025 09:29:44 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:29:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250922162935.621409-1-jmattson@google.com>
Subject: [PATCH 0/2] KVM: SVM: Aggressively clear vmcb02 clean bits
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

It is unlikely that L1 will toggle the MSR intercept bit in vmcb02,
or that L1 will change its own IA32_PAT MSR. However, if it does,
the affected fields in vmcb02 should not be marked clean.

An alternative approach would be to implement a set of mutators for
vmcb02 fields, and to clear the associated clean bit whenever a field
is modified.

Jim Mattson (2):
  KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
  KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN

 arch/x86/kvm/svm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.51.0.470.ga7dc726c21-goog


