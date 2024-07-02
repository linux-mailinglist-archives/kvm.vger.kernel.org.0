Return-Path: <kvm+bounces-20846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAAEA923D07
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 13:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD7E91C2282C
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D48415CD61;
	Tue,  2 Jul 2024 11:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+4Pz6lS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485715B14E
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 11:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719921526; cv=none; b=QeoUb4GRVt5XK8wW8x1CXgJZMF8aD+NiXVqdlT6KLxsdJ0MU4gTFlsuaUw77iK1tgwClmORKAVIYR1oTcGnOWYWc069jjBOi8vk+YFg6UtUYtttc8JTprFzlUU9226huYWf+VOeBoHZLNxwzN2DFCM7Zc2KmLmibaTELclP5t3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719921526; c=relaxed/simple;
	bh=KA/gTPIEpoc6m29kg6p3grQR0k9seCK2G9eGrcS0VJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvW8J2XfSJB7YJzEYv2oE/aTvw91xKHcoHXOyl744MSNxQOnSgRxYNRvT8qK14Tj0yfEzaKZoZSpvOO/LZsIhoU+Kn/5q7HPotUXSwito1PxANrSMlR1gyeGkle/KPz3x5clioXy7h0Y2/WuFuz3AuLiBJaEejxxPMw4h+JHRQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D+4Pz6lS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719921523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lkiB6cGn26gz3s4xlpFfIRE9tnus7zUNdqLSVwr/vwk=;
	b=D+4Pz6lSJIaD3EIpc1ECOW5myFGMEG0m9YQZTUg9i8wiV5qteI7yIcghHRgxPlbNTh8c3z
	kdDDdF7AiOF4k9qSNSnFapckApT6ypbShMCq/XS64hTxkLEXjRwP/1m9yUiJSYNfx+/lYJ
	896D5Rzw2HrN2NnYrHN7LXsJV9Us5eQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447--SvZ36PkPsyV4IVl7EosSQ-1; Tue, 02 Jul 2024 07:58:42 -0400
X-MC-Unique: -SvZ36PkPsyV4IVl7EosSQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ec507c1b59so49774741fa.3
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 04:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719921520; x=1720526320;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkiB6cGn26gz3s4xlpFfIRE9tnus7zUNdqLSVwr/vwk=;
        b=lMGNNo6Vx+yiPP2cc6Cqb/C7vU9+4Zk+42Lt38LYQ3EUj3KAED3GPY0navdYxIchpo
         bYpseB2AR+zJB8QZGOvVr68Dqw2BWrToFAkZuviWAkK9r9wgCE+e5nL/e55a5Ai6wEum
         7nXDQcWChOKboTotnjr3a08g0ZwhPkSWvEQ5G+IN1THdMixnITGb8+DaQCIcWTw9z6lc
         /VQavLzRWIqi6r+29wMSdS3VfIeIcgO1ncX3ktbTiLmj4YBRwOYH3LEH3Hl6FNQ9iJEI
         E3t/ZwaRV1uj7pQw8ghFH93kNoOmRT4o3lrqiLLwzbn6eIGjSNLCstxGaUhmxWMrudKK
         HRTg==
X-Forwarded-Encrypted: i=1; AJvYcCWoHRKWp9+vN4WJQaTXyC2xr9sBIDe61mHTrRabwdANigr29LZ2HC3u59nlNDPOXMMVej3Jf1l8rLXO0UwEDdf5+scs
X-Gm-Message-State: AOJu0Yx1D7Xgu5S1hEda3M5vfxdcu8gD4EgzwEnbaSOe4Ns2AXqYXzVD
	v5dqeHUjsWtfc4AoGmy+Ej6STqPa+BiGZF/WjWQwIoR2GyETqnFnRo7rWNxZarm4xUkoJvoNK8c
	a4D0bqvPklL3QU0Jimfhq1D6ElKM+YaUwE5JGln1qpYGdRBSSOQ==
X-Received: by 2002:a2e:9985:0:b0:2ee:5b32:9d5d with SMTP id 38308e7fff4ca-2ee5e707c04mr61495011fa.47.1719921520468;
        Tue, 02 Jul 2024 04:58:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDNn/RKVPOMLHiAil/WkMHWZ+FZZKVg6IgZXsVGvZDgGHeJ7KVkTUDN9+GUn6oGTu/3oUstw==
X-Received: by 2002:a2e:9985:0:b0:2ee:5b32:9d5d with SMTP id 38308e7fff4ca-2ee5e707c04mr61494751fa.47.1719921519694;
        Tue, 02 Jul 2024 04:58:39 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.133.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab0b889dsm417567566b.225.2024.07.02.04.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 04:58:39 -0700 (PDT)
Date: Tue, 2 Jul 2024 13:58:34 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Cc: Alexander Graf <graf@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <62w7rlwo3raue5uiskk3plfkleksfqjowzqd5zhifhc4q3tkbf@f4lxokul67am>
References: <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
 <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
 <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com>
 <hyrgztjkjmftnpra2o2skonfs6bwf2sqrncwtec3e4ckupe5ea@76whtcp3zapf>
 <CAFfO_h5_uAwdNJB=fjrxb_pPiwRDQxaZn=OvR3yrYd+c18tUdQ@mail.gmail.com>
 <xw2rhgn2s677t6cufp2ndpvvgpdlovej44o6ieo7nz2p6msvnw@zza7jzylpw76>
 <CAFfO_h4WnSkinX1faduAD68h=nQCWhPgpYKTPV+xfSqyfMmxEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFfO_h4WnSkinX1faduAD68h=nQCWhPgpYKTPV+xfSqyfMmxEA@mail.gmail.com>

On Wed, Jun 26, 2024 at 11:43:25PM GMT, Dorjoy Chowdhury wrote:
>Hey Stefano,
>Thanks a lot for all the details. I will look into them and reach out
>if I need further input. Thanks! I have tried to summarize my
>understanding below. Let me know if that sounds correct.
>
>On Wed, Jun 26, 2024 at 2:37 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> Hi Dorjoy,
>>
>> On Tue, Jun 25, 2024 at 11:44:30PM GMT, Dorjoy Chowdhury wrote:
>> >Hey Stefano,
>>
>> [...]
>>
>> >> >
>> >> >So the immediate plan would be to:
>> >> >
>> >> >  1) Build a new vhost-vsock-forward object model that connects to
>> >> >vhost as CID 3 and then forwards every packet from CID 1 to the
>> >> >Enclave-CID and every packet that arrives on to CID 3 to CID 2.
>> >>
>> >> This though requires writing completely from scratch the virtio-vsock
>> >> emulation in QEMU. If you have time that would be great, otherwise if
>> >> you want to do a PoC, my advice is to start with vhost-user-vsock which
>> >> is already there.
>> >>
>> >
>> >Can you give me some more details about how I can implement the
>> >daemon?
>>
>> We already have a demon written in Rust, so I don't recommend you
>> rewrite one from scratch, just start with that. You can find the daemon
>> and instructions on how to use it with QEMU here [1].
>>
>> >I would appreciate some pointers to code too.
>>
>> I sent the pointer to it in my first reply [2].
>>
>> >
>> >Right now, the "nitro-enclave" machine type (wip) in QEMU
>> >automatically spawns a VHOST_VSOCK device with the CID equal to the
>> >"guest-cid" machine option. I think this is equivalent to using the
>> >"-device vhost-vsock-device,guest-cid=N" option explicitly. Does that
>> >need any change? I guess instead of "vhost-vsock-device", the
>> >vhost-vsock device needs to be equivalent to "-device
>> >vhost-user-vsock-device,guest-cid=N"?
>>
>> Nope, the vhost-user-vsock device requires just a `chardev` option.
>> The chardev points to the Unix socket used by QEMU to talk with the
>> daemon. The daemon has a parameter to set the CID. See [1] for the
>> examples.
>>
>> >
>> >The applications inside the nitro-enclave VM will still connect and
>> >talk to CID 3. So on the daemon side, do we need to spawn a device
>> >that has CID 3 and then forward everything this device receives to CID
>> >1 (VMADDR_CID_LOCAL) same port and everything it receives from CID 1
>> >to the "guest-cid"?
>>
>> Yep, I think this is right.
>> Note: to use VMADDR_CID_LOCAL, the host needs to load `vsock_loopback`
>> kernel module.
>>
>> Before modifying the code, if you want to do some testing, perhaps you
>> can use socat (which supports both UNIX-* and VSOCK-*). The daemon for
>> now exposes two unix sockets, one is used to communicate with QEMU via
>> the vhost-user protocol, and the other is to be used by the application
>> to communicate with vsock sockets in the guest using the hybrid protocol
>> defined by firecracker. So you could initiate a socat between the latter
>> and VMADDR_CID_LOCAL, the only problem I see is that you have to send
>> the first string provided by the hybrid protocol (CONNECT 1234), but for
>> a PoC it should be ok.
>>
>> I just tried the following and it works without touching any code:
>>
>> shell1$ ./target/debug/vhost-device-vsock \
>>      --vm guest-cid=3,socket=/tmp/vhost3.socket,uds-path=/tmp/vm3.vsock
>>
>> shell2$ sudo modprobe vsock_loopback
>> shell2$ socat VSOCK-LISTEN:1234 UNIX-CONNECT:/tmp/vm3.vsock
>>
>> shell3$ qemu-system-x86_64 -smp 2 -M q35,accel=kvm,memory-backend=mem \
>>      -drive file=fedora40.qcow2,format=qcow2,if=virtio\
>>      -chardev socket,id=char0,path=/tmp/vhost3.socket \
>>      -device vhost-user-vsock-pci,chardev=char0 \
>>      -object memory-backend-memfd,id=mem,size=512M \
>>      -nographic
>>
>>      guest$ nc --vsock -l 1234
>>
>> shell4$ nc --vsock 1 1234
>> CONNECT 1234
>>
>>      Note: the `CONNECT 1234` is required by the hybrid vsock protocol
>>      defined by firecracker, so if we extend the vhost-device-vsock
>>      daemon to forward packet to VMADDR_CID_LOCAL, that would not be
>>      needed (including running socat).
>>
>
>Understood. Just trying to think out loud what the final UX will be
>from the user perspective to successfully run a nitro VM before I try
>to modify vhost-device-vsock to support forwarding to
>VMADDR_CID_LOCAL.
>I guess because the "vhost-user-vsock" device needs to be spawned
>implicitly (without any explicit option) inside nitro-enclave in QEMU,
>we now need to provide the "chardev" as a machine option, so the
>nitro-enclave command would look something like below:
>"./qemu-system-x86_64 -M nitro-enclave,chardev=char0 -kernel
>/path/to/eif -chardev socket,id=char0,path=/tmp/vhost5.socket -m 4G
>--enable-kvm -cpu host"
>and then set the chardev id to the vhost-user-vsock device in the code
>from the machine option.

Yep, it looks like an option. Maybe we can have
     -M nitro-enclave,vhost-user-vsock=char0

>
>The modified "vhost-device-vsock" would need to be run with the new
>option that will forward everything to VMADDR_CID_LOCAL (below by the
>"-z" I mean the new option)
>"./target/debug/vhost-device-vsock -z --vm

IMHO the new option should be part of the --vm group (please avoid short 
options) in conflict with `uds-path`. We may also need a parameter, e.g.  
the CID where forward them.
Something like this:
     --vm guest-cid=5,forward-cid=1,socket=/tmp/vhost5.socket

>guest-cid=5,socket=/tmp/vhost5.socket,uds-path=/tmp/vm5.vsock"
>this means the guest-cid of the nitro VM is CID 5, right?

Yep.

>
>And the applications in the host would need to use VMADDR_CID_LOCAL
>for communication instead of "guest-cid" (5) (assuming vsock_loopback
>is modprobed). Let's say there are 2 applications inside the nitro VM
>that connect to CID 3 on port 9000 and 9001. And the applications on
>the host listen on 9000 and 9001 using VMADDR_CID_LOCAL. So, after the
>commands above (qemu VM and vhost-device-vsock) are run, the
>communication between the applications in the host and the
>applications in the nitro VM on port 9000 and 9001 should just work,
>right, without needing to run any extra socat commands or such? 

Right.

>or
>will the user still need to run some socat commands for all the
>relevant ports (e.g.,9000 and 9001)?

Nope, the "socat" work should be done by the vhost-device-vsock daemon.

>
>I am just wondering what kind of changes are needed in
>vhost-device-vsock for forwarding packets to VMADDR_CID_LOCAL? Will
>that be something like this: the codepath that handles
>"/tmp/vm5.vsock", upon receiving a "connect" (from inside the nitro
>VM) for any port to "/tmp/vm5.vsock", vhost-device-vsock will just
>connect to the same port using AF_VSOCK using the socket system calls
>and messages received on that port in "/tmp/vm5.vsock" will be "send"
>to the AF_VSOCK socket? or am I not thinking right and the
>implementation would be something different entirely (change the CID
>from 3 to 2 (or 1?) on the packets before they are handled then socat
>will be needed probably)? 

I think you're right.

>Will this work if the applications in the
>host want to connect to applications inside the nitro VM (as opposed
>to applications inside the nitro VM connecting to CID 3)?

Nope, if you know in advance which ports to expose, you can add another 
parameter to expose them, so the daemon con listen on the address 
(cid=1, port=1234) and forwards the connections to the guest.

Stefano


