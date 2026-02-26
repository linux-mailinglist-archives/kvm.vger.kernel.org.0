Return-Path: <kvm+bounces-72068-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MyINmKaoGlVlAQAu9opvQ
	(envelope-from <kvm+bounces-72068-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:09:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA271AE330
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D4AC530A893A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE05342B75F;
	Thu, 26 Feb 2026 18:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ix3TDIy4"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60F2D249E;
	Thu, 26 Feb 2026 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772132219; cv=fail; b=CS4Ac7/tVCxohAHsV3QFL0SYZJNfKLhF59EpA509V0+9ivBsaAVvP9zj5tuM/YwTanh0AWRmXWxsg/sRPRwX0lFpJacz+p36MIGz2RiyJOnjJoEqO/ApHgWSsbINfNq+rF7xOvuq/N00EpuSfjEEIBep3Ya5ftxzGFaEgJ++TMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772132219; c=relaxed/simple;
	bh=IjVYoIV9p3NtCe4bA/DWbaCmz4wTLbldOo49DQMbSTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Wgy6rZ9gozKcTpVuyYici06t7wC/kaj6qwdoucUt/4mLGtHOLR6eIUEd+ayJILh4ilC0VBAw6TUxoa91F+2gH72iTffxMcNxqPrG2pQHJRF4QXnlSQj0gv0mzpTw38FlKhAVH/UB3DgIU+fmjw8hE6AygPaQR8Io27aVeME3L1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ix3TDIy4; arc=fail smtp.client-ip=40.93.195.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wd3ZUH1wIYJzI77XXkhHSlEdKDiNZK3/qwi8HPJeKvxCroT/7NyGIhmjTPDAKtD6yDzh73O2ZfKc6RbPjdLxLq69GfdGv68pydHB2T3JcJ1U/hOP0rmKEjEn3POYLKubVFV7nqvC735v8rbGZKEP8gXzDJI8l3O5ThwZ0svBIivzorQnf1I8WH4BdZ0itjEJaLQWwaCn7k1Wa6xevb1r1Ut3xSJ5Hmqhu2xAecFoLQs/MbtuyTxuw6dV9hOrJh+rlKG+MoEYpdjlCuXE06NVGJfNbzuAvoGrIrkDfQQkAemOIjWPWOSGR626qzxO9P2TxkXVT0EGv6Vp6K3YNY20Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjVYoIV9p3NtCe4bA/DWbaCmz4wTLbldOo49DQMbSTg=;
 b=uXyrKKEyUB6EqO2X3oIsowocEUkZk3lBKtioPDm+NaEByVAHckuLK9nMUkex0Y90HCqyBhQcnJTbJg0ILXflBT9PywnwIgbzFD68eQpYedGJUOEC3hNWaT3Tb0iWMmFTSGKWGZasjqKhOzKq7cA64IUICdMYWNGLTNf9BZLZVkbZHEixeJ7yZWYfjas+Iboq0waYct6VByY7nTLFl9k9wG032mEWexi5F5JGbOTJnhdNexFnA6gfEzfD3ah2O2vBmawYSsHIFF06xO5M5aAnvUxWAbgY3sySy5L1DqelqjFrXpiTgr38P3fjgc940bRdDHzu1eRUF1j6XwINr8YlpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjVYoIV9p3NtCe4bA/DWbaCmz4wTLbldOo49DQMbSTg=;
 b=ix3TDIy4YN09gdx7qjHr59ceUUEEJn9UX1t6C452abuFUvwNvbESKYAKnSznvKRKFrhGkPX0tYIIziFbqCPI+1X6KZFPltU4C/Cl7wxiVtVgwJfDx+Rb+M3lovUbF51xfY2LkSdY6ADDREZ5+AIkD+x2NreRMj5Sboej2oX5LMYawT7qCXF0jlKaqe3txf5Ev5TwHJoMvDVYPwBxZPBsnhW+hUke+oCghDBHMm8XPSEOzng+dKjQIrWFjd7ZbUEhUwEP4gI9ddu7GzqZmQANHZZ4idFWpu7hFWo2FIt3HQ3dd0YmVx/sB4KrsFCo2WxhFK9BIWID6+iBWhqgf2uKVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB6666.namprd12.prod.outlook.com (2603:10b6:510:1a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 18:56:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 18:56:54 +0000
Date: Thu, 26 Feb 2026 14:56:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>, "alex@shazbot.org" <alex@shazbot.org>,
	Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
 handing out to VM
Message-ID: <20260226185653.GG5933@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-11-ankita@nvidia.com>
 <CH3PR12MB754812AD77FF9E02B0AB2F1DAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3PR12MB754812AD77FF9E02B0AB2F1DAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0047.namprd15.prod.outlook.com
 (2603:10b6:208:237::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: 11db3d05-41e4-4050-d2ec-08de7568cec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	hLKzLeKfDbZ6iAbDpl/043ulSsklj3qrlDi0tjK98Ki16V+1m1uG0BFSqXFy6U+/3osM4mevedfVXx3TyFJlO4sUFnwmjPBdteVs10SOqPSysqJxRaZkIY85x3JVUdFkwb+To0PhKANjlDdeP8eMACV+Ws6q7QiXhi+44lY9su7Pkza7qucpdqSap89aHTQGSD/aTTIcFmS0lTBF+KGdjbPIZ8NquTF0YDzNZkMIM+ldQJN0staFZxNdzCgN18hZOHB1C6JqD5DLxlPuuNLAQUcvywbJEMKVXsH7uSRQD9FltDkpVV4VtVqIXi5AJ27IdFZscg+cw0KqX/aqSOwCoUi2RFXoYnYppK2wLI/fbjfCFJtnrrzN4kbUloZQtJ1XtF0DZ0/igx/sulvVxjW6B2rLkKbjv6CLZPoljezQ+wh45AJY/rp4lUP0u6HnzM89/NTxKxR0zEQ7omXWL8N3s8dGxL0RtVGjz8cH0TLfOf2nNg4xZtFJS3abRzRWc30JIlQB203nEbjNjNCdha47f7EB9qbzvEfDDvK5/JHtNKb/YbStLzsuOMEcOpXUTjHVSRA7yLE+sgMaBGD1kEzQS0EECBlT8yiCF2uJJ1IfwnKJlN8rwsNM8h2HtnJSy3kneZs2UE30zR1udqvD4o/bxT04+Y7eR7e/bPTH+zkED2VfDhhr5pZUUeQ+O1U5mnjqkRGdiLvbx6jj+pxTvGHqxdsvyIepT7ei9kdhSDTi04g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QvMcgTAqjvt2IAbhMCdNQ0cL+fQ7W74cJGRUUikA1E988MplwOsGuy7LOBiE?=
 =?us-ascii?Q?tvyPp92SoItMS35QNyL1DoP0LkhiFMdc7jDhsGSw1jXGDmSwCOfvoIThufaG?=
 =?us-ascii?Q?zox+EhLH/QoK3dSb7rLbJg9zgMqKlCovFtpBVofXnyVJo1QRIDs/ruF2RpxN?=
 =?us-ascii?Q?V32M6aHT5ltv8Tq1IJ2hbKA8h0e4xWB7JmBfAX50BUnyBgLck7vHYFNM4mLB?=
 =?us-ascii?Q?xuwulS+u/T5aPKbQ7eF2P2WzaKSWh8blS23f/5I7xNU3NdX87miyrgILvPgl?=
 =?us-ascii?Q?AtEqr8Z73KUjVjZkDOuFNdqc7owa0QbqgvZPXgHWccaka8BzhoG7liMbEP01?=
 =?us-ascii?Q?NHMkjWws/5ouNlCgQdICXDplO/JEcAhh/195QapNSGEvDJ6J/JZBmfQbjPsG?=
 =?us-ascii?Q?m9piHruqphM/ZoB6eAvs59evhrTgueRDcKtVj0uulQgihSkGiRfOzt2f5V/y?=
 =?us-ascii?Q?rs4DKLN0wouYamFQI4bOWsQywL6nGRK7y+YPIV1l/TlK4UyaVMGWQ9t2+/yv?=
 =?us-ascii?Q?f6DuoArM+WDv13+NfnXb1VZJjQUrI5I40rXqigrf9EtfjM/yhTtT+09YjpKh?=
 =?us-ascii?Q?mroW/E5f7Ud4/eJ2R8gFPjQNigNGPtqLazMgAEfeUI7nYp7DWdlMwbVqelY/?=
 =?us-ascii?Q?jjpH0wCpmsaOKnlKLFRkVindEeo56m9Fn6+vCWy7yIPaCwOb/IXstzzMULfN?=
 =?us-ascii?Q?ZLmftPeOu4SnfJxDi9vMblhrmaW6WMUPzklyx9FVdXUxBQn+kHK/uAE/NhbA?=
 =?us-ascii?Q?tqTZIGs006690Qq87XTsIGH2wKf9WxfcGKjz3rsSx0jgVf5aXZBQpHKTOZ1P?=
 =?us-ascii?Q?qkJxgjS+HDzVlIdQZTwTR7mKEbnXxkhTjKQ9EgY8ocfzEVX90WtxaKy+anbJ?=
 =?us-ascii?Q?bz+yFEZiZuZcfSC6/VWtawEmRM8ib1XEav08CG7qmPijhanc6wZLkpw1+lNm?=
 =?us-ascii?Q?k6NzgmfJEpJnK4+WqSluaJiSah8Tt363chvJkI5FqRh0B+8VOGyVQJeW/wcf?=
 =?us-ascii?Q?tfNPL2RSo9iWLCh2IL6SEm1YQlphvrZMr1Vs9yXuwUaN4B1+rbspTRKMsUOF?=
 =?us-ascii?Q?RfvkGgcZTLRD9XLnuPmzsyc9kpXDPA0b8pJROlvQsUETNdQEDcSKb7RWM9j9?=
 =?us-ascii?Q?OnCfPG/1rKRg5JW6Tq0UZqAmgdyA9Y0ewIxro5f1GY6rE4ZBFQcwFtXHZx45?=
 =?us-ascii?Q?UNTJ4Bgf/sotbQHKaUpteuWzag1YuGgpNM57gNMomFbn29398mw3mp1jSMUi?=
 =?us-ascii?Q?v/yF3Wp4K8D+MPwKo5Eqobr8MNUN21v9dbUMvuaC9eRngiyRsqEAloTQHsNc?=
 =?us-ascii?Q?YQDBqobAbJme5KEg3hUGN2pXusMTMyEEDYKX1aW/MxWGkepmZdi8u1F4uK6y?=
 =?us-ascii?Q?+xSpsfnQGYf6e8IYvF2e73H940U1ehPrI2A7UvVacHcyxcolZrkaO+kUgXXO?=
 =?us-ascii?Q?OD6qPMAvRX8HW5VYX7hhYd6Fp/0o68QZl3ybWDSfYa5Lecr+aFO3vj//4gA0?=
 =?us-ascii?Q?INC7gmsaCAFWSoxWrMeV9vkfdsxfl+eNrs97Nzj0FJQw3jnTQ2SDsZEYQp7E?=
 =?us-ascii?Q?0Q7sCpU5MXQZhvER4SYsWN/0S+E7zyu8utUzEMSu9M4t2Ds2AneLEUcjJ1+v?=
 =?us-ascii?Q?5xWbxsO8Yk6MzpalN8SoiIVgWVyatcExmzL/u8BsulZ0pp2mddO3XSJsEQ1a?=
 =?us-ascii?Q?me5Zg5KWGTQcsuJzf9uoVNZ7ShR3VkldO4ufuKqVHSTzFP/TzH1vXMoW135o?=
 =?us-ascii?Q?hnKFf0UjcA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11db3d05-41e4-4050-d2ec-08de7568cec2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 18:56:54.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXIZVq1Mb/Qwfn/kv4RIvSWuAMdo+qs34O7TrY7/swrtSRYsXnrWLgIxIHh+wlVx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6666
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72068-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 1AA271AE330
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 06:15:33PM +0000, Shameer Kolothum Thodi wrote:
> The mmap mapping stays alive and accessible in userspace even after
> the close(). Since the release function decrements open_count on close(),
> a second process could then call open() and wipe the mapping while it's
> still live.

fops release is not called until the mmap is closed too, the VMA holds
a struct file pointer as well. close does not call release, close
calls fput and fput calls release when the struct file refcount is 0.

Jason

