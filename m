Return-Path: <kvm+bounces-68402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 618F1D388B4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40E3D30EC9E9
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DF93A63FE;
	Fri, 16 Jan 2026 21:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTngvH+a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5297F312830
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 21:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768598954; cv=none; b=dHC/u9izXDNKZ8dg19hQsdkOVkFgphgXfbwjIR39Wqequ0ZVv7E8WLytEOc0Zv3qCAtbdNsOINpMG7XqTfBzV0UwOcG6hZspXWa56Xhokx2s7abwOHUq0GhThnkhFwwcL5MMN0j8j7x45wbYMB7SV7gKV13SOGT2FWk2OuzgEWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768598954; c=relaxed/simple;
	bh=uCgr9JbNpxUqM9gbGsf2Jmk4aJqJ6fTLHuKaFTvudAQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qF5HugybZo4hYUDw7hQJkkL/s762bgc6/UTWUlQcisuU0HJdTSsnibS4xSY8vm4sNA71xjFajRwB7wJW8w2mT5rvmO3rE3ZuPnfRZkliPJzYfKlBtbTKZDxXzuom97yvX0oeWjcg2wfSzsdgrFfpkFO4K3PQVra2Qa2ESna98FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QTngvH+a; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6468f0d5b1cso2182550d50.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768598949; x=1769203749; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UqzpQf1IlJwSFAKiovBpo5/3/EPxdibd9liBmZD9wA=;
        b=QTngvH+aHSlgpc6sbkMxQQXQgVjpHfvo8/ybabtKjpTSprv3GfeKKJBTALE6RgtdDg
         RswwtkZl+IAqTCdFrDCPHorrsMHWw0aGSIuwfImh/UGEDyme9oneRL6kbIwX9Efx4xYB
         mSieuSGsc5RLrst1Mabf/Ewlk7C2Dqx2NlbGcdszebK3DDxj6a+r+epSXdjJn0nDPKzT
         LlHE6x72Cg7y9/xaxwXYp/AuW6SFdnS4tBfDYGej85+UwalYdyDNm/lmAXapIFWbnshx
         Zf+/2YilCh3DnjHITvjH31s0Dihvq+0QcEtewyuuNiLeDx3Zqzetfk728lYJ+zB4Ell/
         0pBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768598949; x=1769203749;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9UqzpQf1IlJwSFAKiovBpo5/3/EPxdibd9liBmZD9wA=;
        b=Gi9Nbt6xj85mBm0+YrwJW2JIozVUWw382Z1rO9bdEoOHeyXZawB6L/4q6+9bdlIQqv
         5pezZhylh0xDTGLdGFVl92YOTLoSAqpKeKKtMIKzVCcbGjNhCVkiCPbPJ9/lGKZXcDf0
         z7ZcKU0imbRmJAXBWftg9R81pfA3QfQTzTNQy+iS2Tm+li4KkvIA4HcTqmoKLaXyfvKJ
         2UBniy+0X+3hQES7ap2LdN6fgOJYQHUEReLFe/Pepo74L80zth8sTCex1hhsVm/ifiap
         Cb7HVYzGkRPMP7rxu/JIXgjOAo8gWhC3phjT1gcfuD59a6ADNC+MinAFXXv29/hft0vh
         cSAg==
X-Forwarded-Encrypted: i=1; AJvYcCWnFYQR/pmhVLWYHqnL4Jy//1UcGeLzAyffibN4UU9oiq0AqFec+EAndLioQFtpe8iYfhk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEhT3ZOS9LI+uvJ910R4fFe+MDK6Lrk4EnZm2HSxspM1iglqw5
	+ezppXNlUBDitQ/n5KHS4TjfoxpQ42Xbz93S7IFL6j1XQiwfhcz23YLOV1u6oQ==
X-Gm-Gg: AY/fxX567qnvS1GQYQipYJM/vGIGSzTr7Vw8a78xOLwYIXThojy4X41Itp2C7LeQznc
	cKjkStW9TmGmhq+tMZ1v/uCcY0hRK7p0UShlAnX2xjEfAE0j0YMIl4Biaz4iPTBOWpYI4AnHb2R
	jjzR2O4NZbRcNSe+Zn34Yigh/bMwYRc/1kyzSdcokSiJNyhkkt3612P8UqNYeFkApotoCoGYwOb
	dUkRWs21scMqiuIu514mHhjXWbFq7imr4vHsCJT/1cOJgClcvAj3UnbFBOwLzzlkIIYoq5Z9ICT
	csYQ2pXroQmQ+VTpuba9kX2BemDREeB3t5J89nTNdRQKdpQeSzgENqiUzvkp7ozNQ75XgSZw7lD
	D0D5TdWbhvaN3hKDVF2auPguy4V12Fd9/TotK8ik6Pqf3cO6GowVWCyxadHm81Ex4fa7Nr9F1f+
	fwuntD/xpP
X-Received: by 2002:a05:690e:d8d:b0:644:60d9:8667 with SMTP id 956f58d0204a3-64917773d86mr2650287d50.88.1768598948802;
        Fri, 16 Jan 2026 13:29:08 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649170d2f04sm1663457d50.22.2026.01.16.13.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 13:29:08 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Fri, 16 Jan 2026 13:28:47 -0800
Subject: [PATCH net-next v15 07/12] selftests/vsock: add
 vm_dmesg_{warn,oops}_count() helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-vsock-vmtest-v15-7-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
In-Reply-To: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, 
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


