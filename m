Return-Path: <kvm+bounces-21640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB7493128B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 12:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A3D28455F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58CA1891AF;
	Mon, 15 Jul 2024 10:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="U05jbKfb"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2013.outbound.protection.outlook.com [40.92.89.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB34171E53;
	Mon, 15 Jul 2024 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721040334; cv=fail; b=BUgj4YNFnLG6qnws6ghAFWxer4JLLLnfEZlNX8turUjyo52R9girg/YQXUURb4peTrRBKyOQzknbsx+qA2Zc0P+HF8Ogvc/q5v+IVNRMYhMjDVdTyhmsFKg16W4dte1kmOXxCztGS2OKfjpAFJXCcduAr13nIYGNsLsjv+C8hjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721040334; c=relaxed/simple;
	bh=tbqSF1cYUhkzFmFjeNZdZFOvvXuKqkqNqT0I6ZzoyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J0+3zbax3FAgje/wGkePJQg0xMBk595JzNFWBW0i2ywBnuJacHPxnWvlJyDA2vG8mBPPBBYEF12X0cgTT/D5bBDIodq9z/ukXUrhb54U2nQxoNHNIV11HBq4QOFJCq5tjRSyGaO7uWTIk0dPiIjsAhy45ly4GtWShv76qwzrhYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=U05jbKfb; arc=fail smtp.client-ip=40.92.89.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZmDKHOsfqe0saZlw1oifvi2wyOw65zoc8zn4sDKmxWiyxJyzVOkVuk4Lf6ZYrdjJ4fZazvHu5/uzz9BLYCGFuK087bfbzVGqioeSFqiN8eQm5heFSyH1m1Wf7i4Pnx8+N1aDitOb8x4y5ugAZe/QJKBHinM+W0eZJSNLCrDifOZNNfa6jZX5gVb2TufIkNpNq6NYruhlooAa01uMmzTbatReiCEPTRCxY7cZs3YHorQI1bJhn7Vrcit0Bc1+s0M3yz/+3ri40WizVgZvpdH+2JBGH2qB/6ZvhUESbiEss92sTOZLrAHZU8+CgKhK3ufSgRK87Icq+ag7cdDUL513g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbqSF1cYUhkzFmFjeNZdZFOvvXuKqkqNqT0I6ZzoyjM=;
 b=KLrUoz08ek05liRoRTGUL4jUY/pigZvKBuPgaX7BLlDSWsgDt1ixpjLy55xqvJ0vuJAQGNTfxtJEqU4ftSUtbbH254WAaN6MXxyqJBrADcdUq508FB3lVk5M7O6tQ4wS0yhN9smNaCqfGKqfqapxe8AN79z8YteSCLrgUAFm7+yVbAsyHSc3EHHjNDAhaW6G6rLhuN68L80Uy4N65lOsyNR3A3nGUz8dJKueTuI19SqQEEf69h3GYh13P6916/D84OhkajNQSIA/9XhAPzr4H8PjxwyVu/3NXFP71R2yTl+e/waHtV+Tx5TZUiCOjN1VFV+Y6B7O2nFPLXqljL6RZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbqSF1cYUhkzFmFjeNZdZFOvvXuKqkqNqT0I6ZzoyjM=;
 b=U05jbKfbvJYrsdOCXQ+yPBqavpV+QjEyQxlgXqOyVhx5vhWNlKZR6OKTltqjnLbOw/qofIJ+GUSWSbTVkQWphMztxGlh7PiIatoqePrYOd4n9BkXLj6QWkp+qP+4Q795JdAdovFSrYeVO45zS3QlkgDdD6XwMhbHd7mqEPjWutmY82cGHbho5FhV5wFT0U4WirSdxstnz5FFPxgRFBn91P4g6WVmx243KECYR1iGIFs9KwokIDf3sPeEntBS9bYAIgIwQ42U7mJqMQ/izwoeeKWR0qP6x94FYMzIgyBlmLcNB86O40T/EdkgmUv+FKYjT3KoK4r0YBz6SnyvaaRN4A==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by PA4P194MB1135.EURP194.PROD.OUTLOOK.COM (2603:10a6:102:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 10:45:29 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 10:45:29 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com
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
Subject: Re: [PATCH net-next v3 2/2] vsock/virtio: avoid queuing packets when work queue is empty
Date: Mon, 15 Jul 2024 12:44:49 +0200
Message-ID:
 <VI1P194MB2166D217DAB34D4A774FA2129AA12@VI1P194MB2166.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <4ou6pj632vwst652fcnfiz4hklncc6g4djel5byabdb3hpyap2@ebxpk7ovewv3>
References: <4ou6pj632vwst652fcnfiz4hklncc6g4djel5byabdb3hpyap2@ebxpk7ovewv3>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [7I9CNCLVGfv0eEWN2jEbHUk1JDj3EcXX]
X-ClientProxiedBy: MI2P293CA0003.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::16) To VI1P194MB2166.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:1c4::11)
X-Microsoft-Original-Message-ID:
 <20240715104449.14687-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|PA4P194MB1135:EE_
X-MS-Office365-Filtering-Correlation-Id: 2448f90f-57ee-4c70-fd63-08dca4bb3d7b
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|8060799006|19110799003|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	6UllsjvSSIsN8/WDapz9qMl7r2kBYS6uDRnfllxVO+j6CdFTg19N8ZHULkXYDH3LjG/EhjR97us21ClLCYg4+z7+QQrjO7zqDAArmFvbJoVkRo/4VrLvlBVoe+ETtZh6l9FVh37K0RcA/uMXIByIK4gwD3ZwngIAYpEkDRyZF10JBcqMPnWDj2ByPnBIpz186cezLy/f6ch00Cap6duLENOUTG+GwPLShYjP/W2DkiuQg5ghEJJaHEwwhHz19Pd+vvpxEVFP6QgbgUfxpC1F5oaH1wqkz1ijR8zRL3qQ+cER86B4uE1JRrGF3f7zRMKCb5zhBwc8E0py+O4MB2PoNo9UzWS354vPoE+Di7IfHsrIZE1AYRUjV3tBIhRWkE66nwhPsrJVGaH+uBTh7CSjmWxBMJ3l78ffr0qcmabsxbWbqFwa3BHUu3Y9HMp132BNAtTQ02WNh3CNmzSRH8/cVacrf6WvNHdcJ941i7PWt4FaOtN0VznGe9DtCtgTdaYJ7rN6n1JCaPUW+RmZmKhDX8cbbPVMv7VDrssBOEXsqRfajC/x585kWLRPVRKww6kbp3AKGw0aHgQmd6M1TS/6NJQlJOBA8Qv5PwUqO78g6BPe/frLWbuXEJgF+3o8o3fDOIpjjTSJVGH6lVTmOrxSVd9egGrUq5e3QU1zf62amVXYViPX9906EUxM30BSjMgL
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?euqBBuYain5aIP2usZS7QBbozl8wCBeqW5xZNpof9D2AoJYAv5QJFyIc/EEE?=
 =?us-ascii?Q?ucal/FHSKJ8Ux6VYSWW9vgFw0nse2GyjvSDlHMlvhfrEZQBvCn83ueaLLrh7?=
 =?us-ascii?Q?qOyet42XaeJU6SKqeI0eLSPMZRhxSUdk3gzqglc/wpXm2GgJfm1AHVlwUo+p?=
 =?us-ascii?Q?Kyhxqr2wxQ5ex3GPlvOqKpe6J2DCOz3Gc0UHxy+K/cC87Vs1McwVddQ1yQol?=
 =?us-ascii?Q?AMFN8Oxhxu6+Be3pDpUp/vKG8SfweHaKVT6gnbOmZwz8xsKZR9J/TVbAjzHh?=
 =?us-ascii?Q?JoHN6aJIITTkhiPWAu17XFa9dWqyRcSebJhMiZWuGMobfT6ex1osfRQtZ6Va?=
 =?us-ascii?Q?Hlwa8sT+d04zgVYL+hybrOlizYprhoScGXWon0TX6dRdz1iWWgK5UicDoW6P?=
 =?us-ascii?Q?YiHoU3izvhPn8qkHAJbHMTDS/7gCrmIEXkPiQkfgJG9RAH1Q2vA8JIB1Vj6Z?=
 =?us-ascii?Q?C+heTJ9NRF/l5qEFLtGr8ydHp4xAM99xWk0wbUz7AN+7bcjmyzhT689Le3cj?=
 =?us-ascii?Q?D1w+njzzBjLuAshHA2XHI9c+behv3aUzLo0UdY+YK0yI/y7pIBb3w/1worwP?=
 =?us-ascii?Q?76GNgBsnOrqAvj5qcSKk/Z8U3cMA9lBiQSDB+7KaISDEcVy2cuxxbcrYYwz6?=
 =?us-ascii?Q?WsmQksTOWK5wTEL3TFQRjELtT/GamhitLtyw9cXMZiDF+Wwq1ucwl4X8TlRH?=
 =?us-ascii?Q?xKDy/5rOj/6WmGkXTHpvTBGawKG57hM1gga58ujZMwfnGzbwAIuBTwzumHSQ?=
 =?us-ascii?Q?RvXyckneRvy0hot9lHY+jGuDicLAtqbugPstdNJt730irGQfdcC6GUukXXAk?=
 =?us-ascii?Q?UrLyP++SgmFWiI+q+buTMRSVDKB4utXG5ko51zt4IeNl9d4hdJnhE+6qmIfY?=
 =?us-ascii?Q?dJ+EZy76hqCmUu6aDhd9bcR+Vd1wK/fGBNUo1BBWW0gnC5ENA6cnWLImwUV0?=
 =?us-ascii?Q?G4Mq4sBiIE5hK/xSD5gnRhzEnezb1HOVA4NHwDR6PguixMJCnoobKptxQeeC?=
 =?us-ascii?Q?erHM8OunmNky3gbAjGZvlV+Ixd+sJLN0AdeenmCAaOrGNt4NIUsVk7Ujxnon?=
 =?us-ascii?Q?Tl105euVHNsw+uLhfl4Q4nQJ0zSX10CfoCEScDg5XuVtkzRPf6Awwn6ei5kS?=
 =?us-ascii?Q?qpreqIo/xyVb9/cwNjUSPwDRKjO3mADUQOj2CO2oJy0iSOcNch5sIEG24LKf?=
 =?us-ascii?Q?iH/po9iejyKVMFAkKdiy1Tu2JUHijscAVGWX1t8FYLj9QzKNWUZUu6xpueX8?=
 =?us-ascii?Q?W5xaNTnGOTQX6GflTXi0?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2448f90f-57ee-4c70-fd63-08dca4bb3d7b
X-MS-Exchange-CrossTenant-AuthSource: VI1P194MB2166.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 10:45:29.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P194MB1135

Hi Stefano,

Thanks for your review!

> On Thu, Jul 11, 2024 at 04:58:47PM GMT, Luigi Leonardi via B4 Relay wrote:
> >From: Luigi Leonardi <luigi.leonardi@outlook.com>
> >
> >Introduce an optimization in virtio_transport_send_pkt:
> >when the work queue (send_pkt_queue) is empty the packet is
>
> Note: send_pkt_queue is just a queue of sk_buff, is not really a work
> queue.
>
> >put directly in the virtqueue increasing the throughput.
>
> Why?
My guess is that is due to the hotpath being faster, there is (potentially) one less
step!
>
> I tested the patch and everything seems to be fine, all my comments are
> minor and style, the code should be fine!
Great, I'll send a v4 addressing all your comments :)

Thanks,
Luigi

