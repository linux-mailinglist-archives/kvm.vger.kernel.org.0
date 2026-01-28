Return-Path: <kvm+bounces-69306-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CLXyCbppeWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69306-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8309BFE7
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C18C1300D5F4
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D5425A2B4;
	Wed, 28 Jan 2026 01:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UCPC9bjb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038E254B19
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564594; cv=none; b=qrbUcY7V84x5V4Ypp6Rl2qfFgw2M7aDTk9ZFXqIPGBYhVqQ9edT9dqOeXLMBs0he1pzImRp5v2iX07wHC82aU8k8B/I+6dYhZwZAqbevIB6HwiBQbqTUd36ftp3uMWSep63UZ9H51VI8dCxIAYWfT/bXNsnjYvRmTG6ht5wPBXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564594; c=relaxed/simple;
	bh=j0s1qIzuHKm1Dt5CuSHj15PHrJ3Ost58ZGpP/cKvDbk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eTbj+jJmtaEogswsHFnGAT53EDEahblfREc5PDijv/IzREcdpmFQkAjpPONAcM9bp8o0ti8MKzOVdo3vuRStGfWCpPtulywDU2To1QrAxsywOFTR55AccT8IV7odrr1IL1slpqHN3U51zxd6whcMtdRi2HcjPVIcEZ3f1Ga4lJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UCPC9bjb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352ec74a925so2226738a91.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564592; x=1770169392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vJtM9RKlKBtslM9posblyhDH9U56GZnbtFwtuNq2ynE=;
        b=UCPC9bjbs+4WHilB9klEFXlxC8y1XF1xD7GjEkXsGkP5JyaHzEsw3VzLuIn+YMlMoE
         dRLNBQn/WZWLgk59RIxc8rDf6WZ0nQOmCZSANuCf86cpBUMpdtODILINGdKbwN/gVEun
         wIW7dqzaLdSM76KQrFHO5QRKC7qjQUqj7gX0mjn2ZV1Cb6muzIZt6Wz+XraImR5fJYyM
         0UuD9qhbrB8ypyQuXPHgPe4EqAzsRFpxd5lQNxFKeA44S+eYHXzJfDRyxsyMmDCnAW1L
         P38P4qRyAB3A4ld/ZBbR8DSQGE1R33T0VflKhwIs9QZL2WcbPt4wh1TIvO/8xKvcWvu2
         +CEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564592; x=1770169392;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vJtM9RKlKBtslM9posblyhDH9U56GZnbtFwtuNq2ynE=;
        b=I0jL5OZLv6KcQEfBgl+frlR7cOa7O6aY8YAby1V7yZAzxznvIqE3mTEHdmrij4IxWb
         cXDkX8WHWlL35MC/8Hyo6WDhlPEH2WdW9UMMuzsysn9cTYK7Tq8Fdhmfm90fDDAa7Vm3
         J4U05PdZGSr/NbBkmrfS6iv4Vc/NK3+H7ScG7icz2JcZMgRviBjmmQkV5fSRUB4U0fec
         j+yAkC7f9OSuqceptQYHtIs/R4R1YlXcoA9KUzPDVSR35wplHqsO+hEGoxYIzQJc7LG2
         g0ahgyQkD7hfIOeu02gGD/cD3SNujQLWbADAtKjEW3QWmOhPr36aXV05PRKRRJYMI+ov
         TwwQ==
X-Gm-Message-State: AOJu0YxgpaIRiU4IUGoKKcQgICWkOSpUA2ZB8BEOgiZK4wDo7r72mEDT
	BJbsFz22KmnK2wxtfKH4tWyr6eKzBJO1Vd9tdtOxTGBVEMnslrNOQuB4qcdfz/qE0/XcoCGjIZ+
	9B/rvUQ==
X-Received: from pgbee1.prod.google.com ([2002:a05:6a02:4581:b0:c1d:2c61:149a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8d:b0:366:2360:8f7
 with SMTP id adf61e73a8af0-38ec628988fmr3941038637.14.1769564592551; Tue, 27
 Jan 2026 17:43:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:43:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128014310.3255561-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: x86: CET vs. nVMX fix and hardening
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69306-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: AC8309BFE7
X-Rspamd-Action: no action

Fix a bug where KVM will clear IBT and SHSTK bits after nested VMX MSRs
have been configured, e.g. if the kernel is built with CONFIG_X86_CET=y
but CONFIG_X86_KERNEL_IBT=n.  The late clearing results in kvm-intel.ko
refusing to load as the CPU compatible checks generate their VMCS configs
with IBT=n and SHSTK=n, ultimately causing a mismatch on the CET entry
and exit controls.

Patch 2 hardens against similar bugs in the future by adding a flag and
WARNs to yell if KVM sets or clear feature flags outside of the dedicated
flow.

Patch 3 adds (very, very) long overdue printing of the mistmatching offsets
in the VMCS configs.

Chao, I didn't include any of your Reviewed-by's, as every patch changed
quite a bit from v1.

v2:
 - Isolate kvm_setup_xss_caps() from kvm_finalize_cpu_caps(). [Xiaoyao]
 - Fix the pr_cont() printing. [Chao]

v1: https://lore.kernel.org/all/20260123221542.2498217-1-seanjc@google.com

Sean Christopherson (3):
  KVM: x86: Explicitly configure supported XSS from
    {svm,vmx}_set_cpu_caps()
  KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps
  KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch

 arch/x86/kvm/cpuid.c   | 10 ++++++++--
 arch/x86/kvm/cpuid.h   | 12 +++++++++++-
 arch/x86/kvm/svm/svm.c |  6 +++++-
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++--
 arch/x86/kvm/x86.c     | 30 +++++++++++++++++-------------
 arch/x86/kvm/x86.h     |  2 ++
 6 files changed, 64 insertions(+), 19 deletions(-)


base-commit: e81f7c908e1664233974b9f20beead78cde6343a
-- 
2.52.0.457.g6b5491de43-goog


