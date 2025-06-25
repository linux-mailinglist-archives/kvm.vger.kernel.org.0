Return-Path: <kvm+bounces-50604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D56AE747E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6767C192224D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEBB19CD1B;
	Wed, 25 Jun 2025 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="hC9AUGTb"
X-Original-To: kvm@vger.kernel.org
Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE6C194A60;
	Wed, 25 Jun 2025 01:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.214
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750816397; cv=fail; b=QbpJqQTHl1cyynE7uZi/I/TG9kBtGk0/VqZyvfdSiDczvdIULzClnGjx+/CtqqkP9t84oie4iqhJYNdTsnK4WAvSSbsPMcmgeUs2h/qIA5ZKuv+79RKjvjVqt6jW7g1IblVgZROqSxUuXxuxoxKPAMrMYGBLdGK3VOYllEE9dhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750816397; c=relaxed/simple;
	bh=jKi6ZiLPhGAu6r2tq1JpC9QoTTrHBPbMQWnJfZv5xl8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QPUII68Y+qsy37lCgo6mqmVuHm9igRDFV6O855gztNTEdy79SA5VMXjvk7IGO6b6CDL+LkxNltq6ILv5DJAILnIw2Ni0W5T5bCk3APEAaP28CxoxU4OmDMphzRz0Vr9zqKz5Pj8BeFmlWtZt18+pakTG1ZwUiHJJjG6W94IkM8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=hC9AUGTb; arc=fail smtp.client-ip=68.232.151.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1750816394; x=1782352394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jKi6ZiLPhGAu6r2tq1JpC9QoTTrHBPbMQWnJfZv5xl8=;
  b=hC9AUGTbaF0/6g0H2niATKUx2sAVlMzKdmWY9CMF89b0YcNQBW3i9tS3
   CcjJv31fPL+Pl+EvCZUdiGiZ6EsmMIjH8hK2PdGEPzHqIzj7OgfplyLA+
   ZiCdZ//IeHWVJLVbxFBY9bizJDvqXpQn2J7fxai+pfzRokdT+SA+F17FZ
   nMb9iwKs+JLmXzjLnvgsrSZzaCMZu3DYR4VCm63hBsHteJu3QfzHf/Xrb
   zLDF/PPkb6yLd5ZxGThcY2xhL+LeN4NTgH+QuGKQdTh4eQIc/BC7JG417
   8jrcZeL/Jk008Ans9lLNGYAP1jblsZTQF+sHI9o+KpGl2F/hMXyvdGi6Z
   Q==;
X-CSE-ConnectionGUID: 2Nrp1BkPQe2DN1b3TYIY4g==
X-CSE-MsgGUID: NZLstIbpTEOFodPMwDUpDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="72572165"
X-IronPort-AV: E=Sophos;i="6.16,263,1744038000"; 
   d="scan'208";a="72572165"
Received: from mail-japanwestazon11010030.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([52.101.228.30])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 10:51:56 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sYmIEVUTe6YC3utFEM44PNJBY9sWif2JaV3uxRui3ewDP6vomm0mlIJnkQhU0Xyf9pdIE7idkGnmQY6ceAHK52eeiIQJ2v3g0fBv3EDJKIrc1V8QIWTmY0/2g6ZK4VrKibtPoF7mKdOPP3jbdYEKChSzkOrHbepln7MtciQocSJNrHBxCa4UcdIX8f4kVuDSovPdamdCv7BoRco/ovBTws0sFJ9hvCa5kNOWWvHzYDvexb/gEUYN1Eo09LoaDL9GYVvdySBCHimpMVz9MpCUg3qRzGBdeW23JnsGQy9XnvKpYSiFJRNsxia6oVhQr6UbN3afVySyqZ5wUBrD5yISAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKi6ZiLPhGAu6r2tq1JpC9QoTTrHBPbMQWnJfZv5xl8=;
 b=fJXbygHelx+9qtdYbyluMQRLE64OtGINe/wp+1Ok2pCTE4hWqhRZ1ZTYA7uW+HqU6QRMuF818WnHQqDuo/0X4DX5vOz4gaQqM0GaFy6fUALhCCyyfh9zgnyZLUC2p+kk8i4cYVQTFTpUR0aaMLzOjtKaDmBoP9VcjN1ebxEGQvfNwmlKrMt1feprPcsAckPcaf1x4asdmSXS4OrZgAAaBvwW/RDj/sb6A/uv5VD7KA1oJOiD+Y2p04HXezNh2tGwSMi5hI9hY620pqBskZGZDZZxUNdJuu2r4Mye+JC30KOPPTe0AjEv56VhwE8mHUKPxd1r2cYgr4zc2oW3NDuKqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYXPR01MB1886.jpnprd01.prod.outlook.com (2603:1096:403:12::19)
 by TYWPR01MB9340.jpnprd01.prod.outlook.com (2603:1096:400:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 25 Jun
 2025 01:51:53 +0000
Received: from TYXPR01MB1886.jpnprd01.prod.outlook.com
 ([fe80::c110:9520:20ab:e325]) by TYXPR01MB1886.jpnprd01.prod.outlook.com
 ([fe80::c110:9520:20ab:e325%5]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 01:51:53 +0000
From: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>
To: 'Steven Price' <steven.price@arm.com>, "'kvm@vger.kernel.org'"
	<kvm@vger.kernel.org>, "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
CC: 'Catalin Marinas' <catalin.marinas@arm.com>, 'Marc Zyngier'
	<maz@kernel.org>, 'Will Deacon' <will@kernel.org>, 'James Morse'
	<james.morse@arm.com>, 'Oliver Upton' <oliver.upton@linux.dev>, 'Suzuki K
 Poulose' <suzuki.poulose@arm.com>, 'Zenghui Yu' <yuzenghui@huawei.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, 'Joey Gouly' <joey.gouly@arm.com>, 'Alexandru
 Elisei' <alexandru.elisei@arm.com>, 'Christoffer Dall'
	<christoffer.dall@arm.com>, 'Fuad Tabba' <tabba@google.com>,
	"'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>, 'Ganapatrao
 Kulkarni' <gankulkarni@os.amperecomputing.com>, 'Gavin Shan'
	<gshan@redhat.com>, 'Shanker Donthineni' <sdonthineni@nvidia.com>, 'Alper
 Gun' <alpergun@google.com>, "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
Subject: RE: [PATCH v9 00/43] arm64: Support for Arm CCA in KVM
Thread-Topic: [PATCH v9 00/43] arm64: Support for Arm CCA in KVM
Thread-Index: AQHb2r6F9hlypWnIW0m62NZE1x6lPLQTMfbc
Date: Wed, 25 Jun 2025 01:51:53 +0000
Message-ID:
 <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
References: <20250611104844.245235-1-steven.price@arm.com>
In-Reply-To: <20250611104844.245235-1-steven.price@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9N2Y3ZTgwOWMtZWY3MC00NjllLTk5OGMtYWE3M2EyYmU0?=
 =?utf-8?B?MmYwO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI1LTA2LTI1VDAxOjQ5OjQ0WjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYXPR01MB1886:EE_|TYWPR01MB9340:EE_
x-ms-office365-filtering-correlation-id: a1512951-a49b-4e0b-2b46-08ddb38adc24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?RXp2aXYxbnY1L2c0d2l6L09XNjVPQy94WTI0SUJDNjh6UEZtYk9UeUE0a1Vt?=
 =?utf-8?B?ZGRPTE1JUU5pQXVUWTdQSHJLeno0UzMvZWRLSmlFREJkdFo4MEZOK0xJV0xo?=
 =?utf-8?B?bHZ3aTVUczVNTTBpc3R4OGFnMTErdCt2djd0bnVjVTB1SWp4N2U0Y3NFdnFm?=
 =?utf-8?B?RGtxeWk4RVFPc2xpM25icTloVitvYzUrZG04N1NYeC9ySG9Rdk85MlhTZkx0?=
 =?utf-8?B?WDVBWVdvK09EZ28ybTRIWkN3L2N3OEFVNm4wZkcxd1JKd0ZJZ0VTa1BhUTlG?=
 =?utf-8?B?aXVNcmE5Y0pNSkVqeElMVXN6anBqTGNPQUVJSDE4NFF2YTBvQ2tad3REdmQ0?=
 =?utf-8?B?bHN3Z1h3bkVKS0syUkxwMm8vcHBJeFNEUjFmbG5JQS9qOVdMekNNVnU3RjRE?=
 =?utf-8?B?Rm9rWkRaNTVRMlJENVIwcGI1SnloMlNkRkl0Si9jWkpoZ3grdlhicVpub2Fp?=
 =?utf-8?B?Q1hScFdjK0lJTnEzb2xvVUc2aXlNSkplc3BHYkJUdmdMclNZaUFNMm1GRmZm?=
 =?utf-8?B?MG5HYXc1eUlCekhiOWkvQ1pHSS9MUjVFeHZKMWVuOWF2SSs1NDNybGYvWVNk?=
 =?utf-8?B?VkYxMHNhbW1WVVZmTi90VXJHRW43ekk0NThleHRtZ2VVaUlyQVJxMW53RXF4?=
 =?utf-8?B?RDdVMTNJcWdjSHI4aUQrQXJvLzlHNHBSYmtiOUttTVZ3WmJGVVI1WWNBcUt6?=
 =?utf-8?B?Wjd0YmQzMy9xMTAxTjh1NmQ1SmNod2lQTmNoais1MzlMMjh5RkZnY3krQS8w?=
 =?utf-8?B?c0lUK3kzU3Y0U1V1N01rcTBKOFpmaTFFWlJISXJDNWhKU1ppUTRjNkRxM3Jo?=
 =?utf-8?B?RGVaTVpHQVNUamdTWHdrS21EVHMvWWxsVWZsTHVYT2lpUzg5ZEJxZm0rVG9O?=
 =?utf-8?B?Z0RIMndXa3ZxL1l6UzBvTU16L3JVR2tmNit4NVE1UG9kdHJCd2U3Qjlxb3Ey?=
 =?utf-8?B?ajN0S0Jqa2hzMDByVlZYQkZOQXVnYlNxYkJKZzgzcDkxMU1YVzdPVm5mcXlm?=
 =?utf-8?B?NWN6MUFFdTdPZkJ2dXJSd3Y5T0xlK0xkUEJuTkdmdHkxdHVZR01XNlBRY1gw?=
 =?utf-8?B?aU9Wb0xWWmV4dkVMNU45K0xTZkNaeW9yN0YyTElSbnVrcDhPS1JEWW5LVEpa?=
 =?utf-8?B?YUhqdms1VVdGWW5wSjhnRk5ERFlzNjRTKzFMemgraEhLVEV3ZFNDeVRjOTJs?=
 =?utf-8?B?dHNON1B6Vmk3RERDU1VPaXc3YlZ5QjFiVGVGWXpHYmVHbEtmRFloTlJ6ZHEr?=
 =?utf-8?B?RnpjV3NjRGVOK1hZV1kra3ZSTDRFdkRUWXBjekU2YldINGt4SVdiQ3hkdEs5?=
 =?utf-8?B?bTdGUlRCM1FjVjNxZUh5UXJvYzVSWHl0VGpFckFPQVk0czlHTkFUMkpzT0Mx?=
 =?utf-8?B?Vlh0Q3g4aFlQajFyaGhYQnVYcGk1TU82TXJFc1pnMlM2TTloVVJXZmxpeitq?=
 =?utf-8?B?V1VFQWordGE0MnVrSGplNWFWY1RBU2lWMmJFckhYYjJVeWlxR3lCMWplQmtL?=
 =?utf-8?B?NkdJTVVsaldJS0drUTRiSjNNZ3NkRnJMa1l3QStRUFJNSmwxRWlJRC9GSjVD?=
 =?utf-8?B?cHJBT0ZpVUZ4b2RVdjY4Y3hqUUYwTFI4UjZtK1FHVGo2UkdRUTJBVk00RUsw?=
 =?utf-8?B?T3VWZHI4UG1NaW4xQXJuKy9aMDJSMCttU2NiMHFBZkczOXo0LysybllwWjEw?=
 =?utf-8?B?SjlzeDAyK1JwRnRNM1p3ckk4RXJqeXlRZmdtZzI1QTN6MmtRWWo3YUxPWURl?=
 =?utf-8?B?dDBobzVWYW9ISGdmVEZvR0ZPbktnUEhvZm5rT0dubnhmVjVXUkFQakZWMmE0?=
 =?utf-8?B?SDJUMStlK1NrOFRKaGQ5cCszRW1EL1AxeWVGbXhJRXVFbnZKM2hPUGtOUzBV?=
 =?utf-8?B?SHF6Q2ZBelBya29Nd1hWZ1Fpb283RXpiY3dkYWowZWowMVAwVmJ6aFp4TEdk?=
 =?utf-8?B?MGRrdzBNakNVNHkzeFZjVTVzRzZkeG93NjFOK0FjWnZsNTBsZGdHcGMySzds?=
 =?utf-8?B?c1ZFRlI4SEZiSFU2SUxDNUhSWTkyM08rNUo3RDdwMmE5aWVKbVhXdFp6T1Fx?=
 =?utf-8?Q?db1Tj2?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYXPR01MB1886.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MlU3anJnR1ZPSXZ5Uy9YN2d3UFpXamtYS2t5TzNaNmNubkQ2aEtKSWJIRVFv?=
 =?utf-8?B?dGNtdlRHaktoa2YzZWFjN200Y1FNbVZxT21XcUdyc1RBbVRjaVMxMWwzSWxa?=
 =?utf-8?B?d2twR0FHZDhuYUd1QTcwMDVKaGZMU2k1V0Z0dXBDNUhqQlhvQi9yUk9XSUt1?=
 =?utf-8?B?Tk9zbEpWYXMzTTV5Q253eVNyVUdTTU15eTk1RVdIZUhWTlhrNUtreG9rSDFu?=
 =?utf-8?B?YklZUncwTmRsNncxQjhqa2h1Y2JEc1VNVDM5OFh5c3BlL01JeDA2bWZXK3M0?=
 =?utf-8?B?WnEvdzVuRGlDRS9ITGZNcXdkYVhvNko1WmkwR2cwd0t5UVVuUGNUSys1cVBO?=
 =?utf-8?B?c1pCTXBseGZIaVhRTXZ6QTRVN0F1bDd4OFlkVDA0aUxGNnllMVVZYjhhWXVU?=
 =?utf-8?B?QVlIZFFlU2kzc2F4NVhZcE13NmpzQTNtTUtEWFBjU01iZFg0UDQvUHdlbWFp?=
 =?utf-8?B?bnhVY0cyVEtyNlA5Tk5zMmpmeGJMRCt0NVJoWFhDY1lySWR0QnNtdWoyTG5j?=
 =?utf-8?B?YWtMU0lNcnRuR2hGUVVteXR4Sm1abXQvOTRZalZtS1pJSnR2eXlsTlVmN1pV?=
 =?utf-8?B?WEhzaXdPY1dZSkk3cEs2ZWNJWFdWOWdSL1BrY2JpcFBKdStlTElYQkl3b0xq?=
 =?utf-8?B?K2U5L2Q4bzhnbWNZOXdsQkZDRmpTOHNEWWJJREJNVHJrOUllVlpzOTVjZ1Uv?=
 =?utf-8?B?VEdHUkhoY0J5aEJnSXNaMUU0dFU4aFhXd1FIMHVFcmlicWlMRzkyREhGVVlp?=
 =?utf-8?B?Z3k3bCtscWZkV1hsS2JjWFRGZlVLL21RcVlWOXFRR2pHMlZCU2g4YnBGZGxj?=
 =?utf-8?B?RkxQYzBzNWw0WU9rUXVHWHlPZ0p3Q0taelVVcGQwd3B5dEE0Q1F5dnhIUkJv?=
 =?utf-8?B?dG9KUi82M0IvU1JtWk9KbEhXR0ppc2lFTytDZDAzeUt2N1hKdkQ4Tk1DeXM2?=
 =?utf-8?B?dHVzNFRac1k1eGxiNlJQKzVWdkxuZTBjTUZVKzhVSHZiTUtWWDhMdEpLdUpD?=
 =?utf-8?B?ZENOV1ZQWTVWN1RBaDVBVHhGQmlKYkt3T2VGK2ZzbHA2cmFoUkFaZXUxS1A3?=
 =?utf-8?B?aG91NzRLeWhISEtJQnVISVFudndzWWxrM0kvc09YR0J0SjMwakl3M0Z4V2VJ?=
 =?utf-8?B?Ynh0SEpNeEgyR2FvVEs5aS92QVpMTUYrTGxjN0RRNnc5UFBLd3Zzb3hBTFN1?=
 =?utf-8?B?amRLVGZsbnRqVEJlejNpeHo0YTlYSVJia3NSYnZ6VEl0Yi9BWVRPdlpJUG5T?=
 =?utf-8?B?MzI1Sm1vM3AyS1FSNDhreXdtMXlJdTI0ZndYdExKdkNOWFJYbzJRcVl6ZjZv?=
 =?utf-8?B?d1pDRHdIZE9LakliSEgwNGZNTGdCSzlKZUY4bDdBSXJTK0tNVTUxRnJvM0Q3?=
 =?utf-8?B?UmNVTUhacGJQR1kxNmxHMC81Mkh5aThWWGRCZXc2RjlNTmh4Z2hLV0FMMTJO?=
 =?utf-8?B?ajlLWUNzTXlIakhoSGdpeUJBaXAyZmcyTFE0Q1ovQ2ZrVlpvdThLbFNYN2hX?=
 =?utf-8?B?UVIrTnM4MnA1WXUyZHNxWXpmNS9NMTU0M0RDc2ZmditHOWE5TS9ScERHeGV5?=
 =?utf-8?B?U0F1ZEg1czNFKzlrY09KVFIxK1Rac3NHQ21WOWNBZU5ya0V5RWNyUVNBUFJm?=
 =?utf-8?B?OEFPNFV0UCtvNSswZ0FNRGpONDBmYkM2ZXhvK1NxcXZuYzkzNXFhakQxdkZ2?=
 =?utf-8?B?OElFaHR2Nm4wN3FiRTQ5cUl1bEpTOE5FUFd2VjBTbDk2c3ZoUzVGSkllOGJ0?=
 =?utf-8?B?ekluK1NWc0dOaGN2V2g2ZWowTE1vbWFEb1hVQWVTSFdnVEw3K1hZM2lKQmQv?=
 =?utf-8?B?R1J5LzJUR1J5T3JUWXJPMm0wZjhsckpQVGZnZEZ5aTUzanhsSEQ3amVaNnls?=
 =?utf-8?B?RENvZzl1S0k5VUZvZ1JrSHhiZ3NnR01aQXRTNjlkTSs2NllzTEdDSTlmeXE5?=
 =?utf-8?B?dGZIaTBHT0JGeGx1SWc0VVJYYTV5NHJsNkkxRnAyZFNZZnRmaU1kRFA5TCt1?=
 =?utf-8?B?Vk14YTJwWEJISURCclZMaHhhZFl2N3NrOFRRR2l3Qkc3Mjkwd1dHK3lVTHNm?=
 =?utf-8?B?Z3NONDJBQWMxYVpiOHFzeExRQXUwa1dhMWNCbGFVOU9GK0xSdXZqaUNkTHJ2?=
 =?utf-8?B?cTc3TUJmVjRubTd0dzZWaTFRQVk2aStGYXhVVytXMVk5Z1hDRi9HREdyaitl?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vpw3Xuvo/AD6U+PxCoruoBoCCBjfUdMNBv4WtMHbKdyElklPMbAJqmE4S88e8o7jt2r8YKd6rnf+VOrZUcvlx2UFU42m3scNayeY/3Iq+mQCmv6/0JkzLQaDZLx6eyOIlkXkkjJkRidDlLQskjDhiHEXzpN1GF7S3QVg9wkxjkvZAsH3arql91DHZG/8dSJirjZ4e7HW8vU197boeT+PUFbeF9I68SlPVdDOM0jjmOhb5NGuXMXfo1cqMiVjG0oCoq2siutQiR7vpW5JKCjYstC0hxLW2nxfeWemczpg7yQhzVQVWohiY2i3yrt4mCkOLrZUp63pnCkkDct4kdeWHFXHwQ4IGSz9DjjiwR38wAkoPUFGPUnnER/bDs0gdc3bEDahva6GQh58Up50BAla2vhnA6a6E6+LHK4nIhPmrWNKUXmzR7qddnvzGSVu5mv7iJgbUvsWBOUDmtTqE6ba6e22ILVds6eqHo7QJExmA629xB4aeW9mS3R4Bzl4CC+fVnZb5FdwCS/N0wb6DZd10nbLBCA3HIVpALvFpqSiqSDxwDkUP8sz0Uwv3jxDcJ2vqCTBs14Mtca0Wueb1hmjqc72Ruytk1xx2ss/H4tRG9k25NAgoZC9sKiZ9KCU6vuJ
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYXPR01MB1886.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1512951-a49b-4e0b-2b46-08ddb38adc24
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 01:51:53.6149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gPkSxpu7jnAXyfTTL/ZlEOZ9AqIkwr5z7Cg1zOXQ8vbtUk5F2WtEIyU7yH9D9bFYsj4D2713h3pbwSR3+43VCRUKKQ1XjSC4DfaS5jIqUEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9340

V2UgdGVzdGVkIHRoaXMgcGF0Y2ggaW4gb3VyIGludGVybmFsIHNpbXVsYXRvciB3aGljaCBpcyBh
IGhhcmR3YXJlIHNpbXVsYXRvciBmb3IgRnVqaXRzdSdzIG5leHQgZ2VuZXJhdGlvbiBDUFUga25v
d24gYXMgTW9uYWthLiBhbmQgaXQgcHJvZHVjZWQgdGhlIGV4cGVjdGVkIHJlc3VsdHMuDQoNCkkg
aGF2ZSB2ZXJpZmllZCB0aGUgZm9sbG93aW5nDQoxLiBMYXVuY2hpbmcgdGhlIHJlYWxtIFZNIHVz
aW5nIEludGVybmFsIHNpbXVsYXRvciAtPiBTdWNjZXNzZnVsbHkgbGF1bmNoZWQgYnkgZGlzYWJs
aW5nIE1QQU0gc3VwcG9ydCBpbiB0aGUgSUQgcmVnaXN0ZXIuDQoyLiBSdW5uaW5nIGt2bS11bml0
LXRlc3RzICh3aXRoIGxrdm0pIC0+IEFsbCB0ZXN0cyBwYXNzZWQgZXhjZXB0IGZvciBQTVUgKGFz
IGV4cGVjdGVkLCBzaW5jZSBQTVUgaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgSW50ZXJuYWwgc2lt
dWxhdG9yKS5bMV0NCg0KVGVzdGVkLWJ5OiBFbWkgS2lzYW51a2kgPGZqMDU3MGlzQGZ1aml0c3Uu
Y29tPiBbMV0gaHR0cHM6Ly9naXRsYWIuYXJtLmNvbS9saW51eC1hcm0va3ZtLXVuaXQtdGVzdHMt
Y2NhIGNjYS9sYXRlc3QNCg0KPiBUaGlzIHNlcmllcyBhZGRzIHN1cHBvcnQgZm9yIHJ1bm5pbmcg
cHJvdGVjdGVkIFZNcyB1c2luZyBLVk0gdW5kZXIgdGhlIEFybQ0KPiBDb25maWRlbnRpYWwgQ29t
cHV0ZSBBcmNoaXRlY3R1cmUgKENDQSkuDQo+IA0KPiBUaGUgcmVsYXRlZCBndWVzdCBzdXBwb3J0
IHdhcyBtZXJnZWQgZm9yIHY2LjE0LXJjMSBzbyB5b3Ugbm8gbG9uZ2VyIG5lZWQgdGhhdA0KPiBz
ZXBhcmF0ZWx5Lg0KPiANCj4gVGhlcmUgYXJlIGEgZmV3IGNoYW5nZXMgc2luY2UgdjgsIG1hbnkg
dGhhbmtzIGZvciB0aGUgcmV2aWV3IGNvbW1lbnRzLiBUaGUNCj4gaGlnaGxpZ2h0cyBhcmUgYmVs
b3csIGFuZCBpbmRpdmlkdWFsIHBhdGNoZXMgaGF2ZSBhIGNoYW5nZWxvZy4NCj4gDQo+ICAqIE5W
IHN1cHBvcnQgaXMgbm93IHVwc3RyZWFtLCBzbyB0aGlzIHNlcmllcyBubyBsb25nZXIgY29uZmxp
Y3RzLg0KPiANCj4gICogVGlkaWVkIHVwIFJUVCBhY2NvdW50aW5nIGJ5IHByb3ZpZGluZyB3cmFw
cGVyIGZ1bmN0aW9ucyB0byBjYWxsDQo+ICAgIGt2bV9hY2NvdW50X3BndGFibGVfcGFnZXMoKSBv
bmx5IHdoZW4gYXBwcm9wcmlhdGUuDQo+IA0KPiAgKiBQcm9wYWdhdGUgdGhlICdtYXlfYmxvY2sn
IGZsYWcgdG8gZW5hYmxlIGNvbmRfcmVzY2hlZCBjYWxscyBvbmx5IHdoZW4NCj4gICAgYXBwcm9w
cmlhdGUuDQo+IA0KPiAgKiBSZWR1Y2UgY29kZSBkdXBsaWNhdGlvbiBiZXR3ZWVuIElOSVRfUklQ
QVMgYW5kIFNFVF9SSVBBUy4NCj4gDQo+ICAqIFZhcmlvdXMgY29kZSBpbXByb3ZlbWVudHMgZnJv
bSB0aGUgcmV2aWV3cyAtIG1hbnkgdGhhbmtzIQ0KPiANCj4gICogUmViYXNlZCBvbnRvIHY2LjE2
LXJjMS4NCj4gDQo+IFRoaW5ncyB0byBub3RlOg0KPiANCj4gICogVGhlIG1hZ2ljIG51bWJlcnMg
Zm9yIGNhcGFiaWxpdGllcyBhbmQgaW9jdGxzIGhhdmUgYmVlbiB1cGRhdGVkLiBTbw0KPiAgICB5
b3UnbGwgbmVlZCB0byB1cGRhdGUgeW91ciBWTU0uIFNlZSBiZWxvdyBmb3IgdXBkYXRlIGt2bXRv
b2wgYnJhbmNoLg0KPiANCj4gICogUGF0Y2ggNDIgaW5jcmVhc2VzIEtWTV9WQ1BVX01BWF9GRUFU
VVJFUyB0byBleHBvc2UgdGhlIG5ldyBmZWF0dXJlLg0KPiANCj4gVGhlIEFCSSB0byB0aGUgUk1N
ICh0aGUgUk1JKSBpcyBiYXNlZCBvbiBSTU0gdjEuMC1yZWwwIHNwZWNpZmljYXRpb25bMV0uDQo+
IA0KPiBUaGlzIHNlcmllcyBpcyBiYXNlZCBvbiB2Ni4xNi1yYzEuIEl0IGlzIGFsc28gYXZhaWxh
YmxlIGFzIGEgZ2l0DQo+IHJlcG9zaXRvcnk6DQo+IA0KPiBodHRwczovL2dpdGxhYi5hcm0uY29t
L2xpbnV4LWFybS9saW51eC1jY2EgY2NhLWhvc3QvdjkNCj4gDQo+IFdvcmsgaW4gcHJvZ3Jlc3Mg
Y2hhbmdlcyBmb3Iga3ZtdG9vbCBhcmUgYXZhaWxhYmxlIGZyb20gdGhlIGdpdCByZXBvc2l0b3J5
IGJlbG93Og0KPiANCj4gaHR0cHM6Ly9naXRsYWIuYXJtLmNvbS9saW51eC1hcm0va3ZtdG9vbC1j
Y2EgY2NhL3Y3DQo+IA0KPiBbMV0gaHR0cHM6Ly9kZXZlbG9wZXIuYXJtLmNvbS9kb2N1bWVudGF0
aW9uL2RlbjAxMzcvMS0wcmVsMC8NCj4gDQo+IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciAoNyk6DQo+
ICAgYXJtNjQ6IFJNRTogUHJvcGFnYXRlIG51bWJlciBvZiBicmVha3BvaW50cyBhbmQgd2F0Y2hw
b2ludHMgdG8NCj4gICAgIHVzZXJzcGFjZQ0KPiAgIGFybTY0OiBSTUU6IFNldCBicmVha3BvaW50
IHBhcmFtZXRlcnMgdGhyb3VnaCBTRVRfT05FX1JFRw0KPiAgIGFybTY0OiBSTUU6IEluaXRpYWxp
emUgUE1DUi5OIHdpdGggbnVtYmVyIGNvdW50ZXIgc3VwcG9ydGVkIGJ5IFJNTQ0KPiAgIGFybTY0
OiBSTUU6IFByb3BhZ2F0ZSBtYXggU1ZFIHZlY3RvciBsZW5ndGggZnJvbSBSTU0NCj4gICBhcm02
NDogUk1FOiBDb25maWd1cmUgbWF4IFNWRSB2ZWN0b3IgbGVuZ3RoIGZvciBhIFJlYWxtDQo+ICAg
YXJtNjQ6IFJNRTogUHJvdmlkZSByZWdpc3RlciBsaXN0IGZvciB1bmZpbmFsaXplZCBSTUUgUkVD
cw0KPiAgIGFybTY0OiBSTUU6IFByb3ZpZGUgYWNjdXJhdGUgcmVnaXN0ZXIgbGlzdA0KPiANCj4g
Sm9leSBHb3VseSAoMik6DQo+ICAgYXJtNjQ6IFJNRTogYWxsb3cgdXNlcnNwYWNlIHRvIGluamVj
dCBhYm9ydHMNCj4gICBhcm02NDogUk1FOiBzdXBwb3J0IFJTSV9IT1NUX0NBTEwNCj4gDQo+IFN0
ZXZlbiBQcmljZSAoMzEpOg0KPiAgIGFybTY0OiBSTUU6IEhhbmRsZSBHcmFudWxlIFByb3RlY3Rp
b24gRmF1bHRzIChHUEZzKQ0KPiAgIGFybTY0OiBSTUU6IEFkZCBTTUMgZGVmaW5pdGlvbnMgZm9y
IGNhbGxpbmcgdGhlIFJNTQ0KPiAgIGFybTY0OiBSTUU6IEFkZCB3cmFwcGVycyBmb3IgUk1JIGNh
bGxzDQo+ICAgYXJtNjQ6IFJNRTogQ2hlY2sgZm9yIFJNRSBzdXBwb3J0IGF0IEtWTSBpbml0DQo+
ICAgYXJtNjQ6IFJNRTogRGVmaW5lIHRoZSB1c2VyIEFCSQ0KPiAgIGFybTY0OiBSTUU6IGlvY3Rs
cyB0byBjcmVhdGUgYW5kIGNvbmZpZ3VyZSByZWFsbXMNCj4gICBLVk06IGFybTY0OiBBbGxvdyBw
YXNzaW5nIG1hY2hpbmUgdHlwZSBpbiBLVk0gY3JlYXRpb24NCj4gICBhcm02NDogUk1FOiBSVFQg
dGVhciBkb3duDQo+ICAgYXJtNjQ6IFJNRTogQWxsb2NhdGUvZnJlZSBSRUNzIHRvIG1hdGNoIHZD
UFVzDQo+ICAgS1ZNOiBhcm02NDogdmdpYzogUHJvdmlkZSBoZWxwZXIgZm9yIG51bWJlciBvZiBs
aXN0IHJlZ2lzdGVycw0KPiAgIGFybTY0OiBSTUU6IFN1cHBvcnQgZm9yIHRoZSBWR0lDIGluIHJl
YWxtcw0KPiAgIEtWTTogYXJtNjQ6IFN1cHBvcnQgdGltZXJzIGluIHJlYWxtIFJFQ3MNCj4gICBh
cm02NDogUk1FOiBBbGxvdyBWTU0gdG8gc2V0IFJJUEFTDQo+ICAgYXJtNjQ6IFJNRTogSGFuZGxl
IHJlYWxtIGVudGVyL2V4aXQNCj4gICBhcm02NDogUk1FOiBIYW5kbGUgUk1JX0VYSVRfUklQQVNf
Q0hBTkdFDQo+ICAgS1ZNOiBhcm02NDogSGFuZGxlIHJlYWxtIE1NSU8gZW11bGF0aW9uDQo+ICAg
YXJtNjQ6IFJNRTogQWxsb3cgcG9wdWxhdGluZyBpbml0aWFsIGNvbnRlbnRzDQo+ICAgYXJtNjQ6
IFJNRTogUnVudGltZSBmYXVsdGluZyBvZiBtZW1vcnkNCj4gICBLVk06IGFybTY0OiBIYW5kbGUg
cmVhbG0gVkNQVSBsb2FkDQo+ICAgS1ZNOiBhcm02NDogVmFsaWRhdGUgcmVnaXN0ZXIgYWNjZXNz
IGZvciBhIFJlYWxtIFZNDQo+ICAgS1ZNOiBhcm02NDogSGFuZGxlIFJlYWxtIFBTQ0kgcmVxdWVz
dHMNCj4gICBLVk06IGFybTY0OiBXQVJOIG9uIGluamVjdGVkIHVuZGVmIGV4Y2VwdGlvbnMNCj4g
ICBhcm02NDogRG9uJ3QgZXhwb3NlIHN0b2xlbiB0aW1lIGZvciByZWFsbSBndWVzdHMNCj4gICBh
cm02NDogUk1FOiBBbHdheXMgdXNlIDRrIHBhZ2VzIGZvciByZWFsbXMNCj4gICBhcm02NDogUk1F
OiBQcmV2ZW50IERldmljZSBtYXBwaW5ncyBmb3IgUmVhbG1zDQo+ICAgYXJtX3BtdTogUHJvdmlk
ZSBhIG1lY2hhbmlzbSBmb3IgZGlzYWJsaW5nIHRoZSBwaHlzaWNhbCBJUlENCj4gICBhcm02NDog
Uk1FOiBFbmFibGUgUE1VIHN1cHBvcnQgd2l0aCBhIHJlYWxtIGd1ZXN0DQo+ICAgYXJtNjQ6IFJN
RTogSGlkZSBLVk1fQ0FQX1JFQURPTkxZX01FTSBmb3IgcmVhbG0gZ3Vlc3RzDQo+ICAgS1ZNOiBh
cm02NDogRXhwb3NlIHN1cHBvcnQgZm9yIHByaXZhdGUgbWVtb3J5DQo+ICAgS1ZNOiBhcm02NDog
RXhwb3NlIEtWTV9BUk1fVkNQVV9SRUMgdG8gdXNlciBzcGFjZQ0KPiAgIEtWTTogYXJtNjQ6IEFs
bG93IGFjdGl2YXRpbmcgcmVhbG1zDQo+IA0KPiBTdXp1a2kgSyBQb3Vsb3NlICgzKToNCj4gICBr
dm06IGFybTY0OiBJbmNsdWRlIGt2bV9lbXVsYXRlLmggaW4ga3ZtL2FybV9wc2NpLmgNCj4gICBr
dm06IGFybTY0OiBEb24ndCBleHBvc2UgZGVidWcgY2FwYWJpbGl0aWVzIGZvciByZWFsbSBndWVz
dHMNCj4gICBhcm02NDogUk1FOiBBbGxvdyBjaGVja2luZyBTVkUgb24gVk0gaW5zdGFuY2UNCj4g
DQo+ICBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgICAgICAgfCAgIDk0ICstDQo+ICBh
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmggfCAgIDQwICsNCj4gIGFyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgICB8ICAgMTcgKy0NCj4gIGFyY2gvYXJtNjQvaW5j
bHVkZS9hc20va3ZtX3JtZS5oICAgICB8ICAxMzkgKysNCj4gIGFyY2gvYXJtNjQvaW5jbHVkZS9h
c20vcm1pX2NtZHMuaCAgICB8ICA1MDggKysrKysrKysNCj4gIGFyY2gvYXJtNjQvaW5jbHVkZS9h
c20vcm1pX3NtYy5oICAgICB8ICAyNjggKysrKw0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS92
aXJ0LmggICAgICAgIHwgICAgMSArDQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3Zt
LmggICAgfCAgIDQ5ICsNCj4gIGFyY2gvYXJtNjQva3ZtL0tjb25maWcgICAgICAgICAgICAgICB8
ICAgIDEgKw0KPiAgYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUgICAgICAgICAgICAgIHwgICAgMyAr
LQ0KPiAgYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jICAgICAgICAgIHwgICA0OCArLQ0KPiAg
YXJjaC9hcm02NC9rdm0vYXJtLmMgICAgICAgICAgICAgICAgIHwgIDE2OCArKy0NCj4gIGFyY2gv
YXJtNjQva3ZtL2d1ZXN0LmMgICAgICAgICAgICAgICB8ICAxMDggKy0NCj4gIGFyY2gvYXJtNjQv
a3ZtL2h5cGVyY2FsbHMuYyAgICAgICAgICB8ICAgIDQgKy0NCj4gIGFyY2gvYXJtNjQva3ZtL2lu
amVjdF9mYXVsdC5jICAgICAgICB8ICAgIDUgKy0NCj4gIGFyY2gvYXJtNjQva3ZtL21taW8uYyAg
ICAgICAgICAgICAgICB8ICAgMTYgKy0NCj4gIGFyY2gvYXJtNjQva3ZtL21tdS5jICAgICAgICAg
ICAgICAgICB8ICAyMDcgKystDQo+ICBhcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jICAgICAgICAg
ICAgfCAgICA2ICsNCj4gIGFyY2gvYXJtNjQva3ZtL3BzY2kuYyAgICAgICAgICAgICAgICB8ICAg
MzAgKw0KPiAgYXJjaC9hcm02NC9rdm0vcmVzZXQuYyAgICAgICAgICAgICAgIHwgICAyMyArLQ0K
PiAgYXJjaC9hcm02NC9rdm0vcm1lLWV4aXQuYyAgICAgICAgICAgIHwgIDIwNyArKysNCj4gIGFy
Y2gvYXJtNjQva3ZtL3JtZS5jICAgICAgICAgICAgICAgICB8IDE3NDMNCj4gKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gIGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgICAgICAgICAgICB8
ICAgNTMgKy0NCj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMgICAgICB8ICAgIDIg
Ky0NCj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jICAgICAgICB8ICAgIDYgKy0NCj4g
IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jICAgICAgICAgICB8ICAgNjAgKy0NCj4gIGFyY2gv
YXJtNjQvbW0vZmF1bHQuYyAgICAgICAgICAgICAgICB8ICAgMzEgKy0NCj4gIGRyaXZlcnMvcGVy
Zi9hcm1fcG11LmMgICAgICAgICAgICAgICB8ICAgMTUgKw0KPiAgaW5jbHVkZS9rdm0vYXJtX2Fy
Y2hfdGltZXIuaCAgICAgICAgIHwgICAgMiArDQo+ICBpbmNsdWRlL2t2bS9hcm1fcG11LmggICAg
ICAgICAgICAgICAgfCAgICA0ICsNCj4gIGluY2x1ZGUva3ZtL2FybV9wc2NpLmggICAgICAgICAg
ICAgICB8ICAgIDIgKw0KPiAgaW5jbHVkZS9saW51eC9wZXJmL2FybV9wbXUuaCAgICAgICAgIHwg
ICAgNSArDQo+ICBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmggICAgICAgICAgICAgfCAgIDI5ICst
DQo+ICAzMyBmaWxlcyBjaGFuZ2VkLCAzNzkwIGluc2VydGlvbnMoKyksIDEwNCBkZWxldGlvbnMo
LSkgIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ybWUu
aCAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vcm1pX2NtZHMu
aCAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vcm1pX3NtYy5o
ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gYXJjaC9hcm02NC9rdm0vcm1lLWV4aXQuYyAgY3JlYXRl
IG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQva3ZtL3JtZS5jDQo+IA0KPiAtLQ0KPiAyLjQzLjANCg0K

