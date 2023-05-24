Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129FB70F8E0
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 16:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbjEXOip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 10:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjEXOin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 10:38:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B761B6;
        Wed, 24 May 2023 07:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684939109; x=1716475109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LAmJa+fHZIGh72ytVsGhZMkD0LlDFf9gjEW5QSDIj9E=;
  b=dShjJnD1Hkj+5Xl/4S/o1mQ6V2uzCH1TALArRYZU7uX15aslj6Q75kYc
   w3ub7pRzRKq7KunpPUUNfvQbabMI5nd8Zojnq7PdkJ/LX7TEMPQYLhnUg
   tjTxnwjY3XDR9KfJBEHd9nqE9hS92j5XoXAKV3eIpwB9lcHVrXGygmZBk
   Zrce5/cNf+ixZpV1vAH5rteqVR3Bo/udyb8GkE+7claVkkY7huBU4dl2o
   M+1LZRWf06p3auILHez1CqJMjsLyWWXaNq8LXL7jn3ThYjbZpOcrpXl6Y
   aHq5m2HXPuecxpSz+1C1LTjX40MO/lxAHz5DjzahuU+CC15Elbj/uYmTu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="351095341"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="351095341"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 07:38:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="816618676"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="816618676"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 24 May 2023 07:38:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 07:38:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 07:38:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 07:38:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 07:38:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCtzBEtl2GAyapl6vcMwIDUUBWMRora89Ji9Sv1upYWlW9TR2A7JDp9gnuZyEso1yRNyjtILc5h5R5epZA33wMEHdyS+DQTA87wgjKagBujA2JB1NEljwBZuyQFORDI9eD+M+kfUQXoO0aHrWrGiM+VrPcVH3+pfUoNnEgCh+yM3dBNzFc3oZ4x9NqZuYL5D+dQ/iSmQNv3Jc387c10qA+z6eVP8cRetdcJgaeAPsCrFI8C98bZua/2mouUfwVdqJ6jtwhLbEi43IIugy3xBboZQumxU/g3BJSGUscDXkdDocl5JIuc0NnwlXoSIfO4+4A2w8Sn7chdIDJMEfyEXfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SVrnl4Mw4MyBqr7vTjxE7VLVnnv+9yVkyyrb0sb8hk=;
 b=gcGBvRhT8EItlEaWAq72yumP/blU0R7KuQmiJ//tVXM9LKBZVoqM7o58rlr6WTPTAgURWmDyQc998kS1VMFUyTKeLjmu1QVN0WnZRL0eJgV07OGNb+Nj5CcBhPqjNXhEoYwMjmJPf9mHjd9d2k3UzpGu5Ihc0WOJ7XqmLBI7jgF8RTBAe5xzTYYBXD1cHCS9J9lRbhcYPvTCUSFPRULBxXar4Va0JtWIzYRk+1u8cjkVCMIUt9nwzPFsj4rt1I/lZna3PukXYXzX/eUDNBaUCPxXWLzQS7JOwJPDnjUOnDpB0v58qVqMJ/cBtQuLYwDG+/FmIjBOPYr5YfymROjf3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7339.namprd11.prod.outlook.com (2603:10b6:930:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 14:38:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 14:38:15 +0000
Message-ID: <8f7e96e6-6b0b-e51f-ba45-b0c827abf59b@intel.com>
Date:   Wed, 24 May 2023 07:38:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Content-Language: en-US
To:     YangHang Liu <yanghliu@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <20230523164301.14620a69.alex.williamson@redhat.com>
 <CAGYh1E8Yk-eVNOMQrx6SUgNou5fY6=jFzHR=rQ9diwXbJAaKVg@mail.gmail.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <CAGYh1E8Yk-eVNOMQrx6SUgNou5fY6=jFzHR=rQ9diwXbJAaKVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: cf343f23-7222-4f3d-049f-08db5c6481da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0xx16OgL0GUAO+cAAmpGkbO/cGVlODEOHKaWPgSBk1rMlXX7P3Xa5LcdK1N8sh7Fx2IxAqiw+VvzrH/a67BRyUW77OijkiDE1eDh0F1asr5UhMebRzZAm9X7ehf1hz7ehoZjM9dsfu2QHUCVpfkxSDBG72Avhu4NIFuCX2p/RRvhfP5JmIJa+iy1CedXkkyUmCD4X/e1zLvk3CuQpqFV/9b9LCLVL/zVk+tj7AI/sF1sEpeLbLausp3VC7jIFJVDRcGl4quOsda0CR7PK3ZXkYuhTHxVynEIIp72DqFAB/soxBufL5Qhb/1eyj0PLiMdwMcVdLM2gKy82tbtqfkGDDxEAKM3dZb4dOMsO8BqAkT+wBkNt/7l1tZHOllkRSJo5U2f+/ReS8+2MIe7e1FdRonDCzO70xPWBptMr0wpI6ozYjZSm5Emi0Hpv7H6EVyg1H5MlYIUnb9AA3FseQp7C/dnG9NPrP+VlnuEHHh8yzlgHdgTXGxt4may3NVM5ioPBl0OvS0VBcZ/2S88Ajh18dM4lvjCEa7u2a0BJ1rfuUfwhEX2wxOuF8quME+0V174hd6p9wKtFnyBit+h6z18Q/JwvaaCm5+gwIL7uwlJMtPpnjp+f4XrO15MjEB4NHl6eGR7TqZYlPwh2NePdIi3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199021)(31686004)(31696002)(4744005)(2906002)(6666004)(26005)(6506007)(6512007)(41300700001)(44832011)(110136005)(66476007)(4326008)(478600001)(66946007)(66556008)(82960400001)(38100700002)(53546011)(86362001)(2616005)(186003)(5660300002)(8676002)(316002)(36756003)(7416002)(8936002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXZleWhiMitXcVl1M2ZYTVpxUkRUV1VaY2d3bWQrMERwWm1kU3FOLzFzSHRm?=
 =?utf-8?B?YlIrSnFTUXpZUklrNmdWMS9KWHd1aUE0Y1NFYm14NS9WU0JoY0JuVFZrWll6?=
 =?utf-8?B?QzZYNTc5SlJIdHh4NHpySkNPaE5IUkpWVHVhOStaaU00Vm1Xa0ZqWjl1czdK?=
 =?utf-8?B?SU43ZzBXeDdDWVFmTzM1bFArK2VZai9LLzhzR2Q3KzFXY3EwZEwyNnJXVTQz?=
 =?utf-8?B?c2JlS3QzZ1dyVDFjekpWWWhJNWRKeHR4c2dZUTZKNVBaRnltUGlFNlJsVWg0?=
 =?utf-8?B?a01jMXo5K09jdlNrWWJ4Qy9VTkZIbkhQdjhNc0N0UlpWTDl4VWtsVkVGN0tq?=
 =?utf-8?B?Tlp2aXBoNStKM3E0UGVLeVlGbzdoazRyM3ZRNFRRRkczS2RFUGJLcVVTaWhT?=
 =?utf-8?B?TGpjZXErRmJCRXdkNmt4cDA3NXRFTkU1UmRDU1JIOHdFdURXSXhYcE1Tc0Fu?=
 =?utf-8?B?UHYyQmY4VUdlaXk4ODJrL0xqMmYvZEY1aktuNVBNblljVmxyRWtvMjBkT1pY?=
 =?utf-8?B?TEZTMEF5VC9xNHVnTjVGc0txTmY1K2NWNktXNXFFV1h5bmc4NWs2VThlSUZW?=
 =?utf-8?B?U2NVSjhqdnJtNTU5cjFCbkkvVXUyRkhOV0h5V2pXanlwNVRKeGw0dG9HRE12?=
 =?utf-8?B?WFlJWXEwTFRWdTQ4NEEwSEQrWFpGaEJvMDhBZlY2NG9CMTNhR21jL3d0cnVi?=
 =?utf-8?B?NmlWVkZDUmZWWjRveHhSWWVNUkt6QlNCYWt0VXRXUWtJalNmalo1WnJpY001?=
 =?utf-8?B?bkI2c1dxN3FIdXpoMFAxa2JoNUZLZTgyellGcHVJQWRMTmJ1bityMDhQMzFq?=
 =?utf-8?B?VHNpNEdjdFNWelpaeXp0UTZCZ2svUUc2dW9VbVExam5SVEpKbk50OTJZeGdk?=
 =?utf-8?B?RTZHa3FpNS9DSXdnSDZHdFQvTE9OUXA0L1dwWGQ0SDZzdE96SVhTcnZ6UDdo?=
 =?utf-8?B?ekZSZGVhNXZQcU9HTW43cFc4MzdJN2hXdTIveEg1ckxPUWJMR1hkS2U4ZkxZ?=
 =?utf-8?B?RkNISVFqd1pqVmhnSFIzbnlMUFNoaEFERWpKYlRHbjhGUWpoV284bTB2WWlp?=
 =?utf-8?B?R2ltSmkwYkZETUw1VE1ubFY0RlNzNUpkY2dqTE84Z21lQnN4ZitIUGZFR0sr?=
 =?utf-8?B?elcxNWNLUGNVdG1Qd3FNNEhlTkdnRFNTMEwwQ3JLWmg5V0dVT2FzWm5mVG42?=
 =?utf-8?B?VG9GTVpES3lQRVk2MEQrSlJYL2ZxZEdPdmJGdUtXSU55M3hIam51T1lFemJx?=
 =?utf-8?B?K240SXhhR1o4a0htekwvcERwYlk3SVExTmd6cjdhMy9xWEl2ek1tU3FMQmhn?=
 =?utf-8?B?QkdzVU5YNlMwbDdDakN0c2RzMWk3by9sMnVtdnlGVVRpbHhKdG5YOVJQclBL?=
 =?utf-8?B?YlEvaWN3MjN5YzBvcWltT1VXTHl0Ukhwb0FnNVdiODRSQmpZM2lmeDNpK0tz?=
 =?utf-8?B?bnRUSHN1ZzZ2c2VPVlNSNitNWlhxektDVVpFbnZFL245VkhEZDFMbi9kdjJ2?=
 =?utf-8?B?d1RSb0ZLdjhwT3NjRnZ5elI2bEdNbzdra3Q3enI5VjVlSkY4dTZWeitqY0lP?=
 =?utf-8?B?QUVTOG0rYzJXQWRGYlRRa0V6dzRYYTZMTTYxUStJWDRRd2RlSEhFOS9QOVpR?=
 =?utf-8?B?R0wyUUZMU0FzNnlhSmg4VkQ3cnE0bGd6V3lacXFWeDhwSlplN0ViNkEvbFNl?=
 =?utf-8?B?SnhNQzMzbi9yby9wT3BtaU1BWXJVaWF4ek8wOHF5NGkrWk1yQ2JEaFhUSElr?=
 =?utf-8?B?UENOTFN2eGVoODl4bVZCa3d1TmkxWlUrNW8zMmdWYS91VmU5QlZCQ1lnRTMw?=
 =?utf-8?B?djlUc3VMTUw4UW1hbmRCYk0yVXhXM1EwY1Qvci9jRzdlT2cxYVZ1M0Zpbzdw?=
 =?utf-8?B?YzVIZ0l1MkN2NXp4VXlqekFXbGNSS3VOQWc2aXVHd29CVjdUL0MxaU05MGU5?=
 =?utf-8?B?RjBoNmtWSFQybVEvbnM4V1BDUnlWdE9Lbm5xM0pjR0ZwUjAwMForbXVyTkRp?=
 =?utf-8?B?N1BFWVZjUUtKNlhsNGV4emZwN0lTL0xXY3hNWk9RcXl5cThlaGJnVWRCQVVO?=
 =?utf-8?B?all3TFUzSW41ZVplUVBEZXd1NGRaTDFqWVhWd2xHbTdBTDRqWVZFK1BUQkRm?=
 =?utf-8?B?TlduY0dEakxoczdhOEJGdG5ydVNXd2pzY0Q5NzBPV0hQUHVPYWFVc3ZQbjNM?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf343f23-7222-4f3d-049f-08db5c6481da
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 14:38:15.1750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ifRyA1mRHbQnenodMc5qWY0ky7s4JcnDFntlYUHEhU5KhQrOc1LCB14pJ/4KsoYq1vEmBLw6UdposqwnOqKJrrONWvH1xWXPH6yaMmC4rG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7339
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi YangHang,

On 5/23/2023 7:43 PM, YangHang Liu wrote:
> Running regression tests in the following test matrix:
> 
>     i40e PF + INTx interrupt + RHEL9 guest -- PASS
>     bnx2x PF + MSI-X + RHEL9 guest -- PASS
>     iavf VF + MSI-X + Win2019 guest  -- PASS
>     mlx5_core VF + MSI-X  + Win2022 guest -- PASS
>     ixgbe PF + INTx + RHEL9 guest -- PASS
>     i40e PF + MSIX + Win2019 guest -- PASS
>     qede VF + MSIX + RHEL9 guest -- PASS
> 
> Tested-by: YangHang Liu <yanghliu@redhat.com>
> 

Thank you very much for this thorough testing.

Reinette
