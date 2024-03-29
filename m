Return-Path: <kvm+bounces-13042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D00348910C2
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 02:58:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02B47B244EB
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 01:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9593D38E;
	Fri, 29 Mar 2024 01:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PyVaOg7L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044B1E515;
	Fri, 29 Mar 2024 01:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677261; cv=fail; b=C0O/fQv21Za+ZsppSwJehhvpipf5uzCuaUwd/jj+MUwlysNAA03Je+qDFdPLL9U2OsCzkGkYF4oXUHFuEYwXiIWUgpQ77BiWcaC6a86lKB6V4dX/HDEv4C6ZuXNcbm4e5VpXP4TUROAI8bZjaB/mGHb6VogauQ4R8JUAQSJ4Mj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677261; c=relaxed/simple;
	bh=nK3dCJ9Je5oHu6hcgw0gvRABj723iVfvHwrQPykJvi4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VESf8KK4AweZipjuBlCDZ25sUBllA8zBncWeQbhxQL/JyXbom3GRRbeDDnX0puWKtTQZCoatP/UFgXQnWzW4CvYIPf7Mu0TPoOM/aTCJy7mGFW1SSjNUcpEEdLxxtB81vr0/+LV+9N2wZ29WXzCy4fdfW8kA2Cwpn2UZOCtDNoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PyVaOg7L; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711677258; x=1743213258;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nK3dCJ9Je5oHu6hcgw0gvRABj723iVfvHwrQPykJvi4=;
  b=PyVaOg7Li6nRBeRkJHhal8NT8H16SZh/de1Bb+HDw3uzQO5npsQzV3Tw
   uBomltQKfQCTdZ7naiPJowNDVo5npbD8sTc4uJMTHdwPxa5qqUxFRWUDe
   2IujSuJW4YRiXV2e4rRW5jWL7hPEN0/kZUDvCtrpOdUcfKjXVHy+FohMN
   oM0DaH+YvAD6lklU9vKNabURkEaN33rccFSOU0rRbwEaLweS6GL+e8MNb
   2cNwxEI7CvfnArjV0njgEf6uCgbamw8l+61EVNDbYMjUzAOaxj23gNR9U
   0LBNhctkgv9XUSDQrIq+LdEW50UChPlYW8T03S6TpKu/s2mUA4cmL+8hL
   A==;
X-CSE-ConnectionGUID: 0tIKzPXwTamGgz/sKpCOBQ==
X-CSE-MsgGUID: WcRQn2UDThOTZJu2JjqUtg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="18244334"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="18244334"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 18:54:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="21508073"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 18:54:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 18:54:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 18:54:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 18:54:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmZMoFenRoS/l86vWbY9Jb+HitMYlx4ex4/oO9GNZO9VmvfilGUL/LkJ1WS2qczDd0NMq0kHLkalvRtlC5q5ycEZhRJJcGkBWWVmpiVDGqk4i8uuD3MNkqTAM5aBM5/+9XLwT0kPLUe05mSggrrEOaAj/RZrkMaH64i784aEHKc9Su+J+8Lz1oIfRrG8OM5ciaNIw6+R2+XoIwiLQE5XwfNSuoyqSFAbEZMHqRVReue6j+IRO/JmgYOd78hu7+NN+sgMgmVT7++4Vkv21JO+8qsoK9/VSKRNE6GuF0R5pMSKc5vyEYVb5ZrxLafYYhqgbrKzlMeh9XH6wWi+Ev5hAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDrvEidbFvTK/9Igk3FeBTB78ieeqvb5fX/O56pJV+s=;
 b=OvzkH1VXqJdAZqX7v1cyniU/2qhO3Fczfq7T3BKzokThR8v4ivTtCnncgLA+M56TbNIxIewyggg+4zYhBG2dlc7LoMSCNmEevW37pQHnmiFaZJQ9VFtZcFPSEd5LbLopMHZFh8HPQn18jNlMEHyO6XYvniDc97HYDgopdU/lVUQOjgOiCWS5pXEigMUCfNMnjBrGoscJSQ3VFOPAGA9DcmKmEwB9uqIV5WGJxpkrGMjuo7KCyKGbMg9f1/ETfYHFL0xL/qBrSr8IfkSylMIGHmhq1UwD0BxTKIEUqTVhRhWstKEeL76/6wB1kBTZ+SRgJnbZr71ZogtKCc/UFOPLMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Fri, 29 Mar
 2024 01:54:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 01:54:14 +0000
Date: Fri, 29 Mar 2024 09:54:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 093/130] KVM: TDX: Implements vcpu
 request_immediate_exit
Message-ID: <ZgYfPAPToxbgGZLp@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3fd2824a8f77412476b58155776e88dfe84a8c73.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3fd2824a8f77412476b58155776e88dfe84a8c73.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB5819:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GiJmcHyanj9PDWMV4J+PxHVxAgLkfy+yHs/ErnMIsJgC1pPrLu0bH5RCxJHasdonOXdyqiabzZ9BDvkU2W0339V/rrs0hAqdcpy1QkvI//HUY1AGP7mXWpAIOuL3qrYSAH4X41YvF/w8rLzhdkLT55+/TXBYDe1vZm1UCVLpuR6DW6S6YEoTk0VnPEJO2XoEUoDYgO5q9komDlQ8Com1GNGD/nBsjta1PElPlS34ZLeQKouizWog20bq496jnLKgAdv9xcNvY/u84P11OXuSExTaG3f2FVFWM3KL4rHGkheQyAjs/m9MyjBTfzi1c4vJPhPARYyXrT3mYfnGuLOgOecqZkhDygq1WqBNm/Ucxff3e5hyGZ7h17jvfdRYz/eqY3vHir8M+8rSmnj4CNw++dT389uZ1sasY22Xb8zEsrDBhjlGs/yv9p8+rfHDjNwGdr2DRpWhXAJlRXSEQThs69qHLLnmKS/TcqQy5deLkV2fvaPAxvZJd5N0PQHHRaHJjHpI9dgZokjV8XnmeqildWvMsdFi0zotcqhTpy9E8J45LTWkEgNgU3HwBvWdpsC8OVpIsTj/sH0COyNjHzXRQH913/fjTgv4vkAfTxZBbHaHhYvY8dpPfwuBnpL7yTHCMDK9xa0Bato2g7e3zNsHNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E/aRR9ObiLfdbadr9iBOuapVz+uCJiacv4DS/3mi0AjL/FLHtQdzSq6sQgjz?=
 =?us-ascii?Q?qHESUohHEAMTDew8q7OtEvq4JJIOBVbPiM9gvsR2OoEsOzpyAkCGm2scmZTH?=
 =?us-ascii?Q?rvGOpmimNkwtekKz156MZKYRd29LdQ/ti0cz45vAK09Zr4SXrCagKtLXIpvr?=
 =?us-ascii?Q?p+XUiMDxi97L3dhrrhdlA73mlvbeLJMRTO9epOtf7pRdNIxTY4SbUD5EsYhY?=
 =?us-ascii?Q?I7gVSym2miWPD1S8m0S3hSHg+1idOoJtUYFxgZcEdXPtNVRMSPCmxsZcwAYf?=
 =?us-ascii?Q?UhGiDwXEdBGHLy6ngWG0FYFWqqrKN863C2P8KxfCcOviJEL2DSb1wru1+2Dj?=
 =?us-ascii?Q?U+gHNu1jyN3FyRFkDh4aDpLfm01nrPaFCXUjIDq6/1jokZFV0QGWw7ueqj8d?=
 =?us-ascii?Q?FicPnODDjEjyQdDnLbqz4xBk7VXlu5eEPFRLlFfFyR6LbsMyHwo2O4TcPJEq?=
 =?us-ascii?Q?Z7gt8A4tGO03uXuQeg+CItQNKEi+8/b/+dQLd28LKuc5grKp68LSb+95vZeP?=
 =?us-ascii?Q?GQyy7Pp6P8OjzWoQPF3Z9IcQdfA2jKLS5ZFAM1JHYSXoBP/X6MuLf90unDKu?=
 =?us-ascii?Q?EKlcI+rX+dVN5G1/oOMIbVCsF3ouO/OxTATf7RLpjaqTQxIVMdkakFtwvPPq?=
 =?us-ascii?Q?YZ7acWKn1Bv7FjW3DW8r+gZ5vBoNZhHN5ql0HQCB3olAqS/gv/5vPG13IF1I?=
 =?us-ascii?Q?lD9PNBXPSdEoAUa0jtVh9bogTFi3maVDDjBGOH9sOrfX90MhvGC/l+YTZlXp?=
 =?us-ascii?Q?LsOjsrIxJtpJlAoWCYJzSzo6D1ovAI0VFB+7HtfR8dZ7O+jr28dDAXE/DpNX?=
 =?us-ascii?Q?uC1a9CK9+XoDfsS5VIQAqidbnUm1NbnQX1PryeQtCYAe9di2sNwqUF73Z/w0?=
 =?us-ascii?Q?ElNK05h7GAakpjVnIJTAx89qaL2j3Vi2jKudHH933cTj8H64dONl3V7hBER8?=
 =?us-ascii?Q?Sdv09QxLtIwPYgzp/+XBRdwxlx4sJZqlRg8Cozd8d9FN1MzZvgZFZnz2u9fP?=
 =?us-ascii?Q?/a/lgPa5Gq1sHMO54U5c1GFRCpb9EH+Ui5uZQT7wKcXax94C527FmVE3HEen?=
 =?us-ascii?Q?qQymqiUXOYDP6NOZiOkGh2w11nz04eyJ+F1y0VBVa/7o0c4KmUZCcWKMQJFM?=
 =?us-ascii?Q?L6fiP3zZr9ldkqBHQnA4QlC0o6IbjU2IHZm18q3G4N0bHPRxZr00+Ui7xfk5?=
 =?us-ascii?Q?x9YDW2G7oVs6BImcic/za66rxQq0svPe62kNVFvl18vX+Z8BHSxR8fCAhzt4?=
 =?us-ascii?Q?TrU3vAsj5YVaDXK2m2vn46YtWns8g4h+Qbnqyo6bvI8XUx7VydIzckaPQKdL?=
 =?us-ascii?Q?+7qkzJTMMCLSUHhOhbsHsRbvvguhjWguUt7NNsAyGKpJj+dpvpMJOs0xzjVl?=
 =?us-ascii?Q?I5bPNMliIl9U6WnUCgAz5XbpuKxEZLbBI2ZWSwbBZqELUq0c2/uxTP4TfAXt?=
 =?us-ascii?Q?FMpDXrKyjqYQ/LYfKx02/oXybv3GOjC6QRztBHzQPYKFQDlu7m6hmBwpjyW/?=
 =?us-ascii?Q?CoTnduNGo6SvRnwbjYnNN+TG5unSFN5wDhPNc4S1wvz3sm/F+71zu1WsgpVU?=
 =?us-ascii?Q?U0by+AP2K8Ww4YYqC/xFNVpDvZMZdtMUP+9Zqilh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b81dc0-482e-40e3-b0f0-08dc4f932291
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 01:54:13.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55IyzqrnCEnTU8DbZYVLHCd/CKrjbsoSBLCfFHDAXBXFTIRrHVM6iioNIDat90U/bSPcVelDOVbWEJ6qtZ1Uyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5819
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:35AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
>vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
>unblock on pending events, request immediate exit methods is also needed.

TDX doesn't support this immediate exit. It is considered as a potential
attack to TDs. TDX module deploys 0/1-step mitigations to prevent this.
Even KVM issues a self-IPI before TD-entry, TD-exit will happen after
the guest runs a random number of instructions.

KVM shouldn't request immediate exits in the first place. Just emit a
warning if KVM tries to do this.

>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>---
> arch/x86/kvm/vmx/main.c | 12 +++++++++++-
> 1 file changed, 11 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>index f2c9d6358f9e..ee6c04959d4c 100644
>--- a/arch/x86/kvm/vmx/main.c
>+++ b/arch/x86/kvm/vmx/main.c
>@@ -372,6 +372,16 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
> 	vmx_enable_irq_window(vcpu);
> }
> 
>+static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
>+{
>+	if (is_td_vcpu(vcpu)) {
>+		__kvm_request_immediate_exit(vcpu);
>+		return;
>+	}
>+
>+	vmx_request_immediate_exit(vcpu);
>+}
>+
> static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> {
> 	if (is_td_vcpu(vcpu))
>@@ -549,7 +559,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> 	.check_intercept = vmx_check_intercept,
> 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> 
>-	.request_immediate_exit = vmx_request_immediate_exit,
>+	.request_immediate_exit = vt_request_immediate_exit,
> 
> 	.sched_in = vt_sched_in,
> 
>-- 
>2.25.1
>
>

