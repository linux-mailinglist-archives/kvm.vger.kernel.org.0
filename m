Return-Path: <kvm+bounces-22089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B191939B2C
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 08:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50772B22E10
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 06:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5C313C8E8;
	Tue, 23 Jul 2024 06:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b="lEDHSQkl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2129.outbound.protection.outlook.com [40.107.92.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFE513A275
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 06:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721717567; cv=fail; b=sXU67NRFgMuiQP1WxVQCLf4yzKVxs8EWH+fSIktf8pL/gpXUALEPEq4vzgD6OP9rYeFRiiEqoelg+UISgdHZjA5sVhKn/Dm4lvzDoBLlR2BEYaLPbMEnH9huubLD9bT3G++rVuDf32hkZ+l7Vl9k7t6Bhi5ben/rQaZAUwNmpIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721717567; c=relaxed/simple;
	bh=NdQ/+hi4AWQPnrWm/ahDlyQ1e7h9RuPvwYX/wTKKBvo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UDelyneVkNxc9aWx6f/BM+S/uwNLHJRhxy0fVnBsA/DrQZKJIiLTLE7+mHQ0a/O6lP/g4uvhwbW2nWM6YCzmuNLB/elEfmDKULafk9GWItho6J9W2ZryvRsP2npguJGjGzYVX3DHRjZgj2RqC0a+XrZz7BC0LraYL6qSxZ7NR1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com; spf=pass smtp.mailfrom=petaio.com; dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b=lEDHSQkl; arc=fail smtp.client-ip=40.107.92.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=petaio.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ay7V39h6dNAI3YPmv8gGaO86KNzB0+Rpq683hUpYy+Ifzz7mgXTzz/m6zElCU8LHzqjqyxAVWS+RfDiwBVcEnSqDnjZ1XLkLo4CWpYkwci2mmnqjTwEjDSa7wIggWAAot7nOK4kHmN/ql3tvLkQHjZhmqZHm1UoPmXa4PwZoqojiWRHdqQx7Nmy9JZDElUt7WLs5yHDTT3+0hnHd6D33blaD++mfEHQ/PO33Z60vcff35mJme01pgndZQRt+Ci+COp/2nps35Rqv7sA4bXTLrVdtYCyAoyIf6YbdrF7Nej0eahCz9F+FEVgLF3PVrvYEVVH87lWrYM6OBKUqiKmxwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdQ/+hi4AWQPnrWm/ahDlyQ1e7h9RuPvwYX/wTKKBvo=;
 b=phvi/ugyrSaiAWgP1F4VMqpe4lXiESEMFAiFtnfxFVoILk94Qpd5K3VgOR7IhEhuzxllMdCBxAm8LBGeJAuA00+gBDihT8xv3L4Rbu0Tf6Li5iibt5jQEaME+Cyi55Wk7oKLHAFnuECqGT4sR+yrP1d+qsejjfCcHBJsk6J/5ygO/eakGJzQPDwhZIml1fvKwDOs3Rzt1xZuy2FOs7j2p0JBSO7t1bNfjOA/wFOV4pMsINofEyWprvgTbhrahlKj9Njq5QznZHjUhRnSbYDyDMdeoBTWYG6hVvUw1RKMdO09aaOGZjLH5iTHsaWqYCZ4BPQnzkYjSBTdxw2T5BJ7hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=petaio.com; dmarc=pass action=none header.from=petaio.com;
 dkim=pass header.d=petaio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT2018045.onmicrosoft.com;
 s=selector2-NETORGFT2018045-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdQ/+hi4AWQPnrWm/ahDlyQ1e7h9RuPvwYX/wTKKBvo=;
 b=lEDHSQklAHOX5YQVV7107szJblIoyTajTtnYfEY9Lay8IAqaYV4WeVDmXksjeQgh/qbY/9DLrw85yyZ59poIU7KdXwFZWPXhonR+h4fW0sTSK9QHjwRINFPRw83NLF14siCbhnjiqfQvzK5vie3170AceydAz4T0PzZ7w92NI2s=
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com (2603:10b6:a03:439::9)
 by LV3PR18MB6283.namprd18.prod.outlook.com (2603:10b6:408:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18; Tue, 23 Jul
 2024 06:52:42 +0000
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310]) by SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 06:52:41 +0000
From: XueMei Yue <xuemeiyue@petaio.com>
To: Yi Liu <yi.l.liu@intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject:
 =?utf-8?B?UkU6IEZXOiBBYm91dCB0aGUgcGF0Y2gg4oCdaHR0cHM6Ly9sb3JlLmtlcm5l?=
 =?utf-8?B?bC5vcmcvbGludXgtaW9tbXUvMjAyNDA0MTIwODIxMjEuMzMzODItMS15aS5s?=
 =?utf-8?B?LmxpdUBpbnRlbC5jb20vIOKAnCBmb3IgaGVscA==?=
Thread-Topic:
 =?utf-8?B?Rlc6IEFib3V0IHRoZSBwYXRjaCDigJ1odHRwczovL2xvcmUua2VybmVsLm9y?=
 =?utf-8?B?Zy9saW51eC1pb21tdS8yMDI0MDQxMjA4MjEyMS4zMzM4Mi0xLXlpLmwubGl1?=
 =?utf-8?B?QGludGVsLmNvbS8g4oCcIGZvciBoZWxw?=
Thread-Index: AQHa3KxuuhkrPMFLEU6ok/qWEqHOQrIDoT1QgAAQhwCAACCkgA==
Date: Tue, 23 Jul 2024 06:52:41 +0000
Message-ID:
 <SJ0PR18MB5186B961317770AE36A58A3AD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
References:
 <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
 <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <859fc583-6aca-4311-ad9c-ffbea68c5b17@intel.com>
In-Reply-To: <859fc583-6aca-4311-ad9c-ffbea68c5b17@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=petaio.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR18MB5186:EE_|LV3PR18MB6283:EE_
x-ms-office365-filtering-correlation-id: affd893b-a2b4-463d-22ad-08dcaae40c6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018|220923002;
x-microsoft-antispam-message-info:
 =?utf-8?B?aS9IbWxyYkdrU0xLcHFaNkFrMk01VXZJM0YvK1dESVpQcU1hcXg3cy9JYTJi?=
 =?utf-8?B?RXJjS0ZDenZVMXJQQ1J4OUErR004Y29meG84SlRFbDh2YUFtU0t1WHV3M3FW?=
 =?utf-8?B?VXpPa1dkV1BobFFCenIzbUFXSjNUQTcrTkp6T1dLNlR0YWVLRTgvUG1MYWtj?=
 =?utf-8?B?VzhGTXJ1M0RnTHRML0szOFF2UHRLazZMZ3h0TmlzZTIvUEZ3YmwyRFRoTzA3?=
 =?utf-8?B?YUJLTE8rUkRNbVlKKzZXK2thY2RMV3BHNGV2RzUzMERSai9XYy9ZYXFUbWFv?=
 =?utf-8?B?Y1QveXZld3ljdUVTdHJ1TTdWOEtCTWlaMnd0Rlk2YytPWEZWUkt4SFZqTHcy?=
 =?utf-8?B?a0thbkw0L0UwMG85SFJuMUd1eUNhTmFkYXRnUDlmK21xVWErSCswdzVjN29N?=
 =?utf-8?B?VHZYeitTZGkxSE1oMHdaMVpxZnhuRzZ5RnRsQVJhRG9HRTFHOGcrT1lkMXJ1?=
 =?utf-8?B?U2ZkRHMvemVvSnZ4WXM5ZzFuelRiVjRibHZWTS9WSGJudURpcjgwUkVNL3Fs?=
 =?utf-8?B?T3cwWHRwQndQNnQwVlBkM3ZBMzVzNEdjbDVVQ1pndjlhdml4T0V5bldJZzBS?=
 =?utf-8?B?dEdDMEZ2RkJvNWozazNaZENUUmMzK3RPbyt0R3JPaXlReElyRUtHMi9lVlJY?=
 =?utf-8?B?UmdZS2oxMFBwcHYvWVE3WEFHdXEzMXY2VTNkejlWZG5WWWx0cEVTaGE1MG1a?=
 =?utf-8?B?dlh0bEMvQU5DZzlEL3dENDVLTkVQeUttdVJwdkNZRGJNeDBqbWNQY21ZbExI?=
 =?utf-8?B?TVJRTW9Hci9GTFhYanRCclREYnp5RFhzdk1mRHZhZ3hqbmJOc29kaHVpWUR6?=
 =?utf-8?B?cUQ1cGJCSVRJVy9YVmd2RUE3QXpkMm5HdDJJUWJKWk9FSFFHMzVRSGUzeEVm?=
 =?utf-8?B?NGlVNDY1U1lzNnVvT1Y3WE5qQlFWZnRrS3U3WUpMUVZRZStwY1RCdEpxU2NO?=
 =?utf-8?B?eUFGYkNlZVd1RmU5WStqbE9EWG1xbThlNWwvb09SYmcweUtzcDVUV2JKclpQ?=
 =?utf-8?B?N1c5cXBoc29ReDlxSzBpT0lPcUl1OWx0OGhRYzkwaDA0RVhPNG40c2YxN1M2?=
 =?utf-8?B?YWNaUytIL1pseHhibFlieXZTMk1ZMDBpSmpmRVh5SEZCZTZrWTRScTRrcVVS?=
 =?utf-8?B?TjM4aEF0WngyWTgwa2VZL1BCeHc2VGRmQnVOamwrbjhicEFmSi94WUthM3l2?=
 =?utf-8?B?bnZVL01MNGwrbE9EM1dXK0hzTTdINitkZXYwNWcvTTRFSXFtUHQ3QmRFYkVC?=
 =?utf-8?B?U2k3eWk3ZlZtUnBiYnU2ZGxWaG5wZFdJTlNFbnRwRHBMWVQzMGFtclVvc3Qw?=
 =?utf-8?B?ZXJMOUtYRlAvZzNBUEJuSzVHS0hxMUErcm1VNGJDaDJZMlpUZDFDTEFiTHc0?=
 =?utf-8?B?Zjhpa1NOQ2hPYnVaM1lxNm5NWEFFMmVhR0NtS1Vrd2FrcncrUlYvdFJxb3VE?=
 =?utf-8?B?NUdNeW1ramg2eTJuNUg3ejk5RVlUc3NFSW5NN1BLOVA2TWx4QXIrcC95M09I?=
 =?utf-8?B?a3dLNFVPYVZZMFB4cEYzamJXZ0djYlFKVExTd3prako5UmlqTURtc2w4bWJy?=
 =?utf-8?B?WkJlWWw1a012VnpPMFpHMG5TTElTUzROWk02MFFUVGpHOHVydkRZSFZJbXVW?=
 =?utf-8?B?MloveGN5d2ZhTlFjVXhDWVpZd1hXai9Ubk9HZ3lTMW4rQi9hSmtJcmVjN0Zp?=
 =?utf-8?B?OUN3ZU1ITVhpOTkzN0VGSFZOeDdsaUF0VE9JS0NTanBUTVdaL0Mvc3lPd3Ja?=
 =?utf-8?B?SlJvOUxtQ25SVTVtemIxWklkU0h1bUlHU3hhcUlxc3EyQld3NTFaeXBaYzBO?=
 =?utf-8?B?cjJRMWJsYjNWL1ptQ0dGL0N3S3ZEZXd4M3hqRG1TcVBScXVpSzkrdWd6TXFQ?=
 =?utf-8?B?UDhIZFREcTJzMDczenRybklicXRxKzIyVHVPZndVTmRzalE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5186.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018)(220923002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ylo5OE1hUXRiWTNMNWZnbXZxdVo2UEpydm9QbmQrUlJZZU1HSnZkR09WTkZK?=
 =?utf-8?B?bm1qVWxtcFZ1azFobmVRQytpUGh0Unk0aWlieWtHakordGFhUTRCL2ZoT01U?=
 =?utf-8?B?RldZa01VSDV1MnZLTlBJd1lrRWMycTl1MTBiZklYTkdSeWtnSksxY25uMU9F?=
 =?utf-8?B?YVcvcHB3WXBWMjc2Zk5pODJPM3p3UEgrUUtteGhnVS9ETkdaa2dtbTRYbVpL?=
 =?utf-8?B?cTRRclFCTWpqZUlFLzVoSnVEelpyMEwvMVJkdm5lb2VlenhjQ3k0UjNIbkho?=
 =?utf-8?B?bTlBVVN4VlBpUkc0YzF4VzVTZzVUdjBxVzg0cVY2Ty93RUtkUnptMVlvR2M3?=
 =?utf-8?B?RE1hSUw4U290QUNKSW1UTzdwVjJqNzdwVVgzNE1uQjVwZGVlN0JhaU5mYmht?=
 =?utf-8?B?azJPN00ySXdKejZ4bE1vOUJ0b1B4T1RtanVmS2d3Wlk0QXVac0xEclcxS0dx?=
 =?utf-8?B?U0tIaTNreXByVC9GTTdlK0cyaHA1WUNmZEJLVTJ1ZUk0QUJ6Z3dueG1NNWlH?=
 =?utf-8?B?OE1wQjFwVHBzVi9wcXl0dVNBelpOWDFQNGR6ZG1uYmEwNWxueEhKbHFXU3hP?=
 =?utf-8?B?bkZFUTVMeTlrNmtmbkh6L0prVjc3WjBTTjJkZ2RCKzE5SENzN2hiN0x4aWNO?=
 =?utf-8?B?RUNGUHIvckozcGRHRHBzT1lPYlg1ZUpERUkzTkp4NGVvLzJuczhmRHZhSGtH?=
 =?utf-8?B?L1krVzY0U3dPTHVUU1Nsak1EcG9SRUw1T3RsU3dGZ0ltdGJsV3Y1R1BXTDN1?=
 =?utf-8?B?R1pqVVJ1c2xNamJodXlMUVI0TU0ra3RabGFIVzNRNkpqQzU4aDNkTWpEQVlm?=
 =?utf-8?B?UUJkSzJQNys0akhoQk45TVFNc04wOVRxeDJjZ0JqMkNjamJ4K21rNXhIcTd3?=
 =?utf-8?B?SDBwUWJ4NGpVaDhYaU81aXdvZ2RuZDI1TW5uRm9KRmVHYTFDaUlIZk9rL1Yv?=
 =?utf-8?B?a1liaEZ1SUhLQm00WndyZFpVVmpraVJDNFA4ZndZRk5MVnFzZjhhOFBxd2xU?=
 =?utf-8?B?OGJsQVpDQy81Zi9nMm1LZ0QzK25YVTc0UzZZSCtaSWJrcVQ5VnFWNjA0MkZS?=
 =?utf-8?B?T1M5OFplV1lJTVoyMWNsME5jQlc3ZFhUMTl5a3kwVWtIcUFvcmJ1NjZhRWhK?=
 =?utf-8?B?bEpiSHY2OCtoaVA1ckJkclBzNDQ3aCtNcnVmV0ZtVUtKeXZTdmdWRWhBTEdP?=
 =?utf-8?B?OXpWWkVuRlhOZyswd1U1bUk3M1hmMDZDM3VqZTRLY1V3SHdpUWNSajBBYTJr?=
 =?utf-8?B?WTRDcnUvL0hNVVA2QzIxbE1zdnZ6aW5uNHZZWndzbXNlZktCcTVrQXRjWGJa?=
 =?utf-8?B?OHhqemYzTnRtbjlKUittTnNjV0hqYmU5ZnRZM1oyUkNjYnY0TTdIY1NYWlUv?=
 =?utf-8?B?bExSQVF0WlVuM3hHNEF4UVJkbU4za3RzWkhiNzhBdTlnenZMMzlFSUJkT3p3?=
 =?utf-8?B?ZFU1djhmM2ttMGxTLzk5MlRkWE9qbHhQUnIyczFlQzduNGhWdTRiaFBhVG1Z?=
 =?utf-8?B?RjZCQ1AzaEM4eW1TcTU5R25BUm1mTFBOci8zMzhDTFpUZjY0cWp4QmZVa1hs?=
 =?utf-8?B?OU9SWFlZN0hJZVVOa2swd3ZMTVQ0RllWNjZySlJreC9ZQVNGSFc3S21RM1R4?=
 =?utf-8?B?dWlxT3pwQXJyeVdhbnlNY0lVdWNyRDcwRG5Ga3Mrdm5KTFJ3amtucjRkc2hP?=
 =?utf-8?B?ckJvclgrWlNMUGlIUlR6aSs5bnJoNnJWa0tYWE5CVmRibWhoajh1VFJzRWZH?=
 =?utf-8?B?QlB2TU90WnJKaFQ2WlJJR1BLOHBhYy9iYzF5ZHNQakV5VndiWVNxa0JRc2Ir?=
 =?utf-8?B?bHI0WTZOZEVvYk9OMDJRZTBIbUZMTis4d0JodUxvOFhqdHFXN0FmZFZLVmVQ?=
 =?utf-8?B?RzYrUVdScDAybXpndTU3QzBud0NXZG14L0xQZXpYSVFoRkMzcmNXZ3J4TjlR?=
 =?utf-8?B?bkllK214dFliODd1ZGNmMWtaeEw0RjVlVlhtaXZhenB3M2tlTjh5Z1RBTEdT?=
 =?utf-8?B?RWY3SnpialNWa0gvaXY0UWtsOEpPanpTeVdSOXhPVDRENUFWTkcyOERFdTlM?=
 =?utf-8?B?UjFKb001RGo4MGg3VHhnc01wZUJOSENta1VoVG1Od3RPSXNoZ3R2bTN3L3E3?=
 =?utf-8?Q?ayGTwiIZb/ewJEW2e84zHlh+A?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: petaio.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5186.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: affd893b-a2b4-463d-22ad-08dcaae40c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 06:52:41.7152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a0ba8444-51d8-486a-8d00-37e5c68c7634
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9OytdOFVnqOMVbseqrQTaInYQdw9gyxBEAdG5gPDVNQVb0KnIHdr7UhfRwo7C22vapYqmUEaScvqKg4bYl5EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR18MB6283

SGkgWWkgTGl1LCANClRoYW5rcyBmb3IgeW91ciBzdWdnZXN0aW9uISANCndlIGhhdmUgdGVzdGVk
IEFUUyB3aXRob3V0IFBBU0lEIHN1Y2Nlc3NmdWxseS4NCk5vdyBJIHdhbnQgdXNlIFBBU0lEIHRv
IHZlcmlmeSBvdGhlciBmdW5jdGlvbi5tYXliZSBub3QgcmVsYXRlZCB0byBBVFMuIA0KQ291bGQg
eW91IGdpdmUgc29tZSBzdWdnZXN0aW9uIGFib3V0IG15IGV4YW1wbGUgImlvbW11ZmQwNzE2LmNw
cCIsIEhvdyB0byBtYWtlIGl0IHJ1biBzdWNjZXNzZnVsbHkgdmlhIGxpbnV4IHVzZXIgQVBJID8g
DQpUaGFua3MgdmVyeSBtdWNoICEgDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9t
OiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4gDQpTZW50OiAyMDI05bm0N+aciDIz5pelIDEy
OjA2DQpUbzogWHVlTWVpIFl1ZSA8eHVlbWVpeXVlQHBldGFpby5jb20+OyBpb21tdUBsaXN0cy5s
aW51eC5kZXY7IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyByb2Jpbi5tdXJwaHlAYXJtLmNv
bTsgZXJpYy5hdWdlckByZWRoYXQuY29tOyBuaWNvbGluY0BudmlkaWEuY29tOyBrdm1Admdlci5r
ZXJuZWwub3JnOyBjaGFvLnAucGVuZ0BsaW51eC5pbnRlbC5jb207IGJhb2x1Lmx1QGxpbnV4Lmlu
dGVsLmNvbTsgam9yb0A4Ynl0ZXMub3JnOyBTdXJhdmVlIFN1dGhpa3VscGFuaXQgPHN1cmF2ZWUu
c3V0aGlrdWxwYW5pdEBhbWQuY29tPg0KU3ViamVjdDogUmU6IEZXOiBBYm91dCB0aGUgcGF0Y2gg
4oCdaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUvMjAyNDA0MTIwODIxMjEuMzMz
ODItMS15aS5sLmxpdUBpbnRlbC5jb20vIOKAnCBmb3IgaGVscA0KDQpDQVVUSU9OOiBUaGlzIGVt
YWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIFBldGFJTy4gRG8gbm90IGNsaWNrIG9uIGxp
bmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBh
bmQga25vdyB0aGF0IHRoZSBjb250ZW50IGlzIHNhZmUuDQoNCg0KT24gMjAyNC83LzIzIDExOjIy
LCBYdWVNZWkgWXVlIHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHnvvIENCj4gTXkg
cGMgaGFzIHRoZSBQQVNJRCBjYXBhYmlsaXR5LCBTZWUgdGhlIGF0dGFjaG1lbnQuDQoNCm9rLg0K
DQpCVFcuIEEgaGVhZHMgdXA6IHlvdSBhcmUgbG9vcGluZyB0aGUgbWFpbGluZyBsaXN0LCBzbyB5
b3UnZCBiZXR0ZXIgdXNlIHRoZSBwbGFpbiB0ZXh0IGZvcm1hdCBhbmQgYXZvaWQgaW5jbHVkaW5n
IHBpY3R1cmVzIGlmIGl0IGNhbiBiZSBleHByZXNzZWQgYnkgdGV4dC4NCg0KPiAgICIgSSBkb24n
dCB0aGluayB0aGUgQU1EIGlvbW11IGRyaXZlciBoYXMgc3VwcG9ydGVkIHRoZSBzZXRfZGV2X3Bh
c2lkIGNhbGxiYWNrIGZvciB0aGUgbm9uLVNWQSBkb21haW5zLiINCj4gICAgIC0tLS0tLSB4dWVt
ZWkgOiAgU28gaWYgSSB3YW50IHRvIHVzZSB0aGUgUEFTSUQgdG8gdGVzdCBQQ0lFIEFUUyByZXF1
ZXN0IG1lc3NhZ2VzLGNvdWxkIHlvdSBnaXZlIHNvbWUgc3VnZ2VzdGlvbnMgPyB1c3IgU1ZBIGRv
bWFpbiBjYW4gc29sdmUgdGhpZSBpc3N1ZSA/DQoNCllvdSBzaG91bGQgbm90IG1peCBBVFMgd2l0
aCBQQVNJRCwgQVRTIGRvZXMgbm90IHJlbHkgb24gUEFTSUQuIFlvdSBzaG91bGQgYmUgYWJsZSB0
byB0ZXN0IEFUUyB3aXRob3V0IFBBU0lELiBBVFMgaXMgYSBwZXJmb3JtYW5jZSBmZWF0dXJlLCBz
byBpZiB5b3Ugd2FudCB0byB0ZXN0IGl0IGluIHN5c3RlbSBsZXZlbCwgeW91IG5lZWQgYSBiZW5j
aG1hcmsgdG8gZG8gaXQuIE9yIHlvdSBjYW4gdGVzdCBpdCBpbiBwY2kgdHJhbnNhY3Rpb24gbGV2
ZWwsIHlvdSB3b3VsZCBuZWVkIHRvb2xzIGZvciBpdCB0aGVuLiBJdCdzIHVwIHRvIHlvdS4NCg0K
LS0NClJlZ2FyZHMsDQpZaSBMaXUNCg==

