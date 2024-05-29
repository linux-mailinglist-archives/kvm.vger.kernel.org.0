Return-Path: <kvm+bounces-18269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC9D88D3073
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1521AB2860A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 08:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB09171E65;
	Wed, 29 May 2024 08:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoTndkzt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2833E16F830
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 08:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716969904; cv=none; b=Idalv6hseR5is7hI1BVpQqiCk7qQJuts0Tit1je6kcrHtLHBavYLh8ogEX+TN9qDiqdRHf4jJiCO70fypSqt0M3DnbKiVglM2wjYvi9CVEECPCxppXtcFblRtm+kqTQ+/0HtJdfljUX5QQ2BpFuRFZfTWtgHZfUdB0vgdoo76JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716969904; c=relaxed/simple;
	bh=mxwFgX0ee/RsDjwK9KZLEjg+gxWKY3iC6TRaX0vb9Vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pUsbTf1Sx31jO69/Dc1eFtxjx5fs4PY8CpUrV89yCKYixr/Agh5EtHfcVMOvE/AaAjOy9+eSKMeahfwP04heT3/XHITI4xrOLA8d2QrTkHmJM2PQqLYL/d5B3wbBnc6LSoA5yQeJYkLeLNurxaHBKehyn/NYm4oDwAfmh289Gpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eoTndkzt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716969901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c0znsjLSE1yLPWNM3y+n583dNDLRUtm6D9bl9xtR23U=;
	b=eoTndkztGLcaIqDJg7w6mYm+WEtrSj3lF5k5Kc2qrOuPYX49QeJ3x/MMa5/4zcV+2yxxSW
	qk7QCd2+jRw0m9M4onDAc5vCbA87BzDIkFULWgJ009t1pphXmAjo4lAkfEGSZNf+8IQW/k
	PEEy/O0T40dSz7NyQg5SGVT4mOhjABU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-xtz1nNGoMhOXARYk7bVuSg-1; Wed, 29 May 2024 04:04:59 -0400
X-MC-Unique: xtz1nNGoMhOXARYk7bVuSg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a62c4ffecefso89816866b.2
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 01:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716969898; x=1717574698;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0znsjLSE1yLPWNM3y+n583dNDLRUtm6D9bl9xtR23U=;
        b=EMdw6B1UAxdA3eYDUOIucBqBr33gicvm9F040jO/1a8Z+L1QwY4dFXC36fO+RrneHM
         TaanI75belFI6BOZ3pyF4QXFdm31GbvqpgX2Y6yrWRUB3YnwmvPJm0KiHLUgUr7r9GWB
         gJ6adgOc0JUkiunFy2t48yiww/DR0Ap+7qfnMz6sIR+0FG4qIc9wSYIfChApqm5mzVdd
         iIaE0UeGD6k1B6P2phXuWNl9EFoubXCVbQr5FMgQPFkTOAwd7KEfzX7wuL7i/3Lu09CK
         fmB/UePTUQvrhVjuyLLe0ZRWpK/z7vdENcGf7Xr4oYDstOY9oA/MxKzmkMuJc1Dbfmlg
         /2zw==
X-Forwarded-Encrypted: i=1; AJvYcCVnEg8P1kqQr6J4c3d4ivPRKUMRW22en5qgpmI/D0rpUCWWmCFJZRhJSVrELcoDXvJ9QSco27Tp63+ALPpLTY8JKm9S
X-Gm-Message-State: AOJu0YzyLv4zk1/ZuFQh2dxMUeE3f3uXNappg18eI1Nbg5jpc6qq4Mh3
	1DTV5piAdxAyJ3D1KVIRnD9NlfZkJIQ4+Z2eHomqannA+PIyLM9qn3HSg8qMmEjEku+SpSI3anJ
	igLvWeXSEc36uU/zhG4p35d6zCuqRERZtBzDB3lQlmqM82fxlMA==
X-Received: by 2002:a17:906:1991:b0:a5a:5496:3c76 with SMTP id a640c23a62f3a-a6264192fe8mr965923066b.6.1716969898135;
        Wed, 29 May 2024 01:04:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFz3oZ6DAlLfDM/y03ogAch7fcEovR9jFh0/fcAMsdrO8YhuD4/gBBFarrhWDhn7bgaFEHpEA==
X-Received: by 2002:a17:906:1991:b0:a5a:5496:3c76 with SMTP id a640c23a62f3a-a6264192fe8mr965918366b.6.1716969896946;
        Wed, 29 May 2024 01:04:56 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6333fdb2b5sm181142966b.211.2024.05.29.01.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 01:04:56 -0700 (PDT)
Date: Wed, 29 May 2024 10:04:52 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <graf@amazon.com>
Cc: Alexander Graf <agraf@csgraf.de>, 
	Dorjoy Chowdhury <dorjoychy111@gmail.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
Message-ID: <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
References: <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
 <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
 <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com>
 <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>

On Tue, May 28, 2024 at 06:38:24PM GMT, Paolo Bonzini wrote:
>On Tue, May 28, 2024 at 5:53 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Tue, May 28, 2024 at 05:49:32PM GMT, Paolo Bonzini wrote:
>> >On Tue, May 28, 2024 at 5:41 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >> >I think it's either that or implementing virtio-vsock in userspace
>> >> >(https://lore.kernel.org/qemu-devel/30baeb56-64d2-4ea3-8e53-6a5c50999979@redhat.com/,
>> >> >search for "To connect host<->guest").
>> >>
>> >> For in this case AF_VSOCK can't be used in the host, right?
>> >> So it's similar to vhost-user-vsock.
>> >
>> >Not sure if I understand but in this case QEMU knows which CIDs are
>> >forwarded to the host (either listen on vsock and connect to the host,
>> >or vice versa), so there is no kernel and no VMADDR_FLAG_TO_HOST
>> >involved.
>>
>> I meant that the application in the host that wants to connect to the
>> guest cannot use AF_VSOCK in the host, but must use the one where QEMU
>> is listening (e.g. AF_INET, AF_UNIX), right?
>>
>> I think one of Alex's requirements was that the application in the host
>> continue to use AF_VSOCK as in their environment.
>
>Can the host use VMADDR_CID_LOCAL for host-to-host communication?

Yep!

>If
>so, the proposed "-object vsock-forward" syntax can connect to it and
>it should work as long as the application on the host does not assume
>that it is on CID 3.

Right, good point!
We can also support something similar in vhost-user-vsock, where instead 
of using AF_UNIX and firecracker's hybrid vsock, we can redirect 
everything to VMADDR_CID_LOCAL.

Alex what do you think? That would simplify things a lot to do.
The only difference is that the application in the host has to talk to 
VMADDR_CID_LOCAL (1).

Stefano


