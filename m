Return-Path: <kvm+bounces-7312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13AFB83FECC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 08:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B88872854A9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 07:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169A04F1F7;
	Mon, 29 Jan 2024 07:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQBwYKNx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6084F1E3;
	Mon, 29 Jan 2024 07:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706511895; cv=fail; b=RfdfLpIZJrkuKOUSzHsDz8BJipXwA3Uz/oMHtGqwAvjO8N9hGIkop3j3MKXiJejk2zu/fqmKiHOmgG4Q+GUl9h+hpuVELjYLqpOayPmgy0RxdgMBL1dmWP4i054qauTA1v1V/eBwqaccWJSwVGYHu2Qu3Phg2ld3uNz0ueaaqXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706511895; c=relaxed/simple;
	bh=+qfEvfozW8c/XFHNbWKV6ETM34lR2OKJU1o1xAGLmxw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X7CT67M2hkudkbEYnHAz95cWFmwkrRIQi4SJId4E1ScVGmRRxwD9R3cbIyFBYt9fHgrgDfyHtxMSctzUnwzLF4TDRYNiCLBj1qIG27gAg5cG3SQnhAVE4IDSf/uj9STC6kPxPdnAqseMA9/SLvV4QUvQqIwS9WCkcAAXuMWd93o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQBwYKNx; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706511893; x=1738047893;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+qfEvfozW8c/XFHNbWKV6ETM34lR2OKJU1o1xAGLmxw=;
  b=KQBwYKNxoo6/5RfuTcAOwe2FQ2DoepAKAmCIvRkwQUzUgG81KZak1TOl
   z86e/W/92a1SMA72YSpKW5paj6lOD0VGR0v6nrRnkVUL+vMUZ27oacXPn
   W1Im4g/6G03kIistkAIo8WlAO4XlrvPTByqF4ONu5oZ//dKZjNoaCkTSV
   CuSC9bydngSgjnVZjBhMr5CZvpbFXaHQ8iAGCe9pfjH8eKQ4Q00q9YLEY
   YgHHd0/n+/WVa74+8LBHRrJdvGMSIx0eZo/+PqrwGSLz6gN9gY2ntcy3C
   U12W5P0TIRSlmHMRGJDMO4vmR15czyfu9R0K4pVGqArtIBYZVMfqRtNkb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="24338037"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="24338037"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 23:04:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="857996606"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="857996606"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jan 2024 23:04:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Jan 2024 23:04:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Jan 2024 23:04:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 28 Jan 2024 23:04:50 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 28 Jan 2024 23:04:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O93dY3KLaI21sCOCiAIpx6LefL6AH0gR0COM6PTOBMgEZZSx1CsOpJmuPpwYxEjgz3rU+MFd0CgSPQ0UUD+U1SFee6PKzd/Tx3+TLUFbt+X8JWf3mKER00JIZ2GQddA/2Jlma82XJVOMZkeAswVRoULR0uWfmp4Px4eOdyO9Xemf//PJDDRpTdMeuyucOmnDX2DQBAcwgAKuUAqjMwCRAI0VOL/DIcvr1zcEqzZDThFF0wBRC2k4DpiWJGFIbWsdyYd/UlMDvuJ3Z3ZXAoLyloy1MubOUZrmWwM5EsJIX1ijWTBQY0df8aKGZGO7dyl5GLTVVE8+9ABMKhgnDTtDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuBnfhOGhG2+qMV8bAO4fUEUYjyj2YUT2rEi9MLwxe4=;
 b=BqeFPZdLmaP0hlNWr6+9003NU9AFrdHrE+pYdoE5xbpK8duMDqMwScWTu2hNtSPTXe1rrFZaSepercf6AD7Q0PXAwDZr69nwj49mhN+QE3rpLUTODOAep0PvqouxbZWON3jLPj8H66CFIU9rxXheplzR8fwCp+WqUaJ5dNkqRH8jZKc3pEwkSn9zrsoFR/mMhu6FJ2wFlNepmviZ+eVuLAJh6OMkXb+6+PWx/EPNkwZQDK23EGlMAvhou0UR1sEfZll2Qv7QeJFqb+magLwEoUwRHvCwk4qKs7sY0BTCd5vOIGVBgRCAoB4/kzJznsh5HHYmv62WkEN5e0o0pfLQ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5200.namprd11.prod.outlook.com (2603:10b6:a03:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 07:04:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 07:04:49 +0000
Date: Mon, 29 Jan 2024 15:04:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 26/27] KVM: nVMX: Enable CET support for nested guest
Message-ID: <ZbdOB5YWX8CGsEHC@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-27-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-27-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:4:196::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ecc2aad-d4a2-43be-5e4a-08dc2098951b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z61+be55ZRr4blnwm1w/U+9WBxi+oFso1+oXcBUZ+GMTQDPzrQbzemDqWb3+fQZ30QKOsKR/pCTvZy6cOaI4m3dEZ+jLmbZirKj1zpB4LtB7u0T8UAk/Cwyr0VMJcBK1q0M5LySf8pNvwOlfqENq6XQs/2qvN6CYba5qVU7sxMdO0v8TB1Ot6iEmn3Mmua810xa5yauwgghG6I3S50SLAccLG7HDvF7sy3I3xt8V7Sgd5TWbtoSMt3wMYLZg81WYhzdl69m5e3/2OQ/DSpvD0t88P6sNhrJbhC5HnynkaxyQKm8z0S6iA6cIE+SddOa+tUINfJf9c2gvsYvI1RretI/Vin5mh9Dv+xInt9DxaEIKnt9FJxfSc0ElG19/VLXPJPoJmnwqtVTe+8Sex5h4mcZmck3WcvdG+lA1tWiTxIVBBleaaxqqxU8koIpdXvfDAbzcTXOYov5yAHiGw5uG3Wp1nvnnBLBXq8mTFVLQmRyi9PvDp+Lxsxo6E3uP27zFNvqGy4xW9VhL3ikVObmgBYox4yOZJY7cR3zRWyHAy1RroYDoAEh9Ny8YjcW6FFdO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(376002)(396003)(366004)(346002)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(26005)(83380400001)(6666004)(6506007)(6512007)(9686003)(38100700002)(5660300002)(44832011)(4326008)(6862004)(8676002)(8936002)(41300700001)(33716001)(2906002)(6486002)(478600001)(316002)(6636002)(66476007)(66556008)(66946007)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ea4XY66LcznVACxBfD3Z0A5OlNEtlaRZ5frrkp/7GKTCo+UFdZtHQbDC1ue?=
 =?us-ascii?Q?DXYIiV5eybjtPmvD/An+jPLavwn11ZtA0Nyd3+JgjYykbggolgul3ttbN0vi?=
 =?us-ascii?Q?V5R4dRrP32vblR/n531UFmNlnreUAJlzCFPbW7zokda8EDBLYnMnNK7yu1Qc?=
 =?us-ascii?Q?Y5PqaRk2wRHdhUL9QwVIJLtbNlZVCNQz6JBzYQqJ/fjlqk3GOj9bqYKzIln4?=
 =?us-ascii?Q?NqJtej4xQGuUpGlAU3o5HLkLnakC3wsYdimhQdghTh4RjV17eQbBKBotMLn7?=
 =?us-ascii?Q?QQCVJTQMRsjBtzIe2ORM+qESbWTWcHZBYEQe3IW7dbxJehFWeAbJ8ApZFF/S?=
 =?us-ascii?Q?KpeMDuFUoIn9Qt/mlAtxu40rmvSRlTD92udAKRm1z2PEV0IsvvNHzBEU+aUo?=
 =?us-ascii?Q?i8kaCmIupu4W22NrR11NrMYC/2lDPdeSGn4O2MwWkaTTTPRVSKiN1FVpW+Q2?=
 =?us-ascii?Q?/oYqO/8y13dkaqZMbcgYy5A9XsEMDSzQKFxszNA5EsJeg4HHNgPINKRKWemZ?=
 =?us-ascii?Q?n+ye5I4PuMDz5kaYuPbSX0j/9rAmGdmhd9SDjAa74f6hhESEXleEsGIGK+yr?=
 =?us-ascii?Q?xpb3bXGAD2fruR6UXnvB4zJIl3Anpu5i3jbRVQ/5trjKSMeF4szq+ka1dqzJ?=
 =?us-ascii?Q?KrBZljAJcShLR7QminiMAn12UnRkeQlS7t9pRmw7mtDGvffDk2Dt/vdcrBB/?=
 =?us-ascii?Q?S77C5yvwC08LY1sbxVnGbXVLaWxLNGbkfJUmaBheHJ1Qx9j7QdWUrUUuj0He?=
 =?us-ascii?Q?ynzbDoP3cgVJpdyIThEubFuFwMNQ383drrhyfgFs8WoRX98/kR1jWg9AUwCC?=
 =?us-ascii?Q?jGbzpMFWW5A529k6Imcnq4ygK5UhJECYSiRetJkuMewk62wwAzsD1ulJuKhX?=
 =?us-ascii?Q?jrCZkDQ6IDtINQw4IGJ14dhbnpdm7PcJ/04A+Bp2UTWDHNifoxHQQa3QAgys?=
 =?us-ascii?Q?tyM9J9f+92u3rbuTHPQZHkSGory9YPg+powB5sf4G5QyinPsaVWmJcA/CqIw?=
 =?us-ascii?Q?fctqWqsXyOHg4aDvWetWRjS8VKzRC6CuJIq0WfVMzA1EB4i/icfYKzigl7+V?=
 =?us-ascii?Q?F6Q7lhrMeJzOaDUBI0aS4IQe3DcslnizDhVWbuXhDcooLa+5i0JBm9oci3st?=
 =?us-ascii?Q?l3H1PreVg5gG867UrvUNd042hTxXlZfLwwlGL/6GWurxQqO7pr3IsXq6+Zj4?=
 =?us-ascii?Q?ZytpVi3wGlEo4hR4nPxkImyktNysURWHCLDAAzGP875EJkTZuUpigvLPxe+k?=
 =?us-ascii?Q?eb3peeXejFtI0RzZjKI+lbc2y0RBTUeA9h58cYTgDP27q9ifF8tPuDUGTdqS?=
 =?us-ascii?Q?t3fMN8tPm042tr7mwXYH0ksXpxe2ZTrBYz6H5+DYFHzGJ5Drw2gyPuzILLx1?=
 =?us-ascii?Q?j//bp+ByaCCaP6MJP6BjD/U+UL4ORqCiIHObRUlZOftXFb7oUe1lvSABMOW0?=
 =?us-ascii?Q?DS8WefKyrdesqiy91pXDsN16cnpn0SGvjX8SkOReB9cHmfS7WMwdup4LXjU+?=
 =?us-ascii?Q?MmZ9uQ4Yd5d85lwVMYBMv6iXZ0Adzzjqlsuc9+bmEIZD/t6TAdyK65riqiA9?=
 =?us-ascii?Q?79msLl+McrhUTmILhTIqas14NFZbRRNMxd0pty6K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecc2aad-d4a2-43be-5e4a-08dc2098951b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 07:04:48.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKLmXfTWffkJPJTdh3KMxS7Qel2gO4vxFEoKoHvYHExk6/hOR2vebqpT7gzomlM5Th3XN2HZyIDxfcRIRTCKHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5200
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:59PM -0800, Yang Weijiang wrote:
>Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>to enable CET for nested VM.
>
>vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
>to resume L2, that way correct CET states can be observed by one another.
>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/kvm/vmx/nested.c | 57 +++++++++++++++++++++++++++++++++++++--
> arch/x86/kvm/vmx/vmcs12.c |  6 +++++
> arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++-
> arch/x86/kvm/vmx/vmx.c    |  2 ++
> 4 files changed, 76 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 468a7cf75035..e330897a7e5e 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -691,6 +691,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
> 
>+	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_U_CET, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_S_CET, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>+
> 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
> 
> 	vmx->nested.force_msr_bitmap_recalc = false;
>@@ -2506,6 +2528,17 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
> 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>+
>+		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
>+			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>+				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>+				vmcs_writel(GUEST_INTR_SSP_TABLE,
>+					    vmcs12->guest_ssp_tbl);
>+			}
>+			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>+			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>+				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>+		}

I think you need to move this hunk outside the outmost if-statement, i.e.,

	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1)) {

otherwise, the whole block may be skipped (e.g., when evmcs is enabled and
GUEST_GRP1 is clean), leaving CET state not context-switched.

And if VM_ENTRY_LOAD_CET_STATE of vmcs12 is cleared, L1's values should be
propagated to vmcs02 on nested VMenter; see pre_vmenter_debugctl in struct
nested_vmx. I believe we need similar handling for the three CET fields.

> 	}
> 
> 	if (nested_cpu_has_xsaves(vmcs12))
>@@ -4344,6 +4377,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
> 	vmcs12->guest_pending_dbg_exceptions =
> 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> 
>+	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>+		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>+		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>+	}

>+	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>+	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>+		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>+	}

unnecessary braces.

