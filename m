Return-Path: <kvm+bounces-12983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8405F88F9CC
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED938B26CF8
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE5256B65;
	Thu, 28 Mar 2024 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bcBGgQic"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B40053804;
	Thu, 28 Mar 2024 08:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613577; cv=fail; b=tiZ6xh2XLXS+NL2sq8jdni38mDyF3Lz4cIfYk91KFgsG+VUUdzuhRy5FG2kM1sBJFinrD+OlwunQTEIzFb9rHsQge7HFkC6PNNNFGMtknXeT246N/m9zoQUVENFiWyqI8Bjno0IK9fcUKg2TR/jqLS/21FKQut9u+sAF9yDWvvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613577; c=relaxed/simple;
	bh=sunIeWDx8susiaFheRxJw85Y5l9oIxjanG14uXffjXE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ojtrLnJASPr9+QxDoC/2qw0FDostuhk4dtaRuLPV+jCug+o4yMrX9ISwO38SloB++BvU6VOSu2cP5ifHl/UGjvuU8NPDbSW+UtF8oyY4oQlQOPQ7SoAY+RgdT6OVD9qDqnxOt2jYvNfL3JNJcxqRZsB+y2f6fPUFGhc2GiQBPkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bcBGgQic; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711613576; x=1743149576;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sunIeWDx8susiaFheRxJw85Y5l9oIxjanG14uXffjXE=;
  b=bcBGgQicf6Twbf1p+AZgX/w6X5LRXhn+aZPfGi0wIIxxd1rV2GUx7lgk
   2SWXmKbvv+9+ZVOzo0eEvWS4a/SwEUm8OQKg2raZ5V3aw2G0dhbUr8kQT
   Rrw1IdngmSKRTpsPTecVoB75LZGgg1zYiddQ8sq9OXv+wh+rlLZ1yyJVQ
   80zSAziy8YPZzVN5u/vTrfOHXMSgbz4h9JDhtvT8nwr5pSVQPn7HGwPUE
   iuNUrNMMiJIc41w8GwemCICZhdF/Yx9t9AQJeUrg8EU41et1GI26U7zmn
   Koli7yC9Jbrv8O5vaPyf+c98Loe+ps9MvguWTU+XriVesdTnDRvoGAnBR
   w==;
X-CSE-ConnectionGUID: YDLtwnWnT7a9A8+XYM2j8g==
X-CSE-MsgGUID: SK6u5/9vRk+XXPUtEyMaZQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17481084"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17481084"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 01:12:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16604381"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 01:12:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 01:12:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 01:12:51 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 01:12:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O62CcwGVt5j9urwv7aCF+jX94hHOQ9MMUv9q7CF9o9gk3HRsIhsJizfXEBu3NNF8D4T7DBLE4ftSATqnNtIXYr5Afpw6/q73gnQ6QQtSj1XBXpeTjPNgw8E1xD9D5NE4P91atxAFV7ncS7p7fVThcb1WWPo9tBU+ODCh15TBeuSz8Ae+IuNEnwhKFP0h144g3tItF+iTjyQo1BAmYZTVZWPpckLom0cTED9RvAQnatIa4l5YiDi5P4+zb2oQcobpdqdKpk0zOOoZIzjxm0A/qAdP7qrpKnyCOKxJrF13y7SpErh+L9u9grEhq6974hgZNIlcw9P+OQiJXUbWFo/6pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFufGMDYtGfRxH9EvBG7jQwW4xSN//imvdQTkmDmOB8=;
 b=JzJR/uZVrb+I48e2bngbiEGo2mUln4Sy/1vnTPZEc85xEkmq9oqppAEqAxIRBW++XpMHq0GUKulyEFxoAldzK3BXvzV+GY2TyCwDDis3vFOokZHpQzEjdMkZ60UzWkLkI1N4lnI/uqcaj+YQ4jXoQUDQ0Kp1sketUWS63j4y0TQx/FqG1DdRYiezQZrJAzt3Oh68Y//7kCfPZJuozMWvZBkHcHHfhmQAprRcn1nSw7klGL3Br+65ryQM0WIshyScx+8I1jjl1Oyo0C1E2X7euwBVv20fBYxsFXUK7tBw+xCc6Ze+qIvQuQDi4PvxAy8vSr1GfaEHE555SXKUtqc2MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5996.namprd11.prod.outlook.com (2603:10b6:8:5f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 08:12:46 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 08:12:46 +0000
Date: Thu, 28 Mar 2024 16:12:36 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 091/130] KVM: TDX: remove use of struct vcpu_vmx from
 posted_interrupt.c
Message-ID: <ZgUmdIM67dybDTCn@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:3:17::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f90f63b-1350-4a8e-ad00-08dc4efed9b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beEAre1K0qElt/N+BlOBFs5s8tkdVEJQu2Rxw8SxmPjZ7fI/6ZXmKgC3PaEgcRbzXYITRdFjcIqXhSpoAr70yAKbMXjNa21Yq3cppq8lsTCdmtwTBlRXusw1HWOjzufaEZF8km7kTPz2IBglkQ1uzuKXiuWBrjmN2rdkXoitGkuoMTmNCm+6LxkpIZCZ0ngIdchqnfNwTIna+FiWnFyJ6Ce2g8XG8BozyRwnBuvDNYHSoT049h2imG2YlLfbqkKAh/mJSZqsAgJS1RMMjQa2VFAPeSSIetjXKNbpSQRH3Qcmt2J9EaZOlHLsl1/HL7LyWzHYUmjttHhee25cNGVCUCmcrne9ZCE5+6+KEm7ceJ48+DW3tiweDibkX57bi4VfMjynvlHn5KFAXzjEopAFZqzWMtE1nMthl5+g/bmHOKh4zCX+YI7bJYtAOyo6OMGsKOuQpAyrw1OpJmaKVfyfZbNWYV00cmq3EBczoQqHcQUFsCHtNkkessDYWh+FEEs1+EcPPmL6JSekPdUvEW32ykGkGmCkp6R3ux7wFdvJp9JapR6Cx0+FcNGOfYrZiJRLoOjpNqdC6qNISiPzW1yVtSfhk0pf00LcvS1cqlkqGRSxWjYzCvZs9eCVy//rJ6lu1Exzc76HxqYssRlzDkywS+LJBTHKduZq6SRizK+CSBk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MQzZmwKgoDIw35b+jtUD6ksnoNq9U+/uB23DLF9tKckR1mg30vRDJpr8kcyO?=
 =?us-ascii?Q?oyhOtoEjZA0yhB53J1y8ipByFexTW42a2xukroDyT0d5KE7d/AffXS1NadmS?=
 =?us-ascii?Q?ae2XzJKBSrtKq2BTBimA0NOmHMeuXIyW14PDayVGiyk4lDYnC+2hjbbXKXom?=
 =?us-ascii?Q?v85O67yBNpwg933kPAFu3G4Pmg0mEVacx3dr+6FZ4t6TZZF53ZHA0P3unQQx?=
 =?us-ascii?Q?lBcpQb5ppV6RjwTfTZWlrWRxA6MzMt/EYfUa9h6C3q9cki8fbcyuy/3ZA8Mx?=
 =?us-ascii?Q?TyM/cypvUs9XdptCm4bY9drE+cjFBQnDMTeMftHCcdLYaYosvHyaTtsLA/TH?=
 =?us-ascii?Q?kfXLxr3i05oQsaj9CVU4NIPR7AxSB5uonWpSlt1H8mFx51PwCIZDUP3zUJFD?=
 =?us-ascii?Q?nNHNDzSPhAVfzNR1Nh8GwtZoTvhsU+b3lNsg+4Gykptv9e/aZ0cVqXqh0aQD?=
 =?us-ascii?Q?X6qclm4RUjIybM8EsBZXUA+vjCgI0dBER5tr3TDeZl75D0JdmkFIBoirgNWp?=
 =?us-ascii?Q?GBZ8q8us5ifpHSY8POSnM1SD83qlnsPiWK0r+j89QcKoHO0cj7R+S2JNcYDN?=
 =?us-ascii?Q?7PTtNXGcCZaCRRo0lXTgK/8WYCE2tPoVxeoOVyEil50pu1GKi/WUAKY6BWQk?=
 =?us-ascii?Q?iOND30o7TmSXVF5YIYvKavnHJ9fhvyApru4+WBe1yMynXoyOuxIx0GkC7cGD?=
 =?us-ascii?Q?nDPLpjxAXC2cv9IcmvF+5jBYvMjmJ6yykBeUpRp4376sHx8GhSymZo7gE2km?=
 =?us-ascii?Q?C6VVC4czruRdQ/392l7qVP9/zCkLHDSHTHPmOdspAJyOy3E3UklKvpf5D2oG?=
 =?us-ascii?Q?RWoGsWceXEmE3s2Pa7SUGfQD+Lhi2Vkojbszbn2LaTTaCksC4OPJ2iSc1wXi?=
 =?us-ascii?Q?sgqbe3aIfT7K/pUsY2M1cpvzubQnoZyO1VPqrfVh1urlCmkXKUhpK/jfHb8F?=
 =?us-ascii?Q?OeWMsIXTD2L++DyjGDCq6sjBia+WkTxhMPe4Tf2FApPKM3P987PNRmdpGoP+?=
 =?us-ascii?Q?RGNU7fV4VTivUJH/7RmZClxMkGMPrUhhflR2H5t7y/dBbACJqiYx9E9HOT73?=
 =?us-ascii?Q?OKTa/NCYEEnMrYZzETkuwDF41jLb1Bn3dQyTVumNOfrTH1auz/yeTd3HoPtO?=
 =?us-ascii?Q?OnoH/rH14rYfLsFFl4nZ1rWpqewdY5lBdKzzPuSU2AFecxiWq98mO8iJnYy9?=
 =?us-ascii?Q?yXG0Fp6TOtsfgeT9AsllSi7PEt8tcVqsn+IT2lVC9ZUNOmXpTrao2E9BHhvy?=
 =?us-ascii?Q?LC960IjC2IauZAF6wDlTbfhfGpm03R8rAPhi2vvGbG2mkdppj3wCkyc7bIAS?=
 =?us-ascii?Q?GwIy3P5NA86qATqMf8WWZUjB6jWJPrM3uWXc+QWcewwKxIGDqID8TJdNOHkE?=
 =?us-ascii?Q?BNj8dHy4Y/rXwH7jgLIZhv3Nlrnsha+gvgJIfY+MmqP8h/I4HYm/8OWgEuCB?=
 =?us-ascii?Q?4nCchd8oPewxir/nbtrUMzL7pf3HCWiKO9wmJ00UwVpbwaSPUNl1+bJ9FB41?=
 =?us-ascii?Q?urd2YH6m/ctoIIkIfrQcFp/xF3cCUp2sKO/lQSkj4XSgrAScVp21kpi5ETmz?=
 =?us-ascii?Q?X5xXpFvcs7gbx6GdS+fXfUK0bMw8yLmHonJMRXq4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f90f63b-1350-4a8e-ad00-08dc4efed9b1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 08:12:46.2097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7soK+zwdkOLf1hX2577do7+VAl+bQcXDJC9C0W7F8yKZgdY5nAY8HEHZqnVMUOou4EXlgd1LJd+M/2assGxtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5996
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:33AM -0800, isaku.yamahata@intel.com wrote:
>@@ -190,7 +211,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
> 	 * notification vector is switched to the one that calls
> 	 * back to the pi_wakeup_handler() function.
> 	 */
>-	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
>+	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
>+		vmx_can_use_vtd_pi(vcpu->kvm);

It is better to separate this functional change from the code refactoring.

> }
> 
> void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>@@ -200,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> 	if (!vmx_needs_pi_wakeup(vcpu))
> 		return;
> 
>-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
>+	if (kvm_vcpu_is_blocking(vcpu) &&
>+	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))

Ditto.

This looks incorrect to me. here we assume interrupt is always enabled for TD.
But on TDVMCALL(HLT), the guest tells KVM if hlt is called with interrupt
disabled. KVM can just check that interrupt status passed from the guest.

> 		pi_enable_wakeup_handler(vcpu);
> 

