Return-Path: <kvm+bounces-18210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FD58D1F1A
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 16:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1E8F1C2253B
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 14:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A6116FF39;
	Tue, 28 May 2024 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZXBzcuO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA95170821
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716907431; cv=none; b=fRffD3reMIyqnne3fRPfXc+E7afBfgyKBvCh6YlHA4pytA5HL9hhceAPkSMsM43WbLSoO48kv6XP+38C/8Z1WkP7Gc3PZHjawQyGi1QEE8vTGmvohg9SIwgBSrHUZjRyGEEXgF0IVN4kuPFY99Rs7zbUZYZOY10d9mBwVxG5PEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716907431; c=relaxed/simple;
	bh=l8PL4ITreuRzuAabhern06z5m9w9eYF1RtNoXSO1DFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=otga6gzjAvQt7mKHrXNKTCUFPjPfOsrRahkclrwqHS4uWjfMod5AcR7Ocf4GpvTDYnUupinAJhdzZm5I2lf5yE4ElaYS2zmSaA/Wm/fu9pb36Q2/O5LOFNSP6mjg3AbmdAqxixuvUar9An88EfFxMhHYTDwT+YZ73jxg+Bg0fXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZXBzcuO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716907428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ7SbRqo3yUKi400fXlwv6prAX+h9G6ATKUpe9IKZfM=;
	b=FZXBzcuOTw/evruV0hCgIgUvnOOjXKbLlnrnbaffEeAUA2gG7V4dp3knWA1b/rVe+hSKNq
	RsobWbI4og7MGjKEEc3HRMxeE8NFRi+2GRfjAHO+EWYbqRef20HvvdFNYbCD0VUxbQub4y
	QoUyecfYg+H6qtPmTpfTDFSd2A6++hg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-BJmV3joFNzWILXh6OzemzQ-1; Tue, 28 May 2024 10:43:47 -0400
X-MC-Unique: BJmV3joFNzWILXh6OzemzQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42120e123beso4031345e9.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 07:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716907426; x=1717512226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ7SbRqo3yUKi400fXlwv6prAX+h9G6ATKUpe9IKZfM=;
        b=Cti0UsF0iikftP/sQ/ZeoMC9ZMa3wJDD+bOv11S/SS7ZoYQTJtCiaXjWNZGyVM6iOZ
         aA+eQg/Ldw0RYZSPW2SKPOVRheyJOEV4wmg+InI4I2ka9IduV7OGQpA04eDOEiVy9fDy
         i9Rf2fPkWNSYXwdvqfnYpe0s7C4ZiLE0KEeEVUaRImWMD0SCMmYWpt+1zouiWrrPbqAp
         VADoZGIhrcVisFse6YMs/wHUdC7KhB6aHdPGv/iUN+frPGhw1Rjws9TEEWPVNDZjGH3e
         oqOwYTvcvr8Etm4E0fimSmDtMAiuY1mhks47arm8mTP4nFKM7lkxSeEkSjPFH7KiViah
         pt/A==
X-Forwarded-Encrypted: i=1; AJvYcCUDataR/BysvjLmYtbkW/448IU2o6+ySnr90RAfb5ZLaWr05EOnGhOTjM4XiCXJePZRKQ/0rMLJnxm3MKZHgEDDQxjM
X-Gm-Message-State: AOJu0YzZ9jnHzSxz8g8KPc4NHkdrm7fxNwLfvBR0Hze3dU8W1Wte1aLI
	gTld9yuzryOBSd348pr3izQXYY3AX62DFpGTdomKP13a7dS4JfqRCOoB1AU5D1gb/C0VPFgnSxL
	hN5bMy2b908lzSLrSOJ4wYYuS0nHwXbcnbS4k9h16C22d+oMf9Q==
X-Received: by 2002:a05:600c:5129:b0:421:1fb1:fe00 with SMTP id 5b1f17b1804b1-4211fb1fecbmr19203685e9.17.1716907426131;
        Tue, 28 May 2024 07:43:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5W0e9gKn3FUSUFC5qJt7ioXJzCWomZRrdk8cPW4i6Z/Cawy24M4FleXwYrOgLgbaIzYuxxA==
X-Received: by 2002:a05:600c:5129:b0:421:1fb1:fe00 with SMTP id 5b1f17b1804b1-4211fb1fecbmr19203395e9.17.1716907425687;
        Tue, 28 May 2024 07:43:45 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4210e63ea39sm116795045e9.30.2024.05.28.07.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 07:43:44 -0700 (PDT)
Date: Tue, 28 May 2024 16:43:40 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Alexander Graf <agraf@csgraf.de>, 
	Dorjoy Chowdhury <dorjoychy111@gmail.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <tg7l3dr2x7jbf4kf6fbl5vforfonx6b4ls7smrimq6fg4tlluc@udyk6ex7ymrr>
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
 <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
 <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>

On Mon, May 27, 2024 at 09:54:17AM GMT, Alexander Graf wrote:
>
>On 27.05.24 09:08, Alexander Graf wrote:
>>Hey Stefano,
>>
>>On 23.05.24 10:45, Stefano Garzarella wrote:
>>>On Tue, May 21, 2024 at 08:50:22AM GMT, Alexander Graf wrote:
>>>>Howdy,
>>>>
>>>>On 20.05.24 14:44, Dorjoy Chowdhury wrote:
>>>>>Hey Stefano,
>>>>>
>>>>>Thanks for the reply.
>>>>>
>>>>>
>>>>>On Mon, May 20, 2024, 2:55 PM Stefano Garzarella 
>>>>><sgarzare@redhat.com> wrote:
>>>>>>Hi Dorjoy,
>>>>>>
>>>>>>On Sat, May 18, 2024 at 04:17:38PM GMT, Dorjoy Chowdhury wrote:
>>>>>>>Hi,
>>>>>>>
>>>>>>>Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
>>>>>>>emulation support in QEMU. Alexander Graf is mentoring me 
>>>>>>>on this work. A v1
>>>>>>>patch series has already been posted to the qemu-devel 
>>>>>>>mailing list[2].
>>>>>>>
>>>>>>>AWS nitro enclaves is an Amazon EC2[3] feature that allows 
>>>>>>>creating isolated
>>>>>>>execution environments, called enclaves, from Amazon EC2 
>>>>>>>instances, which are
>>>>>>>used for processing highly sensitive data. Enclaves have 
>>>>>>>no persistent storage
>>>>>>>and no external networking. The enclave VMs are based on 
>>>>>>>Firecracker microvm
>>>>>>>and have a vhost-vsock device for communication with the 
>>>>>>>parent EC2 instance
>>>>>>>that spawned it and a Nitro Secure Module (NSM) device for 
>>>>>>>cryptographic
>>>>>>>attestation. The parent instance VM always has CID 3 while 
>>>>>>>the enclave VM gets
>>>>>>>a dynamic CID. The enclave VMs can communicate with the 
>>>>>>>parent instance over
>>>>>>>various ports to CID 3, for example, the init process 
>>>>>>>inside an enclave sends a
>>>>>>>heartbeat to port 9000 upon boot, expecting a heartbeat 
>>>>>>>reply, letting the
>>>>>>>parent instance know that the enclave VM has successfully booted.
>>>>>>>
>>>>>>>The plan is to eventually make the nitro enclave emulation 
>>>>>>>in QEMU standalone
>>>>>>>i.e., without needing to run another VM with CID 3 with proper vsock
>>>>>>If you don't have to launch another VM, maybe we can avoid 
>>>>>>vhost-vsock
>>>>>>and emulate virtio-vsock in user-space, having complete 
>>>>>>control over the
>>>>>>behavior.
>>>>>>
>>>>>>So we could use this opportunity to implement virtio-vsock 
>>>>>>in QEMU [4]
>>>>>>or use vhost-user-vsock [5] and customize it somehow.
>>>>>>(Note: vhost-user-vsock already supports sibling 
>>>>>>communication, so maybe
>>>>>>with a few modifications it fits your case perfectly)
>>>>>>
>>>>>>[4] https://gitlab.com/qemu-project/qemu/-/issues/2095
>>>>>>[5] https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock
>>>>>
>>>>>
>>>>>Thanks for letting me know. Right now I don't have a complete picture
>>>>>but I will look into them. Thank you.
>>>>>>
>>>>>>
>>>>>>>communication support. For this to work, one approach 
>>>>>>>could be to teach the
>>>>>>>vhost driver in kernel to forward CID 3 messages to another CID N
>>>>>>So in this case both CID 3 and N would be assigned to the same QEMU
>>>>>>process?
>>>>>
>>>>>
>>>>>CID N is assigned to the enclave VM. CID 3 was supposed to be the
>>>>>parent VM that spawns the enclave VM (this is how it is in AWS, where
>>>>>an EC2 instance VM spawns the enclave VM from inside it and that
>>>>>parent EC2 instance always has CID 3). But in the QEMU case as we
>>>>>don't want a parent VM (we want to run enclave VMs standalone) we
>>>>>would need to forward the CID 3 messages to host CID. I don't know if
>>>>>it means CID 3 and CID N is assigned to the same QEMU process. Sorry.
>>>>
>>>>
>>>>There are 2 use cases here:
>>>>
>>>>1) Enclave wants to treat host as parent (default). In this 
>>>>scenario,
>>>>the "parent instance" that shows up as CID 3 in the Enclave doesn't
>>>>really exist. Instead, when the Enclave attempts to talk to CID 3, it
>>>>should really land on CID 0 (hypervisor). When the hypervisor tries to
>>>>connect to the Enclave on port X, it should look as if it originates
>>>>from CID 3, not CID 0.
>>>>
>>>>2) Multiple parent VMs. Think of an actual cloud hosting scenario.
>>>>Here, we have multiple "parent instances". Each of them thinks it's
>>>>CID 3. Each can spawn an Enclave that talks to CID 3 and reach the
>>>>parent. For this case, I think implementing all of virtio-vsock in
>>>>user space is the best path forward. But in theory, you could also
>>>>swizzle CIDs to make random "real" CIDs appear as CID 3.
>>>>
>>>
>>>Thank you for clarifying the use cases!
>>>
>>>Also for case 1, vhost-vsock doesn't support CID 0, so in my opinion
>>>it's easier to go into user-space with vhost-user-vsock or the built-in
>>>device.
>>
>>
>>Sorry, I believe I meant CID 2. Effectively for case 1, when a 
>>process on the hypervisor listens on port 1234, it should be visible 
>>as 3:1234 from the VM and when the hypervisor process connects to 
>><VM CID>:1234, it should look as if that connection came from CID 3.
>
>
>Now that I'm thinking about my message again: What if we just introduce 
>a sysfs/sysctl file for vsock that indicates the "host CID" (default: 
>2)? Users that want vhost-vsock to behave as if the host is CID 3 can 
>just write 3 to it.

I don't know if I understand the final use case well, so I'll try to 
summarize it:

what you would like is to have the ability to receive/send messages from 
the host to a guest as if it were a sibling VM, so as if it had a CID 
!=2 (in your case 3). The important point is to use AF_VSOCK in the host 
application, so no a unix-socket like firecracker.

Is this correct?

I thought you were using firecracker for this scenario, so it seemed to 
make sense to expect user applications to support hybrid vsock.

>
>It means we'd need to change all references to VMADDR_CID_HOST to 
>instead refer to a global variable that indicates the new "host CID". 
>It'd need some more careful massaging to not break number namespace 
>assumptions (<= CID_HOST no longer works), but the idea should fly.
>
>That would give us all 3 options:
>
>1) User sets vsock.host_cid = 3 to simulate that the host is in 
>reality an enclave parent
>2) User spawns VM with CID = 3 to run parent payload inside
>3) User spawns parent and enclave VMs with vhost-vsock-user which 
>creates its own CID namespace
>
>
>Stefano, WDYT?

This would require many changes in the af_vsock core as well. Perhaps we 
can avoid touching the core in this way:

1. extend vhost-vsock to support VMADDR_FLAG_TO_HOST (this is need also
    when the user spawns a VM with CID = 3 using vhost-vsock).
    Some new ioctl/sysfs should be needed to create an allowlist of CIDs
    that may or may not be accepted. (note: as now, vhost-vsock discards
    all packets that have dst_cid != 2)

2. create a new G2H transport that will be loaded in the host.
    af_vsock core supports 3 transport types to be loaded at runtime
    simultaneously: looback, G2H (e.g. virtio-vsock, hyper-v, vmci
    driver), H2G (e.g. vhost-vsock kernel module). We originally
    introduced this extension to support nested VMs. This split is used
    mostly to handle CIDs:
    - loopback (local CID = 1)
    - H2G (local CID = 2)
    - G2H (local CID > 2)

    Perhaps the simplest thing is to extend vsock_loopback to be used
    here, but instead of registering as loopback (which can only handle
    CID 1), it should register as G2H, this way we reuse all the logic
    already in the af_vsock core to handle CIDs > 2.

    The only problem is that in this case your host, it can't be nested.
    But upstream there's a proposal to support multiple virtio-vsock
    devices in a guest, so we could adapt it to support this case in the
    future.


WDYT?

Thanks,
Stefano


