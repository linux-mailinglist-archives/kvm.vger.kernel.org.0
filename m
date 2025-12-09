Return-Path: <kvm+bounces-65581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B307CB0D2F
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A51D301E9BF
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D491E2F7ACA;
	Tue,  9 Dec 2025 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G1x87BW4"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012016.outbound.protection.outlook.com [40.93.195.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7F72F5A27
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765304455; cv=fail; b=qogMduNa6XAyxTdZ2ctAlGYRYkGWV4a/SvGMTvujCINytvqOUHUzIOWYYW54z1/2ODoB9gLeZHU4ausWsqleONjIVJpMO6CW5CnGLTZ0TDVtRFKsZS4v4QoUN+JdrErSooGbVWFJlpTO/0ZdFvkYWS5SpRhgEW4EKIpc/cV0aHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765304455; c=relaxed/simple;
	bh=ivOaW5bANX+5MoOcrmtMTPkNyZ9d8EubTrKxvmB7IjE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eQT22d8jzBn0bNAMJn6UBYZe2krJKVNHSnOgRQLEZw8cEjsQqkLV6p+BQTc3/ZVOiKvhJXQF8Q9bh3iF+S4IZfOqo0NvPJkFBIvJ/9HDpHl0vpp4bJKBwdoUGaRwvSA/TF52TZq6gSUhpI+1Azv4UCGiRrPiLOqCOHgxvLrWAqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G1x87BW4; arc=fail smtp.client-ip=40.93.195.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAzIqx0abCfDv3bbK/aOkaBKviVEeC8EjyXRPKbAT3Vpq7VoGXAJ5KDMhcRMAP1R4pfqXFeHIqIkxURiqcHPEZ3+8ZNu3vyRGa/4AEAjTojO/BOLgpMDPEkkS+j3AyvULLsJ6jem1u4ppiscZCIBVqiSktVg6lE6lAKVbvvNZncAIJMd/UP9hvRYV38ZG1i2R084uybDJwUA6l4vuJJWVPktopjyQTdoLnHCZKORgrh5WwcUyKEj6JnyjUW9YDdmEbzVC4JLyvnAlX5Dwz+AMiu/qyQx1GG7n9G+24dVyozMC4dei0dVs+APXFp9j2iNtQkqd9cjl0AnTKsX6Q5sEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXN0WcQw/BZDaoBIyWvsn0GCEfG++6xsvOIzuZArVNs=;
 b=YjE+ghPwyNudYRoouVBLzEfavhTY+Fn1GJoDsZU3aJKwQ5JVQnQMJwzZIemKFBpQwJuZoYssVOrehdep9CVoW/yR0Ll86mcC0ntoqQVuipwWdGyCJd1rwnKc19B4opEOkp8D1tinuVt7IumVw9xjumFYLQKBC9aF+6CwLzDtTg+cFF1vmDtZ1NhEhKAhIcrMCisJqvTDdWrGftWn1y6g/wxskIwgUFoc64AzcfHhfsRB4teP9p/up4rjh4WmVr1DtsdCUXshZySlUxZkBC5+5f37f9o6HsJ5DP08Ih5998WU2WrkU1+tFgpgXAb+JJQBcXpAk4AUh1gJ591aZvkq+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXN0WcQw/BZDaoBIyWvsn0GCEfG++6xsvOIzuZArVNs=;
 b=G1x87BW4Bw4EIgEElffaKEhJGnTc3smzEvxRXw9RwMy7JLLvMHz6T9qnTK7QB+vIJpmx+1rViF8Fb+fJDSOvdV90D+LFGS7XMkBMKTizx2pXHyfKSAcWzWdDA1oPmX9s8PpzztupcAl3Y80BvkRCRXRNeYJhgK3FGgxdB9S8zLW/3d84HAMRE2y8K2zBj0UN3mf4KhGXgUQ6mk72EUnFvBrteT3vbg1zXLqKntsHMn0qDXmjgDAXZ0LFVir6z1xrHik5GTjlP1T7sdO64/pOLD+uexTizGNsuT7HRs3QRigYsHyTvzR9jAeMmH1UjxiAjWjGBTywUdE+4HaUiJ0QtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by PH7PR12MB7938.namprd12.prod.outlook.com (2603:10b6:510:276::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 9 Dec
 2025 18:20:50 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 18:20:50 +0000
Message-ID: <df0d1e2e-a496-416a-8cfc-22d69ad4c37b@nvidia.com>
Date: Tue, 9 Dec 2025 20:20:45 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] virtio: add driver_override support
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com,
 virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
 oren@nvidia.com, aevdaev@nvidia.com, aaptel@nvidia.com
References: <20251208220908.9250-1-mgurtovoy@nvidia.com>
 <20251209113306-mutt-send-email-mst@kernel.org>
 <49a3aabb-eb28-4149-b845-1bc5afffb985@nvidia.com>
 <20251209124819-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20251209124819-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0002.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::12) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|PH7PR12MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ed4ea9-049b-4ae5-592c-08de374fae8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkpkK1RrQ0ZmU0dwbW5oTTAyMlNsU0puMnd2VUVGR0lvVG1JUm5pQXFRT0ZW?=
 =?utf-8?B?SEdRREN4bCttZXUzY2NqREV6SWNRVHlKWW9wL2dyM21ZVHRpSEh3Sm45ZVZt?=
 =?utf-8?B?QmlmV21KZDZIZnVmOS83cHlEc3ZTODlOR3k3dHVIL1dVMEc3Mld1YzFQM1cx?=
 =?utf-8?B?WXFjdTdKZTBHbFVseVFZeXFoMThxbGVMaXc2OGk5ell0Y3JmWlVta29ERGhH?=
 =?utf-8?B?NC9FNXhwcUhuSzZaRnYzeDRZT1BzaXdTR2ttdlhhWVRBdEJBOFBGS0k4Nms5?=
 =?utf-8?B?OVRlUStXLzc4Uk45SEROZ0VUdDdaNVpXb0Q2NlhkV0JaTURNT0dLSXdvaHJJ?=
 =?utf-8?B?Q3FiVnIvWG10RjVVOFA4Y2ZONE50Q0NzYUVIL0RrRk96MW9sNkRHRTg4SHJL?=
 =?utf-8?B?QkllbFZ2WFdCK1NaN1djTUtBVVNnc3UxdmJSdlRPK1ZSck9CZEsxeTNpK3Ba?=
 =?utf-8?B?MHQyS1dla2l3TEdBTERTWFA2UXd5WE03dGxqeWQ0TURRZnQ0bnp0emwvRXBj?=
 =?utf-8?B?cDBrdk12UllOYjBJSDRqeFRxL0dLM0wzQlV4bGpCMnBWbDFlZXdsTnRYOTRr?=
 =?utf-8?B?MUVTWmw3R0NVUGU0TUVqc1dXcExJeDZKMlg0SjJ0NmsyUEhMMVJxR2VwbUZG?=
 =?utf-8?B?V2xJVVFSZzRnMTJvd2pVVzFSSlZRTnVpeldHQU0rN09ZcWpCQ2NXM0hYR1Jq?=
 =?utf-8?B?eHhiWVM5cUlQWks1eklwVlBjUUcrdDVuZzI4Zzh6U25qVTdoMjk0R241d21n?=
 =?utf-8?B?M1pEZmNEQWlGejMxVkttaWlzWk95N0tYTjVxYTB6dTJpdE95SmNMSFIzWktw?=
 =?utf-8?B?Q3psQi9iRUMybysvbUFEQWgrTHVSYk5WQVdIalZEdFBSbklWMHZBMVJ6N05k?=
 =?utf-8?B?Zk9UTHozMDRacGhXUFFRQ1FnKzNyRTdwcHByVE1UeHdkK0Y2a1Z5SnE5VU1j?=
 =?utf-8?B?VVl0RjhKb1BZdkhQOGt1akNYZGFOd1M4cGdGNTVhWEcxQlplUUVQc1NqME9K?=
 =?utf-8?B?d2IxRW51NWJ5U0hINWFYRCtxMTJhM29Fd0lTeEJSTjJ6eVlJMUJEQ0JyNUJB?=
 =?utf-8?B?eTNBU09QTlZnN1pCaU0ydE5pb2MycDhvUGVMUnM0cjVpNFVqaVFDT0RXMHgz?=
 =?utf-8?B?L2U2VGdtZGUzaWhBYjlqQzhwOVp3TE53L2tpWllrRG04M2ZSNDMwTFg4VStG?=
 =?utf-8?B?dWhGd3ljM3VsQTh3RFZDZk45bVhRVTNGSlhCUVg2bmxmdjdzNWRZWEdaMDd2?=
 =?utf-8?B?RTNyYzVoajFNa25hSmtneUZUZkxhL2x5ZWZRaTBKbTdZcncxTkdYNk1FTm1G?=
 =?utf-8?B?RDZtaXRCdUJ5MXVSdFRlZm9QbFpGOWx3UXl2ekVqdDJON0FSYlgvTldoYkZt?=
 =?utf-8?B?NklGQ3JYaXVFd2NNVGFsVzFrcXVnSmZOUmtQYWNpL2N4OFdHcjJBNkMvcnB1?=
 =?utf-8?B?Q2xMZC95Y25GejBFU3c0c0FzWFpCL1MyYkd3SXlGdmRWbm5nVERrNXVaRTJI?=
 =?utf-8?B?bjAvMGxkdHQvSkRtR0g4UTFvbVhjZTRvUlNmUnhTanFOZVg3eThMY3ZKU1Bw?=
 =?utf-8?B?MVA2aStzUjZZcFJ1NEJaQU0xRnovbCtHZGNqeFNrdDlQNmpEbDM2Qy9WNHQx?=
 =?utf-8?B?YllvY2VEeHc3TjVibEIrOEMwZW1RVVljOVNFRWZrc3dJWEdPQWcvN1lSUCtN?=
 =?utf-8?B?eDR0S2YzQWpBYitySUppZDh3eVZ0MUlla2ovSHZZNmRGNVJBNjIvT3crN2M2?=
 =?utf-8?B?RFFuRWVRSml4ZkZSaHJmMmpYSEVaT3dLZzREWGgwTjVqazZ3bkd0Qy95RWdY?=
 =?utf-8?B?eHdhOHZBY1FMaVdIejQyd0NPOVRKbmgrb0d1N2lEOUhxbEFxZmRiNDhyL08x?=
 =?utf-8?B?enZiRHM1UFJ0NzNwQm1wZlNUaW1VSTBNaVdUbzYyOU9VNnp1L0NDZnB3VXVM?=
 =?utf-8?Q?QynzOvI/tzOuueGMzcFAwa40cVfC7aj8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2NpeURxbFVLTVBHMlhTQmpvc1R3V1pMWUJCUkZFV2lQc3A4ZXozTjdmSFcy?=
 =?utf-8?B?eXVZOHB2QldaeFdDVDVlOWNLVG5rQU96Z084Y3hIL1kzMlBnb3lFSkdQU1pT?=
 =?utf-8?B?ZmZIZVFHTVI5M055STRKQ0o3WVFYenhIUUZwS1lGTW5SSWhUa3NWK0ltYTI2?=
 =?utf-8?B?ejBTbkNYWk8yc1g2TjduZmZZL1F2cmp3QlUyZ21kYlZFWFZWTVJMZW9qVUVK?=
 =?utf-8?B?UnlxNmNneENaVEduK2NmSGxhRDIrcTFVcCtJY3hQWlY0VkhZbUVWY3FGUWxZ?=
 =?utf-8?B?MThGeUVzZm9TdmZMam1YVU5qYnZFRVh5T1Z4Zkp6UmJ0eGZMSjNJa05xQjJF?=
 =?utf-8?B?eGlqWnpLTGpvenlYOVZNYWdwd0pNWEtmQ3FXK3FvYUxpUzUvblNnZlB6Zmcz?=
 =?utf-8?B?RVI0Rmtxa0YrendWVW5HMEJEaUZSQVhvQ2dZY2dCUUZBVnc0R3lDVzUvMStJ?=
 =?utf-8?B?S054eVRYak0vUVR3UHI2OGZBYUF6dG0yeXRQRkQ2SzZVSnpnQWc3M2xXZEJH?=
 =?utf-8?B?ZGRoUEN0M1BkK1B5U1Q4c1cxdG1TTFZ6S0xqWCtydmY1UHNPeG5GNlk5VDBW?=
 =?utf-8?B?eHRzQW9EaittMSsxZHh4TUZHT29weERkVElEZmlFNHJRWEpsZHI5QkhjRmx0?=
 =?utf-8?B?NDVHc1hrL3E2SkR1L2RNM0ZnYTdXdC9TUzhySjhaVjRra2J0b0pvN0FXK20r?=
 =?utf-8?B?LzBnMzd6TDdZc3REMjN5b2VqQVZvY3hRS1NkamllVnhKWC90Q1ZsWVJic3Zq?=
 =?utf-8?B?dnhxZjBPVlAzYzVFeE9pK2RtQkFIUjBUNkdaRS9Fb1hEVFVwWE85M2tqc2sv?=
 =?utf-8?B?U0Fvd3I5dVZtZ1pIcUN5YlpsOVQxUEM1YWNlc3VpTzJ1UWRNYkExSFdua0Fs?=
 =?utf-8?B?d3J2US9RV0hoN0RQS0IyUS8zZkZkYzl6alQ4REx4Vk9PMDYzQmFpTEIyRytJ?=
 =?utf-8?B?Yk84bjRDcmkzdExCMlVRTUt0K2h4Zzc3UTVWMzVQNHpEd09Qcnh4L3RJWE9z?=
 =?utf-8?B?bDNGTXd0aU1lUHA1dytQcDFsMzJvdlZteGtxdkVhRmcyQmE1cEZPU1JmTmtZ?=
 =?utf-8?B?RGp0RXlpUEZxVDBEb2tNblh0WTRIeXNuOHpPb0llSkdEWEp4cXZEczV5Z0c4?=
 =?utf-8?B?SXptdlFIbmR6cXlSWWg4cG9BSFl1THBpU3k3Y1RMY0JWZUc5SDNPcnlmK3JO?=
 =?utf-8?B?enQ1ODc1NHh0MUpTUFh6czZWQ2ZIam1OaXprQng1K3E2Sy9VSXpYUEFya0tp?=
 =?utf-8?B?cFNiMVVpSmdVNHcyVnJ4a25hak5KT3ladmJENkN1ZEJRSDRhNkZteHhRRlJL?=
 =?utf-8?B?dXg5dzBDWnJnL00vbncyZVRzeTNXSFpEZE16TGpSSzRPQmZIZndzVlVxV3R4?=
 =?utf-8?B?UkFoYm5xS1dETmZUVmR3RkJ2TFNtMTd3TmZORG1Mb2Z5TnpxRkkxajFBVExB?=
 =?utf-8?B?V0J0SEpya0FwOTBlRzVYR0p3VC93bEE4YkxLM2lpK29FaERpZDBwR0xnb2dr?=
 =?utf-8?B?YjFacTZpa29wMklKc1o0Zk9jcHNQaDFjcW8xVUE5SmtrUkJyTUkyVWpXN0o4?=
 =?utf-8?B?ZVVTaXVIRFk5WjNZYW81cEFHMmpnb1NKZVRFK0gzQk1hZDd0WHRsd3RzNHlJ?=
 =?utf-8?B?R05WU3NKSE42M2Y5Z1RjQnMwbXdSWGQ0WVBpY2I4ZmsvU3pLVTR1SXp3VXFs?=
 =?utf-8?B?Z0JMR2tQNENLeGMxSWQvcHRUbVlnME50UFNGZmdSTkdBbEpDWXFqd1dKaUJx?=
 =?utf-8?B?ci96cGFiMEZ2OHlEaUNxeDlya0hwVUxkYytuWG5JT0s2QmwzN0c1UjlEK05o?=
 =?utf-8?B?M01ObjVtOWFoL0JyaUZ2QlpRTUR3enhuRk5WN3VyL0hyd2NlM0NmaktJQnEv?=
 =?utf-8?B?V1QreDZSd2JBWjVIa3l3YjVycWlWdDg1RlJRMm1nNGdDcXdLYitORzg0N2cx?=
 =?utf-8?B?enBqUXkweWdOdkdOb0hTcFN4dStjaWt3d3VMOEp5VTErQ05mMkR1U3RRZXhF?=
 =?utf-8?B?WjMwRHBCdXBESmcwdFhhZ3hCaWlpSjVpWWM5ZTJWaVozUWtCTmFqdjFsWmxV?=
 =?utf-8?B?Vlllb1lGZkNNMzZNeWpVdis2WUcxUVZaUk9WWTR4WFVZSkRKOEx4L2NIbkFz?=
 =?utf-8?Q?f9IfotmUKR4HXbjlXKGFu037m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ed4ea9-049b-4ae5-592c-08de374fae8d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 18:20:50.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBzyJaY3GtpAJ3HnD01zBaGpgLyyRWnaRVrjwqqmCbpFF45F+laIOigEtwPAgTwjXX+04h9pBSNJVDK18Rwq6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7938


On 09/12/2025 19:48, Michael S. Tsirkin wrote:
> On Tue, Dec 09, 2025 at 07:45:19PM +0200, Max Gurtovoy wrote:
>> On 09/12/2025 18:34, Michael S. Tsirkin wrote:
>>> On Tue, Dec 09, 2025 at 12:09:08AM +0200, Max Gurtovoy wrote:
>>>> Add support for the 'driver_override' attribute to Virtio devices. This
>>>> allows users to control which Virtio bus driver binds to a given Virtio
>>>> device.
>>>>
>>>> If 'driver_override' is not set, the existing behavior is preserved and
>>>> devices will continue to auto-bind to the first matching Virtio bus
>>>> driver.
>>> oh, it's a device driver not the bus driver, actually.
>> Yes. I'll fix the commit message.
>>
>>
>>>> Tested with virtio blk device (virtio core and pci drivers are loaded):
>>>>
>>>>     $ modprobe my_virtio_blk
>>>>
>>>>     # automatically unbind from virtio_blk driver and override + bind to
>>>>     # my_virtio_blk driver.
>>>>     $ driverctl -v -b virtio set-override virtio0 my_virtio_blk
>>>>
>>>> In addition, driverctl saves the configuration persistently under
>>>> /etc/driverctl.d/.
>>> what is this "mydriver" though? what are valid examples that
>>> we want to support?
>> This is an example for a custom virtio block driver.
>>
>> It can be any custom virtio-XX driver (XX=FS/NET/..).
> Is "custom" a way to say "out of tree"?

The driver_override mechanism fits both in-tree/out-of-tree drivers.

>
>>>> Signed-off-by: Avraham Evdaev <aevdaev@nvidia.com>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>
>>>> changes from v1:
>>>>    - use !strcmp() to compare strings (MST)
>>>>    - extend commit msg with example (MST)
>>>>
>>>> ---
>>>>    drivers/virtio/virtio.c | 34 ++++++++++++++++++++++++++++++++++
>>>>    include/linux/virtio.h  |  4 ++++
>>>>    2 files changed, 38 insertions(+)
>>>>
>>>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>>>> index a09eb4d62f82..993dc928be49 100644
>>>> --- a/drivers/virtio/virtio.c
>>>> +++ b/drivers/virtio/virtio.c
>>>> @@ -61,12 +61,41 @@ static ssize_t features_show(struct device *_d,
>>>>    }
>>>>    static DEVICE_ATTR_RO(features);
>>>> +static ssize_t driver_override_store(struct device *_d,
>>>> +				     struct device_attribute *attr,
>>>> +				     const char *buf, size_t count)
>>>> +{
>>>> +	struct virtio_device *dev = dev_to_virtio(_d);
>>>> +	int ret;
>>>> +
>>>> +	ret = driver_set_override(_d, &dev->driver_override, buf, count);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	return count;
>>>> +}
>>>> +
>>>> +static ssize_t driver_override_show(struct device *_d,
>>>> +				    struct device_attribute *attr, char *buf)
>>>> +{
>>>> +	struct virtio_device *dev = dev_to_virtio(_d);
>>>> +	ssize_t len;
>>>> +
>>>> +	device_lock(_d);
>>>> +	len = sysfs_emit(buf, "%s\n", dev->driver_override);
>>>> +	device_unlock(_d);
>>>> +
>>>> +	return len;
>>>> +}
>>>> +static DEVICE_ATTR_RW(driver_override);
>>>> +
>>>>    static struct attribute *virtio_dev_attrs[] = {
>>>>    	&dev_attr_device.attr,
>>>>    	&dev_attr_vendor.attr,
>>>>    	&dev_attr_status.attr,
>>>>    	&dev_attr_modalias.attr,
>>>>    	&dev_attr_features.attr,
>>>> +	&dev_attr_driver_override.attr,
>>>>    	NULL,
>>>>    };
>>>>    ATTRIBUTE_GROUPS(virtio_dev);
>>>> @@ -88,6 +117,10 @@ static int virtio_dev_match(struct device *_dv, const struct device_driver *_dr)
>>>>    	struct virtio_device *dev = dev_to_virtio(_dv);
>>>>    	const struct virtio_device_id *ids;
>>>> +	/* Check override first, and if set, only use the named driver */
>>>> +	if (dev->driver_override)
>>>> +		return !strcmp(dev->driver_override, _dr->name);
>>>> +
>>>>    	ids = drv_to_virtio(_dr)->id_table;
>>>>    	for (i = 0; ids[i].device; i++)
>>>>    		if (virtio_id_match(dev, &ids[i]))
>>>> @@ -582,6 +615,7 @@ void unregister_virtio_device(struct virtio_device *dev)
>>>>    {
>>>>    	int index = dev->index; /* save for after device release */
>>>> +	kfree(dev->driver_override);
>>>>    	device_unregister(&dev->dev);
>>>>    	virtio_debug_device_exit(dev);
>>>>    	ida_free(&virtio_index_ida, index);
>>>> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
>>>> index db31fc6f4f1f..418bb490bdc6 100644
>>>> --- a/include/linux/virtio.h
>>>> +++ b/include/linux/virtio.h
>>>> @@ -138,6 +138,9 @@ struct virtio_admin_cmd {
>>>>     * @config_lock: protects configuration change reporting
>>>>     * @vqs_list_lock: protects @vqs.
>>>>     * @dev: underlying device.
>>>> + * @driver_override: driver name to force a match; do not set directly,
>>>> + *                   because core frees it; use driver_set_override() to
>>>> + *                   set or clear it.
>>>>     * @id: the device type identification (used to match it with a driver).
>>>>     * @config: the configuration ops for this device.
>>>>     * @vringh_config: configuration ops for host vrings.
>>>> @@ -158,6 +161,7 @@ struct virtio_device {
>>>>    	spinlock_t config_lock;
>>>>    	spinlock_t vqs_list_lock;
>>>>    	struct device dev;
>>>> +	const char *driver_override;
>>>>    	struct virtio_device_id id;
>>>>    	const struct virtio_config_ops *config;
>>>>    	const struct vringh_config_ops *vringh_config;
>>>> -- 
>>>> 2.18.1

