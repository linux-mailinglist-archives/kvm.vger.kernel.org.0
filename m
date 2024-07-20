Return-Path: <kvm+bounces-22016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9296E9382CE
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 22:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4502E1F213A1
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 20:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C02149013;
	Sat, 20 Jul 2024 20:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="XOBw0mCr"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F56F1B86E6;
	Sat, 20 Jul 2024 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721506277; cv=none; b=AOrXTBy2KNPOkYE1QbLSBHFCjho8oS4acq+YbHtTgLBVdpjbIh1xpMVI8vst+GEAxrcp4QW0/biYyanZdK4lrD9cnig5vyidmHis+gLybuoM/532w99hfUbmJPz+hi5cKvdnhNfoZuyFLLZetPe0GJWjIEJUSHG07I/u492JXaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721506277; c=relaxed/simple;
	bh=MMccahpFs/BX2/ZmF+Ahe+wf3beg9doy+mIncCTABp4=;
	h=Message-ID:Date:MIME-Version:In-Reply-To:To:CC:From:Subject:
	 Content-Type; b=u0i2O8nWcv7T59FRhKkAwN0/xeiW7h9P7LQoOL+HyMfZ95jeLtLcy9xCvrXBgehj4H6zmoQdFmeKjNUyQt7RH48nclhAl4hPYeA4U4y60vOO//Xwj6qOjhLHoC+s38YWJiYfWNx083+lAsIfj7JWWSSSYwFe+ofZaTBtIpuCgZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=XOBw0mCr; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 6F39C120003;
	Sat, 20 Jul 2024 23:11:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 6F39C120003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1721506263;
	bh=US63tdy4CVQs+687WGqzILjkxPtutPxeQcKuCPb5QWE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:From;
	b=XOBw0mCrV7p9Zi+pEfyVJhDbFSCAllSki3+OQFo1UD8PDCgyWMKGxd82B8vppA3By
	 3n04+nn1OmyrqRAxCEI/6iHHe/2yce0wlqwh+WC8O42G2/5tf9KVh0/3wtQy2RN3oI
	 UqLkWj/JtfahxoHKnBMXgqxOhjhxxRLLupCSrR0JLTqfJWc07CtWM1elgsrynBS9tq
	 gfxgjCNrA2HmbRQ218tRvyitPcQW5smW963cWZkKIpjA4DrP7+FuUgLJlvt2JQvsdg
	 Fn70wFoJcG+kvUnqbTPdgq+rJjNl9rpYBlpD5ID80vSYAHzDAn3bJlnM3llh1aApV7
	 Yl8MidrEAKk1A==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sat, 20 Jul 2024 23:11:03 +0300 (MSK)
Received: from [172.28.192.160] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sat, 20 Jul 2024 23:11:01 +0300
Message-ID: <8e3071f2-682c-7f0d-ff10-2865d7c2d8d4@salutedevices.com>
Date: Sat, 20 Jul 2024 22:58:40 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20240710212555.1617795-15-amery.hung@bytedance.com>
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
	<ameryhung@gmail.com>, <xiyou.wangcong@gmail.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
Subject: Re: [RFC PATCH net-next v6 14/14] test/vsock: add vsock dgram tests
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186631 [Jul 20 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 24 0.3.24 186c4d603b899ccfd4883d230c53f273b80e467f, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/20 18:23:00 #26109921
X-KSMG-AntiVirus-Status: Clean, skipped

+static void test_dgram_sendto_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,

^^^
port is not hardcoded, it is 'opts->peer_port'

+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int fd;

Thanks, Arseniy

