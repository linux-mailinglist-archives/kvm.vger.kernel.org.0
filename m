Return-Path: <kvm+bounces-58049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3DDB871D4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E46803B6554
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 21:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50652F9DAE;
	Thu, 18 Sep 2025 21:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gdQ/WlwV"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481DC2F7463;
	Thu, 18 Sep 2025 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758230623; cv=fail; b=jqNkGjVZN9HhMMdCFkA32SDTvNLSjgy1dGRGaZxmDmraXJD3itJUvO8UHY5iMsnmWF6TpgOvnSDT9vTH7ij8Tr/u7AdEfZ0Z/6J2NDE+L1S8H/8osRq6TxuNnv4+Hhlxzp8nq+xAwNuWJpM/OOO8EYt5oaYWoIN3Vje/Tbqnoic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758230623; c=relaxed/simple;
	bh=UcQBeAViy1fEd2eYuSrZOKAhLAR4CwObhvBRvSBlH7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XNb3F15Qa7anDHVZRwuM4/ScImDQQcLc8fwdLaPi8PX75KdM1JvBdsouCldGx4PCGvn+ZSf4XT6FTcnUvwSKwfHmb/FsaTzgI++3aK1rfkLULa10SFVj9GERSL3Qi1fLRL5JWpwhcgLHGWS3MKHLA1gWZ8rjbKLBtCHOJqDePIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gdQ/WlwV; arc=fail smtp.client-ip=52.101.62.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8y6O7lEBFAhEHTTwU9bAmO2RH+gRsS+LkTJzL+xZrbYtxHUd3dRFula3eIDyXCCPG8aDWrQliy5f3UZoHYcLU5P5/oy/gUK3g32cvvfJY0EIiZ748zIu+QSJytYhQin6tg1JoN7dQZVC3wyvRoqjsXmmDQooyaacPz84ecPfYKGILfF6Hs6Pcg8RisgVbboT8159iwkBOTmp5fJ3E+vbFWQNBUUMHVxV5XmF70lm9sUKob+aWq3mfhKWIMcnT2I7bQPBYvKFX9VrRP57OyD3OwVpprjs07dnba7wdq2wLITd4Xj/+SO9DrJadxtz25fEGZCL5z7ca9s9VdzHa2+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e44kzZjkoAnm6XDjmByCC+2Sr9OAS92mIFsjAe5cWbE=;
 b=ae+ns+s8HJUFtghHFoj0uEj0QPUjZjr+t0rpulEhYsgrHrr7G0SEYL5UbVNBbYYqn9DiDa5LxjDaVAypSsOO1LtDW47DSL+U7l9LKyJ3QtHOHP1DB+EBkPWz6V+EOlx4Ktaun+Anr2csZJf/8ePXeAGxrLouSG8v3ogobSJr9G6D7YVKCzEgx/gaYDT3KnpFZiAvKw4gziIobOz/CZHiJB6UkY4JNUPOSfz8FAxQ8LbptVUBQhspoZnzFqykeXpmUtLFjCedcs66yYhwAXvvd8RWqlVj8svcGPEZpE+il5momD8GUlkwlX/UnsZ2BeExAXX0NvobT8a7SG6s29YzeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e44kzZjkoAnm6XDjmByCC+2Sr9OAS92mIFsjAe5cWbE=;
 b=gdQ/WlwVUvfqjm948Dmd68h9tOn00LlXcqWOPBvvXdZKiyC1qk9BUpViOrkL5oNrztczwq8nIs3HbOXr6REBIXWmFgJJP0/fvepu7E8+7rnBse7VGoyogK3hxavtwFQuZ2+vnrNU225LE0OVkmSk1UyzFaAalPc37rEKK0eQzjE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS0PR12MB8367.namprd12.prod.outlook.com (2603:10b6:8:fd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 21:23:38 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 21:23:37 +0000
Date: Thu, 18 Sep 2025 16:23:27 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
 <aMnAVtWhxQipw9Er@google.com>
 <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
 <aMnY7NqhhnMYqu7m@google.com>
 <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
 <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMxvHbhsRn40x-4g@google.com>
X-ClientProxiedBy: BY5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::26) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS0PR12MB8367:EE_
X-MS-Office365-Filtering-Correlation-Id: 28529ffa-f679-4561-81c4-08ddf6f9a12d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fct38E3k30d1uQsS8gh/ogaVD5P1MVphXhmcWUvDBa2/aRNM5m6ASSBw8R56?=
 =?us-ascii?Q?Y1AoyVkF+jHfnXRI4+fNqfwOGsUMiQLWTOuzzRNu6JT5zchkr92gpXwHau0R?=
 =?us-ascii?Q?ywxhNs/nPKH6R7VKiEmE2EPndE1FeIeWPoFsFrEw4sM6oE59WeMmGUx7GEO9?=
 =?us-ascii?Q?gdpN9V30ItV+x81eFs7HmwlNnu2YB6dnAYCS3QFtBU0vGCN5YPG3yNpTYdHS?=
 =?us-ascii?Q?jo8hECHCNrix5s+afkEY7o0aRaJJUDsnuAfPo/BVGi53tTnWzsbhqwihF8hs?=
 =?us-ascii?Q?8+k9qtalGnbyXHeOIUjagA6NBZajp5qrda6p2SPc9dd0092D9bhIGD9LN8xr?=
 =?us-ascii?Q?DWuHCIfba/O69FsXIgMvX6IUdhpqpDPmGjh1j6jelckG1dgoC2x5DbTOUcNr?=
 =?us-ascii?Q?lnLBL2Os2jcdRV4qZDmS9kNdxb4WrNJtv4oFphSXWbvjaLNl1/Y7zOcBrfOo?=
 =?us-ascii?Q?8CdFRaw3l4bWAdP2R95q0NPdnMZ5GLBm9UUH2er0Kk11jbKGFh6zBLQ6re9A?=
 =?us-ascii?Q?jdnj2gyRmyEnRTztL1NChVqi4zXFsoThCQZqSsJPUKJXqo4fhW092bi4s0I8?=
 =?us-ascii?Q?meImyUF5siE+HP840/hzjQ2TfBcjY3HILeP30PhPddRISiYQeYdVjtX8cgOg?=
 =?us-ascii?Q?YW7aVWUCM1bYmJGCC8Q4y48VcizA7uN2eiPoY01OTPV3NcrBF4Qv8MACAvI/?=
 =?us-ascii?Q?sP3F2o0OQm26HkQeDeWmKab4e9/WfdS/cHWOJc3g6vmToH11dv8CzSCRYvSI?=
 =?us-ascii?Q?UTY/H1g60Z6UV4k2sCr0JYlDvp3tW5VucS2OIvC3Zmd+M0ok1nZ2gaN38sxG?=
 =?us-ascii?Q?CQTzgQH0Gjvw6/0m/oj6V9558P8YVxMa42kJ8HVqckWmG2EXaoH8ZKHZA8mQ?=
 =?us-ascii?Q?Kh7tKaexnUDYjTtHAXWNyTQuCFBkP9q/8Vw2Wx3oXood06KwydKtqFtw1fKe?=
 =?us-ascii?Q?+RcupAfRObu14GHsFgsMIBF6Feym5ua5s6uQ1J+WcV+MZ9/850K/hYpbfjEq?=
 =?us-ascii?Q?2JNz4EhSkJxO0PeRRymfVOnVdM7CvR1Wsncx5LxhPyE18eXWHDTDSLO609RI?=
 =?us-ascii?Q?noDpzOnVIIkWcy7gT8v899ZAFb4aQydfXEiAwz6nAk6vvcGw2IL62tjje/ix?=
 =?us-ascii?Q?jchTcTTD6NeKZs7xd1G1GecpGZIti2dnuR2HpqMCxmbyMcwoGnQwx+wigytY?=
 =?us-ascii?Q?ZMRDQfuOjYpkMPSNTDJMeKhP+marO3cJGS8wX1X9MiY7ZR+ZCCeEB2554wJ6?=
 =?us-ascii?Q?Lpuv+vgt8H05s4FQXvny/jgFjzbJCIFlNG+iGM4gIwRoEaE7o60le9fVKlPq?=
 =?us-ascii?Q?iE0ZsmJgV3nUZZXnyxNzuvaTpFAxM3aUkwQK/2ZxVIh868gXHlOiErDOBDgD?=
 =?us-ascii?Q?KGYln/WwQn5Yd6KG3V70DyTQssVLIEWP5mHuHWsAHrgNpWgQT+8qi2hTVAcO?=
 =?us-ascii?Q?GjPxBP6UtqU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eW6m4QyaBKpKJMPG7d8Sw0bOW/8fICD7AGhhRSnPHroKVvaqBjVBSterSi3e?=
 =?us-ascii?Q?Mc/vrQXRHJqCPJB+OJ/p6hhX9LDUyXtzQZ896+RXc5fJCxJsIv4R4NAEO0P6?=
 =?us-ascii?Q?jgC0rjr2F73B5O2SOrCarmteiWJKUzKXgUEpuH6FspKLloGw5iwHpxiV0mf/?=
 =?us-ascii?Q?umF3wh2JPZKYyAdV4m27baLQu+H+x7mlvQ+tC+ddbytnrO2fql9wGQP3Vpjy?=
 =?us-ascii?Q?CdTu7iPUmHesZelpCud890sLfDyPrR1ch5yhs3qqZaRNNCl/mJs01S4CkBDH?=
 =?us-ascii?Q?GsteoIrrsLQ036RrgqZM8UZwEmcshEEYxOCHAMm9zaAJIs6g4FkBh10/870k?=
 =?us-ascii?Q?2VYjkhGeucovZcYgJdfTEcEcSYGjpcaQhk2cr96JpBTZnNoyknXdlN0DsynG?=
 =?us-ascii?Q?2jPxwRdVJwwJX/sllqLb+BKFGS/f202ntLSC00FKwNFcgUa+exNxDM3/WULX?=
 =?us-ascii?Q?a8jSzaVuK+v0PfGleSmUnbFq7CE1JFP2OE8xFXbz8lsywDxW9C2RB+bHLUwV?=
 =?us-ascii?Q?aUIklIjP/7pctd5vuyWPlTYG80BT1w7S3+fr5MUXnWypyvmB/fI+brntaGYI?=
 =?us-ascii?Q?IaSGCBaPnJ9szDKX8al/CiDf6X33XlFImn3D6IX1cr/0rty3g1oayQoO+dsk?=
 =?us-ascii?Q?aKnkCkCqwgVnXkRWVejL6/73hVJnSSRXtGmWJ/oAhfg0LEOKo3XZ2Mw/IgkL?=
 =?us-ascii?Q?PQwNX/25UohecXeTn1MKrpsxzMSISt6JuvbXf/3b6GCB3HSza9ARcTMGxoDl?=
 =?us-ascii?Q?a1fSvsiF7Cm/CRGOIVM4cyjP0F9zm9QvK7v45HYy0X8n2xSnfLQDbK8cJSTz?=
 =?us-ascii?Q?CRmTTymcK6VcGA969OYJzy0ACNp38LX1F0qQLMkGuA4ZvZ2EJCc58XYuRhLe?=
 =?us-ascii?Q?MgEISZFU1n3s/26q2SXJXt/3/R8AP2LCJ4MJ7I90cpeQjancbngXhqpaRqPx?=
 =?us-ascii?Q?yQzxlfCXBqZ4Z6yN9b9mW4isobhAUMMOmA8uimya8inPuWcz3XzSD0Xi7JY2?=
 =?us-ascii?Q?wN+NKSvT1JRfbyOACUQ5eBTYHOPb/BdYOrAtObEXZuIb9AsRuhfKAvjgipc4?=
 =?us-ascii?Q?tiv5xWri66dtzlToKMsA2NFRL4GJO2U5kMU3Z0fFFoJgKM8/J9AlCPpeKMnw?=
 =?us-ascii?Q?sV3lvBQU3o4BHr/xXFPI9ipTtZPteiV44WXFphAyfDeNvGLmHxTBIaOFa1AH?=
 =?us-ascii?Q?U5bV7LGgK+wIofIq05jnQ/42qOCT5nuzCbL9YiBf4YpwaaMoqxErHevBG45N?=
 =?us-ascii?Q?ezS54ZM7Y/4BNK7pekSWBhl/QXPrBxzcNJVR5L2rDvEEvNL+jAKqv2ueTAhZ?=
 =?us-ascii?Q?FfPCZaZPKr8eVJqWxI9l6E/E6FMJQ1TSoABPjLUHEtaSguq4zciRHkl16USn?=
 =?us-ascii?Q?3mEFxg6DUQIID0BmuxBCgUX5tOgJSpOZqiqfV4LWcO4YK5WdIaDJaqac2Blu?=
 =?us-ascii?Q?yqDBpRO0yTIeO7DvqphOGYU9edhWHs9CbeRHIH0IK+UbvGgb4ParBEz2uU7x?=
 =?us-ascii?Q?IzKY/nMlcAViotcSu/CLzxLFdpmxVEPQmYEj5pNmrf3RtsPBMybKTbUivat1?=
 =?us-ascii?Q?izZDGidksUb6pwE8oUhxgFeulYq87gnTmo8aw2Qg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28529ffa-f679-4561-81c4-08ddf6f9a12d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 21:23:37.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1VvN2/H18FZZS8fQWfUXsWy+eN1WZyHnVhFDtK0vHm+ytWC/6/haH7wKOkM4HnkPoYf5joFfBOdEW4u9th5fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8367

On Thu, Sep 18, 2025 at 01:44:13PM -0700, Sean Christopherson wrote:
> On Thu, Sep 18, 2025, Sean Christopherson wrote:
> > On Thu, Sep 18, 2025, John Allen wrote:
> > > On Tue, Sep 16, 2025 at 05:55:33PM -0500, John Allen wrote:
> > > > Interesting, I see "Guest CPUID doesn't have XSAVES" times the number of
> > > > cpus followed by "XSS already set to val = 0, eliding updates" times the
> > > > number of cpus. This is with host tracing only. I can try with guest
> > > > tracing too in the morning.
> > > 
> > > Ok, I think I see the problem. The cases above where we were seeing the
> > > added print statements from kvm_set_msr_common were not situations where
> > > we were going through the __kvm_emulate_msr_write via
> > > sev_es_sync_from_ghcb. When we call __kvm_emulate_msr_write from this
> > > context, we never end up getting to kvm_set_msr_common because we hit
> > > the following statement at the top of svm_set_msr:
> > > 
> > > if (sev_es_prevent_msr_access(vcpu, msr))
> > > 	return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
> > 
> > Gah, I was looking for something like that but couldn't find it, obviously.
> > 
> > > So I'm not sure if this would force using the original method of
> > > directly setting arch.ia32_xss or if there's some additional handling
> > > here that we need in this scenario to allow the msr access.
> > 
> > Does this fix things?  If so, I'll slot in a patch to extract setting XSS to
> > the helper, and then this patch can use that API.  I like the symmetry between
> > __kvm_set_xcr() and __kvm_set_xss(), and I especially like not doing a generic
> > end-around on svm_set_msr() by calling kvm_set_msr_common() directly.
> 
> Scratch that, KVM supports intra-host (and inter-host?) migration of SEV-ES
> guests and so needs to allow the host to save/restore XSS, otherwise a guest
> that *knows* its XSS hasn't change could get stale/bad CPUID emulation if the
> guest doesn't provide XSS in the GHCB on every exit.
> 
> So while seemingly hacky, I'm pretty sure the right solution is actually:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cabe1950b160..d48bf20c865b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2721,8 +2721,8 @@ static int svm_get_feature_msr(u32 msr, u64 *data)
>  static bool sev_es_prevent_msr_access(struct kvm_vcpu *vcpu,
>                                       struct msr_data *msr_info)
>  {
> -       return sev_es_guest(vcpu->kvm) &&
> -              vcpu->arch.guest_state_protected &&
> +       return sev_es_guest(vcpu->kvm) && vcpu->arch.guest_state_protected &&
> +              msr_info->index != MSR_IA32_XSS &&
>                !msr_write_intercepted(vcpu, msr_info->index);
>  }

Yes, it looks like this fixes the regression. Thanks!

The 32bit selftest still doesn't work properly with sev-es, but that was
a problem with the previous version too. I suspect there's some
incompatibility between sev-es and the test, but I haven't been able to
get a good answer on why that might be.

Thanks,
John

>  
> Side topic, checking msr_write_intercepted() is likely wrong.  It's a bad
> heuristic for "managed in the VMSA".  MSRs that _KVM_ loads into hardware and
> context switches should still be accessible.  I haven't looked to see if this is
> a problem in practice.
> 
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 945f7da60107..ace9f321d2c9 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2213,6 +2213,7 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
> >  void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
> >  int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
> >  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
> > +int __kvm_set_xss(struct kvm_vcpu *vcpu, u64 xss);
> >  
> >  int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
> >  int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 94d9acc94c9a..462aebc54135 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3355,7 +3355,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> >                 __kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(svm));
> >  
> >         if (kvm_ghcb_xss_is_valid(svm))
> > -               __kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(svm));
> > +               __kvm_set_xss(vcpu, kvm_ghcb_get_xss(svm));
> >  
> >         /* Copy the GHCB exit information into the VMCB fields */
> >         exit_code = kvm_ghcb_get_sw_exit_code(svm);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5bbc187ab428..9b81e92a8de5 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1313,6 +1313,22 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
> >  }
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_emulate_xsetbv);
> >  
> > +int __kvm_set_xss(struct kvm_vcpu *vcpu, u64 xss)
> > +{
> > +       if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> > +               return KVM_MSR_RET_UNSUPPORTED;
> > +
> > +       if (xss & ~vcpu->arch.guest_supported_xss)
> > +               return 1;
> > +       if (vcpu->arch.ia32_xss == xss)
> > +               return 0;
> > +
> > +       vcpu->arch.ia32_xss = xss;
> > +       vcpu->arch.cpuid_dynamic_bits_dirty = true;
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__kvm_set_xss);
> > +
> >  static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> >         return __kvm_is_valid_cr4(vcpu, cr4) &&
> > @@ -4119,16 +4135,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                 }
> >                 break;
> >         case MSR_IA32_XSS:
> > -               if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> > -                       return KVM_MSR_RET_UNSUPPORTED;
> > -
> > -               if (data & ~vcpu->arch.guest_supported_xss)
> > -                       return 1;
> > -               if (vcpu->arch.ia32_xss == data)
> > -                       break;
> > -               vcpu->arch.ia32_xss = data;
> > -               vcpu->arch.cpuid_dynamic_bits_dirty = true;
> > -               break;
> > +               return __kvm_set_xss(vcpu, data);
> >         case MSR_SMI_COUNT:
> >                 if (!msr_info->host_initiated)
> >                         return 1;

