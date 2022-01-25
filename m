Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9049BA9C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 18:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354979AbiAYRt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 12:49:29 -0500
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:13729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349665AbiAYRtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 12:49:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVmCF5s6zAMXHuDlnStNQvQj40PW605Txe9HZCpO0TERweNBsQh62f3bGn138i58qSZxDNIY0/X9JXP6ZqkjzfqZE6aj6afI/v143/2mykTKWMUlJ7WxAl4sxe31Errjewh1hfSa/4zdtDXcVdbsOAm5k2NiVHFAMgedS0nIwCG9XtjCrBWC3Ks+YF+kzn82yewNzQpTn6LX4vgqNIvwiTHW5SYxteymnk8dqB+E07PzNss3B8mjqlCV8dq95/+HZX7lT1n+o+pn4S7HJbLqSFwLDqkSLaRR1zQ8po0A7FWMv/jjPmm8VeCtNcBggrNnPyaBBPynup69QZF0KALUww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcyNNLZiS9O7z5r+DqDwKxBTUryGNn8bcAfqYzZgo2k=;
 b=gTIAzfp4LYjgV5nNjUqGBat3h+RR46LBTuZEI+Tj/Y3y1K2w8lxEI/EhnFeAEk+AC2IlycJGBd8W4e6NQd3kqb30OY1e0Yzxh/Uu9jX2FVicDnfwylXWMD0pJOOE0GXWTupwnbFqEghwMQDpkUyNEryLetbKxEka7Fr5LpY/nMkbau0H/ELpDr3R+l2OB5JuAfJOsPN5pcXzJ96d3NpRM8vB6VYIlZbmJUZtkRPjhV0d0/UVM0BRjVKkIwFSw87H4s5ZdT7/MEMquXiKQuIa87YXgK4TDaGwiy6jYT1wAzeIG7BcjVQnE9ZtmZj7297tLAL77VgkjrNesi/zYM/AgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcyNNLZiS9O7z5r+DqDwKxBTUryGNn8bcAfqYzZgo2k=;
 b=gIC+yxlxfD8uc416QjSEM629SycmzWdw2zJaHgHIp3iLFfqDXVXOI3T/BctKeHa9g+CO0x2VOyfbMJtQlfyIvs6z2q+sEkoLYgxQyQRYCssITqpD4p3TNcYjVZbW2EznDD/imz58kXj+BpJJJa+tLHhpLp34rLrGsOHm1cxcnoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 MW2PR12MB2556.namprd12.prod.outlook.com (2603:10b6:907:a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Tue, 25 Jan 2022 17:49:19 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4909.019; Tue, 25 Jan 2022
 17:49:19 +0000
Message-ID: <04698792-95b8-f5b6-5b2c-375806626de6@amd.com>
Date:   Tue, 25 Jan 2022 23:19:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com>
 <CAMkAt6rxeGZ3SpF9UoSW0U5XWmTNe-iSMc5jgCmOLP587J03Aw@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMkAt6rxeGZ3SpF9UoSW0U5XWmTNe-iSMc5jgCmOLP587J03Aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0048.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::34) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8dbca14-5093-44dd-b2df-08d9e02b02f8
X-MS-TrafficTypeDiagnostic: MW2PR12MB2556:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB25563BA239E7D2CDE3EF8689E25F9@MW2PR12MB2556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/En8VrInnL7+V1wPse4L/kyUqavsQpw5ABY8x/768JCk9R/DqYQ3fIFdyfs/4ZVgc3yax9MrMEC/xuWWtmpL0HTrSvp1l8ZsV/F91crjTTXh7eaw14misUCiCA31zkrTExMWy9u0cfAwvcrmtMiaftTiQPj6lVI+23nobchSpe4ShAruziS14yWBhBSH3ZHczA88O1oCCGrh/0Sd0ElJj21fJvl0ZLgD3gSSaajkLR9dd8fYPn49AdXx8IWCYDkBi1Tl/HFVjLYMbrCkiw2wO6OJ2Eli2/NpePnKqkJnJS7zkZcxATVa2HYBAI1XeVDCzTBIFEZJOzj9V6NS7+ZXagG26jm9xom+JIF1EXyLOZm6hhe4nLhj1m/YmdFagLVqVtFpLgyuiO0XiHrFx9lvPQeK+Op0OAUdoOtLY8SnmjaeZuucNFyAgP6ah1AlRdmyenjPyuhdUp5Ec1575t0oJL8EmsmCzgDlrz4axvP3dNSWBT/MSsZiYhzazy0jTyhA3dZ+8W7nCPFlSN6BTi2L4Uo1OzkKd5KHVE+9bl5UJR/ZyPdgq4mFLw+E8tUuRPlSZYGLkPh8RT5y2B/t4Py0GS1aKBlyQsdZug/4lUC0oNcUdDoVs9sKhIdSqF0wVV0goUXTIauxq5cyjfOJHTIZ7t7oo8SzopnmYln34283CmswKCdvUc/K7ZVx31G9+rZhYyj+18BiqmJNS8DIiE6ypmwPLS5fK5wfmbkiMUTnUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(5660300002)(26005)(66556008)(2616005)(31686004)(83380400001)(4326008)(66946007)(8676002)(54906003)(6486002)(6666004)(6512007)(186003)(36756003)(8936002)(2906002)(53546011)(38100700002)(4744005)(316002)(31696002)(6506007)(66476007)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2NOVmU2Y2EvUWs3NkQwVEVKVndBclArNkVRYkZrbXNZbTk3cGx6cngvUGJh?=
 =?utf-8?B?VEN2c0hnczIxNUFLa3R6ZWdLbkx2SW1Rb1hDdE5hSlFKTkw3VkgveVBSbWlv?=
 =?utf-8?B?MU5MNEhwbURpUGpFYWNOTDRHSlVhK01pVFlmSlEvOU9yYWxJTFBwSjJlbFcv?=
 =?utf-8?B?UmNiZjB2R21ObXI5SFBQOS92VldqQTdFeTZIc3NUU2E0U2VCa3JJV3R5S3Yv?=
 =?utf-8?B?WnV1cjRjZm9LenczbSs5VExyWGpMTE5yQ2ZHQVo4bGptM2QzU2o0NUFocEVs?=
 =?utf-8?B?UUpXMDgwbUxRb2VjcjlnbkhnMUI5SGlKZGg3QllLOGZjWEtnS1l0bzJZRjFZ?=
 =?utf-8?B?MnA2RXNob09jMk9nbjVRczhPYnZqdTRZOWxLQkxxamZwZTJGQm1MeWt2aXFl?=
 =?utf-8?B?OHVSZVhjdlRzSFVBdVNSZVJZaG5uVzQ0bENLQitnYjJpZmJKVUpXakQ5SGt4?=
 =?utf-8?B?L21COWM2RU5EZEMzR25hcDdBM1Riam9IRVhjWFYyTXV6d2NtZ3BmMjc4Rnh0?=
 =?utf-8?B?Kzl3ZFpaeEZieWdOcXYzL3dyNHZyaGUvME1BZ3M0ZkdTTlN6SG5DYWJZMHhC?=
 =?utf-8?B?eFNDcThoT01CWjYyZnN0L0Y3OHEwK2hVcXIzR3hJZmhGWTlkVjR5YUhlaENZ?=
 =?utf-8?B?T2o3bklKazQxTHh0em1DTkhWRlp0dmkyNWdJWkVxNnFkZUxLamE4SzdIc3Yx?=
 =?utf-8?B?c25vL2ZkM1l2bzdOcFpKYll0UzYxRE1OSnBnK0UzM09Vam1RejBsejZkYXZI?=
 =?utf-8?B?YldsSG1TMnZlUkFwbEJoSUZRcjVqam1Ha3N4Q2QxeEVHUjVSNjRkeU1oMFhM?=
 =?utf-8?B?MHREbjRGNlBGNTYxY3FoclhROUhLd0ZhZ3dGOG4rUE1FeFN0QTdXcjhkVWVI?=
 =?utf-8?B?N1lsOTdNV3Vxd3AzenJzaTA3WVBCZUxZVnhYTi9aQ0dOVG5pOGorRmp2S0c2?=
 =?utf-8?B?YndjMFVlcGJmMEVNdUx3UlMzUFVLalYraE1zcDdPR2tOU3ljNHN4NDlPZlBm?=
 =?utf-8?B?aUVpUVpMYmRLWS9kcjZDZGlLRmNHUkxYbWRyaXEvR3Zla3BqcURxVTBBT0hU?=
 =?utf-8?B?NS92QWcwQUdxeXU2eU1aYUZGSU8yaGN0TWZvR0d6YkhZcmM1TkF1V0N5RDJD?=
 =?utf-8?B?OFZUdXg0LzU5d01yZDBrRy9JMWNxRzVlaWFMQWJ2OTFYSGNVSmdhcVBuckE5?=
 =?utf-8?B?UFhPbWFwbVN6bHNkSWl5RlowYkV5R2UwUTI0UmdqY0tuTkJabXZkZDhQQjNy?=
 =?utf-8?B?dzJrK1RLNkQwNnRNSHVQTDR6R21tR1lQeFpIQTJoVEhFOHZSOVJRR2FsL2RP?=
 =?utf-8?B?VFNYZ2IydmJoKzZhbzBwcndkeFRkOEVYTW5XMXprVUpPMzRXbHZSVUJXU0ZS?=
 =?utf-8?B?ZDRMNEo1Zm1KOEhIWVU0WW1PZTFQZ3BqMTlYRVF2QzFqejUyMWkvb2dwbzE5?=
 =?utf-8?B?WE9iSU9oRzJweURlZ3FxNUQwVTZvbzBiRjVUakhSZnI3d3laNmdXNWxBVG9S?=
 =?utf-8?B?cEhEdFc4bkRWVDJxWi9tdzlWQ1U1Lzg1TlhCWnZpc0tDa3dXcnZFNkp1bHNk?=
 =?utf-8?B?U2dQdDRaN2F2Nm1ISDlQcUdpdHVrVk4zV3puTWRDYzJwN1praWFTdVdQNlg0?=
 =?utf-8?B?MEdNeUYyVE5IWE85V0lYWmRROVBvRUZiV0hVdFh1eUN1ZFNpTFZ0OEVZT0tY?=
 =?utf-8?B?NVkzb1B1Vjc4T0IwRVNWZW9IL2pYSnlOanRDdFFNTWlJWDFONlJwSG1BK09U?=
 =?utf-8?B?NlYzN3N6RnBEa1VPeXNiRzFKc3lDRVdsbTZQNXA5L2ZLbW1sbmFzSmhGeisw?=
 =?utf-8?B?UGRvQWgyMDU5M0VZekRqajM2SW9VTnZ0ZDRyOWErRzEwSkgyM09iVFJxallw?=
 =?utf-8?B?b3F1eWtBN21RL2FPZTIwai8yeEZrWVA3S0EwKy9NTG5leTdSN3gwMmVTN1F0?=
 =?utf-8?B?WUZvYkcxYjNsOVhGMXVyV2tVZ0pvWk0vcmRadHpuU0lZZDZ1QmRuQXI4cTc5?=
 =?utf-8?B?QXBzWXpadFJEc0VpczdyQ3VHSXdHZFM5ZDdjUXkvUjZkQUczQS9ONTJBRGg1?=
 =?utf-8?B?MUdEVXBaOUR1RWpsQXpqUUNScjJJdzBzOWQwUTQyL1daR2tTY2x6TnpNRGxh?=
 =?utf-8?B?MXJNNTNRSmQ0TWZMTCtMSWdtbi9uR1pBSStBOEk1eEJYNUdRU1ZUZmtobHk3?=
 =?utf-8?Q?FhE9ZF/69VvjgyWL36TiEqg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8dbca14-5093-44dd-b2df-08d9e02b02f8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:49:19.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCHbL4zqKfxDL81nFSbTd7h15VWge1lPlWPctS0UByffqAm2cZTBqCGt/yLxQ2DHQfzPmvZLdGWjyL991EkPiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter

On 1/25/2022 10:17 PM, Peter Gonda wrote:
>> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>         src->handle = 0;
>>         src->pages_locked = 0;
>>         src->enc_context_owner = NULL;
>> -
>> -       list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
> I think we need to move the pinned SPTE entries into the target, and
> repin the pages in the target here. Otherwise the pages will be
> unpinned when the source is cleaned up. Have you thought about how
> this could be done?
> 
I am testing migration with pinned_list, I see that all the guest pages are 
transferred/pinned on the other side during migration. I think that there is 
assumption that all private pages needs to be moved.

QEMU: target/i386/sev.c:bool sev_is_gfn_in_unshared_region(unsigned long gfn)

Will dig more on this.

Regards
Nikunj
