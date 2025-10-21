Return-Path: <kvm+bounces-60772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC30BF95D4
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D6A5C505D7F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2726E2F691B;
	Tue, 21 Oct 2025 23:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FaeNva2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487A0253F3D
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090439; cv=none; b=BUSkN0LvnkUHYbahi7GwgfmaCgwyyhxudKQo5nFXq15cAcrtAgcz77y+a4Y/eIE5+dgNaHO/tuhjsPURt6Z3+YsjAX/qF0eftTg5Z5Zz/fzyf+rvDDdVxEZVj9aIVS4mqtk+AkbmaNPK/eqPYso/5O+GjkvnLPWjwQzyDdlRDrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090439; c=relaxed/simple;
	bh=cSAsRDqBVRjV5+J5lLGOrcD4Yn/sBflKtNCYHEuiaRw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GtXQodowrlotJAlf0qsorhgYp+EdAYxF/RPyLgQgfsxZBFSnFxAvfbn5oKMK2geL2RR1Md28VU89tJtWEU6LC1cwQ2sPPlF6P9WmcNbx6IKeO7asvtB0Vgz0HcNApc3sTPJcxSwv3wjTODmlg7zvyai5Y+JofZwrXQomBiInCC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FaeNva2E; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6cdd7e5736so130970a12.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090432; x=1761695232; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERN+jbjLqe2GDwDaLELjNRkAEJw/pLWXwhebqrcXkEc=;
        b=FaeNva2EiD/NGgDwWGw28Af1TvmhCwwSrssU24IT9UtinFqoiRii3VR64u6+V/Rv5D
         NTk1K1Ju3nWPjPVkR5DXWNM8Zuf6cjMWjfI6JQf8u0z+P4pnKVasSVJV0vJvlM9xmTl4
         MpmYgR+PXE5M8B92PdVIhvSNYgVI0oX10aC0qq5iVvpsbaomVVS6SsXQ4nt918Kv55VQ
         DkDyQx+FrZqJ55dpT1i71vEJ6gYtvDK+FDFuqfEExcNimUiMRcMtHVMOOYQhLk/+oViV
         Q0hx0qxLdDO16BFZ7ICU3thERrmCamimPO2osMnPtC+U1NLhk/Ir16wcU4eydcsn6QCa
         ll5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090432; x=1761695232;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERN+jbjLqe2GDwDaLELjNRkAEJw/pLWXwhebqrcXkEc=;
        b=bkPerHNZ17PgkhmoG3Dqmi2xk0u3y8q5Eqjyr6fHRGssN83RbzQ+NaToEB9V7oPSmi
         uBX3VbCvgbv+nRDz0yjOY3gVJK/V/lRgXSmZSi+BtK6Z6WccsDTO9IDwYilKIDZfbFgM
         W9kVTEC/yZ5huoPx42DBgIHaKxB9SgXjUuRIc4OR3FtGRfCng+KP9IrIM3Rv4fKb1p+K
         PT+9u5iv3dXcer8ndq+B5wpAiEU/zFACilJ5Yxo+iR/9MmgMywr1gImVytNbCTvm2rqD
         P7SaFa/vRpsXMtkuOrYQqsEDXsRTYVghDBWk0M5lxJ2OITWAzSLH/F+ok5iZC7PTY9q3
         2Mxw==
X-Forwarded-Encrypted: i=1; AJvYcCUAq6m76lrQtf18CeAgHnEB3wq0PXCMO98FWPYSKpfFH/hhLaEjjY3YMvZrz0ck+U47DGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPeypPpWJsuLg1lgusuaxROrAMwEyAuuMqGXRuaW36amBwd1cw
	0M/jEfbpxInpm6NR2Hh3W+s1KYYSD4salHTX7AOk3XgMhijurCru0a5Z
X-Gm-Gg: ASbGncskteho1cr4RabJgc0FEUF2kuvIL9290JuH50A9zmIVlv5UhP7D2JJVLRI/aja
	0swrFcE5jwlRwa85JfETjcd80yv4QVDDZSeX0lxCNcQTNndCXgEJ1kid4yMdsLgWJbSG5PSEl9C
	hO3Knlu/+9cPHI9NeTU7zhX+PZloa95bC0PsXsp/P62VPKud3p/HXGeFMVpFrocGSIr8JCZP6ok
	FaR18ldh78JOtGAa6j6bAp9Rrqik+rvDq6xfmiGWQ56zEMPcpquMAfdgsQW40eMFAtrK3DgC1xJ
	jLRHmy3YwPdv7D2TvDDEB7YYxjMoGmVsjHnYODmUGqLlCyJm0whF9NTSyYb4gaykjieXJ4KeZKE
	V2mVomeYErFoopLQzn/W2QnnNmCj0ZnM+Q1O8S/Uk5QaPQcs5oBBQiYfnQhhfMw6RBiq684lCZ1
	zK2YzG/wCh+SjjGVmqmA==
X-Google-Smtp-Source: AGHT+IFGmvrlTRJrVB5IZHQoRBZsqDSzVsYhhC0KT8URosDDz4O0ZlQ6n+lydCzN5y/3yUEEnGsBVg==
X-Received: by 2002:a17:902:cf0b:b0:24c:cb60:f6f0 with SMTP id d9443c01a7336-290cb66025amr253714265ad.58.1761090432218;
        Tue, 21 Oct 2025 16:47:12 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246fcc2e0sm120841465ad.34.2025.10.21.16.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:11 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:46:57 -0700
Subject: [PATCH net-next v7 14/26] selftests/vsock: add check_result() for
 pass/fail counting
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-14-0661b7b6f081@meta.com>
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

Add check_result() function to reuse logic for incrementing the
pass/fail counters. This function will get used by different callers as
we add different types of tests in future patches (namely, namespace and
non-namespace tests will be called at different places, and re-use this
function).

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 020796e1c31a..5368ec7b1895 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -78,6 +78,26 @@ die() {
 	exit "${KSFT_FAIL}"
 }
 
+check_result() {
+	local rc num
+
+	rc=$1
+	num=$(( cnt_total + 1 ))
+
+	if [[ ${rc} -eq $KSFT_PASS ]]; then
+		cnt_pass=$(( cnt_pass + 1 ))
+		echo "ok ${num} ${arg}"
+	elif [[ ${rc} -eq $KSFT_SKIP ]]; then
+		cnt_skip=$(( cnt_skip + 1 ))
+		echo "ok ${num} ${arg} # SKIP"
+	elif [[ ${rc} -eq $KSFT_FAIL ]]; then
+		cnt_fail=$(( cnt_fail + 1 ))
+		echo "not ok ${num} ${arg} # exit=$rc"
+	fi
+
+	cnt_total=$(( cnt_total + 1 ))
+}
+
 vm_ssh() {
 	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
 	return $?
@@ -523,17 +543,7 @@ cnt_total=0
 for arg in "${ARGS[@]}"; do
 	run_test "${arg}"
 	rc=$?
-	if [[ ${rc} -eq $KSFT_PASS ]]; then
-		cnt_pass=$(( cnt_pass + 1 ))
-		echo "ok ${cnt_total} ${arg}"
-	elif [[ ${rc} -eq $KSFT_SKIP ]]; then
-		cnt_skip=$(( cnt_skip + 1 ))
-		echo "ok ${cnt_total} ${arg} # SKIP"
-	elif [[ ${rc} -eq $KSFT_FAIL ]]; then
-		cnt_fail=$(( cnt_fail + 1 ))
-		echo "not ok ${cnt_total} ${arg} # exit=$rc"
-	fi
-	cnt_total=$(( cnt_total + 1 ))
+	check_result ${rc}
 done
 
 terminate_pidfiles "${pidfile}"

-- 
2.47.3


