Return-Path: <kvm+bounces-71155-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPqjOp2ElGlBFQIAu9opvQ
	(envelope-from <kvm+bounces-71155-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:09:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AAC14D6E4
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4817E3004C84
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 15:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B734D36CDE2;
	Tue, 17 Feb 2026 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQMgqyOL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q2wmJ0DP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4994C97
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771340927; cv=none; b=NMdjHHcaIjCaL4kovtCQQLEoWBp9skIDh0xHXkQHrBr59/MXbWhXKM9Pdo37hh7VvDsvY19E2fkq9OSXXjobi6JkVixS2H+SXGy8cupwFn6nO4ZsXBnMb8eYLFkUbF8K99fkDdrUxfurIWN5KvG83KtRiICA/DW5ppXDvoUb6+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771340927; c=relaxed/simple;
	bh=FATg9XsSiPlYwAbae8L/USKuKRBil6Mn8gqbYCmEG2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhLsJV7avznMtY+8vb4h9WPsHAotFUF9qUK7tcGerZRl9JUGhfsuF5zNmxFwAB0FrGjGBaCHQj8X6h4BY+ECX3XjO9Wi7LREMVt75EJRJ7rhP73t2AHT3kQXBNjFBppLkBTU4ozaXDoK0IdOp61CBDhdLzYC2ksR5amsJvowiGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQMgqyOL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q2wmJ0DP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771340925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jEc67c+eucBHPlMa8Z8GafQvzyfH5CJQ48/ZIvcQG9w=;
	b=HQMgqyOLCR0Kc8prihtCKCt5Ccd0OkMDpsJbF+9M4qJei12K18I39typGEWahftEpYluI8
	pnvgSZV+79/A2OXWUpy68e/80W+p2sWBiEfiSSARneJkWgN/O4KGJpReCibU7VMHzx8Ai2
	wuVJYiTglbArlSITF6kQt9NDiWzC2/s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-Q_dd5spsPtqC1jNOCSySNA-1; Tue, 17 Feb 2026 10:08:42 -0500
X-MC-Unique: Q_dd5spsPtqC1jNOCSySNA-1
X-Mimecast-MFC-AGG-ID: Q_dd5spsPtqC1jNOCSySNA_1771340921
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so47324505e9.3
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 07:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771340921; x=1771945721; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jEc67c+eucBHPlMa8Z8GafQvzyfH5CJQ48/ZIvcQG9w=;
        b=Q2wmJ0DPwomE3lsee1BYstQjxqAnEoTsy5rJ+GWkPVk8D2TXrPTr+q9n8RfHUtq6SU
         QkMKme1nOLQPh3W91U2V+9xYt6kUNqX56HkI+vksqVJHb6CzSYBoBA04iEkLOkgvJfCN
         Ak9ZVvabnKDg1E6BW13xVNL6Sa8FLyHglfTZqy7QFyBj+p/48xxZCUIIJM4N+rEyGXRS
         fKIP2GV0s0i0ZcDAVrdZ+qjYM5Z0bSsjw5cdpD8bvUd3kH5FphEqA1D4QKB6MteiGUIV
         yfznMv6w5ra0fpKcDt+HWEkfAb+DPIZNnqqil2+Y7sk0/jNVnCXcsc9CyiIpOav8I+n5
         dBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771340921; x=1771945721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jEc67c+eucBHPlMa8Z8GafQvzyfH5CJQ48/ZIvcQG9w=;
        b=FiFrpcmrVv5bsBsM7Qw6kWmb3PCBBDpAokCYw32gxSjLPLlMfmdpJ2LUL3zLG7ZbPy
         DwHGM6TpGOPqIJPfxofoU3BD5ne/1pAIv1j8qXs/KewIKvTkXBXvwAlSIhJRUL6bEVzB
         fH+BzpT6UM6BmtgTqi6UXnmKxkYIxtwwkVqdi44Af25MipUNswluP5fevkDkN6gXRK2D
         urAvrn/vzESziFrPOnET8wuKc8Yo003W2Io4CivkVchJtmHVv+xnkxNaSntBXsrZ20hV
         dPczeLIcxedOosQLeAG6n6qwCULX+CGnancTboyDkcp7DSzoXtWVvZ3w/P0QdlOYE5A5
         3OAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXofEQm9R84TISp3IQZ7WCAAwZiEFDrUj7R4dbns5GgSm+OPPjXpi28xdvAhlWLruBXCFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyPhFOmK3/qR4OsRYNRFYubLWlAtI1lwiehdN8oN2OLH7QgYtt
	vlKwNvNecG5volcbp556VbT26E/UVPYHLNLI9jAfhqt0W+AQFmruOETNRl7yG2beJCEixFAty5Z
	cmgUwhP8mK0n+DFFWj/YQMD95bXQ3TPSEQ0GKgtff+beRAPgfjWQaiQ==
X-Gm-Gg: AZuq6aJOEkiDvjU3IHGs3dpDTA5fLdC8mq/SEkQi+uk4eCYiylbviGrzqW/h7AEAfu+
	soXNNsu0RcvaEVHiwxtZeU/GtVl+g6KQ0dS7c87Dxm/H5fs07+toUznOb9AqN+530fQ4Ye37FOe
	tc/OLS85GT/iDB74np3tXKrZCWyekF8Yj5uGEzvWEGeGG0jZco9gjtz2i6lfHFzp0O+LtvZdH5/
	Tn0DOLJjfy94qvQOxBpJgZ8fILFLXnieTdKR69lo9Ynxy2rZBrlXs47BBJ9Yd5nZjzPGf1DWi8X
	cd2rN74CcgVcMrl43XCO5pzlaCjbO+J+XsiQ8FXHfx0OsF0ujfS27kbjxbA46e0tP5Fj0wnxOXM
	O5FGBP7i8uEzG01UaAdluaIi6X9ZNt8vgIaX3m7aqGIn8e8r+yYEMSP/ZiF9HG//kSumlNXM=
X-Received: by 2002:a05:600c:1c1c:b0:477:7b16:5fb1 with SMTP id 5b1f17b1804b1-483739ff8damr256414615e9.7.1771340920702;
        Tue, 17 Feb 2026 07:08:40 -0800 (PST)
X-Received: by 2002:a05:600c:1c1c:b0:477:7b16:5fb1 with SMTP id 5b1f17b1804b1-483739ff8damr256413865e9.7.1771340920135;
        Tue, 17 Feb 2026 07:08:40 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b64b08bsm102571985e9.6.2026.02.17.07.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 07:08:39 -0800 (PST)
Date: Tue, 17 Feb 2026 16:08:33 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>, 
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	Daan De Meyer <daan.j.demeyer@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	linux-doc@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v16 01/12] vsock: add netns to vsock core
Message-ID: <aZNNBc390y6V09qO@sgarzare-redhat>
References: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
 <20260121-vsock-vmtest-v16-1-2859a7512097@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260121-vsock-vmtest-v16-1-2859a7512097@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71155-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,redhat.com,kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[35];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 30AAC14D6E4
X-Rspamd-Action: no action

Hi,

On Wed, Jan 21, 2026 at 02:11:41PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add netns logic to vsock core. Additionally, modify transport hook
>prototypes to be used by later transport-specific patches (e.g.,
>*_seqpacket_allow()).
>
>Namespaces are supported primarily by changing socket lookup functions
>(e.g., vsock_find_connected_socket()) to take into account the socket
>namespace and the namespace mode before considering a candidate socket a
>"match".
>
>This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
>report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
>for new namespaces.

talking about this new feature with Daan (in CC) we were discussing a 
possible change to `child_ns_mode`.

Currently, if two or more administrator processes in the same namespace 
set `child_ns_mode`, they compete. Obviously, after unshare()/clone(), 
the process can always access `ns_mode` to check if everything went well 
and eventually retry.

Daan suggested a more conservative approach, allowing `child_ns_mode` to 
be written only once (a bit like we did in the old version when the 
child could change the mode only once). This way, most users who want 
isolation write `local` in `child_ns_mode` at startup in the init_ns. At 
that point the user  and can be sure that no other process (including 
administrators, e.g., container managers) can change it, so all new 
namespaces will have `local` mode.

I think we should support this option in some way, because it seems to 
simplify the user space in most common cases (ensure isolation). I see 
few options for doing this:

1. Change the behavior of `child_ns_mode` to be written only once, but 
this would limit other possible use cases where `child_ns_mode` can be 
changed more than once (I don't know if Bobby had any in mind).

2. Add a new sysctl `child_ns_mode_lockin` (or something similar), which 
can only be written once with a mode (local or global). A write on this 
will also locks `child_ns_mode`, of course.

3. Add a new `local-locked` mode, reusing the same sysctl.


If we go for 1, maybe we can do it in 7.0, or not?

2 and 3, on the other hand, may have to wait until the next release.

What do you think? Any comments?

Thanks,
Stefano


