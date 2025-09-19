Return-Path: <kvm+bounces-58160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DE2B8A86E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0927B5A8308
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9D131E0EF;
	Fri, 19 Sep 2025 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GYnKfRFA"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010049.outbound.protection.outlook.com [52.101.56.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5040C31FEC6;
	Fri, 19 Sep 2025 16:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298432; cv=fail; b=ho3yWjfQR9I9E75dtZfJUL0cTpMfpy9tV7EQqn69k/e1i3tN4O4WKIaN8Fj0m0renuNPG+M7pUpp5MA37J5RER6hs3ixFSsq3s/3WgXcuhwcTq2sMgrHNKCQEeuXLy7YYVegfrMO5eWHPY0w/mzDwecp7T4W4PW1yHu+9Kw/vEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298432; c=relaxed/simple;
	bh=g/h/bVzMmrHSeUjA4+yQJXt93/d863bx63vfhizXlZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EduB9LViWIJgVTBA80k2LZiiuDA0RgC6cXhjE9uTZqCNnMh0nbW77FPtLdnsP61JwBkNPUearptevt7w5rQDicp/ZhKIaikuRyraxfzQC1J5n2xp5sZl6reXNenLIdWE6ok1BjZ6veau1nLoVVMF8GosGF6IWDVAwZ3M0IyQZnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GYnKfRFA; arc=fail smtp.client-ip=52.101.56.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AvKTrVWHXqU5ISTUtPtr3gDK8vqcP7g7aCdoCNit8+fDm/RnLtwmxGbWky5BL3kfP/M4icPlLzwOWxm1Q2iBFcWbd88II100j/4ESoxa4q9O4Zwn82tGGWtFA+CT7Qgcy37X/a51vHDQFSrRwB4AXRrX+1GdIC4v8nd7kCspl5S4Rp1BdRNxOo6zlusCDlHZon8WrQLZ1WpqzWjgfPZYIgn1eL7vkDHxG5Nhvu28ctU8Iw7Fe0bGgrg4a+HOmrPygLR2XgsVMtwB4o7TA1ejSKw26Mq6mQbtr4lmB6U4hqBKcnrGh8zCSL4FYVrvtGHFmhDYXz0b+DyiHN7fSbPx/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFZWwiDJJ1F/0U76J5x2UbFGRNuRJ8c0fhhf25OiybM=;
 b=VQSI0cShdvdSJLMB+OwYAzKb/q0SF1YAIIdjlWPqq7CPJF1cxvgrGjg/2/2GpOcM4B13485aXLhYOJKGcD5vlb4WVkiO2FqKy32REXesvX2cJqAzhk6gm9azP3ISLo6sHLxsc5s0Eg8vB8fJq0OFkrDL4GI16Yn9jDA97pIXpdwbeDJJAvbpo95Rg74EL0HXXdZVyqt8qFyNLFQQTaPYPcZye9ikOfctMvph30505iCrSrzG4sQfmLK/gGN0E7KWnZ+TIY6cH5Fo5bphrQRVksDmf6mMCp4qYkU5SEgK9jG/qbPyOSMgU2b8icQsTv/fbLVDx18XlpN/9qR/yqpbHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFZWwiDJJ1F/0U76J5x2UbFGRNuRJ8c0fhhf25OiybM=;
 b=GYnKfRFAq1J/ygo0SzBWW6qCjT6YnjOg3rUVRNas5m9iKnXf1GqxREJ3T0rpX3mc4CxQqX7azGD4CqHh3R7LdGveH1X24WO076uSS7hzTYImcpv8D20QDGU/U1ZsbKXngfhs5BGV/lbbTZshaInK4V+3R8+1AplD59XegkaZQ8M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DM4PR12MB8474.namprd12.prod.outlook.com (2603:10b6:8:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 16:13:47 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 16:13:47 +0000
Date: Fri, 19 Sep 2025 11:13:36 -0500
From: John Allen <john.allen@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"minipli@grsecurity.net" <minipli@grsecurity.net>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <aM2BMM+hw+v893Qt@AUSJOHALLEN.amd.com>
References: <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
 <aMnY7NqhhnMYqu7m@google.com>
 <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
 <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com>
 <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
 <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
X-ClientProxiedBy: SJ0PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::31) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DM4PR12MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b9b2172-71a8-4726-24a4-08ddf7978314
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4p1RSIKG3giHBEGH6qB/djdUzYzreWFX9ZnIuTi+d0pUsE1pVMWRd6KiWI5Y?=
 =?us-ascii?Q?BRG7/lZRFnBXJOutboGoszeltPsR8ChouNDcEcaJgTg4lyrqQfTot+2Ef05b?=
 =?us-ascii?Q?vTqXOiOurdGXsZvE2lriskt77YjPLHs8Gf9xT7j+G4MfRgqa2doWbqQLrLj5?=
 =?us-ascii?Q?m9vOuFVDDkSGin6Q9iJL2TrZImEQgT9axcOlvCy7H2qPahPb/atRYOyRKDb/?=
 =?us-ascii?Q?0N+P1AHnR6WVgC8vNIAdPFTRlW5YxeHdflh7nUYfhHDIA9Qz0+wZr9JxuE3M?=
 =?us-ascii?Q?74QTc4ZSghtB8hDp51gJIXr9R39riNnN83oWYzypWA2k7gt7inIrjeeuJUN4?=
 =?us-ascii?Q?eAxGLas3/x9DTvjPcKOY9isHWfbGDssmGjKLEskFAmDOMsKnZN8RE8hVlQQy?=
 =?us-ascii?Q?RM4xSen+EhG/8FkcA2xTjHA2lA8pwYgw6kdik7/VOHk7rwWg+tw2wSwDJGY3?=
 =?us-ascii?Q?D2wIO1uxRRIevQMZdnlL4QuR/YNn1Iv5HQXjB71NO0ONupVaKdjMsLQiGZZB?=
 =?us-ascii?Q?Gu+FKo7pSxLZBotHHUoEFMB0d08UPLyDLdtx0OMLFZJ/lcbQCP27oCeopy5/?=
 =?us-ascii?Q?kouskX/yovbN/JMcmom7pQXC+CbdM4UusJB9S/WSwMwnOC6j3mbusD8IAnuH?=
 =?us-ascii?Q?a3CKjht3kuoa/IDVZyH59amWYIPovT3j3aehSdA7hqkECaWIASe1abwRQADq?=
 =?us-ascii?Q?/Q6DTXWtM7q6hwoGNrxuRrVs6VKQh3P3xGnR0x1/7FHXukARFna+drByy9Zx?=
 =?us-ascii?Q?kM7vcJWIsRjmJmPvb9eCEY7YVQlGLrQS/y7MWxY155vxTA60BHtgPdvh3nhO?=
 =?us-ascii?Q?EMZR2oWGgtZzrSEus/CiQkjSZQ6KZqLwqkbNSZAHgH1akjlP7KePuvs9LJ6v?=
 =?us-ascii?Q?/DuNAkV6Tfo3MC+RPjCDSQ46a9Ap0142vZExfuuTbD6nkRPiYQzDzxS4ndua?=
 =?us-ascii?Q?5cF4FuVtMXg7XqhKvPkVP7x/WGF8Oo7zjVnHsOBd7mS5qFC9ikG0Kex3IKD6?=
 =?us-ascii?Q?EcOer4i/wQm2wMSuxTPSvjqIKROjGWmZUt6kd/jx/vWku+paYH3UDWPeGieA?=
 =?us-ascii?Q?4mYX+eKNrPPN/MePn8CbkD8AL6IzDtoSUuwIDHPhTHGditIliCErPW/Ahx8r?=
 =?us-ascii?Q?Z3TwQPcrJKzeNSPZqbeURhDr0Vi7Anoujx22BpUgpBh3w9RqzenhJql7vPI7?=
 =?us-ascii?Q?88UM7I6ZA0zDt2S9lGn5BKmsCS470lgznEZgKNLRua92/TrT3QPwEEnJu/B/?=
 =?us-ascii?Q?4RnHmgPQTRZhAxCmRQjKpBb7TcKp7zdiDuBnzCB/uvFUzkl+eYHNxfcS+C95?=
 =?us-ascii?Q?7qYlfFZb3Rdh+0Pp+caN8IaZeMKRh1Sb7yTaBd4tvt8l2r3IXijWnQTr32IH?=
 =?us-ascii?Q?2iWrrxu962ci2WKGxRes3ZIZtivw5x74e4FDYoVIo+piKRjIOM3TUh/PtHqq?=
 =?us-ascii?Q?a7+1siz9+yQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nwcmvqj8StID5nm4HEUHNq9UqO4WCqqT1hrvBlYScBAEVleFYFeDbzVK/8S9?=
 =?us-ascii?Q?p7M2Az4EVmphR9JSjewQ4ggdWHM8nAvPgbw7GiHPxOq/b2nqjzq3zQdlA2wn?=
 =?us-ascii?Q?d/s2GfB4BpsxRrCzPB3tMr7mkEWlTyZr/R9V24A8UnXBvwq0WtSHPgCn5BOA?=
 =?us-ascii?Q?V9QTyuYW6kTDgV0yjMgw0wM1pcQvSfBM2rqnG1mKIkS8CWAKV9SB6d2ObtEi?=
 =?us-ascii?Q?ckI31r8Cx9GM9RJPF2cpRqaHwaqtnmOUVXATMq/CzzZYnBSj/J0HuDGtKkkv?=
 =?us-ascii?Q?HWHgc+DMh6F1t8Z+uKqr4FNUjelHv/DvDTIPHWRw9fRl/zBIjEpjKnoFl9iL?=
 =?us-ascii?Q?ImSCuOjYED+ezi0Q60CfEXTufkSseA+/WvOVSruKIWvhClc7CJhwI2lW4hYq?=
 =?us-ascii?Q?OJMgrJEgjL18P4zxilm++0tGOvXMualb5wShK4VvHY0qPGiN+s4BLAsqvy4W?=
 =?us-ascii?Q?+q7BWKrEG8VcS/clKJOa41uJBVqv4bhFtAcqzGTa1ifuSNwGyIVz2LyDiEsg?=
 =?us-ascii?Q?sPn03AyCNz85jnlg3uoIyhgR+6FhKr9MpLNOdYq3SgX5yfPtL9jYuDU6NYNZ?=
 =?us-ascii?Q?MPIDrecKbfkLClWtxnyPSxiQUrzWDXuXzDLO3urulDqkHXzJD9wHwzUS9o4P?=
 =?us-ascii?Q?mhGqneDyYkOI41/h4yxKNfL5VbrK8zx+bp6ZRjiJrfFvssVhmcJnVfATHB/l?=
 =?us-ascii?Q?05KWM6rHmIADOdGtJqJMiRTVSE/nHFdfIlw0D0dlM7ONW/IHay3qWOyi0ce3?=
 =?us-ascii?Q?keoc0kYryws/lOOeiVwSTg3NLF9Zsg4hxDpPrhrEpPPtRIoW4rpc3HMa97YU?=
 =?us-ascii?Q?FJfo3CDDRC4lY+uwpuvgW2Xuyz2QA2P3pAFT3TAkB4q3demSSeRm7Oyd3YhO?=
 =?us-ascii?Q?UKIn7Di1aNZAUaoqT1W/LKwVNBYytDwoIBNzlpmJ/iBo+RUvMcuFblkgQn+v?=
 =?us-ascii?Q?NB0KA4apR8aoF3wDkMEm157mTGRBvDH/kl59NSmfKXpGOqqV4mWYsFT6TO6Y?=
 =?us-ascii?Q?zOfsyU/kZp99q+XP5Sd0eVPYpr+aAEWPuTY4e4hG5jHaffpwbQCiGYAbA/2k?=
 =?us-ascii?Q?pYBJjBugSDKXAGHCEyUrdU4CzTBrX0h6cBWNWJbbzCB+c9O+s51jSWrWajkc?=
 =?us-ascii?Q?YYNbaCS/yVw8YH6nJrxyaJHC2MjWocb8qHRTgyigPWqO1vffOKwc3PQldLtz?=
 =?us-ascii?Q?stNUWNXYFkfs9yy92XgfhyBcAxSHA2/og2UH4D/alr156rdfrgemjDWUGNs1?=
 =?us-ascii?Q?kviVexIW7FogrPS14QtZ5QMip86eE8HONjynvpHpPHKyPW1OE4+hVbatAh5y?=
 =?us-ascii?Q?/EhuGwPwQO4+ssh3tXDDQTvWOE29i0grMLN0Q2s16w8FkogjI+c5lCWJA59G?=
 =?us-ascii?Q?bYtnOVb28MfAP+lqGA4JOF0U9exRhfa7aN3lLPZoxUgBGQsrr3kC+OWDJTxV?=
 =?us-ascii?Q?Yrxyctod8JJgyF76AbpDAtQxLPKBpYqxaSSBJ3h3dz3XN68GGvDmviiB/Qg4?=
 =?us-ascii?Q?06c0a7sK3qRXBGxRx3UU5EPE3/FpCYZW6rsvru7o/is6UamS+QI9JwgztQv2?=
 =?us-ascii?Q?S/ECxGLSS3fIKh99tzcbuxIrRWVIKM7g8uKFOK7Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9b2172-71a8-4726-24a4-08ddf7978314
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 16:13:47.0503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SQ42WVoktzrXLs9rXE+QAwxa4sRt4vT74Bob1jAWRX81DqLMNXDYN8AYZ0uWZKw5yx819puW0PSfK9pkq/sNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8474

On Fri, Sep 19, 2025 at 08:40:15AM -0500, Tom Lendacky wrote:
> On 9/18/25 17:18, John Allen wrote:
> > On Thu, Sep 18, 2025 at 09:42:21PM +0000, Edgecombe, Rick P wrote:
> >> On Thu, 2025-09-18 at 16:23 -0500, John Allen wrote:
> >>> The 32bit selftest still doesn't work properly with sev-es, but that was
> >>> a problem with the previous version too. I suspect there's some
> >>> incompatibility between sev-es and the test, but I haven't been able to
> >>> get a good answer on why that might be.
> >>
> >> You are talking about test_32bit() in test_shadow_stack.c?
> > 
> > Yes, that's right.
> > 
> >>
> >> That test relies on a specific CET arch behavior. If you try to transition to a
> >> 32 bit compatibility mode segment with an SSP with high bits set (outside the 32
> >> bit address space), a #GP will be triggered by the HW. The test verifies that
> >> this happens and the kernel handles it appropriately. Could it be platform/mode
> >> difference and not KVM issue?
> > 
> > I'm fairly certain that this is an issue with any sev-es guest. The
> > unexpected seg fault happens when we isolate the sigaction32 call used
> > in the test regardless of shadow stack support. So I wonder if it's
> > something similar to the case that the test is checking for. Maybe
> > something to do with the C bit.
> 
> Likely something to do with the encryption bit since, if set, will
> generate an invalid address in 32-bit, right?
> 
> For SEV-ES, we transition to 64-bit very quickly because of the use of the
> encryption bit, which is why, for example, we don't support SEV-ES /
> SEV-SNP in the OvmfIa32X64.dsc package.

Ok, I knew this sounded familiar. This came up in a discussion a while
back. The reason this doesn't work is "int 0x80" is blocked in
SEV/SEV-ES guests. See:
b82a8dbd3d2f ("x86/coco: Disable 32-bit emulation by default on TDX and SEV")

So I don't think this should be a blocker for this series, but it is
something we'll want to address in the selftest. However, I'm not sure
how we can check if we're running from an SEV or SEV-ES guest from
userspace. Maybe we could attempt the int 0x80 and catch the seg fault
in which case we assume that we're running under SEV or SEV-ES or some
other situation where int 0x80 isn't supported? Seems hacky and like it
could mask other failures.

Thanks,
John

