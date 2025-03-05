Return-Path: <kvm+bounces-40101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F64A4F2DA
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 566D9188AF9E
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633F87081A;
	Wed,  5 Mar 2025 00:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gp++zdng"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FBF1F957;
	Wed,  5 Mar 2025 00:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741135148; cv=none; b=BfCXbI1ds4bTIlJtdVxG/Nb+uyIGt4YLyw+Wzax/m54+btDYszZBs50aq0aaZbydQZ4nd8jvTGpVH47m942hc8lK1Bam8iLD7gR86Uwq912OEHZGqMgwIPvzmfQ4ydWRed/ZGNTaw+P0vlwxku9pFEqSyZ84us3xpVQ9mD24CbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741135148; c=relaxed/simple;
	bh=GffaeRHQ+IZsy69KXO82DY5gWnWpz0RqxgHkgUms0Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDlA5lU3an+RSyrVMAkIHfPXRHlRho55Fst+qyqGdujVCab+e6trwCt+nxuYQrJmY5U0wk3/BeLxF9GpeZvPBwcxf148MbUptLTv5cvOvJQpcfosbwQpdcMDoCFTy0YuTYqCQo9RAGfdADWGS8lRWeA3pPPea0oIta3rTFPOqxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gp++zdng; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22349dc31bcso110143595ad.3;
        Tue, 04 Mar 2025 16:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741135145; x=1741739945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UprHo0WfBiVLbk323XZc3dMbOaIjPzElNygx0f4wgwc=;
        b=gp++zdngeCzxnHRDJ8C9SHDV7cnxs2mfR1BJm3IgDEJnGEIsciw+Y5uOsnj2m0eZ4+
         z3p7te8G1+hZ8LEX1fedbYygXZzpkI53Z4iPBvYUf8i2Z4yWNJ7tREj4RhaXTry5/xrJ
         VJiNHX/zVy4F5HVaeaT/tFE0gg/iZA/S2CSOI0pS/Vst4RrfDnnCV02CRFQJlaberIBE
         LJCmCdXLiB1vm8xFUa3O+a/rJuGtbfuqu7ThZz5DVsobx7dIyfRR6No9eNEdYY7xEx3V
         03yV1r87v37dS5e/3ttW3pTYOPeltH0y9+B8vFow1x4ag3wtFqYHTWMWLnRtbCM9/Xzn
         Q7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741135145; x=1741739945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UprHo0WfBiVLbk323XZc3dMbOaIjPzElNygx0f4wgwc=;
        b=B6B4Y8hEzjcG0pcoTIybEwyRCnS5OmA3GAsnnEPo075a7d0NKxzH+6DU1aR8ghVlPq
         4mrN8kGL8WRIVAZW4GqJfQ6PpX8kSDojloVzN/cRnoteQFnRSKrN3sAYaEv/uSxfhBtA
         Z6zN/hdfYJu+5XUt5ShkIYGysOatRQ9zfWDfKkbHI0JZCPE5j7h7hlpKjq1/8/b5aMI7
         mPhKFRLQo08pRXe16wDlphHrgfj5hWtGk/eYqdcn5CVzhGu3QGiJZ/DNNVAhIZPDLdeM
         7JTwwKOOaD/cfE3sm0Ska7ubVsdb6OQ8MjMN7+toeNXLqlZ7MK2+T0g+ww7izuHEasJO
         BI/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2y+rm8Ch6w7yEYw2wyh4KTk6uhgGGpVtrG8bZ3dlaC6mrjucHUdKstuNhXXNl7iyinOqb/zICwUctAXuA@vger.kernel.org, AJvYcCVqIHdhaW4PH8BIcRpa1NcgysuIyDqWJHv+bFB1NGOtXfdteeWaH+FA7KSHinkBG3OI6YF+uhCW9L4fWJWS@vger.kernel.org, AJvYcCX/5yNqL//nbAh3VuOok9h1H34x448nkUk+vjUOhbbc3dzS0g821ZWLfktmE3/JjGBKQx4=@vger.kernel.org, AJvYcCXxzXmCg3TuTZzWRgibG9hSOixpwiC2aqRlVNK0ZdlP5OdKGhSSt4ESpu1yQUDu0m7LRRkBUgD4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/rsVoSjWDDnN7Hhz7v7Xdk44bmz2ftOO5JIn1MEkIU5ZP76cL
	TG6Nidjna7lIMC3u4SoY3U7+/9VsamGAFtYi7VgjpBQOUittSe8epIerVrm1
X-Gm-Gg: ASbGncsEuIpsFYNJYyfE7ECkf/VgYRGzvUdImOFOYoXa0Fc71fi1AvIWzL1/ZJJpmDf
	usLJuzf6hianBI2y3KQgZkP0E83IitOQdZUaaNi3kxYgLFKz558iRIY/J4Y9Pe+qMUv8yBW0nAI
	dxJe7HB9nH/kIUhMvutDGRMxpCBFBdK0CTM65VQwtzeoT0OZhNQI/7ZLasD0kVO9kt5fbY7hWSy
	B+evQ58UGUtYWveWJz9ZA1QvmfoZt2GyZsXPmqx8AbG9WOLcEagvj9m/7qiYZgjLrrbaEb0wtWC
	v6h+6x6oM3cVml5BsiQ6gInoxkDL4jzA/UvigQwV7jt/o09Sja0Ua9hyv245pw/RlQ==
X-Google-Smtp-Source: AGHT+IECiYjFVxf6raN09EdNcRoqe9t6RTi4k2HhtgndswCUxU53XDMOZQ0P2qwRcfTEsZetXhEh+g==
X-Received: by 2002:a17:902:d50f:b0:223:5e76:637a with SMTP id d9443c01a7336-223f1c97445mr13662535ad.23.1741135145249;
        Tue, 04 Mar 2025 16:39:05 -0800 (PST)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d28desm102409635ad.16.2025.03.04.16.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 16:39:04 -0800 (PST)
Date: Tue, 4 Mar 2025 16:39:02 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428160052.o3ihui4262xogyg4@steredhat>

On Tue, Apr 28, 2020 at 06:00:52PM +0200, Stefano Garzarella wrote:
> On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
> > 
> > 
> > As we've discussed, it should be a netdev probably in either guest or host
> > side. And it would be much simpler if we want do implement namespace then.
> > No new API is needed.
> > 
> 
> Thanks Jason!
> 
> It would be cool, but I don't have much experience on netdev.
> Do you see any particular obstacles?
> 
> I'll take a look to understand how to do it, surely in the guest would
> be very useful to have the vsock device as a netdev and maybe also in the host.
> 

WRT netdev, do we foresee big gains beyond just leveraging the netdev's
namespace?

IIUC, the idea is that we could follow the tcp/ip model and introduce
vsock-supported netdevs. This would allow us to have a netdev associated
with the virtio-vsock device and create virtual netdev pairs (i.e.,
veth) that can bridge namespaces. Then, allocate CIDs or configure port
mappings for those namespaces?

I think it might be a lot of complexity to bring into the picture from
netdev, and I'm not sure there is a big win since the vsock device could
also have a vsock->net itself? I think the complexity will come from the
address translation, which I don't think netdev buys us because there
would still be all of the work work to support vsock in netfilter?

Some other thoughts I had: netdev's flow control features would all have
to be ignored or disabled somehow (I think dev_direct_xmit()?), because
queueing introduces packet loss and the vsock protocol is unable to
survive packet loss. Netfilter's ability to drop packets would have to
be disabled too.

Best,
Bobby

