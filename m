Return-Path: <kvm+bounces-51397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4A2AF6DFB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA2984E6548
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74AA2D3A8D;
	Thu,  3 Jul 2025 08:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kCq12SBc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kCq12SBc"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011070.outbound.protection.outlook.com [52.101.70.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2C32D12F4;
	Thu,  3 Jul 2025 08:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751533128; cv=fail; b=A3NcGgk8mQhz159qTxSkSmaP+nKRpbF3sB1S1HTi7Rvwo0Xo0Wq0H1BgN4Tuq4nIZU4KwvM/1VabmCxSf31cM/c+KB4qaT39m7Qj3GH+s6E81VdsaBMH6biDqvkoOlpsZNYmUm7X8IBZZyjLLz/xNVb6LdOKCKeMwhzk4VlO85g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751533128; c=relaxed/simple;
	bh=I+GN/odvSGUG9B58/YErImTUrrePrmbI9ALeHcA19s0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FWgLv/o0N7gBtkWHnA5Hs3YMYvWvmfogj8avz4yXzy1Vaovj5b3LKbkw0Z6EfHw4Iejfmr2IuZX3K6HpNGQIZ6X7ZG6wGZxco8B78KToyGxMk3sVmjoExlwTF3hIevHnu81FMohMa0bwJbiVYGBwQw7tH30npNF6L4zYrVbTqj0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kCq12SBc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kCq12SBc; arc=fail smtp.client-ip=52.101.70.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=x2p+Iq6nxQ1MrySu9fth3mEOuGPzRxg43oMZnHVBTdRyPZ9LefhPIBkg0DfOkq3Hnc/N0xETdOtYAI0kcLTy6RAogjyplVF7X6ofgnnKdnHqFBsiM3QBajBWpzbPUmxdNHqCkffBaXLb4Yj9GHlF0Ll3xI59ZJVfBllPINkIq+VBwzH7KDvaNLjgjCOrp3TNzCQ5LkSNVq8LhdHaqc37c1sWLkFL3Uba0HH/fA7hT7gJgjtt4BC1+V0MWxL5qF1ARacgM2DYeL9lnP7E/IeWUGv0cew/pvoBaf3fDHfoK8BclaM9il90jtSeardqqMZrHomWAtSEi4uI2rlOuI6b5A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+GN/odvSGUG9B58/YErImTUrrePrmbI9ALeHcA19s0=;
 b=S2kXmx0akNvkJa39Kjih39cu24MKqxWJu+UAKT1nUrkD8FR4AQ39kxlsjbFoafmRYq//frdh5/FKLRPo6bpG1KV3drP1Ug8kYMeFWyvvGcc8cFAuPx2BGNELOy1O2PqzTBJbkrcsWIjXUQJ3uZVytTjLcSYWONJjSDzvhsDvelOUX0we6Jk8zzY4MCIC4gWNrZn9D7orN7Mpy933bfjpda+t8BctVeSSp6JJdBFMcPxqbX7VrsD0w4L/VbpfBb0ev1Y2XFABKSmWDKRFWfLlxZF4WejbaceTBbgXF+s8wLdwwDiyITRcQWhJM8G1igsERa8bMpNiGGEWm+rbAneASg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+GN/odvSGUG9B58/YErImTUrrePrmbI9ALeHcA19s0=;
 b=kCq12SBc/biZW6qQ4PsxjafdKBega3sVQLbNhkqkrJAziPxw6Tgos1LHELcGNSc7hVymOlJ0+3NAA8MAyDeLuO5XOoLCQKdSWg5nsZC7yZ5YdRBLz8b8nrNhQwI63pZqHtTPK84uxVj7ugvgId7btwuFZ/Q0kyAydjhuesNYHUY=
Received: from CWLP265CA0467.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d4::17)
 by DU0PR08MB9078.eurprd08.prod.outlook.com (2603:10a6:10:47a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 08:58:41 +0000
Received: from AMS1EPF0000004D.eurprd04.prod.outlook.com
 (2603:10a6:400:1d4:cafe::69) by CWLP265CA0467.outlook.office365.com
 (2603:10a6:400:1d4::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.21 via Frontend Transport; Thu,
 3 Jul 2025 08:58:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004D.mail.protection.outlook.com (10.167.16.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.15
 via Frontend Transport; Thu, 3 Jul 2025 08:58:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWdnfvveAnpriGpxOPVuwwS/Pqg4O+njIfBvrbohTDbpfvBnQ5nmWdAifHOLo7qAk+WQtoJllPT7ODwVdSoSODVX+7+uhQRjK0idgWmh7eZo+B1CgbZwoP5/Q+HPlhTbthI+tqKTW2UDL1zMHXEZFk/U96oKcfxiGmqPEx8XEhT0pal6bcPynluZKUo2RZQitSrmxjthtQK0BRm53GkskI4mhhlqtb9Dcmtdg+1LqJ/mFT9WpNsZYO8RDGTrG5/CQAgDUbhfNa7zHuSQOcrNgvIp090eamgIOeUuLme5PblnFjg5NBvjAaEul5Xvwa7wiaFlzj9/qBig9bHSiWpA5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+GN/odvSGUG9B58/YErImTUrrePrmbI9ALeHcA19s0=;
 b=egoEBSjiHu3B7sqxCILw3exJX3QZxKnhBavucaqeV5qPFXenWebaILtQ2Hiu5NG3X1ZrCoE7jS0ajQ6obuhfSfvxtxXrnwLgMIordH9pzGRbUVF6P3vrusqU5QtkWavQKomwo0q/08A5JV9Ki2c/cVXLFbLWNLRjjcJUCQ4+ImrhZZcX0UpkdqBHTvR5OX7e5WrigKwjHrveUpcBSBqsJv8owxdp9Nj70SCe9bLopjaWrzYrrIvC3CdErRs5zT4eXT8MCRc2tL/WS61IMPIejUekg+nThvTedeJ1P36zlsSFAn2Y9ALYPJYBBBIeqVHS8Gdh9rOvGc78cybIxf6/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+GN/odvSGUG9B58/YErImTUrrePrmbI9ALeHcA19s0=;
 b=kCq12SBc/biZW6qQ4PsxjafdKBega3sVQLbNhkqkrJAziPxw6Tgos1LHELcGNSc7hVymOlJ0+3NAA8MAyDeLuO5XOoLCQKdSWg5nsZC7yZ5YdRBLz8b8nrNhQwI63pZqHtTPK84uxVj7ugvgId7btwuFZ/Q0kyAydjhuesNYHUY=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DU0PR08MB7485.eurprd08.prod.outlook.com (2603:10a6:10:355::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 3 Jul
 2025 08:58:05 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 08:58:03 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, Timothy Hayes <Timothy.Hayes@arm.com>, nd <nd@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, "will@kernel.org"
	<will@kernel.org>
Subject: Re: [PATCH v2 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Thread-Topic: [PATCH v2 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Thread-Index: AQHb50uBVT08xxo3SUOh7vh/YrsqMLQe7IIAgAE2EAA=
Date: Thu, 3 Jul 2025 08:58:02 +0000
Message-ID: <7e105ceb41faa0d48430af99f6a04eb8add828cb.camel@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
	 <20250627100847.1022515-2-sascha.bischoff@arm.com>
	 <20250702152816.000010da@huawei.com>
In-Reply-To: <20250702152816.000010da@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DU0PR08MB7485:EE_|AMS1EPF0000004D:EE_|DU0PR08MB9078:EE_
X-MS-Office365-Filtering-Correlation-Id: fe75694b-5fee-41f4-0eec-08ddba0fce8a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cFpGelprWGF3Z3QvK2ZWeDErTWlXQkp2VFFJTDlDbEkydGRYa1VvK0N2YVJN?=
 =?utf-8?B?dyt4QWRwdTlqSVpoSHpqZEwvTVpZa3VUM0NHV1VjTVpTMjMxL1BsRytZekNG?=
 =?utf-8?B?eEhJeFdzeE9nTXNZSkpxL0FGMzlqMnZ6ajIyR094WVpES3kzOUVrMEMycHBF?=
 =?utf-8?B?eGg2OGtGd1VPN0xmRkVCK1VNZngyZGVTTHA1TzVINWd6dzUwUVZ3VEZKb012?=
 =?utf-8?B?UUk5SmJ5ejM2T1kzb0NaUnY4Mk9xMlM2SmR2aHBiV2hza3FWemhwVFRtdHJ2?=
 =?utf-8?B?RHRHRVFWYmFLemdTRlR0MFRzakVqOTI1aVAycWRqWldJTXRVd2U5bmJDQjds?=
 =?utf-8?B?NmNrWWdLL2F3b3E2cGFSL2UzengwcjlMYVlDZXdUNGlQZ3BhZS9Kb3pDbHVI?=
 =?utf-8?B?dTBkU2drT2EwQ1NnZWIxRjRyZnAxSUp4cGZBdHRja1BKeGY4NndHOWl3ZG4r?=
 =?utf-8?B?aUtycy9WNkkvTFltQ2xQZkJBY1VpaC8vSWw0dXNEOC9YalEzUmhqc0hDdkdp?=
 =?utf-8?B?S0Y1ZFVkdjRkdzdQUjYzaHhZZkFKN21kUFp4ZVdLT2I4ejBwcnk0czVhMXBB?=
 =?utf-8?B?S05FZFlUN2hZMytXQXVMNk1ibDhvTHRWdGNnSWhMeTBmbXFwcjFHdDB6S0dp?=
 =?utf-8?B?TG1GeW5kazdkdloyRkJEbCt2TktSbXlGNGw0VHU1ZTZ3V3lNU091Mkk4NzRX?=
 =?utf-8?B?c0dxZmxmNFBNZ2JKZjBMc3hZZmp2WVlzQ0lma3N4SUdqMTdSbEZHb3pYUEVS?=
 =?utf-8?B?cThEUnhrM3AxekFJY3pvYVRjcEdraG1Ock45eEJlSTl5cEtWYWhSMXlCQkxs?=
 =?utf-8?B?QjJ3TUg4RXNrZjF5UzNnNjF6bGR6NVNsdGZibmJDNW1GY2toS2JRLzlCNW9t?=
 =?utf-8?B?UXFaazBCZHY0M2pEVXNMZ1dJTGpNemdjR3pjeEZJaGVySHdXL2NVQUt6MlNO?=
 =?utf-8?B?S28zRTBaZHduMzFXQTJOODlmVU16UisrYmpMWEdJQ3lVVnI1SW5WZm8ydFBy?=
 =?utf-8?B?TEozdkdyWGJRQkFVbGdyMGlQdkVHOW1xR3o5bnhFazhvR3Irb0NHZGR5V3BQ?=
 =?utf-8?B?SEthOFlmVDV0MjF2ZlBhcDhYSWhsMG9DdnVBMkRwb2c2eTBxNW10UkdkbnV3?=
 =?utf-8?B?WkVLSkU5bEFsZXBjN1VDWjJERG1Bb0V4WlVZd3pwZGVtQ2JXWEdaQnZFWWQr?=
 =?utf-8?B?R0VFVTNTOUQ4TWs5cm56ZzdtSE5SK3VpbHpiNHJhemsvSGlMVHpKUlFrdy85?=
 =?utf-8?B?ZVBuS3JzakMrUDJGOGNNR0pUcGgwWWNHTER6dTJ4YmFjOTZ6QlkxbDNFU1Bu?=
 =?utf-8?B?YWI3MnkyRjN5VktkTWw2a2V1eE9YOXJOSEJhY2FhYm9sVEZXSkRMSXRJM3BS?=
 =?utf-8?B?a05adFhHN0puWERZT0g5NTlEV1FVVjBraXNRSGEvWEZUdFNSbGdxUW9JWjB1?=
 =?utf-8?B?bFh2amc5ekpncmxFajN2R1o1RUpZNFhDVkxJVEllM0hoVEtBNWdkWlY3NzZS?=
 =?utf-8?B?WVVqOUZudGsyMXRDYS9WQjFEbWZmcWlLR0V4QjRWNHBrdnBnVDZUYXNWR1pO?=
 =?utf-8?B?K3U3dWg0cFlMWTIwcWlHUCtMb2kyWWtVWTFBd0xhcEVhMHhDeW5SdFFvaFJD?=
 =?utf-8?B?c0hRTkVYQTR0d1JoVTR1QUJNN1NnWS9zd0hyRElmSmlQelJxYksyMlZBWDdt?=
 =?utf-8?B?L3FMZnduSmRxYUJiMExicGxaU1pjRFZwbmJSR0NFWmpDcStkM1ZWb0JOMjdw?=
 =?utf-8?B?VmV1U1BTTituY0c4cWtkc3h6dmtWMVhoemVXSTdVaWFxS3VjWTJ0TlZvVFM4?=
 =?utf-8?B?dTdSYkZ6K1NadklqdkRYOEN5dW9rWForNUFJWGI4UlRtUGFzZCtVRElrQXdX?=
 =?utf-8?B?eWNacnlGbGVYNTdpbkFWcVdEN2IvUTZDKzI5RGxlYW8rZHRhektEWlVLWE5m?=
 =?utf-8?B?TG9pVE1SOXllSCtsUzNjVnVEV09PQ3FSR2ZWS1lJYXpYWXJYMWgxZ3ZYTElL?=
 =?utf-8?B?NHlQY2tISmtBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC981828F1E6F0478931A9CCA3E095AF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7485
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9605b8b5-6114-4023-2bae-08ddba0fb7f1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|7416014|376014|35042699022|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkhyTlQycFd1LzNoQlhSWUdHSzVFODcwcGhwb1lhRG5pMVlJZzBqa25OMTVU?=
 =?utf-8?B?anlPeUFCbzlONVVCRENhMVczOW1CcFRHcDFzVi9ldUFxVkRzMEYxbVZpUkFy?=
 =?utf-8?B?TlFZeE5MczZnU0t6SVZ0Wm4rR2R3TUp2UmhPcEtJSmZjNHd0SWs1WkJLNUxB?=
 =?utf-8?B?S0pYOGkvZDcvZ2g3UDV6L1E4MWtLeVdhdWVTQmg5MG81cFdtSktZdzRtUmYv?=
 =?utf-8?B?bkhwVHdvRGdONFppTCtSNy9OaElVbklKK1h3ZjlsU1hTbm0wL3dQa0hGUzVN?=
 =?utf-8?B?STVzZEsrUitpTWdZNmNxRDRCVnhvVEpXbjk2MEF3WmhsV2Y3ZUo3V0NkTDFN?=
 =?utf-8?B?T0xHSEMreFdrMWtZN3cxbmZucTExdENIWjFacFBDQXpheTZvUW4zNDA5eS9I?=
 =?utf-8?B?V1JoYllFLy83V2xuMmxmRHAvVkxSTHVoMW5GaWNyUGlLQzk0M2Z3Sk9udVdD?=
 =?utf-8?B?SGFOSFlSVXhkUVVwc0JkTVVoRmxZYUFNU1pQM3FidTR6OUJ6VHc5NTBQbzBa?=
 =?utf-8?B?M2l1L3Z6a2w3R0h3UXNzQzFPdEpwUmtkM0l5UDhGdURYK0lsV1dyeWNLU0Uw?=
 =?utf-8?B?RjRjaEgxZTlBMjVldFRKRFAyTEpKL0hpKzd0a0s5VFZaSXh0K2tTQVNYQ0Vk?=
 =?utf-8?B?dmhJRGt4WUhqQytORmxDS3NNdnBTM2U0UmliR2NIbnRXOUZJUlZwdmErbWtG?=
 =?utf-8?B?VVhXMHBMMzY1TzhDNnVsWkdaMWN6OEpvbnE0Q2FvaVorT3dJeXFwYU9GVW5w?=
 =?utf-8?B?bmJ1TTR5RTZ5RnkvVzBQSjlFN0NHcWo0Yy9UZU9yYWV3a2hnalJYRDdGNmJT?=
 =?utf-8?B?TnRVc0hhWkFkQ2Q3eWlPOUZ3R0NDb1U0QUJKbDJ0U2xTOTdHUXNydDZwTjVV?=
 =?utf-8?B?TmlOYVJaNTN2QkJWckNTQ1ZxN1Jmb0lDT1lhbExFOVVrbWJVYTU1S0VEQmtp?=
 =?utf-8?B?dysvNVViZXF6VWcxQ3NYZTBFV2J3UEpjZDVlak5WTHR3bUYvNlZ1cmhpU3Rh?=
 =?utf-8?B?VVNMQjJpVTZTaW1JbmlaZU9QVkJoWkNYTUY4RkFQV3NJQ0FFZ3JYRjBsUWpn?=
 =?utf-8?B?Y2NlOEVEeUd0MU9uNk1Kd1RxZjJoRXVGVmdETEFKQnZBVDdkNzlkaU1paE45?=
 =?utf-8?B?QVZvcnJiNW5RQm91ZDRCM1JVdnB6ZVQ3YmlPb2tqU29NTjVFbzZFR0crOGM2?=
 =?utf-8?B?TnM5RnlIYmNqNm50YXV2KzJuTHZ6MW9lM2kxeXFEWGpHSFJobjhmbXp3U0RD?=
 =?utf-8?B?SkdrV3I4OVc3d29CWnRrYjhVelMvS2dDdTJQNG8rQ241OFRSUit0bHNFQitY?=
 =?utf-8?B?VmdvbE02NExvWXVkSnVBWDA0QzQ5bU5DZU9URkNvcVRLakxkczEyMUxocDZl?=
 =?utf-8?B?TTdDcUlYUnNsd2hGcEJJZzFmTUhHelJnbkRFdUZ5R05qN05CUXl1aEhKd3Js?=
 =?utf-8?B?UTVKV1RLYmJJdGxleGVzWmh0OUlRc1RtZ2JuS0VKeUw0UGFPMjl4R2lxTnRO?=
 =?utf-8?B?MjVLN0JXZmRDdVhMbmcrNDBURVlmczZPd1M5WjVzRVlOdWtmMktqcStEYWJX?=
 =?utf-8?B?ZVplRzVFRHdBL1VpTlZubVFSV3JHdzZPdGYrYXJ2elhWWFhOMXY3MHhHOE9a?=
 =?utf-8?B?a1ZKNVl6VlpBanZPY3lDWC9DOTRUQkZUbUN5YmFlWmNsUG0wL1dmS3BIdWNy?=
 =?utf-8?B?UVRBYzVnenlSQWdMaWdUcTlQMm5ZdlRqQlFqK1VQUHlQdVFnL1c3dG03eTJi?=
 =?utf-8?B?ZmFZcUFkK0pZblVXenpDQ241Y01ubmZ2MDJQZGVpcFJZL2tBVjVWQitaaFl0?=
 =?utf-8?B?UzRtYjBOSWt3c1Exa05xejN6MGlvMWhDZnY2aHZrT3dacG5CQ3FUZDZOVmMr?=
 =?utf-8?B?K1dDYkMxMHhPYVdaT2FzU3V3MmZXb3gvdEYxOXcvSHV1TFFjM2ZrWlI3RStX?=
 =?utf-8?B?U3djNU91ZGRlZnFJY3c1TXhpRTdOUVhsYXI2VEhNV1pLZFB6dlBHZ0YrNnRR?=
 =?utf-8?B?RjJkM25zSm5WQmZYMXRiRUs3b3p4UWJxRSthZ3BnZTRUZEliVlJBTHRVejFO?=
 =?utf-8?Q?EImhAb?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(7416014)(376014)(35042699022)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 08:58:40.7944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe75694b-5fee-41f4-0eec-08ddba0fce8a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9078

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDE1OjI4ICswMTAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDI3IEp1biAyMDI1IDEwOjA5OjAxICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBJZiBhIFBQSSBpbnRl
cnJ1cHQgaXMgZm9yd2FyZGVkIHRvIGEgZ3Vlc3QsIHNraXAgdGhlIGRlYWN0aXZhdGUgYW5kDQo+
ID4gb25seSBFT0kuIFJlbHkgb24gdGhlIGd1ZXN0IGRlYWN0aXZhdGluZyBib3RoIHRoZSB2aXJ0
dWFsIGFuZA0KPiA+IHBoeXNpY2FsDQo+ID4gaW50ZXJydXB0cyAoZHVlIHRvIElDSF9MUnhfRUwy
LkhXIGJlaW5nIHNldCkgbGF0ZXIgb24gYXMgcGFydCBvZg0KPiA+IGhhbmRsaW5nIHRoZSBpbmpl
Y3RlZCBpbnRlcnJ1cHQuIFRoaXMgbWltaWNzIHRoZSBiZWhhdmlvdXIgc2VlbiBvbg0KPiA+IG5h
dGl2ZSBHSUN2My4NCj4gPiANCj4gPiBUaGlzIGlzIHBhcnQgb2YgYWRkaW5nIHN1cHBvcnQgZm9y
IHRoZSBHSUN2MyBjb21wYXRpYmlsaXR5IG1vZGUgb24NCj4gPiBhDQo+ID4gR0lDdjUgaG9zdC4N
Cj4gPiANCj4gPiBSZXZpZXdlZC1ieTogTG9yZW56byBQaWVyYWxpc2kgPGxwaWVyYWxpc2lAa2Vy
bmVsLm9yZz4NCj4gPiANCj4gDQo+IFRyaXZpYWwgYnV0IG5vIGdhcHMgaW4gdGFnIGJsb2Nrcy7C
oCBTbyBubyBibGFuayBsaW5lIGhlcmUuDQo+IFNvbWUgc2NyaXB0aW5nIHdpbGwgbW9hbiBhYm91
dCB0aGlzIGFuZCBJIHRoaW5rIHRoYXQgd2lsbCBoaXQgeW91IGlmDQo+IHRoaXMgZ29lcyBpbnRv
IGxpbnV4IG5leHQuDQoNCkFoLCB0aGFua3MgZm9yIHBvaW50aW5nIHRoYXQgb3V0ISBJJ3ZlIGZp
eGVkIHRoYXQgKGFuZCB0YWcgb3JkZXJpbmcgLQ0KdGhhbmtzLCBMb3JlbnpvKS4NCg0KVGhhbmtz
LA0KU2FzY2hhDQoNCj4gDQo+ID4gQ28tYXV0aG9yZWQtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90
aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW1vdGh5IEhheWVzIDx0aW1v
dGh5LmhheWVzQGFybS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxz
YXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMvaXJxY2hpcC9p
cnEtZ2ljLXY1LmMgfCAxNyArKysrKysrKysrKysrKysrKw0KPiA+IMKgMSBmaWxlIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlw
L2lycS1naWMtdjUuYyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtDQo+ID4gZ2ljLXY1LmMNCj4gPiBp
bmRleCA3YTExNTIxZWVlY2EuLjZiNDJjNGFmNWM3OSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12NS5jDQo+ID4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMt
djUuYw0KPiA+IEBAIC0yMTMsNiArMjEzLDEyIEBAIHN0YXRpYyB2b2lkIGdpY3Y1X2h3aXJxX2Vv
aSh1MzIgaHdpcnFfaWQsIHU4DQo+ID4gaHdpcnFfdHlwZSkNCj4gPiDCoA0KPiA+IMKgc3RhdGlj
IHZvaWQgZ2ljdjVfcHBpX2lycV9lb2koc3RydWN0IGlycV9kYXRhICpkKQ0KPiA+IMKgew0KPiA+
ICsJLyogU2tpcCBkZWFjdGl2YXRlIGZvciBmb3J3YXJkZWQgUFBJIGludGVycnVwdHMgKi8NCj4g
PiArCWlmIChpcnFkX2lzX2ZvcndhcmRlZF90b192Y3B1KGQpKSB7DQo+ID4gKwkJZ2ljX2luc24o
MCwgQ0RFT0kpOw0KPiA+ICsJCXJldHVybjsNCj4gPiArCX0NCj4gPiArDQo+ID4gwqAJZ2ljdjVf
aHdpcnFfZW9pKGQtPmh3aXJxLCBHSUNWNV9IV0lSUV9UWVBFX1BQSSk7DQo+ID4gwqB9DQo+ID4g
wqANCj4gPiBAQCAtNDk0LDYgKzUwMCwxNiBAQCBzdGF0aWMgYm9vbA0KPiA+IGdpY3Y1X3BwaV9p
cnFfaXNfbGV2ZWwoaXJxX2h3X251bWJlcl90IGh3aXJxKQ0KPiA+IMKgCXJldHVybiAhIShyZWFk
X3BwaV9zeXNyZWdfcyhod2lycSwgUFBJX0hNKSAmIGJpdCk7DQo+ID4gwqB9DQo+ID4gwqANCj4g
PiArc3RhdGljIGludCBnaWN2NV9wcGlfaXJxX3NldF92Y3B1X2FmZmluaXR5KHN0cnVjdCBpcnFf
ZGF0YSAqZCwNCj4gPiB2b2lkICp2Y3B1KQ0KPiA+ICt7DQo+ID4gKwlpZiAodmNwdSkNCj4gPiAr
CQlpcnFkX3NldF9mb3J3YXJkZWRfdG9fdmNwdShkKTsNCj4gPiArCWVsc2UNCj4gPiArCQlpcnFk
X2Nscl9mb3J3YXJkZWRfdG9fdmNwdShkKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiDCoHN0YXRpYyBjb25zdCBzdHJ1Y3QgaXJxX2NoaXAgZ2ljdjVfcHBpX2ly
cV9jaGlwID0gew0KPiA+IMKgCS5uYW1lCQkJPSAiR0lDdjUtUFBJIiwNCj4gPiDCoAkuaXJxX21h
c2sJCT0gZ2ljdjVfcHBpX2lycV9tYXNrLA0KPiA+IEBAIC01MDEsNiArNTE3LDcgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBpcnFfY2hpcCBnaWN2NV9wcGlfaXJxX2NoaXANCj4gPiA9IHsNCj4gPiDC
oAkuaXJxX2VvaQkJPSBnaWN2NV9wcGlfaXJxX2VvaSwNCj4gPiDCoAkuaXJxX2dldF9pcnFjaGlw
X3N0YXRlCT0gZ2ljdjVfcHBpX2lycV9nZXRfaXJxY2hpcF9zdGF0ZSwNCj4gPiDCoAkuaXJxX3Nl
dF9pcnFjaGlwX3N0YXRlCT0gZ2ljdjVfcHBpX2lycV9zZXRfaXJxY2hpcF9zdGF0ZSwNCj4gPiAr
CS5pcnFfc2V0X3ZjcHVfYWZmaW5pdHkJPSBnaWN2NV9wcGlfaXJxX3NldF92Y3B1X2FmZmluaXR5
LA0KPiA+IMKgCS5mbGFncwkJCT0gSVJRQ0hJUF9TS0lQX1NFVF9XQUtFCcKgDQo+ID4gfA0KPiA+
IMKgCQkJCcKgIElSUUNISVBfTUFTS19PTl9TVVNQRU5ELA0KPiA+IMKgfTsNCj4gDQoNCg==

