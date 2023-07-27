Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9E764B2E
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjG0IOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbjG0INf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:13:35 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D754ECE;
        Thu, 27 Jul 2023 01:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690445336; x=1721981336;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9h8TcU4pGrIxeuEqQE7+b9eiSeDIH1T+dkBKgAIDfFU=;
  b=gG1N478Ul0gkooR03Q3Q25lmSWZp5c3ACDRMoABCk5fKahZOcAhKTQwU
   uF+MNYUutqjSCgmzs3HXfK3pGq56kgUbckY87q+rN5iGUbjuc38EFK160
   qBKnnMeDN+8Qs7WIalp2reF7HRK/Lj3T7ra3uCMWMARk/Tk0n5tSoFoGg
   BXPy17ikpNB2X+/PDVJUCLyrJHTfgTW+4Hwef1xqwvKz7u4lruen3Tpo2
   +8uobypQBJyvRvDfdoRMDAFvdJfkEc4EVbybzUgGYq/Z79yPBFoqXgf84
   VEYKZEEtjcNztVhhFv02APyq/VhnHdNA7R75abqHo2LyCsbZFRyl2T70y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="432037634"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="432037634"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 01:07:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="792280673"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="792280673"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 27 Jul 2023 00:41:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:41:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:41:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 00:41:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 00:41:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMvGAyVjsFcUXtMccQL1uWXCbdU7QgxrLds6jh7IN2d0N6P5ihKErq2GQoQrzjZ3/ue2S71iWnYE1z+90ZBGVyMyFR4J/hkrgexwYoM9UmLRvGjGoPCAkTPe102Y2aEbKuiNoL9oIlvkn6dsG4d2zDS137wRz7Tj6Cew81oD0GNlPm2U/2Exu3/wypBYfmhJOOXWkAzf87QhPmYfIaaXEBzvpoRN5MC/N3knXUjnkdUWMwK2KvUaXzEwyJx9YtAPlplyUYNPRxUG1G7vR7nJ2ZT/bCja9PsEHcQJKbLJzxkn7v4KyHH8/VGqSZfkXIzP4XXt7/w+vrsxRbU7kfqORA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbr/LWBfHfEYuYjTEBrXwBCZ4iUruBGQFKgUeU9ARSI=;
 b=OrKjoTy50jsIMZmqmZnuiEgeUzuO2r8AuxErUZWVbnEdzC2lAu6GqZ+sO7nrS9r73fA2l1le+0VVYb6sMvsprRlO92j3PR6lKm4Dym9drRAd+KSxCEh1yjFHAE+nM9uEG+0Wp/lvIXemX26BZMlwpfN+cqz6l16tiyKDyoTQboiKXRqErKKBUQOpM/fEyhJgjC84kCBEGTNL4Y/pcUMQyPCmo8wTCap+RtAtIAfXNbsnIsrrPOAnI+ZCnT4b7ppe7/Yo62cp5tXI50ov41EarkLKUriyTuTbMpfaq6CLhy1vk2+xdARGCsIGXao5THLFzGXVpXtBwXbCVKeQEV/76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB5816.namprd11.prod.outlook.com (2603:10b6:a03:427::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Thu, 27 Jul
 2023 07:41:18 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 07:41:18 +0000
Date:   Thu, 27 Jul 2023 15:41:08 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 09/20] KVM:x86: Add common code of CET MSR access
Message-ID: <ZMIflGq2i3m3bNLU@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-10-weijiang.yang@intel.com>
 <ZMDMQHwlj9m7C39s@chao-email>
 <67250373-c5f4-d1d7-9334-4c9e6a43ab63@intel.com>
 <ZMEjudsdr8WEiw3b@chao-email>
 <4565ab4b-f386-7b70-4634-627e92acbb45@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4565ab4b-f386-7b70-4634-627e92acbb45@intel.com>
X-ClientProxiedBy: SGXP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::17)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB5816:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b52b8d2-9b1c-4878-2fc2-08db8e74dd40
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uL93ZkjMsS5oRvGFykwsQJKBUjsydFVGL+0jjAjB87LOW4q98CIvT39PuVLxY7WX2wqFXVutTKtQ3BB1Cdc441MCNlvrXATohj7vu6s4BxvqVLZlybu8akv3Qxnahp5YkbK3Z77Z+ZAW9PYhW6SRJPPjDbatCL/6XzAXDzo95k32T11arL+SjRrNfpeBZaU5iyJRaiUsUWR1lG1dv4Z1lbcHzWoh5qZaN03ddlLbrjzMaTXg329LfHQ2TLCWeOayUhSL/RN4oIeEi7d/S8wOyB+32SFdYF73HpaTt4sikfUhoxDliKYM6CHly274lAirUosgsANiIUI0hOXc3Mj5WhcddElT/bQXru+iwYqzQPs09y7bG5Ei9+ebb6DwCprkS2+BXYveVxD8QObPHZGFYroK9XZXHr/fF0RbWJflwZi2rccGU1GtS3Qiqw4g1gm23vddUnqVWsenFevOthQjLyRHdf2fxnvTRnplQvjAQRpgeMbp4csmpaBYkphYNEv/8Xko/t6z7AuGau+jpO8fiDs96W/XKbtgxYypelVpZSrlhubE65y+IybarqQgSFO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(8676002)(6862004)(44832011)(6512007)(6486002)(6666004)(8936002)(9686003)(66946007)(66556008)(66476007)(316002)(478600001)(4326008)(6636002)(83380400001)(33716001)(2906002)(82960400001)(41300700001)(5660300002)(26005)(186003)(86362001)(38100700002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fVHissIjJrSWLxY4UOJEmhger7zOM2ySwo2mjssubi6ulYgXnd+1TvvcMsgf?=
 =?us-ascii?Q?Hjq5ZoFrvW3Zlq9sa32Y4AKq1ihgOy+d/cCrrPU8u1cWJy1ep+ZxU9qgqc7f?=
 =?us-ascii?Q?SBWnoclBqS9xamDcUEZHC+n0m6DFNrfxJSslpitKp3yZs/9ZEnftSnRILfnD?=
 =?us-ascii?Q?f57pYePckJGLpMzbMJYhSnP2Lx0Yho+aoDlC3fsmq4sZc0xipDLhw16lO8bD?=
 =?us-ascii?Q?iK/tW55CSLNZUy6AlauaSQJTImuQ+YCdQfVmd8UJr4+bwgoAF+6sgjmv4vo0?=
 =?us-ascii?Q?GAkCfKkPDD+Jbkb/sAUuJEZmwLmSQtk1Ff5Huz57A7pNU9rBonQ0EoWO4PUm?=
 =?us-ascii?Q?oVnx51b6j5CX/RCY1YG9ycg9x4l3af0Onljlex9StoHc0rbkkYFBSjlq6wp6?=
 =?us-ascii?Q?PAzuIsH9FZqCgCVWi/8hjNVV3jHmHBQ3oBCRFMTuqMLPJT90rQIoOfgNBtv1?=
 =?us-ascii?Q?VtZAn8CbR5948IdqOIc4+iwPHA0IIyqNa5rOcxFmL9strks2jQs0pQbtfO3C?=
 =?us-ascii?Q?aZZVDmvrkjp0A6vbtg4w2jJ4G93S7WngGOvRYqJ/HfDQlXA9ni1IzX3ic4BN?=
 =?us-ascii?Q?I7DLeL07N5jol/wXflajZMK+3DYD13ZsAGD82T8ZdcHWX0bpUtZdQur3jPO+?=
 =?us-ascii?Q?hvDzE2YY/gBwzb2YWbQeggOzrRhCt6pNydFJcYpQl70ynDcVJk7RX0cX/mWX?=
 =?us-ascii?Q?8FURQht3hu0/zinzinlDHmWqFe8ehFCGII4Uqjji1jNGXfI9UVmqf2fMZqfI?=
 =?us-ascii?Q?/vYcwgsOvhOCTP9ScF9qwxGko2+JQ1m7zdOIx8hmisyTunJ9VaNBNJIMqkIe?=
 =?us-ascii?Q?ZpEIyZ/taxsheoMTVxQFEDQGCW2TT7VEnTFeSRAbIRkU8v8Gg8Ib9q90PFQi?=
 =?us-ascii?Q?SkpfOy9nP8tX3Y+YAvugQwSM8q/rKBswObWsXCLmHSmzgr27sA7aLmGcIKSb?=
 =?us-ascii?Q?PrbbSteLnAcnpKtqUZtGWhHtldnIslzGQHdWl/oxaMgP3Gj282fwIIHDiIjL?=
 =?us-ascii?Q?52biLyJfjvo04A4iVxfvKPgoNOKvQC96zCYMgeLkwYQry/CKsLuJACnnN0Fe?=
 =?us-ascii?Q?JjcXWD0NdBtIjaI26gBfkL/e1L6Sk19WtdWwivaNRXlCqhgCPLBAe+GnLp09?=
 =?us-ascii?Q?DqqegKJyx7OH2vfQ8e7GL9Mie+meDIlVvW64uM8EuiV2F1knGjn22blzIjzT?=
 =?us-ascii?Q?Ee51g4mPhG45J18XPsuKK5GPWx7O7Majy7aAUu0Ou7qXh3sASgQjRIQsXwS6?=
 =?us-ascii?Q?dtSHkL6IiWKHWhp3Yvj60uZvQoZuHXyf7ayJZObVTMCBVXX/tesu0LWBWuI8?=
 =?us-ascii?Q?OkpuzogmAA54pUmIH210kGsBrqqDtApuGaL7ylWqqXbSb6vl8DwEDf2cqj04?=
 =?us-ascii?Q?lKNLKEHDpf5tjKtJy0IlqAIHuaqtI4W6b3jAROGeTjInIENgD2HtP9hifvfc?=
 =?us-ascii?Q?x4bL/VG9IxEmMYNdwfFXEt2wHO1aMR+m3A3w4tCCMISC3aghWa2N3LoNc+ll?=
 =?us-ascii?Q?6fjyeST2DqzdVzhzg8v+waYsqHmcW6G6dX4FSSxZMNI/8GPHyL6xCJH9gGkQ?=
 =?us-ascii?Q?6H1GaWIUkHS/RbbmsxKk7pEU9qRxUcuOyDHHCrA6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b52b8d2-9b1c-4878-2fc2-08db8e74dd40
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:41:18.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8USNfhHRA98JzrRRXL6PD/SAamLjUNXgxij0Lqt5TeOTqBBARkRGVJJmzf3oYCnECsJdWLcal8xDgEx7CgEvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5816
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> -	case MSR_KVM_GUEST_SSP:
>> -	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>> 			return 1;
>> 		if (is_noncanonical_address(data, vcpu))
>> 			return 1;
>> 		if (!IS_ALIGNED(data, 4))
>> 			return 1;
>> 		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
>> 		    msr == MSR_IA32_PL2_SSP) {
>> 			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
>> 		} else if (msr == MSR_IA32_PL3_SSP) {
>> 			kvm_set_xsave_msr(msr_info);
>> 		}
>> 		break;
>> 
>> 
>> 
>> BTW, shouldn't bit2:0 of MSR_KVM_GUEST_SSP be 0? i.e., for MSR_KVM_GUEST_SSP,
>> the alignment check should be IS_ALIGNED(data, 8).
>
>The check for GUEST_SSP should be consistent with that of PLx_SSPs, otherwise
>there would be issues

OK. I had the question because Gil said in a previous email:

	IDT event delivery, when changing to rings 0-2 will load SSP from the
	MSR corresponding to the new ring.  These transitions check that bits
	2:0 of the new value are all zero and will generate a nested fault if
	any of those bits are set.  (Far CALL using a call gate also checks this
	if changing CPL.)

it sounds to me, at least for CPL0-2, SSP (or the synethic
MSR_KVM_GUEST_SSP) should be 8-byte aligned. Otherwise, there will be a
nested fault when trying to load SSP.

I might be overly cautious. No objection to do IS_ALIGNED(data, 4) for SSP.
