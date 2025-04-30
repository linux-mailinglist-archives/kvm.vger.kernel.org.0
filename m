Return-Path: <kvm+bounces-44958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA2FAA52CE
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 19:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F8164C7D20
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36923266584;
	Wed, 30 Apr 2025 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gbs7tjKL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17721BEF6D
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746034985; cv=fail; b=jsWshdvjJSP58k3Ov8bk53c+2Vs+zOZfHwNnnPX84A2sPLEjK0vQWkDPD1u0SJ8cQU6uQHO5GrZbbHZub5Fe3NnRTJlbM3LxBcD5aUN/G5c2b4fob64dbkS2qqkc8ofSL8bN93y9xHHU9/s1ixnKrfRng3f5dJX+3l/XnJYNcDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746034985; c=relaxed/simple;
	bh=YJ0alZcxSVsufl/mzdMsnuVj0EymOmoyUUt3atryGZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j9KTNmwUlk7eAHeTah5nZSLV67Ah0cjzTjJVqNsi/Vq6gmJfjD0uc3U7t2yfJDpkJlonZjWp4EBUlanDG/xMFQSpAQT9Qcn36IfZxCoJi2raZmBrUmY7v+SB/tuVSgEd4M7F66LU3elBU+AEMh1WG4pde18krrKXPGqEWf3oCUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gbs7tjKL; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kkiH3zDiRLQpETetuQM2GPhdoPIZc2EAkgOUmX6gCbdE8bjv77sq5+lbpSp5hfcfOlt9xNN82PaiyQu460oBWNIFPQmXoxw98utgqzn3ZmReLUmsceBGSeckKV+qrKdl8MHeE95mS6FwqkjTA/Q9qaHewVFOwLL7gfspayJ1YkRONzVDwCLquLSab3EUBYMAekNxQ2PxuX1nwL0canoxvjgpUCPaXmRjaFOvUiCez6v+PhM6Zy7DPyVUb9nZgARpBSqWMddceaEmVAgaB1MzcPytPH55Ha1oh6p7BXK5LsjuYEOsY6+4eTWlEIYbiJc187LEjbOWdMxH4hWAo5tZCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJ0alZcxSVsufl/mzdMsnuVj0EymOmoyUUt3atryGZk=;
 b=msMDzHaZcgCo+zBeqlVsoL0PB62hnsnUuVqAzIERAoO9H1RGd0PEQzzR/sbDmZ+rYTqn2qS3p/mL03DpU1I9fCr60pG6fJhZIUbSPkzA5sXY+WqIx97g24XhVuF0r3IeuFVLgxwIR5R9D8yyWXD4NMlZGF4IPgjSlyYPf9FU9sJZhxXSdsQVicm2FntL4CAFoxkL/ucnfy5h2VILrmtRqOUj6wbm/+QLjC0XSfGJ3l5EErry2aZWHibrWwN1d0bn0Kbf8NOlaTYWe3DnEOcoGVYaIczciD6TZ/Q8YsIl4gpYDboiZJ/hij4pUBCy1l/qa4EWqRAJBtfXMnApoUVeHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJ0alZcxSVsufl/mzdMsnuVj0EymOmoyUUt3atryGZk=;
 b=gbs7tjKLtZvW1EJykh31nyBkMocoan+Sr8md7ccjS62Kbtvp6X9GhmIDnQ42AnySEjSDOD2tDHdHOABoWqPFagrOfMQGPUnAJ1E07ubi1fgP3V9ve+lg/wSzySA6vwmgi3t7Y+bqXBv54bNH8mmfU5ryqfYTUEab+oyrRm7l2zCZ/Lpww2oAqVLtSp6UDN5hYs7RQT6BFVmCM6P7fvO2x001F3XzMACXpJkissXSvpvEpxDeYx+hpRANqPtq92Zc9zDF2JUQYVArtQQz2jXQykWPiAgMdUny+gXDrYwgWX+D2H1KDr9h6TXQdadrqtlbvL/xGP8Gbv+XD3UgZPZFZA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW6PR12MB8916.namprd12.prod.outlook.com (2603:10b6:303:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Wed, 30 Apr
 2025 17:43:01 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 17:43:00 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>
CC: "eperezma@redhat.com" <eperezma@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>
Subject: Re: [PATCH] vringh: use bvec_kmap_local
Thread-Topic: [PATCH] vringh: use bvec_kmap_local
Thread-Index: AQHbudg0QiOmNcOxY0OD11XZTHnxk7O8evEA
Date: Wed, 30 Apr 2025 17:43:00 +0000
Message-ID: <325e9e19-8b54-42c6-b2b2-2ae47e0cd5b3@nvidia.com>
References: <20250430140004.2724391-1-hch@lst.de>
In-Reply-To: <20250430140004.2724391-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW6PR12MB8916:EE_
x-ms-office365-filtering-correlation-id: 8c1f4fd1-a803-4f18-3656-08dd880e73b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bXdzRE1GMUdaYnhyYnhQSXZVbTJkc0pMaHZISlBOQ29QZEk1ZGR0dzdBK21J?=
 =?utf-8?B?ZzMvQUFxNWdVa3J5MHB0Q0FWNTF0MnpzdllsaWxsWGpyRURoNGkwbTUrUDdR?=
 =?utf-8?B?Mms3Ymk0SWJkZVpKdThZdTJpOTZTVWdxNUV3NkE2RUdjaE5GNlRld25zV2RS?=
 =?utf-8?B?Mm9vSnpYc1ladTVPVnlkYzVxWHpWTklOVGowMGlZMEp1amg0OXRUTDh2U0hX?=
 =?utf-8?B?dkp0Mi9IV3ZOYnRraktmV2N6V0lTZVczOXVxNWl6TXpkZ1l0S3lOd3BxSFY0?=
 =?utf-8?B?c1RqM0w0OFRJZHFOaGJaOTcwNDFNbktIbUZVUnhDM05aNFlnRUdZTyt3MUhk?=
 =?utf-8?B?VWxTdXQ2enpJYXh0TTFjOHhuMDR1WTJ4WjFvVHRPTlJUTzFEZzdQbXpDTDJX?=
 =?utf-8?B?eWZJTmxBdWpCMlIrVHhwWUxEMXBha0dFOW4xR01udE13VTVyRU1LaitGRER5?=
 =?utf-8?B?SUNPbUpIejJ5VXBDQnZNdU11cmVhL1N0aFVHWTVWUmFCajVvL29hdmZ2SVov?=
 =?utf-8?B?SEw5aFc3WFkrOTM2SmoxSmVyZTdTUWNpcGlRbXZSbkpPTUxXdWJHSW9SSXZ0?=
 =?utf-8?B?anB6RWJKVk52VnFZeWFkQ2ZtUkxjUWg2T0FGYllycTdGc1NoVUQwbUJLdzN6?=
 =?utf-8?B?RkZ5SzRUYW4yYVJtdklIZFN3YXN3Um1hWWtRVWI3bDVDVldVdEw2OFRPRCtK?=
 =?utf-8?B?L3VyVjgzSDBhZ0tWMkNMOXhScm9UaFJGY0xTMmFZTk9QenhMbnoxOTJyVmo0?=
 =?utf-8?B?VWhFajUwNm42NnZFQ2NWN0M3dDYvOXA4ZFZZSEtQQ3ZxMUluMVo1UVR2U1Mx?=
 =?utf-8?B?bjREc0cwRkRaUDdXb2NZUzdvK0RidHdKM3lEdDJ2NGl1L05qRlNUR3BTWFhX?=
 =?utf-8?B?QlZROGlDRFdVNktoRE5LY3hBOWNDMVpYd2w3Nk9BUFNUMTRUUldnVHA1Nk4y?=
 =?utf-8?B?MldqK0ZDdVZDRmdHZGczSTdKc040b3VRTUVNS21sQ1dNUWlpcnFLL0tPQ2lo?=
 =?utf-8?B?aG1vN1RIaUhEemVCc2hnZlZWdEtnUVJWdDVPNFNBS2cwUmJnbG1HaEQyTHp4?=
 =?utf-8?B?MFcvYktvNWJtR2pyQks1UnRQazJTdDljOHZtWWFVQy8rWnNUWFJKaU01STFx?=
 =?utf-8?B?bXY0aEVNNWluaDlwenMyMjBGK05PZi8veStJZnJGMlJvVzJscGxhNWl0bjFZ?=
 =?utf-8?B?UWFYMnV1RFBnZEZ1T25kZ3F6aFdDemMrTjV5OW0zTzNBa2tENndUWkZ4M1J5?=
 =?utf-8?B?QVMzZFBvT0ZDTEQ2OEVnandLU2hpOXN3Mkx1aXpHaUxJdmJSL0pKSlhGZDJw?=
 =?utf-8?B?VFkzb1EwWHBNNWdhSUNlbmFNbjE5MHlxODFQN05XTXJlMGFLamh5ZkdoUlFG?=
 =?utf-8?B?R3AzMi9DMTR5VGVhL09oTHhZT0ErR2NJU0VBUXhmMFhrRlBML3Y4M2ZvOXlI?=
 =?utf-8?B?eGJET2dGdmRvMGt5aVZ2WEFNbDJyUUJpQXAwY3RIcUZGVjhtL3V4WXFyY2NV?=
 =?utf-8?B?QmZ0Z1hkNVZJMldLZ3JuOUVVRFROUklsV1diemE2dFNQR3h3M2NGY2pFVXJU?=
 =?utf-8?B?RDBZVkJyR3Q4MlZ2N1M4akttVHBvS1RrSlBEZjQveXIwaEVWeW1MV05DSkkz?=
 =?utf-8?B?ZkdzME5ZNk81QTVValBDUEE1clNwMzI0TElJODNqRjhjTjFkc0QzRTV0UXNF?=
 =?utf-8?B?S0FUWVRtM1NqOE80R1VBR05wVlVveHFFVnhQTkpLQUloZUlnVlYzVkRtZUZB?=
 =?utf-8?B?bDZWQ2t3VjV3OVlpVER6NnFXL3BoT2M4K2NsTGZ1UndwQVJxZGdCZmNkYzQz?=
 =?utf-8?B?azJLMG04RWhNSEF0OHZHNEwzM3kwTGgvSVpoYWFUeDlyMXQ5d2wyY3NLRnhp?=
 =?utf-8?B?cklTbEx2ZHNIUlFyVzlMSCsxa2FkWk1RV202UFEwcitIQWtBSUY2cWxUKzVZ?=
 =?utf-8?B?MWVaSlY4cXAvZ3JHRDRVSTlTRTV4K01pa2hCZHR0QVlzcUZ0ZXdITGZ0cGNX?=
 =?utf-8?B?TWVrdXFNMTh3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZVlVQ3B4VHdHRks4VC96WE5IaHRXVmVVcWhlNit2RkZaTm5PWmZoNmQ0UWtS?=
 =?utf-8?B?ZWFYaVpwaFNNTXBFRnNwUlBiOXNnTjc0aEJyandWTXZ1cE1IZTQ0aDlJQTg2?=
 =?utf-8?B?ZWxpNDZ5L0JPQjRmRUdJby9Dcmo3T29UYWY0cVVtUlpnaWRKQVZpMlltaFVu?=
 =?utf-8?B?L1U2aldYZ2NzdWUzd0pEZm5NcmZPNUFmckhNQUw5MkJ0eUF1a01XOGc5RGxD?=
 =?utf-8?B?Wm5PMytEVXJUQnNCVTBMWEpibWVLWS9RMmV6eXNZcm41MUdnT0VDTVY0dnJH?=
 =?utf-8?B?aWx0ZFNxdDg5b0xtcitvblFpeDh4VVNEY25Dc2srTXF5ek1uOXcra3g3b2NI?=
 =?utf-8?B?ZEp2UUpaM1QwRUZGV1BSM2xqalViOHFLTGJFOG5tekx6d2NMSVNqaWQ5cnB1?=
 =?utf-8?B?QnhkWVZMUzlNcStudGN6ZWJJeWFndjJnQmU3VDZyNmxGM0d3UHlPTEdVSnBY?=
 =?utf-8?B?U25sVEFiMUtlL05PRXNtRkw4TjZJOHlnaDlFb0VwRTJLQ0xhdkNBSUxGQ1V1?=
 =?utf-8?B?UXZQVlRpYWNScDBqV29UenJQd3EzSTkvOUVadHM2TS9hbFF3cWUxRTlkbWdN?=
 =?utf-8?B?YzBpL0hYN1pnSkoxR053Ym4xWmFqMFl5TVdOcEhxRGdTbThkaExyaTAxOUhK?=
 =?utf-8?B?ZUptZExVRjZsUnJpZ2krTDNRU1JUMkZvSU9WVHJBOHoyS0R6V1N0WjkyUldB?=
 =?utf-8?B?eXZOWHlyL0VPVnI1ZTdOZmZNVDcyT0tKWDMra2hpb2FvaU5JcXBmYjdESFAw?=
 =?utf-8?B?WFdicyszVFdrWDRiY0FYMzJGRjgvZVFqRjNqbHZjOXBvMHVqL1doMXNyUXla?=
 =?utf-8?B?S1liVGF5WE5rUHVkekNQZUtLR3AwR253QkljbXRvc0tDcGRkQlBwZnlQSWFm?=
 =?utf-8?B?NUQ2VTNDL3cvTFJyczErSldKUDZvZGZYWmt5b1Q5Z2pNclRnVFZ4ZWRqbm90?=
 =?utf-8?B?dEpOMmpmTzl4MTYrVVQ3VVQydkRVYWp3K3FUbGpObkRUWXJNeGl1bzkrVVVn?=
 =?utf-8?B?ZVdSYWFDWHdoSnQ3TjBQM2pUYm5iYzZZeE40bkk1cDZXcFkvcURHVGg3aU1q?=
 =?utf-8?B?WWpaT3lGN3NneVp3QVFwei8zcmdydGZoZFVzSmEwWFJub1NPQ0RVamNHOE0w?=
 =?utf-8?B?R0RzZGgvSTBybkREVVUrL1krVGpaem1wY1lOdjFmalE2dGpCWXF3TWgwYlho?=
 =?utf-8?B?TGhlUWtxM1RGa0NrV0pFRFpDOHdJU2hqVm5pdndJL1pZSE00REFocU1YcTk0?=
 =?utf-8?B?ZnVWRFVrWTUxUkJONVU2RXpPWWI1SVV0UlVuaE1TcVc3MVluRS84aHJxTHNT?=
 =?utf-8?B?TVBpUFFlOG0zSTR5cVJPdGFJZkI3S0FGRGpqc2JyMHVwM24xQ3ZPSlo3Vjdz?=
 =?utf-8?B?TDVTSTVGV2dKd3k4WHlpTWFKTVp4ZW9CaHBxeDUwdC9HM0loTnZWUlVDdktx?=
 =?utf-8?B?bkd5R1g4RkdOZlpad0NBSUFEemZRaVl3Ly85b2dOTFB3YS9aOXdjdGVsRDBL?=
 =?utf-8?B?Skw5MXc2bjdiSE9ZN3Z0NjFlbVhTclMvbFpQY2JBUDhoZmxmNzNpaElNRlIr?=
 =?utf-8?B?UWNhaEUxOHBXSGRJRDVlb2hxUkU2akhSUDFMQ014alFYaU9BdFpsUEpBQlJ6?=
 =?utf-8?B?dU0va2U3Q2h5THZpN3RzRWdHRHhtaDFCRFBPMzRhZGJtTUR2eXRKaDBqRXhq?=
 =?utf-8?B?aUhsRlRjdytqeXJtNlE2bThmZ295NEZTVjZib1JjYlB3OXZFblVHZ0JvWktz?=
 =?utf-8?B?ZmNQZWFuVncvQlloNXhhd1FXZDVRTWFRQS9yUHlBY3gydWE0SjVWWW5PS3Nk?=
 =?utf-8?B?T1o5V0FUZGFCbDZOS2FSdHkzdTBMM2ovalFlV0dPcGVIRTVxQTVtMDN4S1oy?=
 =?utf-8?B?QnJkL3IzODhaa1Y3SkdWYTErYW1WQ2N5U2Nxd3d1dWRKRGlGYWo3YmV0eW1p?=
 =?utf-8?B?SzdpM3pyU2xoeDVkKzU3elFkVWZvWldlN2dOSXhYUzlGTS91NGNXWlB1MWdi?=
 =?utf-8?B?bllVTXRRRG9weCtEYWFzbkNFVGRtdHZjUkZqZFpsU29mU1Y1aHlEdW9rOW9C?=
 =?utf-8?B?dWI4ZWc5RGNxdkFHRFZURXNwT3J0QngyRzhWWmk3L1U1b0tBUXVudW9YcU54?=
 =?utf-8?B?c2MrOFMxQUZhMmF0WmpKbldEUUZjc2tUQTZiOEFjSmZGcWdZY0ZTMVd1U3dw?=
 =?utf-8?Q?dAL6ocX0G3doTOCnKDTIamfvoJkEjzE13sAO0oZyNDjs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42788D7EDA755141A0065E06109714BF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1f4fd1-a803-4f18-3656-08dd880e73b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 17:43:00.8505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G94PsxQfPI/+ZtJUp9ZX6ew2HNtAPFvmDM2DHXgEw2t8mhgzPMYeT5htQwJJLv0p3m+XfTZaxQzt1ZkB+aXxCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8916

T24gNC8zMC8yNSAwNzowMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgYnZl
Y19rbWFwX2xvY2FsIGhlbHBlciByYXRoZXIgdGhhbiBkaWdnaW5nIGludG8gdGhlIGJ2ZWMNCj4g
aW50ZXJuYWxzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hAbHN0
LmRlPg0KDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fybmkg
PGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=

