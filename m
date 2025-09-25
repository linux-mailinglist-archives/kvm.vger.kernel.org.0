Return-Path: <kvm+bounces-58812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C02D7BA0FB1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 20:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C0BA188C648
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 18:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82B0314B83;
	Thu, 25 Sep 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V+48MIyU"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0870C313552;
	Thu, 25 Sep 2025 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758824104; cv=fail; b=V8c7EEOsBHDVT/J5lS1Kur3hNVJCgDDpI7VHJzWwHUuAingMBqvjFSBjfdbY9jWlxBFmKKjgdOcUoa9JGmTMYLhRDjmuVHQkRKH+ytnpJz9POjsgy7i1b6OXikJ/tqWBWi0Md+kArps3rjbf5nlUiHb4rqHNcuuJIKzO4YNUgdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758824104; c=relaxed/simple;
	bh=8V9X7wtLCmbgOpkBmG6y4rzAKXkCF3I+ZTowBRoy3Lk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CdgoPbHWIVVHzoivfnNlkjuUOiHrVaeXbTGVzJ5mq8+9viwu/LM4BcAn8wlJE9V6oZStTiRaWzirM9/kpRhjd9D/y0vOa/9Mn3rgPgPHb9G/AP02hQnPBsd/YINc7kHpRDVvWA7YrMkeeLputXOVl5lvM4/Kw0j0SQ2uKiMeOEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V+48MIyU; arc=fail smtp.client-ip=40.107.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGpEVccZ8Qivr6WCPOAbXMc8KPWF1/24IOViY8aRaGYySMW1nWXMLTRZNu7BjXG11KKkDYglfjojQi5uJ5sLS1hIpNP34YsKofG9O7xcLrE/1Bcaa5v4gtdbL/SHVoVZ/ihoRjw79CEZsBCbxPbQn8XJ5hMTPBuCNoEA0ueVY8iI669ZIvKQ3V67ja2cXTuzkuiux5KxxjJHXz4sjEwjBkYL6y2x+MW6ZPcRCkpSDIHyORhTqw2B9qu3qUMGfJJJeS+d3bMPoYx+nF5OoGlSWe/bQk8WYhOFGWmf8LVCI5UB9J0kOgCKh4PBMYguu3TLlt36MwjZCnW1dZw2S4UHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RB4TXZ1EDqFl6kx4T8Q6b8U5sLcbAqvRSk/Gbm5Ed+g=;
 b=SuNKnMN8bI/3iQLepTf05WhLj318O8gTPkuA2fsLtPTnsRuShDYtBPudhGQi5GCD2nzJMfEd1JHum135OTxKFz8TfSml2NRNhtkCxHhMrtMiq0gadMa2rNZnzhvqacX2hyF9asGmNI/nae9zXPix694sHv5pLDTUAxNB6nSvuOBvFajfy3hEb4Hui6ZAAollrqBx+TKgC+Vacp28ZWAI6jKyFM8KXnp/+FrspOPZoohIvOdQTthwpqpx3yp/npTMF/EeHuuBuHsu5zPlh/gmAqif+yhwHjA6wmzts33XZNgMFJi6RphqOCxX0lnAuNVKbmz6jiD3cLBungNd71Zyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RB4TXZ1EDqFl6kx4T8Q6b8U5sLcbAqvRSk/Gbm5Ed+g=;
 b=V+48MIyUK1g9pc8yufrXEJaJAf4pVXajHHKOAOdloH2HboXlf/grCpDJjaKHE0EPnM0h1qSvwc2kO7gleggzq+D5lz1mmtlUFTVYQ73bbIBub+aHUykniJVBmypaQ+L4WpVM8HgNQq/Kml/DgU84pZRzMUY7o7lzCegYIL8cugY=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by CH3PR12MB9431.namprd12.prod.outlook.com (2603:10b6:610:1c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 18:14:54 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 18:14:54 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf
	<jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Asit Mallick
	<asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
Subject: RE: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Thread-Topic: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Thread-Index: AQHcLcnkEpgFX/ZIl0y6qFiuZVHWGrSkMVpw
Date: Thu, 25 Sep 2025 18:14:54 +0000
Message-ID:
 <LV3PR12MB9265478E85AA940EF6EA4D7D941FA@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
In-Reply-To: <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-09-25T18:01:49.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|CH3PR12MB9431:EE_
x-ms-office365-filtering-correlation-id: d1dce410-6981-43b8-5ac9-08ddfc5f6d78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?VP+rduu7JJuYqE6bG4AbSALtf20UzZhCuMyl8004vASlI35xscXF4P6n6kpg?=
 =?us-ascii?Q?0pRATzpxisYiSnmjaYimEgDMi0VInEyjs4fDhoqpcIlHjfP3qf0ufRWPqN0x?=
 =?us-ascii?Q?+1RHZUmg3ZnQ23utc6XIUKTuscGXj+GzIuwKOTqffoSASp/va8OjThBBRd0J?=
 =?us-ascii?Q?bvM1E7uj/xL7EaITfcSbNSLVikPm1IGY9fZeC3J6XxR5ocUdRMYFO6FTUKS5?=
 =?us-ascii?Q?8rx/NpT2LB55yzH3+7ou+rX1UsC5zZP7A5KgV7kff38KlWTVVjgPhQEhGI6f?=
 =?us-ascii?Q?ovqQhKF/WFBSbUYsRzZVhOABI9WiP94TePjW1qsPLj3vgLldbrlVpFgdRcQO?=
 =?us-ascii?Q?IhnlZD9zky71eCjoNDyUwvZPmxuMwp0cY0F7Ros8qTku+olPHmse8xiXa1cp?=
 =?us-ascii?Q?rhprBQSLhPZbPkFmalPTCZTDoh2AF1cJiHBFQ3LtUIzTX7SDcc6ubrkdnQ9X?=
 =?us-ascii?Q?up/ICNrOYpbHI9d+oiYjfZYsqx1Y1CnyRb0vhccACwCZ0hGSg1g4ii1P2tTb?=
 =?us-ascii?Q?1h79+k5XJtZs/nyMNXjqJdvyDkZ7k1LkD5/6JrSQKBA+dO7PirXZ1rh+em6H?=
 =?us-ascii?Q?yq/d0vNdgZt+hrtuI3bE6KsoxMsKKrNAUAml/9fNtXCGSm6Jzz+aT8AWtIrT?=
 =?us-ascii?Q?JqbuwYdYOMXpsakwPzoq+R2W/jO5m1sJh5ds5eudoUq+BM4QSHPpig4Yb9kR?=
 =?us-ascii?Q?ajgIYOG44N6HDFxKRCZ1IsRxjM5iwx2TnFgeoGWWSEAp1hlX1T5M68qW+MTk?=
 =?us-ascii?Q?mXCWsxM6S+YO4Qs0vBYoql/NvMjyRLiYodneCzMkikBraUpT1wBgbwbg6YR/?=
 =?us-ascii?Q?1/0VIXRI0kIi24wyg7kKomRpN7CVhWwBdL+G4SvSrCLlV2J/n51jmBAA4PAe?=
 =?us-ascii?Q?LxjQQRGxhAlAh1efoL0kGU5wwhYiyPNwCOz9eIZqBpo9o9mZM64a7ZOGF0xh?=
 =?us-ascii?Q?CQG0LfcqWTgdad5y8a7NRCtgYJEBJDTAdZJBfCo0FZTdRsl4isUFFmdtKSne?=
 =?us-ascii?Q?rpzyrePNufQvjC2SmZ3I5X1ewWIFYdVNbHl/UHhh5JXJbQrRWlMNVi23Y0Ul?=
 =?us-ascii?Q?uduQbe1ni3YBK426EsKIXUXX00KD2TTOqzu9UkWUkafU3oTq3LLNsiq2/Y51?=
 =?us-ascii?Q?TQqJTWF+yuh+W5/bkhuF7lCyGCaiZFUZ528IHiLd2MV0IhwUr0irMm4a2C7R?=
 =?us-ascii?Q?OOQLM0aS7Rm7rIb1g0t8nrXCoJG0SxGbnVAE49HdPu/sYC9n9dr77GM9ifZe?=
 =?us-ascii?Q?lnsQdfdtI2gVVPbA56BREN3K0CtYonyCvLF0fLrVssfpZAwoev8+/cjla0r2?=
 =?us-ascii?Q?/tsOAd66CfDfLhmx0fyPFa0ibdROYCP7KzsxxjuC2p0KnZ5mUyJLuiHVQjlZ?=
 =?us-ascii?Q?lspPj9BvolrW4Y2PDEbO5VajwULj6xctoYNxnCseWZ7Ak4A2R0/U41L+2PCE?=
 =?us-ascii?Q?JZwncnV+qc/AjQRIw7mmum3RTA+vlsH1q+xoL/IuaR4aMDG1vXsncQ/3BG9m?=
 =?us-ascii?Q?lqKh2zy87F3dGX1zOm4eE6k50z+bCHgHXqMp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?2nXpRWn8yjplUxIEC0BJ2UV8Kp5x2UsvfHP+B2FuldWpSQ49ShsZWr2nHpU9?=
 =?us-ascii?Q?mxD9CU1L9Ss1qCE+MJWH6GTbAxavWL22v0O4I0dHL/0gRUhiBfLT7wALTpQf?=
 =?us-ascii?Q?zmOWE3tk17lj6OZMOGHG5DNs/kQ5i8OMj88olfIbRZ61wo4J74enFZobmQ+f?=
 =?us-ascii?Q?F7CNw8p7Z+MxvEpw4SN/f8oTHJsus1jxZLRgBBnROV5p+HDcUMZy9ysTwE5a?=
 =?us-ascii?Q?WDo73GnylviAa5WMvGOR43PpKIoGG506TFei7HqPi0fXirSls5hVzf0BF9Ra?=
 =?us-ascii?Q?0PZcD1vgkG6m4w5jTZTXqgNa50S23XbFj/KKWjkSYC9489BsAP0PYWVHkWhC?=
 =?us-ascii?Q?kQcv3+lMeOj0CAKGJlA6++ao+iJ5fwn5mFM/g2zBFeb0nMNbuZ2up18NlBvj?=
 =?us-ascii?Q?7XMJc1kQbN7M+B3Y1gaXAZaxNoSpxTm8cJrjwFAUmcnHec2IJ5+rpQ6QK5R6?=
 =?us-ascii?Q?kHLv3eUa6/q7yqj19lnG4QlB8ZSmtZslX84C0PBKAOq/Nb82lPvG7d/5uVva?=
 =?us-ascii?Q?OwGPIDZeBWyClco2PR5t/sB+FV1RHlqr9fCwLM4yqBUTHuZSh0QxSR6ThdsK?=
 =?us-ascii?Q?crBCfU+sl3WZuIb+Xoavv6iqZK7x9rC016d50EamdgbDgpig/Kht5jI6HKij?=
 =?us-ascii?Q?hr65x+r3GCxlQNCQwvep/L6ph30KavqqREwK78yJeobQa5AdlYqT4loHwVDd?=
 =?us-ascii?Q?6rbid2OADXu0GgM5roI6dkjzVXJIYHmCGjppY7Z2ea9x3CaizCSqnyVQ+FcY?=
 =?us-ascii?Q?75GupnJIAJEFZH+vzf1ncIps4yTS+GHzPyxI0KyYKzlyIY8UYdSaU0dbB61Y?=
 =?us-ascii?Q?oA98tO6U7KqwZyyCHyrYTzLRgkcozNkwQ0cPxL75N4LV3XZYJCHODuHLH3qI?=
 =?us-ascii?Q?aSX09XR6QHhfblrVMdBWE9RCajR28cOkRCG2SloF2B2iduYxgqox513qWV5o?=
 =?us-ascii?Q?/vKWrtrilxuw57WkLXLdSXgKuZRn2uElgAZx5kj9udzhGxzxyIm7t4zrfGex?=
 =?us-ascii?Q?YF4ZUF1HEe4nWmljhqxOBUNEimAwRElAzBITrXv7oZEF1i6OcL6zWMP5YcbF?=
 =?us-ascii?Q?WkDXhqhnCT5e4y6Ez9JOiZf7MVB4ohnYrm1r+3FbJVaujRxgVMzxrGFcIR3Q?=
 =?us-ascii?Q?PAPZkyM44kPE48efzLA+OkXc1MEyI+TS14/9C6aWD+m0N3mfEizjDcwCIpnD?=
 =?us-ascii?Q?pwmQ6MZmaKz/bQ1SLkz/k3O1w1vIbFT6UF28xbYpXld6IPQWnh1ZnMLnWuCK?=
 =?us-ascii?Q?a1Rv6FnNnZaQaMxNMsRE2usIDOhj7wUW+gHAd73uzgbDAPeZfAIpSplCRTk8?=
 =?us-ascii?Q?bQHFoGAHT0uXWEfRWAtknqlkKh/NcHsGFreosFA3yEH4olDoS7L/n0QkUddt?=
 =?us-ascii?Q?A3c0rLUJBt2xBWtRm3lFHOtewFmra8Ae3cON1PfdCbNhLZzaKZklv2J7m5sq?=
 =?us-ascii?Q?v6M+o6xFvNNu5mhlJh/KI9TYilK7gR23gj6ZRXeqXGUgrKwte/75pYc7wBRc?=
 =?us-ascii?Q?GYytdvRLKHrwtyJ1T/ptG9MbXSQO0p6+gDXiy/WhK0em9XsmBxaAMBXNOufn?=
 =?us-ascii?Q?M+bkPuXmkN1hHFDxPx8=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dce410-6981-43b8-5ac9-08ddfc5f6d78
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 18:14:54.4847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D2URqyLtUjg6q67ymoAVEIHu2DKODPbMJi6riWwOa7QSTk2QMLtWm052HkmUsqxr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9431

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Sent: Wednesday, September 24, 2025 10:10 PM
> To: x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; Josh Poimboeuf
> <jpoimboe@kernel.org>; Kaplan, David <David.Kaplan@amd.com>; Sean
> Christopherson <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Asit Mallick
> <asit.k.mallick@intel.com>; Tao Zhang <tao1.zhang@intel.com>
> Subject: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear =
on exit
> to userspace
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affecte=
d
> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> indirect branch isolation between guest and host userspace. But, a guest
> could still poison the branch history.
>
> To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> the branch history between guest and userspace. Add cmdline option
> 'vmscape=3Dauto' that automatically selects the appropriate mitigation ba=
sed
> on the CPU.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 +++++
>  Documentation/admin-guide/kernel-parameters.txt |  4 ++-
>  arch/x86/include/asm/cpufeatures.h              |  1 +
>  arch/x86/include/asm/entry-common.h             | 12 ++++---
>  arch/x86/include/asm/nospec-branch.h            |  2 +-
>  arch/x86/kernel/cpu/bugs.c                      | 44 ++++++++++++++++++-=
------
>  arch/x86/kvm/x86.c                              |  5 +--
>  7 files changed, 55 insertions(+), 21 deletions(-)
>
> diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst
> b/Documentation/admin-guide/hw-vuln/vmscape.rst
> index
> d9b9a2b6c114c05a7325e5f3c9d42129339b870b..13ca98f952f97daeb28194c3873e
> 945b85eda6a1 100644
> --- a/Documentation/admin-guide/hw-vuln/vmscape.rst
> +++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
> @@ -86,6 +86,10 @@ The possible values in this file are:
>     run a potentially malicious guest and issues an IBPB before the first
>     exit to userspace after VM-exit.
>
> + * 'Mitigation: Clear BHB before exit to userspace':
> +
> +   As above conditional BHB clearing mitigation is enabled.
> +
>   * 'Mitigation: IBPB on VMEXIT':
>
>     IBPB is issued on every VM-exit. This occurs when other mitigations l=
ike
> @@ -108,3 +112,7 @@ The mitigation can be controlled via the ``vmscape=3D=
``
> command line parameter:
>
>     Force vulnerability detection and mitigation even on processors that =
are
>     not known to be affected.
> +
> + * ``vmscape=3Dauto``:
> +
> +   Choose the mitigation based on the VMSCAPE variant the CPU is affecte=
d by.
> diff --git a/Documentation/admin-guide/kernel-parameters.txt
> b/Documentation/admin-guide/kernel-parameters.txt
> index
> 5a7a83c411e9c526f8df6d28beb4c784aec3cac9..4596bfcb401f1a89d2dc5ed8c44c8
> 3628c9c5dfe 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -8048,9 +8048,11 @@
>
>                         off             - disable the mitigation
>                         ibpb            - use Indirect Branch Prediction =
Barrier
> -                                         (IBPB) mitigation (default)
> +                                         (IBPB) mitigation
>                         force           - force vulnerability detection e=
ven on
>                                           unaffected processors
> +                       auto            - (default) automatically select =
IBPB
> +                                         or BHB clear mitigation based o=
n CPU

Many of the other bugs (like srso, l1tf, bhi, etc.) do not have explicit 'a=
uto' options as 'auto' is implied by the lack of an explicit option.  Is th=
ere really value in creating an explicit 'auto' option here?

>
>  u64 x86_pred_cmd __ro_after_init =3D PRED_CMD_IBPB;
>
> @@ -3270,13 +3269,15 @@ enum vmscape_mitigations {
>         VMSCAPE_MITIGATION_AUTO,
>         VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
>         VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
> +       VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
>  };
>
>  static const char * const vmscape_strings[] =3D {
> -       [VMSCAPE_MITIGATION_NONE]               =3D "Vulnerable",
> +       [VMSCAPE_MITIGATION_NONE]                       =3D "Vulnerable",
>         /* [VMSCAPE_MITIGATION_AUTO] */
> -       [VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]  =3D "Mitigation: IBPB
> before exit to userspace",
> -       [VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]     =3D "Mitigation: IBPB on
> VMEXIT",
> +       [VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]          =3D "Mitigation: =
IBPB
> before exit to userspace",
> +       [VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]             =3D "Mitigation: =
IBPB on
> VMEXIT",
> +       [VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]     =3D "Mitigation:
> Clear BHB before exit to userspace",
>  };
>
>  static enum vmscape_mitigations vmscape_mitigation __ro_after_init =3D
> @@ -3294,6 +3295,8 @@ static int __init vmscape_parse_cmdline(char *str)
>         } else if (!strcmp(str, "force")) {
>                 setup_force_cpu_bug(X86_BUG_VMSCAPE);
>                 vmscape_mitigation =3D VMSCAPE_MITIGATION_AUTO;
> +       } else if (!strcmp(str, "auto")) {
> +               vmscape_mitigation =3D VMSCAPE_MITIGATION_AUTO;
>         } else {
>                 pr_err("Ignoring unknown vmscape=3D%s option.\n", str);
>         }
> @@ -3304,14 +3307,28 @@ early_param("vmscape", vmscape_parse_cmdline);
>
>  static void __init vmscape_select_mitigation(void)
>  {
> -       if (cpu_mitigations_off() ||
> -           !boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
> -           !boot_cpu_has(X86_FEATURE_IBPB)) {
> +       if (cpu_mitigations_off() || !boot_cpu_has_bug(X86_BUG_VMSCAPE)) =
{
>                 vmscape_mitigation =3D VMSCAPE_MITIGATION_NONE;
>                 return;
>         }

It looks like this patch is based on a tree without vmscape attack vector s=
upport, I think you may want to rebase on top of that since it reworked som=
e of this function.

>
> -       if (vmscape_mitigation =3D=3D VMSCAPE_MITIGATION_AUTO)
> +       if (vmscape_mitigation =3D=3D VMSCAPE_MITIGATION_IBPB_EXIT_TO_USE=
R
> &&
> +           !boot_cpu_has(X86_FEATURE_IBPB)) {
> +               pr_err("IBPB not supported, switching to AUTO select\n");
> +               vmscape_mitigation =3D VMSCAPE_MITIGATION_AUTO;
> +       }

I think there's a bug here in case you (theoretically) had a vulnerable CPU=
 that did not have IBPB and did not have BHI_CTRL.  In that case, we should=
 select VMSCAPE_MITIGATION_NONE as we have no mitigation available.  But th=
e code below will still re-select IBPB I believe even though there is no IB=
PB.

> +
> +       if (vmscape_mitigation !=3D VMSCAPE_MITIGATION_AUTO)
> +               return;
> +
> +       /*
> +        * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use B=
HB
> +        * clear sequence. These CPUs are only vulnerable to the BHI vari=
ant
> +        * of the VMSCAPE attack.
> +        */
> +       if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
> +               vmscape_mitigation =3D
> VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
> +       else
>                 vmscape_mitigation =3D VMSCAPE_MITIGATION_IBPB_EXIT_TO_US=
ER;
>  }
>
> @@ -3331,6 +3348,8 @@ static void __init vmscape_apply_mitigation(void)
>  {
>         if (vmscape_mitigation =3D=3D VMSCAPE_MITIGATION_IBPB_EXIT_TO_USE=
R)
>                 setup_force_cpu_cap(X86_FEATURE_IBPB_EXIT_TO_USER);
> +       else if (vmscape_mitigation =3D=3D
> VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER)
> +
> setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER);
>  }
>

--David Kaplan

