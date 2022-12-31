Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DCF65A374
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 11:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiLaKM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Dec 2022 05:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLaKM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Dec 2022 05:12:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B9426D1;
        Sat, 31 Dec 2022 02:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672481576; x=1704017576;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aW5ZGryVMK2VQFsh5mX74JHZL8h4NsFrN3Tw0KZxIG8=;
  b=Vi2XlurNlOj+2ccAO8Gnz4i0MreCKCPzXRSWOTPHImeevmqmWrOJuG+o
   UzUgBy7UjsYhOVAA5rL7dsObBWOzKnyNV21Jruvj7ll5wDZPKFd7XaUZm
   ioURcY92LI7x2qE64A9/wu4Z+Z7hBB4QjGTr3dswSfwoGtEb3aVf6XWxp
   lWwg6rhASoogcTb5SGH5yGAUhkqczDjFQwf2jUH9qoUB5jd2xrUM2sYR9
   e7ZmyjAq1SfeCDbqGqU97gBGkp9dBQRkqN3h+6jGdO7AZ4/2MctTZZ1ol
   4pVxWa8cCcKx417kWU52eV8Vqr6cyFQSiDgU2XF59jm3fdvf7nexxixiO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10576"; a="407565075"
X-IronPort-AV: E=Sophos;i="5.96,290,1665471600"; 
   d="scan'208";a="407565075"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2022 02:12:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10576"; a="982851640"
X-IronPort-AV: E=Sophos;i="5.96,290,1665471600"; 
   d="scan'208";a="982851640"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 31 Dec 2022 02:12:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 31 Dec 2022 02:12:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 31 Dec 2022 02:12:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 31 Dec 2022 02:12:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 31 Dec 2022 02:12:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pvrv+ol8wNmW/NxYihU42bF0b00q76e4z8QTXb/EpgG76deASogoSARRF3xDa2xDo3x7JrSWxXlvB7LpG5w9UGF0G9ekd4FLvlgrQxWfXuykaqkMOkHasRFc2pEoOddMJQyzX5NjgmkV5Mlp5kir+18un4k2s+KwuExmR8qNVtRJ3Y78BBzz79AzZZqmwa3WWR+0x7BcHGhKu3ocYkb/PKPv5mroiDCuMkhcWTSp4ahHpQfgKmSA7n1oFKTdCUst6B9o2gKXZg/v/8NugKJerJfgXTDQvQ0vUYRI0S0XOl+Ee1hRrpLHu9sJ3EcS+irI/XR2sEf7/EqRog0YYyLoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUrrh9BO3D0iOT9iV063MTnDimybzwjzlA+bU72PNCA=;
 b=AAjgiHBLO2fbh3tv54YdpJcYbZCZe3UkFJd8Ejebw1SyVPBjDPinxiqo8bN7je7pCnoFF5eb9NSG0kr2iD/7C7ICKY10rnmwE8Bo2sgxXZoLdRr0T+F6p9f/+x2v6npegtU41bPf+SWCx6QFxpFh4chm9TKnVwGVrWfFfJHAfCyxLzuylwyPtFa0XqEkyN40me44RM/9vBdq3Ey8dKERlNhKvmm9bno7kfhS/UBCQWu/sevh2PVdilhJdfMU2PeKNhshmrVF7UWtIQgWHVkR/KmnUjDiRANtAItPotsSWhlUNyKOGxxnhdwhnWAWzRIm/ecGa3qTKLe8sdud2NXe4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB8246.namprd11.prod.outlook.com (2603:10b6:208:445::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.18; Sat, 31 Dec
 2022 10:12:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%9]) with mapi id 15.20.5944.018; Sat, 31 Dec 2022
 10:12:52 +0000
Message-ID: <0e5dc3e1-3be2-f7bc-a93c-d3e23739aa3d@intel.com>
Date:   Sat, 31 Dec 2022 18:13:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: DMAR: [DMA Read NO_PASID] Request device [0b:00.0] fault addr
 0xffffe000 [fault reason 0x06] PTE Read access is not set
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Major Saheb <majosaheb@gmail.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Zhenzhong Duan" <zhenzhong.duan@gmail.com>
References: <20221230192042.GA697217@bhelgaas>
 <29F6A46D-FBE0-40E3-992B-2C5CC6CD59D7@infradead.org>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <29F6A46D-FBE0-40E3-992B-2C5CC6CD59D7@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:4:197::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB8246:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a282d1-3f5d-410f-9960-08daeb179360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8x1ESNHc7es/9E+CqaJtOFOlR3Xd/MLj2MsiMVeKNycCPMlUau+2gplZPKon2G8UkQsllRxjuwfmyY/CPSHnrPImq1Y1QL1TDBxOStsTYidh9SOuzYHeuDFc8O2zzNOI88H2pteaBzIiC3J2B9MOn2yhg7/X/0M4baV4iArgxzPfnc339gO0La5VX3yIIbawbvh5gkhx7JJF4gYCYx0A9Mvy0K7H3UK2GAuRz3ebOYtI+fM47Eovpr2TDhbjvz6aUdJ7QJ8rRC3nsJDN8vi4i0JVjSLOMgdOitQ5+SGMTCa0cv7PGQODEjPKSZVgvT0fEC6YZIIXSwYPX6qBIWPR+dUEkhSdhiVXg7bXKHVCtGwTDdjU+8IT8soPSg0eWi77arWYhpCv70lZQIJ+KBvUICzWWdhaWplee//JPb6QzO9pEJShVp0Wom91qAGju4YUF+0pNdzVFZOvh+0Jga60Sxi7d969o4lw0H1PiyBx2W7WZLhqxlFXqZG+pxJDilDkZ6wTH1bAk2Vc1Y8/7QqHRfsQzElNj5CLPqYqRn8LIhB1ZW/E00Ci4q+rBhVlKS/OrP328ct/W6dnOz/I/6McqgRYCXeGYSveMo0FN2zG0QMyrSQuHziJlGzzvSQBJMZ3Z0v32EOsv3yY9g2wynx4oJ7fTNrhGyhvMEwoB1I2Fz0yt0Qu9rRSLV0qc2XwNss2HyLw84Z/kJJ7m3+fzmb+6k2eYSOoZL/UsM3rz74oiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199015)(6666004)(6506007)(53546011)(6486002)(36756003)(478600001)(86362001)(31696002)(82960400001)(38100700002)(186003)(26005)(2616005)(6512007)(83380400001)(66476007)(66556008)(66946007)(8676002)(4326008)(8936002)(5660300002)(41300700001)(31686004)(2906002)(316002)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGVqTnc3NmVyV1MzOG5iajR0YnlmRTZiTnVoN2Y3Zm9aTHo3eU5LalN2S2E4?=
 =?utf-8?B?dWV2WENtbm51bHdqY3BxZDBWOFBPTlhYaklDWWNERDhJY3BMK3BIWjh6bkN3?=
 =?utf-8?B?WWg0dG94UTd6WFZ1NDdJSEF6RFBrV3VxUFd3VGZENjhYZ2dJTTNLYU1leHZm?=
 =?utf-8?B?cFJoUHk0S2N4OGYzZGIrRG8wQkFNb29MUlk0VTNOK1c5NGtWdVBOSTJHalZR?=
 =?utf-8?B?ZU8wL29haWY2SGYyT0w1ZjV4dzVBeEhDN1VnSzhJVi9VMzd6Q3A2WE9yREI4?=
 =?utf-8?B?aHg5ZTJhV0F3NkZ5RnRHQ2ZkMlRkWHpFVDBneFVXR0NzbDU4d3hxeS9MejRI?=
 =?utf-8?B?cm5yQkEwK3B5cmNFREgrSjI3cko3TExTN2NNNFo1ODdheUhGTlZ5amhTSTlq?=
 =?utf-8?B?UC9nUCtvb1MwU251cXBGc3lqWE9IVHlGRzRUalFNbkpkVUU0OW5iOVRkeVNm?=
 =?utf-8?B?bk84UXExeXJCUjJzWExGSGlhQnlLWGk0a1pOQzg2SUdqK1NyQUpicHVNOGhN?=
 =?utf-8?B?V2FJVVZpVzhGRTF2U2liTjNXek9kRXU0ME9LZTQ0eVp3QnIvOUoyd1pjMUpt?=
 =?utf-8?B?VDdyQ1l3ZnBheld6S2lkWG82TEhUZmtCdDgrU2NoT0IraldYbk9XT3lIL3FQ?=
 =?utf-8?B?UVptb0VzTWhTellzdWEvSEU3cGRremNDQnhWZm5RenFQUGNSMGM0SnpFcVRN?=
 =?utf-8?B?dEE5VGFOUEF0VFp5N3hkdnBSMVV1QXI0R3R2ZzlWM09IeXJkaG9vaStXZ3dr?=
 =?utf-8?B?QkUrV0RNOE1scHlFd2JkZ0xtWUxKOWVYTWw0SE8wZmNnUEx0WTY1eW5nK3o4?=
 =?utf-8?B?YlEwY0JIanQrUWhWQ2F4ZHJkajc3RDBnVXlNOHh4UXhXVzVkZ3BwZUNOOEN0?=
 =?utf-8?B?RjRrZDdZd2NNbmg4T3g2T2FaVEVFVllERzZ4VEd4OEJQM2xGUkljb1NaUWRT?=
 =?utf-8?B?SHhyV01yZGk1c1J3cDNiNXBiZ1NJbFRMYkYxSEs3R2Y2a1hmR3hKVGpJbCtN?=
 =?utf-8?B?M1YxRUNjcERPOEJNZDRtQUp2UDJtaE5NMlJSNmp4Nk40bUVNYnhyN3ByQ1JX?=
 =?utf-8?B?bXk1SXA4QjBXN29VeENvdUJqSkRLN3g2dVRZNmYxZFJueTNWdjhjUGNEcW1B?=
 =?utf-8?B?bzRoQVdyamFLUHVmTFRjZ29VVXRaYTFXWmVoYlpVbDZzZDlPVHNnQlJYYzA5?=
 =?utf-8?B?QTNNckZBMDZKbHFieXExQWkvUTdFaUFWbG5UK0hYYkl0NzZQdXVzK1U2MTdy?=
 =?utf-8?B?THhEL21ROWR2RTNIWTBsNTNheGI5WlFmTXYrdkdwQkhtS0Fxc2dhd3lTbFBF?=
 =?utf-8?B?NEpwNnk5UlFxY1UxRTAyQzdKZ2FlVWYvU0JJV3dRWlVYZWpJbzBFbVRCRHNP?=
 =?utf-8?B?S3JTUVBZR29JelBjOW5OVENnc0hTMnlhS094d05OS3Z2QllwakpocS82QzdD?=
 =?utf-8?B?dk1MY0xhemVCZ2RpVE9jQkxLcmFuNG1wY2RORzJjd1RncHF4RDFMWUJnejRJ?=
 =?utf-8?B?OVFBZ0dtRmhwTTNVM3QwQi9Hb0ZZakdlaVRqV2dnanZ0WUVhdGg3VDl1M1d2?=
 =?utf-8?B?SVJDWEQ5bm9zdWFiMlV3OWdoZTk4RjgzbUtWQUlkTCsxMktZUVZEZ2phODIy?=
 =?utf-8?B?cURIZXFNYnBzZ3F0dXU5OURpOXl1YXRMRnRFUVc3c1VXaGVBSHBadk1nczJO?=
 =?utf-8?B?NWlkT1U3NlZtSEVpeDJaS1NldmlGMDNYOVJCajlkVG1ES3hkMEw2WWdNcytN?=
 =?utf-8?B?cXJDMEhnNEpGeDR5djFnMi92a3dncnFmZ0cxSDBTN25tVCtYNW8wM21zSzJn?=
 =?utf-8?B?bEZUbDIzdVpERlNXUWo3eldYZ1o1VVhmM0pHVUtsMnY5S3d2VmtJcGtmL2Ev?=
 =?utf-8?B?ckNrcEVmbWR5alp0LzBXQ203Y0R1ZVFyMnFHQ3JRamlmWWFXZFA3ZERkcTV2?=
 =?utf-8?B?RTlSTDcxQitpeW9KSlNVbDQ1SlhCOXEvSkN5alBETld2Z2FzR3JYa1dtVm5B?=
 =?utf-8?B?Rmx5cFcrZHFuRndONFlTVWVGazdJelVkMkRkZ3gyZ1RSc0w4Um9WUkZxL3Ux?=
 =?utf-8?B?OVRmOEpzMDhFUUtUbXdMYTk5S3BNN2tuL1pEZlljWkpGWGRrNTIvcDlMbDFa?=
 =?utf-8?Q?6UJ98vzPNeoytCPAtatqmWApG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a282d1-3f5d-410f-9960-08daeb179360
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2022 10:12:51.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfO1XfxBrU387GF+o41rNb1cLeY1DmQOj0P7gV+H4Lbp7rjymABxzDkmKyKPnq5pbsXydqYMgBsio+SzdcaPAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/31 04:07, David Woodhouse wrote:
> 
> 
> On 30 December 2022 19:20:42 GMT, Bjorn Helgaas <helgaas@kernel.org> wrote:
>> Hi Major,
>>
>> Thanks for the report!
>>
>> On Wed, Dec 21, 2022 at 08:38:46PM +0530, Major Saheb wrote:
>>> I have an ubuntu guest running on kvm , and I am passing it 10 qemu
>>> emulated nvme drives
>>>      <iommu model='intel'>
>>>        <driver intremap='on' eim='on'/>
>>>      </iommu>
>>> <qemu:arg value='pcie-root-port,id=pcie-root-port%d,slot=%d'/>
>>> <qemu:arg value='nvme,drive=NVME%d,serial=%s_%d,id=NVME%d,bus=pcie-root-port%d'/>
>>>
>>> kernel
>>> Linux node-1 5.15.0-56-generic #62-Ubuntu SMP ----- x86_64 x86_64
>>> x86_64 GNU/Linux
>>>
>>> kernel command line
>>> intel_iommu=on
>>>
>>> I have attached these drives to vfio-pcie.
>>>
>>> when I try to send IO commands to these drives VIA a userspace nvme
>>> driver using VFIO I get
>>> [ 1474.752590] DMAR: DRHD: handling fault status reg 2
>>> [ 1474.754463] DMAR: [DMA Read NO_PASID] Request device [0b:00.0]
>>> fault addr 0xffffe000 [fault reason 0x06] PTE Read access is not set
>>>
>>> Can someone explain to me what's happening here ?

You can enable iommu debugfs (CONFIG_INTEL_IOMMU_DEBUGFS=y) to check
the mapping. In this file, you can see if the 0xffffe000 is mapped or
not.

/sys/kernel/debug/iommu/intel/domain_translation_struct


-- 
Regards,
Yi Liu
