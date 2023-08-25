Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C93788D7B
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbjHYQ4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 12:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344033AbjHYQ4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 12:56:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E99E67;
        Fri, 25 Aug 2023 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692982561; x=1724518561;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1a2z65Q+ju2P2XGVyRhM6CpOWF+jyO7PBc8OhxButAE=;
  b=goSLzQNhcD/P5KlniHreeOwllzHRO71UVYG+NfEVp2QY1vAoSXw6FaJA
   5CbcKNqIDtr2iGTiaHRoEi0m2NEu+mjytTIc6ldMzEDIXQIZscgVQyjZv
   PPJhCL4ujvazvi14ZC13nEGKsuG0XK/hK+5KChG1iwcRs9gyDzgjouG9x
   OCZ39ZWLY/EUvI0dxw2uevVnRpgAco293OfCrZoj2+nRumwymIfCAsjRb
   NmR31pbO2ldsYOYYznXoHJMGpGO15Bb+7HB+ukOFIGOgkrNDrLdZ/NNBW
   f1WBScakNGfbqDUggJNJ3YP2G6tZQ/TWS5TVLocwLBpmfcQUCBxcny+tk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="378536456"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="378536456"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 09:56:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="731114870"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="731114870"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2023 09:56:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 09:55:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 09:55:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 09:55:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 09:55:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSaxUYrLHGKxsUfn7EHYpp/t/D0T7DXK0uwxaM0UpYEGl5ZHk0HphKEzDJKegKS0QMJ09LIOv+/b6ifU2qsfZs9VYiCwSJv/V+hbW7bXTKG5HumRiijcrWidi08XpgPsR+CQCW2P/NfViuoZxRUVXB26B5YCv9H/UCaFmNpvgbIVprVIZ67Vlf1uNgnu1NRQVZ7aln3fUmZxrkbuN3cS1AB2atVmSL2ThibEP361eOZJmMi/pJlHuL7qBiVDPfKrKhrs6G2rnbJLw5t4p1ulxExBqt4XCwl0mSxZPR2ko5qPX+wrd2EWLnQxMMRAhzwpz8IYoaxG+tj+v9waY3QMHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSSdzrF6d7v+7P/E6dN5FetUHKKAug66PFm/AUWZ2Cc=;
 b=clnKv8m9R6Ff3IiBTnJ88nXD43qouLI+py1sxz0oiFWpXsqsEAP8butbaChdZt6D7U+DuUlPtxfbHis8o+LSZJvS4SYX3Xfw5fBSMttc5Cm7JXTniqFpTdBiC1jnrpzmjC4FlD8LnKZU7oNP8wdCF9px5dmji1a29sJd1HBHdBImkxqcE4QkMwKStz4CVVThqfzDUuye3NBZFrvVeKyhxJ/3XG7MfHDCEtAhRuSSpxb8bPjCN9SP9pmoRSpibOPL+u36PiJ2OfsvDEiKcGHgbO6u27fNQNvNUlP4jLHnRddVKOX7qCmt5Hdo08UFOiv346r6d7ZjRBjbs+oKZwvlTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7579.namprd11.prod.outlook.com (2603:10b6:8:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 16:55:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::47e:3e1f:bef4:20e0]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::47e:3e1f:bef4:20e0%3]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 16:55:55 +0000
Message-ID: <f46f44cd-2961-7731-d5a2-483c9e5189d1@intel.com>
Date:   Fri, 25 Aug 2023 09:55:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1692892275.git.reinette.chatre@intel.com>
 <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
 <ZOeGQrRCqf87Joec@nvidia.com>
 <84629316-dafa-9f4e-89e9-40ccaee016de@intel.com>
 <BN9PR11MB5276D9778C48BD2FD73CE9658CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276D9778C48BD2FD73CE9658CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0326.namprd04.prod.outlook.com
 (2603:10b6:303:82::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df09c32-ac6f-405a-9ef4-08dba58c2608
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxoUi4t5yN6RokWuECwsNEJ9jgUM0NJTaazYOzvtxvSxEc5XTZ6mgt/NUm8wmyH0SUIGfjKuCeX8q2u9EUa2eQT3B91ZoeP3hfHBtk1F7/CmLR6qZnAbN1Z3rbubV+BiSQ6bBBofYi/jxJnhWWFXAis+WHh3cnwGuN6zQ1ydzukI04jYXcPwwUENDolONhBiCtxn04rcqLsIpxxtIOorZSunGCaX5ZfvRedhpZ8zVhHE8b4L3kJRcjS/14YWoES4D92vPPAOAurQxz5k7wgGSO2hgUPeR6Q7mubx+zotxlKifLAw1WfWJ8OcRDlPXwD+b7t6CcmQ94/BhC1AzPc/Dt8rbC8XHDOphHG7E7Ig34cm6S7luCEvPddnTo6JLJGLhQCd2sSnq4NSvc3birh3+xQPEuRt3HbfAhWxRHEFAJatOlJU1/2jeC8h/Hj1oomVEEp7D9vVVs9F8V/fINo0yhqJO0L2XrjXS7XvbxVRUrLld/erKlvEj0hgHHMwitwG864cQ6kHtBcqBkb76878EWiRfQ6s6w65KEgJBXAfak9quEpbVS655Qtcu7aGFtlLgkTwDpsLFBEJzNw1jO/BXfttctqZLVO9Xo+MfcXfyu3rFhWSN/4jsGM3gPVssvF1u+JB+xqdRESZqOY/CaS8+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199024)(1800799009)(186009)(82960400001)(38100700002)(8676002)(4326008)(8936002)(31696002)(54906003)(41300700001)(6506007)(6486002)(53546011)(316002)(6666004)(36756003)(66946007)(66476007)(66556008)(86362001)(110136005)(6512007)(26005)(478600001)(44832011)(83380400001)(31686004)(2906002)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STRGbzh1T0ZQQkdaRFBnQWtOYklrazBsWTJ0L1pVS09RNkZPT2pIRFBTYndz?=
 =?utf-8?B?TE95MUFRbFFmRXpKbVhhK1B4VEdGYmFwS3ExOTdSZnlGRFNzQk1zSWpsMFZK?=
 =?utf-8?B?czBOWEVYVXlqb0JYbnRpUTBDdWQrQWN2dlVmUDRUNlRNTkZjVU9URjFUY0Ro?=
 =?utf-8?B?a1Q5Yi9MOW1xRStPR3VrTUVUN1hDQ2hWR05UeEdaMm1vVUVmYkxBZHZML0dW?=
 =?utf-8?B?ZTRoYlN2TWE4bWxia25STTJ5TWVDczZocThHTHRnc01TSUJoMkpNZ3RueUo1?=
 =?utf-8?B?bWFybVNMeUVtMFZwcnJScnBOMkpXcmtTTDNYSDhoRjBORUkyMHhxUzlhdy8r?=
 =?utf-8?B?b1lHSVhua1hERjhOOGFxbU1NMCsvVnYxOUFhS0NmTHJ4aXV2VFYyTjcxQ1ZE?=
 =?utf-8?B?TSt0NE0vTzk0ZzZIcjZVcXh3Rk1SZkFxekVmbXlua3RQRHI0OHRxTjNIQXVN?=
 =?utf-8?B?RStWK2MrRWVOdWVMUHhvUHBYUzc4b08xV0FFM3dpVG1rbmRjZ2pYZXFsbWJi?=
 =?utf-8?B?L2RydUtRVU82ZzM1WE5OZFI3djF6cUQ4L3hsQXhwUnloTUFwUXUzbXp3K0xB?=
 =?utf-8?B?ZEdSQkRzVGxuWW8xSWY4T2VXdW91QnNUTTVodGhQNTRUUG80NzM1YVVXUkdu?=
 =?utf-8?B?bWdlL0J6R20vaGtyZjBtTUJkWFFCaUNCR3FyeXpjTm5LcVNXZW5OSW9BUHFB?=
 =?utf-8?B?YStLdU92YVZNQXNaQ2N3NlNhZTNYZ2JmWVdCU3RNWU9HQkVodUZJVmhVQXFT?=
 =?utf-8?B?Z2JPYmM2WnFpeTY5NXJuVElWemh5WHVKN29xMDh6b1Q3eDd0WU1yN2VFS1ox?=
 =?utf-8?B?S3FscEJLNkllVC9mZ0l1VjU5TVRUNDY2TndGUWZkZmRNalpXQ09nUEszUG5q?=
 =?utf-8?B?VmpLYmQ5YURkQW1vZUJPMnFjTG9nWFNDbWx2QjRMei8vSWxvK2krSGtpL3Ir?=
 =?utf-8?B?TmxJZTRJRGd4ZktHeDUwbFUrRHg5YmRaUVA4SUJHWEpPKzJ1R05rM080cnFv?=
 =?utf-8?B?Qzh3OXoraWcyeGpwRHR4WHY0RWRNZzgxWHhwR0xSYjlodSs3ZkpmMkl5Mnlo?=
 =?utf-8?B?RFVmb0UrcWxrTmQvYm1ld3ozdk1xY2hySjQvYW5tNHZlUzd6TnZzdXc2NWRH?=
 =?utf-8?B?S01CaGdVQ045ek1LNURGMnpkQzMwUmdEYW1Bb0tlLzJJcVMzSUMwSjlHQ254?=
 =?utf-8?B?bWRCc2J2OHdQUEdrcnNmWjM0WWovOUp1RTNUdlo5NUxBMGo3MHllMmwralYx?=
 =?utf-8?B?NTMrUEhieHVQTlRjZ1JrQTRuU0JvVU9iOWFMaDZJbk56VmNPU28rT1I5YzR0?=
 =?utf-8?B?cXV1MzR5TmNwa0wvRVNLV2tQNW9Pbmt2SExuNHhmUCt2TXgwOTRaWkliaFpQ?=
 =?utf-8?B?TzFhZEhQOE50Sk9ORFVlaWZKSmNBMXlzbEs5ampYQys0cTdXYi96OVlCeVRy?=
 =?utf-8?B?c28wVnN1amxrbGNuMTBHanc1WXJCcGVXUkl0cm9CUVoxOWxIUXVPNUlnVDNM?=
 =?utf-8?B?Wkt3WlA4Q2o3TmlXM2FWanI0RzliSVNKUDRBRVV0NE5qS1hhSUVmcFZ2SC92?=
 =?utf-8?B?VUxBK0tITWhqMUhyODIyQXh5Q2EvYmJ2cGlKandaOFpFVHlJRnN2RjJLM05C?=
 =?utf-8?B?c2JaTUFvejNtbHV3cFppcEs4M3kySGMwSXpJL25TNTVhcWlIOWM1VlZyNUhx?=
 =?utf-8?B?YU12ek56YnN3RjNjS0N3TjJqZyt1UG1JbTV6cW9mS095NUxja2hWdld4TFh0?=
 =?utf-8?B?L29JdFR5T3E4dmRQeDhOcmJWTnhIWk5UUkJsMDU2aW4rSUp6Z2I4RitaMW81?=
 =?utf-8?B?QmZyeGQzbWxzUU5yRGhXMnZPaVh0RXg2dmpEZVVYUzV1OGwxVzlNWVpNOUla?=
 =?utf-8?B?aW90eUpJTk02YXN0eVdmZVJuS0xTc1JldWhZeFJ3QmhLTkhSNzhvdEZuWkU2?=
 =?utf-8?B?ZlE3Y3BZUHh5WWhaaGlKTnNsSTFOTGhwcjZKYWdLdDRlelkxdDcrT2Ixbkln?=
 =?utf-8?B?RDJnNWdDOFkzMUorRk1ianBwcVJCV2Y4V1V2bEhDd2Q1eHVoMEcybFEwWFdl?=
 =?utf-8?B?ekNJODd2SzlXSFNuY3A2bUtFY3NjVlBEQ1hpVmZlKzRzdnVTLzByY1R0OHBP?=
 =?utf-8?B?UkwzNGFHa3R4aFZHRkpvaEVTWEtNL1JFUUlpckllcEc4VHJSWWtMclBYZUps?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df09c32-ac6f-405a-9ef4-08dba58c2608
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 16:55:55.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X32SCMO+opEiFsEWxvaK6ukkddnN49b0xYcz0ii/ORy+24Px4RZJKsHcOuA3rSK1BYms9W8Y8BooDTBaXta63pb7xicKfbCP7cxLK5V900E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7579
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 8/24/2023 8:05 PM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Friday, August 25, 2023 1:19 AM
>>
>> Hi Jason,
>>
>> On 8/24/2023 9:33 AM, Jason Gunthorpe wrote:
>>> On Thu, Aug 24, 2023 at 09:15:21AM -0700, Reinette Chatre wrote:
>>>> Access from a guest to a virtual device may be either 'direct-path',
>>>> where the guest interacts directly with the underlying hardware,
>>>> or 'intercepted path' where the virtual device emulates operations.
>>>>
>>>> Support emulated interrupts that can be used to handle 'intercepted
>>>> path' operations. For example, a virtual device may use 'intercepted
>>>> path' for configuration. Doing so, configuration requests intercepted
>>>> by the virtual device driver are handled within the virtual device
>>>> driver with completion signaled to the guest without interacting with
>>>> the underlying hardware.
>>>
>>> Why does this have anything to do with IMS? I thought the point here
>>> was that IMS was some back end to the MSI-X emulation - should a
>>> purely emulated interrupt logically be part of the MSI code, not IMS?
>>
>> You are correct, an emulated interrupt is not unique to IMS.
>>
>> The target usage of this library is by pure(?) VFIO devices (struct
>> vfio_device). These are virtual devices that are composed by separate
>> VFIO drivers. For example, a single resource of an accelerator device
>> can be composed into a stand-alone virtual device for use by a guest.
>>
>> Through its API and implementation the current VFIO MSI
>> code expects to work with actual PCI devices (struct
>> vfio_pci_core_device). With the target usage not being an
>> actual PCI device the VFIO MSI code was not found to be a good
>> fit and thus this implementation does not build on current MSI
>> support.
>>
> 
> This might be achieved by creating a structure vfio_pci_intr_ctx
> included by vfio_pci_core_device and other vfio device types. Then
> move vfio_pci_intr.c to operate on vfio_pci_intr_ctx instead of
> vfio_pci_core_device to make MSI frontend code sharable by both
> PCI devices or virtual devices (mdev or SIOV).

Thank you very much Kevin.

For data there is the per-device context related to interrupts as
well as the per-interrupt context. These contexts are different between
the different device types and interrupt types and if I understand
correctly both context types (per-device as well as per-interrupt)
should be made opaque within the new vfio_pci_intr.c. Additionally,
with different mechanisms (for example, the locking required) to
interact with the different device types the code is also device
(PCI or virtual) specific. Considering how both the data and
code would be opaque to this new library it looks to me as
though in some aspects this library may thus appear as a skeleton
with interrupt and device specific logic contained in its users.

It is not obvious to me where the MSI frontend and backend boundary
is. If I understand correctly majority of the code in vfio_pci_intrs.c
would move to callbacks. Potentially leaving little to be shared,
vfio_pci_set_irqs_ioctl() and vfio_msihandler() seems like
candidates. 

To clarify it sounds to me as though this design is motivated by the
requirement to bring emulated interrupt support to the current
INTx/MSI/MSI-X support on PCI devices? It is not clear to me how this
feature will be used since interrupts need to be signaled from the
driver instead of the hardware. I am missing something.

> Then there is only one irq_ctx. Within the ctx we can abstract
> backend ops, e.g. enable/disble_msi(), alloc/free_ctx(), alloc/free_irq(), etc.
> to accommodate pci MSI/MSI-X, IMS, or emulation.
> 
> The unknown risk is whether a clear abstraction can be defined. If
> in the end the common library contains many if-else to handle subtle
> backend differences then it might not be a good choice...

Thank you very much for your guidance. Instead of Jason's expectation that
IMS would be a backend of MSI-X this will change to IMS and MSI-X both being
a backend to a new interface. It is difficult for me to envision the end
result so I will work on an implementation based on my understanding of
your proposal that we can use for further discussion.

Reinette

