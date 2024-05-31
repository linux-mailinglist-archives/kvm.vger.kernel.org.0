Return-Path: <kvm+bounces-18520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1D98D5E30
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 330881C2103B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB0580C07;
	Fri, 31 May 2024 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iNZdVjcW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8C978C92;
	Fri, 31 May 2024 09:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147643; cv=fail; b=j8XwWCUBdyp5tj6TOjRMYMMbhSELgL3ORHY6CE0HCnah1CCaYEO1PQWaS/hGd5DMhEu6Ux9FoiJXnaO+hqxa+MtGh9LmsaTcEToUDKsZQZssxSuFfr/ijWv3K3HW9/ape0ca+PErpwJPyp4u257BrwaymF8bHq4Qvzo9s9mV+gM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147643; c=relaxed/simple;
	bh=mgqhPFIcjmL+kYZxfLQQg4a+Q30a7EqY/dXkRMcfxgY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=afsVE2h1LtMaUM7zmhp+H4ITkrdjw7GUp925ZXm2Bm+X9Q6VU9lpbJJrT0CQeKnyc2+c68qXAUBw1uHBhVNpbQQ+AxDs3EWC6WqZZCqENseo3lgYJy+b9bwRr24ok7aaN0hkR+8jjVLA/htZhmPdxa8WQnlX2rFfAF8uX81s8AU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iNZdVjcW; arc=fail smtp.client-ip=40.107.100.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5y6L3GshN7x3C2cQZTXOVZpwXOrEbqyygeJhgCSVU+ihq+L0TUPiE01YNEjyQl5XdJ6U+LoAepmzqL2XmK/1UAo9geNS3Z6ZfCWyTBTMNSdV6xGypOfXRmz2Lhx2BtxHXHAhrY/9JyAMDc4GWa9dVW7cimTqfaO3eA9B3Hv4GNeOPddC3u/GkV4Qwxy6fpi6dqVOczv5j5znrRWARYc7Tyu14Mh1AsPReG9jnGiTj7kBfl5zj8DLIrDfEwsllnx73jONi1PRI5CSpxEsrvwU06BYxtCnskeskslqQqI9YYIoAvJPz/T52tQxf/DizRCbC0pJd0zVxS1L1eq1CmJAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/J3CYrImIWEGN1dpKfgx/c5+IFjxmpL5oWhmgHfmWc=;
 b=lQg3ef0oKxXk5vNexufCxps5CjtkVEb+x/aBgCfQSQdRORfhgUwg3XmuujFfpgJEgYiDLqS6ErttGUWCX/m2Jm1itBwgtW2Ta0Go3tNodgq+s4CrQU80R6sJZTU7a9xdqbE8PpsdBqPGB7bj9zV+X3eMMcBIOD26gFsxGn2VmDA44XGb0OSYJt2AY1HfaNa6sxsV+iO5VHaKSacyyOcP+INYdpHcFmL8LuR8vXgIBkjGwSV31nabC7H2hejGk9VhoykphsMtUdwyGj7bt6+jOdQxlg9B3OxVy0a8RDLT5Xu0coKnb+aVsLoHvKLLcJnto3ZaeSwdYv0Pc7iolprTKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/J3CYrImIWEGN1dpKfgx/c5+IFjxmpL5oWhmgHfmWc=;
 b=iNZdVjcWJvurgYBzE6p9su0o+rhLZyJC28b9CwWG04tns9ccjEfBoFzbQp13Ig/QFXp6YDCBehjpr3aGvMqY56SqHEadsvO+i5TuzSui+D2hghwxE6qoNsqPZ88uNU2pzCTkiA06HvKH5E9SMYUqtkqRb1YZ1NwRYP1CveHyq80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM4PR12MB6303.namprd12.prod.outlook.com (2603:10b6:8:a3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.30; Fri, 31 May 2024 09:27:19 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 09:27:19 +0000
Message-ID: <ac8d6cca-0f59-4d03-8c11-d1b0f2fd3c08@amd.com>
Date: Fri, 31 May 2024 14:57:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: x86: Expose per-vCPU APICv status
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
 <20240429155738.990025-2-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240429155738.990025-2-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0133.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::15) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM4PR12MB6303:EE_
X-MS-Office365-Filtering-Correlation-Id: d28898b3-66f5-4a49-6f87-08dc8153de1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDh6ZGZCcjU3TXFmYmZsNUh3ZktOVjY4Zk12QjlPSnNoTEJHbGwxeWwzOHEz?=
 =?utf-8?B?OWVsMEZ4WXc0SWJrUm82bUtxQmFZcit2L0tGblM2Z3JybkpNSGszbGlaM0VF?=
 =?utf-8?B?WDJzR3dxL0hpSWh0b2d2cTh5b3FIb3RBbWI5OVhjaWFPNlJBRHdZbkJBVTBh?=
 =?utf-8?B?Z2hLZC9HdTdLd0l4QlpJdmxhVVloWlJXcXUzZm5MS0JTT2J1dWpvQ3NuOWx0?=
 =?utf-8?B?MFZVeVV4WjNMbU9xaFd4TFBGdnZ5YVFRdEt1TG4vY3BkS2J4am5YNVM1VXhi?=
 =?utf-8?B?eHIvS0NnUXFuQ0IyS3JKdXQ2V3k3ZTNhbVFlODdYM3NCckdIMStucURYNFYv?=
 =?utf-8?B?SE81eVhXNGkyYUZQOGVlQ1AwcE1LSTJKYmFzYWpIckFKdUFVaHd5UEdiV0pJ?=
 =?utf-8?B?MkNRVnRCd0Vmck1CakYxS3FVcTFzRWdXQzZpL2NIZmp3Mk1aYjI1YlpXMWxP?=
 =?utf-8?B?L0JER0Npc1FEVnBSZjFqc0RhT3hRRHd5bmE2eE9tSnVoUFJGelBDNmV5dTBH?=
 =?utf-8?B?SWxTakh6TFRuMXUyaGp0eXdPYzhVTTd0b21PeTBub0pQcFVrMjhEdVpieEFx?=
 =?utf-8?B?SHdza1JZUWo5MzN1Tk5MSi9aTGlFY1A5UlVJQlVXS29DYTRPQ0hqVC9DMHRx?=
 =?utf-8?B?eE5mQTFkM1JKUEZQTGdxc25sSTk3bTBpRXJnbzh2cC9aVTQ2TEdXdTBLYTNG?=
 =?utf-8?B?cEpUZ055b1BXVmovMnNGMjcwTmxUOWlQdFk5cVJaV1AxR2xjN0x2VXJ1VTlO?=
 =?utf-8?B?VjNYT2JTNlFNMkIzUXdsa0JJN0YyVlVua2hBdlV5WC9oZTJzM21iS3l0OTBk?=
 =?utf-8?B?U09TSXZyaStnNnArTHQwZThZTGxZeUtzTitIRzQzakpLVlJnNDB2TUhaMEEr?=
 =?utf-8?B?K3pWV2FyalBoclp4TVlVUHpGWnBXUGRFbVYvSUZuUXQ4cDMrNjAxOGNvU0g1?=
 =?utf-8?B?OExBSk1sQTl4RTRIYUxPTUUxbzRrZWl5UXVQUDZyY3NCM1NTSVpFVkJtemRu?=
 =?utf-8?B?TERjNmVoUXZqSTdiSjFndnJIQnZyY1R3RVJJMng3UTZaTnczajBoNDYxMDZu?=
 =?utf-8?B?d05YSGtjUXRKNU00R3BGV0tCaUduRTFWeUpQTlF6Ykxua2NYL0tDay96c24z?=
 =?utf-8?B?VXN3R1grR2VaamN2RlZZVVU3eXdEaHRUaVZ6RXc2NEFTUXZuL0t5NFI5R3VR?=
 =?utf-8?B?SitZaGtkUVduOHJ3am1YMmJ2bk5LbVFPdE9lUnAyU2IrSW9tSVdhd1g5TkhQ?=
 =?utf-8?B?c3VwaktjS2RJSUVUWEQ1UjJ4TTQyV0JLUEl3SkdoL3ZKb1g5UFc5UDJiUTkr?=
 =?utf-8?B?ai9haWxSUUZ3VEdwZjRBS0d5Uk9YVnEvWVo1akJNbFNURytld3NhZEhSN1d4?=
 =?utf-8?B?ZHMwU3FxN2NEVVI2SG1hMldGcGhUTjZUM1dNM2pXK1RUUENxTEFwUEZ4cW42?=
 =?utf-8?B?elMyRWxsOEVLb2ZuNk10SXVsblpFRXdMR0NPemcrcUNMbGF5VWZHVnBWSjBs?=
 =?utf-8?B?QjUxN281UWJjRkxSSkdTaUJhSVloTUhUdkxkZmFzM0FEOFliOTVMOWRscWkz?=
 =?utf-8?B?bzFWa1ZpQmd6TlR1TE0vTGNMOXJWQVQya0IvVm9lVG1udlZ5QXVEeTY4bzhP?=
 =?utf-8?B?YnhQbGVTVXVwenJmUGZqMjlsd0NWMTZxb2FGbHJTS1YyNkVsRlNFNGRNKzBW?=
 =?utf-8?B?Zzd5ZXhMbjhjSkJVUjBnVkwwWVczc2d2UnBaamZodHltZVppNlVhWnNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekRPM0FKQnhZNzFUcVJPakNSM3NnOHE5eDNlWmhsTk0rOHJLRy9SQVkyT1hu?=
 =?utf-8?B?OUVPSnpPVTYzNk5pRS9CU0FvRXBSclE1anJKOElwbEMxeS9mWXhDbElpZmJa?=
 =?utf-8?B?Sm83V0JQcDZ0bzBCVGpDNEJ6RnVQZ2plTHNtL04zNE9LUTV5Wk5LTFdnQzM0?=
 =?utf-8?B?RzBaOEgwaXZBc3FxK3EzUXJSWldQc2RBdzN1QVl2bmVSaSt2Rm5LTEtIQTl4?=
 =?utf-8?B?MURFQjFaTWdLNHM1MjFIV0MwNFBuUlJlTTY4T21DL1B3TkkxTmxFNVJsRkFZ?=
 =?utf-8?B?cVpJMzFXMlV5RE4rOEhVd3pieXh0V2ZTcks1Y0JiZE9SdURYTEJBOVB6aXp0?=
 =?utf-8?B?b2ZCY2RCUFVhZFpoNzlPS0Y4eFdobldUQWRvM2Mvejl2SWFxdWZ0WVlwV3Bo?=
 =?utf-8?B?bENzd1dYZTkzWlZ0V0t6SHpSSDBSZm9mRHhMRXhUUkdySjFQWS9NR0RwZ1Bk?=
 =?utf-8?B?V0VGS25Nbit2SXA0RkxTNHM0RnZneGdWdGV5cWY3L0paMU1KaHJBTDBQYVVP?=
 =?utf-8?B?dnIzdUc3NVlDNGJzTUFvZW9sV3VGL1ZGOWd0ckswa3cvdDNBRFRBV3NvNVpR?=
 =?utf-8?B?SnBBNVFhTWlGZmVsY0ExYjhzbTBaZnhST2tIRkF5SlUwak0xYWxsd3V4SW1a?=
 =?utf-8?B?ei9SWFgvM1dOMEE4Q2FlVE1CYy9MYTUwYmFJT3JkeEtTNlFoODh4MkUraGYy?=
 =?utf-8?B?Yi9nMHlLMk1UcTBKSGZLRkZ3RE9ZQzRNTk84ZnBoS2d4SzBEbDhQalllSlJK?=
 =?utf-8?B?Z0NzOHZqNzhSSDFtczFtYUV2S0U2c0N2V0VIMHplVW1TeS9mSzJ0ZDNEeUVq?=
 =?utf-8?B?c0lxZHpmVnhZVWxXYW54akFVZXVGQ0FZOVZrNkg2UDhNZno1aHpRdWNQdzdF?=
 =?utf-8?B?MlBiMjArZnJtNFUwR1QzUFp6UFB2b1F1YUhpb2hXTUI5S2VaSWZzQVlCM2NL?=
 =?utf-8?B?cnhVV0FUQXBISGdHVEFEUDQvbloxWWY1YWVtRDNpeGYrTVlXZ0kzYVFaSXMr?=
 =?utf-8?B?N1RtQ2gvcW5OQVgvMlhHYnpUTjREa3J6eUoyWGlicWUzMk9VNzBJMEVIdEJq?=
 =?utf-8?B?YjgzbUtDaWhYQVJlM00zREpnc05KOG13WFhzNFJzMkk2VVF6Nm8yZmNFemdw?=
 =?utf-8?B?N0QxakFTenYzU0RiNFgwQW5lRnhDTE9SU3I0eU4zL3dhMDdJZWs4cGd0am1p?=
 =?utf-8?B?SVhUdkxOYWVRbG1NVDlSOGJhaktoRENlOFUvMVVrcS9TNXBVL3NUdG5ucWdy?=
 =?utf-8?B?ZEpJN25TY1VrNzFPV3l3bktBNUJYSDhIZGpBZE1tVFFDbDdhZzJjUi9rV1VZ?=
 =?utf-8?B?bHd1aXE0Syt0L2Jqa055WEt6VC81aWMrZnBCeFpNNjlTbndSdGJ4Z1FQZGZt?=
 =?utf-8?B?MzNtYVNzMUNsbGs5eVVsa3kwb29BL2tOUXFZck1HcStNV05Cb3I4NlQvMHcr?=
 =?utf-8?B?Q3cyT3RkRHJzRkFlcWxHL3luUGJNdzJSb1Jab2llZXVhcHBTeUtYRzRPbk1U?=
 =?utf-8?B?aGVBMHhXS1hmMGJEMEJFdVBxUjVMTVJXdVRCOEZ4blhZZUZ4T2FBVjRrbjhu?=
 =?utf-8?B?UTBIdXJycFJNZVlxVnpjdzA3MmE5WE9YQ0kyS1dJNVlueFB4UXNLSi91QS84?=
 =?utf-8?B?MzFiWUh4KzZ3a1IxaEM5N1pkZkJQQ1FrcHV3eUV2aTlzZGtlaGd6ZWwvYkNZ?=
 =?utf-8?B?Um81cllqelAyOThSZTRpMmxqK0xzcjdUWEJXSlFwTyt5NWtDSlVEWmdCbmhX?=
 =?utf-8?B?U0ZGMU1ENmJOVi9Yc2pxUXRBZWM4M2E0RngvYmxhMERnK3lBVHJtdjU3SVo5?=
 =?utf-8?B?YnYrQlA3dEU2ckFMbnZwV0VkRStXRE1YdU5aVy96WGt3TDhWNnlDYkZGQnJs?=
 =?utf-8?B?UnFvSzl5cFEzT29adUJMc0FCSWcxc0JBMFh2WEVXdisvL1lxTzdPZnplSnNY?=
 =?utf-8?B?K3FCNVBLWHRWMENhTWxVTFZKNDBLbG9CNmxMTGRFbk9jYTVwaVlMZkVaZHpx?=
 =?utf-8?B?YkMySnV3Y3JJSmp3cUdJTlNiQWdOV0pjQ2lBaDFHd1B6andFeHhVdUNGZS9l?=
 =?utf-8?B?V3hIS3ZFS1llT1lzMzJjMUEvQ3E3TVFHNWNYZU5xWWorQXV6TXg2WFhGMEhD?=
 =?utf-8?Q?qJGz+3rWKNNPkJIAq1md4Nc3N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d28898b3-66f5-4a49-6f87-08dc8153de1c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 09:27:19.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AcmsmghOv67vTDIkQmvXUTJZoxhJGGuJq365aCbHfjUqlVD8PD8OhMZXGlFiwZ2LOb9I5Kz8wcSKiddJEtLqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6303



On 4/29/2024 9:27 PM, Alejandro Jimenez wrote:
> Expose the APICv activation status of individual vCPUs via the stats
> subsystem. In special cases a vCPU's APICv can be deactivated/disabled
> even though there are no VM-wide inhibition reasons. The only current
> example of this is AVIC for a vCPU running in nested mode. This type of
> inhibition is not recorded in the VM inhibit reasons or visible in
> current tracepoints.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/lapic.c            | 1 +
>  arch/x86/kvm/x86.c              | 2 ++
>  3 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1d13e3cd1dc5..12f30cb5c842 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1573,6 +1573,7 @@ struct kvm_vcpu_stat {
>  	u64 preemption_other;
>  	u64 guest_mode;
>  	u64 notify_window_exits;
> +	u64 apicv_active;
>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cf37586f0466..37fe75a5db8c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2872,6 +2872,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	 */
>  	if (enable_apicv) {
>  		apic->apicv_active = true;
> +		vcpu->stat.apicv_active = apic->apicv_active;
>  		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>  	}
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9ef1fa4b90b..0451c4c8d731 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -304,6 +304,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, preemption_other),
>  	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>  	STATS_DESC_COUNTER(VCPU, notify_window_exits),
> +	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
>  };
>  
>  const struct kvm_stats_header kvm_vcpu_stats_header = {
> @@ -10625,6 +10626,7 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  		goto out;
>  
>  	apic->apicv_active = activate;
> +	vcpu->stat.apicv_active = apic->apicv_active;
>  	kvm_apic_update_apicv(vcpu);
>  	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
>  

