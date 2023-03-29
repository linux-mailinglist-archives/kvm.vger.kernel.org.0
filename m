Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774A66CF635
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 00:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjC2WLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 18:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjC2WLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 18:11:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF33E1FD8;
        Wed, 29 Mar 2023 15:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680127896; x=1711663896;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hd8FFbXtg1JBpZQRDfqYJQge/OpcFpiBWjz3v1wTvDs=;
  b=bZ0TZ5gE947rrKa91V7cTxxx37u7UmG944H3obOOrVheYzZ2LHoGS3yB
   tja33/K3VQ3PN+f3n2iWPj+Bas5NtW/gmE6M2W3XkM1n/+6RT2kvbn/gr
   B7rlBzpkBKSvP8JtDvOJl8/h7Q5eg5sIOc7tqu3sOHrZ71pUEwy+sFo3U
   H+JUPRgqJrSCnoyUSWRIDjVTjAQZCLoPyc1TWGsPTgddAJDvQVVi1TWPR
   nnfiQ0aTYcRFicBCjGCE6TYhwyyT63GeVhoawMdhos7B70tuWvi2oqS32
   907OBABEoOb4k5Mbmq7O4efeq5a8W817AbFmTco/xpodiCLHYjfpTj0/K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="343458092"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="343458092"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 15:11:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="753760660"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="753760660"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 29 Mar 2023 15:11:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 15:11:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 15:11:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 15:11:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 15:11:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ii1KbE9yPwvLc4PQJ04iYdOrs2x9/9E0wclZ9FsETyGGv6+uYlupI1BQTDVKsbg1wXQKVWvAaDU4WYtD64kkmxPsbBemkyyhIj5X7GF/KIj6xm5Jcn3E+HFxZZUDJFJ8xTTxCaXceZr2jAsYr72C2vsu1nmRHGmMKR5bJ49uY+Oo2igfwJ57kvZOowpfpCWcb1fcMc7LQ2NdFYkfa/pS6bGTSRDu6m6JMvRaskEEO86l6WX5wyvCWaexVVNsaJgzG1qrWckMBjA/66GCMEqU0ccP0bajhKWyxO4bDuG1fICkOC4NS09fghgcnlsTCrN0VqVtD/mz/jSFENWrepy8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hd8FFbXtg1JBpZQRDfqYJQge/OpcFpiBWjz3v1wTvDs=;
 b=gQj7WewGaoagTe9VLyKowiW5zrk8dAyiew5l4oi3oAYXgqMevZIyBXcBkSxYxo+J+tkVA6n/E28xX6uZUVSkqSRGEfwk73tsNrOvlseqDqVlU0dTzRGfYjzKiS22rbcsvlrqLw8/zJ6sCbhfrBguQfxccU1Rlva5bWBQ3lf3C6+7Hynv+IN1wHrBneeXoxgCYeL4PX65eUwLqQYfHQSTiVdiHRzRKsU9kmN/wvqz45REf4LFVjeMCoZ43mYZw0LoC19uAHwzTtgR3sjSMFLlEhroaBsJFZ8nXHtl1E56BQhEDr17iKJed7Fe87tfdOpFQwlV/Ax4/6ozX2UYX1paOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by BN9PR11MB5354.namprd11.prod.outlook.com (2603:10b6:408:11b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 22:11:03 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6222.035; Wed, 29 Mar
 2023 22:11:03 +0000
Message-ID: <444b4a41-2edd-2eb1-70d6-9bd4f70c6c78@intel.com>
Date:   Wed, 29 Mar 2023 15:10:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     kernel test robot <lkp@intel.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <alex.williamson@redhat.com>
CC:     <oe-kbuild-all@lists.linux.dev>, <tglx@linutronix.de>,
        <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <202303291000.PWFqGCxH-lkp@intel.com>
 <d3eb55ac-02c1-616b-830d-60ad752f42b4@intel.com>
In-Reply-To: <d3eb55ac-02c1-616b-830d-60ad752f42b4@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::45) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|BN9PR11MB5354:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b5e8524-46e2-4ce9-4c14-08db30a27bee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REzoj6uJAbbSvndsBgd8iB4FgxTqkz6lceS+Uus/M1DuMRh4Xl1U8Y6/RAeaRAWNb/0xHnMF/ak8vTu0D5qbe7K9dBRYUrKxadWtp315w6hvzeHn208nQTx7nqKlmAwpifv0AzCILkq7g7f2p2l4XrcvezTA8aQhlZ1wP5LzWYSGWCv73dA7oabTumN7Z8qm6wNfPjgSrJ4jIHceazML4TZWGM56cyLrzw9PWWYpxgA3H+7dvsSxUJ2whbJ89vUYeOPvOjkMFWque+afEDcmub77n0sp0krelxJSDh9E9TCreiXYyC1rgpZOEl1OB1xuwt6hcYdtSuXopkz6uyT/lIR9noZytr2dGV2aAEpg+W9Hn8IsQ5/vlcLYZXoHapzLUZbhBaMfUDTJhu4VA7VCQeG4KE2lERAru0UuBC+8fcQMkDmA3OJU/7fsX1CLtI+EcurBdwp4KN6YgsLzYMSN21/q1JUdxJWXpEhZGgQbaAm5V2hjzVNW5ALnCTa8zdQ9O9B0oM//sUK1yiRhU2hH8eqTEoXMXOnJX0dZyNhBbEIJRZ5Vpu5KKcFpDjfyDDvlXs1lZF8kGwc8GbxX4ZV/IIknNh+Md2bLRPKz6z+1CfW+raeicz/ZJ+FAsOZaXM63zmfBKn4XwbTW5uygGXpv/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199021)(26005)(6666004)(82960400001)(53546011)(38100700002)(966005)(6486002)(2616005)(478600001)(186003)(44832011)(5660300002)(2906002)(8936002)(6506007)(7416002)(36756003)(558084003)(316002)(31696002)(4326008)(6512007)(41300700001)(86362001)(66476007)(66946007)(8676002)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REQwZUNEcDByVjJMTHZQNmR3cXUwUmw2N1lPbHZCT0RldzhOZHN5VGQxWjVD?=
 =?utf-8?B?TGhaUzVNd0prQ2lEQi9nTTh4QjluUWVKOVFKdWJjT0pTMUx4N3dsRnpCRUFt?=
 =?utf-8?B?WUpmbFMzZ3l6YytwRkJrN1kyK0Q4dkNRNk5CT2ZaRU0wMGJERE1DZUlaSDFT?=
 =?utf-8?B?dEkrcUdaRXVSRlU5LzZmTGJPSEJjSEJHaUgxMGhEeVh1MW5Kb2ZwY3k5S2Jz?=
 =?utf-8?B?OFFqTjl5dUYwTVVkVlc1VzJLVnJjQnpwN2FrOHhRTXRxRkpycjlVWkhqNmxt?=
 =?utf-8?B?bmtsN1NkUDJWNTNuUHBhb0hYaHE3V1NNMWdDUUd3TnFuNys5aXNIQ09Ma04w?=
 =?utf-8?B?QUhFdDRoelJqV0xTZkxaZFBJQU5KS1lFUnZ0anRHeWJXdmpYNE9VaExzSzJI?=
 =?utf-8?B?dnAvbEpuWURBN1ovZkNxK0I3SmxjaXE5RXpSc2lRbkZ5UVFtMW9aZTBHTmdX?=
 =?utf-8?B?bEpjRGVyZkxIZkZhRzd0cGJWY2s2QVpMUWtndWt5bThHZ1J5dWRra2NHOW41?=
 =?utf-8?B?VENCYVZUVllyaW1aYzlxamdWOGhPeTZBbUs0MlYxbDY2RXhXT2Y1d1hFTlBn?=
 =?utf-8?B?YURibmgzd1ZadU5vWTBsQ3A5TG5DS2JVZXVkWjQwOVFuUWk1Njlic0JBckh5?=
 =?utf-8?B?UUR4NGtvcE1vTXhBQnFJaTBNS2dvYXBkTVpOQkpyUTVyTVViNEFZYXBmakhr?=
 =?utf-8?B?aGxRYm9HSVkwYndpSnQvclZrRnhaSTN4YjJtaG5wdXRJaFJZa0dHNUJKeW9v?=
 =?utf-8?B?UnM2blJDRUl1VnZwR2hKK2N0Wmx2Y1NnQTgvNzh5b09BTk1VVnhEd3dRYmlP?=
 =?utf-8?B?bnhKRk4vNmlWL3ZKeDMvR2JoMFRnckMrUkdPTXA5NS9yNHlDWm1aTVFMZkFo?=
 =?utf-8?B?MTBIRzRuelBWdC9mY0lURzY1RzRRM05paVZCZ3R0M2VaSmQ0VTlnVUoveXZR?=
 =?utf-8?B?TGlzUjd6Z1craHh1ZHpObHp1T0ZiaWN2RnVTR1BLQkNkT2dGczVnTUV5VUdN?=
 =?utf-8?B?WnlaVUU4NkhFT2hob3lwL2JabnMzZEJCcDNYeGpVWWFsYVIvbnhvMzFmNlVt?=
 =?utf-8?B?TFUzL0F2d0F4RHdXSE9TMDJZcmJVSjhlSXNTK0hFZy9FZXl6aEdmWDhYcWdQ?=
 =?utf-8?B?ZzdhM3ZFaFBMeXF3Smk2cVluMFFRTTB2WW9lMjNYRnVtR1pENHpYZncvWW1N?=
 =?utf-8?B?bWZmVmN2M0dPMGxiUmgzenNLM1pEN0xIR2UxbEMzZytFSlR3V0ttanpPcmlK?=
 =?utf-8?B?M2RWWjVNZFZaLzBaZVAyYTJUTEc4b1kya01VTWYvVVVldWJyOW9MUXBzSmo1?=
 =?utf-8?B?aElmZUJkbFdpT2ZtMCtrcW5WekltdzFNVDhYL1Nqb21EWXVNcVJNbUNSMmha?=
 =?utf-8?B?cUlKZXczYVFiOXlURzRsQVN5MkNTZDZMZzRkeHdSMVljdnhvTEFKUmZPNlJR?=
 =?utf-8?B?MklxMmlTWDJIWm9mWGJGYkwxcm1uNy9Zdk1IM1pVb1IvVlJlRUtxeWd2Mk8v?=
 =?utf-8?B?cWtyUlAyTnZOa3FPOFdGOTNuL1JpTmE0WS9zdndvM1dpTnExcGhIbk9ycnVB?=
 =?utf-8?B?dGsrMytHMXIranQzb3RoVUpSMURXRFpPRzYxQXkxV0o0d21qWEtTdGtld2J5?=
 =?utf-8?B?MnNNUHgveWYxNWZGS3ZkaW5MSTlRWTFpUC9ucmVqYTNDM2xRcWhENVJLM2dw?=
 =?utf-8?B?eHlZWUZXT0dzb3V0YXh5ZFpMZXBlSHprWXhXektZNlNsTnQ3aGlCL0pzUFdS?=
 =?utf-8?B?VExiNVY5bXdnaURRZWZ3RTRiMjVnMDFldnVzemxmQW9WN1JkS0I5aTR6bDV6?=
 =?utf-8?B?R2ZWSVlEdmJGWFkzU2ExdTMxQUJuRi9Bc0o4ZTNqUkJBdGNINm4vbkVpSWFC?=
 =?utf-8?B?RDNIcWhMa1loS0lKMVNPMUVHa2lhV3QyQ2EvUC95N0NSTXphUmk3dEZHTGtz?=
 =?utf-8?B?TW5jR2U0a2xTRHA3a3drUGh3dXM2M3UzZ1hUL0s3dU5mV2JQNGZ5cUp5SlRW?=
 =?utf-8?B?dGM5VklPa21JK2U5TVQ5K25TKzN2cDhCLzVZaGR6Z1FVa2tYTzdHQ25YOWky?=
 =?utf-8?B?clQrdnROSWRqejFIaTVpOXNnMk1KOWpxbHpxK0VqcWVDOWxLLytrS1NaZ20y?=
 =?utf-8?B?SEhMSjdFLzZoNHM1VU5Qa3N1TGptTzlaMm5GZ0dmUmw3YVFHS2RzN2tqUUhC?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5e8524-46e2-4ce9-4c14-08db30a27bee
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 22:11:03.0487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hjvg8KYNayd2XcuwTD3TVlivEr9DcRXdAIfnuiJl9m3qXWY1rqb/Hyy0jjeiuwynOsgOwX860j8Q90VVkmgJNhbF37d8IXnrxG5upy1O3gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5354
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/2023 7:42 AM, Reinette Chatre wrote:
> I'll send a separate fix for that.

https://lore.kernel.org/lkml/310ecc4815dae4174031062f525245f0755c70e2.1680119924.git.reinette.chatre@intel.com/

Reinette
