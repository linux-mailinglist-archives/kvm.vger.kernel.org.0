Return-Path: <kvm+bounces-56511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C28B3EBF1
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E44277ABF28
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528423064B6;
	Mon,  1 Sep 2025 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DjKJ9hEq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FE13064A0
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742998; cv=none; b=Qf0z+TIBisYCzeNrB7EwtE2V5LiV+feGoPrlV2povLejdCh7fTVJwRdLJO3I1arYDONY5MnTmgCt3Ji5DTiX0RFEc9siZAf8mytDGtNhrig9dUInyOHOj2D47sttYVr2GJO37LhwyoFK4VmKxdj5DOcMAlXfDmUIoBMgMRK0evM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742998; c=relaxed/simple;
	bh=Q3PKDbHD38isJx3I8Ber0baejrO6TVXVWQsXQu3Gx6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNK4t14OFIG5K2UBqZMIP0qnlFjvDlwFnxEn5ZbPGVoh4RI095dYWWN9Evrc8rhVw3wCWlNz2SFgQ63s9gjXjw9TJ2e3ZMqYXTb1LyKBzYkvKkCD+MAd32Fuw/wFyRkrO11lN0I29kAx4aGBAkmMPBn4vmoXkX4gLvZveVclpKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DjKJ9hEq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756742995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iUjmNo6Stszk1jMfX7esmLkjaDgZtcc668a9zyeu+wg=;
	b=DjKJ9hEqqFfmMBgopEiKdgEeuORC7FNgNWmJGi3fClL3hiqYbO4Rx8dGbYLd2M5PBzIK6l
	Hl9cR6wfLvbfIXINHAG6jDz7BxMxDaNCGt2p2brYI7CUplJyaC3Ts/JxOg/G5iGgDxt4cz
	iq5YZoP9eeG6rZlhJOKWTGYTRJffNl4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-f9kaKRk0NpSlUWbAsYMOTQ-1; Mon, 01 Sep 2025 12:09:54 -0400
X-MC-Unique: f9kaKRk0NpSlUWbAsYMOTQ-1
X-Mimecast-MFC-AGG-ID: f9kaKRk0NpSlUWbAsYMOTQ_1756742994
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b30cb3c705so10246001cf.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742994; x=1757347794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUjmNo6Stszk1jMfX7esmLkjaDgZtcc668a9zyeu+wg=;
        b=fw4M/F9pv1/w8HuScz/BbjdN+cJdxFB9FlUSAwABB5ze20g7mSIs8Ba7qs1j4/WxgD
         CUwpSo2Qdb7OYNAHGNU1ztUYsg7a+uEOtsubmf8t8MxDewgjaN8T9LUEEe8fFw0CyRed
         ZD8VCNy3hjLSGvqnjR4L3+P9BKe9tQeVJZj0vuJzK1WWw/tofFGhe3SRMecSh+jNVUDV
         TtErYc/pWSyPad+lYcOmPaFrvcioPkEt0tA34/TdYWS9B47QWCX18DJlczBj7rWMDiB4
         zTkPskbg65z0mdGVTj8K5A2iXVMRm09aS9qnqG/fjkCjmDv3EqWyB6LM+qwdHKcuH3kk
         Bo6g==
X-Forwarded-Encrypted: i=1; AJvYcCXBWfVGExce0OL4QyH6oxC2SUXM10aYT7NGvCkFHP4uaMcHIZlg6IQbK4Qnx6ffDyJV6Xg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJP0sNsE8M6uwBBTPF83OFyNM0ufzOc8BQ0fDa6lguXEsl6yFB
	Y6bb3bDkuIEUo1Smp83UC3pqEhMY42+iqrTQdfQEk0n0jWDnzjq3jKUGnr4ZHOf5/1suvK1VZ5Z
	VYGCj4yrji/AjAvGYiQDYfXaZfsi9OxuHmS428G26hpzzenikgApLcA==
X-Gm-Gg: ASbGncs7S0IsJ95NxyU15xlJxxF/I7iVCE/FTELtkSuDz1/gnkcYETWh+OoX+ZMSGPr
	Oir8zkbFd4MNF6OEarNom0FuZPSNhCtN7+qq6eI7OZnvcQc4EE4qNXkmvhhi2yO23Y5Mii8RVah
	sWv8hnewPdpjWmuyQI+v3KL8CwXE2fRn9OcuLwr1HZJ0tfBkhrhLEeDHjmFQbSqPzeago9cVPq9
	3LogJkEXb2bqy7Pj0/UVWX9cFOmeOb/BhRN8nvFUw9FfjLDIjHkgmhspVnGW/QRVYBWbk8cJUY6
	7sbdqXn6ZtJznjdxgYmcM2END5cgYUBbTcJKGTo/p67mFBtiXXPAbq/8o9sROzxxouGzhoLogIi
	qSisGmnNtik6whwF2rO4UyDverUnPtx9czrJs7OiLyHsMx0fsbXIthJ9Sg4uW9rovE+0O
X-Received: by 2002:a05:622a:2cb:b0:4b3:d28:c96 with SMTP id d75a77b69052e-4b31d7f062emr105567711cf.13.1756742994144;
        Mon, 01 Sep 2025 09:09:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0H+Me2WNr8OP1G6r+ikLDYpI0KnL49DOiTcekuqb2wap6IvnGdRHVwSMHQzA8c3JlD+sHkA==
X-Received: by 2002:a05:622a:2cb:b0:4b3:d28:c96 with SMTP id d75a77b69052e-4b31d7f062emr105567311cf.13.1756742993721;
        Mon, 01 Sep 2025 09:09:53 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7fc1643ac5esm681629485a.68.2025.09.01.09.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:09:53 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com,
	x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	kai.huang@intel.com,
	seanjc@google.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX partial write erratum
Date: Mon,  1 Sep 2025 18:09:27 +0200
Message-ID: <20250901160930.1785244-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901160930.1785244-1-pbonzini@redhat.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

Some early TDX-capable platforms have an erratum: A kernel partial
write (a write transaction of less than cacheline lands at memory
controller) to TDX private memory poisons that memory, and a subsequent
read triggers a machine check.

On those platforms, the old kernel must reset TDX private memory before
jumping to the new kernel, otherwise the new kernel may see unexpected
machine check.  Currently the kernel doesn't track which page is a TDX
private page.  For simplicity just fail kexec/kdump for those platforms.

Leverage the existing machine_kexec_prepare() to fail kexec/kdump by
adding the check of the presence of the TDX erratum (which is only
checked for if the kernel is built with TDX host support).  This rejects
kexec/kdump when the kernel is loading the kexec/kdump kernel image.

The alternative is to reject kexec/kdump when the kernel is jumping to
the new kernel.  But for kexec this requires adding a new check (e.g.,
arch_kexec_allowed()) in the common code to fail kernel_kexec() at early
stage.  Kdump (crash_kexec()) needs similar check, but it's hard to
justify because crash_kexec() is not supposed to abort.

It's feasible to further relax this limitation, i.e., only fail kexec
when TDX is actually enabled by the kernel.  But this is still a half
measure compared to resetting TDX private memory so just do the simplest
thing for now.

The impact to userspace is the users will get an error when loading the
kexec/kdump kernel image:

  kexec_load failed: Operation not supported

This might be confusing to the users, thus also print the reason in the
dmesg:

  [..] kexec: Not allowed on platform with tdx_pw_mce bug.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 34c303a92eaf..201137b98fb8 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -347,6 +347,22 @@ int machine_kexec_prepare(struct kimage *image)
 	unsigned long reloc_end = (unsigned long)__relocate_kernel_end;
 	int result;
 
+	/*
+	 * Some early TDX-capable platforms have an erratum.  A kernel
+	 * partial write (a write transaction of less than cacheline
+	 * lands at memory controller) to TDX private memory poisons that
+	 * memory, and a subsequent read triggers a machine check.
+	 *
+	 * On those platforms the old kernel must reset TDX private
+	 * memory before jumping to the new kernel otherwise the new
+	 * kernel may see unexpected machine check.  For simplicity
+	 * just fail kexec/kdump on those platforms.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) {
+		pr_info_once("Not allowed on platform with tdx_pw_mce bug\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* Setup the identity mapped 64bit page table */
 	result = init_pgtable(image, __pa(control_page));
 	if (result)
-- 
2.51.0


