Return-Path: <kvm+bounces-68695-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cA9wM0OhcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68695-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:49:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 510EF54B03
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 114A68A181A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FBF4779A1;
	Wed, 21 Jan 2026 09:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cOSVseZ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BIgNmuoq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63E847B434
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 09:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988197; cv=none; b=R/etHjPxz0YqQe7ndzgVGmY2sJgHpq/tZvd0369gn4W/xpjGuwjKS1XDr3CLRyLu6uX/mjgxiZf/q5QrOgChaZLAYugzU2mE37MTExtjsu50NdeHdKVxUB0CeZhHQNvYJJYqImyhyEWh81MgYLK399D195mGT3J84Vj/BhqdDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988197; c=relaxed/simple;
	bh=fGsZTd5bffSkjK7pmvupzLZGleZjRWTTlZMrE5HbivA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CVCZKykvET9aqY7a7byn6jsdl+pM1/EWa/O/gba9IngTHDmdDJeBc3s9m7PoLB7yexR5JZ9on7Ai8U1HP9gOHF0y7bM7m5TPwA8wRwAaEhaFHq4brInSjRgY3iwFdyXAUqDjjSfD4V7h49FKe7gjGiiyDX8wcE0AgA+r4OxFUOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cOSVseZ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BIgNmuoq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768988194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R+pe6lmC40Ggeh//WpcWFgKiyf26tVP3wEil7HyM01I=;
	b=cOSVseZ3cTj9KXgJ9mQE5B8JNIGUxzGmXBiJXUw8KYly15DDxVgaFnvMc1geXrJZY7v7tR
	RSDh5j6pPW0OmalkedKPXoqqJu6pRr4teL2/82jAfVpxmK3ig3H4RY/eWnR+AP/AjfvUAI
	vVbG0ykpKg/W6p+kGsCXtPKgdEUspus=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-p92Bo3Q2OM-0d1PtlRZR_g-1; Wed, 21 Jan 2026 04:36:33 -0500
X-MC-Unique: p92Bo3Q2OM-0d1PtlRZR_g-1
X-Mimecast-MFC-AGG-ID: p92Bo3Q2OM-0d1PtlRZR_g_1768988192
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435a0fb0c9cso216567f8f.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 01:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768988192; x=1769592992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R+pe6lmC40Ggeh//WpcWFgKiyf26tVP3wEil7HyM01I=;
        b=BIgNmuoqhUUPhsL6lO8w44lczsGx5RI9YlRd6qmCZKkcTFf8fq1uq6ODEnwY2duSZ6
         KTu3uDctr6T2G2FCj27QAjEmJj6bKj+uROxRS2WX86BY35mXtzcYRsA4BSeQJJhzqeEt
         Ri1mBbs+OjkcdjPzT2B9+g1wkq+Afi6otDb48O8Di9vgVTBTqrBvJ6HwNF+asaVHWF0n
         10JkqE93952QoBCr9a/lGcbH7rXZvRS89n8vUaIxIFMGLdAbce0yGfTfjNHrkjWDpOsn
         jga0Hdnsp6tSNGObAP375pSFuyBM1SyJ98pwvMf572H0N8jBeXTWVcsXqrtgSBq+vl/g
         /RLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988192; x=1769592992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+pe6lmC40Ggeh//WpcWFgKiyf26tVP3wEil7HyM01I=;
        b=h1SdBNxVgKxQNtDZ+9CwMssHMGFOMcahEQ/jJkcwSOU8wjfnw4EPVs2wpXmFysWhA3
         Vc005lgZMTivSHIFP9JPfcxyBb/3USEQ4aec065XE4mRe14mEBX9VuU/1YFQq++d4oKC
         bEfyYHJvIRzbUmcpvAcRAjXdQ+zMPKA+tA+mqeKeHv/tbaCxD7zG2ByFC+fnCKjzcXsh
         kq5pJulQsMEVdpbCYr1Gx3u46iVC+8K/wP+XbKg0rgO6Z+B/u+lJ5mzaGV6725uq5QDj
         1dtTiVkEevkyLyIjjyV3Ac0/xgLLFFZBNkaXmUhXuyKREh3vaAQhmfmztkwOW98kL5o/
         //5w==
X-Forwarded-Encrypted: i=1; AJvYcCWkOS/E03l+Whve5JJzShkdG6e51MCp/NBufucfbjmfTp3AJn1+4aYZkiBwOjO7fL4T6QI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhklQ+b+qXSCOYkUbLnDZad01J/MRyLNulig5ZWjvG5Kz/kiaJ
	av9wsnvWG/hA8gErrTuq+x/9+cXcfwE6ain2YOH9xaH5a+rwbnVL0OFuixJ/FfkNbuJZ0NXRyIz
	n6pq0WC7dYfDj9q9KkJrx9LS1biza69yup99+1RnaCLpU6HScmyHT/w==
X-Gm-Gg: AZuq6aJM9FIDjF9qCJ9fD/CYycDv7ZxryGmJ06bzE174ajyHE2wsYzGVOCpvDuJCP6e
	bDti2ap1nRKGBmWhaD1FM4URdW+nD+l4/uFAP3qoNvutsbltkHaTaeH4qBod02AEl7UPJGP4BP6
	sEf4Gc6jSPakuhq24FanslKP/MhnTWYT7ODbKhNY1P39DjcaLowXdxHTGOt5U6jzNHDC+JcWTfR
	30Sx2+EWmkO4YFvVPYLlO0q4eN89r8n6TwD+y5jKBd+Y+0wFaikj1NYvtsPb4cpG8vsmfYgUq2K
	7z5rtoJBNFlOLgHrXNesAkgea9uMYIMkh5cxXrh+sD5kely8zZWS0xvd9KN3p8ZzpL96FUN72lU
	b1QCSzf6rNTeU8/QRqmSXYb/uCZCthBrrNlHyn4q3oOzMQ7CDDXsOflJ3FmQa
X-Received: by 2002:a05:6000:186f:b0:432:7d2a:2be4 with SMTP id ffacd0b85a97d-4358ff6fb27mr7238590f8f.60.1768988192255;
        Wed, 21 Jan 2026 01:36:32 -0800 (PST)
X-Received: by 2002:a05:6000:186f:b0:432:7d2a:2be4 with SMTP id ffacd0b85a97d-4358ff6fb27mr7238536f8f.60.1768988191774;
        Wed, 21 Jan 2026 01:36:31 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921facsm33887841f8f.5.2026.01.21.01.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:36:30 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Stefano Garzarella <sgarzare@redhat.com>,
	virtualization@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Asias He <asias@redhat.com>
Subject: [PATCH net v6 0/4] vsock/virtio: fix TX credit handling
Date: Wed, 21 Jan 2026 10:36:24 +0100
Message-ID: <20260121093628.9941-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	TAGGED_FROM(0.00)[bounces-68695-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 510EF54B03
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The original series was posted by Melbin K Mathew <mlbnkm1@gmail.com> till v4.
Since it's a real issue and the original author seems busy, I'm sending
the new version fixing my comments but keeping the authorship (and restoring
mine on patch 2 as reported on v4).

v6:
- Rebased on net tree since there was a conflict on patch 4 with another
  test added.
- No code changes.

v5: https://lore.kernel.org/netdev/20260116201517.273302-1-sgarzare@redhat.com/
v4: https://lore.kernel.org/netdev/20251217181206.3681159-1-mlbnkm1@gmail.com/

From Melbin K Mathew <mlbnkm1@gmail.com>:

This series fixes TX credit handling in virtio-vsock:

Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
Patch 2: Fix vsock_test seqpacket bounds test
Patch 3: Cap TX credit to local buffer size (security hardening)
Patch 4: Add stream TX credit bounds regression test

The core issue is that a malicious guest can advertise a huge buffer
size via SO_VM_SOCKETS_BUFFER_SIZE, causing the host to allocate
excessive sk_buff memory when sending data to that guest.

On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
32 guest vsock connections advertising 2 GiB each and reading slowly
drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
recovered after killing the QEMU process.

With this series applied, the same PoC shows only ~35 MiB increase in
Slab/SUnreclaim, no host OOM, and the guest remains responsive.

Melbin K Mathew (3):
  vsock/virtio: fix potential underflow in virtio_transport_get_credit()
  vsock/virtio: cap TX credit to local buffer size
  vsock/test: add stream TX credit bounds test

Stefano Garzarella (1):
  vsock/test: fix seqpacket message bounds test

 net/vmw_vsock/virtio_transport_common.c |  30 +++++--
 tools/testing/vsock/vsock_test.c        | 112 ++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.52.0


