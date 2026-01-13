Return-Path: <kvm+bounces-67898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 262E6D1672A
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6128E301C544
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2D2324B2A;
	Tue, 13 Jan 2026 03:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8eG1yT0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08490321421
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 03:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273987; cv=none; b=Dt/stP3dlyz8TQ5CSt6GoyAuDoe9ewro92sCeM55U4GCcZf0qPwCSZQbxk2tAzD3Y89U1I4/V+YBEqUR512ADqU7F9KjGm808ofc/nJuxS8Zu7ULzx3f/oj6qqxs089+MfYAqPp7IfogU2C55rsdEBuZbzhV3wfVFXDvi4pn8GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273987; c=relaxed/simple;
	bh=uCgr9JbNpxUqM9gbGsf2Jmk4aJqJ6fTLHuKaFTvudAQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cZh8Wmi13ZpbQAzr4y3Dj43seYJpfg8foNFihVrKIfNCwffTTG25NXAsBouR1KskvkwhpjK4tAWZGAJOd8DGbQk/vrXKpPPT6ot6FvYdr/UT20CkuMwVIzSS3sSWDKja6JVnxKmkq1QsiYENQFA1/btxCsm/y+RcAkyNsBJbXlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8eG1yT0; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6467ac59e16so5022786d50.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768273984; x=1768878784; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UqzpQf1IlJwSFAKiovBpo5/3/EPxdibd9liBmZD9wA=;
        b=j8eG1yT0nvgMdV6L40UkIQMxcZoHNi6trsPgi+4lZMxptZZlBH+Tl85gsb4bedLNdw
         vFS3YVdUQHH6/F84XL2UPjLszh6UWAMNWctB4yGYRVr5aXT3ifVs2Oy5JT5WOjvXQxbV
         jzI91DoAZhXUqoa2QA87kb6Qe6pZ/9LCfgWYhTpo0JzTRrOu6xFyWvrFjm7qKugWTt90
         Qej8e9kG4WdV5FPzv6OCRC+Rx/8WGRmDA8vK5/7+qEWuKRyNQgOfKYKuiP7gP7clkbA2
         Jkfb4uRwTBGfFlWybyxJDhZzeX1APimo2ohTxERbulRG+6oxrT4J6V3bplMCakrLhdna
         pZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768273984; x=1768878784;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9UqzpQf1IlJwSFAKiovBpo5/3/EPxdibd9liBmZD9wA=;
        b=n5dUdDhTFoGvet7h1Zyubt8Wt5ftAdULVXeFC804eljwr4U3w4PMDkzkJEoFgFzhIT
         cJTugfyq8UXlgn8utao6ZKc7LE5ZBxoTRID+/tJ42dWEABM/+s9UyfBxR2xKQbcNTy/o
         PyHH/0IN6hKzdqYCND93NOpSziTFs0EC/SVaYoMPrk71hKy8Qacn/6xVFA5VoexUdbrK
         ni9oIiMyEPg8aG1vOmnwKrw4V6aKezOUkGMWS1JH4rbHk87MeuFsdCSlOJqd/LP5pk+C
         MLsbIbIBX2QFrjlpfgAU8T7oSdqstF8b5bvT6v4zreSTiILsobYCQMf6dcqiDiz272CN
         jBbw==
X-Forwarded-Encrypted: i=1; AJvYcCVjHOsAlbtTsLBdzcX8rCbgqrJvFaPeCa08idMeqqHEd6Pv3sD0Y4SeWiUG+C5eGxHgiXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxCbssJr+5YEO82nWjCUyAGlHfu51Rf/KgibRfy6EDkfhUXzSL
	MMtGcrH7Me+GgN6XyCbGq0jvr32MA3iE5oim0F1Y+KKv+/GziEm/9bgp
X-Gm-Gg: AY/fxX67t4KMVHnOBSbdqQhpLTuQMLuvFS2M8OjW/TIpi4ZapXRaB8HggRaFStq/EL4
	8Ui2Qgltvcz6yOvdmnIvCNB4nou8xJ8LXDVJq6R3OkhxowZTpxWCtAVsVq3Ud5W0lU9yRFIa722
	iiK5bRe4MojgGbv0/1ZxqriYYIjW3taiTYxLCvAgr4C8fzEQHkI8Ggx/0AiXIfqL6tAcnXwD88A
	KGUcMAzYbOILPlGLzjcgnN08l2jkUQfRe5P05u9A0qiqXEFYmhxVKZaSIsuM9mAHkl8o9ZrTz2U
	EJQA/Lb03V/oVLF3dG4r7jhIWvvhub9LXAoRT9vPfnjb306S0q2UUMo+Rph/vE6cECZJs/7w27A
	877QBqztRoKu/7RTeUX0sBVTOa7v1p/b166kg7OkmX3rUTA8E3GmTT03+4jaHJ5xULyEw14z2eM
	AvAWOxg1Ln
X-Google-Smtp-Source: AGHT+IErvHvsN34Y4EeiTfc/QvQN5Cj16XfAwMvouHBrxnnMT8gw+lZ3jiDdXraGFB4o7lMM07JE3w==
X-Received: by 2002:a05:690e:1686:b0:648:f70e:2271 with SMTP id 956f58d0204a3-648f70e3129mr1251005d50.28.1768273983606;
        Mon, 12 Jan 2026 19:13:03 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:9::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7916d0c3f72sm49159977b3.21.2026.01.12.19.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:13:03 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 12 Jan 2026 19:11:16 -0800
Subject: [PATCH net-next v14 07/12] selftests/vsock: add
 vm_dmesg_{warn,oops}_count() helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-vsock-vmtest-v14-7-a5c332db3e2b@meta.com>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
In-Reply-To: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

These functions are reused by the VM tests to collect and compare dmesg
warnings and oops counts. The future VM-specific tests use them heavily.
This patches relies on vm_ssh() already supporting namespaces.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- break these out into an earlier patch so that they can be used
  directly in new patches (instead of causing churn by adding this
  later)
---
 tools/testing/selftests/vsock/vmtest.sh | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 1d03acb62347..4b5929ffc9eb 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -380,6 +380,17 @@ host_wait_for_listener() {
 	fi
 }
 
+vm_dmesg_oops_count() {
+	local ns=$1
+
+	vm_ssh "${ns}" -- dmesg 2>/dev/null | grep -c -i 'Oops'
+}
+
+vm_dmesg_warn_count() {
+	local ns=$1
+
+	vm_ssh "${ns}" -- dmesg --level=warn 2>/dev/null | grep -c -i 'vsock'
+}
 
 vm_vsock_test() {
 	local ns=$1
@@ -587,8 +598,8 @@ run_shared_vm_test() {
 
 	host_oops_cnt_before=$(dmesg | grep -c -i 'Oops')
 	host_warn_cnt_before=$(dmesg --level=warn | grep -c -i 'vsock')
-	vm_oops_cnt_before=$(vm_ssh -- dmesg | grep -c -i 'Oops')
-	vm_warn_cnt_before=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')
+	vm_oops_cnt_before=$(vm_dmesg_oops_count "init_ns")
+	vm_warn_cnt_before=$(vm_dmesg_warn_count "init_ns")
 
 	name=$(echo "${1}" | awk '{ print $1 }')
 	eval test_"${name}"
@@ -606,13 +617,13 @@ run_shared_vm_test() {
 		rc=$KSFT_FAIL
 	fi
 
-	vm_oops_cnt_after=$(vm_ssh -- dmesg | grep -i 'Oops' | wc -l)
+	vm_oops_cnt_after=$(vm_dmesg_oops_count "init_ns")
 	if [[ ${vm_oops_cnt_after} -gt ${vm_oops_cnt_before} ]]; then
 		echo "FAIL: kernel oops detected on vm" | log_host
 		rc=$KSFT_FAIL
 	fi
 
-	vm_warn_cnt_after=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')
+	vm_warn_cnt_after=$(vm_dmesg_warn_count "init_ns")
 	if [[ ${vm_warn_cnt_after} -gt ${vm_warn_cnt_before} ]]; then
 		echo "FAIL: kernel warning detected on vm" | log_host
 		rc=$KSFT_FAIL

-- 
2.47.3


