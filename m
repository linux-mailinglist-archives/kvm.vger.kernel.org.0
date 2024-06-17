Return-Path: <kvm+bounces-19752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E691D90A2A8
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 04:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79E63282AEF
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 02:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5F517B4EC;
	Mon, 17 Jun 2024 02:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jiAcqWJh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFF4367;
	Mon, 17 Jun 2024 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718593050; cv=fail; b=cvlEqUZLcLwWgdrRjssnXpq40FsBXgqTJ+1DcDPBtR1U128Kf0ZZaBeCaMQy/tPi8nikUJ3fvjCXXKb3iLSxhFJP5RfMob21EeiKCNmVpzzyjCCqlfquPAqvysP8MRdfymk8wj//GQqQYZGJofobX6alSxhTKtN9ytUioI8x/8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718593050; c=relaxed/simple;
	bh=GdNHCZt6xzQtFSlPYkeDgV9EFMWp11AzRArwNu8WjUI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NAVLF0FrOGQJAAfcfmvqLDAY9ZNxDK16Pz4ui0Wq4EWVdXU8pBrYzTRiqG70nCyTZMZkjMdpIQhF448mJsoEfBwpf1USPjSQDbVMM0BxkwWefqYz6XUXtzlcsZwKsFK1fQB9+m5FEAZkra06LRJtG+Ae1Ex/ISsEZ0roHmQnUHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jiAcqWJh; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alr+6P6OAOxFSK1gQWZKbVyz5CqfMJxYzyqWCwHCZKeHrz9cfXMzVLYoicoyyc33OdnZs2LMjpdPbD/CJQfzouPa2b/6EbTwdIhmuzaTjuBaRIhWVCQVkgD1sItQv8r8z6EMRy4u0TSzxvx49817rtOPLtChAmgMjrPuf5W7+hvHJZSUkfRbOJEhHqA5yZPx2eC314XZui9jNKJMMOlgph4SgNfEGFNOi1tXmd5zFB28QM+ZcPsBPKNg2h2X+QBDmLkU/UaUMAMiyTpQiWTBBbU1IKmUNJIEGJtLqhZp+6W9jEvXXVSi/2vsNDCXBDlqXuvCads1Sk7glpGRMRKFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdNHCZt6xzQtFSlPYkeDgV9EFMWp11AzRArwNu8WjUI=;
 b=kWVrDvHNUOoNQmlcgv1K5jV9aNBOmUJqmh8kvvW+22AfN6O03PZam6PBz+lks8cektQoa03JOOMwycGG5LSiwoaV6Jdh3GyPglxvEkDIoz2PwqNPOsffL0N3AH+e36qhYu8OfKVxoBEj9+QZ0X5SWTQLg0vrLpLl9b+4tsjXxjyxc1XFEk9l9qAD9BZGSmphwNLtOHf2uLtfldWHODXLnbUwa5CAzIzSGytiQsp9DRKo1Jhtfc6utpPh6CEYDkRgPyZVVKJ9KIoNaTzBA7uiZqBo5LBsJY0C43S4Dx7ZSz5icziiJDM3ThIJRUeh9ZWqgAIf/xNNNwfSCiPlfEUMTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdNHCZt6xzQtFSlPYkeDgV9EFMWp11AzRArwNu8WjUI=;
 b=jiAcqWJhAr9yUfU9EyWXtrmLkZgSFmDupLc3zmOtjnyYDyQPO/appOlA/TOw4RB2vDgj/F+CwoFJZE/23WC+76Lq2Q6xAH8vucW0pRUP5SaZ2AevZ6ViiuhjVrDc9ezQs0lVCTiQ1rGdPeGVL+wMz3UEfsxFNi+rft+Gtdz/Br4o9anNGXVA3Sl3EPQikrAFDYqdCb2TGG3bDn9K31gFLA808jzrSnNG+i2mbqUTfs1/2s8W5W5EwXiEG6qmIKAryoEGoKct3f7aRvxrsdnee8jLEECzQzJ3W3KkOqoi03gp+SiY/h48qwazJoJ4VXVT3hC5Hi9ebDO2wLoZnqEaaA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB6447.namprd12.prod.outlook.com (2603:10b6:8:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 02:57:23 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd%3]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 02:57:23 +0000
From: Parav Pandit <parav@nvidia.com>
To: Jason Wang <jasowang@redhat.com>, Jiri Pirko <jiri@resnulli.us>
CC: Jakub Kicinski <kuba@kernel.org>, Cindy Lu <lulu@redhat.com>, Dragos
 Tatulea <dtatulea@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Thread-Topic: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Thread-Index: AQHau8E82Oi/Eu4kG0WR1z2wkwF2SbHDYHEAgABL6oCAB4z7gIAAEN/A
Date: Mon, 17 Jun 2024 02:57:23 +0000
Message-ID:
 <PH0PR12MB5481BAABF5C43F9500D2852CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org> <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
 <CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
In-Reply-To:
 <CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM4PR12MB6447:EE_
x-ms-office365-filtering-correlation-id: 62813f60-db35-47a5-31d5-08dc8e793684
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?OTc1aFlaOXNKTEJpMUVoNXNSRmg2cE1pMjEzWUJ5L2FoUy9tNzM1MFNZMXk1?=
 =?utf-8?B?VGNVdUFUay9aWGN5Z2c3NE82U1RPZ25EbEI3Wi9uNXN6cjRaRG9kUHFqOVdw?=
 =?utf-8?B?UFhvYkRta1RKM3pDNis4ZVhiSTlQSERTSWh1MjR3MHBsdERkQzZ3amFhbU5E?=
 =?utf-8?B?c0ROcU02emVjdTVDMldFem5XZ2xPTERPYkpTeksxci9WRmNwWUdOcFU0bDNj?=
 =?utf-8?B?cjFrS3hrd1Jpakxpbm5FbjB0TEc0UXRDRytLSEMydUNWb1lBSGRjb2xLYmV3?=
 =?utf-8?B?SUNZTDF3Z3drM0g4cEp0WE1DbkFWR2VtMm5CZmZnVTVBanVXd3gweStZQWtE?=
 =?utf-8?B?VUl6RmtRcGpRd0JRT0Z3WENHTDFWbWtoeVNhTW1pMU02RHZzRTYwcmEvRGpK?=
 =?utf-8?B?OUxKNURzRWhnVW5sUnJjU1BiVkd4MVVhUjFjWXRaWGxUZ0UydkM2VU8vN2k4?=
 =?utf-8?B?K01kenBTY1lQcWZYcUtSNEE5ajFmWnY4bTR2dG05YVNXUXcrR2lYbTNHVEda?=
 =?utf-8?B?ZmZRN2xHeDYycklnMFI1Tkl0NTFyRWx5Vms0K3k1ald5dnFMcDRZK1BXYTZP?=
 =?utf-8?B?c3hCa3l2cDlPMVJWdFRlaDA2cC8rb1F0V3hDUmp0NGQvU0hnbWNuSjUzQlpY?=
 =?utf-8?B?T1IzTkJiaHNNa244enM5UVQveXQ5czVmalBhNTNkd2dOYmhLNXdVT1BhYnVY?=
 =?utf-8?B?UUFSdVV3UjJGaUhWY1lEbkxqdVJRSXc1Q2FlRURYajhTRlFnZ2NpZWF4NDZY?=
 =?utf-8?B?RFJDek43cHhsOFM5amxGTjFGNnhpd3YybVYrY3EyNkpCYVRhV1BXYWNzZ3BR?=
 =?utf-8?B?MUhGOG9PVUxORVRQeGowVFhmOUcyK0dPcmM0QzBLOHU4WHNsWUk0VU1ad3Z6?=
 =?utf-8?B?eFpCQjFtelM2eHdBd0x1UjhRUStGNE1DaHNGL0lTQld1Nk5ZaXRMWFR5QWxn?=
 =?utf-8?B?Qi9KVDhDcnhYQVRaUlB1V1hweEpBNEJjZ1h4bE95SGFTeEFMMDBEbHpNdU1I?=
 =?utf-8?B?aVFkenpVb1dNZk1BUDhtTnd5V2F3ZWZ4emQzcS9obEYzSi9IU3l0a2FMaVZl?=
 =?utf-8?B?UlU4cGd5bytFV1FTYStyN1JVWllaTmd0MitFaXJ4UWJJRExiV290S1R2ZnUv?=
 =?utf-8?B?UGUxTlhsQkNMY1lyMkFRTU0vRm9zekhIb0xNb3hzN3p5NS93TWt2S0NIbDZY?=
 =?utf-8?B?S1dpMkhZZU5hRzdtY28xb1AxNUZSbTBrYjlRbnBpOGU3NHJtOFRYNnF6Vit5?=
 =?utf-8?B?bmNURFVwb1ptNDhWVjhqcHllMlRIVFFJL3ZhTWo1U25UU1AxdktUTXpTU3M1?=
 =?utf-8?B?eTcyOHNJbm5vb29UM2xLeVV6NllMQWREN3ozV0VLQ2FXUFpwenozTXhUUlhB?=
 =?utf-8?B?ODI2U3FRWjB5VkEvSXpKSlYzVGczd0sxRUN6KzhIYVh3V1lJUGFYYXowV3Nr?=
 =?utf-8?B?aGxsRFY5dnNTSjFJbE40NlI2eG5NWXAyY3VPMGVRL2MxQkZYQW1BMGJ0bnh5?=
 =?utf-8?B?b0ZIKzNraUFJbG1Ec284bm8zWHg4cUUwN3UxR2Q5VzJzNWVtVHNhZHNFSmc5?=
 =?utf-8?B?cW1TN0Fhem1wTWN1bkRNQmUzazVuR3Q1ODRIRFJZSWlNR04xYWV3dS9vckY0?=
 =?utf-8?B?WnpleHlMZGRvSmFVZ2lnaVhZTTB5MEFIRCt6cjFPTHkzNm0rT044Yit1SG9Z?=
 =?utf-8?B?YW05aWd0QVJkTmRVeFJNdFE1TTVzc0c5OHpuRkVvWUVnRXZzQi9ySXRKeS9P?=
 =?utf-8?B?MXMyTDgvK1VaQlVuTkdOMHdCRFo2U251ay9KK0Q3NlFmaFlUWlJSWWpKbWVi?=
 =?utf-8?Q?TBnBdNPa1wPbzT0lk1rr4XG3fkCJB7XPWTi+E=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bU8ySzVyVjV3OUJHMHFHS0NpZXN3aVdhbUtrb2NPc1NkNGYrVlQxSkcwS3Uv?=
 =?utf-8?B?N0pKd1I1YUw4MmdNWUZkdjR5VTJ6aUlKNEMvdEp6VWxmSWNLMldHZmUzRDJk?=
 =?utf-8?B?cmNlL3JmS0JWeUhnQ3NqcVpxeTZRd2FIME91SDM2NmdOK0V6RGhJT3hPQkFz?=
 =?utf-8?B?dXpBZlNBaFRBTmZkTi9UQnpSUk5Lc2x0WGErTzYvZTkrMnNidkQxSmEvcnVw?=
 =?utf-8?B?WU5FcGc4clBSVXZ0RmJOMzk4RUZsbEtkcjRtbjhJYkRFTGxGVG5ZTkRPZ2J4?=
 =?utf-8?B?aUNLTVlobkJUNVhNZVNJeGNmYW5qZGlHeWxLcGw0ZzhmYXl5L3ZQbTN6emdh?=
 =?utf-8?B?U0tqcWY2MTdVRUFyYVh4RGxtK3U0Sng1MWNaZVNSdUEzdTJEc2tXdzIzZU1s?=
 =?utf-8?B?dmVqYnFUbm5jc29tNjR2MmJFMGFZcTdqcCtSanl3YTlyUnEzTWN4T2gremRI?=
 =?utf-8?B?bjg4MFF1Q095QlJuL0pFZzFrVi9PWmxTOWx4T3F4c1RSVFJsVUNxdW9OWmR5?=
 =?utf-8?B?d2lrSWRWeEpPOVVZQVR5aXJuaTRqNmNpTGZsUTBWclU4ZFdKNlh6QkFUTEhQ?=
 =?utf-8?B?VVRHWmJRZDZ6aU1JbDB4V24vaER3TFpyOGlIZUhTWmNXWTVyZE1NYU1jUXRI?=
 =?utf-8?B?NWI5M3Uybm5NbDgvbzVCL2ZYZFl6ajUxRTljZHRRNFpyZ3UwM2F2c3ozb2lq?=
 =?utf-8?B?MEthNU9LWUhPRmxmZDNzQ2hxNW54NThOQktEbEphYVZQUnJObVNYdkNJaEVr?=
 =?utf-8?B?Qm5DayszSEZXbmx5L29RbmROZEVSanNGd25vQXpCckJWSDVJOHEwem5NYWkv?=
 =?utf-8?B?UXZTWEZqUFpMQW5FbW9IN2ZFOUsrYTcxeUU5aVZvYUM3b1BNeExpU3VhYVVG?=
 =?utf-8?B?QmQxcUNaMFZnNGk2T0ZIUGtiK2lhRDd1aktnU2drcjQ1bVNRUElHTTcwcFpZ?=
 =?utf-8?B?dC9rS0xUUFdTb3J4dm03WW4yam5aSTIwR3pLRCtPd1R4RDZwRVJtVjV2em1y?=
 =?utf-8?B?NkR3MG8xWUZheW5ic1daVG5Wbi9VdU5FbnpVdGZXdGMzMGJyMnExa1ErQndt?=
 =?utf-8?B?bnRaZWw2a3R5VGJETEhaMEMwR2s4d2N6bDV0bkVNR3NJSU5UbVpMbitmdk1I?=
 =?utf-8?B?cloyQmluKzVtZ0V4TVJyeFBuQ3RqTmNMTE43aVJ4a0VzcWdYUmc0cTErRi90?=
 =?utf-8?B?UjNHYU44K2FjNC80K2dTYkpXaDZ0MTErUC9BcCt1Z0s3aXJQTHNqZlowdGF0?=
 =?utf-8?B?NGd3T0FnV2NNQWV4T0pmZjR0Vm9hbGhqck1BN21icmlIT1luY1luL2ZKTGtG?=
 =?utf-8?B?RmVXT2tIR3YyRzBUT3NOQXVSVzQxbHQ5ZVQyVjdZYVd1M2E5SC9nNVpkQWlz?=
 =?utf-8?B?TjBLTXNUQ2VnREhvczVmb1JML3REc1lWUFpIWi9Jc1BkOVFweEhnU0JrNmEw?=
 =?utf-8?B?RjZpN3BacGhEQUNpbENiOXU4UVQ3RHZ2bHJZMXZtd0p3QmU4V3p2K2RkaWN4?=
 =?utf-8?B?REJOSGRoMTRwUWtxejVBdlFNblFGc2tpUzk2R1BzaVo2b01CS3VoTUliRktv?=
 =?utf-8?B?Y05oQllvWjJocThFVnNTNDNhdElhaUhqWEMzMGZQbDFTMUtnd2NtSzIvUGdU?=
 =?utf-8?B?VVFvWEZZUzRHb1MvdFBWQUFwNUg2K05nVGJlQXp4VDU1TUVQVXlKZHRla0hl?=
 =?utf-8?B?OVFnMEpIZVB0Y2twNG9JOEZES1Y5TUp5akwrTDZDVXVjakFCNGZvdXUveitv?=
 =?utf-8?B?dGMxUkRya3RWR3dUOHJiVDFzbUM1U3crTUszWDNyaGJOYUhtaEtQZnlLR0o1?=
 =?utf-8?B?TnpaUnVHeFdzUFhIYWdZSU5wZGZuekM5T01oQU9MRkFrUGNkd2JHVjRHRzU5?=
 =?utf-8?B?MmMvWnlrcnlST2d5Y0laK1hlR2tTdU50VmNxOS9BQXNtT1FJZ0dFVEl3SFd3?=
 =?utf-8?B?QjNDUnVqY1d3aTNERWdRZFZmWEo1L3VBMHh4czhtQXFBU3N1YVB0Z1hRN2Nx?=
 =?utf-8?B?QUtSdmJHYi82WnV4SHEwR0NnQmU5ZDFLNk9DWHRaQVJGT25MY2VuTEYwUzd0?=
 =?utf-8?B?U0t3QUdJakNOSU94bWdtaTJ2SjRJZHdOOE1ybGRGUnNKM2g1OEZlK2haRG1t?=
 =?utf-8?Q?Hyio=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 62813f60-db35-47a5-31d5-08dc8e793684
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 02:57:23.6128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H+arFysVjNpFgQZJrkRqN9pNhJHpcxS6rBM0m5Po3MsecnI+SJnGiJo/pp8YEN0admPXkYkx5bNr6VXKW2T+Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6447

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogTW9u
ZGF5LCBKdW5lIDE3LCAyMDI0IDc6MTggQU0NCj4gDQo+IE9uIFdlZCwgSnVuIDEyLCAyMDI0IGF0
IDI6MzDigK9QTSBKaXJpIFBpcmtvIDxqaXJpQHJlc251bGxpLnVzPiB3cm90ZToNCj4gPg0KPiA+
IFdlZCwgSnVuIDEyLCAyMDI0IGF0IDAzOjU4OjEwQU0gQ0VTVCwga3ViYUBrZXJuZWwub3JnIHdy
b3RlOg0KPiA+ID5PbiBUdWUsIDExIEp1biAyMDI0IDEzOjMyOjMyICswODAwIENpbmR5IEx1IHdy
b3RlOg0KPiA+ID4+IEFkZCBuZXcgVUFQSSB0byBzdXBwb3J0IHRoZSBtYWMgYWRkcmVzcyBmcm9t
IHZkcGEgdG9vbCBGdW5jdGlvbg0KPiA+ID4+IHZkcGFfbmxfY21kX2Rldl9jb25maWdfc2V0X2Rv
aXQoKSB3aWxsIGdldCB0aGUgTUFDIGFkZHJlc3MgZnJvbSB0aGUNCj4gPiA+PiB2ZHBhIHRvb2wg
YW5kIHRoZW4gc2V0IGl0IHRvIHRoZSBkZXZpY2UuDQo+ID4gPj4NCj4gPiA+PiBUaGUgdXNhZ2Ug
aXM6IHZkcGEgZGV2IHNldCBuYW1lIHZkcGFfbmFtZSBtYWMgKio6Kio6Kio6Kio6Kio6KioNCj4g
PiA+DQo+ID4gPldoeSBkb24ndCB5b3UgdXNlIGRldmxpbms/DQo+ID4NCj4gPiBGYWlyIHF1ZXN0
aW9uLiBXaHkgZG9lcyB2ZHBhLXNwZWNpZmljIHVhcGkgZXZlbiBleGlzdD8gVG8gaGF2ZQ0KPiA+
IGRyaXZlci1zcGVjaWZpYyB1YXBpIERvZXMgbm90IG1ha2UgYW55IHNlbnNlIHRvIG1lIDovDQo+
IA0KPiBJdCBjYW1lIHdpdGggZGV2bGluayBmaXJzdCBhY3R1YWxseSwgYnV0IHN3aXRjaGVkIHRv
IGEgZGVkaWNhdGVkIHVBUEkuDQo+IA0KPiBQYXJhdihjY2VkKSBtYXkgZXhwbGFpbiBtb3JlIGhl
cmUuDQo+IA0KRGV2bGluayBjb25maWd1cmVzIGZ1bmN0aW9uIGxldmVsIG1hYyB0aGF0IGFwcGxp
ZXMgdG8gYWxsIHByb3RvY29sIGRldmljZXMgKHZkcGEsIHJkbWEsIG5ldGRldikgZXRjLg0KQWRk
aXRpb25hbGx5LCB2ZHBhIGRldmljZSBsZXZlbCBtYWMgY2FuIGJlIGRpZmZlcmVudCAoYW4gYWRk
aXRpb25hbCBvbmUpIHRvIGFwcGx5IHRvIG9ubHkgdmRwYSB0cmFmZmljLg0KSGVuY2UgZGVkaWNh
dGVkIHVBUEkgd2FzIGFkZGVkLg0KDQo=

