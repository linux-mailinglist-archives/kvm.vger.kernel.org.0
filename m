Return-Path: <kvm+bounces-14521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B307B8A2CC4
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68E1428B69A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5D14437D;
	Fri, 12 Apr 2024 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOttQK+w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B06C446AE;
	Fri, 12 Apr 2024 10:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918726; cv=fail; b=hSDsCLd5ZTEVQ8G+86MchFFfXHBg6yrUXMTwHWa5t5BwNBHSqShI+KExKD81tmsRg7A0PTekfcvQGF1YjqNhkIqtCQvjG0UI1KPUAPCF5pFfkP5QxR/Tfocr2dDBjWcMWxc3c9gWWBxuZ9uxlDsU38km4WkJ1wiyCvNPZBCdIDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918726; c=relaxed/simple;
	bh=F4shREE1LtpihRypu8rlGTDK96YvGESAs3sjR7DRJKE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D3p2NC0P6RZIUbkr4Bf9+Zi3dAiHgw0mCfRFzqX1LoTT1P2XrDy/3vn5hRp6oct9y1kZ+0AXA4TW1P2z0pY14ADuqPu70ELz3x6gLvAuT2pNrUPK4j5V1SUA1iemJD7Xi5JxHw9ECZLozmtguRShT4bEQM3BSOqyyLEL1ECU2AI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOttQK+w; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712918724; x=1744454724;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=F4shREE1LtpihRypu8rlGTDK96YvGESAs3sjR7DRJKE=;
  b=jOttQK+w2XO3n80VBEylo7pwAhZKhCJ6yrPvOFH/JO6oQsN2yroT5TpN
   +YcY7R0LsH9GZQ+ky0aL+eSkDlrRksACi6ge3F6m412bvXWKSJ7QBYUc7
   zXOlk/uXEc6souzqMCA4PbV/3ksQdLOgR1HDfJWE/vqxkHsGLrDhmuxLu
   Oa2tQsdWn0i0l1jt24x96idwERggDgbWL1Swmdwy46k9HbZxFXRwUAtsC
   YBYf8qdr9MaarAu8A3pKDuZUbG8S2ji3yxx9qtYTrynG+VJ9vSj/YiDOt
   vZphi4qDJpKP1asDQReHrRvoyMFkPuI0gVxtdTNRbscEpC1Mr8AHKU5Qt
   w==;
X-CSE-ConnectionGUID: nkESZkZISMelmci6LequYw==
X-CSE-MsgGUID: RL2Wn0+yTOiqxA3ce40law==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8538010"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8538010"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 03:45:23 -0700
X-CSE-ConnectionGUID: SrUiIjmSSsuUlAGue4XUHg==
X-CSE-MsgGUID: DWU562zfRw+Rl3sTXTdkLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21107963"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 03:45:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 03:45:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 03:45:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 03:45:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OprojtI18A+BN9a9r/xtRaaPsKimQF85eLCDm4XKHJmSckXIORF00RdFcJLc/68ncxqyFzpYH2xbqNfzjjB9KEb3vlBuDooifo2O0pniowwIr+J9GG/WoWYCtjtE0+H3EcGXwZSR/xbpt3CIzCbiw9CtNTWFRNDQ8QVHwuSJnUBtChN+JVbcAR6hA/Xx9X6ED3XxeTbO3BBLuS0B9jWyQh/yhor8V/wcdJNMDQxHB2nWeGpHzD+Gs9/2y97/PS+1MuWZ3lRH2tRg9upMJBHfVFzBsShYx8rEBBlEpJtADinaGX5Gr1MNu+pTX7OpHvhiM9BAs2theUBVk/lbxaZNMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UW1/4vcvKQGCgFpHOkozLTrH9XKmatOWURLcyVx/Rc4=;
 b=P/XBosu7cD+0HNrgdFemK+XQZc43cxQkhza1jqVP+jeU8dmNlrtXhHDYT4fMvTg4HLvol4qVac2MoHaPIbYsnIBm+lMJ59xDlDwXulzFwLf337DD6sh3AGO7dsDGtw2Ih4qcbAYVKzszl/ZpRX/pX/Whb6aj2v5wq6dnJpQiIoq2/8YLliFR0y480cweSWwOtPh19R89hsIug2OzRCct1SFiUzmJQZMCk5VYPGmC1He31uArmNJg04slMuCCG6sm8qOoHBhO6N3c1sxmrLOHW7XKuDix0ucMxt1CwIMphLyHhfpRpctIIrChfaozltHtuz0JiHf1RHH+F7lI8gwPeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7043.namprd11.prod.outlook.com (2603:10b6:806:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 10:45:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 10:45:15 +0000
Date: Fri, 12 Apr 2024 18:45:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
CC: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <joao.m.martins@oracle.com>,
	<boris.ostrovsky@oracle.com>, <mark.kanda@oracle.com>,
	<suravee.suthikulpanit@amd.com>, <mlevitsk@redhat.com>
Subject: Re: [RFC 3/3] x86: KVM: stats: Add a stat counter for GALog events
Message-ID: <ZhkQsqRjy1ba+mRm@chao-email>
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com>
 <ZhTj8kdChoqSLpi8@chao-email>
 <98493056-4a75-46ad-be79-eb6784034394@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <98493056-4a75-46ad-be79-eb6784034394@oracle.com>
X-ClientProxiedBy: SGXP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::15)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7043:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a4197b7-6015-4a99-7c15-08dc5adda314
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTaXWheyzvQbg3S9Qy8IGNS85ybJ6pk5D4ujPvZgy8E+srF6LOCuCPiatB34P38PsREuAasjL4CQuEx0gim9WpHjo1GeJsM7yHv+b98i1FkepCqK8xEupG/OCjH16YIY0lToX6aCDt+jXSqSyjuWudPcZ0KPSJBfDN6bdD2c6tZgXVfsoije31iQN/QD/L4iJtQLZVWpi5tZM8vq0Ms5xl+mPp5Qnwcwy9eShorXCzgI8jCLdr7nNRTpShOzwxq6CPnCv3BL+ov3ia39WG5EWo78SX+EB+hydpUyh4CNs+sN1ETtOhipIspNlHIxdWEjhJoE2D8H1LPZekOd0mbDMC0EUkot5GxKDaumRU1BcldxEctDGB4MDYcBk4kbo37RXi3IKIFuTeuWDXSev+nS6LjNocJLMuQYXjTKL7Kos/9kBv7VxKHutku/+z0J6tjTxcbDL3Qr9nREJzEPdEnBpiVfvFr7xBrNFfLtWi0w9ddAUSWGU8mtJ220ldpKULmROdLrBBkH2b2xDA8CZV3p5g8F8fpOaM/rjsPd6AJ8iHrRcCp30AycbW13iCWeFGMWOq7AG8uU42QIQrJI2RmlD2wSE2feYEFQtnOaXqpnHPEiNgztrBEfhH/dQyHX1kYMkJmAO05lMeN/Nn6o6YnpOF4STQZG9NkP0JgYGMcNcNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P0mjnh8R6HiBGdhdglK8xJ3SM9GlrRAlMfeJR6SfF8Jh63Pa9yrvRo21mNVb?=
 =?us-ascii?Q?10hy2eWsTEhNpx6WmOMU9Q8cHfzPF9DACHZ1Yn3CXyhV+PZV20VLz/viHGSQ?=
 =?us-ascii?Q?XoOs7HGvadSaQm33YIYcP7OsM1QwTPRv1uclVgh9l3iERS38vMs63iFEK8zD?=
 =?us-ascii?Q?qDDVJMGvSCv7xHEzBrDjpW5M79RbhNoDLi82MeU0mJU3/M4OILHhgNQHpzrq?=
 =?us-ascii?Q?2Zxu+zhBgcKW4xTSDfXITZWPL3Wn8t3HZ4TDaidMNf5F2+K4J8IWPHfNJ5U6?=
 =?us-ascii?Q?w99MmkWhDPO1cC5bDrcP2H1CazpmzZvbZxKWqqlc0rNLjmHkiborUpweIJCV?=
 =?us-ascii?Q?UEi2x9yrQ/+kcZ6un2MxKdQKlOnJTXz9LhLbEf2gJJE7yzcUo6n5vFWEdMd1?=
 =?us-ascii?Q?UCz+UoEu+ZiZWDRGo3aebySFM2TfwLvKUQE4JDSyJPHZpEtS3IT1PB4KKIDv?=
 =?us-ascii?Q?zfyLhBcMVQi+UXm/vuUauMUllYRrVpxC5WEtGnea1XNdY0ZIi20gWrKlHRNp?=
 =?us-ascii?Q?Z+kOrM62ZYjwLJWKsRNoP191UcEGOz2GfQZ76Dnvf546qecN0aX2FZRQkE5+?=
 =?us-ascii?Q?LewQdcLJEkofLBGo9EbnrQd5KhobkrQJ1durqyPB2xAfNBY0/EyZC+ev94Wr?=
 =?us-ascii?Q?xqhKNysdfJUNonftO1klblDu2BXK8ge5ezEdUg20hcZhAVEOek633aXCS2Ur?=
 =?us-ascii?Q?lGnXmPw1TadG0MP4Bk9tmjVEPFMUJj0F7G3YFwsC/mIazr711m1GrUTlhBQg?=
 =?us-ascii?Q?e2Nn+b2Gxlgt5dx3RdSlZhxAY4s92EzpZ2NE5Sczwk0KxVprmw8UA51OsC/F?=
 =?us-ascii?Q?t5P6n3uOvBFSVZTRb8SDwWkvEKfnD/aUyKWAqvghoKwICwGl/AbnfOeYYlUA?=
 =?us-ascii?Q?9jrHbJ6buAmxWGoxk+npO75n17NrSCzo640EdfrsTShh/IcuU90RKTiGAgLo?=
 =?us-ascii?Q?v9oJW0dJQmGs6IO8OvY37b2/82AcJ41kPcNE5gUY6tmGxrJlp2gQeiappPD4?=
 =?us-ascii?Q?/DD+qESHzg3jbRqKgI3R+frADNFpx9TLAjLm4/Ap0dZq4VStXLscTJl5qRdI?=
 =?us-ascii?Q?FmKJA2xXwM0hLg6DUtJX8Ge8tS+8xPOGSd00zxQdYTpAqv+tiZJryvI0BcQx?=
 =?us-ascii?Q?TjTnheg2/i1/aIrqOKgyeDFelCmk7AHZwSogmmx6C/XOwKizVKdGbA/wkRQ8?=
 =?us-ascii?Q?MYENt7PjoB5hZ0GSyldBvneKcFvCMHPfdRDOX33MBcc9WVAa/KinlRtyV1I4?=
 =?us-ascii?Q?0EP0r/fF0JChq+XqDg+MUZ5AdVtKsOcwMjkYRrvJt41uxpOLZoFZDN/YUd1U?=
 =?us-ascii?Q?NZs69T2okq486ZRwv5bCjqd585dVfvXY8at4Gi60dobxpCEUDddCHvdjki9V?=
 =?us-ascii?Q?eO53QbQ+CezLLRMJKVgLq0CWZBk+3y6NhlyZqgVpzFyFt1v6JGoJ2Fq+3B3f?=
 =?us-ascii?Q?0vTFn5VfNXKxIEGb4T8bGJHn9WWuVvn6YXTR2pcblU3aih4JQSDKe71NPGcT?=
 =?us-ascii?Q?VCKsEU4LMeG7CUelNKZYiXpDLoPnJirItGMCtPDvuTICdKtbaG2f8DDcZmvd?=
 =?us-ascii?Q?9CefmkWMBupDueVwLGqt2Mey9gBzycsM0Ns92bss?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4197b7-6015-4a99-7c15-08dc5adda314
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 10:45:15.1248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejJmeLP38n809Zx3+vKE1T9NVt3Wu4VL+ucfdkWqVVa/gbwj/pwFt++nuSk36K8TmOKOq2ZmzCsK3eP1HYYGUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7043
X-OriginatorOrg: intel.com

On Tue, Apr 09, 2024 at 09:31:45PM -0400, Alejandro Jimenez wrote:
>
>On 4/9/24 02:45, Chao Gao wrote:
>> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> > index 4b74ea91f4e6..853cafe4a9af 100644
>> > --- a/arch/x86/kvm/svm/avic.c
>> > +++ b/arch/x86/kvm/svm/avic.c
>> > @@ -165,8 +165,10 @@ int avic_ga_log_notifier(u32 ga_tag)
>> > 	 * bit in the vAPIC backing page. So, we just need to schedule
>> > 	 * in the vcpu.
>> > 	 */
>> > -	if (vcpu)
>> > +	if (vcpu) {
>> > 		kvm_vcpu_wake_up(vcpu);
>> > +		++vcpu->stat.ga_log_event;
>> > +	}
>> > 
>> 
>> I am not sure why this is added for SVM only.
>
>I am mostly familiar with AVIC, and much less so with VMX's PI, so this is
>why I am likely missing potential stats that could be useful to expose from
>the VMX  side. I'll be glad to implement any other suggestions you have.
>
>
>it looks to me GALog events are
>> similar to Intel IOMMU's wakeup events. Can we have a general name? maybe
>> iommu_wakeup_event
>
>I believe that after:
>d588bb9be1da ("KVM: VMX: enable IPI virtualization")
>
>both the VT-d PI and the virtualized IPIs code paths will use POSTED_INTR_WAKEUP_VECTOR
>for interrupts targeting a blocked vCPU. So on Intel hosts enabling IPI virtualization,
>a counter incremented in pi_wakeup_handler() would record interrupts from both virtualized
>IPIs and VT-d sources.
>
>I don't think it is correct to generalize this counter since AMD's implementation is
>different; when a blocked vCPU is targeted:
>
>- by device interrupts, it uses the GA Log mechanism
>- by an IPI, it generates an AVIC_INCOMPLETE_IPI #VMEXIT
>
>If the reasoning above is correct, we can add a VMX specific counter (vmx_pi_wakeup_event?)
>that is increased in pi_wakeup_handler() as you suggest, and document the difference
>in behavior so that is not confused as equivalent with the ga_log_event counter.

Correct. If we cannot generalize the counter, I think it is ok to
add the counter for SVM only. Thank you for the clarification.

