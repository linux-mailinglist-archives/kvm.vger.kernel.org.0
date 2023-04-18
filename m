Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5940A6E5740
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 04:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjDRCCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 22:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjDRCCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 22:02:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D867E6;
        Mon, 17 Apr 2023 19:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681783330; x=1713319330;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jvcBsiVsDfbuMbfWXLvptUx2kPijOYCePxfMm2yjf+g=;
  b=DNfGE/8EXJBdAfeua9Spr66jEd09+rPrmd84DqC+tVes7c+drqXzjWH9
   TMmW5o2p1DL75veyu8j1/xlVXoV8fYbqFZrPgAJUWULMALKwn6KV+Yowz
   XQRikjvxnb6lowBZN8sXrwW6sMgBCgX+XaadDp7w852NhlfSzHMIZIur3
   Gw9NZIUZKKG/Hz8v68fpyua4+6Z/bnbwGXofonJfjhO4Nd9b8GI0u4oWx
   NNuLjtrejjWuFf0mDIiii18S4WGkAjA9oQslUevYxbbws6xH2hTh+3VsE
   AEcpLiNslh0YGHlv7UqF7iVF/8hoaybJtrje7+/iyk1hLLGEHNiLLd6n/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="372931985"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="372931985"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 19:02:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="721352773"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="721352773"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 17 Apr 2023 19:02:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 19:02:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 19:02:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 19:02:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 19:02:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPWqhHiT17PPk34EsnsyIKxKgh87g79UNl5ZIGOJRU6EgYc4+Eb+XBuFQVmm5vddek6zN6plbrudznOfdLJKlcaD2w1tyUuybyLCc91B2IeU0Y2JZVONc18UmnlmC5rrj4ZXRCNfItnmDN8rtTfskrDcRF3iZduGQYVvBpze+XDvX7fV4rNa8OGGPxlcoaXP6aS4A0QpnXde3dKZdNzARacXdb1AuTQQKCpnPZG2ZH7RmXeqZSnxe2ZfnFpqnrrnfuVCdQchYDzHZaXIdFaB2MfakV34cxZwFAdZmvF3FfYAAC9vU3MqS4gX/QHzmUo422m/z0aG40++SKEvr0zozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFV4tzHIjfyRoSxnmtTvaMEEQ1Vfo4iqorEYhtN1UjM=;
 b=BrrEFVph36d4hnYA9kGDr+Sob2vGTwev+XEP3CAKnuk7RqnqgEtm1sGipt071HRA7yp2QEQ3oP4Zozfk5OCBzJ5nCaeN7uTcTvUVgyfoTtXjHLAKgmHjPdldolqaKekWw4M7Axvu0Q67XOP0NhjHstnT6iRjYxRZOcJueeBRZiBoGHJlqzIXWKtBvx9IbZlGlDn9thkPmWI6ppKwdi/eNvrX6TQotcSbU4gZFQtR35z2qtjh7eebvRJ2DqxgZ333VFyk7mmULOw4GL60cxDxUcmUQGIkRmbscMakIOt1oIZgwxcH4OmfSPICvdHttOgIlaffxP2zbnmOi8KPnUub/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by IA1PR11MB8224.namprd11.prod.outlook.com (2603:10b6:208:44f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 02:02:05 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 02:02:05 +0000
Date:   Tue, 18 Apr 2023 10:01:52 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Babu Moger <babu.moger@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 05/11] x86/bugs: Use Virtual MSRs to request
 hardware mitigations
Message-ID: <ZD35e6XS9RePNZCx@chao-env>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-6-chao.gao@intel.com>
 <0312c900-fa7d-2ae5-22f7-956a7517193c@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0312c900-fa7d-2ae5-22f7-956a7517193c@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|IA1PR11MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 61d824d6-db50-4775-bfca-08db3fb0e818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3tQdVSCDaYO4C+W8vNm/iDlHfdpHJ8sTEa9XLWUrb6sJqc/uPjL4Yb+eZSHAnyONBx4+9oLaZ3c8Es5Jd/HOwcBwWoE7pQD7CRyKTQm44sGI0iX0dlDWEozIY/QjHtluvDXPxw1OCqMfwXRqXP5xSSg1D4SKWXUl5OAGubnwTWN7rKcPptqWqMZqdsZvrQjIRezhXH7pIb0trhHvf8Viw/kOdqEJAlBA6Al5dJWhZoNCHreV/sSrr2GF6JrEjZK22j4e3ACluwMdJkdcF5glVTssrN95R3jbTV4763C8LJnGWT5Hqo5TuKyM1XL7LPoivmUqS3RdmVkNlaF0QTh8usj4NBVyb2G6OPfMfu1i45+HqdrT6qoQFrBXy8hC3cPcRsfi5J4daq59jtbLC7mxusqhYo+TZSV4d8fst6ZxiI0FKemGpxzjiUt0iPsLMLhsouu5IExpeJ3LMqXaNySkMxOkperJZHm+xaLJVgewllOZ/8Kve9D/Za8lIREljY6d6/YvWAOraXmxv6y9wJPW4GxV5Hc8e3nn06JcCJ2BNme5L+/7yy6yApKXfE1SgkW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(82960400001)(41300700001)(6916009)(4326008)(66556008)(66946007)(54906003)(66476007)(186003)(2906002)(6512007)(26005)(9686003)(6506007)(86362001)(83380400001)(33716001)(5660300002)(6486002)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uU92HopG3cW5isVTIFLByVK4s4kRwh2YNCKWxbaLZmKMgGwEoavWnW2io/UV?=
 =?us-ascii?Q?g0zJUHvtHw+tx/Sp5eAYME0aMmY+mfhLgJmiLqTUlzLrBEccVbc2HB6wYmo2?=
 =?us-ascii?Q?DmpYJsbWGlzbTJOOCQgDEWjLgHq9bFZZEqZQ/jq73ais5e5OVPwDaFM8ADiw?=
 =?us-ascii?Q?w1v46kazvepzben2KSwSjR9KtPVPPBAM+yOzblUwYfKwJHC2D4i2x8qaROi2?=
 =?us-ascii?Q?IeEID8Vri5Y3fe9EAh8pe+zYeeE3U8orzHV2TBcOt5cbW2QY919bSXojGb/Y?=
 =?us-ascii?Q?ETEJFoEEi0+X6Oe3cZoQQad8kcfU65WZx+CSnYyfHQro8zbZCiGFxEh5FNJP?=
 =?us-ascii?Q?WgpB0Lm6Yke38adzUU2AZ8BwO+VmyJ4esOKWKykciS+XUjFnIfTFHf/PmVYX?=
 =?us-ascii?Q?KPOY4+Pz6CsVlFqm9NnJQ+d2JoHPiRZtt69VepT1KSEtbxj4kShXo8wFM14t?=
 =?us-ascii?Q?Z6M1seDo5guY420NiwLuhgLGhWAaNKdHRgxTIxkb0G4UB2Sk13A7xY7I4yrx?=
 =?us-ascii?Q?3n5zEhC1h6yUHINy3erjA2pR2O8+fOR0asx6JNAEfpIXh/5GmW+3SRTmPihv?=
 =?us-ascii?Q?NzVPKEZIhz4o+bZa1WIK/k0xyUcvkwaeHFaEgejFnWewcXKimqLqCF+WUtsb?=
 =?us-ascii?Q?kfB1kQ9mSBT749T9X3t8nePrJ5IyDLFTdoEtS8fKULbDAqklwDjfbSSlycFv?=
 =?us-ascii?Q?YKZoKxH3UbMNuV1M6buD9jSxBXWcN6pegmJdr2yAuk1BRHdkfLL2vE6TGRet?=
 =?us-ascii?Q?sHC/itD9ufFRklPKxnmsL88fSlClAAdKhuKDjJkAbEW7hiYcsKF9jUNtWdpu?=
 =?us-ascii?Q?jazwM1t5pv69fscUaynI6fA9XtypRVT9ki/f9rxnQyAtqZ5Kj/NzNyhqtvar?=
 =?us-ascii?Q?4Nn4e06hR6Urue1apBAsn2rCQeQS2Abc1nMkOuhrggYMeFCS+/Gbodut8Gkp?=
 =?us-ascii?Q?KYPpWm/lghsx1ElQp0+mYoXlygnHivaDZlFJlBpIsoCjyXs4QCCc79cSz07M?=
 =?us-ascii?Q?VPWUOOAZmgibscyyXLKAn7/iCBdurjdZSOuVhx0D7/hUw8803xVW9reysoEP?=
 =?us-ascii?Q?ZuJrx82vcx2mUnQWsm++nrMEaGbCSmqf+/wKRKk7rF1T3pkopqDwVvFn4dil?=
 =?us-ascii?Q?Omrpsxwsx+4kgghMaK3s6Gg4WaAmjn0XNS8/h1fTMxXghdF8AwugvbbCDqw8?=
 =?us-ascii?Q?gew21lsfHOA+cUTiX17I/DiohbZllp2Y0R12G01YaVSHrFGxS+y5kBfqGJNo?=
 =?us-ascii?Q?qUyMDuskLyaFb9jDspq5TSL0qTKhKKkHdwGJYJ+CPWsi3gObU/ZhoVKPfxxq?=
 =?us-ascii?Q?nmRDUPQ8ysGPPuwsJEj57ooinOq0cESaSeIqZAFlVjzXApiQqWKUJT/6AZ9H?=
 =?us-ascii?Q?ztp6AIx4zLLaBdY1c/zFQUWWDHTV9wmUCe/WpFewC/rLjHDNwqg3uSmvyGtt?=
 =?us-ascii?Q?rY9flPCPn3NKdqA/+dTVzD0UEO4MN8HCphKQc4+Bl23oW0hvZSxveOPiht/G?=
 =?us-ascii?Q?oa4EhLBMI51cfPWkxqLjaQDAxzYu+ZW6DGx+WwDzh5WwHC607LClIcSwuUsd?=
 =?us-ascii?Q?4rsx7ubcbpv4yYc7n2aJ9SpNcaKn7XpVBeDBWYJA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d824d6-db50-4775-bfca-08db3fb0e818
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 02:02:04.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5NRg2kGmflVndSXxYNHQngfnhl6ljxzjvsh8dfsQ6A3BqvI6frCYyab0a9fwkLx9x7u4N2b5rQ8Sy9chLpSHag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8224
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 09:43:59PM +0800, Binbin Wu wrote:
>
>On 4/14/2023 2:25 PM, Chao Gao wrote:
>> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> 
>> Guests that have different family/model than the host may not be aware
>> of hardware mitigations(such as RRSBA_DIS_S) available on host. This is
>> particularly true when guests migrate. To solve this problem Intel
>> processors have added a virtual MSR interface through which guests can
>> report their mitigation status and request VMM to deploy relevant
>> hardware mitigations.
>> 
>> Use this virtualized MSR interface to request relevant hardware controls
>> for retpoline mitigation.
>> 
>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> Co-developed-by: Zhang Chen <chen.zhang@intel.com>
>> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
>> ---
>>   arch/x86/include/asm/msr-index.h | 25 +++++++++++++++++++++++++
>>   arch/x86/kernel/cpu/bugs.c       | 25 +++++++++++++++++++++++++
>>   2 files changed, 50 insertions(+)
>> 
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 60b25d87b82c..aec213f0c6fc 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -166,6 +166,7 @@
>>   						 * IA32_XAPIC_DISABLE_STATUS MSR
>>   						 * supported
>>   						 */
>> +#define ARCH_CAP_VIRTUAL_ENUM		BIT_ULL(63) /* MSR_VIRTUAL_ENUMERATION supported */
>>   #define MSR_IA32_FLUSH_CMD		0x0000010b
>>   #define L1D_FLUSH			BIT(0)	/*
>> @@ -1103,6 +1104,30 @@
>>   #define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
>>   #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
>>   #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
>> +
>> +/* Intel virtual MSRs */
>> +#define MSR_VIRTUAL_ENUMERATION			0x50000000
>> +#define VIRT_ENUM_MITIGATION_CTRL_SUPPORT	BIT(0)	/*
>> +							 * Mitigation ctrl via virtual
>> +							 * MSRs supported
>> +							 */
>> +
>> +#define MSR_VIRTUAL_MITIGATION_ENUM		0x50000001
>> +#define MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT	BIT(0)	/* VMM supports BHI_DIS_S */
>> +#define MITI_ENUM_RETPOLINE_S_SUPPORT		BIT(1)	/* VMM supports RRSBA_DIS_S */
>> +
>> +#define MSR_VIRTUAL_MITIGATION_CTRL		0x50000002
>> +#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT	0	/*
>> +							 * Request VMM to deploy
>> +							 * BHI_DIS_S mitigation
>> +							 */
>> +#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED		BIT(MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT)
>
>Seems it is defined, but not used to request VMM to deploy BHI_DIS_S
>mitigation?

Because Linux kernel doesn't use BHB-clearing sequence. Instead,
"disable unprivileged eBPF by default" + SMAP + eIBRS are used.

KVM uses this bit when checking if guests, which may not be running
Linux, are using BHB-clearing sequence.

>
>
>And IMO, it is more natual to put this patch after the four capability
>advertising patches.

Makes sense. I will organize the series in that order.
