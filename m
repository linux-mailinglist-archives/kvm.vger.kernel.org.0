Return-Path: <kvm+bounces-65960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4ADCBD6AD
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 11:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51C0E3010FDD
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 10:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E31A329397;
	Mon, 15 Dec 2025 10:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J+hbE/ol";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J+hbE/ol"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013014.outbound.protection.outlook.com [40.107.162.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B8727FD56
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 10:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765796136; cv=fail; b=s9wtNpcuoDmg+vV8JxcDLhHiiUT4UBtjUq6UjXQ+s6OkzIZPpXWC5CoIgYvExvtXhOaiKikke87yiXDBIDut3bHe1lylTf/1kP0Ntu/9bZ93uDmoJeQndwJ1QGjLozsVPO8Y+QvBhOW/qbEoK8SJeNj/dp1dOjoE9LZgQaVhUiU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765796136; c=relaxed/simple;
	bh=59VMslqeMHHHUHmLphIKRDuZ/k53wTGDzVMx+2ruiRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YEduIffCQLRzHCl73ocEKBjawMX/PIyS1Q3vGJ17mq7Y0oSWEbyjZUH2TP8ocvz6meFtgvkJT3LdlroWssHtQflinEVTr32jXqsPLlnTx2TV8FXAXOFKx6sc5wlwr32ZtodCjooy88ZO4UzLHkyhBmBuuiNIA6jmkfzJ0YbE3HY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J+hbE/ol; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J+hbE/ol; arc=fail smtp.client-ip=40.107.162.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uzqh24qEdx246lh1ZzmHMwUsgpgAS93o070lojpC0YlOvAg4X0R5kObNcZJvwvH7UTh+xjP9o8r1LfSpy6NZr9cE0ZoaxfqfEtFbb3r6Gdf6NMlg8rlgGH1ii3c9L5GJb9n5Dqr2eJikeHJ0hZQ68xgIFUuhavtmV7bCAaR8rZ0DH/bcXLm421DhcxfLY/K2KPkNgYyxVLDZMj4IsQpylmoKnioBJlxy8n5ZINcNyEX25cKGkP7e0HKEcAJBfGd3ZmOvrX+mqAe25Iz2l9P2Yr7YZ7CB9PyXtQv2oSXWRmHi4IZqkovX0/IRxzyUhL2KXM8jrgXHVoZLb05U/7+o9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59VMslqeMHHHUHmLphIKRDuZ/k53wTGDzVMx+2ruiRg=;
 b=uv/7mOLBX2J8TggAqGqssDUKCuUc0LM1FzRwq6h1M9CiBVfVt4VDGbmaqBO3xpdigs9EhGWP8SD8xVKAR/Bb4hv661rvbDsK1CHreXrWXx0PHcmWkavNaDIHQD5US1y13zIrzazuVCIxS5ZPbd60B6WziCZwkUkZfqfM5yR1qVpYHK4NIsLx+rd4/6mxMmr9RFb5pdUUt7MWbiGl7SeZyoRG3NIL9ciZpVnTIcuUPRAqKTK4M5F4037cb+ipvhW3EGZd/iVu7MSD+h4+ofd8ggI7kysFbnORBae+sD5sPkcgH9CV1X/IuZsUibc8AR5qwkQ10L0g7tgsUaQS0r6TOA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59VMslqeMHHHUHmLphIKRDuZ/k53wTGDzVMx+2ruiRg=;
 b=J+hbE/olcAhr5PZLoKm6EpfxFUwidxYR/T5KHV6hlCkc6dSfPjwaO36Z1zNhb0SU6jrMMhmyAvao88ytEfKcDx6nEx6QwAly5ZepCK/8yGfc0LBCPqdfScr1jllqhJLAUP2lWS/dSLiySl292BxLyFoUW/3XtS7ZY3IaTdMe9hw=
Received: from DUZPR01CA0293.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::7) by AS4PR08MB7950.eurprd08.prod.outlook.com
 (2603:10a6:20b:576::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 10:55:25 +0000
Received: from DB1PEPF0003922E.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::c4) by DUZPR01CA0293.outlook.office365.com
 (2603:10a6:10:4b7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 10:55:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922E.mail.protection.outlook.com (10.167.8.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Mon, 15 Dec 2025 10:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FOm9wTGZa2V09bFqLwlQuPxl+EiF5P2xPLiSQTDBXZOzXuyKjCTki3J8nYpaQU8Ic9IPHwQlG5cyu6hu5gxKe7HLFoaWD0mXyN7jVHWli9jVhOiWE9kkFMNj5j8kcBhsW0DoSPUf1dNYQ7khxah02L2O5nd5oq0sVfFELlpNb+0PuJLSN8ci7v5Gvz3aIe4+1WXHBOxX6mu8FLe2D2x2YykYS7UXsf6svYPdZYzN3Y9BM5bFDUb+JdXP0ViYBh4NscoboiBfdvj82K5qUZEVAtP6M/SvusIM8Q/nqW0dsMJKN/kGocEC7j9YcPqVfxyX+UA4jCWWo5bcb4uwtMMKtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59VMslqeMHHHUHmLphIKRDuZ/k53wTGDzVMx+2ruiRg=;
 b=xQx4TRHt44fIHEPhQJb7lpXLyAgTJCuxp35TUCoPopC0dJK+0tR4CbS8JuQCibdrQIMNJFRmkV7U8cBM312mdGaBgtWG2fRKqi6utytfi13NalL8JRS45BJz4JvE101RzpHvH1S0xyMzXMUvr4eakDLFP5F+UJl7/eCqNFRmyrNLXUuE3NNwk8ACD81Oi+sI8wcpS6r3hjeoTjzr1p7UhapXN2fVcRWH6eO6m3G1Q8m4tKtcMiaI+Ig8ajbLDjX+wSKdkLBr4qP4YT+nkfKwd06zOK6Od2zLsk4pTYn3R6NwFCav0k18i3BIt8sLuIFuIUPUYZ3Zfd0H0ZyxQHudig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59VMslqeMHHHUHmLphIKRDuZ/k53wTGDzVMx+2ruiRg=;
 b=J+hbE/olcAhr5PZLoKm6EpfxFUwidxYR/T5KHV6hlCkc6dSfPjwaO36Z1zNhb0SU6jrMMhmyAvao88ytEfKcDx6nEx6QwAly5ZepCK/8yGfc0LBCPqdfScr1jllqhJLAUP2lWS/dSLiySl292BxLyFoUW/3XtS7ZY3IaTdMe9hw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GV1PR08MB11090.eurprd08.prod.outlook.com (2603:10a6:150:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 10:54:20 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 10:54:19 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"lkp@intel.com" <lkp@intel.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>, Timothy
 Hayes <Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "maz@kernel.org"
	<maz@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: Re: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Index: AQHca3snr2OLKgEPBUyx+ouJOXBKPrUfFFyAgAN2/wA=
Date: Mon, 15 Dec 2025 10:54:19 +0000
Message-ID: <fd72d2f3cee71081d6abca6bdefd20c2962708b0.camel@arm.com>
References: <20251212152215.675767-15-sascha.bischoff@arm.com>
	 <202512131338.pYhd9ptc-lkp@intel.com>
In-Reply-To: <202512131338.pYhd9ptc-lkp@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GV1PR08MB11090:EE_|DB1PEPF0003922E:EE_|AS4PR08MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: e921b786-d2a4-4a9a-b44e-08de3bc872ef
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UlVHbHNnZ0luR2lRVW9kNlEwVkNWVktYSGFYWlQrYU5zaG9MbzVMR1RSMUFz?=
 =?utf-8?B?R0lvcnIxa3M4bEthTjdWZWxmamU4amNqVXBlVkYzME5KYlUrMktSUGZBVGJs?=
 =?utf-8?B?M3pqRngyRnV4LzRFenZtempVZWd5WFNxRjZJMDNiejlSRXBVeWU0K2pOMWdK?=
 =?utf-8?B?OFQ1QURGelNmU0taeFIyMDNpV3lnT290clV2SERDb2tySjFJMThFd2NYQTNl?=
 =?utf-8?B?TGo2cUd1TXpqUnVWMVc4cW1VaVV3Q1VZWDNlREd6MDNpaEE3eXRGZGRmMENK?=
 =?utf-8?B?UHpoTVR0azlTZDFZWnlDa01mUEMzNG04ZGp2b1V2cmdCb0tBR1V3TlBMQW94?=
 =?utf-8?B?anBSZW9zaEdHckwyTW9Gb24xSFJxVkJqNUNFcFBGaDVpbVI2TEozZi9nTnll?=
 =?utf-8?B?QTdaVEdXK0kzVmpsZk5hUmZHQXhMVWM3Zi9OcHM1czIzSHI1TFB0TlVpbUhr?=
 =?utf-8?B?STVUQUNaNjBDRmpYcEhMN00rMC84NzJSdkNjRnVSQnpXdWZYUFlWc1lmTXgz?=
 =?utf-8?B?YUlycmFkN0ZEMXgzTG1TemJ4K09scUV6b0dSb21ZL3Z5eWVZeVVLMnppa1ZX?=
 =?utf-8?B?eXZTYmhNakRBL3dLNThxNDZTMmE0S3prTXh4WmYyRys5UzJtenFIU25MdUlv?=
 =?utf-8?B?YlNxaVcrQ2hKSVpEemdFdlI0SFNGVGQxUzVCUGwzYUtzaEVwRGpKdlBkQWRx?=
 =?utf-8?B?M0NkU2NXSkdhNnJZaERmVDBwM3M4ZHd1aDZOZFJDTW5kSmFWLzBQejlHN3lj?=
 =?utf-8?B?ZlpiWUtrSnRHR25tUXloNU9VbHJtODhvSnpxVmg3RVNXQzV5c0FjTHlXUDl1?=
 =?utf-8?B?Zzk5bFRaa3dYbnJmM0pOZ1RlSnhkb0FSa0MzRVEwbXlrUHdQRWZZZCt3YXhz?=
 =?utf-8?B?dDVuUVgvLzcxcmNLd3FYSkFCUGlEVVlTOC9VcGhDTSt2bWpVT3dRd2o1TE5k?=
 =?utf-8?B?R3NrRmlsM2FjbVpsd2daZFBnOFk4dE03eldkNmgxanpHSDRlNUhmYVZneHJ1?=
 =?utf-8?B?Y25DclcwUEsrdHBkU3E2c0N3c2R2ajgyeTRWWG5LZEtxUUVkZHQ4K2VQS01I?=
 =?utf-8?B?dkI3WnpjS2dLcWNYc3NISTMrRnBvckxPNUNvZmIxdjdseG40ZFZ2WWc1OHd5?=
 =?utf-8?B?WS91UzhMZkd6R2xlNW1FWG1mRjFudlZaZ1BFSlF5OGYrQkpCRjE1SCtDMlI5?=
 =?utf-8?B?NlY5ZHBBdTdwZklGUlhDRUg0UG5WV3VlWGZZSlJSZ21saTBQUG1hMDlwcFlv?=
 =?utf-8?B?NlZ1WHE3UXpZLzRrZDRncEZ2bEtvYjJGbFAwUzY4YUlsNkg2M1drRnRwV1FL?=
 =?utf-8?B?bWF4WjczRS9acDBMcnpMVDNxb1pUM0dkVk54VlFJaE9Qa1FvZEV3ZThKbWV5?=
 =?utf-8?B?UDlvS0hhZzNiS0J3aTZhTnJkN3ZjZkhYLzdGZG9sRFZoVzdLQ1hzN2RqcDAv?=
 =?utf-8?B?RWxTK3cwWHpiMnBSTWNtdHF4OSttTXd1a00xYzhwaGdrZFIyM2JkUU56eFpR?=
 =?utf-8?B?NVVncURhaVNJc2s5RGI0MGFtMm5WUjJGQzMySk4yQUxqWVpsZ0pLS2gxV3Ix?=
 =?utf-8?B?b042bklSbmxEUGtadHovNXhqcVdzdVJ1ZEdOcStkTkc0NlhPZzljcWNPak9q?=
 =?utf-8?B?c0o4dWdQLzZTaXQ4U2xMUTNWZlV4a2hCeGQwSllCUmdJbVBDNnIxTHBoVjNp?=
 =?utf-8?B?Y3ArY3M5K2R4cDNKYTJ1T2VVemtuT3pwZ0NGcXZYYzlhWXJ4ZGNzdkQ4Y3Iy?=
 =?utf-8?B?bVo3MHVDOXF3L2JaNmZUQUN1MnJiRjJZSEQwdVBKVDVSRXd6S3NSL0ljUktB?=
 =?utf-8?B?NEd0S083L051SGtRU1c5TTJRcFpmWFUxcDlJSytUa0c4ZlVUL3BkMHhEVXFY?=
 =?utf-8?B?VnAxM3BIL0w1RjNna0VpcVV6bzhQRnZ0bUxmUXFQaUZWNzYwSWhqMFNEV2tU?=
 =?utf-8?B?ejVKdXNpNWphdHdwYW1UYW9QNTl5R3pKUThGWEpxT3BTYWZwU2MwSkoyWjdk?=
 =?utf-8?B?dlBsbmw2UVZPQS9kZGVjdkt0U3M0RWJ5Mk01NHQ1U0dZT2xhT1R5enFCcDhG?=
 =?utf-8?Q?Xd6IDO?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E996B11B12A2D044806555CF58130173@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11090
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	10185e66-9f9c-4bc0-1f03-08de3bc84c85
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|35042699022|7416014|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3RUSW1GdG5CR1dWL3R2d2o5M2ZqZUJ3dXlGaXRuNjd1S3h0a3lvQnh4NW5w?=
 =?utf-8?B?TzUrK2NkblUrYkM1ZjBEbCtSNnRLWm5NNFkzd09IdUN2QUtDaGVwaHdlYmFt?=
 =?utf-8?B?Z0pEZGJ4WTFuaXgzSmE1Zk9iZm9yMnl0Zmp2d3VxNURPMmE5SVlsOCsvZWFP?=
 =?utf-8?B?dVhsQTRiUFlXanN3bjRmeGZlb0lzd0huRDVReW1wNlVqVE5mQWxscnQ3K2Rk?=
 =?utf-8?B?U1hUalYxRUhzTktxSGVXQzFrcHphVkVhSkZXcm9KcUwyamFoVmU1eDBqZUNY?=
 =?utf-8?B?Y3B5YjM0L1kxT1BsbU5OYkZZaGsxYlhmUVpiR2tJNEFsYndQZnhiK0Y1SE44?=
 =?utf-8?B?cnZQNGpHS3IvK2RtaGV3OTVMaWdNQzRsbFd3QWlWSGZ2TjZIcEJ0NEJ5dkl3?=
 =?utf-8?B?dmhNU041bkltUm5EZUFQWGZmbHRWT29uMFpsK1pJYWNpc3FWWGxFR3J3Z2F2?=
 =?utf-8?B?ZDVnSC9iNlU2QkQ5d1J3NlRjUkx2Sm9UREZENURKczZTYURaL1piaGNvYk10?=
 =?utf-8?B?a1FzQ2tCcHIyd2xMSStTbnl6VHhxUE1LV1IzMmphQnVyL05oaXp3eHJtZGZK?=
 =?utf-8?B?MlBLbjBnK0FlYkluZXlYRCtHaWcrckZnU2pGZ1ZxN0tMNkFGdzJsSVNXdU5j?=
 =?utf-8?B?TTBFenZFV3dta2xvRUozbGFtR1FhUVlTdjdxdG1WaXB2cGNiOHdSSWVUQW43?=
 =?utf-8?B?V3F2Z2czQUtMSWtOSHZ0WGdycTkwM21nSmNlUnpGVHdsZTgvNXRvTmIyWTNR?=
 =?utf-8?B?Wmt1TzFSYmw4WGFPU1RhVTc2Q3FOQ3kxeEY5c3U3a2twaEJic0tzYUJOU1kx?=
 =?utf-8?B?U0dqcHM0bEZKanl5YTFnRW1hM1pFM2g4S29teUhMWmNrWmRYUnBLZWtQVmUx?=
 =?utf-8?B?QVh2Q1dMUUF0TVNaN1ZMSnBGeHViMUczSjVtYjU4RkZ1SGNlWS9yRXlIU2Jj?=
 =?utf-8?B?b1hjTEpCOVdNaExESUt5SDdwUmJUcUhSbU9HZHI2SXhGR1NKMEVxN3lTZzJV?=
 =?utf-8?B?MnV2eC9wL0d5T09PQll0UXhPTmttRG5CTjdwWUhZK0pLSEFHWkVvS0JzRFd3?=
 =?utf-8?B?RHU4d2RnTjFYRndSYXVQOHgrRDFIeVZTUEFENjFUT3ZPUW9LbE1XSXdBOFd0?=
 =?utf-8?B?WitOYmc5YWFadUJFU093OHlQVTNwT0xwQmQrNGFqRFE4MldtRTdldUcwZ2JL?=
 =?utf-8?B?S29xais4cVI0c0JYZXk5Y1YrelZiNnlNWGs4SGlkNzZycEdkMjAwVFYza0Fy?=
 =?utf-8?B?SVhqczZJbTB5VmtjQ2l5Y2p6Tm9CYkpNb3dQYUhUaDlwcjRBMnBQVWJSaUZ6?=
 =?utf-8?B?dHptRVZPWlpic3dOVlpJbFBEakRLZWpjZEV2NWpYd0gwM3RGYlNraFZJOURV?=
 =?utf-8?B?bjdCdDFWUmVBQmRIRjRDdHY5Vzk5blBKTG5tY3ZlUjN0VlRROUxJbkp1VnZE?=
 =?utf-8?B?TDN0eGpsOHRPZFd5RlEwQ0hNL1luY04xV3RENEJsR3J5TEdNTXJCc25nTFJ5?=
 =?utf-8?B?K3BjMUhhQnhFV09lZmcwLzIvaUJSSlI1Q1BzNTdkUG83MENKNkExYURxeFNa?=
 =?utf-8?B?NWliUmswVG9XSTI2dHl6MktXZXp6dEtva0ZmZDQrMUZhaUVUQ2tHNW1zRUpR?=
 =?utf-8?B?NDA3QVRPRDhjYVhPeUlHclVsa3FjMXVSY1pRdkhaM3lJVnBBdlIyNk56V2hU?=
 =?utf-8?B?bjNYN2tIRWN0RWF2akJhclh5ZVN6Rkx3S3owazRaOUhsaHBrKzRnUE4wNC9H?=
 =?utf-8?B?aHEvTHlId0xYOFlCV2NlTTRxNGNqQjFFc2NoMzNQb2FXRWFPcUJKdFFjMi9w?=
 =?utf-8?B?Q0VFNUgvdEdRNXBOMCtkTnp1ZWZXWGwwRURmSUdZNVJCQ050cUpIWlJiQk9y?=
 =?utf-8?B?TVB4WnFNSDRYanRjY3ZReGpHMDR0ZWhGcTRIazh6ZEQyUUJEUGNnNTVORjFj?=
 =?utf-8?B?MnVLVEVTZ25BbjFIYjVMTTlsWUk2dHA1a1hHczQvcC9wZkh4b0hycG4vdWZ4?=
 =?utf-8?B?cHhqWXpCWmRNTnhva1ZzbWJ4aXUxcFZsOGI5MUJnZEZzSDFiR0dESWdGZkEz?=
 =?utf-8?B?VUpUTXMvWlp6K2pjVlYyNWl1a2htZGozOCtLUDVYOGwyUzhtUUYvb3ZmL0RT?=
 =?utf-8?Q?yFJY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(35042699022)(7416014)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 10:55:23.9937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e921b786-d2a4-4a9a-b44e-08de3bc872ef
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7950

T24gU2F0LCAyMDI1LTEyLTEzIGF0IDEzOjU5ICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToNCj4gQWxsIGVycm9ycyAobmV3IG9uZXMgcHJlZml4ZWQgYnkgPj4pOg0KPiANCj4gwqDCoCBJ
biBmaWxlIGluY2x1ZGVkIGZyb20gYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oOjM2
LA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmcm9tIGluY2x1ZGUv
bGludXgva3ZtX2hvc3QuaDo0NSwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZnJvbSBhcmNoL2FybTY0L2tlcm5lbC9hc20tb2Zmc2V0cy5jOjE2Og0KPiA+ID4gaW5j
bHVkZS9rdm0vYXJtX3ZnaWMuaDozOTI6MjY6IGVycm9yOiBmaWVsZCAnZ2ljdjVfdnBlJyBoYXMN
Cj4gPiA+IGluY29tcGxldGUgdHlwZQ0KPiDCoMKgwqDCoCAzOTIgfMKgwqDCoMKgwqDCoMKgwqAg
c3RydWN0IGdpY3Y1X3ZwZSBnaWN2NV92cGU7DQo+IMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF5+fn5+fn5+fg0KPiDC
oMKgIG1ha2VbM106ICoqKiBbc2NyaXB0cy9NYWtlZmlsZS5idWlsZDoxODI6IGFyY2gvYXJtNjQv
a2VybmVsL2FzbS0NCj4gb2Zmc2V0cy5zXSBFcnJvciAxDQo+IMKgwqAgbWFrZVszXTogVGFyZ2V0
ICdwcmVwYXJlJyBub3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJyb3JzLg0KPiDCoMKgIG1ha2VbMl06
ICoqKiBbTWFrZWZpbGU6MTMxNDogcHJlcGFyZTBdIEVycm9yIDINCj4gwqDCoCBtYWtlWzJdOiBU
YXJnZXQgJ3ByZXBhcmUnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuDQo+IMKgwqAgbWFr
ZVsxXTogKioqIFtNYWtlZmlsZToyNDg6IF9fc3ViLW1ha2VdIEVycm9yIDINCj4gwqDCoCBtYWtl
WzFdOiBUYXJnZXQgJ3ByZXBhcmUnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuDQo+IMKg
wqAgbWFrZTogKioqIFtNYWtlZmlsZToyNDg6IF9fc3ViLW1ha2VdIEVycm9yIDINCj4gwqDCoCBt
YWtlOiBUYXJnZXQgJ3ByZXBhcmUnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuDQo+IA0K
DQpJJ3ZlIGxvY2F0ZWQgdGhlIHVuZGVybHlpbmcgaXNzdWUgLSB0aGUgZGVmaW5pdGlvbiBvZiBz
dHJ1Y3QgZ2ljdjVfdnBlDQp3YXMgd3JhcHBlZCBpbiBhbiAjaWZkZWYgQ09ORklHX0tWTSBibG9j
aywgYW5kIHRoZSB0d28gZmFpbGluZyBidWlsZHMNCmhhdmUgS1ZNIGRpc2FibGVkLg0KDQpJJ3Zl
IGZpeGVkIHRoZSBpc3N1ZSBsb2NhbGx5IChkcm9wcGVkIHRoZSAjaWZkZWYpLCBhbmQgd2lsbCBw
b3N0IGENCmZpeGVkIGNvbW1pdCBhcyBwYXJ0IG9mIHYyIG9mIHRoaXMgc2VyaWVzLg0KDQpTYXNj
aGENCg==

