Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EBD4F49C2
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444184AbiDEWVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573088AbiDERzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 13:55:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA840C53;
        Tue,  5 Apr 2022 10:53:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JF1+LxTe2qiU3qpt5EQyT0gqHpY7rs1xGXU7qDN7XVUdOwuEGFHl0BFFXsfFfUY/NTtqiR3GZbWJ/SXlk4ObZPpAmqZ1XM3vhuZXr1lP1k0lO1xXvLCekM96SuHIiK5qv/55Aiv2di/0UAptcpVL/jHYU6/mF1fHWcqwRbsrJ1P8hWpexv2HyN5nZY0r6EUtpfaCXN+4rGj3UDpijIb3b90Ynv63yq/ovhve3kPsGlUpDZQq/3oQIIsjBmR3cdXdb3T75sb2smrHAsdWkdcK/LFiDW9Qsv8sVsJNyoQICMr9Z1e6WUHoeObIxSDUAXuAb2KzJxmJRqxKSpejbXrO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cx0Md85+OjQl+K3dA8Y50XnOsnMOptANWRBjNvTs12c=;
 b=EddQpUNsDsQYY93A6J6fygARxm/95nDscMrMH5K81XrzM+/AXBqcEDP8Sw/pVo3qOzFOtgmm43Wz0h30lGzIzYzqTF04FrOaI0+8g8T76pB71pcqkwLGEaD/2NFuF89TERwZllw3o3u3qVS6CGnJE65SzzRh5IafEogud9kWbsm+pREYhWu/yR0CQlkdxWqXdhKfM1ScdYvt6P8S9i6+kxlx1Qv6N0Fw6lW4GTiT1xLi5dQ2lnL4pn18zWDvvIeELFAGowig+aXt7uSHRn/gWKYY/+ogeGU/fwzdERjdKQYYIj5DL6JiNqfn0Am3MfbJ3YhZzV10b8ar2kYwBCHRqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cx0Md85+OjQl+K3dA8Y50XnOsnMOptANWRBjNvTs12c=;
 b=Xmk9n5U7mahqHeFWo1JS2HqGf4+/IvcUfCbZ7grFjaCgHhF4WYQRUfLtizE50Iqor6gZDhySiM9w8Wi3bK5wcO5fUHUQYcMcXqs4A3l6mdyMabWMopu+YvCvyJONIausj94OqTFijv4dI9l2BFYufPxfH3Bpbr+uuhHCGKga7D0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM5PR12MB1849.namprd12.prod.outlook.com (2603:10b6:3:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 17:53:33 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1946:2337:6656:ae2e]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1946:2337:6656:ae2e%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 17:53:33 +0000
Message-ID: <700e336a-7d2f-e468-f38b-96e6d35174e7@amd.com>
Date:   Tue, 5 Apr 2022 12:53:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 101/104] KVM: TDX: Silently ignore INIT/SIPI
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
 <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR1501CA0022.namprd15.prod.outlook.com
 (2603:10b6:207:17::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bef6279a-302a-4310-60e7-08da172d3375
X-MS-TrafficTypeDiagnostic: DM5PR12MB1849:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1849635AD0CF3BB0D2A05019ECE49@DM5PR12MB1849.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7pQkoUL9rNeFdMBi7OWm6P42tcz6Vieizr6+NJdLrN545w9v6UhkGd5Aou1T7iqiXnjxyZbrkW94T8iyoGFmWZq7FxgdRFHZZxI/kVk2xJbhZxi4pF1Tv/eTOIXdYDefkuqi8D/LM5Qmf7+NANi7wNw119bNH5cFvc7SyoICrkQGigGM+PM3FiXh7WmWpsx7bb5p3JHQuQd3nDG6+Rjj3FsP0NFVMg9kLSW6RdK0WoT/M42eUPsIFYenh+xS5Z32xfRmGFBO1LpQcV09Ou8fJUbgbU4b2p//2+fb1l7BoiQYwoKF7NrmZiD0acnr1gG1BmD2LFjjOengVhmnzFxvgJwgWH+R5gok7xkkadhjPRPO3N/e07m2afZcDvNjxojEyaXK5keJhYXu5K7YPU5Ljwu+jbgZ3g1hDO1fw1W2QJ1MGkHjMiy5KNjE14wvg2eflrCR455sd/JHnXtd5wQ+WRhf7j/lvRtHRJ/tKlWc3i+1goNl8XxoeuBN8QxaB3pZqJjBkmCyoBmORYQreDohJOJtv/RMN8vlyCm9gfrsqcxMujnuhLr6vAVvT/DJUHRUDu5Eks0LLKoy/ywT6u9WbCAZdMZWqqg+TsTsDBlYEw5XUrJFGODx0aSg8Mwp+PGyql7Ll/24pZrJbxNqBkqRiO6NhOqU1rOlNQqkL3icqy3mDfwsOoqSTx97pqjMCKZDS1IkzIeckOLmAeunxe7lVDsNZ7gOMm69c/3gqn+qC0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(26005)(31696002)(54906003)(6486002)(186003)(86362001)(316002)(2616005)(508600001)(66946007)(66556008)(66476007)(4326008)(53546011)(6506007)(6512007)(8676002)(36756003)(31686004)(2906002)(83380400001)(38100700002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUlON0didXRHYUZrREdyL2d6ZkZrcngzUUlsdCtDQmo5TC84Qmg0UGhBOE03?=
 =?utf-8?B?Z0VBYW8xamFaZThSSUNNYkN2TWUxQ2x0UVFjWGVGb1RObTljWFo2MUM0WnFQ?=
 =?utf-8?B?dW9PWmdLQnkvTmRLTkpFRktEQlYrdnd3REtsWEpWMkovSVVDcGZYeVdna0Jm?=
 =?utf-8?B?NDd2SXQ3Rk53cmQvM3JnelBOSXkzTW0vclU3SmNEU0x2ZWtUM3ZNZTJZWHpT?=
 =?utf-8?B?SWUzVFgxbG5vNjJBazlRVWVqRWozQlVlTXNXdWk0QlBVUmJER0N3VWRxWmw1?=
 =?utf-8?B?aEluc3VrZ3RWWUk4VmRPUk4wVURQYVZwUDlGK0puMXZnTWVqQXhZdW9IQTJP?=
 =?utf-8?B?cnkxMWFhUk52UmxTMW5VZklKcGpNcG5mS0hObkZndkZZRHVGTnB5NWc4aTFF?=
 =?utf-8?B?NTMrZjN4RDU0ZFJ4T3g4V1VsclpMcGkrTXd1QXpLM3FnQUlUeG42MTNvbWls?=
 =?utf-8?B?Zkt3SFRXQklQWDBnemVOZU11K3pKbndLSXlHd3EvMDBFZzNZUmIxb3hMaTN2?=
 =?utf-8?B?N1doT1o4RUhua1BsVS8vREgxQmpGOWs5M0N0U1ZSdkIxZzFrVjU5bXI5WGsy?=
 =?utf-8?B?TXFlekw2dXRzby9aNnVoSytlYjhEa1VOaENmUEVpQlNWY3lyWUpLYUFhNVZP?=
 =?utf-8?B?U1o2N0FxMFlmbnN0OC8xVU1jc1NZa3BvTGwyTGNyVExvc3YyVkhVWHR4QldR?=
 =?utf-8?B?ZzZ5bWNJQklPM1IxSmdhbEJhNExwZ1RLaWdYSXF4cEpZYU5aWkV0alBUN1ds?=
 =?utf-8?B?MlBsN3AxeWRxU3cxOHQwUmUySUVleTRZZWVmTS9zZDB2Z1RyYnpGUWhTWmNo?=
 =?utf-8?B?MitCVGtUMGZDelpJcEI4VDdHNlJuQU1jeC9oWnArWmt0U1JLZER0Sk1FNFBP?=
 =?utf-8?B?TWFIYjJYMGJVOEMrb1NxNmtwUkhaTHNtclhWZW5KTFJ1OGMycWgwWTFzL2tu?=
 =?utf-8?B?Ym5VcXlhMXgzRURuandnbDkvd3puM0N3THdHdXorUkZrSVBXdmljM1oyak5m?=
 =?utf-8?B?SHJwNzRjRWxSR3hOTGkvNmM1RHRiTnh2LzFmdnJtdjB0ZXptYldTY3dHc0lF?=
 =?utf-8?B?ZjZFbFZPc1hPaTlLZEZSUlAxa0FWTnl1U2lpLzVjWExocU1DNVpTM1lWZjkx?=
 =?utf-8?B?bEs1MEQvVkwvRUU0SWxLR2dVd2MxRTFxV0xzRnNvRXg1YTRJY1lOK1lBd2lr?=
 =?utf-8?B?eWlYdWwzRkVsTWhHak9IdzJqTlVRMlg2d0o3S2ZOMENOektMdjBmVEZKQUNi?=
 =?utf-8?B?R0xUM2dxZ0hEbUt4U0phVUEyUjF2YlVwUGtPOTRzMW9oazRmQlhYekJZQ1RV?=
 =?utf-8?B?YThnZXhVTXFjcVV4SUtuODJvY2JvcnRjYmVuNEh6ZUNSRDllR1REVWxSa3h6?=
 =?utf-8?B?Z00zODd4a2lkNGNIRUI1bStsZG5JUXBnZUZuQmtVMmVvWm9Ud2dwd1lDc2tB?=
 =?utf-8?B?TTBNTUl0VnNGenFDRWlqSFNZSUxOV1VXU2ozNTFnMHpjdVBqUmxjTlpCZ2VG?=
 =?utf-8?B?RTk5dktWNTBHWE91WVNiYXFZMDh5Q0ZrUWxqMVhJeDkwVGExMk55NXlOMlFp?=
 =?utf-8?B?eHd2OEx5TERmZVMwU2I1Q2tjYldNZG9kZUhrdzRubTRqM0l1SC9KbXB2RllL?=
 =?utf-8?B?WHNTOWJFMlV5OGdFbjFOSEdKUWszSHNCUUdUTyt5eFRiUUdzUlpnY3p3SUlI?=
 =?utf-8?B?UU9Od1ppd1BUMy9wQmtNNkh0UTNGNE0wTGtFRVEwT0ZuNmZrUmNyZzU3Rk5E?=
 =?utf-8?B?bWFMYU9uMnhJQmVkOXp1RWphUW5vSG14VG0wUXNKUXJ0NjhmZk40ODVZMUt1?=
 =?utf-8?B?V1B6Tzhxei8vN1RqWGF4TGRWNmkxQzYxQlpzQjhpZEZDVzBrSkorMUF0Rnd2?=
 =?utf-8?B?bmR2cldzTlMyNklzWThUb2l3YzlubGhZSXd0dXZHdXV1ZmpvSVY4M2N3RHBk?=
 =?utf-8?B?TS9IbTc4bU9ieXYzQm45UkVHVFVMV0lYTEY1SVBwOWF5VDlEVlFScFRwcHpI?=
 =?utf-8?B?QmEyeU9LdHd4WjJFbzE1R3pDZEhHb3pZckVRQWJTaDJLM2xnbFA1NVhwaEtO?=
 =?utf-8?B?ZU9DYlFRdFgzbElIdXpLeVM4K2RrNk1sQlRmK29ZK0R5SzY4M0QrVGhrK1Bs?=
 =?utf-8?B?R3JrcFVESHJDY040WjlMRVRZSnEzci9sYXpNZjVPL1dNa0NiZ3FheEZ6Tm1R?=
 =?utf-8?B?UEZFemdnL3VQdFVTQWF4S25OUFNFbHBibWdJVU1ERXBhVitRRjdvaVdIVkhW?=
 =?utf-8?B?cEpFK2xPU1hDditPV0U3clFId1M1cjZKMlIwN2J5L1k0UFd3K25QZGNvRVVW?=
 =?utf-8?B?azVXRE1JLzlNd1BJOVZxcjJzeWF0WW5yYmFlM3lmVEJvTmREODMzUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef6279a-302a-4310-60e7-08da172d3375
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 17:53:33.2831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDjYfTRsBnD3yVp3tXT3tZk0NGY5OwWPAC+2nnaOkx/Akp0FVDe9qeoYDYmYtbnUgnsCH/c9uQitZUeEO3X+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1849
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 10:48, Paolo Bonzini wrote:
> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
>> +        if (kvm_init_sipi_unsupported(vcpu->kvm))
>> +            /*
>> +             * TDX doesn't support INIT.  Ignore INIT event.  In the
>> +             * case of SIPI, the callback of
>> +             * vcpu_deliver_sipi_vector ignores it.
>> +             */
>>               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>> -        else
>> -            vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>> +        else {
>> +            kvm_vcpu_reset(vcpu, true);
>> +            if (kvm_vcpu_is_bsp(apic->vcpu))
>> +                vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>> +            else
>> +                vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>> +        }
> 
> Should you check vcpu->arch.guest_state_protected instead of 
> special-casing TDX?  KVM_APIC_INIT is not valid for SEV-ES either, if I 
> remember correctly.

While the INIT doesn't update any actual state that is in the encrypted 
VMSA, SEV-ES still calls kvm_vcpu_reset() to allow KVM to set any internal 
tracking state, etc. I haven't ever tested SEV-ES where that is bypassed.

Thanks,
Tom

> 
> Paolo
