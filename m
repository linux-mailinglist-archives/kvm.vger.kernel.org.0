Return-Path: <kvm+bounces-13824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A6289AE58
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58069B22C0B
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17243D64;
	Sun,  7 Apr 2024 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dDnBOsKI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C36E17C9;
	Sun,  7 Apr 2024 03:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712461821; cv=fail; b=Bm7ONNQex0lXlL0+36hZmS7ksciucxA4KrW1gsNb+en5rVVSCo8SwsZYYSpVSU9J2pG0AYh+6eo/6AVLtzlnTSON6cKwkPiw5/txEwoeyckFo1NIazELF5OgKnu37/YhGuOF1e0RZaW6NpSythlz4tcOhzEZJwLVtDsu0tl8SP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712461821; c=relaxed/simple;
	bh=tglvvFOUAC5SAkrJ98EblkvfqcmiP1TWws1+z5/gRCU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I/vejTav9reVf/I9r5MKLKMEi9W4nvWX1Em3zsKKOLWHlzvdyNN8w7R7a8Fyjk8zbxugDM0pFKaqgvK3UO1bff0o3kRKfH5pEptuhcUHF5c/j4lUm/oweibMOwfAgX82WWN+Hhqn0aigVMiCoS0vawujltIn2XNZOC+zk2cLdQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dDnBOsKI; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712461818; x=1743997818;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tglvvFOUAC5SAkrJ98EblkvfqcmiP1TWws1+z5/gRCU=;
  b=dDnBOsKISlcgVcQFa7SDdw2v+NZsmtTuHiew18Btyh5Lty/gJBp+kwnh
   81H6Te3AZ4DIgRLDIpchN5jxnBQE21+8j33GDE222qQhlz2xVlW3O1R9a
   ObxmlxUlPpcxqJJr0u2The3jOz2UAFJ4M1NXHbE/j5pu0eaPvGeuUJlr+
   8pXo6nkDqWHo744xnYsMcNQQ6iGts4HQJFABleQIRZ0H1JABUiwOTimVK
   t8cz8L9XoHdPit8wCpU1V7tO5TXxrKxvbCLwrbOnU14v7D3z1faW7cI7I
   HkwQqzA8NKi3NwAIuojz5CXNb+/+a2F6fzExv2WSEwbPv7lD7RplyfPAr
   g==;
X-CSE-ConnectionGUID: IkH3dyc9QQumw6pcG+9suw==
X-CSE-MsgGUID: dcdAsexzRWyqXUUaYDPdYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="18327895"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="18327895"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:50:18 -0700
X-CSE-ConnectionGUID: Qpnl6Z+NQLWyd8dyYPtZNQ==
X-CSE-MsgGUID: xHuoxtWVRruo1KJ/IP5E+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="19459929"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Apr 2024 20:50:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 6 Apr 2024 20:50:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 6 Apr 2024 20:50:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 6 Apr 2024 20:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfeYYlSN6nAFcNNcJZogwBaNq4GI/lXzL+R7ojuNvH0vMk86wyUFpjhkP5BXZgmuff57OMfyHKfmvYLt7MfCFOb9n8r6rhIPRwxOGUJtGduCX1qD86x8Z6RD/1drZpJtRyDmkkZCVQJdOsi8325U/2I+H+P3pB1TFnG7HdTS93n16XHcFgCYZR5YTWRJePhKw1k3ozX/ks+RDGwlYDfVCfAfWAbcKwYNMgRUyGPZ1e+2kpFQvir6xnxswSvtCln4Wo/oHPtKv3kki3zNj5RMkfx/f/cTBuzJhM+zDDO3QcXlQ/Gx7gfnVDRXRa0jVsLFde/Rjd80CF7yLQkP9FPstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ml/uKMTxI4LqJwtfXbv7Ve3KlFIP3qCCI1RxFhPpKhk=;
 b=QIQmF08s8pgW5BErRM99SsflzqonREWiQrH+uffmbpu0rM10goTdPpPilCfb1+6jVRfP55rnrJqnCDXbmK/uAGT+eIBiAyjNFxfq6LYm2P5tnbVolyeQMVyjqXRbdInetoUNeFrmfyTq3e9y+8b7fQM1Gh4UjPAgdMHOGdEszHxxXoH3OB4HytY/Rw5vU9/NF5RSDnidp62eav5e1YUSh3wLpxT5IfA8kX8tTxLZM0Rlk1Aj8JX3WxGh0UEcnSaIKfLFlZQA2caMYRXTPVEgqUAe7efH9SbvwyHNC/U5iL9DN8Oerc5MAA7kCgz64QUNxnYRXjgn+UGWMUul/MO5LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BY1PR11MB7982.namprd11.prod.outlook.com (2603:10b6:a03:530::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7430.46; Sun, 7 Apr
 2024 03:50:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Sun, 7 Apr 2024
 03:50:14 +0000
Date: Sun, 7 Apr 2024 11:50:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>,
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 108/130] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <ZhIX7K0WK+gYtcan@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
 <ZgzMH3944ZaBx8B3@chao-email>
 <Zg1seIaTmM94IyR8@google.com>
 <20240404232537.GV2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240404232537.GV2444378@ls.amr.corp.intel.com>
X-ClientProxiedBy: SGXP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::17)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BY1PR11MB7982:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNQYwnqblxLGWU6mvpnjm0pSTLt7wHpZzNMA0Q46324crc+JaaMMc9eaw7vEMAz4xfczHHVMpKESMgEV72BLvuu0h0wXlmdpuwX4FcjYxr0hAZEQaZgA2vxr7Jae6zLYoHxHSaY5iV7VqnNizbENBA0Ps+4E2Ay3LJVHaV5WBmY5yTIwZj3jea1L2moYvZEJFlMHBxoX0JgnMbevRXJ9fWbbCkTGaL07iJAkNtYobr5zKBa4OyDLaIETH+Fd76NJ0WkIzd7mBADusbK2zqQx9bh8ck6xcVPGrca7PYTC5vKku0aJTxu550G9JoPT4L39b6sFQ+qvm6GoS4VXH72BIgpVB0s3vdh34aRT6qWSlqClTtSYuAGjyCR4QSfrzUK+10yR5Scq8Jt2GITzMP6DrNXSbNJsrWqsQE3bjRiKxmswVb3vqg0TM1NlEOT1h0bcZAgouvwO/7RIl+FzpAg5f6hLld+uJyi8NFbc5qhGYERTr3uMmwW+EdOrJzbvpQqFgfZB/psXMQ1oc8fvyOlXAzr3xuKslrz9ktHI5GXZ/0Oa1ltP1jtp/IuGcHbHGZnNsym8T2lJP/8ToaUR4hViqvxcBqD9mNXQR6xwu6muyvSNucLb5M+ygKkf62QP2CS9zbPqfjRCNkDa501/hJ9OkZIOQpkzYbpTu/qRxCJVhgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LOOiQCvZwJbY4CTEqsOwo8nW6G1dj4FpQ48fNJaEAlVzUZgea5UWFH8cgRjl?=
 =?us-ascii?Q?EflERt+uviHfJL31RXzPPzhFNLIey5Ii/ipg2H4EDfIKef6tY75l24nrhI2j?=
 =?us-ascii?Q?MVNyaSg3nch5CW7nd4nttQSa7SuNpgpCc1UYO/cTAoaPUkQyVSSoAA1pKjIS?=
 =?us-ascii?Q?FeLuaxN+QESx5WMMBoIgRi6QoOmro6+Z0oygW5tFIpmdtRK56hs2oYu9YVUx?=
 =?us-ascii?Q?R5AplsxNtHGnmnbdP9eeWH2T9Of2BkYg2HfNjxw5jeDlw27u8a6qhWKQtCGr?=
 =?us-ascii?Q?akGTmmmVMKVNvL413O5PtDKu8G14Y7t11Gm1GRIEgNxDRwEdiNZQPljrfVFS?=
 =?us-ascii?Q?ozCWuw+tNFMFG6KlN+e1Vhn4IBr35rm1tnxm0tE4lFBDQ1RpcL3oOXFGF3MK?=
 =?us-ascii?Q?/JHJEtzazjEIiBoFxhU6Mv7Irw/kk6Xx5QV9slg1SRQcYJN801is7mprctNk?=
 =?us-ascii?Q?jT5NaJGsEe09hbCVhU2jfZhUs+oFtqnPR6bgGvtGjJMJ71d4gFufJbBJgH6N?=
 =?us-ascii?Q?6rA96r4/E2yB/mNVsb6aUQCpsfWq+IFGoAw72T/goGWvfPgWZ/H27mWKppF7?=
 =?us-ascii?Q?g2djo5/+p9lq2nnNJbJk6a3VcYMNwh0GnubYRL12XUGfcXtFJfJJwHPq6qQK?=
 =?us-ascii?Q?Fs/fgQ1+qOSepgI75jFSRY+zJuwvDmrONgPdJlN/I1+Sdu/nmSEQDro5jnRD?=
 =?us-ascii?Q?j6gpPKnAhSR1/JEbBJjG6Bvot4Cu6tr0Elwm17i1ZV2B9aRDJB0BcWC9jAwu?=
 =?us-ascii?Q?B307GLWEdUCrqmWUeBcADh7kRLD5NZW0r2Hnx1R3IzTlIMqCBK7aSkh8UEt5?=
 =?us-ascii?Q?4agLsg9zSpeSjW+2vXc7RJW5S5CwjSITuBtFJNyGPJVR5nMnrJsLPD1pgVJv?=
 =?us-ascii?Q?t1wSDGoiyv84O9iznxqUrVXtoveiFeuzSkCCgZvI0BZhS3Hscwcz9SEiYXNt?=
 =?us-ascii?Q?1Yn+3c2ZATtm8BBJ06o/Sp7E5BrSMyPsw/HivsnFOooKoYEk653PZHLNCbpS?=
 =?us-ascii?Q?jqdYNa2NJWbQFKJ+S/ibCAsUhH7IgdwU0TEsDvNvBqKBwT5ENoH0zRRXNZa8?=
 =?us-ascii?Q?wleYdjHe+F3MDUgBzJMALRW5KooP2WkDvvn/RpHBEhUgUpT7oIC0XvDQU2U8?=
 =?us-ascii?Q?O8EL0xiTWF5Ma4m2fSdyzEXpSbdk7zfaFzatJKnRxACcTbZd+G/FiKE9Z1kK?=
 =?us-ascii?Q?i4Ucyr9XTffxeHQRUqau35Uu6LvEbjWebZHPrQ5uZk0kqn8nkXSf59MuZBt4?=
 =?us-ascii?Q?+SvNNLBPHY4IqcLbt0VNwNcSARUxJbAsV3IYNiouk393kOcG4JOtKiAWbPoE?=
 =?us-ascii?Q?jqF0q/8VjONGCc4aB/Cw7gFp6+0xMG5GoavPgtDC2jXmCqs6Om+O3TpVHCIE?=
 =?us-ascii?Q?dsSvXH8fvI3jHyhMwz5p8BfjeivD5fUdgoTggJPr2Q+MOcuOKJCFskxriGlC?=
 =?us-ascii?Q?Y8rR2PE2B1b2OjkBrzLXWv53N31qLgrha5jpRVXtcb5g5LN14QH+S0nLmsnh?=
 =?us-ascii?Q?dbJlrBX3MqG3+4Zy5MM7wppsrjVojfVzNgKTnsC1ZjgwSXndFZbYbwjCxXRR?=
 =?us-ascii?Q?B80DmRJmrnaPZxXph9GZSOSu9dW6+tE1kwPVO8VV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56998a8f-c4bb-4c30-8047-08dc56b5d52a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2024 03:50:14.6610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjzuwJfzOh2CXoc5PfA414kG41pqso4ww3atyKSdjvTKNDasOZmXS/seNa+aM3GtBKbv6MV1D095Ugn4GAqoHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7982
X-OriginatorOrg: intel.com

>> > >+	union tdx_vcpu_state_details details;
>> > >+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> > >+
>> > >+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
>> > >+		return true;
>> > 
>> > Question: why mp_state matters here?
>> > >+
>> > >+	if (tdx->interrupt_disabled_hlt)
>> > >+		return false;
>> > 
>> > Shouldn't we move this into vt_interrupt_allowed()? VMX calls the function to
>> > check if interrupt is disabled.
>
>Chao, are you suggesting to implement tdx_interrupt_allowed() as
>"EXIT_REASON_HLT && a0" instead of "return true"?
>I don't think it makes sense because it's rare case and we can't avoid spurious
>wakeup for TDX case.

Yes. KVM differeniates "interrupt allowed" from "has interrupt", e.g.,

static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
...

	if (kvm_arch_interrupt_allowed(vcpu) &&
	    (kvm_cpu_has_interrupt(vcpu) ||
	    kvm_guest_apic_has_interrupt(vcpu)))
		return true;


I think tdx_protected_apic_has_interrupt() mixes them together, which isn't
good.

Probably it is a minor thing; if no one else thinks it is better to move the
"interrupt allowed" check to tdx_interrupt_allowed(), I am also fine with not
doing that.

