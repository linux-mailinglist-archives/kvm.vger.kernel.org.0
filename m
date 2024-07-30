Return-Path: <kvm+bounces-22708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E12942197
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:29:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DD371C20DC9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A2018DF6B;
	Tue, 30 Jul 2024 20:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ta1ayV73"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42BF1662F4;
	Tue, 30 Jul 2024 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371329; cv=fail; b=LXJ2nAfTw55HLl1UPFcR2Mb7VvqM5FzR0GOxdqpReW2pNCc/WxW5kqB+he3T3/oYPrDezxlj0DpcFeYWmLRKAY4vNF036NrKU3aD6f8zop0wZ5SuOV7rMhP2TH6IsIULOENhhsXmbjI3YJOc0Z7VvGxroz8SJmtZPR37Fl6nHF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371329; c=relaxed/simple;
	bh=gq+QOOXisRL+JyrZHplcSQGeEk603uTcgaIBdRwzChM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BZzMJ5oj7iCXtTaB/z6gMx7iQvlHS5sxRgNvhGE4tUH8NlJul2y8tjvLqdH46Uq+9Jb+2/r5VarB7tYSFcBK5vChY3xNuiOpqHQrc/yG8BPLo/B7n1nds/iltNa/xszDPq5DNv8Zx/ZePrrtrbKal4aJ+MAuInvYYu7mblnSr54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ta1ayV73; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=En9vM+tArHoRfeEkNYJmJO4A5XngRcVyhPb/WJt7vbLcc9RVm0u1z/kEayNJc3O5V/PHn6cF6EOgFvT/3Jwt/8dw3d4CDlSKV6ojOBFkr1bNpqQMpAJ5TaIM4Xpobn4h3MxnIxmUv5nGfBGPs8+hg4oGnYpUI1eil1QSsPeC5LuIRbgXMfc3J+NOuWhm2+TPdZZ1OHupII1Wd4ARxE51squpA87C+JMzGFKYB+1ESm3XLpDH6dKDR0ipb1uasXMs3FezZ17BJm19utvfT0zWZyQoshepQTgli60eiftKr+pO4dyv/XjiZcgYD36u18qqJLGbYpKLjo0i1VPLnRe1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNlz0FPg7YoTm6AgK4DIQ02Ns404t6PoFikQ/9S3UV0=;
 b=IV5i9nHym325L6j88nobddN9ysc86oEkFDCVwwEQYdV1d9DQD3JHxL1OXfS/oYoP8K52RoynsdZqe0D70HCFDCHEDQzB2iWVeaNJwn7wo5ApR33ymzlP5/RO80NAoocJtwNhE+Uf0AClzyFik7+xd3/zWahSjXDvFZSLkNhQHGEYupRa7JLBawmzxws1WoCbKgiYLamobP3eVt46JWoKqNRQUfe1tOzIuXqv1i9hU74i5v/iXMeQVEEFXZ88JS36VArDwshJLx1LF4kd5GxrukhGMs3vr05oaRBTnHDIovhois+QFXS1vYfGgUtwhzpJArLF4oLyhNqpx8XB6tDqHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNlz0FPg7YoTm6AgK4DIQ02Ns404t6PoFikQ/9S3UV0=;
 b=Ta1ayV73Vg0YCoUtOs9FBahcODn2g8eXnQNuecNNjfp+74hBu/CFJ29NKbLTgAdZvfOSpJrHjwMmDS+jnTmMK8b2bVXtc/nC7w/g+tANq0Is6+ol60SAD4cJwwkqHrUCvIcQ65zmLF7LeC6RqojWep7KYHQiG1i6v+Vme1sbaX4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CY8PR12MB7538.namprd12.prod.outlook.com (2603:10b6:930:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 30 Jul
 2024 20:28:44 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%5]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 20:28:44 +0000
Date: Tue, 30 Jul 2024 15:28:41 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com,
	bp@alien8.de, mlevitsk@redhat.com, linux-kernel@vger.kernel.org,
	x86@kernel.org, yazen.ghannam@amd.com
Subject: Re: [PATCH] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
Message-ID: <ZqlM+SpJGg11I2Ae@AUS-L1-JOHALLEN.amd.com>
References: <20240730174751.15824-1-john.allen@amd.com>
 <ZqkqWTCa6GdeVykw@google.com>
 <Zqk5IqoQBnQbbuCK@AUS-L1-JOHALLEN.amd.com>
 <ZqlMEehDfursUXSB@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqlMEehDfursUXSB@google.com>
X-ClientProxiedBy: SN7PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:806:121::17) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CY8PR12MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: 04733652-cf44-4043-13c8-08dcb0d6352d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oy+rFUdDMaMhRvIa25GNElz7XyLsczdUf7P9ryi/zwY6Wg0e68dHC1VmlFXK?=
 =?us-ascii?Q?bh/sMjnko4GSDcbx4BpCHQtM5+yw9UFyf3fUT8a8ZRo+aQaT5jYnhFzjopze?=
 =?us-ascii?Q?efhpXu9baML9mBWUXLjOGSE1zvCp2ygEBDv0sHNCjasD7wgWG6Fh+6oNyMry?=
 =?us-ascii?Q?w1NyHfKCgq6PMFNF5VXL2fZ7EZC0ob2/1NgzlSJumuyT4ZRkRX6FGyHnEhQo?=
 =?us-ascii?Q?oef1n2gLIch2TjrGwJhfjnzgPc9zTWTxzamPifO5fJzjd2xIFaszTNP77/bU?=
 =?us-ascii?Q?PcK6nZae+jyMkicoWn73Sf6/nlEAt7bAFrdPD/ELGS2KMY5hg1ZPRUOTeoK3?=
 =?us-ascii?Q?tpC4v0k/b83j1LlMbfh9zoiRA5gGniRoUpeV77BemZU8oQkVebogFq2d1ivY?=
 =?us-ascii?Q?urc3Z4nmFKcW56GkkimJWRU3WmZDEmZuZCiawgPNtufolciD9lbZscZyg8jN?=
 =?us-ascii?Q?ZQvmNvcpWWqXeC0tyUBEXEjw0qYkuJ9sWQp3MgI7VowWRbn5IYEQJv1e0KiN?=
 =?us-ascii?Q?vPLGmq2ddy/49Gdt2z/8N2z0gnFoV/xCKVxKwZCM4dG8AYErcmV3COQ55A5L?=
 =?us-ascii?Q?qQ8j2ds6p+c8IBu15q97rxg0We3M/gCjgA2dhCbNSh4vYFtFzuM40BKv6pBJ?=
 =?us-ascii?Q?0hQxhj5Q4Fr955gD9NFbrVpk9B2sWvp0bnwy+FNKXJJBItVh0ChZxvD5Pj80?=
 =?us-ascii?Q?KrItgT9YfwR/Fy7v77cwJU7JoXSqFIzLbI9ZLWii9Fmqppf+B+Dk7YDo4KaZ?=
 =?us-ascii?Q?GBXri4zRQ/w5QCSNnPLktqAHZPFfp+X9ppCufg7hEOn63gcOpFwzn3bWiA+a?=
 =?us-ascii?Q?grqLgyqCzQg+1J1VGYDsygj7nmWFR/FbCN8C5ByqQdMFr2q2TPIS8Cp2ym1+?=
 =?us-ascii?Q?1LEaXN32GEqJtkOt9Us8miHlgrjfufl93CQysqHpZFmwkr+yzHioJHbJuNhm?=
 =?us-ascii?Q?LDVFcipd5n9wR5sSyGoAKDrxHX7vTpgInYjHZnJg9dMIigfaeW18Vdio+XaF?=
 =?us-ascii?Q?ofMD4ly+NtelgxAxyBjBvqf5HsgyZM6K5dJ/FSX+zjsmcKqidiRgGtG7NlN8?=
 =?us-ascii?Q?+ZBAhSIPgXS1KM+YXDLD5MZ8rRP6X7elziW0M7dsN96SkcEhpwX+5AatD0o/?=
 =?us-ascii?Q?yKXgGdY/lzblY6DdtSg2ll3vJQP6deM5H/vJbPbuQryEFTDv5acvCnzLPjKa?=
 =?us-ascii?Q?JFVNpAxZtsGJu1zZayhw6wbm68QUnYAhCjTmzUp+s48PuE1/1T7VuB0W+aqT?=
 =?us-ascii?Q?WhNlBmjhF+QxM/27y5nFAAz6R8mFpnjTdMC0rO7BUy11NVSVMe7aFBFOShn9?=
 =?us-ascii?Q?JJ/6gej0ABshZvxVaUwf3AJFCttz2fvFOCgy+zD8N5LDqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?omj3e0uVT9uzEqP4P4PH0kXaYDLlBq2bPCuRbxXLNKfU3JAfUj0lEi3Ds2RT?=
 =?us-ascii?Q?zh/3oXc8f/1iTG0ZOhwnIA5ZOWlHeeUDIA2Xd1vY1A4PrM7NK53uGuw5X49L?=
 =?us-ascii?Q?R8grTPHtnHu47QR/w9ZbWJAVZ+ZNsBPgQOpJZi1tiT+XYvKYrmJYQJRxpBdM?=
 =?us-ascii?Q?Ssn1G54OSyedpQV0Eev8Jf+cNfDbc4+0dCEzRRzAt5chL/Yd/6ZvE5c1XUfK?=
 =?us-ascii?Q?xHJTNA+Bc4Wr5/xnJQb4n71/aCxZF3gTTwKGWSpLUxdkbccErHs+Ev39kjVY?=
 =?us-ascii?Q?qJR3fhbvRFc6f0jFWYminQ9bJ0Jh89GYDqra+2dHmGZLAVKE5QOs9CIh+VtN?=
 =?us-ascii?Q?7wsojPKP/9O+GsOgCii/1IRNVpzEBeC+Q4OKPtgrDg7xJl6YuCxtaQm/oHqg?=
 =?us-ascii?Q?wrzhoh5zpYtVUYBh57HAfr+yadl9usGhEajm0G9HBkz7KkZuy+TqDvUwr8qb?=
 =?us-ascii?Q?g773GTIwCiH7Bw8okKvEO8x4oE1GCVF6JYBgyyhcedDFQq/8Dr1TGbRApeYD?=
 =?us-ascii?Q?T69pG7eLAR83IebboPRraRpTbqsC0NSo1X1C02hFUJZAuebm8MxuU3HePVC2?=
 =?us-ascii?Q?dqRNdDYzSD64MWJXEdCZjd8ICp6CAACGycA5l8GbDuqAx2j/F+j7fOXmotOf?=
 =?us-ascii?Q?PbPpwzg+khBqAdxJ0mjJ9Nrm+ygcu81bkYG/OvlOb1NKHITSKXicZrxSSiPm?=
 =?us-ascii?Q?pbljytRocKj9JZSwqIaVNQtUy7ys3bZEM2e7ljUD6+iuMiUmxwk1ysA9+Bae?=
 =?us-ascii?Q?o+YHwRCUunHZeZ/+87MiwWlKobex5lk7WehhKKBYnEdM7TCvh+8iBrDXZSbH?=
 =?us-ascii?Q?2nGGHnupLW5mKQ2Ym5nK7JlRTnuHGwrHNMNF+W/GVyyKE0AZLSgkToBb1nge?=
 =?us-ascii?Q?mf5h5+XURQiSmIxxZ5oXC9moVyB/9ABudUsWDroIeg+sCoTPZcRxuoEuuPcA?=
 =?us-ascii?Q?RrrWUIP5WVz+xYj/xVcGNxBSYU6jjiBv+pHggxD4WBPohN6WqCGoslYj9/ED?=
 =?us-ascii?Q?+vDDV3sk83ifld9GIgWztgkFeeLSS4Qlva0UtPbgU/QBvmA5kzEcSgXC0lUW?=
 =?us-ascii?Q?blARy6/uPXJ+dBdLrAVBTiAznJX7AmDnVpKVuqI2K1N84etoF45cnX+KKbT5?=
 =?us-ascii?Q?F408O9qYm/p+i/YzwlXYeTz8D0Idijrp6dH/qBYNNRvvIOqMWaELmLR+c77n?=
 =?us-ascii?Q?YPZzZdTpLKMELw4vwAU0N2JCtO42/oqv97zTldPKWsXDUxPEtcPwJkSrqlpu?=
 =?us-ascii?Q?pFVdTmBypzNOdj7B1tuQ96WJTvGBsIbrsRfSA8+IH+GD6m4O3f4ICNg+RbtQ?=
 =?us-ascii?Q?PH4jmnEDe7Gp/P2cUYcuObuhlWhwd9jq8iE6p9DwldwMBGojCgfRsKEWd4gM?=
 =?us-ascii?Q?ayDEiYp/WgQsoFoKlTTnBhIcC6dlU1ThXZrnfW/VhKJLfBQkPGPpnG9HtD9D?=
 =?us-ascii?Q?WUvYnbUO+dItfv+WLuhcJqjaF/zkOS339O12C6RyvH+xx9jSFjR6XDA3gC+D?=
 =?us-ascii?Q?T/f0G65Efqs9OOdnfLrvXFuC+9SP4NRpgqjUTMmm622+Tf0AN7gqxrPG3J08?=
 =?us-ascii?Q?E5U6HmgXJT40TfAp7B9fWx54qfF3dlWTSABTuKQL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04733652-cf44-4043-13c8-08dcb0d6352d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 20:28:44.2264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgdHs87oqNPUCFJFOaAigDfZRk3VEWImtqdCYddXJv0NJ5OMjy5gVazZNGS5gqa6rjAjOk7ZbP3Yu7SajQCkDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7538

On Tue, Jul 30, 2024 at 01:24:49PM -0700, Sean Christopherson wrote:
> On Tue, Jul 30, 2024, John Allen wrote:
> > On Tue, Jul 30, 2024 at 11:00:57AM -0700, Sean Christopherson wrote:
> > > On Tue, Jul 30, 2024, John Allen wrote:
> > > > Handling deferred, uncorrected MCEs on AMD guests is now possible with
> > > > additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
> > > > bits are advertised to the guest in KVM.
> > > > 
> > > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > Signed-off-by: John Allen <john.allen@amd.com>
> > > > ---
> > > >  arch/x86/kvm/cpuid.c   | 2 +-
> > > >  arch/x86/kvm/svm/svm.c | 7 +++++++
> > > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > > index 2617be544480..4745098416c3 100644
> > > > --- a/arch/x86/kvm/cpuid.c
> > > > +++ b/arch/x86/kvm/cpuid.c
> > > > @@ -1241,7 +1241,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> > > >  
> > > >  		/* mask against host */
> > > >  		entry->edx &= boot_cpu_data.x86_power;
> > > > -		entry->eax = entry->ebx = entry->ecx = 0;
> > > > +		entry->eax = entry->ecx = 0;
> > > 
> > > Needs an override to prevent reporting all of EBX to userspace.
> > > 
> > > 		cpuid_entry_override(entry, CPUID_8000_0007_EBX);
> > 
> > Right, I see what you mean. We just want to expose these specific bits
> > and not all of EBX. I think with the patch as it is along with the
> > change you suggest below, this should resolve this as the above case
> > already has the cpuid_entry_override just above where it cuts off.
> 
> Heh, nope, it doesn't.  The existing override is for EDX, this needs one for EBX.

Ah, yes you're right. Sorry for the noise!

