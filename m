Return-Path: <kvm+bounces-60776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA65BF960A
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 934BE460C99
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AFE2FC871;
	Tue, 21 Oct 2025 23:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acBU5El1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE582F12CD
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090442; cv=none; b=T7x0OT617tGP6iLHhq1pjvwd9Uhy3GABiGQFpUXV2bxhQ6F2k/vp24lbWp/pd1wI87fy4cfbSPR6abAyw9cJIxAdCXVVU3c6zicp5ejJO+xKy1RIa2HopbUL8u/yZbKuT12Gw2RM0YFd4RFFSNHECWq42IOcnBuJOWTqvWK7dXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090442; c=relaxed/simple;
	bh=Vq3JxLDexMAZpBZBOMz7RcnedkE0owAELSAnlUsmBpE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oa+LqLGtdVfG1RBl9NHRJD0VE5gz/MXts4rRLVIuvYaPetRlvUtE5VhCZxVHctypjFOkCD8YpubyiyeXkdKFQBQ/BZQxv1fd9iv/8MYPq8zMTvC3rZ1nMTOCojP7Rh2zeSTqyoO6ZXyf/v0nqzexGzxc5Inh+icQRd096hAQPSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=acBU5El1; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-290b48e09a7so74386245ad.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090437; x=1761695237; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ziglltQonD40PF3NaoQP9RaIb5nYxZqEFCDNXD/J6U=;
        b=acBU5El1XUnF5ahrQ6RY667sgPxLgA4ZdJwjIRnfSKapdKibrM29eTmpmAJGeNqGam
         Vcpo5EVSM/PpE88hHnTPEhkCDnqRwI4cGqC5L+itv6PdAMBrIWmxYm6c3+oEBeygAmy6
         fu5bI3vqAMWu3xJuEIO0Rhb3GHPzv9pf+BzPM1LR40a9FHLJsf75hxbid5OouU2WBszC
         1uLIzC2hXnfIslq5jjHwcFSVb2CGnHOC6lJ6DmmhpmukPvJhLqyOQ/Ki5YffYmkwXBwl
         IVfJNKxJtnLyzFbeScTbyoOKiaWotKOmkrnlWFw7QJU8JyZV0addM1hna8phjUUpizMN
         04Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090437; x=1761695237;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ziglltQonD40PF3NaoQP9RaIb5nYxZqEFCDNXD/J6U=;
        b=is2MWmpBv0qFY4eyK2MEpM6lGEwtuxJbG0Hxv7gUDHcqHJSJQAadN3SeeT/pr4T/+X
         Ao6LRyIAiW+P1eSu/v9VKTqLTRPFDUsfNV8a2iWFva+EEFlqfpaZbQhyhfFHBSHBld0B
         8OaEiHLv+DCEF4iLLxPTh6gTbAJf+2DgqlZfDaNsEJ0Ydjwx3Csh5pC4htxLdmuhS9NU
         j0b3QtsiqtwgC0+XnoK7mbuB6XfVzW/arAgS7JpnlinDQKrXMMHdKX9xEcP/N8i+Ch0I
         3jjHA/88HHS4pasScJJ+Z0eQeJZp2eC2IEMdMH/A1OiygdBPg7744MaZaPg8nStwj33b
         dbug==
X-Forwarded-Encrypted: i=1; AJvYcCUYNVVdyjIWc1CCbxIXu6iBBqsmZ2TdUDpeWYooMXPDftMUTbTLs5PhWqYu5sxg1CH8nOE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlutg+WX8PIOz2Yo5sAZXnsgWznK1rWOenQKHl7VRbiFv0+llY
	1om33HO9zXJ+TlV6eKN+YZXnHgUEPU7Yfh+1G1Jg+02bYJUvftRKC/pK
X-Gm-Gg: ASbGncsg80mY0nNI+RWo5hpJ5Dv1Jxc5018ZFcQKvfkYI/CW/+WU2guPKZwsTxHSwf6
	asYSGmlktGPqqLucYtjHqlPSrMRBiZZzKIWhkEVTlTrunETv1ZHzGeVMs+d1bcTm3Ukb1U7yj/O
	Ln/phkKcR2mEaK0Ti5tKyJQTd7+QiiPfxVYuoL7KwN9K4Y52RmYx4wq1zuC6QwoLSWvfFA36j+H
	2digOYVWev+KEcxyTrZoc//DFrPl6lDhF8pim+Xs6L0Cn1SAFUlWaQD/QbckZU7KBHbYAcLFcCq
	XXxVT3cmK+y4ti+eKJb9zxIEwzX2ngw8DeAAnsKbHSBjoruNmnMP6aFGcn+y5dlQ5VvYwVtmY57
	EbW9z5CpxbXcdVs0jVZA96/tQ9j6p32x0cVTJgZsPSh428AGnZW+KSFK3UYz5JkvGAh6c5I3hGT
	nVX1Pnvj8N
X-Google-Smtp-Source: AGHT+IG5dGgoFfjLOrDybopHtR5kmquL2RmRYL/ZwgLqL0f5q8OPShyxosfyQ4g18ky0R7BE1MkTfw==
X-Received: by 2002:a17:902:e84b:b0:290:c0ed:de42 with SMTP id d9443c01a7336-290caf8582emr300060005ad.36.1761090436967;
        Tue, 21 Oct 2025 16:47:16 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fdd10sm120304085ad.83.2025.10.21.16.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:16 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:47:02 -0700
Subject: [PATCH net-next v7 19/26] selftests/vsock: add BUILD=0 definition
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-19-0661b7b6f081@meta.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
In-Reply-To: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add the definition for BUILD and initialize it to zero. This avoids
'bash -u vmtest.sh` from throwing 'unbound variable' when BUILD is not
set to 1 and is later checked for its value.

Fixes: a4a65c6fe08b ("selftests/vsock: add initial vmtest.sh for vsock")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index e8f938419e8e..9afe8177167e 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -626,6 +626,7 @@ run_shared_vm_test() {
 	return "${rc}"
 }
 
+BUILD=0
 QEMU="qemu-system-$(uname -m)"
 
 while getopts :hvsq:b o

-- 
2.47.3


