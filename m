Return-Path: <kvm+bounces-34995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403C2A08A5A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA9C93A906F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C702D20898D;
	Fri, 10 Jan 2025 08:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1KLGp/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530CD20767A
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498121; cv=none; b=tfPQ9x27BdHKxdsZexkO97bBChlxy+1JaQRbPMQjLWQHLh1JOOrQBzbPlCHfaTzaBI1I+0Lh1VzdXpAhEPEFP+6qxOO2THz2OvudPevW/ggZs2WMEILW6DS8ZNuU3xKL2mM5erb3TD9b6flFFfYwajLpEiPjfP47CaPhgQtwBJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498121; c=relaxed/simple;
	bh=QijatkL6bTXb4QjXb8f+a6DCbXKfBlg4o0lO26tSjvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UV2Uwi3oAcbWUq7gkimOTJMccDgAXI4qBZnku07Mc5NJjUJwKKUTMBf1JCnZkchXIkSDhE8Q0iHs2/W+BqfC4ZKE+3pVD8mRArfnSH6rkBbLdk/B2WRfAStBGh0hCBQj4tk+g8rN/xFZvhoovfoYBzBegOEEE/eHKUqBzGScadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1KLGp/6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736498118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Yzh6BESNkCmUyBWDujO38MFMNfd269W0kyJHQMOPcgo=;
	b=Q1KLGp/6jBPTukyqyao4cRj8eZwT7TwMKr+U/54CnE13KfTZ2Y6C28vHJPI7CbB7aCtnEE
	HChrjDtnX8R7n6DrMaPYb2Ijk9SRjR6c2ViF3eC7JM2Mq1ZB4kYd9P2y46zCbFwzyTfp8k
	LeBmiVjz68zQ+RnzcRkGdmTBkmkIX1Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-KPetVSn6Ml6DxiOqk3ftGg-1; Fri, 10 Jan 2025 03:35:17 -0500
X-MC-Unique: KPetVSn6Ml6DxiOqk3ftGg-1
X-Mimecast-MFC-AGG-ID: KPetVSn6Ml6DxiOqk3ftGg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436379713baso8625795e9.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:35:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736498116; x=1737102916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yzh6BESNkCmUyBWDujO38MFMNfd269W0kyJHQMOPcgo=;
        b=WovIesSGMX0JAyhbghfNpXDsfMwKkvMz3VDJxdD/c1vqiFVqJQquQx41YrzvgvOK+I
         GpTskkwT482INusq3IkOqwUei3cP29i2fCYcgNffMZ8ZyS9ACivD2MyR5K9RdMqG36fL
         AMwOv4RzSLb3UTFx+AQ16hBOXsXWaBb6OAQtZaRTgwYCxNpGSmfyUCJkT7vO+5DToSEi
         4cWtjQ0WTHpYfS9xHzVvOBTZoinxCfrDSOuXclgJ1hqu0XyeiIkYHBbNZy///uCAnjeg
         x3xo1GhQlDxeIRV5uCKjN33OGkr53Fxkh5VzEQKBf9/UY2PoKIBZbboPLORbj9nOVClp
         ZauQ==
X-Forwarded-Encrypted: i=1; AJvYcCW00wVZMS0AkzoMGRAxm0IxQh4kERFsyHi5jQuIxFqRDUDElRZUWtL1PschxvgZycKDJcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YytancSsExU5wO2Sm0nnZP7IReG5UCR0NZj0SnBIc7rUjfzdPPF
	R95SvfwwFyMt0y7ggNM9ok/9UnHmEVzptz1mgaNvETRkO3S8WMYbmefPuatWDxEunTGxEgQ7s8d
	3atq6hv1X9sYAUVEtAtVLcPy7BTltn9uV6GnhhelEju0X76Q4AQ==
X-Gm-Gg: ASbGncuYjPw9DZEt8zIkVZe7ovif8mIf0GiKQW7slgKFBmjL3ioVV3llWKk+s26b2Qr
	QKs33hGDBzjQJB14SI35KZIt0IyJa8vmwLjLjZ36TTxgf2Rm5x6h+OOxpiuTrMR0ZEmPwgTSFT4
	6vYYFNb7yXLcr6x7xBg1IJsEPMKz59qoFy2HBAs4PFWybGDMlcWs5s9nDF6O5oqMgs/YvvDZ7my
	emNjyonwA7X95HoLurgpsx7PLEw5QN0PIgffIbIgOIsXjQ=
X-Received: by 2002:a05:600c:1e0e:b0:434:fd01:2e5f with SMTP id 5b1f17b1804b1-436e26ef441mr85679795e9.29.1736498115842;
        Fri, 10 Jan 2025 00:35:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXWC3jUEXmmFtLxV2Q6VbhhNg8qt0/mZE4AbvDPzxpMk49Vg8ocWzwB7SpzfJcC2i53xpVFg==
X-Received: by 2002:a05:600c:1e0e:b0:434:fd01:2e5f with SMTP id 5b1f17b1804b1-436e26ef441mr85679275e9.29.1736498115183;
        Fri, 10 Jan 2025 00:35:15 -0800 (PST)
Received: from step1.. ([5.77.78.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e8a326sm79953575e9.35.2025.01.10.00.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:35:14 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luigi Leonardi <leonardi@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	kvm@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Michal Luczaj <mhal@rbox.co>,
	virtualization@lists.linux.dev,
	Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH net v2 0/5] vsock: some fixes due to transport de-assignment
Date: Fri, 10 Jan 2025 09:35:06 +0100
Message-ID: <20250110083511.30419-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.47.1
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1: https://lore.kernel.org/netdev/20250108180617.154053-1-sgarzare@redhat.com/
v2:
- Added patch 3 to cancel the virtio close delayed work when de-assigning
  the transport
- Added patch 4 to clean the socket state after de-assigning the transport
- Added patch 5 as suggested by Michael and Hyunwoo Kim. It's based on
  Hyunwoo Kim and Wongi Lee patch [1] but using WARN_ON and covering more
  functions
- Added R-b/T-b tags

This series includes two patches discussed in the thread started by
Hyunwoo Kim a few weeks ago [1], plus 3 more patches added after some
discussions on v1 (see changelog). All related to the case where a vsock
socket is de-assigned from a transport (e.g., because the connect fails
or is interrupted by a signal) and then assigned to another transport
or to no-one (NULL).

I tested with usual vsock test suite, plus Michal repro [2]. (Note: the repo
works only if a G2H transport is not loaded, e.g. virtio-vsock driver).

The first patch is a fix more appropriate to the problem reported in
that thread, the second patch on the other hand is a related fix but
of a different problem highlighted by Michal Luczaj. It's present only
in vsock_bpf and already handled in af_vsock.c
The third patch is to cancel the virtio close delayed work when de-assigning
the transport, the fourth patch is to clean the socket state after de-assigning
the transport, the last patch adds warnings and prevents null-ptr-deref in
vsock_*[has_data|has_space].

Hyunwoo Kim, Michal, if you can test and report your Tested-by that
would be great!

[1] https://lore.kernel.org/netdev/Z2K%2FI4nlHdfMRTZC@v4bel-B760M-AORUS-ELITE-AX/
[2] https://lore.kernel.org/netdev/2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co/

Stefano Garzarella (5):
  vsock/virtio: discard packets if the transport changes
  vsock/bpf: return early if transport is not assigned
  vsock/virtio: cancel close work in the destructor
  vsock: reset socket state when de-assigning the transport
  vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]

 net/vmw_vsock/af_vsock.c                | 18 +++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 36 ++++++++++++++++++-------
 net/vmw_vsock/vsock_bpf.c               |  9 +++++++
 3 files changed, 53 insertions(+), 10 deletions(-)


base-commit: fbfd64d25c7af3b8695201ebc85efe90be28c5a3
-- 
2.47.1


