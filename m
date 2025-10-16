Return-Path: <kvm+bounces-60140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 147D4BE4624
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E7F04F2F26
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 15:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C3034F483;
	Thu, 16 Oct 2025 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TXmBNGN4"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012015.outbound.protection.outlook.com [40.107.200.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8953D242D78;
	Thu, 16 Oct 2025 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760630287; cv=fail; b=eSWlaWPXJ6EBSJW6xpYc8CiQIgorZT01Jka5VZGH7HjDB2lB+HFK12SjlXjWFBnp1UTaPaOWImWm5gJp0MA2E34WRJz19vFt1otpbpLXZrEWid3epuKAGgkkU+0GVkGYiuNWgUF+zqZb4QfwYRgMY5P4e9d7QghIacvXdvZPeSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760630287; c=relaxed/simple;
	bh=pk/64iVjc+KUnuX3UQ5D7RGs8s/7tDYJYyKoma+NyN0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dNkMRhosifVnGP9+KpykjDvPPqo1oaSUgFZIJjDHUfEhDsDiG80iMeSNnU42Kxq22XvaystvcHgNbBH49UedF8uK5dFClrUQMopFfIHaGHsCFTXjTOpQYSdVdVisbh2udpqMYiWiNwocNPaDMekdormbXciadCFbW1CQOV4LIYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TXmBNGN4; arc=fail smtp.client-ip=40.107.200.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXMrs5mFfil4kh0yJ1jgLabtIvSQTlCtn1M/3PzL8YA3W+KgzfBI5NmTgB+F1so6Qst9ZuBPvnae9asyddtjDB19Y8TEdnYj9pjBDaF4nVjhF4XFqOub833lpqgyFSHm+7PeOZdKXaSqdb8iJ/DzZn/8UY6W/jg3TMlW/boHOVNEgbgZSuuHudkkcDlH8UFeyTU23lBnaW/pJUDMBFp05NsF06nFJ3ndb/OwY8mdpnUqRLwXBvuZpVdUSqM5FQMREKhw3rlgICZuDITYNNSelahG8e90VQd2+uSDH9hp9SfLsRMbKNrxpzPCJsC7g22Y6bJbLxECcoaAkyhoggw4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aM9nrOWrcyVch4u/KEXHpXHoy35LzK0y750n1OCJ9qo=;
 b=nuvhNudzh0z4SiJxIgFVpMrhGHhj49FO3098a1KIAc9UeSLusn5iKhdlIaI3FpKd6fOLDmjuSn33MW0I1MyIK+DYymj1j5YEXKxms7UFV8eegglQdNOYocS+Fx0GrIdpG7nTBkm0BDVhMmPml+bJn/ZdT1Zw6i3m9o3X9c6fVX+WiseShptquZ5ZOpmga+kTnlpW0F9bCSNayYJouHBTcQNp5pIrV5WNmkSfLp9xGIL/BU8+ybOP2X5qa5okr3g7l/FnHHiSobaOqVqJvy8P7bQaUrAX3frD1E9xHPlymN0GvE52RP17UzQ1Gp3xtth4ZRWJwB5SQ+Lveko1KXSR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aM9nrOWrcyVch4u/KEXHpXHoy35LzK0y750n1OCJ9qo=;
 b=TXmBNGN4LGYp5xZYfCHaj/am5ZtFsVFCq1jBplQ4WITQp36CDm7kSh5QXQDLn5+1/pu8nLVodz+gtd9GjAN2uEqiYjuOxng7X3AR4811MqiH439tgw/JHZtoFpolZJYxRTUrvJL9FgFAbnFnulfH6Wrky9Wx+eGHIa702OXb7NY=
Received: from DS0PR12MB9273.namprd12.prod.outlook.com (2603:10b6:8:193::14)
 by CH1PPF8423FDA82.namprd12.prod.outlook.com (2603:10b6:61f:fc00::617) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 15:57:57 +0000
Received: from DS0PR12MB9273.namprd12.prod.outlook.com
 ([fe80::a3be:28f9:394b:74e6]) by DS0PR12MB9273.namprd12.prod.outlook.com
 ([fe80::a3be:28f9:394b:74e6%3]) with mapi id 15.20.9228.011; Thu, 16 Oct 2025
 15:57:56 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf
	<jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Asit Mallick
	<asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
Subject: RE: [PATCH v2 0/3] VMSCAPE optimization for BHI variant
Thread-Topic: [PATCH v2 0/3] VMSCAPE optimization for BHI variant
Thread-Index: AQHcPj9sJw6GnRVPMEqIRDpNzR7ljLTE7nGA
Date: Thu, 16 Oct 2025 15:57:56 +0000
Message-ID:
 <DS0PR12MB9273669FB9A3DBE8F53C51FA94E9A@DS0PR12MB9273.namprd12.prod.outlook.com>
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
In-Reply-To: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-10-16T15:56:44.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9273:EE_|CH1PPF8423FDA82:EE_
x-ms-office365-filtering-correlation-id: 718aa1f8-0d91-41ba-4aae-08de0cccc608
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EgAQvzYpfTaNNKHaG4DJtZF3rm90xwmfvvXNJCvru7BPIcL3c1pTKGQ9I7Qv?=
 =?us-ascii?Q?tazTAep/adD8yo3O+nmtsPvrQwZDKRcFOe1rQsBJaWX95cXrSyWyWU1DfXMI?=
 =?us-ascii?Q?gW1TWUHpYNK9ivKo/js9Iv5i/S+ATwfcXkMmAZFfv/cv7SB4ku0vd0mMQgtc?=
 =?us-ascii?Q?dvYUjBsGi/jOkZdWK18fVam1Q+rRpHdUwfjQV520uTN5I8AUuiUMNkJX57+E?=
 =?us-ascii?Q?h6NqOx0cL2k1Ym3usBho1bj0vC4CDXtglvF7iIZ2rNp57KRThpQ9QQGwKEKp?=
 =?us-ascii?Q?9DS4aKpcd2L1szyfKa5SpmJHqapJuDy7jPqi3FITgr47NUFy62ogPULahhOx?=
 =?us-ascii?Q?KUyU5/DI2tgCQFXfjyZ7v8cgmkb1rWTwiGp4Ye30YEu1lGncBrUMwIcYyTbj?=
 =?us-ascii?Q?+hYgIexRpzxGJHUB4/tX38PW14oyLvo4mHEeVHFfljLbHd6u9v4v1raSI7ea?=
 =?us-ascii?Q?KU7rw4eSF2RRYlc8FXd+lzRnoJ+Dr0fu0tjVoH026eiJSRt3TCpXl2fsFuPc?=
 =?us-ascii?Q?11D+SBFBPRB8Ps2UvPJTK45+u/bRyY/W2q1a485D50vCGSgUjxQjGTvN06hT?=
 =?us-ascii?Q?KQrCgDo+bALXuv3WrICHe4haLZj7Wnizd1gu6CV4IzVbTZKpoYzIdsYgvWxl?=
 =?us-ascii?Q?0gPvspCJSCC93tG/1gaNopTdd4k5M5LivU4e2+74qVfdmGSTmI8ri6ZNZss4?=
 =?us-ascii?Q?bid7+L1+IRN520cfYOk+pWj33W5qY0TAJQALpYEOmxLVf9Mkrzmtd7FUd+/9?=
 =?us-ascii?Q?C0ZjoqvmMeyj3ec1lV0SdWKU5gDAIKYFuLCH45o/U86racuCg4VsT+vOv/2B?=
 =?us-ascii?Q?B5eA2wytiT6Ibr635bsNA/95fe97oX9baD0Lp7L2ZUOpXeUXsvtNyfZDBs5X?=
 =?us-ascii?Q?WqMnx2ipVunN0PRFgnI6CNwljL7hjZbFrgDnDhseqDlPJExqPV2ajsNYaWYp?=
 =?us-ascii?Q?DsM3jmlUJF5d2i4iTIOoak2WXebIC2h6GTR9WqyG0/8sO1YY/1bOLiZlsuNN?=
 =?us-ascii?Q?pDdk5ZPt2yy5dmHklKQEVNbz0JSXTpftTsL3gC42U7kRbua16Kq+/slkdrM1?=
 =?us-ascii?Q?QsmykwgUcLbKN8UC0N/YRhEaordcE5IbfKc3f/4O7op7ifErNnggcjIT3CDK?=
 =?us-ascii?Q?IPMKSg1utkXXoIDSdDegs0yUTJN6im4qUX4gQ0NE9e41xzE6YBUvZjCm0fIE?=
 =?us-ascii?Q?dGOGZL3+Za8ZmY9JV0w0QALWCh8OOaKQil9n+d8Q1awAxekW4G2kyfIKtzWa?=
 =?us-ascii?Q?JZcfITU26QTWCljrdlELCE24IeVzZhhCcLSwWDitfawRA5TbZH9M9I3BbMT1?=
 =?us-ascii?Q?+7EOCFlgxPNLFneDFjLQh9Z+J11yq2EuY7c9zMlNcdJNHW+itfOpCf7L4sCO?=
 =?us-ascii?Q?3+43wS2aIx0xn1q5WC1L6IywH3rNr6YgC8rM9dqQwoIPqo2FtxQdYNVY7Rwg?=
 =?us-ascii?Q?z5rQB/3EqGH407CEByTUhtXJJAVjOOi8YACbN/90ElDkAsKIkKM2Cg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9273.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gdVpERQpPoaLjwkhk//BcIhAYgjLDaM53eZvsNhtt6PFL51jvjrt7ZQCDJuX?=
 =?us-ascii?Q?1Y+3sSYxMy9z5Rp5hSXsyqVIihY4/I5eiBlgm0T4nceZeVhA8AsYNaRkrnvf?=
 =?us-ascii?Q?wkWGe2OX5RmtkcrXCR5elbq0m1UojxwVoR4EAnjL6J81P+Tx8t70PZbRDOuV?=
 =?us-ascii?Q?rmi9/knuWWF16Guo6b5DurJAg8AEA6I9qYwnJgbkEw75yc1jAzEt0GqwjcFP?=
 =?us-ascii?Q?7mJihgPdQRhPpS/KdzezZ4G3cjKEnennwKPzVSwaNNVbesEMoYUc2wDlL6bs?=
 =?us-ascii?Q?qdkJ0f5fZXjsLe86z26Mk03QkeA9KWt0WGRfHmg4yZn5TSQrzjHDyZqgwyo+?=
 =?us-ascii?Q?9hasAz0HOH08NtOJr2XkxnCiC6sPqc45InBSoEn1b1Xc5EhX0n5Ecuzlbx8f?=
 =?us-ascii?Q?uDKfCuNPPAr6KNRb/h6M7kYpnK9LXjWl4Iu35j9ja+PKpOVxl5kpOjzu0xMc?=
 =?us-ascii?Q?p7C+gx4UXnr79JoN1tdKQIIhj6DQgS4mKvT4d7/YUgv2iTcCTGVLa98K0iz7?=
 =?us-ascii?Q?gAkYV3LbY1WkuTTd3PLhnMnIRRApaPoHR+HMOVtriiUMlKbC0WWyRijkDYys?=
 =?us-ascii?Q?55v+EuQE2XLxNf1DZCMaifBeUZo12YSsm3Eik7TBVuuC1qJq5cQb2qLM8JCw?=
 =?us-ascii?Q?5IsvaykfM9DkKhNVmRJhMCMK1EU1eQVWJZ4Zobd/zfYBbhej3+zjpL31P6z7?=
 =?us-ascii?Q?nZ7IDuvpK/Gri2yPfgY5Om0UvkR+5gBx0rUmyOJoht9k1NnvkiOOFW/6tTHz?=
 =?us-ascii?Q?gpYxva8QmPi+v/vpNCsBxlg680M0WOvC1AnvhV7On8U5DRQmOatm7EclyIfr?=
 =?us-ascii?Q?ni1Jj4QJ4xjNbuNjFRknLyeQvKFl6LSAgMkWynRIkQDITskWiXhAAs6b6gS6?=
 =?us-ascii?Q?cs3v96qE+NaF2y0h9BeMmSngF2gRhtxH+rxoRFq9ZAf4KcnYI2rKyNRmrfXm?=
 =?us-ascii?Q?tqOmKs/ZKSqCH4Stm313bs3F4uLfPdQxfiFQ8i1Eb0sjQZL9S0gpr+cCYs+j?=
 =?us-ascii?Q?5F67g5uaM86YVZFtS7GMgR0R8PKjDWA9ry8VVNNzZ66ucSwBdpcrYklQCxst?=
 =?us-ascii?Q?SdT/jny+v2Htopb7inHpFjBIUB7JvPjmCgK8t+4TdSsh8JXT7XDm5Ocm1ewm?=
 =?us-ascii?Q?Wvr1IgAjFpJ+/K8L9Yyo+/P8CB65mRCB+a8iAwLi4qHNH8Wl0CBGriON6uKo?=
 =?us-ascii?Q?YzBOUokLhaq1MFjH7dqU4ZeJazGjSuF+NFKXaZsAJZbhF7DVslKr0o0Fan0u?=
 =?us-ascii?Q?+5zqLKD/rcOTtLWVDhu1JD/EOdPZNyCQ9DvqdJLYRUGrF5lSR0u7kA+fkNKf?=
 =?us-ascii?Q?nwq26URvAk5djNqgM3bmr6VNTmCGuof/2uU8ybyA4d5g6cRDMIFb//ba1HH1?=
 =?us-ascii?Q?R8oWxSPkq2DUhkS1hCpJHAyi8VsuaxyQyYJefAo3ujrAeY0vx3UipDR/43fy?=
 =?us-ascii?Q?MIeNt71TeGybSX1sPiEO7DpskKw9ZBMtaNotBl84qa0qxMkNhUL2MLm5Rtcs?=
 =?us-ascii?Q?SYGvR4XJ+pqiCcPRDxvZEtO8cjw/9aUXkjXjeutM2OtHhtCr+T2fzB4bMP5u?=
 =?us-ascii?Q?/7yuId/uUEKXgeCiEIc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9273.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718aa1f8-0d91-41ba-4aae-08de0cccc608
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 15:57:56.7838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1I8GkKc1Z0SriAaC+6IxbKyFQ7+wX2lIyCdRdoy4cVjCSv1XzHGy5vhUuj1Fu4Qy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF8423FDA82

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Sent: Wednesday, October 15, 2025 8:52 PM
> To: x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; Josh Poimboeuf
> <jpoimboe@kernel.org>; Kaplan, David <David.Kaplan@amd.com>; Sean
> Christopherson <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Asit Mallick
> <asit.k.mallick@intel.com>; Tao Zhang <tao1.zhang@intel.com>
> Subject: [PATCH v2 0/3] VMSCAPE optimization for BHI variant
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> v2:
> - Added check for IBPB feature in vmscape_select_mitigation(). (David)
> - s/vmscape=3Dauto/vmscape=3Don/ (David)
> - Added patch to remove LFENCE from VMSCAPE BHB-clear sequence.
> - Rebased to v6.18-rc1.
>
> v1: https://lore.kernel.org/r/20250924-vmscape-bhb-v1-0-
> da51f0e1934d@linux.intel.com
>
> Hi All,
>
> These patches aim to improve the performance of a recent mitigation for
> VMSCAPE[1] vulnerability. This improvement is relevant for BHI variant of
> VMSCAPE that affect Alder Lake and newer processors.
>
> The current mitigation approach uses IBPB on kvm-exit-to-userspace for al=
l
> affected range of CPUs. This is an overkill for CPUs that are only affect=
ed
> by the BHI variant. On such CPUs clearing the branch history is sufficien=
t
> for VMSCAPE, and also more apt as the underlying issue is due to poisoned
> branch history.
>
> Roadmap:
>
> - First patch introduces clear_bhb_long_loop() for processors with larger
>   branch history tables.
> - Second patch replaces IBPB on exit-to-userspace with branch history
>   clearing sequence.
>
> Below is the iPerf data for transfer between guest and host, comparing IB=
PB
> and BHB-clear mitigation. BHB-clear shows performance improvement over IB=
PB
> in most cases.
>
> Platform: Emerald Rapids
> Baseline: vmscape=3Doff
>
> (pN =3D N parallel connections)
>
> | iPerf user-net | IBPB    | BHB Clear |
> |----------------|---------|-----------|
> | UDP 1-vCPU_p1  | -12.5%  |   1.3%    |
> | TCP 1-vCPU_p1  | -10.4%  |  -1.5%    |
> | TCP 1-vCPU_p1  | -7.5%   |  -3.0%    |
> | UDP 4-vCPU_p16 | -3.7%   |  -3.7%    |
> | TCP 4-vCPU_p4  | -2.9%   |  -1.4%    |
> | UDP 4-vCPU_p4  | -0.6%   |   0.0%    |
> | TCP 4-vCPU_p4  |  3.5%   |   0.0%    |
>
> | iPerf bridge-net | IBPB    | BHB Clear |
> |------------------|---------|-----------|
> | UDP 1-vCPU_p1    | -9.4%   |  -0.4%    |
> | TCP 1-vCPU_p1    | -3.9%   |  -0.5%    |
> | UDP 4-vCPU_p16   | -2.2%   |  -3.8%    |
> | TCP 4-vCPU_p4    | -1.0%   |  -1.0%    |
> | TCP 4-vCPU_p4    |  0.5%   |   0.5%    |
> | UDP 4-vCPU_p4    |  0.0%   |   0.9%    |
> | TCP 1-vCPU_p1    |  0.0%   |   0.9%    |
>
> | iPerf vhost-net | IBPB    | BHB Clear |
> |-----------------|---------|-----------|
> | UDP 1-vCPU_p1   | -4.3%   |   1.0%    |
> | TCP 1-vCPU_p1   | -3.8%   |  -0.5%    |
> | TCP 1-vCPU_p1   | -2.7%   |  -0.7%    |
> | UDP 4-vCPU_p16  | -0.7%   |  -2.2%    |
> | TCP 4-vCPU_p4   | -0.4%   |   0.8%    |
> | UDP 4-vCPU_p4   |  0.4%   |  -0.7%    |
> | TCP 4-vCPU_p4   |  0.0%   |   0.6%    |
>
> [1] https://comsec.ethz.ch/research/microarch/vmscape-exposing-and-exploi=
ting-
> incomplete-branch-predictor-isolation-in-cloud-environments/
>
> ---
> Pawan Gupta (3):
>       x86/bhi: Add BHB clearing for CPUs with larger branch history
>       x86/vmscape: Replace IBPB with branch history clear on exit to user=
space
>       x86/vmscape: Remove LFENCE from BHB clearing long loop
>
>  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
>  Documentation/admin-guide/kernel-parameters.txt |  4 +-
>  arch/x86/entry/entry_64.S                       | 63 ++++++++++++++++++-=
------
>  arch/x86/include/asm/cpufeatures.h              |  1 +
>  arch/x86/include/asm/entry-common.h             | 12 +++--
>  arch/x86/include/asm/nospec-branch.h            |  5 +-
>  arch/x86/kernel/cpu/bugs.c                      | 53 +++++++++++++++----=
--
>  arch/x86/kvm/x86.c                              |  5 +-
>  8 files changed, 110 insertions(+), 41 deletions(-)
> ---
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> change-id: 20250916-vmscape-bhb-d7d469977f2f
>
> Best regards,
> --
> Pawan
>

Looks good to me.

Acked-by: David Kaplan <david.kaplan@amd.com>

