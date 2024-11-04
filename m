Return-Path: <kvm+bounces-30433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE239BAAB1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 03:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681E1282719
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 02:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C111632D9;
	Mon,  4 Nov 2024 02:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMLlRqBZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA1E3FC7;
	Mon,  4 Nov 2024 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730685887; cv=fail; b=pAlP+9r8/ipW4OS8LFC4tu81tyqq/0j4tJFfhG9nTKUaHTZMYxoxI19UTjU4VsPM0Tocb/YT78KIxAlFPdUfUnJ+DVBbjL1MZSgc6HW2Qkm2Th/wWZOu1v0mNfi9/cIcCo+W2i3YqUjAM4prKNfQRhyY77i92/lwbWc0Jdpc6BU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730685887; c=relaxed/simple;
	bh=QGHBZtW/7ub9JqEGN9ZNadUAYlNKS8oP6pD1dxFC9zk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cyuBBA1UdQLgteG5JPompPjjh/yfdXg2u1h9VRmZeN6bIozovJXSO8ChkZwWrZMcuxsDDNSjXJsoyFhthJ+E6/RR+S/GDB9/HpoDZdlt10fA7SeQF0dXHvH+S/6Yl8IZUxF8cd1oJ7oiOwJdSOGpOJr+1qHpW1Y2EQcK4qbO2sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IMLlRqBZ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730685886; x=1762221886;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QGHBZtW/7ub9JqEGN9ZNadUAYlNKS8oP6pD1dxFC9zk=;
  b=IMLlRqBZx9m2VMvSB8cfo4JxZgimfaTxZP1EhNM/e3i1d8t+pSfMl+qQ
   W2osnANC7x7Qu0uSVHCwq9MEdzfO6n1C8ztVnbt6skw3+tflO/yw5qQ6d
   1Qqcvy8Dah4AJvyXlNqwT4Ai/3J54c/a2TlgWFpufI+KMjvw6QRv9BT1G
   cVTbwUN2mzH8LGBcYLDkuHYqKecQNPJkRdQBNPwe5PA98Kc1lB+DSTjnX
   ACbjHaTypFAe950tu2q1BbatoD8U2mhSbYtPFz6nHWSSGcOdgMvfGZFyc
   2m2r9+hD4GqZTCtKyIOwQh819s6pPKQOK5FeOwNkHFTZVReGfeunum+Bz
   Q==;
X-CSE-ConnectionGUID: LhHYLu3KRv2zqQ7D6Li7YA==
X-CSE-MsgGUID: rrgh16qXQx6zJ7ybro+a7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="29785832"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="29785832"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 18:04:45 -0800
X-CSE-ConnectionGUID: /4MARb1oQDGmJdkFx1VJvA==
X-CSE-MsgGUID: u1HLu7QdTHuP+86tpf3xqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="88099747"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2024 18:04:45 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 3 Nov 2024 18:04:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 3 Nov 2024 18:04:44 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 3 Nov 2024 18:04:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKtrey7urSWIg1OCZWm8ejHcfOAKMhMX18UgRFoEjaEDmTW6fxNIFXtU9uny0QvPwZm+z8SMTfXGHJx1ZHCyZTwZMMWhezkEx4Z8bGBqPH/Kzawc3DZqBLkXG6sZSNX7Z8r2UI7HcT5m1nU54hK82fjiZpFfA64PuLWOuIkRslZGQPXi0lF7WTCyGquXo8AR5TVqEcJdAvSevCxr4tLUp+y9gw546wG1D0IW/h0EhGAOMESX43ygIxsAd2Mf1h53t9YTMxuyJ2JMRfEtSgFh621hNdbT4EsYeyZ/vuZhjGBEOFsuTQTd5HzhODQPVFIUM1RgwM3TZAxKM4g5CLWQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UF3XOXqLwDtU+CqvZTD4HGNJA6NJs7VPeUgD+r6b4Qo=;
 b=i7o2WpPocwiexi5gSxfVNyiKauX4/WH/AuXfC8XRaesGRBVMt/Xq3JHiwMfFRvoeJqsRyOWJgxLedmDDiwm7mwAHdccwWzhkY6rnivTeMegVeN2xGTmL5qWey8+jknyNlIErHuKUjKOAwdaB+Ys8nj1QukMV4y7O8ogykBfi2xZ3bM2LuxBSOS3h/GuJLFIN+lgFybv8fbi0j6xiVC8i+94TYRbfTInTXJcWxjwlsiP8vW5863imq3u+mznBoKHewrfhGcoTMm6AalBA4D5p5VrhrzkK5tvBpxi+QAZYBLYy8CFSs6ceTBEkCaU/9NtzxdI0IRf2fMOzJy6t/ssKBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 02:04:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 02:04:40 +0000
Date: Mon, 4 Nov 2024 10:03:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <yan.y.zhao@intel.com>,
	<isaku.yamahata@gmail.com>, <kai.huang@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tony.lindgren@linux.intel.com>,
	<xiaoyao.li@intel.com>, <reinette.chatre@intel.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 17/25] KVM: TDX: create/destroy VM structure
Message-ID: <ZygrjxCKM4y3+Z4M@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-18-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241030190039.77971-18-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dae1298-beca-46ab-d29d-08dcfc750ad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?K3pfmBJ7WtwmY/D60ccrpyqEiWpRUNv7pQV6b43hmbcdIU4yz5QVwuSzvMnW?=
 =?us-ascii?Q?EwN6kYcSBrDx99785+ze0Wvvjrw9OgHdxaUChefcyVCKt0yF36CNxHIrB5tr?=
 =?us-ascii?Q?yGNoQrHD05RpUMxC0b6H31N4/jXp3qVQ3cb9biemFHowgQYUxlFO1gFRnlou?=
 =?us-ascii?Q?cTdKxTXTHmja9Vl1vJr4FofA4W5TA0a9t7mDgadgLFIeoSCohUOkUy1F7JeE?=
 =?us-ascii?Q?pCmE3XdUiO0p+Z8Lp0SQV1y9qOuZ8VVCUaEOs1b0Cf8IgeITEpwZQZo/ozwN?=
 =?us-ascii?Q?4S98wZXizfKsYwgsTQFRVRd6tMyIhQTnagkPt2tyQ8dHD/8y8HjZMKcaaMf2?=
 =?us-ascii?Q?9QwNTi/E2rx1z+ooxVTQMwp7QIqa4F6cwfx5tBqiHSLThCM8jhBBdl8S+MIM?=
 =?us-ascii?Q?uqhRiS3R5Tff6QWGzFrN3xKbCIwBWZoIVMN7mfffcN87+jc4i6IxwmWinGuP?=
 =?us-ascii?Q?4NclfhQ+gIw+0ZIxTT9ltn6taEXOHeuc/SJhfeDzCItN/lAJZs++akC/vwaU?=
 =?us-ascii?Q?2TvTuJI0SRQzYrFpdVP0fmKxuKqbNk9Y4hKuJL++cCdCPmRenVxMDORB/wI8?=
 =?us-ascii?Q?qp5tPUhovP3RYTNOupNGUPNxbVu9JXQ1H3P5NYgRrXxfu9Z66GxFcyx+dY2b?=
 =?us-ascii?Q?GYrCIL3RjJuCXXi0sK6w6LND5MSveOtD5KR+VipyGJzmff09ni0EjiQnLOqC?=
 =?us-ascii?Q?iWFohEAUyGcMc/NrWnf4igCvVoWU/FHThGrxkgcD4myK09kQVvZpw2rnDwmb?=
 =?us-ascii?Q?+ABgLD9OeJCgMGw6A93KX0vRYLXPuSY5qGIQjj7HudrbOzMGPC/mVKyF+2aJ?=
 =?us-ascii?Q?rw9HmFfIbd5OSpirrbTj/XmfFHtqeUmWg6tIevnqzEwnUBuOIgGCiT9lCuAa?=
 =?us-ascii?Q?+66UjwqphaKd3XrOLgFnMK//4noh7g0pFBcEM1axMdhDGIZX79vUhns4JlAw?=
 =?us-ascii?Q?AMdBcYGWkAoOHxp1rhgm6ZFs6Y7ORrLRwWpT5lQC/5kudOvv6u/Y3yHBZ9s4?=
 =?us-ascii?Q?80CYUSOeoABRKb0zmGMxEpsrQFt5pHDSLITpglzTEJB92haoXlyP23BUnsfV?=
 =?us-ascii?Q?FRwNez5dFMkFy5fCxxteVabjqi931+zeO+ihT4i66LIzO4S3ujXl7xhJUbww?=
 =?us-ascii?Q?0yOJk1S0j2rUzFHJsHbdBT7vEzs+eVfCxQUy00idgRoUmVUyaPuNeAPnj49d?=
 =?us-ascii?Q?nUEHV8nOMC+znCj6KrI/dVO5J4inO4AmVJW770S8c9dX7wkavZk/227asMB1?=
 =?us-ascii?Q?bwK/Exhq7VAIHl6OF5VgfIBq3KXYwFrEckZkmHgiGgJqr85NX0K4tcjLqnde?=
 =?us-ascii?Q?pEA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IT5PLmMWaxP5do62d8vaI1qr8sLRORebBhXi6bAUaUZAIyiHTIkouFS4cA5s?=
 =?us-ascii?Q?cnZdvIlPwwWjSXzeDP5+aRtXIKSe565kzSxAMsM+G/n0gFECuy2Ue1G5/5pe?=
 =?us-ascii?Q?ZmEJtJsXD/8hb+En/T3srT5mY0wEy+QcEFmQQzD7lUcxAf9OTQ5qQ6STBzmY?=
 =?us-ascii?Q?uu3L7ANX6pQA/mSVTS/F792g8pGrIFgDJEjwTuO3MyW/1+qLFwWco9Jo96Si?=
 =?us-ascii?Q?psMTv/Lu+UClxYjHijLxZv68VJywtPI1tl6iG3kv1RtaORrK9WLdQEwF85Kx?=
 =?us-ascii?Q?XkPOEjzw6IaZgqTQamU7okWN8XSJCyH9BSo/saGk25PdidPM5GjKmX6EbYH5?=
 =?us-ascii?Q?Tl3nPXns8Fwc9Uj+5c2nx0dW5PEm8K8GswhutxiwQ7SsZOUX5tAzFo/vmEpN?=
 =?us-ascii?Q?mT47fkWdKLYnyXBT0bwtFx5LbyeKc4q8GCLfAhCAPDX4ODjbo2pjrRcwnccM?=
 =?us-ascii?Q?K7f+5YT2kp1VvMCtoTeEdBCuhhnDt8eDACtv90Jek+4B4Foxg6jm9MKFe80e?=
 =?us-ascii?Q?hISM5WsrBpsfu3xRcxrmx4tkwVboLcto+30U2RB2ONzOgI4dCdKKLnmN9PxL?=
 =?us-ascii?Q?e2fuu6OHa8VvXudxRnwxSCSPIBwOC4RCEfkLdjwTAbbSPp4CJ33CgE/anwwQ?=
 =?us-ascii?Q?pt1icCodz2kdJrxhBV5REoOOUWsQl/YM33ceXDGP1lZyzLPIIyN97xUIO9Ls?=
 =?us-ascii?Q?IwGpZoTPXiQkceHQr6G9p/W7yqhwabx4ISUNFE7DXyp9CRPvxat7Udq2F7VV?=
 =?us-ascii?Q?kEAAMAxqkJDtA1dKm2FvEQ/6LhgzeqU9tKeRXOOv6tj5pLNU/qlcNQrdzAYr?=
 =?us-ascii?Q?GbnRvfKGaGyNhbwdYEhk/mVZ0rAbcJimBDGas724kRUPK27XazZxUhJ9Uwd3?=
 =?us-ascii?Q?RTJvSocgP4Ghim7twEk7hx57pBeei5XqoSUjwSFlmWVCpBOVzK/9jMAz0XSi?=
 =?us-ascii?Q?RGq4n9VISo0h7OsCTA3kOBqpnW9vzUf1Op5InkhFGkLgzoJYv7F8ENN0dxWi?=
 =?us-ascii?Q?O0Iu59cluMVCMfKwEoyWECxM8AGI4LUQZF/dEEG26/RC3UAH5F6ty+2pSr7W?=
 =?us-ascii?Q?H9t5EYxMohvCoPa9NjsacMuUxELhYq27TryvzPh3nWLpne32srjX+xf+YAHB?=
 =?us-ascii?Q?gj4/6acyBIAMBwBeAKvw+M8X2qcis64cFocHPfxrAtc8OmTSeY7aBKeyj70s?=
 =?us-ascii?Q?DsP3J+FSVh6cuNKG9OF6c5+S2Nsm4q2R3y8rHjd8tCeNb5AmwGNrssud5y5f?=
 =?us-ascii?Q?0gobVWpIpNEfxx7fDJ62pwtW+PE8EvJfLcufjgZLMMg9IeNg1d98lnCu+W3m?=
 =?us-ascii?Q?S+R10lON7s6pOoF9VBfhG0VM3IVg2zpms6MDyO1S66NQTKYcC3LwQfpo81Ii?=
 =?us-ascii?Q?kST1J3JUJ1e3h1uedkYfjrdRTeMojRXgQ+VqqR0GFquhphtBK6nTONqIP3xI?=
 =?us-ascii?Q?5KdiC8+e+leihRAREbGysYV3WhSyCSGAOn8/lvgVhlKkSEcmY0WCE/NQEKaQ?=
 =?us-ascii?Q?JvWdfQz27dAoopq5rABOHJdJ5s41YVW7UQte+nQZS/zdjLI8ML8MtWh8Oz/O?=
 =?us-ascii?Q?4PvJYtBtOu1ILHpPcd3giwYJI2H8UngVA8fcf/9N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dae1298-beca-46ab-d29d-08dcfc750ad3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 02:04:40.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Udn2+a+ibMwVQ1lbR0GeFLlu2sqLIqHmrfhDhXOBF6kF5OJMowgR3+8p1/K4pUN2MDPbKuJfbnVnIJSmxpeuLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
X-OriginatorOrg: intel.com

>+static int __tdx_td_init(struct kvm *kvm)
>+{
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>+	cpumask_var_t packages;
>+	unsigned long *tdcs_pa = NULL;
>+	unsigned long tdr_pa = 0;
>+	unsigned long va;
>+	int ret, i;
>+	u64 err;
>+
>+	ret = tdx_guest_keyid_alloc();
>+	if (ret < 0)
>+		return ret;
>+	kvm_tdx->hkid = ret;
>+
>+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
>+	if (!va)
>+		goto free_hkid;

@ret should be set to -ENOMEM before goto. otherwise, the error code would be
the guest HKID.

>+	tdr_pa = __pa(va);
>+
>+	kvm_tdx->nr_tdcs_pages = tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
>+	tdcs_pa = kcalloc(kvm_tdx->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
>+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>+	if (!tdcs_pa)
>+		goto free_tdr;

ditto

>+
>+	for (i = 0; i < kvm_tdx->nr_tdcs_pages; i++) {
>+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
>+		if (!va)
>+			goto free_tdcs;

ditto

>+		tdcs_pa[i] = __pa(va);
>+	}
>+
>+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
>+		ret = -ENOMEM;

maybe just hoist this line before allocating tdr.

>+		goto free_tdcs;
>+	}

