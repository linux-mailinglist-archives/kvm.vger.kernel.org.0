Return-Path: <kvm+bounces-67364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EA06DD0280C
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FA1F30EAAC3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1912C44303A;
	Thu,  8 Jan 2026 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VFSEs3wC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VFSEs3wC"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012062.outbound.protection.outlook.com [52.101.66.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CF24383B8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 09:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767866155; cv=fail; b=cNQ7D9J2SF76pwSfWRUgrq4kn5CmOZMg17p1seSkGa0fkubLIxr4ako3urPoNHcq9TIEEC0pbMQ6RPfzDyN47THJLx1ksZRLAfIfxrwi4ZlnLK9Tp0iKPHUjMZlJyGoU9g3eGAIDe05/dFoFr5lyW56csmZRYje2p0cGAragZ3c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767866155; c=relaxed/simple;
	bh=MAu1Dn/bm3+J4fPsA1ta5md2/e0e7aYW1dXuqIbgaA8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QADpDTv7W5F/bZmFS+ju8VrGG70WL74EBhiVd7OT6AiFssjsXKplMXFjYG7wIT9lLg/Kbk+jst82uGoQYKxHMNoCBItufQ0TNOyh9a3wjqitprI8Wb2npGVJTKSc4vdl9fegAROmfKQoC3YXjr3oD/bmXbIykcnQ8MRVTI2XDv8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VFSEs3wC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VFSEs3wC; arc=fail smtp.client-ip=52.101.66.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vGBpGew/0nuysYqWpUlrmLFYbq42e3JYdLZdaoBDPgO+kn5dERlvimuOod6oqELKQEvGEU0E0AVHqmxKKJ5KCg1WJErePK6dwK6Tj+j9p02e59jAcbXuKUN6A8t/hoCW7znbWaSR7LhHsqeZAR4FoF9/EuueLkubp5rGY7IDhwn8yuK2l2qrKneF1ZISNtAHrqlnBXTUfOhpASIm3RpuOKUP2K9iJ7tJN12irQprQ6wJGWU5uycU/OZAuz32xRvkxw/qu9tZomPvhcaizVSUdLLg32emZlpZ1Qxj/sXVDtFcAYhxihPki61m+QGxErr9kvyfD02fskys2imQ+wa6+Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAu1Dn/bm3+J4fPsA1ta5md2/e0e7aYW1dXuqIbgaA8=;
 b=yW0OI6MLpEyl3c7n+xMcCKd/okiFtv/B6IwU0I0TohOnu+4cAGnkLWKq1yZzcI1ex2FMNGiMGHpiPmwTnDnoee0Fqot+LTimqlRTikSsnl9CuQqhNEdNYf5PU67vtgWS3Iqf4YsZaLXTCbOtWH/OcnFT96Mj375ML0L1Bs252FDgl0qfrGks+UdwuTe1WRohGOG6N+b90It0obTU2ACY6Pvg9Svs8xezz5gpr8BDq2JIOUKMb5JVMt1GZBlY2LGZvalXYbNBz0e87off+FHsj4b6Kyvo5B1vBG5dq+a/X047xh8sfiyEeWpluVsKvwwBn9JkMP+U3jg8DTBio5wOQA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAu1Dn/bm3+J4fPsA1ta5md2/e0e7aYW1dXuqIbgaA8=;
 b=VFSEs3wC8rJyRmX5VLBm/bkESGk3ucMiLgjiR+FMV3lsr20wAWrgkHws6fzbOjtaE802I1B9BlKWvVudEoEZBZh5SgD89mwpf3QPclF8vaxzDLCZExC8cnbrJ0gwAA757sr3dCipDilEB3+dD8UKrZ3APwLUaiWc38ofNjBeU2Y=
Received: from DB3PR08CA0005.eurprd08.prod.outlook.com (2603:10a6:8::18) by
 PR3PR08MB5754.eurprd08.prod.outlook.com (2603:10a6:102:91::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Thu, 8 Jan 2026 09:55:37 +0000
Received: from DB1PEPF000509E8.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::9d) by DB3PR08CA0005.outlook.office365.com
 (2603:10a6:8::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 09:55:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E8.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 09:55:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYa7rIsUx/nQBGMhJElw+XaYlMaTAjEY+L6uDotGr5vJtg0CjnmpO57mwUquEqFrajQcPTFjpDZ7PFqGhzznHyG8fDReTHvy4r8//b+6+y+x+Ag9QxbtB7NfBSLzSywuYt0EDYSI/jI3cSf9f7uPz8Zwas1X4I+qSCVE4bafjBw1iBsLxIn//eBxySrwUEtIvjYPH+7b4C/pHsyp1V4BVkhMvshSChtU8XDrAImZwC/BvJLTHt9KHAJawArw1kgYvi1si1vrOR98efTKtdhnTjMB7P85Ez3rOwTbc3h3kNDqCXM7P4C62BLoPjrd1fsnN5SAcYy69GlX/BaTEtgZtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAu1Dn/bm3+J4fPsA1ta5md2/e0e7aYW1dXuqIbgaA8=;
 b=OXVFTxVIfYy1tdCjUYRE6GfP0QEP9YfdFCFy+8GpxDOMJ/MF5ZKwSoOa8ydY0r8zie3EB2DNL+mpsTLOuz/W6NQtGGfadoNVfGEBe2WBGhYGsd9weWXtvVzO9GnSb5mtV1q58tz5he8sDm6wWkvGz5gqLymWenhw4iIOiH/3vmcbZDYqczeV0OmchV4c5XsPtDa/71sTv/guKBfMgehVRVl/HEmyCq9WVcLN48vVqqNQdB+xGXTs1Y7FRAav0FEwX7aAflX7otqGaM2ucBA6ukLI0EYb/TwnmH60naAjvCxlAP7ZRwxqo9P8Dc/IJvg7w8sg8WgLgc9bBzKK4Vz4cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAu1Dn/bm3+J4fPsA1ta5md2/e0e7aYW1dXuqIbgaA8=;
 b=VFSEs3wC8rJyRmX5VLBm/bkESGk3ucMiLgjiR+FMV3lsr20wAWrgkHws6fzbOjtaE802I1B9BlKWvVudEoEZBZh5SgD89mwpf3QPclF8vaxzDLCZExC8cnbrJ0gwAA757sr3dCipDilEB3+dD8UKrZ3APwLUaiWc38ofNjBeU2Y=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB9364.eurprd08.prod.outlook.com (2603:10a6:20b:5ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 09:54:33 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 09:54:33 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 10/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v2 10/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHccP+A2Tk0cVHCD0G6AA5H+3aHGbVGpv6AgAGAlgA=
Date: Thu, 8 Jan 2026 09:54:33 +0000
Message-ID: <66960fc2d53ac7dab5396ba76e2e2b80faae565d.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-11-sascha.bischoff@arm.com>
	 <20260107105803.000050be@huawei.com>
In-Reply-To: <20260107105803.000050be@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB9364:EE_|DB1PEPF000509E8:EE_|PR3PR08MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d223b4f-f0d0-411c-ce2d-08de4e9c12da
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cTdDRDhJNEs2amJGcFdhQ3BBQlJHS0tBSlh5OVNWcXFMcDN5Q0Y5SE5SMktt?=
 =?utf-8?B?TzRDVmtudVZSb290T0R5Wnhld1AyNGYvaVdlck5iZkpEMUF2SlR1Tm5oS0da?=
 =?utf-8?B?cWpveDZkRVRLV0tydm8rV044dDU4a01Vd0RER1d0bHVCUlVQZnR0MWwrRDdQ?=
 =?utf-8?B?SytsZFdIWUNOR2xDTUJDa1FGbjdyZkVaTUJ4Vm42NTJ3T2RTMGdIR0hpWmZS?=
 =?utf-8?B?RU1mVkF2K0RiMzFKeC9HWklaSVlra3o2Zm85SlYrQm1CQWM3aEdPc1ZTQXNx?=
 =?utf-8?B?UXZ3L3p0ZWppalVhcEZ3V2FFaGtEbW5CNEVUaFZIZk1kMUIySFZyZnErSkpE?=
 =?utf-8?B?MzNBWjI1RVJGbGZYYjlUWlRTNlU4Zk9NY3NzWFU3YU5USE1sNEZSWG5JelVX?=
 =?utf-8?B?Y01QOTdXY1kyMU5MS0hhQ0JrUXl5TkRZQW9uQWFyTUNiazc1anI5QUMxcExV?=
 =?utf-8?B?MlArVlloWmtlMjJFNzFNOWtwVDZRUGtiSDNScmxQVmtTVkljT1htNnVBMG9t?=
 =?utf-8?B?RUVOQTlneFpkT09HcXBmMFpadnE1M1dIakdhM2NtSndQeUNmVFY0VC9MaUQr?=
 =?utf-8?B?Qmk0bThOUVo5ckJHK3VJMExDTmltREJ3ZWdYQ1dLQ2hJN2ZzcTJuYm1tMVpm?=
 =?utf-8?B?eStQYVdacXZxbnZ3Y1dVRVVOQXRzdGxKdWdKRURHWlY2MEJldXlZSmZGOEJW?=
 =?utf-8?B?MDdMVEFTTXpOcVVsV3AzNCsxNnRnU0xhMENEWlpDV1c3S0NSclBBeGZITE5o?=
 =?utf-8?B?WTRsK2NCaUwrcnZoWFlBQkRZVDgrYmlZb2lvSjl4T3pxbHpkdEo0dEUrSHFM?=
 =?utf-8?B?QXBBbVJnZGFBYzU1OUUwOTkzeEpTT0YyTitJNDFCdmZ4cUZxYXE2dUs5THla?=
 =?utf-8?B?RWxJUzlqVngreSt0NVdIdmdvQkFkK05jdlB6UG1UU0Nsb052c1FsL0lFbVVs?=
 =?utf-8?B?UGs2QmVVZE04eXovdkRZUFJ3dC9jcW9wbjlGRnNqZGEvYXZOU3QrSGt4Y09M?=
 =?utf-8?B?T3p3dEg2WXI1Rkk0eThJY2RocUJTMjBKT2p2L1BHT0VaSWtCM2dNVWxJK1pv?=
 =?utf-8?B?KzVuT084ak5mS0pwTHEyRm11eXNxVkRaSStsMHFyU25BVnZBVi9qZjZsQjdw?=
 =?utf-8?B?aHpDMzBxRUpmeDJzaktNVGJQOEY5SDVmRStyb1lNWCtEK0lBOWhXYWk0VURa?=
 =?utf-8?B?TkhhNkgrSmN0SnhjSE1sbW80RmRyOVh0b3cwS1dvTUFQYUNCUU9Fa0taWHFK?=
 =?utf-8?B?TGsvSGJMZ3VhN1pJUUp1RXoyd0l1emZFWURPalJlcHRWeTRiejRWaCtVOGQ4?=
 =?utf-8?B?SGtybVl2N2Jub0d4OWN3N2x5YlZVYnJ1eXNIeDg5eWxxOGcrVTBVZFJpNGtR?=
 =?utf-8?B?bHpjczF4ajlaTEhuU3duY3BDNTdoMVpSeklWaFBPdzhKK0VTVWN0dFZSSjdG?=
 =?utf-8?B?R3NmSUtjbDA4TkZVVEFNL01Jam5FQU05dGcwcXQ4WFM2L0tlN1Z3Um1xZzRt?=
 =?utf-8?B?Y2kwRGI3cm1TYXpkbWtycWhjWEQ5K3dnVGQvdVlxckZIMlRQeFVWR2Fwb04w?=
 =?utf-8?B?SWg0UXlTaDRCSXkxWldUUlFDbkp1UUQ2eTZnY1c4akZ5QlNlZmZiUDh1dThF?=
 =?utf-8?B?aUdqTDFFelluemVySFNXcVVHODF2cmNwM0lpZFhkdkh3RVNIeHVJQzBIYmVl?=
 =?utf-8?B?VXkyZE9OdE43VWpxZDFSL1ZIeThwSmJROHo5VjRjczVDSnFETTJ5b3BjQkZ0?=
 =?utf-8?B?MXFMRVpMMkQ5ZnZndk1pckdnV3l2TkJlenNWRHZYN0tZK1VHZ2Nxa1JDdTZr?=
 =?utf-8?B?TmlMNDlUVkxMaUJTeTcyRmhxem44NlFwOWlmWnpXRUNMNlZYMXc4ZkNWTTZo?=
 =?utf-8?B?NjZYMTBYVHlocDBHOEJSTFhETy9INVM2dVdTc1FQRG52aWpUYW1HZzdVaFRJ?=
 =?utf-8?B?UXpPZmd3Yk9DaW9ULzBPVXlYL01uZktLVmJPbCtoemRBa0NKOGdxUkxzcmRY?=
 =?utf-8?B?UUVHR3ptYm9EQlI3UU1TVjF0TUZ6bDF3Z2V1WWpTZmlGVFRNbitBS0ZXRERo?=
 =?utf-8?Q?rxxLNL?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <20885025D6294B47810834BD8298EEDF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9364
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aefe7063-f7d7-4b7a-2246-08de4e9becc5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|14060799003|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K29nRnl1L0ZUL282ZGdCYnhsb1FGU2RDM0txQmtza1lkeWozSUY2M1hmc2xC?=
 =?utf-8?B?b2lmazlBZnRaS21yRFhFYkRMT1VhSEpPekh3amhnOEpNWU1kRW9wejVudkdx?=
 =?utf-8?B?T2Q2YW1vNnYvY1UweWxTdHk1UE1YK2g2U3ZxelRVc2w4TVp0ZllzTm0wV0gw?=
 =?utf-8?B?b3pPU3NnKzlLZEhUSTQrem1QSkR2YzRpVHFRcUl5Yjk4aDhKV2tVWTJKZitE?=
 =?utf-8?B?SFM4K04rbjZDTktkR2NSRmtneGxaYjlWMk9qNERtKzZkZmk5dlk2Y1ZpK3NQ?=
 =?utf-8?B?aFVocDJZYmtnV2lwanppaUNaNGdHeFhESGtlaW5WdnpYdTBOeWZWc1l1czRa?=
 =?utf-8?B?MWR4bmhuRnhnZ2JuS2IwRmpRcDMzSTl2OWlYMFNqWFBBSzRLRzV4R0x1ZkRt?=
 =?utf-8?B?cDhkQjlLRXJIMjRaK2o3NzVmMTVVQ3cxRHpHbmk5ckRQL0ZxYXVpbXVmMzRY?=
 =?utf-8?B?NVh2cFFHSk1kTndMMkdjOVk1Q0s1SXR0d24vT3ZGME5LaDd2L05YYmtSYU9R?=
 =?utf-8?B?eXJvNTFqZkNGMVpzY3lTY1ZqM2VXZEZOb0pqcG1YbkV6cGVLYmJ0dXdCekEz?=
 =?utf-8?B?Z3JWNFlpRWIxZDNKMTA3OGtGbWsyaDFDR1dybVBhL1lpR0NWYzhDdytVN3Ay?=
 =?utf-8?B?Q2ZCdlhkRDdwdzJGTjhoNlkxMEZwSGJuaUMrdUxKZFQ3YkZtdWVscTBtZUFz?=
 =?utf-8?B?OUs2aHVJNWxCR3MrZko3aXk2aTE1Z0Q4Z0pnemhTUHRXRDlONlpJYUVnSEJH?=
 =?utf-8?B?RVlmYU8wajNwRTlHYnFmQW9raFRSQkZtbWJoR0VEZGdoWFhzTXZ1Y0V6SlBK?=
 =?utf-8?B?SGVNT0EzcXRoQ0krL2lOa3RtTzJJZ2d5VkhDbWtKSVArRzM5VUM1ZDFYcHQ4?=
 =?utf-8?B?U004UlNIYjM0UnI0c2xydGpLVXFMemdVSXR4Vlk1NEFacDB2ZGdBa0lCSE0y?=
 =?utf-8?B?ejZ4UzI4aWk3ZENKV2pyUnR3Zm91eVpUeWJuMWhwenloSFVtUHFGejlNa2pR?=
 =?utf-8?B?bys0NGxuS2tPMHRtdnkxS3BNODlPbWd6c0Q3MGE1TUlQS1pUTElvZnRPM1lx?=
 =?utf-8?B?cHhHWWtFS1lPTFZ5bytNcEtjYWlVWEk5YzhxYXBQdGVDOHBnK3VxajQ2NkVS?=
 =?utf-8?B?OU5BQ2pWQlllM2dsVFFNVytpbG9Eb25PSlhLQk5UTTh2d0pRRGg3UUFJTEpB?=
 =?utf-8?B?ajdrajZDd2Q5NTlJZy9PQXBXQzhNYU5LY2U5bG9DcUJwcTZMQVgrbXJEelN1?=
 =?utf-8?B?QUlEU0piaUkrZXdnTHBreEhIRFUzNVBjSjU1MU5aZG01dDBKd2Y3M0JNemlL?=
 =?utf-8?B?M3ZwckpBaVVDcjBKMUIra2V2Tk12STBVVm0yMEN1TUpjdms1b05UbC9DTHps?=
 =?utf-8?B?cUZ6TUo1Uk4ySlFic1JNNUkwenVjTXkxNVlFNGVUNGNCekl0WEtreVQvWVZW?=
 =?utf-8?B?UnJ4dExydDArOW1BTDFFaTNiU254NDBBSGRGb0I4V015YksvYmJiQWVtS1ZZ?=
 =?utf-8?B?WEhtL2llYkNBZHFVQWlUVkpPL29SZ1BCZEhzMHpaTy9CdTg2ZHpsNkFVOGt6?=
 =?utf-8?B?NEh3cWNDY2dMT1Zudy9Eb0hMZk96QkwzNG03ekduODRTQWVqUXNuUkxVTlRL?=
 =?utf-8?B?bktFNzhQaS9EM0VwMUFsOEpKa1hyUUhVVldteTZJOFM4Snl6Y0NXUWhySTNa?=
 =?utf-8?B?VzhNOEpESzRVMmpOL1VLWUpta0plWnJZYjBWNkN6QzRBZnV2cWg5bDJDc1ZT?=
 =?utf-8?B?VU9Tekc4N0E4NldVM280RUl5MktrcFRqU0VPTm9sdXd6NE4rOHU0WXRPUys3?=
 =?utf-8?B?UjlKZ3dUVmVBeHFWa3l4ajNCWmFtek9VcE9WSU5OQWZYMDB5UUdMbGdtNzM2?=
 =?utf-8?B?Z2VjT2x3VHNqazMwOFFqUFltRzR0SW1lTzBxUVBJZTlEaVhUSjZwakRiWFVM?=
 =?utf-8?B?aEwzMjlueFVTU2c0bjd4L1FqWk5YUWg3Y1ZqL2JmRXVlVzdETlJQK21oT2sz?=
 =?utf-8?B?cFU0VFRmWldNMEdkLzRTRUVrNWdRV2ZSSmtrWmxpdTY3S2pDd2JlclFiMjBO?=
 =?utf-8?B?QnJlamcxVktYNUlPV0g3bEVlWWREQWpaUU1mTW9vWmF4K1ZNMWcrV0I3NkdH?=
 =?utf-8?Q?MoHA=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(14060799003)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 09:55:37.0296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d223b4f-f0d0-411c-ce2d-08de4e9c12da
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5754

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEwOjU4ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM5ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBTZXQgdGhlIGd1ZXN0
J3MgdmlldyBvZiB0aGUgR0NJRSBmaWVsZCB0byBJTVAgd2hlbiBydW5uaW5nIGEgR0lDdjUNCj4g
PiBWTSwNCj4gPiBOSSBvdGhlcndpc2UuIFJlamVjdCBhbnkgd3JpdGVzIHRvIHRoZSByZWdpc3Rl
ciB0aGF0IHRyeSB0byBkbw0KPiA+IGFueXRoaW5nIGJ1dCBzZXQgR0NJRSB0byBJTVAgd2hlbiBy
dW5uaW5nIGEgR0lDdjUgVk0uDQo+ID4gDQo+ID4gQXMgcGFydCBvZiB0aGlzIGNoYW5nZSwgd2Ug
YWxzbyBpbnRyb2R1Y2UgdmdpY19pc192NShrdm0pLCBpbiBvcmRlcg0KPiA+IHRvDQo+ID4gY2hl
Y2sgaWYgdGhlIGd1ZXN0IGlzIGEgR0lDdjUtbmF0aXZlIFZNLiBXZSdyZSBhbHNvIHJlcXVpcmVk
IHRvDQo+ID4gZXh0ZW5kDQo+ID4gdmdpY19pc192M19jb21wYXQgdG8gY2hlY2sgZm9yIHRoZSBh
Y3R1YWwgdmdpY19tb2RlbC4gVGhpcyBoYXMgb25lDQo+ID4gcG90ZW50aWFsIGlzc3VlIC0gaWYg
YW55IG9mIHRoZSB2Z2ljX2lzX3YqIGNoZWNrcyBhcmUgdXNlZCBwcmlvciB0bw0KPiA+IHNldHRp
bmcgdGhlIHZnaWNfbW9kZWwgKHRoYXQgaXMsIGJlZm9yZSBrdm1fdmdpY19jcmVhdGUpIHRoZW4N
Cj4gPiB2Z2ljX21vZGVsIHdpbGwgYmUgc2V0IHRvIDAsIHdoaWNoIGNhbiByZXN1bHQgaW4gYSBm
YWxzZS1wb3NpdGl2ZS4NCj4gPiANCj4gPiBDby1hdXRob3JlZC1ieTogVGltb3RoeSBIYXllcyA8
dGltb3RoeS5oYXllc0Bhcm0uY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRpbW90aHkgSGF5ZXMg
PHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hv
ZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiBIaSBTYXNjaGEsIFRpbW90aHkNCj4gDQo+
IFRoZSBtYXNraW5nIG9mIHZhbCBoYXMgbWUgYSBsaXR0bGUgY29uZnVzZWQgaW4gdGhlIHNhbml0
aXplIGZ1bmN0aW9uLg0KPiBQcm9iYWJseSBuZWVkcyBhIHNsaWdodGx5IHJld3JpdGUuDQoNClll
YWgsIGFncmVlZC4NCg0KPiANCj4gSm9uYXRoYW4NCj4gDQo+ID4gLS0tDQo+ID4gwqBhcmNoL2Fy
bTY0L2t2bS9zeXNfcmVncy5jwqAgfCAzOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKyst
LS0tDQo+ID4gLS0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmggfCAxMCArKysr
KysrKystDQo+ID4gwqAyIGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDkgZGVsZXRp
b25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMg
Yi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+ID4gaW5kZXggYzhmZDdjNmExMmExMy4uYTA2
NWY4OTM5YmM4ZiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+
ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiA+IEBAIC0xNzU4LDYgKzE3NTgs
NyBAQCBzdGF0aWMgdTggcG11dmVyX3RvX3BlcmZtb24odTggcG11dmVyKQ0KPiA+IMKgDQo+ID4g
wqBzdGF0aWMgdTY0IHNhbml0aXNlX2lkX2FhNjRwZnIwX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsDQo+ID4gdTY0IHZhbCk7DQo+ID4gwqBzdGF0aWMgdTY0IHNhbml0aXNlX2lkX2Fh
NjRwZnIxX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gdTY0IHZhbCk7DQo+
ID4gK3N0YXRpYyB1NjQgc2FuaXRpc2VfaWRfYWE2NHBmcjJfZWwxKGNvbnN0IHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwNCj4gPiB1NjQgdmFsKTsNCj4gPiDCoHN0YXRpYyB1NjQgc2FuaXRpc2VfaWRf
YWE2NGRmcjBfZWwxKGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiB1NjQgdmFsKTsN
Cj4gPiDCoA0KPiA+IMKgLyogUmVhZCBhIHNhbml0aXNlZCBjcHVmZWF0dXJlIElEIHJlZ2lzdGVy
IGJ5IHN5c19yZWdfZGVzYyAqLw0KPiA+IEBAIC0xNzgzLDEwICsxNzg0LDcgQEAgc3RhdGljIHU2
NCBfX2t2bV9yZWFkX3Nhbml0aXNlZF9pZF9yZWcoY29uc3QNCj4gPiBzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsDQo+ID4gwqAJCXZhbCA9IHNhbml0aXNlX2lkX2FhNjRwZnIxX2VsMSh2Y3B1LCB2YWwp
Ow0KPiA+IMKgCQlicmVhazsNCj4gPiDCoAljYXNlIFNZU19JRF9BQTY0UEZSMl9FTDE6DQo+ID4g
LQkJdmFsICY9IElEX0FBNjRQRlIyX0VMMV9GUE1SIHwNCj4gPiAtCQkJKGt2bV9oYXNfbXRlKHZj
cHUtPmt2bSkgPw0KPiA+IC0JCQkgSURfQUE2NFBGUjJfRUwxX01URUZBUiB8DQo+ID4gSURfQUE2
NFBGUjJfRUwxX01URVNUT1JFT05MWSA6DQo+ID4gLQkJCSAwKTsNCj4gPiArCQl2YWwgPSBzYW5p
dGlzZV9pZF9hYTY0cGZyMl9lbDEodmNwdSwgdmFsKTsNCj4gPiDCoAkJYnJlYWs7DQo+ID4gwqAJ
Y2FzZSBTWVNfSURfQUE2NElTQVIxX0VMMToNCj4gPiDCoAkJaWYgKCF2Y3B1X2hhc19wdHJhdXRo
KHZjcHUpKQ0KPiA+IEBAIC0yMDI0LDYgKzIwMjIsMjAgQEAgc3RhdGljIHU2NCBzYW5pdGlzZV9p
ZF9hYTY0cGZyMV9lbDEoY29uc3QNCj4gPiBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB2YWwp
DQo+ID4gwqAJcmV0dXJuIHZhbDsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgdTY0IHNh
bml0aXNlX2lkX2FhNjRwZnIyX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4g
dTY0IHZhbCkNCj4gPiArew0KPiANCj4gVGhlIGNvZGUgZmxvdyBpbiBoZXJlIHNlZW1zIGNvbmZ1
c2luZywgc28gbWF5YmUgbmVlZHMgYSByZXRoaW5rIGV2ZW4NCj4gaWYgaXQNCj4gd29ya3MuwqAg
RmVlbHMgbGlrZSB3ZSBuZWVkIGEgbWFzayBmaXJzdCBvZiBldmVyeXRoaW5nIHRoZSBrZXJuZWwN
Cj4gdW5kZXJzdGFuZHMsDQo+IHRoZW4gc3BlY2lmaWMgbWFza2luZyBvdXQgLyBzZXR0aW5nIG9m
IHBhcnRzIGZvciBlYWNoIGZlYXR1cmUuDQo+IEknbSBub3Qgc3VyZSBpZiB0aGUgaW5pdGlhbCBt
YXNrIGlzIGhhbmRsZWQgYnkgdGhlIGNhbGxlciAoZGlkbid0DQo+IGNoZWNrIGJ1dA0KPiBpdCdz
IGluIHRoZSByZWdpc3RlciBhcnJheSBzdHJ1Y3R1cmUpLg0KPiBBbHNvIEkgbG92ZSBjcm9zc2lu
ZyBzcGVjcyB3aGVyZSB0aGUgZ2ljdjUgc3BlYyBzYXlzIGFsbCB0aGUgb3RoZXINCj4gZmllbGRz
IGFyZQ0KPiByZXNlcnZlZCBhbmQgdGhleSBhcmVuJ3QgYW55IG1vcmUuwqAgV291bGQgaGF2ZSBi
ZWVuIGJldHRlciBpZiB0aGF0DQo+IGhhZA0KPiBqdXN0IHNhaWQgc2VlIGFybSBhcm0gZm9yIHRo
ZSBvdGhlciBwYXJ0cyBvZiB0aGlzIHJlZ2lzdGVyLg0KPiANCj4gPiArCXZhbCAmPSBJRF9BQTY0
UEZSMl9FTDFfRlBNUiB8DQo+ID4gKwkJKGt2bV9oYXNfbXRlKHZjcHUtPmt2bSkgPw0KPiA+ICsJ
CQlJRF9BQTY0UEZSMl9FTDFfTVRFRkFSIHwNCj4gPiBJRF9BQTY0UEZSMl9FTDFfTVRFU1RPUkVP
TkxZIDogMCk7DQo+IA0KPiBTbyB0aGlzIGVpdGhlciBtYXNrcyBvdXQgZXZlcnl0aGluZyBvdGhl
ciB0aGFuIEZQUk0gb3IgbWFza3Mgb3V0DQo+IGV2ZXJ5dGhpbmcgb3RoZXINCj4gdGhhbiBFTDFf
TVRFRkFSLCBFTDFfTVRFU1RPUkVfT05MWSBhbmQgRlBNUi4NCj4gDQo+IEhlbmNlLi4uDQo+IA0K
PiA+ICsNCj4gPiArCWlmICh2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpIHsNCj4gPiArCQl2YWwgJj0g
fklEX0FBNjRQRlIyX0VMMV9HQ0lFX01BU0s7DQo+IA0KPiBUaGlzIGlzIGRvaW5nIG5vdGhpbmcg
YXMgdGhhdCBmaWVsZCBpc24ndCBzZXQgYW55d2F5IGluIGVpdGhlciBvZiB0aGUNCj4gZWFybGll
cg0KPiBwb3NzaWJsZSBtYXNraW5ncyBvZiB2YWwuDQo+IA0KPiA+ICsJCXZhbCB8PSBTWVNfRklF
TERfUFJFUF9FTlVNKElEX0FBNjRQRlIyX0VMMSwgR0NJRSwNCj4gPiBJTVApOw0KPiA+ICsJfQ0K
PiA+ICsNCj4gPiArCXJldHVybiB2YWw7DQo+ID4gK30NCj4gDQo+IA0KDQpJJ3ZlIHRha2VuIHlv
dXIgYWR2aWNlIGhlcmUsIGFuZCB0aGUgZmxvdyBpcyBub3cgbXVjaCBjbGVhcmVyLiBUaGFua3Mu
DQoNCldlIG5vdyBmaXJzdCBhbGxvdyB0aHJvdWdoIGFsbCBGUE1SIGFuZCBNVEUqIGZpZWxkcywg
dGhlbiBmaWx0ZXIgb3V0DQp0aGUgTVRFIGZpZWxkcyBpZiBNVEUgaXNuJ3Qgc3VwcG9ydGVkLiBG
aW5hbGx5LCB0aGUgR0NJRSBmaWVsZCBpcyBzZXQNCmZvciBHSUN2NS1iYXNlZCBndWVzdHMuDQoN
ClNhc2NoYQ0K

