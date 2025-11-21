Return-Path: <kvm+bounces-64063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4721C77746
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 1E8B82FA4A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB96A304BD6;
	Fri, 21 Nov 2025 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIGiNvYy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD392FD69F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703905; cv=none; b=nxeQpVtFLbbzLMIu2S+eZhN8MRx1oYsVy1LXESeeak4XlEP9NOH9OTrh4dxkkBUcUqTMQAaF4rxhQIr4zU9TWmCkQjSRFC5jiJx3Ci7OBXho954trqSYr6orhOE/SH+kImAguK6nyrq/pfoGTKz3LXLQy8o5BhP+ED9VM5jnLug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703905; c=relaxed/simple;
	bh=nx6UHyycvOx0nOMJPrniexSgcT4f8Lew6DQLvX17eQE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GEm/cuHelRD7tu76JdG8rZiKiz8qarc5ZHjaz5FKyRpbHfbhNgwaq29NrAg8PXb4SZb547JZ1bSbPbtwQJy9HR6ohdZMjXAGcZhfnq7bGzU2sjtHt/R7rENLytj2MVl3XBpx6JTAcPgiBkH0vFdQ/725lV8+mK7vBOiU4+HMCac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIGiNvYy; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1978772b3a.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 21:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703899; x=1764308699; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8WanE8FrhGxigttKl86eZszwf4U+f6tE0kVhiGDUGVY=;
        b=XIGiNvYy65++kSc1B1HqQC6TtCuiv5nxOxbFE3MP1nSN0Rn30KHMSEoG6W+f1pf5fa
         vQWTgyXdxY+RvJeCvEqPXSgtpjN/cb/DvG7ZMDnHiw9+LOaktknE3zrVLKMRZxyc4TGv
         15XuW1+Hjh/yi9t2cj2dqFPCP8IYlUPXZtMG/+1zokdyGyi0obrfvY8aTyX0cDQlKUx3
         FEDnidpQyx98b/LkBBl19spwy36Karcm3JTKxCPoxTHWCtosijdXCHddeSWWdDubBBdQ
         bc8E+oQhbItA3wSe2BmW0fUdaMskfmFzS1DkKOcarxSzD9ITLsqx0nPCmYYy82Kz1BWF
         whvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703899; x=1764308699;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8WanE8FrhGxigttKl86eZszwf4U+f6tE0kVhiGDUGVY=;
        b=R310cSAVzptGudYimhNMvo51o6RuhBMzPc0KYz2IOYbD+8ihYNz1wYERtqzemaDTKV
         PvZepI7tRDp2J958Sxj9DgI7otHKhe9FUsKlEgXxlNq7W3XVGYA7+exVoITgkpxIL8kV
         OpH872Q7jk6fOsetYBzgc3VyWti+x/9jk4TrveMStN2XheailVwzjsJhIgixawRjk3oI
         FiNZP01hLNhUMCqvCodC5RdXjijrC5v/Oysa28u0jKaP9bXlIabsnjG9KwCBej+DxoVM
         q7NVclk3NVfiF15wy4NoC7yoVIOCGAWww8kuNs5EGxZT3YFp6sfC4N6u+B6WVApF+vWP
         EIng==
X-Forwarded-Encrypted: i=1; AJvYcCXJgK9ZliMGEmvWOjqrAiU66v2lTEEm0RxsZAY01ChXKHvp0tRrVk/WmRbnKISoYfpK5cs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdOJ40K8zvKBB33omfTqPLAkSjqi9ts7LC9r70w7aihfm6IFO+
	vVdbcI3gNfQSOn+WBFiVOcOsIDu8BCR6+hnRZ5Tzr+CI08+3vKWidEp8
X-Gm-Gg: ASbGncsq8wk9rfpbQ/53NVVek+nkLKQMVwWsKfb2RRgafpLD1EThb2ZFKiKsIpVyqpO
	cbVG9k+XK+wh939j8K39CGfovs+yt8nx3DQVIO2ABD4M9uDEMj/gpEQFTn7USmEp5hi4cMPX8aB
	0nwgNd5aZZv7JuobULkhOlSdSJ/5dZKRCVcsvP9q7ddt7N2ULV4o8zdit2wmzlaiWIyjaoHCR0l
	5R0ZXgrP+JGyP8RhOLfdCToiAA4F9vxQkeptuu7CADDS+H1HYJcV9MVqCLtF8BrjCdVovqlP45R
	iBqKFXXsUec+pnvk6nHFhT/XzG/CU5xERG0eqEIxWDQDYq8d23PeeZp2DpOFLgOumFwOgWJRHGF
	mdk+tO0toO5NuG4fD537ebxH2pTsG6lQhINeTuR3GCCq5rgPVJXxeHUj3j7yhtS4JY6uiwn4L8p
	rG4+HwKCGwQS6igVH+wi7Ss0uoAqwQHnw=
X-Google-Smtp-Source: AGHT+IHqyE0w19zDPkaB/Ash2VMSaGraMj87gNleVuj/tN2LhZMjdzS2nkC0fyQfEaBt2i2bVW/KCA==
X-Received: by 2002:a05:6a00:1ad2:b0:7a2:7237:79ff with SMTP id d2e1a72fcca58-7c58c4a4fe3mr1123886b3a.7.1763703898643;
        Thu, 20 Nov 2025 21:44:58 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:42::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0b63dbcsm4627465b3a.50.2025.11.20.21.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:44:58 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 20 Nov 2025 21:44:40 -0800
Subject: [PATCH net-next v11 08/13] selftests/vsock: add
 vm_dmesg_{warn,oops}_count() helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251120-vsock-vmtest-v11-8-55cbc80249a7@meta.com>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
In-Reply-To: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
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
 Shuah Khan <shuah@kernel.org>
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
index 4da91828a6a0..1623e4da15e2 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -389,6 +389,17 @@ host_wait_for_listener() {
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
@@ -596,8 +607,8 @@ run_shared_vm_test() {
 
 	host_oops_cnt_before=$(dmesg | grep -c -i 'Oops')
 	host_warn_cnt_before=$(dmesg --level=warn | grep -c -i 'vsock')
-	vm_oops_cnt_before=$(vm_ssh -- dmesg | grep -c -i 'Oops')
-	vm_warn_cnt_before=$(vm_ssh -- dmesg --level=warn | grep -c -i 'vsock')
+	vm_oops_cnt_before=$(vm_dmesg_oops_count "init_ns")
+	vm_warn_cnt_before=$(vm_dmesg_warn_count "init_ns")
 
 	name=$(echo "${1}" | awk '{ print $1 }')
 	eval test_"${name}"
@@ -615,13 +626,13 @@ run_shared_vm_test() {
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


