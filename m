Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB436F8772
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjEERVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 13:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEERVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 13:21:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE2C13288;
        Fri,  5 May 2023 10:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683307289; x=1714843289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HQJqRj+GbgcC5efwYq3wat0ilvYEpft0eBQ5tgV0HSc=;
  b=XX4y1RF4k24bD8Djh0ITim7QFAJtcqS3Pusao82jZn85laXiHKhXLbLQ
   UZKNr2FLNNH0YsQKZBIGKJNHRohdnuTgjboiGQodD+ozy7oTRPpnDXc4m
   +cNx1HdCNQG10Hz+cvbtKomSXbHjz0H8zlaPFhdgCs89czyS+lAR/SXdV
   XRkDl9/ua0rZgxVBG0/uuDwiuxJnbvs2pfV+7YWFhdbR+XJTLNHdfBtat
   DvKk+OuXLfMVQU6LXfArtPjbgbIcSv9Zi14todMZRz9Di00xC5Kop6LZI
   K+og9KLDuaXZy/gPLynq/HYKMW1UBAw9pnX6+plk/evQwJM9T0ssk9/Wp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="377340047"
X-IronPort-AV: E=Sophos;i="5.99,252,1677571200"; 
   d="scan'208";a="377340047"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 10:21:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="730437202"
X-IronPort-AV: E=Sophos;i="5.99,252,1677571200"; 
   d="scan'208";a="730437202"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 05 May 2023 10:21:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 10:21:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 10:21:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 10:21:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 10:21:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJtlCGZ8r95fBziC5h9iRO8evl2udD0JXodxe/RSqP0o1CsJ9+poMe8/ST138mxHdGdUgplTpRX5UcSPBEkG1eLV0DX+WPWeAHYDNsQ9lWmwR/rx6wUgXeTFOHZ00zE7cizKlkR+38dlYWfUsXyqNfVr5TOal7zboCzFJufv8K0Aqb+WTSfNQcwGT897oqVO4LWyr4hEwzC/Isju/JNhkKVcsFyG8XqdDSRwpI4L4p/N3FR3LryrtvwnZaM+D7gROP3UiVNs0OAqXfLY6knpZpFQTHK7hgvb5odxjI0IG0P1M+pjBIgPyYGFTXo/s7GJFL4HKE2yBk6mvlylmrx9mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QohNymwnel8frGPUFHsrXfhreIVSFWO8Lb4FktfL3NE=;
 b=eBMUyIyRIfbJfFIJ9KjFmkM1b2GdNQuIWQWA+XO2t+suLI3xZxMGYiRm2qODy3tP42K9Rd3WPiv+0Wbwakq+Jg1WdCPVfh/8IfK7z7jrYzQ4tCCMqRixBqJqXaTD5q1Da60kE6ptW2C6Mpig7SQr9zQevK5uH12DYeEhiF47FJa58/r+3wSczw/qyOhP1NfnRKila7yMdqtda/fq3pI90pj17ej92Wnibbx0rh8KyXdJZLrqkolOwk6q/2lWpGI/14KWgOQUg61ODV+1JjDuERAeSCEu+AOrN17KJyEfJYS0FEyEr6JnF0wjyKmwN0Cu2oyy3GJqMJJyTPgUxyqWqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN0PR11MB6160.namprd11.prod.outlook.com (2603:10b6:208:3c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 17:21:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6363.022; Fri, 5 May 2023
 17:21:24 +0000
Message-ID: <ca71f97e-ce0b-945e-4e86-49f485fa7d5b@intel.com>
Date:   Fri, 5 May 2023 10:21:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
 <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN0PR11MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 2763bbdc-3622-4b72-4b1f-08db4d8d2705
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvTkbraeGb3PJ1XyYWncT4MuuNhxngZLWWbzRR68zwEkHtqQmyY6Wr7A9qzGicv/3471fyJ03XWc4oAquhPZJ8ZbukWQVv/muRgvl1/GO4RfeSI4uF4ObQHyjBsXY+uONFKp0Z8ZBFbtDf1iKlNFMxyXXXVoYQn3u2iaMgbhGUPCbNRr0N7/niNadCMDtOArOgvE09Pq3fDIx/t2r5WZTB+kkWDMJ0JVZ6+zCNziS4om82V4tK4c6e8Bhm47oMCM01uaymeL3imO5tA5eQhMHAZ50omt1cz2tbB2J2sDDAaOoiV5KQH2j6DfhdXZD6CqQCV1QkiP9CW3NYrGCtMycPQXFDJe19VH92XQtIkCiZX7Nvg0vmt4UckSGbhVAuCi5ZTch8DT5cAEe9UR7mXGtVPDrNTLbROhw4KIR9hkP2ghc0e3zjmzr8VhyFdlVnCbLo/3pwpdkrjkOHAUjVFsKv9I2NiZFLLHSmMywL7ZsZObMQlXABviW9YqVCh21tZs/NhJF2007ip7UF+yW+m5W28p6RKuH/LS2to9eTVGE4m/A+B3avNz73c/D0vMGdWQPm9ipTZYLbc5Tz2+3cjPAXYOp1hS79BRO7+seRi2LUH6QnDuHyECoDIUojQLngVcpAakLFb+rGlT+D8sxE7XQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(2616005)(31696002)(2906002)(31686004)(83380400001)(86362001)(5660300002)(26005)(6486002)(36756003)(478600001)(66476007)(4326008)(66946007)(66556008)(41300700001)(82960400001)(44832011)(38100700002)(54906003)(186003)(316002)(6512007)(53546011)(6506007)(8936002)(8676002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGl2dnhyallCQ0lpcTVSVmRNQ3VBWEZ6THNIUXkxbGRUNEZ6MEVaSVVEa2xF?=
 =?utf-8?B?cExGUGs2OUJnVWxwNStLUnJMY2M5SE4rYzB6amswcHJYUnF3bG9NQXdWMHpV?=
 =?utf-8?B?OUQ1L0diZHNubXc1eXpTRjBVVUpQcnNON2V5djVEd3NZRjg1TVNaV1I5SXpG?=
 =?utf-8?B?WGhIUlhkOE1UUW9CWGF0YTJ6NjVTNWpvK0VwK1czYUxtTVY0b1dpTGRXZGVR?=
 =?utf-8?B?by9iWUFIc0g5eTVFOEhxay9VZndOaXRmN1MrM0QvK1pkbkZPWkE0UmlTOG0y?=
 =?utf-8?B?M3Bla3VCNlVKdm0vMFdvaVhad1owNmkvbHVQaDd3eWRxQVB6ajZxL0dJZ0RG?=
 =?utf-8?B?ZlBEYVhiVmFwUkwwY1pFR0Rjb2JSVnlXZ1AyL2J5U1RvNHdQeXRac1dNQWRX?=
 =?utf-8?B?N2pyaWE1ZktKdEp1dDRTWWZZWlFXc3lub3NtQm5CQUluOE5hUDd4Qk1Ra2Jv?=
 =?utf-8?B?aHpZdEJwMzVVYjNBU0NwaTlpREh0ekpiUFZ5NjB1VUpqM1BHNVU5VnpqZ0NY?=
 =?utf-8?B?dmdVbnJUSFE1d1VzemYrNTExQkRtcnkvTjdOTVNYRUtoalFIZnU5cnZXdGgr?=
 =?utf-8?B?V1hZYWthd215YlNrNUNJNkp1OVViM0xjNkN2bkU2OWJyTG9nOTd2L0ZJcEdt?=
 =?utf-8?B?QXByTkkraGRETGNmOXYyK1lPazBBT1ErbWxPcGVNMS9oTDhWWTNBSTFhU2E5?=
 =?utf-8?B?dkRMR0lJUEdtcm82ckRaQjJmTFJLZ3lFMVdZRFI5ODYzMjFZOGZ1OG5LS3Nx?=
 =?utf-8?B?OUthSExSOG02cmRCejZ4UDhhalcxb283ckpWcDM0NGxMeks3ZE92QXgrU0hp?=
 =?utf-8?B?OUR1ODJhOURwSnE2NGRnM0VPK25GaUdKUjdqa0VWV1ZaOUdHNi9kUitLdGNR?=
 =?utf-8?B?UEJxVTBYMDl4N1QwNWVDOTJpcWgrVXRqYkhaRXRxV0srLzc2aDIyWE5LdVFy?=
 =?utf-8?B?SVFGbGNxbWgrU0JUMHJjNnZGOTJOYnRYVnZKS29ac3FHQ3h2SzhFKy9oejcx?=
 =?utf-8?B?NjdidGd0YTRXTHZwdG1nSTRvajU2cWE3ZWNxR0tuRks3NVF1a3lZYnZtRGpT?=
 =?utf-8?B?RXhoc0JucDBvWisrb0RTQ0pnM3ZuUklsTlFycVFGMTVEUmdjZzRyTnZIckUv?=
 =?utf-8?B?UjdrbVVWRnAyK0RuRlNaRnpwVXJEeFNBU3c0eXhDUWlHeDZXRzFIZ2hVc3NV?=
 =?utf-8?B?Yk8zL2hyWVNpQXU4RlRvQUxOSVFIak1GcXhhN0duS1RoOHB3REw3ajZML1U5?=
 =?utf-8?B?aWE4ck1FVVdINzRjQVBkWm5IdFNpTDdFa2k0T3hkSEVRU1FwVzhmVVBlQitJ?=
 =?utf-8?B?TlBBT2RldGxYeFcwZ2VtOG1YeWZrSTBZK01UNkNGYXdZUnRvMG53VWxkYXBW?=
 =?utf-8?B?NFJ5SFhUZkxJU3k2N21vRzBqdS9BSTRpS2x0UCtpSCtjOWt6QWhYaGRYK0N1?=
 =?utf-8?B?VnJyMklpSFBva1VueUFtaG1JenJhVkhIR3RqR001QmtYSDBpSWZRSTA3ZTJh?=
 =?utf-8?B?NnQrckt5T2RnRkNna2R0NGlzSWpFSXRBQVAvdWdoK3ZnTERUUXM3RUp3bzlv?=
 =?utf-8?B?dTFSVjdtQ09LMUtJZUFrNkNkVzNwRHVmRXA2b0pDM2s1NXBVenBPL0dWaWQ0?=
 =?utf-8?B?ZDJxVHUwQWtjWDZlQ3FXUDFlUWl6a0dxbXUvMDNld1FUUEZTS0Q3YVVlR2hS?=
 =?utf-8?B?dlNHNlI5OVB2Tk9ZcjlveUJING1uNnlXMU4ycDMwTFEyNFh1OE9sM25RR3hn?=
 =?utf-8?B?a1N2NE9FTVVTSExPT29WNDlSZWRTTmxVcndwYWRJalY0QXNnMnh4MmNQTGYv?=
 =?utf-8?B?SmpiQVM0OUZvdmtRK0ZMTXNyYTZoZDlnMDQ3NnBxczUvWWJRc0F1TnVBa1VT?=
 =?utf-8?B?aXpRenFxZEpGSER3a09pV1IzeURSbWtIYkxnUUw2VUdjNHR3T01hUTRvL3BH?=
 =?utf-8?B?ZktzVkVPYW90aFlLSXk0QlZWMzkwOHNoSGIyeGxwQkp3SWFEMGNMakI4eW1v?=
 =?utf-8?B?RDY5NjNzKzBlQzVHSTFpck9jMCtkZVZySkVXRExPMVhpMU11NWYzcU5PSmNL?=
 =?utf-8?B?S0szSlBRTjB4YTdTaE15Y1FsMEszRnFSM2RNVEc3d3Q2UnZjTG9Ta3p5dzBp?=
 =?utf-8?B?U1ZiUXlsbEg0YS9kVjJrbjZ5S2RvbkhQUlEzSTVicVNVeUxmU2pmeUtEL1F2?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2763bbdc-3622-4b72-4b1f-08db4d8d2705
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 17:21:24.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAHL9DldYgCBpOfAUCRar5hAK9o036mvU75+qIyQ+qasZWl08eFcnTAoHZcvtaX3M/tGg2bK7RqWqAt2fol++7NU/yWFGWGQEu8ie6tjtl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6160
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 5/5/2023 1:10 AM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Saturday, April 29, 2023 2:35 AM
>> On 4/27/2023 11:50 PM, Tian, Kevin wrote:
>>>> From: Chatre, Reinette <reinette.chatre@intel.com>
>>>> Sent: Friday, April 28, 2023 1:36 AM

...

>>>> +/*
>>>> + * Return Linux IRQ number of an MSI or MSI-X device interrupt vector.
>>>> + * If a Linux IRQ number is not available then a new interrupt will be
>>>> + * allocated if dynamic MSI-X is supported.
>>>> + */
>>>> +static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
>>>> +			      unsigned int vector, bool msix)
>>>> +{
>>>> +	struct pci_dev *pdev = vdev->pdev;
>>>> +	struct msi_map map;
>>>> +	int irq;
>>>> +	u16 cmd;
>>>> +
>>>> +	irq = pci_irq_vector(pdev, vector);
>>>> +	if (irq > 0 || !msix || !vdev->has_dyn_msix)
>>>> +		return irq;
>>>
>>> if (irq >= 0 || ...)
>>>
>>
>> I am not sure about this request because pci_irq_vector() cannot return 0.
>> The Linux interrupt number will be > 0 on success. 0 means "not found"
>> (see msi_get_virq()), which is translated to -EINVAL by pci_irq_vector().
>>
> 
> There is a subtle difference between the description and the code of
> pci_irq_vector().
> 
> /**
>  * pci_irq_vector() - Get Linux IRQ number of a device interrupt vector
>  * @dev: the PCI device to operate on
>  * @nr:  device-relative interrupt vector index (0-based); has different
>  *       meanings, depending on interrupt mode:
>  *
>  *         * MSI-X     the index in the MSI-X vector table
>  *         * MSI       the index of the enabled MSI vectors
>  *         * INTx      must be 0
>  *
>  * Return: the Linux IRQ number, or -EINVAL if @nr is out of range
>  */
> 
> From above '0' is a valid irq number.
> 
> then in following code:
> 
> 	irq = msi_get_virq(&dev->dev, nr);
> 	return irq ? irq : -EINVAL;
> 
> '0' is obviously invalid for msi.
> 
> I didn't realize the msi part when reading the patch. It left me in
> confusion that '0' is unhandled as here we only check ">0" while in
> other places "-EINVAL" is checked.
> 
> Not big matter but it sounds slightly clearer to me to follow the
> description of pci_irq_vector() instead of its internal detail. 

I can add an explicit check for '0' and, as you confirmed, this is
invalid for MSI and thus I think it should be treated as an error.
This is perhaps another candidate for a WARN considering that
pci_irq_vector() returning a '0' for MSI indicates a kernel problem .

I now consider taking guidance from pci_irq_get_affinity(). Note that
pci_irq_get_affinity() contains:

const struct cpumask *pci_irq_get_affinity(struct pci_dev *dev, int nr)
{
	int idx, irq = pci_irq_vector(dev, nr);
	...
	if (WARN_ON_ONCE(irq <= 0))
		return NULL;
	...
}	


Would you be ok with something like below?

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b549f5c97cb8..a8e96254f953 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -393,6 +393,8 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
 	u16 cmd;
 
 	irq = pci_irq_vector(pdev, vector);
+	if (WARN_ON_ONCE(irq == 0))
+		return -EINVAL;
 	if (irq > 0 || !msix || !vdev->has_dyn_msix)
 		return irq;

I would prefer that vfio_msi_alloc_irq() returns negative errors. This enables
callers to in turn just return the error code on failure (note that dynamic
allocation can return different error codes), not needing to translate 0 into
an error.

Reinette








