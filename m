Return-Path: <kvm+bounces-18216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2688D2038
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 242621F2422D
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDC117109C;
	Tue, 28 May 2024 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0/H/h33"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B2F16F260
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716909586; cv=none; b=soo2wtVDuOh51CwmZvIGLtz7XLArEzSOhcpkzUEaZTBEFrj/i4UVRWpG/5hudiXFCHdPdSl1vtJOMmpY7UTyq9DoNe4FEeMKSV1ktBt+ESfJRmMeKZTy8urKzQ1hPTyajH3ov6AOV7MO73BMC2ATZFbvATn/4pYZZhIoL6mVpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716909586; c=relaxed/simple;
	bh=swH47NzLIrWmNG5Dq5kPKHjN8HHyRyCcrtbFdlo9EWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WQx7Xzllr9gv4447CoKQHQehedPu1OCnm04KndzeZPqqGa2ERe50S9zc6hGqvDcdmZNqQhe6D47bWrzRsN1HYLCe+rTNwnUcQNEP5BkB6aGxqjUWJaCOjPvPXeATLtqjzKej4NIldG6guMxcdNXUcanEbOQR4b1osRaYgWRJ7Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0/H/h33; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716909583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vsaiDIPGuDsuYpLn1cPcKBqTvdjJak0yaX0MA31ltAg=;
	b=E0/H/h338pzXkAqgKhjlYojsQa1wKaDp0+Njz4Udeo76os3BEqLUfel0ypcVMJ0ET5mhpo
	3Cp82PnT0sObxmgih/jg72OycX0z0l7iY/F1Wffw+7Xqcwb5p7sa6KFjo0F7wAGNMhXspI
	O/xMsCQxlVE8HU42c0Q7cXrw+n0eNNo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-NQWeCrp7NlKstlCrbfQN4Q-1; Tue, 28 May 2024 11:19:41 -0400
X-MC-Unique: NQWeCrp7NlKstlCrbfQN4Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-57865139b7dso2907190a12.1
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 08:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716909578; x=1717514378;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vsaiDIPGuDsuYpLn1cPcKBqTvdjJak0yaX0MA31ltAg=;
        b=EMoKcjqFd4G1NzyVxBLr210kW/6mg5GSGKWUD15+tpCg2OUNkoOP4no8IzQVvmPh8U
         Xtm9QtMQlhNLDxZlcf9EVJTLj5xi7Q1lUTaO2JoVYRWYjzqVtnbfdYEgBD6jj1yHxgca
         3/r6cJiPZv+lhdKUdQJffKKcqzvsfauGcDh8p7kCX4ipBFY9BJyUb18YAuv5GeOZL1jr
         GcpPtXUPZwm+doK+KbVtvI6MRV2NUrfTe7S8keblD8lb5aaRDImDLWYJzvGZv9FdTsLp
         gqfzFnDZJS2dpA3XpdzmXMde8hy5PugRDBYm2YZZBr98q+8ZOZxlXMa6WCDisqsGbRMx
         BDYQ==
X-Forwarded-Encrypted: i=1; AJvYcCViWQx6wjJiLkfQcnzNCb3aBPqxaoVWJ5cuzozQX83PU+GB68heMixFJokPTjRXVcaSfSz5koaqU/4YO8LXk6WSM2/6
X-Gm-Message-State: AOJu0YyIKtGKnrMD+uOGXz/8RS4ei3f+0+LAvTqDTqWLzlopkKpG764+
	BUt13bDRQZuXbXY1gh54SvSC8wiBdGtpkn/O7fDuT9yFVStGNuV1i+mz4jplVtmQXWBSJzclJls
	KzlR4XI9XoctZUPR8G0/t8HI4ru6J5kIwty6SLgZBQIiWWzcPAQ==
X-Received: by 2002:a50:f60d:0:b0:574:c3e4:1fa3 with SMTP id 4fb4d7f45d1cf-57857e0f3a5mr8638102a12.20.1716909577997;
        Tue, 28 May 2024 08:19:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnuWIkISeq3N/UOY4U5xmXRTy3oOBrZnKO4yXJDBoC7X5FT2/X7div/OaN+ItViOMh/FOQmQ==
X-Received: by 2002:a50:f60d:0:b0:574:c3e4:1fa3 with SMTP id 4fb4d7f45d1cf-57857e0f3a5mr8638078a12.20.1716909577559;
        Tue, 28 May 2024 08:19:37 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-579c3fac836sm4424676a12.89.2024.05.28.08.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 08:19:37 -0700 (PDT)
Message-ID: <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com>
Date: Tue, 28 May 2024 17:19:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Alexander Graf <graf@amazon.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Alexander Graf <agraf@csgraf.de>
Cc: Dorjoy Chowdhury <dorjoychy111@gmail.com>,
 virtualization@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org,
 stefanha@redhat.com
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
 <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
 <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/24 09:54, Alexander Graf wrote:
> 
> On 27.05.24 09:08, Alexander Graf wrote:
>> Hey Stefano,
>>
>> On 23.05.24 10:45, Stefano Garzarella wrote:
>>> On Tue, May 21, 2024 at 08:50:22AM GMT, Alexander Graf wrote:
>>>> Howdy,
>>>>
>>>> On 20.05.24 14:44, Dorjoy Chowdhury wrote:
>>>>> Hey Stefano,
>>>>>
>>>>> Thanks for the reply.
>>>>>
>>>>>
>>>>> On Mon, May 20, 2024, 2:55 PM Stefano Garzarella 
>>>>> <sgarzare@redhat.com> wrote:
>>>>>> Hi Dorjoy,
>>>>>>
>>>>>> On Sat, May 18, 2024 at 04:17:38PM GMT, Dorjoy Chowdhury wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
>>>>>>> emulation support in QEMU. Alexander Graf is mentoring me on this 
>>>>>>> work. A v1
>>>>>>> patch series has already been posted to the qemu-devel mailing 
>>>>>>> list[2].
>>>>>>>
>>>>>>> AWS nitro enclaves is an Amazon EC2[3] feature that allows 
>>>>>>> creating isolated
>>>>>>> execution environments, called enclaves, from Amazon EC2 
>>>>>>> instances, which are
>>>>>>> used for processing highly sensitive data. Enclaves have no 
>>>>>>> persistent storage
>>>>>>> and no external networking. The enclave VMs are based on 
>>>>>>> Firecracker microvm
>>>>>>> and have a vhost-vsock device for communication with the parent 
>>>>>>> EC2 instance
>>>>>>> that spawned it and a Nitro Secure Module (NSM) device for 
>>>>>>> cryptographic
>>>>>>> attestation. The parent instance VM always has CID 3 while the 
>>>>>>> enclave VM gets
>>>>>>> a dynamic CID. The enclave VMs can communicate with the parent 
>>>>>>> instance over
>>>>>>> various ports to CID 3, for example, the init process inside an 
>>>>>>> enclave sends a
>>>>>>> heartbeat to port 9000 upon boot, expecting a heartbeat reply, 
>>>>>>> letting the
>>>>>>> parent instance know that the enclave VM has successfully booted.
>>>>>>>
>>>>>>> The plan is to eventually make the nitro enclave emulation in 
>>>>>>> QEMU standalone
>>>>>>> i.e., without needing to run another VM with CID 3 with proper vsock
>>>>>> If you don't have to launch another VM, maybe we can avoid 
>>>>>> vhost-vsock
>>>>>> and emulate virtio-vsock in user-space, having complete control 
>>>>>> over the
>>>>>> behavior.
>>>>>>
>>>>>> So we could use this opportunity to implement virtio-vsock in QEMU 
>>>>>> [4]
>>>>>> or use vhost-user-vsock [5] and customize it somehow.
>>>>>> (Note: vhost-user-vsock already supports sibling communication, so 
>>>>>> maybe
>>>>>> with a few modifications it fits your case perfectly)
>>>>>>
>>>>>> [4] https://gitlab.com/qemu-project/qemu/-/issues/2095
>>>>>> [5] 
>>>>>> https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock
>>>>>
>>>>>
>>>>> Thanks for letting me know. Right now I don't have a complete picture
>>>>> but I will look into them. Thank you.
>>>>>>
>>>>>>
>>>>>>> communication support. For this to work, one approach could be to 
>>>>>>> teach the
>>>>>>> vhost driver in kernel to forward CID 3 messages to another CID N
>>>>>> So in this case both CID 3 and N would be assigned to the same QEMU
>>>>>> process?
>>>>>
>>>>>
>>>>> CID N is assigned to the enclave VM. CID 3 was supposed to be the
>>>>> parent VM that spawns the enclave VM (this is how it is in AWS, where
>>>>> an EC2 instance VM spawns the enclave VM from inside it and that
>>>>> parent EC2 instance always has CID 3). But in the QEMU case as we
>>>>> don't want a parent VM (we want to run enclave VMs standalone) we
>>>>> would need to forward the CID 3 messages to host CID. I don't know if
>>>>> it means CID 3 and CID N is assigned to the same QEMU process. Sorry.
>>>>
>>>>
>>>> There are 2 use cases here:
>>>>
>>>> 1) Enclave wants to treat host as parent (default). In this scenario,
>>>> the "parent instance" that shows up as CID 3 in the Enclave doesn't
>>>> really exist. Instead, when the Enclave attempts to talk to CID 3, it
>>>> should really land on CID 0 (hypervisor). When the hypervisor tries to
>>>> connect to the Enclave on port X, it should look as if it originates
>>>> from CID 3, not CID 0.
>>>>
>>>> 2) Multiple parent VMs. Think of an actual cloud hosting scenario.
>>>> Here, we have multiple "parent instances". Each of them thinks it's
>>>> CID 3. Each can spawn an Enclave that talks to CID 3 and reach the
>>>> parent. For this case, I think implementing all of virtio-vsock in
>>>> user space is the best path forward. But in theory, you could also
>>>> swizzle CIDs to make random "real" CIDs appear as CID 3.
>>>>
>>>
>>> Thank you for clarifying the use cases!
>>>
>>> Also for case 1, vhost-vsock doesn't support CID 0, so in my opinion
>>> it's easier to go into user-space with vhost-user-vsock or the built-in
>>> device.
>>
>>
>> Sorry, I believe I meant CID 2. Effectively for case 1, when a process 
>> on the hypervisor listens on port 1234, it should be visible as 3:1234 
>> from the VM and when the hypervisor process connects to <VM CID>:1234, 
>> it should look as if that connection came from CID 3.
> 
> 
> Now that I'm thinking about my message again: What if we just introduce 
> a sysfs/sysctl file for vsock that indicates the "host CID" (default: 
> 2)? Users that want vhost-vsock to behave as if the host is CID 3 can 
> just write 3 to it.
> 
> It means we'd need to change all references to VMADDR_CID_HOST to 
> instead refer to a global variable that indicates the new "host CID". 
> It'd need some more careful massaging to not break number namespace 
> assumptions (<= CID_HOST no longer works), but the idea should fly.

Forwarding one or more ports of a given CID to CID 2 (the host) should 
be doable with a dummy vhost client that listens to CID 3, connects to 
CID 2 and send data back and forth.  Not hard enough to justify changing 
all references to VMADDR_CID_HOST (and also I am not sure if vsock 
supports network namespaces?  then the sysctl/sysfs way is not feasible 
because you cannot set it per-netns, can you?).  It also has the 
disadvantages that different QEMU instances are not insulated.

I think it's either that or implementing virtio-vsock in userspace 
(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c50999979@redhat.com/, 
search for "To connect host<->guest").

Paolo


