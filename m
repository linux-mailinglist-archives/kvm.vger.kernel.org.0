Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A1C3B3402
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFXQjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 12:39:02 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:31489
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229445AbhFXQjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 12:39:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQLdzkRpIaUaXBlsa6fu47lU8g63iKZuE71hka/67XkF67HqawByuaipe20K8m3fqPXfD5mL86hGULXEZSYqAvCUb2HXth5adtd+CetuanHO1BNS5Dblwep1RhttZL75R9Yc6aIl6p8cfS07pwfPwSyPcrP/7xHbWD6iOeAhqmP/OTuaLPGNz0sYUjGUQ7K98TaJzT6GnYeAnRms9KtaJ66m2awez6d1l3XZIb1hCf02XxvdA5CulIDKbZeJ0W8N6OfiUBMQLnfGkM3wgqnksxTIg6Elas+qQPW+Ufgmq/FRa8DKNISa+W7oXoaodO4dtR9Fuv8v7iXRpJ30dQDyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ms/R1TE6CWfbHRi8wNjSsoNe8geNOXxECpQOJaeSezc=;
 b=TdQJJrt8RwOQMEAUMaSJQHRxhFPtksKXHZxFMXTvGDZCm/OWd6Nl0oGvShToTmhtwxisX5FUk6thaMwQJeO8ByNsa6exWV8uUGrXdiPyLcUVp0q/vEOELASauo2wnA1Rny6S6b/e+MaMFj+mJFof6nom3wdiDm+DQbYbA9w6/tHlHiB5ujK5jwDucHL+P48ipjq6b/z3jcxTMI2OypDVXZXosTe+QsykuBplR5YTeGcv3J8hD2sjyeCIfJrwLhDvSlKyZ4O7PAAmbuRTrUV3hVAUQBjDXpe1gFx6O6d3JWK5B8CZRdO/tXqB3q3wal+gZPZVYUMS9Q1JPQ92Q+cOlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ms/R1TE6CWfbHRi8wNjSsoNe8geNOXxECpQOJaeSezc=;
 b=e5qnUcPKsEdKFcTDjUABFheLQVtEutDOLVPVi+fJk9PuxlDStWdoghCtR3pIxfiMr1z8MW8NUjKMysf2+SVSdiiHh0VP/9wgufht98i9x2mvHRljG5bwQKO3JTmMPqOdvWVXwEy8vkgJH+rJyExIz9jpkGzx7IQCjAoG+g8AWrU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.19; Thu, 24 Jun 2021 16:36:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 16:36:40 +0000
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210623230552.4027702-1-seanjc@google.com>
 <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
Message-ID: <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com>
Date:   Thu, 24 Jun 2021 11:36:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:806:20::27) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR03CA0022.namprd03.prod.outlook.com (2603:10b6:806:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Thu, 24 Jun 2021 16:36:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bbd1269-b248-4599-c9ee-08d9372e3e22
X-MS-TrafficTypeDiagnostic: DM6PR12MB4092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB409246707AA42A0241AC217EEC079@DM6PR12MB4092.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9KOZc5BQ+O1StJCNFCj5uVlfl5yGCpux/KeB7vmoIgZE4ss03yGSGC3GNoNM030l1DQLF1sUmR2TitpWr1KqKhAmAM4OJ2uyKnSC7JsfNcc+fQ8xr1ZNd9mvG2AmuoEWjKuv4rxM8soxIbzg79yB5yxMqjZRgFnOPEDWyiNSl3ok4tTz4Ug3tNNYAIoj7LgDBEdCMYhFhQUH8YnnvRh8VGOOBs3gidPXjDY1ColIZtnvyjkQpKeDG9lgayToauB3fO7g943e9+EPYc9vdE5CrYANJuzwdw3OOOhn9RVz69ro6BSbBq4/J/Ft5dUf01pJuyqmPEOYT9TFtifGH/UEytiObDLtl4D/oSZ5JcDjX1KSps2UTiK4C0KW0QZuGTsZ5yghEgoVZ2O7EJYfe1KYUQefwHOdljkUUz9pqiYWJwz3VE6HT1GBrxHMmHhcnexq7zGAfzCymHqyFEpvxiwp0yFw9mtgIfMDcDVglJHYlbdh18ZLE64t85cte1s0+tWNr4kNSbUg/v/2ytMl+gSMIsxAsByGXecbazWu3f6K3i33bT/Vjxft2YQAjsFwk4+Ks4KiEUDAh7iM03YhyAbumCDvtF3M2ETjbFpKxdmRtc2QQxtM7wZgnK1gOBheh9J49Tswsz7J3uWD3xpFBt2bTmJ8Q/Jh3ps34/NXzRt72SLLvT1OtXuFqCoicWu9rOpjtQqJVn/02qsANCQuYkB/QKETBvG9D53sKKCQH4GcfwYTjYmwU0/ismVZr4yfwRr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(31696002)(66556008)(66476007)(2616005)(956004)(86362001)(31686004)(66946007)(6506007)(26005)(4744005)(36756003)(110136005)(8936002)(8676002)(6486002)(498600001)(5660300002)(54906003)(4326008)(38100700002)(186003)(16526019)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzFmNHVqMFJiRG9kc3dzS0NTNWh0d3ZtNmdVR1J3UXVDd1FvQk5aeGt2ZTVL?=
 =?utf-8?B?QmhYbzd0R2k0S3ByekY3RUIxcVZ5Y3JESkwrM29YRkdHY0p4TWNuTGdCMGM1?=
 =?utf-8?B?ZTRJUFJoWlBSQWVpay9nVXZOZkx2QUJqTTg0NUZ1cTE1N2Z5VkhBR3YvajZy?=
 =?utf-8?B?bUI1RlFPcHpOcHM4Mzh2S3hvcTVOdVFrVDA0OE1sSlg0Q2VERUVkQVlCdGlK?=
 =?utf-8?B?U2dFcFpBaVRTTDFwK09BNUFZb0JiRDFhSGQxMFAzYSt4dHZnOHRYYW5TY0RM?=
 =?utf-8?B?cy9rb3Nna2FrS0lZdC8veW1OU0lpbVRiLzFBbDVSaGVxWlNhaXF2SWo3c09V?=
 =?utf-8?B?RVlsSkZsdW1qdnNCSjdwQ3lDNHBKUXJFUUFGVkNLOU05NFhhWExyb2xyWHpX?=
 =?utf-8?B?bk54S01NUklSTmtKLzdlak5CdGNzUlEzbTQvdGhoSXBMUXlHaGcxaHBKazJG?=
 =?utf-8?B?dkpLS2dqWE9UeWtHTnBpRmpwenFSbkFZWGxLMlU0Y3lVMVpTM3VXZm4xSHc3?=
 =?utf-8?B?YXI5bzBZZllwRmFIb2ZLSGRQaXFIMzhlR0txN3c0UGJqci91WUMvdXJMeXRC?=
 =?utf-8?B?enRES29JS0JKRDRzSVBVZjBGaG5Sd0RGN1hBNmpySE50QWdxV3laUE9zcUsx?=
 =?utf-8?B?b0U2UWZHUzJpRHNRbktHZmYyUWluRjU4bFlLMGs1cGtSMkxiRXVDVzhNRHFv?=
 =?utf-8?B?OVFEZDlPcjhhb3JhMkpQd3RHM082bFJZWjhEOGlmM2hzOGp3eVNHQk1veUMw?=
 =?utf-8?B?VVpUeFdtM0MyNkpBVjJ2ZXBybytEaGJLYTJVSmV1MW5NUzROMjdrRENSSGlB?=
 =?utf-8?B?SGlmNXI1a29PaUZxWWRIVHlxNDkrcHBzdGltN2RHa1RocHByN0hJVXZsRnJw?=
 =?utf-8?B?OVdrOUsrYnM0MS9XcWNMQWsrcDNiUzB2WGc4eTFnelkvcFUyRVJkZ1ZTcGtt?=
 =?utf-8?B?ZlZ6alNmYVVDS2ZXSzNwbEU4bTNlL0twWndMeXRDT2NRVzFER251dTlqWHdU?=
 =?utf-8?B?ZGYwWkZtS0lMSkVENVRlWVFFMDZFYkZzNFZHbnNSK2J1ZTV4NU1yZXRiZG51?=
 =?utf-8?B?MUlHLy9GcVdsdnlKbnk3aU15WkxISlhMamNLbFdaTmxKQ0o2ZTVYZ1IvS3M2?=
 =?utf-8?B?M3dlNmRxK3lyTFNqakhzTFNXakl5bS9QdDRrejEwakdPRkVMY0RMa1k5c2pn?=
 =?utf-8?B?RDlhZ2FBTHpPeEFOTW4wUVBlc2RwUUt1Z1YzQmFLL2tJa0dWRmN0UERndG4y?=
 =?utf-8?B?TjdkdkV4VlBlZ1BCc1VKRmZmSExNWDVZcnhPUHJSM3hzazhKOUJFQTlQYjk4?=
 =?utf-8?B?OWZ0bi85TEt6WlcvV2djVzFJVER3OXppUzNZWVRmcTQ1UzlXM3UySk9wTEJy?=
 =?utf-8?B?ODZFUHAyZmwyZjNBNzJUWkRUbGhOODd2dXNHN1E4SE5tLy9seUNSOWh5dE9U?=
 =?utf-8?B?L3ZPUm1UdWUzcUR2Sldva21WVHhJbFR6dWt2b2lJaUJyZGZ5aW9WTVFBRjBn?=
 =?utf-8?B?eE15RnNuOXNoRWNmaWtwZ0tBWHQ5cjdUTjZtVGxjQTZ1NW1WRkVWTUFIakR0?=
 =?utf-8?B?UTdoNUVsaXNxcnFNL202MzhjaW9MMkY4TnZoNU9tRlhJQktNNXNZWEt0ZjZn?=
 =?utf-8?B?Z3FLbGRJWlUxcnA2dUtQM3NnaU5HTWVFVHdHMVFkZlhGMGpodE1oUnJkZ2hV?=
 =?utf-8?B?cHVkTnBtOFpPbnNDZ1dOR0xNUXMxR2dDQSttVHQzNzNjMVpBNWpYcGxENGdO?=
 =?utf-8?Q?D1A76gZT4dHRhhnDZ4sdiOjNQEddrDnaHscPhfi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbd1269-b248-4599-c9ee-08d9372e3e22
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 16:36:40.1757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkxAzLvzlO20aFHbZMgZrWLSyd4JpMGbKVDq6SD8mS4KfxtoT2vyHKee4h685Oj47lEL7US8saXT+CNT3+/JPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> Here's an explanation of the physical address reduction for bare-metal and
> guest.
> 
> With MSR 0xC001_0010[SMEE] = 0:
>   No reduction in host or guest max physical address.
> 
> With MSR 0xC001_0010[SMEE] = 1:
> - Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
>   regardless of whether SME is enabled in the host or not. So, for example
>   on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
> - There is no reduction in physical address in a legacy guest (non-SEV
>   guest), so the guest can use a 48-bit physical address
> - There is a reduction of only the encryption bit in an SEV guest, so
>   the guest can use up to a 47-bit physical address. This is why the
>   Qemu command line sev-guest option uses a value of 1 for the
>   "reduced-phys-bits" parameter.
> 

The guest statements all assume that NPT is enabled.

Thanks,
Tom
