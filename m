Return-Path: <kvm+bounces-17755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7098C9B95
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6806281F86
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 10:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FAD052F61;
	Mon, 20 May 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ofw9CsKP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E492032B;
	Mon, 20 May 2024 10:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716201928; cv=none; b=WmyINivwbVrrQk+6yJxM/By7liwWHdEnIUGclM0gSbFpMo+hFCFbObaPd5fSYw9w/cGGjdD2u/ZtdTodoN9Z1Xy7G15GW72VHMtj5oF3Nwn3ZIHtfUOvUNDYYIY6TRaV94GQQ9jVy7GleJDzvAOhsWl+sN+aN/4CxaIAf2l8vrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716201928; c=relaxed/simple;
	bh=EZgcxZYosWTpjlDGG28pfLwDr3xap2F3W7fPcx1epbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PQipyAa7WDM4c2/V/dAsMsy6oZw4nmcTLvXQLdBifUTvj3KZ5zCSIGkHDtJ2LJDO4DgoU6BAsY4wk1DgTLH1bOgjjXRXkiO5PGmZyvlWRgj40eSjVS3ApdUEkE9Ao9UJretrF2yK1pDKxN1UvV9h4lo1firkuJKoBKCZjua8cH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ofw9CsKP; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e576057c2bso59027951fa.1;
        Mon, 20 May 2024 03:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716201925; x=1716806725; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EZgcxZYosWTpjlDGG28pfLwDr3xap2F3W7fPcx1epbM=;
        b=Ofw9CsKPZX+TWAE0nXdcwVDCoU6fc4UjE2PFe9VgxThm7Pn1Dt7UAJWIlww1cZzMLU
         r9J3cfto5vtAvD8a6xs02vVu3gqIeK1jlfhADWipwZ+Ihe9/Rl0qRkLhj8IxSF8QjV51
         5rDdIQ3r/L8FFg+6MrAMwhSf+gE7pemMeNvZyqWP8r8jCIw4DYe28SQkVUskNzAFmUwf
         s94Xs16nL0wO6xX9/XYW4IpYPLVLY4Tc+3VXBVGSvNvbWSC47l4iwRmyaFQYiN1bMeuW
         6Sn3M1X53pOTBfT9FdEkMij+5sD4KDic3/+j7UR4MKP3qx17kVWoG+zm8QwQDL0FpRbZ
         WOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716201925; x=1716806725;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EZgcxZYosWTpjlDGG28pfLwDr3xap2F3W7fPcx1epbM=;
        b=BOuquMPULRQKVOWgTuyOTSMucIRltToji8os3YoUTxgQoZepmQGSKiuznte/cjvSFm
         hgLut0a0mUwN+XnaoU2ZUQeKhQ1dU0+0qntGoIvuq3yEkzgA7dC6l1Ec4RfWtPei85C+
         orXZz2kUiFRIFQmK1QRkBh2FGcZ2XENB1ymPhPIrJXT9yo1mwZBGbfiHzPzUKGygFNOq
         A3bXrzZoSDhjhRidnj7UYXQ8RI8w51nAjfE3Fu5TBWCUGi0sbJFIQPPSpt10Y0+N4urI
         yMWAqVaS9NXA/8TBkvQuWaJDK111PfgepYuJ//g3eSgyUOx5+XC8P+A5WvWF3h3CYm1+
         syMg==
X-Forwarded-Encrypted: i=1; AJvYcCUk9zAKs52yfX5R1Uk7fWYioMgTGVwnF1AK+XnylU+Zpjh3V238cYRR3J/WqYFwMv6ZQL/yPnC+pyvNwZ4msNH5yysuB8yliIRYzHHg56Qtpg1a030i6/G27rEG
X-Gm-Message-State: AOJu0YxfAIWmi7N1UCVdOmNrvKy48NC+YDL/EH5fmkbQfPmJ/j7Grn7Z
	B0OYAnYb7Ytljx22o6DzS7ZMTWdrZ0q1DPHzrPCAGUV1wDckG/JueFOpmctHc3LpfxycL9TUikt
	YNs3BXz17yGHI6czQ1yAjXfxBK0Sx/rhT
X-Google-Smtp-Source: AGHT+IHwR1xkxC2pVcRW4nJIcn0EzHCZRjgzP18BRB06fBmjFhDjrdkXtVR4LSyfOFUQGtpombpgh+2M0nfqSJXjnSc=
X-Received: by 2002:a2e:8404:0:b0:2e7:b9d:31da with SMTP id
 38308e7fff4ca-2e70b9d327fmr80018311fa.16.1716201924904; Mon, 20 May 2024
 03:45:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
In-Reply-To: <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Mon, 20 May 2024 16:44:59 +0600
Message-ID: <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>, agraf@csgraf.de, 
	stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hey Stefano,

Thanks for the reply.


On Mon, May 20, 2024, 2:55 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Hi Dorjoy,
>
> On Sat, May 18, 2024 at 04:17:38PM GMT, Dorjoy Chowdhury wrote:
> >Hi,
> >
> >Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
> >emulation support in QEMU. Alexander Graf is mentoring me on this work. A v1
> >patch series has already been posted to the qemu-devel mailing list[2].
> >
> >AWS nitro enclaves is an Amazon EC2[3] feature that allows creating isolated
> >execution environments, called enclaves, from Amazon EC2 instances, which are
> >used for processing highly sensitive data. Enclaves have no persistent storage
> >and no external networking. The enclave VMs are based on Firecracker microvm
> >and have a vhost-vsock device for communication with the parent EC2 instance
> >that spawned it and a Nitro Secure Module (NSM) device for cryptographic
> >attestation. The parent instance VM always has CID 3 while the enclave VM gets
> >a dynamic CID. The enclave VMs can communicate with the parent instance over
> >various ports to CID 3, for example, the init process inside an enclave sends a
> >heartbeat to port 9000 upon boot, expecting a heartbeat reply, letting the
> >parent instance know that the enclave VM has successfully booted.
> >
> >The plan is to eventually make the nitro enclave emulation in QEMU standalone
> >i.e., without needing to run another VM with CID 3 with proper vsock
>
> If you don't have to launch another VM, maybe we can avoid vhost-vsock
> and emulate virtio-vsock in user-space, having complete control over the
> behavior.
>
> So we could use this opportunity to implement virtio-vsock in QEMU [4]
> or use vhost-user-vsock [5] and customize it somehow.
> (Note: vhost-user-vsock already supports sibling communication, so maybe
> with a few modifications it fits your case perfectly)
>
> [4] https://gitlab.com/qemu-project/qemu/-/issues/2095
> [5] https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock



Thanks for letting me know. Right now I don't have a complete picture
but I will look into them. Thank you.
>
>
>
> >communication support. For this to work, one approach could be to teach the
> >vhost driver in kernel to forward CID 3 messages to another CID N
>
> So in this case both CID 3 and N would be assigned to the same QEMU
> process?



CID N is assigned to the enclave VM. CID 3 was supposed to be the
parent VM that spawns the enclave VM (this is how it is in AWS, where
an EC2 instance VM spawns the enclave VM from inside it and that
parent EC2 instance always has CID 3). But in the QEMU case as we
don't want a parent VM (we want to run enclave VMs standalone) we
would need to forward the CID 3 messages to host CID. I don't know if
it means CID 3 and CID N is assigned to the same QEMU process. Sorry.

>
> Do you have to allocate 2 separate virtio-vsock devices, one for the
> parent and one for the enclave?



If there is a parent VM, then I guess both parent and enclave VMs need
virtio-vsock devices.

>
> >(set to CID 2 for host) i.e., it patches CID from 3 to N on incoming messages
> >and from N to 3 on responses. This will enable users of the
>
> Will these messages have the VMADDR_FLAG_TO_HOST flag set?
>
> We don't support this in vhost-vsock yet, if supporting it helps, we
> might, but we need to better understand how to avoid security issues, so
> maybe each device needs to explicitly enable the feature and specify
> from which CIDs it accepts packets.



I don't know about the flag. So I don't know if it will be set. Sorry.


>
> >nitro-enclave machine
> >type in QEMU to run the necessary vsock server/clients in the host machine
> >(some defaults can be implemented in QEMU as well, for example, sending a reply
> >to the heartbeat) which will rid them of the cumbersome way of running another
> >whole VM with CID 3. This way, users of nitro-enclave machine in QEMU, could
> >potentially also run multiple enclaves with their messages for CID 3 forwarded
> >to different CIDs which, in QEMU side, could then be specified using a new
> >machine type option (parent-cid) if implemented. I guess in the QEMU side, this
> >will be an ioctl call (or some other way) to indicate to the host kernel that
> >the CID 3 messages need to be forwarded. Does this approach of
>
> What if there is already a VM with CID = 3 in the system?



Good question! I don't know what should happen in this case.


>
> >forwarding CID 3 messages to another CID sound good?
>
> It seems too specific a case, if we can generalize it maybe we could
> make this change, but we would like to avoid complicating vhost-vsock
> and keep it as simple as possible to avoid then having to implement
> firewalls, etc.
>
> So first I would see if vhost-user-vsock or the QEMU built-in device is
> right for this use-case.



Thanks you! I will check everything out and reach out if I need
further guidance about what needs to be done. And sorry as I wasn't
able to answer some of your questions.

Regards,
Dorjoy

