Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB27A706D27
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjEQPrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjEQPry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 11:47:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29203A80;
        Wed, 17 May 2023 08:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684338468; x=1715874468;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vtAp9TzYeFIwnHq/8IN/GBjJ7m3vKJLSB5p50ddiyJ4=;
  b=B/ivbG5Ly3+BwVq8RIRst+D1PMzu43tX+ir6DfTIxdAywMQhwWBwFKQL
   oumAYvvNVILw9W0xxDh9dPLgoQ+QnI/ynyz3//Wpd5Ezd3RI+R5tx4iEz
   fNn6kw+Wb3W7C/0F9iZesA/+1zxUce2dOtabYKWiBik5PxOdOeNs5NBWh
   MUmhjKaKWJbuySBZTHINuofrHMBNu1vNCRTBqYRFdqU0LtUZvLHJ2L6Ui
   nvDEBf5txxrpaX7wvE+XL0YJQGR5yORk4GkmR4A+MSTo3Mj8/docQfRoy
   GZA8MNq0RxuuT30bCt2p0W5/hIz0RwOFGmqsHecdN3Vq/frcUcjjHg+wl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="349299891"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="349299891"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 08:47:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="826007574"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="826007574"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2023 08:47:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 08:47:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 08:47:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 08:47:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 08:47:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L24NDIESyaz2PWcekw102+OU5qV9iJxdXQ6GLH+Lkmpex93ENthjJLUKufuJaA1+z+aXRADORUaoEkE9qKd7YiKnrFtYMVps79mTgBT3FXfTPYqmiMrMm8vKjdK6CuCS/SFanTHc1TTv1k4hzJKJacRme+kfXgQ7Wvlq81tfZMCx3TpREiS75kjIXVFhmbrQmXeTxeZnp++Pj9QzzMlGQ9r8fbX0iJbafLTiKTc9mZRCOtybXJQeD206xm4qIxFSxbHpfk2K3VbqkKWybmZPYgs2LyAzV+EbAIQ3ce3vmfSAwK0Hb4Y0YlRjb7q1PS5aGXIPPSExUNwn+/zDFcYMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTiOH2b/pji99sIDuCgDmgBkuHugJsvrivwmpJVRBdc=;
 b=aBNAN4xH/cJxj6OoUYaP/IOJyCSM/ChZ3XaTzFvhkGI2/J5C2VoqCabOcha/lhW8UhtxUTJp/DCjGp9ZaJAtF2ACM9WhqA9W08Jw9i/g90NDJLNZy5WTkM3PmciyrV/pe12G3DFbb2Y84d04qAUEH1JdqGFLgoAe94loQ/UWHEXo8IZNfo2CRiKK2B38Dn14hoAL78kNxEyGdKcjubF9Q2LsSsNgd+vKNa3WT96tpnKHaIbuxg2JGxm7nt3g+VTihopL4ZMo/0hnnGHRAvtbVr86czGKvQKpBWFBnhMRBEUym0edD0EAC+2T457TQIkjPcNEjgdSYjss+1sI2oJtBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7827.namprd11.prod.outlook.com (2603:10b6:930:77::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 15:47:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6387.028; Wed, 17 May 2023
 15:47:41 +0000
Message-ID: <01bd329c-3395-1942-8bac-08a66b9533da@intel.com>
Date:   Wed, 17 May 2023 08:47:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <alex.williamson@redhat.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <ZGTj8oD4VW15eo6K@nvidia.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZGTj8oD4VW15eo6K@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:303:8e::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7827:EE_
X-MS-Office365-Filtering-Correlation-Id: fd4d8614-649c-43d0-53bd-08db56ee0c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNXAVumbGEodoOJczLmF52nFvHHEKfsdMyAkThVaH7X9szm86K6y+cXq1/8gcbDnQso79k8KtnAEWZeKtqTAkfqkqcKY0Ye1rEUCIlkrnRNJ4gTrgkT1siCHRRa1Hj/3bcmfZvlsYGaSaUGoO+qyCxVPaRMN8+LM23xSb5LRdz+2J0br8K0uFaZEyMFmHKkDClpbXncDgAnwX7IXPYzdsAgzcKZqbRNsoNZz8FBZf3ATIKitnjQ2Mnwb8QErUnPjOerjo4Teaoo3AckDTNCR3BbKo4nw3Z3hXD33vb/G4LHGVtwd2h9mbXdOcFG36nIEoz2pm4omv6ob15Bmv1bCvSUeP45LO8fs8Xp0Rhj0CEf3F6D+zJqDSjBOg14/784iE7Qm3hUCg8j7RAbL8CfrDPKaFIo30rA5Y9nwhCmeQTvhaUeD6c9a4Y1t40RqqxjBK/9wbGiFXluzNMJ3lTR/I/cScq2sdkpSsZFQAo4PzpfMV+HDatVkrxH6E0tk2s60KkajnKr6C53qcD10SEP/tW9JLkqNwHlkLmwFsRu9LjSDv8cs9gCmyPekT0XvoTA2Pd+dZSJ3bQuDZdSzLvOKUIDyvMBYKF6ZfIDCN0wf0FdOwnuVJ3QcBiD6icT8+blA5FeP0hxdgtl/ZFNQ+g4qtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199021)(31686004)(6916009)(66946007)(66476007)(66556008)(4326008)(478600001)(316002)(36756003)(86362001)(31696002)(558084003)(6512007)(2616005)(6506007)(186003)(26005)(53546011)(6486002)(44832011)(41300700001)(5660300002)(8936002)(8676002)(2906002)(6666004)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0FnWGRiT2o2RWpyaWNIWGpIY1RGVWRFcmpidlZaVlg2dUFLdktnWStuelVr?=
 =?utf-8?B?cWNrS1VUTTBUcTJ2cE5hRmsvbXJSYWRhcnYrTEMxcVQyYTMzazhjVDlHSVln?=
 =?utf-8?B?VzZ0bW9heVJpR1VmQTJWYjJRNktwT0VlT0tVR3hjVDFPUnJ5a1Jpdng4THIz?=
 =?utf-8?B?K3ZqOWg5elJWVTY5cTJqNExPMjV6bkRQWlRiQzdHQzFMKzZXbzFoeDU0R0FT?=
 =?utf-8?B?RWlSbVEvYlI4T0x0SE41YWdYeUFWSnFpeENraFRieVRlay8vYUNCU1JwTjRw?=
 =?utf-8?B?RTZZc2xkenpYOUwxSVl0WExnTW8yKzNNMGw2bFBWYmdyMnowdU42OUdhYzZ5?=
 =?utf-8?B?aDBFWHlCckpaYmhkSzlxVUJYVzlqZDhFd3JHSVFWQklZeTBCelY2NjZRQ2RJ?=
 =?utf-8?B?MG1JbGtwenJQczZxdWV1YTRiUWg3a1BrVXJHem84NjMrSU44UlVNejlPdWxL?=
 =?utf-8?B?MWQyMFFtbUFud05USjBnMStjTThFQUJNRUovNlZsNHh2OHJCdTh0WjBhR3Fk?=
 =?utf-8?B?L3hYaTM2aXhNN2E2b2xabXNzakx4Sll3TndKZzYyazNhU0JDZURkSDBCNm1k?=
 =?utf-8?B?VHhhTGZnNjhJK0R5eVQ5NU9Ea1lQSytubENKOWduUjVuenhUT1ZNaUV3M1ZE?=
 =?utf-8?B?TWw4dVJLb1hEdzlCRnZLOWtWQkhOejBJdWdrNUVTVWt2ZGRzZGMvcmZjQ0w3?=
 =?utf-8?B?TGVkUVRPMjFWbmN0eGp2SW5KZ3lCSWdKUWpKRUN6Sy91WFRleXFiTGFGSnNY?=
 =?utf-8?B?bmptVGxZZG5iMHorNWZQdk5iTmlnb094WVBMYklBNGZVME8rWVJ5aU44bmhD?=
 =?utf-8?B?L25jYzFadURibStMendpTisrVFI3dmFKRzdLV3FwL0pMUVJXOTEyQmFlZ29P?=
 =?utf-8?B?T2Q0dzJUSTdqNG92N1ByempjN0ZicjVsR2NGS1JPbmw1VHVxOWVmbk5lR0xM?=
 =?utf-8?B?STJ3UTUrOC83Z1l0ZzJRNU4rQ3o4T09xL1pRcmllWjNBVmhKdVdtUkFkY3R4?=
 =?utf-8?B?S25ERCtsR2dWcXVuYW82MGxoSGNpV24zWUZtNkpIZCtBTW9Qc0pBamd5ejU0?=
 =?utf-8?B?YzFJSXJCWE1yMDVlaGMwazMrVUxDa1hyTkpwNm5kYm0xQitFR1NiSTI4ZzdG?=
 =?utf-8?B?dndjRG9YdG5LTGV2SVJGZytYT0xoejZoRGR0djVmZjhnNEcxdnpELytFZy96?=
 =?utf-8?B?eFRMdVlrKzhISGUrQVZrZFlFVHRJSG0zRUNFMGpHTVpReHE4RDJ2RTUvTTdI?=
 =?utf-8?B?TGNhNzBkYS9GcmtpaGJBTFNHdjV4bEk1Y25sMmZDWC9qV3NCdU82U3RvZk1N?=
 =?utf-8?B?d0ZSWkFJazZIY0FGSmRuaWJKTUlYbmkvcy9HR2VBekJVNm12ZnNQUVRkV3FS?=
 =?utf-8?B?NXJxR1lKNjhYV2lpeWdoZ2JkS01yZGVFWk5LZ0txOUNPVEdXOWd2SDJiam5n?=
 =?utf-8?B?VGFRaGlaM0FFMEJYSWJkVW5memVjRWZycUcrcFNTcEkwZFU0bmhVQVFxQ3Ar?=
 =?utf-8?B?Qkp6S2hIallLTEFPeDlxdEZsTXNZVXp4RThQNWNDM0RiWDlLenBqbHBiNmlw?=
 =?utf-8?B?SUVVc3YzdDRTQUVidGIxN2FXbDBqcXdzSnBSdUx1TitUR0thQ3hWdDJzQXAr?=
 =?utf-8?B?UHNSTEFvRkwyR0lnb1k1U2w0ZytkemxMcnd4RkZmckVDWU81dlRGRDl0c0gv?=
 =?utf-8?B?ZFY5a0hBd3dlc0NiVDh0bmszZ3dTdER1c0xiY3pvYUVMVG5pSVNNWVVPZ00r?=
 =?utf-8?B?dUY5c1NwdHJvd2NwVDhlZFFNRGM3R2hxV2VkWTZ3RTlqaE9TVGJCa3Vad3NR?=
 =?utf-8?B?OG42MWxWYzB4R2xhMjRRd251bmRjV0dWWGlieDdWNU9wTHJESEVzSzA3cWVj?=
 =?utf-8?B?bTlIbEJoVDJUeWpUeFFGdFIzTDZHenJ2djg5aUMyODVBNzlmUmRSN2x6cnc5?=
 =?utf-8?B?NDFXUUVGQjNucWlvTjZKZWxYSXptc2hNekZBTVBtUEFhMWVhb3V2ZjBuSXJt?=
 =?utf-8?B?UWp1UWJoc1ZsaldLUXZxZzMvSERvMkRZSWoyQ3VuZ016aEU2Q3JmYVdwY053?=
 =?utf-8?B?VkppZXBxRjBzSWhoQlJXajhCTFlCWTJyVjlDcmhJK0twWEpsQm9XbGZhYk9I?=
 =?utf-8?B?T2FRT01ablkyeWhzdW1wdllrd0wxbmFFSVNyTDU5bERRbEVmQlRGWTNleldz?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4d8614-649c-43d0-53bd-08db56ee0c15
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 15:47:41.0484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmN1xG4Hjl6AtfXcp3YVWbYcWLaiFRvLLVEQjsWvfRhVOTACz4VbeSncCpoVb8SabzBEHt+qmHDJwkWxaQXoa+mzebJY1k+3TPT0gT8s6QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7827
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/17/2023 7:25 AM, Jason Gunthorpe wrote:
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 

Thank you very much Jason.

Reinette
