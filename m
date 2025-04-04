Return-Path: <kvm+bounces-42635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A295A7BAC8
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01EB87A873C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BC41D5CE5;
	Fri,  4 Apr 2025 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGeP6yY9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF831B6CEF
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762571; cv=none; b=Hj2qXyQW/od13rMqRKyHShsp7Dzvvviuu/Bykqm7EDHptdZ3XbjCEgW8k7ERjF1G/I79/9Moh+mAukwL6DC5KP73nKcT9TvdKrr8XKoOtBsc1Ed/41617m9SfA60yO9uGTlhU8R/X37lw6R0DbdJTf7iXeaf71R3w/LtMWhZbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762571; c=relaxed/simple;
	bh=wPnxq84hCxnZktHB5n2SHxZDe2iMMhApu5mhJ8fGjr0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvdTf9h01+t4yhIOztOH2q5DizLsBPC2oqgqwJB1DvJIClbcBA+yD6Z7PNkjbySS1tjYr55N1bc7CN6zldhJCHKTDXvfdVCAcaKFruZ8D+/F57M/pU9lDWEy3PVJ8X26Zsmjt4YzBYo2s5gitkLUvteW3gZ3M5+N4ywtTv9XlpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGeP6yY9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxOnUPdlMvuJ8v48pnMnggaUsB9ujf80p/0TOnoHhrk=;
	b=EGeP6yY9g19O+cGlZW/oHtFixl/XbdVG+4j+JlzD/WFj8UxghPbVuMmqIgJ4/pmhxz7sA5
	ZBJ7EtLKaT5IalMPpAlF1LRRjMr6PebssTgx/Gnl/odhASm3b59bBwfPsyIdoMCbNgTBcT
	TauF6mgUbJcGU/x9CHHflN1qFPfRTSs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-TZZ5NGhMPaW8TkxwqIOkTA-1; Fri, 04 Apr 2025 06:29:26 -0400
X-MC-Unique: TZZ5NGhMPaW8TkxwqIOkTA-1
X-Mimecast-MFC-AGG-ID: TZZ5NGhMPaW8TkxwqIOkTA_1743762566
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac2aa3513ccso161410666b.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762565; x=1744367365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxOnUPdlMvuJ8v48pnMnggaUsB9ujf80p/0TOnoHhrk=;
        b=aP2zBvzUdYphFuclN9M5wbOW6nMy/G0tIO4fHUwdCAfNcX1u90BMdO41BnHmNfGKxj
         FMDlnOcYaRDbHLa/7SUV/RLz1AkXHo17RLLGBVs11Eq7nuK3RvEzuxhk5JLAiRttrAlx
         jq3fupubuDVXAq6F+tn7JQ/iKBb2aVlt0+Dkk+EpWTHXhnf77C3oZXX868Hkxk23pYfj
         iIwIMh8M4vZO+XomE6INA9GU4iEizL/NYRpiQqUfQ3N+yecRolEhnajAMUswn90/5Pq7
         uA7RD3jooJ8Oj8/mCzovPFoVewFzevsRFK4CdZM2JHRkHWeSvk3pnCHHw7RhmNTEeyi1
         3Lsw==
X-Forwarded-Encrypted: i=1; AJvYcCUJqNH1htyZsbnOuUaaFXg8dsP2PnFTnRHi44Kr3anrQk5/+anPHL5v2IJhIzMQEdzCjWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpAv4llgVhXRCaVoO1j748a731+IkeKAaFO5X9h2N/4QGIhxgp
	86h+g13WYcdJs0lAFaVxf/ah0Hl5xJKpGbovzPwL4pmTiQ/bLR2FoIhlvYVyisR++bhKkgAg6Z9
	aVMhhdgv/v8OpTOFzEZn3Lf5vhgMOwdw44qU1cpPB/Dw3SFUftaOmfN5l9Q==
X-Gm-Gg: ASbGncsoJvcaIKlwlYWjsq5kQeckLGyMZ6c21tTwEwmpqbnIAj9NjfOOhz4UfXRfqpz
	2bRq9p0CWtMt77HSOq3D30h8IfKkMIxJ2twd4YuZ0W/IEq+ZNTfilXHK9dkLKWTayDNXRovV9kL
	LmbAkWLdTLWebAhe9yXiqTpJYvZ3iDX6Gn5Apbh8ffp2vZ8s2v+CMwKGid2tKVz3SzED4+RNEEe
	XkCAM9vm9N2r/HfwOG1oqpZsoI/wxn6Jmfgr+GOxJdqvJ+V2wJFBqOGGKfBRGWXdXyn9EyCpp0W
	s8uuq0bm58qy5wnIWfW1
X-Received: by 2002:a17:907:9801:b0:ac6:e33a:6a0d with SMTP id a640c23a62f3a-ac7d199c8e5mr253554666b.55.1743762565182;
        Fri, 04 Apr 2025 03:29:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8o0pRabc4+gB4uulEDJjEE2gwOSpzOcpXqcH6CxNlDKuFME6qGnzVcNfndR6IyXcr7RMoSA==
X-Received: by 2002:a17:907:9801:b0:ac6:e33a:6a0d with SMTP id a640c23a62f3a-ac7d199c8e5mr253553166b.55.1743762564788;
        Fri, 04 Apr 2025 03:29:24 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.230.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe5d688sm228256566b.33.2025.04.04.03.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:29:23 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 1/5] Documentation: kvm: give correct name for KVM_CAP_SPAPR_MULTITCE
Date: Fri,  4 Apr 2025 12:29:15 +0200
Message-ID: <20250404102919.171952-2-pbonzini@redhat.com>
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

The capability is incorrectly called KVM_CAP_PPC_MULTITCE in the documentation.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ef894e11727c..49a604154564 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8862,10 +8862,9 @@ clearing the PVCLOCK_TSC_STABLE_BIT flag in Xen pvclock sources. This will be
 done when the KVM_CAP_XEN_HVM ioctl sets the
 KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE flag.
 
-8.31 KVM_CAP_PPC_MULTITCE
--------------------------
+8.31 KVM_CAP_SPAPR_MULTITCE
+---------------------------
 
-:Capability: KVM_CAP_PPC_MULTITCE
 :Architectures: ppc
 :Type: vm
 
-- 
2.49.0


