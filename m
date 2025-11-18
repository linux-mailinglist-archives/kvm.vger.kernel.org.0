Return-Path: <kvm+bounces-63581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CAA4C6B297
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id B33072C0D6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF273612CF;
	Tue, 18 Nov 2025 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPXt3JgT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FoIB6mbt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B974135FF5D
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489667; cv=none; b=VH24UZ6CtH5tQ5vhTBGGoY/EZ9AByzidKiDgiUTylSxOaajKXQqS93nUIqcrwDfgY9M04I0oX4IB5HfNPTD8Qg/Toi/WrN/Q5vuPeWRNFR9D0yD6pwaGp3obgY4cH7VqsQ1+qL1YH5BIack7Jfx1iwaGcuMLnr/OWn5sMVoHVcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489667; c=relaxed/simple;
	bh=93pZ6dl5lFQD43TapInbMA0s7FqryaSyeA9SjB2/Swk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZ2p5f83l/imHT8au+SLsKNKtPU6k4yBE2gwO7hfX7L744cC2oygWH1uJsK9Yu+ziVcTV+ylA+MxvwGt2y+wNCDzHCmhIyZc/u5jjQ1ZdlhqRY/xzh4VKAR7dz1SPG1vWZbNTo7BZ9dzKFxt6PvAISV9g8jjQIISGC06kI0fSrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPXt3JgT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FoIB6mbt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763489664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ogfCDQuwBr308yi4xavgkU0Sq9YiKn4sM5QwPOHCZ7A=;
	b=YPXt3JgT3WfKGtMRiafhymWvX8w6wIvzrxJuitdlK/TIHSjkH6wys4F9KRzmeaZrgno7El
	gAnP12Ug5QNK+0tfAL1YzFHW6EdiSC3DCqw3z90hvl1uK1DV3YU+c17nEwEZFEpJ1XGYsF
	2q8Bwbxubvwr3EXG3WsBSsNS6lAOgPo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-7J9GOGRCPzuVgTNx6jCVwQ-1; Tue, 18 Nov 2025 13:14:22 -0500
X-MC-Unique: 7J9GOGRCPzuVgTNx6jCVwQ-1
X-Mimecast-MFC-AGG-ID: 7J9GOGRCPzuVgTNx6jCVwQ_1763489660
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b2f79759bso4163052f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763489660; x=1764094460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ogfCDQuwBr308yi4xavgkU0Sq9YiKn4sM5QwPOHCZ7A=;
        b=FoIB6mbteb+Uo4T86irp/XzAl6AecdpoiX1D0DT6C3PRR71pDf/bnDxApUzfFSOtIt
         qq4r6VZwppZc2lahK+/F+IPRXCPfu/74Mbxv9dimzrI2PagLTlVw5DGveCMppD1U3DjV
         ziyEC8UTUUYUhs98KFd8xI56blKiIyDJUR8fk2kzm5ZVJZ7Dl9bM4mkJOE26AG/oXjO1
         MNM1o8q2G9KX85fRdGMpVQO3jort4EGrWpWkCbHWVSq3F4cc4NoHqHDhlNdBAJTCkCyF
         FZkZ4fqXExrsJPERHtiMld5kc9VtCqMYu3CswKL8xEFfgahzbZ0hDRQfSCGHgOuQakgp
         1FVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763489660; x=1764094460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogfCDQuwBr308yi4xavgkU0Sq9YiKn4sM5QwPOHCZ7A=;
        b=E+kj1GAJqVkMLcS7cqfhy2L7OS+mVw0IMno7j8vYLxKLbaPRq8J4sakK8NSqyfKwUv
         dFpk5Rz0i5YFRuoxYqPaHZ8/ovh+MZPXbLefsfvv4dreQshCIUGvOChLCr+0SkYKiCqE
         mBxktqwr8qIyI4OzdEeU6uo72sCgc4+pl9oSDnbers/f8Sf3dKXBZPtGa8RaH+dmWrA9
         8SOL4CQ8gtN09PU99H6aBd783djoGqgdF/k7QzZFwOi1BYS/KJ7nqdXS91PuBxeJgL+r
         e0Tmg4cN1m/PCu0mE3wXs79/Uo6PA/frdQXudhDC9lmnwE+vk1o3PrqRFffqAS6Fayue
         MMsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXb9KZqiL4YI57XOmpZb0Ni8nR2kcpkePaRd/OP2HOLLt8aTs70pP4AGU7rJC93UGEqYpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzABdsJVQyiHMAmpeVyIs/QIOtPZt7HcwB5OpvfC2IQ1lp9ORO6
	3VUU1xrKBFkwOQ1o4Xc4RzCh7a5tMyPMngWOriQvonxAjAhphKGBnnr4Nxql19Rg/QyzttbgnAa
	6wBALxS4NnkQqDxnSp7D/j1yu4+TO7Ykfbh2isO0FIKs9HiBG7VHzag==
X-Gm-Gg: ASbGncvN6Ku4FMm0XgfVekxZc3wu5xSN1vSZj7R7imsm3EPkAvSCvkm6pj2dX2YVty1
	2RPtEIqm7ZCz6+YUKdy99LWZGDHxaoybY8iQEaxzKHVCEpHVJj/XMQK73UnDkIz6hbP9bgyJY3T
	m2qSpqTi7EmvuMWHhSmBHvfPDgEFNtDlzEVgIdhjnZrdZAl2OaJRYjq8c3UtPwLtgyHRIJQa8h/
	Yz4aZEViBLC1h0KxJKweYmTvNiu/7R1VmIvO2DKETmcIbSRPgcOF6uIn7T5h10b4aatGdk9LM49
	ypz/r5cRIB7XXcJ08KmS0ppJejVXxfaS+m6hpHYw6RLuuGXGwq8okMrBXFfBDBs4PnFL3MHG0Ls
	C31BvxP+iE5YrI7HM43xANOGYfZySu0JiUojjOdquiG78oYTL1aXYUcGPDWc=
X-Received: by 2002:a05:6000:4210:b0:42b:3bd2:b2f8 with SMTP id ffacd0b85a97d-42b593849ffmr16260479f8f.46.1763489660386;
        Tue, 18 Nov 2025 10:14:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFS8o+OnlcCO7Yj6XaGWOD+hRu7PmlcNwfKGvJu2ycvTutZuUYYNXih4+y5NlFSoF//9qYsmQ==
X-Received: by 2002:a05:6000:4210:b0:42b:3bd2:b2f8 with SMTP id ffacd0b85a97d-42b593849ffmr16260434f8f.46.1763489659913;
        Tue, 18 Nov 2025 10:14:19 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-250.retail.telecomitalia.it. [82.57.51.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f19aa0sm33992549f8f.37.2025.11.18.10.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 10:14:19 -0800 (PST)
Date: Tue, 18 Nov 2025 19:14:10 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v10 09/11] selftests/vsock: add namespace tests
 for CID collisions
Message-ID: <iyn62b6uwxgoz5r3rk3huca3ehwvh6zv4rx37hliqrkh3bknkt@qfmfnrwdd3ks>
References: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
 <20251117-vsock-vmtest-v10-9-df08f165bf3e@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251117-vsock-vmtest-v10-9-df08f165bf3e@meta.com>

On Mon, Nov 17, 2025 at 06:00:32PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add tests to verify CID collision rules across different vsock namespace
>modes.
>
>1. Two VMs with the same CID cannot start in different global namespaces
>   (ns_global_same_cid_fails)
>2. Two VMs with the same CID can start in different local namespaces
>   (ns_local_same_cid_ok)
>3. VMs with the same CID can coexist when one is in a global namespace
>   and another is in a local namespace (ns_global_local_same_cid_ok and
>   ns_local_global_same_cid_ok)
>
>The tests ns_global_local_same_cid_ok and ns_local_global_same_cid_ok
>make sure that ordering does not matter.
>
>The tests use a shared helper function namespaces_can_boot_same_cid()
>that attempts to start two VMs with identical CIDs in the specified
>namespaces and verifies whether VM initialization failed or succeeded.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> tools/testing/selftests/vsock/vmtest.sh | 73 +++++++++++++++++++++++++++++++++
> 1 file changed, 73 insertions(+)
>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index 86483249f490..a8bf78a5075d 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -48,6 +48,10 @@ readonly TEST_NAMES=(
> 	ns_host_vsock_ns_mode_ok
> 	ns_host_vsock_ns_mode_write_once_ok
> 	ns_vm_local_mode_rejected
>+	ns_global_same_cid_fails
>+	ns_local_same_cid_ok
>+	ns_global_local_same_cid_ok
>+	ns_local_global_same_cid_ok
> )
> readonly TEST_DESCS=(
> 	# vm_server_host_client
>@@ -67,6 +71,17 @@ readonly TEST_DESCS=(
>
> 	# ns_vm_local_mode_rejected
> 	"Test that guest VM with G2H transport cannot set namespace mode to 'local'"
>+	# ns_global_same_cid_fails
>+	"Check QEMU fails to start two VMs with same CID in two different global namespaces."
>+
>+	# ns_local_same_cid_ok
>+	"Check QEMU successfully starts two VMs with same CID in two different local namespaces."
>+
>+	# ns_global_local_same_cid_ok
>+	"Check QEMU successfully starts one VM in a global ns and then another VM in a local ns with the same CID."
>+
>+	# ns_local_global_same_cid_ok
>+	"Check QEMU successfully starts one VM in a local ns and then another VM in a global ns with the same CID."
> )
>
> readonly USE_SHARED_VM=(
>@@ -553,6 +568,64 @@ test_ns_host_vsock_ns_mode_ok() {
> 	return "${KSFT_PASS}"
> }
>
>+namespaces_can_boot_same_cid() {
>+	local ns0=$1
>+	local ns1=$2
>+	local pidfile1 pidfile2
>+	local rc
>+
>+	pidfile1="$(create_pidfile)"
>+	vm_start "${pidfile1}" "${ns0}"

Should we check also this return value or return an AND of both?

>+
>+	pidfile2="$(create_pidfile)"
>+	vm_start "${pidfile2}" "${ns1}"
>+
>+	rc=$?
>+	terminate_pidfiles "${pidfile1}" "${pidfile2}"
>+
>+	return "${rc}"
>+}
>+
>+test_ns_global_same_cid_fails() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "global0" "global1"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
>+test_ns_local_global_same_cid_ok() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "local0" "global0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_global_local_same_cid_ok() {
>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "global0" "local0"; then
>+		return "${KSFT_PASS}"
>+	fi
>+
>+	return "${KSFT_FAIL}"
>+}
>+
>+test_ns_local_same_cid_ok() {

IIUC the naming convention, should this be with _fails() suffix?

Thanks,
Stefano

>+	init_namespaces
>+
>+	if namespaces_can_boot_same_cid "local0" "local0"; then
>+		return "${KSFT_FAIL}"
>+	fi
>+
>+	return "${KSFT_PASS}"
>+}
>+
> test_ns_host_vsock_ns_mode_write_once_ok() {
> 	for mode in "${NS_MODES[@]}"; do
> 		local ns="${mode}0"
>
>-- 
>2.47.3
>


