Return-Path: <kvm+bounces-27331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C73C8983FD3
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8B7B1C21B99
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 08:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF6E14B08C;
	Tue, 24 Sep 2024 08:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xnlb7u85"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18DF79B8E;
	Tue, 24 Sep 2024 08:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727165003; cv=fail; b=QcCiIqCWezzcXt9OpJuvPastkBpLtxdl/kxVtUPtE4YfAGx2v4LTRKLAniXntHTegJUZg6LYPaCJsKfrDgMKZ0fXCFLvjbBr4Yeas1isZrWpDZgBYOriY+2pDr/c6zNDRpwm1CDKXDa/VeCEyg56AWhCNkASJ2Wr9EnDSPQQ2PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727165003; c=relaxed/simple;
	bh=Nw+bTDumLr5aIwWHYsHE4lBEifxTgz+6vPtVk0tDvV8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lYteYRBFRnL0dN159ewHLKoT69ueh0gZe3gfajknzb6f2ghXJdzs3ur5re1gMxGqfl2NsdqL/dHhQ4ZQ89R6XAzgJc4AIja4k2PCmnA5iMPAc/Zki3IQQ174rkbla7l9NaNSARPSU9yutKHkOWCfS/4USCcDU8F3DdiRmU4hSVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xnlb7u85; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGEpoQb7SH/+tuvsHvjcWFp4mbOM8OF1dHvmtHTgGN/4hv2ciZa6Cv7rXNJzJJWXZkk4MF+2lxMmSQwHSycUJ1T4h1H5/vNBGWI8KbgxI59dSFdcrASWvASS7ticTDdl83/+8jkNmvOuBkaAZXkSTiUM+JPI08XIWJwZA4CN02YvS+zkwVdK2tOxE5JbLqn46LaBhjRBqD5cXZexx1+ts/AH+nocPrqkI7363drkXl4sjIplUS47+6M30ju/fwNQGEGwngoqOywxsDEDSBsFeU7rFbTzCF5/M/JKwvEeCLgFtNvNOZ2w4X+GtAIMR+MhlvkVnn1UlhwR1XT79CKU9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nw+bTDumLr5aIwWHYsHE4lBEifxTgz+6vPtVk0tDvV8=;
 b=cFjkdtjNtEA41nkRegG+R0qgCgK96jZSseHat1G0comFJwWJITTFiP0lf894FBe9d36l6cwIFGEjn22VeKoHS+aRjFQnGtikZKmfrMjqAAMTZPpQO/fIHVSFN0fe6x8F6/apGmOy3kpe1Fxiq1eySDr8xvsQo9QMnp2eoYpmZZElxcJRKaI/uJbfmedaKPvwM3m6JDGk7d8ffZEpNpwG3FkRhrjz1LMpcV2PM433iVN+7ccPovVfSKOE47rTcDYz5qs+c7wroSB+H9BxXOIV+5c4F5e40Lhz4DvgaRyJKE7NQF8UX+97S4sOTDx+d5yINEBKuxfxcUmVZ4eATWvEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nw+bTDumLr5aIwWHYsHE4lBEifxTgz+6vPtVk0tDvV8=;
 b=Xnlb7u85sJ51DAqggZ7SSLuRXxTsaAukC69zuXGv6/N9l8MSYphYv8QhvTVQPytlcMRmfLB4J6YZ2m9LpsnKqvGXMSNyzFPFFd7UFRVb/Wde9gJKT3cxJqGyu5ZgbhZXWYYs2kj9oUT4CxCOG07akp5Py7JaujqswgdRlSy20ZOcbkRPWxhJ2y6raGW2pTySDFIRvtobiw5rghblGP160h8AutK1IfN+2byae3SqgbXyx8aM4+oy6tgEQJxUFMRcPM7EGs0P6yjIMUPftgm7STmhDabnR7djZfs3hSvfSXvZWgGK6MCP6u6xsZ1vflXPq/X2ZnDFtFFkVMWGCf6www==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by DM6PR12MB4339.namprd12.prod.outlook.com (2603:10b6:5:2af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.26; Tue, 24 Sep
 2024 08:03:18 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 08:03:18 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave@stgolabs.net"
	<dave@stgolabs.net>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "alucerop@amd.com"
	<alucerop@amd.com>, Andy Currid <ACurrid@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 01/13] cxl: allow a type-2 device not to have memory device
 registers
Thread-Topic: [RFC 01/13] cxl: allow a type-2 device not to have memory device
 registers
Thread-Index: AQHbC61aQfwv6GH4JEqhWpg6Alu7SrJlhgcAgAETDgA=
Date: Tue, 24 Sep 2024 08:03:18 +0000
Message-ID: <8bc78434-892d-4faf-bc2b-c26cb7c140e9@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <20240920223446.1908673-2-zhiw@nvidia.com>
 <e43792c3-c4d5-48e0-a4d4-586cebbb49b8@intel.com>
In-Reply-To: <e43792c3-c4d5-48e0-a4d4-586cebbb49b8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|DM6PR12MB4339:EE_
x-ms-office365-filtering-correlation-id: a84bbe23-4d8a-40a2-a7aa-08dcdc6f59dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RGJrc01MUmZPUWtUditjTnBqQjNrNHBNVU9Ic0VmcDRNWmtsVVBMQzJ4dDR1?=
 =?utf-8?B?MXA5YjYxS0tlYkpjN2gyMHpTNkN4M2RucnM3TU9EbldHZitzMjFucjUybVVx?=
 =?utf-8?B?cEtQMzhDa1N4MEdEN0lVYWpmUjhSZWYxUWVUTTJUVUR2REhpazNYdFNYcmEw?=
 =?utf-8?B?ODVtQXEwTWM2SGFuZHVxckJsZ243SVpsalBUYzZNUHZiZERaa3Q0Q3VFQmpE?=
 =?utf-8?B?TTR3aytnOHBXQmN4VWpaaWx5aHBJTk9BRVlCaFdHNGxOUlo0Wi9YeXRQSGVL?=
 =?utf-8?B?YlI2Rm54dTdVSzVpNFhvdGhtaUE5YUhkNUJlRURKSkduS0R0TEVScE1lNjQ5?=
 =?utf-8?B?SnBjdHNKN1FRa3VIYmVJQS94UWs2NVdHOU03OXZaTlVkcTdDUkN3Q0hpR000?=
 =?utf-8?B?QnhvTk9MQ0ViQ2xqbUtWRW9lUkRvdmhXRmhwZ0loYkdTeEVBazIraDBLT2pZ?=
 =?utf-8?B?L2grQ1J2RmFxU245M05DZ2tiTkRCcEtya2ZOOUFkOTdmSGpKckNNbEhoK29T?=
 =?utf-8?B?WTEzOVQwN2ZSYXUwSndQYnlsZDhEcVB2QnpGcUJLQzMyQkVhVzVpMEZPdGlX?=
 =?utf-8?B?OUFXNGFJU090S0o1emZHbWViMjJwK1ZPRXRRQnpwUjF3VFhWM1ppZ0VkUW9H?=
 =?utf-8?B?WVd0WHMyNStOSTRiMHF2d01DZFJTRk5rcFZBQ09sZjI5ekV3WXlHOGFKbi9B?=
 =?utf-8?B?clRhRm1LS0hHQzhpYjA0QWZHK2R2M1JtbHNDcmwrYUNQQXpmd01HMUFoYXA4?=
 =?utf-8?B?YmFkbGtXYm9HdEZGV1NTNXNtNlhFNW9MQ0drcysxVlpveUR2bWZQeUt6TFZH?=
 =?utf-8?B?eVhSblJ0dDFMR3piL05zYmY0a2JGVDhVQmJqemdiVVdwNDFoOGVPQ0F6Qm93?=
 =?utf-8?B?NEJCQXJsdnJVcy8xQldDeXgzMkpDamlrSTVpSjVIak44Q0pjdUVCVnA5THZK?=
 =?utf-8?B?Z0VBZmFrRmZuWHI5Yi9YY3cybDVkV2ovUVhISlY5a3MwRWw4V0JQVGpqbTcw?=
 =?utf-8?B?WXBHSVFLZ3RBVUpHMGdwZlZvVU1Jbm9GT1QrVUViNlc1M1pZb0tEMWE5MlVz?=
 =?utf-8?B?QXBXK3hUUXUrZXhid1FqSDFvTEtnZ0U2Rm9xOVU4QzdGZHIwcUlrL0NMN1R5?=
 =?utf-8?B?Y1l4Q2ptMzhVNWlyVDlRcnpGRmlvL1VxamhqYUg4V2pXQmpxUkJzNEIxMkJr?=
 =?utf-8?B?OXpRL1FjWnM4TCszRSt3SXdsdlFVMzBiVEwrR0hLeU9ib3dEWWYrbDIyRlkx?=
 =?utf-8?B?NXE5VG0ySXc1SzF5ME1qZE1NaW5BbmJOdFRzbmthalI5OUdjNDJmT1VRRnFL?=
 =?utf-8?B?N2g2ZWRNYURYLzl3SXhZVWZ3R1lkOWFHWXB3aTJOcGYzMnNjVERPRUVDUmd5?=
 =?utf-8?B?czU3bnp4YU5FZEE1SHNMY0F4N01KVjJVRVlkYW1xNy9GTzRNTis5Q0RweWxw?=
 =?utf-8?B?MEg3TENKUXFKOTBpRGNCR2hCVUtVTDlteFRZY2hSbFNVbmFlODBYNFk3ZGRr?=
 =?utf-8?B?VDNadFdpUXZYRWkzSjNMZXEvb3VQazYzTlBwbFhvVFBwdWFtampoaVloWmY2?=
 =?utf-8?B?TW9BeVZSTWJNZmVka3JibkxHVFpha0YxWnZZQUFkV0JYZjhaOE16ZXgvSlBJ?=
 =?utf-8?B?d1ZLRTFsSm85eCtSa3NyTys5dEVZdHhuOXU2QVpuaC9JUHhPOGE5VzR1WEZK?=
 =?utf-8?B?ZGFGa3VxL3VOMUFxUGgwSGJXWlFMbVhsSDdocjBBbzI4d2hXVlJvL2JEeG5p?=
 =?utf-8?B?YXNaazFvdEFGNUQ2QUJKVUx6UXVreDFna011N3RON0ZDRUdRTUVUbCtDdmhT?=
 =?utf-8?B?Zk9rMTIvd1ZRZEMzNFRCQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ckRubWlFWVVjc3FNR0t0VkV2TVpTa0ZZR1ZkVmR1YXJwTWJ4bFZJZHBlZ0lU?=
 =?utf-8?B?OWNKMEx2REt1TWE5UzkxK3VKN2llMC9PemhGY2JGVnBlSitCa0VYYTFnelNk?=
 =?utf-8?B?OEMydzQ1a0lMOURoMkxBWndsS2RVcnZ1VVJXVWdIczlqSTR1VGg1ckIwRmtQ?=
 =?utf-8?B?NlQrbzB4Ry9jVHg3N1BZdGVkeW9tdzlPaUVCSWVaYjFqWmRtdDhldVVWNFcw?=
 =?utf-8?B?bVlDTm1vL0J0VEhsdE0zMWZWdzhOY3RZTXcrM2tiMktyTTc4QVprc0NlcXcv?=
 =?utf-8?B?Z1RjWVRiOXZJYjBqNDhJQno2THJWL0ZZanpXZG9NLzNncmZ3cHovcy9yd3Jo?=
 =?utf-8?B?SlQxQ0Z6dE9kUDhIMzA3SjZRZzNsNzRpcVBqRTh3a0tYaHBYT3kzeDVheHlQ?=
 =?utf-8?B?WSs4WGhNR3Y0cStQUnduWk5ZQkNINzUyOFNMaGJnN3FIMFl3elVzUTl5OStq?=
 =?utf-8?B?SURicFlvSnZZc3dnazdxSm5lZHpJV1dLRmdRckFEelBNbUdMVXRXTU5vRVhh?=
 =?utf-8?B?bmRzVnpmMTdWdWhyclVySnF4RXQyaFQ2Yks0bEo0MDg0SHJLQkkwWDR4aCs3?=
 =?utf-8?B?ZTZKaFRaemlpYVRxVVJKLzBaaUlDdzRERjF5MS9GSHZNaGhqa3NxNEEyRjN5?=
 =?utf-8?B?b0VPTmhJYmhXVFdPOENZZUJSQ0lzaVJrUzFMa1h0WGs0VFNoUlVLM0FjVjB5?=
 =?utf-8?B?a1o1VERER0FFMzFlUEFoTDBsY2kyZzNjYnZ3a0ZvaE1pZ09TTGNnbjlvTGpF?=
 =?utf-8?B?aVVNbkk2LzZaZ21iUHhEYTlaQ0I1MGVyVnF2TC9ocTJxN0VrMVFvZzVOQ3Yx?=
 =?utf-8?B?M1FRdkFDaklLc3Zod0pLMFVMNzZzTWFQeXdURFh2eVA5OVQvN3lQREg3czhT?=
 =?utf-8?B?bFZOT0RENjZyK1VVS0R2eEpmNHA3azNSTk1oQis3bTJwMjZvOExJTXh2bVA3?=
 =?utf-8?B?RmlrTWFuUjM3WnExaEdHV1JBSlFvcTgveVMwalZ1VU9Jdms2dU9kdDZwVTZZ?=
 =?utf-8?B?bThUUkRRcW9jekNkdDk0K1UraTBXT3h4YUM0TUlVdy8rWk9zb0tPbGJzOG02?=
 =?utf-8?B?Qzl6VDVWWjkzNnY4Sm1Bb004QkhBdjlPSU1lWUp2bDFhVVgvWXlnOXdzRFp1?=
 =?utf-8?B?Q2kvMGVaNFpPdlljR1JUSFVjdHBaMUhyUXRjQmp6NXI2d2FQdmIwcjZ5ZUhS?=
 =?utf-8?B?RXVVUkdENlZCZE8rTVhiRHZvZllXb1BZb3dldlhsMWYwbThwRjRBOVBxRnVk?=
 =?utf-8?B?YmliVlZ0eTlrSkxxL0JhbXZ6L2phZUFHMzh1Vyt0dC8zZ0JVWmxadXFkNlgz?=
 =?utf-8?B?YmgweGFWekNnTmtaaGNqbU1HbnVGNkxNTm5JU3o3TmZ2RjBxZ3RRQUVOSlFH?=
 =?utf-8?B?cURSOUtuQnIwZjJxSklvOVFpS3JHOXA3R3p6V1NNUjB3dlZNODJ0eEVoU05t?=
 =?utf-8?B?T0ZPT1JwWkFUeTVwUkRmMUJXSGI4d2JhSCtwVVZ5eWFVb1kxVjRaazRjNmlI?=
 =?utf-8?B?UVVyUHppRjQxbXhSVlBCT1JLKzRDOGwycjM4MjFZZmc4RTFzWTV4TWdrNW13?=
 =?utf-8?B?eHNrUlFJTkNzUXhOZU1hY1B6WHFhRzBTeTZvdnl0eldkZDhqQ245bEFuUUx3?=
 =?utf-8?B?amZ1bHdEblJob3RsZXIxZmlqOWlnRDBIRXpTMHBJZHFVNnIvYit2aWtIazhD?=
 =?utf-8?B?blc3TTg0bzRMcStjcGw4bGNtanQ0amFvOUpLbjdTR1JiR3l3OVM4enJCQk95?=
 =?utf-8?B?cmNEdy9uaWVVZFg0aExLVzZQTnlxWHB2K2RLWUxVZkpHdlAwczN4SzdoM2FL?=
 =?utf-8?B?SVlMVkRUaXZqODNpRXZKcjJJVWs0RlRXUWhYY3ZJSUdqU0J2QTk0WWd1eElY?=
 =?utf-8?B?bnNBb3VnQXQ1ZGJqNFp4UzZYWmE2UkRtZDEzMmpmUjNLSVdCM2ZXSWZvVXpQ?=
 =?utf-8?B?dDZMRUM0VHk2UkpveHVsaHlrcGVlanZTYmtLZHoxdmVnc2dIWjNXREgwTC8v?=
 =?utf-8?B?M3JwWGgrYVJ6a05uZncvWXBTZHFwZVBpeGVENGx2bGIrVVFyRWw0QUEveTd5?=
 =?utf-8?B?NHNxSG9ETHVoQzUyb0FhOEphU2d6QS96elZjNmVYSXpQQjg2a2l5L2JTL0Rn?=
 =?utf-8?Q?Swps=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4331DE6DA3B0E843ABBCDC5A26DE666B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84bbe23-4d8a-40a2-a7aa-08dcdc6f59dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2024 08:03:18.6861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxuJA+GnBna3QBl11Qkvl0G2gM5VjYW04Du2ZtuQQDLppBRVueLWLU033GE7i7KV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4339

T24gMjMvMDkvMjAyNCAxOC4zOCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gRXh0ZXJuYWwgZW1haWw6
IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiA5
LzIwLzI0IDM6MzQgUE0sIFpoaSBXYW5nIHdyb3RlOg0KPj4gQ1hMIG1lbW9yeSBkZXZpY2UgcmVn
aXN0ZXJzIHByb3ZpZGUgYWRkaXRpb25hbCBpbmZvcm1hdGlvbiBhYm91dCBkZXZpY2UNCj4+IG1l
bW9yeSBhbmQgYWR2YW5jZWQgY29udHJvbCBpbnRlcmZhY2UgZm9yIHR5cGUtMyBkZXZpY2UuDQo+
Pg0KPj4gSG93ZXZlciwgaXQgaXMgbm90IG1hbmRhdG9yeSBmb3IgYSB0eXBlLTIgZGV2aWNlLiBB
IHR5cGUtMiBkZXZpY2UgY2FuDQo+PiBoYXZlIEhETXMgYnV0IG5vdCBDWEwgbWVtb3J5IGRldmlj
ZSByZWdpc3RlcnMuDQo+Pg0KPj4gQWxsb3cgYSB0eXBlLTIgZGV2aWNlIG5vdCB0byBoYW52ZSBt
ZW1vcnkgZGV2aWNlIHJlZ2lzdGVyIHdoZW4gcHJvYmluZw0KPj4gQ1hMIHJlZ2lzdGVycy4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBaaGkgV2FuZyA8emhpd0BudmlkaWEuY29tPg0KPj4gLS0tDQo+
PiAgIGRyaXZlcnMvY3hsL3BjaS5jIHwgMTQgKysrKysrKy0tLS0tLS0NCj4+ICAgMSBmaWxlIGNo
YW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9jeGwvcGNpLmMgYi9kcml2ZXJzL2N4bC9wY2kuYw0KPj4gaW5kZXggZTAwY2U3
ZjRkMGY5Li4zZmJlZTMxOTk1ZjEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2N4bC9wY2kuYw0K
Pj4gKysrIGIvZHJpdmVycy9jeGwvcGNpLmMNCj4+IEBAIC01MjksMTMgKzUyOSwxMyBAQCBpbnQg
Y3hsX3BjaV9hY2NlbF9zZXR1cF9yZWdzKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBzdHJ1Y3QgY3hs
X2Rldl9zdGF0ZSAqY3hsZHMpDQo+PiAgICAgICAgaW50IHJjOw0KPj4NCj4+ICAgICAgICByYyA9
IGN4bF9wY2lfc2V0dXBfcmVncyhwZGV2LCBDWExfUkVHTE9DX1JCSV9NRU1ERVYsICZtYXAsDQo+
PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjeGxkcy0+Y2FwYWJpbGl0aWVzKTsNCj4+
IC0gICAgIGlmIChyYykNCj4+IC0gICAgICAgICAgICAgcmV0dXJuIHJjOw0KPj4gLQ0KPj4gLSAg
ICAgcmMgPSBjeGxfbWFwX2RldmljZV9yZWdzKCZtYXAsICZjeGxkcy0+cmVncy5kZXZpY2VfcmVn
cyk7DQo+PiAtICAgICBpZiAocmMpDQo+PiAtICAgICAgICAgICAgIHJldHVybiByYzsNCj4+ICsg
ICAgICAgICAgICAgICAgICAgICBjeGxkcy0+Y2FwYWJpbGl0aWVzKTsNCj4+ICsgICAgIGlmICgh
cmMpIHsNCj4gDQo+IEdpdmVuIHRoYXQgZGV2aWNlIHJlZ2lzdGVycyBhcmUgbWFuZGF0b3J5IGZv
ciB0eXBlMyBkZXZpY2VzLCBJIGRvbid0IHRoaW5rIHdlIHNob3VsZCBhbHRlciB0aGUgY3VycmVu
dCBiZWhhdmlvciB3aGVyZSB0aGUgY29kZSBhdHRlbXB0IHRvIG1hcCBkZXZpY2UgcmVnaXN0ZXJz
IGFuZCBmYWlsIGlmIHRoYXQgZG9lc24ndCBleGlzdC4gTWF5YmUgbmVlZCB0byBjaGVjayBhZ2Fp
bnN0IHRoZSBjYXBhYmlsaXRpZXMgdGhhdCBBbGVqYW5kcm8gaW50cm9kdWNlZC4NCj4gDQo+IERK
DQo+IA0KDQpDb3JyZWN0LiBUaGlzIHBhdGNoIHdpbGwgYmUgZHJvcHBlZCB3aGVuIHJlYmFzZWQg
dG8gQWxlamFuZHJvJ3MgbGF0ZXN0IA0KUEFUQ0h2Mywgd2hpY2ggaGFzIGhhZCB0aGUgY2hlY2tp
bmcgYWdhaW5zdCB0aGUgY2FwYWJpbGl0aWVzLg0KDQo+PiArICAgICAgICAgICAgIHJjID0gY3hs
X21hcF9kZXZpY2VfcmVncygmbWFwLCAmY3hsZHMtPnJlZ3MuZGV2aWNlX3JlZ3MpOw0KPj4gKyAg
ICAgICAgICAgICBpZiAocmMpDQo+PiArICAgICAgICAgICAgICAgICAgICAgZGV2X2RiZygmcGRl
di0+ZGV2LA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIkZhaWxlZCB0byBtYXAg
ZGV2aWNlIHJlZ2lzdGVycy5cbiIpOw0KPj4gKyAgICAgfQ0KPj4NCj4+ICAgICAgICByYyA9IGN4
bF9wY2lfc2V0dXBfcmVncyhwZGV2LCBDWExfUkVHTE9DX1JCSV9DT01QT05FTlQsDQo+PiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgJmN4bGRzLT5yZWdfbWFwLCBjeGxkcy0+Y2FwYWJp
bGl0aWVzKTsNCj4gDQoNCg==

