Return-Path: <kvm+bounces-60770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9B4BF9586
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 981A64FE7B3
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DF32F3C1F;
	Tue, 21 Oct 2025 23:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5w6B0ZJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B47D2E88AB
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090436; cv=none; b=a2B3/a5QoknASO3Qm4YxFBvWXcI0/WmwdWYdYtbpFktrf/I/DFnO6TQt73tUJjMYW80QeAW8kjmi8D8DRzjw+R7H9mylfW1DyQB//4+q/uK6NDlDfJMG4yD7fcoqD3xwOzLrzr07MSvRnStXJ9JDvLRuaDW5l/Egt9B0QjOn48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090436; c=relaxed/simple;
	bh=sFmiWiqcfg8xXVngUspNtrgGk8pAsdPv+UUIRplZPLI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=INTVS5XFyFThbak3fuyHbpORMgu91oYnVnzSER7H/6Z1rVBwnGQJ7BbblYuypaF7+p9qNztojeg8uHXMudptiHTp3DIK0kf138nwGW1SSDD6zm2Qx7asbBWtyyRtPBBc1OY3ik46dehgRVaQTlCYkjfhDLy4l/3V0E15E8tu16Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5w6B0ZJ; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77f343231fcso4277901b3a.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090430; x=1761695230; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Lx0Vsy3+YgWmRX9GABJkmBtAr8R5JRasWccNZRzMeM=;
        b=V5w6B0ZJQCwTfCtO7I91J2tvyL/SZY+dKcKM/ZSTCGmXFn+uZS3Zgy9/vw/BmVhkJw
         Fo7qWb/fhwFDmXhHgWiEH6lTicnillbZmtMOG24ahvMSpaaZ+V0FMB2ob3F9X3W5MXvg
         eU6SdHEC32W7j0DyAIPbXGZ2gdnKRn4EonlVaavHMJ0a7rx30dEPOaeKw1wXVmx6unVW
         kyApOWzSE4uEG4ObG6H0kk5ooKvjCeo0o5fvKb+KxPSCkNFoKrjYLJwiVfDBA6QqaZ3A
         kts6xEGkq1UHN0AL7BQEw7x6L7ZKkpPnsQz0KIQaee9Rf1Oi3lyUg5c+I4mwnnR+Xn6R
         CDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090430; x=1761695230;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Lx0Vsy3+YgWmRX9GABJkmBtAr8R5JRasWccNZRzMeM=;
        b=wpLVx/OVakhLVhFMVzksiI+AMmzvxAgYV+1Q8V2RoV9eP/ELZMJD3HsgOoAX8tXXS8
         aH+Up7A84H+pDQ79uBBuvLSGy6WddnGSjWN1u1vZuBB0NpQfRLYurQCsAaa9Ei6AlbvG
         vTtFL9s3P0ljb5wfyUW/vgNpbgaToMQY5jbQw5+aIqLyS1DxwWhsTFvaIHQ9ThmgHDIv
         upq2fvek2TOlbIBCy5gc8BmhpSJ7lqCvqnqZmi9Rdcx8rHdlTBrVXbIVqt4BPrGVAbq+
         M+qdjmVF6BUa2+orHljQmgTmThO1liwE4bM/jf509W5hgy10eMKGSzgjmW1j90jlGage
         DIzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQT24p0vDVYMfjp0HFR+0+cS6za29BHgYtHL7Y8PlVBFta3FYd8C7r/6k0YCoiIIwTqCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW9PCrqW5nX/oSu21QJFcdLejXe5UDQ53aTFooiGyyZmWm/9o0
	jPwgLH0bes+pIbvQmMem/MgHb72QR/50vX64ESIswtnpBbSEtvv2ZDlb
X-Gm-Gg: ASbGncuH3W+n99LOfxHStc2TwhYOjTs5OXylGClZmug4CfYuTbEdTzizmfOCoMZU32d
	45quE7JUt6DNn/a5F4Z6fw3Yv3zQX8ZD9q1Ya4DoDxPjxUBlEo0ZHvmcu7aSDBbTXBri1cQekKh
	Z6hTLDEhkYCD9at0BUIEBy0mrfIg4H65IHRe4Uirlonx1p9U5Ak4GP0piqEVS2wuKZvxRKIKR4H
	XCPtnpa4S9TFu7LyPe7g/q5lY7QgujupkZkucmkJRbRYn+UzSzbAHK+mgWwrESrbfT4haOqQxfr
	bilq/hx1QGog1ZAvrsrKkfxyftnV0U/6QZIBHdMblyFtM2D9b5lD8mzm8Ubxe55Uh0yJ6GGDESl
	0Kf/BqIbg5q11M3yvZIyh+M9umoJ50g/gVvSl+/FFeBydUKFffxzZKUpyPF1UxZpirvnelIQ2j3
	qrlqj2Zlkn7jX4SnMGb+c=
X-Google-Smtp-Source: AGHT+IHBIC1WFg0H2qiLSSMrqYIuCevWaKcWLpJLUcG8eiGjix0DgQfBr2qDeIJoI8W1LO6p9Cikzw==
X-Received: by 2002:a05:6a00:130e:b0:77e:8130:fda with SMTP id d2e1a72fcca58-7a220aa090dmr21331246b3a.13.1761090430385;
        Tue, 21 Oct 2025 16:47:10 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1599dsm12619953b3a.4.2025.10.21.16.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:10 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:46:55 -0700
Subject: [PATCH net-next v7 12/26] selftests/vsock: do not unconditionally
 die if qemu fails
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-12-0661b7b6f081@meta.com>
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

If QEMU fails to boot, then set the returncode (via timeout) instead of
unconditionally dying. This is in preparation for tests that expect QEMU
to fail to boot. In that case, we just want to know if the boot failed
or not so we can test the pass/fail criteria, and continue executing the
next test.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 9958b3250520..d53dd25f5b48 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -221,10 +221,8 @@ vm_start() {
 		--append "${KERNEL_CMDLINE}" \
 		--rw  &> ${logfile} &
 
-	if ! timeout ${WAIT_TOTAL} \
-		bash -c 'while [[ ! -s '"${pidfile}"' ]]; do sleep 1; done; exit 0'; then
-		die "failed to boot VM"
-	fi
+	timeout "${WAIT_TOTAL}" \
+		bash -c 'while [[ ! -s '"${pidfile}"' ]]; do sleep 1; done; exit 0'
 }
 
 vm_wait_for_ssh() {

-- 
2.47.3


