Return-Path: <kvm+bounces-54019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A615BB1B653
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F5FF7AE04C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D9C27702B;
	Tue,  5 Aug 2025 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ESAVVgMZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27256275B02;
	Tue,  5 Aug 2025 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403891; cv=fail; b=XjG85MWD9p4C6vLjk5z9uYmJaUkJef4Qdl5FjEMApumpLSYsxoR/62CU+chGqBYmSyl2LHUUrSL9NOm2SvP/rxkxm9cvGSxwxAdkn/ipYibM8eGkmTCzYhgVKB8hhgwXXqP4Dnp7xxsBGO4DLlpORnRCZj2XOHIxDJYrVyyDAM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403891; c=relaxed/simple;
	bh=U1h4FGM3vG3LvQk5ze2GmEBboqVsoyhS0k33haXBvwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uSppd6E6YD1ZyGLDjgTkc6uIDGrF/d4WvIOCfVpXvbnfyULQnT6HO2Pr76Ot/NyOwQp+SV3vFuceftXQHfOGxyyiOpw4HuoASgMgJiivNiRVml9v5FVCgnqwvTBTKI9TK1AyU+u2hbb6XzAKlrLIWJxV1xcVT3iOw2+T4AOSh+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ESAVVgMZ; arc=fail smtp.client-ip=40.107.94.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dY4xJoUt/X56KC033a5UNrI0JNU/TjxHXV6mElyb5B2czJ55FgxkF+iJu/E3lCBkU2PcvtF/XcefckFYsAA3k3vksarw2pYevqaKpeuD4Vtil+uCQ2Uhx38s1Mr/9RquKW4RTv8zPC0Vnb9dPwjW0wYcEXTZtn5ve1DYTfba5TLNXWTP0fJNjjbzTMXcdHDHeYJs2+JTynYKEWMDX6g4I++9rnHLzGmNuaChfpdlGUkbhxG2QzklRXFVrTHfnKPyIPwFTp090R8/JahNSFZkhV7dOrBdILykmZ+XwQzWzU1Gws8P+d+hD+Jft9ne4o04DDccJjK1KlGX3pW4OLm7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMrU5nqhBP0D2+SVCth1m21IGmEUm5qZ7VMtLuiXTIU=;
 b=juVdPhRvWI7N+B/ZLjvfkFIkwCxK7DsSBDN82NFIyiH7cFImlnczKG2+0V7T5az/lVfYY+bEEIZunB2pN2TFpwv4Z/y/I7/agCgL5/8cj3XzOhtr5N6QbOWqdArzOwLvge2RxLUjLQ/Rc9/6avRiioudKEdtCZE8gelcvVB8wrEweR2ke7QkkEgvJffyyHmCHHnVqleeXJC+hbmA7jswz4VoqD/V0smZ7AcYf5bcnUSsMqym5R4t/3n6+c7pfvRdwUA5iubSLaklec7deDK4EdGfvZlJvzxLE154EnmXTpvFz/HP4TmLlSrg0ZnWDtJG+KUR9mMlo1WZOzU25dMz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMrU5nqhBP0D2+SVCth1m21IGmEUm5qZ7VMtLuiXTIU=;
 b=ESAVVgMZ+tIlEzM8l4hEsJBFt8nUV80KnumR3+rGE24+GdYrzKnJ2+0w7pBUTN/CS4p2rSAATcr1Yru5fqjV+HV6mQf+EnO4xX9/cYo0gFCl3DgdNy/sDZ5X9FNgfLaeaRpVEIppKyhdIo3MxGRe9viuyE0QwgHOA+HebQy+V94E6AVtJFlkJ4VThVbAbwvMENwIRgu/I/sP6DFmPn7EWnWHsuyX3wuszoPyvM9Gju6537lZGls2UWfIM8Bv43F/zkLmjYv0c06LIj2/Esa3xdRv/ENHcO2cUjddx/MHqFyQ08NNtnOsAknpMEt4Xq5EWZHr5E0ViKA0KvZhsL8XTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 5 Aug
 2025 14:24:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 14:24:47 +0000
Date: Tue, 5 Aug 2025 11:24:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805142446.GN184255@nvidia.com>
References: <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
 <00999740-d762-488a-a946-0c10589df146@redhat.com>
 <20250805135505.GL184255@nvidia.com>
 <44157147-c424-4cc0-9302-ccf42c648247@redhat.com>
 <20250805142028.GM184255@nvidia.com>
 <57582464-cfd5-47f5-877d-88918ffa2ec0@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57582464-cfd5-47f5-877d-88918ffa2ec0@redhat.com>
X-ClientProxiedBy: YT3PR01CA0141.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8059:EE_
X-MS-Office365-Filtering-Correlation-Id: dcd0e58b-3f42-4f57-8b41-08ddd42bd4c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eIYQ9f22dX0XWKpW6WFZVBKUGkWabnviaJM/J5vuZetFLu/VKGVlnlAC0Cjq?=
 =?us-ascii?Q?hsBpEwQevwee0K55NxvBhYF9kMMJ2h5CeEcFzhMKpLv4LY1TXx0jSSQRLqbM?=
 =?us-ascii?Q?Pdgxz0EEVVTZMvSkJvtcqnT1aRs74EqLerwaduqwNVcFtjeXsHdGv6n0uYTC?=
 =?us-ascii?Q?F+QB0OpkUWPuT69mN1Ve+4Hy9c7G23GghO69T20La561Zg82pqlJgDSk9vX5?=
 =?us-ascii?Q?bNvrtbTXZmah6hGHQA94trjFDmkMJB+l0OJ1N0zLMF70NBsXsgBTXUn3eeOn?=
 =?us-ascii?Q?O01Wk3sRlitR+u+sHViwxMR7ggmKzpivs1uHJc82l1NxdCjVinMDWUMeFQQZ?=
 =?us-ascii?Q?sECQkI+2ZdlumCrPrNJ6p2G49B/30ZOU3GTzKeGopcALwvvQ22c2C9ZR7wJR?=
 =?us-ascii?Q?BQ+n8JMMRKAId1hnV+JVMvE6BKU9unmMl5hyAlU/eKd7wPHUUJM8RquDTnkR?=
 =?us-ascii?Q?hKr2MkYXzJXrhaXCb1jO0wcCMq+zXN04GHx93Tj+8vv/LwVJAXohVj5YlpmZ?=
 =?us-ascii?Q?X0i9DjqvewlRBE7F+G+aytF3TBN4teC5BCgjBh9U7Ofd59q3NxUNjLNoFYSM?=
 =?us-ascii?Q?onOaNZlmaHnKXn9o+R1G2XuNeLsczXSIiWohhMeHqsa1HPPYDj9V/s9ka+jg?=
 =?us-ascii?Q?92u0lb9EghxcEsildoCo4TWry1eBfr4Fz1bdMkEPfQMwYLiS+ZmOvKcInJQe?=
 =?us-ascii?Q?Wkci+/cWixmec/IJ9MureUjHTW7xXgd8ObmYggBpbXMDtyKxUgpft7onTAnC?=
 =?us-ascii?Q?+7zfT1U/QpCzMjQdevzK32ma3Jij2c1h1RMFbkNxbb0Pn8JL1V4w3CppgEGS?=
 =?us-ascii?Q?dqnRDfr7QWaHeTEdoKTO0gvUo6kNUezj+78uShXvp9RT84f7kBXy9gZ6Liyl?=
 =?us-ascii?Q?ByCRDKgN4AB6SfEvYOgjE841POuOU/qx0BYzTNFiKcJAKsuWrIrG5O5LQd8b?=
 =?us-ascii?Q?nLthzxEKCcs9bZQQS0rZrUnWte08cPo6AoI9vQQ8gXykVvqpY4Dwux28NlQj?=
 =?us-ascii?Q?3GHCyiDbO0GhSwv+5r/Ssh7hXhcsPzkdYp3ov8UxsFsumzZA43oS77tO4F8H?=
 =?us-ascii?Q?U3lcK9+IloThE6R83EONmApH3o1UkgIATBwhWX5enEB3frZhaaY3GGQeu62C?=
 =?us-ascii?Q?p4IohVd7Jw6UuK3RMgGlPvqautD3s4dv0StiF5i8wNGEq8S6kKwU63CI4oXC?=
 =?us-ascii?Q?w0rzjSpIhm67IrFLZRt6l+efz6QHGSivQc51sGSmGfjb1VEXMjSHV/TXoB8P?=
 =?us-ascii?Q?8ecNb3sMLXc69yTRJhFdYyw8rraICISIXWXb3NTt8gP1nA+KHJTa4RAAZP8R?=
 =?us-ascii?Q?s2s/+yHPlKb0DxvaiCKI0amehUN/06+4eN80C3JuN2/d6JUSj2zsGo8lzhP8?=
 =?us-ascii?Q?JDSxC5WFDXYfzq7vPY+vcbUHWF0QlskLqazjPkJ+rVOe0E4Cnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qO9VLsuiMNhT1MTYOweYGZsQM9LNCybqWjDiQ2JH4rGNi916ZaQX6zkgMfIH?=
 =?us-ascii?Q?MprW+4kQMNrYt+i5U9Wr4HXIajbsl1c7mygzuH25/EU6rVJXT8WiXLRG/DND?=
 =?us-ascii?Q?PtlnzW0qiJXJeAPHK8YIXOhe8uKKKxPFbeARH+nPx+JyrYLOI18JuTBeVOSv?=
 =?us-ascii?Q?o+rfBW5ANwyM9dGIUe4sU8ppxa8HxaWA6xPrqGTxw2D0/+sWDyflgosO7PF/?=
 =?us-ascii?Q?3Eq/h1jAhcsyYGTVzBxrWizz9CisqystJ/jM0I8zNXzy6g8oMfIDjTbu2iGO?=
 =?us-ascii?Q?q9dxi0A6Kh6SrqyZjr5ymbc9yfzrEiJdPDQN9fvCSFkS5mzs6nGRl23aBfqa?=
 =?us-ascii?Q?OiK/5jxahaQWzIrdz1YjtLIcjX3mYQoLaQKX5kKRppWh/zkngozfJu/g3ssH?=
 =?us-ascii?Q?BeFWlxFq6PEEqixTTMMRtBl/0b8rC7YIFXOfl01fNIgm7Y1shXDYMTYbDRaN?=
 =?us-ascii?Q?xSFkQIsGJyZxgPPZ3bXBBzRYIAPV2aZaCOvYjIzTPxdeC25mJkeUJJp40M9P?=
 =?us-ascii?Q?sVQqQtc4BXqV1p/rm4S7PBDwDieedSJv0A8THpuDqT80+4BGi6/8DOJlG6b8?=
 =?us-ascii?Q?VWanLR2AGJPlW/u4JbsKEHpPtQqUXS2L32mM4qM8rkVUMDx7S/zIKL8L0QQB?=
 =?us-ascii?Q?cnLLlUo5uq+UKExtWf7lgnTocRoAj2iRkYZLZ9zua+zL1h2sXFFekiT1p+d0?=
 =?us-ascii?Q?5z/wFrgtm9sopBjGd+TAzlBczQ0VD8j1QkOKvctr9HZ7KiwYJZ9RvNuCz/vw?=
 =?us-ascii?Q?IGgxKCTJZ2qHwRvQADw9KaDQ8r4lnonUhnUAn29jqbv0iIMsaWczKvKvMT/v?=
 =?us-ascii?Q?ThCUgMJCzr3Lx5u5Vi6McASLwUrqolWeRYbRTg8BkMBBbgQ99XqFn0W0B2bR?=
 =?us-ascii?Q?GWFBQRhAZVDmZhC7VmW5pFWdeBVrxbK0m9yV9plwZ1wiQYOCx3igCj+lIn6O?=
 =?us-ascii?Q?aiJxb3O7p4EtvApdGRpxDhgZWLWHLTfDddpSfChWK8+biDRYrAICkv6zWhYU?=
 =?us-ascii?Q?/c86zmrDzcf+V60fZJ5KNwnix1ppDsotANe6ItrvhwumbJbGezkqV3GfcXTO?=
 =?us-ascii?Q?P5P2AKK9f29hXcrYNU29Qmgn22ae7BCglutnD706E1zECo7+j6qFokpL0Y4I?=
 =?us-ascii?Q?g2K+E8U2MpjwBp2OK2o45f9ASN0kQNq1trHjSL0pmHIY2RH5FXmuNnaCwSd5?=
 =?us-ascii?Q?+jw8KrtGXwmzLkgXQRzz7HibmI9LbUNRLzDM6X2UmQL+6jG39xS7YeUEnmEM?=
 =?us-ascii?Q?jtyMnlcEFi99VzSP6tDKNx4Ivnrxn73lfMK/OZbrB85Tsu/pqIhBFuC9FROI?=
 =?us-ascii?Q?GKRltrNQzabjvsxqhSsXLSV/ilBMK22D/syf/1ZtKCQxjtauiae0hnpryUWc?=
 =?us-ascii?Q?SEnMO+j0OSctYZ5Bbjaju3/f7KCJh2tsAlrml/DXLlf3cJZktAap72hGJWo7?=
 =?us-ascii?Q?VQYT21L/dSgUGZ4MrpIh2SRM0XpsOO9UUCcu/C5MY9P93TnpAhhkb6EdDjI5?=
 =?us-ascii?Q?1xVbc62eXmPG/RTD1KOhS/uv2u4zNEEPef97g6faDZ23PvjycwTPRzAfvTZg?=
 =?us-ascii?Q?rW1bt/WbLrK8oK9zTog=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd0e58b-3f42-4f57-8b41-08ddd42bd4c4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 14:24:47.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAGU0IxIpDVBREyZ79KwoiINyg2TpS2fqPldj5tV2cAF8vo0yWOaTPWGSLuGr+5L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8059

On Tue, Aug 05, 2025 at 04:22:32PM +0200, David Hildenbrand wrote:
> On 05.08.25 16:20, Jason Gunthorpe wrote:
> > On Tue, Aug 05, 2025 at 04:10:45PM +0200, David Hildenbrand wrote:
> > > There are some weird scenarios where you hotplug memory after boot memory,
> > > and suddenly you can runtime-allocate a gigantic folio that spans both
> > > ranges etc.
> > 
> > I was thinking we'd forbid this directly, but yes it is a another new
> > check.
> > 
> > > So while related, the corner cases are all a bit nasty, and just forbidding
> > > folios to span a memory section on these problematic configs (sparse
> > > !vmemmap) sounds interesting.
> > 
> > Indeed, this just sounds like forcing MAX_ORDER to be no larger than
> > the section size for this old mode?
> 
> MAX_ORDER is always limited to the section size already.
> 
> MAX_ORDER is only about buddy allocations. What hugetlb and dax do is
> independent of MAX_ORDER.

Oh I thought it limited folios too.

Still same idea is to have a MAX_FOLIO_ORDER for that case.

Jason

