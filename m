Return-Path: <kvm+bounces-67237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB84CCFF15F
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 423183149AE8
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69126350A02;
	Wed,  7 Jan 2026 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bCu3mG06";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bCu3mG06"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013068.outbound.protection.outlook.com [40.107.159.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4199E3469E4
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801668; cv=fail; b=ITt/sFEZ0mUvkKC01xcaWhwj9ROCYuh1XJnf24Up5d4uoaqMpB5sMDQhxvdXgKAD7SXbLW7oRA4znK4HFz92TjqiuFRPiOm5IRVhaS7KFFL2YJiDK3dxQ+1AG4twSHsMXeYp0MeNuvmz69Wal1CAfGx0nBSAzmM5ounaWqG+iyE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801668; c=relaxed/simple;
	bh=ExeJybkAw4e1FkrtnQlEffcUdIBbOFSvN/baUmkp4YA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fDj8P/kcG4X+Z/Mcna7iYHo+O+2tlf9wNdOsVEyhonn8RnYjsAQi33DkS5hcG6v2XOOgwvXRqoGBDjeGBH90n2uh7TFz28ipxJ7NwWwX2FU/mWHFjhqMQF+fQusWt3l7Igox1/EcXGc8Z9sO3Ya3WEAnsXibVgmqX2pbho2tp+U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bCu3mG06; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bCu3mG06; arc=fail smtp.client-ip=40.107.159.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fFP/NS4Wm2ec+g2qTafZgUdB1/apX53tl5P0mTlAVOp9bEeUw6hR5EzXtqfuHxprwpztjoJn9qASGqu1fmqQFsJbes/uALkC/+/5yYlulrSkStFvW3c545DUt5ipL+zv3+omQE6/wMc7gSHfdZEdSfUGe2BbKO6axTpepPr0ai2yFhCa6xt91oI2W4Xps1ke1Wue2SkEviInFOgJvs5+1sKuv48BnZo7pPjLbH7PeZcfB3oLj/W5ckC2qSkYORS9ly3OkWrQZVf7po3F9iVv+aPcuEaNwvSsiZw3Qa+JnpT14uIrCmuqtd7NLv6VVesy4YRd72kDakyLO41Wp9RC6Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExeJybkAw4e1FkrtnQlEffcUdIBbOFSvN/baUmkp4YA=;
 b=PH5LNkx0QWagV3M3UQQhFqMJulDFfLIGX6qipWf4tKKNcHHfRbdyIbWS4ZMrV8GC78xHejRYBo3WLyyqghpdKEc5vzygpq/3hdFSnItfzlx8ncDybpOlq4g0fZDVr4A/DVTnu1HMUvyF9CajzVngSS5juuQNVAlMgc9bsdgFyw8Tzg+Ez3K1mlQzg4X1/A+1Ab9/L6xZplhZm1UFzdo7/ELakIn1ENU3u+ebf1dVJhcmQ2w4TJzQN/O6usaOeFa/MtKDy2mrQYiV3Qdphb4CBCKuHHPhUxwjvrtc7L5T/MkmJOXAo9U0ECle0mtgtjBAixy1EwyMgY67dMMntbxRpw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExeJybkAw4e1FkrtnQlEffcUdIBbOFSvN/baUmkp4YA=;
 b=bCu3mG06u7BrG8UyBD/QD7tb3KVmK2InFRiOjGuW7ivMFDayQ0gAQ15WSdv5HZMYGS+A/bm3Y+Hq78f5OpgAsLVOTEvTwBHhOTGfWnsYAkCpk4lQxuI1Nwz7H0OJ8RBYyMrm9XOdJBCsjlefNkEZAq2HeORaJTK6SGHUEVWztfY=
Received: from DUZPR01CA0197.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::11) by DB9PR08MB8436.eurprd08.prod.outlook.com
 (2603:10a6:10:3d4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 16:00:47 +0000
Received: from DB5PEPF00014B8A.eurprd02.prod.outlook.com
 (2603:10a6:10:4b6:cafe::67) by DUZPR01CA0197.outlook.office365.com
 (2603:10a6:10:4b6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Wed, 7
 Jan 2026 16:01:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8A.mail.protection.outlook.com (10.167.8.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1
 via Frontend Transport; Wed, 7 Jan 2026 16:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAXzw7ypu9GPGXpNtxV1FIKdpXzh2eRDkVHH4qhNDyLcLmddyfbX+7QNFUGxf4oeJ31DCUttBxTLsFyfuLXHmiWIEofPXgQ+cDTkzDs11weg5RadjUPQ7jIPUfDxpfvOaqE+0ChJyODwIsKVVhGGKSCj3dyLOfRMXuz+NmYt/OvXDraaDR3vaxNAONyW86925JGmfR3ydMIoL3XFylDbtassYi27PnBoPAsOIhaaEpWvNu82CnmBi0ik/GAIohpV0YxsudR49IJv7oI4wae33oJBMBeJ1oAPS6Dn28MURnWy+/OQeirMCedNcjhNKANRBJC3QcbbIVN28aLnIhiyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExeJybkAw4e1FkrtnQlEffcUdIBbOFSvN/baUmkp4YA=;
 b=vlS0X/PmJn9EodHIuqg+LlyzLtD3qqtC9P2DgyUbs82APRmqOPv88yiyw2E3yr9RFuMi3mbfnk9J/FCbpLqk1uJwM32RBpQvdZGIY6FWnVO43+XlxUjRHs6YeZLdZC+sS5ApTurw1PvadX7V2nGhpw+fD+qgesOTqnOGf5UOdHP6Uy6ZfigDOsWzsZb/dAC+znIiAgppsNlZDpq4SILi6OjtbixcuondxnElLoj0tdIRtPMhzkhXlfuaTSOYglJ4YTr62o+PD1nL9Vm/uQStPdX30Oi2wqUjuFcSQZapXKhzgszO9qh/oZMIrJzLH/6F16A5xjgfJeYp60bbExGtxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExeJybkAw4e1FkrtnQlEffcUdIBbOFSvN/baUmkp4YA=;
 b=bCu3mG06u7BrG8UyBD/QD7tb3KVmK2InFRiOjGuW7ivMFDayQ0gAQ15WSdv5HZMYGS+A/bm3Y+Hq78f5OpgAsLVOTEvTwBHhOTGfWnsYAkCpk4lQxuI1Nwz7H0OJ8RBYyMrm9XOdJBCsjlefNkEZAq2HeORaJTK6SGHUEVWztfY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV1PR08MB8689.eurprd08.prod.outlook.com (2603:10a6:150:82::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 15:59:39 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 15:59:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHca3soLX+ZjvZJeECiRPwCqFVv3bUl7BcAgCEaMgA=
Date: Wed, 7 Jan 2026 15:59:38 +0000
Message-ID: <33b69200a4672a5b4134d02b2cb939339f268871.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-19-sascha.bischoff@arm.com>
	 <86zf7hmbb5.wl-maz@kernel.org>
In-Reply-To: <86zf7hmbb5.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV1PR08MB8689:EE_|DB5PEPF00014B8A:EE_|DB9PR08MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: d466eb9c-2538-40e4-5550-08de4e05ebbe
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MzQ5NWUvYzRNWkh4ZnZJZjl2VTM5QVdTUDJqaFFNMjRBTVZEQmluYmtXOXBV?=
 =?utf-8?B?M01CR0t2dVJZTWxiVDR1WmRlWUVndHFSREJkRnByU1FkMW1kOEhNS3g1UzNj?=
 =?utf-8?B?ZTVVMWRUNGVmcVRleGpwUExDbHRRdHV4WU5pR01LY3Byc1d4aXRsVmRPVHgr?=
 =?utf-8?B?a3gvVWw3MFZkN0Z0NlNqTTRoSysxcXd5WVZKSG45U0JFcjZWVWlPU1hnNUxJ?=
 =?utf-8?B?UituOVIyNkxVbXZBd1pLRno4UFVOL0RZYjlFcjBkbHBaQUhMZ1RzaE5NMmJ4?=
 =?utf-8?B?Wnc1NjJLbW90U1JWVUs0NjhQN04vMnNTUmpIaDZWd29wa2dmdXVCeHZNbTRJ?=
 =?utf-8?B?NFFNSnNWUi92dmZsVHc5MThIbGdHTHRLRkZvZWtzQVh1c1lBMWRwMXVNbkUw?=
 =?utf-8?B?L0ZZb2RwMTV1ZFAyM2MyWDd6ZUhIOGJMMkVudHVKQTNTelllZG8wS1orVTdv?=
 =?utf-8?B?Nm1URDdwbWRWQlFod2NHczR2Q3ppZlliNExWTEhtS0hLUXNOWGtMaFY1YWxn?=
 =?utf-8?B?aE9OVy9FVmZFVHpmTXRER2dyOWN3WWtVenlSQkZndWtuNklYNEtKWU1LdWt4?=
 =?utf-8?B?d0cwd21RTWFTd3ErRVZQTkdHOEdlTmR2RjJlWDB0VWlGdVBTTjBwZzVJQ1ZH?=
 =?utf-8?B?TVNJYTlDY0ZqQTREMCs5aGZLOHQwanN2OHpQRTRoMVh2NEFZUHJiNnBYMjQw?=
 =?utf-8?B?L3cwN0tiODg2VVJRUGRmZmU3SVZ2YTc5N1J3blErd1hEZ0thVytUYnNTbGxp?=
 =?utf-8?B?TEVTQXJpQkxHYldtYXowTU5xYTBxZW53N2grbkNmQ1YwNGtBd0xwVDBHaU1p?=
 =?utf-8?B?bTRjb2pFT1VsbDN6Umt1bkxuWFJaTlp0THd5bGY2aGpMTUZmeUMvREZhc0hN?=
 =?utf-8?B?QkYvQmU1RGRXcktLZmozOGZkQ21oMFI3Q2VRSnpEblhVWXdtbVpHRHp2cjB2?=
 =?utf-8?B?bElsL1g1YnAyMHdncnBSeUZPaXljYm5ZbEhJejZYTVFXTlRvMjVQekN1clhn?=
 =?utf-8?B?TEo5eUNTWjRpSDNzSlpoYWE2VG9JeXhGY21kNzJ3RFhiRzdsNW1uSzVaRXJY?=
 =?utf-8?B?dWZCd0F4OGZ3SnhjRmpoL1FMejdCN2ZUZlhYMFk3RkF0RktkT3gxb0ZnUGpX?=
 =?utf-8?B?QVRFVVMyeDNvMi9QY1JLWVJhT0ROaUl4OHZnNDRjMGxPVkpqaHdmQjBqTEY1?=
 =?utf-8?B?NG5rbFhMZjg4OTcrUG1EOXA2NFVSb2xCcnZnYWRzR1RJbFZZK3pBWW5LRWZa?=
 =?utf-8?B?TkVpVHY3ZmEwOUpFZGkveUNnbGo3SDhHUnFXQ3Z2Tm5FQWtlM1Z0ZHlyRG1h?=
 =?utf-8?B?Ti9ZdGVGWC92TTU0OHRSdlFjRGhzcUZYWFlNODNiWVlvR3B4MzhwV3lGQlcz?=
 =?utf-8?B?c29WVUZkdHVyWnBFOG1WRDRTMkFZczBVYVVONzdEWkl1UGRYSjFZdXNnZ3dN?=
 =?utf-8?B?cVNaVFI4N3djZi9sZEtaNUhFYk1adlo0bnZKMGdLdlhFVHBaYkVYRnZ0S1hu?=
 =?utf-8?B?MUVnN1Nwcml0VWtFZ0U5K3Yvb2V2K3RzUU1vT0JSVnJydW9GSE5naGx0VFQ1?=
 =?utf-8?B?VjZhS1JEdnQ5bFo4aVdBNElnRVRwTERkUlloblF2RlVsYThIM2Rucyt0Wnlx?=
 =?utf-8?B?c2NZU3NFSUVWVSt0ajZUNnpGU2hOcjc5cHAvbGJxQkxlVXFpUG9KbTRiSFNY?=
 =?utf-8?B?cXVWVjJabzh3VVZ6MmdvLzhVQ1BKdkJLejhWUHNNL2wxWWZpVmxZS09RWVZ5?=
 =?utf-8?B?VW4yR2NydUszR0RIejFCQjVPOCthcm9UcXl1NUJYSXd1SnhQYlB6ZGdoZUhu?=
 =?utf-8?B?d2RqSENlM3VHRE1SVTUyWjBvaXNVZnNMeXhXbUdYYXM4akNCd3ZwWGg0RVVj?=
 =?utf-8?B?TVNpQ1dsVnZrRU9lVDAvRndZLzJ2aDlZWlBFRGhaYkhOc2tJdjFMb0ZUOC9l?=
 =?utf-8?B?OThsMU9jRURaNm93amlyRjRyVXN4QmEya1VmRThSUFF2Sjc5dzlBS0RxUHFE?=
 =?utf-8?B?RmpMZWhKcklHWFhUNVFBb3EwWVZ6OUVwaE1MKzJVdG04dmJmOUNqdXpoV0dz?=
 =?utf-8?Q?htyk7b?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <90EBDC5FA085354E81237B80B2728A91@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8689
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c6dbfcff-485f-436f-46c3-08de4e05c343
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|376014|82310400026|1800799024|35042699022|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VllMdUJmM05CdFAreVhYZmhySmp0emNxY0c4UE9nb2VxUlRJbDZpYVRJRTdM?=
 =?utf-8?B?YTV2Z0RidUUzMGJKZ3pXeHRBUk5aYmNkVVc0RXdudjZFNEdBKyszak1zT0Rp?=
 =?utf-8?B?SytKTlVFWkJmZXVJVllFdmx6RmhoMEtCRVU4c1kxdFRrTVdtTEhHREdlaGRI?=
 =?utf-8?B?VkxIZVNiN1gwdnFDZ0MwOUFhVFZoK2x4MmNZakVjVGtLUzlSUzBVMmxpNHA4?=
 =?utf-8?B?OERJZ1ExVzlmU1hYVmszc3Q4bmo3blYyQUxnYm9XK3pxNEtjeUFyTHNsN1F6?=
 =?utf-8?B?WW9sUk1tM0ZYRzA3a1NOWnQ0a1BtVGlWSE1yT1FkbHAwUkRoK25zK3lsMlFQ?=
 =?utf-8?B?a2ZtNE5MZ0RIVWY2OWhNUGxRRmpmZGdLNkhhUC9tS2xKN25nRVNyZ2o4NlRR?=
 =?utf-8?B?RVJhaTVkblVaRkNadDhKVS9RS3hqUHFtK080c3A5d2R5YTJyd2VRVzBtSW5s?=
 =?utf-8?B?SnN0L2VYbVJ2T2JGamMyUnZRNmI1WjVGSjc4MTlGOUdycTkrSDFnRzRxcnJU?=
 =?utf-8?B?Q2RPWUc5SVA1R1VReVoxTndNVjkvSEVGWVIrZ0lNeVFRSkNjdjE1aGFYd2hp?=
 =?utf-8?B?ZDcvM1NlTHN0STAzSXM3M2RNV0lkdlBrRjZoR0RVSE4yd0Y3bmJ1S1pqZzZ3?=
 =?utf-8?B?TWtENjBSQnB6OTBHY3p0LzlvZ3FURnpIWXF3NVFFeDFKcUc5VkVTbHhKTjNl?=
 =?utf-8?B?ekh1amlUUDdHb3U3Z2ZSRFh4d3k3RXFsZ29pOEZ5cFBId0wxS1lEMkRQdm9T?=
 =?utf-8?B?M2k2Z2tkaXd2ZGJnWkl3UHlxaDNlVVZ3VWVhc21VandGeXg4UnBLVGNlUzFO?=
 =?utf-8?B?NENVdGdvSVlHdEhLZjFaVlpXaHcxaTZNRGJMbWxxdUNUaUhtSG9ZWDJKaEhr?=
 =?utf-8?B?S01CblAzcExubkZPSHQ1bjFLSmNJWTl3Y1RLTmpsU3hCMFQ1MUU3QmMyb0Rr?=
 =?utf-8?B?UnpZNmlEZWx5TzgwY040ZnBLTlozQWJ1cEpHa1RKSEdXeVlLU2I2TThJMmh4?=
 =?utf-8?B?RXlaR21heDVwYUZaL3A4c05sYVRMVEFybG9CQzhiTXNWSXh2YTA4UFdRTmNN?=
 =?utf-8?B?bmlJb2F5dDBBbTRYMWtENkVJcUZmdXRWZlhVM3c0WU5oT2tJZTcvZ0IxUGpk?=
 =?utf-8?B?LzF2djJjWnhhVVFCWEpWUmx2aHR4SmpGTFhscjhPaDYyQkhhbnVqcGVKK1pp?=
 =?utf-8?B?SWpsVFV4Zi9ZeEV2R0ZtWTdPK3d4eGEwNlNWVEpyR1haUnVUTUREZTVmUS9h?=
 =?utf-8?B?UFdJOFpxOWYwbXNvdFRIbVhwOENUZS9aalNwN0Y5L3RFSGNGRTJtM2ovaTQy?=
 =?utf-8?B?YWRRVnhwTWxlTkhwWC9rUXVOU2NUeWRoMW9iT3hKcyszL1QvTXo5SHQ4SDg0?=
 =?utf-8?B?YkUzTDhTWjVDNE9zMlVMK1JzQ1JOOVFiZXRqcm1UdzYza0JWZEZveVpkb2xM?=
 =?utf-8?B?YWhrOFhHRkFZRk1pR2NYRlRtQXYwQlB4SDV4bGpjL25obzJXNDgyR0l3TEJp?=
 =?utf-8?B?N01Pak44VmlpS3hYSEJXcXVOWHhoWWNGdWVHUmx4WkZxZXlmcVJDSjVFRHJX?=
 =?utf-8?B?dEd1N0JPTkZxSFFjSUMvUzlWYUxFeU9xWmYxVjFRVGg5WEdTYjJUWm51M1Zi?=
 =?utf-8?B?RnkrM2lDOEsyMDF5OGU0anMzQTRyUWZhTWNlWUlLd1hOaHJJb0FCWCtqMytR?=
 =?utf-8?B?WHR5SFE3TERpY20ybEpXUzRRWWNBOGlZSVlQb2QyRCtFSnVROFJ6ZUxwZnpl?=
 =?utf-8?B?ZFcrWmowQ0hsVFJKUnhhTVZHTjFPVCt0L1d5ZDdWbjBCNlFMdXFoTGxTdHQy?=
 =?utf-8?B?Q3ZCbHUyZ0VQVVI2U0lwRmZNMWpuRVJtRWR3VXFjUVprTHFYQVltbE1QdVNp?=
 =?utf-8?B?SUdXT0JjUGVCeXNaQ0RSeTM3WlM5c296UGk5VlB6M2lOTCtGZnErSG8wK083?=
 =?utf-8?B?OWZSREpxMU9KU0hrYVZIRG4yZThjenVXS2V2TmdoUEdGaHJaL3VMT1p2ZXpJ?=
 =?utf-8?B?U2NlZVFpZ3JzN1lJTXJHM3BvMXByNGlVcTFHRTFSN2ZpQVpZV05xRm5IL3N2?=
 =?utf-8?B?UnQwZmlucHBqaS9RNjZaSVJldGNuUXhZekkvQ0ZzdW51MGVuVzh1M3pZdHY1?=
 =?utf-8?Q?Ijvs=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(376014)(82310400026)(1800799024)(35042699022)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 16:00:46.8938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d466eb9c-2538-40e4-5550-08de4e05ebbe
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8436

T24gV2VkLCAyMDI1LTEyLTE3IGF0IDE0OjI5ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6NDEgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoaXMgY2hhbmdlIGFs
bG93cyBLVk0gdG8gY2hlY2sgZm9yIHBlbmRpbmcgUFBJIGludGVycnVwdHMuIFRoaXMNCj4gPiBo
YXMNCj4gPiB0d28gbWFpbiBjb21wb25lbnRzOg0KPiA+IA0KPiA+IEZpcnN0IG9mIGFsbCwgdGhl
IGVmZmVjdGl2ZSBwcmlvcml0eSBtYXNrIGlzIGNhbGN1bGF0ZWQuwqAgVGhpcyBpcyBhDQo+ID4g
Y29tYmluYXRpb24gb2YgdGhlIHByaW9yaXR5IG1hc2sgaW4gdGhlIFZQRXMgSUNDX1BDUl9FTDEu
UFJJT1JJVFkNCj4gPiBhbmQNCj4gPiB0aGUgY3VycmVudGx5IHJ1bm5pbmcgcHJpb3JpdHkgYXMg
ZGV0ZXJtaW5lZCBmcm9tIHRoZSBWUEUncw0KPiA+IElDSF9BUFJfRUwxLiBJZiBhbiBpbnRlcnJ1
cHQncyBwcmlvaXJpdHkgaXMgZ3JlYXRlciB0aGFuIG9yIGVxdWFsDQo+ID4gdG8NCj4gPiB0aGUg
ZWZmZWN0aXZlIHByaW9yaXR5IG1hc2ssIGl0IGNhbiBiZSBzaWduYWxsZWQuIE90aGVyd2lzZSwg
aXQNCj4gPiBjYW5ub3QuDQo+ID4gDQo+ID4gU2Vjb25kbHksIGFueSBFbmFibGVkIGFuZCBQZW5k
aW5nIFBQSXMgbXVzdCBiZSBjaGVja2VkIGFnYWluc3QgdGhpcw0KPiA+IGNvbXBvdW5kIHByaW9y
aXR5IG1hc2suIFRoZSByZXFpcmVzIHRoZSBQUEkgcHJpb3JpdGllcyB0byBieSBzeW5jZWQNCj4g
PiBiYWNrIHRvIHRoZSBLVk0gc2hhZG93IHN0YXRlIC0gdGhpcyBpcyBza2lwcGVkIGluIGdlbmVy
YWwgb3BlcmF0aW9uDQo+ID4gYXMNCj4gPiBpdCBpc24ndCByZXF1aXJlZCBhbmQgaXMgcmF0aGVy
IGV4cGVuc2l2ZS4gSWYgYW55IEVuYWJsZWQgYW5kDQo+ID4gUGVuZGluZw0KPiA+IFBQSXMgYXJl
IG9mIHN1ZmZpY2llbnQgcHJpb3JpdHkgdG8gYmUgc2lnbmFsbGVkLCB0aGVuIHRoZXJlIGFyZQ0K
PiA+IHBlbmRpbmcgUFBJcy4gRWxzZSwgdGhlcmUgYXJlIG5vdC7CoCBUaGlzIGVuc3VyZXMgdGhh
dCBhIFZQRSBpcyBub3QNCj4gPiB3b2tlbiB3aGVuIGl0IGNhbm5vdCBhY3R1YWxseSBwcm9jZXNz
IHRoZSBwZW5kaW5nIGludGVycnVwdHMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hh
IEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jIHwgMTIzDQo+ID4gKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmPCoMKgwqAgfMKg
IDEwICsrLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmjCoMKgwqAgfMKgwqAgMSAr
DQo+ID4gwqAzIGZpbGVzIGNoYW5nZWQsIDEzMSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0K
PiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCBkNTQ1OTVmYmY0
NTg2Li4zNTc0MGU4OGIzNTkxIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy12NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBA
QCAtNTQsNiArNTQsMzEgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0IGdpY19rdm1f
aW5mbw0KPiA+ICppbmZvKQ0KPiA+IMKgIHJldHVybiAwOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4g
K3N0YXRpYyB1MzIgdmdpY192NV9nZXRfZWZmZWN0aXZlX3ByaW9yaXR5X21hc2soc3RydWN0IGt2
bV92Y3B1DQo+ID4gKnZjcHUpDQo+ID4gK3sNCj4gPiArIHN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAq
Y3B1X2lmID0gJnZjcHUtPmFyY2gudmdpY19jcHUudmdpY192NTsNCj4gPiArIHVuc2lnbmVkIGhp
Z2hlc3RfYXAsIHByaW9yaXR5X21hc2s7DQo+IA0KPiBQbGVhc2UgdXNlIGV4cGxpY2l0IHR5cGVz
IHRoYXQgbWF0Y2ggdGhlaXIgYXNzaWdubWVudC4NCg0KRG9uZQ0KDQo+IA0KPiA+ICsNCj4gPiAr
IC8qDQo+ID4gKyAqIENvdW50aW5nIHRoZSBudW1iZXIgb2YgdHJhaWxpbmcgemVyb3MgZ2l2ZXMg
dGhlIGN1cnJlbnQNCj4gPiArICogYWN0aXZlIHByaW9yaXR5LiBFeHBsaWNpdGx5IHVzZSB0aGUg
MzItYml0IHZlcnNpb24gaGVyZSBhcw0KPiA+ICsgKiB3ZSBoYXZlIDMyIHByaW9yaXRpZXMuIDB4
MjAgdGhlbiBtZWFucyB0aGF0IHRoZXJlIGFyZSBubw0KPiA+ICsgKiBhY3RpdmUgcHJpb3JpdGll
cy4NCj4gPiArICovDQo+ID4gKyBoaWdoZXN0X2FwID0gX19idWlsdGluX2N0eihjcHVfaWYtPnZn
aWNfYXByKTsNCj4gDQo+IEZyb20gaHR0cHM6Ly9nY2MuZ251Lm9yZy9vbmxpbmVkb2NzL2djYy9C
aXQtT3BlcmF0aW9uLUJ1aWx0aW5zLmh0bWwNCj4gDQo+IDxxdW90ZT4NCj4gQnVpbHQtaW4gRnVu
Y3Rpb246IGludCBfX2J1aWx0aW5fY3R6ICh1bnNpZ25lZCBpbnQgeCkNCj4gDQo+IMKgwqDCoCBS
ZXR1cm5zIHRoZSBudW1iZXIgb2YgdHJhaWxpbmcgMC1iaXRzIGluIHgsIHN0YXJ0aW5nIGF0IHRo
ZSBsZWFzdA0KPiBzaWduaWZpY2FudCBiaXQgcG9zaXRpb24uIElmIHggaXMgMCwgdGhlIHJlc3Vs
dCBpcyB1bmRlZmluZWQuDQo+IDwvcXVvdGU+DQo+IA0KPiBXZSByZWFsbHkgZG9uJ3QgbGlrZSB1
bmRlZmluZWQgcmVzdWx0cy4NCj4gDQoNCkFoLCBhZ3JlZWQuIEkndmUgdGFrZW4gSm9leSdzIHN1
Z2dlc3Rpb24gaGVyZToNCg0KaGlnaGVzdF9hcCA9IGNwdV9pZi0+dmdpY19hcHIgPyBfX2J1aWx0
aW5fY3R6KGNwdV9pZi0+dmdpY19hcHIpIDogMzI7DQoNCj4gPiArDQo+ID4gKyAvKg0KPiA+ICsg
KiBBbiBpbnRlcnJ1cHQgaXMgb2Ygc3VmZmljaWVudCBwcmlvcml0eSBpZiBpdCBpcyBlcXVhbCB0
byBvcg0KPiA+ICsgKiBncmVhdGVyIHRoYW4gdGhlIHByaW9yaXR5IG1hc2suIEFkZCAxIHRvIHRo
ZSBwcmlvcml0eSBtYXNrDQo+ID4gKyAqIChpLmUuLCBsb3dlciBwcmlvcml0eSkgdG8gbWF0Y2gg
dGhlIEFQUiBsb2dpYyBiZWZvcmUgdGFraW5nDQo+ID4gKyAqIHRoZSBtaW4uIFRoaXMgZ2l2ZXMg
dXMgdGhlIGxvd2VzdCBwcmlvcml0eSB0aGF0IGlzIG1hc2tlZC4NCj4gPiArICovDQo+ID4gKyBw
cmlvcml0eV9tYXNrID0gRklFTERfR0VUKEZFQVRfR0NJRV9JQ0hfVk1DUl9FTDJfVlBNUiwgY3B1
X2lmLQ0KPiA+ID52Z2ljX3ZtY3IpOw0KPiA+ICsgcHJpb3JpdHlfbWFzayA9IG1pbihoaWdoZXN0
X2FwLCBwcmlvcml0eV9tYXNrICsgMSk7DQo+ID4gKw0KPiA+ICsgcmV0dXJuIHByaW9yaXR5X21h
c2s7DQo+ID4gK30NCj4gPiArDQo+ID4gwqBzdGF0aWMgYm9vbCB2Z2ljX3Y1X3BwaV9zZXRfcGVu
ZGluZ19zdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gwqAgwqAgc3RydWN0IHZnaWNf
aXJxICppcnEpDQo+ID4gwqB7DQo+ID4gQEAgLTEyMSw2ICsxNDYsMTA0IEBAIHZvaWQgdmdpY192
NV9zZXRfcHBpX29wcyhzdHJ1Y3QgdmdpY19pcnENCj4gPiAqaXJxKQ0KPiA+IMKgIGlycS0+b3Bz
ID0gJnZnaWNfdjVfcHBpX2lycV9vcHM7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArDQo+ID4gKy8q
DQo+ID4gKyAqIFN5bmMgYmFjayB0aGUgUFBJIHByaW9yaXRpZXMgdG8gdGhlIHZnaWNfaXJxIHNo
YWRvdyBzdGF0ZQ0KPiA+ICsgKi8NCj4gPiArc3RhdGljIHZvaWQgdmdpY192NV9zeW5jX3BwaV9w
cmlvcml0aWVzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiArew0KPiA+ICsgc3RydWN0IHZn
aWNfdjVfY3B1X2lmICpjcHVfaWYgPSAmdmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+
ICsgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiArIGludCBpLCByZWc7DQo+ID4gKw0KPiA+ICsg
LyogV2UgaGF2ZSAxNiBQUEkgUHJpb3JpdHkgcmVncyAqLw0KPiA+ICsgZm9yIChyZWcgPSAwOyBy
ZWcgPCAxNjsgcmVnKyspIHsNCj4gPiArIGNvbnN0IHVuc2lnbmVkIGxvbmcgcHJpb3JpdHlyID0g
Y3B1X2lmLT52Z2ljX3BwaV9wcmlvcml0eXJbcmVnXTsNCj4gPiArDQo+ID4gKyBmb3IgKGkgPSAw
OyBpIDwgODsgKytpKSB7DQo+IA0KPiBVcmdoLi4uIDEyOCBsb2NrcyBiZWluZyB0YWtlbiBpcyBu
byBnb29kLiBXZSBuZWVkIHNvbWV0aGluZyBiZXR0ZXIuDQoNClllYWgsIGl0IHJlYWxseSBpc24n
dCBncmVhdC4gSSd2ZSBub3cgcmUtd3JpdHRlbiB0aGlzIHRvIG9ubHkgc3luYyB0aGUNCnByaW9y
aXRpZXMgZm9yIFBQSXMgdGhhdCBhcmUgYWN0dWFsbHkgZXhwb3NlZCB0byB0aGUgZ3Vlc3QuIE1v
cmVvdmVyLA0KaW5zdGVhZCBvZiBzeW5jaW5nIGVhY2ggdGltZSB3ZSBjaGVjayBpZiB0aGVyZSBp
cyBhIHBlbmRpbmcgaW50ZXJydXB0LA0Kd2Ugc3luYyBvbiB0aGUgdmdpY19wdXQoKSBwYXRoIHdo
ZW4gYWxzbyBlbnRlcmluZyBXRkkuDQoNCj4gDQo+ID4gKyBzdHJ1Y3QgdmdpY19pcnEgKmlycTsN
Cj4gPiArIHUzMiBpbnRpZDsNCj4gPiArIHU4IHByaW9yaXR5Ow0KPiA+ICsNCj4gPiArIHByaW9y
aXR5ID0gKHByaW9yaXR5ciA+PiAoaSAqIDgpKSAmIDB4MWY7DQo+ID4gKw0KPiA+ICsgaW50aWQg
PSBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX1RZUEUsIEdJQ1Y1X0hXSVJRX1RZUEVfUFBJKTsNCj4g
PiArIGludGlkIHw9IEZJRUxEX1BSRVAoR0lDVjVfSFdJUlFfSUQsIHJlZyAqIDggKyBpKTsNCj4g
PiArDQo+ID4gKyBpcnEgPSB2Z2ljX2dldF92Y3B1X2lycSh2Y3B1LCBpbnRpZCk7DQo+ID4gKyBy
YXdfc3Bpbl9sb2NrX2lycXNhdmUoJmlycS0+aXJxX2xvY2ssIGZsYWdzKTsNCj4gPiArDQo+ID4g
KyBpcnEtPnByaW9yaXR5ID0gcHJpb3JpdHk7DQo+ID4gKw0KPiA+ICsgcmF3X3NwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJmlycS0+aXJxX2xvY2ssIGZsYWdzKTsNCj4gDQo+IHNjb3BlZF9ndWFyZCgp
DQoNCkRvbmUuDQoNCj4gDQo+ID4gKyB2Z2ljX3B1dF9pcnEodmNwdS0+a3ZtLCBpcnEpOw0KPiA+
ICsgfQ0KPiA+ICsgfQ0KPiA+ICt9DQo+ID4gKw0KPiA+ICtib29sIHZnaWNfdjVfaGFzX3BlbmRp
bmdfcHBpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiArew0KPiA+ICsgc3RydWN0IHZnaWNf
djVfY3B1X2lmICpjcHVfaWYgPSAmdmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+ICsg
dW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiArIGludCBpLCByZWc7DQo+ID4gKyB1bnNpZ25lZCBp
bnQgcHJpb3JpdHlfbWFzazsNCj4gPiArDQo+ID4gKyAvKiBJZiBubyBwZW5kaW5nIGJpdHMgYXJl
IHNldCwgZXhpdCBlYXJseSAqLw0KPiA+ICsgaWYgKGxpa2VseSghY3B1X2lmLT52Z2ljX3BwaV9w
ZW5kclswXSAmJiAhY3B1X2lmLQ0KPiA+ID52Z2ljX3BwaV9wZW5kclsxXSkpDQo+ID4gKyByZXR1
cm4gZmFsc2U7DQo+ID4gKw0KPiA+ICsgcHJpb3JpdHlfbWFzayA9IHZnaWNfdjVfZ2V0X2VmZmVj
dGl2ZV9wcmlvcml0eV9tYXNrKHZjcHUpOw0KPiA+ICsNCj4gPiArIC8qIElmIHRoZSBjb21iaW5l
ZCBwcmlvcml0eSBtYXNrIGlzIDAsIG5vdGhpbmcgY2FuIGJlIHNpZ25hbGxlZCENCj4gPiAqLw0K
PiA+ICsgaWYgKCFwcmlvcml0eV9tYXNrKQ0KPiA+ICsgcmV0dXJuIGZhbHNlOw0KPiA+ICsNCj4g
PiArIC8qIFRoZSBzaGFkb3cgcHJpb3JpdHkgaXMgb25seSB1cGRhdGVkIG9uIGRlbWFuZCwgc3lu
YyBpdCBhY3Jvc3MNCj4gPiBmaXJzdCAqLw0KPiA+ICsgdmdpY192NV9zeW5jX3BwaV9wcmlvcml0
aWVzKHZjcHUpOw0KPiA+ICsNCj4gPiArIGZvciAocmVnID0gMDsgcmVnIDwgMjsgcmVnKyspIHsN
Cj4gPiArIHVuc2lnbmVkIGxvbmcgcG9zc2libGVfYml0czsNCj4gPiArIGNvbnN0IHVuc2lnbmVk
IGxvbmcgZW5hYmxlciA9IGNwdV9pZi0NCj4gPiA+dmdpY19pY2hfcHBpX2VuYWJsZXJfZXhpdFty
ZWddOw0KPiA+ICsgY29uc3QgdW5zaWduZWQgbG9uZyBwZW5kciA9IGNwdV9pZi0+dmdpY19wcGlf
cGVuZHJfZXhpdFtyZWddOw0KPiA+ICsgYm9vbCBoYXNfcGVuZGluZyA9IGZhbHNlOw0KPiA+ICsN
Cj4gPiArIC8qIENoZWNrIGFsbCBpbnRlcnJ1cHRzIHRoYXQgYXJlIGVuYWJsZWQgYW5kIHBlbmRp
bmcgKi8NCj4gPiArIHBvc3NpYmxlX2JpdHMgPSBlbmFibGVyICYgcGVuZHI7DQo+ID4gKw0KPiA+
ICsgLyoNCj4gPiArICogT3B0aW1pc2F0aW9uOiBwZW5kaW5nIGFuZCBlbmFibGVkIHdpdGggbm8g
YWN0aXZlIHByaW9yaXRpZXMNCj4gPiArICovDQo+ID4gKyBpZiAocG9zc2libGVfYml0cyAmJiBw
cmlvcml0eV9tYXNrID4gMHgxZikNCj4gPiArIHJldHVybiB0cnVlOw0KPiA+ICsNCj4gPiArIGZv
cl9lYWNoX3NldF9iaXQoaSwgJnBvc3NpYmxlX2JpdHMsIDY0KSB7DQo+ID4gKyBzdHJ1Y3Qgdmdp
Y19pcnEgKmlycTsNCj4gPiArIHUzMiBpbnRpZDsNCj4gPiArDQo+ID4gKyBpbnRpZCA9IEZJRUxE
X1BSRVAoR0lDVjVfSFdJUlFfVFlQRSwgR0lDVjVfSFdJUlFfVFlQRV9QUEkpOw0KPiA+ICsgaW50
aWQgfD0gRklFTERfUFJFUChHSUNWNV9IV0lSUV9JRCwgcmVnICogNjQgKyBpKTsNCj4gPiArDQo+
ID4gKyBpcnEgPSB2Z2ljX2dldF92Y3B1X2lycSh2Y3B1LCBpbnRpZCk7DQo+ID4gKyByYXdfc3Bp
bl9sb2NrX2lycXNhdmUoJmlycS0+aXJxX2xvY2ssIGZsYWdzKTsNCj4gPiArDQo+ID4gKyAvKg0K
PiA+ICsgKiBXZSBrbm93IHRoYXQgdGhlIGludGVycnVwdCBpcyBlbmFibGVkIGFuZCBwZW5kaW5n
LCBzbw0KPiA+ICsgKiBvbmx5IGNoZWNrIHRoZSBwcmlvcml0eS4NCj4gPiArICovDQo+ID4gKyBp
ZiAoaXJxLT5wcmlvcml0eSA8PSBwcmlvcml0eV9tYXNrKQ0KPiA+ICsgaGFzX3BlbmRpbmcgPSB0
cnVlOw0KPiA+ICsNCj4gPiArIHJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZpcnEtPmlycV9s
b2NrLCBmbGFncyk7DQo+ID4gKyB2Z2ljX3B1dF9pcnEodmNwdS0+a3ZtLCBpcnEpOw0KPiA+ICsN
Cj4gPiArIGlmIChoYXNfcGVuZGluZykNCj4gPiArIHJldHVybiB0cnVlOw0KPiA+ICsgfQ0KPiA+
ICsgfQ0KPiANCj4gU28gd2UgZG8gdGhpcyBzdHVmZiAqdHdpY2UqLiBEb2Vzbid0IHN0cmlrZSBt
ZSBhcyBiZWluZyBvcHRpbWFsLiBJdA0KPiBpcw0KPiBhbHNvIG5vdCBjbGVhciB0aGF0IHdlIG5l
ZWQgdG8gcmVzeW5jIGl0IGFsbCB3aGVuIGNhbGxpbmcNCj4ga3ZtX3ZnaWNfdmNwdV9wZW5kaW5n
X2lycSgpLCB3aGljaCBjYW4gaGFwcGVuIGZvciBhbnkgb2RkIHJlYXNvbg0KPiAoc3B1cmlvdXMg
d2FrZS11cCBmcm9tIGt2bV92Y3B1X2NoZWNrX2Jsb2NrKCkpLg0KDQpBcyBJIHNhaWQgYWJvdmUs
IHRoZSBwcmlvcml0eSBzeW5jIG5vdyBoYXBwZW5zIG9uIHRoZSBlbnRlcmluZyBXRkkgcGF0aA0K
aW4gdmdpY19wdXQoKSwgd2hpY2ggc2hvdWxkIGJlIGEgbGl0dGxlIGJldHRlciwgYW5kIG9ubHkg
c3luY3MgdGhlDQpwcmlvcml0aWVzIGZvciBQUElzIHRoYXQgYXJlIGFjdHVhbGx5IGV4cG9zZWQg
dG8gdGhlIGd1ZXN0Lg0KDQpJIHRoaW5rIHRoYXQgdGhlIGNvZGUgaGVyZSBsb29rcyBhIGxpdHRs
ZSB3b3JzZSB0aGFuIGl0IGlzLiBXZSdyZQ0KZmlsdGVyaW5nIGJ5IGVuYWJsZWQgaW50ZXJydXB0
cywgd2hpY2ggaXMgYWxyZWFkeSBwcmUtZmlsdGVyZWQgYXMgd2UNCm1hc2sgZ3Vlc3Qgd3JpdGVz
IHRvIHRob3NlIHdpdGggdGhlIG1hc2sgb2YgZXhwb3NlZCBQUElzLiBJbiByZWFsaXR5LA0Kd2Ug
c2hvdWxkIG9ubHkgYmUgY2hlY2tpbmcgdGhlIHN0YXRlIGZvciBhIGZldyBQUElzIGhlcmUuDQoN
CkFsbCB0aGF0IHNhaWQsIEknbGwgc2VlIGhvdyBJIGNhbiByZWR1Y2UgdGhlIGltcGFjdCBvZiB0
aGlzIGZ1cnRoZXIuDQoNCj4gDQo+ID4gKw0KPiA+ICsgcmV0dXJuIGZhbHNlOw0KPiA+ICt9DQo+
ID4gKw0KPiA+IMKgLyoNCj4gPiDCoCAqIERldGVjdCBhbnkgUFBJcyBzdGF0ZSBjaGFuZ2VzLCBh
bmQgcHJvcGFnYXRlIHRoZSBzdGF0ZSB3aXRoDQo+ID4gS1ZNJ3MNCj4gPiDCoCAqIHNoYWRvdyBz
dHJ1Y3R1cmVzLg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0K
PiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBpbmRleCBlNTM0ODc2NjU2Y2E3
Li41ZDE4YTAzY2MxMWQ1IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBAQCAtMTE3NCwx
MSArMTE3NCwxNSBAQCBpbnQga3ZtX3ZnaWNfdmNwdV9wZW5kaW5nX2lycShzdHJ1Y3QNCj4gPiBr
dm1fdmNwdSAqdmNwdSkNCj4gPiDCoCB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+IMKgIHN0cnVj
dCB2Z2ljX3ZtY3Igdm1jcjsNCj4gPiDCoA0KPiA+IC0gaWYgKCF2Y3B1LT5rdm0tPmFyY2gudmdp
Yy5lbmFibGVkKQ0KPiA+ICsgaWYgKCF2Y3B1LT5rdm0tPmFyY2gudmdpYy5lbmFibGVkICYmICF2
Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpDQo+ID4gwqAgcmV0dXJuIGZhbHNlOw0KPiA+IMKgDQo+ID4g
LSBpZiAodmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3YzLml0c192cGUucGVuZGluZ19sYXN0KQ0K
PiA+IC0gcmV0dXJuIHRydWU7DQo+ID4gKyBpZiAodmNwdS0+a3ZtLT5hcmNoLnZnaWMudmdpY19t
b2RlbCA9PSBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUpDQo+ID4gew0KPiA+ICsgcmV0dXJuIHZn
aWNfdjVfaGFzX3BlbmRpbmdfcHBpKHZjcHUpOw0KPiA+ICsgfSBlbHNlIHsNCj4gDQo+IERyb3Ag
dGhlICdlbHNlJy4NCg0KRG9uZS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+ID4gKyBpZiAo
dmNwdS0+YXJjaC52Z2ljX2NwdS52Z2ljX3YzLml0c192cGUucGVuZGluZ19sYXN0KQ0KPiA+ICsg
cmV0dXJuIHRydWU7DQo+ID4gKyB9DQo+ID4gwqANCj4gPiDCoCB2Z2ljX2dldF92bWNyKHZjcHUs
ICZ2bWNyKTsNCj4gPiDCoA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMuaA0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gPiBpbmRleCA1YTc3MzE4
ZGRiODdhLi40YjNhMWU3Y2EzZmI0IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy5oDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gPiBAQCAt
Mzg3LDYgKzM4Nyw3IEBAIHZvaWQgdmdpY19kZWJ1Z19kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSk7
DQo+ID4gwqBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvICppbmZv
KTsNCj4gPiDCoHZvaWQgdmdpY192NV9zZXRfcHBpX29wcyhzdHJ1Y3QgdmdpY19pcnEgKmlycSk7
DQo+ID4gwqBpbnQgdmdpY192NV9zZXRfcHBpX2R2aShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUz
MiBpcnEsIGJvb2wgZHZpKTsNCj4gPiArYm9vbCB2Z2ljX3Y1X2hhc19wZW5kaW5nX3BwaShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X2ZsdXNoX3BwaV9zdGF0ZShz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X2ZvbGRfaXJxX3N0YXRl
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ID4gwqB2b2lkIHZnaWNfdjVfbG9hZChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpOw0KPiANCj4gVGhhbmtzLA0KPiANCj4gIE0uDQo+IA0KDQo=

