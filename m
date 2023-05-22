Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFBF70CEFE
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjEWAYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbjEWAKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:10:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491951FDC;
        Mon, 22 May 2023 16:58:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fe/otDxqgU+5NSnoqZS6+fDWtRIe6eY/K1ltO6XkecDFu0EIv9Ldi6ivW2E4CTxKE5lbawKJntpL7RMDIFHQ8PANtHNlkO5KptJQBLL+5Z06w5jIAatOPfnTq7ueyDGSOQDjLk1PXof/XS5Wbme2w7j0ihCnieJgONiJGYvVWnWe7Hb1xEsNI3h4NgBN+buXiHE5f/RuUjmJIP+ALYuS7v9PJ4yRuwzfeRc1CvgdZBtYKh6Dt0MzzGnecMnUG40CskElgC+yNOE7A6EXPvhsVSU5wJZn++zohHU8AiWoMbSBXWta/rAzfA99Pkm2hMfG/7aFuWNUaSsIZ7p5+rjStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ws1eLdoOH0Uz082UlEZts2wEDcphreDm9Wwk0iXcJgE=;
 b=WahrqJdLOeIYRGElHoMjZUner+2+WnApVrgWbsc0r/3FQCRhwCEmm0VgVE64bdiKHdrASNIjijqENtYpCiMjkpxEQXagqXdn2kBc6RXr7D3RG+p12YXTwQVlMIRVhM/BaR9wwEgOUijM2ejabeDveScgLw/4ODOdTFjeEyOcDt9llUjdaDYo3DzgC5yccrhfZdVg7IIhc11h7sqWD1RM8pavahXKlU9FwrelHjdFLv0yqp5MYBXof6L+lqGy0xhZaixByPySh9P3xCFBOK+eQEuem2CC48ROnTkrc+Y74Kllc+djpkn47qz4BC+jStfrBEU3qlb0B+VwDEuGXunFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ws1eLdoOH0Uz082UlEZts2wEDcphreDm9Wwk0iXcJgE=;
 b=IczJWZzI9XX8sdq107uRvFPlt9tz+P8PNra/SQ4ZmGagXDHcS301fFc3tR2KM/acdshXWCR9klKZISz01HmRZAppRhR3HA84nGplgDOq8ZnBU0NH1NqZH6rZuEzHncD651xWgM280MrcjMePNeRJ8961z5waJWdN9Ik6n8ThJaQ5P44YEoOnCPgXVpQye3VKjRmFDnrCMO+QzwVgehrkqfz1a9MAn21D4o5Dm1lJAhx4pW2mnbGIkeM71kB3v9IrcbvTroviJB/NSJqR0Jw2oMtrqUWq8oVvjplA6dxIZRQVlL6vGunGqwgLESBhitj1WqaddyUMpLwkad57PZk25A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5376.namprd12.prod.outlook.com (2603:10b6:5:39f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:58:20 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:58:20 +0000
References: <20230522063725.284686-1-apopple@nvidia.com>
 <ZGuFu0VwRfZszABB@arm.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Tue, 23 May 2023 09:52:55 +1000
In-reply-to: <ZGuFu0VwRfZszABB@arm.com>
Message-ID: <871qj7apgp.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYAPR01CA0015.ausprd01.prod.outlook.com (2603:10c6:1::27)
 To BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM4PR12MB5376:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a146b54-823d-46e3-a57c-08db5b206b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbYSZVmYWs8AbZz8JXElmtUCjZaDlJY8BdaUxU7UrEyTubyyw70yGhXhoyWdvPK7mKPd6onW8/o5iqG2OaIFRy8f65n35iYOvulgVq9esOy/8xNPxXyn8HcnNsnGZYRVqDI30nBzocNu4gFc7X8b+CKX9G2q3RtAMkqqEPqKWxBeMWcVQJrGGDKiGucDmxwLyDPNiyg3Qh1pUgiX4+s+UMb9ztCwMkuSo34mx5jpJO9Ws6OiwQrFnyCIOxXFnSc4K3lZdlOZWRc5XjubYDzvTipSWqaJAyPjIxdHoZ0RwPPQHTRXiWN6p/FP/uCgEH+3Fr1LjbgbF57JGWI84GLJWEs+71D5Zp7ZZr/DmVhcsiGE5GU3UQYvEZwlCKMWDJ222zCsGLdKP4zwV3wtv9q9L2JZL/Q00zAfPcA0S8KvkJRS7bKP3qF4jZcUsg3WauqQoWbogQbPA+1UVlt6AfmAae4AidAd3ZCyvpHhMXQdG6lD+1ppmU1Yb6vzPEMdHXOE+JJ3EYOA4f27kimIWBECWZK4G0H620i+yihVLvLGt7o4kmCbK+LC3+4WjjENggsO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(5660300002)(8936002)(8676002)(86362001)(26005)(6512007)(6506007)(2906002)(83380400001)(2616005)(36756003)(186003)(107886003)(6916009)(66556008)(66476007)(4326008)(66946007)(316002)(54906003)(478600001)(38100700002)(6486002)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OS4EIRLciq5J5mZQbFaUcJuhyRB0F+pPCAr+LQlgOAUvlNqJtAoiV84SzQ4H?=
 =?us-ascii?Q?0W9nA1d8ZZZ/3K1Lw5i2uVIeCHqoEnZcOHfte4R934cXqSY7qGhwjjoVin+1?=
 =?us-ascii?Q?M5JibU+rkweB6vRuIdFT1+JuWNSWXkq5LpzLvM1QO9WpqnRHnztPcTl2KW6d?=
 =?us-ascii?Q?TvwMrMinXdOk8ojewlnm9Zrwm+ZUtd4uusdatYEFvSDVuHAHP77rDZJ6+dyO?=
 =?us-ascii?Q?fr5yV7LgYnKdHTtwMIWkHYDaX79hNXjuk0bSRfBW91osjo/628jDj/+w85k5?=
 =?us-ascii?Q?pZAU6a0XR5BBpcXzJAKI/y4H5JdKWh5fqHvMEQ2FDv7MVTOQ0J9ShLGtGbFm?=
 =?us-ascii?Q?kd3UxyigS6q4MsmWb4DyMhwa2UuXDcsD6uaaqFOvlIZcAEf0BWms2FaelINx?=
 =?us-ascii?Q?1ilLz5h+cNwXDL0vMzuHJcl0nqjAqcShEQxVxegEm1DhLJoG11ZQFaBXchhU?=
 =?us-ascii?Q?zQELpHG+n3lnUA5oyGP/HsyAxJRFYmUNATlNstB8ozQSB/hIDNtkp6lXpA9R?=
 =?us-ascii?Q?RDO+4uOXMWOWFCyZY++3/dIS8ivo9opBDZ0upBtddlWwyHPJ7Wz6WqjbI/1t?=
 =?us-ascii?Q?fONZL+PUYZVbXur3mM1gbF0oglOTstqWoMk34mxuT7GVdS96sWRIghdT8bvo?=
 =?us-ascii?Q?mQhxrzK5GA0WzZM3tAXaYcfT5aHqemfYqMAEkUQo0GSOrSfxcxqseL57AAQv?=
 =?us-ascii?Q?S2pc8d49YOy5pdHNMLvOO0X6rdKsqnDE0b8ziSqJdVBMRRTjUOi2KPmxxupO?=
 =?us-ascii?Q?9uIKSP3LDCr7ZIw0eG74UugMgcrr7qFpJn9FTQpg3i+PR4YR8wMIgARJ7Jmo?=
 =?us-ascii?Q?qrmlcd608Dw+2Qm7jtzOXYdwTGpxXva9QB1hj/y6VUsVtxBx8rqoWZl0m4LU?=
 =?us-ascii?Q?soBq0fHL9tJE7blgDGrHwNDU9t8FMLUCzj6X31SGvrkUtDC9pcRsNoo/iAoa?=
 =?us-ascii?Q?grlUlExpKZF+tI0fwA4Zp+mblUBxP78AX+K/kYD2AK7a5QJ4B7ZB+xtg2uOa?=
 =?us-ascii?Q?w9RXcl4L67GNbfQSGZyWVD2PkWxFTldf9xMhmu9u8UZ/InsunNMcy8vY1PNE?=
 =?us-ascii?Q?C0SUpg3FCnoMHj2biopCq7grU/2eZKFM8uhOgS+RRDnbcJaXh7F0F7MOwvzB?=
 =?us-ascii?Q?yqBnENtLSKsT5+QKrEQJHfZEpBTIayf76S6Hg2y5+0J0x1YqCGEZ98ajtfIh?=
 =?us-ascii?Q?TU4iu5xAd8d9IafRxGIHAA00V4c6QRmnStxV9/m11kaSsLGINB5N7I/qvxN5?=
 =?us-ascii?Q?mqP8hF1/q5d08PAwMylyUQxCE9ws8ipSHAao4XdhPFq/uJvflQDb25XTaajm?=
 =?us-ascii?Q?OLEUOAEOFa8/db+t1BQW50OBN35cyalrCveDs2Oya+Vpq3Znc1RBvhEdhgPF?=
 =?us-ascii?Q?AvfyVDmlNVlwJL1YhVhKjmu/yHvVm9DZcB7MBJcxsuP26u0LNwSP3ZpIISO5?=
 =?us-ascii?Q?OhJXrjByqoaj3F6aqxDIPQ8HQAAqIT4Jmbe212W4Z+jiJGtkBttteTNmajDa?=
 =?us-ascii?Q?a2sC92ctTWWb5rw2K5SYyjOaJqT14gpSCllRLvq4KwtaBvOGaQcx0Lpeh3Um?=
 =?us-ascii?Q?R6jmAovWwGRKNoYzW0EyPlcD4PkxWfdEcuQrq0FQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a146b54-823d-46e3-a57c-08db5b206b33
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 23:58:20.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10tYqOu8apmS8QW1IgqFW62Tg1P1Ah8sPUiY2HzypjslRMKjnIncV7ziDn9ITB4Eo34typB5uIzJCwdIiQ4DlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5376
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, May 22, 2023 at 04:37:25PM +1000, Alistair Popple wrote:
>> diff --git a/mm/memory.c b/mm/memory.c
>> index f526b9152bef..0ac78c6a232c 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2098,6 +2098,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>>  	struct mm_struct *mm = vma->vm_mm;
>>  	pte_t *pte, entry;
>>  	spinlock_t *ptl;
>> +	bool changed = false;
>>  
>>  	pte = get_locked_pte(mm, addr, &ptl);
>>  	if (!pte)
>> @@ -2120,8 +2121,10 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>>  			}
>>  			entry = pte_mkyoung(*pte);
>>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
>> +			if (ptep_set_access_flags(vma, addr, pte, entry, 1)) {
>>  				update_mmu_cache(vma, addr, pte);
>> +				changed = true;
>> +			}
>>  		}
>>  		goto out_unlock;
>>  	}
>
> I haven't checked all the corner cases but can we not have a
> ptep_set_access_flags_notify() that handles this (and the huge
> equivalent)? It matches the other API like ptep_clear_flush_notify().

Good suggestion, thanks! I can make the implementations architecture
specific too which helps with filtering on platforms that don't need
it. I had assumed the invalidate_range() callbacks could sleep and
therefore couldn't be called under PTL. However
ptep_clear_flush_notify() already calls invalidate_range() under PTL, so
we already assume drivers don't sleep in the invalidate_range()
callbacks.
