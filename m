Return-Path: <kvm+bounces-29163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 854369A3ADD
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 12:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A57FE1C221F5
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60441201038;
	Fri, 18 Oct 2024 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KBx62V8+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CCF2A1A4;
	Fri, 18 Oct 2024 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729246032; cv=fail; b=HbbzG9Jr9zTq3nKAnERF33hbiqgBNUwdvmYwoAO1IkhzmrOIEPpu061//hok249Y2E0QwvZMlNI6nu7E+4B6U4uw0oGR0Tg8RBSA93WBLwsIgD61TmSrc4FhfABZ68QOH26hAF4/oXGfIyYf2FtfokoUJJVJ0W843xymFwz2UPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729246032; c=relaxed/simple;
	bh=36R5qvyRNjZ2AL98rAuPkT3QyEP/uzmO3ZpX3GkEKJk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZMBrEc6CIGByc/2IrB22zRcrtgrekX2JZawHEZIYmZEmL35sBp+wFvidSD0U+uXHM4fN5ch0SHftck31dp8BmWtyK9Qig6rflzsXzzi7iuqO0IHMoSazION62NtlizGgrMVU+WIal3WshXU9ZOygiWKcoxyXuVCRYTay/VOpZdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KBx62V8+; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQ4fG2lv5htDkrWu6ht/2+77AUu94ocoxwgVmZNl9UJ/Yns3IYV4iPVErafy79nLkiPkWglHgDXPeQLefFkv6az6EmWWv2wAZFb/jSBOUnVRfreBTjB1fhuZI329t7FWr1nm5TaYWyvgJMUKKGG94kS1T4Yi5TykPebU6pWMHpJrczeqDskgU7fJ1MFsTq1TUQbgH82EbfnrLHOdKt9j1nDoE42AHGN0vuJYFZyK9AWc7qybmyGn0hzhkTCAwNV2eQ1KDgBPNTGB1wWfHHLi73/+oROQKVDW08YwwlGboah0KEe+ecXj2RHgmSuOjX+2YfJPjOXJpafZcZsKhNVXwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6Qr4lukAPeF3kXn4TgXl0Oh2knnWiEdZ3QyENngCg8=;
 b=gunqWEVpTHfRDT8UTo7G7DCSeU1FXYeHDDbH3uAdt5b97wavnTuW/m+QRji5B6hZH2UNy8VBF6DYGvI1LeaABOfe9BrpRGLvf9wQ6hzgk/DCK2sbHgr+6rF6gdzQTWRuQH2c/tKx2Ra89Oluw9PvtJUkUwikJIOkIDQblK2UYz5XOFQ1DE8qdDltOcR7EUMWA6+k5VKyEiNbJyAsqgLv0XqSaqOY2z/FwhW1B+AYjQJrtVmXbpMVPVD+TCEw52Deig2EJOPisPO7sWmoROsiG769xwMEz2RM1lzVNdl65nxcG8s+7pX5n1gji3C66usOzdRcq9QamATZaXhXOUZKtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6Qr4lukAPeF3kXn4TgXl0Oh2knnWiEdZ3QyENngCg8=;
 b=KBx62V8+0kZpGzsY+bLGGbOEPu/cdKO2lFRjCJHeoZUiB58gG1GhltIbOYebNB7F+TDMMiuc6Ku+1cssbU2Q5f8UGESmFCb6jSFevsywofmwoPIa7xWpxsJyVP+8ihjm6qo2sbX7dMqNBrY2rRzxoOP+pkFdyYDkhNZkGtbZDbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH8PR12MB7447.namprd12.prod.outlook.com (2603:10b6:510:215::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.19; Fri, 18 Oct 2024 10:07:07 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6%4]) with mapi id 15.20.8069.016; Fri, 18 Oct 2024
 10:07:06 +0000
Message-ID: <0f7dac2d-e964-467c-ad4c-cfdd2daa30f5@amd.com>
Date: Fri, 18 Oct 2024 17:06:56 +0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SVM: Inhibit AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
Content-Language: en-US
To: Joao Martins <joao.m.martins@oracle.com>
Cc: pbonzini@redhat.com, seanjc@google.com, david.kaplan@amd.com,
 jon.grimm@amd.com, santosh.shukla@amd.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20241018085037.14131-1-suravee.suthikulpanit@amd.com>
 <13b7b4eb-a460-4592-aec5-a2132ad60b02@oracle.com>
From: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <13b7b4eb-a460-4592-aec5-a2132ad60b02@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::21)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH8PR12MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2c317d-9b74-4032-04e5-08dcef5c9f00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTQxdmptMloyQllxMm9rQWZqQXJyOE40VlV6ckIxdmdBdkUvQjhtTmNvS0Qv?=
 =?utf-8?B?WmFWM2dHR3UrY3o5WHE2dlg4Mi91L0Qwd3UzMG9DNXdqQXdIWlBCeWhDM0Nk?=
 =?utf-8?B?eHpULzR0WDJMYlg4THBaRHNQeGREWHowb2RXWThaUVVuTTFRelNJK0ZIMjRM?=
 =?utf-8?B?MjhxdlVkcjF6Zjh1MVFWekVkYklFOWd0bjVpSldxVnVDRit4aVNpSDl2bHB5?=
 =?utf-8?B?SEo0eFE4MTJ6Z1c0dlNQYWRydnB0d080YXBHdFdwMS9vNGxGWE9hR1JiZWpw?=
 =?utf-8?B?YlIzQTcyL3lsQUlVOWFSdGxXQS83NDhkRTNxYm9iNllRRDVHakl1dk1Pajd4?=
 =?utf-8?B?dkx2K1lEdHBCVFQ5emozSnQ3dklQelZlTmNzUXdkbVd0bTE2ZmdsbmkxV2Fq?=
 =?utf-8?B?UldyYlZod0JLREZ0YlhYZmdCc3VtRFpMMDY2elhVT2dickRhT1l1WVFzcS9D?=
 =?utf-8?B?UDlmYkg0NVllZ0lXbGpwNG9qaEl4NW95MGtLMTcxTGtMUVpIQ3lTNzhoQzJ3?=
 =?utf-8?B?SjBZVUhHNSs3T3lTMVFWamtyV05iNEJyLzYraWFwVTJKK29yU1ZLOFZsbklU?=
 =?utf-8?B?WHJHVDNZeXNKalhzdFNHOEN5bnlzNnV6emF0c2NMMnhnTmxLQmZTZVBVSW5u?=
 =?utf-8?B?MTB2dnNMRUE2bmVqZkg4RnZxZU91UXN6Zmt1R0drd3EvL05KQmwwV0xRTThW?=
 =?utf-8?B?dlpCUCtWK2V3TE1mN0VCZVQwSVRCMXNSZkU4RnlNajIyeExxSDVhZUZEYVYy?=
 =?utf-8?B?cjhyQVZqbnpnUDNYZitMYkNQMnowWGkvNUpEQnBUdUhxeEVjWUJHcDZkS0pE?=
 =?utf-8?B?R2VUdXpvYW04R2IxUnlyUml4RENQbVhINnI4WDJtbkNnK2FxdTNOV2Z6dEpW?=
 =?utf-8?B?N3NYR1hLMUlsZ0JoZGNFSGxFTEI0U0dTd1lsejVwTmJscmRKemhzRFpzQWgz?=
 =?utf-8?B?Njk1WjZCenNBOVRVNytNOTBiWktBcnRpQjZiSHllRlM4ckZ3YXdDRmxIMjZ4?=
 =?utf-8?B?cWlLK1pSdjBqcXNPdkx3YmNnVlpaajdXaHVhOU1tVmJ2Ym5pMlB4UUFLRHli?=
 =?utf-8?B?TkMvWXJOY2tEdVVxYlEwK1pYWmsyQ2FMTjhoMmhLK0pvVVA0Z3I5dzdlRU5W?=
 =?utf-8?B?dks5WjlzYTFGaGNCTzBJbnhTS1ZFZjdaWjFPNTk4RWdDOFZCbG4wdCtqTXF0?=
 =?utf-8?B?NGpmd1NlM3plbnhJN2FGd3E0cVZLRkZnS3VpSDY5SnFiTG9QK3JnUEcwUWxJ?=
 =?utf-8?B?aE9uSThvNzhUQm1EZTBmelhXNWVpSXNvUktob1I3T3dJbzgxNTRTSTN6SlhH?=
 =?utf-8?B?L1p0M1drbzJxVHlHajkxbi9jckNLaWlCNmFPdU5XSzBqanFPTEF6azV4Q3Rx?=
 =?utf-8?B?anllaDUveVczZmk4TFJyWTZIQXRQMERLUVZ5QjNGaTVzekNjQncyczV1RnFz?=
 =?utf-8?B?QVo3NEJlTEh6LzFXL3YvK2ZoZElyNmRidzNnUTJWbUVTSVpSbFFqenhHZG1w?=
 =?utf-8?B?bFFIMDA0N1hGOTBnMEMyUUEzS25ybkk2UWlOMmovVjF4K3ZwQUtLV1hqWVVT?=
 =?utf-8?B?YktFZnYwV0pKdmVhRG5pbXpNcjlRbkJmMTZzZWZPTVBxcjJkSlZzLzhYOSs1?=
 =?utf-8?B?a3M0eUNjZGtIb3F2aU9JYTNUY1paMVllWTNnUDV2T0dydlpjbVNRSzBLQVRo?=
 =?utf-8?B?Q3BOdkJ1WDdRY0lrajkrUEhacDNIaHZrOGRFZDJqWXo0N3RlQ1pUVE0xWnp6?=
 =?utf-8?Q?Q1vW9ILXQ0LLCx9oq42NcUHR/xvh/7IFIjqqBi3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tklhd1JrQzdmQVRCN1NDOUlDMkN4WlBiNU1JckUxWmJZOWpVSUNvUEMzbGox?=
 =?utf-8?B?anpseE5vSmxGMzkwTmZSSThhdUZlUms0aUJDWUtLaG91WVBKWHdQT1hOQm9y?=
 =?utf-8?B?ZjE4NjY4dGRkKzhJV0lZMU9za1NvMW82c0JiWWYwcS9WTkVyVU1BZnFwR2Y3?=
 =?utf-8?B?VkxRYnRPVk9xR2V0Y0RhT1NJQkFDb0JIR2s4LzhnTUsxQjJCMkcrWm5nUDI0?=
 =?utf-8?B?UWF3QmgxaHJmRUdXM01ZZ1NZaHQrenNhWjZYUXoxMkU5N1NPVGZIMEQxZ0NY?=
 =?utf-8?B?QmtmeE1iZ2NYS25vN1JuQ3E1Y2VaUmY0Tm9aN1J2VzZSblY4VzlLNUhwRHFD?=
 =?utf-8?B?U2tobVRHalZRc2RFNVFIakc5WUcyTGorRlgzS1I0bkxxM1NKeVR1QkhvWlBP?=
 =?utf-8?B?ZFlYT2dMK04rOTY0NTZ3bEVLUmt4SUsvZE1wZUlpczlIR010bFRqOXRNci9k?=
 =?utf-8?B?a1gzNVNaRGNaemNoakJXbDl0QXVTRW9zQjhvbFluRjEvMXVOa09HcTRzZ1JG?=
 =?utf-8?B?aVBNeUxWWlR4VFJNV2V4dmZ2VUtsTmF5ZXVCTVpXOTM4UnJIS1VEaEw0RkhZ?=
 =?utf-8?B?dE5CUXoxUmM0UVp4WDJNQk9zZ3FYcnEweGtyNVlmb0ZNcWl3U1pJMzRWemNV?=
 =?utf-8?B?Z2V4SWcvd01WMVczamdsZWlpN3kwVmhXY3R5cytUOHVGZmc3VmZhd3Flbkox?=
 =?utf-8?B?NXROWGdIUjJ3WXJMMkFNOURjbkNBYnVDZGNzVVdJYkRVRWh3cnNzRkZXZkhE?=
 =?utf-8?B?R2g2ckFMM3JJMTJtanQ3UkxNYkgzc3dzc2xiTjR5V204OGxtVjhPTFJrREVV?=
 =?utf-8?B?SWorajh0czYrWWYwb3lVQ0dQcHh6N3VjaUhYcG5Ibjh2Y0VZTWpMbkFhOG5p?=
 =?utf-8?B?QW9KMjhiT3NFRllYRFU5bld3cFl6R282NVNOMHR6SFFsa3lOaThXVUVGRWpT?=
 =?utf-8?B?UzNRZFNDZnpISFZReiszeXpkcEhtUWgrTGkwWTRiZVBKS2ZvOE84R2xjR2Js?=
 =?utf-8?B?NGxWZGQvZ1A3ZFdsUGhvUzIrdE9pV0FXVE05RUVIbS9saUhJQnVKQ2VtRnkv?=
 =?utf-8?B?NVcrdW1hcVRQWmxqMU1lNThlRWRNSjBjQnJ5MVhlbkxkT0dIUTZQY21YNzd0?=
 =?utf-8?B?NGFWRVlzZXhXUzZ5ZUFzQ3pDUE03b0FuK0xoZWhWNG9PbDJVbm1kT00vVFNr?=
 =?utf-8?B?UjF0RVMvaW5wcFgwclAxczNEaG1Ub1F2Qm5pZ0gxelgvR3ZubVdlTWd6ejFv?=
 =?utf-8?B?OHIxK1VVcVRVTndHNnEzRXhFVVA4WThWUGxNZWltS0lSWkcxYlZSbzFEbDRa?=
 =?utf-8?B?dFRaYi80ZkhPWnBtTnREWnNENW11eXMybE1GNWxJcExmSDJXNno4QWNpSk5p?=
 =?utf-8?B?Qlg0Lzc2QStRNzBqcDMxUzh2V1dzemhQR2tSTDVpS055WEI2bjBLcmlPWXlF?=
 =?utf-8?B?bjNpdjdUNmFiZWdZYlJNWnpYalp3RU01ZW1HT1R3ZlZrZ2s1RXptcGptbnJ6?=
 =?utf-8?B?TjluRmN6cXZwUzZ3QjlPUE1Kb2dpY3oyUlZpMVR6L0l4WXNKbng2U2FIa0I0?=
 =?utf-8?B?QzFUeThvV3NyU0JEemU4c0Z1QjBYREFIVTQxejFSL0lkUkxRK3Z1OU1TeExQ?=
 =?utf-8?B?ZCtVZEdsRmZLa3ljdDhEcFN0Z21XeTN4d3psWTZGQ3BHU3VzMmkyRVU5aU5U?=
 =?utf-8?B?Q0xhZzUvdGcwVE1tcWZmalBSVlhkQmw2TFNqakRjR09iVFppTVFtRE95dHho?=
 =?utf-8?B?dGF2V29sNnFyMTBZazFrdGZkQnp6cHlJNTkvQXE2THEzOTRicWlwaFl5T3Z4?=
 =?utf-8?B?dmZQTHQ4QjYyb2I5V1BuUXFOMituVi9wQnBXWEZkbERvb2M1UkJ2ZDQ1TXRl?=
 =?utf-8?B?dlRvdS9aMGtyYjlBQmtMZEhDYW9TS2ZjMWNHVEFaOEYxYlJaU2V6YlZBSTJC?=
 =?utf-8?B?OU9UbDFjWVptc2JhTnk1Q1ErVVdqbWQvcHhQalJFTkVCSFphWkdCbndsNzdL?=
 =?utf-8?B?TVk1ajFFSCsrSm5OL2h1NElrbUd3TXJPNno4MmhUaTBLeXRiOWJ4OEVCQnhW?=
 =?utf-8?B?MzRqeEEwWGtyenlnVmpCWmpCbUg4b0xTdDR0VE9GQmdkcnBtKy9xRGc1ZEI5?=
 =?utf-8?Q?QpWIwJT3qP1Y2O9lmjM18oXkF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2c317d-9b74-4032-04e5-08dcef5c9f00
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 10:07:06.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xNN79E17VyYn7am+v11wLnCmO0UePSxAGHI3mMpX19p7Hcx2hKQlA6jL+cMPYd17FODGfekJgdvAFw8YLcqng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7447

On 10/18/2024 4:57 PM, Joao Martins wrote:
> On 18/10/2024 09:50, Suravee Suthikulpanit wrote:
>> On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
>> the guest is running for both secure and non-secure guest. Any hypervisor
>> write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
>> will generate unexpected #PF in the host.
>>
>> Currently, attempt to run AVIC guest would result in the following error:
>>
>>      BUG: unable to handle page fault for address: ff3a442e549cc270
>>      #PF: supervisor write access in kernel mode
>>      #PF: error_code(0x80000003) - RMP violation
>>      PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
>>      SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
>>      ...
>>
>> Newer AMD system is enhanced to allow hypervisor to modify the backing page
>> for non-secure guest on SNP-enabled system. This enhancement is available
>> when the CPUID Fn8000_001F_EAX bit 30 is set (HvInUseWrAllowed).
>>
>> This table describes AVIC support matrix w.r.t. SNP enablement:
>>
>>                 | Non-SNP system |     SNP system
>> -----------------------------------------------------
>>   Non-SNP guest |  AVIC Activate | AVIC Activate iff
>>                 |                | HvInuseWrAllowed=1
>> -----------------------------------------------------
>>       SNP guest |      N/A       |    Secure AVIC
>>                 |                |    x2APIC only
>>
>> Introduce APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED to deactivate AVIC
>> when the feature is not available on SNP-enabled system.
>>
> I misread your first sentence in v1 wrt to non-secure guests -- but it's a lot
> more obvious now. If this was sort of a dynamic condition at runtime (like the
> other inhibits triggered by guest behavior or something that can change at
> runtime post-boot, or modparam) then the inhibit system would be best acquainted
> for preventing enabling AVIC on a per-vm basis. But it appears this is
> global-defined-at-boot that blocks any non-secure guest from using AVIC if we
> boot as an SNP-enabled host i.e. based on testing BSP-defined feature bits solely.
> 
> Your original proposal perhaps is better where you disable AVIC globally in
> avic_hardware_setup(). Apologies for (mistankenly) misleading you and wasting
> your time :/

Repost from v1 thread:

I was considering the APICV inhibit as well, and decided to go with 
disabling AVIC since it does not require additional 
APICV_INHIBIT_REASON_XXX flag, and we can simply disable AVIC support 
during kvm-amd driver initialization.

After rethink this, it is better to use per-VM APICv inhibition instead 
since certain AVIC data structures will be needed for secure AVIC 
support in the future.

Thanks,
Suravee

