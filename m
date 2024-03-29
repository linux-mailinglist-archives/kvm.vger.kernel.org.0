Return-Path: <kvm+bounces-13043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4573889118B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED630294E58
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 02:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEF924A19;
	Fri, 29 Mar 2024 02:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzA+9qEr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B173219E8;
	Fri, 29 Mar 2024 02:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711678285; cv=fail; b=A1LKFXBwlwABm9AV3f4LZD5ztW6OGJh504gWMfW1c9VTHAQAU08tKZCx2PUccWIZWGOjdN0PwbDwT4aVAWxgfB9sm0OCTpJqiUiaeNUfCVP8nleyZ6dDV1Rif83H7dzkjE70G0juTtSCAcSjntJp7xJ2JGSPjVykc4JU0LpKW1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711678285; c=relaxed/simple;
	bh=ZVtUqmHtTBS7mIojvDt1qNOuJewqgom8Fo/ocxC70ow=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZVdT2kMXeyfiA7i0igUW/9EJGi1Z3RNLI9XmN6iEln4fs0zM841c51UGFdCjZq5goDg6qh1R0exorW3pa3sCsjj8uQrQzBHpHtqKGNNV3l21xsRH+ugXjxyZM8epGjiucDIMjGGHwDITuIRZL4sPSd/5wCbHg3Uk+/ySomDnXxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MzA+9qEr; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711678283; x=1743214283;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZVtUqmHtTBS7mIojvDt1qNOuJewqgom8Fo/ocxC70ow=;
  b=MzA+9qErnNHNI/A1uoy72HfHQWgeVuI761qsEfA9MSsMplGzSDD4CX/y
   NFppu63lHypm+FeBTOvFxLYB5RRqqq4pJZylBEF8I1WeC21y2MTSRUIBB
   IO7vzLY0eV8qruVG1u9FZcu9vQHtj4n3/4ud3NfNfaeQHn5OadYnW3zBV
   auIMFBY2DzkSmqDkdIKhnRfFeBQAIHLmSrG+yiICrEfF+WfWiF5/bQ9oc
   /UjCRWxZE5xvnNiB8NrH6FEAdG4zjBNraSqHqEmQtFnM29qw25vjkosUK
   iCUY98OeOTFXSlozdhgd0k+d0zGb67UG23QDzHNwck30usKqIcGcN+VPm
   w==;
X-CSE-ConnectionGUID: IiVcxlQ4SeKqo5g2k/+R3w==
X-CSE-MsgGUID: WSyIyFeJTEKCaJXvWNWPaw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6729079"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6729079"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 19:11:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="48040985"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 19:11:22 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 19:11:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 19:11:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 19:11:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3AdKuzkjQqcAx3bKkgaACuCFnIbQ+mKV6lYHTUA+6eOwS6gZzYtUe2Ixql8c1aC5iVEsAvPtaGuDAd09ItPhUSjROPFyFkwQtVSwaGnZ2KXqDQgTqdh0nI3PJyjhlaFkB12mH9zKfek4XF7BWMJO3JLgDnTdbPENXgEVJqJXuyosxzkr92p5oLdKmSrW29iO6iaezX9yO1moZlxa3Wsdsm9CZSolI/4f9yC4OnAZtypMl1JDV5WV+Ga3LVkCgX56OqVIdaIAAd60kWBwSK6bNplsz7t6AEAF7SIdU5bzcbBKinO2aCtljcUlryr42sSxbzdxBX96qJs/TLq/EyOPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHhr/CAo34Ad22ptyR/VI/94H4B32DO5TIwpqCfK2RU=;
 b=g+buutZsLphEEmL2zTe08YU/XHXkZ+8WMz8vKbRYqdeVR/LrmZ7Npxfkzm0BbC/hi+LERJEhalkfpp0sC3eEfLTFEI2r/TfxfXsBIG5vc06sZw1H9vCSWXit/JIJZrA98zMiifXb9D9Op4O1E9xRBOWtBxnaknzWl/eySA2p0ffVnSxuMmvSh25cQtnFbMgA8oJ87I2fO5oV1jifz7SNVA+5whplCBRPdz5eA5Eefsz5R2qM34ajMoWKdTMqRjKeBhO6tOfrR6GuWlrIEz164FDIMfrRMSulod+cRP0De9wwjLSoYLJYfMNn3jXLw2XbflPp1vN0Y0HjwBAnsl0c+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4611.namprd11.prod.outlook.com (2603:10b6:5:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 Mar
 2024 02:11:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 02:11:14 +0000
Date: Fri, 29 Mar 2024 10:11:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 094/130] KVM: TDX: Implement methods to inject NMI
Message-ID: <ZgYjOfkH2p/fSXuw@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a7ce6023eb8dd824e61023a95475629bd7ae2278.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a7ce6023eb8dd824e61023a95475629bd7ae2278.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR06CA0188.apcprd06.prod.outlook.com (2603:1096:4:1::20)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4611:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x9UVJtFh/UFkZz3M4Yubj3hsc8v77Z60Umu0TRPNQU0GJgWIdAnfsKio4G72x/k0wdamjXaw3qbJjNZxVB5cD5RXjU+RDlC8jGqQShW8bdvgBH+dtxUE92HSob+9xk3FApmBqLnvyrqDgWcVP+F43WRu6UGJvRyoQlUMXuxvktYYN05vgnVOtEUEOQ8IPJzBNorosr5G+IwMsnyeRK5B1x0y0y6Wfps0OzjjHH8PY6ziSfsDxFFY6uvpC6o7PkLk1V1B/PK88G97VkowGSO+FGvwFh65tziFp8+LHBj09/HrRVEUMIgQS3PUI+GlBDZPDE2co6OUbFD1kdK4Wl2whRYVTV8vhoaIQz+ru/Fa+DyKsnJ7pVsJ9zYDY5QKOXoZH4QPTAFU6vSycPmdZopaaP1xzN/+3rdVOLVtruKLmb128Zeu7q94u4k7MJBlsy8LO0N+4cP+FmaNtv3LGCl4UDohnYZb8nRQjtJJB63H8/4BNwWyV1793ZhBJVuDZctSPLT55cR2ZTBrHdi77Wsdwjk5n2rzFvILilvDTCWhdKTuOJzRUQ3op2JasTq95o9tcuXakXGLkoD+UauVKtesPGIkqm9KjBMcJRQLNbppCnur/4+/CKkfaRtgk4fcUe5dlaj5hYhN+2yyAgKpZQ7OCbsOrUisYkDUNHqwqn2VOoo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7wtXrSdoS+FONpdjGZRII8Ba8B36bbV376L5gEZgA2hvZTJvrVRcZ1xL2vFM?=
 =?us-ascii?Q?NBHn7yGNLyY+Jtl5Ft6t0oRTCCuoqF34q0PM2c3VQA9RcwGpWGt611LTGen8?=
 =?us-ascii?Q?uacIFNApodf+P/coec1rpGGW5OGuc+AcjMLTbKDJSF3aV/lF8L6FcD2uqy5G?=
 =?us-ascii?Q?VvD7+wXSlVck2F7l2Ws54f58aShKS5hAl2B2+FeBP9+pLCV/fooGXEBTDIjQ?=
 =?us-ascii?Q?PMTQOFcvZzq+EGx8qcPuoa/W705eWdbdvDyGBjxxd/UuaEyYHzvXGHcM2pqG?=
 =?us-ascii?Q?tE6TCNAR9tqSyzaXoYmMqG+/E+A4zZNzVMDMmavsJG0oXVhJAHwCWdZzesOE?=
 =?us-ascii?Q?CLRvAO47x5WX/Vdoe7VAbKYhr5fkw+ioHt9DVW/fLAc1EURP6rvsgQ4jltRU?=
 =?us-ascii?Q?BG2z1PNzAZ2MDEcTiCMXgMvygSlLBxnq6Yy61uEiuD3KxqWMz80kg2cNCWAN?=
 =?us-ascii?Q?9V5q64RxyH1JBuiWHcS6C5upDoBftg0VJc+qmCsfvgcjxmcgKdg87s0nedkX?=
 =?us-ascii?Q?rpBW+lZIVZdGJAj4oo8msjv/fIeqm65dZZYc+VCpS3zT1lT0075mIJh+2fMJ?=
 =?us-ascii?Q?yTHtSgA0qQmigngamCYiLX59+UtlvQvyCnGhmIYosfywY/ZfLKZ/cUGnsJsB?=
 =?us-ascii?Q?hJdNIGZw+/4DXCArCDgxNOiFO3CckEzhHKhcUh2UuJCOOZwl5+hrf+KS4P1J?=
 =?us-ascii?Q?IlFflz5V6y3CoJL/Ua/+7sPE373V+Dfixtl8L9VUlgJdCEzFmTwSxemBb1ss?=
 =?us-ascii?Q?OudKPJq60uKkjFR6hAcGF/lIKySGqyc99C2YuEkTfXoKyHs1TX2bNv49yFfK?=
 =?us-ascii?Q?BC+2+3fej+H9hkrp+3ZLAAFPr/nGKxObLpvPIJpiPxd+12KrxTq5SW7uRzlr?=
 =?us-ascii?Q?fXk02QTD9M33AtbnL6h0/mcCuI8duvhhSCQmmjRmOakOShBYt9gE8LLTys4M?=
 =?us-ascii?Q?80Ha3BEZitNwNYeU8X6kxbFoXl45c1rW88T0ShBERQWC7eLoZkhqoHYQZ01M?=
 =?us-ascii?Q?pu9UjWZpYHrui+XbTMI01Ox1gZ+qTJQmUmswKeCDad98Tpe+BCdzGUN5CCsG?=
 =?us-ascii?Q?razhx2IEhlMp99R84gVMHuqY8RRdiIMHocn+y9UMxlk2c42EZ059ntmD8gw5?=
 =?us-ascii?Q?zMQucwwD4BCkbqJZuuyNvFrdXzmI1X3VoSV9MOLUrxzrafrPsX7Gzz4bFaYX?=
 =?us-ascii?Q?RLxW1q1Gwvyg2l6aBAD5Ao5+UINfA0obkH3SO0Ky+oCnZ+6dFGUz4nJhcIgT?=
 =?us-ascii?Q?VfXbKMluOGdl9OQnsIvPTvuu48hNEcR29/8jhwZfIY8ZNWk8mdnpgBVKDP2N?=
 =?us-ascii?Q?YwpKO4Lm+hEGYsdxRNbIPHOXwA+e7alEy+FnTn1D7XoNuD5REBhljF3SwLpF?=
 =?us-ascii?Q?eTD0JUcNWFBuN2bcHJpHgcamWNv1xSNjPaSseZ8ByHHmflpvioy8TDuvv4mL?=
 =?us-ascii?Q?iiqMMVHIfcdOEynXY8qfXNoe/4mBLyOtAZ8R+f7afaNiOc8TAP73kLgx6FjR?=
 =?us-ascii?Q?iVsnCCJRq2FhXB5OM1f+HQEIi4OVrF2r/UIojb0Qu3YihotwtFR0O+YPb2Fq?=
 =?us-ascii?Q?H+3TZJ7Z6Rikp8Zosu+u8RjUNmV+xamzX+g3TdAz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e66841-5eb6-4ab6-b4ef-08dc4f9582f0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 02:11:14.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JbG0YPM5cJPMVvf6ilys3aBvfSCn7ZjZlnxwGtgYiu+lq2KDJyaaZ2t1cntoFBqNNXq69DXReXxKdOKgA9MaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4611
X-OriginatorOrg: intel.com

>+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>+{
>+	if (is_td_vcpu(vcpu))
>+		return;
>+
>+	vmx_set_nmi_mask(vcpu, masked);
>+}
>+
>+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
>+{
>+	/* Refer the comment in vt_get_nmi_mask(). */
>+	if (is_td_vcpu(vcpu))
>+		return;
>+
>+	vmx_enable_nmi_window(vcpu);
>+}

The two actually request something to do done for the TD. But we make them nop
as TDX module doesn't support VMM to configure nmi mask and nmi window. Do you
think they are worth a WARN_ON_ONCE()? or adding WARN_ON_ONCE() requires a lot
of code factoring in KVM's NMI injection logics?

