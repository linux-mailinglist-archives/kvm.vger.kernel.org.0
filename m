Return-Path: <kvm+bounces-53992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8769DB1B491
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3C9C7B09F0
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B78277CA4;
	Tue,  5 Aug 2025 13:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/TdBr0f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233722737F8;
	Tue,  5 Aug 2025 13:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399468; cv=none; b=eQU1EMpS+pmHliXcIE+6kAHYXL2n5TRtZZbgjqTEtJm1GwfUA15FvvzcVg0xc6ewaUOUJQPs5iXJeniBYw6FIMOPL0f0KpQNWh6dhxMmeh+Utmx5TF4Jp6dn90oXLnLC+hy9pCqevWXgQhxqUPZYUDCAOK+fQ7FM2LFYLg1M5MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399468; c=relaxed/simple;
	bh=mRdXlyaVgEfR7OWk3t/3Qh77MsdYzNNqgku4AEMnXIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UDNL3fA5bJWA8nvztdyklXxbo8XAJhAAFKXrJTmiTKR+ffVWggugkMPq34pnqvj4KQ6KgU6CTI3aQm7l8bMJjXgFFeA8aaLpGRrdA7vDbwCu5QIR7eg7h+KZjCTNumIwxAytJNnISMIYzgLhbPAY2Lbl+yw/0sjgS626RKbovM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/TdBr0f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC93C4CEF0;
	Tue,  5 Aug 2025 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399468;
	bh=mRdXlyaVgEfR7OWk3t/3Qh77MsdYzNNqgku4AEMnXIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/TdBr0fyFSACJUo8w8l4WBk0pjWP1FVjdUpLJsI63lOTuLslZ1wVEA/o2eqiJXp6
	 iXQ1Edm5pUC2oXCoJsb1rLuIJk1dL60SbgQlO5QgAbR9kyuGquxEJOvh1yit1Kbkus
	 kO4MUKJxwB/wwPjWXw/eaPPeMhbwc81qNO6XdpnolaRgF97fhfrazbDA9+AGQwSijG
	 +VmH93cHJzmOzEFbX+BNZzLPeeuarr/guJXAj5bbtAsGkwZt0QZAxz3/IPYszvmjm+
	 wSzDqt8aSIdtUgxnVFyjMkdbDAbCTknzZ/PT1720H8HIv0gy/5kdR+TIJYfWpRxBXM
	 zhC7FYTGsqjYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	stefanha@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page
Date: Tue,  5 Aug 2025 09:09:12 -0400
Message-Id: <20250805130945.471732-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

[ Upstream commit 03a92f036a04fed2b00d69f5f46f1a486e70dc5c ]

When allocating receive buffers for the vsock virtio RX virtqueue, an
SKB is allocated with a 4140 data payload (the 44-byte packet header +
VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE). Even when factoring in the SKB
overhead, the resulting 8KiB allocation thanks to the rounding in
kmalloc_reserve() is wasteful (~3700 unusable bytes) and results in a
higher-order page allocation on systems with 4KiB pages just for the
sake of a few hundred bytes of packet data.

Limit the vsock virtio RX buffers to 4KiB per SKB, resulting in much
better memory utilisation and removing the need to allocate higher-order
pages entirely.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-5-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Let me analyze what we know about this commit:

**Backport Status: YES**

This commit is a good candidate for stable backporting based on the
following analysis:

## Reasons for backporting:

1. **Memory efficiency fix**: The commit addresses a significant memory
   waste issue where ~3700 bytes out of 8KiB allocations were unusable.
   This is a ~46% memory waste for every RX buffer allocation.

2. **Avoids higher-order page allocations**: The original code forces
   the kernel to allocate higher-order pages (8KiB) on systems with 4KiB
   pages, which can lead to:
   - Memory fragmentation issues
   - Allocation failures under memory pressure
   - Degraded system performance

3. **Simple, contained fix**: The change is minimal and well-contained:
   - Changes `VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE` from a hardcoded 4096 to
     `SKB_WITH_OVERHEAD(1024 * 4)`
   - Removes the addition of `VIRTIO_VSOCK_SKB_HEADROOM` in
     `virtio_vsock_rx_fill()`
   - The SKB_WITH_OVERHEAD macro (defined as `((X) -
     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))`) ensures the
     entire SKB fits in a 4K page

4. **No functional changes**: This is purely an optimization that:
   - Doesn't change the protocol behavior
   - Doesn't introduce new features
   - Maintains backward compatibility
   - Only affects memory allocation patterns

5. **Clear performance benefit**: This provides immediate benefits to
   all vsock users by:
   - Reducing memory consumption by ~46% per RX buffer
   - Eliminating pressure on higher-order page allocations
   - Improving overall system memory efficiency

6. **Low risk**: The change is straightforward with minimal risk of
   regression:
   - The logic remains the same
   - Only the buffer sizing calculation changes
   - Has been reviewed by the vsock maintainer (Stefano Garzarella)

The commit meets all the stable tree criteria: it fixes a real problem
(memory waste and higher-order allocations), is minimal in scope,
doesn't introduce new features, and has clear benefits with low risk of
regression.

 include/linux/virtio_vsock.h     | 7 ++++++-
 net/vmw_vsock/virtio_transport.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 36fb3edfa403..6c00687539cf 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -111,7 +111,12 @@ static inline size_t virtio_vsock_skb_len(struct sk_buff *skb)
 	return (size_t)(skb_end_pointer(skb) - skb->head);
 }
 
-#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
+/* Dimension the RX SKB so that the entire thing fits exactly into
+ * a single 4KiB page. This avoids wasting memory due to alloc_skb()
+ * rounding up to the next page order and also means that we
+ * don't leave higher-order pages sitting around in the RX queue.
+ */
+#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	SKB_WITH_OVERHEAD(1024 * 4)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
 #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..f01f9e878106 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -307,7 +307,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
 {
-	int total_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM;
+	int total_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
 	struct scatterlist pkt, *p;
 	struct virtqueue *vq;
 	struct sk_buff *skb;
-- 
2.39.5


