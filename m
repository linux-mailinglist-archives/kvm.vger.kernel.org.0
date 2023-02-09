Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537FA6902E6
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 10:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBIJJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 04:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBIJJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 04:09:38 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923462682;
        Thu,  9 Feb 2023 01:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675933775; x=1707469775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QAu5R2naLm9VdZdGLCu64/9Gxx1NVHeNRl7Y1NtfZCg=;
  b=VpgCuTUTj/PD2sWejLUfiFmO2CJGhBLWRM2AOpZgOgyVEQJb/mWxwuYa
   USZpS9BR9ZBpJFPK3i8hgH0BnHVh61P6E182Z+p4AN7NLB1lTpX0+bT9l
   o7xwUiOQkdAsEUFNifwk8j0HQKCKZTm9/DTCg8drshXT87lu9RHstSn5x
   aFqLj9yBft3NTMaLbl33xABywk0Ct5sM0uA3AAc9ju6x8JQSwbLv7Y3Vn
   quiiVcTjx/KZ1TVnJoK0GjSWlNY75EjcqdWnIl+oPjoMTmvAzpEwfag5z
   9KeslRhATRvA2pfdkTUnq3K9OAHlKFQDv3n9W3I9n6UNnGuEVTktxuPf6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394647412"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="394647412"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 01:09:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841522914"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="841522914"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 09 Feb 2023 01:09:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:09:31 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:09:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 01:09:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 01:09:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO/Z3SRlENzn8Aaai0BpF81CDbcCslu6G30frIqTsoP2iSWypk+W0zgjFNH2ykeAEPtCwUL/Y8O5CZR33wyOFHJbVbdC9iSOXMKph5ZoroY/L0BEV2PA5lRU/bO70rscomZWATa2n5/vepHyHg55Y3EL6U0xRTpDEp66lpQZ+neJYMBrmNffSi9IuAd7WIDM9Osq/cKv7lPWK4/i6jkLRnWJpvcQQWR6G8ncKwT02z0MXeAclJ4OPzds5z15jYVhY9sywXrlv2HA6QQcbW0izcATpYxUe1cALSnxWZURGCU+kKZPzzOhfkoJr/N4m3mImGt4QPDlHomzUaPHVVz7dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iHx1TqXsCd7UmBeF/2OOGxCwCuuhVpA1L/YBIQoidc=;
 b=LMAWxwF7rtS51B+oQyLWRQMmYezmHXnDreljEtsXHodRA7iZgNw4mqrrczmAeviFPIkMm7eUMJyo5JwqHVXLHlBSJzWwqcTvBYBFguXmKucC4HSvOnqwVY7OSqjcqBzKjUyUvJrVRxkDGnwu1VxTRxblYGHQXdJJEfRx8mGeeWZ55n5BktagW9g8g6Ebr12MsN+cThlGJr833DGCm+G5kZ2x24oLLD37r7l+7XZMvwjRXKvgFlcLbxsCbxFrBHal9OvehOUTb5th+M6Rh9f51B13VTXfI/MvQzY2SyUbON1iwOAoqFTkcIOLng2RGZuHWwnN68HXAAdnYwx8YWT97A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM8PR11MB5640.namprd11.prod.outlook.com (2603:10b6:8:3f::14) by
 PH7PR11MB7001.namprd11.prod.outlook.com (2603:10b6:510:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Thu, 9 Feb
 2023 09:09:27 +0000
Received: from DM8PR11MB5640.namprd11.prod.outlook.com
 ([fe80::6f87:d86d:7988:7ee2]) by DM8PR11MB5640.namprd11.prod.outlook.com
 ([fe80::6f87:d86d:7988:7ee2%3]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 09:09:27 +0000
Message-ID: <554a9faa-ea51-8c86-dd08-30ac387158c0@intel.com>
Date:   Thu, 9 Feb 2023 17:09:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 3/5] nvme-vfio: enable the function of VFIO live
 migration.
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, <kbusch@kernel.org>,
        <axboe@fb.com>, <kch@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>, <jgg@ziepe.ca>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <mjrosato@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <kvm@vger.kernel.org>
CC:     <eddie.dong@intel.com>, <yadong.li@intel.com>,
        <yi.l.liu@intel.com>, <Konrad.wilk@oracle.com>,
        <stephen@eideticom.com>, <hang.yuan@intel.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-4-lei.rao@intel.com>
 <e7b22356-0ce8-1c14-e693-6803a9b77485@nvidia.com>
Content-Language: en-US
From:   "Rao, Lei" <lei.rao@intel.com>
In-Reply-To: <e7b22356-0ce8-1c14-e693-6803a9b77485@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0121.apcprd03.prod.outlook.com
 (2603:1096:4:91::25) To DM8PR11MB5640.namprd11.prod.outlook.com
 (2603:10b6:8:3f::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR11MB5640:EE_|PH7PR11MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 88706455-f23b-413f-9ad8-08db0a7d57e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djvg0xGZH5tf6luBZ2xnNORO5dB/gy3BbETBTBZMK3GzzUuP73/USSlwNvKiqh7n5w9BJWxO7Lo7/UrtkQXM1sldhK1Qqt26xZFJDVN0Spn9ExKjq7bA21YnAgeS6vm0mnQIseDXvWc/GurH6MPxJfE5QIc4J2SxQg5r+R02XYfJf7Da9SWvrKEtyNPbtQre9WdC6gTtFO8SW64nJi8SmtImR0gm8ps2gxqj78NdJabma19C9mxvTYLLx7zOZ1/ay3QNlBKFS8Zpfaf6WcyqrY0/Q1pzGQ7/UDnOESoBMBbwnrM3ckclBNBN9Nn0GCMWf/yWvTVGAH0phhvMJ25ebrRqnlQw/QCsUxytwwZBH01n8ZCfEJrb2LETWTaDnX8+fzLJ9CIFxITUPti2BWVzzIErRPlH1xa8WsKY8ePp5Psfof6cngmoxBLQlwzlxpqoWCuMI/r0TiBqHGPgbAY/YjclWSNd+TsdKRcjgXPp6ZwnoPEjf17X6mjIXpMIL/Z57tzwSxyTLj7ENu0/iKF2pWh50sv25+JTkFrLxnlghotpZE2ni9lOGzptcDPwn0xou/TAj7VSwcTi+NnfIJZXJt/R6acEg3stb//VR9MQlsL1b/OYfGnXIzE6YUuZVZZIHDLoSKR3QGhsIGerbt1oLyvFl8zbpt8vPwe2w0+JbHEAkwkBzTx/otrll43JolPW+Xn8SHmLUkOltiL8BaYazDzt00NpuEWmnz8TWEbRWpus6O2+1ZrhXrXB8E2bPmOZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(346002)(136003)(366004)(451199018)(6506007)(82960400001)(66556008)(26005)(316002)(53546011)(38100700002)(186003)(41300700001)(6486002)(31696002)(36756003)(6666004)(107886003)(478600001)(6512007)(86362001)(2616005)(8676002)(66476007)(921005)(4326008)(8936002)(5660300002)(7416002)(30864003)(31686004)(66946007)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlpyN1lrMWprV2hZTG9JZmZZYk1nbTMyb3huaEdwdmJEYmNZaVoxa0poSThO?=
 =?utf-8?B?SlhaTVJTUnczTllkcDd6WE4xWE9ZdUE5bHkwRis5MFJ5V0xSWlZNZnMzTUt6?=
 =?utf-8?B?U0RWeEUwSUw2dTNoWDAzQm5sdlMxaTdFODEvaC9WUzY5cnEzWWJVL0pFazBk?=
 =?utf-8?B?QTVyZmtEbUYwdW1mRU5RdTJjQlUreHIzMGU5QkNuZi9VdGpubTNSWUVVb2li?=
 =?utf-8?B?NmtuMEUybWU4d0lXTWdqWUtSRHd4RW5GM2VUTjAvOU5BdTMvUzNOc0pLMXk5?=
 =?utf-8?B?U21qQmxkeTZlbnFuOG5PMXYzOUx0ZktUdThoWHR3M0s3YWx4VDNaQnZIckNp?=
 =?utf-8?B?c2dzT29CanRUMXdLL0h2UUZyK1RtUmVrYlFPNGpHbVN3TTFUUDhuL3docG4r?=
 =?utf-8?B?Ymp2UmMyZkpwVHlZeENDalY2WHEyUFBMTmFVODR2NXFnd1lBUFl0dDI0Ykhk?=
 =?utf-8?B?VVIyTGc2eDJ1TGpkVlBsN2lQZGdkYUJUT0VvNjRlNUR5MXFiZG1PK2xPSjcw?=
 =?utf-8?B?SHhXbXNqdzkzSHRGbFZzeGtQeWlHUjZPOGdVRjB2M2lqc2ZacGhsVzJYMWw5?=
 =?utf-8?B?SFVZZEpUcU15Y0pDTmpiMVFRNlE4MDFCWXh0VFY2N2V3T0dQVk9VZ2x1Y2JH?=
 =?utf-8?B?aW13WDdtbSsxREpMOE5Ncm9OUU8rT3Y3M2w2dkh2aFJsYytLNmJ1QitaV05r?=
 =?utf-8?B?OFRCT1crNEdzL3E4SnlsVDFjcVBiRDBpWGxNZDRVOXE3TVNESmQza0g4OUxB?=
 =?utf-8?B?VGV2OEM3azNQZ01ZRUVnN3lzR3JjckpEc1hIdU5sQUJVcGdSZmdjTm9ramxP?=
 =?utf-8?B?UXd4djBXbERadlRpN3crWGVmWnBnRXhkRUQ0TGhFTm9uQjBIWFNyYVhBblF3?=
 =?utf-8?B?OHVYSWVkR0d5b2N2L0ZpL2k5bUM1Ym5xRXJldlppazhLTUxlRmgyNndJa2M1?=
 =?utf-8?B?R2JrWkxFdFI1VzBYWGliS0JoMzR1dzFUdk9XN2g5bXBEU2xPNkxOWlBFaEdH?=
 =?utf-8?B?bXFKakh3cGd2N3EzaTF0SXNiR2tURkJIaEJKRVVCQXRiYS9NVlFGbEp0dStE?=
 =?utf-8?B?SUJpeHVBcEQ5SEc0aVNYajlNenJiUjR6b2J0QkNoVUZsMm5GTHpaUHE3UE5z?=
 =?utf-8?B?R0IwY1hXNmVVVjdSQ3FnNWJ4MlNGT3R3bHZzN1BuaXVKdzE1U1l2aGRINDV3?=
 =?utf-8?B?UEdxeERXUVFTMEZOMGZFTVdNZ1JpdzhHNWZFVWVBSHlTOTdJK1ZtUU9weW9p?=
 =?utf-8?B?ckdmWDErUmRvUXBHSTlZamEyWFRmcHZSN1EwbHR2VmJKeERkZnNmMEZpakpP?=
 =?utf-8?B?a1h0a0o2V3I5TktNN2tOTE95SmhIZEgzMGVXSDFNdGlpRC9xcWlFd3Q2Ky9P?=
 =?utf-8?B?aWpqeFFVZkx5cjJKd1AwUk9wYk8xTnlJL3l6OEkvZ1ZneC9GNFVLb0xVU2Mr?=
 =?utf-8?B?c3hGR2lhem9PUXc3R1BWbG9iWTVWcjkvdFFYZ1Nic0g5VHFqdHVFdlB6Z1Fj?=
 =?utf-8?B?TzhETmZVZ25VdXhsMXhzRWlVVjNTWjBzdUhGM055bVd5TjFiRHFKS2NIZHM2?=
 =?utf-8?B?TmhLOUlid2s0YWx6KzBvZUpPeWlDRzJRRW1YNE9wNUhxZDVCYkxKbjduZ2oz?=
 =?utf-8?B?VHZCRy9hcExYUTZWS0ZaZUxTaG9QaGhTZHVNS3dZU3NFRjlFcllWczA3S3Az?=
 =?utf-8?B?S3VsczVZMndYS0dDamlhOEdPaUIydzVGOVEyV2o5NlBHUyt6QjM3ek1SWVhj?=
 =?utf-8?B?WjkrYjJJeWQ5RjhUU010ak8wYVc0VWNaeVNkYis0MDVRUm9OTENMTmxQbnlz?=
 =?utf-8?B?UitTNVZTUVdVblUrZkZxZnd2MDJVSEtRcG5Sem9NaGprUjFyc2UwY1dYdkVw?=
 =?utf-8?B?Sko3QU5odk92MHRtaVdLd3poYzVKQ3VMNjhyeE1mQlJIOXJKZ0JvZGZtV2NU?=
 =?utf-8?B?M3lKQzRoMi9uK3FIVXFReXU1UFowOXNKeVdzYjlqYkE3bWx0czErdk1HZmJL?=
 =?utf-8?B?TzRzaDJNRlZCSVNGZlRiL0p0WHdVdVdjbDBNcFFzbElPR0p1UEJuQ1E4Vjl3?=
 =?utf-8?B?MXo1bWowWFR3clR3VVR1MDYzTWFFc1pNRjRVWThkd0liMmpXNjdFL2VRaWpr?=
 =?utf-8?Q?o4hZmOoPz26UBNRDbdl5nZjG0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88706455-f23b-413f-9ad8-08db0a7d57e7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 09:09:26.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMwGmiQ56oHYlNaz8BBgdqsHzzfT4u2+jYR5f+bvJT3PqkB9AkY+MV25DekKeZtT9avYAqHj6nyhz/NIiIyRPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7001
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/2023 6:21 PM, Max Gurtovoy wrote:
> Hi Leo,
> 
> On 06/12/2022 7:58, Lei Rao wrote:
>> Implement specific VFIO live migration operations for NVMe devices.
>>
>> Signed-off-by: Lei Rao <lei.rao@intel.com>
>> Signed-off-by: Yadong Li <yadong.li@intel.com>
>> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
>> Reviewed-by: Eddie Dong <eddie.dong@intel.com>
>> Reviewed-by: Hang Yuan <hang.yuan@intel.com>
>> ---
>> drivers/vfio/pci/nvme/Kconfig |   5 +-
>> drivers/vfio/pci/nvme/nvme.c  | 543 ++++++++++++++++++++++++++++++++--
>> drivers/vfio/pci/nvme/nvme.h  | 111 +++++++
>> 3 files changed, 637 insertions(+), 22 deletions(-)
>> create mode 100644 drivers/vfio/pci/nvme/nvme.h
>>
>> diff --git a/drivers/vfio/pci/nvme/Kconfig b/drivers/vfio/pci/nvme/Kconfig
>> index c281fe154007..12e0eaba0de1 100644
>> --- a/drivers/vfio/pci/nvme/Kconfig
>> +++ b/drivers/vfio/pci/nvme/Kconfig
>> @@ -1,9 +1,10 @@
>> # SPDX-License-Identifier: GPL-2.0-only
>> config NVME_VFIO_PCI
>>     tristate "VFIO support for NVMe PCI devices"
>> +    depends on NVME_CORE
>>     depends on VFIO_PCI_CORE
>>     help
>> -      This provides generic VFIO PCI support for NVMe device
>> -      using the VFIO framework.
>> +      This provides migration support for NVMe devices using the
>> +      VFIO framework.
>>
>>       If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/pci/nvme/nvme.c b/drivers/vfio/pci/nvme/nvme.c
>> index f1386d8a9287..698e470a4e53 100644
>> --- a/drivers/vfio/pci/nvme/nvme.c
>> +++ b/drivers/vfio/pci/nvme/nvme.c
>> @@ -13,29 +13,503 @@
>> #include <linux/types.h>
>> #include <linux/vfio.h>
>> #include <linux/anon_inodes.h>
>> -#include <linux/kernel.h>
>> -#include <linux/vfio_pci_core.h>
>> +
>> +#include "nvme.h"
>> +
>> +#define MAX_MIGRATION_SIZE (256 * 1024)
>> +
>> +static int nvmevf_cmd_suspend_device(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +    struct pci_dev *dev = nvmevf_dev->core_device.pdev;
>> +    struct nvme_live_mig_command c = { };
>> +    int ret;
>> +
>> +    c.suspend.opcode = nvme_admin_live_mig_suspend;
>> +    c.suspend.vf_index = nvmevf_dev->vf_id;
>> +
>> +    ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL, NULL, 0);
>> +    if (ret) {
>> +        dev_warn(&dev->dev, "Suspend virtual function failed (ret=0x%x)\n", ret);
>> +        return ret;
>> +    }
>> +    return 0;
>> +}
>> +
>> +static int nvmevf_cmd_resume_device(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +    struct pci_dev *dev = nvmevf_dev->core_device.pdev;
>> +    struct nvme_live_mig_command c = { };
>> +    int ret;
>> +
>> +    c.resume.opcode = nvme_admin_live_mig_resume;
>> +    c.resume.vf_index = nvmevf_dev->vf_id;
>> +
>> +    ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL, NULL, 0);
>> +    if (ret) {
>> +        dev_warn(&dev->dev, "Resume virtual function failed (ret=0x%x)\n", ret);
>> +        return ret;
>> +    }
>> +    return 0;
>> +}
>> +
>> +static int nvmevf_cmd_query_data_size(struct nvmevf_pci_core_device *nvmevf_dev,
>> +                      size_t *state_size)
>> +{
>> +    struct pci_dev *dev = nvmevf_dev->core_device.pdev;
>> +    struct nvme_live_mig_command c = { };
>> +    size_t result;
>> +    int ret;
>> +
>> +    c.query.opcode = nvme_admin_live_mig_query_data_size;
>> +    c.query.vf_index = nvmevf_dev->vf_id;
>> +
>> +    ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, &result, NULL, 0);
>> +    if (ret) {
>> +        dev_warn(&dev->dev, "Query the states size failed (ret=0x%x)\n", ret);
>> +        *state_size = 0;
>> +        return ret;
>> +    }
>> +    *state_size = result;
>> +    return 0;
>> +}
>> +
>> +static int nvmevf_cmd_save_data(struct nvmevf_pci_core_device *nvmevf_dev,
>> +                    void *buffer, size_t buffer_len)
>> +{
>> +    struct pci_dev *dev = nvmevf_dev->core_device.pdev;
>> +    struct nvme_live_mig_command c = { };
>> +    int ret;
>> +
>> +    c.save.opcode = nvme_admin_live_mig_save_data;
>> +    c.save.vf_index = nvmevf_dev->vf_id;
>> +
>> +    ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL, buffer, buffer_len);
>> +    if (ret) {
>> +        dev_warn(&dev->dev, "Save the device states failed (ret=0x%x)\n", ret);
>> +        return ret;
>> +    }
>> +    return 0;
>> +}
>> +
>> +static int nvmevf_cmd_load_data(struct nvmevf_pci_core_device *nvmevf_dev,
>> +                    struct nvmevf_migration_file *migf)
>> +{
>> +    struct pci_dev *dev = nvmevf_dev->core_device.pdev;
>> +    struct nvme_live_mig_command c = { };
>> +    int ret;
>> +
>> +    c.load.opcode = nvme_admin_live_mig_load_data;
>> +    c.load.vf_index = nvmevf_dev->vf_id;
>> +    c.load.size = migf->total_length;
>> +
>> +    ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL,
>> +            migf->vf_data, migf->total_length);
>> +    if (ret) {
>> +        dev_warn(&dev->dev, "Load the device states failed (ret=0x%x)\n", ret);
>> +        return ret;
>> +    }
>> +    return 0;
>> +}
>> +
>> +static struct nvmevf_pci_core_device *nvmevf_drvdata(struct pci_dev *pdev)
>> +{
>> +    struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
>> +
>> +    return container_of(core_device, struct nvmevf_pci_core_device, core_device);
>> +}
>> +
>> +static void nvmevf_disable_fd(struct nvmevf_migration_file *migf)
>> +{
>> +    mutex_lock(&migf->lock);
>> +
>> +    /* release the device states buffer */
>> +    kvfree(migf->vf_data);
>> +    migf->vf_data = NULL;
>> +    migf->disabled = true;
>> +    migf->total_length = 0;
>> +    migf->filp->f_pos = 0;
>> +    mutex_unlock(&migf->lock);
>> +}
>> +
>> +static int nvmevf_release_file(struct inode *inode, struct file *filp)
>> +{
>> +    struct nvmevf_migration_file *migf = filp->private_data;
>> +
>> +    nvmevf_disable_fd(migf);
>> +    mutex_destroy(&migf->lock);
>> +    kfree(migf);
>> +    return 0;
>> +}
>> +
>> +static ssize_t nvmevf_save_read(struct file *filp, char __user *buf, size_t len, loff_t *pos)
>> +{
>> +    struct nvmevf_migration_file *migf = filp->private_data;
>> +    ssize_t done = 0;
>> +    int ret;
>> +
>> +    if (pos)
>> +        return -ESPIPE;
>> +    pos = &filp->f_pos;
>> +
>> +    mutex_lock(&migf->lock);
>> +    if (*pos > migf->total_length) {
>> +        done = -EINVAL;
>> +        goto out_unlock;
>> +    }
>> +
>> +    if (migf->disabled) {
>> +        done = -EINVAL;
>> +        goto out_unlock;
>> +    }
>> +
>> +    len = min_t(size_t, migf->total_length - *pos, len);
>> +    if (len) {
>> +        ret = copy_to_user(buf, migf->vf_data + *pos, len);
>> +        if (ret) {
>> +            done = -EFAULT;
>> +            goto out_unlock;
>> +        }
>> +        *pos += len;
>> +        done = len;
>> +    }
>> +
>> +out_unlock:
>> +    mutex_unlock(&migf->lock);
>> +    return done;
>> +}
>> +
>> +static const struct file_operations nvmevf_save_fops = {
>> +    .owner = THIS_MODULE,
>> +    .read = nvmevf_save_read,
>> +    .release = nvmevf_release_file,
>> +    .llseek = no_llseek,
>> +};
>> +
>> +static ssize_t nvmevf_resume_write(struct file *filp, const char __user *buf,
>> +                       size_t len, loff_t *pos)
>> +{
>> +    struct nvmevf_migration_file *migf = filp->private_data;
>> +    loff_t requested_length;
>> +    ssize_t done = 0;
>> +    int ret;
>> +
>> +    if (pos)
>> +        return -ESPIPE;
>> +    pos = &filp->f_pos;
>> +
>> +    if (*pos < 0 || check_add_overflow((loff_t)len, *pos, &requested_length))
>> +        return -EINVAL;
>> +
>> +    if (requested_length > MAX_MIGRATION_SIZE)
>> +        return -ENOMEM;
>> +    mutex_lock(&migf->lock);
>> +    if (migf->disabled) {
>> +        done = -ENODEV;
>> +        goto out_unlock;
>> +    }
>> +
>> +    ret = copy_from_user(migf->vf_data + *pos, buf, len);
>> +    if (ret) {
>> +        done = -EFAULT;
>> +        goto out_unlock;
>> +    }
>> +    *pos += len;
>> +    done = len;
>> +    migf->total_length += len;
>> +
>> +out_unlock:
>> +    mutex_unlock(&migf->lock);
>> +    return done;
>> +}
>> +
>> +static const struct file_operations nvmevf_resume_fops = {
>> +    .owner = THIS_MODULE,
>> +    .write = nvmevf_resume_write,
>> +    .release = nvmevf_release_file,
>> +    .llseek = no_llseek,
>> +};
>> +
>> +static void nvmevf_disable_fds(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +    if (nvmevf_dev->resuming_migf) {
>> +        nvmevf_disable_fd(nvmevf_dev->resuming_migf);
>> +        fput(nvmevf_dev->resuming_migf->filp);
>> +        nvmevf_dev->resuming_migf = NULL;
>> +    }
>> +
>> +    if (nvmevf_dev->saving_migf) {
>> +        nvmevf_disable_fd(nvmevf_dev->saving_migf);
>> +        fput(nvmevf_dev->saving_migf->filp);
>> +        nvmevf_dev->saving_migf = NULL;
>> +    }
>> +}
>> +
>> +static struct nvmevf_migration_file *
>> +nvmevf_pci_resume_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +    struct nvmevf_migration_file *migf;
>> +    int ret;
>> +
>> +    migf = kzalloc(sizeof(*migf), GFP_KERNEL);
>> +    if (!migf)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_resume_fops, migf,
>> +                    O_WRONLY);
>> +    if (IS_ERR(migf->filp)) {
>> +        int err = PTR_ERR(migf->filp);
>> +
>> +        kfree(migf);
>> +        return ERR_PTR(err);
>> +    }
>> +    stream_open(migf->filp->f_inode, migf->filp);
>> +    mutex_init(&migf->lock);
>> +
>> +    /* Allocate buffer to load the device states and the max states is 256K */
>> +    migf->vf_data = kvzalloc(MAX_MIGRATION_SIZE, GFP_KERNEL);
>> +    if (!migf->vf_data) {
>> +        ret = -ENOMEM;
>> +        goto out_free;
>> +    }
>> +
>> +    return migf;
>> +
>> +out_free:
>> +    fput(migf->filp);
>> +    return ERR_PTR(ret);
>> +}
>> +
>> +static struct nvmevf_migration_file *
>> +nvmevf_pci_save_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +    struct nvmevf_migration_file *migf;
>> +    int ret;
>> +
>> +    migf = kzalloc(sizeof(*migf), GFP_KERNEL);
>> +    if (!migf)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_save_fops, migf,
>> +                    O_RDONLY);
>> +    if (IS_ERR(migf->filp)) {
>> +        int err = PTR_ERR(migf->filp);
>> +
>> +        kfree(migf);
>> +        return ERR_PTR(err);
>> +    }
>> +
>> +    stream_open(migf->filp->f_inode, migf->filp);
>> +    mutex_init(&migf->lock);
>> +
>> +    ret = nvmevf_cmd_query_data_size(nvmevf_dev, &migf->total_length);
>> +    if (ret)
>> +        goto out_free;
>> +    /* Allocate buffer and save the device states*/
>> +    migf->vf_data = kvzalloc(migf->total_length, GFP_KERNEL);
>> +    if (!migf->vf_data) {
>> +        ret = -ENOMEM;
>> +        goto out_free;
>> +    }
>> +
>> +    ret = nvmevf_cmd_save_data(nvmevf_dev, migf->vf_data, migf->total_length);
>> +    if (ret)
>> +        goto out_free;
>> +
>> +    return migf;
>> +out_free:
>> +    fput(migf->filp);
>> +    return ERR_PTR(ret);
>> +}
>> +
>> +static struct file *
>> +nvmevf_pci_step_device_state_locked(struct nvmevf_pci_core_device *nvmevf_dev, u32 new)
>> +{
>> +    u32 cur = nvmevf_dev->mig_state;
>> +    int ret;
>> +
>> +    if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) {
>> +        ret = nvmevf_cmd_suspend_device(nvmevf_dev);
>> +        if (ret)
>> +            return ERR_PTR(ret);
>> +        return NULL;
>> +    }
>> +
>> +    if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
>> +        struct nvmevf_migration_file *migf;
>> +
>> +        migf = nvmevf_pci_save_device_data(nvmevf_dev);
>> +        if (IS_ERR(migf))
>> +            return ERR_CAST(migf);
>> +        get_file(migf->filp);
>> +        nvmevf_dev->saving_migf = migf;
>> +        return migf->filp;
>> +    }
>> +
>> +    if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
>> +        nvmevf_disable_fds(nvmevf_dev);
>> +        return NULL;
>> +    }
>> +
>> +    if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
>> +        struct nvmevf_migration_file *migf;
>> +
>> +        migf = nvmevf_pci_resume_device_data(nvmevf_dev);
>> +        if (IS_ERR(migf))
>> +            return ERR_CAST(migf);
>> +        get_file(migf->filp);
>> +        nvmevf_dev->resuming_migf = migf;
>> +        return migf->filp;
>> +    }
>> +
>> +    if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
>> +        ret = nvmevf_cmd_load_data(nvmevf_dev, nvmevf_dev->resuming_migf);
>> +        if (ret)
>> +            return ERR_PTR(ret);
>> +        nvmevf_disable_fds(nvmevf_dev);
>> +        return NULL;
>> +    }
>> +
>> +    if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING) {
>> +        nvmevf_cmd_resume_device(nvmevf_dev);
>> +        return NULL;
>> +    }
>> +
>> +    /* vfio_mig_get_next_state() does not use arcs other than the above */
>> +    WARN_ON(true);
>> +    return ERR_PTR(-EINVAL);
>> +}
>> +
>> +static void nvmevf_state_mutex_unlock(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +again:
>> +    spin_lock(&nvmevf_dev->reset_lock);
>> +    if (nvmevf_dev->deferred_reset) {
>> +        nvmevf_dev->deferred_reset = false;
>> +        spin_unlock(&nvmevf_dev->reset_lock);
>> +        nvmevf_dev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>> +        nvmevf_disable_fds(nvmevf_dev);
>> +        goto again;
>> +    }
>> +    mutex_unlock(&nvmevf_dev->state_mutex);
>> +    spin_unlock(&nvmevf_dev->reset_lock);
>> +}
>> +
>> +static struct file *
>> +nvmevf_pci_set_device_state(struct vfio_device *vdev, enum vfio_device_mig_state new_state)
>> +{
>> +    struct nvmevf_pci_core_device *nvmevf_dev = container_of(vdev,
>> +            struct nvmevf_pci_core_device, core_device.vdev);
>> +    enum vfio_device_mig_state next_state;
>> +    struct file *res = NULL;
>> +    int ret;
>> +
>> +    mutex_lock(&nvmevf_dev->state_mutex);
>> +    while (new_state != nvmevf_dev->mig_state) {
>> +        ret = vfio_mig_get_next_state(vdev, nvmevf_dev->mig_state, new_state, &next_state);
>> +        if (ret) {
>> +            res = ERR_PTR(-EINVAL);
>> +            break;
>> +        }
>> +
>> +        res = nvmevf_pci_step_device_state_locked(nvmevf_dev, next_state);
>> +        if (IS_ERR(res))
>> +            break;
>> +        nvmevf_dev->mig_state = next_state;
>> +        if (WARN_ON(res && new_state != nvmevf_dev->mig_state)) {
>> +            fput(res);
>> +            res = ERR_PTR(-EINVAL);
>> +            break;
>> +        }
>> +    }
>> +    nvmevf_state_mutex_unlock(nvmevf_dev);
>> +    return res;
>> +}
>> +
>> +static int nvmevf_pci_get_device_state(struct vfio_device *vdev,
>> +                       enum vfio_device_mig_state *curr_state)
>> +{
>> +    struct nvmevf_pci_core_device *nvmevf_dev = container_of(
>> +            vdev, struct nvmevf_pci_core_device, core_device.vdev);
>> +
>> +    mutex_lock(&nvmevf_dev->state_mutex);
>> +    *curr_state = nvmevf_dev->mig_state;
>> +    nvmevf_state_mutex_unlock(nvmevf_dev);
>> +    return 0;
>> +}
>>
>> static int nvmevf_pci_open_device(struct vfio_device *core_vdev)
>> {
>> -    struct vfio_pci_core_device *vdev =
>> -        container_of(core_vdev, struct vfio_pci_core_device, vdev);
>> +    struct nvmevf_pci_core_device *nvmevf_dev = container_of(
>> +            core_vdev, struct nvmevf_pci_core_device, core_device.vdev);
>> +    struct vfio_pci_core_device *vdev = &nvmevf_dev->core_device;
>>     int ret;
>>
>>     ret = vfio_pci_core_enable(vdev);
>>     if (ret)
>>         return ret;
>>
>> +    if (nvmevf_dev->migrate_cap)
>> +        nvmevf_dev->mig_state = VFIO_DEVICE_STATE_RUNNING;
>>     vfio_pci_core_finish_enable(vdev);
>>     return 0;
>> }
>>
>> +static void nvmevf_cmd_close_migratable(struct nvmevf_pci_core_device *nvmevf_dev)
>> +{
>> +    if (!nvmevf_dev->migrate_cap)
>> +        return;
>> +
>> +    mutex_lock(&nvmevf_dev->state_mutex);
>> +    nvmevf_disable_fds(nvmevf_dev);
>> +    nvmevf_state_mutex_unlock(nvmevf_dev);
>> +}
>> +
>> +static void nvmevf_pci_close_device(struct vfio_device *core_vdev)
>> +{
>> +    struct nvmevf_pci_core_device *nvmevf_dev = container_of(
>> +            core_vdev, struct nvmevf_pci_core_device, core_device.vdev);
>> +
>> +    nvmevf_cmd_close_migratable(nvmevf_dev);
>> +    vfio_pci_core_close_device(core_vdev);
>> +}
>> +
>> +static const struct vfio_migration_ops nvmevf_pci_mig_ops = {
>> +    .migration_set_state = nvmevf_pci_set_device_state,
>> +    .migration_get_state = nvmevf_pci_get_device_state,
>> +};
>> +
>> +static int nvmevf_migration_init_dev(struct vfio_device *core_vdev)
>> +{
>> +    struct nvmevf_pci_core_device *nvmevf_dev = container_of(core_vdev,
>> +                    struct nvmevf_pci_core_device, core_device.vdev);
>> +    struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
>> +    int vf_id;
>> +    int ret = -1;
>> +
>> +    if (!pdev->is_virtfn)
>> +        return ret;
>> +
>> +    nvmevf_dev->migrate_cap = 1;
>> +
>> +    vf_id = pci_iov_vf_id(pdev);
>> +    if (vf_id < 0)
>> +        return ret;
>> +    nvmevf_dev->vf_id = vf_id + 1;
>> +    core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
>> +
>> +    mutex_init(&nvmevf_dev->state_mutex);
>> +    spin_lock_init(&nvmevf_dev->reset_lock);
>> +    core_vdev->mig_ops = &nvmevf_pci_mig_ops;
>> +
>> +    return vfio_pci_core_init_dev(core_vdev);
>> +}
>> +
>> static const struct vfio_device_ops nvmevf_pci_ops = {
>>     .name = "nvme-vfio-pci",
>> -    .init = vfio_pci_core_init_dev,
>> +    .init = nvmevf_migration_init_dev,
>>     .release = vfio_pci_core_release_dev,
>>     .open_device = nvmevf_pci_open_device,
>> -    .close_device = vfio_pci_core_close_device,
>> +    .close_device = nvmevf_pci_close_device,
>>     .ioctl = vfio_pci_core_ioctl,
>>     .device_feature = vfio_pci_core_ioctl_feature,
>>     .read = vfio_pci_core_read,
>> @@ -47,32 +521,56 @@ static const struct vfio_device_ops nvmevf_pci_ops = {
>>
>> static int nvmevf_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> {
>> -    struct vfio_pci_core_device *vdev;
>> +    struct nvmevf_pci_core_device *nvmevf_dev;
>>     int ret;
>>
>> -    vdev = vfio_alloc_device(vfio_pci_core_device, vdev, &pdev->dev,
>> -                &nvmevf_pci_ops);
>> -    if (IS_ERR(vdev))
>> -        return PTR_ERR(vdev);
>> +    nvmevf_dev = vfio_alloc_device(nvmevf_pci_core_device, core_device.vdev,
>> +                    &pdev->dev, &nvmevf_pci_ops);
>> +    if (IS_ERR(nvmevf_dev))
>> +        return PTR_ERR(nvmevf_dev);
>>
>> -    dev_set_drvdata(&pdev->dev, vdev);
>> -    ret = vfio_pci_core_register_device(vdev);
>> +    dev_set_drvdata(&pdev->dev, &nvmevf_dev->core_device);
>> +    ret = vfio_pci_core_register_device(&nvmevf_dev->core_device);
>>     if (ret)
>>         goto out_put_dev;
>> -
>>     return 0;
>>
>> out_put_dev:
>> -    vfio_put_device(&vdev->vdev);
>> +    vfio_put_device(&nvmevf_dev->core_device.vdev);
>>     return ret;
>> +
>> }
>>
>> static void nvmevf_pci_remove(struct pci_dev *pdev)
>> {
>> -    struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
>> +    struct nvmevf_pci_core_device *nvmevf_dev = nvmevf_drvdata(pdev);
>> +
>> + vfio_pci_core_unregister_device(&nvmevf_dev->core_device);
>> +    vfio_put_device(&nvmevf_dev->core_device.vdev);
>> +}
>> +
>> +static void nvmevf_pci_aer_reset_done(struct pci_dev *pdev)
>> +{
>> +    struct nvmevf_pci_core_device *nvmevf_dev = nvmevf_drvdata(pdev);
>> +
>> +    if (!nvmevf_dev->migrate_cap)
>> +        return;
>>
>> -    vfio_pci_core_unregister_device(vdev);
>> -    vfio_put_device(&vdev->vdev);
>> +    /*
>> +     * As the higher VFIO layers are holding locks across reset and using
>> +     * those same locks with the mm_lock we need to prevent ABBA deadlock
>> +     * with the state_mutex and mm_lock.
>> +     * In case the state_mutex was taken already we defer the cleanup work
>> +     * to the unlock flow of the other running context.
>> +     */
>> +    spin_lock(&nvmevf_dev->reset_lock);
>> +    nvmevf_dev->deferred_reset = true;
>> +    if (!mutex_trylock(&nvmevf_dev->state_mutex)) {
>> +        spin_unlock(&nvmevf_dev->reset_lock);
>> +        return;
>> +    }
>> +    spin_unlock(&nvmevf_dev->reset_lock);
>> +    nvmevf_state_mutex_unlock(nvmevf_dev);
>> }
>>
>> static const struct pci_device_id nvmevf_pci_table[] = {
>> @@ -83,12 +581,17 @@ static const struct pci_device_id nvmevf_pci_table[] = {
>>
>> MODULE_DEVICE_TABLE(pci, nvmevf_pci_table);
>>
>> +static const struct pci_error_handlers nvmevf_err_handlers = {
>> +    .reset_done = nvmevf_pci_aer_reset_done,
>> +    .error_detected = vfio_pci_core_aer_err_detected,
>> +};
>> +
>> static struct pci_driver nvmevf_pci_driver = {
>>     .name = KBUILD_MODNAME,
>>     .id_table = nvmevf_pci_table,
>>     .probe = nvmevf_pci_probe,
>>     .remove = nvmevf_pci_remove,
>> -    .err_handler = &vfio_pci_core_err_handlers,
>> +    .err_handler = &nvmevf_err_handlers,
>>     .driver_managed_dma = true,
>> };
>>
>> @@ -96,4 +599,4 @@ module_pci_driver(nvmevf_pci_driver);
>>
>> MODULE_LICENSE("GPL");
>> MODULE_AUTHOR("Lei Rao <lei.rao@intel.com>");
>> -MODULE_DESCRIPTION("NVMe VFIO PCI - Generic VFIO PCI driver for NVMe");
>> +MODULE_DESCRIPTION("NVMe VFIO PCI - VFIO PCI driver with live migration support for NVMe");
>> diff --git a/drivers/vfio/pci/nvme/nvme.h b/drivers/vfio/pci/nvme/nvme.h
>> new file mode 100644
>> index 000000000000..c8464554ef53
>> --- /dev/null
>> +++ b/drivers/vfio/pci/nvme/nvme.h
>> @@ -0,0 +1,111 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (c) 2022, INTEL CORPORATION. All rights reserved
>> + */
>> +
>> +#ifndef NVME_VFIO_PCI_H
>> +#define NVME_VFIO_PCI_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/vfio_pci_core.h>
>> +#include <linux/nvme.h>
>> +
>> +struct nvme_live_mig_query_size {
>> +    __u8    opcode;
>> +    __u8    flags;
>> +    __u16    command_id;
>> +    __u32    rsvd1[9];
>> +    __u16    vf_index;
>> +    __u16    rsvd2;
>> +    __u32    rsvd3[5];
>> +};
>> +
>> +struct nvme_live_mig_suspend {
>> +    __u8    opcode;
>> +    __u8    flags;
>> +    __u16    command_id;
>> +    __u32    rsvd1[9];
>> +    __u16    vf_index;
>> +    __u16    rsvd2;
>> +    __u32    rsvd3[5];
>> +};
>> +
>> +struct nvme_live_mig_resume {
>> +    __u8    opcode;
>> +    __u8    flags;
>> +    __u16   command_id;
>> +    __u32   rsvd1[9];
>> +    __u16   vf_index;
>> +    __u16   rsvd2;
>> +    __u32   rsvd3[5];
>> +};
>> +
>> +struct nvme_live_mig_save_data {
>> +    __u8    opcode;
>> +    __u8    flags;
>> +    __u16    command_id;
>> +    __u32    rsvd1[5];
>> +    __le64    prp1;
>> +    __le64    prp2;
>> +    __u16    vf_index;
>> +    __u16    rsvd2;
>> +    __u32    rsvd3[5];
>> +};
> 
> Just noticed that the save_data (similar to READ operation) doesn't have size/length member.
> How does it work for you ?

Sorry for late reply due to the CNY.
Before the save_data, it will send the Query command to get the data size, and then the driver
will allocate the data buffer used to receive the device state through DMA. That means both the
controller and Host driver know the device state's size.

> 
> BTW,
> 
> Are you doing iterative reads from the device to get the state ?

Yes, in theory, iterative reads are needed.

The size of the device state is related to the number of queue pairs.
For NVMe, the states of one queue pair that needs to be migrated should have only dozens of bytes.
As we know, NVMe can support a maximum number of 64K IO queues, but the actual hardware
can support far less than 64K queues. Therefore, without considering DMA dirty pages, the size
of the device state is small. Practically one read should be able to retrieve all the device states.

Actually, this is also related to maximum data transfer size (MDTS). If the device state size
exceeds MDTS, it must be read iteratively. If needed, we can add a command field to support iteration.

Lei.

> 
>> +
>> +struct nvme_live_mig_load_data {
>> +    __u8    opcode;
>> +    __u8    flags;
>> +    __u16   command_id;
>> +    __u32   rsvd1[5];
>> +    __le64  prp1;
>> +    __le64  prp2;
>> +    __u16   vf_index;
>> +    __u16    rsvd2;
>> +    __u32    size;
>> +    __u32   rsvd3[4];
>> +};
>> +
>> +enum nvme_live_mig_admin_opcode {
>> +    nvme_admin_live_mig_query_data_size    = 0xC4,
>> +    nvme_admin_live_mig_suspend        = 0xC8,
>> +    nvme_admin_live_mig_resume        = 0xCC,
>> +    nvme_admin_live_mig_save_data        = 0xD2,
>> +    nvme_admin_live_mig_load_data        = 0xD5,
>> +};
>> +
>> +struct nvme_live_mig_command {
>> +    union {
>> +        struct nvme_live_mig_query_size query;
>> +        struct nvme_live_mig_suspend    suspend;
>> +        struct nvme_live_mig_resume    resume;
>> +        struct nvme_live_mig_save_data    save;
>> +        struct nvme_live_mig_load_data    load;
>> +    };
>> +};
>> +
>> +struct nvmevf_migration_file {
>> +    struct file *filp;
>> +    struct mutex lock;
>> +    bool disabled;
>> +    u8 *vf_data;
>> +    size_t total_length;
>> +};
>> +
>> +struct nvmevf_pci_core_device {
>> +    struct vfio_pci_core_device core_device;
>> +    int vf_id;
>> +    u8 migrate_cap:1;
>> +    u8 deferred_reset:1;
>> +    /* protect migration state */
>> +    struct mutex state_mutex;
>> +    enum vfio_device_mig_state mig_state;
>> +    /* protect the reset_done flow */
>> +    spinlock_t reset_lock;
>> +    struct nvmevf_migration_file *resuming_migf;
>> +    struct nvmevf_migration_file *saving_migf;
>> +};
>> +
>> +extern int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
>> +            size_t *result, void *buffer, unsigned int bufflen);
>> +
>> +#endif /* NVME_VFIO_PCI_H */
