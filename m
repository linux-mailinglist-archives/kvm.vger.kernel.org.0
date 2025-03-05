Return-Path: <kvm+bounces-40149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDE0A4FA18
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 10:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F20A3A28C3
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EAC1E2847;
	Wed,  5 Mar 2025 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrvjDzyA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73471FC7CA
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 09:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741167038; cv=none; b=Wi9ZT7g5T25Gym36ro84tyRHcgM16mi+1H/A4ysMK34knKz11+CeOoZfvJG2uuehE4aQTiK5YOAOyEQ99j2YzLA86hw3yZlv2HYo2IT3qg01WVpHGlqQ45GzOtEIY0n6+8tC9P/hr9UvXaxq0rh5dWT1kVc8KhXNLmL8doCz408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741167038; c=relaxed/simple;
	bh=Vxv0VBbtdbVDbDGLcORTnzoIpxIDB3hFqwWMEq+B6MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1ruSC9/K/NBSdT3Oqom65IkXVk/+Y4FrDe8/7jszYStDvQj48op0bUceHui0i21g8/UPAxOfbprJs0MmUwUTb9JRZn6aPdVzMguNorhFjG1p8GjDzoV7Dd+/N4k1SDkWHnLZScBxQUGMT+MFT8DhTzs9dAXCC4o0Hz8E2GMVSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrvjDzyA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741167036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8BZqtssEKSX9U+sm7giaUTnUcD9w0nxNJyaKF0Dg8jk=;
	b=ZrvjDzyAJjA3AF4vKrijg4WtOSpsejEVLqEv+YV974FkuPBCPfyBE+QsFuv+gYraZu/U4p
	2Z4n8eZ6DIdUoTgedY1D4EsdEJqI0kD/F0SIqklBMfLone4Mmar4yWLwj3JZEbVGM4gRW/
	wpdwf5bw22YSWQb53//FjGyiQ3Cz9qE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-qmDzsZBuMP-2cvkBLHbsiA-1; Wed, 05 Mar 2025 04:30:24 -0500
X-MC-Unique: qmDzsZBuMP-2cvkBLHbsiA-1
X-Mimecast-MFC-AGG-ID: qmDzsZBuMP-2cvkBLHbsiA_1741167024
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-abf597afe1fso439455966b.1
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 01:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741167023; x=1741771823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BZqtssEKSX9U+sm7giaUTnUcD9w0nxNJyaKF0Dg8jk=;
        b=OQHG/2wRpam6/iCt739I76PELLRynB+dL+IRyRWWFElxA+6vlTmRI3dk+JdTEVWrKX
         yhhVVY+y89JDLne6uDKi/g+z16IJjD6ZS957YlKFVzH1Q/qdD+2u2ffyP4bg1BNNySXE
         5hhXU6CjLJ4DhpPZzH0YCq0/aNbsj0aoPm2yrBshjNy5AnQ/uzbvMM7sIXEKUrGm2i5A
         5FUI9k5nfoFF2RwaMIVSt8ro+/R7/DHMTgduS8l7QCLognuKW1VUPRs75bmZsJTcsSKr
         N8jFz3KVux26Vt+033VcUJ52kwkNtp1io16ePaSVpLH3jrUUEQdiyTQO5JesPcdFuKGN
         w79w==
X-Forwarded-Encrypted: i=1; AJvYcCUyzAdjxcViWX+XjCJ5iryS4gBgHzUtQYEP0uPbOTiOxG/l0bEM2nSvEfBrhD62JcV0Xew=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVG2zIA2jHZrz9c9+UpXqJH8JTExxUN9p+LhBXWKXbA1C1lRj9
	ABNR9B4jcEqotPqe8tD3wmr50vlibHbW6+U3Fl0XuIUIKP7w3gp0t9z13tZ6F6fibDzcHdUgXXD
	gEPABw+GUZ3tFVu4t5jMB3WsCq1Y+IYcqs1IJ6hv3ngpgxFxxEA==
X-Gm-Gg: ASbGncu2xYIQj7gABRijJtl/BS1AdXPytkgVMR2jAYF1r0w5IuTAU8y3W0XXXIIGwqG
	S0VYYFRpIHljYKr6NP3vjSMV6bxAe/17NlDoMjykLqgxq/fCTloWukPpC/S4RTXrBbl5PPWWopW
	038/vaNOKePat7afB4hSTSAWMDjNwZcjEOqLZXCv1j8yh3wM26tj4MYP5gpreVc3VprTqsWDDlA
	/FDlXl79ZA1fv0YAg2WWkA3ZsS7Qe2Hn2v5SEOgHl2UMlzvc4+84eAHRuikQJ9/vrl/NHmTiHyz
	ZNBdPAI0oHcNzBcQ2t7v2kOCXgoP9dHH4oucuTFrnVRoMyFFnroSsDLCdeqc52aO
X-Received: by 2002:a17:907:9494:b0:ac1:da76:3633 with SMTP id a640c23a62f3a-ac20d84412emr257570266b.4.1741167023624;
        Wed, 05 Mar 2025 01:30:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXk7a1z+Ze1GZvne805ygS+jajQyu0NiMIy6MNpjgAxqXVnbiuz0kcZ2+UtS+U3NrxoZnl1w==
X-Received: by 2002:a17:907:9494:b0:ac1:da76:3633 with SMTP id a640c23a62f3a-ac20d84412emr257565066b.4.1741167023076;
        Wed, 05 Mar 2025 01:30:23 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac20225a3a5sm182343166b.177.2025.03.05.01.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 01:30:22 -0800 (PST)
Date: Wed, 5 Mar 2025 10:30:17 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
	Bobby Eshleman <bobbyeshleman@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>, davem@davemloft.net, 
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <v5c32aounjit7gxtwl4yxo2q2q6yikpb5yv3huxrxgfprxs2gk@b6r3jljvm6mt>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
 <20250305022248-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250305022248-mutt-send-email-mst@kernel.org>

On Wed, Mar 05, 2025 at 02:27:12AM -0500, Michael S. Tsirkin wrote:
>On Tue, Mar 04, 2025 at 04:39:02PM -0800, Bobby Eshleman wrote:
>> I think it might be a lot of complexity to bring into the picture from
>> netdev, and I'm not sure there is a big win since the vsock device could
>> also have a vsock->net itself? I think the complexity will come from the
>> address translation, which I don't think netdev buys us because there
>> would still be all of the work work to support vsock in netfilter?
>
>Ugh.
>
>Guys, let's remember what vsock is.
>
>It's a replacement for the serial device with an interface
>that's easier for userspace to consume, as you get
>the demultiplexing by the port number.
>
>The whole point of vsock is that people do not want
>any firewalling, filtering, or management on it.
>
>It needs to work with no configuration even if networking is
>misconfigured or blocked.

I agree with Michael here.

It's been 5 years and my memory is bad, but using netdev seemed like a 
mess, especially because in vsock we don't have anything related to 
IP/Ethernet/ARP, etc.

I see vsock more as AF_UNIX than netdev.

I put in CC Jakub who was covering network namespace, maybe he has some 
advice for us regarding this. Context [1].

Thanks,
Stefano

[1] https://lore.kernel.org/netdev/Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com/


