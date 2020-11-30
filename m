Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA62C88F9
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgK3QHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 11:07:33 -0500
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:35372
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbgK3QHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 11:07:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDb0QFqfVSsNvKsN9JT8Xmfd+/qtMZUR8LbDUT1VnY/EE85xmWgvf8UiYy2RWKaDAI2lUCyU75WrQ+HlfhwQf7r5CVqLuQDNvkjfBGbHNgwLryTXUiEbD4iVogI5kpVZgpFA8WjfD5vR4qhIlQU65U9VNDLE0quv1EZZHasJZYxTtd3g1JabUB+6AeK6QUpGgvZtRpscjz1hhYYY4qSFkb6GrOvaGCKQE4o5Mc4BTiElFXexQivN+AwUezH1EIb9AR7tmb18+eMEVepvDiHxAJYgYK3/z2ygxmbzyJRRWzvR9557MUStUtkFguJlB9WoeuMWwoqLKebNAPxnP69aPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/fgtEcPBfS8uhm8TjrFayT6ljwj48MRYxCZwX1JU5A=;
 b=YjS1sxRnv4us4a8sm5Cm2XEMqaknVu2WvBckMvxdXPDZSie+NVn8fDEut5T/MTCDn1waridxHavjR6inhkm0TstVTcHDvaSsj8SKJU4otO1Nxz4P+O2lwBdSjHgyodP1Pp+szx4l3hXgW/TWRW0hc2iJe6gL1/U3RLpVtMA7fxay5Pnzu/VF1lIGhsJcrMJuWfz6QbxK5Ti8Qd4bgYr60BzK6u2ZXy50uZ3u4Y6bBbBNx+Wk0RBTAcyX24peVlptA/V7qyjqTWLW9SD2kMRHOG9U05Lz5SNN/OvNNCmwLyLHWE9qOR9S610Iw0Qse9yAa36keWvz7InnEX/dFCGnnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/fgtEcPBfS8uhm8TjrFayT6ljwj48MRYxCZwX1JU5A=;
 b=s/UginYNn+1dQlw1nFlXKiGJ8Tunh5IYNiEuExoFBV/adT4P8bJiIGGPItMKF9vVFODZqUtSq1l4Mn9X8lRQBtWVgtgfQuytr+shgC4MclkjKBqCEiq/O5Lh6KB8AePp1vKp6KZiuvS7cszTCta4WKH5+jSDJsrvdPes9N2g32M=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0027.namprd12.prod.outlook.com (2603:10b6:4:59::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25; Mon, 30 Nov 2020 16:06:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 16:06:39 +0000
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
 <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <38e89899-cf58-3a39-1d09-3ce963140a57@amd.com>
Date:   Mon, 30 Nov 2020 10:06:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0025.prod.exchangelabs.com (2603:10b6:804:2::35)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN2PR01CA0025.prod.exchangelabs.com (2603:10b6:804:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 16:06:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 190132ba-26f8-4ac4-7aac-08d89549ebc1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0027:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB002738D65014F1F11FEAC183ECF50@DM5PR1201MB0027.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67CcpDaDb7dQcMndR7pmi1rrIR6Sj8LvQsBLfp1+9lReFqShy/zlvujpIqHG43yuNA25UONy2Fmue5vnfHJis7VoAkGYGlzRyCyuxBgfYE/9w43OJw/NAZ+1VPhowvhtROIh76ta+x6PZwDvV79161J1PjXaiSXLdf+vh5JPbvGDA1Q1sdX1Sg3ptSOyAyDfkjXPqh0yb9UrofyEVvBwJELW3fkqGekWuFfqexfWcB1eBIIXuPNxrWaQ8YlVV/GPjUSLCi1Wp53L/gchjnoThrTN6KzLhNKGghRBoaUreqf/PbQi7qgRMCpqFaa1QiC/NUCATNq6n4TeB399pVt1jpwgpPo4R5nV05RSA3JRVEOX3fw7k3HVB/8ZgAyVFsU2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(31686004)(53546011)(8676002)(86362001)(52116002)(2906002)(31696002)(16576012)(316002)(110136005)(54906003)(7416002)(956004)(478600001)(5660300002)(66476007)(66946007)(2616005)(66556008)(26005)(8936002)(6486002)(36756003)(4744005)(16526019)(83380400001)(4326008)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXBHQ3NIT0xsMkc1MFRKRUdVVnRZMm5sLy9BbHpmaFVrQjJLaFNzUFJuY3ZO?=
 =?utf-8?B?NGZxSVJCV3FWUnNBWUVGdkZUUmVabjdFYUNMUU9HWFI1QlhGczJSNTA3MmV0?=
 =?utf-8?B?VWNSVG52cVlFY1ZhMk1PV3dCbFJHY0tOeUxhYWhXUEswL3FnWDhlalVNMGh1?=
 =?utf-8?B?dEplb1gycFZmR05YUW5tUStpb3NTSlRURTlaUkNzVUxDVFhoTXV6N05JbE10?=
 =?utf-8?B?d0VWL0d2V2xEZkU0Z0VvRmsxaEdvQmxnaFFibFRKa2J1VkkyMEJUUnkvZTNy?=
 =?utf-8?B?RTY4N2JPN0Yveit0Q2lISnAzcDFZY0YrYkJNNjFpbksvUmp0TndPTUkxT2xz?=
 =?utf-8?B?SUJZMHJEd0JxenFDeUU4UEhKc0sxQUdEWDlmRHRKUlhkdDc4dVZlczd5NXg3?=
 =?utf-8?B?SlJIWFhWSkQyOFpZSnE1aURPMXpCT3RKU3dzRUVBb2VTcUxsMUgzbjdncDNt?=
 =?utf-8?B?MkVpTEtCdEVSbEZ5YnBwSnZsUVF0S3NOV0Nzc3IxVXM1dmFzRUFqekZmSWdQ?=
 =?utf-8?B?OTdJZitSUkxpRGh3ZHNjY0s3b042WFpTWG9HcHdtRzUyMVdoTHBsdmE1T0di?=
 =?utf-8?B?WUxTektHeFh5clpzWXVVZEMxZDF3TGhXVWZvQXdKZGgybXVZdFlETEpQSGx0?=
 =?utf-8?B?NVl4V0o5VXhhQnJGNm96S1NOV0phMjdJaDJOYWZyM3RORWVnVWVWZzJTL0x0?=
 =?utf-8?B?d05lb0h2VDVuSnJRY2doZlNZQWZvTHBZRE5rdHg4ZVBZV0QrV3hObEpWUjND?=
 =?utf-8?B?Z1I2T3NuQTBPekVkNTVTVTZpYzVEOHhNKy9FbHhLRFhHRU84OHJxRDJYOVZB?=
 =?utf-8?B?d1BaWGRSMDVob1ovdEtvOGdQV3dBTXlrUGVkTFNINEVjUUFWN0JWSUVzQ0pp?=
 =?utf-8?B?WXB6Qkx6ZVZ4ZWl0cERWZnN4a3R3eWhwVytOenpDV2lSSDMvN3F4S0M5UVJm?=
 =?utf-8?B?cnowQllBTHhZd3NrRUlGL2Fzc1VrQWtXQWVJbG1lNEN5UTJUVHFoVXRyTmZI?=
 =?utf-8?B?b0UxdjBwMCtNRUExNXZRUElPbDRSbkhhaG1oakY2QzBqZlJISjB4SEkrRDJD?=
 =?utf-8?B?dk9hU1RrRUdzL0lvR1dRNXV6RHBkQzRvbW8xTWRFZWtJaEN6WnRCNWFLbUMy?=
 =?utf-8?B?bXduaUJReERUMHVFQ256Y1FDbDJFRFNaK21pa0dxM3JhOEtzUlBBSHc0eG16?=
 =?utf-8?B?OWZjQytCYjdiaTNqeG55WnRJa20yQU9PQ3M5YWxMUmZyS3hwbHJrcXlXYWVz?=
 =?utf-8?B?S1pkdmR4UFZhL1hyeng5MVpWWmVkaGk1cFNBTXlaZXludHg4SWFFOEZuUlZX?=
 =?utf-8?Q?UCkgfCommpcQ8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 190132ba-26f8-4ac4-7aac-08d89549ebc1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 16:06:39.6040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhlZ+V+ErlKxwpbmcppOp9SjjqDaJ/IZNBF63f+opyqXOQ7EkT4FCj+zQmFUQzkV7yjo+W3AHrCaedatEfs4Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0027
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/20 9:31 AM, Paolo Bonzini wrote:
> On 16/09/20 02:19, Sean Christopherson wrote:
>>
>> TDX also selectively blocks/skips portions of other ioctl()s so that the
>> TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
>> injection restrictions are due to direct injection not being allowed
>> (except
>> for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
>> exception injection is completely disallowed.
>>
>>    kvm_vcpu_ioctl_x86_get_vcpu_events:
>>     if (!vcpu->kvm->arch.guest_state_protected)
>>              events->interrupt.shadow =
>> kvm_x86_ops.get_interrupt_shadow(vcpu);
> 
> Perhaps an alternative implementation can enter the vCPU with immediate
> exit until no events are pending, and then return all zeroes?

SEV-SNP has support for restricting injections, but SEV-ES does not.
Perhaps a new boolean, guest_restricted_injection, can be used instead of
basing it on guest_state_protected.

Thanks,
Tom

> 
> Paolo
> 
