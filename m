Return-Path: <kvm+bounces-28903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB1F99F0E2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71E711F24D05
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CDA1B3935;
	Tue, 15 Oct 2024 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OmvpPrwy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4371B2193
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005579; cv=fail; b=rBGH9TPGUSmdke2O7q0NmgXhURAgjLplfwBHSdw8sbhg2i+Gd+ChsDQsdhpHIxW3EWVujKOdxq6MGK+hl52NeywofeQ6dFtSH7bpfeyrZ7wt5t5bhy56OfvSnLb49Q7Cv7WmKr2HUhyYDkjRpF5MJCBx4shWc8+nkWHKKY9eYpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005579; c=relaxed/simple;
	bh=xnanYnDidcm+MWxXCUYzD1HOu1Qei9hBKpfmWFckiVk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a6QBZLHJdyoz7o5Ro0oZX17OfdJ051j/C+ipeNC+l2oe3o6ARtLd23ttOCNisryQ+RswD15qxcp5TnJC3qRhVi1SQgGph3PHQhX4WQmiCDoeXpmfdwFTLvMGIDrtv/yvYMjbUsyFMk803TWtBx8EYwFiXdHEr+xh/IOf6/Z2tCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OmvpPrwy; arc=fail smtp.client-ip=40.107.236.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GUEJ5r9GmXXrbTdZ+Jm/V0cI/LH87iVx9nQ5LbzXGvYutScu+PE3WLMTnCMWiogs1XWgHMtsvolhTJzOdrfuwzXs28DT56n8eBfCxknJLc/bv8bRMRcMtaV39jnMexWFHa01WtyBuX9NcfSUuksO5KXJg1QMN7pmQHwAH2wBjmRmGZEt8/9mFt+GHJfAIVsDnSFRRGzEGcAMdQK3scRhfXYPJ41sP/zz+AsUvCQOrPi3F1LfmBRQbuyd0Pg1fMXyW/ccnms+N6JIwb05CaypUxl57AfRHEi39roAUwTrsfGuhBemnRr8maf+IAMMCJZn8Wt5H8t+zuAwgOH3HkXx2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnanYnDidcm+MWxXCUYzD1HOu1Qei9hBKpfmWFckiVk=;
 b=UKZBpwdp4o67MTkqUcLkwzn2thSxfcnCAwOuBBTy7ziwdc1BMZyQ5xE8Z5LhGajAYEKe9IaINCXtGI2ILVKZWxrnpTFdxrWvQwPwIgRugYCEOrjdd4Td9g1talHXZdCgjPGPx7f68g/rsuFI+E8KHmy//5TDazRjiPcz9W1oT1uwqmkl8HLVYy8TOCX0l61PFBQOaxB4ikPG6PxpNFR1Lazl9DfvDpGXLmbhhBwoZDr75w61qW2+Ol254EpB8WdUN3FXHYLAFLev+p32GmXKXwn2kKjoIUknwYn76M+bR9d6s7YZ+eW6XExbMhF/BwLy35s4+g6Hssj0QgisALn+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnanYnDidcm+MWxXCUYzD1HOu1Qei9hBKpfmWFckiVk=;
 b=OmvpPrwyTjPnqH0LfAJ0OH/Ve2PfJGCRGFZ6fEuN4WNAmpDMX7bg9yEv4LbsRFOTuc9pJdGTzGinuEE/ZmjBWHQhvrhg5JFpP3bxEJFM2ZB2IfxCD9CL53CyFHyjjZGnCxK7L2Aljr1xyrnkFmpCco9LBrDgnjpLzUd1AuYg+oQD0UvwIm1gS0VS36xHTXUmzrU4bxLNSMiJuLhWmMuSHprQFiDWAnKVReRC6eAyUtvL66nN5DeuaBEjl3AXraii5EEL15FcHtr25AiWyRRDbFNsGP2Lsf/faRl8J1Lb7xW8cDKcR25H1Zn5eceLY+c8h6Qtd++HRMZMl6yYmBJW/Q==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by SJ0PR12MB6806.namprd12.prod.outlook.com (2603:10b6:a03:478::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 15:19:33 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Tue, 15 Oct 2024
 15:19:33 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "airlied@gmail.com"
	<airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>, Andy Currid
	<ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>, Surath Mitra
	<smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Thread-Topic: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Thread-Index: AQHbDO4HAXykAyawME28ijfgNcpxfbJqs0AAgBp1kQCAAraygIAAMegA
Date: Tue, 15 Oct 2024 15:19:33 +0000
Message-ID: <4ab53705-c7bc-40a3-8907-1204597fb451@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-5-zhiw@nvidia.com> <20240926225100.GT9417@nvidia.com>
 <e76bf5fe-4ac7-44e3-a032-35f04249355f@nvidia.com>
 <20241015122057.GH3394334@nvidia.com>
In-Reply-To: <20241015122057.GH3394334@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|SJ0PR12MB6806:EE_
x-ms-office365-filtering-correlation-id: 45edaf86-9d54-4799-7b07-08dced2cc5cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WGdqMmx0d1Y4QkhTbi9XT05mV2o2RkpNVGtqUy9HMnJMMGphWFhRK2xBSXNZ?=
 =?utf-8?B?UDFoYnh4S3RqUXFodGZPNGUyMXJ4amNMR3pudmxJSkprMHBFeElyYVVWOWg2?=
 =?utf-8?B?eGZLREFRTnZnUzF6NG9yUHg2d2lpQkJrZEZBSWhBY1IyUjNPbVJkMnpIbkp6?=
 =?utf-8?B?S0doaDhUbzc3K3h1WGQvL1RrU1VIbVhjanVKRDNEdjRHOGw0dmxqWHA2eXZG?=
 =?utf-8?B?TTB5ejJHS0lvVC8rTktSKzhxTTZkcW9oY2JDNDVaSmpyU0czbGZoWGVmenlZ?=
 =?utf-8?B?UjBiQ2dwNUtVVDVwZy8wRFI2Q2FHODBoOC9LVzRDVVRIMEFEbkRHRHREVUw2?=
 =?utf-8?B?ODRST2dVVnA4bk9DaW1pS2tNZ0dPNWkwSnI4RUpZaEtEb2lGenM0Vm9EYVRy?=
 =?utf-8?B?VjM5OHBzVzQ4amRyWXgrd1FXRWNDdjhMZG1OaDM4c1JJdUdPZE40Rks1MHlo?=
 =?utf-8?B?VUpLaER2b25hRVhoOTg5aWptODlDeUtLVldHN3gwbXBGb2ZjMFFQWXJpTWFU?=
 =?utf-8?B?OVpsTXp1TlhXeGYxQ09sS0N0cmY0MElKQkw2b2FXT0c1ZzZWVUFWKzJ6R09T?=
 =?utf-8?B?clozVmpPdWJoa0VVVG1pYjY2dnplamtldFdsQlEyYWJqWUJ1ZU9QSFBRY1JY?=
 =?utf-8?B?TzR0QmpFMU9JVUVjZFdlS0pkV1kzK0MyS0VGZDBKLzQ2aGFRcTlBdFJsZnRT?=
 =?utf-8?B?WkhmZUpubWEwa1pMRzgyV1FjVXVoTDYzL29FbXlycjB1TEJlZzJBTnlHUzVl?=
 =?utf-8?B?Tjlxby9qcjIrUHRyWWRPUDliNEw5YzZvVGI4VVBPSVNpTFFxeEdjenBlUU1w?=
 =?utf-8?B?VytBYzNSQUNvd29tdWs5RUNsb0M4eTM4Q3JwNm9FVWhxaERpNlVsc0VuNmo2?=
 =?utf-8?B?V1RzR2hXZUVlbExnNmFPWDZ0MkZCRDNLMmp2QXJ2ZVNnS1hIckN2bldSRVMw?=
 =?utf-8?B?Wm4yaFc4MUw3NDV6WWdqejMvc05JYzRoUDFMS1B5ZklIUk9jSURsUmJveCtF?=
 =?utf-8?B?WEVRVFRWaDJuWDlWL2tiaW01VGFLYnFPUG5oOWhCUW9ZK2t2dkRlQW0xR3NX?=
 =?utf-8?B?dEZHTzkzblBJNnBSNGZEeno2REdoTzBRcVVkOFlKMG1OM3Q1M3Y2dEV2Qk9G?=
 =?utf-8?B?TzVaU2RlbTVLcDJ5bUQra3hwNjRXUG5uOFpHdVF2NGdoVFN1dWlKUDBLTHlS?=
 =?utf-8?B?V0UySURvMGxnZkhiOGEybjQ4Si9EcXk5U282Z0FtSlpnd2YwYU01OFN5LzB3?=
 =?utf-8?B?TVhVbmlzNU56T1Bzb05hZWNSOUdUYjhNTm1BYWhab2dGbFFpb3lUdTRVelAy?=
 =?utf-8?B?NmlPMHRpRXVWNnNtL1YvUlYwTWNDUE1pUmRvYTBqM3hSTm0wa3hwMzNmdmdD?=
 =?utf-8?B?bmhHdnBiSkRzeUVmMmpsTEhhS3BDZ2lZbDNxVlpkbFZMQ3ZZNGplRVVRS2VM?=
 =?utf-8?B?NjREWE94bUZHeE5CSUpmZVA0alNBcEVuRW1vNnk0QVBQbXZDYkViMjA2OHg1?=
 =?utf-8?B?cmlKMzhzaXRtLzk0ckRMaURTWXV6ZjJMNjJqWlJ3VDJ4OHdxb2dpMVlOU3BG?=
 =?utf-8?B?NStoSGdmblI2MFBBNm11SWgzZ3pmYzlyR2NwWXp1aU53Y1BZVlQ0OWlmSnlv?=
 =?utf-8?B?YUtRYnJzdm84SDhZTDFmTGlSL0JuMFkvR1lIR3pWSnk3cE9VYkhqeDhWTkJ3?=
 =?utf-8?B?cTEyc3RtaXNUSVZSZTlFZ3BNVjZWVGU1b0REZVExWGxEQXdvNUdiUXFuR3di?=
 =?utf-8?B?ZVV0SmUvdUZwS1JQZG9jRzJRSUlaUnY0ZlJlNHFkc3hyWnZHZENaOEJ1MXlR?=
 =?utf-8?B?V1hxbHNoemExcHN0aERtUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aG1nL3IyZEdVVEo0b3J0QWhqQllnV1JaTExHUXdqaVNFQnpPQm9lMzhTbWFI?=
 =?utf-8?B?SmdKc3gxWEFHZTdsaW82MnE4QTRzLzdyUmhkZEZWWEt3ZEkzU29JZGFpTFpi?=
 =?utf-8?B?ZDN4RUxYYVNaZjN2MGtsWTRaVncvS2NtZG5RQlFkK3B4enF2b0YrTkpjOWQx?=
 =?utf-8?B?UVY5T1dDOE5VcEcvbStoQTN1SWR4Y3FtcFBFUkwzUjJYMmpoNzJsQmROcUpv?=
 =?utf-8?B?amtLMWp3ZnIwOW9sb01xdUo5ZmwvTzdyNjFlbUs5Ti8zdmhYbmdjaE9SK0JP?=
 =?utf-8?B?dnpyckVPNCtEc1FtenJ4RTdONEZxYllaRTZ3UUR5Nm82SUVXRVNZZy9pRGNa?=
 =?utf-8?B?NXpVT203Q3orbDFQQzBFRHZDZ1RQeHpIdVZmMkpOSFJNY1B5SXd1dGFBQVBi?=
 =?utf-8?B?S2xTbE9YWGxOMXdzMndRUUdZUjFhVUZvYVd4Z0tEUk44ZnRRUHVoNzZZTzB5?=
 =?utf-8?B?dWVnVHFzVVBvY1ZPS3lEWnZyQXg2M0xlT1ptMHN2ZWpaUlBTd3MvVDlDa3A1?=
 =?utf-8?B?N1NsaUd2WithU09Rc1R3ZEo5bTR0Z2Fueit3My9temRVOGExVmRVZDBYVTJ4?=
 =?utf-8?B?T2pXdGVYbkFteFkzeWpEbGtaaTM3eC9oTytTUnp0OEVTdHlTRXlzVVM2SFda?=
 =?utf-8?B?ejVUZlVwRTBLa2M5Y1dTQW5wUHNrWFVOL3hRUkxRTmJmUUNiN2FqbTZUbkZV?=
 =?utf-8?B?bWxXeXBaWUZvaDQ0MU1nbW9aS1FYUk1xeGxRbUdsVE4rWFdZT21FOERiRXVl?=
 =?utf-8?B?WWhDMDhaVDZhT0NNcG9tVElhaEgyd0tpZjdkdGs2djVISTFrY2svRUo5cFE5?=
 =?utf-8?B?V0xPWlIxVjZvb1RBMTVkNXVmNDlMT3ZSTm5VekVmMk1sYjgzZlBSQWw4ZkxP?=
 =?utf-8?B?Q1BFYm9CbXFHaGNEdkE3a3BUVUVDZWZSQUJVaHduZ2N4M0Rhc01DQWExS0dM?=
 =?utf-8?B?V2ZLZmQzN1ErVERuOHRwTDR2a3REUFlVSEVQcXVTM1FscGNFakJqbWRXZW85?=
 =?utf-8?B?TXU2K085SHVOT0ovY1BXd3YyMTVBdVR6QTFxK2hKTElwQjFjbE5jY1MvTzN5?=
 =?utf-8?B?eFhlSGt0aVJIT2Q3MUdMcStkYWhIUDFUemZBUnI5TndYaDB4VXFqNUV2dlNT?=
 =?utf-8?B?SEVCWTdzT1ZIbzBFZitXYUpEc0J1clJ1ek1uMmF3M09CUmxMOUIrMkZjMDAw?=
 =?utf-8?B?UTlONTRpa0ZqTHJWRFdsUG9GNWJPandMOFlRWElhZTNzNWowVUJ4bDVVOXdZ?=
 =?utf-8?B?ZUlqL215OHYvbFpic2g5UllLekJlZEo0Y1FCWkVKY2E3eXpYNUZGTWRHOFRT?=
 =?utf-8?B?NHpNZFMzSmhoZkQ5WHMydkx4RDV1NXpFZGJydzJVTEk2NXhSM2M0R2RQSS9L?=
 =?utf-8?B?K3h5WG80RFdNU1RCUllvVWZJb3l2YkVxSFJUMmw2K3RGVXZncU1ubDlORDdk?=
 =?utf-8?B?YzFnUVZkK0s5Z1JCakFES2Q1SE90LzdOTVF6L0NFV29ka1RZWVlXbXMxQ2VW?=
 =?utf-8?B?bzZLS0NSSkZTS2J2M0hEZDd1SUpXQWtDY0Zpb0RwVDZ6SjFOY1pINkdLVkp2?=
 =?utf-8?B?NkxZK1pvNDZkdVV0M0xuYms1STM4MUlaSW1EWWVjTjJaZDU1WnNCc1ZRaFl2?=
 =?utf-8?B?TFFJd2ZWME9QWDNPUVRQT0tUZW9XQmhyTk5pNjYwaUJMMjlreDRQSzNDVisy?=
 =?utf-8?B?TG1UeUQ1ZDcvNXM2YnpTbk9JL0hTK25xMlNUM0NSTGwyNjloRU1qblhJdHBP?=
 =?utf-8?B?NFA3cThZNXNFVFU0RU5JV3lURVFoZEYyVGxzQ1ZMK0tSNkNWY1VoV3RvUnZG?=
 =?utf-8?B?MXNjcW0zeVh5U2RxYTUrY1hkUnVTcyttMmhCUlBWQk12WGtPSGhPbkNjNEVN?=
 =?utf-8?B?b3dwLytEMmtGNUtBVlhFdFVlTXNIM3FGSUFZMVVwRlJnbG9wVCtiS09ScFZu?=
 =?utf-8?B?RE5BZk9DYkpZK0M2ZTBrNGE3MUl2KzdCbW91TjJWQ3lWM1JRaXlocVMyMW1N?=
 =?utf-8?B?RXpwa2w0MDBBWW9JQW5xMDFoYWovKzR1VUVwN2RkYXA4ejdGakpZcW1rb1RU?=
 =?utf-8?B?K2tNYmlIV0R0NFJPVUpDRFg2TVQ2MlhhRkU5YXlLQitOakh6OGtPTHpPa3hn?=
 =?utf-8?Q?T0Fc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D806DDF1A895A740A6360B7F146164BD@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 45edaf86-9d54-4799-7b07-08dced2cc5cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 15:19:33.2247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6T2NIE02KcGvUXjWYaonnj3kmfTw4ddu9BbleNxVtaBVfLMqkP2jkZivM+G9wORS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6806

T24gMTUvMTAvMjAyNCAxNS4yMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiBPbiBTdW4sIE9j
dCAxMywgMjAyNCBhdCAwNjo1NDozMlBNICswMDAwLCBaaGkgV2FuZyB3cm90ZToNCj4+IE9uIDI3
LzA5LzIwMjQgMS41MSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPj4+IE9uIFN1biwgU2VwIDIy
LCAyMDI0IGF0IDA1OjQ5OjI2QU0gLTA3MDAsIFpoaSBXYW5nIHdyb3RlOg0KPj4+PiBHU1AgZmly
bXdhcmUgbmVlZHMgdG8ga25vdyB0aGUgbnVtYmVyIG9mIG1heC1zdXBwb3J0ZWQgdkdQVXMgd2hl
bg0KPj4+PiBpbml0aWFsaXphdGlvbi4NCj4+Pj4NCj4+Pj4gVGhlIGZpZWxkIG9mIFZGIHBhcnRp
dGlvbiBjb3VudCBpbiB0aGUgR1NQIFdQUjIgaXMgcmVxdWlyZWQgdG8gYmUgc2V0DQo+Pj4+IGFj
Y29yZGluZyB0byB0aGUgbnVtYmVyIG9mIG1heC1zdXBwb3J0ZWQgdkdQVXMuDQo+Pj4+DQo+Pj4+
IFNldCB0aGUgVkYgcGFydGl0aW9uIGNvdW50IGluIHRoZSBHU1AgV1BSMiB3aGVuIE5WS00gaXMg
bG9hZGluZyB0aGUgR1NQDQo+Pj4+IGZpcm13YXJlIGFuZCBpbml0aWFsaXplcyB0aGUgR1NQIFdQ
UjIsIGlmIHZHUFUgaXMgZW5hYmxlZC4NCj4+Pg0KPj4+IEhvdy93aHkgaXMgdGhpcyBkaWZmZXJl
bnQgZnJvbSB0aGUgU1JJT1YgbnVtX3ZmcyBjb25jZXB0Pw0KPj4+DQo+Pg0KPj4gMSkgVGhlIFZG
IGlzIGNvbnNpZGVyZWQgYXMgYW4gSFcgaW50ZXJmYWNlIG9mIHZHUFUgZXhwb3NlZCB0byB0aGUg
Vk1NL1ZNLg0KPj4NCj4+IDIpIE51bWJlciBvZiBWRiBpcyBub3QgYWx3YXlzIGVxdWFsIHRvIG51
bWJlciBvZiBtYXggdkdQVSBzdXBwb3J0ZWQsDQo+PiB3aGljaCBkZXBlbmRzIG9uIGEpIHRoZSBz
aXplIG9mIG1ldGFkYXRhIG9mIHZpZGVvIG1lbW9yeSBzcGFjZSBhbGxvY2F0ZWQNCj4+IGZvciBG
VyB0byBtYW5hZ2UgdGhlIHZHUFVzLiBiKSBob3cgdXNlciBkaXZpZGUgdGhlIHJlc291cmNlcy4g
RS5nLiBpZiBhDQo+PiBjYXJkIGhhcyA0OEdCIHZpZGVvIG1lbW9yeSwgYW5kIHVzZXIgY3JlYXRl
cyB0d28gdkdQVXMgZWFjaCBoYXMgMjRHQg0KPj4gdmlkZW8gbWVtb3J5LiBPbmx5IHR3byBWRnMg
YXJlIHVzYWJsZSBldmVuIFNSSU9WIG51bV92ZnMgY2FuIGJlIGxhcmdlDQo+PiB0aGFuIHRoYXQu
DQo+IA0KPiBCdXQgdGhhdCBjYW4ndCBiZSBkZXRlcm1pbmUgYXQgZHJpdmVyIGxvYWQgdGltZSwg
dGhlIHByb2ZpbGluZyBvZiB0aGUNCj4gVkZzIG11c3QgaGFwcGVuIGF0IHJ1biB0aW1lIHdoZW4g
dGhlIG9yY2hlc3RhdGlvbiBkZXRlcm1pbnMgd2hhdCBraW5kDQo+IG9mIFZNIGluc3RhbmNlIHR5
cGUgdG8gcnVuLg0KPiANCj4gV2hpY2ggYWdhaW4gZ2V0cyBiYWNrIHRvIHRoZSBxdWVzdGlvbiBv
ZiB3aHkgZG8geW91IG5lZWQgdG8gc3BlY2lmeQ0KPiB0aGUgbnVtYmVyIG9mIFZGcyBhdCBGVyBi
b290IHRpbWU/IFdoeSBpc24ndCBpdCBqdXN0IGZ1bGx5IGR5bmFtaWMgYW5kDQo+IGRyaXZlbiBv
biB0aGUgU1JJT1YgZW5hYmxlPw0KPiANCg0KVGhlIEZXIG5lZWRzIHRvIHByZS1jYWxjdWxhdGUg
dGhlIHJlc2VydmVkIHZpZGVvIG1lbW9yeSBmb3IgaXRzIG93biB1c2UsIA0Kd2hpY2ggaW5jbHVk
ZXMgdGhlIHNpemUgb2YgbWV0YWRhdGEgb2YgbWF4LXN1cHBvcnRlZCB2R1BVcy4gSXQgbmVlZHMg
dG8gDQpiZSBkZWNpZGVkIGF0IHRoZSBGVyBsb2FkaW5nIHRpbWUuIFdlIGNhbiBhbHdheXMgc2V0
IGl0IHRvIHRoZSBtYXggDQpudW1iZXIgYW5kIHRoZSB0cmFkZS1vZmYgaXMgd2UgbG9zZSBzb21l
IHVzYWJsZSB2aWRlbyBtZW1vcnksIGF0IGFyb3VuZCANCig1NDktMjU2KU1CIHNvIGZhci4NCg0K
PiBKYXNvbg0KDQo=

