Return-Path: <kvm+bounces-45959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F902AAFF16
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6080CB2251F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030E526FD88;
	Thu,  8 May 2025 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FmNFDKiF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647687F477
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746717635; cv=fail; b=EpFVO7jdjfmKcpsl5KM0jbQUHNvCL/tv9Qf7TDK2bZWYGStvvUs4Pwv9Ja1hzX/AY3PizkTBps3jqZX7GbsCYuSCmSHuTG6yehlzucI4RABRtl0RjC7EVbPL6WBrCddlJlGDdvhoVroOnn/NPDV5IU1V3dumUS8y1oiaEnFR6Ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746717635; c=relaxed/simple;
	bh=WAJQ2fuDaJyCZoWM0a+F6oukRQD7XlpJ2A/WZaLbLQs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=my07t66yNJ0uW23FQSRmdt+PRNXy9cP8892IzdCuVTeWIEI+Z6DzmM5eZBcMUKjb7+PB34X0NJjEgeA4Rjy8Zic3Wcpq1YDiTfiyWaML7mrQD405zCXQnKngIxlhFcQyP3wkrZCr9dwX4sLSq/fQrYg1JSXimfhyHMiJGOFJXFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FmNFDKiF; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtN+dQMSyMutVeM+RONuYXcg1S3HQ8FQL7NdMZvwiR5aj1DuAqPqNkTNntdxNUaBAJXFcuyVb+3pgFRjxHh/a0daPuFL1NouMrqTJ5Yp8uNhNKkieLGpGkGPTN6Aa1nXBDMS/4/zlwMTQDtYCdhakPjguhr/Dwad3MRCds3+WcSZLCrbBhZHuhgu0hK6Nb9FcXEGLl9RtCW0HpVXlkMNUAZrTYUG9or0tDkVm+Rz1+IuoUvh+e2cgaqAQMQVJtzWeB4M2vOesY3oR7LlZ9TYcrroxa/yvgRG7KbViN4AvJSMDOw80so7QX83NJM3mekO3G7LI00CrWyySvVdeqD4xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAJQ2fuDaJyCZoWM0a+F6oukRQD7XlpJ2A/WZaLbLQs=;
 b=QcCupjPTTKJJPJv4ShMnrR6UXoQptGw50jw+3NDAtM01qpMYW4RIlKlsZstZl6VpqCYpnHTt9PsXae4myI449Uvq0lSHPjFVU4tyfWIzxv/wxgFAvqqjfKSYudI+oCbl2JQsjPaFSQx7b45F/RQqnMkcTygaa/DgBxZ9WOR9OrRayrj8czJFXlVABjRQMlXNbm0pnLiaEV7f4JrafS/qazGCf+P3pHzdJVrucJFc6v1izwDvt8u3TS22WguZTa85bNPCuyaYXL8yNEHD3mYq2qajRDrdFBIt9UKllsX+tm8wCEWCBSaLOFIK3EbH1MEQPcItuuZrCmMJnqEA5zGdqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAJQ2fuDaJyCZoWM0a+F6oukRQD7XlpJ2A/WZaLbLQs=;
 b=FmNFDKiFurWf694CMW9O1pEikg4BGqaxxSCzf2n0va/QIFKYZSaJ4ZxOLQPqTqpgelJiJV4xsioSCjM/FRMv7PfpZlt46ithNBa2zl+C6wz1KLTB4LkMy5ebfZg1QOFcHiOFASjhGM0Rm2u6UglC0zAIFoMvOvdgnmq6qTJmKaZedol5DKrxfz0GxEAbIeXBHmPgAhh/RNDCCDJNkZWeUDnyLRl9Smy2H1pjMYSg+UUnNsRpD+YlRLm7/9RrPOcNq5V69GkMscInrol5CkQuoW6WpGLAhYCWiqcZLR0GDbMoL7j2tH8drjVaCZ0sRUTbb030WB5UcDoWaIEIrYxOrQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS0PR12MB8816.namprd12.prod.outlook.com (2603:10b6:8:14f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 15:20:26 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8699.024; Thu, 8 May 2025
 15:20:26 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>
CC: "eperezma@redhat.com" <eperezma@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>
Subject: Re: [PATCH v2] vringh: use bvec_kmap_local
Thread-Topic: [PATCH v2] vringh: use bvec_kmap_local
Thread-Index: AQHbuqSIdf/M3o8V1kGFcND3MpicdbPI5CiA
Date: Thu, 8 May 2025 15:20:26 +0000
Message-ID: <ba360382-710b-4b61-b4d4-4fd9d6d42c35@nvidia.com>
References: <20250501142244.2888227-1-hch@lst.de>
In-Reply-To: <20250501142244.2888227-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS0PR12MB8816:EE_
x-ms-office365-filtering-correlation-id: 2a898946-5219-4bde-8b0f-08dd8e43dc12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NmhmTHg4MXZkQUFuZ0MwN1ZNcFFqVkdDUzdNM21OMkV6S0hpNFUzakFPODFo?=
 =?utf-8?B?bWZNTEJXcUFWMlpmNHV0VVU2bUZLbnpYd1hFbmFjZW9zZisvcHptbldIRVpB?=
 =?utf-8?B?K0tXMkgvMG15WUI1RWxra2o0aUp0VzdXaGFrVHJhdzZsd2JROUo2bTJHV2o5?=
 =?utf-8?B?bkNrNlhiUGJRVDdyZlY4OVorNG1hMFBEcDRlT1NlOEV2VmQ2dUlia3RJeXhP?=
 =?utf-8?B?TG00RFVGeEZCNEVCMjFhRzVYTm1uWjhNVnYvQTVQSkhjMmxtT0lva0dmZFBw?=
 =?utf-8?B?NG5DZE9CK3JlUnU4c1B5cm1tNXVlVFhuMnVXVTdhbXhJeEt0U2VmNVY1OWhq?=
 =?utf-8?B?SGFMZ2N2RTBUSXZWOWt4NzE4bXNhWEN0RGNESmV6Rzh0Q2FkZkE3VGt0amg2?=
 =?utf-8?B?clFUNERhRDZXTGpFN1E3dDFTVmxxRWp4ZndlUkphbnQ1b1VWSHBCaHFBeHdQ?=
 =?utf-8?B?d1pvV3g5OTRSM1lZcFZwS3VYYkduazhRQUVKWHFsQ21iTlNEcm5GK0lSS0U2?=
 =?utf-8?B?MTRHUE9CUzJPVHRKYjgrVTJqWkk4UnlOaDZXMXdqOGlPWTJiQkNpMlJvNkdu?=
 =?utf-8?B?VXFRK3hHTE40SzIvbDNYQ3d6eXdOeWcvWk1vV0txVEZlRVBvQlE5M2FGV09W?=
 =?utf-8?B?UU81bnd5MjRaUHR1MitDRTFUbnZWTHNzb2VmT1lQb212K1ZlZzJzVTFnYmhr?=
 =?utf-8?B?Z2s0VWxib2FRWTBLY0E3aHdoRHg3d2NHeWwxQ3VEOTBqcCtpaUh2dVRFMmNP?=
 =?utf-8?B?VG9YcUxlK2Y5dTQxY0Niclh1b0FCSHdxeUQ2SVU5bkhtOEN0UEJwMzI2MTh1?=
 =?utf-8?B?ZW1xK01GZmx0VC9kdVRpZVUveEY0WTE3L3ZuVy94UW1pS0U1TVozSEtwUjJq?=
 =?utf-8?B?L2QwdzV0Wm5ITVV3cWh1dFBIOWNmaEsxdjRIZDNmclF6bE5BTjFrZG9kdW8w?=
 =?utf-8?B?WXF0WGcvM1djOEhqRlg5VmtSU1NPa0VBNkh0S2xRK004VTZ3QkhMTXFmVzRB?=
 =?utf-8?B?cE5EWUpoVTVsVEhrLzEvVG4yaWo0ZnNaTW43endRZTlHTXFxekJmalpUWGIy?=
 =?utf-8?B?N1dlbHNKcjJSRGFsL3VSYTFmVXVQeUpORytZaUdsNDdNb2lkQnR0VVROUnh4?=
 =?utf-8?B?K1NVUkF0eDBqTkxNbTBIeG1iTVZnSVdOUUxBSWVjNnczdllhc2VPQS9QY0ta?=
 =?utf-8?B?b1ArQVZPWVlHN1M1MktvRnR3UUNqNGlhQ0N0dGNUakVBdXRZTDJKbkRTTmNJ?=
 =?utf-8?B?TzdGZ0FraThYYnY1RW9lb2piUmQwVDRBQTBMZ055cWh1dlY4ZS9BbHJuMDRR?=
 =?utf-8?B?NWNmV2l0NTlmdG9nL2FZek9xUDhVWGYwbzBqbTlqTklrcVZLaXlUTVBYNk9G?=
 =?utf-8?B?aVpza0xRWDVBcTFoaURTVXVFM2tQREQ1UWU4R1IyNmptOTQ5eW1TOVVGV29R?=
 =?utf-8?B?dUVwbXMxcUx3dWh2VVBwb2pKT3hBaVh0TDJZY0JwTFFaMWs5ZnpjdWsrNEY3?=
 =?utf-8?B?MWFXNG9sb3FqbUJsM2ZORjZ2emdVdGxnaVZMa0Z2UHN2cURCNzNMTTFVYWZZ?=
 =?utf-8?B?RTFzTVJBVnJDZXFsQ3ZkdDl0M0xodjlpOHNIWTNjTERlU3NHbDdWNUVsbUI5?=
 =?utf-8?B?bVM1Q2lYYnY2NGkycFFNcHhRMHlqaTFUdG5LOWJSWlNHUERoMnZ5R3B4cHFF?=
 =?utf-8?B?SWE0WllCcFlGUEk3ME5sWlJKcHhsd2tvcnJEWWQ0bFB3bVFVbCsrK0pyb0g4?=
 =?utf-8?B?SHU5WDdSQVBUa0RQcHJOTlRLRGE1SHQySmJqWUV6SmdaeFF2Yy9LcWZEU05G?=
 =?utf-8?B?UHpLVnJJbDlJeVAxNjJLNEJRRUtxa08yNUpvVTZxbFQxdk1XNlZpZmZSZTJX?=
 =?utf-8?B?UnNMZEhhdWRoSll5ZmlrYWp1eGllUWhTazd2TnFNS2RKNmtWYmM3TUs3R0lS?=
 =?utf-8?B?UVRDL0JwZHFZS2xuSkRPYWFJcXQ2L0pBMmZOZGltWTBoYWcxeWdBcktUamg5?=
 =?utf-8?B?ZW91bmxaaFBBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZXpyNHAvK1lEcEZyK0JkWGNBbVlnOWdRUWFwemhNTHpTREtKdmpjUTJueVNq?=
 =?utf-8?B?WlQrb1hEeitINFMxbGJkSHM4cHBxWHdLbTloTVZOdm5UUkd6OVhvYXRuMTls?=
 =?utf-8?B?YmxNL095WmI0THhMUlYvTnY3dnRnOFVWRjRsUFFyTEFrR3gxdGxQeW4ya3Z6?=
 =?utf-8?B?dDJhd2JJTlQrc0xTVVZ3VVpXN0lFNVMzRDZoN2hld2dtRlBSM1duRXd4Rkpw?=
 =?utf-8?B?OFlGOG1GMVJCdnFSek1FcUx5QmxXY0tBUmxoeXEzM1NTdVRGOExTMyttOXYx?=
 =?utf-8?B?S3pqaUFSdXVxa0VZZjhpV3pUTXFkandRcjhmc0VIYmtTM2pxQi9ZRGJUeHhL?=
 =?utf-8?B?UjNXdEUwa1N5U3U2aHFZdm9waFhCa0t0amNBUjZReXpZZTN3VTVBd051UWVr?=
 =?utf-8?B?K3ZSSWJlbUpGL0o0Z1YwK0k5YlZnOVJwelNwd3BwSG54ZERiQ0xlL2tYTCtQ?=
 =?utf-8?B?cUozUVAwWWNvL2l0N2Q2YnJlWXRoQlFHb2l4NkdIbXZHT1ptWTZxOTN1RmJh?=
 =?utf-8?B?ZUx5R3dVcUs3VDVHM0dHelhhUC9lRnVFT1pDV0R6dzk0Q3ZzY0pUWlhFS2ND?=
 =?utf-8?B?WVJEa1F6VlBKSXI1UFlZeE1naGltOXBzYXRwSFFuSWtwUkNoZS9tK2VJTXJu?=
 =?utf-8?B?YUVzRzNqbnRQdlNva1cvY3pzQnZTMW9waWhaVDFMa0FGTWFud2ZXMElIRFc2?=
 =?utf-8?B?WUxRMCtVQzhJSmZkREtXUjdlTmM1SFBQd1N4b1RKa1dBNzhMVVlsTmowUDVM?=
 =?utf-8?B?OTJCZnJVd0hUWndDL094azhEMTdrYnd1RzlGcW8xNjY4WGdpV2hFRlZhdU0y?=
 =?utf-8?B?TFRtVG5NVkpiZ05DRWJmc1BleEpXQncrMWFyNHFocWpqQlBqWkp0d0pscU14?=
 =?utf-8?B?YlZ2M1F5ckovWGxIMlRndHRoTTlOaTZmbFZvRDZQam90Y05ERTRJY0dQdHg1?=
 =?utf-8?B?TUgyVE1URmZQb0hPSnJMaVR3WUIzcnNzbHJES2VBaWlScStrNlFURmhYaHps?=
 =?utf-8?B?UGhJL1U3YkM5T1VLeDY5aGVnQzRkZEdRRE5IQXA4UWRaQ3dsUFFSZVM0TlVp?=
 =?utf-8?B?blY0WXVMcXl0SVdQbG9XZGdzVThYaUdLQVdkeFJBQThGV2FKbGFBSjF5REZI?=
 =?utf-8?B?L0lIN1JkTEc2YzdzRHhwb3pIc2pFY2NHZmtCait5TXdleXJ6SXlmaUgycUpr?=
 =?utf-8?B?c1dvaFh1YnZZR1p1SVcva0prTXh4ZmJ2YlVMRTNWZGd1YTNrNnhrVFBLM0NS?=
 =?utf-8?B?QlZyazNIaDNuSFo0NFBKZGV2czZjTGRZOENPS1IzZEU5WDd3U20rVVhoczF3?=
 =?utf-8?B?ZVpxZWQ1M2djOFJOZlN4Yy9laVZ5ZnFHMGl3L0FkWTNVdDRRVXQxcUpJWjBW?=
 =?utf-8?B?azU1NVpZaTc3M1c1MzBxU2I5NlNWY3lFdEgzeDFTWTNOSGtXQndCNUJrNktO?=
 =?utf-8?B?alljTmxlbFIwc0ZPSkR3dzh6bDRWbGhtUS9NVXZQYVRiMlNoNkxyRUNuYlI2?=
 =?utf-8?B?Y1NJb3pJZkxXUXZQbTZCdXlieURSazAxb2JTeXROL0dHVDhFT09sdDNkcGQ3?=
 =?utf-8?B?N2lVRzZOZERPN24xR0cxdllQbEcrREdsTlQ5ZGVBVDVCUWRlV2FOUHVXYVFV?=
 =?utf-8?B?ZGlWUVBOQW5RRXNjQmJSb0oweTZ2cVR1YjBwQjl0WGYrbUthOE83UGtjUVdX?=
 =?utf-8?B?Rjk3Yy9pbEdYcTRweC9hVUFvckZPT3VlVG5aMldCV2hrYzhxYU5FSnJZT0ZE?=
 =?utf-8?B?alUrc24wM2dtYy9yRnFNTDlEVzZDclFpRkgyalo0NDVldDRwK29Bd29YVDRt?=
 =?utf-8?B?SmQ5ZUxiMkpHV2VEVnFhK1h6QWxBc0pVa1dXME54bWFneWJ1a3drZ0d0RE5T?=
 =?utf-8?B?VVZrVkRPcWNRNEdxOExndXFmVFlWWlBYZ1cvYy9VNE52aEkvVFpRVGp4UGor?=
 =?utf-8?B?V3BRdDFvc2RGYXllOWw3RFcxSGoyakYwanVZcXM3ZVduZTRnZW9MdjdTNUow?=
 =?utf-8?B?UXVDSUx3Qk5wRkFJV0lrUzRIZDArZkc3Tzh0RmxVUEhUZHRiSlA5aks4UFl2?=
 =?utf-8?B?VDVqZzdGQUNqVnBpNEpZS09UeFdNOWFxSEtyOC9lNjBMNWRnelhuVDAyc0Jx?=
 =?utf-8?B?MzFKVFI4bElzMkpmRjRzTWJ6WFZMYnZPaGphVXQ3TjhhaUpwVmRTRDYrMWVY?=
 =?utf-8?Q?VQxvtMeMozv2T97iRFPePrHnbsooaNHS6qbRuC7SH5fn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50F9434F29E9FB4481037B1B0F1D8D08@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a898946-5219-4bde-8b0f-08dd8e43dc12
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 15:20:26.2039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N36T4wdqZmS+qWAZXtTw+xsk7V2llE5Pn0rrzV64RlfEXjlU9iiUmAqM3NOA4CbyE0XUtMNi64UoPWjP81TZ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8816

T24gNS8xLzI1IDA3OjIyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gVXNlIHRoZSBidmVj
X2ttYXBfbG9jYWwgaGVscGVyIHJhdGhlciB0aGFuIGRpZ2dpbmcgaW50byB0aGUgYnZlYw0KPiBp
bnRlcm5hbHMuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnPGhjaEBsc3Qu
ZGU+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlh
LmNvbT4NCg0KLWNrDQoNCg0K

