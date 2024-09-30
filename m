Return-Path: <kvm+bounces-27686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6627498A8E8
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 17:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDA9B1F23BBC
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 15:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24080192D68;
	Mon, 30 Sep 2024 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWWkb4z/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E0B36D
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727710981; cv=none; b=E0sFDiRtaJ+xKOsgi80vUsFlihXh72wUCXeJuVJZ57vIamDcpYvi3jG6Ck44hMkg+r2qDoolmZCvs0hCymN5YGViJolj4vSaMUMNwX/WxTaaT1nPmAGz3kEtzgCqs0UVW7n09VVJpjEAXNI0IKM94ZF0PeAiLFImuOJAk3O5Jvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727710981; c=relaxed/simple;
	bh=3T33t+EUFrhX7XERdYOTfYYMeR6IB0nGO1voqFz9yKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzhjSdi5lwBgd+Dsc5WhXfEeWhCybBc588Bc+zpctyF4JGVk0mpnXDXSeIJGWEiaCcCWyr+asitc90dXNlhe9QZTwshWwWpFnN2fo71LLWkAHq++3yv84imU7tImZG8JT5apu4S9ScpmIUr4dDMIAn6OfDpn+vlz9Mk0PWZxr2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IWWkb4z/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727710978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTjUE8YZi1Ehaq4q7rU8j5BXAi9GfabG0EHDs77unUw=;
	b=IWWkb4z/BYod0utzVYsR1RwrpRAsViDOlWklzRur73ZLFrUh14ZbmvP5OxCiCRepRM3sdp
	6LD3rF5K8I8CAhrcSn28rPlRjAITZ59tOFiULar0IdtT1DHsVttpoAitrQsr/SV0Tbe65l
	dQXbtIi2ITzFzRrFmb/40FNX99v1Foo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-D4dzApd8OcuFP657T9SXjA-1; Mon, 30 Sep 2024 11:42:57 -0400
X-MC-Unique: D4dzApd8OcuFP657T9SXjA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-20b0ca9288fso64605925ad.2
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 08:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727710976; x=1728315776;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FTjUE8YZi1Ehaq4q7rU8j5BXAi9GfabG0EHDs77unUw=;
        b=VzhJq4LCgnS8dCW+IJmNZSy45pWy8v3mZOnCH7MKrP36DTnoxN3JQ7R435WgQvMCL6
         X1HaNztUs99l+W6wiBmlEqKOZY301O4gnZvbBzo1tc144FvHEGpP2nKuS5kf59dF2lkF
         JwlKGqEC135Uxxc/hB8t7sZePZTqqVv93nt48R5gxBohy/VdFPXU+BUF7tycNyjruMCw
         El1LZrz5/J7d/cc6pJ3mL84FKtdo9EzhHC7DF6BUy/aRUk+pnzOnum1FjMfhVkM5D2S8
         JZhIwsQl2++t9e9vu+zPGFQzsZyLsqYBBYtOBoJGrSuBaIjGmcYnWdzTKPlkR1P9hmqq
         iKEg==
X-Forwarded-Encrypted: i=1; AJvYcCUH6ZvH81GZaRA0JHC5gScoSrBR2y7FzgPqSl/5NS+2G0mq6BC4msgClgGetgokTUdN4wM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEzSdJfmRfts2wEXtwFGcDMvgSfSaPFwIh2Yn3sK9AR8SDyCWD
	IQvt+PCxwPPK4Od4FC7eMDUtmaUMwoxTaOYpCj4Pl8WzXvY7ftaS2YTlvid5EJ+8irKbF+e8UDE
	xsnMp2mkAEXNOluZXJ0qEJLqJgGBjtUKowLsJQB+JyhThX43H8cuUIsrcozsf
X-Received: by 2002:a17:903:1c8:b0:20b:6308:fd2f with SMTP id d9443c01a7336-20b6309058emr102681165ad.11.1727710975951;
        Mon, 30 Sep 2024 08:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+1Km5mMVpw4lqxWS39fSDeWCd+6vNdZZTnbxpwI/FRJWUFEig5XS+HU0bEHaqrW9MJ5oTQw==
X-Received: by 2002:a17:903:1c8:b0:20b:6308:fd2f with SMTP id d9443c01a7336-20b6309058emr102680725ad.11.1727710975336;
        Mon, 30 Sep 2024 08:42:55 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-231.retail.telecomitalia.it. [79.46.200.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37da2195sm55818475ad.104.2024.09.30.08.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 08:42:54 -0700 (PDT)
Date: Mon, 30 Sep 2024 17:42:47 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: kuba@kernel.org, stefanha@redhat.com, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vhost/vsock: specify module version
Message-ID: <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
 <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>

Hi Aleksandr,

On Mon, Sep 30, 2024 at 04:43:36PM GMT, Aleksandr Mikhalitsyn wrote:
>On Mon, Sep 30, 2024 at 4:27 PM Stefano Garzarella 
><sgarzare@redhat.com> wrote:
>>
>> On Sun, Sep 29, 2024 at 08:21:03PM GMT, Alexander Mikhalitsyn wrote:
>> >Add an explicit MODULE_VERSION("0.0.1") specification for the vhost_vsock module.
>> >
>> >It is useful because it allows userspace to check if vhost_vsock is there when it is
>> >configured as a built-in.
>> >
>> >This is what we have *without* this change and when vhost_vsock is 
>> >configured
>> >as a module and loaded:
>> >
>> >$ ls -la /sys/module/vhost_vsock
>> >total 0
>> >drwxr-xr-x   5 root root    0 Sep 29 19:00 .
>> >drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
>> >-r--r--r--   1 root root 4096 Sep 29 20:05 coresize
>> >drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
>> >-r--r--r--   1 root root 4096 Sep 29 20:05 initsize
>> >-r--r--r--   1 root root 4096 Sep 29 20:05 initstate
>> >drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
>> >-r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
>> >drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
>> >-r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
>> >-r--r--r--   1 root root 4096 Sep 29 20:05 taint
>> >--w-------   1 root root 4096 Sep 29 19:00 uevent
>> >
>> >When vhost_vsock is configured as a built-in there is *no* /sys/module/vhost_vsock directory at all.
>> >And this looks like an inconsistency.
>> >
>> >With this change, when vhost_vsock is configured as a built-in we get:
>> >$ ls -la /sys/module/vhost_vsock/
>> >total 0
>> >drwxr-xr-x   2 root root    0 Sep 26 15:59 .
>> >drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
>> >--w-------   1 root root 4096 Sep 26 15:59 uevent
>> >-r--r--r--   1 root root 4096 Sep 26 15:59 version
>> >
>> >Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
>> >---
>> > drivers/vhost/vsock.c | 1 +
>> > 1 file changed, 1 insertion(+)
>> >
>> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> >index 802153e23073..287ea8e480b5 100644
>> >--- a/drivers/vhost/vsock.c
>> >+++ b/drivers/vhost/vsock.c
>> >@@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
>> >
>> > module_init(vhost_vsock_init);
>> > module_exit(vhost_vsock_exit);
>> >+MODULE_VERSION("0.0.1");
>
>Hi Stefano,
>
>>
>> I was looking at other commits to see how versioning is handled in order
>> to make sense (e.g. using the same version of the kernel), and I saw
>> many commits that are removing MODULE_VERSION because they say it
>> doesn't make sense in in-tree modules.
>
>Yeah, I agree absolutely. I guess that's why all vhost modules have
>had version 0.0.1 for years now
>and there is no reason to increment version numbers at all.

Yeah, I see.

>
>My proposal is not about version itself, having MODULE_VERSION
>specified is a hack which
>makes a built-in module appear in /sys/modules/ directory.

Hmm, should we base a kind of UAPI on a hack?

I don't want to block this change, but I just wonder why many modules 
are removing MODULE_VERSION and we are adding it instead.

>
>I spent some time reading the code in kernel/params.c and
>kernel/module/sysfs.c to figure out
>why there is no /sys/module/vhost_vsock directory when vhost_vsock is
>built-in. And figured out the
>precise conditions which must be satisfied to have a module listed in
>/sys/module.
>
>To be more precise, built-in module X appears in /sys/module/X if one
>of two conditions are met:
>- module has MODULE_VERSION declared
>- module has any parameter declared

At this point my question is, should we solve the problem higher and 
show all the modules in /sys/modules, either way?

Your use case makes sense to me, so that we could try something like 
that, but obviously it requires more work I think.

Again, I don't want to block this patch, but I'd like to see if there's 
a better way than this hack :-)

Thanks,
Stefano

>
>Then I found "module: show version information for built-in modules in sysfs":
>https://github.com/torvalds/linux/commit/e94965ed5beb23c6fabf7ed31f625e66d7ff28de
>and it inspired me to make this minimalistic change.
>
>>
>> In particular the interesting thing is from nfp, where
>> `MODULE_VERSION(UTS_RELEASE);` was added with this commit:
>>
>> 1a5e8e350005 ("nfp: populate MODULE_VERSION")
>>
>> And then removed completely with this commit:
>>
>> b4f37219813f ("net/nfp: Update driver to use global kernel version")
>>
>> CCing Jakub since he was involved, so maybe he can give us some
>> pointers.
>
>Kind regards,
>Alex
>
>>
>> Thanks,
>> Stefano
>>
>> > MODULE_LICENSE("GPL v2");
>> > MODULE_AUTHOR("Asias He");
>> > MODULE_DESCRIPTION("vhost transport for vsock ");
>> >--
>> >2.34.1
>> >
>>
>


