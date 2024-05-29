Return-Path: <kvm+bounces-18277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5C28D34FE
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0888D1F2516A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA4517BB2A;
	Wed, 29 May 2024 10:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EcArVvro"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A9217B50C
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 10:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716980171; cv=none; b=VXaFtznnYjqXm82iecKNBvf8i3LlkOQqUUJfmEZKCyFnfnuAfVfdAHi0nMO/FylQtwJVcQ5aTWkAuleeUxiWM6Nkxa733Zj2SHCP7riIbS+ZM0W+rSVQcro9i/C66cmHN0YCKfZo01JNwb/VwkUgQtKWt1Rq9sCgCAWE01C6LOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716980171; c=relaxed/simple;
	bh=2eq9RHpWGnbH5bMsvZ9gjK91MtzdKTlb2oxg+DVHL3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkuUfAvw1siIeB/dJTI9YpNIKhY3yfhLEHwAhKNuecnGIytz/C90vyCeFysHjIpzP3vGht5Oh0VT8TmXEpxYsWXDIQffBhO95EcalvFpIxUnfugjKGttxKUsfBtNvZu0UXYtMlqgna9LT3r53CB8A1+SGMlXxtAlqeAMcW+KUEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EcArVvro; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716980168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/IW4Faf1WCV8kgopnLSo94ttZs/Y2hkDErm/OSdzVk=;
	b=EcArVvroa6p8EV6aJ2SAiIAN3aVsQlqHPmjCj6HFY8qpGdOlgvMnvorGURGpMBs4zGxKqz
	+WTUiFjwqXJGyDBEbSqMQWXxnX23N7PnKbRIvFvBTcKk806GsOAkWGWGLZ779TOl3x9+u7
	cuAnEpxZUtqN25Uv/659iQqiSCAUIXQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-mv3q8uSKPpKd3NiSEJlctg-1; Wed, 29 May 2024 06:56:06 -0400
X-MC-Unique: mv3q8uSKPpKd3NiSEJlctg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-43f7eb72eccso13307821cf.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 03:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716980166; x=1717584966;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/IW4Faf1WCV8kgopnLSo94ttZs/Y2hkDErm/OSdzVk=;
        b=gUBKAodFU75sxpUWVVV8nLq7MIqdefBR3qficbz8jxySb+xLIgSk3OkZcmkGDJDp0Z
         tAxIQJdbrxbCBa/fVTEPpd9Nw+ltGqYcFbbIKqR9Ljp7kPLpAkd2ieUibi2PGU3PetfY
         Au77lqxXrLwCmDFHRINByqtVoh/M3Vbl1J4iukZEWVlKPAA43kdHZgXZys/y6qqcYkFn
         mTaj9GDT0na4S19x2+8m9yZUqXY8lGm+HqE6OZzvED+yOO6Qz3UFl0GoZnRRuhK9L6BO
         akfmT9GmnLi6T9Ow5lPNYpNdXDfAERYt97GuCkEf7BmE8dYfRbAo5tsUBQGY+HvRQZBS
         BDXw==
X-Forwarded-Encrypted: i=1; AJvYcCXkFMTFe3G9mRtbf0Vgj6FSAZOcx1iasGhg4qgrWC8uAObhM+Ge9FU1naH2OoulZ8y23rRPIWs6bbJfYXUhp1k7n4t+
X-Gm-Message-State: AOJu0YzIxNC2LE1B9YE5SZbptd0sL0w3EqXwk9K+NGwEg20h94IRwa8B
	Xple2aorBICeQ+Zg16tPGkBTHUiXipw4YgWBxUe8ta58/4ksZd/XttKJZmVHmYmaG/GrAQN04ZA
	caurAfqEdZzTvFsIn3dQOgBWYhaz9QXyUAUBBra446s5lud3jtA==
X-Received: by 2002:ac8:5ad4:0:b0:43a:c0c7:a218 with SMTP id d75a77b69052e-43fe12871b8mr24606871cf.33.1716980166356;
        Wed, 29 May 2024 03:56:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYZXr2GVdAp/Ri4KfEP1VHGQ64i7iFk7NFAo87pQluTH/X3DAr8lzSE1WqVCix95BVrkz/+A==
X-Received: by 2002:ac8:5ad4:0:b0:43a:c0c7:a218 with SMTP id d75a77b69052e-43fe12871b8mr24606671cf.33.1716980165996;
        Wed, 29 May 2024 03:56:05 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43fb1832368sm52838811cf.57.2024.05.29.03.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 03:56:05 -0700 (PDT)
Date: Wed, 29 May 2024 12:55:53 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>, 
	Dorjoy Chowdhury <dorjoychy111@gmail.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <hyrgztjkjmftnpra2o2skonfs6bwf2sqrncwtec3e4ckupe5ea@76whtcp3zapf>
References: <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
 <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com>
 <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
 <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
 <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com>

On Wed, May 29, 2024 at 12:43:57PM GMT, Alexander Graf wrote:
>
>On 29.05.24 10:04, Stefano Garzarella wrote:
>>
>>On Tue, May 28, 2024 at 06:38:24PM GMT, Paolo Bonzini wrote:
>>>On Tue, May 28, 2024 at 5:53 PM Stefano Garzarella 
>>><sgarzare@redhat.com> wrote:
>>>>
>>>>On Tue, May 28, 2024 at 05:49:32PM GMT, Paolo Bonzini wrote:
>>>>>On Tue, May 28, 2024 at 5:41 PM Stefano Garzarella 
>>>><sgarzare@redhat.com> wrote:
>>>>>> >I think it's either that or implementing virtio-vsock in userspace
>>>>>> >(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c50999979@redhat.com/,
>>>>>> >search for "To connect host<->guest").
>>>>>>
>>>>>> For in this case AF_VSOCK can't be used in the host, right?
>>>>>> So it's similar to vhost-user-vsock.
>>>>>
>>>>>Not sure if I understand but in this case QEMU knows which CIDs are
>>>>>forwarded to the host (either listen on vsock and connect to the host,
>>>>>or vice versa), so there is no kernel and no VMADDR_FLAG_TO_HOST
>>>>>involved.
>>>>
>>>>I meant that the application in the host that wants to connect to the
>>>>guest cannot use AF_VSOCK in the host, but must use the one where QEMU
>>>>is listening (e.g. AF_INET, AF_UNIX), right?
>>>>
>>>>I think one of Alex's requirements was that the application in the host
>>>>continue to use AF_VSOCK as in their environment.
>>>
>>>Can the host use VMADDR_CID_LOCAL for host-to-host communication?
>>
>>Yep!
>>
>>>If
>>>so, the proposed "-object vsock-forward" syntax can connect to it and
>>>it should work as long as the application on the host does not assume
>>>that it is on CID 3.
>>
>>Right, good point!
>>We can also support something similar in vhost-user-vsock, where instead
>>of using AF_UNIX and firecracker's hybrid vsock, we can redirect
>>everything to VMADDR_CID_LOCAL.
>>
>>Alex what do you think? That would simplify things a lot to do.
>>The only difference is that the application in the host has to talk to
>>VMADDR_CID_LOCAL (1).
>
>
>The application in the host would see an incoming connection from CID 
>1 (which is probably fine) and would still be able to establish 
>outgoing connections to the actual VM's CID as long as the Enclave 
>doesn't check for the peer CID (I haven't seen anyone check yet). So 
>yes, indeed, this should work.
>
>The only case where I can see it breaking is when you run multiple 
>Enclave VMs in parallel. In that case, each would try to listen to CID 
>3 and the second that does would fail. But it's a well solvable 
>problem: We could (in addition to the simple in-QEMU case) build an 
>external daemon that does the proxying and hence owns CID3.

Well, we can modify vhost-user-vsock for that. It's already a daemon, 
already supports different VMs per single daemon but as of now they have 
to have different CIDs.

>
>So the immediate plan would be to:
>
>  1) Build a new vhost-vsock-forward object model that connects to 
>vhost as CID 3 and then forwards every packet from CID 1 to the 
>Enclave-CID and every packet that arrives on to CID 3 to CID 2.

This though requires writing completely from scratch the virtio-vsock 
emulation in QEMU. If you have time that would be great, otherwise if 
you want to do a PoC, my advice is to start with vhost-user-vsock which 
is already there.

Thanks,
Stefano

>  2) Create a machine option for -M nitro-enclave that automatically 
>spawns the vhost-vsock-forward object. (default: off)
>
>
>The above may need some fiddling with object creation times to ensure 
>that the forward object gets CID 3, not the Enclave as auto-assigned 
>CID.
>
>
>Thanks,
>
>Alex
>
>
>
>
>Amazon Web Services Development Center Germany GmbH
>Krausenstr. 38
>10117 Berlin
>Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
>Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
>Sitz: Berlin
>Ust-ID: DE 365 538 597


