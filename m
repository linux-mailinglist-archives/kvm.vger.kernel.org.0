Return-Path: <kvm+bounces-7082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A099283D553
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CC7A1F24A24
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B55605CC;
	Fri, 26 Jan 2024 07:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gkv4qcPm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C61BA4B;
	Fri, 26 Jan 2024 07:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255470; cv=fail; b=ZlhKvZYY6fayxNgvjPqQphJKcrWO/IMw8jVadauWXh3J5M7mSDSIrg3WpPGnr6MGe0FlYsHU2oDvxWZ9TmBny5vx5/iXsumJstUtZ1VXAxn09eNF6tWsyv+k+8NAMf9gebWHrmwnqFvTARagaT7Ly+fp6SbTRt/x5X3IRD+XpXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255470; c=relaxed/simple;
	bh=m+Ok7tekb1qMT4j7A4HG6tp6ARAn0c7urs7P67+yHZc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VSIRvvMJ9MozsW1Gm9ZM5X2bB9VS0GD7v2FsTbfX+sSUiK2vO0GhJhNhdloA+1Ye16AcPvAk5L99avTSPakwJzZN/MR522w/kR9avHf56Rvo3bbQRE+ubuCyF92EJ3ky8ZLHk6YglmVAg5PYChbh8V8U3i4yLZQHsaCYdPUMgR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gkv4qcPm; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706255469; x=1737791469;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m+Ok7tekb1qMT4j7A4HG6tp6ARAn0c7urs7P67+yHZc=;
  b=Gkv4qcPmbaGPGu/b3ZExniD3kDRDP2mO3yP1E+56+AoF8EjbgDa7lxNC
   cS4mg9f7L9ifsUgCqPbspPGV/mQL8CKmZ5CFizrJ4oxRZzpUGDyNMZeNd
   Vghawe0BlvGsYFNSAGHoN7vcxo4MDzMFcnYcrZmhAi0VJ0D8M0bpz4rjL
   udX9pa+hocYj/PUQ4FJfbwQh0X6veylQKPWXHkMA0Crgb+A37pQZ/U0uH
   r9FR5i6vkrulvHf6/IXPiIewVHAH7cVsNifz/9t8f+6EPJEA6NwxuZxaf
   AUPW+PW82yjwitsTX6LkTHlmzMPJ/ILliluRxhrVa7rh/oa+kH7xrWaLc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="20956206"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20956206"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 23:51:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="857329588"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="857329588"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 23:51:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 23:51:05 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 23:51:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 23:51:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0dHdVoNg+EJi2Ug/M+wF+MUPR7GK4NZ/F2xwzxcV7BDXvszr+tHG70K3wlwP4ep3onnhtkN0NdsTZJwnwFRWHm5lsvaUdjb238YSNwyfQ+7mBxrC1k1D8DU1JQ5aVbQQs8Ds3lN0qZXoiDH4dZFIQX/biJmylwF2YXTExuUuSpCG5xT13mkFP8vN/GcAEdNRL92YajG9iIO4uXQD02Lht5PRdHszk6Qjxob/gjUxrtHumW1pbTCXpKe544HOz2F8Mrh8b+V94I4/2km0nNx3pNjYEg4Tps/WReRXWoa4UWbkaw2Kf99VqVPEyKy8LL0Oi9n0DI9xXUbJtY9ybl9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2r1CzDLYF18AWgn6cFuXOSut2yT9IBmBSBJ/VjVuCDs=;
 b=AJh9/ywc7WyvDpAtC7ciP1vE+JHWK7Pn40r3sFiAL/GY/PWXJ5DRCDJ2MJtp+TRpyt4Ygmyi1OObf8JOxMn5LERBNPrOM3uRf/Tkvoo0qzyOzCHcgxKqabv/C/BT8Qp4vkSxHMk6ieBjBD+tEfAb+KsirsjOODGlO2dCP0VXnCDw3qhUxmUfJIp5XrC0siRdjDlydge0UGeDc9YSry42pjSmcQhtM1b2TZpHxZxiAFQ1g7r7kJkxmlX3hzmBVX8JbbpQxmSvD8N2FYltwVUFDU8INZmge6Rxu873/VeK/dq9JHxqEIRQcAo8OtoyDZnGaHLxaK1EpU724nnHwfCDiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 07:50:57 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 07:50:57 +0000
Date: Fri, 26 Jan 2024 15:50:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Message-ID: <ZbNkWFuSP7wwq49C@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-25-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-25-weijiang.yang@intel.com>
X-ClientProxiedBy: SGXP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::24)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c58bad5-dd22-4c98-504d-08dc1e43881c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 047XO5XzQiUPozqk/I4pUw/dN12Q2p6VB6WccPp011iWvvkc/bI27/ikB5Z/S2UC3ravc6byolM2EgSGH4w0/3vpp9YMPaKobsr3Fy+Wha5pNPxGTjlSjkZ8whk5TuMwvpyXVsrhNn94CFa95lEnMX7XQfPbfLWvV7El9QdHoDYk/PdCf9tgaVQzrK0tnrWiglr0EV1jWrVGHqkLQIJnGX8OrFZWf6PTr4kGXU3mSC22SI9wES4EvJJ7oTi3z7CmC4iZ2Pmtys4TmzEnV07GEHypMlOYzK7nimqan2QqCP1xQH12tgCp+h/jUijzRnB3wVbFv+F30boqWIy1dQgyGBvy0s0cACr7WIh2Rvf0YPSMI0AT99I5BGZKenfdtHs6dVZzC+A2bA1vGOKU6X/irVOaSeNPfRhLziNsLVDtN2pAqZA1Fwc26k59WRun7oqgqYRoQgDp6slgiNPxbUasg8xeclY0Df7jpVDv9303h4Oj6mWXzxzLAcwe/aaojX8051NGfg1fNTqWHg1kiTnpTW3HAzWxytvzuPSGO0okKaHVFQcLO1UFplIOHDGKfzk0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(6512007)(9686003)(66476007)(66556008)(316002)(6636002)(66946007)(5660300002)(478600001)(6486002)(26005)(6506007)(6666004)(83380400001)(44832011)(33716001)(38100700002)(30864003)(2906002)(86362001)(8936002)(82960400001)(8676002)(6862004)(4326008)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xLj2LT/dkh2YWWBi4zWWAgBUKL1O9B78vnIntphF2eEBPOn3NF/aw2G5H8GO?=
 =?us-ascii?Q?RAlbVLKb9tuLypfyGEgonCuEn+UDpOJwXfzi638q8j8Vw62RFAwYl2Mekudb?=
 =?us-ascii?Q?kpR7Wcx5h4tESambuec12hrWihak+oDQXxXxGXmrG+eBzA94KKcJ3Z+b4r3e?=
 =?us-ascii?Q?3Vas79y03u3DpNOMq/iX8a+MjEB/eCtVhnKUevG0jt7blB7xo1OZDNEjuWea?=
 =?us-ascii?Q?xRdfUHBIMSLnHb95FJP8K10nlYaGNljai8MImiSkitq9QNGUdgitOCquevVT?=
 =?us-ascii?Q?DpXczPQdIDoITZ1T9rgt4IJ8W4jaMC+kHC2qYKJpugvt5h7CEnuewPjF7nZf?=
 =?us-ascii?Q?LG/AwPbsdqdk/TW62KeXpXDTsrNKX2QthlpuIX8abMtItipMMxzl80C6TtlD?=
 =?us-ascii?Q?Em++p+XmCrjoHS3OIN1nhdaGxKYhUz3iRVw4t+b1FHWLf7EkI2BFUGbjQ/2W?=
 =?us-ascii?Q?nduqyDmUy2pYMcp/csOwZlke9Qdax+OshqDXk2sEp1iKr85sFdEgDiwLrWNq?=
 =?us-ascii?Q?hdv1LJNvG7XoO7MzmCYilXUQtLK/W9GPhrel9c8sGg6E4fFQAy877r7qJYB8?=
 =?us-ascii?Q?yQMeRVeZSAcOQRLmAleUYJ3d9TcqI4/PnBZEI7v8PPWimPnii1qWMvbB6azw?=
 =?us-ascii?Q?x5ijpA0DYRpPM7R8ziJGtthLFzI7WI0RbKjZbFTUpkeIzaPRC5r3tsUZyzjE?=
 =?us-ascii?Q?NCrwYFFlJeauwXz0ncpJwUOLu5yzxnDIXFnpfej8sF6LyfNgyFWQE/UhfFgq?=
 =?us-ascii?Q?CnOOiVnBU9K7q1CMinPl1MB1ZirDqpq4k2DIWOleCfUPj9fBf674uygWEP11?=
 =?us-ascii?Q?QSZYRWNRewN1jfNHQik5b4nQYkDGmuJQJgw1i7a/4+gVRT0swsh50ekQNHO/?=
 =?us-ascii?Q?G2EFzxDIhYV/GNZtnJlIXsyNPC8Iu9ZNOazbbHAagRI70dvClmHX+4XmSC3V?=
 =?us-ascii?Q?S1Y4l/h+oaxpHy2WlAZkbZMSnQM/8yNlKLvUB8VTomzlF0TKXIzo/iHUxa5e?=
 =?us-ascii?Q?ZL5y+MaNEeZe5ZYx+rPSV3v7WNsHbIEif3fSXI2AnkVlnXKOGbzTs4yFK9nY?=
 =?us-ascii?Q?wN+stYnRR1Gwwpayk9fCasNisfIanqatDY9gwTwGeE2AtV4dBoPRzYrvfW3k?=
 =?us-ascii?Q?J6GmHO9+89MJrjmRM+wNzpUJgGqywsk+UEIPZ91doTMK2kCaVXBz3zaxmWgm?=
 =?us-ascii?Q?zA8SHh3s4bAAbt/Jg/Mz0ejcjfTVihqQJBeCSHjNgBAE/58973nn6QVVnI46?=
 =?us-ascii?Q?O6e4bEgPU+6z7rAF270/Sw0DvXSv1FWxiPraDV/PhS2bLrSezUvSJ4SM+OiV?=
 =?us-ascii?Q?fKLfFz1H0m/ydiL2cf7Xazk0un4+pLmXP2LGndfDj+RGhJy7fnv+742stmG2?=
 =?us-ascii?Q?j2zmgFjbcsxWpHh9cwglgDTaXGf9vyMJ6JiuaD76Q/9NGwz30Lk9B2uf8Y2u?=
 =?us-ascii?Q?nJBBWGZ5AB3b2ZmNjuOG0EmUbnY6YAPR3fdpL9iTiIZMAT9+P7oTjCEHVVG7?=
 =?us-ascii?Q?Su/lImo2n1r0EfzP8TkiaWV6C4Cx/La/SoA4EVqFJrX197Etcyo/SunVcyN/?=
 =?us-ascii?Q?GUfaMjJvMtvZ1YDONSs4FHv9Ud8KcMR6UDludEFR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c58bad5-dd22-4c98-504d-08dc1e43881c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 07:50:57.7022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OdKdBlOfxdpfj718ze2oQ3h2yGZGsFmULpting1vqVpOk223mZ7YX/Bt6FAMfdw4tmCK57Calyml8Q8hkfdnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7880
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:57PM -0800, Yang Weijiang wrote:
>Expose CET features to guest if KVM/host can support them, clear CPUID
>feature bits if KVM/host cannot support.
>
>Set CPUID feature bits so that CET features are available in guest CPUID.
>Add CR4.CET bit support in order to allow guest set CET master control
>bit.
>
>Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
>KVM does not support emulating CET.
>
>The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
>guest CET xstates isolated from host's.
>
>On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
>code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
>error code is allowed. Disable CET feature bits if the MSR bit is cleared
>so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.
>
>Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
>in host XSS or if XSAVES isn't supported.
>
>CET MSR contents after reset, power-up and INIT are set to 0s, clears the
>guest fpstate fields so that the guest MSRs are reset to 0s after the events.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/include/asm/kvm_host.h  |  2 +-
> arch/x86/include/asm/msr-index.h |  1 +
> arch/x86/kvm/cpuid.c             | 25 ++++++++++++++++++++-----
> arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
> arch/x86/kvm/vmx/vmx.c           | 28 +++++++++++++++++++++++++++-
> arch/x86/kvm/vmx/vmx.h           |  6 ++++--
> arch/x86/kvm/x86.c               | 31 +++++++++++++++++++++++++++++--
> arch/x86/kvm/x86.h               |  3 +++
> 8 files changed, 91 insertions(+), 11 deletions(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 6efaaaa15945..161d0552be5f 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -134,7 +134,7 @@
> 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
> 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
>-			  | X86_CR4_LAM_SUP))
>+			  | X86_CR4_LAM_SUP | X86_CR4_CET))
> 
> #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
> 
>diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>index 1d51e1850ed0..233e00c01e62 100644
>--- a/arch/x86/include/asm/msr-index.h
>+++ b/arch/x86/include/asm/msr-index.h
>@@ -1102,6 +1102,7 @@
> #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
> #define VMX_BASIC_MEM_TYPE_WB	6LLU
> #define VMX_BASIC_INOUT		0x0040000000000000LLU
>+#define VMX_BASIC_NO_HW_ERROR_CODE_CC	0x0100000000000000LLU
> 
> /* Resctrl MSRs: */
> /* - Intel: */
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 95233b0879a3..fddc54991cd4 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -150,14 +150,14 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
> 			return -EINVAL;
> 	}
> 	/*
>-	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
>-	 * state is not defined for 32-bit SMRAM.
>+	 * CET is not supported for 32-bit guest, prevent guest launch if
>+	 * shadow stack or IBT is enabled for 32-bit guest.
> 	 */
> 	best = cpuid_entry2_find(entries, nent, 0x80000001,
> 				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> 	if (best && !(best->edx & F(LM))) {
> 		best = cpuid_entry2_find(entries, nent, 0x7, 0);
>-		if (best && (best->ecx & F(SHSTK)))
>+		if (best && ((best->ecx & F(SHSTK)) || (best->edx & F(IBT))))

IBT has nothing to do with SSP. why bother to do this?

> 			return -EINVAL;
> 	}
> 
>@@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
> 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
>-		F(SGX_LC) | F(BUS_LOCK_DETECT)
>+		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
> 	);
> 	/* Set LA57 based on hardware capability. */
> 	if (cpuid_ecx(7) & F(LA57))
>@@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
> 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
> 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
>-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
>+		F(IBT)
> 	);
> 
> 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
>@@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
> 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>+	/*
>+	 * Don't use boot_cpu_has() to check availability of IBT because the
>+	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
>+	 * in host cmdline.
>+	 *
>+	 * As currently there's no HW bug which requires disabling IBT feature
>+	 * while CPU can enumerate it, host cmdline option ibt=off is most
>+	 * likely due to administrative reason on host side, so KVM refers to
>+	 * CPU CPUID enumeration to enable the feature. In future if there's
>+	 * actually some bug clobbered ibt=off option, then enforce additional
>+	 * check here to disable the support in KVM.
>+	 */
>+	if (cpuid_edx(7) & F(IBT))
>+		kvm_cpu_cap_set(X86_FEATURE_IBT);

This can be done in a separate patch.

And we don't know whether IBT is cleared due to ibt=off. It could be due to
lack of IBT on some CPUs; advertising IBT in this case is incorrect.

> 
> 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>index ee8938818c8a..e12bc233d88b 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -79,6 +79,12 @@ static inline bool cpu_has_vmx_basic_inout(void)
> 	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
> }
> 
>+static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
>+{
>+	return	((u64)vmcs_config.basic_cap << 32) &
>+		 VMX_BASIC_NO_HW_ERROR_CODE_CC;
>+}
>+
> static inline bool cpu_has_virtual_nmis(void)
> {
> 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 3993afbacd51..ef7aca954228 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2609,6 +2609,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
> 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
> 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
>+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
> 	};
> 
> 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
>@@ -4934,6 +4935,14 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
> 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
> 
>+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
..
>+		vmcs_writel(GUEST_SSP, 0);
>+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>+	    kvm_cpu_cap_has(X86_FEATURE_IBT))
>+		vmcs_writel(GUEST_S_CET, 0);
>+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
>+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);

At least this can be merged with the first if-statement.

how about:
	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
		vmcs_writel(GUEST_SSP, 0);
		vmcs_writel(GUEST_S_CET, 0);
		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
	} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
		vmcs_writel(GUEST_S_CET, 0);
	}

> 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
> 
> 	vpid_sync_context(vmx->vpid);
>@@ -6353,6 +6362,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
> 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
> 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
> 
>+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
>+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
>+		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
>+		pr_err("INTR SSP TABLE = 0x%016lx\n",
>+		       vmcs_readl(GUEST_INTR_SSP_TABLE));

how about merging them into one line?

>+	}
> 	pr_err("*** Host State ***\n");
> 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
> 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
>@@ -6430,6 +6445,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
> 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
> 		pr_err("Virtual processor ID = 0x%04x\n",
> 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
>+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
>+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
>+		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
>+		pr_err("INTR SSP TABLE = 0x%016lx\n",
>+		       vmcs_readl(HOST_INTR_SSP_TABLE));

ditto.

>+	}
> }
> 
> /*
>@@ -7965,7 +7986,6 @@ static __init void vmx_set_cpu_caps(void)
> 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
> 
> 	/* CPUID 0xD.1 */
>-	kvm_caps.supported_xss = 0;
> 	if (!cpu_has_vmx_xsaves())
> 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> 
>@@ -7977,6 +7997,12 @@ static __init void vmx_set_cpu_caps(void)
> 
> 	if (cpu_has_vmx_waitpkg())
> 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>+
>+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
>+	    !cpu_has_vmx_basic_no_hw_errcode()) {

Can you add a comment here? This way, readers won't need to dig through git
history to understand the reason.

>+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>+	}
> }
> 
> static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index e3b0985bb74a..d0cad2624564 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
> 	 VM_ENTRY_LOAD_IA32_EFER |					\
> 	 VM_ENTRY_LOAD_BNDCFGS |					\
> 	 VM_ENTRY_PT_CONCEAL_PIP |					\
>-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
>+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
>+	 VM_ENTRY_LOAD_CET_STATE)
> 
> #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
> 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
>@@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
> 	       VM_EXIT_LOAD_IA32_EFER |					\
> 	       VM_EXIT_CLEAR_BNDCFGS |					\
> 	       VM_EXIT_PT_CONCEAL_PIP |					\
>-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
>+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
>+	       VM_EXIT_LOAD_CET_STATE)
> 
> #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
> 	(PIN_BASED_EXT_INTR_MASK |					\
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 9596763fae8d..eb531823447a 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -231,7 +231,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
> 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
> 
>-#define KVM_SUPPORTED_XSS     0
>+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
>+				 XFEATURE_MASK_CET_KERNEL)
> 
> u64 __read_mostly host_efer;
> EXPORT_SYMBOL_GPL(host_efer);
>@@ -9921,6 +9922,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> 		kvm_caps.supported_xss = 0;
> 
>+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
>+					    XFEATURE_MASK_CET_KERNEL);
>+


>+	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
>+	     XFEATURE_MASK_CET_KERNEL)) !=
>+	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
>+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
>+					    XFEATURE_MASK_CET_KERNEL);
>+	}

I am not sure why this is necessary. Could you please explain?

