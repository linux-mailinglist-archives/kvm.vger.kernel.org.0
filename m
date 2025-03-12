Return-Path: <kvm+bounces-40860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1483A5E773
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 23:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACF93BC51C
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4AD1F0E31;
	Wed, 12 Mar 2025 22:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFj1bo98"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B9419E96D;
	Wed, 12 Mar 2025 22:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741818552; cv=none; b=OinrIyMTU3IuZ1jlZSO1ntPkKC1daybOczKiOWzbNVtLup/6XWugxrH9N27JAUT6lj09jHamoG3Vdv9TzTyMJHjXVz82vnezGg7Hb+m+oAhPlokNE+yfNiIHPatceWJ86LqrcNn5HghU33MpHdRRGgUmL4TkVTQrG4kWq5OqZGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741818552; c=relaxed/simple;
	bh=6PSD8Ihb5wqTIoMhe00VHOCE57HyMwiB7MEagGbuhZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfSDN2V+AhDwl8spPzkdX142x96Qw2e6u2r6clM3eqWc2rjsJo5BS3IZa0ieF7VjybzQxLpCY9NhVE6rUOAbW8BOCwxM2SEYxkdHMMx4XcCwIIk5Zf2IIhX12ZvFwow8G7j0YSgCvtgafubXneHzl/pnaVM+950LYloch/hu4OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LFj1bo98; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223fb0f619dso6501435ad.1;
        Wed, 12 Mar 2025 15:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741818550; x=1742423350; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7Zt5RBTdS4tu9y1ZkvHvMS6PvikbgYBd+xanSqGhaSs=;
        b=LFj1bo98U5ofV7suHOs88OkZxgEoPC6S5uk1QIxc9pzu1VGMnTEQJIa9pqFlbbheo+
         Em1bmkLPeUvqKMCAuj3lktGsy41LS8xJ62OlGnX+XcQopyeRtKsVgzBRKsAlXF2Cqw4T
         uSiE9jCCNd5zqYE2e/u9bAPP+FlglAIBdufsyDnI8a15K15cS3wBWkQ9+Ktcg3FW/qVq
         NKQ0zVmJDCD0Xs2wjn5kLXxQSvyZCpHDhdStUqrD4XWmXJugMemHmG99qaNq5oRpC4xD
         k1z0MpMY/ZvavWFw1wXSNS/G3JyD1wdkX+uJpQi1zKDtFAez5jLOtkyOnmXn9SrgmcPJ
         u9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741818550; x=1742423350;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Zt5RBTdS4tu9y1ZkvHvMS6PvikbgYBd+xanSqGhaSs=;
        b=M6REmIARnFB01wHvlC5WqT8nCkLI73to98bpjCn5SS/5gY013NBJ5+ntOyn9SfXBqQ
         XmvWKYjEO9wmaWsQYPBwYUxJqHmxc6gosR7yvWyoPoJggp4NUzBupbzBj8cFvT+PUrsa
         yVGZmPAOpmn598HgCZS5IBfm2lhV2HsxizjfgJVOnSJaRzhbZct5INLULu8WgfJdLJBO
         R8rLEi3LoQ4gEnI79baN67sbKvaW0w5Z07hzM7mnH7x/eRCv8nDEJ+csr5UX0I1WBiRP
         HdRBn4oFhfH0blQh4vFoafZ66l1JbAMsL5xeZnj98xTHnGHA+UJ4WCShcuyc3qQVrViH
         myiw==
X-Forwarded-Encrypted: i=1; AJvYcCUOb1ZyfhGJlQh46KJLimc2nFKmCdAKk9+f0dDjXl6dDjqy90pHuhpdLgrNBdvPpbVDOhPn7S4o@vger.kernel.org, AJvYcCV/i046aWP7ZL+eWK4FiK5omCi6DTmbCttUEjtBgw2sAmW+44HTi3cTk74tdsLHsyIwc4YrIzT6Ci0fGTLN@vger.kernel.org, AJvYcCVLqwZhSMWNJ2eB2TaIbB8jjc5Bkil1bsi0rlTMiFwzBfTlMTzyl16aGq8zWla2G3vmUvU=@vger.kernel.org, AJvYcCWGt0N4WZRhVu0x2llfkvwrIVPaZ6xnFd3xIX+SQ5fqrunYWg/ahR49F7Rlo0kSWE6RHbLRNaUTvMq1Mlu6@vger.kernel.org
X-Gm-Message-State: AOJu0YxSAsqp8oGwmY22dRfT/BjW1g2g0yPYRTAFNyQpsw5N12wi80VI
	DtcH1Xq44l0j2N5KLyo5zgucfo1voP6kfauSg/wrZtrGh+TORd2e
X-Gm-Gg: ASbGncvscoeLH16Ju9H0DAln/lesHkz32J1wR7UI3upxFTyCIVuay83Z0VUhoI/d1cP
	DJ9qOz3yMwPG2N7VJyrTNIOkK99+Ba4YiAOwJBya9k2NeHEUN+8pky2RdpbgGuVuaWJlDVJg02N
	TwMjnFzMUXyBYY95+OHI0eFiUC5PQHCOjVwdUv2rUjlXt7dSfOAxnLpd045dOxLrfVMtnOoWwv7
	55g4uUbtFTM3ZsDkj5Z1cvqWwCkAUYvm6SfKuDFeB2FTegp+TfGHdqRmkeeG8pwFphcsJBKEXN8
	/WI4sjE5Ef+3QQlZGR5W+j3939uUqcZ1ftDU8Nmjp9zNOaXX5P4N8HCvz3PuASYLav2EZOdfLK8
	g
X-Google-Smtp-Source: AGHT+IG5eB7LsgG76qzryME3xovo7CXpCBzbsMGvNvGwS4V4Ch2lCvncSSjVtCrUYYynhYS0YR2b6g==
X-Received: by 2002:a05:6a20:160c:b0:1f5:7007:9eb1 with SMTP id adf61e73a8af0-1f58cbc4a43mr14791625637.34.1741818550325;
        Wed, 12 Mar 2025 15:29:10 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:5::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56ea7c87csm46437a12.57.2025.03.12.15.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 15:29:09 -0700 (PDT)
Date: Wed, 12 Mar 2025 15:29:07 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, davem@davemloft.net,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <Z9IKs15jhjaaj5px@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
 <CACGkMEtTgmFVDU+ftDKEvy31JkV9zLLUv25LrEPKQyzgKiQGSQ@mail.gmail.com>
 <Z89ILjEUU12CuVwk@devvm6277.cco0.facebook.com>
 <CACGkMEskp720d+UKm_aPUtGZC5NzH+mp_YKoY2NQV6_YBbRz9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEskp720d+UKm_aPUtGZC5NzH+mp_YKoY2NQV6_YBbRz9g@mail.gmail.com>

On Tue, Mar 11, 2025 at 08:59:44AM +0800, Jason Wang wrote:
> On Tue, Mar 11, 2025 at 4:14 AM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> >
> > On Wed, Mar 05, 2025 at 01:46:54PM +0800, Jason Wang wrote:
> > > On Wed, Mar 5, 2025 at 8:39 AM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> > > >
> > > > On Tue, Apr 28, 2020 at 06:00:52PM +0200, Stefano Garzarella wrote:
> > > > > On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
> > > >
> > > > WRT netdev, do we foresee big gains beyond just leveraging the netdev's
> > > > namespace?
> > >
> > > It's a leverage of the network subsystem (netdevice, steering, uAPI,
> > > tracing, probably a lot of others), not only its namespace. It can
> > > avoid duplicating existing mechanisms in a vsock specific way. If we
> > > manage to do that, namespace support will be a "byproduct".
> > >
> > [...]
> > >
> > > Yes, it can. I think we need to evaluate both approaches (that's why I
> > > raise the approach of reusing netdevice). We can hear from others.
> > >
> >
> > I agree it is worth evaluating. If netdev is being considered, then it
> > is probably also worth considering your suggestion from a few years back
> > to add these capabilities by building vsock on top of virtio-net [1].
> >
> > [1] https://lore.kernel.org/all/2747ac1f-390e-99f9-b24e-f179af79a9da@redhat.com/
> 
> Yes. I think having a dedicated netdev might be simpler than reusing
> the virito-net.
> 
> >
> > Considering that the current vsock protocol will only ever be able to
> > enjoy a restricted feature set of these other net subsystems due to its
> > lack of tolerance for packet loss (e.g., no multiqueue steering, no
> > packet scheduling), I wonder if it would be best to a) wait until a user
> > requires these capabilities, and b) at that point extend vsock to tolerate
> > packet loss (add a seqnum)?
> 
> Maybe, a question back to this proposal. What's the plan for the
> userspace? For example, do we expect to extend iproute2 and other and
> how (e.g having a new vsock dedicated tool)?
> 

If we were going to add a seqnum and start bringing in other systems, we
would probably want to add support into iproute2. For example, when I
played with qdisc, using ip seemed like the best from the user side.
The iproute2 changes weren't bad at all[1]. We'd probably need the
device to carry a new feature bit too.

That said, all of this still creates the problem of adding new
system-level ways to disrupt AF_VSOCK users. I think we could offer this
in a way that is orthogonal to prior vsock, possibly AF_VSOCK2, a
sockopt, or ioctl to opt-in to using net features... so that we aren't
violating commitment to existing users that vsock should work regardless
of network configuration? letting the user that holds the fd of the
socket make the choice might be the best way to safeguard the contract?

[1]:	https://github.com/beshleman/iproute2/commit/55fd8a6c133335cda4ede6f8928eb3cea54534b8

Best,
Bobby

