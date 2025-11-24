Return-Path: <kvm+bounces-64389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2FEC80A3A
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 14:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AED6C4E4F67
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FF92FC88B;
	Mon, 24 Nov 2025 13:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTT6Rd5u";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/3U7RqK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5447F302140
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989365; cv=none; b=etwdfLbQ70vrnJnSw81IyP7RqYThZcyYsd794ILywNjQdeFekK7KI3I21hmAvL+0O2jC4rVDk2mrSDRlljvtlk849EFaC1xrD2xT2qFvU92JsspSePsP7jjtmVPMB47QS+qtb/7Odgy0PJsDfmnyQZGPVKBDqroVVBNFdce70Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989365; c=relaxed/simple;
	bh=/PVux6/qhCM5j7QxIjZ3C4HJECU8mM2bPzRAiDoZo58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kN+Wl8pQP6pwkr+JstOKexymj4ZvVLIS9oNk/rwVkmk45TDQYCp+PY2NEkVukgsaWwEle5Wea4UfhZ3MwtgKqfPUG4ajBQJbesE8/wr0PR+dTGooX+NJ6YEV91/mh67qB7mAwC3P+90iRme0LkgG0jDGSe9COytqO6nve2vkKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bTT6Rd5u; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/3U7RqK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763989361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S6hJnZw3kn5s0TB1aRyIXGCws54UxhojaW//4vyMORM=;
	b=bTT6Rd5udepofJVsC+L7PBT8sq55uOovQ3BWHbvelnH3XJKnUi8wKLHrP3BzAqb3kWHTH7
	SL9CAVrJyv3cvYt6qehKKXInRGRcl8DG+pvFB2xNYN4r0efRIws9v6WfQwJ+ooECJ+riK5
	g4ORvHliOtCoyaRFZOtiXDCKRFW3aYA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-Dzy8XwvbMAKfUrKskCZbsw-1; Mon, 24 Nov 2025 08:02:39 -0500
X-MC-Unique: Dzy8XwvbMAKfUrKskCZbsw-1
X-Mimecast-MFC-AGG-ID: Dzy8XwvbMAKfUrKskCZbsw_1763989358
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b763b24f278so321717166b.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 05:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763989358; x=1764594158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S6hJnZw3kn5s0TB1aRyIXGCws54UxhojaW//4vyMORM=;
        b=M/3U7RqKwoX/HQ6+7Z+Hm4PIr+G5jC0MLb61qrWXNCW+jJ8QW4rLemQ5VX4SooPW/N
         9QpiAyFMEE+gOwQF9rxJa0/d8CiCuvq/8QUYzhy+XMhoNXNDr9O4OlfIvknFF+b2PqW4
         F/HlCxuyjj6F9Geis6aAICSo6bFY8YSDn1lxNUwin+86ntEaZPE7HWHpnSh6PCXuSpS+
         s7WobXG29eFEcW92QiHagmY/jIev8ATdzvFjqvoAUrjBOeF+KyIxqN2YeKD9BwpKP/rf
         9kTWVN/XWqSicoJPnF/MK9EUhVcnOd7F6HZ7+dQ17jyzu0rr/sGNYMDoFliIJcJqOJ2H
         eDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763989358; x=1764594158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6hJnZw3kn5s0TB1aRyIXGCws54UxhojaW//4vyMORM=;
        b=Gw5qlCej95I8L3cz/wICYW8MRboUG+TuOa9TujyWFJTdhGuod1jAIIf1Ht5O5ydhzP
         bJhxUiy8ZBFdoN4IWO6kDuiJZtwmUkciW/vveR15YTnTSqzASMG2BRUPLAMItvmoE0AE
         P8f9X1mPjgsRyGH+M4OLIx0GLCskWzu7Ee6E6z6OyQWBy28hGKdhQFJ/RxIZ0cRkj+oe
         n++XA1gU8w2TdbxRQXqETqP44J50lL6nF4EBl7fdkWiSPTST6uCkQmu0EYHZJzdMLgJU
         m8LvRKf0gWyKB6q/YNT+hsdkKbs6K7VoQI8hGTjoNRJ6jA/5ou6nsF0Mp9MY+tpzelfr
         9VyA==
X-Forwarded-Encrypted: i=1; AJvYcCW04wBJv6fT9WwFg2wPPZq5I9DeISHULTC/Jhj8d9iD5LXrLh1jqqnj6u6wiNCZe43QjGE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5F4NEvRxdwfp4H8ygQDEp/hK1khiyVgZYoZd7LTlutVW7uieM
	to6dFiJCRI+55YznHKsH74JB2s66BE5kbxYO0+NhciSps65N5HzC62G0ZuEqrqDxP3RcAFAS8o2
	3pWVzgiWpa0qlNBdYcNPgdR9+zZAl90tl/vu/IsCFDj0t8QsbzFfn1A==
X-Gm-Gg: ASbGncswxHUPWDEQ32Zlu3vTg2jkRnrNOe4qbgvVjFI+2IHwtl3Tdx2+hnYF0tsN6sX
	+onaK6qMo6babt2ldvnjC8X/noqx97qV1CWT8wtlJsvASFyP73bdo6XoxpBcpeXAU8MQMRDXoFc
	zeDFGxaLLZbnugmjrO9/rpISPg3LnK9rQK2mDFm8M5+l7Ws606gpamAQqMskaOqm44QSlO0KzG2
	sRCyvfaOpxfK8CB1P7P1NLxb8nYz/wRXUGBfYiYb4mNwLdkYuRecEX6Z1rWN/v6pwwosE0HgxdX
	/xzA/EkPrkBzpej5mV4OOW8ZFKxdU63b0Fj6PKxop8il0qgrvPLeiLxfSR8WSrCESF1+EMOfMNl
	6iMIAzi2CWU6j1FpZfOAvupMJCeIFDUd1qmsoa3djmCYwIsv34UuvlBYzVT2Ikw==
X-Received: by 2002:a17:907:d93:b0:b73:806c:bab2 with SMTP id a640c23a62f3a-b76716d9e43mr1032884766b.33.1763989357988;
        Mon, 24 Nov 2025 05:02:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6ykVWPpSwinXanlRQWJeJ0XHFosSyO4ErfL2/mdTAE1Kjbm2jyYgIoPoi+6fsdx/pUINlNw==
X-Received: by 2002:a17:907:d93:b0:b73:806c:bab2 with SMTP id a640c23a62f3a-b76716d9e43mr1032879766b.33.1763989357321;
        Mon, 24 Nov 2025 05:02:37 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76a6bcfad2sm303348166b.68.2025.11.24.05.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 05:02:36 -0800 (PST)
Date: Mon, 24 Nov 2025 14:02:29 +0100
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
Subject: Re: [PATCH net-next v11 05/13] vsock: add netns support to virtio
 transports
Message-ID: <fa5j32kwvwitddkhbuenwqygtue3j2i4kquzl4lsnlp42y244z@zijsgsjjvido>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-5-55cbc80249a7@meta.com>
 <v6dpp4j4pjnrsa5amw7uubbqtpnxb4odpjhyjksr4mqes2qbzg@3bsjx5ofbwl4>
 <aSC3lwPvj0G6L8Sh@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aSC3lwPvj0G6L8Sh@devvm11784.nha0.facebook.com>

On Fri, Nov 21, 2025 at 11:03:51AM -0800, Bobby Eshleman wrote:
>On Fri, Nov 21, 2025 at 03:39:25PM +0100, Stefano Garzarella wrote:
>> On Thu, Nov 20, 2025 at 09:44:37PM -0800, Bobby Eshleman wrote:
>> > From: Bobby Eshleman <bobbyeshleman@meta.com>
>> >
>> > Add netns support to loopback and vhost. Keep netns disabled for
>> > virtio-vsock, but add necessary changes to comply with common API
>> > updates.
>> >
>> > This is the patch in the series when vhost-vsock namespaces actually
>> > come online.  Hence, vhost_transport_supports_local_mode() is switched
>> > to return true.
>> >
>> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>> > ---
>> > Changes in v11:
>> > - reorder with the skb ownership patch for loopback (Stefano)
>> > - toggle vhost_transport_supports_local_mode() to true
>> >
>> > Changes in v10:
>> > - Splitting patches complicates the series with meaningless placeholder
>> >  values that eventually get replaced anyway, so to avoid that this
>> >  patch combines into one. Links to previous patches here:
>> >  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-3-852787a37bed@meta.com/
>> >  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-6-852787a37bed@meta.com/
>> >  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-7-852787a37bed@meta.com/
>> > - remove placeholder values (Stefano)
>> > - update comment describe net/net_mode for
>> >  virtio_transport_reset_no_sock()
>> > ---
>> > drivers/vhost/vsock.c                   | 47 ++++++++++++++++++------
>> > include/linux/virtio_vsock.h            |  8 +++--
>> > net/vmw_vsock/virtio_transport.c        | 10 ++++--
>> > net/vmw_vsock/virtio_transport_common.c | 63 ++++++++++++++++++++++++---------
>> > net/vmw_vsock/vsock_loopback.c          |  8 +++--
>> > 5 files changed, 103 insertions(+), 33 deletions(-)
>>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>
>If we move the supports_local_mode() changes into this patch (for virtio
>and loopback, as I bring up in other discussion), should I drop this
>trailer or carry it forward?

I'll take a second look in any case, so maybe better to remove it if the 
patch will change.

Thanks for asking!
Stefano


