Return-Path: <kvm+bounces-63580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C227C6B252
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id A0C8C2BEB0
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93E035FF63;
	Tue, 18 Nov 2025 18:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHoRL0W9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLwdneCf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FEB2D8368
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489595; cv=none; b=lT4fpbTniWnZoi2e+Kj/uUAoCTlUheCxuV9G0kr4rOjXggJg6zdxqQKEeTWSxw4xX3xHvsQVO80/jzGzmOGtqd2eUtXGa9hvWxenoJReKEv2k7gR/JpillgjU+pHz5efxD5BpHpeIsGYLQ3QIQR6V11j+6/Zdxzqli0MgCqpqCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489595; c=relaxed/simple;
	bh=ESkljyOopVtU50//2SKEaLXXjPSw66upROeHtwZHBTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGZYuoOgmM94InWIYgEOqKb+USCTkc8yEtq2OexT6db3BY2muv9eDTUlQaeuujrd/s9wejtZuftLLIVELru72PuMAlHD2x5H39voaSKV5fWe8UZBhTf4oxk26O8VqC0t4ngVR8/SJ/jT0hr0y+iKmBp5Ag5XYPVbFQPemfxISLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LHoRL0W9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLwdneCf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763489593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voAmjtngZH987SL0d1/xV0xBaRhoeK7O02B2C/SKO58=;
	b=LHoRL0W90uQfrkONRFJVVusN1nPdqkZL/rA18Q8YGdnESAm8eYezQcV0F7cFkAk08uiuG1
	bwpy4TKwIvGW4fgAz1WyykAGqUylyK0XeQNjJUdRHFCwClzBxO3hRvM0HWVKrElPVgTYg2
	z2pmi1vSD5iGtZF30laloS9gNVHbFzw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-li4aT3nmM3OY_ROdT1bYug-1; Tue, 18 Nov 2025 13:13:12 -0500
X-MC-Unique: li4aT3nmM3OY_ROdT1bYug-1
X-Mimecast-MFC-AGG-ID: li4aT3nmM3OY_ROdT1bYug_1763489591
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47788165c97so8637005e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763489591; x=1764094391; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=voAmjtngZH987SL0d1/xV0xBaRhoeK7O02B2C/SKO58=;
        b=aLwdneCfEURxR7QwR+JA//XqUSuJiIbzyi+clLnD3IqgHujVMNwN2T2nrf/ukOJ409
         1j6NmZnROQ9GXRlYiQ2+VolkampsITJDQKVJEsL9ECMWBZyCttOK065SKm5fVHo9AKUZ
         XZfvocAUJVJNmqSWOp0wLY5SyFJnCYJ5b5A3x8A6GdwvSnHwAgWaLBtcRmeoLgCHDsV+
         Pg1Fr0EoSEu1mXF1GRiXY3E2YCnZxBbA3f/9NAfB4aOuBiP1QPS7xqy3GfA1rnR0oivM
         IeiRb2qiCj7z8/rnETcuBpwJYVzlkvPL4EV+Q3ABp1oc7Zv/pOz2+fA76NVhZ+0d+fao
         XUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763489591; x=1764094391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=voAmjtngZH987SL0d1/xV0xBaRhoeK7O02B2C/SKO58=;
        b=PQYeX324MyfOnXlxXIgquVMt3Ybd/D64Wvy2p00amcGg/B6FwY4CaVhoOfTvVBVZ/e
         503G3SwoA8eN2CqJ9JSO6fVZpiTzBULKcKZvQzaoteVN0QtcDHZ9voaRMJwYlkOsYD96
         FPiPOr8KgBM46x+6uEp5fipJc/E2aV9sGYVaZ+Dr9zDHCf2DmgT2SCZkiTgw4iToS1YZ
         9aEc8SSY/PlgQrmYm6jslfs/stKNkR5t8BpmOVHTWYqNWswIs+zt8KN2y/NoSmuG52/i
         WqI86ehM93s37ZRZRGl/vdB9uOluYZoOYe0vf7gS7Tqev7ptg0uRlyF0+PeZcK6GxErZ
         f/1A==
X-Forwarded-Encrypted: i=1; AJvYcCUbIqAauhMP8x2wLMmmioRpLZpXDZBA0f/EXIXO2NvSesiJawQUQgtoD5hi3foufJ8sZUo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybl00We6mOQncJ2uqN81U/bDgrGQryu+rZqoD/gTWP/Nl8m4YF
	Apevh4LSdaSfY7gTlRIti72TiuXVVbksfjS/9GBRjA/H/QuIpwAUNSjsG4G2+8XmdiW20LPOLIy
	MA14GLjRhhW1FZ11boxDzjREuKFGFBTz3lk9JlE7btMIAe+AjQM25dA==
X-Gm-Gg: ASbGncu4JWUlQDlIqvVLt3ccJegxu4lmxK1ps4VjVvlbEWFAOHFEBY5WBbAGJzE+z8b
	Ak1Q+sxfE7SmFT/aMRghxNxBQ3tXRZSCHVKH2GCmKluK8hDxjFBDN5Rd5XVGA7zXClsMD24jC2e
	hUFolhjKpMI2vyEOSmKVDP9eHnIURpLz5aPaFscoMtLdg90rDbtUN/rUGOCRU8PRFzQAkft/q3C
	T4naQqgEfUSQipJS7XagXHKVYONb5wpS5+iWNO6zyw+uE61Q39Zhg6oYJu6erHnJIc8CDIRUTbo
	JBpA96vGnZTsCE62DsWRaHMgG3IdK4MRz6EU6TybC9yrpUIN7E0jHQo298lOl4wkD+EAJzJnLaT
	EZDqCWZrMcqsLBsx9dDUVpIsPfQe3mRWwMzpZ1cWHIq/n22zblPYbmQqAg/Y=
X-Received: by 2002:a05:600c:4752:b0:477:7b9a:bb0a with SMTP id 5b1f17b1804b1-4778feaa7cdmr147586115e9.21.1763489590819;
        Tue, 18 Nov 2025 10:13:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIT8ng0CUWbvzfqjNxNNDfLjFNDwG4+rLmN0Xj3SFNTvDx9hI+oXmEXYHOMQFCNSDvZBqLmQ==
X-Received: by 2002:a05:600c:4752:b0:477:7b9a:bb0a with SMTP id 5b1f17b1804b1-4778feaa7cdmr147585685e9.21.1763489590295;
        Tue, 18 Nov 2025 10:13:10 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-250.retail.telecomitalia.it. [82.57.51.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a9e19875sm21423225e9.16.2025.11.18.10.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 10:13:09 -0800 (PST)
Date: Tue, 18 Nov 2025 19:12:58 +0100
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
Subject: Re: [PATCH net-next v10 06/11] selftests/vsock: add namespace
 helpers to vmtest.sh
Message-ID: <643ayuucvcaet3v47uwh22mahncfbm3arjqf7szs4apa7gsklq@clggma36o37s>
References: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
 <20251117-vsock-vmtest-v10-6-df08f165bf3e@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251117-vsock-vmtest-v10-6-df08f165bf3e@meta.com>

On Mon, Nov 17, 2025 at 06:00:29PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add functions for initializing namespaces with the different vsock NS
>modes. Callers can use add_namespaces() and del_namespaces() to create
>namespaces global0, global1, local0, and local1.
>
>The init_namespaces() function initializes global0, local0, etc...  with
>their respective vsock NS mode. This function is separate so that tests
>that depend on this initialization can use it, while other tests that
>want to test the initialization interface itself can start with a clean
>slate by omitting this call.
>
>Remove namespaces upon exiting the program in cleanup().  This is
>unlikely to be needed for a healthy run, but it is useful for tests that
>are manually killed mid-test. In that case, this patch prevents the
>subsequent test run from finding stale namespaces with
>already-write-once-locked vsock ns modes.
>
>This patch is in preparation for later namespace tests.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> tools/testing/selftests/vsock/vmtest.sh | 41 +++++++++++++++++++++++++++++++++
> 1 file changed, 41 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
>index c7b270dd77a9..f78cc574c274 100755
>--- a/tools/testing/selftests/vsock/vmtest.sh
>+++ b/tools/testing/selftests/vsock/vmtest.sh
>@@ -49,6 +49,7 @@ readonly TEST_DESCS=(
> )
>
> readonly USE_SHARED_VM=(vm_server_host_client vm_client_host_server vm_loopback)
>+readonly NS_MODES=("local" "global")
>
> VERBOSE=0
>
>@@ -103,6 +104,45 @@ check_result() {
> 	fi
> }
>
>+add_namespaces() {
>+	# add namespaces local0, local1, global0, and global1
>+	for mode in "${NS_MODES[@]}"; do
>+		ip netns add "${mode}0" 2>/dev/null
>+		ip netns add "${mode}1" 2>/dev/null
>+	done
>+}
>+
>+init_namespaces() {
>+	for mode in "${NS_MODES[@]}"; do
>+		ns_set_mode "${mode}0" "${mode}"
>+		ns_set_mode "${mode}1" "${mode}"
>+
>+		log_host "set ns ${mode}0 to mode ${mode}"
>+		log_host "set ns ${mode}1 to mode ${mode}"
>+
>+		# we need lo for qemu port forwarding
>+		ip netns exec "${mode}0" ip link set dev lo up
>+		ip netns exec "${mode}1" ip link set dev lo up
>+	done
>+}
>+
>+del_namespaces() {
>+	for mode in "${NS_MODES[@]}"; do
>+		ip netns del "${mode}0" &>/dev/null
>+		ip netns del "${mode}1" &>/dev/null
>+		log_host "removed ns ${mode}0"
>+		log_host "removed ns ${mode}1"
>+	done
>+}
>+
>+ns_set_mode() {
>+	local ns=$1
>+	local mode=$2
>+
>+	echo "${mode}" | ip netns exec "${ns}" \
>+		tee /proc/sys/net/vsock/ns_mode &>/dev/null
>+}
>+
> vm_ssh() {
> 	ssh -q -o UserKnownHostsFile=/dev/null -p ${SSH_HOST_PORT} localhost "$@"
> 	return $?
>@@ -110,6 +150,7 @@ vm_ssh() {
>
> cleanup() {
> 	terminate_pidfiles "${!PIDFILES[@]}"
>+	del_namespaces
> }
>
> check_args() {
>
>-- 
>2.47.3
>


