Return-Path: <kvm+bounces-42277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70521A770CF
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 00:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03DFD168300
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBDC21CA05;
	Mon, 31 Mar 2025 22:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WK1Lu5TX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980651DE4F1
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 22:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743459539; cv=none; b=jpqE+MHHIlPP3poe3OGzlnIg6ndpdb0GJEqE6hZEZ6Nd5/7kUkMOQ5pCJ/3tdXpBf+C76DWGuULMkLfmCtE+ggmXLEYcbyOik6lX26Cx7SluFOmveuQrKT/bRndiBJIx56jkClBhP5bUkTNJGsaTmHltK6qWrJVxhAvbnQjmKYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743459539; c=relaxed/simple;
	bh=Sq/lHqzKBJX9vUWqQixxyY+Nvpc95yRL5aiI8/D7+Js=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YhX2bP3OOPo/SOlL/+obgDoS6YBKTDIi2Hhqzsmv8xCuVlr/ue9AD0B25lDEG+TEHyrSFn3KGFbzRFQFPZld06LUFiY/rl3cXfEdrDtsdDAq5XmzfqOd22h0MZNzcfL8qWLuO+wCfkGSHDUqEKAWlTTGQNn4pOiYBVTO1fYLsE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WK1Lu5TX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743459536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iITEQ8m/+1n7Y9VKquwua3X7ZRDPpcptdjSbJeo6HRE=;
	b=WK1Lu5TXScKp6s3PMQBbdy+SHhhQUiuAuQOYhH/rUyZlW+eBlG1lzmDQj1M0RK/RLdaHVK
	h/x1eowIEw/z/GuQvEYJdRrexm8yeFTrGi65fjM6CkEtLZii697GeydlD5l6tKIy8lv3SS
	6ViJAIba7kCcgIQWXMMVH/Cpogln7MQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-IFkg5vSxPlmCUkNFuAgVuw-1; Mon, 31 Mar 2025 18:18:54 -0400
X-MC-Unique: IFkg5vSxPlmCUkNFuAgVuw-1
X-Mimecast-MFC-AGG-ID: IFkg5vSxPlmCUkNFuAgVuw_1743459533
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912d5f6689so2920682f8f.1
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 15:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743459533; x=1744064333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iITEQ8m/+1n7Y9VKquwua3X7ZRDPpcptdjSbJeo6HRE=;
        b=doIRPiu09s/YfWZJHPRxk4dt0DBGSl7c4qrA58f+cCVYTuqLIljF8ZvdRqluB4HgP6
         dKAG3VvL/R0QXYi+v4jt0+u4Fae9Cig65EClAsGbeB9Lz2PWzti+mCy9F7S5H1N8STCm
         OnzC3ZGoDJ6YNxS0995P3/jOTxK0OM9tVBOyHtiW0TFcIeguToFTWutDg8OvgTjNSY2O
         h5l4G8tX4BcfsX3yqOLz/2AX3T/OkAlbOIsXLi64cUBY78YPR2xBDJNuoW1uXioaUZvH
         FRHZMjAXXMStf3KioQ343z309wAmcdoeqxdfltoQvnzgViU+k/KaO6sUwYLQdXIQ1Do8
         QsLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjBVz2y5yJ7+i9I6yx8xORd1AINOl5Xj4EJvipTUKdlgNksu3Y+2RNZJKPckWqJFyb8VI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA6tZ/DJHrLXuQ9SxOai3o0CcZdiRPdlZc5cU9Nzh4dbuD4QoM
	TQzMF53ukvIUpCnAZkXoSaTcWoc/ZnvAsgdFboPlG0iqOIyr3Tn8IWGyQZBctrPePIphsYBCIfj
	V5J3Bu2YDYf3xkfbu25krJW/4s4Gr+QWj4yk59vQ+kSJ9UoTU0Q==
X-Gm-Gg: ASbGncur9XyFc6SAKfEourX/WYWeFGCeyILnHg+cDUJ2OGQ5FB0hUAoJ4E87su+d0MZ
	/642YF9RkreQEWkL41OndmYf/gcuqUaTlRqDDAUhid4QNPXqQlIeHMwrUIKNCYgg+iLjfiis6Rn
	7gR9Efe3UHm9cs8rMq+lcvp4GR72YeA4YxZLBNyEOudwGRTXbP99ZJKSVZyhqLwnqhe7Zpx7Xsr
	A3T0p3qNP1C+JiN+0GYMiCeitRi7QXV3f+IAMMSg9Ri0YdWy03nzOVL4+E60IridQuEgACPVSYE
	Wg3oiatQM93GvEftrg==
X-Received: by 2002:a05:6000:2a2:b0:39b:fa24:94f5 with SMTP id ffacd0b85a97d-39c120cb51bmr7032566f8f.7.1743459532899;
        Mon, 31 Mar 2025 15:18:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4S+/d4JTKy4IJo7qK99V5Xegqrsg28QeJcnUzqDCSkq1U4wV6u8m5ArteNUmEheoqOhZPEA==
X-Received: by 2002:a05:6000:2a2:b0:39b:fa24:94f5 with SMTP id ffacd0b85a97d-39c120cb51bmr7032555f8f.7.1743459532546;
        Mon, 31 Mar 2025 15:18:52 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.105.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0ddeecc9sm11183248f8f.83.2025.03.31.15.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 15:18:52 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] selftests: kvm: bring list of exit reasons up to date
Date: Tue,  1 Apr 2025 00:18:51 +0200
Message-ID: <20250331221851.614582-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 279ad8946040..815bc45dd8dc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2019,9 +2019,8 @@ static struct exit_reason {
 	KVM_EXIT_STRING(RISCV_SBI),
 	KVM_EXIT_STRING(RISCV_CSR),
 	KVM_EXIT_STRING(NOTIFY),
-#ifdef KVM_EXIT_MEMORY_NOT_PRESENT
-	KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
-#endif
+	KVM_EXIT_STRING(LOONGARCH_IOCSR),
+	KVM_EXIT_STRING(MEMORY_FAULT),
 };
 
 /*
-- 
2.49.0


