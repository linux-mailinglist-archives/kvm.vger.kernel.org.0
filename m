Return-Path: <kvm+bounces-33481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFBC9EC992
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 10:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA20285C86
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 09:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D0A1A8419;
	Wed, 11 Dec 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Do1Pw9Pi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F0D236F9D
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 09:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733910323; cv=none; b=XVvl8Zpv+v3UXoWrsJjinKB9WB7ImkWnKZjUmWF+3fAD0QMKc+9qe6KRB/O764u4B7hxwJRdxtDDYi8E8a/L2Qtedt26kueQtRtKv/jiBchdhoHO+epbmC6Sn/nFjqFqkHCc5g1Y2ndfTjJFIkQRwuo4c2aAzXLfDKgoepT2nfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733910323; c=relaxed/simple;
	bh=1DLcUTgOhU9dxpNm36lznbJ8o7mRT49WQ7R6GPFn3Ks=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mz3XuDWemVJSwEZ2FUG+5fEmiyBMqPV6eMZ2bmQCnDoaNDcILtE9Hosp10Q4xf24qBQxcHDL2qza/QWyX5AYZDK8PbfsmKBYsuBvrTYyvgLmWvvK7Hyb5k5DmmHqAJsivNxVTOFgWV2jzBKB+q3cHap6zDnk+/qoRJqlEF7xeXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Do1Pw9Pi; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434f15b4b6fso22187325e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733910320; x=1734515120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Py9Ei6n3Myyk08ny8UhCuCplC2b1X3m3Qp80EVP+d40=;
        b=Do1Pw9PiLbJz2Y7ItkSmepr61e+pY5btK/a5lEygpGWap564lxBYa8QEP8N1B/Sk2E
         iYCI1kIIaobGA/qjpU5sjQGszJNAz+MkQtZpMJOSDi3P3nwHEjdDdSP8n6tOVC8ZW5kI
         zvHUG6TGzboEWSPdY+Gfy8pRmW+HJlEVjDLMClyiySt5hj08SlImq2RMyWg5TxHohJJN
         /NgeXF27Qxgc1rXn9B+54G86QvXxn5QCSTzZa4koBR2qXzvkNUjKWSisG15bpCSPlqEQ
         vdGaSH9iHQz3essHJY4PjPSyy000yAloQf3QB7f7Vmktk0ZV0Powe/1E9O7pzKiAJCpM
         QjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733910320; x=1734515120;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Py9Ei6n3Myyk08ny8UhCuCplC2b1X3m3Qp80EVP+d40=;
        b=l0I56jbuMBApxbs1EO0eYGz0H+CsNlZ/HJrzaTknyd6VFZk6WYwXo77Qg7uRpgyxag
         ct8HFlWLXU7pRb+Sa5t99drI0ILK4M0E4VNj6hKA6nLSoo6RB3pWSgKdgBQ42ZNHa+ZE
         OFEalXR3frK/5MdJZixZOfRde1Esi5JtwXQdZVT7ImydSmrEKw/MsUKJyEuLmig14tNZ
         BGDRwBn3D1xKidx8DOuq3OgrhC0JhLNB/wKW4qM9/0X6C3KmSW597tWWfxSSHii+6Gz8
         /55UgdGIhEj9Q6ihcO04QsR40KYm63RlFXy7WD3TJzwbYqf1rsUCln8FYABbj7os2twZ
         WvTg==
X-Gm-Message-State: AOJu0YylS5nQVmZ329z61TNr4Q5P06K9Gk+dUmkIX+HtkMdTlrA1Z5dx
	FTmAlmYqAKrJVyR9uet7jtTPq1jD+Ipi4hB9j0yckZdGWuLKvHw7o4OyQ2S70efTwqdKFS6sLio
	G30q8mKyLHa40LsQAf7olYxnA6uOi46mT0tQzuWmhXhsX4zPl9joWPa6fHwIFX0UbkKZrKcTI5O
	ymUJXKHmoHZ5EQ/hVqaY40qOk=
X-Google-Smtp-Source: AGHT+IG0cT3H8mv8VeO0H0pOu/z0WQCKfZkvlEncxAVxLlIAZDxwFZ7eFz8yBK2wlcrbFa8SRxWZM0w88g==
X-Received: from wmok4.prod.google.com ([2002:a05:600c:4784:b0:434:a2c3:d51b])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c14:b0:434:ff9d:a3a1
 with SMTP id 5b1f17b1804b1-4361c396c09mr15258285e9.2.1733910319753; Wed, 11
 Dec 2024 01:45:19 -0800 (PST)
Date: Wed, 11 Dec 2024 09:45:14 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.545.g3c1d2e2a6a-goog
Message-ID: <20241211094514.4152415-1-keirf@google.com>
Subject: [kvmtool] Reset all VCPUs before any entering run loops
From: Keir Fraser <keirf@google.com>
To: kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

VCPU threads may currently enter their run loops before all other
VCPUs have "reset" to an appropriate initial state.

Actually this normally works okay, but on pKVM-ARM the VM's Hyp state
(including boot VCPU's initial state) gets set up by the first VCPU
thread to call ioctl(KVM_RUN). This races boot VCPU thread's
intialisation of register state, and can result in the boot VCPU
starting execution at PC=0.

The simplest fix is to reset each VCPU when it is first created,
before the VCPU run threads are even created.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 kvm-cpu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 1c566b3..f66dcd0 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -154,8 +154,6 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 	signal(SIGKVMPAUSE, kvm_cpu_signal_handler);
 	signal(SIGKVMTASK, kvm_cpu_signal_handler);
 
-	kvm_cpu__reset_vcpu(cpu);
-
 	if (cpu->kvm->cfg.single_step)
 		kvm_cpu__enable_singlestep(cpu);
 
@@ -293,6 +291,7 @@ int kvm_cpu__init(struct kvm *kvm)
 			pr_err("unable to initialize KVM VCPU");
 			goto fail_alloc;
 		}
+		kvm_cpu__reset_vcpu(kvm->cpus[i]);
 	}
 
 	return 0;
-- 
2.47.1.545.g3c1d2e2a6a-goog


