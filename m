Return-Path: <kvm+bounces-64846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 391CDC8D3B5
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3635F4E6D9F
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B9232AAB9;
	Thu, 27 Nov 2025 07:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1bzQGbi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCFC324B31
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229677; cv=none; b=NpFTjQ+VLSqYJQVGgz7T9srluI6zMrQJSCpXTSe7xOODJFcWc/VyeuiUJoWguGWwpT4w4R+UF+F5DbIn2/zusrVfFhiqe6r/5cM9zQYEeNsYQexYPd+63ZmFSmkk15/+E6TaxPwLWyfr9LhI4rahud3Sj1XPAO6UiELel71Eb1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229677; c=relaxed/simple;
	bh=czzpcNHjlEeOECy7L6VEuIsFXHYOopcrm3f9fwHEjh0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F9A0c3T5Aqq3dr6EpDr0/+SNhpR3o5F8eTc16k3jTrIrNGzwXlxNH5aavorocI5QXNft9dHf8BWmdOOruNtLCksvFygQrifZyso5kb9kHUFniTSRsKc03cWZodoEgIxuYKPQrgTmmICIEjudLnloNAI/TdZMtBaYxNaRyGn16R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O1bzQGbi; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b9387df58cso949277b3a.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764229670; x=1764834470; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQ4JZaUoTsMQYrL+kuRb36qxz+zHEzB26FSI/H3YBMA=;
        b=O1bzQGbiuiHCoQa7aBJcBJ+b7+e+Lsreenxf60zxvObi/ttUxG0Z6G+5yEKYtMFt/Y
         dnijsJgbkDnoQ1Y3FyKHHfnXlSio2eZCvE3raBKTeAqUKHGOAdzMqACjDkVTCoePXK07
         hj3QRqFXBjjo1BC83lzbpP7opxa56zdCYtN9AWlRaZIyKojORO8s3GTwK4cmuqjIexqy
         KTwsGtWgGbXx3OVBpY9FdkRQzE4E1I7xi4jzM4FGIsk6++eLTBzVdFtkks4iP0ZdT0+d
         GIJDoGsKKOw3wly83lWWZ1tZTaD82SOY1OrLiZk+iNw+ZbO3zCtffL7jb9DiS6bHjPo3
         HZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764229670; x=1764834470;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NQ4JZaUoTsMQYrL+kuRb36qxz+zHEzB26FSI/H3YBMA=;
        b=TIJpEk3nmjy0X9XWc8z+1INvh5avOUUz9hJ3sM1G8aOzjCbWZ5D9vYlcqLj1DUH+d7
         wUjSWgtYKdF6AyPhOFhO0QF2V9e7qfpLJucgDEr93CHStU672p8Kl5SZZxjxyS9hh26m
         ncx69qzXsID7c6oZ/KAHUg/0J16jV20wJv4rho/Klm4s43Xz+7TkjQYJlhtVsJWwuzer
         Bc3f1wEVpyNVPG6pUG9EbWLIp59BHzBLfTA0lBrDxPoalaB5TqZoLuOFYnDI/jfZ8GnL
         U+rKCuzjs3DjduKuehJxWvaqwGU6Z0vEe2j/gVol8HWor1o1SDR8z/jHzoSGn+9M3dx7
         TBwg==
X-Forwarded-Encrypted: i=1; AJvYcCUbROH7eUvurdUT3uca0eeHFcVHndl1xyCz804ntKYBLYtJqxejGFZ36TzGGxE1aibmcMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwME+8zE999eCPKWek7cdghJWhiqIxArQ/HN+sjiHen9AY0/RlN
	rfHfqq7m9C51fMmRTuu8dIwh0fn3KEUcIXEkrJFgArnP7+/3s3Dp4B8n
X-Gm-Gg: ASbGnctrl3r71o3dfPqP/oAKT4zs/XMWbyteDYqZBrNdI0tIFgjYT9J5KSTKCVOc3nU
	OJgqPfCyoV4wK53QS8x2Vnsk773RHD88heQWNbGBluDd19D6SgMhoqv3r69sdLQK+sqLpTw7QLK
	pfuH32ow9bKq0YUCCB35Pwh5eryFjfM2y3GxJ/b3FF4Ptv+KoBbW/N7IZ+xzKUuqHOyqwEMe4pf
	mR6znihAvJ/aiqB0jLpYvGVUj/bsyX6xdhoAXuxGx1aNUBO+AmFJPmyKuxhl5nPyc1FpqCQz64S
	GGaDQlPkRzWAuNWSUzVNUF226uVXcw+km+zkNZGJs25QrMptp69SCSjd2YtlZR4AlWwbImOZ5Np
	whts7fVSWH099QzBOULruQVNjuwfWMQWa/pLmFI3hJqotuWFULpXToN6qWBkRWOZjNJINhEet4l
	ErB7DoEsCXi+TIuvbTdZ1B
X-Google-Smtp-Source: AGHT+IG/QkipgDC5/9P1526ujkoBXHGm/apxd0sZKMmlL+0mQ3lVcIPyxsJBx47IADm7h5JzGsdVRA==
X-Received: by 2002:a05:6a00:2d0c:b0:7af:19bc:ca71 with SMTP id d2e1a72fcca58-7ca8975f7c1mr11555824b3a.19.1764229669761;
        Wed, 26 Nov 2025 23:47:49 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:70::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e6e6df9sm918997b3a.39.2025.11.26.23.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 23:47:49 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 26 Nov 2025 23:47:36 -0800
Subject: [PATCH net-next v12 07/12] selftests/vsock: add
 vm_dmesg_{warn,oops}_count() helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-vsock-vmtest-v12-7-257ee21cd5de@meta.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
In-Reply-To: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
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


