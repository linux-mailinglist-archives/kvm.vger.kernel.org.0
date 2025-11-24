Return-Path: <kvm+bounces-64415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD04C81FC2
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 072103AC568
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9262C178E;
	Mon, 24 Nov 2025 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1IuLzWL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sFsuX66g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C062C1786
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764006908; cv=none; b=J2HdP3TqIFDhpDTAgPOdKzgW5x2R8l7K2EMM6BuHLuoxWl/pYXRmgvZOVvC1c3NTXS7HdYN12ZGi5kVUKIMbhH2DwXvBIxgtSXInHKZXQugH19Qzr6Q1q7bg+NnmWPakZb2Yzn2unz7J8SLolcfCev/fD34/JyOT6BVXbejmXPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764006908; c=relaxed/simple;
	bh=wgpVnEJcnomKN/oNfPAgd5k9GgyVHMXvOCPZyfz69j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJ8ethiS3Redmxa301qyNFbjSsSkVNGN2MSPYN5FjOobJBz821evymoi5lVYm4PNpCo/NWopUvxlF9uyvNI2gSK2KBVuYb7nhOxuL8ucXxkrwnVWBTm7AZL4jlFe05LuY41eaf6O/BnG6E5otFMdE2Zwe4ktAsDJY41elJYRwZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1IuLzWL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sFsuX66g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764006905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWaaNkWE0gvkjn8TKglV+j77gDxp+Cag+Z34d+Rk28I=;
	b=S1IuLzWLbnCCLWzn3bnEIfkhyqqCOgkB7owQy+BUxdzgG+wAOpiubPTLpoApgwq69u+Q0d
	MbLn6/RD3Zir4pjr1kphd46Spq7ja8PHzxAvnLu82AftoqH9/njkuLwxhE03WW5KOgd7Sf
	q124/E+5ovmK80J9ouGR+AbFxXgZo2M=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-TJrEFcc4P7qatPicYUTSbg-1; Mon, 24 Nov 2025 12:55:04 -0500
X-MC-Unique: TJrEFcc4P7qatPicYUTSbg-1
X-Mimecast-MFC-AGG-ID: TJrEFcc4P7qatPicYUTSbg_1764006904
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ee2fd41c2aso62050871cf.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764006904; x=1764611704; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MWaaNkWE0gvkjn8TKglV+j77gDxp+Cag+Z34d+Rk28I=;
        b=sFsuX66grMVLzij28lmvj3RuFf2VZu0c0RZj5hbgilwQI1qBq/h1T8MVYdXVSZYa3n
         Pg1KCm1/e/YEHmO42Gq9fOp6ysA/1bgoWgEWyMmDZPEx24w9qVUhhC2dffcRbS1nHybg
         aw27VWkRwQoaC+iscIT/r3MVND4X0OXteTjNpsAY9TOWjvYuSCCPa+UClzg0uyO/94yR
         dh/bLdBKjcgYH7le/WDa/awz3XjjOhtOtOKx9OZuY884pYBOyUo7JzIu4ilx9pQwdUVN
         HbVAWk4rmbtEJP+/T4SUfXo0zj3VmQC561VAZJzDgDnDmEoYS2IdZFpEZnsog3nZ9DJ8
         1cPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764006904; x=1764611704;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MWaaNkWE0gvkjn8TKglV+j77gDxp+Cag+Z34d+Rk28I=;
        b=qcbbBSCNQllyqMsvFVB9EwEYQyOZloOMdOhMuJ1lQEF3geNWS2X4bXd2mBKvLMFse9
         jKhJdRvfT0WeW769fVFUBA0YcSjJ5HDTHWixkaYxSEW5MThVGuIebWgro4vJc41fWmdL
         Uyr63OOdFMl2rDA4QwU7vFwzlOXOdHfL/UD9FaD7e1sldoUDYDhlSRV+Ew2CaUthg4+c
         UgE/GpvuxJeKVnT7RY793dx7+Aw6weV1KsLmFg0xphy59f82D4mogvkmc5DjdoHhlMfO
         8cuX7P2riGDNTvQ+z+Ns5G/Tya2vKArWnF7CDmO8bNveb26dSQU2vA9QeVJTdgVeJLNc
         tq/g==
X-Forwarded-Encrypted: i=1; AJvYcCUnmPKPc2r/6cmVXmjJLk7xwx74l6W5XUsFvmgGyWVIatpk0bhFWWv2XntB89DM7Lv9ygI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfOiQP814YLZuQaxyCfCgU2eVZLH0ww11QivBd4vTkcO+9IJ1b
	XG8HMSMeIIspUMMli4Ap0iV1aWXVWOtktBBcIiztY2GsOwMfeBTJVcOxwTu/7Y0GqsLJxzZtE7t
	7w9IRIjB2h7fELdzgEH+eqF8+86WOtXk43oSZs5P2myBxv0zpb9OOoPGTeMLmnA==
X-Gm-Gg: ASbGncuf/YCi+VYYO91cchZn8mdCYfkz2KnEaBLMa5btbetVOxxeHYanVTFA6p6qBNZ
	W+1FutjWx12p74W2D+4qbQZUqACpMkgDK+wiPsm/FQTris3you0XHquZLrNAdAJn3QfIe0mgG02
	0G5Y16ImMEubu3UEzkYgCePyTX53vqxSok6y9hwX9W3G8v82fEu+d8BZzpcwpYRZnoadXXzw5jv
	fldYSxYu/+Q0BirJ695iAr57nhM3yNXBMxXSjZZ9SBjI7OUuxtfurlowue5JbCAv1FsiwHGSKW+
	bAOO5skQlHmz5bwH9Es41DQBIOPz4WoLN976+5qXpWWvjGr38xoh+ELdI2oY1wT146rWqj982Sl
	RzNfHrO2r7lX47Yt982XVSU8qscpJsMyXHQPpVvZtG5u7XmnTDQ7lghDGwyX7vA==
X-Received: by 2002:a05:622a:1b86:b0:4ee:87a:56b3 with SMTP id d75a77b69052e-4ee588cb923mr177167441cf.48.1764006903621;
        Mon, 24 Nov 2025 09:55:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8Gf4NTZ93wIDY4fTFcgjXQPdtoiRJrv+CLpyDvCPlHjnxTw3P0ZMr3a2DgpcLW7S43lbwhw==
X-Received: by 2002:a05:622a:1b86:b0:4ee:87a:56b3 with SMTP id d75a77b69052e-4ee588cb923mr177166801cf.48.1764006903119;
        Mon, 24 Nov 2025 09:55:03 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e65e3bsm90774671cf.17.2025.11.24.09.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:55:02 -0800 (PST)
Date: Mon, 24 Nov 2025 18:54:45 +0100
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
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, berrange@redhat.com, 
	Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v11 03/13] vsock: reject bad
 VSOCK_NET_MODE_LOCAL configuration for G2H
Message-ID: <qvu2mgxs7scbuwcb2ui7eh3qe3l7mlcjq6e2favd4aqcs52r2r@oqbrlp4gxdwl>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-3-55cbc80249a7@meta.com>
 <swa5xpovczqucynffqgfotyx34lziccwpqomnm5a7iwmeyixfv@uehtzbdj53b4>
 <aSC3IX81A3UhtD3N@devvm11784.nha0.facebook.com>
 <g4xir3lupnjybh7fqig6xonp32ubotdf3emmrozdm52tpaxvxn@2t4ueynb7hqr>
 <aSSV4RlRcW+uGy+n@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSSV4RlRcW+uGy+n@devvm11784.nha0.facebook.com>

On Mon, Nov 24, 2025 at 09:29:05AM -0800, Bobby Eshleman wrote:
>On Mon, Nov 24, 2025 at 11:10:19AM +0100, Stefano Garzarella wrote:
>> On Fri, Nov 21, 2025 at 11:01:53AM -0800, Bobby Eshleman wrote:
>> > On Fri, Nov 21, 2025 at 03:24:25PM +0100, Stefano Garzarella wrote:
>> > > On Thu, Nov 20, 2025 at 09:44:35PM -0800, Bobby Eshleman wrote:

[...]

>> >
>> > > Since I guess we need another version of this patch, can you check the
>> > > commit description to see if it reflects what we are doing now
>> > > (e.g vhost is not enabled)?
>> > >
>> > > Also I don't understand why for vhost we will enable it later, but for
>> > > virtio_transport and vsock_loopback we are enabling it now, also if this
>> > > patch is before the support on that transports. I'm a bit confused.
>> > >
>> > > If something is unclear, let's discuss it before sending a new version.
>> > >
>> > >
>> > > What I had in mind was, add this patch and explain why we need this new
>> > > callback (like you did), but enable the support in the patches that
>> > > really enable it for any transport. But maybe what is not clear to me is
>> > > that we need this only for G2H. But now I'm confused about the discussion
>> > > around vmci H2G. We decided to discard also that one, but here we are not
>> > > checking that?
>> > > I mean here we are calling supports_local_mode() only on G2H IIUC.
>> >
>> > Ah right, VMCI broke my original mental model of only needing this check
>> > for G2H (originally I didn't realize VMCI was H2G too).
>> >
>> > I think now, we actually need to do this check for all of the transports
>> > no? Including h2g, g2h, local, and dgram?
>> >
>> > Additionally, the commit description needs to be updated to reflect that.
>>
>> Let's take a step back, though, because I tried to understand the problem
>> better and I'm confused.
>>
>> For example, in vmci (G2H side), when a packet arrives, we always use
>> vsock_find_connected_socket(), which only searches in GLOBAL. So connections
>> originating from the host can only reach global sockets in the guest. In
>> this direction (host -> guest), we should be fine, right?
>>
>> Now let's consider the other direction, from guest to host, so the
>> connection should be generated via vsock_connect().
>> Here I see that we are not doing anything with regard to the source
>> namespace. At this point, my question is whether we should modify
>> vsock_assign_transport() or transport->stream_allow() to do this for each
>> stream, and not prevent loading a G2H module a priori.
>>
>> For example, stream_allow() could check that the socket namespace is
>> supported by the assigned transport. E.g., vmci can check that if the
>> namespace mode is not GLOBAL, then it returns false. (Same thing in
>> virtio-vsock, I mean the G2H driver).
>>
>> This should solve the guest -> host direction, but at this point I wonder if
>> I'm missing something.
>
>For the G2H connect case that is true, but the situation gets a little
>fuzzier on the G2H RX side w/ VMADDR_CID_ANY listeners.
>
>Let's say we have a nested system w/ both virtio-vsock and vhost-vsock.
>We have a listener in namespace local on VMADDR_CID_ANY. So far, no
>transport is assigned, so we can't call t->stream_allow() yet.
>virtio-vsock only knows of global mode, so its lookup will fail (unless

What is the problem of failing in this case?
I mean, we are documenting that G2H will not be able to reach socket in 
namespaces with "local" mode. Old (and default) behaviour is still 
allowing them, right?

I don't think it conflicts with the definition of “local” either, 
because these connections are coming from outside, and the user doesn't 
expect to be able to receive them in a “local” namespace, unless there 
is a way to put the device in the namespace (as with net). But this 
method doesn't exist yet, and by documenting it sufficiently, we can say 
that it will be supported in the future, but not for now.

>we hack in some special case to virtio_transport_recv_pkt() to scan
>local namespaces). vhost-vsock will work as expected. Letting local mode
>sockets be silently unreachable by virtio-vsock seems potentially
>confusing for users. If the system were not nested, we can pre-resolve
>VMADDR_CID_ANY in bind() and handle things upfront as well. Rejecting
>local mode outright is just a broad guardrail.

Okay, but in that case, we are not supporting “local” mode too, but we 
are also preventing “global” from being used on these when we are in a 
nested environment. What is the advantage of this approach?

>
>If we're trying to find a less heavy-handed option, we might be able to
>do the following:
>
>- change bind(cid) w/ cid != VMADDR_CID_ANY to directly assign the 
>transport
>  for all socket types (not just SOCK_DGRAM)

That would be nice, but it wouldn't solve the problem with 
VMADDR_CID_ANY, which I guess is the use case in 99% of cases.

>
>- vsock_assign_transport() can outright fail if !t->supports_local_mode()
>  and sock_net(sk) has mode local

But in this case, why not reusing stream_allow() ?

>
>- bind(VMADDR_CID_ANY) can maybe print (once) to dmesg a warning that
>  only the H2G transport will land on VMADDR_CID_ANY sockets.

mmm, I'm not sure about that, we should ask net maintainer, but IMO 
documenting that in af_vsock.c and man pages should be fine, till G2H 
will support that.

>
>I'm certainly open to other suggestions.

IMO we should avoid the failure when loading G2H, which is more 
confusing than just discard connection from the host to a "local" 
namespace. We should try at least to support the "global" namespace.

Thanks,
Stefano


