Return-Path: <kvm+bounces-48000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB1EAC836D
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9BD3BEB90
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 20:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9A7293475;
	Thu, 29 May 2025 20:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oCfbybZz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF91B0424;
	Thu, 29 May 2025 20:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748552370; cv=fail; b=stalLs2soFplJAXB1jeJb8tLifXXCHYDNO+MKvzxBKgw1tgB+vO8cAvwcC85v9BjYSJeKObAHzuFl1GDvsDKnr1q4Bxr7Gt6SICjqdZFq4w3N5L5ij8bzPgO7ZjqqdKDkkqlBdFDZGrFCXY9Fc2zf6bC8whIUVaCQ0bcZArDO7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748552370; c=relaxed/simple;
	bh=jlyPXNoIbg4mscxk8v4oVfbYXN4mXiqrMd+nUBKRQhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gR0IiwF0M5ydlmO0A5MI3+EVvpEPefIa8Fz80bZahTRFcQ+DbI9RQd8RwlEUUZE0Gqy6xii7hwRMGqc5GXyUpECajdQaHIPUQXA+xNo4mUREPd0dR6jfg4ngqUIFYLr3nLAI/kMxYqb5Nz43DqbDYFb60NFekqiSafNjqr4wjes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oCfbybZz; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CheMQG/ucjxyofpV2VhA8DmN1iqhvhXL7uiwOP70Q+JduJIn9UxoFLj6co5Hp0sFspgCtjLsiuK4qgq4s4LIewK5eZcY+KgmRbcn7M2PqVt2JXo+TN5TiNrDXO2AYPF6UczgzgcjDBcl0p2D//bTKbdFOYt6894laYHtPhQtPDDWfgkMwusIxewEfEJHZhKDQX9Qkgk9mKz3bSRYDnrLhCnINUCQjs0+j49fMOs8VR0iDEgwer99eM7kO5+R9n7pq3aaY8inLYpBrx0dtQT6bRilUfWw0fSGZzvL/r8iFQDaS4wurjfrDJkRBnnCMYDLLhpOwpyDrmXynhNIIrR4Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HARt4K2cGd25OeedMktXhxs97zqtGtj8Uywn5vFudJw=;
 b=pfGPbsALcmkKevzotk+spJyMkVEz7/KAhdjZi1P+7N/MhrC2MFxA+LsWEYfw68+eWj5GrJgFKziiYWSN8ZMQiq9BaCOzzmNi7qNBUNpHjVjxy3UzNVM7zmddG+FVg0oG2Lb/KrT1IjpZY0kMs/BU/s1oc17rB1h9cyjTB3mnzu42XFUPTLACdOzKd9xZdxGIDBVdr6bBFOTP7/hf0h+h35aafeDfhhAKA3UPT2oJBM31yOKTqOjsKI2Toa7gvAAOvZ25la5/Tc1xCrmKQ2145sIK0LtibIKVCArnk0i4FLWqMI3FVNnfTnmARIUYcDheqYPi+n47C0tFkuHCHZ8nyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HARt4K2cGd25OeedMktXhxs97zqtGtj8Uywn5vFudJw=;
 b=oCfbybZzWGDndNJZZZ9Se2h5kS16xsYHZhLtDpo1+Avndfom586JftcER6Z/g6uedOBI9cCJ3Z2yntZVPulokAUnDKL1wAe70FvPAfhM71actaLSr6lXcp4N2qE9ncL8P3tabfJM72TMSv2fpLhE63UbYb3X1pK0olyKTG4lits=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Thu, 29 May
 2025 20:59:26 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 20:59:25 +0000
Date: Thu, 29 May 2025 15:59:18 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com,
	pbonzini@redhat.com, peterz@infradead.org,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, bp@alien8.de,
	chang.seok.bae@intel.com, xin3.li@intel.com,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Kees Cook <kees@kernel.org>, Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>, Oleg Nesterov <oleg@redhat.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v8 1/6] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <aDjKpsD8PTugB0+Q@AUSJOHALLEN.amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <20250522151031.426788-2-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-2-chao.gao@intel.com>
X-ClientProxiedBy: CH2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:610:20::26) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS7PR12MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: bc2d866c-7e13-4bfe-984c-08dd9ef3b176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PHJD4Zcg22txfMynURV5ZpVcv3W/b2xUBKiv1xkiyAPoKe+yQUT3jAwOBo+C?=
 =?us-ascii?Q?/oa9mxBWp1PXGNaz+VWE5dxeMGp5CUio9b5fQ0fvhygA9+ixnEtKa6yV46+T?=
 =?us-ascii?Q?Rf5S2EMyNJi8MhuKgqVkfuI32t74r5HyXI2QqE4NQpEZQX0twX9v+Y40quGK?=
 =?us-ascii?Q?Zmf7oudquGrzGC7I86jyOCs8EVzmH7qnRYQLrp/x4LQWiu8oTenDQCEf4H25?=
 =?us-ascii?Q?J4N0AGUD31jbdfe8O/vRSsQVNEDB+pcfu7kRw7d4Ozw2s4J48PaNeHFrAtiS?=
 =?us-ascii?Q?heqMzJaPHP88u8nP+2QzGAlJxXtIAvayZv0JjxUuO5y1L0pYt+1s/uPQ0whJ?=
 =?us-ascii?Q?WeZsHFntSaazUjSr3TaWRO02J/yP2LgWMgHxauy3lndi2qM/DSUno8swiamZ?=
 =?us-ascii?Q?314L2BbyF9GCy0H4+hNbKm45wMTyg0/ooOyzfJEbrQxlJNTygxPnR7ZmKN2U?=
 =?us-ascii?Q?UyQsOXASRhuMD1awDQwAh5AhXl3QfRceIRXrSkSczdLTm8j9q+oe+yz3tIgx?=
 =?us-ascii?Q?+M+umuPdFjKGMFnZ6p6YQ1evOSYp0q/lE9SPzi0UeKC8qNii5jWUbrb0+/dC?=
 =?us-ascii?Q?Z/Tvw8cN+/i78Udm6szzC/Uka1vyhJnQhNYE/YRQymZCIKNxwUir7my973h/?=
 =?us-ascii?Q?02joiUcIGsUuLLgshm47mLG2bCuypaXD43/XFBkZdCyOvVLg8J/gpKywMF47?=
 =?us-ascii?Q?q91U3ewpZin2maFPcW3Lk5QaJ9hP8yS8Bi5zqqjKHgR+HOq0wy4pUxABsM2r?=
 =?us-ascii?Q?mSd4PUWZQXB5ido2QAc0ZLhgfKhdhO/GpBnFfnOi62EAqmtYHS0uRIEbXADa?=
 =?us-ascii?Q?gdU67DiFxhLzJgZf2rn97lIiw5VDxDWL9vxvdjuD3MHQBDX2VE5Ql3cK2n7f?=
 =?us-ascii?Q?xqo2eCgj/4cs253T5Q+O9BaJudC02wXXhcKvDUEYQuNk8yj7x+7NJMz8REw1?=
 =?us-ascii?Q?VWof4YyMPXYwsy88Y78NBeodmmhktjqrNgJM94jPWSEwDF+zMrW6iLGvi50m?=
 =?us-ascii?Q?UKgNCzcyxGkV3nBJ5YeyjsFsV/qGzIykfRlcyv9ndkBeKqR68y7RwOq2/mK0?=
 =?us-ascii?Q?HrU+99e1uzIS6uQNG5J0ZM1GyxqkfmDrQaHN38kRzJuGz4OEP26Yk0doqbeO?=
 =?us-ascii?Q?IEQ6amo0LSuoQSgufDjoPK4YYzF/edjEc/mnrLgEryGiTYTmdHwYoU/kOZij?=
 =?us-ascii?Q?zbSg+UuCcoZizfteid8uCsmomP/hbP4vG9wMgioMXWWAZ0x8AnhqzN0C8XWV?=
 =?us-ascii?Q?j2buFE7RBt4RVoYkrlgGsjmzmnFVdpEq+H7774kE/6R0q2pzZNlbPVh9SxSn?=
 =?us-ascii?Q?MIRYT+OeUbVYMc3f6PioKMjeppXTJ1UH9FGw6+53GEOdWoqwbQ/i9sJRJ8BF?=
 =?us-ascii?Q?c3g7slKmegnMCPKcBMlElyAnqY/qnyh9V3ZJdzFemSVgd0Rd1cfrRLtJEkqq?=
 =?us-ascii?Q?Rg3JiNArMkY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yak5Gv3LA0u7cpaSX41yjBbFkgdBlBMolFAdY/d+9oMOQtz4lR9El4wWbpej?=
 =?us-ascii?Q?bBXszlahIHJ7RgcFZk4PPEqXexITwiijgR/qOVhmY107t8Ubgxh6wfPMTMhE?=
 =?us-ascii?Q?igYpnRToQMkF+dsVZV4W6N1PTK4UyyjrpSOUmpUpReob67VAMZshjLX90361?=
 =?us-ascii?Q?/02oS5BfFl22TyIczgTyQ9H98EM+1tFD8hoqk4dVjesmWyQmAhXYcfQXvI7f?=
 =?us-ascii?Q?yVVhDaaVmJn/frwGt/UybCnI9RjWCRT99w03egJMdQX9yvOJxosd/A97/6sG?=
 =?us-ascii?Q?okl+JReZ7Xfdn1x879P4yR052W2nrkqU47EtMbwlYnnZvsdsK4Pd341z4uX/?=
 =?us-ascii?Q?jOgnCoZQ/LpRNAqWdlmRP8oM4dFETOAp7l/B7GP0oyw5TV285At0Etacn+9a?=
 =?us-ascii?Q?womNFWCv0I2h/KymTfIXEzIx0JBIj7Mchk6N7uOC5n4xZyCqaqu45fXzMOZk?=
 =?us-ascii?Q?0q+8Vz6C3Rzvx16SGOeSJzzBnfQB2ZB+ax9/zysJDV1a2U096vUWqbzoStkQ?=
 =?us-ascii?Q?QFoOuJPGArlUD9sNbolcHiRQY7hioabc03yV1jw/mOaEtly77fBoQOpgrCpr?=
 =?us-ascii?Q?LkgLI0x9IHv/vBB755mq+tZWvdy/4kwwaeChi2v5iOZO+vm7EloM3hDTheR7?=
 =?us-ascii?Q?tZ4nT98ABlrnQAINYG8QUGAZ75hYBILCT6/oTQjdfYIvrksRkmS7Vk1/MxQy?=
 =?us-ascii?Q?Jjr5ssLT1mHXQ0wFuDWfbpdAhigUf5b2b/PoZ5OTUHNBpGQ/GRTQm9LYx1so?=
 =?us-ascii?Q?Vi4iG2I+2iNlMDsRYgZwjEM+zw25HAp8Zf3Ynpi6R2BnM9xEscynMA8zl+xV?=
 =?us-ascii?Q?l/n/TVINKx3zPx270JGusSFQb0CSzau1RWuAXpPNjF+L/2FADmp5S41AMJF0?=
 =?us-ascii?Q?tp6LILSje7C6Zjc4V5aa7D30ZC4au8ksGWq2tHeBxuA9q9hK3yFkRxTlVWrK?=
 =?us-ascii?Q?2YwRBeTK45/Kc+I2NB6W9UxLxLkzbjdOj2l4HdgK45FA/Wm0iwbXgW2hQfkf?=
 =?us-ascii?Q?c4RKguG7ChpgOryVsXNVudawPVzgmzsN0YoAcA7pdS6bqohYBD6YLp5as3eM?=
 =?us-ascii?Q?BB/1aI/pW4PIwOODJOqZx4eY/XIdyhn/J3pmRIB/qvnvqO1O/eugabd2TIjJ?=
 =?us-ascii?Q?JAWRSyhcrComylDx+QDSRzNKYkvbY9gjG34fxsT8nX7VaaB9esiYqTSoIq58?=
 =?us-ascii?Q?RBMgYhLpluoi9y27fO4u3j3UVRx4XpOPyfBm3rVEepsZw7xRjNCWJ2DjXfq6?=
 =?us-ascii?Q?kX2IgHN6OlE/mX9xg6bdD7kiGOUvwtOXs/UPFe/hJ+6As2qMUZMwJ72WLaq6?=
 =?us-ascii?Q?ryHrhiPMbDkmTZomcNkSiLZpog0PscJIQa2SIjfy4x9wn2+lBisRMx+CSNyY?=
 =?us-ascii?Q?6Q/c0RDIXXJxUTxlB86nMeEC8QRx3TNl8WdbSfCHsdhHeXAzfZj39cgz/Qlf?=
 =?us-ascii?Q?XCfRvVPzd/ztPymgr1wM6exfZFiF6kcNgevhHh9LE1F1V3G/Qac+c2+4g7RP?=
 =?us-ascii?Q?DbU7YqJp62E0uDaAcSF+a2WkgIpWSuWOYUnW0FKf+IqFG0HMQAAxqPBnXCfO?=
 =?us-ascii?Q?CRLe5gyA8lLZQ730jSd+uFSWxDRXaGZDUjgURha5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2d866c-7e13-4bfe-984c-08dd9ef3b176
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 20:59:25.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tErnSkYWv8Q4xZ6OIPAr6RxxgKC9TG7Vfs8rNtPBsVuJC4FXNlSBRKqTAW2qUk9wK+5HtLSFRQ2i29ZKCsHnMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263

On Thu, May 22, 2025 at 08:10:04AM -0700, Chao Gao wrote:
> Currently, guest and host FPUs share the same default features. However,
> the CET supervisor xstate is the first feature that needs to be enabled
> exclusively for guest FPUs. Enabling it for host FPUs leads to a waste of
> 24 bytes in the XSAVE buffer.
> 
> To support "guest-only" features, add a new structure to hold the
> default features and sizes for guest FPUs to clearly differentiate them
> from those for host FPUs.
> 
> Add two helpers to provide the default feature masks for guest and host
> FPUs. Default features are derived by applying the masks to the maximum
> supported features.
> 
> Note that,
> 1) for now, guest_default_mask() and host_default_mask() are identical.
> This will change in a follow-up patch once guest permissions, default
> xfeatures, and fpstate size are all converted to use the guest defaults.
> 
> 2) only supervisor features will diverge between guest FPUs and host
> FPUs, while user features will remain the same [1][2]. So, the new
> vcpu_fpu_config struct does not include default user features and size
> for the UABI buffer.
> 
> An alternative approach is adding a guest_only_xfeatures member to
> fpu_kernel_cfg and adding two helper functions to calculate the guest
> default xfeatures and size. However, calculating these defaults at runtime
> would introduce unnecessary overhead.
> 
> Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: John Allen <john.allen@amd.com>

