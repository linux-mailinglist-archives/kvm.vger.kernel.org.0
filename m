Return-Path: <kvm+bounces-67952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA144D1A080
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B302E3009259
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50EAF33FE2E;
	Tue, 13 Jan 2026 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XTkz7t1x";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZmInMJA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BBB311583
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768319618; cv=none; b=qG3op7mjyKh2uc8bq2ODliM4KemS/sju5e+3K3DVdNbxyvnKDD52Rbvw3PL9bQvWWNBr6KJuJHH0jyMUrwxBhk9nKqjNTFcOE0yZMo9xHwk1gHoxGFEeKxUOURa0JBG8uueT4vNDaj8jPQ/1MPB8mz8pEBWIUKPsCUk91395wXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768319618; c=relaxed/simple;
	bh=Rr2crUz2DUI9okAYGgwFpuu8kDcfbmW4w4rvyQxofL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LecEPcJdK11Lt+g/DxYyZQz0RNkYTGmTXHtLnl/2anSkuXxfcQ/6i4qzXBVNjw8rduRJpX8YvmmJDVw/wP9LiVfIyJWW3FS/qYXIEUQPEWW3VX/etWhk7ZbdsZtI+7AGdJ1J7KtnCR/qNxxMzlOgjP+2bd8eFCDW2AVmUVhtgfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XTkz7t1x; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AZmInMJA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768319613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TZoXydkaCbRzi/BpIgWSYmd+dDTH7DJWzt1xArcC9YQ=;
	b=XTkz7t1xNvqocMM7vFWA0GXBOARlFWTV+4S8wKv9Z+o44hevmVOa7t22dTw0UHghJmUaiC
	DbCpOhN810Ldmslkyjwaf29P4DdS1FcH7zwxeNDS6I0hvLjCpoRvoynx7RHM/KPISIsHjy
	WXxs21wRI6ulUZ1uSGt+h9BEkfs7ELA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-J1FQKXHSMqKivCzFHXt6Bw-1; Tue, 13 Jan 2026 10:53:31 -0500
X-MC-Unique: J1FQKXHSMqKivCzFHXt6Bw-1
X-Mimecast-MFC-AGG-ID: J1FQKXHSMqKivCzFHXt6Bw_1768319610
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so51539905e9.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 07:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768319610; x=1768924410; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TZoXydkaCbRzi/BpIgWSYmd+dDTH7DJWzt1xArcC9YQ=;
        b=AZmInMJAKFbIrBf7UToa72AxvvcyYT/ZyN9qd+0NBs/qY1lbUWeo/SM3iFJijD8Wnn
         CV+rTPczW3bJ2SJWrIGHjz5A5pONIjqR09iBr0+aToxIIL9/lfrBR/8OemiJ4j2fp1Ty
         xHZQUKwYmlLSkkOcZj56yBNMcn5ZoULiYtVnawOfn+fdTAMOq7MAoI+R1crh2pzMQPdf
         CW0JHR5Pf8w14iHiPH7835uPvYSY0Kp+WXVbFALOVIQwF7hmZpw9VGr9fe5p0nszDLBT
         31MntioOtNFIK/Um3yb2GqAjTyGGmw0kuXj68/XA1qzD3VHml60CVmPMmOql+8vXgh43
         b84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768319610; x=1768924410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZoXydkaCbRzi/BpIgWSYmd+dDTH7DJWzt1xArcC9YQ=;
        b=YkB/SSo7oBmH+h0sawSBWqamjvdGsDUnrYXc7NLkPO5cxEmYfVv4uolww6Jy4nXkpb
         wDBJhgpwtIt2LGOb2HKF6C8yumaKJxmXPwdVwhlsPC6U/L6BNzLhmelTx7dHZOKEBNGR
         BTVWf6egUtFTObNKMhX2AcL4oH/smCn2Z1SBNnZsPmub4qsXyVTKCwkYtZoPTPFn7EK6
         oPxYpJ8/id41ztaC8qx9lr7LLrSd8f5bTPc6ep796Qrb1+idEeze7KkOVGj82y5yaIKG
         ZtpPYftGa/RiofidUSlx1WuIcB2Es6z2OLX12wlnXBzLMR08qH4czr2F2qgdti2g/+BW
         L1Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWQvODClLopRZaxf16PPgXCI691wpnFf0dd7ByP4ADjOjoXhcfFqlQmDgUH04AYwZwQmsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjCUAcEoa2vYebt6y63oqmGV6/HLMgGMb7p4NZhil8EzsDesap
	p/+MRjLcCn4d98nXHMDs6Ql5CjBaFZhT2LaRegmzeDgu+e8bt9UXAFEYMS12EciWh6zmu0Rxxgc
	/NrJC/cxL1rVzO8emCrvamJBnrtd/n526P39RuGszwyXJ66a+Y+D+gw==
X-Gm-Gg: AY/fxX4eK5iHYpqdMSAdjW58/4LSulZCA+BFR799erMNVefaK1q/m6Se0YcOlfHT7Yh
	3J1aM399a8TpXRIZd0P0zWakvBqBWP+uHRCgAHLsYEY7YctN5c0gtUQeU/m5SLnlVA32EsRARL2
	ItR8U05ua9EuTrbbkfcFBo0A6/mALV1nH49/9HY5TcrNlyZ3idMpAfEMCk33obkZKN9RB87rTp/
	o6pzUzVBcrUYakGZO+miNdbl40j/9VfNjFsVWyY8/VSKZ+JTrGPnHO9a5Ov8fkQknZCUsUzUScm
	DrONH+bVWy6qnWSl6RtxQfNUh+JN7kMVkO9m3KIEDW8IPGkGUind3v/a87r/bHC2s89h53JkJ/9
	vyP9p2FTdhpeSoEivXBbUs1ir+Gh4obIlgwTK4nqZUAFOH0YD1BTxDegql/EdlA==
X-Received: by 2002:a05:600c:4449:b0:477:aed0:f401 with SMTP id 5b1f17b1804b1-47d84b368f6mr258282695e9.23.1768319610416;
        Tue, 13 Jan 2026 07:53:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQfC7/NeIeIlU44iVNxdFG3KKUWSQZIDiswxSwdGso26nsC4+3O4KhbxqfJ82+1Ys/KVNR7A==
X-Received: by 2002:a05:600c:4449:b0:477:aed0:f401 with SMTP id 5b1f17b1804b1-47d84b368f6mr258282215e9.23.1768319609956;
        Tue, 13 Jan 2026 07:53:29 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f69e802sm419650175e9.8.2026.01.13.07.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 07:53:29 -0800 (PST)
Date: Tue, 13 Jan 2026 16:53:20 +0100
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
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v14 05/12] selftests/vsock: add namespace
 helpers to vmtest.sh
Message-ID: <aWZqYWzhGf9gQgHk@sgarzare-redhat>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
 <20260112-vsock-vmtest-v14-5-a5c332db3e2b@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260112-vsock-vmtest-v14-5-a5c332db3e2b@meta.com>

On Mon, Jan 12, 2026 at 07:11:14PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add functions for initializing namespaces with the different vsock NS
>modes. Callers can use add_namespaces() and del_namespaces() to create
>namespaces global0, global1, local0, and local1.
>
>The add_namespaces() function initializes global0, local0, etc... with
>their respective vsock NS mode by toggling child_ns_mode before creating
>the namespace.
>
>Remove namespaces upon exiting the program in cleanup(). This is
>unlikely to be needed for a healthy run, but it is useful for tests that
>are manually killed mid-test.
>
>This patch is in preparation for later namespace tests.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v13:
>- intialize namespaces to use the child_ns_mode mechanism
>- remove setting modes from init_namespaces() function (this function
>  only sets up the lo device now)
>- remove ns_set_mode(ns) because ns_mode is no longer mutable
>---
> tools/testing/selftests/vsock/vmtest.sh | 32 ++++++++++++++++++++++++++++++++
> 1 file changed, 32 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


