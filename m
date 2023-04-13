Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72816E0B99
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjDMKme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 06:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjDMKmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 06:42:17 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2078.outbound.protection.outlook.com [40.107.100.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3AE44B9
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 03:41:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0beGAR2XmXQkRofWud5hpIENvCX7Yzs6r2LEVmVPLJd6EFn6LneJcUYjPoHeiQCerzglNjdLejOEkcqhN6Co/QN/UFjP4ioyMp7j+x4Um/P0XxCHjVf7C7Z4tWhJ5HvtDh29RtdQ6FGDSFSbm0zJge5PXXDTHUp3zS+Dtm1pX1Wvjmyj2U6z2nGvWqG1RcMDPoQextQjkaUJFWnaDEx8+GADzNsM8K4yI9W7feHXqZRMESlIlrWnghL2UCsPN1Zoe5ad5IXIsjpU4vIniVbaoFw46Bz6yeCXTTcQe3IX+gn6N/2T+wK2VT9fX45TFuqV9M7qkPNkOqxlOD1D7u07w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax42REMgIkOVFRFQpgkkergkbKUinOfmetEVWQg7pjE=;
 b=V8y4kE1hMEnjQVNMVa7BL2pbtAOO2hHrCyS8iaWNp5IIgzUG0RzOT+EmaYJKriZaxYlYpOBjjtchjrpsL18FKPrVFwdn+jfApIFlB4fZsy6UsnsaUVIBgVDisrzSSa2iAVWSoTqg8mBoqlfM7rvhvy2A20LF9sLcgS8DCVR08+3I1PmmZ+jca+BoVKn1++mmJ6kwuYjBu4bDoUm/6rPR9NzptDTZn+s5xcQui4kX4wyl9tILjSvnGtbPQo/3DOx9EagG2sHoDcFnZeWDIgxdPpks7R9NbI5HGcCe3ag+fKAga14oGA4XeT2s1uE7U6UcV6tEmD9IL5dEc8Liul97Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax42REMgIkOVFRFQpgkkergkbKUinOfmetEVWQg7pjE=;
 b=jin/hSywvdEmAuyO/d8jdiuAfZiKQ3Tdw9WR0OeQnNDEd5SaMZjEPFytUkMNhlH9WXNPJ5O2ABIXbaNvVfBzm2qYmq/FCop2e4PR/xl2N+a0ss7EO0e1lLfq4VfyHXkPbYiKrYo6jjUMHSBfmQ9TIk0cGgoE5dslV7QGE/WwOgY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Thu, 13 Apr 2023 10:41:45 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::e959:436c:d41f:f9cd]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::e959:436c:d41f:f9cd%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 10:41:45 +0000
Message-ID: <8ab48beb-2ec7-9b76-5511-b48e87580826@amd.com>
Date:   Thu, 13 Apr 2023 17:41:35 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/2] iommu/amd: Handle GALog overflows
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-3-joao.m.martins@oracle.com>
 <b5d1b9c3-7c7b-861f-a538-f87485e60916@amd.com>
 <0677881c-f801-075c-7af5-efa7471c6e4e@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <0677881c-f801-075c-7af5-efa7471c6e4e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:3:18::18) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM8PR12MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dc9afc7-82ee-4b8a-ddaa-08db3c0bad44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SY97sFhW9QwDm+RMcIvKox2U0nJR2P1ZSkl1IfAABP8W+e4+TLTrBuem41aF7dgtJe2Bmtc0QBLS9x6xN6n43iDVQMOx+TWJMHSRZFKPx8YiuiLLy+TEOnmD1qMwKYe8Q8aIkbiG3QHQpKiz4sxLssWbbZ9vRtq7oExbe6l2xbC99pyaFFA9OWAEWbw4TPxeC3q6PhBMWqdT8BIgl+ILEnBgCCQTTOkP4ZMXyuhIB/abQrvCdd+ukDzu+ZUgxwopjkajVJ7dWKR2M550gisbtYTJt1yibrzvuodVJVwYfusxBIm1uozdC7uvAX3kWK58/r8sLku3zkPMU3V8pbq/6VWRsA4C0i3uoTK74sFAFmQNLjRVMHd4c3F5TDAfYAIsPj70OrBOvdFA2Bo311hI7d3K9lqngErWI77OxfjTytXFXqRYe+NhVLg98/LVCKWDzsH1tWjB/sPgxf2Oc6VIanTYa4chaswem+/Ydp22VHzBEf4wvdUY/6wQxofrApMtrMrx33S77qAGQ5IIec7Gj4NzV29kWf/F/GFI4w2iPN1ppUhdzcrTeKFCcwy6mkXZEgAc9MVXjexNAPs5x9K/2Tr6V7HeYwy12BsBQabe+uoc99TR73zTgVIY60szkC/EOkSz4SpbL1t4oJJnTudi4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(2906002)(31686004)(8676002)(8936002)(5660300002)(478600001)(6666004)(41300700001)(316002)(66946007)(36756003)(66476007)(83380400001)(66556008)(54906003)(4326008)(186003)(6916009)(31696002)(6486002)(38100700002)(86362001)(26005)(6506007)(53546011)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGxEL2RuUC9laXFmelUxN1hNSVB5SzBsTWhYK0ZnTmY0dytsem9XKzZKS0xP?=
 =?utf-8?B?VFZKV2NBZUZxNFExMnlXT3l4clpqSkc2VDJ0Q1NSWnpUWDZJYmJTRWtZRTBV?=
 =?utf-8?B?MG5La0NyR2xpbk1IVVJFVzZleXJkR0dFVlRZMldiS3FGUndRazFPaFdpTExL?=
 =?utf-8?B?LzU4WkUxanYxUUdmZm5KS0lFWndkcFh4bDZwNUlvczcrd2ozOGZVd2lOVTFW?=
 =?utf-8?B?aC9PSkdKS29sODh4MU1FelJvNzhrVC8vbVlpUmplaXAwM3lZZktYZWJDRWkr?=
 =?utf-8?B?WnUwZUtkQ2JPcWxCWVJ2bEtRRXlGenVpOUNFSW1GTVY0RmRxRVZ5TG9rTjYy?=
 =?utf-8?B?Tnk3VUw5UG5CeHBiVVVpQ3ZncUdJdHFqV2I4SzVCa29ISm1yWDRSdVd0QWxr?=
 =?utf-8?B?RHVOMG1pTlQxSmxEOWt3Q3FTV0lCeVRIa1dyYm43TW13RkwzV2hiU0ptekNB?=
 =?utf-8?B?RnY1UmUwRUg1UVdvUU9Tb1ZnazB1UEoydjdPd1g5R2FtejNQcnlpbnBUWGFO?=
 =?utf-8?B?aEFUbm5EM2pYNmVFSEJENmF1T2tqSEpNL3BHK1dtelN3d3NXWFppK3kxQkVR?=
 =?utf-8?B?ODkzOWpwa1FrdG1TV0RGd3Bmc09tcHo1eFM5eDVNV2VoWnQ0ZURTckNCbXJ0?=
 =?utf-8?B?SW13a3R4RGlSeHhPZHBKT2lmdDFRTG8xNHkzNHNtanRqeDNydlp0Sm1nNGNu?=
 =?utf-8?B?a2lNVGZJeDgrM2pzeUltL3pNOCsweW4zSkxMZTZsWmFTcFFlemp4ZzkxOEIy?=
 =?utf-8?B?Ry9iWC9CY29KbzY5enhpRTFBdmZOQjRTOWh6Q3ROQndmVTY4bGdUYzVrZE9E?=
 =?utf-8?B?aWFKcjdGS2x2dmZieVVEMytFSTFBeWxsQlVrYk82aCsvSjdWT2VnOGdCYTh4?=
 =?utf-8?B?ajdwWGxVeUNYdHBRa3Vsd1hzc2JoZXg4RzBxMmtoazVFV3pNcmNKNUJvcENk?=
 =?utf-8?B?UW1xZDlhVVY1U3ZIM1ZCNkhoZGNGQXJuVFdzL0cwdVArT2lJZHZ6OUhmOGtO?=
 =?utf-8?B?LzIyNjA3UDUzbXlKTk9PMm5uOHpZSDlvUVY4ZjVIQ1BheFFhL3BxNUpheWJP?=
 =?utf-8?B?ajN2RktQMkNwakExaHpweUFsVTdBV0J0dy9ocDNFQ2lmakZxNVFvRVdNQ0pK?=
 =?utf-8?B?a1lSTktoRUpsUjl0UncwWk1ZTHVrWW44U1FtY1NpUkJ0TkVLcENEMm1zUGdm?=
 =?utf-8?B?YnVPak9LbWRVcEduL1hhWTd1TnV2b0ZReUFrSUhKUm00dWQ2NlZkdkVSTlhH?=
 =?utf-8?B?ZUxZOWxISFNLRWpBRVNIZUNOMEU0MUJWYlZFeHZzSkVZOU14ZUZrb2ZvMVBV?=
 =?utf-8?B?RG95a1FyNVdkcWpnMGlOL0pnVGRqUHcvSEpWR2J6bU9vOGZjbXZyUW1CSmVM?=
 =?utf-8?B?cUNITzJmWjJOcHFGUVBGOWV4eU9SQlpCRkp3bDdJendQVmNscE4yNUVkY3U3?=
 =?utf-8?B?OWxhVVpDbWh0Sjl3Wi9FdVJXdTAxUHJhS0Z4RHdDd3JMRmw1ZlFNcmErRXRU?=
 =?utf-8?B?ZytTSnFsTUxIeXZDN05YTGI2dlZIckJUdFhiMEVSc25pbjBoQ0JqU2I1MVZt?=
 =?utf-8?B?aUVVMjVlZHVwNEFoNHgxUVFtdTZwczVTU00xZUplSGdYMmtxems4RnBHRGhh?=
 =?utf-8?B?RldrVVk2bmViUjJpU0NPOHNKYks1cEIyeWJadjFyVDFWelBoSlNoUG9xWWs1?=
 =?utf-8?B?NE5wa1FtT3JESnlLNUdLcVNJM2hvd0JlS3RJN0M3U0Z2dzRoT29TSGw4all3?=
 =?utf-8?B?Ym1FN2N0NjJuR1hzQ1psYzA3OFdmVk9yYmx2Nm43elpqUXpHRW1yMHZlL1B2?=
 =?utf-8?B?Y3RTRUd4bUFCbkFsTDE2TDJQaFF1YzA5RkJKUjAvV0dJdzB2eXhLTm5USEhH?=
 =?utf-8?B?eTlVdmhIOTRYQXg3OGI3KzBmOWpKNDk5VHFQZytQQ2FmSldJSWNNTHk1Y3o5?=
 =?utf-8?B?eENnNFlLbEl3dm4zV0tqeUJFM2ZGbnQ4Rk1tZnN2TmFzdUhhR0xqYjBSdkZU?=
 =?utf-8?B?ZWt4MHZmM25iejZlWHlZQTRRMHMzVnhLM1owVFpOcVplVTB2SUZvMmZhcWsy?=
 =?utf-8?B?aHJvam90TVB1UWtDN0h3QUZTVTZjdWlKUHdLMW9BcllJMDZQWVB5T0ptcENK?=
 =?utf-8?Q?WcSglUTe0NDuXsML8+P/vdbe+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc9afc7-82ee-4b8a-ddaa-08db3c0bad44
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:41:45.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYlr34cxSzZYTv6u0LXUmvWxJVIVxm/wTWQ0WvRHgOc1LeXGfFUH0FzYxnUKNaIdvYnD6tItSqH9PPQCRvzT3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/13/2023 5:30 PM, Joao Martins wrote:
> On 13/04/2023 11:24, Suthikulpanit, Suravee wrote:
>> On 3/17/2023 3:02 AM, Joao Martins wrote:
>>> GALog exists to propagate interrupts into all vCPUs in the system when
>>> interrupts are marked as non running (e.g. when vCPUs aren't running). A
>>> GALog overflow happens when there's in no space in the log to record the
>>> GATag of the interrupt. So when the GALOverflow condition happens, the
>>> GALog queue is processed and the GALog is restarted, as the IOMMU
>>> manual indicates in section "2.7.4 Guest Virtual APIC Log Restart
>>> Procedure":
>>>
>>> | * Wait until MMIO Offset 2020h[GALogRun]=0b so that all request
>>> |   entries are completed as circumstances allow. GALogRun must be 0b to
>>> |   modify the guest virtual APIC log registers safely.
>>> | * Write MMIO Offset 0018h[GALogEn]=0b.
>>> | * As necessary, change the following values (e.g., to relocate or
>>> | resize the guest virtual APIC event log):
>>> |   - the Guest Virtual APIC Log Base Address Register
>>> |      [MMIO Offset 00E0h],
>>> |   - the Guest Virtual APIC Log Head Pointer Register
>>> |      [MMIO Offset 2040h][GALogHead], and
>>> |   - the Guest Virtual APIC Log Tail Pointer Register
>>> |      [MMIO Offset 2048h][GALogTail].
>>> | * Write MMIO Offset 2020h[GALOverflow] = 1b to clear the bit (W1C).
>>> | * Write MMIO Offset 0018h[GALogEn] = 1b, and either set
>>> |   MMIO Offset 0018h[GAIntEn] to enable the GA log interrupt or clear
>>> |   the bit to disable it.
>>>
>>> Failing to handle the GALog overflow means that none of the VFs (in any
>>> guest) will work with IOMMU AVIC forcing the user to power cycle the
>>> host. When handling the event it resumes the GALog without resizing
>>> much like how it is done in the event handler overflow. The
>>> [MMIO Offset 2020h][GALOverflow] bit might be set in status register
>>> without the [MMIO Offset 2020h][GAInt] bit, so when deciding to poll
>>> for GA events (to clear space in the galog), also check the overflow
>>> bit.
>>>
>>> [suravee: Check for GAOverflow without GAInt, toggle CONTROL_GAINT_EN]
>> According to the AMD IOMMU spec,
>>
>> * The GAInt is set when the virtual interrupt request is written to the GALog
>> and the IOMMU hardware generates an interrupt when GAInt changes from 0 to 1.
>>
>> * The GAOverflow bit is set when a new guest virtual APIC event is to be written
>> to the GALog and there is no usable entry in the GALog, causing the new event
>> information to be discarded. No interrupt is generated when GALOverflow is
>> changed from 0b to 1b.
>>
>> So, whenever the IOMMU driver detects GALogOverflow, it should also ensure to
>> process any existing entries in the GALog.
>>
> ... And I am doing all that aren't I?

Correct. I am just following up to clarify details on the GAOverflow and 
GAInt.


> Or do you want me edit the commit message to quote these two bullet points from
> the IOMMU manual?

No need since this is already documented in the spec.

Thanks,
Suravee
