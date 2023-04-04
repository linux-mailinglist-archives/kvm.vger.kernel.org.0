Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F046D6E46
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 22:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbjDDUqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbjDDUqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:46:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DB35251;
        Tue,  4 Apr 2023 13:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680641169; x=1712177169;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ppW+EpTPyGWzXqEGPHeSuMn/dB3F27hGqhk2b9lcpws=;
  b=HeT/rbOqsab9p/r/zJmUinwRdUsi6p4dRWpnQqVOO8CLcfOgnZ6sPTpP
   WYpjeDn6gmovpDy+cjfHt3WXSb8FI14MhNQHSI3HV8VF3fwlsN+IyfHEe
   RqxOwyG0G1Vx2x47bjpU/q05LOqJoNRjiAhoAKPfqMejeSqbqQvhFzyaq
   J+AmIKZOTgmt99Pj69BLHMxDjHaq7PmSTS5mVd0Bbqss/mNu0XnfkzR6D
   Z01tULxxcCmmIXsbQGrbr20clna2IvfEEsUj7m/WkuSdLsydIv+HNP16h
   uyG7s6yDf47z0OP978ean6EM0t9m06lZgSqsaj6qipY5FavXDOo/FBZqX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="407378167"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="407378167"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 13:46:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="636658355"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="636658355"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 04 Apr 2023 13:46:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 13:46:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 13:46:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 13:46:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 13:46:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=botcEDEQxTMI545foxfG4+148l97R6kQe6jfggfXM7BlNpTEkasOmlkooRjH4hncCZETMX1xjI2XPaW8Vvs+Chz43hbuHSzMmUtygzIaJXpI/RsgFCaUVxo47PQYBgFHNJDRLQYR5+mTLR1+f9vYGBsWlfiYpUVkhsx7jWUKYBocws1y/aTejl/3gJDxhXcyZ9MXtV/33IiGeSuMzUOjHZr6m2L2mIIzDimoNJO0k4kVoFbEVoJw1xaT7eH7gKnU7N7zsbg1707U65DLF4GIgaHKxNXUAFh26tX3GX8wqS55KA3mUVcfHAKTPpBbwA3Iio12UnDDODNk7E27Cs7E3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yaoE42AhkZCR7naFmos6w4CJuyVYVrSqw4q+PqYbO1I=;
 b=OGf2GIKz5d3PtB6AglwzLKVAm0aR4FsdWzXDAiWDcDJyf/5d7xqwZfV1r00EJjDN7SmFfoAZLVaUaFCEg5dJ1nVuqs2a3MttRdIfoKdQvZefluq79pceDwbg+ybAC1DDP5UUCcxFQZd83nRe08oygdQIV5+BMRHisw/5xbyhp5WLPAD5e3jMdPupNocVBPfyncRfhMWFJClpfPrz+faBx2i/uEtxQsul7ck1Dp9gUSvmN3CaUHB1gkJCpjgLUrPXSq3qVpyej12Q5YPtlg+LemC8FPu65LM4us0mKNAUYgIWK0Yjl9PQGis7hfQu+JssOKMtoZKoFFbgSiKzroUkaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DM6PR11MB4737.namprd11.prod.outlook.com (2603:10b6:5:2a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 20:46:05 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 20:46:05 +0000
Message-ID: <cc84101a-b6d1-c33d-d7a8-115f846c358c@intel.com>
Date:   Tue, 4 Apr 2023 13:46:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <20230330164050.0069e2a5.alex.williamson@redhat.com>
 <20230330164214.67ccbdfa.alex.williamson@redhat.com>
 <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
 <20230331162456.3f52b9e3.alex.williamson@redhat.com>
 <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
 <20230403142227.1328b373.alex.williamson@redhat.com>
 <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
 <20230403211841.0e206b67.alex.williamson@redhat.com>
 <BN9PR11MB527626CAE4BA7ECB64F0E9728C939@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ad8c9137-bd57-4862-46c8-2c77a21b3419@intel.com>
 <20230404124334.45cddae2.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230404124334.45cddae2.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::34) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DM6PR11MB4737:EE_
X-MS-Office365-Filtering-Correlation-Id: 3472c404-b745-4bf5-9fc1-08db354d9b81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YfKekGGNkGTqppf+rDiA0coVIQ/YmgkwxMFGwg4JbdvUhJRD2G1CxHjtlRmLrEA0jDKeClSLt5rd4W3A58ca/8Of9xrLio4TT9XaBPsMDCp9FWHHSk0jb1paxAzNeTJp4r+WMCG8A/7Bih7FqPUs0IpTgoIzu0os7ZdAfY9TGFbV4Rd2GMz6iExw6tjRoz49ylMbgAGKg1TJTm5beRHwZnK/K4eia155f2wVVEgPK6Bm63dslt0ut5eRxVs12dTsrYjvxjJsYfS1+gT9OayVeeEy1Tq95CB0/QMW52sUyS65MFBOQm+VNAIhYd1bp9nnUUE6BmQvaAhM/dGzpU1u7dn7Aiy1Va8kVMhkRmt8FRtE0Nmr/gU+ooJMA+R8uKf4qY4TrmdQohbOJDuCjdaUQhFngtgdmn1rsN0dMVqebTU5w9UsURsDbD7PtCV2i8a3OX7aWNP9KtraqoVwQLz7DMtswpGekj8Fn1D/P7N++LLw16MLoPdzeeCP8WZ/SYBYFoat4cLsyQxp9G3I+Lw6dQ9WUbtpr1MIkZLZc/XL+Fvmrb0FZKmVsxOuExx4rbfnc9Zo4NW/XnwJot4d354ixc7fb8T1fDORyrubiccXLLeQbAeYPlBjvKakZPQbNPs4SxkYNeZ9JNkojdHtPwmhcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(8676002)(4326008)(41300700001)(478600001)(66946007)(66556008)(54906003)(8936002)(316002)(44832011)(5660300002)(66476007)(82960400001)(38100700002)(4744005)(6916009)(53546011)(186003)(83380400001)(6666004)(2616005)(966005)(6486002)(26005)(6506007)(6512007)(31696002)(86362001)(36756003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VldnY2RJTS9nSzUwNEFSWXlncFIwYlFUdTV4cXZjYm5yc3RsaXZBUGVsLzlv?=
 =?utf-8?B?MUtKTkNNUyszWFNUTkNGTWgzeFBHRXdzR0E5RjVhaGpRalFiM3ZrK3RwZFR2?=
 =?utf-8?B?NVM0M1dudzQxSlpwRXdCN1ZZeDdSaEJudFVTQldwRGtCS2t0QTE1Z1R4OUtk?=
 =?utf-8?B?YVF3amY4L0ZkWEtmbXRTZTN6eHM4cG14WnpwS1FmcGtqYjZHTktEejlUcmU4?=
 =?utf-8?B?bktUSlFWelFLOWVQaXpJVmNtenFTU2Z0V05kNkZ4M3RvN2dIOEwyaWp6UnUy?=
 =?utf-8?B?ajJxU25QRWg4aVVJak5lWDlueVJKakRINjBFaVVqaU80QTlFKytFdFlsS0tE?=
 =?utf-8?B?MUR3UFRzWDkvaUd6b3FaUXJpYS93Q3R3RjNCa0NKTXZqb2Q1MVUvQUVWVCtk?=
 =?utf-8?B?RC9DT3BoUTNKSGphZ2FtQ09JOXAvbW5OQXV5MmNmZStzaE4zMmlSU2tkOXVn?=
 =?utf-8?B?TEUrNFpYaTY4Q0RST3ZCeE03SWs0Z2hQemQ2YzRBNDM3TGRBRWNXTVk5aERE?=
 =?utf-8?B?TllvbU11VjAzaCtTeXZrY2RYMVFGNHhuczNXMFMxajFhaEVpRXNneE04aFRD?=
 =?utf-8?B?Qk5EOWtCV05Mdmpna0hMTUVBRXQrZnUwVFFlcGxqTDI5UWtrM0dScnNyUDk4?=
 =?utf-8?B?dzNjWmpvL1V6U1BtaFREaDZiVjNLNERqL2lSRFkxakZ0UThHSm1YNnZodkQx?=
 =?utf-8?B?elRmVHFNaE9kWVZJcythWUNhTjkyQnNtdlB4R0E4Z0FiNkMrbkRQbGlwRXdO?=
 =?utf-8?B?MC9FK0crbVB6Zng1NTNtSWZETEFrOXY4TUp5RmNIQ0JMdThzejRQK0IvdUI0?=
 =?utf-8?B?NE9WOUZTY3RQckhsOUc0Q1VDdFNxL2FoNzFnb3FSOXhaTFNnRVJzUnJJOXlE?=
 =?utf-8?B?cjZEeDNORzc5VUM2VHhFeGhISENlcjJEbldiUEN5YlFIZmtzWHVBbjNCYzIr?=
 =?utf-8?B?UjlqQVZua243THdHbTBoaHlRdkRobnJtWUpqSDBSWmVxNXh3V2dTWUkxYnlF?=
 =?utf-8?B?Z3hYWWxLZy84Y0I5bUt2SmlOTHJWV0ZZM0R4SlhMT3A4OUlEZzIxaUZodkQx?=
 =?utf-8?B?bHM2TzZQMGgzMVlDMWNPRHJJbHlGK0hXYnUwQ2tVamEzRXZrQnRQUGZFQzZp?=
 =?utf-8?B?b1B6ak5OSFdpQ0xDMURpc01kUVVBQ3JCUEZpbUp3WDJZRVN3cTJOV3pPMmRq?=
 =?utf-8?B?U0NydnBBZFdvMzRLa1R3WGhKL3VENXB2eWdUNHlxY2hIMVJHbElFM0VNN1I1?=
 =?utf-8?B?VUQrVU8vSE5jOGUxeTZuMUtUNWRtK2lNaGI1bjRmZytNaDg5a2VvNnNYVmdT?=
 =?utf-8?B?Skd5QVQzWDI4SG81QmZ2RENPUCtaZWhmeDN4d0IxT0tlVTUwS056cGI1REJQ?=
 =?utf-8?B?UExRWTBCU3JVQTJkNmVyNjR0Sldrb1k3M2hISkpwcm16SzVmMml5ZTVaNmVT?=
 =?utf-8?B?TkFCbFBLeGZMQmdHSHg0ZlRSU2J4bW1kK2ZKQktUM1FFazJvZlVmZk55d3VN?=
 =?utf-8?B?aWg1MFJqUkxiY3VoTVRrZlA4L1NJaDhWaFVjQU5HSGc2eFVxc2wwaCtJeUhp?=
 =?utf-8?B?RllhUGYwWVl4U2NSbktkU0VnOHBFZFNQMU9YL0w2WHlkZURxNGJXL3UrazEz?=
 =?utf-8?B?MnNoWmJ4L1Bqd0ZXUG5Xbm5qQ3lLbGhYVlMzZzhrQWZpWWFEVVdtcHJXYW5w?=
 =?utf-8?B?VXAzSUVGT2huMHVYT1RhUld5a2czem5XWmIxR3E3N1Y1QUVma2Jvc1lIZkla?=
 =?utf-8?B?cXE1eStiT2Y2TnUvblhJbEp5SkcyQmtuc0U3Rlo5OUMrQlR3M29WMWxyVVQ5?=
 =?utf-8?B?dkVhR24xSDl1emExY1BOYWhvL3piQzJ0TzVKVmlueFhINmFhN2RCcjVKQ2Y0?=
 =?utf-8?B?ODJML0REWmtONFE1RHpMY1djdjRueHlqVy80eENrM3lVeXhqeDFqOElHcmNV?=
 =?utf-8?B?aFpBb1loUi9ySEJqcWNXMW81YVdVNEFPOExlcDY5NENFWldBUkdyYlUwNjQw?=
 =?utf-8?B?SjV1UzJ6a3plZE9RbStoYjY5ZldnamVxazduNk9ZTFN5aG0zbG4ybXcveU9M?=
 =?utf-8?B?VzhucU1USFJ4YWs4N1RwTWI1RXlKcVJWeHEwUkxmdGpTdzdsYjBVTXF5cjFD?=
 =?utf-8?B?ai9iTEdqR0h2RTRYMzJ3aTNxbVJ5VzcwSEJEWWYwZDdrQWQvRnR1dWg3M0ty?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3472c404-b745-4bf5-9fc1-08db354d9b81
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 20:46:04.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5IrJr76LX26jd72mZxEwbY7rM14ld91r4im53fHM1kVebiNSQnjqqYfFdhm2faGn8Q+ISR88UHhSkTw/kpNj+pUTEaxro4YWbK8QGbkDro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4737
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/4/2023 11:43 AM, Alex Williamson wrote:
> 
> I think Kevin has a point, if it's correct that we do this get/write in
> order to account for manipulation of the device since we wrote into the
> vector table via either pci_alloc_irq_vectors() or
> pci_msix_alloc_irq_at(), then it really only makes sense to do that
> restore if we haven't allocated the irq and written the vector table
> immediately prior.  Thanks,
> 

I see. Even so, could it be acceptable to call get_cached_msi_msg()/pci_write_msi_msg()
unconditionally (for MSI-X) or should the new [1] vfio_pci_alloc_irq()
indicate if a new IRQ was allocated to determine if 
get_cached_msi_msg()/pci_write_msi_msg() should be run?

Reinette


[1] https://lore.kernel.org/lkml/20230403211841.0e206b67.alex.williamson@redhat.com/
