Return-Path: <kvm+bounces-20534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A246917B1A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 10:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E857287549
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 08:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A5816191A;
	Wed, 26 Jun 2024 08:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jQtPfV2a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE256161304
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 08:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719391074; cv=none; b=dUj6NOPPc4ObmhegeWtWIRRY06U0+2XSAlY9XzErAc9QCOV1ppnQlOKqD4NBspVB7ErTL/5UjtLaP/5P/tPO8cU5x1PajDuXiAIzPtpOsk7WvX39tWrf/tfFPvv64/1FnW4VDMCtT47uE4ughhXJpxhqIqtB0l1KackUxzWnmuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719391074; c=relaxed/simple;
	bh=RtiWRIj+hSLQ54YPkKolBiQlrty0POTxE/+VB3Eh8CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8xD7zb+Js9SrHgf2PQyKfEFMB03pH+tBRUk4N3o9U1HJbCQPD7mNy41ICYSON6oJpqoqAkHE4xXLP8S84WDhKluc7Pwd7TqdEL0QRKckSwQ7+W57pqDwrrTdXecsu9TydwA+6Hq/Qj3XwoPjooKa1OT8rBdq+iEBDmkibnGVWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jQtPfV2a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719391071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7EyR2jI3y57JBzoahqt2bc4GxOzHMK3Z1WoVOJyvS2E=;
	b=jQtPfV2amkH1D9cziztk1O7FIr5NoqkvIxjsyLOiV5R7ArnYc9t1Z8vFa7f3rXXtW5YYTw
	pZ6HwTTkN/yI5VC6QQfNGn1msIx4WEsiiTtyS+VvUpzJtroeht4NkdiXRyoUuVD82EvLZZ
	lFlsoSTpkBPBwy+4ZKN0YcaEe/Z3ejQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-FDldEaWaPDWm4C982gwR2A-1; Wed, 26 Jun 2024 04:37:49 -0400
X-MC-Unique: FDldEaWaPDWm4C982gwR2A-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-57d27d8f691so1265213a12.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 01:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719391068; x=1719995868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EyR2jI3y57JBzoahqt2bc4GxOzHMK3Z1WoVOJyvS2E=;
        b=XrBocLXtkJko2n82RRW6xGmRtxQ9gwVkKJO71S1JhWd6Hk4p2fDbVpI1c2M4UYApKE
         7Uze7Hs8AvhCGrPxsRVMWhFJeLSxF7RvzgRFWNhWh/NOT8QWr0IsRhR8zP0TdY7oy6Z9
         r9KYtTsFiatvMY5Hj068kHxwt6M8f836EqnMWedZtdp+KxPoz0jaePVgPn6Hy/GSLrR1
         Fu+SDFGEjFOT+ZTZxR0+MRZnmMkFaZHSJhaLTD2cEWDaBn4hfH4/fUpPlTpkXSk/7kUM
         jM4qUjWZdVvysZlZUkkQwsq/p2IPghBZ8BFrVEPl30jDhthfAYbfQspVpvnauj+mqsdl
         HA9g==
X-Forwarded-Encrypted: i=1; AJvYcCVQ8l0I3M074tPtWWr7dspPxnofgtBtswtZqxCJVe5GjTpAlrLno+Dyf6CIdL9KU3zOWL2HB37Th4ZVEo66TTJQD1br
X-Gm-Message-State: AOJu0Yyuqcf2CIT0jTl7ZjM+dDuyjE7d/LJLwSkdWvRr8LhYjChlQrBJ
	C5riWpK3J5iQSRsffL+TSOx78W1wYLc/1cANfI3SMsVyTf1CH/5sIXDsDrSBSG/QjuWilGwsPlJ
	gWMPF3Ujsu+RRWl89iyZ2m8W8SCHx6jvDH5WcIKj3/fNM1f8bJw==
X-Received: by 2002:a50:871e:0:b0:57c:ad96:14c8 with SMTP id 4fb4d7f45d1cf-57d4bd8f884mr8506693a12.23.1719391068338;
        Wed, 26 Jun 2024 01:37:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0zlrG20Q/erIRLYUmDvFSHuAKwdxWOO2zMTgc/4canrgayIJ1Tp4SqtdXhApLa8Kj5QLs7Q==
X-Received: by 2002:a50:871e:0:b0:57c:ad96:14c8 with SMTP id 4fb4d7f45d1cf-57d4bd8f884mr8506678a12.23.1719391067659;
        Wed, 26 Jun 2024 01:37:47 -0700 (PDT)
Received: from sgarzare-redhat (83.0.40.93.internetdsl.tpnet.pl. [83.0.40.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a727900d2f1sm128041566b.180.2024.06.26.01.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 01:37:47 -0700 (PDT)
Date: Wed, 26 Jun 2024 10:37:36 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Cc: Alexander Graf <graf@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <xw2rhgn2s677t6cufp2ndpvvgpdlovej44o6ieo7nz2p6msvnw@zza7jzylpw76>
References: <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com>
 <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
 <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
 <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com>
 <hyrgztjkjmftnpra2o2skonfs6bwf2sqrncwtec3e4ckupe5ea@76whtcp3zapf>
 <CAFfO_h5_uAwdNJB=fjrxb_pPiwRDQxaZn=OvR3yrYd+c18tUdQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFfO_h5_uAwdNJB=fjrxb_pPiwRDQxaZn=OvR3yrYd+c18tUdQ@mail.gmail.com>

Hi Dorjoy,

On Tue, Jun 25, 2024 at 11:44:30PM GMT, Dorjoy Chowdhury wrote:
>Hey Stefano,

[...]

>> >
>> >So the immediate plan would be to:
>> >
>> >  1) Build a new vhost-vsock-forward object model that connects to
>> >vhost as CID 3 and then forwards every packet from CID 1 to the
>> >Enclave-CID and every packet that arrives on to CID 3 to CID 2.
>>
>> This though requires writing completely from scratch the virtio-vsock
>> emulation in QEMU. If you have time that would be great, otherwise if
>> you want to do a PoC, my advice is to start with vhost-user-vsock which
>> is already there.
>>
>
>Can you give me some more details about how I can implement the
>daemon? 

We already have a demon written in Rust, so I don't recommend you 
rewrite one from scratch, just start with that. You can find the daemon 
and instructions on how to use it with QEMU here [1].

>I would appreciate some pointers to code too.

I sent the pointer to it in my first reply [2].

>
>Right now, the "nitro-enclave" machine type (wip) in QEMU
>automatically spawns a VHOST_VSOCK device with the CID equal to the
>"guest-cid" machine option. I think this is equivalent to using the
>"-device vhost-vsock-device,guest-cid=N" option explicitly. Does that
>need any change? I guess instead of "vhost-vsock-device", the
>vhost-vsock device needs to be equivalent to "-device
>vhost-user-vsock-device,guest-cid=N"?

Nope, the vhost-user-vsock device requires just a `chardev` option.
The chardev points to the Unix socket used by QEMU to talk with the 
daemon. The daemon has a parameter to set the CID. See [1] for the 
examples.

>
>The applications inside the nitro-enclave VM will still connect and
>talk to CID 3. So on the daemon side, do we need to spawn a device
>that has CID 3 and then forward everything this device receives to CID
>1 (VMADDR_CID_LOCAL) same port and everything it receives from CID 1
>to the "guest-cid"? 

Yep, I think this is right.
Note: to use VMADDR_CID_LOCAL, the host needs to load `vsock_loopback` 
kernel module.

Before modifying the code, if you want to do some testing, perhaps you 
can use socat (which supports both UNIX-* and VSOCK-*). The daemon for 
now exposes two unix sockets, one is used to communicate with QEMU via 
the vhost-user protocol, and the other is to be used by the application 
to communicate with vsock sockets in the guest using the hybrid protocol 
defined by firecracker. So you could initiate a socat between the latter 
and VMADDR_CID_LOCAL, the only problem I see is that you have to send 
the first string provided by the hybrid protocol (CONNECT 1234), but for 
a PoC it should be ok.

I just tried the following and it works without touching any code:

shell1$ ./target/debug/vhost-device-vsock \
     --vm guest-cid=3,socket=/tmp/vhost3.socket,uds-path=/tmp/vm3.vsock

shell2$ sudo modprobe vsock_loopback
shell2$ socat VSOCK-LISTEN:1234 UNIX-CONNECT:/tmp/vm3.vsock

shell3$ qemu-system-x86_64 -smp 2 -M q35,accel=kvm,memory-backend=mem \
     -drive file=fedora40.qcow2,format=qcow2,if=virtio\
     -chardev socket,id=char0,path=/tmp/vhost3.socket \
     -device vhost-user-vsock-pci,chardev=char0 \
     -object memory-backend-memfd,id=mem,size=512M \
     -nographic

     guest$ nc --vsock -l 1234

shell4$ nc --vsock 1 1234
CONNECT 1234

     Note: the `CONNECT 1234` is required by the hybrid vsock protocol 
     defined by firecracker, so if we extend the vhost-device-vsock 
     daemon to forward packet to VMADDR_CID_LOCAL, that would not be 
     needed (including running socat).


This is just an example for how to use loopback, now if from the VM you 
want to connect to a CID other than 2, then we have to modify the daemon 
to do that.

>The applications that will be running in the host
>need to be changed so that instead of connecting to the "guest-cid" of
>the nitro-enclave VM, they will instead connect to VMADDR_CID_LOCAL.
>Is my understanding correct?

Yep.

>
>BTW is there anything related to the "VMADDR_FLAG_TO_HOST" flag that
>needs to be checked? I remember some discussion about it.

No, that flag is handled by the driver. If that flag is on, the driver 
forwards the packet to the host, regardless of the destination CID. So 
it has to be set by the application in the guest, but it should already 
do that since that flag was introduced just for Nitro enclaves.

>
>It would be great if you could give me some details about how I can
>achieve the CID 3 <-> CID 2 communication using the vhost-user-vsock.

CID 3 <-> CID 2 is the standard use case, right?
The readme in [1] contains several examples, let me know if you need 
more details ;-)

>Is this https://github.com/stefano-garzarella/vhost-user-vsock where I
>would need to add support for forwarding everything to
>VMADDR_CID_LOCAL via an option maybe?

Nope, that one was a PoC and the repo is archived, the daemon is [1].
BTW, I agree on the option for the forwarding.

Thanks,
Stefano

[1] 
https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock
[2] 
https://lore.kernel.org/virtualization/CAFfO_h5_uAwdNJB=fjrxb_pPiwRDQxaZn=OvR3yrYd+c18tUdQ@mail.gmail.com/T/#m4a50f94a5329cd262412437ac80a4f406404bf20


