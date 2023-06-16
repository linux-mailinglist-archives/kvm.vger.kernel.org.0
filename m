Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE65F732B03
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjFPJFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbjFPJF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:05:28 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2051.outbound.protection.outlook.com [40.107.7.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E146F4ECD;
        Fri, 16 Jun 2023 02:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuU1qyhRO/v/YOir0ZI3+dAl8yRrE39NLPM2m8anBUohFU35JXezHqKCy8KrJ0KdaaCau2YzDoAXw+sxYtwLpMwLYkMbU3lvweMB13MCLYrbKhDjd+VDxGkSRWzxaOJ6RZl/HT0rRcj+0nfnabOpgaBAaod3cCNFuy5ad0o19h+4Q+Ionq9XANoAOSstRyi72iLvEKVVeSvkXKh3kG5/i+6F51olh2CvLxza+k4uDIIttReyw2HU3tUuX7cE6CgMP6PNZOsUp59dm81IijJAzbgb89YBGyX3lBLsmTk4XeAXtno68zxkWgrYL+hq+bI70MvmTK7J+BI+sifF5hcOXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbp9r/MxJZXsBo99FUFLeGmz9bqoWaUu277J8CksR6g=;
 b=oMV8C/LK9K+YE6stm2avLo+bpAXLXLMKjfhYKYPvROaxNtHqLCiTEmCMv1lVAcTIyFyg2pzY0F00I/DWj8wYrg/+xQDH9z7xhX6zFDL5t82hVU0JSjQQ/3eD7zC6PkInIE0hmxpdDVAaiScg7CAVsNJevIgBaX6rpBKIjg2cqKuXekqPA0Oo3wmxgT6hnY7Fvz093cHsKlHdMgW23pnApXhp9Yeqv+Uv7RShJtIm6zGFKqZJUBc5H0B3YVMB3+Tj0z47VjE43VdCxDFRyq3cJBAS9+Mx9lkSTleRRZxUTgHiqql7bSW6VER5BOFlgpVOBRimJiGQfXHusotxtiKB6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbp9r/MxJZXsBo99FUFLeGmz9bqoWaUu277J8CksR6g=;
 b=GmRJQICqZX9yejqw6n2n4S7K7XRwYbK49IcxH98AgL6KgBB1IKUteHv0T4U8IRrGg0vajCWmKrG1Pbkq2UM7by83s3zdo5uvrWZYK2TJDnwOISwiB1PF6JJP+Qb3PhL51vxO0pyYt2M4eSCDO9x1c7kXl+u3ZYt//O0tXnDEPczcfpp0CLfUaiSkdmjU/EStpe4glDxGlqNz9DpOQSMvThxX1E+dQAXyg7qMyjyRldodoY6EURD+omGJWKgG/mMT04MHNfq9eB95ym/K0KE/QNrP1RZED5jLmZROtRA05imMokpJAss5tMWjnPe/CXzGB25awIb1O/ud5Tv0chemJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PR3PR04MB7466.eurprd04.prod.outlook.com (2603:10a6:102:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 09:03:03 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 09:03:02 +0000
Message-ID: <14c2a806-05e4-a9f8-e85f-70b2081cd22f@suse.com>
Date:   Fri, 16 Jun 2023 12:02:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <34853e0f8f38ec2fda66b0ba480d4df63b8aab43.1685887183.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v11 20/20] Documentation/x86: Add documentation for TDX
 host support
In-Reply-To: <34853e0f8f38ec2fda66b0ba480d4df63b8aab43.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0012.eurprd08.prod.outlook.com
 (2603:10a6:803:104::25) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PR3PR04MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 879d2f2a-fb09-4f4f-6a23-08db6e487d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJ7JHo2uYTVBo/2MCYX5x4Rz2GpHx+Grla3fy7qDbBeZRw/0SWHUQ1/uU7P7UZwqvwiqYnbyVIIyAdTVxaDc+rgZ71AWsDlmZXzhjIEd4JcKFMENynaL+jhxieTScADM6Zzx+5lf3xk3EjDxWD7DF0QMnYp+GvL78Dws6uKIvwoIFpXvER5Z3zQsrtDDIWJV4cCu1eKaTtv5XAE2x0XkG4J0RMkHg+126DUo+qD0ZdXU5I4N5l/QWSYpEjfqhQGGa8foNufMwT3YraT+Hq7UpXWr0f1xFrSD4/kFNq+EY+FGSqfw+wrseLstzZwRnrQ/3NeZdDemgB6s99xv+oLO+qszPOdjZrCVMwGGv0ezrBAerSPftxAhRoOPmL+ZFJfx+AaWmJ6u4N74F1fd8QMsPtOz0Wt4lodL1bcEVc4bP5r1NT5LbvmTcKfeszJGnx781MMsmGZyRh572ki8Z+Akr7HZsmBkaijpxKOY55sgcm1GtTUS5r0wcfAglttFrqyWyddtQhnuP+PD57s9WrphrcXgpEX3yTjFVqtyJw9/HhSuorsMO2Ekvjyv1JHNO/ioHZQvz7TRTMr6TU8IwK1uDiYrcd7ofaLfg2RCKmprfI930oFSz3Dq/OUXX6O/bzy4sG+5j0nESp6Uj+o4bQ709Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199021)(2906002)(186003)(6512007)(2616005)(83380400001)(66946007)(66556008)(66476007)(31686004)(4326008)(41300700001)(8936002)(6486002)(8676002)(316002)(6666004)(31696002)(86362001)(36756003)(478600001)(38100700002)(7416002)(6506007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmZkNEVMZ21XcWFqenZFMG5TMzd5SUNENjdaLzFUdFVHb25HU09DdEg0OVVU?=
 =?utf-8?B?SEpzMUthNk5jQ0R1dURodSs1a3MzZ3dPU3BmUEozRTJtZUxkeGZ3MERhVTM4?=
 =?utf-8?B?Wi8wdzlGWk5uWktHTHpEN1RqeHZaTldwRzMxbnJ3OVVCdXZmemN3USsxK3Fr?=
 =?utf-8?B?RnhuL3UxeDJETVBZVTlSUHBXN2R1ZEs1UFlrdElTR3Z2Vk5vcm83Z3EwTmkr?=
 =?utf-8?B?NVdsajdzWHdqVHh4b0Y4N05nVUlhQlN2dkpEK29zdTgrVk0zQXJiWk9MMlE4?=
 =?utf-8?B?SFZzMkdKdVlmdCt0SVQ5K3pzTmQrRlhHQUt4ZjkvT3NMS2NSYkF2ajZZR0RX?=
 =?utf-8?B?blJKSGxnWStIVHVFOTZ2ODFBT2RqZW5jV2k4TXkybUVyb29jb05NdytHZith?=
 =?utf-8?B?WDFUWVMrREczRVBDMktiSEljcm54UktGT05BTTE0K2wwQnNSTGkvSEJ3cEwr?=
 =?utf-8?B?RkJ1Q2lGUlRVbmZwNVNHRjVUdnA5eFdYTGRJdktLL0lLaFU3b1ZsR1NlbFB6?=
 =?utf-8?B?Tno3M1VtOU1xaW4wUFBSeFFSL1loOVhsaDRDQ21BV0hKc09pZmFPTHd6dW9K?=
 =?utf-8?B?MHZaQUg3RDhiR2RnNkd5VXh3V2EyalRuaVRSRkswSVRUZ28zRGJxR1RrOXpU?=
 =?utf-8?B?RTFQWkJjelpPSmRYSmhmS0FDT2tFQ1BueTlDcUt0MUxyUkRjNzJxTjJjaSs4?=
 =?utf-8?B?R2xBdTI1amtWT0s1SENBMXY3dEl2eVJSNW5ZUVRSdHg0UWorSnBpNXJzQ3Yx?=
 =?utf-8?B?SE0yVXlQRzgzMHFiNmRrTHN3a1Y1NXNxRUhieGNSajlWZ3dROEpNc0hJdE5m?=
 =?utf-8?B?ZjJSSC9XOG93YjI1dmM0SmhjRlR6Y0s1UWNlbmJmeW54UzhKUWhhcVlMcU4z?=
 =?utf-8?B?V2R1N3BudEg0K1hMQ0c3VWpqb0YzY3oyMnZYS1haRDBpbDJHWHpWU1ZWY0Nu?=
 =?utf-8?B?SW1Lalg3MjhKZU4wZFExMGdtamVEVHd5S0xUZHJRSXhidjY3S3V4cEhQZXJI?=
 =?utf-8?B?elRBcXZoVjVVRnVkdW9kYjVTQWVvSzNva0ZYbXQyaklYTG40dFN4R3hLV2Nt?=
 =?utf-8?B?ZEFuZytNS1RqcW9pUkwyUEx1QTNrb1U0WnN2UXJVU3oxeUJpSTZxbUdCbDJQ?=
 =?utf-8?B?dnZFYUl6bGp0TExES2orK0Q2dXREcUJXYkx6S2tGTElEMUltSUlZOHdHWU5Q?=
 =?utf-8?B?aXBqWlFzTDZOVGdMN0xRTUFjL0htRDJxUVRxTkp0ZVBmSWM5eDdnUFYvZkky?=
 =?utf-8?B?MDIwaE5mY0JjUldKZ0Q2Q2g1Y3YvMzhQbURWT0dsSnNXM2Rya1J4VmRZemtq?=
 =?utf-8?B?UG1jaUlYSnZhVU1IN3Vkekg3RVM2WHA3UHVJcW9NanpWZ0txOTVkS2dUQzZ5?=
 =?utf-8?B?VjVnV1NDZ3psUFJ3NDZmcWpjK3MvTXgzazNVRmhZb1owTzlWb3gvSU03MzNk?=
 =?utf-8?B?WDJ4bE5rNkMzQVdnRENCOFd1MUlUSjhuY3RhTTRkUExJUFlYY3VRTDIzblpO?=
 =?utf-8?B?T0xpUkIvUXBGdTZqVHVvTXlEUUw1aE1oTXB5OTFPYXJoS01PWldrMmljSWRi?=
 =?utf-8?B?d21rem92aEhFV01ueXpzaElVSmRpb0RLb2FhOGpaNHd4bVlBd3ovd084NG5t?=
 =?utf-8?B?S1llTmlFWmFkTVZJRERpVFo5c2NJd25sZlVxOC9ycmJRckY4RDlpV0Rab1Jk?=
 =?utf-8?B?dWhNNW5OWlZCaTBhczBsQ05pYXVSSGp5M3V4MXNkQWpIdDlIN0lXZG96NW55?=
 =?utf-8?B?bWU4RXVMcFVaVDYxVHdsM3dBM2NRTFgzc0pqbWhKZUgzdEh0bmVwcjBjL0t5?=
 =?utf-8?B?RmZHdEo3TUgrZi9GOG1sVzAzZ2s0YlBqWkNFWXRaTkluTGNpKzdFVFo2TG1K?=
 =?utf-8?B?QUI3dWJnaHhVYlJpbHRKUXFtOTBQMWxxN3NHQlY1NlV6VVc5U3ZlNzB6aU1E?=
 =?utf-8?B?aWQ0cVdLNjhXcDA3WWZtak91cXFacUhCNFYwME55RUpraDFaR2hmZ3NIYWFT?=
 =?utf-8?B?TUg0TzBxMjk1R2Nnd2tjNFFSNUpwcnJYdDdnZ2RuWmJ0Q2lSb0hoWmEyYng1?=
 =?utf-8?B?VWt4OHlER0txNmdoZmFrTzJaN3lHWUw1dXhUcCtybExSSTF3UStPRTBJTlJK?=
 =?utf-8?B?c2tyd0Nwbno4Y3VOcnBkKzJJYldFNGo5QWVQWk5kQ0xaUmt6OHZWbkJUZy9m?=
 =?utf-8?Q?qjSf1fWtJUAdXOXyjK0QG+1qW/8uNnCP5wMln87Khs8F?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879d2f2a-fb09-4f4f-6a23-08db6e487d80
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 09:03:02.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKDFnjVTM1iDCL2ZjdVkM8KR7Zk79wzxN2w/hxC7l+vLTaR8vHxtxOhxPxuAypSZLbzNTEmyc/Ii5/SRoTPqSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7466
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4.06.23 г. 17:27 ч., Kai Huang wrote:

<snip>

> +
> +To enable TDX, the user of TDX should: 1) hold read lock of CPU hotplug
> +lock; 2) do VMXON and tdx_enable_cpu() on all online cpus successfully;
> +3) call tdx_enable().  For example::
> +
> +        cpus_read_lock();
> +        on_each_cpu(vmxon_and_tdx_cpu_enable());
> +        ret = tdx_enable();
> +        cpus_read_unlock();
> +        if (ret)
> +                goto no_tdx;
> +        // TDX is ready to use
> +
> +And the user of TDX must be guarantee tdx_cpu_enable() has beene
s/be// and s/beene/been/
> +successfully done on any cpu before it wants to run any other SEAMCALL.
> +A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
> +online callback, and refuse to online if tdx_cpu_enable() fails.
> +
> +User can consult dmesg to see the presence of the TDX module, and whether
> +it has been initialized.
> +
> +If the TDX module is not loaded, dmesg shows below::
> +
> +  [..] tdx: TDX module is not loaded.

nit: There were some comments that given the tdx: prefix it's redundant 
to also have TDX in the printed string. You might modify this in the 
code but it should also be reflected in the docs for the sake of 
completeness.

> +
> +If the TDX module is initialized successfully, dmesg shows something
> +like below::
> +
> +  [..] tdx: TDX module: attributes 0x0, vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
> +  [..] tdx: 262668 KBs allocated for PAMT.
> +  [..] tdx: TDX module initialized.
> +
> +If the TDX module failed to initialize, dmesg also shows it failed to
> +initialize::
> +
> +  [..] tdx: TDX module initialization failed ...
> +
> +TDX Interaction to Other Kernel Components
> +------------------------------------------
> +
> +TDX Memory Policy
> +~~~~~~~~~~~~~~~~~
> +
> +TDX reports a list of "Convertible Memory Region" (CMR) to tell the

nit: It might be worth mentioning that those CMRs ultimately come from 
the BIOS.  Because it's never mentioned here and in the "Physical Memory 
Hotplug" it's directly mentioned that bios shouldn't support hot-removal 
of memory. So the bios is a central component in a sense.
> +kernel which memory is TDX compatible.  The kernel needs to build a list
> +of memory regions (out of CMRs) as "TDX-usable" memory and pass those
> +regions to the TDX module.  Once this is done, those "TDX-usable" memory
> +regions are fixed during module's lifetime.
> +
> +To keep things simple, currently the kernel simply guarantees all pages
> +in the page allocator are TDX memory.  Specifically, the kernel uses all
> +system memory in the core-mm at the time of initializing the TDX module
> +as TDX memory, and in the meantime, refuses to online any non-TDX-memory
> +in the memory hotplug.
> +

<snip>
