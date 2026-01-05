Return-Path: <kvm+bounces-67075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9643CF5492
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 20:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D88D7302E3EE
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 19:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E982D97A6;
	Mon,  5 Jan 2026 19:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fS+ehzWS"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C50322097
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767639687; cv=fail; b=XXIeo+KEG8jvKw7hPzfDB9ib0Gjvn6YtJRSPos5tD/FCD87Sh+6dMZIHJ38XtyYU7lA8z7us4apiQHj6q1UsBUMKHS5MyIci2yPnDL6sNjXzZBQBvcfQ8u8QQ4HM2KCN6NbGuS9YPs+POxjosK5poJ3KlUBwjmWFvxMqXtBR3To=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767639687; c=relaxed/simple;
	bh=4Vz4apHi4XeDB9ZdwZee7L4lyZm8ilteDHrGDhai56k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VpPR9+ImJZIMBL/JiizmhguXqzyE/CZ3vdIV4zDNei6//BYVajHPNxMHm7IcXcM2HCpwCzr9r7ZKAxiFxpGoLKKsXNm7+0m1w5pYr13adm4AsIyxI6aUA1DQDI8coMzxMpZBuUHTlSLGgZOFR5maPBjBGxcK5hPHXFOLjrPgFqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fS+ehzWS; arc=fail smtp.client-ip=40.107.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PL0o2Ata6+a0JUKcVaTMvGWWbn/G1LhM78SSOhOKGXm1F/LtiKbHPaNhUsgyFXfHK6/4BPrR0Z5YxQbV66KN/Go+XyvKYi+Dlzz3FnfcH3pphW4EOWT1z+kBXXMvchFK81eSUaGJuUJ8qOrepA26fFsiTasTXMOTgwJrA2uTZLfPNGs2MCeXe/yEY5mW/sVM/nAdzqmTwzlW+L9LXfosLnKEgXDaFNAUJaVUjXyWe5GIL9UQglTjo3MMWHn5K9H04hRLQI2IXaVgJ3y+9zc0G6dSh8ammbqJ2KmF/Bg9D2wfK+W5W7FjBxDnQoMlYZTWmIeHM3bL9InGvIpVXbuLag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfjZc81IKK1YGpYg3h8PWFsYfUsQ29S/NkRj10D6/Jc=;
 b=A8vlmAVin01awa48LINh2daeQXSuocvE1A3SOdifEQ1WDBVzyzALqvAhJsaUD5zlBmdvOXz9Oz3266XZ39lfb/VhHGSsxLY8u3BreKZV1Jk6aRiU0jZvKq834vX+zqSGVlZ2RRBqK+mmfWxa8dNk1TYYBW8jVsbLbjq5Iy3j20Zkiz+OLMa928ajn3dWu/0vTatT0wtE//j+DLGKuXHjAqQ/kgce2hx6EUFuSkA54Myb74/iDrAJSuFSrje3QPTnd+KdP2hAtjQstVUqTWc3GqjeLWMzwJfPzZ0fcwZsUeh1Ghr9I0scacvHyawACJBQC4N/22QlIFcKodigD9gu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfjZc81IKK1YGpYg3h8PWFsYfUsQ29S/NkRj10D6/Jc=;
 b=fS+ehzWS006VkwYOoMJuoYb8vG8lUkMfIg89MRkfAlHL6YKZN7KdUYC9p7xb+DNahd9mPIKLmGQoQk/dJlQP08tNVahTG0R7ikRca+b93xVBh3oWiCizl+vob+hYuOXkKZnoM1+OBtFm705aVCOZI/jc+Mmt7xHkgGy0hrLQIzPnSnkjPgA/swtOG5QNm69Bn3xvBn4IwcIRv9GEUGrsd5QR/XbxjvX8dQPwlWyvGjmNnXWHzYLK51PvlnBI3VJ5ddWeqBHNHFT+hhIejJYAqoD4ndaWGYMXFgTaOoUYzeRka+Wc308l2Ti3Tx6CpjBcOXu+xsuyBcx//wch45U2AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW6PR12MB8866.namprd12.prod.outlook.com (2603:10b6:303:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 19:01:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 19:01:22 +0000
Date: Mon, 5 Jan 2026 15:01:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, alex.williamson@redhat.com,
	kvm@vger.kernel.org, seanjc@google.com
Subject: Re: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge
 pages
Message-ID: <20260105190121.GA193546@nvidia.com>
References: <20251223230044.2617028-1-aaronlewis@google.com>
 <20251223230044.2617028-2-aaronlewis@google.com>
 <aUtLrp2smpXZPpBO@nvidia.com>
 <CAAAPnDEcAGEBexGfC92pS=t9iYQRJFyFE9yPUU916T92Y465qw@mail.gmail.com>
 <20251230011241.GA23056@nvidia.com>
 <CALzav=c32W4d=_WtXHWDmjfQaJDyzdxWXS9_kVHvseUsqh=+NQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=c32W4d=_WtXHWDmjfQaJDyzdxWXS9_kVHvseUsqh=+NQ@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:208:329::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW6PR12MB8866:EE_
X-MS-Office365-Filtering-Correlation-Id: b2e9a394-a8f2-4c65-1d14-08de4c8cd140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?toxuQCBjuQkmO3EPmsu0XU2ABKpyTI4UFq8zVI/m50P+e8mKbLoG8EbHiXuN?=
 =?us-ascii?Q?+aLGqh9oE1UevOYPZq9e58czEOQzyk72nnXmBopFUVZESw9EvWcbb7holXW/?=
 =?us-ascii?Q?aWxCgjRIeplNsis2YEKs1c9U4sDUSJ9Jq/tBDgAhRSQRvmhERj0zQ+xeUX9j?=
 =?us-ascii?Q?vNqBZBCzTkQumCiS257p+kRUHQ1qrwvdaEXHN+wqUa1UlLjmzmbC8T9Ot1CV?=
 =?us-ascii?Q?hAebKs5vtLrJrghfLQSv4wa1nz1VoyYLkJCtcGS4/5AqZggty5IxehadQVfJ?=
 =?us-ascii?Q?R4wdYbJAswYvW6vwu2ukXwdkY4C6gbRTKVuDeyAyttN35KFoH4dAXN0SRccw?=
 =?us-ascii?Q?4YhM9k2KBJLvUsm3xipqQTJJfro++LFXGmf1HCdtsStX/jFQzai8Ny0ky3BH?=
 =?us-ascii?Q?pIDEjkd6IYwbUGwYDwF+9X/V8vo0rZjIoNUS3YUgUW80ualWfIE/ylrlOhpD?=
 =?us-ascii?Q?29cttLW4tNxinckxP2fG/A4dbzhqDHFUCXQqA5tuT6Q+3nRJCVdd5P8O6PUB?=
 =?us-ascii?Q?LPxpwjI2LjNCDerYScYngfwLdTeWOJ3KggzZ1nDjYYwGl/fU3x1b/tRc9ls4?=
 =?us-ascii?Q?0QlZlvbiAaMOhV9/Z3WiruSMqCGLfxA7xb/0ZT9FmKQgYmy2V2219YHmZv7u?=
 =?us-ascii?Q?G5QK2MleRnmXXHXZxk5ImuNh/IIHmu7T4S+8IODjnExOQd9Rnx6EiJ2toD12?=
 =?us-ascii?Q?IgNK1HfgGlMjJsBSIPQnur1h58c4/yRGLRQhd5ldAOhaMcXPzcWsp+Nh2DpZ?=
 =?us-ascii?Q?NEOHtX9vTmQcEx7BCSiLMyNZtQVkwe7h6vJfQi5ljmkFWQ7SIFccqcrjcuAZ?=
 =?us-ascii?Q?iv5qb6HV8uWQeGFPZ6Fy+W9WC/0l05XvfrUUCmyP082DFilFNadN46wzJrUD?=
 =?us-ascii?Q?mJBnDzPUMrue09V8ZnxCtRqk1gZ7Fjv8ez/+WcePD/qDd6JOPfCSmPLuDNWJ?=
 =?us-ascii?Q?8VKGoOCZAOzNby61EFA36UyQtvIJJ+BW5V0OhAqwMBJ2tT+5VYM3PUpfiz5w?=
 =?us-ascii?Q?l4Kw0hVneQhgLgD9I68fiAicaekQQUZfKc1A92c7wK9LU5mFKVObhYQ48zR7?=
 =?us-ascii?Q?9rJYJbGL03KXk5JX2S1YzNkKSVKWPXWpOCI6tVL/i4fh4tN6UXD0a9/AFdfM?=
 =?us-ascii?Q?E/2iMlDrUVzyXjYHSn0qdpZLvb4/ijFL79q0VurmLRXFWrC65EW0yjbahN78?=
 =?us-ascii?Q?T8QZoq65OyJNBNF+4K7pph6CHhrReuwtfBL/GdEfnSygoVeaxmEvMXJjboso?=
 =?us-ascii?Q?m+dO8lkZDcNkqq+qbE6oGLX7gx3zzKWZzd2/UG8I6jCXkPv3IVN3OvUYD8AR?=
 =?us-ascii?Q?HnRXMjbrur+Z9vOUu90V5BWfiV8psVGm/uex1rXwZp2Z/DzVGnBnlI+Z8u6i?=
 =?us-ascii?Q?dokOji2grZ1phmBPQcdNbNWq/YzM7jiTgke9tInPthh03QQpcyQxK8rkxler?=
 =?us-ascii?Q?H3oO1ZaAcZHP2RImRhIDB4tVaahcGWpA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FbyNVy2MTyvhqwkQM/1SPVIMMRALGuW3vWUz+bGxBtV+xAHCCbMvzdLqidTr?=
 =?us-ascii?Q?MoxVKl+g3+evDspOcDHpjFsuB49EuHZufwdKLna9qKClH5mVoWkHLIu399HU?=
 =?us-ascii?Q?t9frNVjQPmakLemcAsaSXW2Ce9LYySskS9SkqXt8t9hkLbhRb2HgSJwrR1qd?=
 =?us-ascii?Q?i/TVMQHK4ZWHdkp+Wdf6Sd6+WGoiqMxAW7OBWihTa7DSCxwpa+eKhJVx4MMI?=
 =?us-ascii?Q?NL4SN3ly7U4psZTC2ANbiGx/ldDH3p5YFnZfi/q/X3AwTajQxabqBkBuRHQC?=
 =?us-ascii?Q?oNxZTgQzUXOwc1v0cqZhdHxdoEXA+pCQukYv2TxCPCboWcLJarYv3gNA4nbO?=
 =?us-ascii?Q?AbJ9IsdsIVkNTIzKAWmK7nv92J4Klpw+2WCUS6416Hn1hXRVJnaLF8SKlxka?=
 =?us-ascii?Q?y+yLmBHJc6g71u2eT1bm+PBZc55IqbL3r5e5OBwJXyIjIhBI006z7AeCO/iT?=
 =?us-ascii?Q?zwuno8ONx0LTb00uFLmDTYn9U3mqN/48Gzf68g50EqHulVV0BCKCOl0BNtxJ?=
 =?us-ascii?Q?5TmY3sCiOOntIgqfw6zxTdm62RfCc/7EEUqo5VN/udxjht4Ozfk2N010kaup?=
 =?us-ascii?Q?KRuMD4Hyjm1Mco13jLTySF18aQWvI/ZLO8Av6vnQH4aJCVAlC7h5mneWuAR1?=
 =?us-ascii?Q?RupPhc4IND/p50EiWg0bBWIdaGr7XPiNKR00jxKntEIy7mp5wOEBYv+p1KUJ?=
 =?us-ascii?Q?pIqy97Tygv/dB4/k9BRqkzsL4a0Elz+dJ5uw+8vEY+kpqOoVM04DnPqJccKe?=
 =?us-ascii?Q?DF5KiAMOZG+WJtLmeXKmgZMia1ser4LJP1XtbTKIOLml67oCzJ342Wy30Lsw?=
 =?us-ascii?Q?hP6I1qTmBWaPVWphwZVsBpvP4S/LvxlTqQPYKCy7pe/XLBQRZ/1k+EjA25DB?=
 =?us-ascii?Q?VMjfCWx4Cb+nVGWZo7EEz9WIct6jj52p7geRTmf4ZLUbHrD8dLiKa/t4waBY?=
 =?us-ascii?Q?KXyKl93YCSx5MnqCc/TV9GYndMLDyZHcjRDdzPishspsUEptAHgCgHjP5WHO?=
 =?us-ascii?Q?QWFFGso79EJHNmUaSHOOyf7pYl1LzqDH++7Jww3gtAzEFWiUJ3WsGPbWjmuE?=
 =?us-ascii?Q?3y0Y0jK36LxacjH17FSE+40FGP0YIBl2rUCWtca5g0V4NJKTOm8cMQY7udUT?=
 =?us-ascii?Q?HJ5EHRQcpUreVG5rVCBYzq3kCkQbG2hsub6NMFs18EKKqErHchlkZLddJSCZ?=
 =?us-ascii?Q?y3p54y4Yx6eFHKBZQ5e/TuRhCgyDdSHO+DZqKfyy0QouyM7X8KGIT6Im0/Qp?=
 =?us-ascii?Q?QJZoIzHfvrBPX0MgL7LQnFq4vrFDYQiKW3LyiR7UFqSWlTSqysC3D31BO9Hb?=
 =?us-ascii?Q?wW/RCAclL6Lp6GQIgxHnzGxxu5QbODvNFXbcJc0MQ4+MFcr3IFOtRs03qJWr?=
 =?us-ascii?Q?muM7aTsjegTpQYBSr1x0QhX5TCZQ1fwaKncWOIfV9dO/OqR1CCvW+b03P5dj?=
 =?us-ascii?Q?6sRClwzj5Vn28JCcOqD4rh9Gkq7TUgRy/Xz1KcGbpvoy277haFgNUwkJo6Fz?=
 =?us-ascii?Q?oAR3mpwrQ9fI1oSOAG5/m86l5YRUZ2l9phIAR1iwsXh9qjlpOlFPuFm9S9No?=
 =?us-ascii?Q?NxsnStUor0L+bvUH158wxIseqQKNqjUev3AqAnEC/BE7vVlbBmJs9P39XU+Y?=
 =?us-ascii?Q?+xALuZ4ewpPAPd4FmAWwvZIhiq9AP7I3MNZiYiZZlq18kZ0Klw6KpoGoKh8K?=
 =?us-ascii?Q?z9+s5hBWeGFmSVksS46m2nSbTVt1NsfJVlNZx/sBsbEzTEMN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e9a394-a8f2-4c65-1d14-08de4c8cd140
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 19:01:22.5638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkF2pvj9sPOGC5dEiiNyW9djtY49yOletcIUu2rWkA69VcA0LZAL2mlxPZamyBBu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8866

On Mon, Jan 05, 2026 at 10:31:14AM -0800, David Matlack wrote:

> Ack on the feedback that this is not a general solution and we should
> switch to iommufd with memfd pinning for our use-case. But I think
> Google will need to carry an optimization locally to type1 until we
> can make that switch to meet our goals.
> 
> For HugeTLB mappings specifically, can it be assumed the VMA contains
> the entire folio? I'm wondering what is the safest way to achieve
> performance close to what Aaron achieved in his patch in type1 for
> HugeTLB and DevDAX. (Not for upstream, just internally.)

If you are certain the address range in question is a single VMA and
that VMA is one of the special memfd-like types then you should be
able to do that.

The issue here is that VFIO doesn't have any idea about VMAs and
pin_user_pages_fast() doesn't check them. So you need to give up
pin_user_pages_fast() and have vfio code bound the work to actual VMAs
under a lock with the table read to make this solution work fully
properly.

Of course for your very special use case the VMM isn't creating sliced
up VMAs and trying to attack the kernel with them so the simple
solution here is workable with VMM co-operation. (though it opens a
sort of security problem of course)

But I wouldn't want to see such hackery in upstream.

Jason

