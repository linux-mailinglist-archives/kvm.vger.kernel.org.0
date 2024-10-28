Return-Path: <kvm+bounces-29848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9104E9B30E3
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F7A82829FF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8C31D63D2;
	Mon, 28 Oct 2024 12:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GXldK20L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F7F18DF83;
	Mon, 28 Oct 2024 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119714; cv=fail; b=OeJ4wPYeax0ecaIs6Z8N5JR2T3HdRAaXjGRjoNf9s87GcZ08OSadY93BV9u1M51FDQFWc8RtDnsBXEWbLttTYAm6qCuAA/sIqoTb8pk+C0RhJ5JAnxQ1csDr6OEyl6QmHz6FHB+QgibsxLeqp+KarmkZAASENNjrfsbCznhn+S0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119714; c=relaxed/simple;
	bh=X+MbI/2DTsyDNIdN3zIi3ULkrgveIduxUn7d+XB+yoE=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KALBt2PwMNyNLPNjC9GQfkGSKyrRgRhuRWlFGFSq1ij1ljVZ43VjhCe/U2MCt7BGry91lfcf/QM4b9a4IrYKfcamXdN5FTiDd6SWFeifsjGu5/8Fvfz4A7mdkjlcbocEHpOaEglwR8P08tAoooxiAwrK9b1VkboczPSuFcJAA/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GXldK20L; arc=fail smtp.client-ip=40.107.220.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pu+/TvDKSXGUBqfajKwZXwKe+3MeoU2iGXeJVijrh0DdRum92olfqsn7gKHf+K294OO23306sTF0qJnoVVjbx3liLLldeboc/A2ueGwU70I9Dd3digQoMot5JMwIbwvbirRhMqaGEMtYEgsmWqA6tSOl0JOuCk7PF4FbePTH1jQD7xaAjGQP+kU/5i+GqF5NZihxtM9nm9ZJxcwumG4+NeoygXEMucbbOI9S75biOLzfqWeeWXOBEJzj9VIECM8TtMbTcSw+FmuXG5RjV7UYVAz/MN725NjLcUSw/RlHOH2gX2QKIqwBGKxOCPL86i2amJTmIe6gxAzQSS5URzPN8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozKGI8YiP14dtWCK6fmR8iWJMUuO8TwZTluR4ScOYGs=;
 b=N7gr7lHAzZgiQ1GX/WVrWpPW7Rpo1Im2iELNNGtwrDGPMk9e2FXSus0bUPH6vyCTvtzWhDh9Io+G58PlW6mB4DPnNlmsglJNbfPjOhUO0JBp///I237L7bxAVZY6PuyHd3s+EstrPTUAAwZknwGmM3/qK+Ovi9xWut+xsspWoz1Lw3Pqs7gBJ30tV1bdtOpjOdxglp1a5soLG4YSlVBJj0yBgnmIEuOlnkmH9OYX557a41/wp88GWnvSx0lPYLwoHTynhvMYSBoLabD/z+/QzYmmBHogv4i8uNr36JdzjuQmNydYiPei4pGv+eBCrSRCy0pEjt1CRQBObM79j85VFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozKGI8YiP14dtWCK6fmR8iWJMUuO8TwZTluR4ScOYGs=;
 b=GXldK20L1gxLA7wtCT94QXwz7DwQ/K0zJP/DOq62eTOQ0dCEudENrYgpanyjFGOgSTzaaXhSbNpRN9uvDt/EYwwCIA6thl267zftd/mW1d2jFu90TCpsjTpVn2UPL3PM194ikwHrQGVCud1KwbVLjIDetvGFwQqZMtbhyCrnkUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH8PR12MB6747.namprd12.prod.outlook.com (2603:10b6:510:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 12:48:27 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 12:48:27 +0000
Message-ID: <17a9e834-48b2-c56d-3a62-6f8bcea90758@amd.com>
Date: Mon, 28 Oct 2024 18:18:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
From: "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
 chao.gao@intel.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com> <ZxvGPZDQmqmoT0Sj@tpad>
In-Reply-To: <ZxvGPZDQmqmoT0Sj@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH8PR12MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: 28e81521-8982-4a2d-72b4-08dcf74ed13c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1VFVXQ4bjVWTVpEQ2prbXZwUzM5bjlISlhLUVIxVGVIbTE3bVhlY1JDU2I4?=
 =?utf-8?B?M3F5anlRaVNhZWlHVkdpTFY3L3dkUXlJa3dxcG5FUGFSaU05VXZiOU5nby9V?=
 =?utf-8?B?bUIvYmVUUGZyTHhYMjlFR2dYSlVpc1lVMWE5ZG00ZUZqZmZYVENNRnFXWElJ?=
 =?utf-8?B?MDBlQ2ZQRk9ZTzN6L1RmdGRmcmNOYUt0MEhWSHFuSFFIbm0xeHc3Y3hKUFZH?=
 =?utf-8?B?R3h6cmdtbTZ2WHJ4VHRoTU5XY2dVeVF2a3dqQThHRUtsYU9UVkl6b3FCdE9Y?=
 =?utf-8?B?dEM0NDRLcmNjaU5iMG5ENVZqV0hjZnFRYW1qb09VTzVIY1NnbUUwM2VYZ252?=
 =?utf-8?B?Q0xxVmZ1SWRWc0ErbnlKZjk4ZUdab2xFMFhpazlrMGZDaEJnU1JtOUVCb2Vl?=
 =?utf-8?B?aVlCZWd0QW81ODBjN2tyNlZ0Y2Q4WGlqMjFqL3p2M1M4clc4Qkp4emV5Smtt?=
 =?utf-8?B?MEd0RWdnK2tIeEx1eEZMcHVhOTcxbUZERlVwVkcwOWtDODFMTnVnbDkwZlo3?=
 =?utf-8?B?a0NUaU5pSzI1akgzVjl2UGxHZnRrZExVNUFNeGhYYVJGa21JSElWTHp6UEZ1?=
 =?utf-8?B?bnNiTUpJRXM5cnRoU09XZm52TmFuaURZbzhkZ0hFR3BBYTROcDNMZXQ1eGNM?=
 =?utf-8?B?bXErL1djaVYwM2g1M1ZGT004Zjc5M2xscExocEdsRlNCNHNTYW5qNTBTZUNJ?=
 =?utf-8?B?OFp6VTQ2cTZtaHUrU2w4cWw4SURZUENOL2JjOTdrcE5hWVFzRFgrMmhTNEFF?=
 =?utf-8?B?VjFXeUVLZWhxUUFhLysrYWRWU2pNYmJYRWlaVUhoYTlNVlZRTU14ZkZUaEpP?=
 =?utf-8?B?ZG8xOXJvUUhEQjRLcGhaOGkxeWQvQ0c3UU91ejlIcTdFTCtZeEFRVUswYks0?=
 =?utf-8?B?NEUxVDRUZ2hSbkNGSlZ6bkN4MjBhcDRVN3BnZVlKb3B3Z3VlNGE3M09lV0Qx?=
 =?utf-8?B?M04rYWpZbHRqWUo5VE5rbDRKSXpNZ2p5QU1OZ3NIMWdUT2drZGdDNmdNaG0v?=
 =?utf-8?B?WEdMdjVyRWYrSVIyejdFbmhTVkNyeXhYS2JFRmdRQjk3bUdORWlBYTdCdHkr?=
 =?utf-8?B?dXlJaThmS0prWE1SalBuWWNBaXEzVXowVTNaWUJVaWVBcXhKcDAwV0VrWFJS?=
 =?utf-8?B?Z1lSbmZDUjJ3K1RUVGhoRVJKN2c1OUxRZ0hlSWZUMTZQNzRoQ1N5VG90bzNu?=
 =?utf-8?B?T0llcTVXU3VLK1lybStocDdMeXNwTzFKMTZjMk1VV3RCWWdOakVPeHd1cmtM?=
 =?utf-8?B?UG8xbkVZbHJDQlVJcUdabjNiQSttSm1HdXlGa3o1azBFZmlRbmRBOGxGbERF?=
 =?utf-8?B?S0pmMHlUcmhralNtWDIyaytLbk94Nis2bTltTWREcDhrUklWdkp1TkZTL1Bs?=
 =?utf-8?B?VWZncUdLMkF3MjM5UndYT1VsS0JNM3BTeDZEQzBKU0JnUkxKZW1iU09OZGtN?=
 =?utf-8?B?azZyNzFGNHdLK2kwN0VGYTAzTWJYUUJ1SUk0ckpYczA5a3JBZXIxZ3ordGd0?=
 =?utf-8?B?Y3V4S0N4ZkMweEdGS1ZSL2NmU2dlV0xkQmUvekFKQ2tnWTlEbS81T3RzcFIz?=
 =?utf-8?B?RW1LendkTEluOXdTS3BaSzdvZVJXd3dEQzcxMVhtVUxPbHhLL2ZNV0lsdm44?=
 =?utf-8?B?SlR6YXp5YnFIcUQ2N3MwVENGdURwRjY1NXBrSmVKcXhNZEFnM2tPYTdqV1FQ?=
 =?utf-8?B?RUVVd2x0djVudUc3bm9NOG4yVzE3UlV0Q0lCMHlYU1hjY251YlNsMnZrTFpK?=
 =?utf-8?Q?SDPQB2UtPGm+HeF0/jLzZy4CumrwKnH0AMC/F06?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUFsOVBWcGRNUGJvWTRvemR3NGl2eVVtUjhjS2VHSHAxczNKMWpBYXpQc2tH?=
 =?utf-8?B?NHdXZ2QxdGRha0tQejFmNGVRZXZ1SkVjUGYvL1RwYU9vTDFib0I1RTBKNVYv?=
 =?utf-8?B?NTJDbnpGSDVhaFdOb3RZVkZBWVg4cm9NZDk3YWxNcTBhc0hWeGJrdnZkaS9C?=
 =?utf-8?B?M01ZMDB3V3dvTWxvdjhEZjhNUEZqNjZ4ZFp0L1hlbnJsZGxZejNoUzZhVmpW?=
 =?utf-8?B?WGNSUC91SmFYc25BamtIMlpPcTlyRVNVMzl2dTgrTzJ1eHhaZHp2bHJkYjZO?=
 =?utf-8?B?M3doVFRIUFVxKzJjdy9rMHVXbUtKVjNEQWNzd1VVSVJ4bWU5K05WSG52NUN4?=
 =?utf-8?B?NjdDMEk4RGJveVp5cmZCem1BcWVraTA2TldZaG4rV2NseUxNZnhySVU0U2pB?=
 =?utf-8?B?TG5UVjdTN2UraGVGdm92TmZReE1qRlc5TVJDUmI2TDFpeDNxdWdDa1Q0YmZD?=
 =?utf-8?B?bnVjZlE5Q05uRVJmY2VCUVZDdFJ5QjFVSUwvVDVidTRsZDl6U2FQbFJ2UVow?=
 =?utf-8?B?bWJlMjI2KzQzaTNyaU5MVGZBUFI4M1hTUDVObmJiMlZ4eHFJZ3lKbmQ2UG1V?=
 =?utf-8?B?RUZ3UXpESm5Xd1BxTUpZT3FIMGJzRlNidUxFdHZQcmd6d0ZqMHN6MVVwL1V4?=
 =?utf-8?B?emtTS2F3M2lISis2Q21QcmtGODRCTEovcC9DZnRmamU2eUtaeVR6bGZPYTR6?=
 =?utf-8?B?OTRNcyt0TWNmYnJLdEo5dGFETWFxQ21Namh4VXRQL2tHOEg0bXFCL3VSZ0I1?=
 =?utf-8?B?TTdXYUIweTdPd09NZHVUdUpaMzhibElHZFJNR0RSZUhKVWRVRDVpR2JmZGtP?=
 =?utf-8?B?SERpTUZQMFowa1RiZ1NVMi9TU0FNaE9hVlZwTXNqMFI5cGdJUUhDVzJyUXdk?=
 =?utf-8?B?U2FKRkp0ejFJNnBLcThDQll5clhJUmwyR2h0MjJ0RXAwV29IUm9mek1mVDIx?=
 =?utf-8?B?eGU4dmppUlhsUkVoSFdkMnNJS1hXaHlJK1VxUDByWG9ZNGZlVUI5MlN3UlFR?=
 =?utf-8?B?TE9YWGp2cFdNaGhsdVN1dyt0SnJBbXpERU9PWlI3ZG03YnNaYVZJWnNwcWtO?=
 =?utf-8?B?VVBOZ1JYTStRR0pmM1B4dDBtQ2JTU3BOTk9TM3lYdkRzRmM4SzNPQ0I0N2RK?=
 =?utf-8?B?NTFLRmkzMmVrNXlIaUVYYmw4S2cxSTBWRFdFRmZzWHNJVkZnQ1lpL3BFSVAw?=
 =?utf-8?B?bWdJK1Q1OEVNUEw5WGk1N0ZPdmlZQ0RlMDJiYWp3U2VzUlZCUWtEVm5FQmdR?=
 =?utf-8?B?Z0FWTUNRKzBGeWJYalA3dCsxZkppQVpqMHBTOHNvMUdsNXFZRjdYWHBTbEx2?=
 =?utf-8?B?aFFvczhEaUdjVTh5a2hpMmRBZ0R5NmVYdTU5cStlTzM3Zi8xNEtLOWRoMzJa?=
 =?utf-8?B?NVZYQzVEcDV4ZnM5SHRnTVUrQzdGTFNWVk5vdkxMdnJrUzVkazczTHhhV0tI?=
 =?utf-8?B?OFVab1pLamhDZC94MWs0VGlrTXBhcGNFN2o5NmEvWVB4TGVDZE1OaHFXWHpG?=
 =?utf-8?B?dzdiMUtiSnZHeExFdHdWYWVWTDVibkNjeEVPclU4cnhqRDFMSEJkUHFUK2xT?=
 =?utf-8?B?Y0ZNc2RqdlJGVmY1a1RiSkFSOHgyQlZvWXZUb1E0Q3F4SWtaTVJQUlFBMUtt?=
 =?utf-8?B?V1hpekZvTFpJVmpUaDZERTZ3aTczTjZJY0lyRXpwU01qVzRWaTdYWWlnWkJ5?=
 =?utf-8?B?aEE2ZHNCc3AySy92VXVkaDM3RzREdHBwYjRmcTc2KzBQeXpFQVJqSDBBSll4?=
 =?utf-8?B?cWNlRnBBdmo4Zi9sV2MvRDZvY2hUeXpHd0hHRFBYUWd4Zk91S1R4eHVXZ25N?=
 =?utf-8?B?bHExeXF0eWZEdDdERnNPa3pvL1MxTWtSMDJXdjZqNmh3NVlZVXl3NjV0ZFdW?=
 =?utf-8?B?d2ZoVVhlODZoaWUvWE5mSDRnWkZBM0RsV21RZFRrNjlHZXZDRzFHVEJ5K1cw?=
 =?utf-8?B?V2NpK2picmxtK0s2ZG95a2tCQlpvRDExVmVuRlJzR2Q2Ujh6L1BqaW9wS2J4?=
 =?utf-8?B?cXN3cDRNS2VyWG9iTGFSQktwMmlsWUNjTTJjcFF5d0RvYlNJYkkzdjdEUEd3?=
 =?utf-8?B?K3o0RmRES2NuaVdHQ1NSRmpQZ2FSRXB4eHFldUVqTjJhSTFONzl6ZDV1NlQy?=
 =?utf-8?Q?OVWFVwf9gHlvLFMYQwNKxrqdX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e81521-8982-4a2d-72b4-08dcf74ed13c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 12:48:27.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCU4nUE6FLGvANQIHkORrD9NDnV1zQmYisvhMIWUnZVIxcy2ylJa4RuHN+cLM4twDXLStqE3zJdepnvngaALJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6747

Hi Marcelo,

On 10/25/2024 9:54 PM, Marcelo Tosatti wrote:
> On Mon, Oct 14, 2024 at 08:17:19PM +0530, Nikunj A. Dadhania wrote:
>> On 10/12/2024 1:25 PM, Isaku Yamahata wrote:

>>> Problem
>>> -------
>>> The current x86 KVM implementation conflicts with protected TSC because the
>>> VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
>>> logic to change/adjust the TSC offset/multiplier somehow.
>>>
>>> Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
>>> offset/multiplier, the TSC timer interrupts are injected to the guest at the
>>> wrong time if the KVM TSC offset is different from what the TDX module
>>> determined.
>>>
>>> Originally the issue was found by cyclic test of rt-test [1] as the latency in
>>> TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
>>> the KVM TSC offset is different from what the TDX module determines.
>>
>> Can you provide what is the exact command line to reproduce this problem ? 
> 
> Nikunj,
> 
> Run cyclictest, on an isolated CPU, in a VM. For the maximum latency
> metric, rather than 50us, one gets 500us at times.

I tried out the cyclictest after referring to the documentation[1]. Here are the
results of the run on an isolated CPU in the Secure TSC-enabled SEV-SNP VM (CPUs
16-31 are isolated in the VM):

$ sudo taskset -c 16-31 ./cyclictest --mlockall --priority=80 --interval=200 --distance=0 -q -D 5m
T: 0 ( 1226) P:80 I:200 C:1500000 Min:      6 Act:   10 Avg:   16 Max:     150
$

VM detail: 32 vCPUs VM, guest kernel v6.12-rc3 compiled with CONFIG_PREEMPT_RT=y

> 
> FYI:
> 
> SEV-SNP processors (at least the one below) do not seem affected by this problem.

Thanks for testing on SEV-SNP.

Regards,
Nikunj

1. https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/cyclictest/start

