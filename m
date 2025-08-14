Return-Path: <kvm+bounces-54671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DAFB26543
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 14:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B9382A3B5D
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFDA2FDC22;
	Thu, 14 Aug 2025 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="isYmo1/t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835152FCBFB;
	Thu, 14 Aug 2025 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755174012; cv=fail; b=ZNltfKj/vppwy3KBDstsM8pBpXxx1VoTNYjdYzGUlnQ/y38D4wn2Drw0+zUeGdorJHaaKqK1RMAmEcZ2TKN26p0pdb/7pEq2zQZjJy8MlxqgOv1iWHPmtprGME8L4fIA9sitMxlGWtqCc+A0Zj+Qpvat+1WRoam6AvlCgzm1hAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755174012; c=relaxed/simple;
	bh=gO98iLU0CnpR0TnBbEWUa41UuSGVuyFZWSl/D5LE74k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e+DprZbT0OOfovhsORjdSkG+rgkOrVJKrL7L0yXIPXPAbLRW2RfuhsWajvFTlK4UrPKgwQEGsQA3DxDnhkP1QVAyCl8S1RaRW9or/vVqDp6jctiOSrg+R/9SyOY4dgv0JYfPB3p9x8sFhVHKlQfUgXDJdRQJxAy2DFg2Hu+rISk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=isYmo1/t; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OeyBnzKHg1/iXxgvwlFkRoIrmyZf/qtSGsNGSnDytLI7k1nprghTRw0BPh6pHKeK+3PhrS/zhgBDngXOEH20u4imSb+VsgczZtvnH0AyXr3auH9/ng1AK6R5Vv/m8QS4F9VJOneDhYZM4r8YtF8aR8hW3xp8QT40LNL7Y+/QqpWBLAj4QtpX45tID/t/Mt2p/PVHp5YHXcUyDCW2iImpPyqanhyvnt0NLUtZSPgMTEz6JNiZ4yGLYPsQNK5hja11vpPXJLehi13XlhsnaEfOOjCDMabG6N7SIbNJWKwDigZMA0/DrTD1AdOOSU0Jw3npezim5Pmu9JFq8gIhgRBdag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO98iLU0CnpR0TnBbEWUa41UuSGVuyFZWSl/D5LE74k=;
 b=KWNLAZe0Y8AqthlZI9gvzi80U5ULdyExTD+v512NQQqjM2oHK8xzit8eUR/2AbS0cCQ9b8gKxASRmwpe81RwI+/TRML/qpnBhRlqdRzZsS+u7tv1OqVxP3zjV2a6kr8JaUyG0F3qr1cCCgfFljzbqBTgRM/of0vN8wk8bljfIAL+ST1Q3Mm9COzP89ugd7xCms8Ub/Ssq3d/GHMIUFtfObySEkzFP7X66dcRhma71i46OHbdcvs1e2Opo0cNkZiTLv8YVpRt4zch9Vcos2jR4tYHKxW8n95R5pCpl6dV0KtL5H0VGyd8htPlKbpi2wQ44OFrxro/Jd81v2yEdM7/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO98iLU0CnpR0TnBbEWUa41UuSGVuyFZWSl/D5LE74k=;
 b=isYmo1/tKmuhVu5gytHF5AoNeFvCnnby44KflqBz4MPW0tFbbC5kGXF//7r2czgpd1kReyacVwGyk/1fHbskTrwgEi7+UHCs44NbCjQOakUAkozOKkfQWglezE6VhQPz38YpVKJ1XDteLo79MvkdrLrZohwzV05P8udknykiOYxVak1ZEIeBo4QpRw0ogAPIvt3qNbIaO/3JnzklNfsf47gQ8if4yuJ+Z2hJEelmGbjfcgh7Lg3RShvQzi49C1NQLpPR8iudzxr9wJz/uhyXSFjZgaWYxfgcZ8q3UCBhvRoyiVe9X13Bg1hwlDwDnsuD+rUVnI6gaOsIaor5KszrgQ==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by CY8PR12MB7586.namprd12.prod.outlook.com (2603:10b6:930:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 12:20:08 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b049:8074:780:73f]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b049:8074:780:73f%3]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 12:20:08 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Morduan Zang <zhangdandan@uniontech.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>
CC: "wangyuli@uniontech.com" <wangyuli@uniontech.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/nvgrace-gpu: fix grammatical error
Thread-Topic: [PATCH] vfio/nvgrace-gpu: fix grammatical error
Thread-Index: AQHcDQtHHmqfZKGsbUCHWlYR6tCggLRiERIq
Date: Thu, 14 Aug 2025 12:20:08 +0000
Message-ID:
 <MW4PR12MB7213EA6E903EC10A00BD6029B035A@MW4PR12MB7213.namprd12.prod.outlook.com>
References:
 <54E1ED6C5A2682C8+20250814110358.285412-1-zhangdandan@uniontech.com>
In-Reply-To:
 <54E1ED6C5A2682C8+20250814110358.285412-1-zhangdandan@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|CY8PR12MB7586:EE_
x-ms-office365-filtering-correlation-id: 2dbaaa01-327b-47f6-2818-08dddb2ce8a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ipoaF9majeW6DV59LhTG5sGmsy1MyvdbWRAVmcj6iaKsWmnz5v4j2XyFu8?=
 =?iso-8859-1?Q?tGCrNh7KSNFZhrhnVj/Fd4bVmWq6/6Y4ZrIUIvdD5WfyX59qpbM81imPUv?=
 =?iso-8859-1?Q?kJttQwFRogrEYCzm9N70kxwspsDXFXhjO7VqykWubHOizCAVtqnA593CRB?=
 =?iso-8859-1?Q?uQzsKhByYK19w2ORzVg3TfS8ARcWJ7sH1/7vBt6MmADKcepMHzuczEZaUV?=
 =?iso-8859-1?Q?4zy6j6b5XZZoeDsqB1zSGVYx6N+JYXadIRd7Ivcv4EOa8d0pzWx8loorFg?=
 =?iso-8859-1?Q?RABfqQXgxiSBmfqZdy7YpbKgzsNVylV7zma7KkJwm8J4PwnkuAlu/EfW62?=
 =?iso-8859-1?Q?gnLS5myg0lLSZDGo1Ko5XX6qV6s0Qp41Txj9j1vmD3KuwiumGX7T1OJdNN?=
 =?iso-8859-1?Q?TVBozCEKRjR9ue26gdc1z9EzSOzOAythahqY07ariuHrfJDAP2T0vOVNBb?=
 =?iso-8859-1?Q?J72WYmsdoz/C77BvWqVWQljY4DJh3O+cGJgZI7FkH8oYCSK24Zf2AEergG?=
 =?iso-8859-1?Q?dfwjp34diMmerNSFARHezP0EJ0G8I+cg1mAaCf+gzOaytT+XWtLzHVLJII?=
 =?iso-8859-1?Q?c9X7K1bJvzxAsnPj/2MQywfcDIMNEqH1TiyToIVgVzPDhq4a8SHkV7bts/?=
 =?iso-8859-1?Q?KK6yDSL5nc90eCz6114exlA+3eKA5LhlzxyuaOyVfjf//3Q3W7GNJxBt42?=
 =?iso-8859-1?Q?5AkS2UgincrleGUnfamYaTtvvXMLjmEr0mhM+YuA6r/hpJS/HOMdaF3h/K?=
 =?iso-8859-1?Q?O60PX6L6XQZj1qWqA3qitr9gBbbEOWU6NxgCsClr526sDqsdkguq1XMhJ+?=
 =?iso-8859-1?Q?9yUBfDx6pb29VHH5VVsdDv146nHrmHa8/rPKFtLVL5ma0lTeZ0rXxJBDik?=
 =?iso-8859-1?Q?/v0oV0gMIS29ZUFd/QWjwmf601HBBOdpLUJHIs4mX/mL/P5xorbqkwy+g3?=
 =?iso-8859-1?Q?jJA/P8oFSr57B8dYiO10cNG9oJK65vXQRzNMNXay+PrfgFssKcgr3mtW7h?=
 =?iso-8859-1?Q?1/yqTlb5LMMYGISbG/u89JgyhgjKeaIcts402CyXWNc625I4W8hxEh7KHS?=
 =?iso-8859-1?Q?VwyMGHF00tnt5SzhiFHVA9Q6YQTKTusv07BF/bnIYS+zfn6dQemF2xeVTb?=
 =?iso-8859-1?Q?QnShV3Aj8tVzAxwUho6ZznTbl3EO77jPnPbyVHJwkP1/CEw23lUaWDuaOk?=
 =?iso-8859-1?Q?NgEmxLjcNKlWx0FyFnILql2j57RyFnQUxWS2nIN0ixJ2ldPweDLKwt7umz?=
 =?iso-8859-1?Q?B0NceGrMwqseUGF70Z9yK78Vf8HKm40gbixRrFXYj68CKKdyO8qgnK2X40?=
 =?iso-8859-1?Q?s6rcaHH/Y8GMaJC97LBTtPszrjn5cVkKn7xbJ049qhJaZloNOb2rXFx2Xt?=
 =?iso-8859-1?Q?5VPsMcTqxLdTG3K3HUW1B8kA8wR2aSKBSA6pb+4HBTu1+oO/T+B9eZLM2W?=
 =?iso-8859-1?Q?HcwOyiiNyqIlatj0Y5xZRwdb3SngZRKBCvgjCI2fyRwN/5Me+AXU24G1d5?=
 =?iso-8859-1?Q?5JJwWtOTAa4offJn3+8bYjPPiYPG/UV/E47gtEzHWcjpWJ3UoeJQFx2rNC?=
 =?iso-8859-1?Q?sgmBH+I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?dQhp6HDZNrl1sNbxDkV+64Q7GjrcyU+v0+/m4Xpyzxe/PlILcq8/Sx6nBg?=
 =?iso-8859-1?Q?tkfUS6cis6jU1anKdzVhEM5ImYBx/P+Arrz3rzQJDAc4pQu6bNi/KpY1D4?=
 =?iso-8859-1?Q?HnxPEZr1NMLOiNerZ/AXQHY+dSCoK8P+9SaygPVPpxQgP1zRPq5Pkt5WVL?=
 =?iso-8859-1?Q?e7XTREkZuszvKCGM8Rg6hngXxYTwOv0ICQE+CwuvTbUo+kl5RkBEpNrp9e?=
 =?iso-8859-1?Q?kLdj1DQom+q0V3kl4vn1cq0yAt+6wscJrBvz6GFxOn+mEiBz4cbSiEIJj2?=
 =?iso-8859-1?Q?2N8QjZ4D2hQ2Mq53VVLs56MbmtrGXkRawNmjpr6XIsgsKzjnWjIhv4U6LY?=
 =?iso-8859-1?Q?KRdUQJEpxAu5XjLsXjC/WlR0dV5pVWPUK4FBqPMaTK5sHjs4rlDDqK+ub7?=
 =?iso-8859-1?Q?ni0wSr4ZEwoo9nvyzclLntbsOSZFxyNrcTowC5mhFWb+XQwPmlYjh6jX2c?=
 =?iso-8859-1?Q?T+TlRJnS4tQjV3kUL2HJ+L7NU0jFqDtrw8pCADbO3fQ0nHIShAbF6NHz0T?=
 =?iso-8859-1?Q?GfplwqofsKIFVCc8WYQDgUxegJYd8Lo96E4UWAVUCmHGqTw00BhWRSCbrc?=
 =?iso-8859-1?Q?VxO4feplu+/qVvLie0mz56a1cDIO0KlF/gni+HpfziN+wInaz3RElHGFPE?=
 =?iso-8859-1?Q?IKYcKG0nmYsntFVAuvjR40DY4AmRMS4bJwRjfhB7eKDXYibgwrZj0Lz9pa?=
 =?iso-8859-1?Q?B8/SLHRPEZDEs9H38R3wL/eSe1uhg8lwb3gfuRnIzustVqVuMCimy4cjaV?=
 =?iso-8859-1?Q?e45VHDb3eUhZRiyJGVGJy+xWyN6mlvBIxLkKOPbUEd+K49HWksvCjZDoJD?=
 =?iso-8859-1?Q?o2F/xllX3cy0pFiFzuXvLi091sehzrsdYqqsqefJnTI4Ak0hWZh7RuCJrr?=
 =?iso-8859-1?Q?7MbTv07cx9AZUdx6ND7NCYslyQCIKBETtIaOdDefp8EFcd0hHMP4/akGwY?=
 =?iso-8859-1?Q?FLXQWmI6CdM8odgD6wjK6+FRQ2z8u6LtrMP+j92AhxnEcKG81ufLy5NULv?=
 =?iso-8859-1?Q?+vUZO+QHdJNVhC30Eu8KDC5djaBYwwCoa0bl7yD+nDvM+KOEfwi77rWyn0?=
 =?iso-8859-1?Q?JEvfqJClvpKJxnbt/ezlXIvcOXnKuE4ClEPCUMQx08uJjHUbdkcw6dhOo7?=
 =?iso-8859-1?Q?NOdfvm9xkp0VzQzfDaBJzNalM4nIHCSwQzR6mBlrUanc6rS+4giE7ClK2g?=
 =?iso-8859-1?Q?xsylY1JkjShDf1rGiU6IM/RzM6sCjeDMvTpqoTU0WfKbRNA7oHwVTFstwt?=
 =?iso-8859-1?Q?4BKQWca54XT5999MCKG2P6QFzehUXFOrmUgVgLhPhI+Y7Nviw27G7MNkSO?=
 =?iso-8859-1?Q?sJTrDzKK65kzIHJUWHyT3/xlWRSMGKYHZ46g33ZZhLwEgRy8FUyWpbGjTU?=
 =?iso-8859-1?Q?hSy+I6LrxnMkrOE/o4RZrnFzTG14oV+vLR3aYej/HRSfCticVQQHhcrNzy?=
 =?iso-8859-1?Q?ixz5jKbcxRxfXWlke6quDhXgsOehsAK4zNdCvorIelz6NfNnL7jAPijX/X?=
 =?iso-8859-1?Q?f0P0fnwRxFXe9rlaNWy6pbFoV0TZn0dMv/muyw54tEyHla524UzLzAdOgE?=
 =?iso-8859-1?Q?TIn6ECqKRk/qqcSxsFA1CiQbwwjGVAApNHfaM1eBLI40hGWkGXivR5OJrV?=
 =?iso-8859-1?Q?Bc0XJbCo1NpUE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dbaaa01-327b-47f6-2818-08dddb2ce8a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 12:20:08.4208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 89dTxqVSHuqL44ozjot5q+atuNfQQRH5VWFX6uY0t0yYZEGblrjvvikGPHulmJCnUHcQTY7mKT69OGwisIqzKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7586

Thanks Morduan for fixing this!=0A=
=0A=
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>=

