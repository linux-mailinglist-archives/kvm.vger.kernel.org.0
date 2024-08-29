Return-Path: <kvm+bounces-25340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D325696427C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3577D283908
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 11:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79233190684;
	Thu, 29 Aug 2024 11:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="e1SPA6Zm"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05olkn2022.outbound.protection.outlook.com [40.92.90.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03B5189F3E;
	Thu, 29 Aug 2024 11:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.90.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724929269; cv=fail; b=V2AwBpoM34NljWs3ZW6LLZIlQJbmLn4iMasPSKK/uZT+UUShrsiQ+6gC0DfeWdJFrFcnkEiTXl2jzF9jUmKzenx/rK+0OEtp7y2Ocs68RMeBaR6A8TnMxHbUPE6RgToDHJ238FBdkTk+kiFBmVmV2QNf1aKCfZGQ7ezBh7Ag4H0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724929269; c=relaxed/simple;
	bh=8uPp23xD+y4ayX2+x75nIBCekbV5cto4cyMLZn8ntF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fzwdtZDrzMFzBPLSAJNRp8HPZo1m7soHTbmBaaIdQyax8aoPamUzbzGyZWFQLMLZTEEFXO+EkQztc2mioWZQ8rdWRqHFgfHEgNwxGZdvo3Ny6AUnmaAvi50Bfmml12hlZq4U9H5W4TkjJrDhFBn2UQGzLaL6FvI/vFNIb7dPPv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=e1SPA6Zm; arc=fail smtp.client-ip=40.92.90.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ygq/wVETJjWzhvX4RkZrx6P4Gj/tHLOd4gcebqSENPI/9Xb7Dc992URc8qLGmkUO1Mfpaw0jczT8pl+tziPsifdf2s4xrF+U0ycvIdnjmxm3UwIaDgRLxohlndsvpwCFoRNInclgRzBs/y/6KKp/EkY9x8mHI2KwwkGqSBc6VCTxUX5U/H5rMThxQ1gKrUZt82IlDl0SHbMRYaP5UQIXUAqtDEt6S20hAACY9OhgS4L3slel8ixqAZ5bgWBviAh2izYBF0NqhWpclQsiUVXt1VelQbf8fZKY4nRf/KIaS353iBi2a+tzRFdj6dxyym1gBBDpg50lH7xgwrGZWiAVkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uPp23xD+y4ayX2+x75nIBCekbV5cto4cyMLZn8ntF4=;
 b=fcTyFRDLDskSIuSnHZ496OZZftNLP07thCUnBWGjNrRt+LxJcCaqO20wXDd0dh5NBK1w0YExLnU1TPvg+oqfnTJ+vzJZOkOkAL/GVIjITYiWEa+ToUjsLDhfFXXQ4xQ0zu4iO0Kf8M2snP7/wEj923Tn9+EcAAb1U5ARKyL9z4KIMxwMHLJgXez2KjjeGCFD0ir4mK6HuvL4S5Eb+QicVA1pucLKk9BdACIhZ1WXy2UqfvMPpkYrWl/wzLZaDcfeHtvf+WaXWl51UdMvx5Oh17dgbAvyr+RyLY5gAoBlT5Kd6mp1KVVhNQx+DE4h+wvTB4zZIS7x29SOuclqB44JpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uPp23xD+y4ayX2+x75nIBCekbV5cto4cyMLZn8ntF4=;
 b=e1SPA6Zm3iwFIJ0t/L73wIT08+o4phNVFOIwZXpHcUHpYFtzw+n29ef1e4OqBdNxp5TarxFGi7uAQOAzIhNChPyq/abXo6M9EEGBXjcdg0XCRAPgcU3x/1rknBL4uK4PNoGvb+zVPWG2tmD1jsTzhScEgJ884X5QKGTmVOAk31dUwqcO34tXZYZ5ip3Vq7nMH0G1whwkQJKKzR+j0DgIiyO5wIeQ9/72dzw8FsjPdt82LToGCIjTIf4p7+ookirxW8KRmebC4YcNiqks7dEduoSOtwJ6iX6VIRnqCmt5UDrP4ZHXtKpSNKRdI1FZCKyE+WuzaFRTVaxiAC1errIU/g==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AM9P194MB1394.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Thu, 29 Aug
 2024 11:01:05 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%3]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 11:01:05 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	mst@redhat.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luigi.leonardi@outlook.com,
	marco.pinn95@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v4 0/2] vsock: avoid queuing on intermediate queue if possible
Date: Thu, 29 Aug 2024 13:00:37 +0200
Message-ID:
 <DU2P194MB21741755B3D4CC5FE4A55F4E9A962@DU2P194MB2174.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <tblrar34qivcwsvai7z5fepxhi4irknbyne5xqqoqowwf3nwt5@kyd2nmqghews>
References: <tblrar34qivcwsvai7z5fepxhi4irknbyne5xqqoqowwf3nwt5@kyd2nmqghews>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [/YiQgoA9GBkBc6e8GivfADJ82SQ14uS0]
X-ClientProxiedBy: MI2P293CA0012.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::10) To DU2P194MB2174.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:10:492::9)
X-Microsoft-Original-Message-ID:
 <20240829110037.10934-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AM9P194MB1394:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b1bb33e-3d7e-4100-691e-08dcc819dfeb
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|8060799006|19110799003|461199028|15080799006|440099028|3412199025|4302099013|1602099012|1710799026;
X-Microsoft-Antispam-Message-Info:
	ZrMGjl/lw8Hx5WUDtxzP675NwtZP9CIkVLNnxWqsijKTma7nyHZ9LATMSQoqdE/s1XUooS4oAxu9s+bjdBf3rbjrmj/1MvGjTYIRVf8jm+NxmTUTf0QsLZIYI/OmWvogi07hZUBGmeGoVgvppNDf6nRvgI43WQcOEzNj7P9QrPZIqABoWkDrVX0Cafrh2l2Lii4iSQjpWT1pdQlp56KhTGS9oKS7c/y/r6tN4VBQHoH+5HdBywmP+c7fYTRsmknjVDISJTRGgxnWEQOHY0ig7n/B09LCLNoC2WsuCBK9pd2plJSxtNs1X+tLcjxoCuZU0N0y1mMjz/9OS3xdO2j+c0qYaa/v6iNOW7CkF/+PVY2TIZTZ1egHtEQLc/Ngv6iRbVygRnhgOQVIyNoY8t/VsFNdlIhLH/tMVHNipyF6EMpDec76X3i3LFM/7jaPETm5p+CSmpWl9GV0VH9xjESkaUeRUCTth9xqL+OPFN9LAmpKyeazNJVryCtEas2akx4jEHtUPKF+D0PFBemi0hjPaDwxOA22uzb0H0EXkorn9alXaPJxi/3Q9dYuLXm+XXC4zmcBTgVkhDYAQ3q4iMxu8phYYp9ZBR1eYvx+UnXPfvcGqVI7h4dt39HbkoDEBBJyAn9q5w0pp/2hOnPjl0v2tphy9vsKLvdDl1ICCByaAQ8FtUFbcx26fFbdCIWOanNCGm5oJs0SBX0QCGaPPuNKRnt/CKsClHc5Qc5svSryb48PgbVXPAPGi/H/pSHutfGh3mkwI9apXUpSvQcinNYvA0Dg0BrKitA2hCh9iq4mCcrtpRkFKYDXBUVzP69DaHZxN9qi050O85mm22a8aYE7sK/qjVOiniM0BYDY2Vfg756B6F+VtzP64BRXuBNJwCG3wMJVKca58ohyhhGOXhBrtA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gL2WMwzDnz5q466eslKtSFsynsZ1clOw52WReURJMOrJ7KGIzqj99WoJmUx8?=
 =?us-ascii?Q?CYVPlJSSHIWE1XvzFI/GCZUuD5BpsoEDMUYxVE27synmZKzrOz/t5c4rDBGz?=
 =?us-ascii?Q?HS32YxqmEyFnOvuQPLaqFuPzAS/4NDo5gaIVIFliiTkbrhoMxGITI5FW1lCv?=
 =?us-ascii?Q?aiAaq3g8+dFA2EGqAPQvo6PHR9yxIg3KFqCzGMPjemki8ZtTMJ/x+wN9ByBg?=
 =?us-ascii?Q?04QR9zJNgdGxIBaauCLBzZhPJAY+yOyBd/TiCA9gb5Gt9EG05R63pj35aeQY?=
 =?us-ascii?Q?gm5mV/YXWlvgZs7Bun8ckvJXOc9hZsidMjVnVxufof2aW74KLesLtOLsOdiM?=
 =?us-ascii?Q?Yt+m2PErbrxM0vSmAfoMu3q7mZMvt/spn3FeWCXR0xJ9hq+GxzUABeeKeGOh?=
 =?us-ascii?Q?oD19QajZNcKfBJz0v8XmHf3Q23Hz4FNqcQuvCvcjav7yd2iK3D0xRcNuIOWI?=
 =?us-ascii?Q?qBuX1F5BREewtsVoevAY5fMiUpSE/IhwMxaEVa73l4PHPQQMPQPszbgFwtzG?=
 =?us-ascii?Q?yNYXZmGB6YoS8RX5kYjLWmZmerZ5TjmZrT1GMwU4dJc7PfoBbjEk3a7pliz2?=
 =?us-ascii?Q?rvOe5o8A7Z184KzEnGuixj7y0AGc/xEL+4SXQ1o0EImSd2oZ+be5AZ4Db4AA?=
 =?us-ascii?Q?eRvXLLfoe0ATsBF44LrnCg8yiCi7EQnp3nlI5nJtXIVfg1irHY8kzIEB0SqI?=
 =?us-ascii?Q?LdjXCscSNFBcNY545po9KdiTVRW7lkQEto/UAgPlIew+wk6U6EuZGkoVDuQk?=
 =?us-ascii?Q?jgszkMlh9wJFrbxQUk0rEERT+L55VBgDVrJWqrFPwqtaOinaMS6Tq7ZeBCQh?=
 =?us-ascii?Q?V7otCmGF3S8Rt/HVF3o7Qg+AF+y0z/g6kFP9CNQtKodRHm4QQ+8ukxH5vIAa?=
 =?us-ascii?Q?7XbtC/jjqGofV7NTTGbOWNahYBF1DZIqO/aTgESq/581Z5sChns1ihQEpA3w?=
 =?us-ascii?Q?wY+4eWuaV5B/YHnCmul7XICPr7RXD6wX3zhC0PxfILEQ2LOktEv8RQt8ohoz?=
 =?us-ascii?Q?RhlFz5C8RaXfC4/IWEQm5XC3jGmj5YtKIoPOlRjMoM5vl+ummiAiZdb6X+Va?=
 =?us-ascii?Q?mfrZ+UUJ6VsW+9gwOdi3TJIz5BuJRo5jL/PpZp2LCGHzwtREEtqRr3St5sWB?=
 =?us-ascii?Q?N+5BMg7etOJ7/wzWnlioyYSR7I3SDMgWOFtZ1S/m+qWtNyp0fXLuNeo2qUNk?=
 =?us-ascii?Q?BtH8HNbxyW2nNEZLdoLm5jgBdmFtqHiTqjetX0ypO3pHOi2S6FhzF2UdtinP?=
 =?us-ascii?Q?44RakcIbSk0lCQyaxiNS?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1bb33e-3d7e-4100-691e-08dcc819dfeb
X-MS-Exchange-CrossTenant-AuthSource: DU2P194MB2174.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 11:01:05.1268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P194MB1394

Hi All,

It has been a while since the last email and this patch has not been merged yet.
This is just a gentle ping :)

Thanks,
Luigi

>Hi Michael,
>this series is marked as "Not Applicable" for the net-next tree:
>https://patchwork.kernel.org/project/netdevbpf/patch/20240730-pinna-v4-2-5c9179164db5@outlook.com/

>Actually this is more about the virtio-vsock driver, so can you queue
>this on your tree?

>Thanks,
>Stefano

