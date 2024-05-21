Return-Path: <kvm+bounces-17828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FDB8CA7C9
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 07:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB3D01C217E1
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 05:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76A5446B4;
	Tue, 21 May 2024 05:58:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E6720EB;
	Tue, 21 May 2024 05:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.25.223.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716271122; cv=none; b=eGGfoKBPNQcWgffKLWoj+1OgzhhzJcQwGlETIvBl73AHYCa8IXBI1dUpbNosQh1uhzqL46YnulZ72+hP1T9ZiP8hwDsyqkFubqFXzhwVYqQaHD1SCPgG4Q68HFzNPSl01h0mfquPa4yaehbsNBj3bKOjFIWQSB2BytMf+9f9yH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716271122; c=relaxed/simple;
	bh=2tBIfekw7EOyeqfZj5XyURtUTH8bntiRehCEAfN9lRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WN5u/6gwMIqNBcEJBj9NyEoPa9tKbSiUh7LbmTp3PC4wXivbBhXcrFskfbS7k0T7pitNtL4BaSmFZ+Soe/mqTDlO1fLJeUD6g7YWgPTZdTWOmUmwznQcxUXkKzRilBWTy99WVvQj7L+D497VDNDAndxPghWuyhAWK2fxRwEtClw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csgraf.de; spf=pass smtp.mailfrom=csgraf.de; arc=none smtp.client-ip=85.25.223.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csgraf.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgraf.de
Received: from [172.16.45.73] (unknown [195.142.177.30])
	by csgraf.de (Postfix) with ESMTPSA id 57BE460800CF;
	Tue, 21 May 2024 07:50:25 +0200 (CEST)
Message-ID: <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
Date: Tue, 21 May 2024 08:50:22 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
 netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>, stefanha@redhat.com
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
Content-Language: en-US
From: Alexander Graf <agraf@csgraf.de>
In-Reply-To: <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Howdy,

On 20.05.24 14:44, Dorjoy Chowdhury wrote:
> Hey Stefano,
>
> Thanks for the reply.
>
>
> On Mon, May 20, 2024, 2:55 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> Hi Dorjoy,
>>
>> On Sat, May 18, 2024 at 04:17:38PM GMT, Dorjoy Chowdhury wrote:
>>> Hi,
>>>
>>> Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
>>> emulation support in QEMU. Alexander Graf is mentoring me on this work. A v1
>>> patch series has already been posted to the qemu-devel mailing list[2].
>>>
>>> AWS nitro enclaves is an Amazon EC2[3] feature that allows creating isolated
>>> execution environments, called enclaves, from Amazon EC2 instances, which are
>>> used for processing highly sensitive data. Enclaves have no persistent storage
>>> and no external networking. The enclave VMs are based on Firecracker microvm
>>> and have a vhost-vsock device for communication with the parent EC2 instance
>>> that spawned it and a Nitro Secure Module (NSM) device for cryptographic
>>> attestation. The parent instance VM always has CID 3 while the enclave VM gets
>>> a dynamic CID. The enclave VMs can communicate with the parent instance over
>>> various ports to CID 3, for example, the init process inside an enclave sends a
>>> heartbeat to port 9000 upon boot, expecting a heartbeat reply, letting the
>>> parent instance know that the enclave VM has successfully booted.
>>>
>>> The plan is to eventually make the nitro enclave emulation in QEMU standalone
>>> i.e., without needing to run another VM with CID 3 with proper vsock
>> If you don't have to launch another VM, maybe we can avoid vhost-vsock
>> and emulate virtio-vsock in user-space, having complete control over the
>> behavior.
>>
>> So we could use this opportunity to implement virtio-vsock in QEMU [4]
>> or use vhost-user-vsock [5] and customize it somehow.
>> (Note: vhost-user-vsock already supports sibling communication, so maybe
>> with a few modifications it fits your case perfectly)
>>
>> [4] https://gitlab.com/qemu-project/qemu/-/issues/2095
>> [5] https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock
>
>
> Thanks for letting me know. Right now I don't have a complete picture
> but I will look into them. Thank you.
>>
>>
>>> communication support. For this to work, one approach could be to teach the
>>> vhost driver in kernel to forward CID 3 messages to another CID N
>> So in this case both CID 3 and N would be assigned to the same QEMU
>> process?
>
>
> CID N is assigned to the enclave VM. CID 3 was supposed to be the
> parent VM that spawns the enclave VM (this is how it is in AWS, where
> an EC2 instance VM spawns the enclave VM from inside it and that
> parent EC2 instance always has CID 3). But in the QEMU case as we
> don't want a parent VM (we want to run enclave VMs standalone) we
> would need to forward the CID 3 messages to host CID. I don't know if
> it means CID 3 and CID N is assigned to the same QEMU process. Sorry.


There are 2 use cases here:

1) Enclave wants to treat host as parent (default). In this scenario, 
the "parent instance" that shows up as CID 3 in the Enclave doesn't 
really exist. Instead, when the Enclave attempts to talk to CID 3, it 
should really land on CID 0 (hypervisor). When the hypervisor tries to 
connect to the Enclave on port X, it should look as if it originates 
from CID 3, not CID 0.

2) Multiple parent VMs. Think of an actual cloud hosting scenario. Here, 
we have multiple "parent instances". Each of them thinks it's CID 3. 
Each can spawn an Enclave that talks to CID 3 and reach the parent. For 
this case, I think implementing all of virtio-vsock in user space is the 
best path forward. But in theory, you could also swizzle CIDs to make 
random "real" CIDs appear as CID 3.


>
>> Do you have to allocate 2 separate virtio-vsock devices, one for the
>> parent and one for the enclave?
>
>
> If there is a parent VM, then I guess both parent and enclave VMs need
> virtio-vsock devices.
>
>>> (set to CID 2 for host) i.e., it patches CID from 3 to N on incoming messages
>>> and from N to 3 on responses. This will enable users of the
>> Will these messages have the VMADDR_FLAG_TO_HOST flag set?
>>
>> We don't support this in vhost-vsock yet, if supporting it helps, we
>> might, but we need to better understand how to avoid security issues, so
>> maybe each device needs to explicitly enable the feature and specify
>> from which CIDs it accepts packets.
>
>
> I don't know about the flag. So I don't know if it will be set. Sorry.


 From the guest's point of view, the parent (CID 3) is just another VM. 
Since Linux as of

  https://patchwork.ozlabs.org/project/netdev/patch/20201204170235.84387-4-andraprs@amazon.com/#2594117

always sets VMADDR_FLAG_TO_HOST when local_CID > 0 && remote_CID > 0, I 
would say the message has the flag set.

How would you envision the host to implement the flag? Would the host 
allow user space to listen on any CID and hence receive the respective 
target connections? And wouldn't listening on CID 0 then mean you're 
effectively listening to "any" other CID? Thinking about that a bit 
more, that may be just what we need, yes :)


>
>
>>> nitro-enclave machine
>>> type in QEMU to run the necessary vsock server/clients in the host machine
>>> (some defaults can be implemented in QEMU as well, for example, sending a reply
>>> to the heartbeat) which will rid them of the cumbersome way of running another
>>> whole VM with CID 3. This way, users of nitro-enclave machine in QEMU, could
>>> potentially also run multiple enclaves with their messages for CID 3 forwarded
>>> to different CIDs which, in QEMU side, could then be specified using a new
>>> machine type option (parent-cid) if implemented. I guess in the QEMU side, this
>>> will be an ioctl call (or some other way) to indicate to the host kernel that
>>> the CID 3 messages need to be forwarded. Does this approach of
>> What if there is already a VM with CID = 3 in the system?
>
>
> Good question! I don't know what should happen in this case.


See case 2 above :). In a nutshell, I don't think it'd be legal to have 
a real CID 3 in that scenario.


>
>
>>> forwarding CID 3 messages to another CID sound good?
>> It seems too specific a case, if we can generalize it maybe we could
>> make this change, but we would like to avoid complicating vhost-vsock
>> and keep it as simple as possible to avoid then having to implement
>> firewalls, etc.
>>
>> So first I would see if vhost-user-vsock or the QEMU built-in device is
>> right for this use-case.
> Thanks you! I will check everything out and reach out if I need
> further guidance about what needs to be done. And sorry as I wasn't
> able to answer some of your questions.


As mentioned above, I think there is merit for both. I personally care a 
lot more for case 1 over case 2: We already have a working 
implementation of Nitro Enclaves in a Cloud setup. What is missing is a 
way to easily run a Nitro Enclave locally for development.


Alex


