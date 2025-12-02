Return-Path: <kvm+bounces-65099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BC0C9B183
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 11:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A21B43A71DC
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 10:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EE23112C2;
	Tue,  2 Dec 2025 10:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FawMiLWc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWqlNVfz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93E30FC2C
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 10:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764670706; cv=none; b=VDK1VeavbUFKzYHUccxTa7CMF1kglNO7Du0TYBCSZHaV+7M0v6a8EImp3xP3fG+asuZtQ5booCYtNc/d+Cg5DXpVfVKLFuPp954DAJOVJBgIjO+cG3Ape5qxfdYIDJP9gNEPvkzSMnNKlfLALTAIIWOLgY/6juBX7A1MU9wzxqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764670706; c=relaxed/simple;
	bh=C4AsMPURAFZJ6fstRBG4Qg4vpP3aNkGXJBTFj94MTzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l2bHA8ufZxImx6gVbiGFgn/fb/+ebd2D6iA0y08gIqf5Oa2cc/mUFGmC/PlcD3xR/jZmOHXlbVmTkB0tFtVjVPW8pmV0R0cu3qoKO4GCUuH1hKFV3GLHIR6CrbGHjdM04dYCnLoYM+JSdMsvlR90mpLEmoTPXCXdpGEpRcA7WCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FawMiLWc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YWqlNVfz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764670703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTt4I/sl26XWVMJJrirBgM5lGXHO7o89v/gepGPRQ/c=;
	b=FawMiLWc0qIHh5BLuQkPx09OGT3XagKPL/KKKYZEO8FGKf81qtASmBc6jtW9CGTfAbjDhq
	Xe4KabmRQyfty7eOLrLX8VeBN74DH3kUBnc7+wUc49ofnEGv0PphtJpZmC0Cq0GWgEwy/3
	HyHyUuyvoQXZuvm1X5vGUYX91rmSNVs=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-efYwVoL_NHyxnESg-TLGUA-1; Tue, 02 Dec 2025 05:18:21 -0500
X-MC-Unique: efYwVoL_NHyxnESg-TLGUA-1
X-Mimecast-MFC-AGG-ID: efYwVoL_NHyxnESg-TLGUA_1764670701
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64203afd866so10120295d50.0
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 02:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764670701; x=1765275501; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CTt4I/sl26XWVMJJrirBgM5lGXHO7o89v/gepGPRQ/c=;
        b=YWqlNVfzJ2B+5RypcZGlhYXrKy4RwJ1V7YRi9LFlH/uQgPuttuE4q21nihPcAL1d3y
         NxMsMNM0xcm/Xr7+nveTr+KUeRKozzOgI2IygnagWoH/N1afXmuzp+ENv8S0glgh07vO
         2pUxvV0Z+X5vvKpKwYglz6G42mmbo9qcc6kAdeQ7WhH7dIZfpv1DAd5DXvcny5x3G7+A
         HZse3ajvAWzv6CDjYbkSR1VLF4TFxxBIeAPOtNKLLinyjNUwEoHsfE5P9VALj24dGov8
         8ZanDs0UXrGroviMEKexh6fV5rUyz+eNC+zFQsm7CKyPj79wlPQci4SNmL22NlpGZ8zf
         0EEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764670701; x=1765275501;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CTt4I/sl26XWVMJJrirBgM5lGXHO7o89v/gepGPRQ/c=;
        b=O+KrjCWQo8LYS55gAwsRJ4DgwY2g3ozfyNFv00Ve5Z/jVhK+SmUXDhShStjlGYqK9E
         yNNlMtH1YZ6SDbDWXxl5/ZOwVPS6xTr3FP9MkQC2Uo977XfVW7FQTMylhW2W+Uy3u/q5
         PhRyHyOMcd8s7GjgSVsAexjpq/U2jCzJdgbucl2J30WPnvqZKsx+vX/7oQfVpmZkiatR
         GndzLXkTWz8ye1k22KwztvCetNBrckZ/2QngGhc+T+kP8cLoPM3AYvUN0YrYKt+R9hlu
         xI3kDXBWe3ahgpZWSdVw9uMVzVV6fw1vK2KwJy9vGLr56g3pNE7X5Y8/0kBjvP8axUhk
         wi1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNT6DpBEAj2ZK+ySYhY7caP3lJFxZq0ap147OslUmWzfzRQ13ic9hySIirM8edjUICH+s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs/BdHyCMRstrNheivizUW7HmOYWcOmFcJJff5y3UXxmBrGFIl
	x7XzbE8qTFsi9J6N80DuhLOzOxWHHm6wQ5oQZ5eERAVjR2l7SuuwPaeCZK9+I4U9e8evJ4Hhand
	jL19oUoMZ0fEsUllYDr/4fe3MBPB0/ho5XXRtOmKb3/bTe3j8OxF/Gg==
X-Gm-Gg: ASbGnctEI+5n3dTmWv5cNG6dO0Xvmy7tLaFwqeBrzDhc2nTQrVepJSzkTuu8JSRhUJ3
	ancSVEqXqUn0sbE6Aj1/uARnhg8mKoqXWXh4zGmeWdsj31oMFM3Uu2pkkq5IXxbt5KGweyT7ctX
	I5zXONUw6W5GAHE0KOfDQTof6C8B32Qnq//CkSCv80j7UTtoF1qf/NL7r7MEliFKW5PFdAPIZ6j
	Dhw+sBeqyeXA7bNsNhaxhG5sb4KBQB4iIpV+EzMbrzuTwAuyuBoh3MI40eghJ9tHlzCYKm+eLU2
	yOG8GfLXidezqXjpEs22vF6hjNY4A1hjPGUEtGC6JvMGaeNuOiEPC4kVknFHTwSyzagfkBu8yB3
	CY//m21zutSTzsQ==
X-Received: by 2002:a05:690e:d03:b0:641:f5bc:6959 with SMTP id 956f58d0204a3-6442f18c515mr1347962d50.42.1764670701049;
        Tue, 02 Dec 2025 02:18:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH9Y2QIm+VTnIL7mAD4ACmwgT3wSBe6KSOZFrHyLZqmktUrNUAn/hV1QCPy5jYE4S4xdld0TA==
X-Received: by 2002:a05:690e:d03:b0:641:f5bc:6959 with SMTP id 956f58d0204a3-6442f18c515mr1347929d50.42.1764670700596;
        Tue, 02 Dec 2025 02:18:20 -0800 (PST)
Received: from [192.168.88.32] ([212.105.155.136])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c089431sm6041059d50.10.2025.12.02.02.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 02:18:20 -0800 (PST)
Message-ID: <6cef5a68-375a-4bb6-84f8-fccc00cf7162@redhat.com>
Date: Tue, 2 Dec 2025 11:18:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 04/12] vsock: add netns support to virtio
 transports
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa
 <vishnu.dasa@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kselftest@vger.kernel.org, berrange@redhat.com,
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@meta.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-4-257ee21cd5de@meta.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251126-vsock-vmtest-v12-4-257ee21cd5de@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/25 8:47 AM, Bobby Eshleman wrote:
> @@ -674,6 +689,17 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>  		goto out;
>  	}
>  
> +	net = current->nsproxy->net_ns;
> +	vsock->net = get_net_track(net, &vsock->ns_tracker, GFP_KERNEL);
> +
> +	/* Store the mode of the namespace at the time of creation. If this
> +	 * namespace later changes from "global" to "local", we want this vsock
> +	 * to continue operating normally and not suddenly break. For that
> +	 * reason, we save the mode here and later use it when performing
> +	 * socket lookups with vsock_net_check_mode() (see vhost_vsock_get()).
> +	 */
> +	vsock->net_mode = vsock_net_mode(net);

I'm sorry for the very late feedback. I think that at very least the
user-space needs a way to query if the given transport is in local or
global mode, as AFAICS there is no way to tell that when socket creation
races with mode change.

Also I'm a bit uneasy with the model implemented here, as 'local' socket
may cross netns boundaris and connect to 'local' socket in other netns
(if I read correctly patch 2/12). That in turns AFAICS break the netns
isolation.

Have you considered instead a slightly different model, where the
local/global model is set in stone at netns creation time - alike what
/proc/sys/net/ipv4/tcp_child_ehash_entries is doing[1] - and inter-netns
connectivity is explicitly granted by the admin (I guess you will need
new transport operations for that)?

/P

[1] tcp allows using per-netns established socket lookup tables - as
opposed to the default global lookup table (even if match always takes
in account the netns obviously). The mentioned sysctl specify such
configuration for the children namespaces, if any.


