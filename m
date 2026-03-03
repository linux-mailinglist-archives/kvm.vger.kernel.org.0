Return-Path: <kvm+bounces-72505-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDzTJ62LpmnMRAAAu9opvQ
	(envelope-from <kvm+bounces-72505-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 08:20:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFBA1EA100
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 08:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44670307DB2F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 07:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D0838654A;
	Tue,  3 Mar 2026 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0y0JJdo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="V2YOAFmj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105C4285C8B
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 07:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522362; cv=none; b=nayfLOAFyU+byJMiE3d+o3hbfNgYa0+P3q6AFHu8ttsKZun7wUdQDH+CCY0UMd9QTMbS4IO6PC7d3Ig2v0w6exKhXi/6lVM6m3AU70cYpyFVJgNrvs4zw1025KbtQ5NjVRGYc4g12WzZtnm+sQHa2mXh13Va4RVTfFf/qhEENQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522362; c=relaxed/simple;
	bh=Doad24DQs+44GbcO0UUBHSHOY52WSKB2PaJUheAOQlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5MSnyw5j6U1tM3VMO4QoQuAX8ybL3/xFVug96+mjr0DQ5JX8zddShKQlhFRkcvYqtk9grkW83dso0ZubKwgJNg2MfIiEZ06OWb40QwtXjuali6b4RIQBQKjW15g0nm0fZFZWbcajw6STTnY52pQL/7Qcy6hDk1Yg8Q1qgJBdt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0y0JJdo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=V2YOAFmj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772522360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RxiMbhEuqFZk0pVPwSev6kKmkvJmnoI+zy4WDYfo0AQ=;
	b=N0y0JJdo3FPwrxx3bNG8hHNYC55Y6876rGHM4Iffdind40EvUOo97hw9B5w925UKFj9gll
	zc05LWC9P59h1y1a60Mix51kdmwYtfZcv+dGlu+hopYD5iy1X/Ye5QXUid7U+l9GmKrL02
	VE2BzHQgV/2nSfPZnzixqqN9du4ZRxM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-mFslkh8eORymr7nLc524Jw-1; Tue, 03 Mar 2026 02:19:19 -0500
X-MC-Unique: mFslkh8eORymr7nLc524Jw-1
X-Mimecast-MFC-AGG-ID: mFslkh8eORymr7nLc524Jw_1772522358
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-439b8bc43aeso1149185f8f.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 23:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772522358; x=1773127158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RxiMbhEuqFZk0pVPwSev6kKmkvJmnoI+zy4WDYfo0AQ=;
        b=V2YOAFmjVcf2B8SrwzoQVtvIBuKzSeZ41SqQ7vc/jCE+bOcSD2q2ptVPwj9zcByABO
         ZkxyvRUlPySpOW1K3JhXDK59Hco08cYKVcUtjQQHOFlnQGI79esAutla36cK0UloJS5X
         GGwdagbDdpJH/FgUh1i9DUsMO+TzGFg0wYtKy39pDVYhRANHLMgO6DQz6txNCOQ/iXn/
         o4ITeZ8OB8g467lVpGRAna34k9uVzbWHcWAyYZfGJXgne7Du7/fI7cc7h9JLknR2OJTH
         vfpIIo9oQpxw6J/dXJXGyZIqLzBJd+lw9Mp6+TvBykXv75EqfT7wU/I/sXnan73NbeT4
         AUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522358; x=1773127158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxiMbhEuqFZk0pVPwSev6kKmkvJmnoI+zy4WDYfo0AQ=;
        b=Ix6pXu5dp8LTO6O7gOV9SMWWJXFp3/k4n6t1n/HLZT2S1dLNrn99xBRzo9cRvlecUl
         NpgXW59pLtRUdYf9u4BZHMkUqk1Y0lor3bHYw0u7Ae2uOKj619ppFPHwEbsktosDyHXD
         fcIIjXVqbJBHxkgGXsLMtCmu1vC9PvinAoCB1VY2kDIjA+LdpaVdqlLnYNgjWZC0I0N2
         ijgoxahrxMHihToLV7qAu5rnBsUSiTWWgTDjKGUd2nTsq0cVJeACSh3O3jDTP6OYdKgN
         gEmnaJeOd+d7lNtk9h4MpCGyhuqcRIeA8ABqvv9VABlSUeXPb9HK8mRW2i+e03d4iilZ
         43zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWl2yZsYt8erfq7To360y3sx+oxp3BUCjlIropq93T+pDj5uBn7aENgqsKH9nSPlFtzPQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXSkkPMg3W/2qPwN7svwmtdta6GRi/pOHR68v18LWlKzmjc3Fm
	FKV+1VB5aZlpoOiY8V6EB59TN0EhBa9TEtqZCOukHZO70ClQ1Fk94AMUZSrO0s78q95oRaYDnzJ
	oKGJ7PagzJ9ai7rx0/MkCkgLf8W9T37AZaRWaDBJeKbdHLfmBqkJTRA==
X-Gm-Gg: ATEYQzxpKYDYEQMisKOTxI48DrB7AFDrZ4OJvzDNntjGzXLpdLXpproJ7zUbaZN6jDE
	xzcNRqvGCvNKYgYnZxJeMT2+z+Kt5GsghHTVdjBvJXgH5Z0Rh+or1yhZAgEO+l7aR3aEpdCHjz7
	bmZC8aDLrOIL8LbMXXT/FEIuYhrM86UUwvA6Bi9ZyDJM2lib7K6GIu76MDi00EFjBzPPEYJRfO8
	MYPfWI+8wYYHgcSHc3pWmu7zeSzWp3u2lsWMnWYY9+8Q14X+Gn+5RkXiQprb/zl+PiLanb4Nv8g
	kKWxW675VD6BugDC14Quo2AiImLFzN9hOcjF3YIy/BQIP6PIIpqlhFUQus9Z2hxHcAqyv0dNQV2
	1sCnBYbnGsKuYotz4x8UTnU9AXqOgA6Ks4tGKS8OtvMFUGw==
X-Received: by 2002:a05:600c:46c4:b0:483:7783:537b with SMTP id 5b1f17b1804b1-483c9c0f34cmr256504655e9.24.1772522357671;
        Mon, 02 Mar 2026 23:19:17 -0800 (PST)
X-Received: by 2002:a05:600c:46c4:b0:483:7783:537b with SMTP id 5b1f17b1804b1-483c9c0f34cmr256504245e9.24.1772522357187;
        Mon, 02 Mar 2026 23:19:17 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485126563ddsm15274465e9.3.2026.03.02.23.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 23:19:16 -0800 (PST)
Date: Tue, 3 Mar 2026 02:19:13 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
	Jason Wang <jasowang@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, nh-open-source@amazon.com
Subject: Re: [PATCH] vsock: Enable H2G override
Message-ID: <20260303021723-mutt-send-email-mst@kernel.org>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat>
 <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <20260302145121-mutt-send-email-mst@kernel.org>
 <079fcb93-cd01-45db-9ff7-d6cafd8fb7d5@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <079fcb93-cd01-45db-9ff7-d6cafd8fb7d5@amazon.com>
X-Rspamd-Queue-Id: 1FFBA1EA100
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72505-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 07:51:32AM +0100, Alexander Graf wrote:
> 
> On 02.03.26 20:52, Michael S. Tsirkin wrote:
> > On Mon, Mar 02, 2026 at 04:48:33PM +0100, Alexander Graf wrote:
> > > On 02.03.26 13:06, Stefano Garzarella wrote:
> > > > CCing Bryan, Vishnu, and Broadcom list.
> > > > 
> > > > On Mon, Mar 02, 2026 at 12:47:05PM +0100, Stefano Garzarella wrote:
> > > > > Please target net-next tree for this new feature.
> > > > > 
> > > > > On Mon, Mar 02, 2026 at 10:41:38AM +0000, Alexander Graf wrote:
> > > > > > Vsock maintains a single CID number space which can be used to
> > > > > > communicate to the host (G2H) or to a child-VM (H2G). The current logic
> > > > > > trivially assumes that G2H is only relevant for CID <= 2 because these
> > > > > > target the hypervisor.  However, in environments like Nitro
> > > > > > Enclaves, an
> > > > > > instance that hosts vhost_vsock powered VMs may still want to
> > > > > > communicate
> > > > > > to Enclaves that are reachable at higher CIDs through virtio-vsock-pci.
> > > > > > 
> > > > > > That means that for CID > 2, we really want an overlay. By default, all
> > > > > > CIDs are owned by the hypervisor. But if vhost registers a CID,
> > > > > > it takes
> > > > > > precedence.  Implement that logic. Vhost already knows which CIDs it
> > > > > > supports anyway.
> > > > > > 
> > > > > > With this logic, I can run a Nitro Enclave as well as a nested VM with
> > > > > > vhost-vsock support in parallel, with the parent instance able to
> > > > > > communicate to both simultaneously.
> > > > > I honestly don't understand why VMADDR_FLAG_TO_HOST (added
> > > > > specifically for Nitro IIRC) isn't enough for this scenario and we
> > > > > have to add this change.  Can you elaborate a bit more about the
> > > > > relationship between this change and VMADDR_FLAG_TO_HOST we added?
> > > 
> > > The main problem I have with VMADDR_FLAG_TO_HOST for connect() is that it
> > > punts the complexity to the user. Instead of a single CID address space, you
> > > now effectively create 2 spaces: One for TO_HOST (needs a flag) and one for
> > > TO_GUEST (no flag). But every user space tool needs to learn about this
> > > flag. That may work for super special-case applications. But propagating
> > > that all the way into socat, iperf, etc etc? It's just creating friction.
> > > 
> > > IMHO the most natural experience is to have a single CID space, potentially
> > > manually segmented by launching VMs of one kind within a certain range.
> > > 
> > > At the end of the day, the host vs guest problem is super similar to a
> > > routing table.
> > If this is what's desired, some bits could be stolen from the CID
> > to specify the destination type. Would that address the issue?
> > Just a thought.
> 
> 
> If we had thought of this from the beginning, yes. But now that everyone
> thinks CID (guest) == CID (host), I believe this is no longer feasible.
> 
> 
> Alex


I don't really insist, but just to point out that if we wanted to, we
could map multiple CIDs to host. Anyway.


> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597


