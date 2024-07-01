Return-Path: <kvm+bounces-20804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43AA091E2C8
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 16:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60D9A1C2182F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A17916C84A;
	Mon,  1 Jul 2024 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="khIfk+f+"
X-Original-To: kvm@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02olkn2109.outbound.protection.outlook.com [40.92.49.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A282316B750;
	Mon,  1 Jul 2024 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.49.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845417; cv=fail; b=dXOq0xEg5cEegmSLR+TYnKhQFehNiqyRNqb1iONL/7CQaptkhOgCnAKCp0tX+Z7/3S8FwCXi2TfwpfkBd9iEQ3qGTpcxTCHHIwpVM3MpgXK6rM+s827g/z0lPFgO2HAtxJHIUfpELjAJxCqGmH9Q/ZCHWvgBrQVb+pXQz3hwG5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845417; c=relaxed/simple;
	bh=0PybR2F9bNvwIvO/qTyObZYiEfYjs5DeCBIYUxeCqd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nl0JtTeUAYtOeT/kiVsRGJsCnsVeQXdNo02s9BykjpAJhBimeX5tdt5oPNMxkZaLrsAKKEWXqCD8WIa/BVwKPjrEXjNBZ9S82MFM0TyXo9OMoDuAKU+P6nwwyD0ipcyYh0ZSmi+4TjroqHUYZu0sfl9smhdPt3S6IKnIemao5OA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=khIfk+f+; arc=fail smtp.client-ip=40.92.49.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf3HOF2maZZShc4BV8PlWpNG/G2Msbr20mwzc3iJVByCasw2DWxZKL+0fqbXhDdYwuMLy7zbxB+s9d9rd7JmHR9HTwSoxEq4cXMCqtFV3TPID5Q5snkTy8KvrQVdLLRNyzB4xb/IjSS5k8ZKAXmv/HFyea/HRweojP/ntEw4vp9JbOJa1ts5ZehoydkZ+ZIHdzHbLykcCOxGsOsBmmaXLVC2Xn0GI5lwNYdG5vYB8IVS111HDoSA3CLSlUD1Cmk43wsvYkNG8FPt4ZOs9vqiIJW8bI4928W66ROLR62R31AIZ+9/06ugnjXzywbGXzFjygqFDeMjFGgaemO5lKadfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cInpAUnfgY+dl/3jdMpt0fwwJPOWp5VFOuhZ613ReaA=;
 b=nvvgNwv8y3BKIozMr8IJyRuVniRPQj9IiPISYzwnmchiXgiae+ekEBvFkFmsdS0bRuNZp4I321n57Rkftc3yIq+rhjzPrybjTCtNeKmAIuucH2f/Md7kATDNTX3esYahcpuNprwDycdqfjlFiTAHrbep/Un5tu+RrG5cAcswOqwmdtZq3NO8r0dTvL46TvZiAKkw2x0FxNlIe0LyM9iQRJJhGvbzVusRtTfjaDF3Iww0hS4rwCarAPtzwpFaZm+d2vUaPq0do2tTVEY1MxAoh3Y9HQNy5veT8gr0lrRM/dU9VaTEbzInv5gr6Bu4pWPIsdW0biQuwWXb89gV0TQODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cInpAUnfgY+dl/3jdMpt0fwwJPOWp5VFOuhZ613ReaA=;
 b=khIfk+f+Td49oyK5ltD1Kxhk8rAXh97dwTIBhbrMK0h3VZx02Kp+Z30CjW8cgIOjni9rdjecK884BD90M7Qz4w4p8h98PbDkaXoalSb0mvC6XiEVm6ce3Sq8z5AiscM7LiizRVpxfHr1WxH2FkusEISOO/6bfjtFtafY75csxhYIooUByvBUDbWKI5xpkaGwO3XlY7e7g5SR6jqcBhIefVCuW0ue3lG1ugqvi4o8YrQTzsR8YFXg323H5M3V+xneACAxRBqEhO66Lw42b+5dlgOW9Dq0tmVKBTBxK3yHAFdxLTmkdkP7JSv1xvKabXY7m1fkJmJLx6jPoNTcf8zRrQ==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AM8P194MB1673.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:320::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Mon, 1 Jul
 2024 14:50:12 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7719.028; Mon, 1 Jul 2024
 14:50:12 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: devnull+luigi.leonardi.outlook.com@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luigi.leonardi@outlook.com,
	marco.pinn95@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH PATCH net-next v2 2/2] vsock/virtio: avoid enqueue packets when work queue is empty
Date: Mon,  1 Jul 2024 16:49:41 +0200
Message-ID:
 <AS2P194MB21701DDDFD9714671737D0E39AD32@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240701-pinna-v2-2-ac396d181f59@outlook.com>
References: <20240701-pinna-v2-2-ac396d181f59@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [IifNZn0XtVjad8xnR9zjL0AwBOlrPIrF]
X-ClientProxiedBy: MI1P293CA0012.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:2::10) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240701144940.13356-2-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AM8P194MB1673:EE_
X-MS-Office365-Filtering-Correlation-Id: c55ba186-6ca6-47ef-afdd-08dc99dd1c40
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|8060799006|3412199025|440099028|56899033|1710799026;
X-Microsoft-Antispam-Message-Info:
	ITmXCn5fE80qMaM187/TmGOt3nm1bTMTK9nRiiWnMoBMDH1RrFQlBkazCDYlVBSaIWtguFebTJ5Iany67Ew58+Vp5t3XBHH9ZMQR4R770TgTmt4HkkiKmiR7GjXmnLHH2qlh+rXvcsCKvnjoD+o+Jwk8lNX/I98elGnikuPd6lmvcruqK2EUmArKOLU9B47o3Mv8dlTE3+ZVdgjh54UzdP3BlBwax/+28FvcyLZ9Lq16n5OxjsWu956j4zCIaaoEsYrX9BJWm3hLA2rI0OShHEPY/wv7+U6nDiOR5WJw5xxyExRaJ/TXhlvcbS9u6u2hHK1Zh/loCLC2ZAHrg2VMLVPQF1GLm3C3T1BHRM3VVyuEDLTe/hfwEXgg5QaBjFm+m3h0ZI/NG/nZ7fI4jeTmvq59RYQu+pK9Dqef2dLm3rtkVZ06lh9zZOT3y6FAHfykUzP62nNEk91P3uOju6LDWeCJcq0yYqx2FSktmCmFLz7Mn/v0I0tEPWE9Cs7KyXiez42hOPwWantAePadWio9T0Lx6yFHp2qJ02Op5iliBMR6I3OVXqHPxGRR6djffiGb2mrdTC8MdTYAdoBINCL6IdFTuUPYnMz5An7CXVxY+ePRD2A0+O5HVfF7/d1BD1w7qyuPkjlonM/1UBR4jnGIOw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LO0xSbYbE5mZ8S+rFlNQ6R6JIjfICrH9lxHHKVcx3giV3i+hJxmVw5qeIf+J?=
 =?us-ascii?Q?cKA5GRgqi4Jn7GQ/FiNzg6u5zmQRS+mxSt0saV6OR/hEmAP8s1qhMAuU3Vrh?=
 =?us-ascii?Q?oW4k92M/PYv0Ixpy7DcNdRC6SL69HONjqBec+ztPPZrlNIHqDy7mqbUjpQdZ?=
 =?us-ascii?Q?SKkYX7P7CTsklNJNWbSpuYZkTrBdIjJsSc8iHdqujHNltuMmnGR0UTZDLN2E?=
 =?us-ascii?Q?Tv3NlUWy3DKWdjvTGIZw9PnNw7RoCtXbX6W44AmkX1VMXn66XVBBKqpKZfRg?=
 =?us-ascii?Q?jd2yCaIyH85se9IM8Fel+w64DlHTuUja+3Ek+FyXCalnYeEOr3MNNvc08Fp8?=
 =?us-ascii?Q?UHV+cT3ajCkZ8MD5KiAZ+QO1N9bQFMSSZ3a/P2bUvbDg3zf9BkpvTwGGcD0c?=
 =?us-ascii?Q?BmqwVMD9DDzx6r/nErdSuYnQqteCFJ31Pyz7FfrKQndgOUAt9QtAElScdU6r?=
 =?us-ascii?Q?v6UOxMOue1wt7jTRJUXJrEgibOn4wzOxEG8/NPCmBK/5k3UyqEQwW0YQV6UQ?=
 =?us-ascii?Q?x1lRQSFO2H+Z8oykkBoCZjkuFEewwGAi/SmtFOf4SwTVGrgbB0AVGV+BMVtX?=
 =?us-ascii?Q?JdtIydE6x3TbW1j6IwS7jb7mNg6beyPlAC/mVPa+3FPIaDmArF5WcTXnPgzs?=
 =?us-ascii?Q?OVWcb/A5p472XAKcryiY8Nd/kLetRpI8BLGCl6rGV/QECSnDzRx2qITNb/if?=
 =?us-ascii?Q?AyqD9EwWwdRrgl2hJIOufaYrYqQrJ8qKRDGGROwJE3HJdNcNnohjJ/VZ44as?=
 =?us-ascii?Q?4RfDkbHLkGXaSKLK/KNohM0X17X27TFsLnvI/s8a1Y6W5V9qvcjOt78EqmVZ?=
 =?us-ascii?Q?lGeWvjRaZSW0CmPqADCJ+LMzPjndlOASmKrXHVoHU8S8u+LRCH9y/a6G8zzw?=
 =?us-ascii?Q?qKMST+O7RE6QsHhy2pex/WmLRO/DYl56SiCpBd5jIgWZwGiTJXl1URrrCumY?=
 =?us-ascii?Q?3Cfg8FoZEyTkxvw8jhff4ZoN03Rv5WVuNpdX1FT43Hmo23Jp/PkEXYOoV3Yh?=
 =?us-ascii?Q?OdusZydcQ/tKrsgI2Nm4e6RW4BVkxLRRRFOYXWtS55q6ie3uZdVi+x7cpmw4?=
 =?us-ascii?Q?lETt637l3/qFLO3uLVt0t+6cyGQdQNeg365JiJNHnIlTjSDJs0adRiYfgq2q?=
 =?us-ascii?Q?g5rbPQLnc6qSbT7l4EynHtVENHJh/7O+qCL4aG8LbdJZ0Xl8cwRMFFnkfUS2?=
 =?us-ascii?Q?60WbG2d7TSRhKVHobtpw+lImFcw8l86OtKtNgFzWT8kvzFDZibYD7XfKzOp/?=
 =?us-ascii?Q?5IaJGdvDOTAPLRJQdKnx?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c55ba186-6ca6-47ef-afdd-08dc99dd1c40
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 14:50:12.5061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P194MB1673

Hi all,

> +		/* Inside RCU, can't sleep! */
> +		ret = mutex_trylock(&vsock->tx_lock);
> +		if (unlikely(ret == 0))
> +			goto out_worker;

I just realized that here I don't release the tx_lock and 
that the email subject is "PATCH PATCH".
I will fix this in the next version.
Any feedback is welcome!

Thanks,
Luigi

