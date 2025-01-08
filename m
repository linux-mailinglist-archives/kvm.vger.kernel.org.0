Return-Path: <kvm+bounces-34809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEE5A063F1
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:06:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9E27188742D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB796201113;
	Wed,  8 Jan 2025 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ba+XKSkU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A25E1FCD14
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736359589; cv=none; b=OCZ8EneAvRmXszgpf1vo/rbGnQn49Q9ZHs/BoxSYREiX6INM35IFqGw5JlET9oZyb4OsUZTPO69qn4rIHxfQNYFTbqHtma9pGBYwdZxrasMfYTJiSmTpH2nOYieBaUJqagTSDRWFtEagAneL05byozpNthXN6/BJeKHcyrRS7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736359589; c=relaxed/simple;
	bh=R4UWrVe5Gaa9ndThzF20AYFG7pj0l2pER0Xs1zgkco0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qRv3y/rmiHmAclawj2BUO3RxGE1yzTxXYuiJdXj8oWiVo/FIAb6iENhPbjDYOro7J48rP5yooeWsoUJfPj39dij4N7Vs2OPCyy62Ib2R+pxy84B+sf67/0rOgY9wxIPumBncYjOgDfrnmnz1YkP0Qds/IVUules1OHTFIbMV1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ba+XKSkU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736359585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bnu+BVkl+Xe97p0gYpH/rg1OlF1/gslhVoAE9Hfv1R0=;
	b=ba+XKSkUlnLoHDNX+lGU91WdsNORUXCp3+95qkPC4HyopikKJb5OMl+gs2OjnzC8Pk8v2O
	RuYtgQ75oK0wQ/efw5WaPmhGtrBSORDvACC2hf8GXbLizvvXFWtK8Z43G5SeWy275zVkf3
	S4j8OGoVUZbOj22l3ELCYTRl8T2Ag20=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-z0aUTBoRNQ-4CR4A98z92g-1; Wed, 08 Jan 2025 13:06:22 -0500
X-MC-Unique: z0aUTBoRNQ-4CR4A98z92g-1
X-Mimecast-MFC-AGG-ID: z0aUTBoRNQ-4CR4A98z92g
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-436328fcfeeso888405e9.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 10:06:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736359581; x=1736964381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bnu+BVkl+Xe97p0gYpH/rg1OlF1/gslhVoAE9Hfv1R0=;
        b=Z1WHaU0Q3RNImdPp1EBbIKmi6xPdDIjIF2bhnZTcbBR1MyKPErT8aqkQURbANgMQJ7
         qs1xWtavBNInztRpcdmV2vA9NqzvouT6/gUf55oKUwQvDE1WsdLeXHhfSmb6kay/NF17
         7Wc9kyQ8SsbDuX4/vWn2oM3A1mFQWLu3aEzeVyVQbiq4AXpk0KJBP9Wvq/3Ocg0OaXBd
         eKp3Ph2j89vF+zGK4fYKhlk8+6EMlP7xBCo0QKdpWbeufhtD21/7hz4aQxTZb9BYJcWz
         +C2diZXCA7iZrbo2SD6f6t8hdzuaj6+ji8fmCGORmNBJpHUkImupPZp1FYheuBf+bV/n
         v1fg==
X-Forwarded-Encrypted: i=1; AJvYcCUzypFvxV1HemwDm/pSlaTsNsijCX5/XAnY4v0FDE6T8t/q4Hd/VybYRnPbYO7ZRHZ3Cps=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYq9lBghxrRbGXJpiWVGJk4+enijM9y+baGPFUf85vvbeRb9y3
	/8WTZkZ9sF50MGqlLeX44Kj87bEwlFSW0H7rX2Jdk4watKj8rG13icamGT8yR/hjqyDrBs5i+0v
	aHxdtaIFP7oodn4CfjZyoCmMUu2s/k7/JCyYZytk52XxqlLI4pA==
X-Gm-Gg: ASbGnctCqnoaNyq8i69EzxGkg3Yv+a954v8BwL0U6H8W7q0d+CA+0Q2UGzCRqrQKZI2
	ftJX0rCNprnqJHbuua2h9inljYztiWBGATH8XEdGNAiiZcHXemQX3n5BkBAfkdxMkD5y2/8naku
	RXUnmySDV3DDHAadvc5TeBKQgDcMGfDHUmuQK4N0mM0LeDClm4dbxeHUftTTu4yLGwKuK79pOIo
	/DIZ4pVQBeKscdARS2kN/+TXgoLC1hsfzPgNzRsKFwwORo=
X-Received: by 2002:a05:600c:46d0:b0:431:58cd:b259 with SMTP id 5b1f17b1804b1-436e26f4d53mr37946715e9.31.1736359581546;
        Wed, 08 Jan 2025 10:06:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPzI29sT/XCixMM7XrCBkXw/ioHXUjl2FaMJjmaMr+6Pqs+CX8MLIRg6SGkdexZ2/7lWykfQ==
X-Received: by 2002:a05:600c:46d0:b0:431:58cd:b259 with SMTP id 5b1f17b1804b1-436e26f4d53mr37946165e9.31.1736359580892;
        Wed, 08 Jan 2025 10:06:20 -0800 (PST)
Received: from step1.. ([5.77.93.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c847d7fsm53389298f8f.60.2025.01.08.10.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 10:06:20 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Wongi Lee <qwerty@theori.io>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	virtualization@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	bpf@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Hyunwoo Kim <v4bel@theori.io>,
	Michal Luczaj <mhal@rbox.co>,
	kvm@vger.kernel.org
Subject: [PATCH net 0/2] vsock: some fixes due to transport de-assignment
Date: Wed,  8 Jan 2025 19:06:15 +0100
Message-ID: <20250108180617.154053-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.47.1
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series includes two patches discussed in the thread started by
Hyunwoo Kim a few weeks ago [1].

The first patch is a fix more appropriate to the problem reported in
that thread, the second patch on the other hand is a related fix but
of a different problem highlighted by Michal Luczaj. It's present only
in vsock_bpf and already handled in af_vsock.c

Hyunwoo Kim, Michal, if you can test and report your Tested-by that
would be great!

[1] https://lore.kernel.org/netdev/Z2K%2FI4nlHdfMRTZC@v4bel-B760M-AORUS-ELITE-AX/

Stefano Garzarella (2):
  vsock/virtio: discard packets if the transport changes
  vsock/bpf: return early if transport is not assigned

 net/vmw_vsock/virtio_transport_common.c | 7 +++++--
 net/vmw_vsock/vsock_bpf.c               | 9 +++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.47.1


