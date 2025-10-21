Return-Path: <kvm+bounces-60778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A23EBF9625
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AD6119C2664
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFA72F656C;
	Tue, 21 Oct 2025 23:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvLpxZ/o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FF12E7BA5
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090444; cv=none; b=Xo8W/F81WyPkpaMMPxr77r/Owgl24Pa4I5+QnciX+UeKACsnZ4KvdopGFGAYmna0WEOX8RnUtZ1g89nFtToUabBJNJ7k4XsYj0YzgYJoD0DfC3F80m1Hh6v8pzNbmufJSQFRYA+T5mVfa1BA+/6fYVJ+J61KO+zhcEigRTlhKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090444; c=relaxed/simple;
	bh=8bOFcVzDZsUwxKg5ikgK5NJUIukOBjSEIefCk8ZnB5E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jA6wWW61QpfAhFVPC4mOen+9h3mhgyEt0m9i5F9Q+ngKqTtAQJ0x8FECgeF1wwX/Cp1PshQi22XUdia6iucfGWtq331lq123dr6n5KGSr7K7SqjSw11Pl0XSQkuVXoVOtMk5+KmdETI1xL+WnT4vq+eUIc6oHdGf3wvuEkJRdT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvLpxZ/o; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-782bfd0a977so4600812b3a.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090438; x=1761695238; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z4OFfgfpg2zuYVB97qQ4nYxxE2fA0slLU1vqJ2CVR4E=;
        b=HvLpxZ/oyS6/bJuVCK52e2NPKHQGvQmmYqh8/9b4AxDZ2YYK7TrE1CWlHE2reLMhun
         cX/LAKQcBHti7pwdZlU2FD0gdKfHtaXB2/dH+bWAJ4MFzeB102phEzkQ6vFJs+IXukjt
         uMwjUwdEzoFySh0OWznGnIfPjO/pqtP9StiZeoeJ0Uf0iCnRhDj9DqPV1+T/UUvvEuyO
         Pmr8qsSx87aT0QJixLbYmLlOxCMOosVPRb/C1R4u2p9wuqb0VgI9GgAsvUgodrgqHhvu
         MXACr2Hzlwox7//EKMFlLTUtAca7vOtHRPKdiKoG7me4IQnv5UN75f0ErpeJLP7Xzfkq
         jXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090438; x=1761695238;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4OFfgfpg2zuYVB97qQ4nYxxE2fA0slLU1vqJ2CVR4E=;
        b=m+Mouuolk6heV8EytfuconfZUGhedNSfUFtwgcE6o4UGQExqwQ2ITc8qoERsimXwHQ
         IzZS8mbs6skeHt13xkCgpVR1Jb4YN2qyDVZ6ca3TuWfHkyeWyPXKOry9VgAgr8JnfPHD
         fO80HDG+PNXKFxtRO1TckFd9lgP9VvsHRGbHyjl4OK4zGiw5NKfc4FmTT0HFI37WGaud
         tvrUFFz3Yic6XO4dATUPvSykXyQqtuTZNh1kyqGKMFYyLqD839OxgsQ3DRUxl5LJcorj
         ZW5wPSXUlJQ/eO/7xRcFpgZRz2AG7rzSY0Rv5tABIDsnZbq4Agk5vJRWe7/8sruw+fbV
         lfuA==
X-Forwarded-Encrypted: i=1; AJvYcCUuCR3PjDpZPTvvWVH4OH1l5AmqfR7o7Pxb8BtB6tL0vYyzeN+FJIAAQPd/1UhTUTDw9qc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBk7HrZyV6hbzBcb/cmas5dlNRx6wxhliqMQ5yeM5cQ53n9wgJ
	ZiFm7Ud8k/ipg3/OzFmFD1S4eCS6H34GkG/K12VpskeR3JWzcnEO1qleY48n/g9g
X-Gm-Gg: ASbGncsGqAMsxgh5vGvMpWIBJA+pvOc1rjsxNvO1sFlJ0+VyF2q0a+N/TWiGlbWoK9+
	D90tfOPO9TRfU2pydWJeVN9++BdZEwXqf4njQV41+ZjYwxuIRFhELhh9e7cCx+xUb7g5Ogo1G43
	AtvT3RpIioib5bV4WsVrw/24RZXMEBX6tr8BeOwOMwJpPbRlMTpRRlM7Pwl0Og7C9IFUL42D7U+
	yDUEJwVG9ad1DT0jOgZoqGEEYGlwO/zXcwlpaPW3leABzRdjRU1gnkh2G1R5IK6w+CE42BWd2PI
	Xl5RfGdF69GmFHVKs3YYZWEI6hbxTYqy8Zorl2iHOJ+vpN4Jdf3yupmGPeQ1i7+s5Gwj06g7NHb
	uR0x6C9b5O4OieeEkSdcPJa3TWeuwNlXvXaXX8rxEmLIltZ+toOxl996NEoO+QlUrGkXdibZyGy
	fa3USK4U2C
X-Google-Smtp-Source: AGHT+IFkhGJRP2dLAASLtzToAAHgpD36H89TPJABTWvg0NGgrSHeo1CXKroyw7GJKTzS0N8BFk4Bbg==
X-Received: by 2002:a05:6a20:42a3:b0:334:a832:91a5 with SMTP id adf61e73a8af0-334a862939dmr20305416637.44.1761090437936;
        Tue, 21 Oct 2025 16:47:17 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b33bf3sm11369376a12.19.2025.10.21.16.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:17 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:47:03 -0700
Subject: [PATCH net-next v7 20/26] selftests/vsock: avoid false-positives
 when checking dmesg
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-20-0661b7b6f081@meta.com>
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

Sometimes VMs will have some intermittent dmesg warnings that are
unrelated to vsock. Change the dmesg parsing to filter on strings
containing 'vsock' to avoid false positive failures that are unrelated
to vsock. The downside is that it is possible for some vsock related
warnings to not contain the substring 'vsock', so those will be missed.

Fixes: a4a65c6fe08b ("selftests/vsock: add initial vmtest.sh for vsock")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 9afe8177167e..b129976e27fc 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -591,9 +591,9 @@ run_shared_vm_test() {
 	local rc
 
 	host_oops_cnt_before=$(dmesg | grep -c -i 'Oops')
-	host_warn_cnt_before=$(dmesg --level=warn | wc -l)
+	host_warn_cnt_before=$(dmesg --level=warn | grep -c -i 'vsock')
 	vm_oops_cnt_before=$(vm_ssh "init_ns" -- dmesg | grep -c -i 'Oops')
-	vm_warn_cnt_before=$(vm_ssh "init_ns" -- dmesg --level=warn | wc -l)
+	vm_warn_cnt_before=$(vm_ssh "init_ns" -- dmesg --level=warn | grep -c -i 'vsock')
 
 	name=$(echo "${1}" | awk '{ print $1 }')
 	eval test_"${name}"
@@ -605,7 +605,7 @@ run_shared_vm_test() {
 		rc=$KSFT_FAIL
 	fi
 
-	host_warn_cnt_after=$(dmesg --level=warn | wc -l)
+	host_warn_cnt_after=$(dmesg --level=warn | grep -c -i vsock)
 	if [[ ${host_warn_cnt_after} -gt ${host_warn_cnt_before} ]]; then
 		echo "FAIL: kernel warning detected on host" | log_host
 		rc=$KSFT_FAIL
@@ -617,7 +617,7 @@ run_shared_vm_test() {
 		rc=$KSFT_FAIL
 	fi
 
-	vm_warn_cnt_after=$(vm_ssh "init_ns" -- dmesg --level=warn | wc -l)
+	vm_warn_cnt_after=$(vm_ssh "init_ns" -- dmesg --level=warn | grep -c -i vsock)
 	if [[ ${vm_warn_cnt_after} -gt ${vm_warn_cnt_before} ]]; then
 		echo "FAIL: kernel warning detected on vm" | log_host
 		rc=$KSFT_FAIL

-- 
2.47.3


