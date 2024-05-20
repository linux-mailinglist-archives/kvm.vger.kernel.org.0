Return-Path: <kvm+bounces-17750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0987A8C9A01
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 10:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D8811F21ACA
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 08:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFB61CA87;
	Mon, 20 May 2024 08:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPLSaFYE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF2AE554
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716195337; cv=none; b=T3HwuhdPla7jtauFYzZt/xh1+umI2V54UGKuHVjKKtB85wn55iWClg0SZoX8II3+BQRPw2xM+6pqbKoAfo7K5qM5u2OnE0mYd0USb2/dSJC4/B3zxa1BYGtBlgWjOIxNp+VrjW4q5lxyNKfzn7pZK299nYLoqrkhj+Ts+pxpiPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716195337; c=relaxed/simple;
	bh=zOveTwTANzAYimu3FBsiFyK8fzKWl7a/ASIdBtEaTDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgbAvXN7vqM0hEqof3CSblfWPEhhfYkde83UibjiEmlgIu20cTH2o3KnCJ+nLvgXePIxG5mXuCEAY5LZnOi6wFRrWPbedJSnCNq+T5ADwggcfhckVmlnaH62pqsdFyhJv1V0FXBjfbqXrFvRR4IHM/b6OSzQ1gavs2UcSRa6VhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPLSaFYE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716195334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ude2J6/YxYo8bNsBtIomuhFYlpHiE03QinnQpgm+Mes=;
	b=PPLSaFYEObnLfVw/xENIYpquSU1MtGVnKtZHCWkCE5DHer3YVuTtP5/DYelCO09rnEAqGY
	vvTtKp5Br0YF3gEWkh5nLzfS19jXeatJ7K9Tbq6IyjCiTgoa5/ZOSmyzdyeX36UR9X/8cQ
	qNKMhyHlERCqBRe0utxHBfnJlkIi3lQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-mCZvVvVaN0yOtAjXR4jyxw-1; Mon, 20 May 2024 04:55:33 -0400
X-MC-Unique: mCZvVvVaN0yOtAjXR4jyxw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6a884aca64bso23809236d6.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 01:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716195333; x=1716800133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ude2J6/YxYo8bNsBtIomuhFYlpHiE03QinnQpgm+Mes=;
        b=opU6autZEi2FvCOwQPP86PefeGKk2RMLBt5C3veUXpvkujUYDzVSdSmNmTvBpqff1l
         V1gyVlRFh/MePlS3Wi7/dubBE8Ru/gExwG6QJLF6Ge5xLR6Foytss3WHYW7XJtfeWozu
         XIoOKISIOHVInXO8tCrwa53gcssE/HeNMqjhKB3ULOxrh3AY5gn+/k9PyaAE6WG/YFDO
         Kt6RDA2Qq7lpSWovk7E7/NhQ8HXI2zic04UfLaoyD37Abze0rBol3RuJ+Yjko8+LkIKl
         Aft4A8N+3sUmv5pqVUs0F/OnHnus09O0eqzEcUui/35pM2R4bxGQ3aGED9BSHUT1/a2U
         XJxA==
X-Forwarded-Encrypted: i=1; AJvYcCW9AuKqVUgbwOkhNGcTIXtmFD6EfPmtDXJxnN5cHkb0kgRn6PB2uMEWQlNZ0pfV7Lh2Y9RRen+bw9q15pBTczS4i4iq
X-Gm-Message-State: AOJu0Yx8ZvUw0ojNQNsrpSdu4BGm85pNBjz51k82XLZRFZPyzxkLltiv
	zxMiDDp2pr6RsuThx2/S/Z/51sMXZp4EJ4yXZzQi5nJSu/oDOl7oG8YEQmQIJXfCwQhyeiCSQ79
	HHYTecMn5hMOTRWR/nXiumJmitm1U3ac3D5kn9xI28xL6DNkKyw==
X-Received: by 2002:a05:6214:5d05:b0:69b:2523:fcd3 with SMTP id 6a1803df08f44-6a16825d79dmr338328336d6.60.1716195332704;
        Mon, 20 May 2024 01:55:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFR8gdnVof1nmsWGREGF+KmJcs+xK22+zO3SVF1/gM6fpWReTV080ow/jA5YNvO2eD5VdzcYw==
X-Received: by 2002:a05:6214:5d05:b0:69b:2523:fcd3 with SMTP id 6a1803df08f44-6a16825d79dmr338328186d6.60.1716195332350;
        Mon, 20 May 2024 01:55:32 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-77.business.telecomitalia.it. [87.12.25.77])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f194da1sm109949106d6.67.2024.05.20.01.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 01:55:31 -0700 (PDT)
Date: Mon, 20 May 2024 10:55:26 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>, agraf@csgraf.de, 
	stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>

Hi Dorjoy,

On Sat, May 18, 2024 at 04:17:38PM GMT, Dorjoy Chowdhury wrote:
>Hi,
>
>Hope you are doing well. I am working on adding AWS Nitro Enclave[1]
>emulation support in QEMU. Alexander Graf is mentoring me on this work. A v1
>patch series has already been posted to the qemu-devel mailing list[2].
>
>AWS nitro enclaves is an Amazon EC2[3] feature that allows creating isolated
>execution environments, called enclaves, from Amazon EC2 instances, which are
>used for processing highly sensitive data. Enclaves have no persistent storage
>and no external networking. The enclave VMs are based on Firecracker microvm
>and have a vhost-vsock device for communication with the parent EC2 instance
>that spawned it and a Nitro Secure Module (NSM) device for cryptographic
>attestation. The parent instance VM always has CID 3 while the enclave VM gets
>a dynamic CID. The enclave VMs can communicate with the parent instance over
>various ports to CID 3, for example, the init process inside an enclave sends a
>heartbeat to port 9000 upon boot, expecting a heartbeat reply, letting the
>parent instance know that the enclave VM has successfully booted.
>
>The plan is to eventually make the nitro enclave emulation in QEMU standalone
>i.e., without needing to run another VM with CID 3 with proper vsock

If you don't have to launch another VM, maybe we can avoid vhost-vsock 
and emulate virtio-vsock in user-space, having complete control over the 
behavior.

So we could use this opportunity to implement virtio-vsock in QEMU [4] 
or use vhost-user-vsock [5] and customize it somehow.
(Note: vhost-user-vsock already supports sibling communication, so maybe 
with a few modifications it fits your case perfectly)

[4] https://gitlab.com/qemu-project/qemu/-/issues/2095
[5] https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock

>communication support. For this to work, one approach could be to teach the
>vhost driver in kernel to forward CID 3 messages to another CID N

So in this case both CID 3 and N would be assigned to the same QEMU
process?

Do you have to allocate 2 separate virtio-vsock devices, one for the 
parent and one for the enclave?

>(set to CID 2 for host) i.e., it patches CID from 3 to N on incoming messages
>and from N to 3 on responses. This will enable users of the

Will these messages have the VMADDR_FLAG_TO_HOST flag set?

We don't support this in vhost-vsock yet, if supporting it helps, we 
might, but we need to better understand how to avoid security issues, so 
maybe each device needs to explicitly enable the feature and specify 
from which CIDs it accepts packets.

>nitro-enclave machine
>type in QEMU to run the necessary vsock server/clients in the host machine
>(some defaults can be implemented in QEMU as well, for example, sending a reply
>to the heartbeat) which will rid them of the cumbersome way of running another
>whole VM with CID 3. This way, users of nitro-enclave machine in QEMU, could
>potentially also run multiple enclaves with their messages for CID 3 forwarded
>to different CIDs which, in QEMU side, could then be specified using a new
>machine type option (parent-cid) if implemented. I guess in the QEMU side, this
>will be an ioctl call (or some other way) to indicate to the host kernel that
>the CID 3 messages need to be forwarded. Does this approach of

What if there is already a VM with CID = 3 in the system?

>forwarding CID 3 messages to another CID sound good?

It seems too specific a case, if we can generalize it maybe we could 
make this change, but we would like to avoid complicating vhost-vsock 
and keep it as simple as possible to avoid then having to implement 
firewalls, etc.

So first I would see if vhost-user-vsock or the QEMU built-in device is 
right for this use-case.

Thanks,
Stefano

>
>If this approach sounds good, I need some guidance on where the code
>should be written in order to achieve this. I would greatly appreciate
>any suggestions.
>
>Thanks.
>
>Regards,
>Dorjoy
>
>[1] https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html
>[2] https://mail.gnu.org/archive/html/qemu-devel/2024-05/msg03524.html
>[3] https://aws.amazon.com/ec2/
>


