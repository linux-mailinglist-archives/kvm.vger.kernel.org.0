Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42084622F8
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhK2VKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:10:03 -0500
Received: from mail-dm3nam07on2054.outbound.protection.outlook.com ([40.107.95.54]:2112
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232141AbhK2VIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:08:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE2e2NjL/luUwx480bb7w6RY7WO6TXVOdj/agIKPrLXUeRUjM62fS/dF6yzzSJuIDR34lBqCMb5jf2g3L2eQ7Peuo4um2hK7eY/rlC14tg5uwxLMfY9IBrQX2lmgdAgUba/HsUlz+8DuTuyJm1Yk+ARn9zsoTehp74ElHG+YBHC47j2Z863Ju6YQIvJ7nP9TFa0PLoVjCZv1K7HXGf33+UNz2sLI2BI7/l8Wd6dSxh18tOeXF5MtvF70vPdMAVGiniv75/MY85yfv5aKgkBqkXix1of1qZbRxtAcQGOHGDMIXXOE/zKGPJ8nkzEr0TwKOx5cENRx794QyFkfXlCHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAY8EzBVGzzXG0roxyJpmaWP/hQj/BKTd5F5KPsvZgE=;
 b=g+1p8f5rgAjHYmr3RBHlB4Nb1frHCiTnEFXLys8qfXIE3qxuvJNKR5oH/Fr14iSn53vu/XJtGdDMJDeF1vf6E+mQlckxxjTcqFM6tEBctj9RifDFONMwb1VuFSVqCYFHl9scKiz/yrCL0aXcPmjX40E02DKXejDRtb2U9KWHhZWEZEVVFhAahBMhh+nP5JGgGxVPo5nKW2c0BI1gxLb7jjPPn860fAb1rE8sKG6nfmNK8Bo9jdLrQ/W23u5X3n3z/lby/MRJhVvErlm/sGVQ15xgcy7RRnvf52M91RAjPyxVYa1Bped/dM/ehwZmv7a56bBZLWVPvh67G9ls0niQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAY8EzBVGzzXG0roxyJpmaWP/hQj/BKTd5F5KPsvZgE=;
 b=y+essJbJdYKNcF3tFKMzXo1SEiw6rk6iDcCrxiwTQSKrCio5WcV3IZD9z1EbkBoKLqFqQ3tu2By6EIRyIRfwMNMdgMAa2G9JssSbvjweocRwiTFwxUNPnY2rf3Clz0r+6trcqMcICgoJBx/MPMkx/sB+pDXBk/Q6pFPv7PuDKzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1758.namprd12.prod.outlook.com (2603:10b6:300:10f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 21:04:43 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::d9d8:7051:7185:6c3c]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::d9d8:7051:7185:6c3c%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 21:04:43 +0000
Subject: Re: [kvm-unit-tests PATCH 10/14] x86: Look up the PTEs rather than
 assuming them
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
References: <20211110212001.3745914-1-aaronlewis@google.com>
 <20211110212001.3745914-11-aaronlewis@google.com>
 <5a08da0c-e0e1-c823-b9ca-173a15aa341a@amd.com> <YaU7flyPaTb5xJa7@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <6fdc724a-2ad8-539f-421c-8a1e38aa4b3f@amd.com>
Date:   Mon, 29 Nov 2021 15:04:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YaU7flyPaTb5xJa7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MN2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:208:23b::24) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by MN2PR11CA0019.namprd11.prod.outlook.com (2603:10b6:208:23b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 21:04:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eb3dba9-d748-45e7-560c-08d9b37bdd7a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1758:
X-Microsoft-Antispam-PRVS: <MWHPR12MB17583E0C6147801D189F534A95669@MWHPR12MB1758.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMUhQv1KVdSSij2VB94uaJnn3OBenzj4EN2noru+BEC7KHNwltstaS7p6KWSAndf93zOrfdMOyaS7BFwPyQrhCh02rlUsPPcXDPn3qyQF3hiLl8ta/dPwhqWcW+Y5H8NnyR8FjU0YO0a5q+/KiLSxhi4ee6ltjz1ccKe/P6uflD9Lx8OYA4zg6ExFWJ5vRRvddPou1gBLud+Nu6FheeNhhohcgYd0w5GGRy0JIM90jhjwJSEqDpUCB2lVKOWMhH14TGJAE9b6mwSFwlUBkpNO85tc5q4RcpEnCndat0pv/tgsx/DI/CGdGIQyp5tA0GFmqOrsDXBZbGB59iTxE7Dvt44MXYUxDlqJqWPmED16b1LbwinrW8sYcb14iHTHDFlGoD1RAny4waQO1uqh2KL+0ltaJyVlfm1aAAKzpauRL0KXNn4Xcczer4axRkotFroz22v3XTj+TeHsv8oVuDMnHE7+HDwV44os4uGrSwlU7D3imGmQqD271Wl0r8wrd52V+oUrRDItT/V/nGpBuuyhzx/xa8JQegDDLh48qCzjlDTiP3szglvacFV+Al1N+NB4NKnB8LNE8IamndVORJk7IgCuDZ7VJdmFKI/Xwmx7xRZkC5ARtivS4ISbJwW3bo+ykixpSwS97coI1XYyi7AGU1Y3nNL5zu4zuOFgvHGUkTtPMZkKYo3OYOGw0Z3xmVLCDFdYubUd682jaGZvK44F6xlpqLtWP2osRt672IO3Lo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(2616005)(31686004)(2906002)(36756003)(5660300002)(53546011)(26005)(4326008)(956004)(66476007)(8676002)(6916009)(44832011)(66946007)(186003)(31696002)(16576012)(86362001)(66556008)(38100700002)(6486002)(83380400001)(316002)(508600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXhONlRmVkxNM0RLVGhZaVJ2Z09NZDdwR0dWRjRYNmVEb1RiREJmT1FEd1BP?=
 =?utf-8?B?d0NkZ3dqTmdlWXFtdWpWais5UEpuRFZITWZ1R3FmU2ZiNEVrR29DNUpLMUIx?=
 =?utf-8?B?WTh4ZnZQNlViaC85VXoweU0zdDNzQ3ZNa1dhdDlxbFUxeG85MWRUd0F3V29r?=
 =?utf-8?B?UGNWdGlJV096L2N5eC9vNjdnNkk1VEgyUGovSVMyOGlmY3NtbklKWlo2bWVT?=
 =?utf-8?B?VDJOenk2MUd5Rjl4NUNZZjk3T3NrMVJKZ0xQSWhOUVFDakZObGhrT1VuRDhH?=
 =?utf-8?B?R1A2a3FMRG5qZmh1cW1xVlpqd3l2a1R1QnBYK3ZJc240UFFLTklHTHQ0R3pJ?=
 =?utf-8?B?VXVVZkZFKzFwekFUY1Fxd1dwZEhINmhHQzJxY0hsRnhDNHdmcEhjSEMxNWM4?=
 =?utf-8?B?WDZFVmg4UEkzT0NteUR3bzJSdUJBamxaZ1NBcjJZbjFoUVBaZWpyL1p1alJh?=
 =?utf-8?B?eUQ3aUtrWmk2NkFTNXNhRnVWUVN5ZUljdVo5L1RxK2dKcVBkZFhFNTNqcWZ3?=
 =?utf-8?B?RzFERE1kSjdSdnpTWld1TzZ3WER2NEtpNWthMHFKcU5SQyt5ZUlpZnkyQzVD?=
 =?utf-8?B?QzJaR3JmblZsNzZtUUd1T2IyZC9aZVFCRkM5ZmVHbGJYRTBLZlAvQUl6dWFW?=
 =?utf-8?B?ZzlEVHdodmJmZE9BWUZoTERpeDlxTDVwVE5EWDlSK1JZWUlSUlk1bXJHZTE4?=
 =?utf-8?B?MXR6cVBaSFlUNFFqVDU3NG5lYWQ0WFd1QTcvL21oYzBBaFVmb3oxWC9Xa1l5?=
 =?utf-8?B?ZHRqcUFqS1J3bGlSVVZXZkxxWUQ1KzdNNDFCNWg3QVJRZzFlRG1xczk4QlFP?=
 =?utf-8?B?bi9KdnpMcEUwMC9NOGIzYzdNYUxTZ0x6TjA4SjJ6NnRwU3drUkR2cjU1UFZ2?=
 =?utf-8?B?WmkxU0MxUHVoVW0zdXNoU2s1ajdCRUJCYUFrUkhwL2ZYVzJwdGltYzhNN2RK?=
 =?utf-8?B?R3VscXRMcDZ6eVZjS0pWa2doYmZMWU91U3BHK1FmQndzUTZzZjRRdXB1ZE4y?=
 =?utf-8?B?aWtUZkkwbjZ0MklDSEUybVRRSG9OOWpLbHR5OFBxY2VBTmVhSEl0c1pvSWtO?=
 =?utf-8?B?NWJiNkxMRUtKbkRLN2N2ZklRNnNhWlNSTy9aTkVwOFJnQjhhYnM1eUlTd0RK?=
 =?utf-8?B?THZWVmVQSE1vY0owOFBWazdCNllyMGcxdlRKVnZrRHhrUDJ6MnhZYzl5TXpj?=
 =?utf-8?B?eThLZkNQVzMvSXdxaC94NTdFWFVwb25PNUdkV1VtK2F5VmpWS3hENTZQMzhZ?=
 =?utf-8?B?dytrUUpiLzdtMnFmSHJ4bTFTbGNNZDRCZ0tGMi9LdDBBZ1N1ZjRadUpBakFM?=
 =?utf-8?B?Q0J6cXBoRlQ3Z1gyMmxqRTU4cDhJVzJxTWlxSURsYjJuV0hrRS9QQ3l1Vy9B?=
 =?utf-8?B?OHREZHVUelVkV0RXcHI2ckF6MTh5TlVRQ0JkVElXWDlJdGFUa1lqcVNJRWlq?=
 =?utf-8?B?Mmt2bklYK0dzMXhlQURjbk1NbkhKRG9tNHB2NHp4NHI1QVc4U1lRRWVVbGNw?=
 =?utf-8?B?c2o2SEJxZlhrNFpzdStua1dYbzVnWmluU0tWbnRoTUQxcFI5NUxsWDV5UmxU?=
 =?utf-8?B?Si95b2ViaTArd0tvdlBnRzlPbUgvQ3dsYkVGMEdnejZ6ZUlDMFhkeXRwVWRX?=
 =?utf-8?B?S1Z2c20yMnJUVTUzZXdSOHBHb0VKeGQ2NFl4NS9LcUs2SU93UitqbUQ2N29t?=
 =?utf-8?B?WitpMW1DOC9mcmRHMTZPbk5DVTVEalFpWVdvODRJUzZVUXc0TUJjWXdHdUQy?=
 =?utf-8?B?RTc0ZGlteW85T1BOS3FZalpDY1UzemxRTWdHNGVzb2lKSnhCTFUzR3RJS2dO?=
 =?utf-8?B?Tkx6K210WVpwSHplWDFZSWZvZmN0dHNRL0YrdWRQeVJkN0pUSUVtUllrVGlK?=
 =?utf-8?B?Y3UzRkttNEpNRUlSNlVXbHAxSFpPQkdJZXlOZmdYSHYzVnhBcGZFSEdsalJV?=
 =?utf-8?B?MGcvRGpRTlpKYVEySlhuMHdsM3dZTVBCZG9GT1hxWkhleEE1eW1pY0ROZWJR?=
 =?utf-8?B?NHFwb2xDV2dNNEtVZXNuVzZHL1FYU0ZsaGlMbGdmNHphK3BObWdGNHNUeHQy?=
 =?utf-8?B?VmZxYk1pSFRvNHdQUy9ZK1VLYXUrVzlzaUdITVZUc1pmMDIvVENlQUZkNjhB?=
 =?utf-8?Q?QFgI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb3dba9-d748-45e7-560c-08d9b37bdd7a
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 21:04:42.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRXDUtDbKF0bSSrxWSk7WBnO5QvEyHgWo/YzWa7dRBMPHK7evfXPYqYAixGE2OHR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1758
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/29/21 2:43 PM, Sean Christopherson wrote:
> On Mon, Nov 29, 2021, Babu Moger wrote:
>> Hi,
>>
>> This patch caused the regression. Here is the failure. Failure seems to
>> happen only on 5-level paging. Still investigating.. Let me know if you
>> have any idea,
> Fix posted, though you may need to take the entire series up to that point for
> things to actually work.

Sure. Will test and let you know.

Thanks

