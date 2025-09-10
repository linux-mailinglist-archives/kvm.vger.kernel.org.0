Return-Path: <kvm+bounces-57204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABBAB51AAE
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19640581985
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 14:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293C1335BAB;
	Wed, 10 Sep 2025 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sIiyGwbP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78152322A26;
	Wed, 10 Sep 2025 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757515567; cv=fail; b=K8K42hWC4j4d3H9N+n2zRdb1CgrFwrsgi7DEfQ+MYtIunb7rItNtTW1PRpO4MNbJ8RdnJz6g9oA4Y1fkjNWFt3agr4yX0s1GUQeU5h0jdLwF/6Q25Hhb23AXUa/ngFye6LPeWB00Bom+w8ZKdWWOcUiaeTQ6i4nWPLK+tXtYIZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757515567; c=relaxed/simple;
	bh=uRLIoHIwFFGtBkb744DP24qQnNRRhvp97sNjxG350jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mluNOY21dzlBci2GGjK2oLMJ/kOexuH508s8jHSEm6WU1dmhJ9fPKcTacBJzfgTQpvL9XQ2kPL9OnQEcPTlREePGmSXVxoLse4K6/fBSPaOvyn1h8ms8M0IcrCk1KmO96fTT9icKNa12nt+jYmgFDYXW/RfOu3bZFRdroUziH0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sIiyGwbP; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQYgIDs/sNZUKvptknRllknhFu92wFpnssh6ckZAYKKjEos005U452/Qh6xSsB6DcOBquzaDURO/nDdYqrkNUD55l28Trgze2zjTraoL7Mx0kIfqfjmjrP9yGP0RCTxFmcJYcx0ABCD696o1SQc1Zr3TSLbfk5PKW1gFWpJHolbQeCawSnBhH+cqht0sIIxj/jB/n/FPq717Eq4+9QrkbX4qEVq3KQynOhaE25y6CY+URbjPMCKiy3LUStFM108syg4g2uygqhPHC2yM9FSAmZVpuXXcJprlPBkGHva/NLbfOqowyonGwfBYNWEyRE587bBMgaX5D4UqQOgkBl5t5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GS/HhxjUNWWUBSWYHXDpo04B+VfNj/i7NDijkz7gQYs=;
 b=QzjCbn/udIBd0xifgQMraOLJKU9GgHVA1t28iAiE78UJckaXwuVfEpvMMDKPsnywUDJOEYR4F+B982nTK88HcxbkdCeC+XOkeMrgR7usKqUO3jFiGOJZUnjlQTdMefEnz9xwlB3pyguDh+yGYIz2gJF2cA2IYKDqH3JatjA/jkpsZssYbKM3VxsgS3+xyba6Xwfa6dqqYsqMFYa+TrbOw5CXZlrtSXuJc64c5YewFjBey5Q9ZKrAYMqIWfFv9FtKRE1JFxC/rEOYjAG9AmvUQS6ip49P9Bl9bssWP6XXuIB8nekgEr4agktJHEyoR6awXYYymdfGixJEcyXmjJfWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS/HhxjUNWWUBSWYHXDpo04B+VfNj/i7NDijkz7gQYs=;
 b=sIiyGwbPJWLXXb11pT3KWS4GYhxeSXagrteT0e68BPiVqeet3bPG6zdxA/g+R+VZEYDG4Z2Hpye61SVeRrjRIU7+7R79YJI6UWeFh/hWZB3lYAzGP+18ZJUWqbxFDt2d8hQvhdv/hYWEj1iz7f0VluYJnlV2MQKaEbDsPqfAtjBBoA9nTfH+d+TzYQHRKDXg1RWj+Q9VtvBLyviOUSKPTaQ+w6p7iqHqWYMP3lX6J9/RYb7+6Hw213lF9KqrixtouOrdgrj39yrlcG44MTQKO6AxBYItxG35OvDeXnTsARYYrfLp/+5BuD1Nb6laacth2mzYbtBmOQMXCuhKE+VYOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by SJ5PPFC41ACEE7B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:45:57 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%3]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 14:45:57 +0000
Date: Wed, 10 Sep 2025 10:45:54 -0400
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Mukesh R <mrathor@linux.microsoft.com>
Subject: Re: [PATCH v2 5/7] entry: Rename "kvm" entry code assets to "virt"
 to genericize APIs
Message-ID: <20250910144554.GA563958@joelbox2>
References: <20250828000156.23389-1-seanjc@google.com>
 <20250828000156.23389-6-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828000156.23389-6-seanjc@google.com>
X-ClientProxiedBy: BL1P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::9) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|SJ5PPFC41ACEE7B:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d397e61-da5a-4d07-617a-08ddf078c037
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lBJ1mftQXlMcaL0dEq2p0usWYqA3/fZZoZoDYKEdYljdF1JHeSI3IbYN8TNQ?=
 =?us-ascii?Q?I7HbQein0kFG+OlpL20jCWiYO4pWUtXgOLbx+ldhpYn7AoGLT9GqRj+nvY3j?=
 =?us-ascii?Q?9ltZg95twIK8A7NcqdEidVZYCg+JaC45PA3SvTiD8uikBMBnnt00L2XxO1PY?=
 =?us-ascii?Q?FJToTiNdkS0x0QKJUmauRap3MLUdI6qMFkvblMO/HT/oYnLJ2SRF8Bil7JE1?=
 =?us-ascii?Q?IZ0hJv91zGM5yh4Qh2CtDSqcceMIxZAMlI7eofuQK/noMZ+EMH2OVwIHJ7lI?=
 =?us-ascii?Q?C6XNOSqk5zBwsmVnUUFMMDISh7empJvTyxRrVEol+Jw5D6xalDyC8WMFlg/t?=
 =?us-ascii?Q?qofaX+8gv6EYwKMgwUf9rx9BeNf50tpc6Ztz87W10ty6KzsqSxe3IamcBHLx?=
 =?us-ascii?Q?+IFBdJUnb4CZga4t8bQfDRgAK9W+GzunBDPtoOPABR8AacITyYavxJMXe7XK?=
 =?us-ascii?Q?InVOXu/z5l5jf93JQZouFZk68SDn0TqY2HS/+D3I/Bi19jzcrEbUpHZJOdTI?=
 =?us-ascii?Q?0FxYtQu1As86jYhUsnnokCcyq+msUvSwOQ1Q35eCrkIIf+VyaPaNZ9M0OaKx?=
 =?us-ascii?Q?aLy/aor51huel7nx52f6sqet0UCabae2NnhmUVNbIONz0bSjCQjql7fj0oMa?=
 =?us-ascii?Q?E0Yim+V98PLMqMzzO7jJelSdN7a+tUB8US1YZpqj7I9L8bbA8HGdG5S0QHvt?=
 =?us-ascii?Q?muHH8i0FNx2GDYqLBvTL386vHlM3u8Wkl0fgSs67UMI6fk1Y1kcUglPAnmB0?=
 =?us-ascii?Q?5YuIZ3kXKH3pFZOeDT7NdMAsqEJPLKeJEV6osyFlpv6lmlPQYrsiiJJZ2TrP?=
 =?us-ascii?Q?C/cbOWgFhtjO87U1KGZeYH1+Agjw6+RvKdT6taCUUHUroMVqk3ABeRd3Y9te?=
 =?us-ascii?Q?Waw5DmlJlliDZmD/CoW5NNWSThvQ9JgWj/y0swW8zdq6ocIoqtCmJ07rmL3b?=
 =?us-ascii?Q?hQ6fGhuiHoobrn2F1AP2ybXGrBRtfTUhOU3m84/wBkU4XYMYBdY70mKJZjTF?=
 =?us-ascii?Q?UXkevQaCmIIlFljHRHCnm8LX3SsT1eezPEcvQMN1G8lm2KWdztA/bsWCo2Tb?=
 =?us-ascii?Q?L50NVM1UxZ8m2gyDvKeZdEjDJenFPl80FUQxyMCb2ry2lLGlsCEjW0VcazpZ?=
 =?us-ascii?Q?Skf1vr6qrpOmGfoPTBsrPRAlqRAE75EpsqSAPXkNm8W+h7lGfC4atHH8s9BR?=
 =?us-ascii?Q?JfzZLzL5Nn+imODqj1SkfSo8RqfjkXhTgTDmC321969fUyM64ZQqQBdPgJk9?=
 =?us-ascii?Q?QdvelXW3m8mjkk39lSYzPWQoBIDMad5W+Hu/Z/VOeS5o5qLmE1hPyjd5JVmk?=
 =?us-ascii?Q?/k2/a8exVRHidMiLtwvUYXbiTgJDYhvBKl+fgXVY4ndi1GEmTqgVNDqJyikX?=
 =?us-ascii?Q?cLVIcwM6olbaezLyMF7tzt5TamPkJ66ojyaVSRqQ06yeSIHIEQfvaBkBZfXN?=
 =?us-ascii?Q?qCezkY0+/fA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UJsfAHztgoECTlOO9AxpQTX3/m5ix6H2GCaRGnYkNL6e5Xf667NMWTOhLXIg?=
 =?us-ascii?Q?vlnvmhwt3biFyD7WYKjXHc339cFVD50fWB81kLavwPqI9/aaQ+QjaBGD8+Dn?=
 =?us-ascii?Q?sD9yLpnW+TYYYjy3zNTwm1q7AmKrhbhW95zrZuXb54aO0SH5YV4ssi2JIwX3?=
 =?us-ascii?Q?IDua9rwBZScxB3LQWOxy/B0Pz2vpIr2cWq2owuHrgSPiqU/HwZCIdr+D72Kh?=
 =?us-ascii?Q?ON7miE+ZT7FtgUcJW/T/Fl5YfYCcBIX4I665Knvjziegu+pKueBe1Yyqdg6Q?=
 =?us-ascii?Q?GyWwZHBPdFAYGXXSf4EJU0p46bfsCn0tDt4o5FsOBkgb6nhJsgixf9o6CADZ?=
 =?us-ascii?Q?ASAEpgSw31j8vKhOKRMSMXxEzaUKADyw5IDnsZDnxNHs4yicR0/1NmtoFkyA?=
 =?us-ascii?Q?dT/34dEmGcGmtrV/u14c81pAnR2oi+Bmd6zkpeMgl+CJ2xCDyrz+dISqHy6j?=
 =?us-ascii?Q?WDHpvIpdbk3BzVHtm8UwGyF6r09LOJelkTiAseHN5ETIHhIn5p7kSKtmVqIc?=
 =?us-ascii?Q?lQkEHNNj/mRTqtvVYWKJReFMSDzKtYbrZMgkDLJz/V1jTcZ3D2SFZkMbnlNV?=
 =?us-ascii?Q?sOSHr8unvocM8OJx3qZqXOffmwzquZEjJFJqyNH1aWVCv1GQ8JccCwArCBj8?=
 =?us-ascii?Q?3+uQBuePtboGi/lLyxbWYEVyRkmORVyY08kOjb3Ev/E2lHCcnaMixALwG+jy?=
 =?us-ascii?Q?VrGpnN3kdww5OKF9UlSMRgaZznX1G2JpfJ33zolBIZs99E/8F3PwwE1TCVhf?=
 =?us-ascii?Q?5oZ8N5B8yqjGiUiBq7/eEvG84BDsRqURauHWcQyoAH04sbALtP8Mc0Jlprj0?=
 =?us-ascii?Q?pBBf3JyFuVz0BXIVZ4bJlJ0P23MvX+1c9BbillsrQIlbj18EsPjW3aSsQi94?=
 =?us-ascii?Q?JkweTku7PpFPuU9YP2yrgVev+J7cIeSUZryMDqC35/JohfXZMzYRQEDB3rYV?=
 =?us-ascii?Q?1uiXMK8Qwcg6EDsw1dLRBhkXp0RkU2YyRnKvhEVsFZUuAwbZqImsIAO8rGA8?=
 =?us-ascii?Q?rirHIL5GJrfxut8rsFhHs3sYgNHw1ho9R1rw/OL97wEYQaAPDmuWaupYzGuN?=
 =?us-ascii?Q?A5W8hOvwcuF1mGmkdfBylXKw3pqZgydBucVdH/CnTUNj+/oxfo1+xxSwb8VS?=
 =?us-ascii?Q?9RP/gSdspzFrByfiOswg3w36bsLlWQhGIAsDwI9h+Xy2Yrqrgfzn2ZaD8tDj?=
 =?us-ascii?Q?onW17E0hBCNKtTIEIbWNFi5cAEsS9kfWxtKQWoBpJVKGPiNC1Dpxz2jiC365?=
 =?us-ascii?Q?QfqJSEYFWFKYuemeW5KZQqOI/AxHMy5SsYEtlBbRsAZ0v609CQupG2ajnek1?=
 =?us-ascii?Q?4bQT5U+rPrGB8nMBqy5p7MBfysJNXt3S9u2ZFT7bTGuCdsH0YXC42euYaxpl?=
 =?us-ascii?Q?UpZsGq65gKSndA6hC3yFFOHsG3T1oesdpe6yZvwWuGjCI2z5rRjRZu+GxaCa?=
 =?us-ascii?Q?wS0yPwwnBBh1HLdYYB6DIK7x8qtB41zhabCCVjlYvmEdeJ5qeik9bviQpN1r?=
 =?us-ascii?Q?9U0AulckHw6Msn8qCGOE8PjSXoR7It5yYsaoQ48XvUSmBPZ0wqRc8UkEVALq?=
 =?us-ascii?Q?UariTFoEMwTB3crPDdPenrRwRarWFwC9X22y0cTA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d397e61-da5a-4d07-617a-08ddf078c037
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:45:57.0130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohVyGPNn74G55qtyxmdCEEKWLQ6b8hbS7a05yyTQfmTfC6W/VO+qETLpxI1/NQC2UTL1A9FvQ7h2cySDRJzVhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC41ACEE7B

On Wed, Aug 27, 2025 at 05:01:54PM -0700, Sean Christopherson wrote:
> Rename the "kvm" entry code files and Kconfigs to use generic "virt"
> nomenclature so that the code can be reused by other hypervisors (or
> rather, their root/dom0 partition drivers), without incorrectly suggesting
> the code somehow relies on and/or involves KVM.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  MAINTAINERS                                 | 2 +-
>  arch/arm64/kvm/Kconfig                      | 2 +-
>  arch/loongarch/kvm/Kconfig                  | 2 +-
>  arch/riscv/kvm/Kconfig                      | 2 +-
>  arch/x86/kvm/Kconfig                        | 2 +-
>  include/linux/{entry-kvm.h => entry-virt.h} | 8 ++++----
>  include/linux/kvm_host.h                    | 6 +++---
>  include/linux/rcupdate.h                    | 2 +-
>  kernel/entry/Makefile                       | 2 +-
>  kernel/entry/{kvm.c => virt.c}              | 2 +-
>  kernel/rcu/tree.c                           | 6 +++---

For RCU part,

Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>

thanks,

 - Joel




>  virt/kvm/Kconfig                            | 2 +-
>  12 files changed, 19 insertions(+), 19 deletions(-)
>  rename include/linux/{entry-kvm.h => entry-virt.h} (94%)
>  rename kernel/entry/{kvm.c => virt.c} (97%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe168477caa4..c255048333f0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10200,7 +10200,7 @@ L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/entry
>  F:	include/linux/entry-common.h
> -F:	include/linux/entry-kvm.h
> +F:	include/linux/entry-virt.h
>  F:	include/linux/irq-entry-common.h
>  F:	kernel/entry/
>  
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 713248f240e0..6f4fc3caa31a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -25,7 +25,7 @@ menuconfig KVM
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select KVM_MMIO
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -	select KVM_XFER_TO_GUEST_WORK
> +	select VIRT_XFER_TO_GUEST_WORK
>  	select KVM_VFIO
>  	select HAVE_KVM_DIRTY_RING_ACQ_REL
>  	select NEED_KVM_DIRTY_RING_WITH_BITMAP
> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> index 40eea6da7c25..ae64bbdf83a7 100644
> --- a/arch/loongarch/kvm/Kconfig
> +++ b/arch/loongarch/kvm/Kconfig
> @@ -31,7 +31,7 @@ config KVM
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	select KVM_GENERIC_MMU_NOTIFIER
>  	select KVM_MMIO
> -	select KVM_XFER_TO_GUEST_WORK
> +	select VIRT_XFER_TO_GUEST_WORK
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>  	help
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 5a62091b0809..c50328212917 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -30,7 +30,7 @@ config KVM
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	select KVM_MMIO
> -	select KVM_XFER_TO_GUEST_WORK
> +	select VIRT_XFER_TO_GUEST_WORK
>  	select KVM_GENERIC_MMU_NOTIFIER
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2c86673155c9..f81074b0c0a8 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -40,7 +40,7 @@ config KVM_X86
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select HAVE_KVM_NO_POLL
> -	select KVM_XFER_TO_GUEST_WORK
> +	select VIRT_XFER_TO_GUEST_WORK
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_VFIO
>  	select HAVE_KVM_PM_NOTIFIER if PM
> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-virt.h
> similarity index 94%
> rename from include/linux/entry-kvm.h
> rename to include/linux/entry-virt.h
> index 3644de7e6019..42c89e3e5ca7 100644
> --- a/include/linux/entry-kvm.h
> +++ b/include/linux/entry-virt.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __LINUX_ENTRYKVM_H
> -#define __LINUX_ENTRYKVM_H
> +#ifndef __LINUX_ENTRYVIRT_H
> +#define __LINUX_ENTRYVIRT_H
>  
>  #include <linux/static_call_types.h>
>  #include <linux/resume_user_mode.h>
> @@ -10,7 +10,7 @@
>  #include <linux/tick.h>
>  
>  /* Transfer to guest mode work */
> -#ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
> +#ifdef CONFIG_VIRT_XFER_TO_GUEST_WORK
>  
>  #ifndef ARCH_XFER_TO_GUEST_MODE_WORK
>  # define ARCH_XFER_TO_GUEST_MODE_WORK	(0)
> @@ -90,6 +90,6 @@ static inline bool xfer_to_guest_mode_work_pending(void)
>  	lockdep_assert_irqs_disabled();
>  	return __xfer_to_guest_mode_work_pending();
>  }
> -#endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
> +#endif /* CONFIG_VIRT_XFER_TO_GUEST_WORK */
>  
>  #endif
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 598b9473e46d..70ac2267d5d0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2,7 +2,7 @@
>  #ifndef __KVM_HOST_H
>  #define __KVM_HOST_H
>  
> -#include <linux/entry-kvm.h>
> +#include <linux/entry-virt.h>
>  #include <linux/types.h>
>  #include <linux/hardirq.h>
>  #include <linux/list.h>
> @@ -2444,7 +2444,7 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
>  
> -#ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
> +#ifdef CONFIG_VIRT_XFER_TO_GUEST_WORK
>  static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->run->exit_reason = KVM_EXIT_INTR;
> @@ -2461,7 +2461,7 @@ static inline int kvm_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
>  	}
>  	return r;
>  }
> -#endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
> +#endif /* CONFIG_VIRT_XFER_TO_GUEST_WORK */
>  
>  /*
>   * If more than one page is being (un)accounted, @virt must be the address of
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 120536f4c6eb..1e1f3aa375d9 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -129,7 +129,7 @@ static inline void rcu_sysrq_start(void) { }
>  static inline void rcu_sysrq_end(void) { }
>  #endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
>  
> -#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
> +#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_VIRT_XFER_TO_GUEST_WORK))
>  void rcu_irq_work_resched(void);
>  #else
>  static __always_inline void rcu_irq_work_resched(void) { }
> diff --git a/kernel/entry/Makefile b/kernel/entry/Makefile
> index 77fcd83dd663..2333d70802e4 100644
> --- a/kernel/entry/Makefile
> +++ b/kernel/entry/Makefile
> @@ -14,4 +14,4 @@ CFLAGS_common.o		+= -fno-stack-protector
>  
>  obj-$(CONFIG_GENERIC_IRQ_ENTRY) 	+= common.o
>  obj-$(CONFIG_GENERIC_SYSCALL) 		+= syscall-common.o syscall_user_dispatch.o
> -obj-$(CONFIG_KVM_XFER_TO_GUEST_WORK)	+= kvm.o
> +obj-$(CONFIG_VIRT_XFER_TO_GUEST_WORK)	+= virt.o
> diff --git a/kernel/entry/kvm.c b/kernel/entry/virt.c
> similarity index 97%
> rename from kernel/entry/kvm.c
> rename to kernel/entry/virt.c
> index 6fc762eaacca..c52f99249763 100644
> --- a/kernel/entry/kvm.c
> +++ b/kernel/entry/virt.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> -#include <linux/entry-kvm.h>
> +#include <linux/entry-virt.h>
>  
>  static int xfer_to_guest_mode_work(unsigned long ti_work)
>  {
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 174ee243b349..995489b72535 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -573,7 +573,7 @@ void rcutorture_format_gp_seqs(unsigned long long seqs, char *cp, size_t len)
>  }
>  EXPORT_SYMBOL_GPL(rcutorture_format_gp_seqs);
>  
> -#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
> +#if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_VIRT_XFER_TO_GUEST_WORK))
>  /*
>   * An empty function that will trigger a reschedule on
>   * IRQ tail once IRQs get re-enabled on userspace/guest resume.
> @@ -602,7 +602,7 @@ noinstr void rcu_irq_work_resched(void)
>  	if (IS_ENABLED(CONFIG_GENERIC_ENTRY) && !(current->flags & PF_VCPU))
>  		return;
>  
> -	if (IS_ENABLED(CONFIG_KVM_XFER_TO_GUEST_WORK) && (current->flags & PF_VCPU))
> +	if (IS_ENABLED(CONFIG_VIRT_XFER_TO_GUEST_WORK) && (current->flags & PF_VCPU))
>  		return;
>  
>  	instrumentation_begin();
> @@ -611,7 +611,7 @@ noinstr void rcu_irq_work_resched(void)
>  	}
>  	instrumentation_end();
>  }
> -#endif /* #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK)) */
> +#endif /* #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_VIRT_XFER_TO_GUEST_WORK)) */
>  
>  #ifdef CONFIG_PROVE_RCU
>  /**
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 727b542074e7..ce843db53831 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -87,7 +87,7 @@ config HAVE_KVM_VCPU_RUN_PID_CHANGE
>  config HAVE_KVM_NO_POLL
>         bool
>  
> -config KVM_XFER_TO_GUEST_WORK
> +config VIRT_XFER_TO_GUEST_WORK
>         bool
>  
>  config HAVE_KVM_PM_NOTIFIER
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

