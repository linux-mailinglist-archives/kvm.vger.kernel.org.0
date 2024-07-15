Return-Path: <kvm+bounces-21634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8169930FAD
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63B5E2818A1
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F0618560B;
	Mon, 15 Jul 2024 08:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="jcGInDKs"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F4D18307B;
	Mon, 15 Jul 2024 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721031941; cv=none; b=MxY5xP49Eo7u0kRIFrkuXbj5DfglRjTn7Ebyr5rr932ZJeft7M/jfqm63C46ki3WP7GljRG6sgUzqwR28axpydqmns7++lKahqzH4W4UXC62mAkInPDcIkEaZ7bGXiO2hLgAERXOaUXcg/cUsKbByNBmW1oVfOvWFQ3hNK87Mj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721031941; c=relaxed/simple;
	bh=d5L/tvc4EwqqaJTnXBKa+d71qhwMx1654XYIW7XZa5w=;
	h=Message-ID:Date:MIME-Version:From:Subject:In-Reply-To:To:CC:
	 Content-Type; b=mzAt+9eRKRs/S6MRdhkm8XcQ0uBdCmiiwnJNGlna6CHU3u9AeA5pD7q8zHvk1oH+mX9scK3FHhXy56160a7dDZYYph2SIREYAW2/X19MGwgwbVC1RwQxvC0RbYkzSwbR7M5tnEBuaWGe7ABcY2Jfi4DgL8Ig4D0OAvQ4/Zl8+Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=jcGInDKs; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id E66D1100007;
	Mon, 15 Jul 2024 11:25:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru E66D1100007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1721031927;
	bh=Jyo5eLjXqfi+avI6rSqSTMuKkeDymb7TDQV2NyDA8NA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type:From;
	b=jcGInDKsgmWCzGSc27hWgKZAuMRVfNBV93GLkTqByyDSQRTDaP5DK/QCNB5nfIHW3
	 8lb+Em2ZrNMfCx77yg4uKfaOZSn0tp5os+4peIeyDSvTUGw6YiW1ZWr5QMR+5sSYg0
	 L0w2+iNoMrrXpPPhAGfE7mRaElHQZl1YDE+0DQ0g0jTth00kw1fUBDSis+svEz/lT+
	 z/WGS9SqbLoT1AhQL4Y3qz+qUIuDkY4MolZ0MzqfliBIMA3C4XB71vrEeXXVM/Hwig
	 yI3/oEfLhKqvoympkcGhZbBp237SIgOA55V4E0ZtfsmcJ18HktUnkAmD0eoO8psI0q
	 LS+vZDUEo6+Gw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 15 Jul 2024 11:25:27 +0300 (MSK)
Received: from [172.28.64.192] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jul 2024 11:25:26 +0300
Message-ID: <85d64656-d8ff-1133-175f-b12f4913fccf@salutedevices.com>
Date: Mon, 15 Jul 2024 11:13:15 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: Re: [RFC PATCH net-next v6 03/14] af_vsock: support multi-transport
 datagrams
In-Reply-To: <20240710212555.1617795-4-amery.hung@bytedance.com>
To: <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <wei.liu@kernel.org>,
	<decui@microsoft.com>, <bryantan@vmware.com>, <vdasa@vmware.com>,
	<pv-drivers@vmware.com>
CC: <dan.carpenter@linaro.org>, <simon.horman@corigine.com>,
	<oxffffaa@gmail.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<bpf@vger.kernel.org>, <bobby.eshleman@bytedance.com>,
	<jiang.wang@bytedance.com>, <amery.hung@bytedance.com>,
	<ameryhung@gmail.com>, <xiyou.wangcong@gmail.com>, kernel
	<kernel@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186516 [Jul 15 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/15 05:41:00 #25996221
X-KSMG-AntiVirus-Status: Clean, skipped

Hi! Sorry, i was not in cc, so I'll reply in this way :)

+static const struct vsock_transport *
+vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
+{
+	const struct vsock_transport *transport;
+
+	transport = vsock_connectible_lookup_transport(cid, flags);
+	if (transport)
+		return transport;
+
+	return transport_dgram_fallback;
+}
+
^^^

I guess this must be under EXPORT_SYMBOL, because it is called from
virtio_transport_common.c, so module build fails.

Thanks

