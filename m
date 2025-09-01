Return-Path: <kvm+bounces-56507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD7AB3EBE9
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A56671886C6F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8ED02E6CCC;
	Mon,  1 Sep 2025 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FyZYrmra"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E9713E02A
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742979; cv=none; b=DRsxiZ9Yz4d7GqQTOsZX5bM3gahVJfE+IkC1+Eh80VUDoGH+YXrynCnQKFeY68xPH+ErOrQ6+Sslpo1mbmCIbnOBjAeB/OnUc4OLoINe1iXOaX71a8KLilHNPYbc9cYf8aHPPUZVqXwiIVKr97VywmzKNdRTF+gaJmIxPPfzDZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742979; c=relaxed/simple;
	bh=zuH01+UpwPD6uQfjMhilATGk1akMpM0cfutCtijrf20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UywQIf/CI0qLJPxAWVQic9eA0e4iYOwpO7HQmrACFa0CAGHk5LhtxXPVTb5Pz+Fx0v4kkAstLHahDJf3dnBpfDPccvBYpe2bDGMrptTuBQotKxdLOMsb+OD4P6B4rj1DstkEMsYmZbwVO1cljBnvMP1AjrKulpIYkJpo0lKCR/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FyZYrmra; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756742977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qUxQDVOQO7QvM97v0jkL71CCIdvm08KWkYVR9FcGA/c=;
	b=FyZYrmraQL9y4cV9glz20Gv2EllLBubBt7yqOYTw8XUejiCUenUu5qJXJ/eGX9VLCjEP/M
	AvQQpW9MDXoOv6mEYW+yXuuOLpSSfNC6Xyj8QM3TcU5qKUyQVVlaB6MieCU18gih8daxO6
	1fMxp/Irrf5lr+pPkTcWvdOvYFwL2TQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-60HE_AMXMMaBvuQ2PDn82Q-1; Mon, 01 Sep 2025 12:09:36 -0400
X-MC-Unique: 60HE_AMXMMaBvuQ2PDn82Q-1
X-Mimecast-MFC-AGG-ID: 60HE_AMXMMaBvuQ2PDn82Q_1756742975
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-70dfd87a763so46598266d6.2
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742975; x=1757347775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qUxQDVOQO7QvM97v0jkL71CCIdvm08KWkYVR9FcGA/c=;
        b=EfrxrIxfZptk1jEsIThSUPI8D5LUA0wi3+E6AOWESqHuJd9b6rGrqG9hiCMuLM146m
         AViDzzk7+ZkPEFHr5Ba3ZxqGwcEdGVcN6cm1bNyuenw924ACAqWzQS9x0N0lskBa4Was
         N7hnoRCI1GyLP7SAjLkczhqKScFpPfNHYKAzlNPzidP5x+VWdO4IeueccFIcaJc5D3JT
         hXLkevVS7a+XPtdIzytJ3tume9d16JxzKhOubb6nyP7/8hB9Fgggt8XMo2KfQE+Y+QqL
         GInOOxfEttopZ0oKANpIa8Nyv39Hv8SrcudIHoCibTehyN6cr8XLo3fLHWdgFCgWmI7S
         dqdA==
X-Forwarded-Encrypted: i=1; AJvYcCXEXhDQXykfpkkjU1javtfeDdSJyi2s/KWWMKDv7IrTb6XYXuBowhAACnJzB9Dj2Q6x1Us=@vger.kernel.org
X-Gm-Message-State: AOJu0YzprskFaR2bxQEiGuUS5V/PsgqFBNUsRHY4fKWMPnEMTokd0KEl
	duMVPTjCQkwQQMeJE85UMf8E2Ts+r6VVi7z7fHOn0NmhaqvBzMaver0NpqPXOnkdhw9y4ZDBodz
	cdkbKWRvLY8gEmIBCLtxuYvVAnQglBm6aKbtfbUygixXcNvpSoDrxFQ==
X-Gm-Gg: ASbGncuWSWa12N9say0wx4ZJgxvDHnaMcI0f7QJPCycO6JtLvZYCILpWdtbGlEqGLui
	BuvUIBxYRrZeVOAwJLTwN3kMQdcMMSY2E17tuA0hxYE+BXyUSEpGW/JgIJ8iF0qYUU/f5WltLix
	tQ4eNKhPnmdohV9UB4g/asgpWsaOdL8yawl/TJcEwT43oj1lahbTJVXgZsYqoWh0yjrlxJIEBGV
	SOp5Oj2Be26/CRB6x8WEEOvng6fVHddd74lZ6L+lTB1K9XociHqVDepe+siiaEfWPgOIwXN3mO9
	oP4gHJVXDGBW7fZhKYTHE2lRIcGUxiFfwYuQepngS7uQhiCMrHRUgmWvLUGvAku5vgOAlWDKP3U
	llWgBJobo57WhNBZnOoIdMgTCL+qgHE6q+uZrqA+pnhQRcXK7HJyNonquQWXAKJq2Xpth
X-Received: by 2002:ad4:5746:0:b0:70d:b541:8084 with SMTP id 6a1803df08f44-70fac89260bmr97925746d6.34.1756742975413;
        Mon, 01 Sep 2025 09:09:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI1Ixvv9KmfyodssHHyS8ameq0QtvIfGvGQZk2Ge7kf/hycu1G7Hr2lBrFcKsR5VeRyQhoZw==
X-Received: by 2002:ad4:5746:0:b0:70d:b541:8084 with SMTP id 6a1803df08f44-70fac89260bmr97925146d6.34.1756742974841;
        Mon, 01 Sep 2025 09:09:34 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70fb26484eesm41516466d6.33.2025.09.01.09.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:09:34 -0700 (PDT)
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
Subject: [PATCH v8 0/7] TDX host: kexec/kdump support
Date: Mon,  1 Sep 2025 18:09:23 +0200
Message-ID: <20250901160930.1785244-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently kexec() support and TDX host are muturally exclusive in the
Kconfig.  This series adds the TDX host kexec support so that they can
be both enabled in Kconfig.

With this series, the user can kexec (including crash kdump) to the new
kernel at any time regardless of whether TDX has been enabled in the
first kernel.  One limitation is if the first kernel has ever enabled
TDX, for now the second kernel cannot use TDX.  This is the future work
in my TODO list.

This series should go in through the tip tree.

Thanks,

Paolo

v7->v8: stub out the new code when kexec is not enabled in the kernel.
	Of course even the smallest code change is subject to bikeshedding,
	and I chose my preferred color for the bikeshed.  But it's pastel
	green and I'm sure you'll agree that it's beautiful.


Kai Huang (7):
  x86/kexec: Consolidate relocate_kernel() function parameters
  x86/sme: Use percpu boolean to control WBINVD during kexec
  x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
  x86/kexec: Disable kexec/kdump on platforms with TDX partial write
    erratum
  x86/virt/tdx: Remove the !KEXEC_CORE dependency
  x86/virt/tdx: Update the kexec section in the TDX documentation
  KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs

 Documentation/arch/x86/tdx.rst       | 14 ++++-----
 arch/x86/Kconfig                     |  1 -
 arch/x86/include/asm/kexec.h         | 12 ++++++--
 arch/x86/include/asm/processor.h     |  2 ++
 arch/x86/include/asm/tdx.h           | 31 +++++++++++++++++++-
 arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 44 ++++++++++++++++++++++------
 arch/x86/kernel/process.c            | 24 +++++++--------
 arch/x86/kernel/relocate_kernel_64.S | 36 +++++++++++++++--------
 arch/x86/kvm/vmx/tdx.c               | 10 +++++++
 arch/x86/virt/vmx/tdx/tdx.c          | 23 +++++++++++++--
 11 files changed, 167 insertions(+), 47 deletions(-)

-- 
2.51.0


