Return-Path: <kvm+bounces-63024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5E2C58AAF
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 17:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 47AB64ECFBE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632842F6190;
	Thu, 13 Nov 2025 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZqQIL5/3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wts+n/uy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F5A2F60AC
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763047900; cv=none; b=Igh7wJ5cyd7c8Il5hSsA0MLxU+WH0gNinHS6kJIaajDV4fgzvLcnZIiCQ2Nlpqc6hiad31veLAT+d96CH2XuDQvo8bP2Y9XKn8pakTyOKaKEaSlC65Fxz6Qr9pnAhQKYO63mswDoPgfzF+JNRX4GFKC9MTxca9TBWz3Kr60rNwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763047900; c=relaxed/simple;
	bh=cmUw5fQytCW5K8CgA+45UI+EqXpRzL3G2UrLV2MjQf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icut120aZfVoQwH8RTTIAa+jpDZNF0BI/NS2P/7ihgd7YHDfDXcxpeQp3tCZ9gpqv35+JcTs8QIkJkl6wPnFtQZi7kx4FoiLo/1/HcE4pfOyLOTODAeXEtMpCELs1zIc+p9RaAybXVlXXfYgG8ryMfM+GdsqrFFU11S6JqzMSJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZqQIL5/3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wts+n/uy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763047898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z7XY31OsyOl8v7j52xmkmb5uEiW5I0tIphYxwIfznBM=;
	b=ZqQIL5/3UTREq+0mfpv6OtJWi17VumrYh3NOh5gTr46SWoFYNsCu3Wt2zFsfOkKDxt/WEH
	qzVwtd9JiiSztULsRmCqbVwM3awgaOhBKGKJvaQpdFg9i/kDVIqFUPvfxZ+GMJanUJUO38
	z7a0t4H5IRaE37JyQj3+aYEsGLh25NE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-67xLNZYvPeyS4rMwTes6mg-1; Thu, 13 Nov 2025 10:31:36 -0500
X-MC-Unique: 67xLNZYvPeyS4rMwTes6mg-1
X-Mimecast-MFC-AGG-ID: 67xLNZYvPeyS4rMwTes6mg_1763047896
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b72a8546d73so115958966b.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 07:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763047895; x=1763652695; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7XY31OsyOl8v7j52xmkmb5uEiW5I0tIphYxwIfznBM=;
        b=Wts+n/uyvcUEotTfun8PRRCrASIZGOOHVkTuyYceI7X8bx2pYg0FLaS8sVQGFNTYp7
         AjZFRDNBL6HVJTcTmZmjNQfUsXT4E/+IfRDUPGEuOd69Jfzcx48g6LYVBz/QZ+NtLU8W
         OS8KVPe4lmiJh0brRUYwjj46Sehjg0U/pmOk1h1wreE8QJGBrdGHjU2BaKQ035SfgOOc
         YWS/sP5RCj1xE6S158ZsLv+wXrsaBNsV9ap1T5U+SL6cnsAGb/n7MetzoGVKD98FoPTI
         08vyJEP4MYxeeBKRekzgXZIxolO5mAHhk06b2wfyZIl9Aq2AqtJvIyFT4/WPsXalKB/8
         fnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763047895; x=1763652695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7XY31OsyOl8v7j52xmkmb5uEiW5I0tIphYxwIfznBM=;
        b=o3y8fKwPTEq9y241eqfsYlJaiB0RT2ncnVVUSQxYaQOXONivhNZcu/Ejqkt9AGfMgd
         0CenQ6rr1HOucdXwRshLL4WawY9/uKIN+ooka2FXvMcTYdgpAQ62Anoum8fcPgTt1L0A
         2WJehmLfgpO1x4Wx7GA8FnOl7tpSJMusBAgCUvoAguobyLzo6mYO19nyuKCNRT1H+9Mn
         CDQ1m0zJJiMJ/x3andHJ9BVw1y36RIVRS6LYKzqMW+Al1OwShlwuoIQQiLFoAu2yABY8
         I6damB+7rWgRHGa1WXI289FGh3Uz4lFRli4OeWY4frgtfXhJaq6/Q8YLBTx6ATF5XmjR
         VeMA==
X-Forwarded-Encrypted: i=1; AJvYcCWDvAGprlUepUdjQJnDoV3Wwv2Uf58J7aowaaO3yavHTcNs55rEYD2BbxNYcKOCNHi0ENE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj6Qo3tUJolwh6YBpIFWIMESfzKm4USQSQH5P/HLtLJsT0HGA7
	vs/MYQRACmSOslZmDqLtWj+N7fNLvi7mX6qkK/38WicCZ8DamGq2GTdrD1wq3GEfrkSTIES6O5Z
	UG/X1xRxdzqxp8UzRhP2xxs2kcxMZVqncxCAIcvRcFIn4XJJSxbjGFQ==
X-Gm-Gg: ASbGncuQY0nNlMEt+w/9RS2cChj6IPtlASkeKLHjnwMCWOPdVYqXYhztxwIpMLGf2Jg
	NcVEUdwTn/nJXBz/ccw/dluGevX6/nQ2KKuqYXFRYWQMCP9SO/kN7igYTjF49yCBza/GL2Oz3a7
	/8eC7DH0/0Pm0EtNzHOYkhHO+hzQzcNu8o72EY9XRxOHmwNNQ/7vdUzzGzKdgfGC7wHoIHdQMz8
	hPBk9+kiEXt9CuwXMR7l5rQ2NR0j5ILtb4N5ERby7mS9PR4MwKZWiRK3y6y3fC0VZp7hAYGasfM
	AvtZagfORORn9OAcslGSu44HuFNtkQN6hc+ialIhyxd9u9oHaJMTngeW0ZebZxlaabsTUU/dtLl
	OsB8l0hr2NBi36NZX/7hBNxOZqY6KdQYnDoFa2ok/2tMh+K1iFQM=
X-Received: by 2002:a17:907:c06:b0:b70:6d3a:a08b with SMTP id a640c23a62f3a-b733192f5c5mr808714366b.10.1763047895382;
        Thu, 13 Nov 2025 07:31:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8lpe22E3h1TC8hEnHCzisPSR4qLMl80qiAEbaySsAUvtzhvgQRLYBeX2TaGg4WnRojfXASw==
X-Received: by 2002:a17:907:c06:b0:b70:6d3a:a08b with SMTP id a640c23a62f3a-b733192f5c5mr808708566b.10.1763047894844;
        Thu, 13 Nov 2025 07:31:34 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-153.retail.telecomitalia.it. [79.46.200.153])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad3edasm184936266b.17.2025.11.13.07.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:31:34 -0800 (PST)
Date: Thu, 13 Nov 2025 16:31:28 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v9 03/14] vsock/virtio: add netns support to
 virtio transport and virtio common
Message-ID: <ym7us45wytkmibod5fkxoyss3nl4kxzehlchdm4pqnvvnzreey@dvuwn7olusc2>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-3-852787a37bed@meta.com>
 <cah4sqsqbdp52byutxngl3ko44kduesbhan6luhk3ukzml7bs6@hlv4ckunx7jj>
 <aRSyPqNo1LhqGLBq@devvm11784.nha0.facebook.com>
 <bhc6s7anskmnnrnpp2r3xzjbesadsex24kmyi5tvsgup7c2rfi@arj4iw5ndnr3>
 <aRTg4/HyOOhYYMzp@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aRTg4/HyOOhYYMzp@devvm11784.nha0.facebook.com>

On Wed, Nov 12, 2025 at 11:32:51AM -0800, Bobby Eshleman wrote:
>On Wed, Nov 12, 2025 at 06:39:22PM +0100, Stefano Garzarella wrote:
>> On Wed, Nov 12, 2025 at 08:13:50AM -0800, Bobby Eshleman wrote:
>> > On Wed, Nov 12, 2025 at 03:18:42PM +0100, Stefano Garzarella wrote:
>> > > On Tue, Nov 11, 2025 at 10:54:45PM -0800, Bobby Eshleman wrote:
>> > > > From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>[...]
>
>> > > If it simplifies, I think we can eventually merge all changes to transports
>> > > that depends on virtio_transport_common in a single commit.
>> > > IMO is better to have working commits than better split.
>> >
>> > That would be so much easier. Much of this patch is just me trying to
>> > find a way to keep total patch size reasonably small for review... if
>> > having them all in one commit is preferred then that makes life easier.
>> >
>> > The answer to all of the above is that I was just trying to make the
>> > virtio_common changes in one place, but not break bisect/build by
>> > failing to update the transport-level call sites. So the placeholder
>> > values are primarily there to compile.
>>
>> In theory, they should compile, but they should also properly behave.
>>
>> BTW I strongly believe that having separate commits is a great thing, but we
>> shouldn't take things to extremes and complicate our lives when things are
>> too closely related, as in this case.
>>
>> There is a clear dependency between these patches, so IMO, if the patch
>> doesn't become huge, it's better to have everything together. (I mean
>> between dependencies with virtio_transport_common).
>
>Sounds good, let's give the combined commit a go, I think the
>transport-specific pieces are small enough for it to not balloon?

Yeah, I think so.

>
>> What we could perhaps do is have an initial commit where you make the
>> changes, but the behavior remains unchanged (continue to use global
>> everywhere, as for virtio_transport.c in this patch), and then specific
>> commits to just enable support for local/global.
>>
>> Not sure if it's doable, but I'd like to remove the placeholders if
>> possibile. Let's discuss more about it if there are issues.
>
>Sounds good, I'll come back to this thread if the combined commit
>approach above balloons. For the combined commit, should the change log
>start at "Changes in v10" with any new changes, mention combining +
>links to the v9 patches that were combined?

Yep, that would be great. Plus exaplaining why we decided to do that (I 
mean just in the changelog).

Thanks,
Stefano


