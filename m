Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399945B8E43
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiINRlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 13:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiINRlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 13:41:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7C985A91;
        Wed, 14 Sep 2022 10:41:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pg7wmUaId81MyET1HI3fBkbKggh+WwLYYSR9aB4T7HGrlJte3XVgE80dmJYliE1kTCVlcRUSBobMacH37Oy04kn9T957p1c+vEWq5kedFqII1wna7LAkuRRVOdGyiehE0xh0wlElJj1bRgIZUAyKf8997NLa7ERC3cKW0Pp6StlxP8jcKdHsK6+PUMHCaaBWMi4R/8OCP6C4k74CbR2rGvFy2ziMnx92+yHSMbWH9PfRhpHovIOuqSVVZ/0A0EZFsyzBnwPp3HHqsyPBmd6aL7787FWIw9GQ+E6X7UKud/RX1mIMalnPY+tQnbueakxR6+ktHDFQJ5PMB2iXWIJUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7sMOhEufhTs9fpc4fYFuk8ps+yb1iftlkMw+PFFp3M=;
 b=AqgfijdfoYsXhvHpEeDSOeT+iMVSose6mbh4VNQjC9FVhRjM3UACxzswsRgbxEQot6yqUAG7bssKaEO+BQWjgMMejkeJqAexbjQppEd2LfkGeI58POpcLPAve6fuWsLOuGt5dZWTMUnFTaGdacaKRwHGIwBDaH20sIucFz41dh/ttPrV+8lKySp/IswjU+lsWLzvbFK+IbdyEg0+iTTsNvD9a251ksLNT1FuwNfFtG0cZ7zH5zRvE2Xml8ATeaXEm6iNpOFIAUhEt/R7e3sNiUNy0GbM2GjYtAUpGskd7bPKtZ2lN61MKbXohnN5ZkDHUHKoe1FUi+Gj2WmtQgw2Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7sMOhEufhTs9fpc4fYFuk8ps+yb1iftlkMw+PFFp3M=;
 b=utlFGPi9dyX/KVv3pr+6NfnIZ/zoOVgAetNiTa2dzBK+uuNqEKQe5w4OrFZUE+XciKQkYx5jw08MkUWbvZgI5UMJ0ikXIAscaKyQe3GC+nbw5nMod5iNxlA2yJGX8glkrI6B3ONr9U1CdF/0Gvs/b55VjT5yPSawzWXjW0NEnfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN0PR12MB5714.namprd12.prod.outlook.com (2603:10b6:208:371::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.14; Wed, 14 Sep 2022 17:41:31 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:41:31 +0000
Message-ID: <951f2be3-9830-ad71-0140-e5bbf4b78f96@amd.com>
Date:   Wed, 14 Sep 2022 12:41:27 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU enables
 x2APIC
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-5-seanjc@google.com>
 <b6fcb487-56fc-12ea-6f67-b14b0b156ee0@amd.com> <YyGFGXsbgr6WV0B8@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <YyGFGXsbgr6WV0B8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:208:23e::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|MN0PR12MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: 99eb5bec-10a9-453c-0298-08da96785be6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3647m0OfDS2KixytSV748Qmv81CUtiri7m3hP07XiADLCW0zj5bw3e6m+opnRZXSO6dDVudToFrQTWk8YCvSZo088nfbiHR6y2y1z0qLkxLqrtwadRVvuYYsavQiVAG8Zk7e7itKiTkccomKToe8VKozE3447r6iNcqOHr8mwFNtBnbgWKaFr9evnlx4Ee430VSg2jUTfkfu18Wl0Lr0zxk7PUz37dqqVhQ6fi0zeGrYkA/caLYe05fGIwKxErVCY8h33uXgIcVivt/rVSaPAen6Bd7066NkJYQVHhlFWhDiX4YGNchGzRP88+uTcOFRx5w/hFZzdT39S4trxJEyxJf3ph4IeQpvDwF7eFbA8AvZ/WRQWTMPcjybHoV/mMHfR61HWdXiguPyzBIamSPpKrfk6J2/RL2IRhUWw0Kn/3mBc19KxSS/OBgGqOendfV7eYeMw9ro94ow5wCyEB4Wk5rGL4mLxe0QUqWSMkOiZo91Adg632I8N/tJYq4wGuvM12rSQV9QjTYKOaSn358wZqXuRLZLDw6nQK8gvIAz5h/N503rt6dxVefBWBqPGotSXKza2qd3eyJ17A49xogKKvj7aPDYwzO57DHSNCgNvX8srjiKlCOIGNIC95kBaNek1mZjFFb2U3jI5jj6lrRgp8D1iDxAC/ON/h8uLl6Xr4W/I361QlhcExhM/Q+Ox6USY6K1pAP1y0u34eSOBK4v/MQeP4aIsSjB/HiIs9nKZS/3JDLXDTIBApL/gshYVX6jDXvXTXpmstbVDy3EciVf06mPltC0RvkBqN5c2WzeTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(54906003)(31686004)(36756003)(2906002)(6486002)(38100700002)(66476007)(8936002)(5660300002)(66556008)(66946007)(8676002)(4326008)(31696002)(316002)(6916009)(86362001)(478600001)(186003)(2616005)(26005)(6512007)(83380400001)(6506007)(6666004)(53546011)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFZGSHJGbVBoTDkweDlUTkVsZDJrNjh4VlU5dHBOQy9OOUdYZGpTTjBLbTdO?=
 =?utf-8?B?V21NSkk2QWU1NStsZlJvcG9abWdZbDVMVlF3YnZOblE0Rm1XWFFVS2hqQnFE?=
 =?utf-8?B?bUFYaGJqRzV2ZGFxOVE4cHNlTC9UL1ZaT1ZoU1h2TFdPT1VqenFCamtIOXNj?=
 =?utf-8?B?emQrS2twRXJLQktXWUR2R0FnTUJJQWhCRHkwYVcrekhUYW16QUZ0b0xVRU1V?=
 =?utf-8?B?NlVWU2dBdFhJdWJML0Z1dUE3cjJWK3d1UFc0UlExemNiSDZ1SEhHSC9NN1VY?=
 =?utf-8?B?UHBIak9OcEl4NUMrZ1IyYkc0WTNJcGw1WDNrN0Y3SHVQMmpqK1hOWjIrTm1K?=
 =?utf-8?B?VDFrYkRGOTVrK3lycEJ2R2pyYm1MRVJtek1LSEV6UEUvVkZtRjFOaWcwa3cx?=
 =?utf-8?B?KzNtVGh1dmt1d1RPRzlwZS9SUmFLYUFqN2NuRTNnTGxnWmRhS2FHNUhRV1Zn?=
 =?utf-8?B?OUpkVFRwelBoa0JSenJqc0ZjaWc5WXJuQW5QOXJ0bjRFcllmdjAzWGljaEdy?=
 =?utf-8?B?Q0JrbzV5eTdnODl1WGpEcmpwNEo5VWY4WURvR1FpcWtZeHFkUWorRTVTcjRk?=
 =?utf-8?B?ZW1CTUUxVlBFSWo2amFDWHpmME9wR1VVaE1qSlFMb0RMdWJ0ZXhzU3ZEOHhI?=
 =?utf-8?B?M1pENTh5c0p3N2ZYZ0VhVkxLMUM3RGYwa1JkRUxNVWdpMTJjSXZ6YlJTSXU5?=
 =?utf-8?B?WHBIMEE3L2xXSUVadW1xSkZ6dDBmT1hoOG1iWmdOSThsVGpubDI4U1JBVWMy?=
 =?utf-8?B?YWthcys4ZjJnYUVKZ3k3YmUvc2w4NHVFWDlsUjVUcXpFL1V0dFFKY0dlSkdq?=
 =?utf-8?B?ay9IWXRqOEo4RGhLVGpHQUc1U240anRLUHFpSkJFZ2lSOGpTS1Z6ZmRBTlhs?=
 =?utf-8?B?aklkK3lTVC9jU09IbTc0aVRqOVB2QUltL0syYU1ONGRvV1ZKaFZVNnlLNFQx?=
 =?utf-8?B?T3l6aEZNdGpJeFVGK1pFM2g4VzNjMG80ak90Z3lmdG1xOEd6a1ZNVlRMV2I4?=
 =?utf-8?B?d3A2cXdCSU9jNDZzVzdROTJNbEdMY2tWK1oyQ2VVTmllajZURVhrMyt1Lzc3?=
 =?utf-8?B?eDN2WjNmblhtcmJFeE9WTkZJa3NWRU1sdkE3ZUdHUkRPQmhScFEvbkpkdG1Y?=
 =?utf-8?B?Q2ozNmRtQ1dPR2ZMVWN6V3VncHJoT2YrSHVvZVBjczJZVFBSVFkwL2x0YlNZ?=
 =?utf-8?B?eVZ5Q2NyODhkYnNlR0tOZUs3cm0zekY0Q0xnS2gwZ1BFYTg0ZlBzWjJNbVA5?=
 =?utf-8?B?eit6WlN0STdLSEdDeXZJck9LRStEK1RqcXJ6dFNNYVJjNkRScEtaT0dHN0h4?=
 =?utf-8?B?U1VyRzNuMk5IVTFEaHIraXIxZWZiQnl0N05QZm1URzJEUDJoM0tEZkxna0Yy?=
 =?utf-8?B?WjRMKzhnYW9WS3c2UThyRmVsaXl0YVBiRkNOZjV6VXluRWZmWmJzNEFYVVl1?=
 =?utf-8?B?cnZ4Rll0WGZDWmpZTkl6STdmMjJzTExTZkc4V2pENGFyUm1NK09qd252RGNV?=
 =?utf-8?B?UERxWVVnaTBSeXFqRnJHSG50a1ZrVk9jb1huOUQvYlJvM2lPWmt3UDhGYTRX?=
 =?utf-8?B?a0xSWjZ4MVh3SEdOTUpPcVF0eGp3ZEpQZGM0ZkxLb0p2d2VBOUx3Um5ycEFR?=
 =?utf-8?B?U2JiN1NHa1hKK1BkWnAvL1pRcUs3YThFNWJEODVoMDg1T1BGdjN5ZmFYZ0xk?=
 =?utf-8?B?U01JeDNZM2xiOXYyMWZDSWZpcGNybGgxTHU5djJxcGhrUHVZTzZRV2Vpb0w5?=
 =?utf-8?B?Y25RY2R3bDJFVmsvTVRGb2Zpd0FaeDFPUFpxV3luMGQ4ZlJlZ1RaTXQzMFVO?=
 =?utf-8?B?Y2ZDTHdsQkpMNU5TeGFZSFQxcHVIWVBaQkVlMTJMeERvaUZXeXJpN3NsN2Yz?=
 =?utf-8?B?T3dlVTZqWlc3dGU3WU9WNVZqTkxFeWRLMFlCWmpvLy9TWlhBeXlYeXZCb1Rw?=
 =?utf-8?B?eFNuWTI4M3hzaWsvYmlKaXVZU0ZlVzEwQUVNcUh4dHpKbHdOVThiTmlVN2pF?=
 =?utf-8?B?cW00TFBXVHJodk9QeUlwQXVFbnBaYlF4S3dXalljTFJqQ0JpdWtRbytqMDV2?=
 =?utf-8?B?YnpGcnhZeFFCQWlzeG5OaFdQdnJlREhtSzlCOEdlVEw2L0piOWRYWm94N1ZE?=
 =?utf-8?Q?3cosN9iw1TWwsMNuuncTWwAtX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99eb5bec-10a9-453c-0298-08da96785be6
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 17:41:31.0120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OBY29WgaFxqqUyF6BRG+oLu97eXm0/xFK0kAVHhhQDHOzO6knzNwDAuWHapSAe+47cqhhLlpeWI+uFJi/JpJIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5714
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean

On 9/14/2022 2:39 AM, Sean Christopherson wrote:
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index 38e9b8e5278c..d956cd37908e 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -2394,8 +2394,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>>>    		}
>>>    	}
>>> -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
>>> +	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
>>>    		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
>>> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
>>> +	}
>> .... Here, since we do not want to inhibit APICV/AVIC on system that can
>> support x2AVIC, this should be set in the vendor-specific call-back
>> function, where appropriate checks can be made.
> No, again the intent is to inhibit only the MMIO page.  The x2APIC inhibit is
> ignored when determining whether or not APICv is inhibited, but is included when
> checking if the memslot is inhibited.
> 
> bool kvm_apicv_memslot_activated(struct kvm *kvm)
> {
> 	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
> }
> 
> static unsigned long kvm_apicv_get_inhibit_reasons(struct kvm *kvm)
> {
> 	/*
> 	 * x2APIC only needs to "inhibit" the MMIO region, all other aspects of
> 	 * APICv can continue to be utilized.
> 	 */
> 	return READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~APICV_INHIBIT_REASON_X2APIC;

Also, this should be:

return READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~(1UL << 
APICV_INHIBIT_REASON_X2APIC);

Suravee
