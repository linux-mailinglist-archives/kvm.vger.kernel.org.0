Return-Path: <kvm+bounces-56513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12543B3EBF4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3CFE1888A86
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6FF2EC0AB;
	Mon,  1 Sep 2025 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hw9QPeFy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8873B2EC0A3
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756743008; cv=none; b=LP8lfea8Gi/GVHqWwTY7ZuwughngmoQyhcHc//wDY+aLpLdx0QhyRHax08dL0mbHssAAtt9dOpDv9/DOh9kZkM1ySoLB7YRPF+DFCIctleKzZB8alyqNU+XxoWAWUMH+WO9gwGukTcYJP5zJ9xq5QH/qy5fhRHBjvMCNhFF+VC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756743008; c=relaxed/simple;
	bh=j6vAFM4b+QjRpby8SIZgqTZ2iRbpFgSXYQUKj1TwaXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVxLiV2sGwvUIouWSMvBJ6a6btB99fN3l23zVwZLOdAO6C22yaDY6h+aQjK7xStrmbzpUXauMenfdnP8F0VlN32jSo/O8FS0eLqsfQjLk39fFUf6HDKeMWBFnC7jIZhiwSqg04tAl+9PGC2P6/QvEJqo+xnmTX91+IAsVrscB0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hw9QPeFy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756743005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dtdq00SxSPn8DNlbTBMbLDu8kopEQRB52XTmsM+6vew=;
	b=hw9QPeFyM9EIbrE9UuB94GS3pgeX0akm/NwDlPtsmhHtWUPtXZ2SvH4y/wdQ34g2iy57JR
	MMKS60wteysO7HldUiJue27Zch1t1dxA5OoXhxILXEkHX/sXa8mvMy9aj6CQ7gHAZ7uuP6
	EZJkDxV10PI9VCfP+CZDUN1PH9DHGME=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-EUTtLZixMTiG2vL0A2R4vw-1; Mon, 01 Sep 2025 12:10:04 -0400
X-MC-Unique: EUTtLZixMTiG2vL0A2R4vw-1
X-Mimecast-MFC-AGG-ID: EUTtLZixMTiG2vL0A2R4vw_1756743004
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-70ddbb81696so79564216d6.1
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756743004; x=1757347804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dtdq00SxSPn8DNlbTBMbLDu8kopEQRB52XTmsM+6vew=;
        b=rdKP0x+zuL9VvKvU3Pb2MT30EtsrcLwOOShbHwKSp0YAHHN1XuysbWuraThyI5CPU0
         aB3/zrE7RQPFDZ/RyIE4Bx0w/qLRYZmKYtTzf7vdIcNd+GsORVKcU0lX26l0J3TQAwpC
         GWtYiVz4hYxoCJsbPWtNUGvBRn4QaQWsw9ps+QDrseATiJPzc48H4itGypTBWKmn29+f
         svkVYIVuamiRi8lMGppqzSKLlVGfNCG6fvA1V3hhf46ogWKv+St/J+dM8eHeoplZOUje
         5kPn1yZVHB1AETvYZftO/Fpl5DeWoMtbxNParXcZeFug/G6wq6zRCW6U8YVEtNwU82hk
         tKlw==
X-Forwarded-Encrypted: i=1; AJvYcCV9XKHFNNGdtluoSX7SO6mq3Zj0lYUvrTz6VY/TxyRokfMNxB/NjLVkCY/lnxXIjNvO31s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOQ6s6QTNLocp4L0hCWCC21tEWLKSk01Mh5YyNlY5Rt0hT1G2h
	rbxJmhjYJGAKwFkSfDpRJI2op6hnUey/NbkBcVpYw4Qge5z1U3hnslUWQY7tB+lcyNLCTaoKdJM
	GHy7JM4J56Cdae6vU/3ibI4xAKnqs45xy4yakjGLO+aPJRpukrsowpg==
X-Gm-Gg: ASbGncufocUI3DQxV8XBm2NxpLgua60Eps1QTH37a9Zcog9OH7MRDwwBqBg9lEIP4Fg
	/U6X+/P64gbLdyejkMKJOmd7tHxn9f8rhp8e6n6tPzD1RSBDpS4VLt9kS4ueLRZ6/+mmmnYEf/5
	9EwfX6umAwEEN9RP9mWqdRIOcg0YOTMiHxOheVbU6Z5K1ydL2avdzboVTlkiULm0FzPQ4lvHHhi
	kYPI714uZyv/JYA5u8XntoNfeaLHlcx5B5wyxy/YzA2elLvS8T+fazR2aOrusCnuNFoW+rT9U4j
	WYS9MaZ1kO1vmm7wN8B1U8L0Q0JA4BaPbIHru1xIyvarP/eTNkas/m/qFmTLGEERNWUoBBPyrwt
	IuZlyxDh20whJBmCplVHS7owRsqPL/rJ/5Zn4QK6EKxnkQVhwE9Oa6JIxvEidsKiFNfOD
X-Received: by 2002:ad4:55f0:0:b0:70f:abbb:609a with SMTP id 6a1803df08f44-70fabbb65f3mr84998616d6.19.1756743003492;
        Mon, 01 Sep 2025 09:10:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5ZhmrDjiVHmX4k410H1KEfDTJpsrmWdSsgPge/0tAl2l7w6yZq46ZoMj1qfypUN8EaSKecw==
X-Received: by 2002:ad4:55f0:0:b0:70f:abbb:609a with SMTP id 6a1803df08f44-70fabbb65f3mr84997956d6.19.1756743002916;
        Mon, 01 Sep 2025 09:10:02 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70fb2837f9esm41837066d6.48.2025.09.01.09.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:10:02 -0700 (PDT)
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
Subject: [PATCH 6/7] x86/virt/tdx: Update the kexec section in the TDX documentation
Date: Mon,  1 Sep 2025 18:09:29 +0200
Message-ID: <20250901160930.1785244-7-pbonzini@redhat.com>
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

TDX host kernel now supports kexec/kdump.  Update the documentation to
reflect that.

Opportunistically, remove the parentheses in "Kexec()" and move this
section under the "Erratum" section because the updated "Kexec" section
now refers to that erratum.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/arch/x86/tdx.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 719043cd8b46..61670e7df2f7 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -142,13 +142,6 @@ but depends on the BIOS to behave correctly.
 Note TDX works with CPU logical online/offline, thus the kernel still
 allows to offline logical CPU and online it again.
 
-Kexec()
-~~~~~~~
-
-TDX host support currently lacks the ability to handle kexec.  For
-simplicity only one of them can be enabled in the Kconfig.  This will be
-fixed in the future.
-
 Erratum
 ~~~~~~~
 
@@ -171,6 +164,13 @@ If the platform has such erratum, the kernel prints additional message in
 machine check handler to tell user the machine check may be caused by
 kernel bug on TDX private memory.
 
+Kexec
+~~~~~~~
+
+Currently kexec doesn't work on the TDX platforms with the aforementioned
+erratum.  It fails when loading the kexec kernel image.  Otherwise it
+works normally.
+
 Interaction vs S3 and deeper states
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.51.0


