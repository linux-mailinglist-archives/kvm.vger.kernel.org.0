Return-Path: <kvm+bounces-18022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F828CCE93
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67D81281D22
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 08:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C7713D253;
	Thu, 23 May 2024 08:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmS8w3D3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1105729422
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 08:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716453943; cv=none; b=lVUxDmDiGEr84gnt/ySsQbHYOy1fio270PnXBxmZhuCn1lehVLP2FfxzFbgOfc2bXegcGVY16wBW5TWq/1qL2Ynp5O4t4Xvv2fiuD2Thg84sZUPCWczOKAHOCfFgB7tE94+VRBKy4Qgp7ehGX0FULDv27ku3Qz9KMSOLTP95S7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716453943; c=relaxed/simple;
	bh=Klg5na3ir6Jo0XD2KlZcjnpaAqZv6WA9rKQrs/j+V6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTpHK9t9AdKTTMpfJB3Gt0iO5fb+usnF9xLlnjVp2oEGsH6r+8Hp2hQ5ji3zcKpBVbsGCf1CiHp8p4JowF6jbt5zIzqf+IdzL9hjBONAj39k4bcSpKmHShxtLNP9C9lTENw2hsPs57CC5yfAISE/nSeNfJvaU6tD1+wC0euan/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NmS8w3D3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716453940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RpFPE8buedMm/3/WAIhw3hDkX+HooBF5TiKTfpx87wc=;
	b=NmS8w3D3WiPucSAz36F0rjjqbdnTVlGVA6lQPjbcyZi1mBMmXSgyhlV7AHtTr8C79im5oX
	l7voxiKrWXVQM9PmhucSn535xARH3yLtRFxPi32pQ2/YWHRTkuM/RuShfK/pg1s3VVF/bl
	nn3RKNeRTB3tdG3YO/XA/cbyllp9iv0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-yrvd-I27OpWzsTO6nOEJfQ-1; Thu, 23 May 2024 04:45:38 -0400
X-MC-Unique: yrvd-I27OpWzsTO6nOEJfQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ab6bc106fdso43579636d6.0
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 01:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716453938; x=1717058738;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RpFPE8buedMm/3/WAIhw3hDkX+HooBF5TiKTfpx87wc=;
        b=lZ6c/Xddr3Y8UPzr5AwEWBaQ5z+7pFfhgwPg2+CNbt3DgdhdNA9P3K4suBPpvUa2jg
         qtcLAvS5SEchh/0ztzlRUNtkVxT8jpDbfoHCpDIZO0MTEQJFFffukHeb0Dqa3sjuXXLX
         GvPnPZyScqfobbevql9qVe8xfsJS9OQP1QB2SJWRcq093vR7wtQd0NChYQNXRFl0AcMH
         y5CbznQZqJm6S6PSlAkGvqvwxvilPQCnOnwwazE0WISiqblS+Ob2R31l232yR8faGwwC
         gNWBDcpNIolkX2phBLHfx6YxjbssZ6NV4H8LGxERwqCXPasACg1+ukmcFERz4UItvJZY
         GSDw==
X-Forwarded-Encrypted: i=1; AJvYcCUIrC2Dbc3982RGXaGIWrulVLDBiU9kVz/uNTPLjc7spAOFNtIhdnIYmuNc98JFGFviN+bAmXeDpKYQj5vr46z6UPwb
X-Gm-Message-State: AOJu0YwoZMwJVPpnfDtFoPrnaZPU0m+xquqBlDIPc8HsFTjN9/N43jIM
	tfjbSddeiCrLFf9qftWppOnQfJExx0DphiNkJzvaWp76r3tLrqu2/my2Nqzhso+zj3o+Usogahp
	HufJwzMBFujC6A1EUynVUEwlCLe4cDJaa96Nk/dWFfmiIUtYMTA==
X-Received: by 2002:a05:6214:4905:b0:6ab:8e10:8125 with SMTP id 6a1803df08f44-6ab8e1082c5mr22234796d6.2.1716453938119;
        Thu, 23 May 2024 01:45:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFloMOgtR73Qon0kqp6JglicbZzgw8fwbykGxI2ZjtqO7BGrJ2ZQZCtjJd5lr8hvXwBh4rS0g==
X-Received: by 2002:a05:6214:4905:b0:6ab:8e10:8125 with SMTP id 6a1803df08f44-6ab8e1082c5mr22234746d6.2.1716453937791;
        Thu, 23 May 2024 01:45:37 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a35e6c34a1sm75492576d6.14.2024.05.23.01.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 01:45:37 -0700 (PDT)
Date: Thu, 23 May 2024 10:45:31 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <agraf@csgraf.de>
Cc: Dorjoy Chowdhury <dorjoychy111@gmail.com>, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	Alexander Graf <graf@amazon.com>, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>

On Tue, May 21, 2024 at 08:50:22AM GMT, Alexander Graf wrote:
>Howdy,
>
>On 20.05.24 14:44, Dorjoy Chowdhury wrote:
>>Hey Stefano,
>>
>>Thanks for the reply.
>>
>>
>>On Mon, May 20, 2024, 2:55 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>Hi Dorjoy,
>>>
>>>On Sat, May 18, 2024 at 04:17:38PM GMT, Dorjoy Chowdhury wrote:
>>>>Hi,
>>>>
>>>>Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
>>>>emulation support in QEMU. Alexander Graf is mentoring me on this work. A v1
>>>>patch series has already been posted to the qemu-devel mailing list[2].
>>>>
>>>>AWS nitro enclaves is an Amazon EC2[3] feature that allows creating isolated
>>>>execution environments, called enclaves, from Amazon EC2 instances, which are
>>>>used for processing highly sensitive data. Enclaves have no persistent storage
>>>>and no external networking. The enclave VMs are based on Firecracker microvm
>>>>and have a vhost-vsock device for communication with the parent EC2 instance
>>>>that spawned it and a Nitro Secure Module (NSM) device for cryptographic
>>>>attestation. The parent instance VM always has CID 3 while the enclave VM gets
>>>>a dynamic CID. The enclave VMs can communicate with the parent instance over
>>>>various ports to CID 3, for example, the init process inside an enclave sends a
>>>>heartbeat to port 9000 upon boot, expecting a heartbeat reply, letting the
>>>>parent instance know that the enclave VM has successfully booted.
>>>>
>>>>The plan is to eventually make the nitro enclave emulation in QEMU standalone
>>>>i.e., without needing to run another VM with CID 3 with proper vsock
>>>If you don't have to launch another VM, maybe we can avoid vhost-vsock
>>>and emulate virtio-vsock in user-space, having complete control over the
>>>behavior.
>>>
>>>So we could use this opportunity to implement virtio-vsock in QEMU [4]
>>>or use vhost-user-vsock [5] and customize it somehow.
>>>(Note: vhost-user-vsock already supports sibling communication, so maybe
>>>with a few modifications it fits your case perfectly)
>>>
>>>[4] https://gitlab.com/qemu-project/qemu/-/issues/2095
>>>[5] https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock
>>
>>
>>Thanks for letting me know. Right now I don't have a complete picture
>>but I will look into them. Thank you.
>>>
>>>
>>>>communication support. For this to work, one approach could be to teach the
>>>>vhost driver in kernel to forward CID 3 messages to another CID N
>>>So in this case both CID 3 and N would be assigned to the same QEMU
>>>process?
>>
>>
>>CID N is assigned to the enclave VM. CID 3 was supposed to be the
>>parent VM that spawns the enclave VM (this is how it is in AWS, where
>>an EC2 instance VM spawns the enclave VM from inside it and that
>>parent EC2 instance always has CID 3). But in the QEMU case as we
>>don't want a parent VM (we want to run enclave VMs standalone) we
>>would need to forward the CID 3 messages to host CID. I don't know if
>>it means CID 3 and CID N is assigned to the same QEMU process. Sorry.
>
>
>There are 2 use cases here:
>
>1) Enclave wants to treat host as parent (default). In this scenario, 
>the "parent instance" that shows up as CID 3 in the Enclave doesn't 
>really exist. Instead, when the Enclave attempts to talk to CID 3, it 
>should really land on CID 0 (hypervisor). When the hypervisor tries to 
>connect to the Enclave on port X, it should look as if it originates 
>from CID 3, not CID 0.
>
>2) Multiple parent VMs. Think of an actual cloud hosting scenario. 
>Here, we have multiple "parent instances". Each of them thinks it's 
>CID 3. Each can spawn an Enclave that talks to CID 3 and reach the 
>parent. For this case, I think implementing all of virtio-vsock in 
>user space is the best path forward. But in theory, you could also 
>swizzle CIDs to make random "real" CIDs appear as CID 3.
>

Thank you for clarifying the use cases!

Also for case 1, vhost-vsock doesn't support CID 0, so in my opinion 
it's easier to go into user-space with vhost-user-vsock or the built-in 
device.

Maybe initially with vhost-user-vsock it's easier because we already 
have some thing that works and supports sibling communication (for case 
2).

>
>>
>>>Do you have to allocate 2 separate virtio-vsock devices, one for the
>>>parent and one for the enclave?
>>
>>
>>If there is a parent VM, then I guess both parent and enclave VMs need
>>virtio-vsock devices.
>>
>>>>(set to CID 2 for host) i.e., it patches CID from 3 to N on incoming messages
>>>>and from N to 3 on responses. This will enable users of the
>>>Will these messages have the VMADDR_FLAG_TO_HOST flag set?
>>>
>>>We don't support this in vhost-vsock yet, if supporting it helps, we
>>>might, but we need to better understand how to avoid security issues, so
>>>maybe each device needs to explicitly enable the feature and specify
>>>from which CIDs it accepts packets.
>>
>>
>>I don't know about the flag. So I don't know if it will be set. Sorry.
>
>
>From the guest's point of view, the parent (CID 3) is just another VM. 
>Since Linux as of
>
> https://patchwork.ozlabs.org/project/netdev/patch/20201204170235.84387-4-andraprs@amazon.com/#2594117
>
>always sets VMADDR_FLAG_TO_HOST when local_CID > 0 && remote_CID > 0, I 
>would say the message has the flag set.
>
>How would you envision the host to implement the flag? Would the host 
>allow user space to listen on any CID and hence receive the respective 
>target connections? And wouldn't listening on CID 0 then mean you're 
>effectively listening to "any" other CID? Thinking about that a bit 
>more, that may be just what we need, yes :)

No, wait. The flag I had guessed only to implement sibling 
communication, so the host doesn't re-forward those packets to sockets 
opened by applications in the host, but only to other VMs in the same 
host. So the host would always only have CID 2 assigned (CID 0 is not 
supported by vhost-vsock).

>
>
>>
>>
>>>>nitro-enclave machine
>>>>type in QEMU to run the necessary vsock server/clients in the host machine
>>>>(some defaults can be implemented in QEMU as well, for example, sending a reply
>>>>to the heartbeat) which will rid them of the cumbersome way of running another
>>>>whole VM with CID 3. This way, users of nitro-enclave machine in QEMU, could
>>>>potentially also run multiple enclaves with their messages for CID 3 forwarded
>>>>to different CIDs which, in QEMU side, could then be specified using a new
>>>>machine type option (parent-cid) if implemented. I guess in the QEMU side, this
>>>>will be an ioctl call (or some other way) to indicate to the host kernel that
>>>>the CID 3 messages need to be forwarded. Does this approach of
>>>What if there is already a VM with CID = 3 in the system?
>>
>>
>>Good question! I don't know what should happen in this case.
>
>
>See case 2 above :). In a nutshell, I don't think it'd be legal to 
>have a real CID 3 in that scenario.

Yeah, with vhost-vsock we can't, but with vhost-user-vsock I think is 
fine since the guest CID is local for each instance. The host only sees
the unix socket (like with firecracker).

>
>
>>
>>
>>>>forwarding CID 3 messages to another CID sound good?
>>>It seems too specific a case, if we can generalize it maybe we could
>>>make this change, but we would like to avoid complicating vhost-vsock
>>>and keep it as simple as possible to avoid then having to implement
>>>firewalls, etc.
>>>
>>>So first I would see if vhost-user-vsock or the QEMU built-in device is
>>>right for this use-case.
>>Thanks you! I will check everything out and reach out if I need
>>further guidance about what needs to be done. And sorry as I wasn't
>>able to answer some of your questions.
>
>
>As mentioned above, I think there is merit for both. I personally care 
>a lot more for case 1 over case 2: We already have a working 
>implementation of Nitro Enclaves in a Cloud setup. What is missing is 
>a way to easily run a Nitro Enclave locally for development.

If both are fine, then I would go more on modifying vhost-user-vsock or 
adding a built-in device in QEMU.
We have more freedom and also easier to update/debug.

Thanks,
Stefano


