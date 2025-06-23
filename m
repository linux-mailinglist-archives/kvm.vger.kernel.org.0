Return-Path: <kvm+bounces-50395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C04AE4B8C
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 19:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A45F1726E7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1514D29C335;
	Mon, 23 Jun 2025 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZBaVw1t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68A424DCE8
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750698121; cv=none; b=KPnZ+yURke6L6Yy9wfOEOQQDeq6OmdZB05QSvqRt5Kt1+YduP6Vf15T3RtNaqn9/QIrhbn3AO4PLzHs4TaFadyH8Qa6V/5L1fgHmCZ7zCRayU0BoFbreOta0s848i/E8sj33x5yFsWZOc7hmZke8q9DINpUsYne4nqqA9Euv4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750698121; c=relaxed/simple;
	bh=taqM6M2yCTAkigZXwCzc8+OLPoroFfNThxW7WCtpr+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E16CwLaYpuzd/83xZ77HHJQMKpWJNo1RMVHjmdcp71pHdLgRZHflysQTbkZ1X5nX/1eZFvjL/yrReXpmGLxCV7CqxQb9sgDyvkmVcIrGPTQYeHPJb73DuD3q6kbspLi03Sm8nOSwJ0a/WC/h7OZKyQ0gBKSXiLGitXx49ur4BM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZBaVw1t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750698118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jq5JtTNSTi3UbB2t2zf1v906mYuPWMRbjCVCINzsyvo=;
	b=EZBaVw1tL+bCVbnugS0Xdj8kFpsyVOUXrK/5vX9ALdIHNNZvv7+drTr4+Wlf/FjF7fa3T4
	Vf/tkkTJob3/dIxRAHKxVpGSAynuQ3IagCSG+TT+BWIbnu16qMSLcB0iVa77aBvYx6WPhi
	9tpXjRKroT0H069vVSJrSVkqzTT9ytw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-hJPtYkZRMRGxxOv4tuoPSg-1; Mon, 23 Jun 2025 13:01:57 -0400
X-MC-Unique: hJPtYkZRMRGxxOv4tuoPSg-1
X-Mimecast-MFC-AGG-ID: hJPtYkZRMRGxxOv4tuoPSg_1750698115
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso2558011f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 10:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750698115; x=1751302915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jq5JtTNSTi3UbB2t2zf1v906mYuPWMRbjCVCINzsyvo=;
        b=VxkodlQLMPVuZufK3+Dpwp9kVVelHWsxhriUxQPeMVJ7T1372InSwh+E0bCsC8UUKn
         S+7dq/APZI7uk3YQ9ZS/rPejlRvpogcINdbOhIGNnYq1eVbE+vmXYovU9Lnup4lNMXF5
         Ux8Tr+LBMBwRBbebgMoYg6ETVBhEjVue4pnUkcj66i5vES1NviaHR6tRUVBB0OPvzl5l
         kQ+FsNsTUadM60bfnHdge1siqY+KBME4AJhx9nKqW9JZW5J9YqMP5nyI4lv1nFL8ItVv
         y/O8T9gyIZtALs4WhVDzG4CnNRvYNe4XFyvzL4JhL/yjcvWHJfTCrjA/jRH0RveDAYid
         +Mhw==
X-Forwarded-Encrypted: i=1; AJvYcCVkJ1WMvb6okNlp24wKfDkMPHUGsbP6VVWCy64Xuj893qr4YDtpyZO8FhLNTdnrmexcu4g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4f6tXnPB9YXQUHM15HREbfTwWTIgBIjIZIyy7hHKu0H5GYCrk
	BEfRaou2ebsC94qkvPA300skQFRH2IK6JPSZgDo4tOXEAx6ZuQZQREC0IjaEufyvbEv1wqpkDgY
	peiHI8uQUuDuMmEnryHJW9Zk5aa/Yt0Ji4GCQjPh0wVU2UZBLTTWPVQ==
X-Gm-Gg: ASbGncsicZ3uXWJSK/1hTo5bOERd9bB9TXPf5t0R5IgPYEUEo4YmW4XGi0HKmR7jnoC
	dBD5+QQe97oZtbYCO9+YdhbXPxYHsKwzPpJi9rucjqB5zLQOYTt1VFFKC/WuCvpYnjmCPO9bD/7
	uZh2xnjH9Wvfjm7yJ3FVTOlcgdC/Oc4DchhtTnPNtl+t/WUVT3szcVbTzk9fBVGe1s4p98C9DgW
	iVBGiHPXYuiduVY5jCwGvMXrbwXm/mRqP9Frl58sS6NDgjVw/EF5rPkx83Mru5cPH4QUabXqONY
	UZLOWGFAQVlSuQZdKmwXZPofyVw=
X-Received: by 2002:a05:6000:288d:b0:3a5:8905:2dd9 with SMTP id ffacd0b85a97d-3a6d1331316mr11150059f8f.51.1750698114889;
        Mon, 23 Jun 2025 10:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgLc1G5fHA+5OCdohy+RX20t3SZJ3zi/U76KcD2RoeCTL1jtFDfjcLkndhINDFJCXPqEyFPQ==
X-Received: by 2002:a05:6000:288d:b0:3a5:8905:2dd9 with SMTP id ffacd0b85a97d-3a6d1331316mr11149981f8f.51.1750698114073;
        Mon, 23 Jun 2025 10:01:54 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.144.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f10411sm9667235f8f.1.2025.06.23.10.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 10:01:53 -0700 (PDT)
Date: Mon, 23 Jun 2025 19:01:44 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: davem@davemloft.net, decui@microsoft.com, fupan.lfp@antgroup.com, 
	haiyangz@microsoft.com, jasowang@redhat.com, kvm@vger.kernel.org, kys@microsoft.com, 
	leonardi@redhat.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mst@redhat.com, netdev@vger.kernel.org, niuxuewei.nxw@antgroup.com, 
	pabeni@redhat.com, stefanha@redhat.com, virtualization@lists.linux.dev, 
	wei.liu@kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v3 1/3] vsock: Add support for SIOCINQ ioctl
Message-ID: <opt6smgzc7evwrme7mulwyqute6enx2hq2vjfjksroz2gzzeir@sy6be73mwnsu>
References: <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
 <20250622135910.1555285-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250622135910.1555285-1-niuxuewei.nxw@antgroup.com>

On Sun, Jun 22, 2025 at 09:59:10PM +0800, Xuewei Niu wrote:
>> ACCin hyper-v maintainers and list since I have a question about hyperv
>> transport.
>>
>> On Tue, Jun 17, 2025 at 12:53:44PM +0800, Xuewei Niu wrote:
>> >Add support for SIOCINQ ioctl, indicating the length of bytes unread in the
>> >socket. The value is obtained from `vsock_stream_has_data()`.
>> >
>> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>> >---
>> > net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
>> > 1 file changed, 22 insertions(+)
>> >
>> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> >index 2e7a3034e965..bae6b89bb5fb 100644
>> >--- a/net/vmw_vsock/af_vsock.c
>> >+++ b/net/vmw_vsock/af_vsock.c
>> >@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
>> > 	vsk = vsock_sk(sk);
>> >
>> > 	switch (cmd) {
>> >+	case SIOCINQ: {
>> >+		ssize_t n_bytes;
>> >+
>> >+		if (!vsk->transport) {
>> >+			ret = -EOPNOTSUPP;
>> >+			break;
>> >+		}
>> >+
>> >+		if (sock_type_connectible(sk->sk_type) &&
>> >+		    sk->sk_state == TCP_LISTEN) {
>> >+			ret = -EINVAL;
>> >+			break;
>> >+		}
>> >+
>> >+		n_bytes = vsock_stream_has_data(vsk);
>>
>> Now looks better to me, I just checked transports: vmci and virtio/vhost
>> returns what we want, but for hyperv we have:
>>
>> 	static s64 hvs_stream_has_data(struct vsock_sock *vsk)
>> 	{
>> 		struct hvsock *hvs = vsk->trans;
>> 		s64 ret;
>>
>> 		if (hvs->recv_data_len > 0)
>> 			return 1;
>>
>> @Hyper-v maintainers: do you know why we don't return `recv_data_len`?
>> Do you think we can do that to support this new feature?
>
>Hi Hyper-v maintainers, could you please take a look at this?
>
>Hi Stefano, if no response, can I fix this issue in the next version?

Yep, but let's wait a little bit more.

In that case, please do it in a separate patch (same series is fine) 
that we can easily revert/fix if they will find issues later.

Thanks,
Stefano

>
>Thanks,
>Xuewei
>
>> Thanks,
>> Stefano
>>
>> >+		if (n_bytes < 0) {
>> >+			ret = n_bytes;
>> >+			break;
>> >+		}
>> >+		ret = put_user(n_bytes, arg);
>> >+		break;
>> >+	}
>> > 	case SIOCOUTQ: {
>> > 		ssize_t n_bytes;
>> >
>> >--
>> >2.34.1
>> >
>


