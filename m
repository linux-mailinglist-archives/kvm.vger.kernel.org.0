Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0CE6E0B5C
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 12:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjDMKYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 06:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjDMKYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 06:24:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF17C1BD9
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 03:24:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5TSMjSPzFJw+Z+HDo4Vn1VLT4Kp2MsoslI/x+emLwjezERVdQ410dqzXZKW0T2jsTKVYM/mwzybCkq29FigsNvO316S8yCjN/sB78uRma9+B8T0czT9yMS4IDw75PMxz+ioL9eAncMRju/HU8a1Eo8ai2Y1B+zGMgEC7ZtBhQb2uVZO1AN/+znukMxkbA+osx2mlWsv1WN956+ekK6gUEBRLG8KRK+DPJbJ8r5QZv+9eRn32CotQiSN0R68dNDiqtAyD3/NUb7zpPgc/wpt8cII3j7/ZNsPLlPubNkNZ6Xo9WhwcjmBgacKdpvLzVzVibXTWC2RhSgZRrV5ilfkoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKTEUASCH/XNnsQlYHwd+QA1e8k/v6OArgTZdY+9zS8=;
 b=Wz+ss0E8zuD0vr15cDHW+65MtTynrTMN6TCL28uZyS3vvx0QTiVUmPBwTtf02CoaAN5zhNC3mb04BO243dvh9cLv851iNemVjdPueuSfu98HkCDprspt6Golzfyfbof/+WND4fDQmrl9ksCK3y3ScpA3hxnZyMLMZ74ZKRpKJejJXXg31tTzsDcCyiwL7z8O+EkOzAdInoGNM/Rx4Mk/3QbpRs+9MGh9y+8SneQe8XBALr3ixoVCzOcWO7/2l51t32iO1Q9EpqdsG4+QuLnc4cVLQ8mD0+N2RJ+Uwa0XXjgIEyz+unRztwIAf0CW3o7B3D+r3v4cc386GnmTYnHKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKTEUASCH/XNnsQlYHwd+QA1e8k/v6OArgTZdY+9zS8=;
 b=jCZRYQg2ELd+NG2itsplbC2rcWuiHthAWHeQgytfrg0GvMFDpuZUDI/zqhbaUv99JBtMmFCdz36pqCaRFpSBxCUR2I+Y0tK6b7KmqHxrI+btTCcCjYSADiyFEgNSe8Rlg8z8g4g3/m8T/zwawgiE/ETcyyZf837uF4YRCXRXt+k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB6040.namprd12.prod.outlook.com (2603:10b6:8:af::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Thu, 13 Apr 2023 10:24:31 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::e959:436c:d41f:f9cd]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::e959:436c:d41f:f9cd%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 10:24:31 +0000
Message-ID: <b5d1b9c3-7c7b-861f-a538-f87485e60916@amd.com>
Date:   Thu, 13 Apr 2023 17:24:21 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/2] iommu/amd: Handle GALog overflows
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-3-joao.m.martins@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230316200219.42673-3-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0134.apcprd02.prod.outlook.com
 (2603:1096:4:188::14) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM4PR12MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: de29e8e1-47d8-41f2-d1f4-08db3c0944eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tos1tf0N5jtgCjU3JyRMZkzDZromIB9ynxOXnqQZX8wGWjj6Z6+c5meRbrs58z9Rk9tNN2/bo2vgR/TsnsRx60mycfV7JdTJKrZJIvs8ISDqtBVZr2RVeYIQAT6qWdSo2WB7gfdH0xK7zHUTo+PnnsxBOp9t9epRUcZjqEvCQ48Xm/dl4/SCsRjCJlmJAXxRhMLvV2uqooMjRJrICH1e9HwMsDgBll4Bg7GsEHQ8d58s4+h1vW5voj9xM2wIl2/atNmvslz5Vr/qJMMvzVWJMYsOlCSvLNc9qnpWtVpXRWo0DMFm6Pk3QsCm5mdPnIXYzkC5JwEEFkMpdF8sCfrsO7RTC5q84dEjAGuDnC59eR6hfBYmgj3IQpem6rlXHQxzA2+4kKSwuPR8RHgAFa4i+dgmJL4UhtcgvpPlFHXj2yp5rcU+sGvvt/qXgLZl02fmE1OmluhXsfX6U2NXiiWnEG0thO3ghdbIuSr6AO7zu9Kq4L8QhQRUK5oEHOBk+4g1kN1k1SwXJiRvNbb0VHmwHS1CVWesK8IIcsU9F/tVQXmNwApENHGuCVnyGvnjZ7CTdO2ZLMFfsN5IJ6b8zelHvxDM0+EmyYkAhqAgm5TX90cOZq0H5ij5p9iUuwkT3SI/WL/tcLhd+b0jqzXLmr0BAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(36756003)(478600001)(54906003)(6486002)(6666004)(41300700001)(8676002)(8936002)(38100700002)(66476007)(66556008)(66946007)(316002)(4326008)(83380400001)(2616005)(31686004)(53546011)(6512007)(186003)(6506007)(26005)(31696002)(86362001)(5660300002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmlUK1MxamFGTXVhc0ZpYnlXdGRJNjZyOU5pQnR4YXoyVWdPeUR1ZU0zUitE?=
 =?utf-8?B?WG5mdGt6c2s4WTI4MjVlRUcyY0syMCtISG1ZSXVCNEtVSEpoTFhpc0ZOS3pm?=
 =?utf-8?B?QktQci9yUWdTTXF5aW1JNkNFVUhSTGt5ZU1IS2ZheFlkRVZaTUk0blZQQ2V0?=
 =?utf-8?B?WnlBUFFxVHhvb0M4TTNjbG9kVGhnWkI2YnUyY2RNbWFWRmZXS1BCUms1RkFH?=
 =?utf-8?B?Z3ZkSks3SzlVSnMzaWJ1UWM3aUl2K0JYeU9QSmd0UXR6Q01xY2diSU1Jak5p?=
 =?utf-8?B?NVB4cStJa0lCb1g5ZjNVWG9UWW11dDVZSy9rK09wclAvOHBtdUJRM1F5NEEy?=
 =?utf-8?B?aS9GUXk1bkw4bGl4SnhqUDFKSTZVQzdWNTlVWGsxT0xLWDJLVDNUeDUyTGNR?=
 =?utf-8?B?b09sZFpKQlFjVTZpTGhIczgyeHllUmk1VVJnSWJDNitNNHdTUVJWdVpUelpk?=
 =?utf-8?B?bEdEb0FyNnpqc01LNEFnQTNZZG9VaitQUzVMRXdXZ3lycDFNM2k0MU5lM2dQ?=
 =?utf-8?B?R01MRjJQdGZMNUF4QXY1Y2cxT055V25yOGJNREFhdkNjRGxqQ1hCekcxZzBF?=
 =?utf-8?B?U3hDdGlYMGprWENBc3J6TzBHcHFPTXpTQ3FrNjBjMjA2WFZUUzBtTGtpRUF6?=
 =?utf-8?B?SGw4Q1lDWWE1NTNmZUs2Lytabi9pQjNITlFrQkdZa1ZoUUE5MWhybURuWm5N?=
 =?utf-8?B?OGs4WXo4UUtieVgrb041TjdZeHBEdzZNeE1xVFRBRkNOckFTaUN6SnV5VFNj?=
 =?utf-8?B?TFhrSm5kVmJjMy9TcGNsVCtwdGI3V3pQL2QrN0NxNHlJOXhLNEVGcjhoVlVu?=
 =?utf-8?B?R0UwTmplTDhiOGsvcmxnZWkreVpjaE5GOXg4Ynd0MEpEQUYrUXZnWksvTngv?=
 =?utf-8?B?Q1pDd3lVY014ckl1Uys4SVVvT1czOUttRk9pTmM5Zm5iMHJUdmpqVG41S1A2?=
 =?utf-8?B?b2phcEYrK25nTVluWEowb2RFTWw2L1JOYzBDNEpJWkxoMEd4a2xXejU1OHJh?=
 =?utf-8?B?eXRwbDFqaXY2QXlkRW5wQ2pPZWt1dFF1V0tVbGg5elM5YzhuUllvT1FwMmhY?=
 =?utf-8?B?VEdoWHlpY2djbjBaR25hQW9hVUU5NWxiYy9SUW1kU2VoSnZ0VVd2VUd1bzBs?=
 =?utf-8?B?bGcvaytuSHM4aCs5cGxzT1JQWi9LUlNSSWQ3U0E1V2ljdlI0TnF4Ri9ybG5w?=
 =?utf-8?B?TzE2M2dlTThJMW1TUTJCZDFJakl4NzdlZyszRlR6OVZkM0lZSm12QmZBUXhX?=
 =?utf-8?B?ajFLanJGR0lBNGdIUG5ia0xPRnJuY010QUVWMEtQRkNpNTVINVlmcCtlNTY3?=
 =?utf-8?B?ZlJvSzI3YlpGSm9hS2hjMWJ3WlpzWHMyYWJQcjVZWWJVZEdBSU9MM2djZFBx?=
 =?utf-8?B?MFNoaUFJaldYNXRRak9TNCt0a25RenlUWkVYU240T2xHWG5pd3h0UUxVUEJu?=
 =?utf-8?B?TWlOcU5rSzR0U2VLL2VaMWYxWDlIbk9KZmgxYkhVN0dLbkJPbGs1Q3ZiODE3?=
 =?utf-8?B?amFSQlI0SGJnaVZrV3N4eERzdFk2MWxVWkJPZE9kVXEySjBxbFNkd1VtUWlP?=
 =?utf-8?B?NFlVK3QwZjVubHBsM29lK2ZYZk9ZVFlkSDRYUE9FeitpKzNlZVpGaWIzN2cx?=
 =?utf-8?B?THU4YlNmQ25RdmYwdDV2WlFlWFg2eXV5RjJQYlB3MERVOElTbldGV2ZnbUE3?=
 =?utf-8?B?djJtb0sxTjg3YURaUmVqY1N3MStDeXFFWGcrOEQzUm9PWE8vUzA0ZmxHWlB2?=
 =?utf-8?B?d3RCU0I2TkYzL3MwT3Fob3ExQ0xMemtXNS81MVJUaVo1aUFVbTF1R2hQM3Bp?=
 =?utf-8?B?OE5aek1oK0M5NDliYjlza2ttclF6cnZEVTJrRU9TWDhTZC9zVmtqVGlLUHk3?=
 =?utf-8?B?Y3Z1YkV4SGg2bytudW9uTGRScXpiSWhia0dWNVdlR2Z4ZkJJNlBuZlQ0M1BR?=
 =?utf-8?B?L1lHcm5QVExPSG90Z0RGSS9xNUZ3UFNkUFh1SkYxYTdreHV0VURCczFpKyt3?=
 =?utf-8?B?cGpjU0Q3ZEFVekFZeVI2cXArK1ZjYWp5eVg4UE9XM3l4SnA4OXVyM3dlWkdW?=
 =?utf-8?B?ampIb3d4aFFiVmJpemVHS3JxWHI1OGFpMGlXN0NVVDZVQU9KMEZaQzNkc0lQ?=
 =?utf-8?Q?dYB3dGD2NP66WD6ZwVfr4ou3+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de29e8e1-47d8-41f2-d1f4-08db3c0944eb
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:24:31.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEawAEUVIFL24i9wy09oHLhVBchnJ+lx6iGbe9FYYkkZBloOGNIlR32gbP7m8btEDXaL0Z5pK3ScaftXvhrICg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6040
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/17/2023 3:02 AM, Joao Martins wrote:
> GALog exists to propagate interrupts into all vCPUs in the system when
> interrupts are marked as non running (e.g. when vCPUs aren't running). A
> GALog overflow happens when there's in no space in the log to record the
> GATag of the interrupt. So when the GALOverflow condition happens, the
> GALog queue is processed and the GALog is restarted, as the IOMMU
> manual indicates in section "2.7.4 Guest Virtual APIC Log Restart
> Procedure":
> 
> | * Wait until MMIO Offset 2020h[GALogRun]=0b so that all request
> |   entries are completed as circumstances allow. GALogRun must be 0b to
> |   modify the guest virtual APIC log registers safely.
> | * Write MMIO Offset 0018h[GALogEn]=0b.
> | * As necessary, change the following values (e.g., to relocate or
> | resize the guest virtual APIC event log):
> |   - the Guest Virtual APIC Log Base Address Register
> |      [MMIO Offset 00E0h],
> |   - the Guest Virtual APIC Log Head Pointer Register
> |      [MMIO Offset 2040h][GALogHead], and
> |   - the Guest Virtual APIC Log Tail Pointer Register
> |      [MMIO Offset 2048h][GALogTail].
> | * Write MMIO Offset 2020h[GALOverflow] = 1b to clear the bit (W1C).
> | * Write MMIO Offset 0018h[GALogEn] = 1b, and either set
> |   MMIO Offset 0018h[GAIntEn] to enable the GA log interrupt or clear
> |   the bit to disable it.
> 
> Failing to handle the GALog overflow means that none of the VFs (in any
> guest) will work with IOMMU AVIC forcing the user to power cycle the
> host. When handling the event it resumes the GALog without resizing
> much like how it is done in the event handler overflow. The
> [MMIO Offset 2020h][GALOverflow] bit might be set in status register
> without the [MMIO Offset 2020h][GAInt] bit, so when deciding to poll
> for GA events (to clear space in the galog), also check the overflow
> bit.
> 
> [suravee: Check for GAOverflow without GAInt, toggle CONTROL_GAINT_EN]

According to the AMD IOMMU spec,

* The GAInt is set when the virtual interrupt request is written to the 
GALog and the IOMMU hardware generates an interrupt when GAInt changes 
from 0 to 1.

* The GAOverflow bit is set when a new guest virtual APIC event is to be 
written to the GALog and there is no usable entry in the GALog, causing 
the new event information to be discarded. No interrupt is generated 
when GALOverflow is changed from 0b to 1b.

So, whenever the IOMMU driver detects GALogOverflow, it should also 
ensure to process any existing entries in the GALog.

Please note that we are working on another patch series to isolate the 
interrupts for Event, PPR, and GALog so that each one can be handled 
separately in a similar fashion.

Thanks,
Suravee
