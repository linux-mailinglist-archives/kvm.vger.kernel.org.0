Return-Path: <kvm+bounces-71619-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAU1HeW/nWnzRgQAu9opvQ
	(envelope-from <kvm+bounces-71619-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:12:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 13458188DA5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 233E53074A0B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 15:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB72C3A1CE0;
	Tue, 24 Feb 2026 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cn/lkXq6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qtAZPZRs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8B61EBFE0
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945819; cv=none; b=VH8LMqEVLuF1GP3IHkpSRQJl+2eaJHrrGIKnKHtn0+w5DDpQZRWr4xlWOaveXxT0lnaE3sgn6vDaFXUKy77I6UGwmRAVfMSBOqI1QGnyC/gaFClSVtgM12e+fdDXcWOgl8xmatlkQTgLr/sBlU9bMks3HIYLH6+E+GJEQ2d5cMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945819; c=relaxed/simple;
	bh=TAyHgBBI4ob9tTcrFegG2TRo7EKXGQuXyNpp/MzDVco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8sa4XsVNqxd2YyaZf8D2FhjrKAUno2UYKaygH/1L+m5NqwTrD1Ti9MwJ1NS3pLODYCuReBXRgw0UqUzvs5dbAoyPq0rF+xBlbRHLyYfn/P87YiGhg2+SGNFqNVZBId7I/3G1VeiBwNGE8sq8oOXO63CznsZLAY2XKqFobVMV1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cn/lkXq6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qtAZPZRs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771945816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sCeOSff7eDNB7TgbEfprmGtaT8WW51aaIgrRBupCpNA=;
	b=Cn/lkXq6YEK1vLnFlTOgXLa0Ykgr8IVDtek4hHRtUhUE1im4QiBhL7vN4J8Qk5aWIiD2Uc
	m0rQc779H7yZtqPHTt0U1WDxOkSGw1kdxd25PbGUthn+4uhTDEkGlKPfKAK+zrtTuzVuBj
	V5SZlxKqnLkvwx72K8PAY+A3AR3yQkc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-MavK8_KINTyAkgkmTr2Keg-1; Tue, 24 Feb 2026 10:10:15 -0500
X-MC-Unique: MavK8_KINTyAkgkmTr2Keg-1
X-Mimecast-MFC-AGG-ID: MavK8_KINTyAkgkmTr2Keg_1771945814
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48378c4a79fso42580435e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771945814; x=1772550614; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCeOSff7eDNB7TgbEfprmGtaT8WW51aaIgrRBupCpNA=;
        b=qtAZPZRsazWcNEz1dpn43MRNn7EqFMH6VV6pZ87VafHbDrcQEQOfi02XT09VW5yhB1
         9XZ0xPalpY7hY8ePKM4De1ov9ZSJFRsVX/eQpvrCRu7ks1NvnkmVPJNOJyzYF/Xm2NXc
         ueZJ1mG7Kci4NBnwl4qRBJn2r9oud/asUA4diHCVzDZ1nYQLJQm1afF6n6B0qp9f+PHK
         sUiEIQ64rbteFK83QYFGG5Swrjs+PzBRF+/BReAINXBfgfqBwYvaLhrijhCPf+eA9iVC
         awSbBUKjSvCNldw6QPXub/8jEGw5ZyhzC5gYE7hG/FRJHl0vfDxZkRDBWA/z1K2yPLgN
         nBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771945814; x=1772550614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCeOSff7eDNB7TgbEfprmGtaT8WW51aaIgrRBupCpNA=;
        b=o+FO29BMdz9S3I90zGg/W1nlD9ZYbu1A2c4ktPOnEABw4lRzH75u06OBD0T2vN6bNF
         Nn0FKfaqXHYHPZKwb6/Qi7EJtEBbAy3UjlNOMQEH+oSvqRSVGd5a5Om+vF3TcUE5zAfg
         Nl0YOEy1bM6pwud7XodA0egLKZmNBREN4pipIizPWEh2HgE5h7rHlpMqWbNLuv3fNmX3
         cxDWKJMKPK7ZbIAJTuG0GVlyvPZtSXcP2gUok+toenntjIm+r3gvr5bUqGsHlrGhgTzU
         GQo7bixzHb1TrqJ/TffIT1G7CvP9EDM+cXkzbrecdLtXP7dTHg6kapPNWJ8NOjk0ITCa
         7DGw==
X-Forwarded-Encrypted: i=1; AJvYcCVfVjDgMkkzxIUFNe7D4lNoLUQebnd65C+FgdCjdVOJDmF6v780jHhtuFsU9tKjE6zAuAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqDa+z8PwyFGbSYgFNpfML/kcsn8gjh+Xciq91l4tAH6FmgHPj
	tUt9M5t35PnTCUBoH/ncFi6PwNK7BNtM7R8iWECVvMKNuhdMNAm4WxKW/ctHhCuI2i9i1Y7dWhD
	pR+rTBWdLab6enDTPgD4d1ezYHzAOzEof1a3giY1Zaf3xh09Se9twUg==
X-Gm-Gg: AZuq6aK3cM9qvpUn/voTGRCA3fL9MCrtkIEh3oFAGj37N3xTjJcLsqSlpIJ+GfBLwQZ
	Yjy4JZOHq3oA1CYLnofikOMvldbI3zFzbpucHba9RtEfRAuyiBHy33d6uovewo8By2nM3C2baAl
	LsJr2AWOBPPLw0RGhITl+T8UO8wQ6LaM3jQHrdWKEVpNNwdBRMS2BmKefla3ESgqQ5DZooUWV6h
	VDevPZgtGMPHGr3W9aZ4iX+AjkBY/hIDi+OP6Gz7KpDzY37n4NKT3L9gvsfaJ589CLgJiUaw7H7
	fFnebAjf2kICueoBnV5nBT1d7Ib5CKZ6N6W6LNhi3g0al8K0JIefqDNJq6/1p5cmw41rJ4wBHDQ
	ZyRs6S5FiwFzaa3Aeg8uU+2NtC2bIvaxategZkg8T89yq6SlnDq/tgOCTqRtnzOUfdFA1TZk=
X-Received: by 2002:a05:600c:3516:b0:483:a21:7744 with SMTP id 5b1f17b1804b1-483a9637590mr181464275e9.26.1771945813986;
        Tue, 24 Feb 2026 07:10:13 -0800 (PST)
X-Received: by 2002:a05:600c:3516:b0:483:a21:7744 with SMTP id 5b1f17b1804b1-483a9637590mr181463595e9.26.1771945813378;
        Tue, 24 Feb 2026 07:10:13 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b8912fcasm19737805e9.27.2026.02.24.07.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:10:12 -0800 (PST)
Date: Tue, 24 Feb 2026 16:10:07 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	kuniyu@google.com, ncardwell@google.com, Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net v3 2/3] vsock: lock down child_ns_mode as write-once
Message-ID: <aZ2-yzyNKXNkvPVG@sgarzare-redhat>
References: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
 <20260223-vsock-ns-write-once-v3-2-c0cde6959923@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260223-vsock-ns-write-once-v3-2-c0cde6959923@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71619-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,meta.com,lwn.net,linuxfoundation.org,lists.linux.dev,vger.kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:email]
X-Rspamd-Queue-Id: 13458188DA5
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 02:38:33PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Two administrator processes may race when setting child_ns_mode as one
>process sets child_ns_mode to "local" and then creates a namespace, but
>another process changes child_ns_mode to "global" between the write and
>the namespace creation. The first process ends up with a namespace in
>"global" mode instead of "local". While this can be detected after the
>fact by reading ns_mode and retrying, it is fragile and error-prone.
>
>Make child_ns_mode write-once so that a namespace manager can set it
>once and be sure it won't change. Writing a different value after the
>first write returns -EBUSY. This applies to all namespaces, including
>init_net, where an init process can write "local" to lock all future
>namespaces into local mode.
>
>Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
>Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Co-developed-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> include/net/af_vsock.h    | 13 +++++++++++--
> include/net/netns/vsock.h |  3 +++
> net/vmw_vsock/af_vsock.c  | 15 ++++++++++-----
> 3 files changed, 24 insertions(+), 7 deletions(-)

I still slightly prefer the version I proposed here: 
https://lore.kernel.org/netdev/aZbR2H2oDyIAxDef@sgarzare-redhat/

But this definitely affects the code less, so for `net` I think this 
patch is better:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Eventually, we can discuss in net-next patch whether to change the 
implementation to the other one, but for the user nothing changes at 
all.

Thanks,
Stefano

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index d3ff48a2fbe0..533d8e75f7bb 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -276,10 +276,19 @@ static inline bool vsock_net_mode_global(struct vsock_sock *vsk)
> 	return vsock_net_mode(sock_net(sk_vsock(vsk))) == VSOCK_NET_MODE_GLOBAL;
> }
>
>-static inline void vsock_net_set_child_mode(struct net *net,
>+static inline bool vsock_net_set_child_mode(struct net *net,
> 					    enum vsock_net_mode mode)
> {
>-	WRITE_ONCE(net->vsock.child_ns_mode, mode);
>+	int new_locked = mode + 1;
>+	int old_locked = 0; /* unlocked */
>+
>+	if (try_cmpxchg(&net->vsock.child_ns_mode_locked,
>+			&old_locked, new_locked)) {
>+		WRITE_ONCE(net->vsock.child_ns_mode, mode);
>+		return true;
>+	}
>+
>+	return old_locked == new_locked;
> }
>
> static inline enum vsock_net_mode vsock_net_child_mode(struct net *net)
>diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
>index b34d69a22fa8..dc8cbe45f406 100644
>--- a/include/net/netns/vsock.h
>+++ b/include/net/netns/vsock.h
>@@ -17,5 +17,8 @@ struct netns_vsock {
>
> 	enum vsock_net_mode mode;
> 	enum vsock_net_mode child_ns_mode;
>+
>+	/* 0 = unlocked, 1 = locked to global, 2 = locked to local */
>+	int child_ns_mode_locked;
> };
> #endif /* __NET_NET_NAMESPACE_VSOCK_H */
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 9880756d9eff..50044a838c89 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -90,16 +90,20 @@
>  *
>  *   - /proc/sys/net/vsock/ns_mode (read-only) reports the current namespace's
>  *     mode, which is set at namespace creation and immutable thereafter.
>- *   - /proc/sys/net/vsock/child_ns_mode (writable) controls what mode future
>+ *   - /proc/sys/net/vsock/child_ns_mode (write-once) controls what mode future
>  *     child namespaces will inherit when created. The initial value matches
>  *     the namespace's own ns_mode.
>  *
>  *   Changing child_ns_mode only affects newly created namespaces, not the
>  *   current namespace or existing children. A "local" namespace cannot set
>- *   child_ns_mode to "global". At namespace creation, ns_mode is inherited
>- *   from the parent's child_ns_mode.
>+ *   child_ns_mode to "global". child_ns_mode is write-once, so that it may be
>+ *   configured and locked down by a namespace manager. Writing a different
>+ *   value after the first write returns -EBUSY. At namespace creation, ns_mode
>+ *   is inherited from the parent's child_ns_mode.
>  *
>- *   The init_net mode is "global" and cannot be modified.
>+ *   The init_net mode is "global" and cannot be modified. The init_net
>+ *   child_ns_mode is also write-once, so an init process (e.g. systemd) can
>+ *   set it to "local" to ensure all new namespaces inherit local mode.
>  *
>  *   The modes affect the allocation and accessibility of CIDs as follows:
>  *
>@@ -2853,7 +2857,8 @@ static int vsock_net_child_mode_string(const struct ctl_table *table, int write,
> 		    new_mode == VSOCK_NET_MODE_GLOBAL)
> 			return -EPERM;
>
>-		vsock_net_set_child_mode(net, new_mode);
>+		if (!vsock_net_set_child_mode(net, new_mode))
>+			return -EBUSY;
> 	}
>
> 	return 0;
>
>-- 
>2.47.3
>


