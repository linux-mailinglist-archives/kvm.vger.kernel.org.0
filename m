Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC55878BEF1
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 09:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjH2HG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 03:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbjH2HGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 03:06:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB2B19A;
        Tue, 29 Aug 2023 00:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693292762; x=1724828762;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e6NnAAS03sHW+trWl6kjM+KtsVhJseGI1+vlA9DdJ6U=;
  b=jW3sseIwolDwPDDUJGOjU834RXsFXPYVDQ3qfJY26iW6EBNIzo/qzMoh
   ombb1WixxA1dGJ46wNQpddufgfERWVPY6RB3dblRvo0CMOv+Y3gLHq9gI
   FGOO3LnDLv23c6NTnuhL5RvA2Qu8vQLDLvkXlmHK0Mvy7FZxPQHDM9/Ni
   86K/UzCSUYjQjoI3h2jlZky74imjepGMcyQGp3dblkGuwj1VJCzwxvR3Z
   KYVSFvQOuBxY21UfmH7tzO710lBeGODzF/E5/DMx4/ksxHZCRUZ+7okq9
   Cz+fDfYFBAvcyMaRT4dMwL2jyTJLa9MvgXbde9eUGgYyIHyYdL6l1GkCF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="365498025"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="365498025"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 00:06:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="741706640"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="741706640"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 29 Aug 2023 00:06:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 00:06:00 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 00:05:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 29 Aug 2023 00:05:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 29 Aug 2023 00:05:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG93lpwLg1PhHmuu985FJiO6zDMZwDgp7Vg7441f9mzwBSo0vzKj+8+F3vh6dT/TiCtqUAG2Xpx+euXSc+LHAZyG0ojJdTQPqVJ53csgLILYaSAJUtpHHXadJtSnv+6Tm7bmcNAfq3YoYFymtVjnN9bTkjMQRD4UDzHSouQXYlHd8/uXQrYxpiJft6W76e1VeI0w935i6dJfMsGG3yX8v+DzIAErKeB9pkCXllE96SsoTepWfv0xpe3tL8gfH1tLNnPoutFhSpYogQIZ4zQv+qwtgayXCgnQqMlgu5MeoHM4rUUnFiy3LHL4QCLX5VSjY4h/kVRypf3Bbhbbog2RIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5QYE7lT51LPSuyTvevHVT184S1TnNZHCd7ZYrsiI2s=;
 b=O5p8gBPy4u3q3+63MKhZanWqkx18g/7h8DxMWCl5GNOL6LR/glH9Mz0utn4qm3CBjCmGK6dw3ChnMEGEcYAfWt53WhwfQRpi7OFIvO7PGFTk0x3I/WrZqF2mQ1RxEVWcYNRyJuYoxMcGvDgvatAoQqvku/8C+ZVbirXE2Tq8VAE7IOCo7/O4BgBKIelpadCJMn/heL3I1F16uMKxi3qHIfzoo89t66sTsOHPP8c9JVQva87TC7dgOP70Sfq4vn8KB/1QzW/62b7xPcNcNGdDDnyRer7a0AiZ+pJvMWugjsAhSXUneFvR3jUTXLUuXQe4IeOtLCpYvr6KvArUgPVxwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
 by DS0PR11MB7831.namprd11.prod.outlook.com (2603:10b6:8:de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Tue, 29 Aug
 2023 07:05:57 +0000
Received: from SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f]) by SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f%6]) with mapi id 15.20.6699.035; Tue, 29 Aug 2023
 07:05:57 +0000
Message-ID: <78cfb090-f421-c03c-7712-0f47b03c5064@intel.com>
Date:   Tue, 29 Aug 2023 15:05:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
To:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <peterz@infradead.org>,
        "Sean Christopherson" <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
 <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
 <c871cc44-b6a0-06e3-493b-33ddf4fa6e05@intel.com>
 <8396a9f6-fbc4-1e62-b6a9-3df568fd15a2@redhat.com>
 <2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To SA2PR11MB4972.namprd11.prod.outlook.com
 (2603:10b6:806:fb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4972:EE_|DS0PR11MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa22987-fa75-4141-84af-08dba85e6460
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pkL1iqPsnICit0SARI3GXnwOWwjbKJt71x25Z4coFksCaRjXcNhBiF3s+ZfbQuF+y2eQjemTXaYu9FhZNe3TuqDD/iKjNi2a+Mai6Sh7og5d2j3qV3esXwebOF8sH7UiPaLLbvAcBP5U2daOpNEMoASFTk/nIWmys1hpw2vXgmfhTZtE/Rd7PDz4w0olyrHSF+aGBjoDpscQgQPT2VsnSNtQImmenY9D9bHzjYfRtgRn193kaZQvkaNbbqthmgBvIThwOrwftGm/iT/ezQy3iLnXQP1LMI/q8rWkGBMf5/YYloat2OXfvavUrbJTK//Ru45gPhsp0slBxko/ULYrSECa+QjdgUaM8oSVeziYojlcoIwG5u8vTu4gOPkJeTjtq3ROF1CUnXvbvgr+26zg8hofxXH0hQAQf6GHVJV4EJeprPW9fclBHukJBJvWnWbnD00tr546vfJDJj7Lf3ovLsTYBA8qAg90JBjsM6Wgr+j9Nhh3LP3rblmuK3ZyaumRAVySGYboa8v8nSbrPycfa+1z6WH5G+6kLkovuunU7IxlKeRMUShx3RszWZ23syjhOxj4D+qm8UZEwzzFy0JQicPMoQk3dFhUDD6PjtvdlXjHY37fIg9lqMZ8u08NaN/DajYsczjUsp47sRhPm4H5VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4972.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(376002)(136003)(1800799009)(451199024)(186009)(6512007)(38100700002)(316002)(41300700001)(82960400001)(4326008)(2906002)(83380400001)(31696002)(86362001)(2616005)(36756003)(26005)(5660300002)(8676002)(8936002)(6666004)(6506007)(6486002)(66556008)(66476007)(53546011)(110136005)(66946007)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0Y3NjN0ci9TOTdRMWVIVHNLdkpVK0dZa25DZnd2SGlsbjVmdVNEZkdKa3I1?=
 =?utf-8?B?cTZnM1VLNi94SFBqZll0V0hBQ2lrcFExYWxmM0dOVjJ1QnRkWnpqWDZ1elVC?=
 =?utf-8?B?MmU5RmZvUU9ZM1hRL3RSUm8xU3N3WjhzTGlpYnhmQ0VpRG1XcExxa1JUNXI1?=
 =?utf-8?B?Vi9vMjdURnE1VGp5SHRHNEJaK285SjBoT1FqckxNVUtvRW11ZWpJZW5BSnlQ?=
 =?utf-8?B?UXFaTXRoTHc0dCtCQ2h6NG1saGhuMGtYUWUvZVVUZlRJVVZoT1huYWw3NlF3?=
 =?utf-8?B?d2J4dk1VeFVldFVBVVdMZEIvNDlwZkUva0Q0UlhWdU5rOTVGOFhFb3NVSXNJ?=
 =?utf-8?B?NHh1T1FiY0pSS1hyb2JteE1lK3RlMmlrL3JIUG1sQzZ6UVoybmMwU2I0UDJi?=
 =?utf-8?B?aU1zRzdvbXBQd0YvZzVPdlRwalo0Z3ZNNHZ5UmN0TlQ4K3VGWmtGaDlMVnhE?=
 =?utf-8?B?MDM4UERhSmYvUXdkemhnZ1lMVTJ6anVBUGN1VktvK1FtblBhQVpsQjIzTlZn?=
 =?utf-8?B?VUZiV0ViS3NGMjRWSGYraUR4NGZnaVBpaEdMc1NvL29HUHpZK2tteWg2ZG5w?=
 =?utf-8?B?aVVOa2pnMVpWcjIvTGVLUCtHN2w1dWQvdi9mSXVCS0NQdGdYbTVjVXoxL090?=
 =?utf-8?B?eTF3Q0lYaDduT1ZqMThTVGtoT1Y5RDBNbW1NVnlGTTlXbDI2Qi8xK2t4b0xK?=
 =?utf-8?B?K0pVOThERlhkc1AvV3h3aVl3bnZPUUM1YVROaFNjNnBtc0F4Z2l6K09ZTExM?=
 =?utf-8?B?VGNxdmFmTFFiVmtnWk9lY0VsZkY0eEJhaVhUcWdoM3p6b2U4cGFCaHVBL1FQ?=
 =?utf-8?B?UG4rZ3MvZzM0ek1FM1ZhUWVNTVRIaU4wSHR4NVhGbndyN2F4dzl6NXlQbzNk?=
 =?utf-8?B?ak5oL0FDd0V2ZVZNeHpsZkpsNE9lQ1FpTlFCcUx0MEgzOS9NWFBIS0RYZlBK?=
 =?utf-8?B?S1JDMXc5QUx1STV3UTMzbnZiZmxGUGNvcTBGRzJ0SEJRbGU1NndiQUZxRHVp?=
 =?utf-8?B?Tm9ZT3hQMm1NOHYyTlk4bnl4TEVxeDVuekgrRm4yWWJIREg2R0hwcXlzQzFY?=
 =?utf-8?B?NXcxanZTT0FkclkwY1d3ck5FeTlka3VGemQ1ODZ2YUJtZThyVFJ3bXhFRnlU?=
 =?utf-8?B?TDBEVVVLRm9NR3NrT0dCL3hzR2ZobjRtMU1pL202Z01lOWhMTzZ6cFc3Vktx?=
 =?utf-8?B?amNsaU1sTGhwbjhvc0lnRkpSVGc5QmRFNXFJTkJ1LzRLSnNqS2lLT29tZEFh?=
 =?utf-8?B?YlJIM1dTNXorbXBIM1VTazMyMjhqK1dWZGxGcjE2U1JOUTJpWGVmQUxSenJQ?=
 =?utf-8?B?NHRoNGFWWkppS2ZDNEI2dnkwcnpVb1hpMDJneG8vcGlpZDRPYTdLK25RL214?=
 =?utf-8?B?cFFHRkdkekpIbjZPdWpua3phM0J4V1psQmdiYURpRlNwSFI2T2J4VEVnZ05w?=
 =?utf-8?B?NFl6QVVKRy9CaFRhZWd5aDgrRUhTU2tXeVFSd2o1ZW5QQlZpUFkrNnRIaW01?=
 =?utf-8?B?S2RHSENYanhDUGJLdVhvblhPalRmUUVyb0RBUlVZQzBkdm5FOW5Ea2Z6ZHkx?=
 =?utf-8?B?bDhxN25tS3JwNkhjQ1dmZzRHSTIrY08wZVpKOFRJUFZOSEppa2I4VnNJb1Vu?=
 =?utf-8?B?aDE4TzgxMW5sTmhBK2V6a0hkNkdvQjRhelVzYnMvQUhYRmpmOTZBNmpERURG?=
 =?utf-8?B?d0toTFQ4RW1CY0o4VDhacXFxZWFlRmVZeit5QnBwMUxmWXZHWmN5dG00NW1K?=
 =?utf-8?B?bE5oN1pkMEU0cmJ1U3ZNWTlDS2VJeHNueW9TalRGSU5zb2I5VjVvUjJQdmlK?=
 =?utf-8?B?ZWRodWlrSlZldkY4d28wam1sUVhFU2hPMllOVmd1cjF6L3JkTWhCSGpycitL?=
 =?utf-8?B?WXVBRE91S0lTOTM0NXVxbUJDQXQ2SThtMXlheG4zRUlwZXdzVWJ3Um9BN1h6?=
 =?utf-8?B?K0tlYXNzS1l2aDcyc0FvcnZyNTNPaHJxdzhidlNYOFJEM3k3TzlrZnUyb2hN?=
 =?utf-8?B?dzd4czZVa3BlU3hFZWxZZnEvMFVKcXdISHo4UktUSHRnWjJtcWxvRkN1NTRM?=
 =?utf-8?B?QlprL2NBS21RdERlbm1Gd3Y2Q2VoY2ZtRUQ5Z3VsM2RYN1I4Mm9tejB5L1I5?=
 =?utf-8?B?bXlTYVpmUllVL0cydmhJdm16VFdwaG1KMk94ZE9uSWFzYXpVU3hKQXdzK2dt?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa22987-fa75-4141-84af-08dba85e6460
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 07:05:57.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XF5RxpcF9OS58fui/Plb6D+S4cZ1JQ+ibw/dsNEae6iydCCjxrOrmA1EQzcZA4GsRlxFJcicHwwtxeKnmTI/dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7831
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2023 5:00 AM, Dave Hansen wrote:
> On 8/10/23 08:15, Paolo Bonzini wrote:
>> On 8/10/23 16:29, Dave Hansen wrote:
>>> What actual OSes need this support?
>> I think Xen could use it when running nested.  But KVM cannot expose
>> support for CET in CPUID, and at the same time fake support for
>> MSR_IA32_PL{0,1,2}_SSP (e.g. inject a #GP if it's ever written to a
>> nonzero value).
>>
>> I suppose we could invent our own paravirtualized CPUID bit for
>> "supervisor IBT works but supervisor SHSTK doesn't".  Linux could check
>> that but I don't think it's a good idea.
>>
>> So... do, or do not.  There is no try. :)
> Ahh, that makes sense.  This is needed for implementing the
> *architecture*, not because some OS actually wants to _do_ it.
>
> ...
>>> In a perfect world, we'd just allocate space for CET_S in the KVM
>>> fpstates.  The core kernel fpstates would have
>>> XSTATE_BV[13]==XCOMP_BV[13]==0.  An XRSTOR of the core kernel fpstates
>>> would just set CET_S to its init state.
>> Yep.  I don't think it's a lot of work to implement.  The basic idea as
>> you point out below is something like
>>
>> #define XFEATURE_MASK_USER_DYNAMIC XFEATURE_MASK_XTILE_DATA
>> #define XFEATURE_MASK_USER_OPTIONAL \
>>      (XFEATURE_MASK_DYNAMIC | XFEATURE_MASK_CET_KERNEL)
>>
>> where XFEATURE_MASK_USER_DYNAMIC is used for xfd-related tasks
>> (including the ARCH_GET_XCOMP_SUPP arch_prctl) but everything else uses
>> XFEATURE_MASK_USER_OPTIONAL.
>>
>> KVM would enable the feature by hand when allocating the guest fpstate.
>> Disabled features would be cleared from EDX:EAX when calling
>> XSAVE/XSAVEC/XSAVES.
> OK, so let's _try_ this perfect-world solution.  KVM fpstates get
> fpstate->xfeatures[13] set, but no normal task fpstates have that bit
> set.  Most of the infrastructure should be there to handle this without
> much fuss because it _should_ be looking at generic things like
> fpstate->size and fpstate->features.
>
> But who knows what trouble this will turn up.  It could get nasty and
> not worth it, but we should at least try it.

Thanks Dave for clarity!
I'm moving in that direction...

