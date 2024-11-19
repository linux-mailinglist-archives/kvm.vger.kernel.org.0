Return-Path: <kvm+bounces-32044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C579D219C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 09:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E824FB22F68
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 08:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D11B1AF0AC;
	Tue, 19 Nov 2024 08:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GGTtAHDG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B7F19D06E
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 08:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732005005; cv=none; b=pukXz8wJHUwLMHlkn6sFv0cApnx1J7AWF5eMQ05UFO2N8Jxfh9COEnq0rv5XDjf9Lc+/knPK4Ey1U0PBdb3QmQ01Pwj43uosKntIjNRaISvL6fUa7xZcKopyJ70fTP0FmD2fSpzJUp6XNWpCs1by8P5N6v7EbY086wqkuhzb540=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732005005; c=relaxed/simple;
	bh=+xKCrPwQVHWM0r18FvOpIwNqva/kAUIiweoFAE7ZwzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFyOdBogJiQTzrbvexKDqyEulnv4BuiCwj4lMB7AITRtodYoqsv5uo+INpQwetpVewAe84zlqG0ggp2LXjEvCj912xRhOJQzlr5XI2wQQMWt2dvyaPReqnCi7aNM67THvwuKKjY9D+ENgbPXxfVEpGwa4tpx3OksFmAN/OwoBqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GGTtAHDG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732005002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xTLxAWYQ1JNcTU0UUWCX6oUrShuLfa8MUCD9ctjzgKA=;
	b=GGTtAHDGoa4//IKKyRRDqxZ1KbJ6UnluMRm/sPuc0S2gq1cwPRT8PWChHW8MXxwuwIVE9l
	yx6g8cO+ZxtBHMrkM+CxoE52UtPTTOXZEKJH8F2nzK53tRlWXMdQ5FrTGc+jr1xZv4zirc
	D1SB5sifdJKJsPLOdOUeJq8fxSF4APs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-uW4Vi-9FNWWrjFQiSKbZ5w-1; Tue, 19 Nov 2024 03:30:01 -0500
X-MC-Unique: uW4Vi-9FNWWrjFQiSKbZ5w-1
X-Mimecast-MFC-AGG-ID: uW4Vi-9FNWWrjFQiSKbZ5w
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a9ad6d781acso48753066b.2
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 00:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732005000; x=1732609800;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTLxAWYQ1JNcTU0UUWCX6oUrShuLfa8MUCD9ctjzgKA=;
        b=YYbCMWjqE5TfP6/nAhE68wIA0OpsQ0SH+Hx13kMDkxdp/3/oRSiqj6bUY95wQvkjts
         LtqkvRCFulEdpIV4Wnc4Q6erSu/qFquXiR5NC9G/FHTYw8oqyPxVuJLdNoVyJDFFsaiH
         /n081p5C7Ni610skrk5u1wpjAT11U+Zb9L/T49VQMxFr7h/RfbN0FJu5UH6bFEMKn2QW
         btFiT/mKTyriApIermHVzNBpDyNxbBiUPpInNmS4uL/+2MEGmFBq4TTShChVNm6Hj7JE
         Z1IAajkgMsab9ANpBXFXsWv3WqJGJyyUu6EeLA2XuT/KJn80mpSMno/jdJi+0cjL/R52
         F7PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUr9QML02Tmf+PQIamMY9YzY8qbOjKA3Oz39UvmkYFXXmHQ+mvd+OmKR2WJh9kdJpVedM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpg4txTsUvrDlM496rEi4b/MaEK064j8l8Ru2L09vwm0TWVm9x
	6AUTzQ5PXFYqNa0I8Bwp2eYlw4PxGcjXZVIm0n7V9KT5iIMvKp+PqtNTnHH30QoU/pxf5bLZbhG
	nVZSFwYwBi4hGbSNgPcOaM3Oh4ZzgJJyGbFqDHxSv/MFv3GHt1w==
X-Received: by 2002:a17:907:d19:b0:a9e:b5d0:4ab7 with SMTP id a640c23a62f3a-aa483556727mr1382682166b.52.1732005000133;
        Tue, 19 Nov 2024 00:30:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxd7z957UsxaATiVx0EDfbn0BFQH51aHLzQfor6HWy4iT3aPDneL8plKb/5vnwG3RSEd0qgw==
X-Received: by 2002:a17:907:d19:b0:a9e:b5d0:4ab7 with SMTP id a640c23a62f3a-aa483556727mr1382676566b.52.1732004999357;
        Tue, 19 Nov 2024 00:29:59 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-129.retail.telecomitalia.it. [79.46.200.129])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df4e7bfsm624064866b.42.2024.11.19.00.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 00:29:58 -0800 (PST)
Date: Tue, 19 Nov 2024 09:29:53 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, Asias He <asias@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Paolo Abeni <pabeni@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <efsbknrsmen47tlay7cjrbo5qvmu4bcrmi2lvploi6qq5wpwet@wuu5mfgc3a34>
References: <20241115103016.86461-1-graf@amazon.com>
 <yjhfe5bsnfpqbnibxl2urrnuowzitxnrbodlihz4y5csig7e7p@drgxxxxgokfo>
 <dca2f6ff-b586-461d-936d-e0b9edbe7642@amazon.com>
 <CAGxU2F6eJA+vpYVbE0HNW794pF6wLL+o=92NYMQVvmFWnpNPaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGxU2F6eJA+vpYVbE0HNW794pF6wLL+o=92NYMQVvmFWnpNPaA@mail.gmail.com>

On Mon, Nov 18, 2024 at 03:07:43PM +0100, Stefano Garzarella wrote:
>On Fri, Nov 15, 2024 at 4:49 PM Alexander Graf <graf@amazon.com> wrote:
>>
>> Hi Stefano,
>>
>> On 15.11.24 12:59, Stefano Garzarella wrote:
>> >
>> > On Fri, Nov 15, 2024 at 10:30:16AM +0000, Alexander Graf wrote:
>> >> Ever since the introduction of the virtio vsock driver, it included
>> >> pushback logic that blocks it from taking any new RX packets until the
>> >> TX queue backlog becomes shallower than the virtqueue size.
>> >>
>> >> This logic works fine when you connect a user space application on the
>> >> hypervisor with a virtio-vsock target, because the guest will stop
>> >> receiving data until the host pulled all outstanding data from the VM.
>> >
>> > So, why not skipping this only when talking with a sibling VM?
>>
>>
>> I don't think there is a way to know, is there?
>>
>
>I thought about looking into the header and check the dst_cid.
>If it's > VMADDR_CID_HOST, we are talking with a sibling VM.
>
>>
>> >
>> >>
>> >> With Nitro Enclaves however, we connect 2 VMs directly via vsock:
>> >>
>> >>  Parent      Enclave
>> >>
>> >>    RX -------- TX
>> >>    TX -------- RX
>> >>
>> >> This means we now have 2 virtio-vsock backends that both have the
>> >> pushback
>> >> logic. If the parent's TX queue runs full at the same time as the
>> >> Enclave's, both virtio-vsock drivers fall into the pushback path and
>> >> no longer accept RX traffic. However, that RX traffic is TX traffic on
>> >> the other side which blocks that driver from making any forward
>> >> progress. We're not in a deadlock.
>> >>
>> >> To resolve this, let's remove that pushback logic altogether and rely on
>> >> higher levels (like credits) to ensure we do not consume unbounded
>> >> memory.
>> >
>> > I spoke quickly with Stefan who has been following the development from
>> > the beginning and actually pointed out that there might be problems
>> > with the control packets, since credits only covers data packets, so
>> > it doesn't seem like a good idea remove this mechanism completely.
>>
>>
>> Can you help me understand which situations the current mechanism really
>> helps with, so we can look at alternatives?
>
>Good question!
>I didn't participate in the initial development, so what I'm telling
>you is my understanding.
>@Stefan feel free to correct me!
>
>The driver uses a single workqueue (virtio_vsock_workqueue) where it
>queues several workers. The ones we are interested in are:
>1. the one to handle avail buffers in the TX virtqueue (send_pkt_work)
>2. the one for used buffers in the RX virtqueue (rx_work)
>
>Assuming that the same kthread executes the different workers, it
>seems to be more about making sure that the RX worker (i.e. rx_work)
>does not consume all the execution time, leaving no room for TX
>(send_pkt_work). Especially when there are a lot of messages queued in
>the TX queue that are considered as response for the host. (The
>threshold seems to be the size of the virtqueue).
>
>That said, perhaps just adopting a technique like the one in vhost
>(byte_weight in vhost_dev_init(), vhost_exceeds_weight(), etc.) where
>after a certain number of packets/bytes handled, the worker terminates
>its work and reschedules, could give us the same guarantees, in a
>simpler way.

Thinking more about, perhaps now I understand better why it was
introduced, and it should be related to the above.

In practice, "replies" are almost always queued in the intermediate
queue (send_pkt_queue) directly by the RX worker (rx_work) during its
execution. These are direct responses handled by
virtio_transport_recv_pkt() to requests coming from the other peer (the
host usually or sibling VM in your case). This happens for example
calling virtio_transport_reset_no_sock() if a socket is not found, or
sending back VIRTIO_VSOCK_OP_RESPONSE packet to ack a request of a
connection coming with a VIRTIO_VSOCK_OP_REQUEST packet.

Because of this, if the number of these "replies" exceeds an arbitrary
threshold, the RX worker decides to de-schedule itself, to give space to
the TX worker (send_pkt_work) to move those "replies" from the
intermediate queue into the TX virtqueue, at which point the TX worker
will reschedule the RX worker to continue the job. So more than avoiding
deadlock, it seems to be a mechanism to avoid starvation.

Note that this is not necessary in vhost-vsock (which uses the same
functions as this driver, e.g. virtio_transport_recv_pkt), because both
workers already use vhost_exceeds_weight() to avoid this problem as
well.

At this point I think that doing something similar to vhost here as well
would allow us not only to avoid the problem that `queued_replies`
should avoid, but also that the RX worker monopolizes the workqueue
during data transfer.

Thanks,
Stefano

>
>>
>>
>> >
>> >>
>> >> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>> >
>> > I'm not sure we should add this Fixes tag, this seems very risky
>> > backporting on stable branches IMHO.
>>
>>
>> Which situations do you believe it will genuinely break anything in?
>
>The situation for which it was introduced (which I don't know
>precisely because I wasn't following vsock yet).
>Removing it completely without being sure that what it was developed
>for is okay is risky to me.
>
>Support for sibling VMs has only recently been introduced, so I'd be
>happier making these changes just for that kind of communication.
>
>That said, the idea of doing like vhost might solve all our problems,
>so in that case maybe it might be okay.
>
>> As
>> it stands today, if you run upstream parent and enclave and hammer them
>> with vsock traffic, you get into a deadlock. Even without the flow
>> control, you will never hit a deadlock. But you may get a brown-out like
>> situation while Linux is flushing its buffers.
>>
>> Ideally we want to have actual flow control to mitigate the problem
>> altogether. But I'm not quite sure how and where. Just blocking all
>> receiving traffic causes problems.
>>
>>
>> > If we cannot find a better mechanism to replace this with something
>> > that works both guest <-> host and guest <-> guest, I would prefer
>> > to do this just for guest <-> guest communication.
>> > Because removing this completely seems too risky for me, at least
>> > without a proof that control packets are fine.
>>
>>
>> So your concern is that control packets would not receive pushback, so
>> we would allow unbounded traffic to get queued up?
>
>Right, most of `reply` are control packets (reset and response IIUC)
>that are not part of the credit mechanism, so I think this confirms
>what Stefan was telling me.
>
>> Can you suggest
>> options to help with that?
>
>Maybe mimic vhost approach should help, or something similar.
>
>That said, did you really encounter a real problem or is it more of a
>patch to avoid future problems.
>
>Because it would be nice to have a test that emphasizes this problem
>that we can use to check that everything is okay if we adopt something
>different. The same goes for the problem that this mechanism wants to
>avoid, I'll try to see if I have time to write a test so we can use
>it.
>
>
>Thanks,
>Stefano


