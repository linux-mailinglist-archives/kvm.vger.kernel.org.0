Return-Path: <kvm+bounces-22503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB7593F5C2
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75D58B21E40
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176B91494DC;
	Mon, 29 Jul 2024 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3bc1ajw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383B2209B
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722257087; cv=none; b=DMJaTYWyQYvSKnHe7/wzod+mOOG94f/dvBFMnqWgQP7leZIRZKS6I9otSihOKGtTyy/CBzs+QetCJjKgwcjfu/R16pPlbZSFgE/4FVb99FNH+AGexaH/iJ/kVZAwA4D5MUCDG5adYGX1H5mnkruInSCkRhYv+neZKz89PL8P+Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722257087; c=relaxed/simple;
	bh=5mbYS28kR+anl9LddH2GIect/DwV20q0RBYiy+oebfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kgi3c24iqsZOUlBKUBWIaeM4+8Q1JiGCaJ6MxEAoTL18lWq8okhHsRhFw3BFTsjTRA33ni/3+21wu2ULTzHjmO8VQyTZ3IhbDgOjRbYshdQQnVSBqeymZCnyN+OT6dS+m6TaJ0fB8/va+6kGxtEuQRh7iRBDPzGtZWvfj8uf2vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3bc1ajw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722257083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=imU5JWIdoIr0tLfxDfEeLPjwXwqe1TCwz+4f/zgzfRE=;
	b=C3bc1ajw6FF2exRQYE5ZNqNvs7jyxKv6MwqM2O6OYRecl6JhYd3sDXYwzERgU3FA0JkHA8
	StIKjBtUyywyugwBkby4yQVE8WDWMP6X/UcL9SBr6yyI2rlERG5h1RRnGYuvyJAoRJXHjF
	Z4hOCjhOSo8D+GH6QCeBlpVGrV8Vpz0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-VlF8wY8JMxqV1OhRZxY4lw-1; Mon, 29 Jul 2024 08:44:41 -0400
X-MC-Unique: VlF8wY8JMxqV1OhRZxY4lw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-36878581685so1338897f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 05:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722257080; x=1722861880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imU5JWIdoIr0tLfxDfEeLPjwXwqe1TCwz+4f/zgzfRE=;
        b=sMYxW+VsYobjI3oEJFJlC535Eyfgshu24ME1ayv+e3Ou5MHmOC1MHgcqDmsFToppG3
         fin9i1XChkKwfr9VfrecEzh9SvrLXGQtCW/H4wrkMdGMN/YH22n6Xgni3QCeH0ZWaFp/
         E27WzBaJ0rhG4YymMREtUk6qg1O1wGtGvuwpLkKVwHQhso/MGgCrmu1MGBeNI4yUKQdx
         s4iNI52nHahDWhfP41GvY2mZdN9bpSFidpi4LTXbI5GHbUG/UwZGbjQJM2S0yFwAIwpx
         7h51cUwoiFptkzLTg4lWwuL6LfbqTqMUruwwZYyaVQxQE4zkXI3Q4G2QhpIlL55U7se7
         f4nw==
X-Forwarded-Encrypted: i=1; AJvYcCVnS8Xm4+IJRsVl+J4RNLs4UZ309sqSP6eflKgmQE0lDoYkUBP13LSWPazBeVZfVjwbV52ioArz5d36TXitAPjf3yVC
X-Gm-Message-State: AOJu0YxvyhDq0uMh9ax88aMWgo3Kq4rPrLqemTNaVJZ4oUEeDcjsPAbx
	J7gssJvIsQdTTHDurUi1xnfO+oZC2rerEmRYjr1llgJD5Z63ywMX53FUKUjck9ZXT8kQH1K9i5s
	rVTM7rkipOGQSqqswkuXupg2GFWLaPHjVSGZJRXWN4Xm0vDfW/w==
X-Received: by 2002:adf:fe07:0:b0:367:958e:9821 with SMTP id ffacd0b85a97d-36b5d0d1002mr4391893f8f.29.1722257080415;
        Mon, 29 Jul 2024 05:44:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaJJDIOyE8oIlYOdXwKaZY62JoigjIwdVZsp9HQ8Tass/f0PxfO6xtI8+Zomu1LS9HO70CTw==
X-Received: by 2002:adf:fe07:0:b0:367:958e:9821 with SMTP id ffacd0b85a97d-36b5d0d1002mr4391872f8f.29.1722257079783;
        Mon, 29 Jul 2024 05:44:39 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-79.retail.telecomitalia.it. [82.57.51.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d9a3asm12002314f8f.36.2024.07.29.05.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 05:44:39 -0700 (PDT)
Date: Mon, 29 Jul 2024 14:44:34 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH v1] MAINTAINERS: add me as reviewer of AF_VSOCK and
 virtio-vsock
Message-ID: <4hzlvcppr6t7g3shaghr5w7yv7lvr6q3p3h3albzv7xrs6xsfs@54fx34dq422x>
References: <20240728183325.1295283-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240728183325.1295283-1-avkrasnov@salutedevices.com>

On Sun, Jul 28, 2024 at 09:33:25PM GMT, Arseniy Krasnov wrote:
>I'm working on AF_VSOCK and virtio-vsock.

Yeah, thanks for the help!

>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> MAINTAINERS | 2 ++
> 1 file changed, 2 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index c0a3d9e93689..2bf0987d87ed 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -24131,6 +24131,7 @@ F:	virt/lib/
> VIRTIO AND VHOST VSOCK DRIVER
> M:	Stefan Hajnoczi <stefanha@redhat.com>
> M:	Stefano Garzarella <sgarzare@redhat.com>
>+R:	Arseniy Krasnov <avkrasnov@salutedevices.com>
> L:	kvm@vger.kernel.org
> L:	virtualization@lists.linux.dev
> L:	netdev@vger.kernel.org
>@@ -24370,6 +24371,7 @@ F:	drivers/media/test-drivers/vivid/*
>
> VM SOCKETS (AF_VSOCK)
> M:	Stefano Garzarella <sgarzare@redhat.com>
>+R:	Arseniy Krasnov <avkrasnov@salutedevices.com>
> L:	virtualization@lists.linux.dev
> L:	netdev@vger.kernel.org
> S:	Maintained
>-- 
>2.35.0
>


