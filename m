Return-Path: <kvm+bounces-68895-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOkgIXRCcmnpfAAAu9opvQ
	(envelope-from <kvm+bounces-68895-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:29:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5269868D8A
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 404AC4AC10C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A3B33B97A;
	Thu, 22 Jan 2026 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8epaApq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mn8wNyGS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED31E340DA1
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769090150; cv=none; b=RCgbaWCcGajjV465DT9RkEr5HQrbEi4y0kRwwGBu4RO/a43RZ7bDYdbczFCb090DU8p6IzFf8XjB+kRAMDcqeX+F3HkRvmEkt8Yb4sg2nCHFTUsYeI2x5mLaKRSsDlwYQ8++lcsjFIVSGiCzIXqvOg7OpNRKC8W54tMT0KHTaAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769090150; c=relaxed/simple;
	bh=2nXcGNysBiBdRcr6vy4ZStKKh5dYZxcbpIG7VnXq8as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JslvlAlrt0un6S0B5LVGKdM5xNpm8y8WkqfxGecz49H1qEnfA7+TwdVojqUFbFp4PHwGx5ILyNRB2ijUQNFhYIKPreYZFmbHITeQ/bWXzheYEW2/nrX7t/aA0POrUM7qQdEYHOWiFc9EHOSKTtcQsXgB5OgqaC87+/T3GZc5SUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8epaApq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mn8wNyGS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769090146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F3Df56peZRg7yuOoU4r9j2z63CMqum3dw8Q62JAWFUY=;
	b=R8epaApqU+zzfCY4u4zDJq0HQUb7ZADqMoHziHS6+pmBgLrink174RCwRrngTGaoMIG0Y1
	HnD+JeOnY+gX/NxjcBq8dOTFTWpPuhCfA7DVD1h4iw/WAOMfiFk1bx/UKQJsvWSgqxngK7
	pz7XNYbyTzmBcU4iDAFuHTwapBdEIUo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-7FLOnukPMrGzHbiOkPQg9Q-1; Thu, 22 Jan 2026 08:55:44 -0500
X-MC-Unique: 7FLOnukPMrGzHbiOkPQg9Q-1
X-Mimecast-MFC-AGG-ID: 7FLOnukPMrGzHbiOkPQg9Q_1769090144
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-432c05971c6so796046f8f.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 05:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769090143; x=1769694943; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3Df56peZRg7yuOoU4r9j2z63CMqum3dw8Q62JAWFUY=;
        b=mn8wNyGShfiU8zpLqqW1CJz3jW5+8fjwrYCHmBWgOVC4SJO3MbAFX2tfxro+yd5QDm
         0JLhe+vvs1qJcHtRo5lchGrgx2BOnItYppZYoOf1ejrjs0iqcwJKkfjVOnvok/iEi/86
         p00hhClju5EurMCdnC9TmH/KoYzMejAKc6UDpOHrcqhLVEgKNXCgjZvesK6pkPmZv0nP
         9HQLX/OsK0ZRDVboJL7NcCOJBhUDrGOiOPRo763osNssreWFXsqpCbvstinNRJlH5wzo
         RWu6dp12WnWtsVWBSIq9UrDeqfpnl38BDw726f1wR+ee8TSY3Fzc4yagJg0gWUo+5IuG
         GlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769090143; x=1769694943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3Df56peZRg7yuOoU4r9j2z63CMqum3dw8Q62JAWFUY=;
        b=R0ZgE4gdEpz8wGp9ptcit7Ahxh3Ov60GXFVpQVhFyk3jkTFlx9XsPVeuvsY4bb7oSR
         F/NhwoWGZm8ish6XOgpIXWFpYR6qT9GTtxGAl67vqiemHcLsnsPcSbn98Rw96YVvUjPQ
         29sBHTcYHDDOmfybkYYVyS/XgFB6y+y7gJhgIwJlh8uApUC+Rg1meThMWxgLJVnRQ/WK
         l111DIyvd5TToFFaWEo6MGG4DJ+5QqQGBqIbFN/q6FMfVcOotzPVYexm/NaT7N1C2tyH
         /EV7wcbLZ6q100dAtY88MKfKX59qPm5VuznlvWBgfs2j13eAi/OoszAnAYBKDHStSgW1
         +lHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSrsVgB1kG8BlNG9V3e/v3IHe3NQ561BnMxCIi5XxvcisNM/qWW3Xi/FL0XpT4+8e07ic=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC087ILvKevN1ebnzthSxP+U1npXU5m33yolhGbIQmMvEnamf8
	tL5BmR7wASOV02sIXf7aXNGSlqiqnoec7bhyCFKcYMx2FtIzkSjOKuWFNZszXefWsvyRfJ8UdHF
	krZKvKzUI4HRMAncYLbuJ/G1oEKgFw8g55KritmDm2iKa6kMnMXlbzw==
X-Gm-Gg: AZuq6aItW+D8BNanIoNXa8AJOo+s8SGy17AtwwyTHE0UxQe+nqJgVoJ9UQYM5yz7qNX
	y8arBxTJ0EnSVWIkQswvSqa9tnEm4F2D/PHlCSFH0cfd5ydZFCxvj7nJFgcRh0ieTSoRhdgoNs1
	oOyx2zSrIlIRDk9vueSNmOYy+LXJXkPhiogD+7PZtFeEfwPpvRrYweSxnlYud0H2bpdw0nyuZ7L
	7n6GoeQtfRRv1jK0/4oL94VJbXJRnMFPn1k/CGu5y2jcu8K6kAy7OCFTQZMDN3PX8G8acx9Cn9D
	WRhmLQaZ6qxKpGF1G6Qu1fnjgkRv0/jdDXw6gNbFc8JzRgghKa3SzfQ2qYNtByk6kHPeIihxyKy
	ukgl3RwGhKu7zfRBhfy1qDAXAnVe/YiXuowHyMaEeyVAHVJ8gu6zrbD17Wdk=
X-Received: by 2002:adf:f812:0:b0:435:9e32:2b85 with SMTP id ffacd0b85a97d-435a5ff993cmr4488741f8f.29.1769090143515;
        Thu, 22 Jan 2026 05:55:43 -0800 (PST)
X-Received: by 2002:adf:f812:0:b0:435:9e32:2b85 with SMTP id ffacd0b85a97d-435a5ff993cmr4488677f8f.29.1769090143056;
        Thu, 22 Jan 2026 05:55:43 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4359333b924sm18095487f8f.13.2026.01.22.05.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 05:55:42 -0800 (PST)
Date: Thu, 22 Jan 2026 14:55:36 +0100
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
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	linux-doc@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v16 00/12] vsock: add namespace support to
 vhost-vsock and loopback
Message-ID: <aXH7YCgl0qI2dF1T@sgarzare-redhat>
References: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68895-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 5269868D8A
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 02:11:40PM -0800, Bobby Eshleman wrote:
>This series adds namespace support to vhost-vsock and loopback. It does
>not add namespaces to any of the other guest transports (virtio-vsock,
>hyperv, or vmci).
>
>The current revision supports two modes: local and global. Local
>mode is complete isolation of namespaces, while global mode is complete
>sharing between namespaces of CIDs (the original behavior).
>
>The mode is set using the parent namespace's
>/proc/sys/net/vsock/child_ns_mode and inherited when a new namespace is
>created. The mode of the current namespace can be queried by reading
>/proc/sys/net/vsock/ns_mode. The mode can not change after the namespace
>has been created.
>
>Modes are per-netns. This allows a system to configure namespaces
>independently (some may share CIDs, others are completely isolated).
>This also supports future possible mixed use cases, where there may be
>namespaces in global mode spinning up VMs while there are mixed mode
>namespaces that provide services to the VMs, but are not allowed to
>allocate from the global CID pool (this mode is not implemented in this
>series).
>
>Additionally, added tests for the new namespace features:
>
>tools/testing/selftests/vsock/vmtest.sh
>1..25
>ok 1 vm_server_host_client
>ok 2 vm_client_host_server
>ok 3 vm_loopback
>ok 4 ns_host_vsock_ns_mode_ok
>ok 5 ns_host_vsock_child_ns_mode_ok
>ok 6 ns_global_same_cid_fails
>ok 7 ns_local_same_cid_ok
>ok 8 ns_global_local_same_cid_ok
>ok 9 ns_local_global_same_cid_ok
>ok 10 ns_diff_global_host_connect_to_global_vm_ok
>ok 11 ns_diff_global_host_connect_to_local_vm_fails
>ok 12 ns_diff_global_vm_connect_to_global_host_ok
>ok 13 ns_diff_global_vm_connect_to_local_host_fails
>ok 14 ns_diff_local_host_connect_to_local_vm_fails
>ok 15 ns_diff_local_vm_connect_to_local_host_fails
>ok 16 ns_diff_global_to_local_loopback_local_fails
>ok 17 ns_diff_local_to_global_loopback_fails
>ok 18 ns_diff_local_to_local_loopback_fails
>ok 19 ns_diff_global_to_global_loopback_ok
>ok 20 ns_same_local_loopback_ok
>ok 21 ns_same_local_host_connect_to_local_vm_ok
>ok 22 ns_same_local_vm_connect_to_local_host_ok
>ok 23 ns_delete_vm_ok
>ok 24 ns_delete_host_ok
>ok 25 ns_delete_both_ok
>SUMMARY: PASS=25 SKIP=0 FAIL=0
>
>Thanks again for everyone's help and reviews!

Thank you for your hard work and patience!

I think we've come up with an excellent solution that's also not too 
invasive.

All the patches have my R-b, I've double-checked and tested this v16.
Everything seems to be working fine (famous last words xD).

So this series is good to go IMO!

Next step should be to update the vsock(7) namespace.

Thanks,
Stefano


