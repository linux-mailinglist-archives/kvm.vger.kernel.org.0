Return-Path: <kvm+bounces-54016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BDA6B1B643
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 462C5189292A
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36ED274B3B;
	Tue,  5 Aug 2025 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TUO1FHhE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339471DD0EF;
	Tue,  5 Aug 2025 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403635; cv=fail; b=nR3XPwR0b9l563cesTDorfWgXDyV9aSkqhOVhO7JZi5WFBQQWB3NXYVMdua4xoR0VN7vB8dtOJ3HofrljEnx3rLSQ5Yn4Oi3CmGIY5pwFIDd5dN2jGzFAzab+BdsKgqVgH7h7gaYxdbGrqf5lkP8L2depRyhyxzwDaSGHzGrF2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403635; c=relaxed/simple;
	bh=HGxswZH2ep8qb/SgjWmS0vt35o4z/+Q4r6KldFC6HDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KaNwrSDjGfGDWRWnxBkQrPDsOfTUATJieRnUK1PqplliV4KlGig3iVl7ignx3Y/ZK97hUfPEucPPLQFFGWAxsuBEAKo/IBIpj5+l3miN6NNOyUUm9TDmGwE9vopkgurk4RWS6wGwnMeHsOyUa6WvJ+TwRDY6sEgOfBt9hhDo5xU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TUO1FHhE; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xo7Z6Jteq2x3tL0hKlqHFv1SUv9nV+NpXAs38YRw9Sm2H8rB6itNZhWSflAOchdpUBnqF4yJZdSGCGFjz7EKUjAkjs2oqZsz9Om4r48AZY4nbgj2pFeqYQh14qIhPGvPXobkAXdiE6qgQSHhiavdDDI+Btmn6oKk+byC2AzdU85YGk9AMYq0oxNfhNV7TWD54aeAmoEm0o9kb+yKMTL3CKWMsAjKyL48bfeb7Q0fRPxM4KmbgaWGe5zGHR2zRQrre0j4+QpasSIzIOafbkyNbDxAKXMRZ7ZhcEbaMcL9ZTE4TdoRWe1bdPq/8skcBLr+KS5h99qrZufH/j7+xhJkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGxswZH2ep8qb/SgjWmS0vt35o4z/+Q4r6KldFC6HDA=;
 b=X1RWldk/2X3rbOATQ/QyMDEsDnipcLobwearcPqcMYssNfpnXkGKo/MuPpiUN68LDK3xfX/eP4mkYt4DQsoapxgH+3po+xuvPpXUtdKxqNEJDtm9QQ+Z7SNMskiUvfnoC3kjfCybXNtFEmM6LPyTvgwaBnCc7zEwdKvLZKJBEKYrqTWQ3zN/AETPkPKIP9LNVI6L2PjUsEXb6Kp53eMMSEF/fdbD9AZsbuabIX9SIv2xM7eLdmA4HxF3OqucX4hwFiRQ2RMCWIQpap5y3Bn4672jYxg2J+RgRzzcHmPDAnQrAssQATLvJThNWUcNcOEBiAHdVzeqsV04MKNIuOejFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGxswZH2ep8qb/SgjWmS0vt35o4z/+Q4r6KldFC6HDA=;
 b=TUO1FHhEatayZuqj81Im5sZPH1trETQeWGO/yUlyx9g+CFEGT0Cp57bTAu7H41h4cGan8MYfZljXmiDlJOoR7gd6FLwF9zUwwOwdiKIIFlaqsoyKoxKqF0LpVGfrjvSNyZwpD8Jg4nUEH8b8UIBxC+xA757BNqlhCqRMRVJ+00ck5V/Le/rvfEl5s7cQUAVBH6GD7KiEB9atL5B3fBMw6Zkdc6uuncDveXihj3vKdRyXWKDhZo6nqrDp+FK5VtdppWwaSNH6oU01s+BnmHlKJhGpdBA0Zaf8EX3k1WROFZKXgX1oEXT4pifmSvqxM2QvXV/xPjLyyJZXyskbKc0EcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB9043.namprd12.prod.outlook.com (2603:10b6:8:db::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.20; Tue, 5 Aug 2025 14:20:30 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 14:20:30 +0000
Date: Tue, 5 Aug 2025 11:20:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805142028.GM184255@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
 <00999740-d762-488a-a946-0c10589df146@redhat.com>
 <20250805135505.GL184255@nvidia.com>
 <44157147-c424-4cc0-9302-ccf42c648247@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44157147-c424-4cc0-9302-ccf42c648247@redhat.com>
X-ClientProxiedBy: BL1PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:208:2be::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB9043:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b37787e-1385-4d3d-7ee5-08ddd42b3b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IYb2zdq0boyiMcxOeJAoti+UVXR5EjUYeJoa+mIHnfhvsTMVG/6aM6dMzBZn?=
 =?us-ascii?Q?uZaUDPgRbaHocL0txxsXijQf3TWFUOICGGKhQs3w6HsJ5aFO8wqzf2z3whu8?=
 =?us-ascii?Q?cf7tG6U1KVf3shpJQzJplPRR0634d7wfQ2SJO6uP30VdLU6XuLchHK1WUmQp?=
 =?us-ascii?Q?6aSz0T2HU/jmzJTJLZYchDdvojou4EROevyivxzjMW6HaDVPGARhM/9JNTeS?=
 =?us-ascii?Q?Pe9qBff8V5MajkVzP2El+jAQhcqwkHVeFsN0J4iFvUPv/A5qgtmEaRaKFYLt?=
 =?us-ascii?Q?Ymwg8X4K55YvDoA/c7HOu2VOtmdbnIQ7MhU+G7ZdQfphJ5U8GX2k2lW0oD6B?=
 =?us-ascii?Q?vkKJHP2SKkl6mjutxthwVdrNr9PpU6RRd1O+/z2D6bKadqaRCc4gOgH3Qfj5?=
 =?us-ascii?Q?c7cOaBxI388EYlFdtG+f3JzJbd6DeAqJodYPmzT8lqKiekukvbSntRAQVESf?=
 =?us-ascii?Q?iT/sU7LrcRoa6U3tfPcUk0hPepF5+rcyrE+aBUSO3IZtY+oLSJxnm51Ql5Z7?=
 =?us-ascii?Q?RlAYCltqs4vYqkozi/H1FBvcQLIEPV+5d6aaJvG0Rv7uJDmyCChC1kXOv9Pq?=
 =?us-ascii?Q?YKfHf6uCFVa1EtHNyG6EO6mRJuzO5ue4rbDh6K96ON0ed6KXpKJRgBrUjrCZ?=
 =?us-ascii?Q?l1/EFW0DOAGByfWxl2KTvc++f7zJfoetC3wOHYZSIyROGo54KNFouaO0W7gK?=
 =?us-ascii?Q?DniYRuLVG2k1oCwmo7ocBMlUh24CISSDjkzqhaRz4PWtJzQP/qQ14A9dklg0?=
 =?us-ascii?Q?nHA1NrArNDB29fTh26Ox+mhk4e2FL3FQibdid/0cuOHaTO+aCaP5JWGDxZb8?=
 =?us-ascii?Q?PfIS5aL6B1wda8qtrN6nxzszGL3HhcIzuNSJcTfAzTV1EB3f5An6nlhntqML?=
 =?us-ascii?Q?opf/2nulidWhAZfznS7ossOhd6bxosg52QzK8a0Ut9AxALmkP/ADVrUbJi6p?=
 =?us-ascii?Q?PLfErC5UNiKOvioe5fyxwK+tR7aBfLmDn3fiSqy6sxBaQiFtVqLELFR3qHPX?=
 =?us-ascii?Q?7W2vuHUT0GaS/8rehMMUPAg0tiVpr02a+IiViGXdrHY9ca40Aapflf5/imS4?=
 =?us-ascii?Q?rArIJ4Mrw8tvWjbiU7x+gXraoi2qdLJPk6zNFQq56lHCw0bVS57jtCe3bWD9?=
 =?us-ascii?Q?KvD3IEoUCiPrg4nPGfWepnA/cxzJYPmm8u6jUOFuzPBDL3DpD5IdG5tCSfMW?=
 =?us-ascii?Q?6laBufXcCWNdy+/DpNl9hK4kkEi8i9GrQA9wIamZw/wCwu02Z30o5+aL4dcv?=
 =?us-ascii?Q?6Dasx5hPWY6QjzFN9UYxV1sd0XRKnIOEmxhsA02CH9hxRUcSI0k8VWu6zQuO?=
 =?us-ascii?Q?QOArrIJZfraTGrEgW7cs+yYI7nZ/iSm9SS5Xbxquwdsu9MtBcZ9RS8atw0MX?=
 =?us-ascii?Q?LKf7MDaBLniFmMrLOunZgX/Bo69PA67hiME3RYQhNu/ZkPp/eQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qv6+JoCVTVwswrpItWsx11SYDkHhkF7suJ3gDtTWUWfcTPjO45wI02qW8PGX?=
 =?us-ascii?Q?IpQVp8Kh5HBlkDs+BpcTP/Mj1supa8q6BH+EuOyo1FI7yXwoJqHyapCOAyRO?=
 =?us-ascii?Q?yq+u79qqcAIorm8E1zE1QBWpMNZ6PB02nMgdM9/MtRxas5xACvWcZcFIK5Cq?=
 =?us-ascii?Q?37Tch2aEa5zbUMwIZje9AEzdBA+QL3EaiLTuNY8cyCijYIz/jrf6ChbbqUGu?=
 =?us-ascii?Q?4bHjM+Y0e5eypnlX2Fn0fWj/yo/xUl9p9z1xTRDIFfVlGEg6jA3+gKbnVRk5?=
 =?us-ascii?Q?GHWUQ+LMo1mc8Vj5dENM9/0EbkeKsb6VpwtDY6Ksvhk2K/B0QJh+KJ93MagD?=
 =?us-ascii?Q?GLqLFTC1NRUU2RSfOYlB+RJJuSOxFVfc4YftbDyfIqJVS/9cIuvS9NpIjEtF?=
 =?us-ascii?Q?p3LufnbHyjhcnAe2g6cXCmgThcGtbvravKtD10oXLFIPZzETHyZxJnIgDXC3?=
 =?us-ascii?Q?FDCNPAC1QlMVsXK+UHHx2U+9xo+h9zJXQsctunbLvMYeodzthcVo6h/g0PYb?=
 =?us-ascii?Q?Tb6S7+XtSmqrXX615UIHVd/pPpam+aT7qI7pTAdMH3alms7mrsaM4Ry09nfF?=
 =?us-ascii?Q?m7GXP6dArTbOdTVkAcbmVDx09FZ+qOjYjiI9I4vmxdKQXikioUEV1BqogiFQ?=
 =?us-ascii?Q?YiX6OP7YeCiioFvvFERNbij7kfzCmAabdu+5/QQm3bQ16wpy3j+65h4Agw0O?=
 =?us-ascii?Q?VRMeK4pGcHaeuW0me0rFyqpImrxHOKBq3Kzvg1sBY7VqqUzGmHprJQU3Ylph?=
 =?us-ascii?Q?9cb++A6UdSJ+5W8sPKaR8NltIjmdbdXrpN+JS+29GeOtM6cQiXrYvdAr8SoC?=
 =?us-ascii?Q?IMSg/m94uu5At5eGL2V4Ao+xnHjNU+nGhb9ih6ZGE1WnCogopKIJrsmZiYYz?=
 =?us-ascii?Q?SSIbJEy8dahY+ww1XaaRNb0TLhuCOePSxtfQ+ewSn/BJthbTvWA28+KOY2nM?=
 =?us-ascii?Q?/Tn2p1Ldrno6rdIpDNMkgTYFVWFKK3ViFgNTXIoh/HSysJ3LZ0Z8GZnC12kP?=
 =?us-ascii?Q?Dt/BLHJLL7aLv1M6oCABdxz7U0Op1IVYdC2lCrJPmej4uTQhj9pXM71Sna7g?=
 =?us-ascii?Q?7ONDa75C6YQT1GhY3hheTeeEXpkKIRCZQfxWtIy84YBl9BwUDNq3CPVwOhbd?=
 =?us-ascii?Q?5v4u7SP9hqdF1fkrrDGmk39OSrtM/NgR2MIuw54G0FCriodrjEpndN0+rLVE?=
 =?us-ascii?Q?f9mOdNt+Sh1nlsIJhVnUelVyX2cJBB36MzLcdeuiPEXnYmob+Chu8qH1jmeG?=
 =?us-ascii?Q?uoow8XQTCfvetFxoGzg5+SXwvKBWMI3La9z09tnX6K0JhRBo8gmGycYiNO7y?=
 =?us-ascii?Q?kz6LjiltuMXArR6rSCmS5pON3IRPn81yYY/jOpa9fIc/FzrIeB7fFyg35BuA?=
 =?us-ascii?Q?EoPc0A1bJl9Sn/7YwTpHfOPlR19IRzbyXV6WdW5TqD7BB0JepT/dtymWTIMQ?=
 =?us-ascii?Q?BZQ0WRNkMy5GAm3wdS88STkb7//JG/hBOTxLFCMXRlAlWM3UskOY8bjuTaAs?=
 =?us-ascii?Q?uM/zXKNLSoumkZM1DIhqnlgqIOKlxbpbXCmwJS7x6hwZTYdHbAa4PttY49ls?=
 =?us-ascii?Q?uYrIHq+QTsE3gowKWU0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b37787e-1385-4d3d-7ee5-08ddd42b3b49
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 14:20:30.1266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsB+G3sYZvdTJaLcjc/H2yY7XSvo5JBUVG+HFBpsrZbrI8XyRoADkKzTAoffIC3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9043

On Tue, Aug 05, 2025 at 04:10:45PM +0200, David Hildenbrand wrote:
> There are some weird scenarios where you hotplug memory after boot memory,
> and suddenly you can runtime-allocate a gigantic folio that spans both
> ranges etc.

I was thinking we'd forbid this directly, but yes it is a another new
check.

> So while related, the corner cases are all a bit nasty, and just forbidding
> folios to span a memory section on these problematic configs (sparse
> !vmemmap) sounds interesting.

Indeed, this just sounds like forcing MAX_ORDER to be no larger than
the section size for this old mode?

Jason

