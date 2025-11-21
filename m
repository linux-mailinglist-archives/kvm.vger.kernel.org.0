Return-Path: <kvm+bounces-64059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 04574C7770A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 3F4BF2CA37
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1352FFFA2;
	Fri, 21 Nov 2025 05:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAUOO0WH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C869F2FABFE
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703900; cv=none; b=sUoWujspvutUKH+XyytBko0pltVcjky3hE6m9B0X57cIjlSTRqraqgnsATGr8o8fh6mE37BLP3gzW34LrMFFK8LEdLDPrOS9kFFuGOq8yCOIzVs/32ifoQwU8nWaqpXJSasqEnvzwaIVie79WW00VukizVmcug5EmUTDwPcntEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703900; c=relaxed/simple;
	bh=uK+7wonqeqIE2+4J4eSHlB1BJW2sPOHiw05XtJHZdQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P34e05cf5WrIGwsBNxOVuESSuzNDt67Sajoigr87VAydNIEG8YfaO2jOs0guvi0jza5B6G1Qa4FZI+dgwctZgeUMNpxqlisDLr9OVMjUB6aZgiD4Wgr82ZHR6ZH9dvk/AvaUlLeJIG/z+/xLZVObqbGUjxmpPuLtzPncQ0lNDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAUOO0WH; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2953e415b27so19793015ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 21:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703897; x=1764308697; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSkbmakY8QtibtOCdba8TmlxElnFph3vUeoyjgD6/iw=;
        b=QAUOO0WH3+qgxCZ6gMwgQYIf1kk8I60OZx+Wxe2+vqswILHB94RidaRv6PgCam5Q/2
         0QeqACwTPcokwZ1EwCE9dam0p5utVtxibxiUmQQP4AH9iFGNKaLyhRpYOEnHT9bSW9w3
         nhpWiRmeFGT2pphlhz6ckYZJZlrPTLQUtOx6da7bJ2js+q7FehULpnpD7Lku6lz3sXbN
         KC2TRvN/VeTSxcaaEOdNbgXjk0EKihxBvkR8mfc8eU2hGDUwvoJ3m3eWqgcg3guyA7O9
         MWl5ys8XEXnSXyMtIMLQuXdf5YL/w78Un6fNQG9qKtkWEIG1PTstwa2KYP0Ip0sZFAzt
         99RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703897; x=1764308697;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fSkbmakY8QtibtOCdba8TmlxElnFph3vUeoyjgD6/iw=;
        b=dY9Xl7OAA3riiDpnHSoIKZlYvOqHWQ3NoKO2CrPOnIxS9oiAaiT4cEXx6q5pdFF/di
         zzhx7EMV2i1mLmfR2H/1cZLj9NJL13RN4wKgmIPfGuLbyVDyre/ywepKGfQ1aGVlRDo4
         OabNZVbwadoKeTrbsyFah4v3tEG/u8uXf5JMsqSyP3EOmixM47hbEXKEApUmelBIqmfM
         FE2GyEKCb5HpGsLpXatNvLZnQh/MXvQEkByjBQQDIEr5+BGd1sFP33XGqHEvF0g769Mk
         mnjSAERVJj85msfJg4ra75cn6W7ay8PV+VpzBq11FOtVOjvNtj5/OMVcSnG45zYsx668
         TizQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtTvjCY2ZxHX+ZOUxwPvo5uMIsxGf3UccVN5vEnrqJ1dJHvNBqkfdfr1N+O/tygljx9Ag=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdd51fPpTjbEmFCFwFP1nmZb135eeP899y3S9qynQWwDxov9XW
	MHGKZFq53hV7SkqF3wJCn0mG4kiH98moEff7PGxEPpCYDrJxIuB1kTL8
X-Gm-Gg: ASbGncvaP1+MSyuXOt+paufGdKo0k7647DXj7xT/U2SkUdcoy0EvxqLEgvBOQ3KK8kH
	A4xl/y0ejpwwqr54GYDNSqfPIjhknFvMlZUKMWhJyJ3WbhI1tkszEt4JBN7MrUR/0yeiIgzLVmC
	MB/inFFDf/CMuUkH14qWh7oE/JBH8QnOuHOOpAZKY5iMNbHf/zvdh5bpG+0aBlqDlkkH17fwdvj
	GJkk5TocymkMgBfsW+FaqynDewNAXtVLkCzKIIKVMFEUFg7MNE2sSu1vv0lJ8zFJ2UelufD8tjf
	3upVkb4CCTCI9qnWQ8NNduR6eU4QYDeGj2A60JczMQqa7ZHc+BZdZK5lFwEDeA7G/tyArFmuJWu
	BP7c/f1cQHi5amzlWeTbtnAkADivPZltfDNJmoHktyY7qcdUdV+mGxIcgva2oo1GFqDbuNg3/oZ
	FsaUvBMGb7IGdVWqhzxek=
X-Google-Smtp-Source: AGHT+IGGsDu1q3vm1jDYt6q/UI5NUFr2N2GTMwEvCBun/hcx13LSj7midmn1ev74SGvBLriqPu/3+g==
X-Received: by 2002:a17:903:2ac5:b0:297:e59c:63cc with SMTP id d9443c01a7336-29b6bf19ef0mr14465525ad.35.1763703896832;
        Thu, 20 Nov 2025 21:44:56 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b25c104sm44306755ad.54.2025.11.20.21.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:44:56 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 20 Nov 2025 21:44:38 -0800
Subject: [PATCH net-next v11 06/13] selftests/vsock: add namespace helpers
 to vmtest.sh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251120-vsock-vmtest-v11-6-55cbc80249a7@meta.com>
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

Add functions for initializing namespaces with the different vsock NS
modes. Callers can use add_namespaces() and del_namespaces() to create
namespaces global0, global1, local0, and local1.

The init_namespaces() function initializes global0, local0, etc...  with
their respective vsock NS mode. This function is separate so that tests
that depend on this initialization can use it, while other tests that
want to test the initialization interface itself can start with a clean
slate by omitting this call.

Remove namespaces upon exiting the program in cleanup().  This is
unlikely to be needed for a healthy run, but it is useful for tests that
are manually killed mid-test. In that case, this patch prevents the
subsequent test run from finding stale namespaces with
already-write-once-locked vsock ns modes.

This patch is in preparation for later namespace tests.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 41 +++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index c7b270dd77a9..f78cc574c274 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -49,6 +49,7 @@ readonly TEST_DESCS=(
 )
 
 readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
+readonly NS_MODES=("local" "global")
 
 VERBOSE=0
 
@@ -103,6 +104,45 @@ check_result() {
 	fi
 }
 
+add_namespaces() {
+	# add namespaces local0, local1, global0, and global1
+	for mode in "${NS_MODES[@]}"; do
+		ip netns add "${mode}0" 2>/dev/null
+		ip netns add "${mode}1" 2>/dev/null
+	done
+}
+
+init_namespaces() {
+	for mode in "${NS_MODES[@]}"; do
+		ns_set_mode "${mode}0" "${mode}"
+		ns_set_mode "${mode}1" "${mode}"
+
+		log_host "set ns ${mode}0 to mode ${mode}"
+		log_host "set ns ${mode}1 to mode ${mode}"
+
+		# we need lo for qemu port forwarding
+		ip netns exec "${mode}0" ip link set dev lo up
+		ip netns exec "${mode}1" ip link set dev lo up
+	done
+}
+
+del_namespaces() {
+	for mode in "${NS_MODES[@]}"; do
+		ip netns del "${mode}0" &>/dev/null
+		ip netns del "${mode}1" &>/dev/null
+		log_host "removed ns ${mode}0"
+		log_host "removed ns ${mode}1"
+	done
+}
+
+ns_set_mode() {
+	local ns=$1
+	local mode=$2
+
+	echo "${mode}" | ip netns exec "${ns}" \
+		tee /proc/sys/net/vsock/ns_mode &>/dev/null
+}
+
 vm_ssh() {
 	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
 	return $?
@@ -110,6 +150,7 @@ vm_ssh() {
 
 cleanup() {
 	terminate_pidfiles "${!PIDFILES[@]}"
+	del_namespaces
 }
 
 check_args() {

-- 
2.47.3


