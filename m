Return-Path: <kvm+bounces-27340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD007984164
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C842B24BBE
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 09:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99700166F13;
	Tue, 24 Sep 2024 09:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="1Qp7CrpT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F129E155324
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 09:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727168481; cv=none; b=XF2dJTs/bL8Rb6+yNaMc8cwo0EQv1rxctQ+QQVZ8roNuspjd4ts15ux9zrcIuc07kIPo0DwVe8Tc8SRLxX2TEw7l/bwK4hciG5Zfpl/fN/vELV1C7Ergr+lrCn+tIr4lJsPierZ3y5dpreMX2X+I6D87szvBtNgvBQ+ixFEmYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727168481; c=relaxed/simple;
	bh=sOAXGGuPxVhRSBMMLtZjJhQOr2JtLUlri/1Ey3yMBnI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=uugJKJTiD/9KqcMcOSqmZi3iZLBoJOYvH2d2GTTxScXIgyp7Fo/IWcvxVWmqUDmHEiA52Eh6v0N7QebnlgblWM5x0sJJ/JnXWkHLB7c+HrLk27z0Z1E1mmmBYSl/YVUImLbxXmF/5BO6CBnZ7/mLZ0STcy2XCweNA7ZAg1w8feM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=1Qp7CrpT; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a86e9db75b9so835071566b.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 02:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1727168478; x=1727773278; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ov2zUxVwXGroWMKfnwaYR/rA1EzTscWc/86yRpml0UI=;
        b=1Qp7CrpTHkbJfKVRRUEMi92mkKVMJtsf7eqFjsrffUEOgu4kQg8EWaMK/0HDI/lKDn
         WckKlqF7RjOSW3UHriAy4AF6+Zqro07LC/KeLJv3WZvd/78gSfavc4xu9sqqTFEynHhb
         nyx2qX4TP2+42acQCsSBOIwcrnqFhee8AaBxzaT2IOJjLkb5tq+GCtObfZNQBg+lH6ye
         qVupj8se9wtJ0sUwgnJgNrW7zYw9PyVOlXE0ffZKBtwc3So4Qw1+aRAeCp0iQqoPpSHh
         gRdBTnNE8g8wN/x3W+iFWm0CSjj/4UZyeu1xDxZB2dW0yOqmVOxwgYF0hJH/UCsKHB/u
         jkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727168478; x=1727773278;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ov2zUxVwXGroWMKfnwaYR/rA1EzTscWc/86yRpml0UI=;
        b=ZzZRNDc6oR722QJ2E7XWDeKl51py0RF4iEerVylZlEpG1jiLqfY1yxL8UUwdtvc7d9
         2SXzHy3x2/IE6PwAhE54ac6ojybwbX8ei45SZqU8HzOsbTXBIaVworL9HbB4xb9RMEMn
         BlweDMHUSiO5/JtqZjJzpfvw8QF8CCTHrwWLt0NJR59SJZop6B4YShzueIZ/k7wAvKS8
         TBWbZVrPjTXyU2hSm16r8G4RR3kvXnakAh9JRhbnKsFYH9fDK5FRswyKvhqR8J325R54
         29YaMsOS2wcrkxl0NCmEsWHfYKhAB2f3F4muWROWRQlk+VMSHLLxH9FwmMYhh3cKNfs2
         a9HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMsGWAnsjVgSVVTcvm56X6zx+EEMPHdgeYIzp2nmHtaoFZG2hjOk2L6BvayjgATBuQdr4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlbd1Wjee0mOTjZekyPcSLtPvs4ij8MJACyZcad6RlWZYJITu5
	AZQffScNv+hHO+AjWFnp4WoiLJttXVZK8VjVyfE85vgAXAB61Ir50MUypKyawJs=
X-Google-Smtp-Source: AGHT+IFWAkqffQdJf6+ooG5u5r4ZbQRITl2L+f/622eMMHM38TeEo3AkjhjZ7Qd4F4SO1RqijO7WQw==
X-Received: by 2002:a17:907:9348:b0:a8d:3998:2d2 with SMTP id a640c23a62f3a-a90d518718fmr1921620866b.58.1727168478186;
        Tue, 24 Sep 2024 02:01:18 -0700 (PDT)
Received: from localhost ([193.32.29.227])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9393134bd2sm58552866b.214.2024.09.24.02.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 02:01:17 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 24 Sep 2024 11:01:07 +0200
Subject: [PATCH RFC v4 2/9] virtio_net: Add functions for hashing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240924-rss-v4-2-84e932ec0e6c@daynix.com>
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
In-Reply-To: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

They are useful to implement VIRTIO_NET_F_RSS and
VIRTIO_NET_F_HASH_REPORT.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/linux/virtio_net.h | 174 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 276ca543ef44..f7a4149efb3e 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -9,6 +9,180 @@
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/virtio_net.h>
 
+struct virtio_net_hash {
+	u32 value;
+	u16 report;
+};
+
+struct virtio_net_toeplitz_state {
+	u32 hash;
+	u32 key_buffer;
+	const __be32 *key;
+};
+
+#define VIRTIO_NET_SUPPORTED_HASH_TYPES (VIRTIO_NET_RSS_HASH_TYPE_IPv4 | \
+					 VIRTIO_NET_RSS_HASH_TYPE_TCPv4 | \
+					 VIRTIO_NET_RSS_HASH_TYPE_UDPv4 | \
+					 VIRTIO_NET_RSS_HASH_TYPE_IPv6 | \
+					 VIRTIO_NET_RSS_HASH_TYPE_TCPv6 | \
+					 VIRTIO_NET_RSS_HASH_TYPE_UDPv6)
+
+#define VIRTIO_NET_RSS_MAX_KEY_SIZE 40
+
+static inline void virtio_net_toeplitz_calc(struct virtio_net_toeplitz_state *state,
+					    const __be32 *input, size_t len)
+{
+	u32 key;
+
+	while (len) {
+		state->key++;
+		key = be32_to_cpu(*state->key);
+
+		for (u32 bit = BIT(31); bit; bit >>= 1) {
+			if (be32_to_cpu(*input) & bit)
+				state->hash ^= state->key_buffer;
+
+			state->key_buffer =
+				(state->key_buffer << 1) | !!(key & bit);
+		}
+
+		input++;
+		len--;
+	}
+}
+
+static inline u8 virtio_net_hash_key_length(u32 types)
+{
+	size_t len = 0;
+
+	if (types & VIRTIO_NET_HASH_REPORT_IPv4)
+		len = max(len,
+			  sizeof(struct flow_dissector_key_ipv4_addrs));
+
+	if (types &
+	    (VIRTIO_NET_HASH_REPORT_TCPv4 | VIRTIO_NET_HASH_REPORT_UDPv4))
+		len = max(len,
+			  sizeof(struct flow_dissector_key_ipv4_addrs) +
+			  sizeof(struct flow_dissector_key_ports));
+
+	if (types & VIRTIO_NET_HASH_REPORT_IPv6)
+		len = max(len,
+			  sizeof(struct flow_dissector_key_ipv6_addrs));
+
+	if (types &
+	    (VIRTIO_NET_HASH_REPORT_TCPv6 | VIRTIO_NET_HASH_REPORT_UDPv6))
+		len = max(len,
+			  sizeof(struct flow_dissector_key_ipv6_addrs) +
+			  sizeof(struct flow_dissector_key_ports));
+
+	return sizeof_field(struct virtio_net_toeplitz_state, key_buffer) + len;
+}
+
+static inline u32 virtio_net_hash_report(u32 types,
+					 struct flow_dissector_key_basic key)
+{
+	switch (key.n_proto) {
+	case cpu_to_be16(ETH_P_IP):
+		if (key.ip_proto == IPPROTO_TCP &&
+		    (types & VIRTIO_NET_RSS_HASH_TYPE_TCPv4))
+			return VIRTIO_NET_HASH_REPORT_TCPv4;
+
+		if (key.ip_proto == IPPROTO_UDP &&
+		    (types & VIRTIO_NET_RSS_HASH_TYPE_UDPv4))
+			return VIRTIO_NET_HASH_REPORT_UDPv4;
+
+		if (types & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
+			return VIRTIO_NET_HASH_REPORT_IPv4;
+
+		return VIRTIO_NET_HASH_REPORT_NONE;
+
+	case cpu_to_be16(ETH_P_IPV6):
+		if (key.ip_proto == IPPROTO_TCP &&
+		    (types & VIRTIO_NET_RSS_HASH_TYPE_TCPv6))
+			return VIRTIO_NET_HASH_REPORT_TCPv6;
+
+		if (key.ip_proto == IPPROTO_UDP &&
+		    (types & VIRTIO_NET_RSS_HASH_TYPE_UDPv6))
+			return VIRTIO_NET_HASH_REPORT_UDPv6;
+
+		if (types & VIRTIO_NET_RSS_HASH_TYPE_IPv6)
+			return VIRTIO_NET_HASH_REPORT_IPv6;
+
+		return VIRTIO_NET_HASH_REPORT_NONE;
+
+	default:
+		return VIRTIO_NET_HASH_REPORT_NONE;
+	}
+}
+
+static inline void virtio_net_hash_rss(const struct sk_buff *skb,
+				       u32 types, const __be32 *key,
+				       struct virtio_net_hash *hash)
+{
+	struct virtio_net_toeplitz_state toeplitz_state = {
+		.key_buffer = be32_to_cpu(*key),
+		.key = key
+	};
+	struct flow_keys flow;
+	u16 report;
+
+	if (!skb_flow_dissect_flow_keys(skb, &flow, 0)) {
+		hash->report = VIRTIO_NET_HASH_REPORT_NONE;
+		return;
+	}
+
+	report = virtio_net_hash_report(types, flow.basic);
+
+	switch (report) {
+	case VIRTIO_NET_HASH_REPORT_IPv4:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v4addrs,
+					 sizeof(flow.addrs.v4addrs) / 4);
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_TCPv4:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v4addrs,
+					 sizeof(flow.addrs.v4addrs) / 4);
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports, 1);
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_UDPv4:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v4addrs,
+					 sizeof(flow.addrs.v4addrs) / 4);
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports, 1);
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_IPv6:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v6addrs,
+					 sizeof(flow.addrs.v6addrs) / 4);
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_TCPv6:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v6addrs,
+					 sizeof(flow.addrs.v6addrs) / 4);
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports, 1);
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_UDPv6:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v6addrs,
+					 sizeof(flow.addrs.v6addrs) / 4);
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports, 1);
+		break;
+
+	default:
+		hash->report = VIRTIO_NET_HASH_REPORT_NONE;
+		return;
+	}
+
+	hash->value = toeplitz_state.hash;
+	hash->report = report;
+}
+
 static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 {
 	switch (gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {

-- 
2.46.0


