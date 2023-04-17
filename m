Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8749C6E3EBF
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 07:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDQFFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 01:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDQFFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 01:05:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB11D8
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 22:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hg1U51GNzzcjCmngbzprMbfJxA63Ol76bMG2v3YqT3xXphQEOApp4/zamTdVfuV05RFmpwrGfbX63ywbsbEc1W3S471v/3wTQJDcvgOZeAOAbVZ9ynd90dwJ/2oEL1pgWQIEWXJQ5PE0q22AA1V4Fc1Ax8B3mzg8bK/ApTnd4PGYvnB3qYyBj9ffJY20P0l6tCH6tXs+SuPDXYdzYsFUjNZkSLJjhoRg6iSopa+ZstT8ypRnjzMMUn7+DApmHr1p6IEDYjDVZ24rXz8H3Us1eaEiKPG17r4YHWb18xoKuEWjf5UU2MjWGR0WjmfxIOUH/2nIXXrHmwrzSuYXHMa8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IG2ZrUI+KQF/FfciJwImMKwblFcOMRxNe/qbhe7iBTI=;
 b=NpX9PKgj6F12p/FXVxRgIIaQ0dLVwCnkHywOpigzRHTqT1xS1SzwA/zAftGRk12Ysac4WQB3/ChORYQjSAFOGOLGEIZoSUFtvfY8f4CLVLnSS4GaqlmCEKUVmrRbZgqaKEG/Fjct93vJDkYmZJ0uL37o8IytJPiCgvUfquY6XtohFhYgaHRRKPkbnwB7ymcYuS1g9AW1uYt20aKBaz8btLeUJn8QRvaEr2bPbHlTtNfXK0WTdyU9cb+hbqsHEOILe1MADJuH4VqvdvDHXg8S+eRDTqp8fLmv0UAdCouqWScggEQewcpOzn/l4Cn2oLqjUgyKNT/mcjq12eTXAfXiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG2ZrUI+KQF/FfciJwImMKwblFcOMRxNe/qbhe7iBTI=;
 b=iQGolIeOQPgXGhmOOmxoLI3VbzLHOVQCmz6IzSCP3MfRVR2PLlW3gfundbq2rL6PZWvEmUb6PvkjZs5omYevcJnbwabWgXthv8ZHZl/uemMsCKEiKzPUxQSmoMqaHYkhYKqCVQIm3HnrxvAt8u4ui8V59eiVnFeztG9EXcDI2BA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7SPRMB0009.namprd12.prod.outlook.com (2603:10b6:8:87::10) by
 SJ0PR12MB7474.namprd12.prod.outlook.com (2603:10b6:a03:48d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Mon, 17 Apr 2023 05:04:55 +0000
Received: from DS7SPRMB0009.namprd12.prod.outlook.com
 ([fe80::5047:70da:1240:8d0d]) by DS7SPRMB0009.namprd12.prod.outlook.com
 ([fe80::5047:70da:1240:8d0d%5]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 05:04:54 +0000
Message-ID: <c1e7de02-66dd-fde3-ec44-5493c82ccacc@amd.com>
Date:   Mon, 17 Apr 2023 10:34:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 2/2] iommu/amd: Handle GALog overflows
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-3-joao.m.martins@oracle.com>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20230316200219.42673-3-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0142.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::20) To DS7SPRMB0009.namprd12.prod.outlook.com
 (2603:10b6:8:87::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7SPRMB0009:EE_|SJ0PR12MB7474:EE_
X-MS-Office365-Filtering-Correlation-Id: 911e3103-0a9a-4697-29ce-08db3f0147b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBX+kDDcnJ9faJQy8SXZ8F62cv93fXiBe7Ae8suNIwXLKK1qFTzc4UuSAgh7QOXAWuhiLDlX5MKY9Z0QO2XOAzGbYfyQNCIAQHiRUcPfV/EN7rVPExTf+xmOzI+7cMyNgfe2GC2M86VJt6zH9YvJsiiEgfC8U77Kogee+vsEELMGCy41xoKoXlXHXWD3QYnf4XE7fzz1n763PA1LhAZ0RFjpKqBypRRIUzMe2oQSGjo57phD8oNS8wlqh81ZdmOmFjudTSL+S1dxVRqLHEOwKXXJFAEEWv+tCz8Cu89zG1wFGk9nvfTGAJcuoLwo5RtOC2P3XBWRwD+HQrOp1rZP5UsGccbqm12lR/B7goB2CYmYZqc8kLQDmummpMuwzDJAdYtN2NtvyBB/ZrbPKtwnaUNjq4KPeikCvV675zP9qw8hScmlH/boFx6xwf+DJ/6aIxRpoef9tdciEkUECqHTWcUEf3auHOxkvusYNpYuFbrUh0mBuwf2zAEdkosEF+Mh7PRAJM2m9tWhdoJQWD5d7sxeSVips9uPP5t697I8xHfZdNQJNJN1fZRvGYcdRdlaFX35eiF+yav46q6Q+USE9c4hmYqP4fTMxGR2R8C/SR079y/kMrFExlPUi/4sasZtoFRvEJ5xIMT6/PESO/iTkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7SPRMB0009.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(54906003)(31686004)(6486002)(6666004)(478600001)(41300700001)(316002)(83380400001)(4326008)(66556008)(2616005)(186003)(53546011)(6512007)(6506007)(26005)(66946007)(66476007)(5660300002)(44832011)(2906002)(8936002)(8676002)(38100700002)(86362001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUk2WjZ0OEJlWWJLRFIzYmEwTHg1ODdGMncwQnkzMFEvV00yS1NNOWlPOGhj?=
 =?utf-8?B?SUhBdE5yeFVaWkhTeWdycnB5T0h4ZnptU0N1MytJVXlyQWtnWGdvYUpOUlha?=
 =?utf-8?B?OVlmUDc0bkxDZ3NaZjBaZCt6Mk0ySHhPdUp1WEZCVmp6M0ZyUzBtSXd5cUdh?=
 =?utf-8?B?c0d1bkZVRkdXYS9OZzA0SzR1NUs5MzY0M1JaUk9MR0FuSnZLb0NYK3pBVFps?=
 =?utf-8?B?OCtFbmdTRW9lbGZEQTliSEMrUEtLVUVNTFhVNmZ0dVNCQmNBejVaMHZsZWxJ?=
 =?utf-8?B?cCtvS0I1UHF6RFZKd01VM0dBZmh2QkhuemZhS2hoSFpqL2pobE9GU1ZFNGlL?=
 =?utf-8?B?bXhrUHFSQXlyTTJhRDZxTklkU2tIMnZxKzRxeUVNR0paVW9kMVR0Nzhla0hP?=
 =?utf-8?B?OFgzN0orbjdWOUh0MTAwTmhKZmE4R0VnTlNLUkdZVGlyRThaN0hLMDFnQStV?=
 =?utf-8?B?MitNM1FCZTJybE9LUElJc0R0T2M0dU9BdmpNN091Z1BXQjF5Z0h0RGpCN1Iy?=
 =?utf-8?B?QVZOVStydzlpNW9iYWJCYUszYVR3VHo4SWd3RU1rUmJqeEJxNW9GUytLR2N4?=
 =?utf-8?B?MVNCN28veklDRytJWUZwZC94TWR3SWZQSmVZcjlrTmVqbDF5ZGc4RDNsYzRu?=
 =?utf-8?B?b1ZmYnA4OVFHTUQ4cmkrVmdSWnBoTkFoVXl0RGgvcGs1c0dWOEhmMC9NbER2?=
 =?utf-8?B?SmxnUXdGSGl1RWw3S3ZvNVBTeHNtMjFhRE5RVDlvS0MzMThGQjQyUktUM09O?=
 =?utf-8?B?OGMrOFUwUlpENkc1VlM5Zk41RXkyN2x4czFyMHRheHM2MzRiSEMzU0F1N2dT?=
 =?utf-8?B?YWZobWg0N1RVM2pRb294RHdoalVVUU41ZW1OMWsvaFZvd1VnL1BKT084UVhk?=
 =?utf-8?B?YVdVVmNxeFRaRlNMYVVPeEUyR1NjVkt5WWI0MUd6ZThCQmkwRERjMUZEOXVh?=
 =?utf-8?B?V1FudCsvcStoenpSZVBqYnFGeUplMjVXUkVHZFpTQlhNcmpVT3JxMXNJQ0lP?=
 =?utf-8?B?VzhCSWdEcFdhY1Z4aklTcHVlZ1k5Q29BZ011S1Z2WlduSGkvRVl3cHFOSkJw?=
 =?utf-8?B?b0dmd1o4Nmt6RWtXVktVaGs2ZVlUdXl2dEVMU2dwNGk2T0lma3F1Yk5BeWdF?=
 =?utf-8?B?WWY5VkRhUTRTNUNyL2t0QVVvT3hRZHl1cXZKaEQyWG1za0N3QUFBT29BTzhY?=
 =?utf-8?B?QXM0bDJLMEw3SEh6NkRKRUg1d2xzYjVJcG13MHk3ZElCTkJQWWFHMUVrdUtY?=
 =?utf-8?B?SHlzazNYeXIyM1Bjd1hPZnRSZUNqMzJ2MFNHejhNNGZ6SE5jWGE5dGNseW4x?=
 =?utf-8?B?YlhZcTJNcEp6QXhpK1FuQXAvbmRIV3RLS3BwekNUdWI3MCtJNTZKaHNKREJ3?=
 =?utf-8?B?a05RYlJkMjQ0K0hHeVpUUDhYS1BIQTdnT1kxcUxVTXo2RS9iZEVDRDhGN3hK?=
 =?utf-8?B?Qjh4SmV0NXJ5SkptUHcwYStoanZPN3F4ZTRXcVFta0dhK0t5MExxUWZzdHhn?=
 =?utf-8?B?aXVTOEo3bGZkR3JCeUZFdUtlWW40OWFuOGhTREQwV1FvZE9NMXdHQ2NYbGZC?=
 =?utf-8?B?czh2RjRYVld0amx5Um9MQ1Z3NUlQc0l2OFo5a1hmTVFTcGQ2N2FVczN3b1JS?=
 =?utf-8?B?UVdsYzZ5b05tbFhaNGM4Q3JlQXJuTktJcFZVU3V3dHpkUVRZb1dYZmIyTnRX?=
 =?utf-8?B?bGVVOHNmaGlpU1BFYnRNbjFYaVR6aUtUT2dBZndtUGtQMXVMb3FqSUF6MGxU?=
 =?utf-8?B?NXRja1hGNFVrRzVScmhNUnFnTnF4NWMycjlhc3FrbS9TeUMyMWFoM3hQNU5K?=
 =?utf-8?B?MmxxMmdIZ2ZvNTFKTHhWWEVTOWdqNERESkxFOG5adjRZWGZzTmRBekcwam5a?=
 =?utf-8?B?LyswS25RSHlNdG5QeVVGVzB0bHBVWWFHaTJWWjhuWTc4em1RV0p5NU95Y0kr?=
 =?utf-8?B?R3VDS1Mray9STEtDeVptNmlyRDVxa2FIWUZQMnNFOG9HV3dSYnNVRnZ5Z09k?=
 =?utf-8?B?Q0Y3ZTVqSmxSRXpKeTFIMnpzeHB2MGd1a1pBQzQ5VjNUcTBIQ3hQVmxnVWlX?=
 =?utf-8?B?NXRaZnZ0MTUrdWN1eUcwdXRGaytIOURKUzRZMGF5SDZWYitjNUlZNUtqSStI?=
 =?utf-8?Q?O/5CDtxu9m29yu+3G4GGTecQs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 911e3103-0a9a-4697-29ce-08db3f0147b0
X-MS-Exchange-CrossTenant-AuthSource: DS7SPRMB0009.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 05:04:53.7589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6cZQdeZoHLIQJ8xufhrqOHm8dUzbA5KkSfJGr68WIYOI80ml2WB1jq/u5VbFznPoAL4CGC7QtPYKwxT+YN7GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7474
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/2023 1:32 AM, Joao Martins wrote:
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
> Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Patch looks good to me.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


