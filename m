Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3DF6BEECF
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 17:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCQQsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 12:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCQQsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 12:48:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E9B567A1;
        Fri, 17 Mar 2023 09:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679071715; x=1710607715;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iqo85ZKOial/CMfjsFO3lPdUa1pCQ+PDxgUzJbdjiT0=;
  b=R2lLYNg+b8P1G47ec4L3a3oNhQUEJxJ70YXxv3tAPL/5hBnp/GsIu7PP
   JfCewHXs3/v51syZS3tPewhkuWyfliuk0ZOZalQ+M0oqE1XJos6ZlaMtV
   XSaOocMISuoz2u/U8wrdji/HOw1Wn5cTinys2OPQRCOaobZT134/jCzva
   MZKv1+ATF4zj7utxWDztVEdiDQte2ZkNDepYG8HF1rSaxgGGokqHnev8G
   C1BrZETUknrgDhSFckECU9vhsSPnwWILdGWQfVarPUUuais/oYB4Q9WSx
   wTFbOrqcaisXBQEvyOllrt6PS2ZhE4aouHUtAleCPX3tC59WuG6AstLGr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="317964711"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="317964711"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 09:48:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="854502110"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="854502110"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 17 Mar 2023 09:48:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 09:48:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 09:48:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 09:48:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 09:48:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuVPam20hvF6UXDJvRwNFm45QTFBbzo+DHvyV+De2vJSGu8Rllo8FuKFVR+wrPARPWRphC79jC08FZYKsRUCgvpW7z2w0ucLASz2DMKwVjWfXIdk2y5OedUX/GfR7xWE5r/AJG5Re9vQRTEsFgnpEcxTWrX77ww/bq5f/lUBdL28IArgckDtlfqo6kZAb984jtLbrqWnxfmAeU00uOO9hr5w9M9QCqdVsQlKbzx7YququjNTozIf70iYu7wvHnAxGmNRtfL+RiwAIE1wuNpFtSUcFMzquFPXzuKT4f96UzRwDcwnFV8oeNVUqH7dC8IROxFjNzrXUJ7zrpnsMcecYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOObwVl5dzM4JmhRnkseES5yLmyn8F0z8sLSZhEyTf8=;
 b=g9y5UvPVPftUU0/gjn1VCDaIQan02J43oBR9g0k0AioCvjXB/dGNIGtylYP0eEDPmbVAc3DHHOFZbHHSVSe7QsTwBoFPA3svn1RULn3BcquaKdMpu4hZUIsIb0vMobLOirvuAzBM8Ziy1NN7AOCUXo1sxLTuYRJRLFfXp51bfNkuQiSsA7elNWLh5nGbtYyOdOkz0fac0lCI7CxwTg+oZKCx/Mun/YCEeYaMNpDFx0vajC3wCBdOerouVA1293W8c4J7UWOP+No40eMZvJ6W09EA8+58n8CouXoUmUSZKcKgjm6n6/N8EWdaNyeTiHzu3lTPmaAKl7OvEsLjC0pBAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DM4PR11MB5472.namprd11.prod.outlook.com (2603:10b6:5:39e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:48:19 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6178.035; Fri, 17 Mar
 2023 16:48:19 +0000
Message-ID: <93de5e89-cab3-fa0d-e534-7e6efddf8468@intel.com>
Date:   Fri, 17 Mar 2023 09:48:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 0/8] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <20230316155646.07ae266f.alex.williamson@redhat.com>
 <4d72821b-36a2-70c9-ee58-f7a21b13510f@intel.com>
 <BN9PR11MB5276C1DE988777A97FC5D2A78CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276C1DE988777A97FC5D2A78CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:a03:338::11) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DM4PR11MB5472:EE_
X-MS-Office365-Filtering-Correlation-Id: fa34d826-7968-4121-10c1-08db27076945
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AP4lRa5DMB1BYDoWHjUHDEqlwjRJcg97+ae2kjAT2X9WIR/ovooym4dAT4o63vldrjObN+EeYoyGRPgmFDpyjAXI9zTQpohnYX536HdYUQfOeHS/UqDySC7FcoW6ea2/h5BpNibuzVBSW2/4olj5F9Rdlc/xsUZvFl4L9OEaNLYhE+kLdxrGVdy5d4j2vbuu7uANG+aRzDtR7lLVbcJL31yeEZMAbkx95x89gF9imw4Mqn+fgvvPItxw5IdjKsJg6v43NG2+dDO93VAuRPRac0uGyaM+Vo+rNxmml6q+Wrr+53fXxuWibw3PtE49Qz/+Q3A+9OEYAQGO/6aU1/bPajktutU1dospNRCUylD/P3MJhrcB9S/4wrDEDHlAQnMVG3xDcqdujlZkhqZ/eMGbttnIwQgy2f/mRn8Jy+8xLOD+VdZPUzegWyHrVLPeG4p/U5veKwVLEdff9EqM2GA91eDbDd/LTHwxU9RFUyj0uWXdN82scT0UeI9Y0Y3oEdNk/8/cqZ+9JLa26OOaPIcRkNKmXrL+aK8OjiI4wIGY5F4ATbVqxcUCQLVCKzoehNvSlhdmsopKT8ob4fZ4bYxSd+NKzGEk42lpQau5GYWA4P+pHE9z5KErVtMivsaJ6bditrdqDmdxBmtizd9msyZqzQTvOqe9i6PGGVRJVjHTN6enJ/0Oo7yltnWTnUPvRRrff0Q//czVBkIJkP6COqEzuRFjO+MvMTpWqueyDp6OcVw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(31686004)(8936002)(83380400001)(8676002)(66556008)(66946007)(44832011)(2906002)(4326008)(66476007)(41300700001)(36756003)(82960400001)(38100700002)(5660300002)(2616005)(6512007)(53546011)(186003)(6506007)(26005)(6666004)(6486002)(86362001)(110136005)(478600001)(54906003)(31696002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWlKTDZPUndhdmFCeTZIYms1dGphMXBDUzByQS9wcHZpcjJQK2svK1graGd5?=
 =?utf-8?B?ZHZMbUdTaVVTYWJZZGpicXJETVo2ZDBpS3VRd01IUHJpL1A5NDU5c3hjNGhU?=
 =?utf-8?B?ZEsxZEZXOUdPVTFLRE0yQVVESVlKOE13N3E5NDJ0TkYxRmNBNmVDNFlKZGtQ?=
 =?utf-8?B?azVFbzFLSFA1RU1xZ09vVjRKSGVzMHFkSlVIQlVoN0gwVDQzTkFCWW9Celp1?=
 =?utf-8?B?c05mdGZtZWQwem95aE56TmJRZW10NDhWM1ZvZ3FGUnd2WkYwV2lNdm13NzlG?=
 =?utf-8?B?c2FXRTVaYWVmUzBGajluSEYyMGdGa2xtZHo2ckxqdmRSZlpSVEI2OGpHTGpL?=
 =?utf-8?B?cXJrdTNSOGZnYVI0aVNER09VQzBpczBaQWFMVmQ0YUVTNUhOcVhPL0lqb2Rh?=
 =?utf-8?B?cm50VXBkS2ZQYWhlRGJ5UjRDK3Q2VDZ0OVV0QlRFYXpVaVV5R1I4VytlN3d4?=
 =?utf-8?B?a1JhQlNtZExZSEpZNXBGVHAzbnM5WWRXWXhGbm8yZi92V2dWV21lbm1UL2dp?=
 =?utf-8?B?NE9zL3BRVUVyU09jVThnUExJalBDTDVadWUrUHZMOUZCQkt2MmxrbFAvcUpi?=
 =?utf-8?B?YzhvdFRENkVCMG9vMm1nMWUzWnhUV0FQdVQ2TVpVRmppNXhSMG92SW9iYy9T?=
 =?utf-8?B?WjFJZStpSGp2YmdlaFEzUEVQa09mZnlPQW1NVDBlVzkyMDJVNXp6eGUyVEpU?=
 =?utf-8?B?SnNtRzVTNUl5cmE3cFhnREg0Rll3OGlqdHlQeE9Ddk9DeW1uczltL3JZTDBE?=
 =?utf-8?B?YS84eXQ0QmQ0QmRoR3RFaUpRSGNuaEh2TGZudnNJTlc4a2FLT2NaVm81bFZP?=
 =?utf-8?B?bFYvZ3RGMUNvbTJVbkVNZ2U2MTU0T053QUdsbGtGYlNReHdCaGc0bnl0b3FR?=
 =?utf-8?B?RHpINnNOT2VyQ3k4YXdjWXBwdzk3UjlnMldaMUhRNmdtbStkdlNXRmk1R1Bm?=
 =?utf-8?B?KzNNM1NQdHl5VUN4dzlqYVBmUHltQWNUNkJJY3JybFRtTFFEaFRsaW9nVTV4?=
 =?utf-8?B?cDI2ZU8ybkRpTS92azlOeHRQbGNFQlByVDZhTDJIOEpIUWpwZmFWQTNxMi95?=
 =?utf-8?B?eVU3bURRRFRXc25VK3lCbm5IMklodDIvWk9Ja05MTklnK0pLeVJlNm1EdFRu?=
 =?utf-8?B?Z1MvZndKRmduUnRGVHgrZWRycVpTOWxTTmtkOTJ4WmNIOHJpZjZ4VHljMnNt?=
 =?utf-8?B?dVBISzdEdXhaNEc3bGlvVmVMSWxNMTdoVGs2YUhOTWQyeElOL3dtODVVMmJD?=
 =?utf-8?B?eGswTDFmRWJPTVE1OGJkLzFtTU5DVGJLSFc3NzJ3SVR3Vmozb3RoQkVvZVNS?=
 =?utf-8?B?SHFXUkRLUjR2dzREcitYeTVwRzhQK0s2SkVBR2lYRzI1ZDJLSjREUG03K2Ft?=
 =?utf-8?B?cjNNVFFlMFBiTE1xbEVrUHN1YU5sejhFdWR2RGwrRzAwcnZSdVgxOElGUlJC?=
 =?utf-8?B?TmN3NENYUDdaYzlLaU43NXRsclYzRWZYRnNjbnZRRkMwUTdNOTJWSnRTNVFK?=
 =?utf-8?B?ZEx6N2o2ZFJTcFhvSithNTJ6dXBnSEdJY1R0alE3bTNUSDRDdExXTkxhWHk1?=
 =?utf-8?B?Rm43MzNoclY2dUl6L2IzejAwL0FmUll1WUJvb0hTVnovSWR2OE8wK2lUMllM?=
 =?utf-8?B?OGdhelhKYldycmtHSDYzb1dLUG5QYWdIRnNNRGZTZVdpcUxKZVNvekZmQmQv?=
 =?utf-8?B?VnBxbSsvU2JxNmNJYmthWEU5U3cwclNPdk9rd1NUVVEzZ3R3Y0QyQ3ZNQjA2?=
 =?utf-8?B?M2tBL0daTWJoTVMxRDJaVEU3ejhHNzNZbi94T3FUNlJDVmwxL1ZsZnZrcUNl?=
 =?utf-8?B?eTBxejJNR1QrTTBEL0VaOGFEaUxiNWdBN2lTNjNLLzUyMTlsT21TUjcvaEE3?=
 =?utf-8?B?OWQyWXV6NS9qUUIxUk9QWFIxQzlsZVVmZnZvRld1alNMeElkbVQxTHlUNDAv?=
 =?utf-8?B?dTVLWGJwWGE2eVVrTE50c1NhbVcwQnZGUTdmZ3QrcCtvb05paVQrRlN4QjZL?=
 =?utf-8?B?MHE0SUFFSUFkVy9ZL25yK3ExaDRZM0o2bUJkRnF5a3V5amxlU1FvenVMWGtV?=
 =?utf-8?B?bENlRi96Qm9LVlBvMmoraXBJZkdhaENqRituT1ZKcHdoSElzOTJlUHQ4aGU1?=
 =?utf-8?B?Ly94Z2YvbzYwNGEzYm82QlZZUVp3eW1hY21kdm13ekgrMUhNaW1sbzlXT0Jo?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa34d826-7968-4121-10c1-08db27076945
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:48:19.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0htXaJ2LET+ZBa4az2wCDwJ5eWjr2Ot3pPBfsPqZbVf0Ep2GiT1onFUQENeitvbfqGc8oaRQXoMfPDi4bT3MrcbdYbPSNgGNf+E9v72ICc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5472
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 3/16/2023 4:52 PM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Friday, March 17, 2023 7:38 AM
>>
>>> Based on above, there really can never be an error if we expect the
>>> device to work, so I think there's a misread of the current status.
>>> Dynamic MSI-X support should simply reduce the disruption and chance
>>> of lost interrupts at the device, but the points where we risk that
>>> the host cannot provide the configuration we need are the same.
>>
>> Thank you very much Alex. In this case, please do consider this
>> submission as a submission for inclusion. I'd be happy to resubmit
>> without the "RFC" prefix if that is preferred.
>>
> 
> With that do we still want to keep the error behavior for MSI?
> 
> If no patch5 can be simplified e.g. no need of vfio_irq_ctx_range_allocated()
> and MSI/MSI-X error behaviors become consistent.

Thank you. Yes, if I understand correctly MSI and MSI-X error handling
can become consistent. I'll modify patch 5 to remove
vfio_irq_ctx_range_allocated().

Reinette
