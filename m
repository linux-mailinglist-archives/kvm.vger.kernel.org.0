Return-Path: <kvm+bounces-27605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8075F987F3C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 09:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FEFE1F23C07
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 07:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510F517E000;
	Fri, 27 Sep 2024 07:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MjcL5+Ps"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A11D5ADE;
	Fri, 27 Sep 2024 07:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727421514; cv=fail; b=eYfgu4fbCNRUA6Fr1a8C+YuOB2vPDiHlQj+w81Q322AsqSQ2seNEhdIPae0MJGPpUyF82zVTY6jg9c4vaQPR8mq7QvorYau8ohOLxmYOhnIoShiOVGbsUNCvz9ao0iwD/yFmIvCL3m9EeOH735xol2yxQwJY82O9gTeCxaBUPuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727421514; c=relaxed/simple;
	bh=s7Ja/fUujD3WCuJHqykuSBf2o9Umj7A2yS3aa2Fmj4A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JS9ciEv1WCRond6R/9FVIAmgC6E0efN1aiT6dEHbEKO5xYYgYvdzXdrXbpUSG3TzJUo19NCuUyzCXk3sGxhU+qLayh9HqCmUB0MmgKF1T+cQ/GULpbmGwoV67sia0rX0IaqJINQSOBDA8kS/mUad2I6qvEmCEz1qqNvyPPCu/Fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MjcL5+Ps; arc=fail smtp.client-ip=40.107.212.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E9hpQdI2jz4SbKuFBrUx7IcvmfVWF8Ltr+D2aWedhfO6mrpspu3FDQ/10u0gxQOPDJL0ux2wMgbFfxYiBTvg94vuQzYq5XgeYt6P7gOYuNGAGZ57bAZgNDVyLvi0ucvd109Q1b9Qq73uNrJV9wA8u1P2A8Lgy+NFhoabeSGyD+QX67nw+XuN+BICZcM2CEZpDDSDMWJiSKa8cOpimbVyirp54avWdzPs/O+NmgbKSNexJvaI6gxo0AT50c2U6op61kNwOaf9MxF8T4nD7nJzdYlG0K7Tq1jSx3CDDgJkGweSnPNojEOEGkCbTha/FA9Oc/Y05JkFIYBh/hLV2IwHFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7Ja/fUujD3WCuJHqykuSBf2o9Umj7A2yS3aa2Fmj4A=;
 b=JoVkkNconD2rh86xHPp6KOXazszyW+oT3lZeqB5zvpnauVrHDgenCFDDn9n9DxaPaPTdPdNWi+h1yoDyQfa0og3mf3UOnsZw4HV/PTgX5TtULaNFyfnY3xTc3nUBRsdC4UzWQFCMpOE7meCbioPsqN8yxJFDowbX68qa1HqzIxoq0OimUa7lmM2i68OkiHcfk6E/tpScV+D31Dl0+e/MPoiXWawsEGxJAJhi8i9qzwF51OoCOOCezJPd33AcvMSJTJqdD76rEnQVTPxnC1Uk9XXP3yV/0PvxOBlCghaDWrIKj2kAME9ZqDgResct4OLgkLONxXidOxP2BvperLACnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7Ja/fUujD3WCuJHqykuSBf2o9Umj7A2yS3aa2Fmj4A=;
 b=MjcL5+PsQYS+gl4RFMbKzGTdEK3eKGIp4oHgpTe5zQFoDHDHAE2ZAtvMjE4oNoc4tvEtrVNtNur26OgfZz11UAuK+tvejdf+Lckd0XRSMgb5kqIYBdMfT9yFy9vKxKW3pnjd5R0t1qWd/PySHeHWTNnFo4pry/1ww1kx7icYRWVeCQdb/W/JaLZKTzVb9pmfZaT2Y5zfIT9royvA6FlDFhRElRkGuhvOxu5PGLGn5pHkEw+cusMu9Q+4ayMchaUAECdTy4JkVvfZdkRu1fm2ZE5CL796lTnmf6wDkN+baJ4+s6NXn6tzZPVlGsxOfw582ZA4MhUFwMD/ACJD05FQrA==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Fri, 27 Sep
 2024 07:18:28 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.7982.022; Fri, 27 Sep 2024
 07:18:28 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, "Schofield,
 Alison" <alison.schofield@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "alucerop@amd.com"
	<alucerop@amd.com>, Andy Currid <ACurrid@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Topic: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Index: AQHbC61b9ki2ojKvx0ySv/3ut0ogdLJlBfmAgAGapQCAAd8ngIACw8mA
Date: Fri, 27 Sep 2024 07:18:27 +0000
Message-ID: <5ad34682-5fa9-44ee-b36b-b17317256187@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
 <20240925140515.000077f5@Huawei.com>
In-Reply-To: <20240925140515.000077f5@Huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|DS0PR12MB7874:EE_
x-ms-office365-filtering-correlation-id: b460feef-9fca-40b8-4aab-08dcdec49553
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZTFQdTZFY3BXdWh2QjlTUEtHM2IxNEpPWUhHQjZhemIxQmNJQ3lXVEIxU0JP?=
 =?utf-8?B?a2hsWXFhb3JUMGJNcWdZSFZ2QkY3dUJSTGMvbngxTit3eThqVU9FbVdYM0pk?=
 =?utf-8?B?WjJWWUFPdEZaR1NRSzVidFgramNoRTlhT2JqWVJlQm9HWkdacDZwTjZRcC9C?=
 =?utf-8?B?eHo0ay9OaDY4TXpsN2xBbFhWSUhjQWdHcGJxMmljMlRnT3ZsY0pSMUpiYWxx?=
 =?utf-8?B?TllWYlpGbzRrZmRhYVoyR2VERVNYQ01hWWppNDAxN0VER2FJM3ZQUjZNVEFN?=
 =?utf-8?B?SkhucktmeGZKb0RSZm9kcmhxTndSQTZqSzI5bU1rNTZuY0V4WU9lOXFHQmc3?=
 =?utf-8?B?TlpJUTFtaVN5Z3N5ZUxaMUt0Y0lES21XckI3d3JOVjMrLzZ0RGsxaW1pS2I1?=
 =?utf-8?B?MXhDY1NrVkw0aXl6clpkTmovY0pqdk0venViUjNmV3BWMkdJcUZZYVZWbkNa?=
 =?utf-8?B?VWZDb2o5STVyYnZLV2UvbkhJempTNXRxUU5jU2V0MUM4cEt1ZE54cHY3M1RE?=
 =?utf-8?B?T3FXajlNaEFIVi9qK3pqN240Z0Y0aGIyeFFGdmg5U041WGU0RTV4WjdVV3ZX?=
 =?utf-8?B?eDZXdGZkTktxMlNQZVU2ZmRpTmxrMWM5MzQwd0dNRzN5enZVTmJHUi9FQklH?=
 =?utf-8?B?TVpnTy9iVTlyNmZUYWpWTlBKbEVyVGpseXJTaWgvdXVyUjNKMHJZYmZPUW5T?=
 =?utf-8?B?WW5jZ0szVkVTQXFkY1VxVVhFMzdxMzNFZmw2V2JCaXhsdjlObEV4QmpLWStG?=
 =?utf-8?B?VDZlVVhWdU1BMHhkTUhtWEd4dFRteVZrZDJSR29RWG9rcUJGdURpQ0FDcVV6?=
 =?utf-8?B?VW1UbU1rVytGSlczZlBhd1BPK2NMRFM3ZTNkTWNZdU1zZmZhODJoK3pHcm9C?=
 =?utf-8?B?UHVJRnBrKzBmci91OXBEOUxHUXphdndaKzdFaUhiTi9aMVdIRThSWUVuNUpE?=
 =?utf-8?B?c1FGRk1LVi9nY3dqM2Vsc0hTbmEyU0dlWDl2QlNsRkpBd0MwbXhMWnNCY25B?=
 =?utf-8?B?NDdpM2lDNVB3OTRHd3pTcm1hYXk1RklHVHYzbWpscGhBdHUxcnZZQ0dtNGlh?=
 =?utf-8?B?TjJyaEE0OENQZW05ZVBxNkQ5QlRRaXJ6cDBDOHBFaXd0aS9OeTdIdi9hbis0?=
 =?utf-8?B?S0FtWmZIcHdlUk5PZVF3Mnd0NWtHY28rQjZ1cmdyVzRCSHJmb015UDNhMi9C?=
 =?utf-8?B?RmRKaVhPbUdELzRidHlSK0J1enZYTHFtRTQ2NTVUVWlsMVhydEFwOHBRNGdH?=
 =?utf-8?B?dTYvK1dZc29vekZ2NUFYMklEMXhEZE85Vm5sN1ZHNlVVUmRJRE4wQk5RZ2gy?=
 =?utf-8?B?ei9qRnZ5WlRnNlYxVjQwUGhBOTlGNkhkdGZBS2Iva1Jhd21USThEbzFQcHV1?=
 =?utf-8?B?YWZramtpRFZzbmRHbWY4cG5RQWozSHNNN09pTjdJbzA0R2dHNE56WXlxRXBC?=
 =?utf-8?B?R0k0emhUUzVFaVpjTElJWHRpcU5JdTBhYXpmRStmeXBFdEpIWUZ1N21ZdHpM?=
 =?utf-8?B?cEVON0VNd25ncFdOalZVNUJ4UjVnR21TRC94VW1pay81b21nTUZMMWlaZlhD?=
 =?utf-8?B?Qko5Mm1CWjN0OXdVTEVGQTk5ekxBVXVENWl2Z3l2alBiZ1hBaTdZa0ZpY2dQ?=
 =?utf-8?B?MkhGMTZkVUlnc0tIbXVzVkxQV1JBWDc0ZnZOYk1kQ1l5b2pOQ3M2K2hPOUpn?=
 =?utf-8?B?VTlkZkg1Q1NnclpEWXMzd0l5cC82bENoOFZ1Z1kwMlRoY256NTJNRVZEc2JJ?=
 =?utf-8?B?R2t1Z2ljN2xGSGtNT1VSNnVpWituNGlobXhKbFovbkIrNzQwdWZSWnlnclFI?=
 =?utf-8?B?aVUvNmZJV3dYSHFqL3V0VXFMMHYvQStvd01WRmRjVUZxenhaQS9NRy9LbkJL?=
 =?utf-8?B?aEN2VFpoc3I0alViallrSXpxME45cDBRNS8zSkQ2dlFqQ2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bnZPb05VdnovTnlQK2VCbzJFMnhPMytzalhjRUhDSFJzU200YXZsdktNR0pT?=
 =?utf-8?B?Y0crVUoyaUt4UGdrUlllNzM5WmM0WCtEZzV0SXBMUE1ZL3EveG1nQnRtMHdJ?=
 =?utf-8?B?ZENzV2ZGSVZDQjQ5M2t4aWhjTE05SWE0SFhhYklWbFpGMVFmYjRVZk1Iaml1?=
 =?utf-8?B?U2dzdzhYNTBWbStJVWROT3NUUVVVdXkvUmQ0cEpKT2FOZGJrdjhYZEIvQmJ4?=
 =?utf-8?B?ZTdhWE5mRUs5RnI3NjlHTnBPZlpKK0NacTJEZERjZ2FMWDZQS3NiUjZWeThy?=
 =?utf-8?B?dXlHMGk4Vy9STVZBL1lucHZibHFzcGdRcEZjblRFZ3pwb1lwc0NhUXJESm5R?=
 =?utf-8?B?VFRNblhVb2FuTS9BUUFyZHdTZ1Y0N2hwajc0TEFBMy8yUFFSS01uaU1uajVH?=
 =?utf-8?B?N0xUcWtibVNYeVMzZEs0WUhZcUN6ZmdIdldrOGJLejZRUU9HVVJpc1FVSEo2?=
 =?utf-8?B?ODBiMjR1OXBqQ1FTYUl4MWM3VzhPSTI0ZTM2M3VwNkdaUEJnQkJ1WFZ1UEZx?=
 =?utf-8?B?aVdrMU1wZTRsdHJmaEIrdnBSMWxYbHd0NUNJN1ZKOFlTT1BSeWx4YnVpRTdq?=
 =?utf-8?B?V3RUNnZxUzFjWmk5SGRjbVhPTnMwSmI4STJNY2d0VXFnK3ByRWp2UStiK1M3?=
 =?utf-8?B?SVd4Sm1LWmwraFA5ZDQxR2t2QytBYlpGNUNlYUJEMjRuTjNKZ25xODFqU1Yx?=
 =?utf-8?B?RTQyZ3BlV3c1ZHpDVnZnOGxFc01sWEJxQUpTeVdob2FNQ2JMaG96MnhML2xu?=
 =?utf-8?B?djVHV1NzNVRrVEszOWNuVmpndzRhMytjN205bzVobEtGRGNndXZYV1RQUHZi?=
 =?utf-8?B?anZ1YjRsZk84Tm5lNnZleUh6RG1GR1EyNndTREE2Wlo0c3RvYmpYRE1hTmho?=
 =?utf-8?B?S0ljR2toWnBycVhFYXFUOFRjTGZON2lKMWQ0TUltMzNWSjVQMW9CN0lFTzYz?=
 =?utf-8?B?QzFkcW8vVmNoRG01cElQMXF4cHB0RUdDNjI1S25BWEJtTzVlVXZQeVR4ZXRX?=
 =?utf-8?B?VXZnZVU1RkI1VUFoNHNsLy81aldSVU8wUlVObHd6TFg2UjVNKzZqbDk5bDFh?=
 =?utf-8?B?RTRjVlhNWnVQYUJ4djRLNHQ5QjI5UHJ4QzFyU2orcDd5TG53TlVETzlUVDlW?=
 =?utf-8?B?ODhsS0h6V3RBbE1RdXF6eWRaZC90VkozSmxOMlFtMkhBNVB1eUJjcEpzY3pB?=
 =?utf-8?B?UWEvTXltVkpzM0RDOUUvNlJDK0FmLzUvRVBWTGhLVFFyUzFqcUdrR3FGNHVU?=
 =?utf-8?B?bk9QamlsVjY0eDgwbC9KMDZORCtVaGx3WnY2YmNuQXNiQVovRXhQZStOTWox?=
 =?utf-8?B?LzFQb1NXckx5S01WSzU0MXRHZWtDV3hzam1WV1NZN0VwODlQN0NoakNPQUlD?=
 =?utf-8?B?ZGdweUNaQ294YmFoeGk2VVdtK3R5blVYSVFnVDRQR0ZzODQ4VE95SmFhYWJa?=
 =?utf-8?B?RmQ2b1lvRFB1VHFENHJWbFE2SnlWS2t6aUZqKzlLekhvZHVNTGxhK0xUSlJl?=
 =?utf-8?B?NXBnL1JuME5SWUEvMUYvL2pXNTFRQklPcEJVbHFJWlFGc0d3enlhSUhmeVZn?=
 =?utf-8?B?VUFtYjN3RE5HRjRYUXhCdHdEdGkxcWk2SXF0WWZjWTJ1cGwxOXpVbXVlUGtC?=
 =?utf-8?B?Mk5CYWhDendqUWdTSXQwUFZPQzZWc2t1L3RuVU5nR2xXN3lTNmdQUE5KRXFm?=
 =?utf-8?B?Rm56Rm52UzFLL3ErTEFSQlViaklhc2t4R09zVE1aRFNZbnFuQUpUajhtZjZo?=
 =?utf-8?B?bXE0TmJuRmpiSUpwd1ZHazE3NExCZEM2MnFxNEhkNnF4TlVyTWo5YkRFQ1lF?=
 =?utf-8?B?SnlrOTl5T0NFOEJPS2lxQVhZZC9ERUxwK1NYKzJpRm8wVTRGZmtRWDFTYThV?=
 =?utf-8?B?VkkzYXp3YXduTGh0T0x0em4zeGVVUkhpVnMyVnBCK1JSYzNRQ2VXY3AyUUQv?=
 =?utf-8?B?V0Q3V0pBOVM5NThxeThBcy9BM1FLazY2MG1zMGlORVlHU3k4bWZ6V0NOTDUr?=
 =?utf-8?B?VWlSbG44ZlBMRWRlMVJMbEdMVGVFV3Y2aFJTUTNEc2xYZS9vbExWSGdyeWZo?=
 =?utf-8?B?eWttenJKcGh2cDlWM0NDdEJVZklyeUZSVjRqdzdRYThHNWtyaXpQbjJobEl3?=
 =?utf-8?Q?JHCE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFD626AF51EB92428E9F1C66450A147A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b460feef-9fca-40b8-4aab-08dcdec49553
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2024 07:18:27.9839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BLF0G86OMuq5Ap+LkQR4TLjB5YwO2FGDPDa4yZp81xQ/IAv2YQ06rRFyWjzHV7up
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874

T24gMjUvMDkvMjAyNCAxNS4wNSwgSm9uYXRoYW4gQ2FtZXJvbiB3cm90ZToNCj4gRXh0ZXJuYWwg
ZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0K
PiBPbiBUdWUsIDI0IFNlcCAyMDI0IDA4OjMwOjE3ICswMDAwDQo+IFpoaSBXYW5nIDx6aGl3QG52
aWRpYS5jb20+IHdyb3RlOg0KPiANCj4+IE9uIDIzLzA5LzIwMjQgMTEuMDAsIFRpYW4sIEtldmlu
IHdyb3RlOg0KPj4+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9y
IGF0dGFjaG1lbnRzDQo+Pj4NCj4+Pg0KPj4+PiBGcm9tOiBaaGkgV2FuZyA8emhpd0BudmlkaWEu
Y29tPg0KPj4+PiBTZW50OiBTYXR1cmRheSwgU2VwdGVtYmVyIDIxLCAyMDI0IDY6MzUgQU0NCj4+
Pj4NCj4+PiBbLi4uXQ0KPj4+PiAtIENyZWF0ZSBhIENYTCByZWdpb24gYW5kIG1hcCBpdCB0byB0
aGUgVk0uIEEgbWFwcGluZyBiZXR3ZWVuIEhQQSBhbmQgRFBBDQo+Pj4+IChEZXZpY2UgUEEpIG5l
ZWRzIHRvIGJlIGNyZWF0ZWQgdG8gYWNjZXNzIHRoZSBkZXZpY2UgbWVtb3J5IGRpcmVjdGx5LiBI
RE0NCj4+Pj4gZGVjb2RlcnMgaW4gdGhlIENYTCB0b3BvbG9neSBuZWVkIHRvIGJlIGNvbmZpZ3Vy
ZWQgbGV2ZWwgYnkgbGV2ZWwgdG8NCj4+Pj4gbWFuYWdlIHRoZSBtYXBwaW5nLiBBZnRlciB0aGUg
cmVnaW9uIGlzIGNyZWF0ZWQsIGl0IG5lZWRzIHRvIGJlIG1hcHBlZCB0bw0KPj4+PiBHUEEgaW4g
dGhlIHZpcnR1YWwgSERNIGRlY29kZXJzIGNvbmZpZ3VyZWQgYnkgdGhlIFZNLg0KPj4+DQo+Pj4g
QW55IHRpbWUgd2hlbiBhIG5ldyBhZGRyZXNzIHNwYWNlIGlzIGludHJvZHVjZWQgaXQncyB3b3J0
aHkgb2YgbW9yZQ0KPj4+IGNvbnRleHQgdG8gaGVscCBwZW9wbGUgd2hvIGhhdmUgbm8gQ1hMIGJh
Y2tncm91bmQgYmV0dGVyIHVuZGVyc3RhbmQNCj4+PiB0aGUgbWVjaGFuaXNtIGFuZCB0aGluayBh
bnkgcG90ZW50aWFsIGhvbGUuDQo+Pj4NCj4+PiBBdCBhIGdsYW5jZSBsb29rcyB3ZSBhcmUgdGFs
a2luZyBhYm91dCBhIG1hcHBpbmcgdGllcjoNCj4+Pg0KPj4+ICAgICBHUEEtPkhQQS0+RFBBDQo+
Pj4NCj4+PiBUaGUgbG9jYXRpb24vc2l6ZSBvZiBIUEEvRFBBIGZvciBhIGN4bCByZWdpb24gYXJl
IGRlY2lkZWQgYW5kIG1hcHBlZA0KPj4+IGF0IEBvcGVuX2RldmljZSBhbmQgdGhlIEhQQSByYW5n
ZSBpcyBtYXBwZWQgdG8gR1BBIGF0IEBtbWFwLg0KPj4+DQo+Pj4gSW4gYWRkaXRpb24gdGhlIGd1
ZXN0IGFsc28gbWFuYWdlcyBhIHZpcnR1YWwgSERNIGRlY29kZXI6DQo+Pj4NCj4+PiAgICAgR1BB
LT52RFBBDQo+Pj4NCj4+PiBJZGVhbGx5IHRoZSB2RFBBIHJhbmdlIHNlbGVjdGVkIGJ5IGd1ZXN0
IGlzIGEgc3Vic2V0IG9mIHRoZSBwaHlzaWNhbA0KPj4+IGN4bCByZWdpb24gc28gYmFzZWQgb24g
b2Zmc2V0IGFuZCB2SERNIHRoZSBWTU0gbWF5IGZpZ3VyZSBvdXQNCj4+PiB3aGljaCBvZmZzZXQg
aW4gdGhlIGN4bCByZWdpb24gdG8gYmUgbW1hcGVkIGZvciB0aGUgY29ycmVzcG9uZGluZw0KPj4+
IEdQQSAod2hpY2ggaW4gdGhlIGVuZCBtYXBzIHRvIHRoZSBkZXNpcmVkIERQQSkuDQo+Pj4NCj4+
PiBJcyB0aGlzIHVuZGVyc3RhbmRpbmcgY29ycmVjdD8NCj4+Pg0KPj4NCj4+IFllcy4gTWFueSB0
aGFua3MgdG8gc3VtbWFyaXplIHRoaXMuIEl0IGlzIGEgZGVzaWduIGRlY2lzaW9uIGZyb20gYQ0K
Pj4gZGlzY3Vzc2lvbiBpbiB0aGUgQ1hMIGRpc2NvcmQgY2hhbm5lbC4NCj4+DQo+Pj4gYnR3IGlz
IG9uZSBjeGwgZGV2aWNlIG9ubHkgYWxsb3dlZCB0byBjcmVhdGUgb25lIHJlZ2lvbj8gSWYgbXVs
dGlwbGUNCj4+PiByZWdpb25zIGFyZSBwb3NzaWJsZSBob3cgd2lsbCB0aGV5IGJlIGV4cG9zZWQg
dG8gdGhlIGd1ZXN0Pw0KPj4+DQo+Pg0KPj4gSXQgaXMgbm90IGFuIChzaG91bGRuJ3QgYmUpIGVu
Zm9yY2VkIHJlcXVpcmVtZW50IGZyb20gdGhlIFZGSU8gY3hsIGNvcmUuDQo+PiBJdCBpcyByZWFs
bHkgcmVxdWlyZW1lbnQtZHJpdmVuLiBJIGFtIGV4cGVjdGluZyB3aGF0IGtpbmQgb2YgdXNlIGNh
c2VzDQo+PiBpbiByZWFsaXR5IHRoYXQgbmVlZHMgbXVsdGlwbGUgQ1hMIHJlZ2lvbnMgaW4gdGhl
IGhvc3QgYW5kIHRoZW4gcGFzc2luZw0KPj4gbXVsdGlwbGUgcmVnaW9ucyB0byB0aGUgZ3Vlc3Qu
DQo+IA0KPiBNaXggb2YgYmFjayBpbnZhbGlkYXRlIGFuZCBub24gYmFjayBpbnZhbGlkYXRlIHN1
cHBvcnRpbmcgZGV2aWNlIG1lbW9yeQ0KPiBtYXliZT8gIEEgYm91bmNlIHJlZ2lvbiBmb3IgcDJw
IHRyYWZmaWMgd291bGQgdGhlIG9idmlvdXMgcmVhc29uIHRvIGRvDQo+IHRoaXMgd2l0aG91dCBw
YXlpbmcgdGhlIGNvc3Qgb2YgbGFyZ2Ugc25vb3AgZmlsdGVycy4gSWYgYW55b25lIHB1dHMgUE1F
TQ0KPiBvbiB0aGUgZGV2aWNlLCB0aGVuIG1heWJlIG1peCBvZiB0aGF0IGF0IHZvbGF0aWxlLiBJ
biB0aGVvcnkgeW91IG1pZ2h0DQo+IGRvIHNlcGFyYXRlIHJlZ2lvbnMgZm9yIFFvUyByZWFzb25z
IGJ1dCBzZWVtcyB1bmxpa2VseSB0byBtZS4uLg0KPiANCj4gQW55aG93IG5vdCBhbiBpbW1lZGlh
dGVseSBwcm9ibGVtIGFzIEkgZG9uJ3Qga25vdyBvZiBhbnkNCj4gQkkgY2FwYWJsZSBob3N0cyB5
ZXQgYW5kIGRvdWJ0IGFueW9uZSAob3RoZXIgdGhhbiBEYW4pIGNhcmVzIGFib3V0IFBNRU0gOikN
Cj4gDQoNCkdvdCBpdC4NCj4gDQo+Pg0KPj4gUHJlc3VtYWJseSwgdGhlIGhvc3QgY3JlYXRlcyBv
bmUgbGFyZ2UgQ1hMIHJlZ2lvbiB0aGF0IGNvdmVycyB0aGUgZW50aXJlDQo+PiBEUEEsIHdoaWxl
IFFFTVUgY2FuIHZpcnR1YWxseSBwYXJ0aXRpb24gaXQgaW50byBkaWZmZXJlbnQgcmVnaW9ucyBh
bmQNCj4+IG1hcCB0aGVtIHRvIGRpZmZlcmVudCB2aXJ0dWFsIENYTCByZWdpb24gaWYgUUVNVSBw
cmVzZW50cyBtdWx0aXBsZSBIRE0NCj4+IGRlY29kZXJzIHRvIHRoZSBndWVzdC4NCj4gDQo+IEkn
bSBub3Qgc3VyZSB3aHkgaXQgd291bGQgZG8gdGhhdC4gQ2FuJ3QgdGhpbmsgd2h5IHlvdSdkIGJy
ZWFrIHVwDQo+IGEgaG9zdCByZWdpb24gLSBtYXliZSBJJ20gbWlzc2luZyBzb21ldGhpbmcuDQo+
IA0KDQpJdCBpcyBtb3N0bHkgY29uY2VybmluZyBhYm91dCBhIGRldmljZSBjYW4gaGF2ZSBtdWx0
aXBsZSBIRE0gZGVjb2RlcnMuIA0KSW4gdGhlIGN1cnJlbnQgZGVzaWduLCBhIGxhcmdlIHBoeXNp
Y2FsIENYTCAocENYTCkgcmVnaW9uIHdpdGggdGhlIHdob2xlIA0KRFBBIHdpbGwgYmUgcGFzc2Vk
IHRvIHRoZSB1c2Vyc3BhY2UuIFRoaW5raW5nIHRoYXQgdGhlIGd1ZXN0IHdpbGwgc2VlIA0KdGhl
IHZpcnR1YWwgbXVsdGlwbGUgSERNIGRlY29kZXJzLCB3aGljaCB1c3VhbGx5IFNXIGlzIGFza2lu
ZyBmb3IsIHRoZSANCmd1ZXN0IFNXIG1pZ2h0IGNyZWF0ZSBtdWx0aXBsZSB2aXJ0dWFsIENYTCBy
ZWdpb25zLiBJbiB0aGF0IGNhc2UgUUVNVSANCm5lZWRzIHRvIG1hcCB0aGVtIGludG8gZGlmZmVy
ZW50IHJlZ2lvbnMgb2YgdGhlIHBDWEwgcmVnaW9uLg0KDQo+IC4uLg0KPiANCj4+Pj4gSW4gdGhl
IEwyIGd1ZXN0LCBhIGR1bW15IENYTCBkZXZpY2UgZHJpdmVyIGlzIHByb3ZpZGVkIHRvIGF0dGFj
aCB0byB0aGUNCj4+Pj4gdmlydHVhbCBwYXNzLXRocnUgZGV2aWNlLg0KPj4+Pg0KPj4+PiBUaGUg
ZHVtbXkgQ1hMIHR5cGUtMiBkZXZpY2UgZHJpdmVyIGNhbiBzdWNjZXNzZnVsbHkgYmUgbG9hZGVk
IHdpdGggdGhlDQo+Pj4+IGtlcm5lbCBjeGwgY29yZSB0eXBlMiBzdXBwb3J0LCBjcmVhdGUgQ1hM
IHJlZ2lvbiBieSByZXF1ZXN0aW5nIHRoZSBDWEwNCj4+Pj4gY29yZSB0byBhbGxvY2F0ZSBIUEEg
YW5kIERQQSBhbmQgY29uZmlndXJlIHRoZSBIRE0gZGVjb2RlcnMuDQo+Pj4NCj4+PiBJdCdkIGJl
IGdvb2QgdG8gc2VlIGEgcmVhbCBjeGwgZGV2aWNlIHdvcmtpbmcgdG8gYWRkIGNvbmZpZGVuY2Ug
b24NCj4+PiB0aGUgY29yZSBkZXNpZ24uDQo+Pg0KPj4gVG8gbGV2ZXJhZ2UgdGhlIG9wcG9ydHVu
aXR5IG9mIEYyRiBkaXNjdXNzaW9uIGluIExQQywgSSBwcm9wb3NlZCB0aGlzDQo+PiBwYXRjaHNl
dCB0byBzdGFydCB0aGUgZGlzY3Vzc2lvbiBhbmQgbWVhbndoaWxlIG9mZmVyZWQgYW4gZW52aXJv
bm1lbnQNCj4+IGZvciBwZW9wbGUgdG8gdHJ5IGFuZCBoYWNrIGFyb3VuZC4gQWxzbyBwYXRjaGVz
IGlzIGdvb2QgYmFzZSBmb3INCj4+IGRpc2N1c3Npb24uIFdlIHNlZSB3aGF0IHdlIHdpbGwgZ2V0
LiA6KQ0KPj4NCj4+IFRoZXJlIGFyZSBkZXZpY2VzIGFscmVhZHkgdGhlcmUgYW5kIG9uLWdvaW5n
LiBBTUQncyBTRkMgKHBhdGNoZXMgYXJlDQo+PiB1bmRlciByZXZpZXcpIGFuZCBJIHRoaW5rIHRo
ZXkgYXJlIGdvaW5nIHRvIGJlIHRoZSBmaXJzdCB2YXJpYW50IGRyaXZlcg0KPj4gdGhhdCB1c2Ug
dGhlIGNvcmUuIE5WSURJQSdzIGRldmljZSBpcyBhbHNvIGNvbWluZyBhbmQgTlZJRElBJ3MgdmFy
aWFudA0KPj4gZHJpdmVyIGlzIGdvaW5nIHVwc3RyZWFtIGZvciBzdXJlLiBQbHVzIHRoaXMgZW11
bGF0ZWQgZGV2aWNlLCBJIGFzc3VtZQ0KPj4gd2Ugd2lsbCBoYXZlIHRocmVlIGluLXRyZWUgdmFy
aWFudCBkcml2ZXJzIHRhbGtzIHRvIHRoZSBDWEwgY29yZS4NCj4gTmljZS4NCj4+DQo+PiBUaGFu
a3MsDQo+PiBaaGkuDQo+IA0KDQo=

