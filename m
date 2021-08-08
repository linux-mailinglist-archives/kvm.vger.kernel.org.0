Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD13E3C8A
	for <lists+kvm@lfdr.de>; Sun,  8 Aug 2021 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhHHTbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 15:31:24 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:16524
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230201AbhHHTbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 15:31:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f69Fz+qLH0xvEEjITD1dqbaF/F91sWwRfCnNk0tF63NUPe2EIb6y84CVigkETq6aSI2nyf0lTJEn34QNoAsOexusFdqlLtif7wtQm6VsPwLlIRPop/e76aymQEqFFkcjiH4nQwYGqxDaUpHmJ4MUO4r97ZOJIF3Q0vF7AuxM8FtOU9IeRi2PZV5ACWL7KsiEP6xMQ39w4cTjxqyufp8r0HdbfoRJIjGUWzbmqDXBLXB3csEOwDlWC+ml5Ia7/N5ARm5fb1SKmw/+DfkPEZPdii46jpK6x7wHS+trxnZpkg46WMg9C4KgrBbxN08A8RM+I1Iga0AcYaF33YzyPcRtsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEqrGdk0/Qpa2pbTnNpJzY+ZnSSEOl8VJ8OhRCW+oAw=;
 b=hUAytjJqoKB0Ir6jptX4VwjsBzMzIWeCOc3dcBbpEQQrBetBG70Uu3VyP0fMDYjuDagI97+saKwxblYvqAXyYk8zT+/sLagkw706S4GVMZ3KOcP7UjMeJoctB7d8mmqIiB0KwDaon8xf8JglCk6b80PS4bsmSMaDE9HPAz47Ydvyw4h9lu67ubMfWovN2jgavYODHHq7pYRrFoah8RuDm6dUbkuxRa1tZbV93WFtHbLKxwxFADY3X3WeioxYoQEFhRhyQhxz0qGXI031tEmva9yPiTjKTm1HPCbSRul4yNws+IujnYShEMSwghWf3m+IOHnhjTXyeKGQ9aKfYbj3rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEqrGdk0/Qpa2pbTnNpJzY+ZnSSEOl8VJ8OhRCW+oAw=;
 b=eVhgB6nVBAVtg4KQfWis5zrPDBsP0JNq1V5Lf68r7JmGPJV3QFP4+IaYVgGCY9wLRb//IsbkPdapmcoKU5jAkQtuuzXrwHkxA0RgvNczsKMsEvBWTXjVwEwHBVPDHWsvO31607ypeS4pLx+fT0joXDSzOPr/isn5udqs0H/799o=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 19:31:03 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 19:31:03 +0000
Subject: Re: [PATCH v1 1/3] KVM: x86: Convert TDP level calculation to
 vendor's specific code
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210805205504.2647362-1-wei.huang2@amd.com>
 <20210805205504.2647362-2-wei.huang2@amd.com> <YQxdbq+yoTIJmpL+@google.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <08d21961-db3c-ae91-909c-df068b7be2e7@amd.com>
Date:   Sun, 8 Aug 2021 14:30:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YQxdbq+yoTIJmpL+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0026.namprd04.prod.outlook.com
 (2603:10b6:803:2a::12) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.10.87] (165.204.77.11) by SN4PR0401CA0026.namprd04.prod.outlook.com (2603:10b6:803:2a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 19:31:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72179e55-8ad7-4d42-f7ab-08d95aa30f19
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1434808A2F96753AC222903ACFF59@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpY2cCKoOpRbvlJterPlJhQCx8hJHutvt1XctTUqQp8WfWyEyIYK83iTmzwwTY/25DZ+H+dILvXqtA9wpntzRJXu0zlpKQT+EHAtMLYp+rndUEBVWQZ23gJEu4JdN2dpKz8K22kst/qKFRezOmFvCP+ssUzqk1UIVSlUgTgnYFXo551YH0ApATHTDztJ/GiFwFNhGHTjc9Rri5MxApQQ63czZ4Z5rtlIb1Vw6ER1SoMRgo2/td8GeiN+2kyR3PuTNNGbfM7nGP+RfS3ANJey6i4Nx7oYDKL+dvPxQayk26DrI/B6Z82lGDaM/kpmc43sxhON7wwd9GwD6D4DqxnKn5UdsAhhPQJjKTglRb8K2advj85Y1kDgbIgJMVclZ+HAKoSukHgSGXqRt0cE43h2G/tKTY2ExMI2ANRAqKHVoJ9iQdKYTq6VQ1sl5QdEcfzRLSTUOqG/Pap6W4QRaoLPROrDCEqO3qprCNTHXeccVPqESjYUeikk5ndmaYvRTaGrKHqSfEKe394ldsVumaJRSIZcR4ylNSvOofES2BLvHZkDun0m7sNPHuSmlZ4m7JhxHV4pskBv/00Kfmvvk7CASXcfFAGEvKXlZkx+mmbB+iJdRjaP8d8uiSAdODMSPXofbX7j6asYgPwp16bi18XDi0JbiOQo155QUJlMLcexVQiMUNM6ZrUC0yXxzHeCstFs7YGXRYi7Xih8jwCvpvSOBZ/xjchdJ4Zbob9G7xX1QmSlz4tuMUrDioKShosHgM7U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(186003)(31686004)(86362001)(4326008)(7416002)(6916009)(5660300002)(8676002)(38350700002)(38100700002)(8936002)(53546011)(66946007)(2616005)(66556008)(66476007)(52116002)(31696002)(956004)(2906002)(316002)(16576012)(478600001)(6486002)(36756003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vmx5bkJrMDQ3NmtUODY4U2ErUHVJdFRPcmttcGVHRDRCRjBLUS9UWGFOU2Z3?=
 =?utf-8?B?LzhEdTdZTktsZ1hyUkEySDRXM2VwWVBqdWt1bmhrVFVZTnJlWk00L29PZFdJ?=
 =?utf-8?B?SXZCcE9qWlZYVyt4TW9XMjdUU0ozZXM5TXR2Q01sb3E1b052NHphNEYra3Rq?=
 =?utf-8?B?SFVzTXdNdXFqRWNIdzBSU01CRnBQVEZKa01UdVY4VHFPZTlFc2N5b0EzS2N5?=
 =?utf-8?B?SlZmMXIvZFBEZUVleGxqNEZCaWVQWDRtd3FaSFpMY2ZNRlF1R2N6N0FWSEp4?=
 =?utf-8?B?b25oVDAwR2RWY2k4dFQvWHFKODl5UXdtbTNkUlRlUFRRd3lBSUlsR1p5Qkwz?=
 =?utf-8?B?TWNrQ05xSDByUGU4d3JOZHFDZkZMRzVTQzRDOHJrV210dTdtbmNMU3pLU2Ex?=
 =?utf-8?B?eCtMY1pkSHZPUHc4U0RYQ0Rkc1hwMFhWeXhkRk9MODkwTUxvaG94WXVuQnRR?=
 =?utf-8?B?ckJXNlorcXBCa3lwS3VlQXpjelpYQ3g3L3JuWUNhdmRKWFV5SDhLd0RoMXZU?=
 =?utf-8?B?U25KQ21kQk5tbkhWa3NSS0FNdDdOMjRFMGJXVWwwbjltR2VlMHNjZUNPbTNQ?=
 =?utf-8?B?NnB0Ym14cG1YZnRlYVc5bmhLQ1RBVGZZOU5vVlJTdHQ4ZU5jZ2NtWmV2TEdv?=
 =?utf-8?B?UVo5WmduVWQxQWM2T3VEc3pyWVBtZ0NuY3JQVXF5bGlHUkN3OENZNmJPR2dy?=
 =?utf-8?B?WXcwaGxhZFVwVllWYVc0TVVNV213dTRjYVNNempnVGt1STNwT1JsNmRvTkdD?=
 =?utf-8?B?SE80MjRpOVFEY0RGUERMUW1NMy9mY25oSWlybU9UdjBMYWZmcnJmMUQ3cmVt?=
 =?utf-8?B?cGltTDlSZC9EeEhyZ2NlYTFYb0xkeE9BWWcxdzRFNmNHNW1JZjFtSUFEOWh2?=
 =?utf-8?B?cmZHa2dpb0ZqYWN1ejd6WVpIT05ZdWxJbTdJTlZZUzUzRm12RWFGOWlyMHlJ?=
 =?utf-8?B?SHg5OG11NUtZbWFkN0djemF6cEhJTWFVcEZaSUd0cE9sSEVEUWtFQVY2bFlu?=
 =?utf-8?B?Ky83WVVmblVac3l4Sk10VEVtVlZ3WXdHc0prVGF3VnkzU09LZ0YvNVdDL0Ux?=
 =?utf-8?B?UUZqeFlNYjdiUzdTSHBrYmlyZkV1eGZKWkVCR25TaWlRZFJBL0hIalB1UXBm?=
 =?utf-8?B?cHAvb3ZaOUdOaHNDdkwvNkhmRkxaVlJoU3pKdUZSMTExVEpPN0VHOGRyemJo?=
 =?utf-8?B?YlFqWHVkeVlnRGllSDRmQXE1RkxYMEhIbWl0SW5hRXdCSks3bXNNc1pYcjZE?=
 =?utf-8?B?WDNRdWZrWGN2TkI5WXo1b2RmWG4xZ2M4LzRvNHhaVkp6dHFqRDcvcVV6Uy9F?=
 =?utf-8?B?SGpTbEFGclF3YmF3cDN5YWtwa29OTGwyVGE1cHM0ZW5jYXdwRVpCZmtjbUhH?=
 =?utf-8?B?WnE2SFJ2dTRjK29tdTdXTTJTbVJlM2tkdFRCU0VSRkNPMDhub0ZheUs0bTVp?=
 =?utf-8?B?YVhkY1h0N3VvSS9MNWdCeHlZaDhDRnQ2UUhLdU5mb2hXc2NoMDRrcU9qVDBF?=
 =?utf-8?B?aCtSZmtVL0ZNdWlMSFhZemRUL0ZhVlllQTBIVWx6eURPSGNsQVN1elVQWWpM?=
 =?utf-8?B?OTV5VUpyYVM3Q29xZEZoM3MwN0hIU2lab3R6VTdMZEtTWGVscERYdWZ5NGNs?=
 =?utf-8?B?YWFKUk5kOWpVUUhkUFhaNGxFc1RLU0wweUFtWFMxeU1pWVlSc3VaNnBqZVg4?=
 =?utf-8?B?QXNLeGU0NzlDT3RvUTl2eFZuZ2VrTm5yS2NKQUxndm4wSGdWVkYvQ2c0a2Y5?=
 =?utf-8?Q?EEOyxfUwTXxHgBuiu64Xtmy7VZNbTALKoXUWWew?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72179e55-8ad7-4d42-f7ab-08d95aa30f19
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 19:31:03.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6zxmPq80rso0Nwvh48OHqASy+uJ1VoubZrGdF7i+6jxWY0AgWYAwiJyjqBEJ5zG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/5/21 4:51 PM, Sean Christopherson wrote:
> 
> If we want to keep the MAXPHYADDR behavior, I'd vote for something like:
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b4b65c21b2ca..7e35f2bf89b4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>   bool tdp_enabled = false;
> 
>   static int max_huge_page_level __read_mostly;
> +static int tdp_root_level __read_mostly;
>   static int max_tdp_level __read_mostly;
> 
>   enum {
> @@ -4645,6 +4646,9 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
> 
>   static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>   {
> +       if (tdp_root_level)
> +               return tdp_root_level;
> +
>          /* Use 5-level TDP if and only if it's useful/necessary. */
>          if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
>                  return 4;
> @@ -5336,10 +5340,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>           */
>   }
> 
> -void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
> -                      int tdp_huge_page_level)
> +void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> +                      int tdp_max_root_level, int tdp_huge_page_level)
>   {
>          tdp_enabled = enable_tdp;
> +       tdp_root_level = tdp_forced_root_level;
>          max_tdp_level = tdp_max_root_level;
> 
>          /*
> 

I decided to take this suggestion in v2: it avoids using 5-level table 
(memory cost and potential table-walk overhead) if the host has the 
flexibility of using 4-level NPT under LA57.
