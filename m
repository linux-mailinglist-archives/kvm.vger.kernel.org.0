Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD98870A5DD
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 08:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjETGH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 May 2023 02:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjETGH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 May 2023 02:07:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0446F1A1;
        Fri, 19 May 2023 23:07:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlMeIlGhsiG8qehFHm+kyksodUiYcuNydH49AUnx+3N2ea1IzEaLvrNEWhUDMr+qi8OwLPyEGazINi9xt03LIj2T1lv2v09DcIfqQXnDed/ICboAaBhNhoO2CCASmbpjwlAbnJRdhGFVB/7zI8NiRB4ALuZlPenDuOnVt7rTSb2Q/lM3u3I+fmCydJmj4lJJSPyyNyqlLBy+Ld5Pb5leL/LLQvITQ7OyGAwkLwgKzqMg35oq5ZxJ7O26y+WsUvo6yNCVtYikD5r8BPmY3vnKfDa515LtygPka2qY7+uRZmyFyVkVYDbNrLp9S1JKBa8/MYmPxyAI79VaQpYC0Ti9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5dUBh3bdo7QiN2qYL8PVK0WGibt2uJ3Jw8v4oHkRtg=;
 b=flHlW6JD6YGh9EpXsQQ2SHwG1H65FO3rW6Cl812ALWaIj0HBg8X2278ALnokVh5ygR6lF/FOoeRv32Fc9RoNSMFWBd5A+DVpTd/4WO6TozUeJqtVJT5b6LJ4UA3S9WonHTZqWFWF8u9DHbKsK8/E5LjzhQJMdn+5jDrN1wf8PcIfAsQ2QMSecH9fF9/9TZPSE1t1gQS+ZS/yFthpHCYMJJb8HEy71YKFGViNAotDk2h3RHP65VzrvWLZ9McVIsa2RO7JjhkS3tAKqO1Q0oU1uVx/dVugXtqdE9c8737dAzLMvpDPAqkN0eoaQumBlLI0d+Q7EAGeRFrNh+U2BPhwhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5dUBh3bdo7QiN2qYL8PVK0WGibt2uJ3Jw8v4oHkRtg=;
 b=fCpIU1or5h/ccgnKpCKipoYjmLCHwOYa25OKAPQtmoIr1ePZkxdcW3Lkb5IwHnkm9LJHdm8PFgKo05vm0sF+NofnjFHy+GaWiHqt4FAsJ7kfOTNdT0hmTd+k9mKaDqkL0loDV2ZMYzyh7kl8R8s0uRKZa6zoWJ+Q/CW6TVaHsRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM4PR12MB6615.namprd12.prod.outlook.com (2603:10b6:8:8d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.21; Sat, 20 May 2023 06:07:52 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::6af2:58b5:ae35:6ff4]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::6af2:58b5:ae35:6ff4%6]) with mapi id 15.20.6411.021; Sat, 20 May 2023
 06:07:52 +0000
Message-ID: <cae16272-2fcb-3e9f-5ad3-50d5a7e137d1@amd.com>
Date:   Sat, 20 May 2023 11:36:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not
 V_NMI_BLOCKING_MASK
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <be4ca192eb0c1e69a210db3009ca984e6a54ae69.1684495380.git.maciej.szmigiero@oracle.com>
 <ZGebCSwAA4W10atN@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <ZGebCSwAA4W10atN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0219.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::13) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|DM4PR12MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f26060-a544-428e-5d4f-08db58f88bc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FYEnwFlow8ANOOEqsT9DLYDv5z+83Or/kUb0ImTn6G6fxYzgmTFLKD8SCBx9055UqUJRpPmfcR9F9dImCvl+AlEn/m3dnU8ibAiJKlryU7iXkREQVWaCVQh/PU0bymNnat1SEqo+mX7AFg5mFnP0MY7P744GwW5EpMWhxBuyHkQh8hi91SLVjdKJhQABkdE911LMeySzCQQgr945QOV8GiYnG5PovwLePCoglO32RkIE1EIGTyP3d/KDBwyT7YotcuHU0sZ3X708bmBzz9HFAHEU6mUfNQ1mC3N75NLsokuDJ76ugsii56au0Ajwi/zboQ4wSAUAnajD89Mjuw6K27CeGPkC6Zp/2KE9oEXuVFVO1xH/zBiLf2Alhr7ryHyS9NRI6utTl7E6SQfsV1oKdG5Wf0TrHYIp9KzDfxojjZR3o6BIpxRGcHggUWHA8equNZs7dfe1LusdpWoEw3+ZWFLu1hSFi1DhFq7D0owxiBDis/79gnD/EllR+LkySdK7YYyZOvk2i7D0cyZBPWPhxSrwJU/FGY/pfpk+gOLZmB3OjUzg1hnI34dSFoIz/JoW97uFyokTHR+FFfKNpH4qIb48QIWWtaAbtBtKYYJeGfKrIKdK1blQZDbdBGJt04w+aJjDNPO+UYWhGTccC6psVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199021)(31696002)(86362001)(36756003)(110136005)(316002)(478600001)(66556008)(66946007)(4326008)(54906003)(66476007)(6666004)(8936002)(8676002)(5660300002)(2906002)(44832011)(38100700002)(6486002)(41300700001)(186003)(26005)(53546011)(6512007)(6506007)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXVyUVc1eW1zL0FlbVNTdWl4TUtHQ2JHSGFZSCt3L0JqRUl6WEpUWEJ3YVlS?=
 =?utf-8?B?ZW80TmRISG5Qa2M2eHhDY2tMY3J0YmlDYUhpSGQvZkxERWFXekwwZEhiZGsv?=
 =?utf-8?B?djYvTCtTUEErL2wvbWlwZ1NPOWhhMGZ5aHZGdm1tTndySlNnQXhIU1V6TGlZ?=
 =?utf-8?B?NzFDMzc1OW9Lbnl1alNqN2t4NUJ5TFJGVm5ranBOSmVrODZlakRqZ2JrQytv?=
 =?utf-8?B?c1dORmRmMVducW83aHZQRjVISzZuYjJMbEpMa3BBWTRkQkt5N09Qc28yZ1dh?=
 =?utf-8?B?UmFIaStHZGlWdll2UWV5SFdrV1dmUDZNMjAwR0Ftd1hkc1g0dHlPQzk5OVRC?=
 =?utf-8?B?U2t6Mnd3MDNGSWprTHI4U0lmNS9hMWNZL1VEQlZMdEdlK2Y3TUtQMEdNL2cw?=
 =?utf-8?B?SFFPN3huTTNibDBJTjNka0Q1eGdYUDdjT2xvdm9XQVpFV3ByOSs1eElkNVhR?=
 =?utf-8?B?Kzl0Z3o5VEtjVFZYYkZlU3lFdCt5Z1piUWd3MkFzZXdJMDkyaEw4NFFZQWhJ?=
 =?utf-8?B?bHpjdlBoOG9rREw4dmo1RVdZdkNlSHdWR0FmVHNHYzhxU21TSkhWSEJ1RHda?=
 =?utf-8?B?Qk5nL0MycUYyc04xTisyOGRwNWRHU2VkdGtwTEpWVmltWjlNRkdiRnNHYmpR?=
 =?utf-8?B?cDNsM2Z4bTV0YlptN3pmU0tncUttK0JSdExhSEc1aVp4UUdTak5wd2ZpYXFE?=
 =?utf-8?B?bjhSZXN5VWdDbk1ZUWlZUC8zTzgyNWlEcWlkRDJQT2t3MTJ5TW82TXFoeGRW?=
 =?utf-8?B?ZjFRV01vTVZCeWQvZzlmdlJjbFhGK1NCMWRoR2hOUjlUc3h0eitvU1h5Z0Js?=
 =?utf-8?B?SFVCRGg2QUdubzNKMXI1dWsvV2pwRW03eGR0R0dZRVVSK1hQYkpIMjFhQ001?=
 =?utf-8?B?ZngxejNGM3lqSXNmYkUwUjBZUlFmbWtiTENnMDBmVWtxdmFKZ1FWTlRwb1dC?=
 =?utf-8?B?bGg3RnI0dmExWldaaE94bXFJSkZFbDRmTnRITHBoc1VSM3dpYWhDcHhYSm81?=
 =?utf-8?B?VnhNcmVGT0xsKzM2UUxuVmZRaUFLcjZzTkNsZDRETEJod0c0azhjbG8wZnJO?=
 =?utf-8?B?V2FLaWg0Q2NjUkdCNWI0Nzc4TlEweU8wRHQxc1NiRDgycUIvSWZ4eE9PaDE1?=
 =?utf-8?B?ZFgzR0pXdHlWaEtGbWltWEdTVmFHTjNQU1d4aGFDeXRzc2tTWk54cVVpMDJT?=
 =?utf-8?B?d1FzbGRPaE1jZmc1MW9hVzlYcmRnTFg4REhCQlFKejYraUIxUVhiOTgzUk1x?=
 =?utf-8?B?YzU4N1EwZDRYbzBweTdaV0FrQno1QTdnT3ZKYTMvcWpvdzhyTjh2MTNEV3lW?=
 =?utf-8?B?VWRQL2lXVTJsVVFIM3V6ZGtBTkFpT0JmZWw3R25nNG5HeW94cVA5OElNVStG?=
 =?utf-8?B?aW1POW4zdnhDTkZKYzBtT2pXdGRxYm5GUStmbUVpaGVpdysxaTUvOVdMSzM5?=
 =?utf-8?B?UzlFUWZ6NzZXdktBZjd3alhFbDZuTmZzb1lUT2hvV2RndEtYSklMSm1jdnpE?=
 =?utf-8?B?NHNra0NMazJtdzBxa3QzSGdNYStEeHdOWmx6ZXdCa25TU1JMTHlHVWRZN0VY?=
 =?utf-8?B?eG42eG1FY2c2SmFUMXpBNEVkUFFVbi9maVRPaHZ6ZGlHdllFNEhjRjZ5eXNU?=
 =?utf-8?B?UDYvWXNIbHorQXhJTVk5cmlCSzhkMXhqS2dQWTFCeXdvR1FiZjNWWllHbkgx?=
 =?utf-8?B?NHRMelBKUFVUVitCRWxtbVFxK2tYc0RDa21lRlN5L21EWGFGYk1Gb2luc3dY?=
 =?utf-8?B?Nys2QUF6dXkyaW9TeTI3N3BvcWlRZ0RTaTRvSkZmSlFvOVpWR3JUbWE4NDdF?=
 =?utf-8?B?NG53RlFVYVZLWGlUWFM4L2hxWHo4cjlqdXkwNndkcmhUZUVEOHZZeDhkWkpW?=
 =?utf-8?B?VUZtaFpnUVZzUEVyUGxCek1uVE5UYUtRL0krdnJWdjExMjRWR0dQRlk5Yiti?=
 =?utf-8?B?NFkxYXJRYXhxR3NiY3E3QVoxMzJOTEUxNG0vZS9XUStjMWw2dGVUUHh6TTV4?=
 =?utf-8?B?b0FEZlhBRGNOUXM2SWFJcmMyZjNsaCtMaDlZMHVTU2Vtc0M2WFhGZDN6Vy8x?=
 =?utf-8?B?OW1ZYjRsbUtSQ0lBakRnZFFtazhNbytKbm1OVi9pRDhEZHFHODg4aThubHRh?=
 =?utf-8?Q?PJm/u3IXHK4JDlZx4LCkhaPmj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f26060-a544-428e-5d4f-08db58f88bc2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2023 06:07:52.6365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZ89tJbFyWehUg4am2vc8qLF1Z9wIceTJMiCjws/V1lGDF6XWNw4C1o2BFiKnWilcDJwBNOtlVo4ROdcPFNc+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6615
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean and Maciej,

On 5/19/2023 9:21 PM, Sean Christopherson wrote:
> On Fri, May 19, 2023, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> While testing Hyper-V enabled Windows Server 2019 guests on Zen4 hardware
>> I noticed that with vCPU count large enough (> 16) they sometimes froze at
>> boot.
>> With vCPU count of 64 they never booted successfully - suggesting some kind
>> of a race condition.
>>
>> Since adding "vnmi=0" module parameter made these guests boot successfully
>> it was clear that the problem is most likely (v)NMI-related.
>>
>> Running kvm-unit-tests quickly showed failing NMI-related tests cases, like
>> "multiple nmi" and "pending nmi" from apic-split, x2apic and xapic tests
>> and the NMI parts of eventinj test.
>>
>> The issue was that once one NMI was being serviced no other NMI was allowed
>> to be set pending (NMI limit = 0), which was traced to
>> svm_is_vnmi_pending() wrongly testing for the "NMI blocked" flag rather
>> than for the "NMI pending" flag.
>>
>> Fix this by testing for the right flag in svm_is_vnmi_pending().
>> Once this is done, the NMI-related kvm-unit-tests pass successfully and
>> the Windows guest no longer freezes at boot.
>>
>> Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
>> ---
>>
>> It's a bit sad that no-one apparently tested the vNMI patchset with
>> kvm-unit-tests on an actual vNMI-enabled hardware...
> 
> That's one way to put it.
> 
> Santosh, what happened?  This goof was present in both v3 and v4, i.e. it wasn't
> something that we botched when applying/massaging at the last minute.  And the
> cover letters for both v3 and v4 state "Series ... tested on AMD EPYC-Genoa".

My bad that I only ran svm_test with vnmi in past using Sean's KUT branch
remotes/sean-kut/svm/vnmi_test and saw that vnmi test was passing.
Here are the logs:
---
PASS: vNMI enabled but NMI_INTERCEPT unset!
PASS: vNMI with vector 2 not injected
PASS: VNMI serviced
PASS: vnmi
--- 

However when I ran mentioned tests by Maciej, I do see the failure. Thanks for this pointing out.

Reviewed-by : Santosh Shukla <Santosh.Shukla@amd.com>

Best Regards,
Santosh
