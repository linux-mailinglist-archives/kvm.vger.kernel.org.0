Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CBE542654
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiFHEwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 00:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiFHEvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 00:51:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07EE26180C
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 18:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654651032; x=1686187032;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oZ2EvwfH9u4aA2qQnO28HqE9EhdiVd2zUzQoDMGpoGo=;
  b=I5bbnl7uMVg2InPaAZo4rj2z5LAfIBySKdx6dN2D3vP6Cc9MzTqs39+h
   Z8fF7WEGb5fcFjQlmfCgGxH7xFQqE7MnW2ibQC8FT/sHto25YNySS0ld5
   q7GuAmJaqgD6qBMPIxjVF+MtF5tuD48y/vkEAI1uBBmokPCtHVB8vBb8N
   yP8zd51yMRRIByo1JrK1jx5BXsS+tKCnP8YPGkKNaClXdPZOGhRkcP/Sl
   tz0rh1JTA/AtHI0rN4TsceVBBtyEn02Rjw3xPXJh+ePKUCntLJlyQFNrY
   0d5UE+LHpBTnQ4uM3vJ4A6B4+Lni0i5Tbf4X5pN1WW2T3N66CBhDVJ2o1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="277517761"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="277517761"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:17:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="579838318"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2022 18:17:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 18:17:11 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 18:17:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 7 Jun 2022 18:17:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 7 Jun 2022 18:17:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFZ2+db7CFuOQ+iOzWd59a/NkJc05Utmd4jnCgbWvUxzQremnCB3BQl4OuvglVEns4Lg9CovcQ7mT45aDuqNo69zyStAbVT2HfkKYB6s7Roo1iU/1FwYVYcfvIdZJYgJS5MSVJp0Q0x9yfI8kuJ6AHbsJq0wi9+ZT3mg2I6EIYIwa/14wZQqOa+xJNED8WxYDy7RukolC2laKoQ84Z8zRNbnhJd3Wal7yRw6ooq7LugQBT0zKdbBd21vqiH9CDbE3wesO7LEAZo5N13GMTyVHD7BfLVrKpQzgOoFz3uCXYc1TYZGwrDo3p2NnSP3L22X0Z6CTXMSffpAd1vAgXKTlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHt2t1RQUmPiw5HwaH3FICqR2k0Zeq1ynrP0ZABEW7E=;
 b=mwJLhb46RYZL/vAwC5S6DsqeoWm3B7N4Jcf3jvNYJ+0a7Y2RqsBo55m4nnEvTgOhcqETivzMD67j9xLSpggFpoqklzdbK76OJ3Weqce8mqn2nFsxZwgpzFPDS7CTy37eMixjbwKvhsA1A1jJYALaOyoXJ5qPEvvNFXZQIz87VRruLLR7QBNLK6MPxfM7HNoyP0+SsbxfobZTJBn0McL0NVrQIOxu3Nmr1jw9eeS//IZfIHqH5ziPYyza7+A+lDe1gx7g4dcICjyDzUPxn7TgfWXii83G7lL3C/LNQAg1UtLZpvQDy/jTWalJDnR4ilqNl9u5XTq5KLCfwnZISdoauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
 by PH0PR11MB4773.namprd11.prod.outlook.com (2603:10b6:510:33::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 01:17:09 +0000
Received: from MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::e819:fb65:2ca3:567b]) by MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::e819:fb65:2ca3:567b%6]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 01:17:09 +0000
Message-ID: <bf7dffb8-55d2-22cb-2944-b90e6117e810@intel.com>
Date:   Wed, 8 Jun 2022 09:16:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH 33/89] KVM: arm64: Handle guest stage-2 page-tables
 entirely at EL2
Content-Language: en-US
To:     Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
CC:     <kvmarm@lists.cs.columbia.edu>, Ard Biesheuvel <ardb@kernel.org>,
        "Sean Christopherson" <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, <kernel-team@android.com>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-34-will@kernel.org>
 <Yoe70WC0wJg0Vcon@monolith.localdoman>
 <20220531164550.GA25631@willie-the-truck>
From:   "Huang, Shaoqin" <shaoqin.huang@intel.com>
In-Reply-To: <20220531164550.GA25631@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0152.apcprd04.prod.outlook.com (2603:1096:4::14)
 To MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438d3a32-cd3d-4964-db8f-08da48ec9bc9
X-MS-TrafficTypeDiagnostic: PH0PR11MB4773:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <PH0PR11MB4773411296A55461943155BDF7A49@PH0PR11MB4773.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQnie/QeDonSdFTmxixyHvNQUAP70L5RiTs8+ymvsq4NK406XZbxMmCl5vQApjW05bAGLGIvmIU3XKS42tOJ7eQltu8nTNyIuFpv7cAHmE7Uy68JhLyNKvOSPiX16m9O9GcB+OsdFP0FPtyWD3n2/jBjW2v37iq9pMi1DzeBLcfzuuZzgRFqiPEmYXhVb8ZTiEpF4c6o5S7udQFSY57xr+LZrXhQgjV2e/RezuBa+3Q6x/XUQ9VHl+nSNv+UlRC1Ec927wO2tNj94qP3AQZkyNtgHJgko1u3vzmNteqnxXieNcA6w/A2k5ccPEd0JT+X//KH9SQ+HmmtULUTz8YTXdQyDze6ybBKiJOjRgtweomGBzh/Rtpx5bLiQhTBv0lK4Njzk2jUD03w4d59XV7pVqfC9mR2cOc2pdydj7PbBddZ+8JnTzGaSr9gU0SwK1mrUKwDXZ7p/Bbh4dEj5ezybkJ7n04wXRblCeERXlkdIaAlKVfuDHOL+opbinR2wFI9vjmfFz224qsgqzbgJSuNrnhWq0/cFssciEZCbv6AQkhuUona3ZhF4vanLE+K6V+kA+E+kGREDl/yWrGZlzF9ceZH9UsZ2NekXCWJG09W1Cbvw0xoZAeVMG247x2lru+Ep/7jW+gpjuZOsaBq4TBgGiY3XD58vqjf6wnmPAEyeC4OJxtBGe0lBMzXnWoonobr8yjheV/qa7KkAguoFwYdLzwNHY3yphdtSJQXAJKj2NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(66946007)(4326008)(2906002)(6666004)(83380400001)(2616005)(6512007)(26005)(110136005)(54906003)(316002)(6506007)(186003)(53546011)(31696002)(5660300002)(66476007)(508600001)(82960400001)(8676002)(38100700002)(7416002)(36756003)(66556008)(6486002)(31686004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHo0SWFYbllqWXBGQXNTMGwzZ3FCSnhwaDZ0ZWZJUU44MElTZWlqUzBzR3hy?=
 =?utf-8?B?U0RxRGhtbVhvT0tCTFZmZGtEWkZEZ2pZeEdBeEtEOC8veU5YbytvM3NXS1dP?=
 =?utf-8?B?RWE1RzZoeXJvWkFHVk1sL2VnNnkyY0N1dVRlMFB4a3hibVVWcFgxelMyMVZn?=
 =?utf-8?B?RmxzTG5xYWxWOW9CSmNWZ1NLaUVUcG50ZzEvOFU4ZEpudXZqcG9yVHhqcnVI?=
 =?utf-8?B?clNtOUd2bzB2ZHRzRVBiMEVSbmdzTkNKd082Zkg1K2xnRjluQ0hFbVVGdnRN?=
 =?utf-8?B?OWx3UUJvc3RSYUxXamtZZnllTXF6N082Q01ZMVpMUlhObkpVZVFqRE9HaGN3?=
 =?utf-8?B?MVowbkRpNWQzUzdJUFpSbGFuYzRUQlFJL0RYMnhvL3lsTHVLUVo5WXNCc24x?=
 =?utf-8?B?UVovWlJQeWVyS3lmUXZhSjREbjhZYm12TmRGYktIWElkUk01RUM5OHNTSzVv?=
 =?utf-8?B?M1BrdHkwaG5hc3IvZmhUZ2ppQjVnaGVzMEtiYWNjeGo1TDVOSTVyQnN3RXlB?=
 =?utf-8?B?WUVMcmw5aGU4U1lMTUJKcmpPaGhsTXp0aDJDUFFWdFBFQUZxNXRyT3AzK3dK?=
 =?utf-8?B?eUxLT1VFeVRCMVFSSFJyYXVZeUpUS1crekI1NmJRTjdMU3ltbVpJdGVxNjRW?=
 =?utf-8?B?ZVA5UGFkK2I5QnJsbUZwQ01oOFA1VmpQbEJzNGdvZUdQRlVHK0xzenljdm5m?=
 =?utf-8?B?cmQ2TlMra2hzbHh6Znl5TXh6SWtad1lSOEFEUlYzWU5mek1SWVhOQnRvbG9E?=
 =?utf-8?B?SkFUK0ZsRXBHRElzSGFOQkpLbWhNU2I4bEgxZzdvdGw1OE9ScjNWakNBb01x?=
 =?utf-8?B?YXdLckM4aGtxc254dnlJMG51SmxhRE1UUUhBbmEveko3RUdQQjZablN0cGhs?=
 =?utf-8?B?dFAvSnQ0TzFyeDZaS3pQeDZyenN1K3EybExYTzNqSzMyU1dJU09vaVNOVERz?=
 =?utf-8?B?SGFCaExseTJibE85L2tCUHZjN0ZxTndJK3N6NisyTVVYU2poR0QzZjU3M3hY?=
 =?utf-8?B?M3VPMUN0cFU0cm1LalJHWXR3VjBoZ0pRMVFLT01UdDR5WWxDQ05OQ1F3Zlds?=
 =?utf-8?B?ejd6TmswS0VQWExZemsraFhydmNPM2JjQWVCbEJwUXB6Y2VQSEhRak1UMFF0?=
 =?utf-8?B?cXcyek96YVMzakpPY3lTR2wrNDNHU2FmRVdrRnNnWTJxL3M2cTdock1ZU2VN?=
 =?utf-8?B?a1ZWaUIzRmdnL3BsNUNxN2w0VWtmME5Vd0NrNzZ6T3JJY2lRMkZuWUkwYU9I?=
 =?utf-8?B?WDViUFp1Ky9SbVpRZXlhSFV4U1p3d0d4UytBa2Zzcm80ekJIRnZSZTZTbWdL?=
 =?utf-8?B?U3c5YkswZWV4UEM1dTl6bVhIK08vVFZxWEZvN3FHWlFSODVrS2JjVzhzdjVO?=
 =?utf-8?B?Tm84OHVFMFJTeFNuamo5clk4UUF2NktLSm10d2pOYTAvc3ZCUDR1eFZxSndp?=
 =?utf-8?B?b1lxRHdpOEdHVWkxQ1JaSkhBS1FBdDd2OGF5YWpLa3JidkpXMG5QS2JqR0JY?=
 =?utf-8?B?RW9LSnNQS0lTK0V4NWZRbCsrL0FiL0RPNmlLMkFaUXMxcXdKaDlyN1pZYzNJ?=
 =?utf-8?B?S2FvcEg1Q0RrWU5JMldoTGdCU3E2Snc0ZE1uby8rOTNSR0IvSjhzSzZaMDlo?=
 =?utf-8?B?UlR6SjE3OW0vU1NtOGVybXQyZGFCWTJzSmxOcHZqQnN3WWlKWmVENC8rMk1z?=
 =?utf-8?B?cDFabXBObG4yc2FTOVpSR0FEQUpFVnF5dkF0SGJEZElTT2JPc3BXSWVkYmpS?=
 =?utf-8?B?ai84VG9KTFlEOC9TdVAvSU9OekFnOXBtbUlvL2o4MXZGNWxwUzB0SFAxcDhH?=
 =?utf-8?B?blBVb1JTZkFKaFZOdDB0enZUNUtRTEQ0akZHcVM0YW5QZEtCRk5aYkRpTW9y?=
 =?utf-8?B?WUozVGdOd1lxZHpYa1YwK21hN2c0QXBrU1VTNlFrdERtTjFmZVhJYTlNZkhZ?=
 =?utf-8?B?SVBER01KQWh0WUUxanBCZ2Nkc3ppVDVxc1JXTlFPNWJ5N0t3aXdFRlRiVWgv?=
 =?utf-8?B?djl4ZmZHbCs3U3h6aTluWWhvOFpoLzJyMmdHdUFoVVBNYzdiRys1d2FqWVAv?=
 =?utf-8?B?SWVid2VkQkNSOXZPSjVTLzFic2dPbWFNL3d2RTU5MFlFUzc2MDFVdHFZeENM?=
 =?utf-8?B?YzR0TGYvcEtacG5iL0tDSGd2QnhpdnAwZlhyVktOczdmM2lET1krdU9vdnAw?=
 =?utf-8?B?Z0lCZWRJOGptU0VWNmNnZGFSVGx2bU9qUzNsZUdpRkVXcDZCQjQ1TDQ5c0ll?=
 =?utf-8?B?WE5zcTNDY2ZhaC9QcmtoZld2SHlyWXp6U25YQ05ISkhWQUZhRy9kR1VvSzJT?=
 =?utf-8?B?QUUxU3M4QzFZeG9SbWtqZldxcWR3M1dwVlJWQXRZUWJObmdkcWgxRXpLNlRw?=
 =?utf-8?Q?WOrHcbX2gR9UzAG8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 438d3a32-cd3d-4964-db8f-08da48ec9bc9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 01:17:09.4056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUOe2XgZTA7VNMaCEz3/ADcD/dJ1pschZdCQ9Qln2gqO+mS7iFVz2Zhk1bllgGxpPe/Tyyo+0pQDdxTDJH2t5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4773
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/2022 12:45 AM, Will Deacon wrote:
> On Fri, May 20, 2022 at 05:03:29PM +0100, Alexandru Elisei wrote:
>> On Thu, May 19, 2022 at 02:41:08PM +0100, Will Deacon wrote:
>>> Now that EL2 is able to manage guest stage-2 page-tables, avoid
>>> allocating a separate MMU structure in the host and instead introduce a
>>> new fault handler which responds to guest stage-2 faults by sharing
>>> GUP-pinned pages with the guest via a hypercall. These pages are
>>> recovered (and unpinned) on guest teardown via the page reclaim
>>> hypercall.
>>>
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> ---
>> [..]
>>> +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>> +			  unsigned long hva)
>>> +{
>>> +	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
>>> +	struct mm_struct *mm = current->mm;
>>> +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
>>> +	struct kvm_pinned_page *ppage;
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	struct page *page;
>>> +	u64 pfn;
>>> +	int ret;
>>> +
>>> +	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
>>> +	if (ret)
>>> +		return -ENOMEM;
>>> +
>>> +	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
>>> +	if (!ppage)
>>> +		return -ENOMEM;
>>> +
>>> +	ret = account_locked_vm(mm, 1, true);
>>> +	if (ret)
>>> +		goto free_ppage;
>>> +
>>> +	mmap_read_lock(mm);
>>> +	ret = pin_user_pages(hva, 1, flags, &page, NULL);
>>
>> When I implemented memory pinning via GUP for the KVM SPE series, I
>> discovered that the pages were regularly unmapped at stage 2 because of
>> automatic numa balancing, as change_prot_numa() ends up calling
>> mmu_notifier_invalidate_range_start().
>>
>> I was curious how you managed to avoid that, I don't know my way around
>> pKVM and can't seem to find where that's implemented.
> 
> With this series, we don't take any notice of the MMU notifiers at EL2
> so the stage-2 remains intact. The GUP pin will prevent the page from
> being migrated as the rmap walker won't be able to drop the mapcount.
> 
> It's functional, but we'd definitely like to do better in the long term.
> The fd-based approach that I mentioned in the cover letter gets us some of
> the way there for protected guests ("private memory"), but non-protected
> guests running under pKVM are proving to be pretty challenging (we need to
> deal with things like sharing the zero page...).
> 
> Will

My understanding is that with the pin_user_pages, the page that used by 
guests (both protected and non-protected) will stay for a long time, and 
the page will not be swapped or migrated. So no need to care about the 
MMU notifiers. Is it right?
