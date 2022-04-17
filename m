Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40B550481C
	for <lists+kvm@lfdr.de>; Sun, 17 Apr 2022 16:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiDQO7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Apr 2022 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQO7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Apr 2022 10:59:43 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2670E1AD9E
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 07:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650207427; x=1681743427;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tmhLhpIPUTZbTYe3mmn2uR85DIoMYeHNukaaCb7mzTk=;
  b=NQv2MzIjPxXVC6F3zOZBrA8creCZQlqNRgE4FvMVzOKr2BY/I3o7XGvE
   Qdq6ISO8tWV+QXMnAbtZizY8TXb7NSrls1rIM9o29rr9LKrMqhcLI5fli
   LdNVyTDzB2XdZoawQ4i7PZDkIXAS6Cej+ON+vi9uRDS6gxHRjVxJhm8Tg
   mVnRIGs9He7s7jhbbXv+rIUWBMB5FXZgPtnsdxkGUaFiEI6Pkt7fW2apD
   eMUM2egc3MjtWsAjvV85sJ1JdWos5ftFcxuQebb/LupK8/qyiBCkavCTQ
   nN5Z9i24TBE9oH9IZOngYTL/8F/ElMwQPVrhRt4YlZLa1w3+TrwOhRZso
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="323834341"
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="323834341"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2022 07:57:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="553887126"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 17 Apr 2022 07:57:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Apr 2022 07:57:05 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Apr 2022 07:57:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 17 Apr 2022 07:57:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 17 Apr 2022 07:57:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbRf/MH1TuxtQAD1LePh2Aen7SVqCba7UzF4B8sYazkkKYOFfoBxqjHdevoZ8dquvOzIOAAU1iwAvMTJ9NgyV0QF2EtUiPJx749szrMAzQVCd7Y78TnkllMGjM90WaclfjfJxQ3yhy6RBF73CDtLYkabrIrjoztnZW+ZvrqP6h/RLszKZGIX7vDoh5yEmnMStUV0uAIrkWMRDYTLpo3CCDisZ1AoVXPCBHZgXkHgDSUwvIsND60PL2SYTxAUie80phNuz6hhNLarEX4LKzNjFJ92ESBgJ29NmX3gtsT+4JOIuPITuZgCfpRYmOuIC8RGvOPQtmxwUzON7aoG+IYVEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ab8YnjyRRSxs+MscD1qxwSUpKqTYESC4UaC0tMvIUAM=;
 b=Bu3eXYTyNTFTU8hH/CwIpaojmjaHwtVUeZZCLBpbqCeMB/+Y5M2ASRo3YSkf1bfDYJFJn55WW/AR+wjnmoTL0EjtZAT3uc5TCNPvEhOmgE34zrcHgqnQc6Hsm3ZFCVcGGZRepePPE3S8XMASkyCMNb51L5AGFi0XOa2I4jNv03jiQAs+wRvT4co5L/EZulVlYGsWUSDWC27AkQwan0499zobIbHsxWA5SnKhJSdWD+iO5hpr+xPsvS7NvyneXKJAhIyx+zmzA09W6Lys0zqPjpV+WxeuHSFGNbpZrLqqCXmUhNIhTcYUM4j8s/PNTMUvJA1YF5zMaMvU2dGnFAKHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BN7PR11MB2627.namprd11.prod.outlook.com (2603:10b6:406:ae::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sun, 17 Apr
 2022 14:57:02 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%8]) with mapi id 15.20.5164.025; Sun, 17 Apr 2022
 14:57:02 +0000
Message-ID: <dea7b099-cc21-51f0-e674-50901a7a966b@intel.com>
Date:   Sun, 17 Apr 2022 22:56:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN
 mapping
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Kevin Tian" <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <17c0e7f2-77ee-0837-4d81-ee6254455ab7@intel.com>
 <20220413143646.GQ2120790@nvidia.com>
 <42f6e2ac-8abf-8275-01fd-9b0c5dd53b4a@intel.com>
In-Reply-To: <42f6e2ac-8abf-8275-01fd-9b0c5dd53b4a@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR0401CA0024.apcprd04.prod.outlook.com
 (2603:1096:202:2::34) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8fd9aba-e43c-4538-03a6-08da20828804
X-MS-TrafficTypeDiagnostic: BN7PR11MB2627:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN7PR11MB26271F5FE4B8C78D249A7F8AC3F09@BN7PR11MB2627.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wi+XpOnQmzVmYO/1eJVnUIgKigCSBA7fQbFf9zND3QHWnlBuBAYt9ungXmWgkbkdNVk5Sd/ROhHsrfwZIQwXC5cT89CaaVNsAXFTB4b6RJFNzU1gSUnIbkOBcjC74tA+QCApHN5OoHXSshPLjmD2pD0hQravCDP42xQXhBsEI/C/kJPESxe8WAkUjHGJmUib4QjfX3YrGPCsNObjWbE4nNgBbpLBpbWvlSML8b7Ul0oTpa34ILPuD0VBMRGLtFTU2xbZ3ygMBbtAc+7z/y6m/fAt/+cvUFwdxgG1BlvBvzXo2ZIXcJoHREifnvOaptxrikSiwwSpppE1NIdLKzpWWhcLZitKC2QQhXwwQPFyjHm8k8TD7/S5E1oCT7tN1zjEuG+URFjo1bQjUfKPzqg0MnkW6yrDiflieXeZ92rgaTZmTc6Hfn5DHl5QnKiyX+h5/Gau+QoFlkvB7FkOtnWcsxMIlmpB3nppM0IkOMzVJMl1GrDeCf/bsM/Gx+hn5SttkG57+fzdVX+tYYGgdksOwTQmHOTssY24eg/2bpiod9szKaOvPFyTwry8Vkp/NcY6RWSimoKTsmLrHhbRlh/JcC7VXlSL287CxyAZNhX6aOPPdIt9yIuqRAxFqIpl1C/AMsTRdUV2ORkroSewbo7RcLzC3Kf3rC0SOUwj6YH/vAle5+0irHc+5CSe39thvJNOyrbtA5bnSYEPA2GLBQ37P9PDlDVBktUIfcU9TIMCmLsaqDz43OyK6lK9tmhATT7H1wsE3+uQvL9LJhgkDZNwDfr2vuQf+buiakSE2r3/r1aJmmyZIWxX7wd6fxurcm5V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(36756003)(31686004)(6916009)(66946007)(7416002)(316002)(54906003)(83380400001)(5660300002)(82960400001)(186003)(66556008)(66476007)(8676002)(26005)(31696002)(30864003)(86362001)(4326008)(508600001)(6506007)(8936002)(53546011)(966005)(6486002)(2906002)(6512007)(38100700002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0xTaG4rK2xCQk1yNEZ3VllHT0JTNUlJNVdlM1BORXhVM1hiSFZJQlI5alZl?=
 =?utf-8?B?TFYvOWt3UzBpVCszbkM2cW1ob2JVOUdhbVN3R1dqazBwRDZBZ3RXYkJKbjNv?=
 =?utf-8?B?K1p0ODUyaldodldDZElKMldxQWIvQjR0VlZjK29DdnhTc3kwWkNBai9zeDQ2?=
 =?utf-8?B?Z1JCREloTHJRYnA2QkU4OThJbnlxeDgwQ25mZjZQSHpIU3Y5c2RkN1dKL0hl?=
 =?utf-8?B?b3FZUllqeWZXclNxOUJGSVNlNTdTcjJwQ2g5dXBMa1lVQU1BMHdNTWs1ZGp0?=
 =?utf-8?B?WEZERkxIb3NKVGgzeDBUYmcvWmRtNjN1NVNUZUF0dUVKeGYxVDZiNEZNZ0R4?=
 =?utf-8?B?MTN6WE1WVEpoS3VGRGF3VzRFQkNVemMvOTN2M1c0d2tZY3QxUk9aRVQ4amRD?=
 =?utf-8?B?aktrY0daR0ZUOFVBSUVxcnRBM3ZVSEVqcFpKR0xCOGZSLzcyQ29ZcENUeDlk?=
 =?utf-8?B?dThLcmRoWkR5K1VGem5JS3pYV1o1L25PaEtXTktGcEhIV1M4blpnbTBWU2xM?=
 =?utf-8?B?TWprQjlYY29wQnNhYm9RaURxKzdHVWh6dzA3cC9kWklBUGo1M05iSUVSbDM1?=
 =?utf-8?B?QjJrT0FEUkxjRnpqQW9uRk56cnc5R3hwSCtSbll2Y1FabndIN2NQZ2FPOC9n?=
 =?utf-8?B?MkR1aVRhWE8rKytnMEZyd3NsSUV3ako1MXIwY01rMThCbmcrMklSWWQ0Z09w?=
 =?utf-8?B?VGFHTHA5Z3ovZW1RYlhSR21DbTVYdlVFMlhmbTRmVEdVbzVmL3lNKzBVclpp?=
 =?utf-8?B?QjQ4RWdTTU1JUUtFdGREL3NCMjVMa1QwMHRYY2owd0tNc2hoMDRaMGswbkZm?=
 =?utf-8?B?Y0ltN3NlU3o2UVJPYk5kb0JQODRwWElCQWlPMVpHY0lVdHRiaEFUeDhTNEhF?=
 =?utf-8?B?RldjZ2tPM3N1bVBLZVVQVExnZTVnTHpiWnFickgraDZubUY3Tkhtc2ptSGJm?=
 =?utf-8?B?UHJqODFlKyttTTZ3Vituak8yWTBkTXFTcjcrVEdyQS9TOFk1U0FNOVZFc1k4?=
 =?utf-8?B?TllxcHRNZEUrYTlGalZwUjNyaGVvWjZHQ2tVdGFhMXpuTVVaYjU4T3k4MUhw?=
 =?utf-8?B?RmsrZUh4VEd1STlDcjNxZ0xLaTNUeCtPbldoeVozRm0rZ3hwd3QwY29KYUFq?=
 =?utf-8?B?MFp3UlFQelFHKzVwdnRkNTVBYjUwYnQ3a2k0ejhoQzZhQ2lKcWVLcXFWSG1K?=
 =?utf-8?B?SExMSnRxTW5Ja042eHFnbjREUEN1N3BaLzFuTWhuOG9GZ0ptSjRtaG5Kdkwr?=
 =?utf-8?B?TUdPaWRmRmN0aVRQK1RMV2ppU0x4ejBZU1BqVDVxcHJhTktZNTBqekRHcVho?=
 =?utf-8?B?MTl3TFR5eFFIdGpIVS9ybmxMdmVDUUswL3Z0c1lJd1JIUTcrdExCdUhoU1Fw?=
 =?utf-8?B?UVptYk1wWnU4WExSUWlvMm9maEdiZGVkcEZ4NXBmTWRzaEtXUHkvYU55dkFT?=
 =?utf-8?B?RXIxMUx3UEsvRlovSjhPS2F6a0VhT2UxU2I4Sk1ack9lM0NTcCtRTkd0S0Qv?=
 =?utf-8?B?NUw3OFI5dHNZVDBwYTZLSUU0cUtuM05mbGNvcUM4dTU2cWx2bFpXZ2UwUHp4?=
 =?utf-8?B?aVJlTkREZUtLMGZVUVFIckxlTVg3UGxrTldUam1XYk5tTTlEdVg3WFA4RkFO?=
 =?utf-8?B?bjhDbFFPN1pjQTVWVnV4UzREK2YvWE8rV1NxR3I4S0dhWnNUbjI3cVN6bE80?=
 =?utf-8?B?OU9wOWplQ09aTE1TNmtiTjRsbkM0N040dklWRS9DYWcyT05Fd1AyV2hUa21q?=
 =?utf-8?B?VW91MklMSlJraVE4eTVESEpIejBaTXdaYS8vb1FOUGd0S2JuSU1kVjQrdDlU?=
 =?utf-8?B?WStGcExabTQ3SFJPOTZVRGJITHgvclFkVW90UHZBWElabEtTR1JSdVJtWmZK?=
 =?utf-8?B?ZHFqVytRSXhsV2hDNitMYWcwaU9CTWpUWlJkcGlkR1QyRjArZG92dFRsZS9D?=
 =?utf-8?B?OENaUkI2QytNeTArT2FuL1ZWSXZuckFlU1BSRjBSck5kbTlZdjFIaWZWWVRQ?=
 =?utf-8?B?cGVYc2lKVDVXUWt2UUJzRkZmT0wvWmdIelczYTVDVWNwbEhsS1R2VzJLbng2?=
 =?utf-8?B?Q0NSVk45RCtMa1dNWlVSL0p3b2NkODJxelJNU3FDTEwxQlJXQ3RsZFNrU2Fs?=
 =?utf-8?B?V2poalphTTNwaHBFVmJNdS96c3NYQnYvNFlXRnlWVlNxTWhEd2g0WWpTNlRx?=
 =?utf-8?B?V3lwRExsYUxHWDRjUU9EeHA3UlBQVDhxb2lIU3ZXYlRYeFMxYzF0THZLUTls?=
 =?utf-8?B?WmdsRXM1dTZ6ZTU4TGJaV0E2TjJad2lIL3dldWFjR2RvczBFTVNvOCs0bkp6?=
 =?utf-8?B?YUJNSm9KMllHUVJDUmpZSll1bFlONk43UDJJRjR6QVd3MDFCc05oZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8fd9aba-e43c-4538-03a6-08da20828804
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2022 14:57:02.7554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7y+58WkDwPjCIOVeoYTfCf14LeTah5xJ70YWnYgO7dpEmdTE1pf+sxXtmcQnD9hVuxJt5pT67HaPWE8wMcmzWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/13 22:49, Yi Liu wrote:
> On 2022/4/13 22:36, Jason Gunthorpe wrote:
>> On Wed, Apr 13, 2022 at 10:02:58PM +0800, Yi Liu wrote:
>>>> +/**
>>>> + * iopt_unmap_iova() - Remove a range of iova
>>>> + * @iopt: io_pagetable to act on
>>>> + * @iova: Starting iova to unmap
>>>> + * @length: Number of bytes to unmap
>>>> + *
>>>> + * The requested range must exactly match an existing range.
>>>> + * Splitting/truncating IOVA mappings is not allowed.
>>>> + */
>>>> +int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
>>>> +            unsigned long length)
>>>> +{
>>>> +    struct iopt_pages *pages;
>>>> +    struct iopt_area *area;
>>>> +    unsigned long iova_end;
>>>> +    int rc;
>>>> +
>>>> +    if (!length)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (check_add_overflow(iova, length - 1, &iova_end))
>>>> +        return -EOVERFLOW;
>>>> +
>>>> +    down_read(&iopt->domains_rwsem);
>>>> +    down_write(&iopt->iova_rwsem);
>>>> +    area = iopt_find_exact_area(iopt, iova, iova_end);
>>>
>>> when testing vIOMMU with Qemu using iommufd, I hit a problem as log #3
>>> shows. Qemu failed when trying to do map due to an IOVA still in use.
>>> After debugging, the 0xfffff000 IOVA is mapped but not unmapped. But per 
>>> log
>>> #2, Qemu has issued unmap with a larger range (0xff000000 -
>>> 0x100000000) which includes the 0xfffff000. But iopt_find_exact_area()
>>> doesn't find any area. So 0xfffff000 is not unmapped. Is this correct? Same
>>> test passed with vfio iommu type1 driver. any idea?
>>
>> There are a couple of good reasons why the iopt_unmap_iova() should
>> proccess any contiguous range of fully contained areas, so I would
>> consider this something worth fixing. can you send a small patch and
>> test case and I'll fold it in?
> 
> sure. just spotted it, so haven't got fix patch yet. I may work on
> it tomorrow.

Hi Jason,

Got below patch for it. Also pushed to the exploration branch.

https://github.com/luxis1999/iommufd/commit/d764f3288de0fd52c578684788a437701ec31b2d

 From 22a758c401a1c7f6656625013bb87204c9ea65fe Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Sun, 17 Apr 2022 07:39:03 -0700
Subject: [PATCH] iommufd/io_pagetable: Support unmap fully contained areas

Changes:
- return the unmapped bytes to caller
- supports unmap fully containerd contiguous areas
- add a test case in selftest

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
  drivers/iommu/iommufd/io_pagetable.c    | 90 ++++++++++++-------------
  drivers/iommu/iommufd/ioas.c            |  8 ++-
  drivers/iommu/iommufd/iommufd_private.h |  4 +-
  drivers/iommu/iommufd/vfio_compat.c     |  8 ++-
  include/uapi/linux/iommufd.h            |  2 +-
  tools/testing/selftests/iommu/iommufd.c | 40 +++++++++++
  6 files changed, 99 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c 
b/drivers/iommu/iommufd/io_pagetable.c
index f9f3b06946bf..5142f797a812 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -315,61 +315,26 @@ static int __iopt_unmap_iova(struct io_pagetable 
*iopt, struct iopt_area *area,
  	return 0;
  }

-/**
- * iopt_unmap_iova() - Remove a range of iova
- * @iopt: io_pagetable to act on
- * @iova: Starting iova to unmap
- * @length: Number of bytes to unmap
- *
- * The requested range must exactly match an existing range.
- * Splitting/truncating IOVA mappings is not allowed.
- */
-int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
-		    unsigned long length)
-{
-	struct iopt_pages *pages;
-	struct iopt_area *area;
-	unsigned long iova_end;
-	int rc;
-
-	if (!length)
-		return -EINVAL;
-
-	if (check_add_overflow(iova, length - 1, &iova_end))
-		return -EOVERFLOW;
-
-	down_read(&iopt->domains_rwsem);
-	down_write(&iopt->iova_rwsem);
-	area = iopt_find_exact_area(iopt, iova, iova_end);
-	if (!area) {
-		up_write(&iopt->iova_rwsem);
-		up_read(&iopt->domains_rwsem);
-		return -ENOENT;
-	}
-	pages = area->pages;
-	area->pages = NULL;
-	up_write(&iopt->iova_rwsem);
-
-	rc = __iopt_unmap_iova(iopt, area, pages);
-	up_read(&iopt->domains_rwsem);
-	return rc;
-}
-
-int iopt_unmap_all(struct io_pagetable *iopt)
+static int __iopt_unmap_iova_range(struct io_pagetable *iopt,
+				   unsigned long start,
+				   unsigned long end,
+				   unsigned long *unmapped)
  {
  	struct iopt_area *area;
+	unsigned long unmapped_bytes = 0;
  	int rc;

  	down_read(&iopt->domains_rwsem);
  	down_write(&iopt->iova_rwsem);
-	while ((area = iopt_area_iter_first(iopt, 0, ULONG_MAX))) {
+	while ((area = iopt_area_iter_first(iopt, start, end))) {
  		struct iopt_pages *pages;

-		/* Userspace should not race unmap all and map */
-		if (!area->pages) {
-			rc = -EBUSY;
+		if (!area->pages || iopt_area_iova(area) < start ||
+		    iopt_area_last_iova(area) > end) {
+			rc = -ENOENT;
  			goto out_unlock_iova;
  		}
+
  		pages = area->pages;
  		area->pages = NULL;
  		up_write(&iopt->iova_rwsem);
@@ -378,6 +343,10 @@ int iopt_unmap_all(struct io_pagetable *iopt)
  		if (rc)
  			goto out_unlock_domains;

+		start = iopt_area_last_iova(area) + 1;
+		unmapped_bytes +=
+			iopt_area_last_iova(area) - iopt_area_iova(area) + 1;
+
  		down_write(&iopt->iova_rwsem);
  	}
  	rc = 0;
@@ -386,9 +355,40 @@ int iopt_unmap_all(struct io_pagetable *iopt)
  	up_write(&iopt->iova_rwsem);
  out_unlock_domains:
  	up_read(&iopt->domains_rwsem);
+	if (unmapped)
+		*unmapped = unmapped_bytes;
  	return rc;
  }

+/**
+ * iopt_unmap_iova() - Remove a range of iova
+ * @iopt: io_pagetable to act on
+ * @iova: Starting iova to unmap
+ * @length: Number of bytes to unmap
+ * @unmapped: Return number of bytes unmapped
+ *
+ * The requested range must exactly match an existing range.
+ * Splitting/truncating IOVA mappings is not allowed.
+ */
+int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
+		    unsigned long length, unsigned long *unmapped)
+{
+	unsigned long iova_end;
+
+	if (!length)
+		return -EINVAL;
+
+	if (check_add_overflow(iova, length - 1, &iova_end))
+		return -EOVERFLOW;
+
+	return __iopt_unmap_iova_range(iopt, iova, iova_end, unmapped);
+}
+
+int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped)
+{
+	return __iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
+}
+
  /**
   * iopt_access_pages() - Return a list of pages under the iova
   * @iopt: io_pagetable to act on
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 48149988c84b..4e701d053ed6 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -14,7 +14,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj)
  	struct iommufd_ioas *ioas = container_of(obj, struct iommufd_ioas, obj);
  	int rc;

-	rc = iopt_unmap_all(&ioas->iopt);
+	rc = iopt_unmap_all(&ioas->iopt, NULL);
  	WARN_ON(rc);
  	iopt_destroy_table(&ioas->iopt);
  	mutex_destroy(&ioas->mutex);
@@ -230,6 +230,7 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
  {
  	struct iommu_ioas_unmap *cmd = ucmd->cmd;
  	struct iommufd_ioas *ioas;
+	unsigned long unmapped;
  	int rc;

  	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
@@ -237,16 +238,17 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
  		return PTR_ERR(ioas);

  	if (cmd->iova == 0 && cmd->length == U64_MAX) {
-		rc = iopt_unmap_all(&ioas->iopt);
+		rc = iopt_unmap_all(&ioas->iopt, &unmapped);
  	} else {
  		if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX) {
  			rc = -EOVERFLOW;
  			goto out_put;
  		}
-		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length);
+		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length, &unmapped);
  	}

  out_put:
  	iommufd_put_object(&ioas->obj);
+	cmd->length = unmapped;
  	return rc;
  }
diff --git a/drivers/iommu/iommufd/iommufd_private.h 
b/drivers/iommu/iommufd/iommufd_private.h
index f55654278ac4..382704f4d698 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -46,8 +46,8 @@ int iopt_map_pages(struct io_pagetable *iopt, struct 
iopt_pages *pages,
  		   unsigned long *dst_iova, unsigned long start_byte,
  		   unsigned long length, int iommu_prot, unsigned int flags);
  int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
-		    unsigned long length);
-int iopt_unmap_all(struct io_pagetable *iopt);
+		    unsigned long length, unsigned long *unmapped);
+int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);

  int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
  		      unsigned long npages, struct page **out_pages, bool write);
diff --git a/drivers/iommu/iommufd/vfio_compat.c 
b/drivers/iommu/iommufd/vfio_compat.c
index 5b196de00ff9..4539ff45efd9 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -133,6 +133,7 @@ static int iommufd_vfio_unmap_dma(struct iommufd_ctx 
*ictx, unsigned int cmd,
  	u32 supported_flags = VFIO_DMA_UNMAP_FLAG_ALL;
  	struct vfio_iommu_type1_dma_unmap unmap;
  	struct iommufd_ioas *ioas;
+	unsigned long unmapped;
  	int rc;

  	if (copy_from_user(&unmap, arg, minsz))
@@ -146,10 +147,13 @@ static int iommufd_vfio_unmap_dma(struct iommufd_ctx 
*ictx, unsigned int cmd,
  		return PTR_ERR(ioas);

  	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL)
-		rc = iopt_unmap_all(&ioas->iopt);
+		rc = iopt_unmap_all(&ioas->iopt, &unmapped);
  	else
-		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size);
+		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova,
+				     unmap.size, &unmapped);
  	iommufd_put_object(&ioas->obj);
+	unmap.size = unmapped;
+
  	return rc;
  }

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 2c0f5ced4173..8cbc6a083156 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -172,7 +172,7 @@ struct iommu_ioas_copy {
   * @size: sizeof(struct iommu_ioas_copy)
   * @ioas_id: IOAS ID to change the mapping of
   * @iova: IOVA to start the unmapping at
- * @length: Number of bytes to unmap
+ * @length: Number of bytes to unmap, and return back the bytes unmapped
   *
   * Unmap an IOVA range. The iova/length must exactly match a range
   * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
diff --git a/tools/testing/selftests/iommu/iommufd.c 
b/tools/testing/selftests/iommu/iommufd.c
index 5c47d706ed94..42956acd2c04 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -357,6 +357,47 @@ TEST_F(iommufd_ioas, area)
  	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
  }

+TEST_F(iommufd_ioas, unmap_fully_contained_area)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.length = PAGE_SIZE,
+		.user_va = (uintptr_t)buffer,
+	};
+	struct iommu_ioas_unmap unmap_cmd = {
+		.size = sizeof(unmap_cmd),
+		.ioas_id = self->ioas_id,
+		.length = PAGE_SIZE,
+	};
+	int i;
+
+	for (i = 0; i != 4; i++) {
+		map_cmd.iova = self->base_iova + i * 16 * PAGE_SIZE;
+		map_cmd.length = 8 * PAGE_SIZE;
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	}
+
+	/* Unmap not fully contained area doesn't work */
+	unmap_cmd.iova = self->base_iova - 4 * PAGE_SIZE;
+	unmap_cmd.length = 8 * PAGE_SIZE;
+	ASSERT_EQ(ENOENT,
+		  ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+
+	unmap_cmd.iova = self->base_iova + 3 * 16 * PAGE_SIZE + 8 * PAGE_SIZE - 4 
* PAGE_SIZE;
+	unmap_cmd.length = 8 * PAGE_SIZE;
+	ASSERT_EQ(ENOENT,
+		  ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+
+	/* Unmap fully contained areas works */
+	unmap_cmd.iova = self->base_iova - 4 * PAGE_SIZE;
+	unmap_cmd.length = 3 * 16 * PAGE_SIZE + 8 * PAGE_SIZE + 4 * PAGE_SIZE;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+	ASSERT_EQ(32, unmap_cmd.length);
+}
+
  TEST_F(iommufd_ioas, area_auto_iova)
  {
  	struct iommu_test_cmd test_cmd = {
-- 
2.27.0

-- 
Regards,
Yi Liu
