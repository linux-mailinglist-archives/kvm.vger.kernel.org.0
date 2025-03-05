Return-Path: <kvm+bounces-40138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9684FA4F7DE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C50B73A6E41
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF70B1EE03D;
	Wed,  5 Mar 2025 07:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwgEF8j1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF971C84CC
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 07:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741159641; cv=none; b=SzilZklnkvqtzu51DTpxnTzDzWEC+MoeG3DesPkkXQSsZCLD9MbVax76DHaYG6BWZOgjZa0ZHiOrYAiigO1HXBBaGp7KPnDI7jbTPSpPkA/NScj/rl7oEQM8mC8gEZGALtnkAxpjeXjM9dmDsV62TpGpBNixaCt/Z+jkK+dAsDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741159641; c=relaxed/simple;
	bh=ggBjNt/KlzNhbq7zUAZEYyviD7fOL0zcgpYxjiglnLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6P3TG/KUzaGVkgdNRyQnqNeO+q9XJQyedOzcwq5nYEXResfZ9mxyRxL3Rgcn4V2Kg8QFD0bGj5n9QE2eWFyG543cKPJajViMI3zFvCWFlbAMXvbjWCCj1/d3/laGxeMYjKMIuCn9++AWh+OUIBZx/dqZNp3k0MG8CejdwM5iyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwgEF8j1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741159639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Gqpuh7OkhW6l3/SGFe53202mdgSid6lnY8KI4KHLQM=;
	b=fwgEF8j1cVxduCjmAe9q2TpeL2gaDA58zXgdVRPPU+bxNpzcCwKYBxR3piX7bjk+/ZQEMh
	WET77SmowRsojY6e9tdhW70ZR8bZil+pbCXwfo2X9LqYjLyaiLgXulF3qkLuK3bhTjDOv4
	eiBMi14IZ5X8DWHzpiuWPoSm3vcRBwI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-Mqbq35SrN4K3dKAqLRgAEw-1; Wed, 05 Mar 2025 02:27:17 -0500
X-MC-Unique: Mqbq35SrN4K3dKAqLRgAEw-1
X-Mimecast-MFC-AGG-ID: Mqbq35SrN4K3dKAqLRgAEw_1741159636
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43bcc04d2ebso11958595e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 23:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741159636; x=1741764436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Gqpuh7OkhW6l3/SGFe53202mdgSid6lnY8KI4KHLQM=;
        b=UyoMGUZ8CLyx1M6N6kCYNvLO8pprTrZvmYa5EmWuxpjo9g7WNJSbRTQ3g2EMGBtomO
         ZnaEj9aiKKVXue0wlWBDS4YMSQJ43M9pfd+hjBDZC+mnSoI4pNOKD/d+wOe+VQwlIXRX
         NYs+0FvTDuslmZrnZaVs6XhBbEjy/YAL4NuW+EnrdkwO7OK++O0+Koz1AaulupZ3atdA
         oSjPtGZ/QScIbKEMQ46dmX0P9lQL2JPEFyDtkMeFLvSdVLlFaGOLzdgkEAts/Ik0G7YE
         /vRXrXNy0af4Tdj0M/YFIWoi+jJvI81A5IrPxUNw7ifAxceNuLu26tv57UobTZRsYUJe
         w9Sw==
X-Forwarded-Encrypted: i=1; AJvYcCVeInckmfE9zNYQcCw19/ky2Nlp9kvQrw/o1fvQZzW1SaGPk7HGjpSpYITN7iRZ+HUf2js=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7wV6EA3s/ULA+bmjCi6r2GZmzzm/0ZhClSOXb2HAakgENYZVE
	PNt8zSQ/WCjQ3gAfli7UeH7VYhyUQ5NLrR2yXC00jMwEHrFdqax/Ohz9Jb+xO78CfJ9TXDehGqO
	Y/7QnfZbL94mNvA+U7q+J7+0TvXxJVMCKNMN1t6/Mys5Rm7rgiw==
X-Gm-Gg: ASbGncvSRs63cImCwGmH34GNY/6pPQ+K0vLad2NlMNAYJcFWknfpguw4pnM/rqM571a
	BqYl71zpijrRmFKa8m0SvmPRB8Xl6NGEAeDDFP8sQn+HiMMi57Vr0RHZiY/gNqlQp0j4kuzMKTE
	Goi5vScAoTRF/NvEKNthQ7qpPc5kEFB0PFYCtHTvDrOIAiqtvn3Ad3+UDbY6ORpTRqqqBrtVHbL
	LgW/mjCTNINB7I0K29A+FY1YHIj7LqSp2AvrJWvckhZHlm4RtqQMTt32mQDg/n1Lp7h8T9haBEc
	8d7XFid/Vw==
X-Received: by 2002:a5d:588c:0:b0:391:1222:b459 with SMTP id ffacd0b85a97d-3911f7bd7b9mr1100778f8f.49.1741159636301;
        Tue, 04 Mar 2025 23:27:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFSwg2gbLwAPlPAn2L1vg/ffvpbpIN3dglqIqZN8294KCbPeBfUkyQP4He1JGn832GdDHxeA==
X-Received: by 2002:a5d:588c:0:b0:391:1222:b459 with SMTP id ffacd0b85a97d-3911f7bd7b9mr1100756f8f.49.1741159635943;
        Tue, 04 Mar 2025 23:27:15 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47a7b88sm19898221f8f.40.2025.03.04.23.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 23:27:15 -0800 (PST)
Date: Wed, 5 Mar 2025 02:27:12 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20250305022248-mutt-send-email-mst@kernel.org>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>

On Tue, Mar 04, 2025 at 04:39:02PM -0800, Bobby Eshleman wrote:
> I think it might be a lot of complexity to bring into the picture from
> netdev, and I'm not sure there is a big win since the vsock device could
> also have a vsock->net itself? I think the complexity will come from the
> address translation, which I don't think netdev buys us because there
> would still be all of the work work to support vsock in netfilter?

Ugh.

Guys, let's remember what vsock is.

It's a replacement for the serial device with an interface
that's easier for userspace to consume, as you get
the demultiplexing by the port number.

The whole point of vsock is that people do not want
any firewalling, filtering, or management on it.

It needs to work with no configuration even if networking is
misconfigured or blocked.

-- 
MST


