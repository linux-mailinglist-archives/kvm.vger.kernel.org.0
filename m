Return-Path: <kvm+bounces-64480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B24C84357
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF1293AFEF0
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA63B2E6CA0;
	Tue, 25 Nov 2025 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LRGZkZ5B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAf0C06b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21003287511
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764062706; cv=none; b=ad4q8qp+/EWVflzeCrkKGJ/zPUpTDTKyVOO2ywtrdn3n38L1eclw+IwrrtbVgjFwAfZHhRNdwbtP7DsQRrpS1yL6uPJng+55WF6hZ8i+Dpf7mxZxORb1jqbv0rMF14C051uxj/Z1SMk49GyM/afu7FNBfDGcwbiIvyCBbtuLOwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764062706; c=relaxed/simple;
	bh=hjHfVR6JY50I/PUS5QXDEWVC2vBDOcIlWiJtzvzvF00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0CrgCzoKnYO0/PO/3+yDPctpE0E10rBE/ZVv8cBboOJ8ZsXqjkE9v3QQIrrgNFxwZUW2PDXkXLutibEpm390Q1dtxE9hpXdBZJeqDTEt9Cl2jwBMY3Of4nQCJhZXiJg7yNgVl/+6QkwSCeetsgmuAv2NRAE0nmKlT8yIlCE534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LRGZkZ5B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XAf0C06b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764062704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H+N/esHuq8L2QAewoJC5E7AAXPZDfyRFaWXpHRgQYro=;
	b=LRGZkZ5B6/hrveJK8PSDVn3iHLqPVEdhNbMh/kJ2m0hWiutIhHWpQV4SHHyeSLvj6Hwz3m
	plSgfO61g0DhJrCAzBW3/6tSFwhS9wcduwvXMuyxLfPbfIWUDR9yThYFjmQYMnjkCLODwT
	1hH+FHmcy6hGEBcxUMfyLgcvFkfd+H8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-hiW49PbgNBunnWgHO2jSBA-1; Tue, 25 Nov 2025 04:25:00 -0500
X-MC-Unique: hiW49PbgNBunnWgHO2jSBA-1
X-Mimecast-MFC-AGG-ID: hiW49PbgNBunnWgHO2jSBA_1764062700
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b366a76ffso2464568f8f.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 01:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764062699; x=1764667499; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H+N/esHuq8L2QAewoJC5E7AAXPZDfyRFaWXpHRgQYro=;
        b=XAf0C06bcnZU5GQBpnYc/ujSfbP4jG6w/4pSicwNvfsYD41SZDdgNtSWBxEaO7GLyC
         dAxnJgeH/qrnjHGZW3p+lFjvyfhH86XdG1JNTfujquhjICMEfbX7TUhhOsFjb0nI/jUx
         tap79FJrryKktv5PcOQM0FmtAHgtlaOiiMy9jE/wYHVSOD1EzHao6fWUIoKg210233x5
         OPNHn2X92FReS6CHDhyUUcrfZWglSBv8NcaW9ROB+agdwfufqZ08Q5YM3I/1NaQG1Tys
         z/AvlIWfGDluYvXOQa26O3GC85VKHu/qJvoiqojKTNe/HtfwjthDGpxvr/BmS/mm/96p
         +AQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764062699; x=1764667499;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+N/esHuq8L2QAewoJC5E7AAXPZDfyRFaWXpHRgQYro=;
        b=gid4XfmKDM6qS+zhKrkM09oin6hIK3msYKmfeWKDW3g9JiIstYf4ulo3ZuPXP4lmza
         K4qSSSF0AgpbCMHC7JSZwBUjCsCnhOkHV/KvaZPywKhQHZ7gEp9/+chNWy26b9yMEkkq
         CHmE03Yqbvr+IQ4iuC3e362VIZMjggcM6VM52KAkl1J4EL05qq3dQV2TQx5inZcCgT0X
         hT2DEviPPa633lUhgyfPLSNPshdlqPhmSoq7OR0ABUeoQeFhILpcEEjq+K3uCXneoKBZ
         brG0XK8pVdHeg6JnsBOpRYKJA5NkR04jScNeT/znp9x07WKz2xu7lzpr40jEl0Tj73Kj
         GRKA==
X-Forwarded-Encrypted: i=1; AJvYcCXF8Bpc/0cdsxWindHaYgCnROyheAAfAWwbzdgRTt+hPSTRbdUwzprNcX+17W+XehVn090=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFipu8stz+6iN8zmkkuxhqrlIPrmme07ieSFrVpb5NhgY8vw/Z
	rAoQdWLD1yu0fTrDr0WIBC9NWppJUNt6RS5bEaOnvBYnbXH/U+Xqr5xGUyZVnX11vV+e6Za2RAN
	DSmsujb3xfTKHiUvMr6PbcZH8gRBzzQrT63Z1IoR3adb2kKqFbn/SFQ==
X-Gm-Gg: ASbGnct+oRymPqSx+QnzfQjVcpGuHkCr/dr3DBZJ3uOJH4vDWTL1+kA8Mo3G/hifUn4
	iYw/ql7BWZyewHykWFSLWeV/e4BG1qAtRFWkpnUtpaMrhXIJC2eTUZxB6OH8RPnDbDSi+Yo9VwS
	yHXn1ePhsFJnW2+p+Vv9VjUV6RoltDHT+SaCxSJz69ahL/5tZP5N9CiQwDY9hDVYukPlLyyrF9d
	H8S5P5Ez6LyfT7p0fozhua+0C3z4lcSzSMjc+ZK0ztBjXgl+1cBI4jN2trYEBy6RO9wkn57Y22V
	527aCieQZoA1d6QugmNT9FC9UEo3I4P6nIwS0AshxedlzXqgYDxmtFCF925IsXArZDpciAOkaUH
	zk8GKLly22ftcpzYF7d3jZCBEUP0TDgIy6h57oRfWjk2npdoWIprEgRNm8Hdusw==
X-Received: by 2002:a05:6000:3109:b0:42b:3592:1b88 with SMTP id ffacd0b85a97d-42e0f350255mr1946076f8f.50.1764062699440;
        Tue, 25 Nov 2025 01:24:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFOINmS8NH5yU9ZL8Nf4fEf6WMmOdQHifzU7OMqNv6Owof/NynMw2jUGB1PZoQSH+fj3xbBUw==
X-Received: by 2002:a05:6000:3109:b0:42b:3592:1b88 with SMTP id ffacd0b85a97d-42e0f350255mr1946011f8f.50.1764062698849;
        Tue, 25 Nov 2025 01:24:58 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb91f4sm33924782f8f.31.2025.11.25.01.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 01:24:58 -0800 (PST)
Date: Tue, 25 Nov 2025 10:24:35 +0100
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
Message-ID: <btejwapjdpapzk2jldxzffswbaqvsh4f5nb46otrghortyqbi2@2gdsthrxibjl>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-3-55cbc80249a7@meta.com>
 <swa5xpovczqucynffqgfotyx34lziccwpqomnm5a7iwmeyixfv@uehtzbdj53b4>
 <aSC3IX81A3UhtD3N@devvm11784.nha0.facebook.com>
 <g4xir3lupnjybh7fqig6xonp32ubotdf3emmrozdm52tpaxvxn@2t4ueynb7hqr>
 <aSSV4RlRcW+uGy+n@devvm11784.nha0.facebook.com>
 <qvu2mgxs7scbuwcb2ui7eh3qe3l7mlcjq6e2favd4aqcs52r2r@oqbrlp4gxdwl>
 <aSSjNLrRmaOLkuBN@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSSjNLrRmaOLkuBN@devvm11784.nha0.facebook.com>

On Mon, Nov 24, 2025 at 10:25:56AM -0800, Bobby Eshleman wrote:
>On Mon, Nov 24, 2025 at 06:54:45PM +0100, Stefano Garzarella wrote:
>> On Mon, Nov 24, 2025 at 09:29:05AM -0800, Bobby Eshleman wrote:
>> > On Mon, Nov 24, 2025 at 11:10:19AM +0100, Stefano Garzarella wrote:
>> > > On Fri, Nov 21, 2025 at 11:01:53AM -0800, Bobby Eshleman wrote:
>> > > > On Fri, Nov 21, 2025 at 03:24:25PM +0100, Stefano Garzarella wrote:
>> > > > > On Thu, Nov 20, 2025 at 09:44:35PM -0800, Bobby Eshleman wrote:
>>
>> [...]
>>
>> > > >
>> > > > > Since I guess we need another version of this patch, can you check the
>> > > > > commit description to see if it reflects what we are doing now
>> > > > > (e.g vhost is not enabled)?
>> > > > >
>> > > > > Also I don't understand why for vhost we will enable it later, but for
>> > > > > virtio_transport and vsock_loopback we are enabling it now, also if this
>> > > > > patch is before the support on that transports. I'm a bit confused.
>> > > > >
>> > > > > If something is unclear, let's discuss it before sending a new version.
>> > > > >
>> > > > >
>> > > > > What I had in mind was, add this patch and explain why we need this new
>> > > > > callback (like you did), but enable the support in the patches that
>> > > > > really enable it for any transport. But maybe what is not clear to me is
>> > > > > that we need this only for G2H. But now I'm confused about the discussion
>> > > > > around vmci H2G. We decided to discard also that one, but here we are not
>> > > > > checking that?
>> > > > > I mean here we are calling supports_local_mode() only on G2H IIUC.
>> > > >
>> > > > Ah right, VMCI broke my original mental model of only needing this check
>> > > > for G2H (originally I didn't realize VMCI was H2G too).
>> > > >
>> > > > I think now, we actually need to do this check for all of the transports
>> > > > no? Including h2g, g2h, local, and dgram?
>> > > >
>> > > > Additionally, the commit description needs to be updated to reflect that.
>> > >
>> > > Let's take a step back, though, because I tried to understand the problem
>> > > better and I'm confused.
>> > >
>> > > For example, in vmci (G2H side), when a packet arrives, we always use
>> > > vsock_find_connected_socket(), which only searches in GLOBAL. So connections
>> > > originating from the host can only reach global sockets in the guest. In
>> > > this direction (host -> guest), we should be fine, right?
>> > >
>> > > Now let's consider the other direction, from guest to host, so the
>> > > connection should be generated via vsock_connect().
>> > > Here I see that we are not doing anything with regard to the source
>> > > namespace. At this point, my question is whether we should modify
>> > > vsock_assign_transport() or transport->stream_allow() to do this for each
>> > > stream, and not prevent loading a G2H module a priori.
>> > >
>> > > For example, stream_allow() could check that the socket namespace is
>> > > supported by the assigned transport. E.g., vmci can check that if the
>> > > namespace mode is not GLOBAL, then it returns false. (Same thing in
>> > > virtio-vsock, I mean the G2H driver).
>> > >
>> > > This should solve the guest -> host direction, but at this point I wonder if
>> > > I'm missing something.
>> >
>> > For the G2H connect case that is true, but the situation gets a little
>> > fuzzier on the G2H RX side w/ VMADDR_CID_ANY listeners.
>> >
>> > Let's say we have a nested system w/ both virtio-vsock and vhost-vsock.
>> > We have a listener in namespace local on VMADDR_CID_ANY. So far, no
>> > transport is assigned, so we can't call t->stream_allow() yet.
>> > virtio-vsock only knows of global mode, so its lookup will fail (unless
>>
>> What is the problem of failing in this case?
>> I mean, we are documenting that G2H will not be able to reach socket in
>> namespaces with "local" mode. Old (and default) behaviour is still allowing
>> them, right?
>>
>> I don't think it conflicts with the definition of “local” either, because
>> these connections are coming from outside, and the user doesn't expect to be
>> able to receive them in a “local” namespace, unless there is a way to put
>> the device in the namespace (as with net). But this method doesn't exist
>> yet, and by documenting it sufficiently, we can say that it will be
>> supported in the future, but not for now.
>>
>> > we hack in some special case to virtio_transport_recv_pkt() to scan
>> > local namespaces). vhost-vsock will work as expected. Letting local mode
>> > sockets be silently unreachable by virtio-vsock seems potentially
>> > confusing for users. If the system were not nested, we can pre-resolve
>> > VMADDR_CID_ANY in bind() and handle things upfront as well. Rejecting
>> > local mode outright is just a broad guardrail.
>>
>> Okay, but in that case, we are not supporting “local” mode too, but we are
>> also preventing “global” from being used on these when we are in a nested
>> environment. What is the advantage of this approach?
>>
>> >
>> > If we're trying to find a less heavy-handed option, we might be able to
>> > do the following:
>> >
>> > - change bind(cid) w/ cid != VMADDR_CID_ANY to directly assign the
>> > transport
>> >  for all socket types (not just SOCK_DGRAM)
>>
>> That would be nice, but it wouldn't solve the problem with VMADDR_CID_ANY,
>> which I guess is the use case in 99% of cases.
>>
>> >
>> > - vsock_assign_transport() can outright fail if !t->supports_local_mode()
>> >  and sock_net(sk) has mode local
>>
>> But in this case, why not reusing stream_allow() ?
>>
>> >
>> > - bind(VMADDR_CID_ANY) can maybe print (once) to dmesg a warning that
>> >  only the H2G transport will land on VMADDR_CID_ANY sockets.
>>
>> mmm, I'm not sure about that, we should ask net maintainer, but IMO
>> documenting that in af_vsock.c and man pages should be fine, till G2H will
>> support that.
>>
>> >
>> > I'm certainly open to other suggestions.
>>
>> IMO we should avoid the failure when loading G2H, which is more confusing
>> than just discard connection from the host to a "local" namespace. We should
>> try at least to support the "global" namespace.
>>
>> Thanks,
>> Stefano
>
>
>I'm 100% fine with that approach. I just wanted to make sure we landed
>in the right place for how users may encounter places that there is no
>local mode support.

Yeah, I see, thanks for that!

>
>So for next steps, we can drop this patch and add explicit logic in
>->stream_allow() to allow local mode for vhost/loopback and reject for
>others?

Yep, I would add the logic in the "vsock: add netns to vsock core" 
patch, including the changes to stream_allow(), supporting in all 
transports only the global mode. In the next patches we can support 
`local` mode in related transports (I guess for now just loopback and 
vhost-vsock).

> Plus, add documentation about what happens for VMADDR_CID_ANY
>(will only receive vhost/loopback traffic in local mode)?

I'd document that in af_vsock.c when we talk about "local". I'll make it 
clear that not all transports support it, and we can mention that 
example.

When we will merge this series, we should also send a patch to the 
vsock(7) manpage [1] to describe namespace support because I guess that 
will be the entry point of the user.

Thanks,
Stefano

[1] 
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man/man7/vsock.7


