Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D17B154B
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 09:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjI1Hsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 03:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjI1Hsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 03:48:39 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2089.outbound.protection.outlook.com [40.107.104.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3188F;
        Thu, 28 Sep 2023 00:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQr/GiW4uX6cTRRn5kNVauaU/AGHbQORzVCpH+asm/QaCayNELuyYJycdWXvKS9eewYZQojSCBvkiT1cVMmOAV00toNHhQ40gwG8/2bTW/l0zt16ANKbrVqjkASgzSfc1HNn+qW94BeFMpVPPZf4hksYVrpx6MyrODiaugG49XczYL9zuEIuXgv379dwh9tntOjrXLGXuJ8Kmb7aFLWnMr6VurwJx/XntzNB+y7ZdYT9DyYjtQnCo34siAD/sHkGUYqzGkfJEm7yG7cTbaISB1SpmtafyHJL9uCYYzJYAoW70TRzFakzuia36ul9e3mm/GQ9g0Lb28UUAfTuiEfAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDYJuO3/0+JIskSV8V9TUOR0vYn4QcTBrTcJYRpf43o=;
 b=hzHPfE/ji2GYzKG2+ERrOIpelPt0XoO7PEqdBPJjUknzwwl/S9gL8JZvsU5ZEN5CmJrJoyvy0f+BmR50Nu0elzNWLX3fxB4KY2rZGRWTY1eu7egxp5aD2NiDpDEOxQO7/VuTU894+API27mgck2alxOgLZ9Ry9NAE3O5UwKfoLB/NhYEOs4sVJGsf6WfmTRLdFlaYqnWj2BkkFgRyCqog7YpA78ieKpR9q60G4Pm+2nF6ZzHgVjPFhT880FJFnarQc8TzulRhTkjprXtKEAcegkIvmQk5ocZ+3ByE7wh1uvKBCtXN+mEnk4t29mUsuUW0b2sQNznkJMGdrOs/1kPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDYJuO3/0+JIskSV8V9TUOR0vYn4QcTBrTcJYRpf43o=;
 b=Dd0742w67+5ofFW4Q6Jz2+IHZ00XjXSqEicMPya0hpYpNIzqEbozk7bX5UKAzTZd/LVe2FE9+hDQB7UBd/JKBgZ5TlcXJPh+YszbYIoN1Wv9aYjD8kzCe8C5WXdykGHTxaVeRe68ovx8yBNFVKGy14o0BMAz/zZJIj8SsrQ6OkJlNc/aU1I89fveYxhxpTELVtxlwqWUva+A6S5SI6AbfYPlkrRYN/NQ7cVujuKpRq1RxeiBBHbhwooM9y0lJYMnTdcsvf9Yi3354+BJ1sDMYcbs1ehjhcCmp1RpGiHpwHkrslEkGkZ8qgEnTLWFinMkTEueUHyDsL0g71lVT/boYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM9PR04MB8422.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Thu, 28 Sep
 2023 07:48:33 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 07:48:33 +0000
Message-ID: <01c42d09-c24c-2611-ff2e-e1079b6df157@suse.com>
Date:   Thu, 28 Sep 2023 10:48:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v13 00/22] TDX host kernel support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::26) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM9PR04MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf7bee1-64d2-4c23-9f5c-08dbbff7501c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnIlEj5yECxvp+bhVpviFAR0a53aU1902bgJiUL7l+2yJ1aOBYIQ5EBh5+zsxb+f+8hoWBIhXYv1G3AT+191kp/0nLIKyZUUbE3QNnxxD4HNLbYNhpBdUgerNIluqiBnZQlQnrvYQy8LB1zwECmkbVpbeVEGAYntofx38JyKKQm8Y/SFnZxCIrWe6Irj1EA5mJsd8ZD9gqAylGsi+q85BIXaY5/PXw+F4V/gaSeOBp6vlYNhFzpf4lEQNkg2yUbN2uPW2VGa8td7sacLayYpq9VS2gLv3yulXt2krsCDtuXFtR6td0DsYFWPj6/nECZpwHTDzl7l0hsLthcxdkl4B+rPVcMALYyibqhY15Q4lUbvEBc/g54zWq32TgG9Zap2kPsIxapKwQ0lKlzEJq3JQ5TG4Vz/rdBJ1jT010GENKAYZNxjq8McPbGuFUmScAGfH99uwMfCeDuf8yp8AJBiRkUUq7HvdRXwp3eZDP5zNp1D6xA3U7n1aKClHg4m+lVKQpbex9Idcof9lyTeMmrfkoFDnnm9t1OFxmHMgKm8lqo179HfWBIN+kmp9BU9iXLAup0sE8UhMvJg9vx3rLAZ1cExJQ+lD1oFM+JB/SbdG4TgCudRMBLB+9e03gsWsfSbhJ+z6RfKM7pkyztCcpUwGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(396003)(376002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(31686004)(6512007)(6666004)(6506007)(6486002)(966005)(478600001)(38100700002)(31696002)(86362001)(2906002)(316002)(83380400001)(2616005)(36756003)(8936002)(66946007)(66476007)(8676002)(41300700001)(66556008)(4326008)(7416002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VCtGNEppMjZZUW1Ha2lWZXNRUm5CSmNTL0JEd251RjBRS09pRTF3U3lyNDZm?=
 =?utf-8?B?S3luMGlHOXo5ZjRSVUJRdmlpZUlqbjFsajM5SGpERTlBSHhVbm1DeldVRmtH?=
 =?utf-8?B?OUdYL0FwYmplYXp3TEI4NXQvSjZJOFpSM2dHNEs3ZVNPbVk1MWhIMUtPMTdI?=
 =?utf-8?B?M0ZGczZaaStVUk9CbWdiTFlOVTkzYnNtK3JOakdCcnA5aTFQVGxTdDBYSitQ?=
 =?utf-8?B?MnVkeG1VV0RCSWZHbVRQVmx4ZHFqbjcvcFAvUDQ3aklMeGFpSWtwZklJYjNa?=
 =?utf-8?B?V09hTUlPRkl0YU9OYzJMQ1ZUa1djcklqbFJ3eEZZRkxTZnI2ZjM4TFRHWGRJ?=
 =?utf-8?B?YWl1bXNsK28weE9FWGFsRkRDNzY0N3J2cEpNalpSa21yVFozWFYxZ3g3dDRU?=
 =?utf-8?B?TjJ0dkY1TlNjTWdpZjhqemtyQzVtbi9EZW96cG1qYjVIUTdYVWk3VnFjbXZt?=
 =?utf-8?B?RUtSKzdLUCsxZ0NHS3Z6TlJ4TWVGaVFVd000b2RvZUkrblhrMkpHRFpTWWM4?=
 =?utf-8?B?Q3luUmxtNElZdFF5NEpRcXdsMExIakxDTzg0MUhoWGo4aFVRcEVIOFhUMEpa?=
 =?utf-8?B?Z1lGUlh0ZHNLQVBwTVhhSnZhZ1FxRXZRRVExOXR0MXhYNklvYlRlblBXZUJj?=
 =?utf-8?B?aEIyOEMyb3RueVVXSW9KeTNwVzhhMjliSHMwLy9pZWhJSlZyWlVtaVk3ZC8r?=
 =?utf-8?B?Yk5QRzdxc2lNTVJmTVlTc0ZDOFJMOS9OTjZVdFVvRXRkZkRYeDYxT29EVXpZ?=
 =?utf-8?B?UEZ3MDRNNVhCYXorT1JlaEFPcEZab0dyWGhGQkVRVXQ2TEYyQ25LWjF0QnUy?=
 =?utf-8?B?YUxONE9BQ1hqZmhWaHhCTDhEMVcySWN3SzZiZXVtTjlaNnkvWFpmUElORkpW?=
 =?utf-8?B?TUFUKzRZazg3YW92MjlrV2JuNEMwRExMQ1djWndjanJWUiszeEg0Mi9meG5k?=
 =?utf-8?B?c3ovMzA3QVRYOVRUa0pVY0dkd21MMVFBN0JrT2w5RnVTMDVKbjNtbSs1N0I0?=
 =?utf-8?B?aEhTbTA4S2x6ZDloR1huaVVyU29nSm85N2VDZlZrUlFlaXkvaUh0bmJxNS90?=
 =?utf-8?B?WitPdDFsQWs0QzlremZoODJCOFdabVkxWjIwSDVLUi9kVVRYN0RxVXpwbkJJ?=
 =?utf-8?B?dHN2eXoyWHU4R2xtcThMU283Z1FEbkR3bWgwanVNU2lnbFd1alY0NlBJVWZX?=
 =?utf-8?B?a0hOb0hJRzFEZkk0REZ1SVdvYWxYQ1ExSklLMittRTA5cERJTG15Ykxlajlo?=
 =?utf-8?B?K3lucVA3S2dKQS91Tk9hU2RGVklvelJHaldDczJxZkpybEFYdXRWMWlYVzJ1?=
 =?utf-8?B?SFFhbmo1L2Zmd0FEY3FJSWR6ZDlnTCtGUTBQZlY3Ym4vbi9BSEgvcStQaXZr?=
 =?utf-8?B?OXNDN1ZsSEMvWGQ1QXQxOFdXRklFa05iZG02ZlcvQ1pXQ1JhRG56enhmZ3dG?=
 =?utf-8?B?MWdVc210OHg4Wk10eDEySUR0dmtFNWloRk5xZG8zalkxRmlpbDNmakNRcDRS?=
 =?utf-8?B?aHhWS3A4VHVEOVkySVVtWUVFTnZSdEl4QkNJcEliTHJYczFZOVZwV2tZdFQz?=
 =?utf-8?B?VnpsVHQvTG8rb0k2UlFoSUZ0SHNLbmhyZmdzcDVFUnFuc0RGenZubXNOQVBp?=
 =?utf-8?B?NXR3Zkt0QUhxZk5HN3lGNWkvSElTaklvSTMyeVM2RFhsZkg4ZUUxSkZwbWxs?=
 =?utf-8?B?WGVoTHBrWEtSNXYrTFVMTzJqNkF0QW0zSUVnSnB3OE9TZWFTdHgwM2kxYlNZ?=
 =?utf-8?B?aC9Xem15NjdwOGcxV1VDSjFrZVA3M3NFSGxmdXcxRnIzQjBBa0V5N0ZKRlFt?=
 =?utf-8?B?N0dXVWNSSmxaTHhQOWtHcjVIUUZSN2NSbmQzVnliVWU1c3FyYlByM2VldFBv?=
 =?utf-8?B?Vk1ITERueW51aHljdzNwZENwanpPVFAwMFlHNkY2SFcwcncvazlKMy9zMmJ1?=
 =?utf-8?B?TUZJTGNTZFQvSmZtU3l0SmRxOVRoRTJKY2VaR0dMT3ByWTU5NlBYczZFK0Zj?=
 =?utf-8?B?RklxKzZFMWh1LzFCNm9lTE1QMEtEYlgwYmpwNWswR2wwV2dmZlpHaHg1SjFU?=
 =?utf-8?B?NlBFOHU0U0NIQm8ySEZPNW95SDFrM2w4dkY4OUlYcVZIb1dyNGRDYzlzZmVF?=
 =?utf-8?B?M3BQUHE1MDhaMFZ3OFVmZXpzNmpzY0JaSzE5Uk13T1B0d20yKzAvblU5SDBE?=
 =?utf-8?Q?WEeRCsXyZs7h04mAfTLBZHUIAjZKTsSbZdslNvOwYKi6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf7bee1-64d2-4c23-9f5c-08dbbff7501c
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 07:48:33.0180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhvr7ga3/pmuxbMrm1S94WKsHAp+hqiCK9FeSl+zaUCn7lYuEQHY+UAPO678MSKcAn9D0K/ogj3qoChLC2y6lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8422
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.08.23 г. 15:14 ч., Kai Huang wrote:
> Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  TDX specs are available in [1].
> 
> This series is the initial support to enable TDX with minimal code to
> allow KVM to create and run TDX guests.  KVM support for TDX is being
> developed separately[2].  A new KVM "guest_memfd()" to support private
> memory is also being developed[3].  KVM will only support the new
> "guest_memfd()" infrastructure for TDX.
> 
> Also, a few first generations of TDX hardware have an erratum[4], and
> require additional handing.
> 
> This series doesn't aim to support all functionalities, and doesn't aim
> to resolve all things perfectly.  All other optimizations will be posted
> as follow-up once this initial TDX support is upstreamed.
> 
> Hi Dave/Kirill/Peter/Tony/David and all,
> 
> Thanks for your review on the previous versions.  Appreciate your review
> on this version and any tag if patches look good to you.  Thanks!
> 
> This version was based on "Unify TDCALL/SEAMCALL and TDVMCALL assembly"
> series, which was based on latest tip/x86/tdx, requested by Peter:
> 
> https://lore.kernel.org/lkml/cover.1692096753.git.kai.huang@intel.com/
> 
> Please also help to review that series.  Thanks!
> 


Are there any major outstanding issues preventing this to be merged? The 
review has been somewhat quiet and most of the outstanding issues seems 
to be nitpicks?
