Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF285AF8F3
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 02:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiIGA27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 20:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGA26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 20:28:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7F17B1C0
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 17:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662510537; x=1694046537;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=p5qA1alfXFM1zynNIOtC4TSeO1VDHdPYfedh9rgiRdE=;
  b=LUhzoxuOQ1Bt2B7cfuWtifqB9dZxQX45ekQikND+Ey5g13CfIQ1I6cTH
   LTtknrlYEakoz8XwAQcrg0n8YFU86J84jEDbLPW1rRbkvFjkyrs9ZVBmX
   ZRSZUk+H8Z3T+m5tyaiTAXLMPWZK1Y8tgnU4hvv2qoVguZhDNORwTffW1
   2QVWlryY8NdsuqjgO5lI/z1aBI8WyHLx76eVoWGmmS6rfsn39g/KSsd9t
   oXVE+ucY/gkQCxMvpVbQ5y7luBPTLo5iccJuXA7Grp3x74gW++L836ehd
   Oc1Vvu/KI1IHWDQY3YdSD1fad7RfOqFicn/9fGyTTrlZdnv3cQ6McjtIM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="283741153"
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="283741153"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 17:28:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="789867428"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 06 Sep 2022 17:28:56 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 17:28:56 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 17:28:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 17:28:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 17:28:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Na+ZHaUvuLAnEGQ/CFDHcC6rksaxBFOIoh9/seei5AgvBC1+oTd2qYPw/a+7NGOCahEWJHu5n9ZbsP9/+0GqCuasE8vZ/grbzfUfhrBJmnDuUZpfKdIIL9YZ4+SfJzQ2yXcExJGLT9BME8uIQ3GSJChxvcPdfs4e1EA+4fvb1CJR59wh7XDu8RLstneflxqDfNgrBKM544ak3JQLF4OI6lAem930shY0tH0iFhcd6GHjKdSISDAAPRsVlM+PLUBj5MLUtS/yfaKt5402442mzdyTV3BqRpJL5+kPti8pc1Qz22rtgEEATJaXuxDhavAgni1o14r10XWDODi/Nh67jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5qA1alfXFM1zynNIOtC4TSeO1VDHdPYfedh9rgiRdE=;
 b=CCutl/LeyT6jO3UAX1+XTHBqXINj/1moWXfS9byt8HjzXoPjFQkQOu+aI8vLcigy/q5rT7aEW9XHC5cOSHAwjYrcQjF4Qadbkbcw66hCJGYO1bf0I2/zwDQ0oa4cKtEYh5Y3+Q8BWr1hllbGqD3ctdw3FZ5oJjbLgSpK3QqwINwrPUu0YaZ8vlRf+EqKliK/UpnEMxEMNrxVma+OCoehEyTOBuoU8xOSS1i8hepBO9zSD8qCKWPMOIE1fj9fIX0xyjm16nmCCkiJJRsPkxpaDY5A+cpIahKUkleQjx0qhbdrOQ/EA+6p6eCLXsdP/29BXhCJEdYI7jhEfQNTA5ka0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by BN6PR11MB1361.namprd11.prod.outlook.com
 (2603:10b6:404:49::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Wed, 7 Sep
 2022 00:28:54 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5588.015; Wed, 7 Sep 2022
 00:28:53 +0000
Date:   Wed, 7 Sep 2022 08:28:51 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jim Mattson <jmattson@google.com>, <chen.zhang@intel.com>
CC:     kvm list <kvm@vger.kernel.org>
Subject: Re: Intel's "virtualize IA32_SPEC_CTRL" VM-execution control
Message-ID: <Yxflw2NAghJM1rhE@gao-cwp>
References: <CALMp9eT685aGv-kn8Yb4Xq7u=33kE27U1GHJ=0pqaKn2AcO7og@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eT685aGv-kn8Yb4Xq7u=33kE27U1GHJ=0pqaKn2AcO7og@mail.gmail.com>
X-ClientProxiedBy: SG2PR03CA0120.apcprd03.prod.outlook.com
 (2603:1096:4:91::24) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4923658-ec5b-48e0-1c61-08da9067f19c
X-MS-TrafficTypeDiagnostic: BN6PR11MB1361:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjVAC9Inj/YCB4Z5R1mWhK3uIx4U4GXSEfSGyK5OtRjj2Im4plODZv4LZ1M0vos7cDXwAwrlfOlUTXkfCT4WIKpy6wAGqybcvCUNBestIXubVMQSZehQ0JptCzlMQ6zufxBfGPE3BGc1ghm1XPDpKpb64zZ6lJF7YVdZva3XkbRoao0NLOFcdNxkU8ClhUk0mV/NGj4fZ1hXWx11rp+ibffR7U1rMdDEjLExReLd6EnvIg+A+BG8/gG4ydPNb63K2aShrHvHzKR2j+wbB9yPVImi+JBtMZzpaSKNr1Hu8viT5qRA88KmvkcAyjF1rMSNBhIutiUXpw3XVD2BZjo9d13v7a+xh4ApYJBzr0bY5Q33Yn/YIL0Wmfk/RybhHboRV5xuo8c+7H0hdw3zH/6Q/To4VSiqIKUGfcb6ROT7410mSNDh1C3TR6x49zs4gRcbsjcAZSq8bDid+5NA5ySuxBQwh+BWR8I5OY6tJvcSoAyWDuCfvGZ3bkM/DE1qeFyMZXXFnlOy7ULN3tt6W0PiZ+niBo1BPOnFALF1DkzBEf7iHzoFf4B3BvvuU8i4KmBbd6cc//mSzjZmER1esR8zEs8VQrfMN/IiMA6vN5PQw0pqR4tVcj2+yIkIO8BNwJzvIJ8jJCDhm9f/UVhsaX5pyefU1O7kLRK6M6PgRmhF+84XFgdwiHXNo+hOXl5fWr07kn183r2Z6oB5cHvmuYNiQzZuYTUoCoHQ6ABhWbDxFGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(396003)(346002)(376002)(39860400002)(136003)(8676002)(83380400001)(966005)(186003)(44832011)(478600001)(66476007)(66556008)(4326008)(66946007)(6506007)(33716001)(26005)(6486002)(41300700001)(9686003)(6512007)(82960400001)(86362001)(4744005)(8936002)(6636002)(2906002)(5660300002)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUx6NFRzc0ZzYXBXMGRhbXJWaFFteDNDUlR1RDUzd2Q4RUJ3VnpYOGxPS1lo?=
 =?utf-8?B?dWVNVnAwRlBkM1dGYVdmT0NxVENoWTk5dVZ0Z0Y5WDdJNUlndFF5ZXNtaktG?=
 =?utf-8?B?Q0kyYWdwTFlQb0tVeWc0cWdjSTZpRUVydnQ0bzBYRFpLN0NaWjFtYkNpY0lR?=
 =?utf-8?B?bDVRazlrbUM2T1RMUGdObXYyRE1nT2I2SlMxdUFPYjZQNXBhb2FFb3hsQmpq?=
 =?utf-8?B?VllSeWNXR2JnMENsd1J6SGRBbFVDVE9TdUN0aEhvNkV6RWhuWnJGKzFHMGNC?=
 =?utf-8?B?dlZQS2FSNW1UakhZQ0x5UG1TMElVa3dyeGNOcEoxQ0NyMHRuUWw0d2xkQnNG?=
 =?utf-8?B?RWx1MWU4NUxnUzNOQmYyUk40Z2NnU21vUXpGcTF6Rjk5MFVzWGpRcnNSL1g3?=
 =?utf-8?B?dzYvN1JUeFo2N0UwTTR1SUIxWVZBWEdVaG9QRHI2WUNIT2JnMXRNcU5uOGQ3?=
 =?utf-8?B?RlFrcmVZeWhLYjllajYyY29JL25QaFR6dEtJa0tuSjdDN3VEMW1hbU92UzVh?=
 =?utf-8?B?Z2t0ZWNZSzRSbmFobWw0Q1hMcmxqZmdGTy9TME1TRllhMGIvTEw1M3FHK3ov?=
 =?utf-8?B?K0RuWVhBY2FvSVA4UkJXVGRGaVI3VlBFTFIvaFBuNFhUL3dNcVZnTzlDeU4r?=
 =?utf-8?B?MnVNS1JEcDBsdS9mR1ZZOW9MUzFVOS82dSt5dEJ0VDBZMHNkcjh4T0kyeVhZ?=
 =?utf-8?B?d2lwc0Qrdkd0eGIwQXU3T2l3L1VTN28rSmFqdkhsdXhkZUdiU2dDYmYrci9l?=
 =?utf-8?B?aXhxdkhDLzUzL1hMVVZUd0pxeFZMTnZGV3RrbHRSNE5kTHdtd3ByUFppRE9p?=
 =?utf-8?B?cGJ2elBGZnBZWEdEM0c1M1ZkdVc3NVdUSDRYY0FnZHN0M2N4ZVUycmplU09t?=
 =?utf-8?B?WmY3enNON0pDc2pKd0Q4dnYxdnFrTXNtV0NoelFKOEFaVnE3cHAvQVZWNnM2?=
 =?utf-8?B?aElnVjVJY0E3Sk1FVWJYb0FqK3lqN2p0UnA2WE5MYm1RK0NsSU5PaDVwMzc3?=
 =?utf-8?B?eG1LY2RhcHZtV21WRjk4QWRvZGFmajNIK2pDK0F3Rm8yWGcxUDROTjR5N1hy?=
 =?utf-8?B?YzhLcHpKWmJCNHpHOUFZZEVCeW5yT2tBRWlhc2VLWE1nZml6Q1ZFcnhYUjhy?=
 =?utf-8?B?cDgzR29PTzJMWHYxdXBhVmt5NUpXRnh4eGh5RTB0RGpxdnkrem11SEZ2b3ZR?=
 =?utf-8?B?T3I2RTk1U05UaXYzTmh2d2FCVFlVTjk3bnRxbFJvSzI5ZnVOMjdLQis5ZWdw?=
 =?utf-8?B?QmhTbjF2eTZPRUFzWGRCNTVsaHlidTVxZTJDeGxjVi9zdWJHdllqRll0K05O?=
 =?utf-8?B?S2hDYjNyNDduRG05cU54dllvOGhYL1Nsb2VOUmpPdEVLZkdLc2dtN1lncWRG?=
 =?utf-8?B?MEhvQVFsNTdKRXZEWjk5TlpRNXl3dTVXRmRCOFlFdVBEbENUdVRONzJzcWFn?=
 =?utf-8?B?cDZnbkJFRlhhV09FTVZnZ0o5Q3UxRmtJN2FSUUsxZ2NZb0I2SWdyQTN6cFNv?=
 =?utf-8?B?dm9hcEJVLzVlRk9WY3E5MmxzV0ZiTytlSVF3MDQxUVJXVG5KVEV6bUhPQzZV?=
 =?utf-8?B?N1JsUHk1L1k1TGxQTlhTS0ZkRi95c21VTmtKdllCRWx0V1lhZ2tzQUc5YTIr?=
 =?utf-8?B?T3JpbzRrOWRvYVZFUTc5L21JZC81R2VYZUhrNGx3b3gva0gyaGtjQ2diTEgw?=
 =?utf-8?B?QklESlQvcVgxRUpHQVNZUzZPRkxxQzI2dGZBdnlvcS9DRWUwY3BtRkFtM0cr?=
 =?utf-8?B?U3ZLU0VmY0hyVGJ0eW5CZHJlNnIvUVdJREpsNWVzVDhhTldMQ0NrekFHR2Fw?=
 =?utf-8?B?YXpwZFA2QnN6QVAybXBGK25obTJac2xmVGhDa1JXQ3NFazdqaktXQ3RlYWMv?=
 =?utf-8?B?MVZCckREbDFrR2NWamV4WHc5L0JQWENPbkVJQjNUb2E4MytRcmRodVN6MTZN?=
 =?utf-8?B?elBVYkhYNzI1Tk9ibmRRWkRMWTI5djlSNGZ0d2NTeFZSZUhJQklsSTBrNkc4?=
 =?utf-8?B?VThicHRvV1lRemdNcjJvZHRRYWhqMDc3aENIdzZsUTNmcUFxcXNwTG5VL1BD?=
 =?utf-8?B?eFdna1hFNU5XVVk0bmp1dWRTdktpaVVFd0pLOHVydTdRT1BtUm1MOUNhNTNL?=
 =?utf-8?Q?fc2UmlUMR5PCOPYTV3I/CQlXQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4923658-ec5b-48e0-1c61-08da9067f19c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 00:28:53.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mILJZPl2otNy39w6koQLwEX6nKz1ND5SdRCsxjRNU21KqO+r3aNAZqnRlyf+AVM/ux3j2VeukPJSXEiyFc/qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1361
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 04:41:26PM -0700, Jim Mattson wrote:
>This looks like a souped-up version of AMD's X86_FEATURE_V_SPEC_CTRL.
>From https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html:
>
>When “virtualize IA32_SPEC_CTRL” VM-execution control is enabled, the
>processor supports virtualizing MSR writes and reads to
>IA32_SPEC_CTRL. This VM-execution control is enabled when the tertiary
>processor-based VM-execution control bit 7 is set and the tertiary
>controls are enabled. The support for this VM-execution control is
>enumerated by bit 7 of the IA32_VMX_PROCBASED_CTLS3 MSR (0x492).
>
>Is anyone working on kvm support for this yet? (Intel?)

Chen is working on it. He has some patches already and is working on the
testing and review with security experts. The plan is to post patches in
ww40 or ww41. Do you have any questions/concerns about enabling
"virtualize IA32_SPEC_CTRL" in KVM?
