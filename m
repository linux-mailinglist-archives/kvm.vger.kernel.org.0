Return-Path: <kvm+bounces-23992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47915950590
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C1901C22979
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1323319AD70;
	Tue, 13 Aug 2024 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lNnEyICV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150314A600;
	Tue, 13 Aug 2024 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723553584; cv=fail; b=GMwH3UcTUwSsumMOKcdCG46DeljwM/ljxgG9P5Jv2y9tJS32b8HOhmAMkVaBITYY/nZmZOICP5BmrtUBQJCldpve9dcj+iXesvuqggzMFLY9HJMu2HnHkO3sDnx/OkGidTHhOqShirOpnJNmyzoejmCjn/LeSDwu7RvNWj2/O5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723553584; c=relaxed/simple;
	bh=ahPs6JfylQhRGyKysMdosIopsttgfKejW8MhdN+0YMw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ItJbmcHAkSA95cJdROLC1/I84bTf9HTmnKLMiC+mkD+YMgQXqh2ZRTO9PzAFKptBDzLrkq5lFuYaycLbxw1mJzm0NfUT1RQGW0VU3ILKg9E34PrUmWgifaV9D4MjHsgW7abZTUiRj9j75ojsSv9zIsTqlBEYOj2CY8RfI1t6HtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lNnEyICV; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImO6vSyPZx098MItFOOQ5meTWFqwr5X/lc5IimNFsRqalB+bYje3vKuNBPzrkeV3w0MXrdLQcYpLAMiMszkFMnCk87N72/DqwjcCIaf7Jv8GuxmTJ8zVAXRCkyT7vXXf4nYzsURlyNK9of6cNpc5jZKfy6AuDiWlsZXjwCRMQv6e5bCVwfzR7qlf35UmL9A1EX08E4h+HuXz62b2fx7jaaFtniPyQcsYKxlkXj4mIgJr/m94IFnPduCBxNMdHLtbBS8U4cugy0O6jWauN/2v+3ly3g2JQ2arN+uDvO7C7ySdLP4yLquNiUUsW6fYiSXv+/3wgGJxDhTNTrlHlv6B5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLQtc7wOexlDiAebSTQGq5I7YcUgmwFD6YoXUjbKDOU=;
 b=zH8Aqa2oMeudt2KjohNEyX3ltyoJpgVyHotKhwj9unGGnTTdSawjjq8R3HoKRd9+SLEQAuSrklU00fj2XsHg012UnqkpMBGPl/nxRFmxHLYPpeKCtJHXXNOm9xMIUXCDWbY549WK8zKjsPqTDwNwLbPE6iGp5mjQeJGZsQMwWS2MFm7OF+G9guY6FylgQLKWLres4Y/xBLUa2WOyqej5D/g6uiuFLF8TNLw0pdU78H9kJmA7UM9YZZurheHIYiJI8aOQGAY7U4nNcVXV2INZkUtCqhFyi4S3p7bzmes7X3W8h4STmstVVlDyNeRG5WBSe88ni2w4o3QFPFc6mwCmQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLQtc7wOexlDiAebSTQGq5I7YcUgmwFD6YoXUjbKDOU=;
 b=lNnEyICVyAJUtz3Bt6PUVHMv+rzAMS9uSrjKEfCT2u4JVZeVHpq9x5oj4OWgLHG0OoHgEb0Jw2IvXOVOSFSFT8Pm2HjcrIJvPbntb4xEpE8J39DwjT0DFsaXGv8qQJVtwYjYjrqxbS1WHuQIlWZCmC5wH8aqD4PoHNSWFWX7OsXhjQXPl7SwJuDHNf15VHN5Qec/mq9cqg7fnF+yBm76oz00v8Ao1Q3Z5SH25SudUDvlq4TYBVcbdfSccQTgWhqq3VyTu1dRAurPqXdCmglHyeYpcvOJG39lN0UgM5nQFS2MYRw826dolK9ieFmAmWUAyvIj3eN2kDKEajjpgMzfzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by IA0PR12MB9011.namprd12.prod.outlook.com (2603:10b6:208:488::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Tue, 13 Aug
 2024 12:52:58 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%4]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 12:52:58 +0000
Message-ID: <b4c144f8-5941-4bca-afdb-5feeb23b14c1@nvidia.com>
Date: Tue, 13 Aug 2024 14:52:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token
 correctly
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, lingshan.zhu@intel.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240808082044.11356-1-jasowang@redhat.com>
 <9da68127-23d8-48a4-b56f-a3ff54fa213c@nvidia.com>
 <CACGkMEshq0=djGQ0gJe=AinZ2EHSpgE6CykspxRgLS_Ok55FKw@mail.gmail.com>
 <CACGkMEvAVM+KLpq7=+m8q1Wajs_FSSfftRGE+HN16OrFhqX=ow@mail.gmail.com>
 <ede5a20f-0314-4281-9100-89a265ff6411@nvidia.com>
 <CACGkMEtVMq83rK9ykrN3OvGDYKg6L1Jnpa2wsnfDEbswpcnM1g@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CACGkMEtVMq83rK9ykrN3OvGDYKg6L1Jnpa2wsnfDEbswpcnM1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::10) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|IA0PR12MB9011:EE_
X-MS-Office365-Filtering-Correlation-Id: 33330c78-504c-479b-a181-08dcbb96db72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnpRbFhUVE9xRHhUc2FrQnh1OVRSRWZmTWxha1lacTAzU2IxdXltd3kxeXV5?=
 =?utf-8?B?cWFWN1VWVEE0SG9YWEhaWHI3My9aTkdpMDIzREJoL2VkVmNLK1lqbGRsdWN5?=
 =?utf-8?B?OGJYeksrMkVSUFFQRUpsUzN2QWNXalhDV2xaWlNjMGE4Z3NBS2Fmck9vQlh0?=
 =?utf-8?B?V3J3MER0WCt3cUFVREhyaDM1S2dEcUJ2dEFOMnVIZHk5U2FoQWRsbExoWVo0?=
 =?utf-8?B?WVJHUmcxVGlVYmd3eElEbDRMdExGaktVdmUrZHRvSWFFR3BWRUNGNzk0Q3NY?=
 =?utf-8?B?Ui9rK00yRzFmZVVuUDJZcU5ZSUZCR0V6SWV2T2YvajBlWUMvR0xOSjB1STA0?=
 =?utf-8?B?Ym92S2VPbFdyWGIrVEtiWE9NbEgrN3l3Z2pNU1VCY3kvdGdzbDhGd2xjcjV5?=
 =?utf-8?B?WmdPTlVmYWtvVVVXUGJqc2FkVEluMlJEeGJpcVhMTUlJVmtzdEVlWDg4T3Rq?=
 =?utf-8?B?S0RWM29EYWVvckt3YkI4MXlvNTQ3ZnJZVXdwWGlBQk9Veloxa0QvUTB2U0c5?=
 =?utf-8?B?cXVEajlNanFNSHNLbzZjL2lTZ1JrcTNVMStBaTMxR2g1Vy80Z2pwN0pNalFV?=
 =?utf-8?B?R09mNE5rbUF4bWRsQjQzME1MaGNQMnN0enBqSkVmVjRUUG9MVDZQVk16bm5v?=
 =?utf-8?B?UFcxeHVZMm1Xbm9lOENzcit6RHYwZm5sNmw0UW9IcnhmRE5hZDgyNXdMaXNL?=
 =?utf-8?B?TVk3Y2xDck9CWHBGTWRtUnNrelhHREwvc0lmdlc2S1NoTVlwVXNjUUJnODVT?=
 =?utf-8?B?ZmJpSERTM3pnYUJ1ZXgyYmM1d2RrRVpxRFhEVTYzb2xKYVo3NXpVOHZtZmZw?=
 =?utf-8?B?TEtEL2x1UmZEcFpCN3hwbFVTWWs5Y2lZbHloQU5uQjVpdW1OdkxKTzZjbHd5?=
 =?utf-8?B?c3VqMzFJZWY4TzhVY1NyV0dJbVVZSG52KzRGSm1ZK0N0bldJY0wwMXNNbzBz?=
 =?utf-8?B?WU9VNC9BTzN3OUk3WjYzZGRINm4veU5aUXc1Tzh2WmI3RkJrNHI2bStXQTgr?=
 =?utf-8?B?UWxSbFZpMFJ6WWVyMXN0ODJRNG5Hd3E3Z2NTV0VqR0x4NzJBUWFxeENsb0NU?=
 =?utf-8?B?RTdJU3lzL1RVTEwzdVNZcmlrRElXZEFJSmJTbWluekZSYlNQNVd0YUVZL0lB?=
 =?utf-8?B?NVd5Z0NFLzNrb0N2MWVFV1ZWa00vd2libUVOeC8xSE1xVFpPWFRVTk90Unhy?=
 =?utf-8?B?K2VxVUM0M09YZ1NoNSswL29Tc25xSGQ3YWlTVUZBRnI3MWI1MGRNUVI1TnJy?=
 =?utf-8?B?WFZCNHRIWW1BcEJNZm0vVDB6cVExS0U2MWFIM3kvbzBKVTNhK0xUVzlEY1Bq?=
 =?utf-8?B?S0VQai93WU43WHpBU1diNW03NWpKQ0g2VGpYeUh3eEk5WFNjMkgya0dMb2No?=
 =?utf-8?B?NjJwTlBmUjJ3bFhlbWNlTHNPVFk1clp5RFpOSktEdGNsejBxNkpGMGk3UEJW?=
 =?utf-8?B?UWdyNGdkYTRRaUI5N0xRR3FBbEorS0lOK0o1Y2daOGRxdzZ0VEZ2QmdISFBE?=
 =?utf-8?B?ZGtNRWV3TFdrRTFKNkIyeTF0UEtrdVVDZUFOWDd3ZU5vSWtuYUt3T1B2Rm1F?=
 =?utf-8?B?bUdVZEdvVlB2S3E5b283VndLcUFyWDRQeHR2UHR4QTZnQ3lVWU0wTExvQlZu?=
 =?utf-8?B?NkxrWHFxRE9XMHovYlEvTUlKMnVCZWlKWmY3K0I5a3I1MUNOLzZjSzl5NkxQ?=
 =?utf-8?B?OE00dDh0N1lEOXg1d3ZWaUkreEE0L1dpQ2JXOTdIUnRiRlpNYXdxck41U0Uy?=
 =?utf-8?Q?PoN8tRftsokJpUIkDLJ17VmGUqicckytY6CzbMw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0t5QmIwMyt1ZG1SRHlxakJoNlF2NFFEQmdnUjVOSGpYTDZ1UFZZcXl4cHB2?=
 =?utf-8?B?b04wNUlMZUp5dUgxem4wQ3FTWE5zUFJUQmpnTzd3SXh5R0RoMzdVSmh3anov?=
 =?utf-8?B?VFZ4cmF0ZngxcGdWT0VLaEJWK0VlRGlTRTkrQWVjR0Ztd2ZkK2hrZzZVc1dD?=
 =?utf-8?B?Z1p0aHhRS3lwai9mWHJ2bWlVekFFMEpqMjYwU1hncTNxSlYwaHN1OUk4UWFr?=
 =?utf-8?B?c3RsV2tPa3g5aVI4bnZJenAvV3czSXdDYjUySTdRSUlscnhDeFdBdkVueWtk?=
 =?utf-8?B?ZzVyK0xyblM3L3ZSQURsWDIrUFRhNy9pSUlrbFEydlRZWkEyUldleGJYTU9r?=
 =?utf-8?B?LzluQkJlOTBQbXU0S0pmbFRsMHVpWmxLS0plQWxYdmlZS3ZDZEwzYmFva2NQ?=
 =?utf-8?B?MWtnQVUzTlJKbDhCSEdxZEU4bmVFSDZ6cEZCYjFoQi96dnNneENMTEZYMDRx?=
 =?utf-8?B?RDhoS2YzSlFyUXczYjJ2SlJWcGRhK2lKa0dUMUk3NUlpWXBLYjQ2V2h4WWJv?=
 =?utf-8?B?WDEyTUZZMTF6WE1lQlhjY2kzTklIZ05udTFsVmo2cjh2ek55WjhOQzlkeHA2?=
 =?utf-8?B?OHk2WHN3N2U3ZVNYR05xd3QrYkN2TXFLZ0lYUU50aG9PQjhOeHpjayt5RVBF?=
 =?utf-8?B?Q3J1WHFxTC9lekhHUiszc2lnN2YwM00veFQvRmxyc25kN01hN0Fpc2V5RE9u?=
 =?utf-8?B?ZTlPdGJaVEhHaXg3V0VJUGJGQlFWZzhKQ3dmS1U0TkVBcjZtVUkzSmRuL0R3?=
 =?utf-8?B?Rm1iVUNJRnorRlBXVnl1c3IreXdnSE1RQU9JbURCWVRiQjNJMkdHVW5TWlBx?=
 =?utf-8?B?bXkyMWd6SWsxMnNqMmZmL282V09zNjgreVlzYmR5L21VR3F6bExZK29oQjZt?=
 =?utf-8?B?UjV0M0xiaCt6RUgvcXZSOUdtZFFSQWhBa2lDdWN3dTVVYjYvdzZpeHNlNCtK?=
 =?utf-8?B?eHVZblJhY3VFMlhjNmRlVzVOblc1TW9CR3B3UU9JK1hQZXRtaDZsQjZRUklC?=
 =?utf-8?B?YTF3N0NuNHk0UUtQSzhQd3c3N1pxMVMyRGE2cjR5K3RSczJsamIrVjg0VkpM?=
 =?utf-8?B?cjhJdDU2cjhMeHRSZkMwQ3dBUm14VkZabmJ5M1NOSzJ1d01CeDNuYVkxZUtE?=
 =?utf-8?B?bTNmSVU3b01ZcjJ4OFFhcGNlYk9CNTNmWEwrMjNDZ3VkeXZXQzdkaGQrekVW?=
 =?utf-8?B?SEQ4MGpjQkdhcnl5eWtWTkdta0pNaEpsTVkra3hTbi8vNHBGT2Rpd29IeTk4?=
 =?utf-8?B?YmdVbGRuV0d6R0ZFZk5JaHNsb1k3dTNQM2NJbzJIZjJRMjZQVytJMm1OaHQw?=
 =?utf-8?B?RjFIQkV3SndLTVdmaTk2L3VlTjJ2TTF5N2xWdDNWbTZiRUhpZGg2VGFsOW8w?=
 =?utf-8?B?QzhvNjBpbzNYMWZENEpUc1hjWWk2RjRiZEJZeGdqZ2U3Mjh5YWVIRHM3bm1F?=
 =?utf-8?B?ZDRXeHIxdmhzQWg5dld0c05EK3h1SXQ5b2l1d0J0MDUxb2lpVkEvcUJSL1Ey?=
 =?utf-8?B?QUlucnpnN2JZNFJnTlNrRHdzVjg0K3ZvdHpDaEdwenlScmtBd0VOcFpKTlFs?=
 =?utf-8?B?UW1SZWNhajJvWU5taGtNT0IzSUtQbTgwcm1UMm1zdnBMUmI2cDdpcHZmaUFs?=
 =?utf-8?B?Y1JVeW1XeXM3WG5SY3ZickU0UWdybHUwT1gzVVdsR3dUT0RwNGFlSDJFZUtK?=
 =?utf-8?B?ZjVNY0RFa1FwOWxqZDM2a1F4bFJvRXM2NVBOaFdpWHY5eEZtVE81TktHdEVs?=
 =?utf-8?B?QmZVUnlaaTI1Q2p6ZHd3VGlUcVk2bFdVMXBRaENjenN6S0VIN3pZUEs0TFJH?=
 =?utf-8?B?a0xrVDFNWHZGZk1pMndrYkY5ZDVmcndtenFMajhXaHJpNWxQYmtVcDAvdndl?=
 =?utf-8?B?NDNKVzg0b05Pd20xREk4UUtmWnJLNmwxekNlcWozS2VhLzlDNHFGZm93VHFU?=
 =?utf-8?B?QnBYWXFBZ2cxZlNJOGtma2M2VkRpYVhkYVdDK1E3eWx0Nk5qdm10TkVnblJk?=
 =?utf-8?B?d2lFVlNsUmtscTBqblh6cVhDVVJQNm45M29FRWZjZForR3NRVXp5ajFPdlho?=
 =?utf-8?B?K2hRRlp5eXdWQkxLakVERXJFZitGVlJYbmxlb1M4eFI2eC9MVFhFTDQ4WDZa?=
 =?utf-8?Q?MPgMuZdeUSXt2jVa0aL88hpLA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33330c78-504c-479b-a181-08dcbb96db72
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 12:52:58.3860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0v5vK1cIQ6XFrKBiyQyi0p81fPuG16tXHvpfrBCeXJKm+DQ9GTc9L4Uzdt82qGufP5QrUgOhq4800eBpKW4Hhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9011



On 13.08.24 08:26, Jason Wang wrote:
> On Mon, Aug 12, 2024 at 7:22 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 12.08.24 08:49, Jason Wang wrote:
>>> On Mon, Aug 12, 2024 at 1:47 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>
>>>> On Fri, Aug 9, 2024 at 2:04 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 08.08.24 10:20, Jason Wang wrote:
>>>>>> We used to call irq_bypass_unregister_producer() in
>>>>>> vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
>>>>>> token pointer is still valid or not.
>>>>>>
>>>>>> Actually, we use the eventfd_ctx as the token so the life cycle of the
>>>>>> token should be bound to the VHOST_SET_VRING_CALL instead of
>>>>>> vhost_vdpa_setup_vq_irq() which could be called by set_status().
>>>>>>
>>>>>> Fixing this by setting up  irq bypass producer's token when handling
>>>>>> VHOST_SET_VRING_CALL and un-registering the producer before calling
>>>>>> vhost_vring_ioctl() to prevent a possible use after free as eventfd
>>>>>> could have been released in vhost_vring_ioctl().
>>>>>>
>>>>>> Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
>>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>>> ---
>>>>>> Note for Dragos: Please check whether this fixes your issue. I
>>>>>> slightly test it with vp_vdpa in L2.
>>>>>> ---
>>>>>>  drivers/vhost/vdpa.c | 12 +++++++++---
>>>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>>> index e31ec9ebc4ce..388226a48bcc 100644
>>>>>> --- a/drivers/vhost/vdpa.c
>>>>>> +++ b/drivers/vhost/vdpa.c
>>>>>> @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>>>>       if (irq < 0)
>>>>>>               return;
>>>>>>
>>>>>> -     irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>>>       if (!vq->call_ctx.ctx)
>>>>>>               return;
>>>>>>
>>>>>> -     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>>>>       vq->call_ctx.producer.irq = irq;
>>>>>>       ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>>>>>>       if (unlikely(ret))
>>>>>> @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>>>>>                       vq->last_avail_idx = vq_state.split.avail_index;
>>>>>>               }
>>>>>>               break;
>>>>>> +     case VHOST_SET_VRING_CALL:
>>>>>> +             if (vq->call_ctx.ctx) {
>>>>>> +                     vhost_vdpa_unsetup_vq_irq(v, idx);
>>>>>> +                     vq->call_ctx.producer.token = NULL;
>>>>>> +             }
>>>>>> +             break;
>>>>>>       }
>>>>>>
>>>>>>       r = vhost_vring_ioctl(&v->vdev, cmd, argp);
>>>>>> @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>>>>>                       cb.callback = vhost_vdpa_virtqueue_cb;
>>>>>>                       cb.private = vq;
>>>>>>                       cb.trigger = vq->call_ctx.ctx;
>>>>>> +                     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>>>> +                     vhost_vdpa_setup_vq_irq(v, idx);
>>>>>>               } else {
>>>>>>                       cb.callback = NULL;
>>>>>>                       cb.private = NULL;
>>>>>>                       cb.trigger = NULL;
>>>>>>               }
>>>>>>               ops->set_vq_cb(vdpa, idx, &cb);
>>>>>> -             vhost_vdpa_setup_vq_irq(v, idx);
>>>>>>               break;
>>>>>>
>>>>>>       case VHOST_SET_VRING_NUM:
>>>>>> @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>>>>>>       for (i = 0; i < nvqs; i++) {
>>>>>>               vqs[i] = &v->vqs[i];
>>>>>>               vqs[i]->handle_kick = handle_vq_kick;
>>>>>> +             vqs[i]->call_ctx.ctx = NULL;
>>>>>>       }
>>>>>>       vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>>>>>>                      vhost_vdpa_process_iotlb_msg);
>>>>>
>>>>> No more crashes, but now getting a lot of:
>>>>>  vhost-vdpa-X: vq Y, irq bypass producer (token 00000000a66e28ab) registration fails, ret =  -16
>>>>>
>>>>> ... seems like the irq_bypass_unregister_producer() that was removed
>>>>> might still be needed somewhere?
>>>>
>> My statement above was not quite correct. The error comes from the
>> VQ irq being registered twice:
>>
>> 1) VHOST_SET_VRING_CALL ioctl gets called for vq 0. VQ irq is unregistered
>>    (vhost_vdpa_unsetup_vq_irq() and re-registered (vhost_vdpa_setup_vq_irq())
>>    successfully. So far so good.
>>
>> 2) set status !DRIVER_OK -> DRIVER_OK happens. VQ irq setup is done
>>    once again (vhost_vdpa_setup_vq_irq()). As the producer unregister
>>    was removed in this patch, the register will complain because the producer
>>    token already exists.
> 
> I see. I think it's probably too tricky to try to register/unregister
> a producer during set_vring_call if DRIVER_OK is not set.
> 
> Does it work if we only do vhost_vdpa_unsetup/setup_vq_irq() if
> DRIVER_OK is set in vhost_vdpa_vring_ioctl() (on top of this patch)?
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 388226a48bcc..ab441b8ccd2e 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -709,7 +709,9 @@ static long vhost_vdpa_vring_ioctl(struct
> vhost_vdpa *v, unsigned int cmd,
>                 break;
>         case VHOST_SET_VRING_CALL:
>                 if (vq->call_ctx.ctx) {
> -                       vhost_vdpa_unsetup_vq_irq(v, idx);
> +                       if (ops->get_status(vdpa) &
> +                           VIRTIO_CONFIG_S_DRIVER_OK)
> +                               vhost_vdpa_unsetup_vq_irq(v, idx);
>                         vq->call_ctx.producer.token = NULL;
I was wondering if it's safe to set NULL also for !DRIVER_OK case,
but then I noticed that the !DRIVER_OK transition doesn't set .token to
NULL so this is actually beneficial. Did I get it right?

>                 }
>                 break;
> @@ -752,7 +754,9 @@ static long vhost_vdpa_vring_ioctl(struct
> vhost_vdpa *v, unsigned int cmd,
>                         cb.private = vq;
>                         cb.trigger = vq->call_ctx.ctx;
>                         vq->call_ctx.producer.token = vq->call_ctx.ctx;
> -                       vhost_vdpa_setup_vq_irq(v, idx);
> +                       if (ops->get_status(vdpa) &
> +                           VIRTIO_CONFIG_S_DRIVER_OK)
> +                               vhost_vdpa_setup_vq_irq(v, idx);
>                 } else {
>                         cb.callback = NULL;
>                         cb.private = NULL;
> 
Yup, this works.  

I do understand the fix, but I don't fully understand why this is
better than setting the .token to NULL in vhost_vdpa_unsetup_vq_irq()
and keeping the token logic inside the vhost_vdpa_setup/unsetup_vq_irq()
API.

In any case, if you send this fix:
Tested-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos
>>
>>
>>>> Probably, but I didn't see this when testing vp_vdpa.
>>>>
>>>> When did you meet those warnings? Is it during the boot or migration?
>> During boot, on the first 2 VQs only (so before the QPs are resized).
>> Traffic does work though when the VM is booted.
> 
> Right.
> 
>>
>>>
>>> Btw, it would be helpful to check if mlx5_get_vq_irq() works
>>> correctly. I believe it should return an error if the virtqueue
>>> interrupt is not allocated. After a glance at the code, it seems not
>>> straightforward to me.
>>>
>> I think we're good on that front:
>> mlx5_get_vq_irq() returns EOPNOTSUPP if the vq irq is not allocated.
> 
> Good to know that.
> 
> Thanks
> 
>>
>>
>> Thanks,
>> Dragos
>>
> 


