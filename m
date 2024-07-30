Return-Path: <kvm+bounces-22649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCC2940D00
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3285284AFC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE50F1940AB;
	Tue, 30 Jul 2024 09:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b="Vdq+dGvx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2120.outbound.protection.outlook.com [40.107.243.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C420944E
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330508; cv=fail; b=TIjFFFPFcCG4b/TxJIpTYSud2YxKaB0ICeF0YpBeUZ6D9kBTp+Ltl/DQA7VuC80uko9Eo6UO2EmcKSkOuOdshTItQMs8St09lriGjOt4u8euPpzSPMAWPEPf+xgqCAyeqamN+YMQiw+NL5EMeKO5eAJXOWMeUfmATYu2dRmoGd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330508; c=relaxed/simple;
	bh=tdugE8RM++JwmBG4fbIZGhnDM0LsPXVpVtHfIYYR3kA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RILHSsOFvoirxzFuVgZVW6TCEmOF/fji0E4h/5pWK/SsTltAuDbHFDFAZff9y2DKFioZjzTcEBI2aeXFeDl3WZldxwMcpW2aML7tEINTSUB4CxPqWXHGlDL+URcfe/7rLh1VxNw42zM/FfsuBwz6TrRF3+Ha2rNiSyzzLhltytI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com; spf=pass smtp.mailfrom=petaio.com; dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b=Vdq+dGvx; arc=fail smtp.client-ip=40.107.243.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=petaio.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EhW98vmX2T77ZyR5o8OAcQBwVVUoY66A8eEh3WKtwMt4H1V0Yb5A+t1Yy6jmroflfS5t7lys/DNIUa1rZjcMtTr739MtBQi8EQoNkRbZcieakTaRzsEXC3NfFGhzviz+de9yLmXGSrpslvAYbVe4vq4J4Em9RfGExS90beJCDTKSyLVNNosj3q5futTPotNdDKPp6Y6n1rrieytRt00bQvcctBkN72yYDhSk2pU1u5jCmaY5CT/izuSbtqCAyC63tLGZEw/XVnT9IvpKr8aqZ9D0zpSVOqYqS411Jjz7qYc9F1ulw+hZJ37wqW2v5NL1GaV/8y6aOrT0K9GQsuVFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdugE8RM++JwmBG4fbIZGhnDM0LsPXVpVtHfIYYR3kA=;
 b=cCOyz97Lh9TJIbKXWVRte0GNoVIlUBs29/1bZqwhkbkx33blwsZ57rWhK/c0G1lr4LYW5gBHMvsqOGtyVFApNosZvJwIqR/61HPPqRpzVsHTsDdLMFCcVKcGwL1KJUcB954mm4kvIXOfLkBCWpAirhSoS35BAbHI+E5Z0lU88iRemmNlX09k40S1+NjwUEmcTgje9QFwBjQ4MTScZoxoZ1OIBDm7PQxtv6kCQkfU8kSaSS0X/th4Zg3gFO8RuaxqE1hEfI0WE/WiqHLy6Uy/m8BFyjhxQ2wChyt6j8dPj6XjjvxpHTE1vDYSjHsl8zqB36fc4Y5lrTOvDDtU53mTKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=petaio.com; dmarc=pass action=none header.from=petaio.com;
 dkim=pass header.d=petaio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT2018045.onmicrosoft.com;
 s=selector2-NETORGFT2018045-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdugE8RM++JwmBG4fbIZGhnDM0LsPXVpVtHfIYYR3kA=;
 b=Vdq+dGvxL02IiAgnoj0oxf1FSX9fbYCBr5wXZsyzvD280ZX/oyO0z0Zk6SDanV582RCBL+MkR+XidCCvN3lWD7Y5gkG6pYXmu+Tojah4+X1gwxGnN1ClIKrqyqbdwnOQAcQK9STnq1VwucdewSqWpbgbKSWFIocucqoZvnfCN9A=
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com (2603:10b6:a03:439::9)
 by MN0PR18MB6093.namprd18.prod.outlook.com (2603:10b6:208:4be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Tue, 30 Jul
 2024 09:08:23 +0000
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310]) by SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310%6]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 09:08:22 +0000
From: XueMei Yue <xuemeiyue@petaio.com>
To: Vasant Hegde <vasant.hegde@amd.com>, Yi Liu <yi.l.liu@intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject:
 =?utf-8?B?UkU6IEZXOiBBYm91dCB0aGUgcGF0Y2ggw6JodHRwczovL2xvcmUua2VybmVs?=
 =?utf-8?B?Lm9yZy9saW51eC1pb21tdS8yMDI0MDQxMjA4MjEyMS4zMzM4Mi0xLXlpLmwu?=
 =?utf-8?B?bGl1QGludGVsLmNvbS8gw6IgZm9yIGhlbHA=?=
Thread-Topic:
 =?utf-8?B?Rlc6IEFib3V0IHRoZSBwYXRjaCDDomh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn?=
 =?utf-8?B?L2xpbnV4LWlvbW11LzIwMjQwNDEyMDgyMTIxLjMzMzgyLTEteWkubC5saXVA?=
 =?utf-8?B?aW50ZWwuY29tLyDDoiBmb3IgaGVscA==?=
Thread-Index: AQHa3zzefoHOCJ5aykygf6H/KUyWtLIM8O0g
Date: Tue, 30 Jul 2024 09:08:22 +0000
Message-ID:
 <SJ0PR18MB5186E914411A9BBFCAA50AE7D3B02@SJ0PR18MB5186.namprd18.prod.outlook.com>
References:
 <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
 <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <859fc583-6aca-4311-ad9c-ffbea68c5b17@intel.com>
 <SJ0PR18MB5186B961317770AE36A58A3AD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <034e27df-e67f-410f-93ce-ac7f3d05ded0@intel.com>
 <db1d622e-0f72-410c-ba2d-c21e14dd8269@amd.com>
In-Reply-To: <db1d622e-0f72-410c-ba2d-c21e14dd8269@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=petaio.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR18MB5186:EE_|MN0PR18MB6093:EE_
x-ms-office365-filtering-correlation-id: 776b4afc-d5d9-4ca5-7fcb-08dcb0772964
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|921020|220923002;
x-microsoft-antispam-message-info:
 =?utf-8?B?U2VCdndaNFZCdGdnTzB6ekxsK3pUbTV0V1VPdXFIbTNaeUtqbitZRGJoRFo1?=
 =?utf-8?B?UWhjbng0bjJFSGU5bkdkN0NGMnF2Yk5iZ28xNTQzeE44QjdjM0RyL1k0ZHM1?=
 =?utf-8?B?RXVUejNFb2JJcHp1Wm1lUHdrdmI4ajNabC9TV20zdE5FY1k0VXhRbTNydXRt?=
 =?utf-8?B?b1psako2SnVCeUZ6WHhCd2dHVjVKN2pad0lXUkRYTXZOb0JXdFZ6NEJhdjRB?=
 =?utf-8?B?K0ZBQWYrTVZvcmVKcXIwSENDWmhBT2dlWU9iSEs1cXc2Z3JRWVJkYnhhVVZ0?=
 =?utf-8?B?T0VMOTljbFJRL0tIVGFDT1g2R1N1RW5aSGxUNVhQT0d6ek1tVlJlbnRCWllG?=
 =?utf-8?B?R09QZXhRcmlZK3M3ZTRZWC9ZTHMwQnppbWs5dEU2QVlIN0x5bWR2emc2bnJm?=
 =?utf-8?B?b3h1THVnY3N1aW9Md211TkJOTjJYZ05xdFNiU2d4bndCOEZLQ1g5VUY3Vmor?=
 =?utf-8?B?UVdrdEZyd3MwM2tUMWJYdEJuYXhqMnFLR0dTWVdoSkc5RVhHOEg0cyt4NnNX?=
 =?utf-8?B?TUIyd21waVJobHpWT01uRitwT25iSjVTSGRmVXJaN3dJU3F2WmIzeXVYUnEz?=
 =?utf-8?B?NUIycmNKYzZrUmRsWHI1UjNEVUJzYWg4Uk9ieXJiaWJQVU1MTXFESjVQZW5F?=
 =?utf-8?B?eXZMd0RFUVdiRlZBZnJRd0d1bjZUUnQ4RUZrd25udndjTEltcnJOd1ZEMWpX?=
 =?utf-8?B?VzJrQWxpVDJ6dXZCeVdqdFpVU3FJdHoyNmJwYUR3L1dyN1E1RXRiMEw5VjBx?=
 =?utf-8?B?SG5HM0Y0UmNsUmV4aCt4L3h4MXd3U0lURjJZcTJnQ25mVExMaDA5d0M2eU5M?=
 =?utf-8?B?c29peUNvN0lodUFBbjF1VzlEUVlTb3F1L0JGN1lZeU9mZVpRMUpuVVhrdkp1?=
 =?utf-8?B?RjUxbkZOcW15Z0pjKzdZMi93dUFqb3VUT3B6bTJHMDVoZHlTM0FjU0hhMDE3?=
 =?utf-8?B?RHIvUVNZNXBRR09WbEowVW1aV2RMaWhEVHJYUmRXNytsWHBBT1g3RlF6bmpU?=
 =?utf-8?B?Tml5VVN3dHlpU0piRzNuOHU5TmJTYWpIRWlXWldpakVIbHlYQ3crNWlxWUcv?=
 =?utf-8?B?dUtkLzFjOHpyRXJObXl4elFSR0RrcU12Nk5WMnRCK2t0bXJ3S2czd1hvR2tZ?=
 =?utf-8?B?TnFTcWdCRzdSWm1YRXY4VkpkRTVQUWxja2t6STR4a0RpTXZ0eEJwczBLckVp?=
 =?utf-8?B?QXlVOVNIc04wUXQ5UzBJQ0dzQ0dqcExFNEJwM0I2djFIN2lGcDNWSTE4TUpC?=
 =?utf-8?B?N1FLYWJmUUlhWlNPMnRiZW05N1hvYnEyQSs5N2orc01yNWxhOEVYZnVlU3p3?=
 =?utf-8?B?NkNJRG5VdXVISWFady9WYkhPUnRLM1hRSXFwZENKbVFIQWltdFRrcmJ4Yzhy?=
 =?utf-8?B?T3pjTjlIWTlMcFZwY0l6OWpVTWFVTjlXMndtUWF0SFlNQTRnSkFRcWh4QjBa?=
 =?utf-8?B?dHlSQm1GRmRUNVVSM2pEVnhWOHgzWHE3eEtENWV1eklvUXg2eDBsaEdVNDgw?=
 =?utf-8?B?SlZVOXFsb0xsODNDWmNjbjZHcWpFUTIwbEloZTlmdUNybnozYW1VQ2o2bklh?=
 =?utf-8?B?S01QSExQeXIzdVVxclZzUlhVdW16VlJZNWFkVEtMekxnaVlnZEZJMWtyMVFF?=
 =?utf-8?B?Z2lucW54NWN5VllnUmtNdThzbkRJaDFLbGh3R29PREN3V3RpODBIUjBjelNU?=
 =?utf-8?B?V3prNkZobGcrUHhaSXRiRDdlVi9GZStlaWg3UndtUFJaNFE2WTJOS05lUDdy?=
 =?utf-8?B?bUhxRTVEUFhYUnBhUTNaOGdNSUs1R24zNTBONmpNcWdDcEhGQlNQbm1VUWRD?=
 =?utf-8?B?N1dNczl4KzhHOXVwZU9CMERTTEV3U1dHZTdpWWJRWVNyVjZkSzMyRDNCaXlJ?=
 =?utf-8?B?TU1oVUlLdy9kT2w1cmdML1cxcGRUd3o3YmFxQmpvRlRSN1E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5186.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(921020)(220923002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TG8wWm9ZQWlxR3ZZWlNaZVUrZFlFRVFrdThFZm4zTU4vazNac1BzTGhWbFFJ?=
 =?utf-8?B?OFEwOGxUWWFxby9EWXlwYmVTN01ZNUVWQW1ocnNXbHlUT3NpSndiTlVGa3Vw?=
 =?utf-8?B?T0dTMVk1OVFUSEEvMnpLOE5majhWQnhNdjRrYkZ6Rm9CMTFRODZIaGx3cVRH?=
 =?utf-8?B?RTB6NnNZU29oYXE4akdKd0x2UlJLR1VPZ3lsZS8rYWVtMXhLeHdCNGNwbzZS?=
 =?utf-8?B?ZXRWdGJEdGtjcWowV0tyeG5vSW8ycDF4ZXBuZlFaUVdPSDZMM2VtamRkdEZs?=
 =?utf-8?B?dkhKbTNnS3JaeVNUT1ZUQm1iR3dpWVZ1WGxSSHZ5ZDZNT21GWUhIcUY4ZE9w?=
 =?utf-8?B?WjEzVWYzeDNpZ0M2dXJlTUc2emViUzgrS3hFZmVHYTlXOUdUQkViVFNrVnQ4?=
 =?utf-8?B?NVRQT2tEUVRPWjUzemJsSnhFOElJNHZqcjlxRUJNNVVEYTVxanZmb0dZa2ZU?=
 =?utf-8?B?dWtERzJOWXBWYlpmT2RlV2FER1FSQjJFNnNwYk9GaGsybjhWRDNQb29qVkUx?=
 =?utf-8?B?V0FhOHpmaHNkcTgvNXlNR3Y3TERwTDVnVnVkVUlnYWI2R1AxeUJaRGRIaGRy?=
 =?utf-8?B?TDk0cEloUFdVM2pOOSs0Tld6VW9zNlFXOHJXamU1N3BEcHJjbWdoU2xtdEdV?=
 =?utf-8?B?TUhPN1RZWWVzbk9yOStrRkRZUWdHbGtwWWV2NDV1VlpMVjFmMFJaeXdET1h2?=
 =?utf-8?B?emNyYkNFMUExQmRWbUtoWHovMHJMZUgvTmdZU3JVcFF0RjNEdTlCTTl2NU1K?=
 =?utf-8?B?WW4zVDMxenpLVUNEQmFRbkxIbFU0WGV2WlhyVitNcklZRXlCaUJvQzJOSk9Q?=
 =?utf-8?B?aGIxM1Y3aTFhMXBVNGNXb0V3L2crV0tBTzFsUE14UTIyV2lRaWhoci9EMUlY?=
 =?utf-8?B?TktoOHRzakxLTmc4LzA4SU01YlVRVHUyY3R4RzdOL1o3TzNwUUlyM1laSUx2?=
 =?utf-8?B?a2ZjMUJzWEVHWEF4YXNmMi9Wam5ZUStTMUVkUERrRlZRcExJa1V2Z21Wd3h0?=
 =?utf-8?B?YjNPS2EvZHVoaXI1TkZ6ODRrV28zbGl1clB3bm1maUdqOTU1bytLUkhKcFBn?=
 =?utf-8?B?akZLTkRzYXhvR3p1bTZsMUs3UCtQaEdpWWRmalNpM2o4MTR4ZWVXV1JERENq?=
 =?utf-8?B?dzNXWEYyK0g5SUJiWGsyNnlCZ1p4TC90K1VLdDNzdkVOZU1Pdkp6eDhsSm9v?=
 =?utf-8?B?UGw2bEVKUXdMK3VvMDRLSE82dktmZUVzLzNxUy9aeXJWbWwvbEVIN2FleVhk?=
 =?utf-8?B?aHp5aHZUV2hYRCtrVWxyQmtIWXFXNTc0Z3VVUGZVSXgyVGg3UU8xTFRRU2FZ?=
 =?utf-8?B?dGc4dmtLeWxKaSsxR3Ria0VNVTMreXhZTnhEUjZxc1JmcVZmV0hPeVFSa2lX?=
 =?utf-8?B?SlRndENMelpwS1BpWGQ2OWtNcXFCK3VBSDhPTjJoc0VPWFdObS9CaU96ZjZz?=
 =?utf-8?B?SkhRVzhvYmg3T1VmRVlnVnNZb1l3TjRWL0lVekNTOFprd0d3c056TlZQQWl2?=
 =?utf-8?B?SDJJWWc4MUx0cG52WUduSFJKQlFHcUhCN0NHZUpuL0dOWEdBWGdiMUdnOGZk?=
 =?utf-8?B?U1U3NTg3b2NIV1dvMjNpeHlpWGR6ejN5VDVWaG1wbEdnUjJCOGdiRzYzelZG?=
 =?utf-8?B?VjY5R0VGTEtOb3pyTUZhZHc1RTJERWpVOFk1a2xJSXFCSi9JYVR5ekRVWEl5?=
 =?utf-8?B?dGIyc2Z2czdJOHBNNUxCbW1UeThsRHNZRlBQUExZeW5WMlM0cDBRT0grQkpx?=
 =?utf-8?B?U0ZRanFod1p0RDI1WFhBN0VMUVVoZWljNGtUWHhHTXFyaFVNTlh3TGQ5Ykd0?=
 =?utf-8?B?R20zMUdBM2Y1VktZcE5NT043ZTI5eGN2ekg3aG9WdllreXRKRXQ5NVZWZDB5?=
 =?utf-8?B?eDczbWlheWs0WWx3T1VPclU3Q3V3Wjd6MXRaeVlPSGVEYms4VTZJR3E1YVJ0?=
 =?utf-8?B?R0tCaVFwOHpxUXVCcUtGMHJxcWdaODVpWG50aldNZVpaajdEcnN3QXJFOGVC?=
 =?utf-8?B?aWdhT3RneDZSZEk3eW9zdkFYQnhpVUpvNHpIUVFVMUY2UTIzTzByTGxPci9r?=
 =?utf-8?B?bmlWdzhPUVZhTWpHUE45WTBTYmhaVzNrVmZvZ1dRWU9ncDdTbHFZSmlmNmNK?=
 =?utf-8?Q?h9X4IPFq7lO3HU0+f6rVI591C?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 776b4afc-d5d9-4ca5-7fcb-08dcb0772964
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2024 09:08:22.1768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a0ba8444-51d8-486a-8d00-37e5c68c7634
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QFiu6U9eAl0usmjlqY46qW2fQkfS+kJi7zVbj71dnG+a1rm42TwmmIJVetcmTc1jXZNQ2o2Ltq85l85/GwltZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR18MB6093

SGkgVmFzYW50ICYgWWksDQogDQpUaGFua3MgZm9yIHlvdXIgcmVwbHksIG5vdyBJIGFtIHRyeWlu
ZyB0byB0ZXN0IG15IG5ldyBmZWF0dXJlIG9uIEludGVsIHBsYXRmb3JtLg0KDQpCZXN0IHJlZ2Fy
ZHMNClh1ZW1laQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmFzYW50IEhl
Z2RlIDx2YXNhbnQuaGVnZGVAYW1kLmNvbT4gDQpTZW50OiAyMDI05bm0N+aciDI25pelIDE3OjE5
DQpUbzogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+OyBYdWVNZWkgWXVlIDx4dWVtZWl5dWVA
cGV0YWlvLmNvbT47IGlvbW11QGxpc3RzLmxpbnV4LmRldjsgYWxleC53aWxsaWFtc29uQHJlZGhh
dC5jb207IHJvYmluLm11cnBoeUBhcm0uY29tOyBlcmljLmF1Z2VyQHJlZGhhdC5jb207IG5pY29s
aW5jQG52aWRpYS5jb207IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGNoYW8ucC5wZW5nQGxpbnV4Lmlu
dGVsLmNvbTsgYmFvbHUubHVAbGludXguaW50ZWwuY29tOyBqb3JvQDhieXRlcy5vcmc7IFN1cmF2
ZWUgU3V0aGlrdWxwYW5pdCA8c3VyYXZlZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+DQpTdWJqZWN0
OiBSZTogRlc6IEFib3V0IHRoZSBwYXRjaCDDomh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4
LWlvbW11LzIwMjQwNDEyMDgyMTIxLjMzMzgyLTEteWkubC5saXVAaW50ZWwuY29tLyDDoiBmb3Ig
aGVscA0KDQpDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIFBl
dGFJTy4gRG8gbm90IGNsaWNrIG9uIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGF0IHRoZSBjb250ZW50IGlzIHNhZmUu
DQoNCg0KT24gNy8yNC8yMDI0IDg6MjEgQU0sIFlpIExpdSB3cm90ZToNCj4gT24gMjAyNC83LzIz
IDE0OjUyLCBYdWVNZWkgWXVlIHdyb3RlOg0KPj4gSGkgWWkgTGl1LA0KPj4gVGhhbmtzIGZvciB5
b3VyIHN1Z2dlc3Rpb24hDQo+PiB3ZSBoYXZlIHRlc3RlZCBBVFMgd2l0aG91dCBQQVNJRCBzdWNj
ZXNzZnVsbHkuDQo+PiBOb3cgSSB3YW50IHVzZSBQQVNJRCB0byB2ZXJpZnkgb3RoZXIgZnVuY3Rp
b24ubWF5YmUgbm90IHJlbGF0ZWQgdG8gQVRTLg0KPj4gQ291bGQgeW91IGdpdmUgc29tZSBzdWdn
ZXN0aW9uIGFib3V0IG15IGV4YW1wbGUgImlvbW11ZmQwNzE2LmNwcCIsIA0KPj4gSG93IHRvIG1h
a2UgaXQgcnVuIHN1Y2Nlc3NmdWxseSB2aWEgbGludXggdXNlciBBUEkgPw0KPj4gVGhhbmtzIHZl
cnkgbXVjaCAhDQo+DQo+IHlvdSBuZWVkIHRvIG1ha2UgdGhlIHBhc2lkIGF0dGFjaCBwYXRoIHdv
cmsgZmlyc3QuIEFzIEkgbWVudGlvbmVkLCB0aGUgDQo+IEFNRCBkcml2ZXIgZG9lcyBub3Qgc3Vw
cG9ydCBpdCB5ZXQuDQoNClRoYW5rcyBZaSBmb3IgcmVzcG9uZGluZy4gSSBtaXNzZWQgdGhpcyB0
aHJlYWQuDQoNCllvdSBhcmUgcmlnaHQuIEN1cnJlbnRseSBBTUQgZHJpdmVyIGRvZXNuJ3Qgc3Vw
cG9ydCBhdHRhY2hpbmcgUEFTSUQgb3V0c2lkZSBTVkEgZG9tYWluLg0KDQpSZWdhcmRpbmcgQVRT
LCBBTUQgZHJpdmVyIGVuYWJsZXMgaXQgYnkgZGVmYXVsdCBpZiBib3RoIElPTU1VIGFuZCBkZXZp
Y2UgaGFzIEFUUyBzdXBwb3J0LiBTbyB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gdXNlL3Rlc3QgdGhp
cyBwYXRoLg0KDQpJZiB5b3Ugd2FudCB0byB0ZXN0IFBBU0lEL1BSSSBjb21iaW5hdGlvbnMgdGhl
biB5b3UgY2FuIHVzZSBTVkEgaW50ZXJmYWNlcy4NCg0KUmVnYXJkaW5nIGV4cG9zaW5nIFBBU0lE
IHRvIHVzZXIgc3BhY2UgdmlhIGlvbW11ZmQsIHdlIGhhdmVuJ3QgbG9va2VkIGludG8gaXQgaW4g
ZGV0YWlsLiBJdHMgaW4gb3VyIGxpc3QuIGJ1dCBpdCB3aWxsIHRha2Ugc29tZSB0aW1lLg0KDQot
VmFzYW50DQoNCg==

