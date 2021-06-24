Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DDB3B34EF
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 19:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFXRmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 13:42:02 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:24993
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231407AbhFXRmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 13:42:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMdhs/9fSS5B/WlrLB9iUlFaoanLApE+ZiP73lMFxSbh7bVHiWLmAqGmZ7oaFsNskJ34u8u1Ha3lQ9ZJ/MsmaJsqWEShPHPFi4SOOx9sXebobqR+ZwyRoaU4NRcKuVJ2lupmqmEneTQ2aJ9KijKNMN+c6NZTier7tBXkzaex9mjD+IvLYpOBhVdgsIeZLeMJTPHtprGbP/oBccRhG3Qx8enqP/S5jU5KjZV6T4e4PmpolDvEH/gAGV8tORxSHdNO+XBbCZdhug/KVyFVSYTyc4QTW9JEVRBTP0H4rc2Xv/j+OGp/KBSzRyeptrPeVVwIr82+hptL5Mc1/cXzSyPVGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6C2E6cIobECMMa+SFfc8pwfpzI1x7JgaXG4aAt7mwpA=;
 b=bNJ+QQIKs44XtoWzfw5pATC3Ajbhts/ES60L1QMb3zkDLou1qxwdK/Lq+hwcE6cPjmwVKMkrko254F849iRobCQADOlHKRl2T779JVIeqRizq/Pu2lRmG/DOpiAOdbYk6qMRbpCs2HW8QE0zQHKEf2GBUTYoDAaRZ52yNLo6S/sBAutD8Zvm/y8Dyj4xPXEJ/jAa7nDaVmXnz7O4VEdcRdQDfU3emH0W0OtTZ8YZOlIwkywIrO0Y44facIGfU9H9CL6as1i1CAdweHgCySdAutva/RcK2ndxBCw2Xy1KhNWDWSgK/4Ec7HWi7H9gRnnKD9ea0GoMtVp3PZxdKV+jGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6C2E6cIobECMMa+SFfc8pwfpzI1x7JgaXG4aAt7mwpA=;
 b=O1BolS2dMH0wYDlYqUUY0uvqNnUmf+3Vo4rjZZVvuQvLBxCElAQMeEtcKCMdJrW8/PQ53LD7yPxNLUvDIcrkgGwdDzdnveN04XSL4JvPpJBdTTMrrkWNLTBKxc8dn7kXTCJ61qs5VeBkUwnId52swQz3ggMX4hHpPCPc9+LvFjI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB4679.namprd12.prod.outlook.com (2603:10b6:4:a2::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.22; Thu, 24 Jun 2021 17:39:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 17:39:40 +0000
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210623230552.4027702-1-seanjc@google.com>
 <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
 <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com> <YNTBdvWxwyx3T+Cs@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2b79e962-b7de-4617-000d-f85890b7ea2c@amd.com>
Date:   Thu, 24 Jun 2021 12:39:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YNTBdvWxwyx3T+Cs@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR2101CA0012.namprd21.prod.outlook.com
 (2603:10b6:805:106::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN6PR2101CA0012.namprd21.prod.outlook.com (2603:10b6:805:106::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.7 via Frontend Transport; Thu, 24 Jun 2021 17:39:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5163de24-ac8f-4fd0-7eeb-08d937370b61
X-MS-TrafficTypeDiagnostic: DM5PR12MB4679:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB4679E774936548AC83CB3012EC079@DM5PR12MB4679.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H4lGFc+8OFf5JeFtTXV8+LhEBDsvghLH9yVKV64v0S0EITCD3Dg0TDqUw6MIhTXfLvIuKU9vfZy3Sm2SEeSMuTfAblq89b9BfD5BmptDgchIyyG4GI3rY1lF8hyrV8Y0RKyTiy+Wbg7QHUN3Yw3mETIpHxtAZTBVGS6U60I0NBZk6vz/etRD/ZkC10f8UgmCfrS3isxJOKtLCfdJ3cR70Y25/gNUxZU0Rpub/Oc/vPoyxJKVZwDpjI+g4ViSQsktlms29ZojcTbT3l0/o7/jLHuHh/hPKA/sg7WiL1LFaaMLqyKdOP5EbcK0uCuPdK3AZ925Zc1Fx5sPtiW6VEGIqdS55Jk38rO2+qkWotHkSnXXhhEjT5bxXTLdmpvcofAkquHTwlvcBSMd1z1NpUShqocr3tdoDztkOi7B6oTBPxqWD6KoLxwhkAAlz4MlG/QLOJEjeqqD2C56IEvQ0hkBFVs1mfacTFR4ZRXq7h8yyEV4yF2IGa1eVTgD6AE2hyq+TUgHRl2RgJywYQRq8QuHLkchGCS1A120iKoELrxewotkLqwh31vpTq/bCxtTo5q9TpiLF4kidaxAyAvn3afHsmnCdUT2lPq/2oV2VJCD4ZrgUyUhZPyXlPZA2n+a6AWCNclbZe+LwomXdV0LLKD+lNmnLVki4Lpd0+wc4mnMmGqAdf175ILHl1FD6MtDHeGO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(36756003)(5660300002)(956004)(26005)(6486002)(16526019)(478600001)(8936002)(2616005)(6916009)(8676002)(31696002)(31686004)(186003)(2906002)(86362001)(66946007)(53546011)(6506007)(38100700002)(54906003)(316002)(66556008)(4326008)(66476007)(83380400001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emsxQUc2S2N4RnJsVE91c2JLMmNKcXp1UENaYk1rTlhPNmJjV1MvRk4yVHlS?=
 =?utf-8?B?UG9lWmJHb0ZLbStCRk9SeUNCNXBCQVlFNVZmYzB6bTdFQit1Z0xXcllsaDRk?=
 =?utf-8?B?MUw4Q3BmZm0wNno5REp0dERyc042NFF5WXU4Z25SNXBaZHVGMFVOano0SC9w?=
 =?utf-8?B?RUlnaFU2d1d2bXUwSlRVRDMwOGRGdXB5YkRhMXd6bzVqd0VyL1BzMm4xYnhV?=
 =?utf-8?B?YzBZWDNpdmxSYkhHT045dkJ6TEcvcUVLV0pXQzhMTCtQbkllWGNyOTU0aTVL?=
 =?utf-8?B?SXFFaFJ2OHcrTDRhc3IzbUZkeXg4Wmk0djh5alFDZVNVeTRDK2gzWWxkSTZa?=
 =?utf-8?B?dGVNVkd5Z2YzcWNMMEsrcURxSmxNTG5UZ083OExXWTNnY2xDT1B1VEw1RkVj?=
 =?utf-8?B?MytWOHZ0S0tpNlpvYXlsam55MDIwa3pvUDZQK0dkTjVrenc2WGliL2lBRzEr?=
 =?utf-8?B?T05hVXlYZ2hLQzJSZFEvaDNVbWpnNWY3dk56Ti80TUNKV0VWN3FxeDhOYmJh?=
 =?utf-8?B?TlhrUldxRVBmelNNdkcwWEl5WkxFVEQ5MGRveUUwOGlNSVlZbzFYWGVDUkdq?=
 =?utf-8?B?YmExbXdTa01LYU15bmthdkRNcTNkNHlseTRvYUQ1Mk1hQklLU0tPeVRXdThj?=
 =?utf-8?B?MUNwMkloRUVxd1lBTTFlVVA4WGRxN1JHQU05QkMzR2tReWcrSG56WnI3YXBF?=
 =?utf-8?B?djFaQ1EyeldTS1BTSXhMMkFrU2k4NktLc0N6MEFpRzlFM3JzNWNpSkJHOXVH?=
 =?utf-8?B?QVJRbDNKZEFqSlQ5VkZVekxMT2Z5Vm9JVVhHelhNYmFGQ3JXa1Fubk9JQk9n?=
 =?utf-8?B?RU5mMHhkamNCVTBybU5zSG5UcXdqY3BmSE5Ld2RDQTR4K3JublFKVXorVGZX?=
 =?utf-8?B?R3Y3M2FtanJzY0dPU2srcGQ5VGxUMHBtWDJCR1pPWHBFY1dFVFQwZkNOUEQ3?=
 =?utf-8?B?MUl6Y1FmbmhtRVY2b092dDZhSllBaGJKUkw1Smkwc3B4QkJtS1d1NWNOazI0?=
 =?utf-8?B?RnlPODgxWExvZFRFVGgwbkphRGdhQ2EvNWpTbTdEZCtzeDlzdno2elFMZm1D?=
 =?utf-8?B?U3l1L3NZNHBldjVNMHc3MzBGWGwvMEdwNDdpVG82ak5Uc1Bkanp6bURlNUpq?=
 =?utf-8?B?T3Y0MnN2ZnVTVHhNQnk3cDhvamhlek9KdXNpTXJmSFRBdW5TelJEOEk5RUFr?=
 =?utf-8?B?ejkwQnowRUdYaHkwNHRuK0dYbU9yRE9TTGdQWThVTjB0dDdhdFJVMnJ5NDZu?=
 =?utf-8?B?TFMrNitSOEU1blVhcTY3ZTRFbWRqTGlWeXJhQ3ZjcjJOR2tqYzk0a2p6Nmpl?=
 =?utf-8?B?OERtVnpJQXBETkFYMEFkYm9ab20yVU0zQllXcmJkQnlGNGdnWUNET0hZNmF2?=
 =?utf-8?B?cldHQnBzVy9JSTl3M3RSVE9ZUGFNZzN5QTdoTGVVZ1RoMTNtaVdZNFZtSlh2?=
 =?utf-8?B?NkxxVTFLRS9aQXErSFAxN3dWY3FiUjZZcXRnSCtrY3hJUFVXdHlwZkYyalZW?=
 =?utf-8?B?WGhWbStiYlNqa2lSeFdudS9VT3pGRVNmbVVMcjNjREhoRUxTdVNqS1lSYTM4?=
 =?utf-8?B?cWVwZmlQSEc5VTlYNk15alRyZjlpTHRXWndEUVV6WCtHM3BSdG5XWW16dytu?=
 =?utf-8?B?QUxXYmgwcVZiTmRSdk5xTjhVQzhIVTQ0aWo4M0ZvcSt6QW9CQ1hCa01TR0w2?=
 =?utf-8?B?bmNSVDA3dU9RNEVBSlcwRCt3bDBJS3ozcVREZTNOUVZjZjZ0ZEptUnFEbDdy?=
 =?utf-8?Q?OQ11jveXYY7Mm8Aq8CEL7sm2hHElNE6XPMMA+GD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5163de24-ac8f-4fd0-7eeb-08d937370b61
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 17:39:40.5142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5V4t+Dfl++yzHl4DwPWM2+SkLWzqoRwY5uFkLKaQQ4/Jog4dDO4CeD7VNNmJ7aujLcvvt19JZOirE+/n6n/MKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4679
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/21 12:31 PM, Sean Christopherson wrote:
> On Thu, Jun 24, 2021, Tom Lendacky wrote:
>>>
>>> Here's an explanation of the physical address reduction for bare-metal and
>>> guest.
>>>
>>> With MSR 0xC001_0010[SMEE] = 0:
>>>   No reduction in host or guest max physical address.
>>>
>>> With MSR 0xC001_0010[SMEE] = 1:
>>> - Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
>>>   regardless of whether SME is enabled in the host or not. So, for example
>>>   on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
>>> - There is no reduction in physical address in a legacy guest (non-SEV
>>>   guest), so the guest can use a 48-bit physical address
> 
> So the behavior I'm seeing is either a CPU bug or user error.  Can you verify
> the unexpected #PF behavior to make sure I'm not doing something stupid?

Yeah, I saw that in patch #3. Let me see what I can find out. I could just
be wrong on that myself - it wouldn't be the first time.

Thanks,
Tom

> 
> Thanks!
> 
>>> - There is a reduction of only the encryption bit in an SEV guest, so
>>>   the guest can use up to a 47-bit physical address. This is why the
>>>   Qemu command line sev-guest option uses a value of 1 for the
>>>   "reduced-phys-bits" parameter.
>>>
>>
>> The guest statements all assume that NPT is enabled.
>>
>> Thanks,
>> Tom
