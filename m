Return-Path: <kvm+bounces-22937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4A6944B22
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA8D1288761
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 12:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EF21A01C5;
	Thu,  1 Aug 2024 12:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="aF9reSw0"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05olkn2097.outbound.protection.outlook.com [40.92.90.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E75A16D9A8;
	Thu,  1 Aug 2024 12:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.90.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722514705; cv=fail; b=AIHpRTkoh/nRubYd03yWxl341kr+IQUJnKM2jlJ9w9d13JVuK0N0//JFZ3odCrlpP/lBcGpuGS38w3pJ5fP8oChxbkYUF0xyzT2CgxH8N+dvereDMFqj2osWgH6qwxC/SlLwHEWQlbOJT34+L09b+UHaPz3CkdPPFaglhGJ1MUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722514705; c=relaxed/simple;
	bh=yn1T5EXFnpN2UyQBUCV1nN/Jp5AAkivUHNzAtG20zkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EHfXNQ0Nos3x9I/U+DIpImjExf8g78riFJwMQVNSXkSZbeQlo4pOSiTZjuoQDfHUpjX7XxYaFURkfD0gnTnKFnyXDca6VIJqZlKxei3IvjQe9XTIRJAoi7tOI4igrbznfXyFar5gMwTauGLohXjTzKkJQSSXU4raul5lQfMfP+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=aF9reSw0; arc=fail smtp.client-ip=40.92.90.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQy8Nk6G1Yvb2qiInlHhpjTPUXjpB3+JlrI8Prysd8LJAq6dvl8Z6ikTQ4kseuky5FLBMkronBMRXvN6tm5KbD2BQAYUGrNYQDzGXvOYrcK+NKMUewfKL8i1Al8FAtCzbjBERlzyNBSOzTr490BtTU/eYAR3NBVnhDxvuzDy7Ylz7Ms1duEQhfBKvSHpqw1L3ZDcMUjO6QlrKU4GKFapzg5v40dtuQ4spAOO+MMcNVdYV0nhDeS9LtO3U91M6yqwGULPmYjFnGJVziCjFkXGjQ/Du9QRlEc371YLci3t3eiV2O+K6inWVRKdi14/hBm2lPrB7dDqjI+K/vcCThvgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGnO4fXcZ2TaTfZ2jZ6hPVgOHSGEofFcIDJJISTrQNg=;
 b=qczie6djIjn1oBoluwkv7XwZeaT3k7PvD5lybtLLtcZjJTPbA9xE6ewAVxVE39kQ5GAAgs5TUanEq9Oc01cGnQGMyW6E9MJN9mvN1HdgpIM0ohCBs2RdH22pHL0m3MSech+hLogJjQ+hO1Zaa7p2O2jKhPowxk4DKIEvTGea7nMcA4+/9Xx5z/iIsczWjnHEz58gLEE0L0ma2RlPKQIhVG4Gkg5hz5/kmCK1IQqQrvqS03O2URbZlUr0UXr3F6zmBVXYJz08YuwpGwf5o8Irl7VB8ACLxV49EPppxnX8yhnz8zC0bDzZ0g360s6WvCe+l2+zDV3NxvP5TjdKBdztRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGnO4fXcZ2TaTfZ2jZ6hPVgOHSGEofFcIDJJISTrQNg=;
 b=aF9reSw0bdlNG6bZH6h4OPollJEAHR0vk6e1YclzLVw5I8JVhgrmrgFDYa1Uqm0FV/6bPfWuyGYSumiAgWakrNui9iTpVhXXhsHyenbDKQJTYCuDdtrnppvchWboIrhhf7fS077JQa/dqMB9tDCuiSCofW/1lQTg/cqjSWc9pg9a048aiur+ZSI0GY7Fd6HSc1P6N7xCvHea3vouJwjifBlspKeHVM3cWIOUqlL7rp9v38BLX8ztj7VwaungzHCJjqagd2ZAFTUHH37nuLDZNKpmqm9vVCmZHpZdCfW3Mh+LOK5MiqNHphQP5IrS10MtDEKhXxvYiuLvGLNHljXyYg==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB1622.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:371::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Thu, 1 Aug
 2024 12:18:20 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7828.021; Thu, 1 Aug 2024
 12:18:20 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: ameryhung@gmail.com
Cc: amery.hung@bytedance.com,
	bobby.eshleman@bytedance.com,
	bpf@vger.kernel.org,
	bryantan@vmware.com,
	dan.carpenter@linaro.org,
	davem@davemloft.net,
	decui@microsoft.com,
	edumazet@google.com,
	haiyangz@microsoft.com,
	jasowang@redhat.com,
	jiang.wang@bytedance.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	kys@microsoft.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	oxffffaa@gmail.com,
	pabeni@redhat.com,
	pv-drivers@vmware.com,
	sgarzare@redhat.com,
	simon.horman@corigine.com,
	stefanha@redhat.com,
	vdasa@vmware.com,
	virtualization@lists.linux-foundation.org,
	wei.liu@kernel.org,
	xiyou.wangcong@gmail.com,
	xuanzhuo@linux.alibaba.com,
	Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: Re: [RFC PATCH net-next v6 12/14] vsock/loopback: implement datagram support
Date: Thu,  1 Aug 2024 14:18:10 +0200
Message-ID:
 <AS2P194MB2170C5B197652F909252BA809AB22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240710212555.1617795-13-amery.hung@bytedance.com>
References: <20240710212555.1617795-13-amery.hung@bytedance.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [AIzebGsfxEzyNksU4t6mV/+sZHX+k9gt]
X-ClientProxiedBy: MI1P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:2::20) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240801121810.51876-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB1622:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a383474-8592-4338-3f16-08dcb224078e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799006|5072599009|19110799003|461199028|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	iuVfgoNLWmbaopQ6N6AfRJRdewbMW6OZksW7Fbf8+fxs0utHvKemxrWJntQxVTdEv6LqV3FXU7snXPIVCGM/wlhg+makz7Hu9uSl3XAFxLn+me2u6neJftBKrDrSGNcxY0chdKWxg0i6tXV9FUM8qsEO972D4Cj/yBXnOZJMocongAyGs1NhRHYlQ7ZVWMJNvR7kGt1GorQVFgCv41HRGF7CN45yvj/b6eOHn6U8cvJLrUixGB7efmWsKUPgcV13tzP76wYMFp7wSR2i/SBHqT2Xu4tT9oXpNt/BZ6zxU2FP9TT5hs06WxwOrJ7DI+z02r8F1iYigW029oKyoB9/XuwWqxTew1JjHGAEKX2kB3lC//1AxGPuERzFVTgHTjefX9tIyWEEmZm0yPofbVAZ89jc2pTeDf1fSvrTW3g2RhNFinASg8/+CTTciBhanMrwMNmtycEq7FqnAOV3MJP9IC9oNvaL6W4TuhuUl2hndPbrzIjvM+jE68CdK75bkC24gSWsbRwCZvx7ozZHXQswPGJORRfRjBenMrmTRAVccnO3EQ+mQ0kUwYmAPxBr3fXfZh3UlN7VHbqwz+g6qNL8kie1U54mSPKQ0tWKPvDFfc0li5MIU4jFrgSHoIzfgNp06e1oDhokVENEgwf1Qx9sENh+FNhz4AO9++BmCRrwVq5aIJhEmolpsp1QxTQWDUgmccxDeG/q4vElu6Ux1M7EZQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rJYFAblC/gDnMVbKFjlQRTLAf6ZBpUtpFt53lvjX1eItiaai8geDs/Dm+yiP?=
 =?us-ascii?Q?R37Fs8rm8GpOKoGzPRVlSlkiZ+RENFkQnQIqAiwjpsdLaFP91nnDW8dQHlCz?=
 =?us-ascii?Q?jcPQPWGSwQzQla1cjOSiucxzE59NPz+qKbsFmQJsA8ZapDqUlcgUr2/RcrNG?=
 =?us-ascii?Q?Is3bWYh4sHqyFwDzxywfLcoBQzflXI8nyGNnOu6WxJT52YT0Stlz+cDJEETf?=
 =?us-ascii?Q?L5XUCJah36m9j8Jk1v0wRSjifvRq9Phe5LFMS6TazGcztHBSh/0PkyJlf+GM?=
 =?us-ascii?Q?qtkYGHSZdAVOsUWZUKEjq2Gx1U5XycsdvkrYm4p5wh5Navlv2mtlg/pl1k+g?=
 =?us-ascii?Q?6bFefcZ8oxZz06O2NnpdE/3TeJCWBs6pJAXsbPStjUH8cCOJKqh9xwmpb9sJ?=
 =?us-ascii?Q?DUa09ByueE/w6/vWbkn81XfzYzVWPYxZvdm1ObqL8LHWTq/wFmwHLCUUknhQ?=
 =?us-ascii?Q?TzLygcvFCB+SG035LfYb3lz8rPK9upftTF29EsHeWF5VCfadtdMD5vrD36IX?=
 =?us-ascii?Q?/lXr4aFuX+JKv0ez4SvcIT5BUa7MbYq9HKOu4ao8cuR5XiwucoKdqZ0YDDV/?=
 =?us-ascii?Q?sKii7NEPN2ALhttcG1B9Tve2YkrOkCFlkLlZthbLNHtEIFVjeaH6ia8IrACZ?=
 =?us-ascii?Q?MQvUNkPhsQwjcar8qGdCTWsK9AMbXx+dd6+MXBuIkCdx3DH8yGrxASdFMt0C?=
 =?us-ascii?Q?cNVr4WXi9qKwN+/iqeJf3IXLNZ4bOBHZeDRyAwaH0jxvBtXpbAk6yliotgfd?=
 =?us-ascii?Q?HPAQGp3vdlHquabUKovYvp7GaK6BNpqawxLmbZt7Lq2x4rCe5peUkKxq4zpo?=
 =?us-ascii?Q?Nbo1XgdIxflp835zm0vxYLVvKqh3hp6X9PEM7nBbw2FtKlwwZUWphPrJOb2F?=
 =?us-ascii?Q?x9QY0vr9rvq59zNFkND2kwlRd8j+Oi1T7NqbgbAPWb74sM7ubN9dqIIxc6wK?=
 =?us-ascii?Q?tYubwAGh9A2B+06CG8INY6LJmmQAxHcBwTCXCRW9n5iqpMO2n68rxNRNiQzE?=
 =?us-ascii?Q?A3GnVC/IA2SPp/R3VzYOssASMW9REhqQX63FJqlAXrZRDG5XRswjS/aUpLNm?=
 =?us-ascii?Q?3rQmn2U3B/lTvBaoduWh0uRA/bV2t6PMcBBV7Kv+Nt1aoJvw9Fw378KMupQB?=
 =?us-ascii?Q?EuU/4BtIXg6eaVEs1Bopbj36Ts54ue3YAjKbAbuew671a0DFu1UU2K4Cy0Wx?=
 =?us-ascii?Q?SSg9Nxj2jfX9NpzCtuw3FU6JOnA9LZ/ovYUetqfEZKlxJ9lB7ZvuA20W0U9I?=
 =?us-ascii?Q?fp7W6xFaQ/fpywtEDFO0?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a383474-8592-4338-3f16-08dcb224078e
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 12:18:20.0028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB1622

> +static bool vsock_loopback_dgram_allow(u32 cid, u32 port)
> +{
> +	return true;
> +}
> +
>  static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
>  static bool vsock_loopback_msgzerocopy_allow(void)
>  {
> @@ -66,7 +71,7 @@ static struct virtio_transport loopback_transport = {
>  		.cancel_pkt               = vsock_loopback_cancel_pkt,
>
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> -		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_allow              = vsock_loopback_dgram_allow,
>
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
> --
> 2.20.1

Code LGTM! Just because you have to send a new version I'd modify
the commit message to something like:
"Add 'vsock_loopback_dgram_allow' callback for datagram support."

Feel free to change it :)

Thank you,
Luigi

