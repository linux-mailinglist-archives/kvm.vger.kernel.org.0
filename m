Return-Path: <kvm+bounces-42425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F57A78595
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EB501891BAD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E28A8494;
	Wed,  2 Apr 2025 00:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqwk6oE6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81EF367;
	Wed,  2 Apr 2025 00:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553294; cv=none; b=esOoJ+EV+krM0VLxmu/jnDXN1Gz8TPlEtSZUU4T1CyO2ToCSccg6RV/G3giL4psm4uiWky7QUYsg2hPQzNtYmbJYi8UhK6VZfVTX2KD3cOEWE1YNPyrBwKKph/3YFh86GKxTZCI8gyQCYANKvbDgID+xn7ITOp5VE8XdsQkDdBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553294; c=relaxed/simple;
	bh=g/vGnOWj+RLoNXJFxO2hLBeGdbkn6WT69EDQvJ//6Dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lB+5HTf8rAxXV2S4gs+QfD3KiEp5RT0Uur2yDXCCu3gz14h2G0gvdr/V2zWrnCjb+4LAdpgEv9pbXBn14C4hi8uCfUcEedu/u0s1L2ZJdbwlvEBZe23uK5dHXPUOuOE1J9Wx8XdD2dJPQb4UxVBPZTx6WEFNXkaGkN24fTEAqnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kqwk6oE6; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22622ddcc35so48520695ad.2;
        Tue, 01 Apr 2025 17:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743553292; x=1744158092; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZeLn/wYhVo9FIJa6C3cWnGduVLCV+HiAmOS2o0hOnJo=;
        b=kqwk6oE6FfnKfTOvqOikqwQCLlNV9oplDwQvx8fowkWk3u606A/rVxAJqkMyER5cuE
         q1XJopoRCoXrnLd24QcQD5tOk4eV0nIt06S6bnaLXXzFf3Ep6KQLtAUGzXCrXP8z77Nz
         bM8CbbPxDsrczzxhZ8SBEAnx8EEV3tE7ZyG99RPaKqIZZZQkbEN1Gju+TC6E7QwdV2tI
         cKCkxeFmvIRQ0crD7VBcd3pUn++uYb/r1K3LF54RrEPlbeSBWQ/DeU7PsWPKnzFj7g5x
         QGagL+OCLSl7S+xnElzIuMfRH+327hgxxruSDhRVvywCN781f+Jv3coepXlxWunh24Q5
         TdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743553292; x=1744158092;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeLn/wYhVo9FIJa6C3cWnGduVLCV+HiAmOS2o0hOnJo=;
        b=SnEd1OU2F/j2Qwy4DYjbPIijChrjj0P1TYi4b7C4jU3u4i/Git81XaIs//Eclyb+Ty
         cvRTwvWUkqyLrkwqvVdx/+qUR1ytW0VXDFvvzj2/YuDezSRG3iItd3crikTNNlHw8mcI
         fzZ5WuZvOJWii0rSRUQgdVu6ovrCXjt3QN5bIr+xqEuG5rdX7WaPkhZ9q22rxtQlo3q0
         HWsBmnkj45n/Kg/uC4gqfiWyWwwvYtMmSF+p5uZVxpHuHsc8FN2ywW9vud1AoALBVAaM
         zWslCg0qV2cwqcAi9/FRX/HNsX2GgiRcE2pEw2nn00/BJqXrZrZVacqVeQFEiPE3TwZb
         uKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlMyJW0+0waQwM2Ac0YYXgEtx4ZerGWZMgaUN48ogJgU/sjYDsfLyRPwVdiyU/pTBFiyEvW+9Q1Ir6EFgL@vger.kernel.org, AJvYcCV4cf/60k9Hx9eKQBppXXXFVz7CZHca0Bx+/M/IBtlLkTOro9JOh8tHrM/kRnuUTwI3SH/fmzkcHlSfbTvZ@vger.kernel.org, AJvYcCV5Sj0b+ew1QjtP1pRUagvinwHTXbYUcLnSHcaVpOu2TBsrkYKK0xeUkBV3UbV2MIiGmguJxONu@vger.kernel.org, AJvYcCWVvBdOx98j2xixwa9whKB35luhwiG3+wDe7vrVA2BysvGddKH3O9m1MUfFUduyJES2ZkI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhEysvL2XrPvDWbLk+wLxb/nvsFqnFFbsZWQ1fwYJbUaBdfP4E
	dwvHH0I2J/yIKpOrTGIjgVf2oXdrxmISvRXZ2zaXCHRnMAAbUq7u
X-Gm-Gg: ASbGncsM785IpFWDrJVZPC2lP/131pt/51PvR6wi90jrvjfWvTx+KVXxTwYz4dwSyWu
	trJgj4UxEW3PfiFKaG6SVaVyehqz+adEPGvNYOHMRMGFMdIvVKwwyQ1IX5DLvJ3t9R+OIJXdQA/
	nW2T6TakqMu37WfQUEWTYREqxdpg4AxlpWkjZ+CM0zvLRNlJLs9tNUt1TPaunQDW5PZIPyTh6vp
	RzhBL110O9JdPWtwGwkVqK+xxreZSgrJboLKleqwz/2YBYxxgadSL22q3zDZmTSwNDKmgdyV+3E
	5Q2yhY7Bn+AootfRSstG8gXuM0gUgRHP9BtrOzlRYGWW1WqQCNOyK7gPHksn1IDoJuDN/vYtgJN
	p
X-Google-Smtp-Source: AGHT+IG+mezWcwSTSWGHMlaSZh1ZMn0L/JmAS44qUO3mIuUAuBB2BnPV9gzUgWR5YRWldZH9Je5K7g==
X-Received: by 2002:a05:6a00:4b0f:b0:736:6202:3530 with SMTP id d2e1a72fcca58-739c796698dmr774634b3a.22.1743553291831;
        Tue, 01 Apr 2025 17:21:31 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:5::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710b453dsm9646252b3a.155.2025.04.01.17.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 17:21:30 -0700 (PDT)
Date: Tue, 1 Apr 2025 17:21:28 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z+yDCKt7GpubbTKJ@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
 <Z-w47H3qUXZe4seQ@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z-w47H3qUXZe4seQ@redhat.com>

On Tue, Apr 01, 2025 at 08:05:16PM +0100, Daniel P. Berrangé wrote:
> On Fri, Mar 28, 2025 at 06:03:19PM +0100, Stefano Garzarella wrote:
> > CCing Daniel
> > 
> > On Wed, Mar 12, 2025 at 01:59:34PM -0700, Bobby Eshleman wrote:
> > > Picking up Stefano's v1 [1], this series adds netns support to
> > > vhost-vsock. Unlike v1, this series does not address guest-to-host (g2h)
> > > namespaces, defering that for future implementation and discussion.
> > > 
> > > Any vsock created with /dev/vhost-vsock is a global vsock, accessible
> > > from any namespace. Any vsock created with /dev/vhost-vsock-netns is a
> > > "scoped" vsock, accessible only to sockets in its namespace. If a global
> > > vsock or scoped vsock share the same CID, the scoped vsock takes
> > > precedence.
> > > 
> > > If a socket in a namespace connects with a global vsock, the CID becomes
> > > unavailable to any VMM in that namespace when creating new vsocks. If
> > > disconnected, the CID becomes available again.
> > 
> > I was talking about this feature with Daniel and he pointed out something
> > interesting (Daniel please feel free to correct me):
> > 
> >     If we have a process in the host that does a listen(AF_VSOCK) in a
> > namespace, can this receive connections from guests connected to
> > /dev/vhost-vsock in any namespace?
> > 
> >     Should we provide something (e.g. sysctl/sysfs entry) to disable
> > this behaviour, preventing a process in a namespace from receiving
> > connections from the global vsock address space (i.e.      /dev/vhost-vsock
> > VMs)?
> 
> I think my concern goes a bit beyond that, to the general conceptual
> idea of sharing the CID space between the global vsocks and namespace
> vsocks. So I'm not sure a sysctl would be sufficient...details later
> below..
> 
> > I understand that by default maybe we should allow this behaviour in order
> > to not break current applications, but in some cases the user may want to
> > isolate sockets in a namespace also from being accessed by VMs running in
> > the global vsock address space.
> > 
> > Indeed in this series we have talked mostly about the host -> guest path (as
> > the direction of the connection), but little about the guest -> host path,
> > maybe we should explain it better in the cover/commit
> > descriptions/documentation.
> 
> > > Testing
> > > 
> > > QEMU with /dev/vhost-vsock-netns support:
> > > 	https://github.com/beshleman/qemu/tree/vsock-netns
> > > 
> > > Test: Scoped vsocks isolated by namespace
> > > 
> > >  host# ip netns add ns1
> > >  host# ip netns add ns2
> > >  host# ip netns exec ns1 \
> > > 				  qemu-system-x86_64 \
> > > 					  -m 8G -smp 4 -cpu host -enable-kvm \
> > > 					  -serial mon:stdio \
> > > 					  -drive if=virtio,file=${IMAGE1} \
> > > 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> > >  host# ip netns exec ns2 \
> > > 				  qemu-system-x86_64 \
> > > 					  -m 8G -smp 4 -cpu host -enable-kvm \
> > > 					  -serial mon:stdio \
> > > 					  -drive if=virtio,file=${IMAGE2} \
> > > 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> > > 
> > >  host# socat - VSOCK-CONNECT:15:1234
> > >  2025/03/10 17:09:40 socat[255741] E connect(5, AF=40 cid:15 port:1234, 16): No such device
> > > 
> > >  host# echo foobar1 | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> > >  host# echo foobar2 | sudo ip netns exec ns2 socat - VSOCK-CONNECT:15:1234
> > > 
> > >  vm1# socat - VSOCK-LISTEN:1234
> > >  foobar1
> > >  vm2# socat - VSOCK-LISTEN:1234
> > >  foobar2
> > > 
> > > Test: Global vsocks accessible to any namespace
> > > 
> > >  host# qemu-system-x86_64 \
> > > 	  -m 8G -smp 4 -cpu host -enable-kvm \
> > > 	  -serial mon:stdio \
> > > 	  -drive if=virtio,file=${IMAGE2} \
> > > 	  -device vhost-vsock-pci,guest-cid=15,netns=off
> > > 
> > >  host# echo foobar | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> > > 
> > >  vm# socat - VSOCK-LISTEN:1234
> > >  foobar
> > > 
> > > Test: Connecting to global vsock makes CID unavailble to namespace
> > > 
> > >  host# qemu-system-x86_64 \
> > > 	  -m 8G -smp 4 -cpu host -enable-kvm \
> > > 	  -serial mon:stdio \
> > > 	  -drive if=virtio,file=${IMAGE2} \
> > > 	  -device vhost-vsock-pci,guest-cid=15,netns=off
> > > 
> > >  vm# socat - VSOCK-LISTEN:1234
> > > 
> > >  host# sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> > >  host# ip netns exec ns1 \
> > > 				  qemu-system-x86_64 \
> > > 					  -m 8G -smp 4 -cpu host -enable-kvm \
> > > 					  -serial mon:stdio \
> > > 					  -drive if=virtio,file=${IMAGE1} \
> > > 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> > > 
> > >  qemu-system-x86_64: -device vhost-vsock-pci,netns=on,guest-cid=15: vhost-vsock: unable to set guest cid: Address already in use
> 
> I find it conceptually quite unsettling that the VSOCK CID address
> space for AF_VSOCK is shared between the host and the namespace.
> That feels contrary to how namespaces are more commonly used for
> deterministically isolating resources between the namespace and the
> host.
> 
> Naively I would expect that in a namespace, all VSOCK CIDs are
> free for use, without having to concern yourself with what CIDs
> are in use in the host now, or in future.
> 

True, that would be ideal. I think the definition of backwards
compatibility we've established includes the notion that any VM may
reach any namespace and any namespace may reach any VM. IIUC, it sounds
like you are suggesting this be revised to more strictly adhere to
namespace semantics?

I do like Stefano's suggestion to add a sysctl for a "strict" mode,
Since it offers the best of both worlds, and still tends conservative in
protecting existing applications... but I agree, the non-strict mode
vsock would be unique WRT the usual concept of namespaces.

> What happens if we reverse the QEMU order above, to get the
> following scenario
> 
>    # Launch VM1 inside the NS
>    host# ip netns exec ns1 \
>   				  qemu-system-x86_64 \
>   					  -m 8G -smp 4 -cpu host -enable-kvm \
>   					  -serial mon:stdio \
>   					  -drive if=virtio,file=${IMAGE1} \
>   					  -device vhost-vsock-pci,netns=on,guest-cid=15
>    # Launch VM2
>    host# qemu-system-x86_64 \
>   	  -m 8G -smp 4 -cpu host -enable-kvm \
>   	  -serial mon:stdio \
>   	  -drive if=virtio,file=${IMAGE2} \
>   	  -device vhost-vsock-pci,guest-cid=15,netns=off
>   
>    vm1# socat - VSOCK-LISTEN:1234
>    vm2# socat - VSOCK-LISTEN:1234
> 
>    host# socat - VSOCK-CONNECT:15:1234
>      => Presume this connects to "VM2" running outside the NS
> 
>    host# sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> 
>      => Does this connect to "VM1" inside the NS, or "VM2"
>         outside the NS ?
> 

VM1 inside the NS. Current logic says that whenever two CIDs collide
(local vs global), always select the one in the local namespace
(irrespective of creation order).

Adding a sysctl option... it would *never* connect to the global one,
even if there was no local match but there was a global one.

> 
> 
> With regards,
> Daniel

Thanks for the review!

Best,
Bobby

