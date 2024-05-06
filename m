Return-Path: <kvm+bounces-16726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0438BCF63
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 15:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423871C21344
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20E77FBC6;
	Mon,  6 May 2024 13:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b="CEyuGxtx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C5378C62;
	Mon,  6 May 2024 13:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715003275; cv=fail; b=U54bQKjNsIo4FsTExA45Zp8irObrmpYOWJWfkBVCdAHdU6CcxzVLIMmeZC426QhABm/E1wsiKRLPDObhCxFf5N8wOH51EDE37QcthoGpSZDIjFs4otc6mvLG2v0/m5M+rHhG6z3XYEk3189BtlnYniuzvEhhpWFVt3sFxRUSAxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715003275; c=relaxed/simple;
	bh=ZEQOOoYcY93B9whOMxqE+rR7OXOmXnRfCwb4vOxQaa0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gr9fkTofyatdxDsnvpgvalvv/s/nIEBp9IvHZ87EM+fV3O4mb/pbBNOqDlrj8xBqucE1Jlb3d663BbKXUeuXP+u7OUtLS8hLdA8QGavsMJsUqDp6oSRVDN7voM43kQJQVEP77Fi1KiQPhtuegRWyaG35+1YjrEfE8RiM/mkphKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com; spf=pass smtp.mailfrom=hammerspace.com; dkim=pass (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b=CEyuGxtx; arc=fail smtp.client-ip=40.107.94.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hammerspace.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHQMqqJwC+GKKZd1mnK91IDQUSFM0RRsBeg9iVNWgCdLnYpKu/621ze/Squ5n10EYjcaDNnu51lq6TvNGJMIX1NoF1wQGKgQ9cAw8G/TfNz1/WB2a8svXJiSPAOPqtxKRdaSrb454BkhDPCv4JL7Mch6IcogCM/rxcauUjxUFvmmgycsJy5Dn8gRzGaJJezJvzyOIEBjgdCxvRKa7BFJerbOnNXZ13S+660wpkZ14Psvs/cCYRyBRmYbLOqk/VgbijObtvGXWeoKh0+H3n5zZefuZ/XUMh3SwN/e9nClWh8QwQQsaUpWTeCv0l6LyGwjvNLi6xV33wrvFsImxXqYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEQOOoYcY93B9whOMxqE+rR7OXOmXnRfCwb4vOxQaa0=;
 b=Mt9eAgdM+6mItZK/JV5/BaQjnxSc7Hwq1RTSdsYiaS77vzMkwJBdx6E8l20Yx0GMaIis357RB4Ieye42RzZ8OYTSNiW+iDo5UGXWRefEJ5hfyLOtABo3vFFak8gRku+cCZfoSa0sdeQVTYOUDdxGP2m7uuPoNveP2PCywkYZUAJWiWhuxXTmGLkWQRdQu+vtIN+775EENop666VaFWSGxFlfDqkknkR814thi7kRxjOLNdG/wmVHIX09eL4HPRqqWy3CBbLEbTVfHrEmkjUT5mauT/hs7F8EoDNhJatVkT5AnLYeZwNvtWElz7ywxE6OV9hXPsoPfqSqSNIrPEdOZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEQOOoYcY93B9whOMxqE+rR7OXOmXnRfCwb4vOxQaa0=;
 b=CEyuGxtxhbyt/yEqFj55fC8HO1CWpPEbdAUkRZhhW1gCmh8+K53gDaOeBNJ6M0xvxY0EYkIE/P0sZOdATd9p7oQK2P1E6eLK7jjA7KjS/8APJvhu4udvpKNwotlJ6cTp24rYasRrvzmaJNcu0/1s2SD98EYYCy5X1B9zx5DTWTY=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by SJ2PR13MB6166.namprd13.prod.outlook.com (2603:10b6:a03:4f9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 13:47:51 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::5bb5:501a:fb40:5057]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::5bb5:501a:fb40:5057%6]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 13:47:51 +0000
From: Trond Myklebust <trondmy@hammerspace.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "thomas@glanzmann.de"
	<thomas@glanzmann.de>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>
Subject: Re: I/O stalls when merging qcow2 snapshots on nfs
Thread-Topic: I/O stalls when merging qcow2 snapshots on nfs
Thread-Index: AQHanuDhcYq2/4ppfUWdl/WzrYiYD7GKOjWA
Date: Mon, 6 May 2024 13:47:51 +0000
Message-ID: <74f183ca71fbde90678f138077965ffd19bed91b.camel@hammerspace.com>
References: <ZjdtmFu92mSlaHZ2@glanzmann.de>
In-Reply-To: <ZjdtmFu92mSlaHZ2@glanzmann.de>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|SJ2PR13MB6166:EE_
x-ms-office365-filtering-correlation-id: 17313fef-0576-497c-f4b1-08dc6dd31f53
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?WlJja0lybFFCOFZHajQrbjVmSWxxZ1hTVlJLZFhnd0NvdndSYTBtak9kUlY3?=
 =?utf-8?B?VXA3ZnZjaERLNE43L3J5akp3aFkwZFpTbG9ucTQ3TEpuTktVOEc1V25RMDJX?=
 =?utf-8?B?ZlRqVlRGRk52Z3JJYURDV1VLaWdhYmNOOXNvbVh1UC9SOFpNYUd6ZGsvWHJ1?=
 =?utf-8?B?MWdSaTdndEFTeW9DNEhsR2E2bWVqOWFFazBUa0tqbk1YQm50ZDVtRzN0N3Fi?=
 =?utf-8?B?SGRyMS9MQ252MCtHbVNoVmxlMzdJdkpaSURTbE1zTHBESHNOeEZzTVd1UEp1?=
 =?utf-8?B?bnl6dkIxK1RydkFOVk42ZmNlaDg2Q3ljbW9rcEN0TDlickVjR1ZuNWFGREpi?=
 =?utf-8?B?M3g5UUdQdFFFS0R6OGlDeE5uQkNuMlg1NTFMdS9zc3N2NkpXeFFvMzg0K0kx?=
 =?utf-8?B?akRCNmFSWWd0ekNJSHRvWGgyVzhIZzFRc1ZFK0pGeTBzT2dENHZZemdqOU1o?=
 =?utf-8?B?dytrUXVoZ2wvbzBLK0NGeUNRQXRiY0FLOTRuMUt5RU0zVFlxbVFRZTI4NHll?=
 =?utf-8?B?b1ZMOW45aWM3dndHRWRvVW02ck9yTHU2ZUN1MVEzYkFTb0pPcHBqV0pnU0ps?=
 =?utf-8?B?dVdFK01JczgyMUdOb3BhWlA5ZmVEVkhka3Z4alBYaHJRNS9BYUcyQkY1WkhR?=
 =?utf-8?B?c1JOKzgxRVFPTFozekZZRHVNK0tqUmxrcEp2Y0VJa3ZjZFZoRGd4TnBpRlpW?=
 =?utf-8?B?S0gweXppRC9RSFZDZndITzFXdE9XU05uaDVUd0lwaERobUMvb0VSazJxYmNo?=
 =?utf-8?B?Tm9XUThKZzcvZnNHQ1hFN0ZYN01zbUpobnQzNSs4TFFFdm9BTkJiSkhpN3hx?=
 =?utf-8?B?bTA5bGhLU2tESVBnLytKeWh0Vis2TjNuNmpjczBESzdvZ29Nd0ZMOWE1Q1hx?=
 =?utf-8?B?Rk5pb293L1ZrYXlyN0RGYlB0ZjZ4NkZ0czYzbk5XRThndkd0dW12RGFUMlFm?=
 =?utf-8?B?YVp0RVUvNjdFY3N5N3FxaEVkaURPWlRTTmlEWGZnSTNla1Zvd013ZkNGbHc3?=
 =?utf-8?B?QzY0ZnIwNkxJdkRwSjZRRjNJN3NpNER0dlFobk52dVQvR1poWUVMQnpaQnVV?=
 =?utf-8?B?SXM1SUZCOGxKVDBFZjBXRlV0YWxTbktWSEN4L0RSYkVaWFRZVW5wUGFGYlFh?=
 =?utf-8?B?THBYd1FWZWY5dVpYd3drTjdlYkJmaUtNUzQ5c2FsV3lEOGtENnFJWlNyWEhw?=
 =?utf-8?B?Ums5VzM1QnMxUDJFZ0llTERyV2RTM1FidmNXRFo1REM1M090dWJLaWJYc0Nk?=
 =?utf-8?B?R0IxSnhSZVVnTGhrUTR6d08yWTRCQ0d4MVhQM3JRbjJoWmQ1WnVUMDNWSTY1?=
 =?utf-8?B?Wkd0R3RhK1hJSlhzWmRiZWIrVk1NRWovRG9CYVljSFUzZDZhV3p6T0JtMWh0?=
 =?utf-8?B?WW9nYUw3WGQ4aGJDT3hIb3NiNzZRVG02QnFwNkRhLzlkMXY0emIyOGh1RFd3?=
 =?utf-8?B?RkhVMUUwN2FmbGMxTGMyMnFMZ0FwVHNlVWxMK1lrZnIyRzVLM3gxYUk0dXNK?=
 =?utf-8?B?eVRLZkRkSmFGNmNnR2MxU1hVQk9CdldKNkltcEpKUHRSUzYxTnl3eXhQZWwz?=
 =?utf-8?B?VDZUMi9JMVJFZ0tOVHZNckN5MXlHZ1krUWZ2MXREV0hQeXFmb2Fvb3ZvYmts?=
 =?utf-8?B?ZnVnYkg1amN1TjAzeDVEOFJOUWwzNXJtRXFva3ZITmx5QXR1eGh6bUdxUzAz?=
 =?utf-8?B?RHc4VmNZelUrREZTWXhoUEJXeUQ2STkwd2lQeS9CMXFLb2JXWUJHZkhyMEcz?=
 =?utf-8?B?VEpGUjNtYlN5Z2R0dW9vQ2VJSlRuTXNCS0ZadzUvdXE3R2JyN1R0ZFNSM3Zl?=
 =?utf-8?B?N01SbHI5a0J5Y1VkMm9qQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d2ZuSkRXcCtDMVlzeTJNMUZkN0FuN1AySnErZUFwQTN0ampjOGRGRDZva1Uw?=
 =?utf-8?B?Zk1jenJDMXZHUmhPelJWT0lzWmtCaUY2UmlpellFZEN5TjJBUkdrSkllb1lE?=
 =?utf-8?B?cEh1NnAyalFEK1lIU0dRSnRhTE94cklYT3FNWXI5RlRWenZtcHJEaUJKOFMr?=
 =?utf-8?B?UWdzS2V3L2F1cVFZYmwyUzFlSkxoeVhQWitKNHlpdmJHMFkwT290cFlTTmZv?=
 =?utf-8?B?NFZvVW5aZWsycWsyY2VlSE9oakpwRDhpd21FWHdiZXBTUzRTYlo0b0MzTXF1?=
 =?utf-8?B?WHhwSUQxdDkvNElhQTdoaVpQUXM4eVdqR1BaeWd0eVgvZlEwdVVuUndOTUF3?=
 =?utf-8?B?b0dQekxSOG9kVWgvZUU2d2JINndNOHpUUmdmSVdNMTdzK3d2LzdSdDNwRmZN?=
 =?utf-8?B?bkhnRW5BdTdtNG9QWVYvM2FSa1UxcWc1dUxOWEgzUFdZb1Q3UzdnbDlSakhl?=
 =?utf-8?B?SG9GVWJPd1dnWFhaK3kxS0pPUW5pbWpURk1sS1pReEVJdmtST1B6ZFpoTmpp?=
 =?utf-8?B?VWQzM2dnVXRQMTk2eWRjczBCTTlKeUdKZWFGNEVFME9FN2MrS0s3Y1Y2UjIv?=
 =?utf-8?B?Um1naG9ndXFEVDd0WFRTVWc2MHkzenppZlJWUTR6N1dNd0I4ckFxaXphcDZj?=
 =?utf-8?B?ZGRxeXJwNWY4VnNKcEpXY0NMdFA2azVVaTlOKzlQRHhwOGMzdUlieCtpRnFD?=
 =?utf-8?B?ZWU3ZG55OGZLQXdaNkQyUWlXb0NBWG1lVCtKNmRNZXQyTk9FQTh2MU9rYUht?=
 =?utf-8?B?Yko3L2h4OG9NUFlJMFBTL1prVWEzL2tUVGo5Rko4Nis4blZ2SThMb2tCcFcv?=
 =?utf-8?B?UDk5dnRZZ21FWkpWQWJmN0h1Z3ZDZGMyYmIwVHV0dWJmVFVtTUpGVjhqbFRj?=
 =?utf-8?B?czdNWU8zbTRRZUVHTk5wL0loMk54WG4vcFVSU3FIajA2aHRUZkFSWVg2Y0g3?=
 =?utf-8?B?QXVzTFhGcmJlWkQwV2QrYVozVlUwTTBBbnMrdUlOSDRxK1hYcWRmeUZhM3lJ?=
 =?utf-8?B?UFdFQU1hQVRWbmd5aFl4YVA3dkFVOTJXQ0dlZ2hiN0FKb0pRa2wvZk5pb2M1?=
 =?utf-8?B?ckZYWGZ1bHRQS1ZiZGFraEpwNTVKRkh0YTdNQ3RaNjZ6YzZTMWFpb0loUTQw?=
 =?utf-8?B?NUR6YW96K2x4dDFDdGhVYlBlZnVVS3grSHhWdi90Y2s4eWM0c3NkVEFGN3c1?=
 =?utf-8?B?V0ZUOGN3YTlpSEFDL0ZRb2YyWVRHd3NSV1ZaWkJvaVlDa0crN1JFaDBkUXd1?=
 =?utf-8?B?bFFmQW9XMTJCNG9rOEJUV2gzaGZCUmN2eTZId1MvWnY4bnRqbkdab1E2enNM?=
 =?utf-8?B?TkY3Y3NGb1B2ckVlSFdPSytFWXhVd25GWC8xQWM5N3JsRk52NERUeFRnWUxB?=
 =?utf-8?B?c0x1NlAyNXdUY0VvZHZOQng3M0JKb2hrTDMzVm1lZzJQb05YZ0gwcnVwU1Fx?=
 =?utf-8?B?T2FTWEZWUHBrTHZ5elB2WVZSUXNxMFk0Y0V0SDRDK0tsK3VjVXgya1hKY3hv?=
 =?utf-8?B?ZlhsQ3JsMGFLb1loeTBralZzbTBaMFdYb0ozV3BMejg1V2RXZlYzZnFPSWVy?=
 =?utf-8?B?NVdpVDVVRmZRN1habEE0VzR6dWF3ckN5ckpZRWQ5SmJ1a0R3MUNzYnJlcFQz?=
 =?utf-8?B?YW45NnZSV3FvY3dyamhNV1B3UHdMbWVyTnYwTHpRSXY3U3A1UHJRbUNMWlVR?=
 =?utf-8?B?aUlvTlgxWGVCcnRTZy96UEpseXUrZGpvRVEyWmVyL2lIeGxVUU5PZngvSEoz?=
 =?utf-8?B?QVVjOTJMam5sektHc0ozZElBVWMwU0pzbTVsTkZLSTdUL0dsekE3TW9zWGZu?=
 =?utf-8?B?OHV3a0tPQVFwcXBqMEN6MzVpeVY0WFZkbE85dVNwR3V6RU5VcXRYOWFyS2po?=
 =?utf-8?B?Q3NuL2dXd2YzRUpjT3Z2cFpmdWUxczFjQ0ZoWWtYb0JFaDJSb2JIWWRzdWpP?=
 =?utf-8?B?YXVPYk5McytWL3d1bEorVzM5WWwzbzQrUlhGdDR4N3BXSnhUVWJ4QVFKL09m?=
 =?utf-8?B?OHVTZFFZeGpHSGVrcjZVdXEzL0hpcWZ6SEdrZUZLRkh0SjZTc1lLZWl0blJz?=
 =?utf-8?B?TExLSkVORXZSbEZSektXTXJsUjAzNVVoVjN0ZFNJc2xsMm1BU2xOZ3NkREFn?=
 =?utf-8?B?aHovQm1Ia2ZMd2Fzd203eHlLdzYxUWI4c0R0cmNIN0ZhMDAyQWtxaEQ4dVN4?=
 =?utf-8?B?eVZzTlp4TzdRODA1NCsvdEZoYkFQUEZDbWpKd1lRM3F1NmRsS1RXWHd5WXgv?=
 =?utf-8?B?eUhyS0EwQ3gvREI1b0xzSExFaVJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86B4552450AF524F95AD3D94BD5EF71B@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17313fef-0576-497c-f4b1-08dc6dd31f53
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 13:47:51.0779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dhVUCxodNYftBym3dk1fG54sMRiIzGCHmvakHZCObO56tJu+3h/nM0P+6ZUy4fq9xRyELOFLEHtojtVuKKUTaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6166

T24gU3VuLCAyMDI0LTA1LTA1IGF0IDEzOjI5ICswMjAwLCBUaG9tYXMgR2xhbnptYW5uIHdyb3Rl
Og0KPiBIZWxsbywNCj4gSSBvZnRlbiB0YWtlIHNuYXBzaG90cyBpbiBvcmRlciB0byBtb3ZlIGt2
bSBWTXMgZnJvbSBvbmUgbmZzIHNoYXJlIHRvDQo+IGFub3RoZXIgd2hpbGUgdGhleSdyZSBydW5u
aW5nIG9yIHRvIHRha2UgYmFja3Vwcy4gU29tZXRpbWVzIEkgaGF2ZQ0KPiB2ZXJ5DQo+IGxhcmdl
IFZNcyAoMS4xIFRCKSB3aGljaCB0YWtlIGEgdmVyeSBsb25nIHRpbWUgKDQwIG1pbnV0ZXMgLSAy
IGhvdXJzKQ0KPiB0bw0KPiBiYWNrdXAgb3IgbW92ZS4gVGhleSBhbHNvIHdyaXRlIGJldHdlZW4g
MjAgLSA2MCBHQiBvZiBkYXRhIHdoaWxlDQo+IGJlaW5nDQo+IGJhY2tlZCB1cCBvciBtb3ZlZC4g
T25jZSB0aGUgYmFja3VwIG9yIG1vdmUgaXMgZG9uZSB0aGUgZGlydHkNCj4gc25hcHNob3QNCj4g
ZGF0YSBuZWVkcyB0byBiZSBtZXJnZWQgdG8gdGhlIHBhcmVudCBkaXNrLiBXaGlsZSBkb2luZyB0
aGlzIEkgb2Z0ZW4NCj4gZXhwZXJpZW5jZSBJL08gc3RhbGxzIHdpdGhpbiB0aGUgVk1zIGluIHRo
ZSByYW5nZSBvZiAxIC0gMjAgc2Vjb25kcy4NCj4gU29tZXRpbWVzIHdvcnNlLiBCdXQgSSBoYXZl
IHNvbWUgdmVyeSBsYXRlbmN5IHNlbnNpdGl2ZSBWTXMgd2hpY2gNCj4gY3Jhc2gNCj4gb3IgbWlz
YmVoYXZlIGFmdGVyIDE1IHNlY29uZHMgSS9PIHN0YWxscy4gU28gSSB3b3VsZCBsaWtlIHRvIGtu
b3cgaWYNCj4gdGhlcmUNCj4gaXMgc29tZSB0dWVuaW5nIEkgY2FuIGRvIHRvIG1ha2UgdGhlc2Ug
SS9PIHN0YWxscyBzaG9ydGVyLg0KPiANCj4gLSBJIGFscmVhZHkgdHJpZWQgdG8gc2V0IHZtLmRp
cnR5X2V4cGlyZV9jZW50aXNlY3M9MTAwIHdoaWNoIGFwcGVhcnMNCj4gdG8NCj4gwqAgbWFrZSBp
dCBiZXR0ZXIsIGJ1dCBub3QgdW5kZXIgMTUgc2Vjb25kcy4gUGVyZmVjdCB3b3VsZCBiZSBJL08N
Cj4gc3RhbGxzDQo+IMKgIG5vIG1vcmUgdGhhbiAxIHNlY29uZC4NCj4gDQo+IFRoaXMgaXMgaG93
IHlvdSBjYW4gcmVwcm9kdWNlIHRoZSBpc3N1ZToNCj4gDQo+IC0gTkZTIFNlcnZlcjoNCj4gbWtk
aXIgL3NzZA0KPiBhcHQgaW5zdGFsbCAteSBuZnMta2VybmVsLXNlcnZlcg0KPiBlY2hvICcvbmZz
IDAuMC4wLjAvMC4wLjAuMChydyxub19yb290X3NxdWFzaCxub19zdWJ0cmVlX2NoZWNrLHN5bmMp
Jw0KPiA+IC9ldGMvZXhwb3J0cw0KPiBleHBvcnRzIC1yYQ0KPiANCj4gLSBORlMgQ2xpZW50IC8g
S1ZNIEhvc3Q6DQo+IG1vdW50IHNlcnZlcjovc3NkIC9tbnQNCj4gIyBQdXQgYSBWTSBvbiAvbW50
IGFuZCBzdGFydCBpdC4NCj4gIyBDcmVhdGUgYSBzbmFwc2hvdDoNCj4gdmlyc2ggc25hcHNob3Qt
Y3JlYXRlLWFzIC0tZG9tYWluIHRlc3R5IGd1ZXN0LXN0YXRlMSAtLWRpc2tzcGVjDQo+IHZkYSxm
aWxlPS9tbnQvb3ZlcmxheS5xY293MiAtLWRpc2stb25seSAtLWF0b21pYyAtLW5vLW1ldGFkYXRh
IC1uby0NCj4gbWV0YWRhdGENCj4gDQo+IC0gSW4gdGhlIFZNOg0KPiANCj4gIyBXcml0ZSBzb21l
IGRhdGEgKGluIG15IGNhc2UgNiBHQiBvZiBkYXRhIGFyZSB3cml0ZW4gaW4gNjAgc2Vjb25kcw0K
PiBkdWUNCj4gIyB0byB0aGUgbmZzIGNsaWVudCBiZWluZyBjb25uZWN0ZWQgd2l0aCBhIDEgR2Jp
dC9zIGxpbmspDQo+IGZpbyAtLWlvZW5naW5lPWxpYmFpbyAtLWZpbGVzaXplPTMyRyAtLXJhbXBf
dGltZT0ycyAtLXJ1bnRpbWU9MW0gLS0NCj4gbnVtam9icz0xIC0tZGlyZWN0PTEgLS12ZXJpZnk9
MCAtLXJhbmRyZXBlYXQ9MCAtLWdyb3VwX3JlcG9ydGluZyAtLQ0KPiBkaXJlY3Rvcnk9L21udCAt
LW5hbWU9d3JpdGUgLS1ibG9ja3NpemU9MW0gLS1pb2RlcHRoPTEgLS0NCj4gcmVhZHdyaXRlPXdy
aXRlIC0tdW5saW5rPTENCj4gIyBEbyBzb21lIHN5bmNocm9ub3VzIEkvTw0KPiB3aGlsZSB0cnVl
OyBkbyBkYXRlIHwgdGVlIC1hIGRhdGUubG9nOyBzeW5jOyBzbGVlcCAxOyBkb25lDQo+IA0KPiAt
IE9uIHRoZSBORlMgQ2xpZW50IC8gS1ZNIGhvc3Q6DQo+ICMgTWVyZ2UgdGhlIHNuYXBzaG90IGlu
dG8gdGhlIHBhcmVudGRpc2sNCj4gdGltZSB2aXJzaCBibG9ja2NvbW1pdCB0ZXN0eSB2ZGEgLS1h
Y3RpdmUgLS1waXZvdCAtLWRlbGV0ZQ0KPiANCj4gU3VjY2Vzc2Z1bGx5IHBpdm90ZWQNCj4gDQo+
IHJlYWzCoMKgwqAgMW00LjY2NnMNCj4gdXNlcsKgwqDCoCAwbTAuMDE3cw0KPiBzeXPCoMKgwqDC
oCAwbTAuMDA3cw0KPiANCj4gSSBleHBvcnRlZCB0aGUgbmZzIHNoYXJlIHdpdGggc3luYyBvbiBw
dXJwb3NlIGJlY2F1c2UgSSBvZnRlbiB1c2UNCj4gZHJiZA0KPiBpbiBzeW5jIG1vZGUgKHByb3Rv
Y29sIGMpIHRvIHJlcGxpY2F0ZSB0aGUgZGF0YSBvbiB0aGUgbmZzIHNlcnZlciB0bw0KPiBhDQo+
IHNpdGUgd2hpY2ggaXMgMjAwIGttIGF3YXkgdXNpbmcgYSAxMCBHYml0L3MgbGluay4NCj4gDQo+
IFRoZSByZXN1bHQgaXM6DQo+ICh0ZXN0eSkgW35dIHdoaWxlIHRydWU7IGRvIGRhdGUgfCB0ZWUg
LWEgZGF0ZS5sb2c7IHN5bmM7IHNsZWVwIDE7DQo+IGRvbmUNCj4gU3VuIE1hecKgIDUgMTI6NTM6
MzYgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDEyOjUzOjM3IENFU1QgMjAyNA0KPiBTdW4gTWF5
wqAgNSAxMjo1MzozOCBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTI6NTM6MzkgQ0VTVCAyMDI0
DQo+IFN1biBNYXnCoCA1IDEyOjUzOjQwIENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMjo1Mzo0
MSBDRVNUIDIwMjQgPCBoZXJlIEkgc3RhcnRlZCB2aXJzaCBibG9ja2NvbW1pdA0KPiBTdW4gTWF5
wqAgNSAxMjo1Mzo0NSBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTI6NTM6NTAgQ0VTVCAyMDI0
DQo+IFN1biBNYXnCoCA1IDEyOjUzOjU5IENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMjo1NDow
NCBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTI6NTQ6MjIgQ0VTVCAyMDI0DQo+IFN1biBNYXnC
oCA1IDEyOjU0OjIzIENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMjo1NDoyNyBDRVNUIDIwMjQN
Cj4gU3VuIE1hecKgIDUgMTI6NTQ6MzIgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDEyOjU0OjQw
IENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMjo1NDo0MiBDRVNUIDIwMjQNCj4gU3VuIE1hecKg
IDUgMTI6NTQ6NDUgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDEyOjU0OjQ2IENFU1QgMjAyNA0K
PiBTdW4gTWF5wqAgNSAxMjo1NDo0NyBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTI6NTQ6NDgg
Q0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDEyOjU0OjQ5IENFU1QgMjAyNA0KPiANCj4gVGhpcyBp
cyB3aXRoICd2bS5kaXJ0eV9leHBpcmVfY2VudGlzZWNzPTEwMCcgd2l0aCB0aGUgZGVmYXVsdCB2
YWx1ZXMNCj4gJ3ZtLmRpcnR5X2V4cGlyZV9jZW50aXNlY3M9MzAwMCcgaXQgaXMgd29yc2UuDQo+
IA0KPiBJL08gc3RhbGxzOg0KPiAtIDQgc2Vjb25kcw0KPiAtIDkgc2Vjb25kcw0KPiAtIDUgc2Vj
b25kcw0KPiAtIDE4IHNlY29uZHMNCj4gLSA0IHNlY29uZHMNCj4gLSA1IHNlY29uZHMNCj4gLSA4
IHNlY29uZHMNCj4gLSAyIHNlY29uZHMNCj4gLSAzIHNlY29uZHMNCj4gDQo+IFdpdGggdGhlIGRl
ZmF1bHQgdm0uZGlydHlfZXhwaXJlX2NlbnRpc2Vjcz0zMDAwIEkgZ2V0IHNvbWV0aGluZyBsaWtl
DQo+IHRoYXQ6DQo+IA0KPiAodGVzdHkpIFt+XSB3aGlsZSB0cnVlOyBkbyBkYXRlIHwgdGVlIC1h
IGRhdGUubG9nOyBzeW5jOyBzbGVlcCAxOw0KPiBkb25lDQo+IFN1biBNYXnCoCA1IDExOjUxOjMz
IENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMTo1MTozNCBDRVNUIDIwMjQNCj4gU3VuIE1hecKg
IDUgMTE6NTE6MzUgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDExOjUxOjM3IENFU1QgMjAyNA0K
PiBTdW4gTWF5wqAgNSAxMTo1MTozOCBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTE6NTE6Mzkg
Q0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDExOjUxOjQwIENFU1QgMjAyNCA8PCB2aXJzaCBibG9j
a2NvbW1pdA0KPiBTdW4gTWF5wqAgNSAxMTo1MTo0OSBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUg
MTE6NTI6MDcgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDExOjUyOjA4IENFU1QgMjAyNA0KPiBT
dW4gTWF5wqAgNSAxMTo1MjoyNyBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTE6NTI6NDUgQ0VT
VCAyMDI0DQo+IFN1biBNYXnCoCA1IDExOjUyOjQ3IENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAx
MTo1Mjo0OCBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTE6NTI6NDkgQ0VTVCAyMDI0DQo+IA0K
PiBJL08gc3RhbGxzOg0KPiANCj4gLSA5IHNlY29uZHMNCj4gLSAxOCBzZWNvbmRzDQo+IC0gMTkg
c2Vjb25kcw0KPiAtIDE4IHNlY29uZHMNCj4gLSAxIHNlY29uZHMNCj4gDQo+IEknbSBvcGVuIHRv
IGFueSBzdWdnZXN0aW9ucyB3aGljaCBpbXByb3ZlIHRoZSBzaXR1YXRpb24uIEkgb2Z0ZW4gaGF2
ZQ0KPiAxMA0KPiBHYml0L3MgbmV0d29yayBhbmQgYSBsb3Qgb2YgZGlydHkgYnVmZmVyIGNhY2hl
LCBidXQgYXQgdGhlIHNhbWUgdGltZQ0KPiBJDQo+IG9mdGVuIHJlcGxpY2F0ZSBzeW5jaHJvbm91
c2x5IHRvIGEgc2Vjb25kIHNpdGUgMjAwIGttcyBhcGFydCB3aGljaA0KPiBvbmx5DQo+IGdpdmVz
IG1lIGFyb3VuZCAxMDAgTUIvcyB3cml0ZSBwZXJmb3JtYW5jZS4NCj4gDQo+IFdpdGggdm0uZGly
dHlfZXhwaXJlX2NlbnRpc2Vjcz0xMCBldmVuIHdvcnNlOg0KPiANCj4gKHRlc3R5KSBbfl0gd2hp
bGUgdHJ1ZTsgZG8gZGF0ZSB8IHRlZSAtYSBkYXRlLmxvZzsgc3luYzsgc2xlZXAgMTsNCj4gZG9u
ZQ0KPiBTdW4gTWF5wqAgNSAxMzoyNTozMSBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTM6MjU6
MzIgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDEzOjI1OjMzIENFU1QgMjAyNA0KPiBTdW4gTWF5
wqAgNSAxMzoyNTozNCBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTM6MjU6MzUgQ0VTVCAyMDI0
DQo+IFN1biBNYXnCoCA1IDEzOjI1OjM2IENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMzoyNToz
NyBDRVNUIDIwMjQgPCB2aXJzaCBibG9ja2NvbW1pdA0KPiBTdW4gTWF5wqAgNSAxMzoyNjowMCBD
RVNUIDIwMjQNCj4gU3VuIE1hecKgIDUgMTM6MjY6MDEgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1
IDEzOjI2OjA2IENFU1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMzoyNjoxMSBDRVNUIDIwMjQNCj4g
U3VuIE1hecKgIDUgMTM6MjY6NDAgQ0VTVCAyMDI0DQo+IFN1biBNYXnCoCA1IDEzOjI2OjQyIENF
U1QgMjAyNA0KPiBTdW4gTWF5wqAgNSAxMzoyNjo0MyBDRVNUIDIwMjQNCj4gU3VuIE1hecKgIDUg
MTM6MjY6NDQgQ0VTVCAyMDI0DQo+IA0KPiBJL08gc3RhbGxzOg0KPiANCj4gLSAyMyBzZWNvbmRz
DQo+IC0gNSBzZWNvbmRzDQo+IC0gNSBzZWNvbmRzDQo+IC0gMjkgc2Vjb25kcw0KPiAtIDEgc2Vj
b25kDQo+IA0KPiBDaGVlcnMsDQo+IMKgwqDCoMKgwqDCoMKgIFRob21hcw0KPiANCg0KVHdvIHN1
Z2dlc3Rpb25zOg0KICAgMS4gVHJ5IG1vdW50aW5nIHRoZSBORlMgcGFydGl0aW9uIG9uIHdoaWNo
IHRoZXNlIFZNcyByZXNpZGUgd2l0aCB0aGUNCiAgICAgICJ3cml0ZT1lYWdlciIgbW91bnQgb3B0
aW9uLiBUaGF0IGVuc3VyZXMgdGhhdCB0aGUga2VybmVsIGtpY2tzDQogICAgICBvZmYgdGhlIHdy
aXRlIG9mIHRoZSBibG9jayBpbW1lZGlhdGVseSBvbmNlIFFFTVUgaGFzIHNjaGVkdWxlZCBpdA0K
ICAgICAgZm9yIHdyaXRlYmFjay4gTm90ZSwgaG93ZXZlciB0aGF0IHRoZSBrZXJuZWwgZG9lcyBu
b3Qgd2FpdCBmb3INCiAgICAgIHRoYXQgd3JpdGUgdG8gY29tcGxldGUgKGkuZS4gdGhlc2Ugd3Jp
dGVzIGFyZSBhbGwgYXN5bmNocm9ub3VzKS4NCiAgIDIuIEFsdGVybmF0aXZlbHksIHRyeSBwbGF5
aW5nIHdpdGggdGhlICd2bS5kaXJ0eV9yYXRpbycgb3INCiAgICAgICd2bS5kaXJ0eV9ieXRlcycg
dmFsdWVzIGluIG9yZGVyIHRvIHRyaWdnZXIgd3JpdGViYWNrIGF0IGFuDQogICAgICBlYXJsaWVy
IHRpbWUuIFdpdGggdGhlIGRlZmF1bHQgdmFsdWUgb2Ygdm0uZGlydHlfcmF0aW89MjAsIHlvdQ0K
ICAgICAgY2FuIGVuZCB1cCBjYWNoaW5nIHVwIHRvIDIwJSBvZiB5b3VyIHRvdGFsIG1lbW9yeSdz
IHdvcnRoIG9mDQogICAgICBkaXJ0eSBkYXRhIGJlZm9yZSB0aGUgVk0gdHJpZ2dlcnMgd3JpdGVi
YWNrIG92ZXIgdGhhdCAxR2JpdCBsaW5rLg0KDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0IExpbnV4
IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1t
ZXJzcGFjZS5jb20NCg==

