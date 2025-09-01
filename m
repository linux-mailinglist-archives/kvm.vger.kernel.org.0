Return-Path: <kvm+bounces-56512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FD2B3EBF2
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F681A81B5F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71A02EC09D;
	Mon,  1 Sep 2025 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BxIwDur/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6744A3064B3
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756743002; cv=none; b=hL2SWucn7/Ta430D2CI/q1OKfUs69tomHdhFGQzoy1NsptKpJZddpmCfsFsjX1szd7bKaOrxAWAFLFaANRSTijA32Yq5T8uITDXVqYr1CnfNEi0gBksJZCaqyIHnVHJHhE9JQWFfuKLTk9xloSjI8yQybbBcB50qvagZ+0i6OOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756743002; c=relaxed/simple;
	bh=JGm5CCLptQwOuSwtvIdC2c2wUIwgPDkpfBMNALrs+Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rcd87CBwjvpUuZK4Pyxk3cuxv3N3wRG9vzK9x02Xz0Yp8/zjejLtqqtLHWX1CkWTL21ATfSKI/MbCOnG8bWgo4WzrUx57vH85gJDxF8qNIDEzYCGMAz83MJQ2K+oQSOvxT5w2YZhHV8FBgt5RsLW6X4H07+8T4Mmb2uRWhQ7IG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BxIwDur/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756743000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BK4OUWj9KISSOnqHrSCdtAWi7t1NEdnZ5iAAINpO6Ag=;
	b=BxIwDur/WQTFp/aGfErLzzWsI0J8NXZkxodkOvacd3LAtTymfSFudXeHiXVQJDMxLHftkn
	Qdv7h2d1Ti/HKCxh99sdxPb2J6YKRGt6lzUlK4DE2RAOVSMaKCKm9SOY5kZZ48jaC6AaSQ
	Zn9sWBl7qaHWEdGjfaDNLt8UWLBl/EU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-H5fUYv7HP7-LErhIc0jQ0w-1; Mon, 01 Sep 2025 12:09:59 -0400
X-MC-Unique: H5fUYv7HP7-LErhIc0jQ0w-1
X-Mimecast-MFC-AGG-ID: H5fUYv7HP7-LErhIc0jQ0w_1756742999
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e870614b86so1366459485a.2
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742999; x=1757347799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BK4OUWj9KISSOnqHrSCdtAWi7t1NEdnZ5iAAINpO6Ag=;
        b=gmjtebEWujmk/ZcR6t8nc5JThSK/i6XEvTkVtYjwhcxd41QPzifn0TQNUsuNS3J05Y
         Gb13o1ZvixZhZSu61amINDbBRas/+Df0ullB73bIwVa+a36DhNaHPZ7zBXkm8IYgXEpq
         o5Pbw4JFc3AVXIEaS+RlkKuyjtJ9Z4I69r9x5Os0Hi/03cZvSn3p1xmXjJ+gZDywWqtl
         s48zngUfIF2EHs/GlSuS+2O/XejJtaDJyAeqjJlFL6+pFMx07RA02uSRDQN1sP+Vy0H+
         nCBDbXX3t+UYit1wlN5zipmj5+SorO3qt8HtD2ZeR7MfvkLlC5OAx84TIo4sRFIrbzY2
         Gh3A==
X-Forwarded-Encrypted: i=1; AJvYcCWHhcXiJzDoIjb6HM8EEmtQCZbkk9CGa2qMhOS0GEB56/8K0jJE+uTSGgoi5OQIRIDxT7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIi/BCgWE8Wc5m+QqW7S+phBfAwIOAVUY5IczhVhBmDUCqB7Hv
	dNETd1VNjjlFjDureiqaEkOQzKG1qbFXABRxGWAuKMm7WWAm3NYbEiaBjha5zDaVTXOaBjBe3w3
	+foOP6N4XhCkg28Vc+ji3qFZEzJph7FrRKOXi8WWqW86mhBjUJCvKOw==
X-Gm-Gg: ASbGnctJ9VzjsCdo1xspwXnZUD1PGGBPnlGN9g6g/jzrAgAup+Tf9VDTPV6WEx+8LJU
	WB1RQXO5xNMKQ4zqFqYALuTQdy5gAwmGCtT/udEyy76mztFGMJ/XKiPDdmJaPxXYUoLLYpdpJzJ
	vLzVzsJz4A0cYLMAmPTmZwvmYprzbcPYU8Ew84TBTg2zhBcwWJHQZdLRKqFLniP/rBNArbo8/5j
	LdJng+UpZCfbp1JsR+wmC7E0bJWcT9PpM8/FsRuQN/0X7K+MvjXBETUt9Ra0EjG2ZOJfP1KMLjD
	/vWCNyaVz2aOUvm7B1ynRaMCP5JTaahmondWEUXEY7aWWvbxoopduJf6JvaeHX05t6c/o9VhNDO
	7+QlDLyA1++jU6GjZ60fq1qjOBMY6+5cqNijwuidJbwcalACzJJJ5fAyha//1k1axfvNV
X-Received: by 2002:a05:620a:44ca:b0:7f0:b17:cb6a with SMTP id af79cd13be357-7ff2b5a761emr961316285a.57.1756742998715;
        Mon, 01 Sep 2025 09:09:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWFuIM6z/6h3ooA05y4N+Coc7uXzQ+I+d1s24RIzvqtIGoYRX2aMLPreLhFfFBviPAkLZ8sA==
X-Received: by 2002:a05:620a:44ca:b0:7f0:b17:cb6a with SMTP id af79cd13be357-7ff2b5a761emr961312285a.57.1756742998331;
        Mon, 01 Sep 2025 09:09:58 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b30b54cc37sm61618191cf.12.2025.09.01.09.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:09:57 -0700 (PDT)
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
	farrah.chen@intel.com
Subject: [PATCH 5/7] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Date: Mon,  1 Sep 2025 18:09:28 +0200
Message-ID: <20250901160930.1785244-6-pbonzini@redhat.com>
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

During kexec it is now guaranteed that all dirty cachelines of TDX
private memory are flushed before jumping to the new kernel.  The TDX
private memory from the old kernel will remain as TDX private memory in
the new kernel, but it is OK because kernel read/write to TDX private
memory will never cause machine check, except on the platforms with the
TDX partial write erratum, which has already been handled.

It is safe to allow kexec to work together with TDX now.  Remove the
!KEXEC_CORE dependency.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 348a193a3ede..217982814bd7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1895,7 +1895,6 @@ config INTEL_TDX_HOST
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
 	depends on CONTIG_ALLOC
-	depends on !KEXEC_CORE
 	depends on X86_MCE
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
-- 
2.51.0


