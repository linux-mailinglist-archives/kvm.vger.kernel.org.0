Return-Path: <kvm+bounces-25735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FE0969DF3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC4AD1C2306C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 12:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF031D0940;
	Tue,  3 Sep 2024 12:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ep74w+/n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF4B1DA0E5
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 12:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725367338; cv=none; b=JGGZ5Zt63Z2KJX7WqArc3EQ98X1A5Cr2LqJ9q+ohhCrsL8bjst04Lkng6yDrMMLmrD3/XJdZIkqNhqEV56keKAcs3L1EkwUCdtG3mY+G7eHp8J4k9no8LURQVSyn49dhmylf/oNoAhgmda+EhGxHN5rF4VbsYUumgPFcGiRgs1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725367338; c=relaxed/simple;
	bh=mw8V5ABVal6H/51A8SV/WT9wsnRiZv8L22RniTuFJIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPwhpAxdq4sjL+WcVRyKDvqEFUi9KyzkP0EqvifsN0QzeVzk/uWRSYb0HHmmM0aS8NYeDNwuVdKS1xH1j8FCG2lIpHsWhSnEgc7Zt1FN58FLLvNMAlGFA/PsCUmOoty4fiBy8VOZfOHqt5lJgYxt1cmVwo7/mmoBvpW1ixDc4WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ep74w+/n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725367335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QrIEiVhLJ9bUrmnEnLksh9UeyYXSB1B5dyjmrN1LcAo=;
	b=Ep74w+/ncHP9+mYmjT4oJhbfEg7687yYEz1Ya9sA9qoYS0YD4XJS0vAsD1JUugmMCOlIns
	Pa1hZYKnayNsRMvCr5jP3bD6hsIcryspKnUG2I3Z4bKE3O8Z6CecmLxcPimdlefxZT8U2Y
	LJMn/QXQJ4ezjw8P2mZYjUhzvrhK6TM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-xR2mzhz7OsOK-jnYWhVKiQ-1; Tue, 03 Sep 2024 08:42:14 -0400
X-MC-Unique: xR2mzhz7OsOK-jnYWhVKiQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-7d1fe1dd173so4184995a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 05:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725367333; x=1725972133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrIEiVhLJ9bUrmnEnLksh9UeyYXSB1B5dyjmrN1LcAo=;
        b=Q5BVzud1xlq+IPb9+y4Xn7ZyjvNmR9NSahXAkO+hwKQwehAoJwWwLfHhhYOeX1fnxi
         OcR0XNdgWXUgz7sHIKf4v+83iqJidcN96YZ9x3zgHLpwvHCRnE0UdRBl4qP8HshLblC7
         gik9VcASbI3OGJojiSGKi7eeymXsIMwlSqpuwTQMdMfPUNlM+jbJFpBrs+lFfDPGZwYi
         KLGUWwzFWdomqlNA/or7SBoxlfNUc6TxIpU7sG2oKeHLgkuxWxoc/SX2mnilm/0okMJ1
         ZbZwaflLqldDaM/KUV2vOQ/veSnGIMHh3byXHnSHDsqvVRCSWYxnsrJ+mprQUJ7j2v9y
         uanw==
X-Forwarded-Encrypted: i=1; AJvYcCWdJqyZgLyie5unbOYye5SZMVw/NwB8MnFvcfrmH7N8oiymtESvSOojtnHhmExBtZFwnOE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIwUFrddMeTVGv14xRt4S1pvA3JvwiconQpVKwC/r/u5tbZ+Z5
	wfiqg3QuHFB1rpSo60GL8cIkqnR9Kls1TY69dWzEyA7IRzbwUs6VSLKFyLo4IdtMxnq6qExyWjR
	TpXxaGtd9qtpiaTZTXahIsmq1SzHyIFNc04TVJ0qizensKHL1oA==
X-Received: by 2002:a17:902:e5c3:b0:205:951b:5636 with SMTP id d9443c01a7336-205951b590fmr39929255ad.47.1725367333556;
        Tue, 03 Sep 2024 05:42:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeUiEaFLE5xXFPPRXAqOYMGgp5Lxxy1rmWivLg51XXli2/ChgQ0liP3LPA9T2uchXW0oL+Jw==
X-Received: by 2002:a17:902:e5c3:b0:205:951b:5636 with SMTP id d9443c01a7336-205951b590fmr39929065ad.47.1725367333140;
        Tue, 03 Sep 2024 05:42:13 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20515542350sm80222025ad.213.2024.09.03.05.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 05:42:12 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH 2/2] kvm/i386: do not initialize identity_base variable
Date: Tue,  3 Sep 2024 18:11:43 +0530
Message-ID: <20240903124143.39345-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240903124143.39345-1-anisinha@redhat.com>
References: <20240903124143.39345-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

identity_base variable is first initialzied to address 0xfffbc000 and then
kvm_vm_set_identity_map_addr() overrides this value to address 0xfeffc000.
The initial address to which the variable was initialized was never used. Clean
it up.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 574c62c21a..c8face0eeb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3187,7 +3187,7 @@ static void kvm_vm_enable_energy_msrs(KVMState *s)
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
-    uint64_t identity_base = 0xfffbc000;
+    uint64_t identity_base;
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
-- 
2.42.0


