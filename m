Return-Path: <kvm+bounces-25511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6DC966043
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9A0128173F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAF5199FA1;
	Fri, 30 Aug 2024 11:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mKpj6Wsu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52032199945;
	Fri, 30 Aug 2024 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016197; cv=fail; b=KWNssazetyhQXPdGVl3MUb1iKCAU9PVEBeVnZHom1kGRPwcLA2LsCZWDyvfP/LzMKkrjYTdR3Xg9Uku7LLpwyhTyL3Dr6oHYvsz/iyH0aL9zcVoKNuA3yGSPZ77ivX6fceWxY+eQzKWSIehyUU9Ef/2rjh77kDvhYpPsAkutTc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016197; c=relaxed/simple;
	bh=O26INIV4Yc6E0Xx8l6LxZkBm9qS1iajUW6+TSn90S5M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZJmRiOjheOsw7/5sUaZIYFl5zq88eg4tHAeumZHVuTfp9FbHNs5XQneYKjVhIBIW03xUQAfqbAtWfPnnzH6kNCCcZT1S8Ms8ZqXOOby/dcMOoV1wnnv38WdVudT+Go2Q4v7Ea2o5EZQo3xuNZ21TN6oh6Nk65xKhvUqoWFUV8xM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mKpj6Wsu; arc=fail smtp.client-ip=40.107.101.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eW6fbHBIXipTHk06D3oHa4AMmsMfaGnsNsUxj1pAengoFqM4jjbRXcRs8wyELF9c0Jfa96DUApX0fIVH5LaeZcIDovi7CwV8Ux7eCXIulRj2jnCxROuWl14M9ArUf60Ym2qq3iiiAsCQVu8AoE5QG6GtTFsQF0AoJlpJBa6DTeFPVF7vhEezU1MYLLXrwBPEL9+26k4XJl5I6L7tmSAEwreeLxHdoyHr+MpNMgwirEusqKj63vCrHqW2Us9IWLfHLiXYZvA96q/oUFICrIz0CXLBAU1tGcDqEIGtnIQOprpiOlAc9fngj1wq3geQityFObHwUOo78sa44SmzmJzCaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bK5JCbmhfBWHCHLm2Tj5VvcJALXZGjngAvznNwLi+/U=;
 b=NvhEec4inwvsCHbpagVIVnqH2YcTwq7hNaqg7nVmVA6dW4XjzosUN1FTz2ci+5GjQ1DttMmFaPhXM8fdEcY0Y9G+nZpKFqI0SCcAYr+VJaH6A8egwYawHOwQGjd2QRgfKqmqzg1zzOnhxQylnz5MUTzFWtwa/p3TpgTBETPYknodH8DdNHuqp9mmwoBZS2OJkYUcqUCh3GA/6tyCx8MVSHrQkYSPljsQiFNjKgug5YVTQmkRTxr5yH07IdXaf9lHKJt1RZotiSo2fZ+OtfA27zZWtDHRBc+RVk/C3gMOr9vLMmAFe9WJU8n+YjPfhGufsfujeAuLWDuJlfAy1W1n8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK5JCbmhfBWHCHLm2Tj5VvcJALXZGjngAvznNwLi+/U=;
 b=mKpj6WsuzE//Pa3ABfRj6i4dGCCci7jzT0cDDJeKqKkPv9JmjSuPPbtbDe/kYoXmg1qEVJIW3UtcNeaWCuBiPaAHqF+37RL0l2fx5szk0Bf7P18MNdCyHBSND1TOhlZThTzljr7wWg41OIb6n+GGHNxOgQssC2gkKxZ1Tbl/T1fLPNGnXPO6yvvLXkJI6g3tXGT9nTP7b8/2SENfxfYqCGEhuFW5Q8/h+ktDRm4woX0SWyE9ZTvXHvVZYanzJ7Ogee6JsX+pd5PFy8jC7wvN9OXe51LAkNjD2sY3KEBC3ffDB+pFqbU38vevphtHC4FjwQ+i2YMRZ0PGXgpr6Ppf1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by SN7PR12MB8791.namprd12.prod.outlook.com (2603:10b6:806:32a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Fri, 30 Aug
 2024 11:09:51 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 11:09:51 +0000
Message-ID: <9f9a8d39-61ca-45df-a172-02831ed536fa@nvidia.com>
Date: Fri, 30 Aug 2024 13:09:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost 1/7] vdpa/mlx5: Create direct MKEYs in parallel
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
 virtualization <virtualization@lists.linux-foundation.org>,
 Gal Pressman <gal@nvidia.com>, kvm list <kvm@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, Parav Pandit
 <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Michael Tsirkin <mst@redhat.com>
References: <20240821114100.2261167-2-dtatulea@nvidia.com>
 <20240821114100.2261167-3-dtatulea@nvidia.com>
 <CAJaqyWcFVLXg=nUdOJOviWA+TDfbqBeEHrVROVC1nYrO8+ZmhA@mail.gmail.com>
 <6935f3aa-9de5-4781-b823-30c17817cc86@nvidia.com>
 <CAJaqyWcW2r9bos3CPxE4yZfZDORzki1SKSyODSgJRLXocOam1w@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAJaqyWcW2r9bos3CPxE4yZfZDORzki1SKSyODSgJRLXocOam1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::17) To IA0PR12MB8304.namprd12.prod.outlook.com
 (2603:10b6:208:3dc::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|SN7PR12MB8791:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b6adf3a-c3de-45fc-2827-08dcc8e44457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0doVmhPNVZlcTR1TzVQMURDeURnN3d5VjZyRnFQK2ZjZEdSdXFaU2xHK1ly?=
 =?utf-8?B?ZG5Xa1FIV2RsRHVGRG1HeDBBcG5uaXR3aHpQREg5aUFuN0t4OXV4aWxZYits?=
 =?utf-8?B?aERJWXg3VVJTU0JaTk5zV2hyRDhmcHc4ZHlqbUdLZlY4eEhsNGxoODIyRmFL?=
 =?utf-8?B?UXR3UXF1MHdPVFpzS1RtWVVzMjNQdklnSHp2a1ZMeUd2TmhDSnJNU2xJMlhz?=
 =?utf-8?B?bFhNeURNdnp2REdKWUV5SFFDN0xoYjV3ckpVQkJEZlRHNFNuTGlXcHBJNmNE?=
 =?utf-8?B?VjQ2SnNmc3BkNW92VlVseDN0a2pRblRZelB4MXk2c09XRTRlc1plVU9wWEV1?=
 =?utf-8?B?SEpYeldaN1BZbmdDSmtOeFp1OUh6am9WaFZFR2VqN1hoNXFyYXZNYy90N1lI?=
 =?utf-8?B?T0txcHNOZGcyZmpwalJLUk9tZXR2RVNaOEJ4d0hkN3NRcSt3eStYRkphdW5I?=
 =?utf-8?B?WUNaT0p1RFBVOHBjT3RyTk54QVdKd1hjVmFIazVqWlplZlRkWGVkdTFFb3hI?=
 =?utf-8?B?Z3ROK3RQTXFUTFptMlBRZlVQZExCdENhQWd3K0dNVG1mUnBLalRsOXNJR2Z3?=
 =?utf-8?B?ZHZKNThQbXdJcnErS0JOQ0tyMlpFVUczL1hiTzg4emVnME9ENVY5TTZSM0x2?=
 =?utf-8?B?Zkh4WWx2NktvMnNhUXA0RGI3cGRWa3VZbStwOW5pNzVySGdUNnpVTkZpLzFk?=
 =?utf-8?B?T21OdUY1eW5Oa2ZPZ0tjMHVXMU53VW4wTnNTeDlzSWczSnJEQy9EQkg1cGFR?=
 =?utf-8?B?S1AxQUZNM1A1anEvVVExby9aMW1nUnJTcktOZkdZNWhKSzF3TDJxTFBPSWV0?=
 =?utf-8?B?L2hyL0NZWlBSK0FJd1NqcmI2QjNpdkFIL200c2o0SnRKZWdNWVhmTlZXeHhE?=
 =?utf-8?B?ZzV1SGVYM3kzTGhIalovNTV2TWRJb1BUY1ljQk1hZzFxQlBTd3pEMW9WRmNG?=
 =?utf-8?B?Nko4ZDZvRmdLL3BtVlJncTFDcTVTYXE1QzhkcTRLcmRZVXI1OC9Tdko5OGMv?=
 =?utf-8?B?STQ2ai9kb1M3RGhWYXFjWEhjbmtjRzgwRlh4RVFVSS9ndjFkekRIR1Y1eHZn?=
 =?utf-8?B?UE0yMXE1UTJjZS9Pc081ZU1KSGlOalZ3SjZoTGNUSGxXWjlQd3NrZ2RHWGJh?=
 =?utf-8?B?bTBadVUvNEJmU3djaVJUeUcyV2ZvNnBBdlZQYjZ4NWRqVTNVTzk1LzRDQ1Fi?=
 =?utf-8?B?eUhZd3lVMGtDVnRVYlZhNERDM0pIcWorRDI2YVE1NFB5Z1lWSUJBR2xCVG1J?=
 =?utf-8?B?U3I0Rlg5c1FWK0NZcWRKd0FoUS8xeVJXeG5VRzg4ajVmclFKZVl3TlFQbTkx?=
 =?utf-8?B?UEpjak1adEhmSWRreko2YU0vczcxa1IwakJyTUI4LzZkSFpSQ1ZHVzU2ZXpR?=
 =?utf-8?B?eFZ5WHZQZWd3NGRwSWhlZUYzQTA4TjRYSFc4SmhTY0ExS0NOdy84bmw1YVRp?=
 =?utf-8?B?Yldza3ZSOHJ1dUJvdnhEc2FLUE5TbVRFRm1GWE5zREMyV1MyMTlSNEZqMEJU?=
 =?utf-8?B?bUpMMTREZThyWFpyRzRCQUpmcGJDcjhTNFRmaHNyZlJkMk1JV294L1g1eTha?=
 =?utf-8?B?d3I1YjFLeUVaNzBvb01sZzBISjZNNk5oWmtsczNWSDFvTkdtNmtSSHFoTFo0?=
 =?utf-8?B?SUJobkduYk43bTlSR3dzYjNleEcyRkw4RGkwVEdZZzVlcW02RWY4SGM2Ymhn?=
 =?utf-8?B?Q2NlYTFwNTRmV2trdFNqNFVhK1Vkamw1S3JmSHh2eUNuNnkrT25nOTYyMXY2?=
 =?utf-8?B?Zlh6YVMvRTg1QUxla2ZjSjVTZ3N6blV5bE56L0NRQkVNeG0zUXBXQUU1SDJx?=
 =?utf-8?B?ZDl1OHliWkVKQVdUbkY4UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzlLNlQ2dzAvY1dZU3N6Sk55RUE0YUpzUHJKSU1iWXBRZUVYREV2ck8vUTJL?=
 =?utf-8?B?Z25VbUljT1hDNmhSOTZtN1B6SEptaWNpc2Q0VEVUSkF3YjdGOE1zY3pna1hp?=
 =?utf-8?B?MlBzZE5zL3VPZjQ4WDRSV2VmeUJHbUViWnJuL1NBRVhaMkFxTFI5TEFWODFQ?=
 =?utf-8?B?OXJpblhpMGJFZjNmdm5EaG9ZVm8zdTAvWXhUTWJOSmZJeVNkWUV5YktrcU9H?=
 =?utf-8?B?ak1NaDZhV2RJTWs3dEhnaWVKVDQ0Q2hSZEIrODYxMjVWcmNGWm5NRXpoN2Jl?=
 =?utf-8?B?aCtwaGg0VEJWRUdRa2diWmxSRUp5ZDA1c3NWZ0x2MGUyQzNQZkQ0eUJ4RFpI?=
 =?utf-8?B?d1RQR3hwcWZDdXdhbUtDN1pSUDhFR0tpcXVpcGRoVkNaOFFlVHR0Y2NZMWcx?=
 =?utf-8?B?SkFkU01WU1Rrd0dBODRNRHl1a2FQT01HK3RCeHF4V01XREY3VlhxMEJBRWZx?=
 =?utf-8?B?M0l1RnRncDE4R2hMWlh4cmZZNDRqZU5ROGs3NkdmaWV3WnI4WndJaG9hY3BI?=
 =?utf-8?B?N1pPalJRUlQ3aUp2VGhmQnZIYXJhTHNwVjNaRHdYZnN3cWxaY3Ava0orLzVY?=
 =?utf-8?B?ckVOQ3pHa3pocngvYkk1VHFoSnVUeFZ4bVVEbHUwL1hUR0QycENMN3AzL3FJ?=
 =?utf-8?B?R1p4eUZRQ3RCVDhSaVpVeDRkQTJTRFpGcFVpUkcwNHhWSytKZ3o5eHlJV1Vs?=
 =?utf-8?B?VlJsV0luMmpiWS9sNGFIY0JvUlV3NlJhU2lnQjVYUFZsRmdXMkpCakxaOXhi?=
 =?utf-8?B?UWZzNWNmSXFzOWxtTDRTRVdMdzNHdk1DNXVGTnhHdENpNWVUV1doVTI4U3Zz?=
 =?utf-8?B?WFhGeHdVRHhWMUFlYkQzcGVKcHg4aHlrVERROUczTG50aEtuOVdEdzd2VktB?=
 =?utf-8?B?eitWWW5vOWptS1RxY3VzMk9wM1FFNHVFU3phcmYzb281Rm94RG43R3o4cC9G?=
 =?utf-8?B?TlpadmxEeDJrN3E3MUpNb1BweUVhcHZNWGxZb2VGdTdYMm54Z3dZVGJQeDdG?=
 =?utf-8?B?Y0puNFRYNkV3UWFzNDBqV3M5a0txbFN5S2NVdXpNZzlQTzNwNUVsSE5jRlda?=
 =?utf-8?B?SjR6Mm9GRGx4L0NFb21vaG1naENYOWZEcGYxaGxhT2VsYnEvTWkza1pZR3lI?=
 =?utf-8?B?b2FvR3YvWUxham5KV0pZWDFPcUppUWdnSHlKMFlrYklrMUpzM3FaM3hBMnV3?=
 =?utf-8?B?dTFxdzFZUnlkaUQ3Wis2MEV3bVIxMEQ1VTk5cjN0a1VtYWtHY0RHTVo2THhC?=
 =?utf-8?B?eFlEZjBxRWJGb0pLeDA1a1F1WnlXeGtDYnZ4cSsvRDJ3QzJJdlJ6WFpSYkxP?=
 =?utf-8?B?UTVTamE2TVRIVmVHcUViSStwMnRZbk42T3d3TUVWQ01lOFlMdWJHUlNxRkov?=
 =?utf-8?B?cEl4dktoOFdDSG93VFl3SW85N0NIWnE3ZDJ3VnJhQzdUNG1oSjRlTXZoTDFP?=
 =?utf-8?B?RS85YjBRejc4Sy9tTS9pdVhHTDhmbVJ1OExkSjhpbVgvcHRWWWhaSFAwWUhF?=
 =?utf-8?B?akF2UWx1eHJQQk9KNUt0dDJGNEJTYklXZHgzU2pjZGM0eVhwalBnSFJ1VDJB?=
 =?utf-8?B?SE92YTJ6Mkk0dUg0MGx5MlBlWmJyNEY0Wng4UGhsVFpYaU1BYmJGcTVKYmlj?=
 =?utf-8?B?OTh5TkxvbXplRnQ0U3AvNkN4RGNWa2h1NE5xTXRXeTFyQlcyQUZ1aUN5dlRq?=
 =?utf-8?B?ZE9TbkFPU3BvZXowcGcydUdZV1FDdjFNeGg2WUFGMjlpRU02YkdCd1d4YXlu?=
 =?utf-8?B?OWxmRjlYMlNPeGU3SzhDa013L3E4MVhxR1V6UFlQUUNnUDhUbGJIRG5ucG5k?=
 =?utf-8?B?dGJ5ZEpIaVEvVFVyODdXcEpVU0xzaEQ2Z056QTlrd1Y5T2Q5NTJuS1RyckNl?=
 =?utf-8?B?T2JvcUFmYVEwOFg1MkRiaVdzOWJwazlIam9Wa3ljNHhkeTl1NThBclNyUXg0?=
 =?utf-8?B?ZFg1aDlqdSs0NVliUkFZVVVtaEFjR2V2bWN5RENuSFJUMG5YUDJhN1dJeVNk?=
 =?utf-8?B?SlIyTUc0NzlGTUJLN3dUQWt6QVdvaDlnMWp0cmpnbDhHWmhSUUNnTTEyZ0ZP?=
 =?utf-8?B?Y3kxUzZQYUg1YTVFc1luRjU3a2s2cTNwMmd0ekYvTlVwS214MWVnQ1lyS0pq?=
 =?utf-8?Q?FX+2f/X4U+GYTaxOkGwPXX8LF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6adf3a-c3de-45fc-2827-08dcc8e44457
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 11:09:51.7809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7M6ghSOz/fJdTWAw7j4ulCZ49eAvOoXvc+Hq08IJ5kh9+9nWHSgfTJTtsD5py0UmhuedV4vjxWg9iuwieg3lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8791



On 29.08.24 17:15, Eugenio Perez Martin wrote:
> On Thu, Aug 29, 2024 at 3:54 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 29.08.24 15:10, Eugenio Perez Martin wrote:
>>> On Wed, Aug 21, 2024 at 1:41 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>
>>>> Use the async interface to issue MTT MKEY creation.
>>>> Extra care is taken at the allocation of FW input commands
>>>> due to the MTT tables having variable sizes depending on
>>>> MR.
>>>>
>>>> The indirect MKEY is still created synchronously at the
>>>> end as the direct MKEYs need to be filled in.
>>>>
>>>> This makes create_user_mr() 3-5x faster, depending on
>>>> the size of the MR.
>>>>
>>>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>>>> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
>>>> ---
>>>>  drivers/vdpa/mlx5/core/mr.c | 118 +++++++++++++++++++++++++++++-------
>>>>  1 file changed, 96 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
>>>> index 4758914ccf86..66e6a15f823f 100644
>>>> --- a/drivers/vdpa/mlx5/core/mr.c
>>>> +++ b/drivers/vdpa/mlx5/core/mr.c
>>>> @@ -49,17 +49,18 @@ static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt)
>>>>         }
>>>>  }
>>>>
>>>> -static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
>>>> +struct mlx5_create_mkey_mem {
>>>> +       u8 out[MLX5_ST_SZ_BYTES(create_mkey_out)];
>>>> +       u8 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
>>>> +       DECLARE_FLEX_ARRAY(__be64, mtt);
>>>
>>> I may be missing something obvious, but why do we need
>>> DECLARE_FLEX_ARRAY here? My understanding is that it is only needed in
>>> special cases like uapi headers and we can use "__be64 mtt[]" here.
>>>
>> checkpatch.pl was complaining about it because in my initial version I
>> used the "[0]" version of zero length based arrays.
>>
>> My impression was that DECLARE_FLEX_ARRAY is preferred option because it
>> triggers a compiler error if the zero lenth array is not at the end of
>> the struct. But on closer inspection I see that using the right C99
>> empty brackets notation is enough to trigger this error.
>> DECLARE_FLEX_ARRAY seems to be useful for the union case.
>>
>> I will change it in a v2.
>>
>>>> +};
>>>> +
>>>> +static void fill_create_direct_mr(struct mlx5_vdpa_dev *mvdev,
>>>> +                                 struct mlx5_vdpa_direct_mr *mr,
>>>> +                                 struct mlx5_create_mkey_mem *mem)
>>>>  {
>>>> -       int inlen;
>>>> +       void *in = &mem->in;
>>>>         void *mkc;
>>>> -       void *in;
>>>> -       int err;
>>>> -
>>>> -       inlen = MLX5_ST_SZ_BYTES(create_mkey_in) + roundup(MLX5_ST_SZ_BYTES(mtt) * mr->nsg, 16);
>>>> -       in = kvzalloc(inlen, GFP_KERNEL);
>>>> -       if (!in)
>>>> -               return -ENOMEM;
>>>>
>>>>         MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
>>>>         mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
>>>> @@ -76,18 +77,25 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
>>>>         MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
>>>>                  get_octo_len(mr->end - mr->start, mr->log_size));
>>>>         populate_mtts(mr, MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt));
>>>> -       err = mlx5_vdpa_create_mkey(mvdev, &mr->mr, in, inlen);
>>>> -       kvfree(in);
>>>> -       if (err) {
>>>> -               mlx5_vdpa_warn(mvdev, "Failed to create direct MR\n");
>>>> -               return err;
>>>> -       }
>>>>
>>>> -       return 0;
>>>> +       MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
>>>> +       MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
>>>> +}
>>>> +
>>>> +static void create_direct_mr_end(struct mlx5_vdpa_dev *mvdev,
>>>> +                                struct mlx5_vdpa_direct_mr *mr,
>>>> +                                struct mlx5_create_mkey_mem *mem)
>>>> +{
>>>> +       u32 mkey_index = MLX5_GET(create_mkey_out, mem->out, mkey_index);
>>>> +
>>>> +       mr->mr = mlx5_idx_to_mkey(mkey_index);
>>>>  }
>>>>
>>>>  static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
>>>>  {
>>>> +       if (!mr->mr)
>>>> +               return;
>>>> +
>>>>         mlx5_vdpa_destroy_mkey(mvdev, mr->mr);
>>>>  }
>>>>
>>>> @@ -179,6 +187,74 @@ static int klm_byte_size(int nklms)
>>>>         return 16 * ALIGN(nklms, 4);
>>>>  }
>>>>
>>>> +static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
>>>> +{
>>>> +       struct mlx5_vdpa_async_cmd *cmds = NULL;
>>>> +       struct mlx5_vdpa_direct_mr *dmr;
>>>> +       int err = 0;
>>>> +       int i = 0;
>>>> +
>>>> +       cmds = kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
>>>> +       if (!cmds)
>>>> +               return -ENOMEM;
>>>
>>> Nit: this could benefit from Scope-based Cleanup Helpers [1], as it
>>> would make clear that memory is always removed at the end of the
>>> function & could prevent errors if the function is modified in the
>>> future. I'm a big fan of them so my opinion may be biased though :).
>>>
>>> It would be great to be able to remove the array members with that
>>> too, but I think the kernel doesn't have any facility for that.
>>>
>> I didn't know about those. It sounds like a good idea! I will try
>> to use them in v2.
>>
I tried for this patch: doing the DECLARE_FREE only for the cmds
array is only more confusing because the goto done still has to
happen due to cmd_mem elements being of different size. I preferred
not to mix and match.

I also tried adding a ctor/dtor with DECLARE_CLASS that wraps both
of these resources: the problem there is that the ctor can't fail
so the allocation still has to happen in this function but
we stilll need an extra struct to hold the cmds + size. Overall the
code was introducing more confusion.

However, it works very well for the next patch so I used it there
in v2.

In the future I will look at introducing more of these, they are
interesting helpers.

Thanks,
Dragos
>>>> +
>>>> +       list_for_each_entry(dmr, &mr->head, list) {
>>>> +               struct mlx5_create_mkey_mem *cmd_mem;
>>>> +               int mttlen, mttcount;
>>>> +
>>>> +               mttlen = roundup(MLX5_ST_SZ_BYTES(mtt) * dmr->nsg, 16);
>>>
>>> I don't get the roundup here, I guess it is so the driver does not
>>> send potentially uninitialized memory to the device? Maybe the 16
>>> should be a macro?
>>>
>> The roundup is a hw requirement. A define would be a good idea. Will add
>> it.
>>
>>>> +               mttcount = mttlen / sizeof(cmd_mem->mtt[0]);
>>>> +               cmd_mem = kvcalloc(1, struct_size(cmd_mem, mtt, mttcount), GFP_KERNEL);
>>>> +               if (!cmd_mem) {
>>>> +                       err = -ENOMEM;
>>>> +                       goto done;
>>>> +               }
>>>> +
>>>> +               cmds[i].out = cmd_mem->out;
>>>> +               cmds[i].outlen = sizeof(cmd_mem->out);
>>>> +               cmds[i].in = cmd_mem->in;
>>>> +               cmds[i].inlen = struct_size(cmd_mem, mtt, mttcount);
>>>> +
>>>> +               fill_create_direct_mr(mvdev, dmr, cmd_mem);
>>>> +
>>>> +               i++;
>>>> +       }
>>>> +
>>>> +       err = mlx5_vdpa_exec_async_cmds(mvdev, cmds, mr->num_directs);
>>>> +       if (err) {
>>>> +
>>>> +               mlx5_vdpa_err(mvdev, "error issuing MTT mkey creation for direct mrs: %d\n", err);
>>>> +               goto done;
>>>> +       }
>>>> +
>>>> +       i = 0;
>>>> +       list_for_each_entry(dmr, &mr->head, list) {
>>>> +               struct mlx5_vdpa_async_cmd *cmd = &cmds[i++];
>>>> +               struct mlx5_create_mkey_mem *cmd_mem;
>>>> +
>>>> +               cmd_mem = container_of(cmd->out, struct mlx5_create_mkey_mem, out);
>>>> +
>>>> +               if (!cmd->err) {
>>>> +                       create_direct_mr_end(mvdev, dmr, cmd_mem);
>>>
>>> The caller function doesn't trust the result if we return an error.
>>> Why not use the previous loop to call create_direct_mr_end? Am I
>>> missing any side effect?
>>>
>> Which previous loop? We have the mkey value only after the command has
>> been executed.
> 
> Ok, now I see what I proposed didn't make sense, thanks!
> 
>> I added the if here (instead of always calling
>> create_direct_mr_end()) just to make things more explicit for the
>> reader.
>>
>>>> +               } else {
>>>> +                       err = err ? err : cmd->err;
>>>> +                       mlx5_vdpa_err(mvdev, "error creating MTT mkey [0x%llx, 0x%llx]: %d\n",
>>>> +                               dmr->start, dmr->end, cmd->err);
>>>> +               }
>>>> +       }
>>>> +
>>>> +done:
>>>> +       for (i = i-1; i >= 0; i--) {
>>>> +               struct mlx5_create_mkey_mem *cmd_mem;
>>>> +
>>>> +               cmd_mem = container_of(cmds[i].out, struct mlx5_create_mkey_mem, out);
>>>> +               kvfree(cmd_mem);
>>>> +       }
>>>> +
>>>> +       kvfree(cmds);
>>>> +       return err;
>>>> +}
>>>> +
>>>>  static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
>>>>  {
>>>>         int inlen;
>>>> @@ -279,14 +355,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>>>>                 goto err_map;
>>>>         }
>>>>
>>>> -       err = create_direct_mr(mvdev, mr);
>>>> -       if (err)
>>>> -               goto err_direct;
>>>> -
>>>>         return 0;
>>>>
>>>> -err_direct:
>>>> -       dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
>>>>  err_map:
>>>>         sg_free_table(&mr->sg_head);
>>>>         return err;
>>>> @@ -401,6 +471,10 @@ static int create_user_mr(struct mlx5_vdpa_dev *mvdev,
>>>>         if (err)
>>>>                 goto err_chain;
>>>>
>>>> +       err = create_direct_keys(mvdev, mr);
>>>> +       if (err)
>>>> +               goto err_chain;
>>>> +
>>>>         /* Create the memory key that defines the guests's address space. This
>>>>          * memory key refers to the direct keys that contain the MTT
>>>>          * translations
>>>> --
>>>> 2.45.1
>>>>
>>>
>>
> 


