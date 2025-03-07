Return-Path: <kvm+bounces-40326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D42A7A5660F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 12:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD8361898A6D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 11:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6C42135D9;
	Fri,  7 Mar 2025 11:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="EP1OVHgv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E3B21324C
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 11:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741345301; cv=none; b=uFyhIHcVTuH3K0iDHr3ZktpySNztvc9X00Vpnyjm7UovBWPvnYi9NXZK9JC/3p9mSV3k8ZORHvUJtyayaa03LL1nbV0YFxLc7YqkcEWhgfKou7POTFlf/fJ9Apx44ttrSRgKoKjDjwRm9qhSKvQaAZRbpJKIh39EzP/8clFLcck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741345301; c=relaxed/simple;
	bh=7RPX9fitmTdsnGY+0vv+MsD1yez6e4jdE+UkL3uDAbA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=sgo4PLentyUVQJrDHEtxm5wRxtrcfqybM94vtb+OCvq9kocgw/XEhCDNFQkRwlXeDbPxZsfabMUSX9fLd0n8GaDpHItMdyYrmD/f5sMn8z7ffykdkAXhtTUp4cyJSWO3t4Zi8UoSNdQnLSxwOPYTig3cIZWd2GpEAclqNnYbFQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=EP1OVHgv; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2240b4de12bso1945555ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 03:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741345299; x=1741950099; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrHDxXHbJtd9yquT+CHx8OjBBgZjmiEiJaPvW+aNLuk=;
        b=EP1OVHgvcRva8ZBc5Oe0X4UvIdlxIzFIrQmia+IfnJaYKQIsySGwp/UHt0FuJkWwDp
         qHWryyywOaHlG+tepXcUd8vR+h2aEGACfPp0OzQuD9nLHrSm1f9/stoMHpghKA+cVob9
         d+dLrtmt/WpeTdmU2Z953FG7pOx4I8Z9+GKbf3HMs3SYA0QDXXL2ooAgwJ+ZuzL5QJCu
         2JdmAeBpjVhqiQjpZiWnoWfy2sGG2X9j3p2xdM4eBiCcP5aAWNNVprSj2mW7FWFB86UU
         i2IhYaYpplwnBPpqYasFilQveGN4eoYxOBJGhIIGoRmiTeK0CCcL9M3QT9HO07jUCcZw
         z2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741345299; x=1741950099;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrHDxXHbJtd9yquT+CHx8OjBBgZjmiEiJaPvW+aNLuk=;
        b=mRwRuzyxpbxJehIJUKUl+/BzscehcVDea2HZdz0fLlJfR6V2+918PG2qR2pALcUBFv
         g/NlcPTeP8M4Tn5WHSW8anFDYFFScaGLbaBrwowp6hgyvhA65ApeEjhQ5GXBWmcoX+G4
         pJMBkozvWwMKkm6/GkUjp6Lbib4tsaH0oOuy2DBQvyRzMDEsqYP+8dp9eXEul7YtxYKP
         NCianWjJOjHx0KAYm8XDPSngBZGip0dVR8ECTFQiAixpjCxObVReq+l6Ds2G6j9xW5wQ
         r/cknKt4WiNWQgpVj0oBxCrp2YKs1OpvIFcYQQ8C3mdZK8gPvBZF8pbeg8YokWrg6WQ8
         xQsw==
X-Forwarded-Encrypted: i=1; AJvYcCV6gSn3H7o/k6cullEQ6hHwQQHT369L2NSAh7lgNk+Utp7mwtZ2NRuruEjf1hGHR9v+kzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlzGTGOrUxO8iclKnXmCwr2Sx1kBVM3o9iI3fhnExMPJFrIq7l
	JLU9z0NN79Ev4ZfyVJLBgp9iJVqQjmxPrg8NTumlnKW2O09Jk5U0HGtAIy2YRn4=
X-Gm-Gg: ASbGncvaso6gB+6lLPTLkYWMv7lN/8Nr1jRTlLEcKbQRIrmLsGMATXdj6ggfaS0bMUC
	q44Gti2+xEinNPJlgfK3ebcMkQej9ZwVARZP7Kv6D7gZuLWUp9qahnG9GIzDYg3e06aFpZ3wwzt
	aCUiTfwHsAiZ56NgEsi+JoGJ/uXrEwhTBALPgmAay/ZySh8YIPWSSyWRcTayOPsD019Pkw3ShKa
	OfxKvLumMpYUOfsPHoiucqS5Tc+nvxNluuZqY9KQlfjRryXooKxloBY1Q4EqQcdmzagMUdz1L9k
	eGIYdgRjEayE7SIqU8FS9W6v2mBpD2GNILKul8XWbBFOPZJx
X-Google-Smtp-Source: AGHT+IFVqhjD3PrnvPtKpJry+k6VrnNfv06Qwa8YPSuE/OjcoZLrM6v9+b/biDuL8BbXSO7KdqTgyw==
X-Received: by 2002:a17:903:22c8:b0:224:1dd5:4878 with SMTP id d9443c01a7336-2242887b34fmr43641305ad.7.1741345298886;
        Fri, 07 Mar 2025 03:01:38 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-224109e97d0sm27410595ad.79.2025.03.07.03.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 03:01:38 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 07 Mar 2025 20:01:17 +0900
Subject: [PATCH net-next v9 1/6] virtio_net: Add functions for hashing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250307-rss-v9-1-df76624025eb@daynix.com>
References: <20250307-rss-v9-0-df76624025eb@daynix.com>
In-Reply-To: <20250307-rss-v9-0-df76624025eb@daynix.com>
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
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

They are useful to implement VIRTIO_NET_F_RSS and
VIRTIO_NET_F_HASH_REPORT.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Lei Yang <leiyang@redhat.com>
---
 include/linux/virtio_net.h | 188 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 02a9f4dc594d02372a6c1850cd600eff9d000d8d..426f33b4b82440d61b2af9fdc4c0b0d4c571b2c5 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -9,6 +9,194 @@
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/virtio_net.h>
 
+struct virtio_net_hash {
+	u32 value;
+	u16 report;
+};
+
+struct virtio_net_toeplitz_state {
+	u32 hash;
+	const u32 *key;
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
+static inline void virtio_net_toeplitz_convert_key(u32 *input, size_t len)
+{
+	while (len >= sizeof(*input)) {
+		*input = be32_to_cpu((__force __be32)*input);
+		input++;
+		len -= sizeof(*input);
+	}
+}
+
+static inline void virtio_net_toeplitz_calc(struct virtio_net_toeplitz_state *state,
+					    const __be32 *input, size_t len)
+{
+	while (len >= sizeof(*input)) {
+		for (u32 map = be32_to_cpu(*input); map; map &= (map - 1)) {
+			u32 i = ffs(map);
+
+			state->hash ^= state->key[0] << (32 - i) |
+				       (u32)((u64)state->key[1] >> i);
+		}
+
+		state->key++;
+		input++;
+		len -= sizeof(*input);
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
+	return len + sizeof(u32);
+}
+
+static inline u32 virtio_net_hash_report(u32 types,
+					 const struct flow_keys_basic *keys)
+{
+	switch (keys->basic.n_proto) {
+	case cpu_to_be16(ETH_P_IP):
+		if (!(keys->control.flags & FLOW_DIS_IS_FRAGMENT)) {
+			if (keys->basic.ip_proto == IPPROTO_TCP &&
+			    (types & VIRTIO_NET_RSS_HASH_TYPE_TCPv4))
+				return VIRTIO_NET_HASH_REPORT_TCPv4;
+
+			if (keys->basic.ip_proto == IPPROTO_UDP &&
+			    (types & VIRTIO_NET_RSS_HASH_TYPE_UDPv4))
+				return VIRTIO_NET_HASH_REPORT_UDPv4;
+		}
+
+		if (types & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
+			return VIRTIO_NET_HASH_REPORT_IPv4;
+
+		return VIRTIO_NET_HASH_REPORT_NONE;
+
+	case cpu_to_be16(ETH_P_IPV6):
+		if (!(keys->control.flags & FLOW_DIS_IS_FRAGMENT)) {
+			if (keys->basic.ip_proto == IPPROTO_TCP &&
+			    (types & VIRTIO_NET_RSS_HASH_TYPE_TCPv6))
+				return VIRTIO_NET_HASH_REPORT_TCPv6;
+
+			if (keys->basic.ip_proto == IPPROTO_UDP &&
+			    (types & VIRTIO_NET_RSS_HASH_TYPE_UDPv6))
+				return VIRTIO_NET_HASH_REPORT_UDPv6;
+		}
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
+				       u32 types, const u32 *key,
+				       struct virtio_net_hash *hash)
+{
+	struct virtio_net_toeplitz_state toeplitz_state = { .key = key };
+	struct flow_keys flow;
+	struct flow_keys_basic flow_basic;
+	u16 report;
+
+	if (!skb_flow_dissect_flow_keys(skb, &flow, 0)) {
+		hash->report = VIRTIO_NET_HASH_REPORT_NONE;
+		return;
+	}
+
+	flow_basic = (struct flow_keys_basic) {
+		.control = flow.control,
+		.basic = flow.basic
+	};
+
+	report = virtio_net_hash_report(types, &flow_basic);
+
+	switch (report) {
+	case VIRTIO_NET_HASH_REPORT_IPv4:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v4addrs,
+					 sizeof(flow.addrs.v4addrs));
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_TCPv4:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v4addrs,
+					 sizeof(flow.addrs.v4addrs));
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports,
+					 sizeof(flow.ports.ports));
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_UDPv4:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v4addrs,
+					 sizeof(flow.addrs.v4addrs));
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports,
+					 sizeof(flow.ports.ports));
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_IPv6:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v6addrs,
+					 sizeof(flow.addrs.v6addrs));
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_TCPv6:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v6addrs,
+					 sizeof(flow.addrs.v6addrs));
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports,
+					 sizeof(flow.ports.ports));
+		break;
+
+	case VIRTIO_NET_HASH_REPORT_UDPv6:
+		virtio_net_toeplitz_calc(&toeplitz_state,
+					 (__be32 *)&flow.addrs.v6addrs,
+					 sizeof(flow.addrs.v6addrs));
+		virtio_net_toeplitz_calc(&toeplitz_state, &flow.ports.ports,
+					 sizeof(flow.ports.ports));
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
2.48.1


