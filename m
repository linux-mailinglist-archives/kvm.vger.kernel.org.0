Return-Path: <kvm+bounces-40169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0127A5042F
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 17:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9604C3A2D2B
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 16:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3B32512EF;
	Wed,  5 Mar 2025 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqxuMXdw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275A8250BE1;
	Wed,  5 Mar 2025 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741190976; cv=none; b=MbOAB+Y8UyGbpe23xRZPsq8SvH18fVcSAqFB4r5Eofu4BxPYTxwnXzpB6tP/vWNUmPuBj5PDoyHjU6EBz6McZRpP/t6wRNcFXtfp8fZrFYUJmH54GTVpR8Udkp35HXpLtt1+OfewqE6XjNEvwcpnlVrLQE5bWzFwhPbnK0/RubY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741190976; c=relaxed/simple;
	bh=GKmV83MRa5t4NkQJ3esvrmWFVjgUKTVYEu/IX/vnRuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7Xea7VQ85j4FQf8Omid1dhnQVOak95lwWUmgWp0IP3T2FNDpTQjQo9kxJEeOm2Rg8DIBxe8IqECk9QtTSa0Aj3DpBh3KbIVCmc25jNDGlhyzW8wpLY+odaCRVX/QwuJ+6FRUSQeKqUL1BOfgIEuujQ1BqiahrRbsDcEstlgTM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqxuMXdw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2234e4b079cso130383205ad.1;
        Wed, 05 Mar 2025 08:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741190974; x=1741795774; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W3ZvhVCBXJoVmMj/QDYwjnvrQ0tg00IV0Ab5gY5yAEQ=;
        b=OqxuMXdws3OWw0P7ds8BSRPa+IXzPOrlywOJ5fnHh9XFfwyey7iYNq0pmQi40j3YOg
         cMHvRwyw9vnKf5nWBnYiv3X58jPnjRlA/hUaJacuD/fDCIke42ZBT8R2oTyk9EwQdVHR
         C7zGSy9vlHhK9JzWRQETywUlUndgiR8hzmp9Bncrk3uqiB9NhJm0WgRaWEa2lpo4lRG1
         GRczrWTtBxdy7g7IzAjzLir9heAj6f/mPESiY69znZhG8b40H9tMd95tuSSD2dRZsy4I
         oRRejS+BdMe1/h0BdHaKV9N7CCslUMMafhNmHf9WaMbAXUw7IeXMXF4Zdh/fZql1JPKa
         5AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741190974; x=1741795774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3ZvhVCBXJoVmMj/QDYwjnvrQ0tg00IV0Ab5gY5yAEQ=;
        b=V4DQBnbMA7lbsnMjGkMeGN9FDFwfiY9+y66qgGZTgNKUWURt3UYrMkrnz+1OYiso1F
         GRFxYTPYd11G4vKduB/rR675dgCaXcasHeH9KVzpro8CiLrEKFErzMotbbQKQmzTszQj
         1gtLuKtlHFnWlV/KCJ3hhHmEAdJpSNwYUqayxv4hq5B0/QzOq6I6PJUlaRZuoxyrf/jh
         e74CUISWav9pl3ugu48MqObrXcZbbBNDFST8vQmj/blx2ovx9A3tI02xHbC3WHDBxyhb
         wLZXSk4GO/1oykdewwFNd8J/zU8kcw/jv0xgqsX9MAfIi0hZOI5kwC17nIhvNMU8pxmO
         XLSw==
X-Forwarded-Encrypted: i=1; AJvYcCUFCFGEt2zPXi5VeeQcxZ3UYVwi3KWlM6l2ukecqb/EPTnTli7++seLoy/XS+ITnr99GeA9aj2Q+wqgZgLD@vger.kernel.org, AJvYcCVOcdgU4dArYOur+EnPeCUY6MTvj0Vjo5f+5YT+hbLUrq3Ty11ZiFHEnY5dmO2yJ3KXPBO6fVeJiAkkPpLh@vger.kernel.org, AJvYcCWIey76QEiPHrQR2lziWToNMPtkR1xzvW3yGGFgmLXMdVRcoeQ1JaZbIlMrHQ30CV0I+tw=@vger.kernel.org, AJvYcCXTZTepMbqRvuTAqBGUIr9cMLIlZ9cyMNixdHCz1UNrqrhrwr7flsTSdImA1JfRtnip5mLJmXfS@vger.kernel.org
X-Gm-Message-State: AOJu0YwFLGYplRrJG7d08HxQ2f7tKBBGYrphIN1iFBI9UB1qm0KMTrtG
	5Prh8E2L6awGZj3WdjK2aYOF7A8hpCWCEwE5XmVU/AWgo0I+3R6v
X-Gm-Gg: ASbGncvqOViXB9qNXA48o2z9y5eXjg6WLoEFGFrLhpxTePPuXR+tydL+IUDV7f6MnPt
	9BBINGAoIMqf7+uBm9ICjUn4YmEjrOiwvvEO0eMhzg6SNy1j6ml26QsW/3bStisLG807E8D3J6A
	gO75hXsgNMT8IGCcpNq1tJkIulPvSs5Z1OLGRkQb3cKwL2nB0iiy8D79o9MAE/bzPykee78N/Nx
	ThvQCjpBU0Fm2igNfPYFgOmtpCcS6uXAhKILVhQQxacyA8qDUBpyFoaGuqcr9frDWiAVqHborjq
	mnBYaTOCV6pfoJuDoY/1WslaI+oNZQkfTURDNm1X5GWgluvoddFJHM/zbVIuHz/kqA==
X-Google-Smtp-Source: AGHT+IECEBns91C5EwHlCoDWNpwg07LFYchP/SxyUo4u1fqpcLi7anWcXaFI4dnLEJw/KAKqFZuNdw==
X-Received: by 2002:a05:6a00:3ccd:b0:736:5f75:4a44 with SMTP id d2e1a72fcca58-73682cc409dmr5359182b3a.22.1741190972845;
        Wed, 05 Mar 2025 08:09:32 -0800 (PST)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7358603f4a2sm10921810b3a.173.2025.03.05.08.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 08:09:32 -0800 (PST)
Date: Wed, 5 Mar 2025 08:09:30 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <Z8h3OsmQxL3e48ZJ@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
 <20250305022248-mutt-send-email-mst@kernel.org>
 <v5c32aounjit7gxtwl4yxo2q2q6yikpb5yv3huxrxgfprxs2gk@b6r3jljvm6mt>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v5c32aounjit7gxtwl4yxo2q2q6yikpb5yv3huxrxgfprxs2gk@b6r3jljvm6mt>

On Wed, Mar 05, 2025 at 10:30:17AM +0100, Stefano Garzarella wrote:
> On Wed, Mar 05, 2025 at 02:27:12AM -0500, Michael S. Tsirkin wrote:
> > On Tue, Mar 04, 2025 at 04:39:02PM -0800, Bobby Eshleman wrote:
> > > I think it might be a lot of complexity to bring into the picture from
> > > netdev, and I'm not sure there is a big win since the vsock device could
> > > also have a vsock->net itself? I think the complexity will come from the
> > > address translation, which I don't think netdev buys us because there
> > > would still be all of the work work to support vsock in netfilter?
> > 
> > Ugh.
> > 
> > Guys, let's remember what vsock is.
> > 
> > It's a replacement for the serial device with an interface
> > that's easier for userspace to consume, as you get
> > the demultiplexing by the port number.
> > 
> > The whole point of vsock is that people do not want
> > any firewalling, filtering, or management on it.
> > 
> > It needs to work with no configuration even if networking is
> > misconfigured or blocked.
> 
> I agree with Michael here.
> 
> It's been 5 years and my memory is bad, but using netdev seemed like a mess,
> especially because in vsock we don't have anything related to
> IP/Ethernet/ARP, etc.
> 
> I see vsock more as AF_UNIX than netdev.
> 

+1, I also agree with this.

For reference I added netdev to vsock before [1] to use qdisc and at
least from the qdisc perspect the juice wasn't worth the squeeze (tldr:
only pfifo_fast worked because vsock can't recover when other qdiscs silently
drop packets).

[1] https://lore.kernel.org/all/5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com/

Best,
Bobby

