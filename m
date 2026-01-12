Return-Path: <kvm+bounces-67795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C6793D1457E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0226C3015132
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899E237BE78;
	Mon, 12 Jan 2026 17:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNj0Oim9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CoIhvYqc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2D37BE66
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238796; cv=none; b=heKc/+NwXJ/5TUjBcLLpuq+Sy7ITNnGV0P1FAtZO7cLwl3dgjf61TNwgjTWhFafbpcTP0HhtnYd39cPNbR//wV2Wy+XTNMMZ8qUAZRevAmwv/A6fwr7TorYA4bX1rAN1lg0tkOGL0dOOojm6VwP/r1jFmSnmWiA3XadKOnR0FJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238796; c=relaxed/simple;
	bh=VcWKMM3TsRHjfu+KXLUJOs/P3Fis/5txZmCUs7c62Fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWtWziAazhZelMFoTLnx8+frBLCVvRkKGwou1lL1VEFRaG3A1jjZUA21XfZAzB/bEaPUfPdJRmgYw1zm2aDzYAUaB346299IWRNRK9+jqCHjLH8dEkmJ84GMQY1d9AF75MkwDy8wwevtUC4tFCFUhTAkEV7nV/ekRwiWpcBaygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNj0Oim9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CoIhvYqc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768238794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BcomD5fw9IVBx/EvgIn//kfeDV6vnh/bPzC6DXjWibA=;
	b=JNj0Oim9wKof8VBgCL+0xXrfpqlgwjE0j+zGrhSJX8gZPu83ps7s3wIs2Rp+Oq4y7dpb6g
	nhFZ4pQe/z4bVWUg09iX/tHoJIZHkcpPjZ1olu1FgzH11ZTeGLEjwElfrYb4ae2FZxy1hD
	r+gtw4OOZIO6eI1BvpNExri8+RfMl+4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-9Rt5FNc4OK6xmrsfTMI6og-1; Mon, 12 Jan 2026 12:26:32 -0500
X-MC-Unique: 9Rt5FNc4OK6xmrsfTMI6og-1
X-Mimecast-MFC-AGG-ID: 9Rt5FNc4OK6xmrsfTMI6og_1768238791
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477563e531cso47204845e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768238791; x=1768843591; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BcomD5fw9IVBx/EvgIn//kfeDV6vnh/bPzC6DXjWibA=;
        b=CoIhvYqcw17rpFY27OsZLFV1dDWaDQMOaAHz1OB5jLxB54fYAPrI66KLbBgQmDOt4e
         0Byy7xM5hAxUXVhsa1Tz8xVcXVCjH/QREGxVoXc1FllIr/4XEwey1bEGcKKkTBBTDGYe
         RVdyC/1a3XSA6X+HcSXhgAuBm4nP1PZulUasF+3a/7rpyK2c8XWIsIzVKcA9A90W5hak
         FrLyr0Wn+RyWzqmtjL9y0C/OFEA2+mv80M73RbQ+23xfnsrlkR0szr02/wWloSNz/Yn+
         Q9Vc//qrx0+Ik8cPZYnIuwQwRH2l05c17KpyDxWm6X3RBcEBayBmKfiNtr8mMAeBME+0
         a0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768238791; x=1768843591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BcomD5fw9IVBx/EvgIn//kfeDV6vnh/bPzC6DXjWibA=;
        b=iihPqAVC0CIc9Za6Ujn1D2vaDdDHqb/5B8Av8ztrn1SNVfh35VMHhh7uwBEfau87CC
         ISt8bmvRzWKqcPWzJBod70PV6vTqsqZGcix+2+g9CJXtu6or+8Wdli1PTiiYh7hxzHRL
         dd/O04kfBuoPsSgLqk0/5fT/MVg6Na+OFOdkBvP3taIRAVrRlWUljtiC7sb2bIwJOunU
         uoNT0TCFiX9Y/yE3O99igI+A+DQ5D7IQfUlsBvFsriH9khHZOuYFXZxgLLhdFVs1Ckog
         q6QAb4FQOL1IAFFxLArRgE40YnBzhW48d2EFbxKdfV2Yh/ALDd/nVHd/L/oRbXx1b/UT
         rTzg==
X-Forwarded-Encrypted: i=1; AJvYcCUPHmwoyViXBw154z35aRsFJ06IcITp7W+n2qjMfIxuiMuU29nTiMAqDtllvtVKft8zjJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/GAUJ2xI4tVwjl0nZQTl2aec/mNp/1m+r5nKLp3PberToQfsd
	iRVoMzR14TdVROuBqR9KwawBZmtbJPeodD2aUJ3PjBNR1KXVSkuEpt6FNo1BUoY+QmE1CFVTBl2
	dgggjweMRRG7Ims/DQVvQADDTX0W0qFTd3gYS0ihUuGOjvDD9GWXFbw==
X-Gm-Gg: AY/fxX6KpEQURi3CAymoyW69rjhcK40eUQEbvrHwaSfutE3R24wWicqSY/BWZw78/ob
	E8yn6uz4g7aeA0vLFHTN4v376xAzSR2lYzl7XGREHcU26QShuNRFZXjgFUi4jM6GyxecEGmgass
	WBJMTWR85zi4kTpyLUCv8EDBxtutfpEE7+g3nfVL82TsPXUJsEAfXfTYm5YPgpC8yGG6hsgpGLZ
	Taxk+6Co/TC/CbXGm8uf9YAfwEJtKswd71cch2Mb3dVOc35JdhzwVl3Dm7Q3d2csBi+1yoQ4Hvx
	A6wvyHQuuoMBY0kGQu7KPS4Bbz9EkhAhYSwE2v3okDKTdTZWlt9511Oz6yDZllNOCjMqPijVg9K
	92aw4RHZCp1QPg3TM8dMpA4pzl14hCzzbf+X5qI1dVKDlyCgyZlwPG2v7LiPYMg==
X-Received: by 2002:a05:600c:3556:b0:477:9b35:3e49 with SMTP id 5b1f17b1804b1-47d84b0a23cmr220596315e9.3.1768238791249;
        Mon, 12 Jan 2026 09:26:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbooX6m235tcKkT8gxwgze2BljLHzxenepn63aMTJ5BFbz8FRH46rUY9bsCgL8OFUNeCvvZA==
X-Received: by 2002:a05:600c:3556:b0:477:9b35:3e49 with SMTP id 5b1f17b1804b1-47d84b0a23cmr220595755e9.3.1768238790766;
        Mon, 12 Jan 2026 09:26:30 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6ef868sm358964245e9.11.2026.01.12.09.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 09:26:30 -0800 (PST)
Date: Mon, 12 Jan 2026 18:26:18 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH RFC net-next v13 00/13] vsock: add namespace support to
 vhost-vsock and loopback
Message-ID: <aWUnqbDlBmjfnC_Q@sgarzare-redhat>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
 <aWGZILlNWzIbRNuO@devvm11784.nha0.facebook.com>
 <20260110191107-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260110191107-mutt-send-email-mst@kernel.org>

On Sat, Jan 10, 2026 at 07:12:07PM -0500, Michael S. Tsirkin wrote:
>On Fri, Jan 09, 2026 at 04:11:12PM -0800, Bobby Eshleman wrote:
>> On Tue, Dec 23, 2025 at 04:28:34PM -0800, Bobby Eshleman wrote:
>> > This series adds namespace support to vhost-vsock and loopback. It does
>> > not add namespaces to any of the other guest transports (virtio-vsock,
>> > hyperv, or vmci).
>> >
>> > The current revision supports two modes: local and global. Local
>> > mode is complete isolation of namespaces, while global mode is complete
>> > sharing between namespaces of CIDs (the original behavior).
>> >
>> > The mode is set using the parent namespace's
>> > /proc/sys/net/vsock/child_ns_mode and inherited when a new namespace is
>> > created. The mode of the current namespace can be queried by reading
>> > /proc/sys/net/vsock/ns_mode. The mode can not change after the namespace
>> > has been created.
>> >
>> > Modes are per-netns. This allows a system to configure namespaces
>> > independently (some may share CIDs, others are completely isolated).
>> > This also supports future possible mixed use cases, where there may be
>> > namespaces in global mode spinning up VMs while there are mixed mode
>> > namespaces that provide services to the VMs, but are not allowed to
>> > allocate from the global CID pool (this mode is not implemented in this
>> > series).
>>
>> Stefano, would like me to resend this without the RFC tag, or should I
>> just leave as is for review? I don't have any planned changes at the
>> moment.
>>
>> Best,
>> Bobby
>
>i couldn't apply it on top of net-next so pls do.
>

Yeah, some difficulties to apply also here.
I tried `base-commit: 962ac5ca99a5c3e7469215bf47572440402dfd59` as 
mentioned in the cover, but didn't apply. After several tries I 
successfully applied on top of commit bc69ed975203 ("Merge tag 
'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost")

So, I agree, better to resend and you can remove RFC.

BTW I'll do my best to start to review tomorrow!

Thanks,
Stefano


