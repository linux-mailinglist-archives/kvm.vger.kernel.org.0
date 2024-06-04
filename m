Return-Path: <kvm+bounces-18787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B375B8FB58D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CD6F2857C2
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BE813D524;
	Tue,  4 Jun 2024 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2TFai+X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7013813D53C
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717511724; cv=none; b=HF9b8NGlhNyAJdZeKBJWpqurBoaDT1lvWoL8ti33UrezDEMfi+m6x3sAGuHHNPOki6scmGBT20LG/YStbZDH6A21mGovcnAY/y/PR41MhCOLaW6j7DMoME/++Y2PoGoU1TqZvdZoViSQob46dWyHFWRlo+/0wALi63ceawig4iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717511724; c=relaxed/simple;
	bh=M+Far3En9ffB9q0vEGS3X6oDy7ej2whmMhBDouEEmwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jibjq53NPdO3nol84H7PIbC5DIAgrmbxX5Y8nFOW6JhEYkNG4YyBeRFnEm+7wDLcex61z7JWiqHEFLH+aOnA0TpUtfm6UyHD9qoVo/wVSBO87O/0CM/z/rC0Se4zGKNs+WPcnZPB+WB3bhvhncCfnIXbAnAlclwPg3OXZjETGe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2TFai+X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717511722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=apTzG9OiqPebiowESvb8Z+4f/nXx7OQsLDdb81sk704=;
	b=c2TFai+X1+rm7AmmH29kIxOgZpVBsoOW6IiSz64iLJfGyRWeoi6x8+98/IWMCKkbVcpnpQ
	T4AHti/DIlG0yW4BCY0rsEukN0OIlnTxaVdEsCpBjASfcNc+Py7Yq1ldwofpZXXwPMxrAj
	DtLqy2758fuxw7eEH8MXXJ5daZAnchk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-keLgQu5lOeq8NaoMOp6u3g-1; Tue, 04 Jun 2024 10:35:21 -0400
X-MC-Unique: keLgQu5lOeq8NaoMOp6u3g-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52baa7fb26dso44356e87.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 07:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717511718; x=1718116518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=apTzG9OiqPebiowESvb8Z+4f/nXx7OQsLDdb81sk704=;
        b=Hx30lKH04Dbql0xFP4yPq6+9Hco+3mVBzH7NSXHQIW5y3+nY26zmTPzbdnQwa6MKml
         VYcsVPVhB7nWeUl1EvQfmQojxjbTjMWoq1nVk3Q5s5F1kUigbJ5B2ErJlkDgWNjW8xIr
         oTvmAvtot12j+jkxjNYTO1HdCwWI5rZ9vj8Xr0XebPISE5/F1OxyRTgIxNo9/8ERBnSh
         NNbpPpviFkk8UdSaSrLzyHKqL6adl1l3UC3l7EjSnmtReV1uU3DSQduuj6KI/OVJNDtz
         ae+4PfbAoBC/PnR2ovDGgzsZqI49RGg1yudkLbvBBN+AwPtSBEsD8WxBfwA0yfmzlJuS
         rkcA==
X-Gm-Message-State: AOJu0YwakWrwCxjjRfqUXHgVVG+iwsuVrvr0nNZwXYB3DKlqsMy7EXPx
	XdLPwlwHnz9DAFQ1ol+pgxq61clwtxBEheNFSi7y4np3VUSRMOdfjIt02lXGNFOd4aBJQVs7/R4
	q/7jWmSc4iP2KlD+3tRHs+bjFDN6Zy/S1vm1DapJNRJD1kISyvQ/6B8pYM39DwJ9tcc9OuAX/VP
	6DAxjOIvbaJa69Mt0jlueGWkARTIr8tlNS6w==
X-Received: by 2002:a05:6512:3d07:b0:523:2984:7a04 with SMTP id 2adb3069b0e04-52b8958da75mr12579537e87.36.1717511717957;
        Tue, 04 Jun 2024 07:35:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9g8+Gltxya8rB1tD+RWUQV8L9VZJxVSB7R456M9JYk15VfTdaeD3X67jw5R5EHbreAwffgA==
X-Received: by 2002:a05:6512:3d07:b0:523:2984:7a04 with SMTP id 2adb3069b0e04-52b8958da75mr12579513e87.36.1717511717544;
        Tue, 04 Jun 2024 07:35:17 -0700 (PDT)
Received: from [192.168.10.116] ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a85375486sm1026781a12.48.2024.06.04.07.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 07:35:13 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Cc: thuth@redhat.com
Subject: [PATCH kvm-unit-tests] realmode: rebuild when realmode.lds changes
Date: Tue,  4 Jun 2024 16:35:07 +0200
Message-ID: <20240604143507.1041901-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/Makefile.common | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a557..c5dd4970 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -103,9 +103,9 @@ test_cases: $(tests-common) $(tests)
 
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
-$(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
+$(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o $(SRCDIR)/$(TEST_DIR)/realmode.lds
 	$(LD) -m elf_i386 -nostdlib -o $@ \
-	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $(filter %.o, $^)
 
 $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
-- 
2.45.1


