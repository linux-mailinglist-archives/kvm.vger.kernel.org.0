Return-Path: <kvm+bounces-42638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CC7A7BACD
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF676189E749
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED43C1E1DFE;
	Fri,  4 Apr 2025 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvY6SDnu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD61DF994
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762579; cv=none; b=Bu0Ful979K1EfIrDWGjv5w/z8grr/H7D78coPHVkAHyxMEaEedInXdCQAjfoLe5NLzdWpkgSoOMzUgI5bwsm+99bHE015PVpK3i09SssDUb0imFwIrKgmQrBB9f5OUlwSHy6k7OPBgt5P45YOI0a7PGJejbxuKQcmaZiMncRj6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762579; c=relaxed/simple;
	bh=5+rhWJ9/AaOnxl4/edvsj3Mhq/NPswu21jjxt69P2kM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwiLWzpbae2X7nwxBQeTU3qZzlKhe5W0d/25EYLMbNlWCflmTqAUZDdiBnvE6GjOKF7lLSVbyOWE0H0fV7gq+MJq9DlWHVuieZvp2gDUVKTpQJ4HXCgR0rQsgeogAcAaTVFqYYwBfVYUlK5t+2VBqaBzce5RLqPSpeIX4I5BBa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvY6SDnu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iIj6VBKjZOnFTh+4vM6JPksjZGxz/JfbdG4ThPXJ5PM=;
	b=IvY6SDnuSFXt7su3mg3DKmyWLo6F7h3xR4gjtCFfevLyNgSAqUGtu9/5bKZPMcs3RG5gdF
	9FLrpBzwxb62+EPQLzTSbJJJLOflaENBPoKePRR6i5Y4OkM2olQa7RlngX0QyB9QnBVPWP
	zs2BZr2HZtYn82PSy0Bp01b7oYHutBM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-5_7Vtur6OpWo78WGkjQEKw-1; Fri, 04 Apr 2025 06:29:35 -0400
X-MC-Unique: 5_7Vtur6OpWo78WGkjQEKw-1
X-Mimecast-MFC-AGG-ID: 5_7Vtur6OpWo78WGkjQEKw_1743762574
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ac737973c9bso151018466b.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762573; x=1744367373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIj6VBKjZOnFTh+4vM6JPksjZGxz/JfbdG4ThPXJ5PM=;
        b=haR2V5ea37JOjRtmsVKnpdRwOw4G73IF++gp5RS3OZL3ZpgwD2WzRwYKHE3atwKQBL
         rstHegcAi4pULjch9hxTv9qDAYU7t3l1RHQ17stniAYuMp+yJUMXyFYf7WfaLZJzuT3x
         1FWVW7fst6Dc+6m9B3ovv+bbAfzatRCbQ0txKyQacY7nj+f2E6aeN8oTdSXhHJUJHdT4
         0+b0Mnmav5B8x40fG4Zcx2dRrhOA+EACgM4mxa6oQLGE8c8yPJ9tADvTqcLgBZ0tCqBh
         95zGvWYGBJsHpI2Vs3d+j8IdGzgC9lSSfYrtoSA9U1iLmHr2FoqDPURPxybCNYPxWP7p
         pBMg==
X-Forwarded-Encrypted: i=1; AJvYcCWWEXbciZ6ZS/qBWeFJOSlbW+OHmagU6MyylJ/TGOv/bVckNRrbinUJKc39o10FkIoa03Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRWxfHc1s7V0GrZbE8WeGjiOEp/lFrdbddE+2ZdyxlZemiHVm0
	6pMe8Zdh7v7Oo3VWkIqcEZXac3Y2DF6lRxJ5BnAj6VmIM4lQx/knsgNRUyNOB2rmzEXtbrjDZde
	rhcgT4vD/gr0etLY5DutdSNemxW7xj/KXV3l4Ej3ZUM6tUaTQ5BNT6ArHnQ==
X-Gm-Gg: ASbGncugMieAPgAT4lhhGwW4/qp50o5EyLKxQXztKv2cd72QhCxskaVafUKb03+xmHB
	d4EEfnFnWlyz/mhylEf3wyJhC/ylZf27OHl1ngKrQlVnPoPKmvrEZj6ByvRPhm4Y0Jp5+9XoZ2+
	T914N4vsV2NVr+peYR6Jb5ov7l1kY5mbYKtNnVmM6PgKufGBlnLj7TDKfzi71/7TyZl89ZuTEoY
	u6KKlGCESPAnRx3ZjvRrmSUhH0xhQd/ueW52rCE18wDs/RjHrKICfT0cVdNjrNwqeauZc8k00Go
	C/WtMJ3WVGkb8sHt+Ij0
X-Received: by 2002:a17:907:980f:b0:ac7:391b:e685 with SMTP id a640c23a62f3a-ac7d19fe8b9mr265179566b.59.1743762573237;
        Fri, 04 Apr 2025 03:29:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxQWmbdXNbO0s0OLq5wavir8e/NorfNubB6SFVZLkKltTIV61PUBG1neVaqpwJooF4AHCdPA==
X-Received: by 2002:a17:907:980f:b0:ac7:391b:e685 with SMTP id a640c23a62f3a-ac7d19fe8b9mr265177866b.59.1743762572908;
        Fri, 04 Apr 2025 03:29:32 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.230.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184d0dsm227635666b.130.2025.04.04.03.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:29:32 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 5/5] Documentation: kvm: remove KVM_CAP_MIPS_TE
Date: Fri,  4 Apr 2025 12:29:19 +0200
Message-ID: <20250404102919.171952-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404102919.171952-1-pbonzini@redhat.com>
References: <20250404102919.171952-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trap and emulate virtualization is not available anymore for MIPS.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 469b64d229a6..2a63a244e87a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8578,20 +8578,6 @@ may be incompatible with the MIPS VZ ASE.
     virtualization, including standard guest virtual memory segments.
 ==  ==========================================================================
 
-8.6 KVM_CAP_MIPS_TE
--------------------
-
-:Architectures: mips
-
-This capability, if KVM_CHECK_EXTENSION on the main kvm handle indicates that
-it is available, means that the trap & emulate implementation is available to
-run guest code in user mode, even if KVM_CAP_MIPS_VZ indicates that hardware
-assisted virtualisation is also available. KVM_VM_MIPS_TE (0) must be passed
-to KVM_CREATE_VM to create a VM which utilises it.
-
-If KVM_CHECK_EXTENSION on a kvm VM handle indicates that this capability is
-available, it means that the VM is using trap & emulate.
-
 8.7 KVM_CAP_MIPS_64BIT
 ----------------------
 
-- 
2.49.0


