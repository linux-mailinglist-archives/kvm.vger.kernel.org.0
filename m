Return-Path: <kvm+bounces-21257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A44192C961
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 05:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 025D02831D0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 03:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264C83FB01;
	Wed, 10 Jul 2024 03:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oDG2dmX8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5594A24A08;
	Wed, 10 Jul 2024 03:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720583051; cv=fail; b=uANloKMFeJDZP81LXjyc6MH75zkMh6LK2yoChigJrHERpmjctzj8Mne8pJqfJ1GhHfbWLArQtVIITABJaROERth68wWpj1PvAs0NH4mcOs3Hf8+PAzUPolk/EsDJ3/POSlvC/znyHkJiMa9+xO4oqqSK3P9sIvc9ajL8mCysazg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720583051; c=relaxed/simple;
	bh=Jvv0bkH3L4YW9FDd8WDy0gmZWTypRL8hNz+P2bU4hAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JapW38wR9N6JZsT4+JEFwmx15IWoaH0CczwJlBledrbXGDw0mLPc8vFehP8OmHwIsKBcvFHlWymUKHCuSHLRlsf7OcKIJepBAUN3FBNjIQtu8CBeb+BPFX03cwlP25padN4OINHxdPTcHhWIKoJ8RIMUCZiGkkIRx9SCIofccjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oDG2dmX8; arc=fail smtp.client-ip=40.107.94.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRLaDQQ0mRXLFuURBQuDPqRiwtm1TrkEwh5hFHmDx1cqyuTJAkoqhNnt17vQY0/IBH0B6mdjzQNr8df4hYFyh6kPXYrouTdUVWPF9DOJHLaM0J4Mc4kjOKnCHr6UOO1OkPNAyaJMItAeWgFyaCEVM1Wfwc4AwbNgN5YReavdwZKTuCfxG6mepxUXL11ae1S2oKdKF3wf54JWA972U7WMX2HOglk4BSwxDi2uqcW3VTCYLFYh0YVwqD0FZLspb1XF+JGqLjDBR3PKIuuRIk3jlUgHKG+Lp9bpIrhQXJrtnoxufvEeVJzR8ulnu6AGuqFhKl7OGOdatYnYRc1tKSZJ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jvv0bkH3L4YW9FDd8WDy0gmZWTypRL8hNz+P2bU4hAo=;
 b=Lplcet3YjnnUDjJxHNpa5cSCktFuYzcd7wapo9zujciYA5t0wGtiY7kEXv0SpO3ynZ5BSSiswQ9DORmTkk0Gpls3wHZOWykE185aTfDhAUKUnA+YFK/OvAd40vPvZb/icYQYXqB6J20gwQ35/8nyyOORy2ObXXODgoGJdLd9aZk6VNl42PtHWcmsSdkeJCFavdH73Jk+qANtGkaNumTMbLgkk8WDo0ipYYJjKNGs3B+ZmkoBgaaIJYS15esi0G/i5cuTjMgRuOh9mFM0mTpHdByV/vrEgHdWb/483HBpDyOzuzvbjBOtgSdZz9HfgZbQtHg8VjswnxulM0QM3U1H9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jvv0bkH3L4YW9FDd8WDy0gmZWTypRL8hNz+P2bU4hAo=;
 b=oDG2dmX8WxqlnEBdJ9U5ZaenZmlyWR9gftu+O4IFN+RuisNKBlur0x4NaJmBO6JYdDFwyWZcmmKi1AaTmgN2ykS3UtmW1p7epEEFRb0Vy7PNBrUGHky+NfRcmav29fsMuVNvPUN4Dy40zEAJvlEJW8heZO7N4z5hcDvSpNR/aXGndjryrRL+o4esgwtq/+MfTzDZu1U4a5JkUYZ4YePfinK6L9FEfWgL2y7RrgEW9WRDJoQ5fxQivoQFStVMsgocfSZC/j0scOmu83s5rRUnTCONQIxdj9L0hx0nZutpp4nV1FJ8ETypyOh+j5FG/GZjTF8c8q3CkmtF3pwmA14h6g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY5PR12MB6453.namprd12.prod.outlook.com (2603:10b6:930:37::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 03:44:06 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd%4]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 03:44:06 +0000
From: Parav Pandit <parav@nvidia.com>
To: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
CC: Cindy Lu <lulu@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	"sgarzare@redhat.com" <sgarzare@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Leonardo Milleri <lmilleri@redhat.com>
Subject: RE: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Thread-Topic: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Thread-Index: AQHa0QLfS7FXUVdqN0KzwFRlOGkqFbHtxbfwgAAoIICAAGrjgIAA8WAAgAAJ6sA=
Date: Wed, 10 Jul 2024 03:44:06 +0000
Message-ID:
 <PH0PR12MB54819872A2A265285EF097A7DCA42@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20240708064820.88955-1-lulu@redhat.com>
 <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACLfguXk4qiw4efRGK4Gw8OZQ_PKw6j+GVQJCVtbyJ+hxOoE0Q@mail.gmail.com>
 <20240709084109-mutt-send-email-mst@kernel.org>
 <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>
In-Reply-To:
 <CACGkMEtdFgbgrjNDoYfW1B+4BwG8=i9CP5ePiULm2n3837n29w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CY5PR12MB6453:EE_
x-ms-office365-filtering-correlation-id: 2aa94f47-fb2c-408f-ef06-08dca0928c8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QTBBQ0dpb3BiTXRhVDRqd2RVb1RiaXkxb0dvMWxhVEdPZmxidU1SNkhGMTBm?=
 =?utf-8?B?OU1QZTViU1pYV1FhWHVVTmRNaG00ck84dHVuS3F4NWM1aUlheTJybEJBN0Ri?=
 =?utf-8?B?R2lwc1pIZjRYQXNRbGxtMDlHNDU1VHQzeG1CL1FJczZnNHR3MVlhdjhlS05v?=
 =?utf-8?B?dVYzWWozL3JiTThGU1owNlRoQUlSMUNrZ25JbXo0RU9CWGRvZWlMMHZ5b2ZC?=
 =?utf-8?B?bTdTTVBGTkZDbTE2TmJNbklBaWRHcklSeUZzNTNuYnpKSkdtclBkOWVITjZT?=
 =?utf-8?B?ZnpUVmZ1elpXWFRjWmwrQUM1OVgxUE1EMDJBdUZ3aEZLN0EyOVYyd2ZOKzUx?=
 =?utf-8?B?MTEyOVJwUkFKbFVLUHZZa09COUhPN3N4TlJsYVduZDd0bXp1eDYzcWRCTzF6?=
 =?utf-8?B?dG5MdlVDSFdLZ3BlbmJmMDhtam9iZDRXd015eWdsNUpFZ01QTjVzRGJDK0Nw?=
 =?utf-8?B?NE1QMFFiQ00xRTJMZDV4Y1l3OEt1Vkl6aFdxV1hEb1Bkc0d6ZUxGQ01pNTFr?=
 =?utf-8?B?b2VUOURlZFZqZnlIRDRRakI4MnpHclhKenNUL3ZrU2JQdzB0clNOU0hqYWFS?=
 =?utf-8?B?a2lUOUIrdmxtbTRCYWRPbjJyYnVMRGZYc1B3a0hVaitMcHFkeGdqSFNHSDk1?=
 =?utf-8?B?dEppK3FOUUdGaDNmTVdoK1dXNGJ3UkhuVXh5cHVxZ1ZLRzlLOTlEYUJaU1Jk?=
 =?utf-8?B?UDNOUnA5VEJQWi8xM2Y1WFN4c1R4OU1VUkVRcUU3SjZGMEtjTzdvZExBTnda?=
 =?utf-8?B?MVh1cWpSZW9wUEs5b2F4dWFpRmk5ZUZWdzQxc3VlU0c0UFNIUnVtbnN2NVhx?=
 =?utf-8?B?SzFhK1h1em9iSWk1Ty9lam5NYWhiaXVRbGxFcjQwZWhqTlRQa0wyR0FhYlZ6?=
 =?utf-8?B?Zy9wdFZnMGpPZEV1dVdsenBnbTNjL0ozb3hEYWRJT2pHTlVWOHRWOU5Cc1M0?=
 =?utf-8?B?TjNtVHVLaTlMcklJcVJoQy9pUGt1TDd4bUU2Y0x4WUFpUUEwVlRma05ieVhh?=
 =?utf-8?B?U0I0NG5wWTUrdjRJOHU1L3B0RXRMN3BjVWgrQUZGNDhVYkF1dGs2MFhjbDNY?=
 =?utf-8?B?L0F1b3FzZ1hjclpHLzZVUTF0YVB5MjZtZDNjQ08wZTJld2puanJoTzNMdnRm?=
 =?utf-8?B?ZGRUWUFLK3dCcUh5c0tUWndxWVprRm9kc29vcGNLVzkrNy9YVTNoTFFxMXI2?=
 =?utf-8?B?NmFPWXNkRnZLWE5OUW11UVkzSlEvdjZFVjBYVm4xc1J2b3ZyMVlJRnVQNmpD?=
 =?utf-8?B?M3ZpRWloUUJUejF5QjIvVEcvMkRSMU4wNmJFeWFhZFFDOSt4RE5EQmdFRkJh?=
 =?utf-8?B?S3VZd2o1bDhmdS9yQUdTSlJtMVpGN1orZkxRbDdPOUZSa3Y4K1pZeU9oUGtG?=
 =?utf-8?B?c3RINWswSEs0VWwvbHpOZEFjSzNVK2V6RHFyRFZtYjE1dTc5SFV3VXJoNDlx?=
 =?utf-8?B?RFZWUmltL0lrRDkrZGxJaXVwQ2xPOXZsSU5NRU8zTVlIRU9lcVpEa0ZHbDg0?=
 =?utf-8?B?NFRNYlJ1ZFlaVk5CR1RpRXBDTW92MW5vcEN0TjY4NytrL1VEK0ZGVklsK2tn?=
 =?utf-8?B?dEpZOU4vN0dOamdKVFk1WERjL1d4eW5Pdko5M09vNTYvMGFrUHVwM0Jid0p6?=
 =?utf-8?B?eUs0aXNYbTJLa1puSTJPcVVvcHlheUdVeE5DQU1jdkxXRWZCdFM1aDN0Zk1P?=
 =?utf-8?B?QXdqTFg1M29WbUpGQjY5MFMvdGYzMVpGUWlSRDh5Y0dTTS9IQk43bFJMdGwy?=
 =?utf-8?B?UmF2KzUzWGp2TXlNdTBXVkpIWmhQMG94dWQrVm9DeWFSWDk0TGtMTDU3S2Vq?=
 =?utf-8?B?WGY4amo3Qm9nREplQU5Pb1NzS2Z3OGRBczdqaFBvekZBVWU0dDBGdHJFSlZE?=
 =?utf-8?B?aE9LRnNRUVoyd2FhZWdsYzhXMFpSYWp0Nm8rNjRvWGVUOXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZlV0eUNJbktlU0Jzdm1Cbmhpc25hcnZuaHJHZk4zNGNuSXd4MkhXdER4U1FO?=
 =?utf-8?B?M25FY3p6b1JBQW56a3paSVRicTcvcnFyNU8wWWR5azhlaUxyeXorelYrdHZT?=
 =?utf-8?B?cHJzUHF1SUwwS0FoTU52TFhhSWYvS0JQMkxFdXYzTzhzSTZUcnlwSzd6N2Y5?=
 =?utf-8?B?c21JYzZocnVlNXZ0U2ZmRWt2a0pOQzd0WWlqWjBDK25KRit3ZFlseHBtMjRy?=
 =?utf-8?B?dDJPUHpBVVo4Y1oyZ3pSN2hIRTgvM2FRQ2plRWZzNjZZd0RlajM0SmFNU2lu?=
 =?utf-8?B?RWI5UlA3ZldUYVBBeW1YMTVxZWhiTHNJZnpndkpZMXhjYUgzTkVMdmV0bTRC?=
 =?utf-8?B?T3ZWSWVkM0JVN1RKSUtPYUQ3OUNQWW9nUVEwUnlUUTR3NGptNkJxK2pRVWFM?=
 =?utf-8?B?WkZHRzNCRTZIWUpDdUgwRHc2NjB2NHk2NDcvU3ZORmdkai9JTVRqck4wZFhH?=
 =?utf-8?B?VW1HazM1SEZ3RDRKcHJ3SlNzUVFOQi9JRlFtV3FrRjc3Mi9LQzU0NWRRZlVv?=
 =?utf-8?B?TjNhbUhQa3ZMMWcySE84RG5iUjVOd0JBN1NaTkJpQU9VRjhXNlUwSDF6ZWgw?=
 =?utf-8?B?SHZ6YllIOGVRMEYvSzNkSDc0WTJIcWN3L2hRRkQxQklMZmRiUmNJRHZLZFNp?=
 =?utf-8?B?TWVyaFprZFhQVkJJUVVmQ3gxV2dkNFpqb25RUmJTY2x1UHVWaTcrejFwbTZD?=
 =?utf-8?B?L0NXd3pjbUZRUUs0VFhlN0Y3QkQ1SFFRamJrWWE4YmpyUHdnQmxFYWJENG1v?=
 =?utf-8?B?Uy9vc2ppRTYySGtqUDduWWYvak5sVFBXL2h6c0pURHhLamRnOWVEWSs5Ync5?=
 =?utf-8?B?WVM2SEFTVENwOWgwUjFmTjhNVmg5UEFLOTl4SFFGQ2NCT0dtSEtKTy9mYURo?=
 =?utf-8?B?TG8zZ2N2NWlrUng4ZVVpNDlZbjRjRHg4ekEwalZRR2UwVm0waWJ6dThjNDF2?=
 =?utf-8?B?S1dkQW50dTd3M0V3SGNKbjdnZlFpWG10RCtxWDhCK3NHaHZKL2o5VVFEQkFW?=
 =?utf-8?B?elJGWFBHazZlcU13L1dXZmJRMmhrYXZGVVQrdkN2dmRMYzJhU00wdVZBRy9j?=
 =?utf-8?B?M253STUyeWlsUkRwQmF2TkU0dDRFcHptSlRGMjA0aEFyaEoxS0tZR3RlclR5?=
 =?utf-8?B?RC9JVjY4cDd3Q2FnREpJbHJ5dlV6ZjEyejdzQnRhTTJ5d2c0dDcwaUtEVzlv?=
 =?utf-8?B?YU01ZGQ5QzJHN0JuVWFncmEvV1VTZDlXSDJqbUJQYWlLK2NpMmVpRnVTb2pU?=
 =?utf-8?B?ZWU3bGNwVVU2MGFKZXp3SVVEWjNaWnZWQUl6SDdrb1U2OEZMNXdoU3R6bkdB?=
 =?utf-8?B?OHFBQU5tZ2ppL3FraXZ3NGtZcFN2V3ZRTFFtYXF6YjR1MjhSRTVlcFo0cEtv?=
 =?utf-8?B?cDR3blRaRzFHb2N5Y2ExOXV4bXN0bW1sN3R3ZjNhclgwMDlrZjdTbXY5RmRG?=
 =?utf-8?B?cFhBdHQvVU1GQWRZZDN4RmYwM0FHZXcvVTI5OEM4dU9sVWJuMC9hMkhieCsy?=
 =?utf-8?B?b1IxU2I2NkI4VXFHTEpYUVV1RVZ5N21xVGo3aGhaeUZJcjQ2VXpYaXpZVklj?=
 =?utf-8?B?OElodnFPbTVCYXUrK0ViYmJRN3E5clRHRGlLYXlPTGp0NzZFakhPZjdldUIy?=
 =?utf-8?B?NElXSUtuRFFVdTd0SDRVbkpBbnozYW11ajUxUmF1bDZ5WVRPZW9iN0dqVXhu?=
 =?utf-8?B?ZjNOYUY0ZDhYTEQ3SHo2REs4WDBHYWwyc0QxTmlJVDVLUytkemNZNWNSeTdx?=
 =?utf-8?B?T0pzNS9wclhPVjcvcEdsOUVPZzhXOG9KN1FwTkVWVEEvTklISW5PdU9walBq?=
 =?utf-8?B?elNvMitXT1ZIZCtSRTJDMjFZZXFxZW5aMDB3dFF6YzIzRVR3OG8vT0F5czNK?=
 =?utf-8?B?NWxLQmtrUjFGbWttaHNnbnE5T0ozMDhGN2F1SVZIcTZBUDRlUW9GbldGUDU3?=
 =?utf-8?B?R2Q0N2dBRFdiOUJqUGNodWRGbG5wV0RSam13NVFxVlFKdmhxbGh6SkdtNUw4?=
 =?utf-8?B?aVpiczh6Mks4ak9aSklZY2hWcmNvMnhTOFZMMmwvVDhQTElMYXdZVEIrYjRw?=
 =?utf-8?B?bXNDelB5SmVCSXhZM0FKS1h2aWFDdUdnejdNa0l0Z29hcWV1Qjc5T3ZnTEVP?=
 =?utf-8?B?bjVIS1ZOMWVGNUZyVHg1amV1dU4rbVhOTmVzT0IzSkp5UGRISW9OcmFjdFFV?=
 =?utf-8?Q?+MqMwKHxlsOAO8rWChDst0E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa94f47-fb2c-408f-ef06-08dca0928c8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2024 03:44:06.3190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gx5TmffDVxsijnpt+z7A8qYppVB5wLwOh1cNIaV0BnPeAA18x4Ssf3qenSNRoJ67EON9z8baD5rDihENVhPWAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6453

SGkgQ2luZHksDQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4g
U2VudDogV2VkbmVzZGF5LCBKdWx5IDEwLCAyMDI0IDg6MzYgQU0NCj4gDQo+IE9uIFR1ZSwgSnVs
IDksIDIwMjQgYXQgODo0MuKAr1BNIE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+
IHdyb3RlOg0KPiA+DQo+ID4gT24gVHVlLCBKdWwgMDksIDIwMjQgYXQgMDI6MTk6MTlQTSArMDgw
MCwgQ2luZHkgTHUgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIDkgSnVsIDIwMjQgYXQgMTE6NTksIFBh
cmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IEhp
IENpbmR5LA0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IENpbmR5IEx1IDxsdWx1QHJlZGhhdC5j
b20+DQo+ID4gPiA+ID4gU2VudDogTW9uZGF5LCBKdWx5IDgsIDIwMjQgMTI6MTcgUE0NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IEFkZCBzdXBwb3J0IGZvciBzZXR0aW5nIHRoZSBNQUMgYWRkcmVzcyB1
c2luZyB0aGUgVkRQQSB0b29sLg0KPiA+ID4gPiA+IFRoaXMgZmVhdHVyZSB3aWxsIGFsbG93IHNl
dHRpbmcgdGhlIE1BQyBhZGRyZXNzIHVzaW5nIHRoZSBWRFBBIHRvb2wuDQo+ID4gPiA+ID4gRm9y
IGV4YW1wbGUsIGluIHZkcGFfc2ltX25ldCwgdGhlIGltcGxlbWVudGF0aW9uIHNldHMgdGhlIE1B
Qw0KPiA+ID4gPiA+IGFkZHJlc3MgdG8gdGhlIGNvbmZpZyBzcGFjZS4gSG93ZXZlciwgZm9yIG90
aGVyIGRyaXZlcnMsIHRoZXkNCj4gPiA+ID4gPiBjYW4gaW1wbGVtZW50IHRoZWlyIG93biBmdW5j
dGlvbiwgbm90IGxpbWl0ZWQgdG8gdGhlIGNvbmZpZyBzcGFjZS4NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IENoYW5nZWxvZyB2Mg0KPiA+ID4gPiA+ICAtIENoYW5nZWQgdGhlIGZ1bmN0aW9uIG5hbWUg
dG8gcHJldmVudCBtaXN1bmRlcnN0YW5kaW5nDQo+ID4gPiA+ID4gIC0gQWRkZWQgY2hlY2sgZm9y
IGJsayBkZXZpY2UNCj4gPiA+ID4gPiAgLSBBZGRyZXNzZWQgdGhlIGNvbW1lbnRzDQo+ID4gPiA+
ID4gQ2hhbmdlbG9nIHYzDQo+ID4gPiA+ID4gIC0gU3BsaXQgdGhlIGZ1bmN0aW9uIG9mIHRoZSBu
ZXQgZGV2aWNlIGZyb20NCj4gPiA+ID4gPiB2ZHBhX25sX2NtZF9kZXZfYXR0cl9zZXRfZG9pdA0K
PiA+ID4gPiA+ICAtIEFkZCBhIGxvY2sgZm9yIHRoZSBuZXR3b3JrIGRldmljZSdzIGRldl9zZXRf
YXR0ciBvcGVyYXRpb24NCj4gPiA+ID4gPiAgLSBBZGRyZXNzIHRoZSBjb21tZW50cw0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gQ2luZHkgTHUgKDIpOg0KPiA+ID4gPiA+ICAgdmRwYTogc3VwcG9ydCBz
ZXQgbWFjIGFkZHJlc3MgZnJvbSB2ZHBhIHRvb2wNCj4gPiA+ID4gPiAgIHZkcGFfc2ltX25ldDog
QWRkIHRoZSBzdXBwb3J0IG9mIHNldCBtYWMgYWRkcmVzcw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4g
IGRyaXZlcnMvdmRwYS92ZHBhLmMgICAgICAgICAgICAgICAgICB8IDgxICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gPiA+ID4gPiAgZHJpdmVycy92ZHBhL3ZkcGFfc2ltL3ZkcGFfc2lt
X25ldC5jIHwgMTkgKysrKysrLQ0KPiA+ID4gPiA+ICBpbmNsdWRlL2xpbnV4L3ZkcGEuaCAgICAg
ICAgICAgICAgICAgfCAgOSArKysrDQo+ID4gPiA+ID4gIGluY2x1ZGUvdWFwaS9saW51eC92ZHBh
LmggICAgICAgICAgICB8ICAxICsNCj4gPiA+ID4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAxMDkgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gLS0NCj4gPiA+
ID4gPiAyLjQ1LjANCj4gPiA+ID4NCj4gPiA+ID4gTWx4NSBkZXZpY2UgYWxyZWFkeSBhbGxvd3Mg
c2V0dGluZyB0aGUgbWFjIGFuZCBtdHUgZHVyaW5nIHRoZSB2ZHBhDQo+IGRldmljZSBjcmVhdGlv
biB0aW1lLg0KPiA+ID4gPiBPbmNlIHRoZSB2ZHBhIGRldmljZSBpcyBjcmVhdGVkLCBpdCBiaW5k
cyB0byB2ZHBhIGJ1cyBhbmQgb3RoZXIgZHJpdmVyDQo+IHZob3N0X3ZkcGEgZXRjIGJpbmQgdG8g
aXQuDQo+ID4gPiA+IFNvIHRoZXJlIHdhcyBubyBnb29kIHJlYXNvbiBpbiB0aGUgcGFzdCB0byBz
dXBwb3J0IGV4cGxpY2l0IGNvbmZpZyBhZnRlcg0KPiBkZXZpY2UgYWRkIGNvbXBsaWNhdGUgdGhl
IGZsb3cgZm9yIHN5bmNocm9uaXppbmcgdGhpcy4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIHVzZXIg
d2hvIHdhbnRzIGEgZGV2aWNlIHdpdGggbmV3IGF0dHJpYnV0ZXMsIGFzIHdlbGwgZGVzdHJveSBh
bmQNCj4gcmVjcmVhdGUgdGhlIHZkcGEgZGV2aWNlIHdpdGggbmV3IGRlc2lyZWQgYXR0cmlidXRl
cy4NCj4gPiA+ID4NCj4gPiA+ID4gdmRwYV9zaW1fbmV0IGNhbiBhbHNvIGJlIGV4dGVuZGVkIGZv
ciBzaW1pbGFyIHdheSB3aGVuIGFkZGluZyB0aGUNCj4gdmRwYSBkZXZpY2UuDQo+ID4gPiA+DQo+
ID4gPiA+IEhhdmUgeW91IGNvbnNpZGVyZWQgdXNpbmcgdGhlIGV4aXN0aW5nIHRvb2wgYW5kIGtl
cm5lbCBpbiBwbGFjZSBzaW5jZQ0KPiAyMDIxPw0KPiA+ID4gPiBTdWNoIGFzIGNvbW1pdCBkOGNh
MmZhNWJlMS4NCj4gPiA+ID4NCj4gPiA+ID4gQW4gZXhhbXBsZSBvZiBpdCBpcywNCj4gPiA+ID4g
JCB2ZHBhIGRldiBhZGQgbmFtZSBiYXIgbWdtdGRldiB2ZHBhc2ltX25ldCBtYWMgMDA6MTE6MjI6
MzM6NDQ6NTUNCj4gPiA+ID4gbXR1IDkwMDANCj4gPiA+ID4NCj4gPiA+IEhpIFBhcmF2DQo+ID4g
PiBSZWFsbHkgdGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLiBUaGUgcmVhc29uIGZvciBhZGRpbmcg
dGhpcyBmdW5jdGlvbg0KPiA+ID4gaXMgdG8gc3VwcG9ydCBLdWJldmlydC4NCj4gPiA+IHRoZSBw
cm9ibGVtIHdlIG1lZXQgaXMgdGhhdCBrdWJldmlydCBjaG9vc2VzIG9uZSByYW5kb20gdmRwYSBk
ZXZpY2UNCj4gPiA+IGZyb20gdGhlIHBvb2wgYW5kIHdlIGRvbid0IGtub3cgd2hpY2ggb25lIGl0
IGdvaW5nIHRvIHBpY2suIFRoYXQNCj4gPiA+IG1lYW5zIHdlIGNhbid0IGdldCB0byBrbm93IHRo
ZSBNYWMgYWRkcmVzcyBiZWZvcmUgaXQgaXMgY3JlYXRlZC4gU28NCj4gPiA+IHdlIHBsYW4gdG8g
aGF2ZSB0aGlzIGZ1bmN0aW9uIHRvIGNoYW5nZSB0aGUgbWFjIGFkZHJlc3MgYWZ0ZXIgaXQgaXMN
Cj4gPiA+IGNyZWF0ZWQgVGhhbmtzIGNpbmR5DQo+ID4NCj4gPiBXZWxsIHlvdSB3aWxsIG5lZWQg
dG8gY2hhbmdlIGt1YmV2aXJ0IHRvIHRlYWNoIGl0IHRvIHNldCBtYWMgYWRkcmVzcywNCj4gPiBy
aWdodD8NCj4gDQo+IFRoYXQncyB0aGUgcGxhbi4gQWRkaW5nIExlb25hcmRvLg0KDQpBbnkgc3Bl
Y2lmaWMgcmVhc29uIHRvIHByZS1jcmVhdGUgdGhvc2UgbGFyZ2UgbnVtYmVyIG9mIHZkcGEgZGV2
aWNlcyBvZiB0aGUgcG9vbD8NCkkgd2FzIGhvcGluZyB0byBjcmVhdGUgdmRwYSBkZXZpY2Ugd2l0
aCBuZWVkZWQgYXR0cmlidXRlcywgd2hlbiBzcGF3bmluZyBhIGt1YmV2aXJ0IGluc3RhbmNlLg0K
SzhzIERSQSBpbmZyYXN0cnVjdHVyZSBbMV0gY2FuIGJlIHVzZWQgdG8gY3JlYXRlIHRoZSBuZWVk
ZWQgdmRwYSBkZXZpY2UuIEhhdmUgeW91IGNvbnNpZGVyZWQgdXNpbmcgdGhlIERSQSBvZiBbMV0/
DQoNClsxXSBodHRwczovL2t1YmVybmV0ZXMuaW8vZG9jcy9jb25jZXB0cy9zY2hlZHVsaW5nLWV2
aWN0aW9uL2R5bmFtaWMtcmVzb3VyY2UtYWxsb2NhdGlvbi8NCg==

