Return-Path: <kvm+bounces-46282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 878B9AB494D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C23507A32BC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513751A7AF7;
	Tue, 13 May 2025 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pYisuNG1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="R/cGoTvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1E19DF40;
	Tue, 13 May 2025 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102314; cv=fail; b=Va5/ZCnfEOLnHVGBXnzXaZLGFxjpGCjhz3QYawx2mRCK+o1x37U9wgT5R0wm3zB8GflEQtNAy4AZJ3lwVAxFNu9wc9Xg8wOzQAemtewCi/qlI1CB/9ADAa2qDCiylqIoc2WFWw31sj1RICVsGHfJgBvfZcqyD30kpEiwZ8upovc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102314; c=relaxed/simple;
	bh=ikEeG/vM2A9PuagoWoYDZIG2NUG00wzCbdZwqDj11EI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MwNZK2JXN64IXUWLsSOiy4v1koIqs0iRvd90PAXTK35bLJFPPn1ixBNUThFdSN++J+UzphoQIFYKSmDOcsEwDhsS2nCfY6uwPZ0QPdVRpFEpssGHopsU5IN0c4s3wb9ZDxMUJilJ7veyj0rYBxjsH8pHT8mTTgmB/z/QFCk7tSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pYisuNG1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=R/cGoTvJ; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CIAxIq023596;
	Mon, 12 May 2025 19:11:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ikEeG/vM2A9PuagoWoYDZIG2NUG00wzCbdZwqDj11
	EI=; b=pYisuNG1IM+Vh9Ayg11bHBPSmvHqZht4s9spwkSvXvb3aJZFIGF8E4DYu
	146jHyB7Ccb5VNLbDpPBmkLLtGsFBSKqRlA0+ubkZTr4CZAfwU1sktmjynKdkMsC
	EdXpp4LMSprokiQJII81F1XgPFQXNnMZKrdFYXM+ymOH5XbBhgCICaouZj08BgXo
	PXyx1PObKlnFC1TIBZzeG/kWiZ/+CcuU2nrNAX3oZbTz3hdiI2HToNAZ7JvBoTrt
	COQsoxdXl3yWpByqkwr3oLZQXdg+mqn4S6xWREKFFt33ON5vizgsFwyry64xP71/
	qN899vjkxKFsAVGBuRAzMxefkRabQ==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j6b04ksf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:11:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMuW09Glloxvnem+poqZ/iBy0zOmFriWehpBJiooudns21bb4QGDHjYO7IXMLjIti1fCzvo3NBV+iriirkUKsig1mzjH2WFr3b78iWbyk8eV658yKveQy0XCyaa/jmyrTAlatA2DBIHWxQIJ5o8nIVZM20/4HoLExJIVbsKQAFhrHFHIDpee2Hcmylg2V84slPrPpQbojkYjCUYAJDgjeyCH1awBHXawfxP02OsdyrQkuU5lId7uBEWhpGOAEd2LV+fo+snaX3j8jnerMzen2p15iiD1w5XLb5cG46isDueBQxtzV2O18A2FQgMANEUz2QVbvnd/caeM5EqPhjzwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikEeG/vM2A9PuagoWoYDZIG2NUG00wzCbdZwqDj11EI=;
 b=PN20HsnpuZh83g8PRvYdFjt5n12spEFZGGONtryZ/E02CWZofAHrpzrvvH9NIiq3+XS1/D1BVg05nayqGFM+sb2OBulVjz4SJUlb4cwNauDEzLoAAB5tNfa+mhxlOSI3r9zCPJLK7fw1ebZbDRoDcVlWdJRg03SlV30LKCDwZV7r/YiVXl+A2jk4GRol9QxfhoNBzs7/s8lqdUefzeExudIYgR+TDEwpm2hD84oxtAczJZflVLRS7l96wdC+fULl7pxQyjd7A6w67wUESQ2o6Raya5md4Y0qlw+DQgD/ye/uJk1+FGB3Wy1TZ6/X5G47L3GDmP6aQmFYlgYFqCj62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikEeG/vM2A9PuagoWoYDZIG2NUG00wzCbdZwqDj11EI=;
 b=R/cGoTvJ3Ace9c4Nxl9yC5P4EbSl4Vtrc+XC4zrT4w1X5yFfvh+asIH84ZCaI8bmbwanDoo87r8oqmtZoQOjkxLyoYZf5HQqJtrk8liHwfLsYdK8vziHy0+czn4XBzaEMDgMlvqxh35TA3+8DHVppBZBJ8S5lxYgQMkER9GkelIEWaWsUWzHDn50dOoFukfRtpl8lS3IBIeoQ2s/vNDoRTdkk3mWZ5/dSyFuzty61yUpVxjvSpOUCyxByVugSojogagZw7ZDn3RA3l8SNRAac8QLoIt3UvhzgNIT3HdnNJVEMjiWvRIdFNnC2H/a0fCQCvObRymTxkU4konAgYTumg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7151.namprd02.prod.outlook.com
 (2603:10b6:a03:290::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:11:31 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:11:31 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to
 understand MBEC
Thread-Topic: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to
 understand MBEC
Thread-Index: AQHblFP5gtiSh+duMEucqkZZvv2RGLPPweOAgABuFwA=
Date: Tue, 13 May 2025 02:11:31 +0000
Message-ID: <F36DBE47-2F2E-4B34-9A96-89607EBDBA44@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-14-jon@nutanix.com> <aCJN789_iZa6omeu@google.com>
In-Reply-To: <aCJN789_iZa6omeu@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7151:EE_
x-ms-office365-filtering-correlation-id: 563fa99a-0a07-4a1f-859d-08dd91c37a5f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dU5QSkxBQmJ1dE9PWkxHUEpuc0lCcTJna3J0MmQraWVCdjkvK0NtRmg5c3Np?=
 =?utf-8?B?a0FNVnZlanU0SjV3N085K2NjYjMxY0FhZ3NJSFJwK2dVVVN1ajM2RkdCbHhM?=
 =?utf-8?B?MzZkY1UvKy9DbWRqdldXZEpiQm1EV2pjWmZzdlQ2M3ZmZnVGT2pKSVZDeGhJ?=
 =?utf-8?B?NkVlVFVhaXFhNCtkRE04cUExaVhTU3pPV0FhaXl2NkNObHhiZUVJb081OURl?=
 =?utf-8?B?OFA2Z04yckVzdnpvYS8wZDl6aFkyakhmY0lIT05IbW9uU3NSdEM2SnFZbUs2?=
 =?utf-8?B?K2FYWXNjVFZGcEp6UktaU1JHVmNlUXh4SEVMRGp2dkxzUG11MXFTMjdScDA5?=
 =?utf-8?B?S3JmaTNVS2dRT2F3SDJkWVovWjBYTnFoZ0JoVVRWbyt0NVFNTlR1MjltWEVx?=
 =?utf-8?B?bWlheUJ5UzNEeVhlSTFiUWE3WFA4Qmx6NXBxV00vWGZiSnhjRDF4b2U5U3NR?=
 =?utf-8?B?d0R0RFdNdTBnQ1Y1T1gxZHBEbGl4ek9WbjNJczlESEhMU2VtbXJHZlg0cmxS?=
 =?utf-8?B?ZW5KUGwybWJ1OHdtTTQzeDZ5alNwSU14aG5Ea1dhTDRyY0t5Tk5mWEM1N2Yy?=
 =?utf-8?B?VlNOV04rWEtOVURxYWk2MkJEeGs3OWQrNGFyUFd5Sjl6YlZiV2cweU1tSzJP?=
 =?utf-8?B?TmdhdG1OWlpFaXZqRFhkSDlPVzh0d3lSSUUzTWVIemJQTFJET1c0bmJDRVBq?=
 =?utf-8?B?QWJ4WExFbnZhSDlIZU91WklIUkRVUXNyMjNRdDlyZ3RYRVh5eGlHQmFibHFi?=
 =?utf-8?B?SHdiNElZWVZRZUczSUllL3VWRDFOT3Z1MWhIOTBWbytoSGpQcTQ1TnNxelNa?=
 =?utf-8?B?TlJodkwzWitQR0M4b3A4NE1MZ1NkS3hHSW5menlGbkZhZkpsMTlaM0NGekxP?=
 =?utf-8?B?MHlaUEpra2ZLaGpqNVVCZ2dZeldwMTQzRXB1dWlyTy9EaGVEOGVFZjErVG5a?=
 =?utf-8?B?Rkd4eHRJU01lWlNzRitiQ0NZZzNPa2VDRktISzdRRE5TVzFGQ3JJMG51Ym9z?=
 =?utf-8?B?UUhhMnAwWk0wcmdBWUhjbGhqL0hOTk9JbHhXSW5iLzA2MmRVMTIrNU9SQ2Zr?=
 =?utf-8?B?dGpFVm5QZTJjYmtkQ1pzaUxQWkZUZnp0aHlnSzhjVi9OQmhYVnNFenJkbk9w?=
 =?utf-8?B?dm9LakpvVUFuYlE5dS9HSTdzaGtNR0hqdTM1OUlsUUI5cngvakc5aTZma2xK?=
 =?utf-8?B?U3RzTE9zNTZFMnFQTUlEaTBBbEQ0VHdOaFVQcVJTU0hIWEtPRHlPN1F5T3J1?=
 =?utf-8?B?MzhEL3ZlREF4Skd1R29oYVlCREprcjl1TklCOC9Nd21WalpmOWlWaUVUZzJL?=
 =?utf-8?B?WkJyZlA1WSsvTk5lQ2hDZ3BNQUxCRldQSWJ3d3pEUXhwYXhRTnN1Q2puZHcv?=
 =?utf-8?B?TmVaOWx5aDVROEY2NDZONkM1bE91emVSUkJLdTI0ZUNtZFhxcUMxLzJUVjI0?=
 =?utf-8?B?RHBpNHgyVnhZS0srWVR1TjBmWGRqa2dDZmw0ejhzNWl6azhGbEZrWk1JYS9z?=
 =?utf-8?B?WG16ZGdoMGlvT3A5QzlMU2FKTWF5SzRUa3E4VVFpYnd0Y0k3Z0JGNUpZVFVl?=
 =?utf-8?B?UFAvdE93OTF1REhxSUxYS2dZM29QRjU5NmNDQkhpWE52eGIwekdpUnNldmtv?=
 =?utf-8?B?MmtLaDMxYUFqTTRjKzZGZjdQTU9NVnBsTnRscFczZ3M0RjR2TXQxa3VHZFp6?=
 =?utf-8?B?WGpFR3Z3cUpKblA0cHFkQktXN1NpRXMrZCt2SE1FOHkrWnFjWS9WeENHaW00?=
 =?utf-8?B?Q2FEbCtPanBuSVJ0Y2dpQjlSM1NVbzNJb3VteEZJekpYTlZOdjUzcjBTZ3RD?=
 =?utf-8?B?eGZpeXFyZmoyVUJYNWh4cDhtQzJFaGUrSWtreXF1eDRwajFob2pxK1ZrUzQv?=
 =?utf-8?B?VkRTeWUrRVFLVnBTamVSYVFnVFcrdDlJNXJweDZKZEdQWWFtWTNDZTNXWDVH?=
 =?utf-8?B?bGQzdzlGMHY4Wk9KRzd4dzdibkpDS3Q1ZXNwNmszSm1VSzhQaUFUQzFTckpL?=
 =?utf-8?Q?gVYmZ9eEgDSSeHcs+HDicfUwpbJwmQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d1hlR1J1Y1VVQ1BOMjVwM29iZ2RmTzhzQ2dCNC9tbGlMb3BmeU5PZjJ5SnZu?=
 =?utf-8?B?V1ZQMlVMRVBvaXE4c0U0VUFsUUVoRzB6MnhSY2dkUlAyd28wTGQ3Q1FDdXhO?=
 =?utf-8?B?TUJCWjNvTW5aVnFmMG01aE9HL3VEa0FXWTRtSmRkU0FGdnlKb2ZMMUFvTzA0?=
 =?utf-8?B?b0xMM1NXYTdYM2EyVm1xdnA4SWpYSkJ2TVA2d3pjWWJRbXdNbkk0V2VPRXN0?=
 =?utf-8?B?OElMSU83NTVlbGhuWDVUWXdqNXpjaURRTXVEV1lWRHY1S1FRSUpSUTNaVmFt?=
 =?utf-8?B?dWhaZEZnUXVrYlpIQ2pVb2RhT1dSS0FuU25SVDYyL3UyUWZyYmcyeDREeFZ6?=
 =?utf-8?B?eVBvb1EwZjFmV3paOGUrUkc3d3BEMVVEd0JVa0lrd1Zud2UwUm1yTTFyWmQ2?=
 =?utf-8?B?UFNyMnRCRi8rOURKRll1WHFJUHNpcDdMaHlneHoyWFpGQ1dWWEQ0Ly9BYVRV?=
 =?utf-8?B?ZG54YmhwR3k0am52WDZZYm5XOU1WcEk0cE1Od3hyUVRSeDU1eVJxeXRGbnJw?=
 =?utf-8?B?a0IwZmp1UjVLNGxwQUFubnZWNmY2UHU0M2g3dWpPeDlNZHVBQ2xWS1N0V2Jj?=
 =?utf-8?B?QisxR2dtQ0dEODhTUmk4eUhVVEZZUExIU3ZxVHJ2Mkp3bDVSOHJxSzJMZVFZ?=
 =?utf-8?B?RDY4M25TWVNjNkZsQWFSeFhyYnhnekNkNGs0NnByaTVnZFh5ZldJeHprRHRW?=
 =?utf-8?B?U3JIbzRIL3dQY01WSUVaS3lYQjBBTDFoVWdtMW5wZXE4S2F4NjZyUzBpeVNx?=
 =?utf-8?B?TkNXdFBBaDJMaHNucXMyd2Z5b1AxSUtHTzJOVDE2SWEwT1hRR3IvdDVpRCtB?=
 =?utf-8?B?bXFOeGhkaXZzRTQrdGdJeFRRZXAySVAzZEsvV3NCVEFwY29obDlkek93M0JY?=
 =?utf-8?B?MW14MkhaOUFiY3BodDRzTTJucklKY1ZHQ0Z3UW1hZU1RZU1yTTk3ekNVTnZi?=
 =?utf-8?B?aFpCV0ZHUlExQ20xWGV2eTJ2NmErUkdBanFHMHJwOGV2T0VJcm9HcTNBeGpv?=
 =?utf-8?B?aGNDWXlXR0VhdDVUdVlIbCtJb1dZa1pFR0JHNVZLYXB4dkNHcktXYjFmQVlE?=
 =?utf-8?B?Z0FiZUxDZXJPNzU0VERGbUo1Y2JxOERaSTJnUjJGMEIrbVBpU2dFNFdWelNG?=
 =?utf-8?B?bDdEQ0xtTldzMklUOFB2L2V0dVV3ckRScngwWnNWUHFsZkkyS0xwSVMxbFBX?=
 =?utf-8?B?eHhOMzdjaHc0THpjcjNJRWlkZjJCWEExQkpmMTR1azdUUWhpckk4VzF0MWNa?=
 =?utf-8?B?ZDRVamhZZTFSNE1BT095T082UmhxdnNVZDdEakUwandrQmJjR0tNMGlZRmtz?=
 =?utf-8?B?ZDVwZTVxUUoyUTVNNUsybXgxMUhxdkd1VGVQQmR2NThGd0NYcUdGZTF1Umxr?=
 =?utf-8?B?L291MGdBNytIMFdhVGx1YUc3MnZJN0dFaDBEbzZGaDdybk9IRS9mZHBTeml4?=
 =?utf-8?B?bS94Ukt5YmFQZS9lZ1ZMVWdWWVUvZEFRSWxoK01GeVZva3Ywc0NGZUFEblJ0?=
 =?utf-8?B?ZGdONm9adGR6aTZrejZsM3QrQ1p0TGI5c0VqYThaREFJVGY1UUJFZnAwOW13?=
 =?utf-8?B?eGExMU9GWTE1SWFDTnZqTTRoZHoyczdQSWpXSGhGSzdxN1M0NHVQR1cxUmVv?=
 =?utf-8?B?SFo0ZTZ5YUVDMENQRlROYW1acnNjRnB1WHNFVFpkWE1RWTFFUlJPODA5Z2Fi?=
 =?utf-8?B?WGFuc1RCeG8zb2lMK2cyU2szVHR3Tk9jaklaKzIxcDlOem9QTitHL2V6YzNS?=
 =?utf-8?B?NVlSUEMvTjR0OGkyMEt6dTQvY0YyMEQ5SmptUjRBMmFvNzBOU3hXR2JhUmdp?=
 =?utf-8?B?WENkeTU3a3JpajRjM1duL0ZsWEpBTVAvUEdhNTg3QVlDZWR4L3NhK2gvc0JW?=
 =?utf-8?B?dEdTcU83VENHMFNGakhvT3FVV0R5MEt2SURpWDdoNTIyaHZXa0RzcG5Kc0Rv?=
 =?utf-8?B?T1RRdXJjK1Z4UDZCQjdUemYzS2o0MzMzc0dCM1RWRFNodFN2NVp2MnpReTZx?=
 =?utf-8?B?RFE1TXo2cXFycXFXR0QvcFVLQm9WR2dpRnpDbjFlNmQySngzdmR0NHZpcmNp?=
 =?utf-8?B?U0dsMG9TeXFzWHBidDBjb2w1QkxsTXlab2xUQy9SNytvY2VNNndHY1V0b3li?=
 =?utf-8?B?UnU5T2FzbzZkdEVDT3dJdzE3dmluY00rOHptVjdXUTZ4TWloemlJYThnTmw1?=
 =?utf-8?B?VmxKUm9IalB4eFNCQ1hSdGxLajM4ZGdQUnUrUllNaGRPbjRXZE9ZVTZDRnJy?=
 =?utf-8?B?Q1F2N2FQMjh1MURPMUVHQ3RWTnpnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C05E1EFD84FF24196DFC816ED5B79AE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563fa99a-0a07-4a1f-859d-08dd91c37a5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:11:31.3835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CFT52ZHAOqTirHf/2cBYmy+1akDWI2aLrj99sZ5uKiPf4VlwKzR8O9/cCe0+sQb3T7n1q0ubTNWhi2oPTg6fbKZoULnNxRGuE+qPNrAVCrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7151
X-Proofpoint-GUID: -hb0VBt4SKo6HINe3FQ2zaSEwIgYqBqv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxOCBTYWx0ZWRfXyLVQRrOQVaGd HILA053pNKBtszaTfGKWcrfh+/Q3jTG4onK/iBXCs6eY2/2dRc9HHOOn94yOTrz9BU2fVjK9b4K NbH1KUeM5cG+Zx4JyOEeYuUj2yHQb9/B/BFuR5Ud2RUA1mR2Phn1hXgZ5Eq/a7Sd8nXeTjoyO61
 vcLWBnpehF3+3E6sUfNYz1D8WXcIaCh6JMx9xrQc9SPDVOFKtcrHhdxM5XSLSiEIIKC9KtLQoVI S2GQJE5Y8VKFoBqzsKFXfu7NhcWb+ucrWlEdpP5k+Z63xck0hSqbqJCsPdwR6vrlhs5Cy6wFhOs rM1qzeMX8ctJELoNZVZG7qgNIi5PLSKpFze1QbjqEU8U642pgGTot2U+wzOJgmSxzQn8kHhdzcE
 qLp7Z+lX+MFhQ+RvYdIDGImwpjMdMkP5rxp60bgo8YHe9odLpDm5v1uUa6+vQDUY8ONno30T
X-Authority-Analysis: v=2.4 cv=FZs3xI+6 c=1 sm=1 tr=0 ts=6822aa55 cx=c_pps a=SX8rmsjRxG1z7ITso5uGAQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=F0Sn3rKbV6buAPlfiVUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -hb0VBt4SKo6HINe3FQ2zaSEwIgYqBqv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAzOjM34oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gUGxlYXNlIGJlIG1v
cmUgcHJlY2lzZSB3aXRoIHRoZSBzaG9ydGxvZ3MuICAiVW5kZXJzdGFuZCBNQkVDIiBpcyBleHRy
ZW1lbHkgdmFndWUuDQoNCkFjaywgdGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIEnigJlsbCB0dW5l
IGl0IHVwIGFjcm9zcyB0aGUgYm9hcmQNCg0KPiANCj4gT24gVGh1LCBNYXIgMTMsIDIwMjUsIEpv
biBLb2hsZXIgd3JvdGU6DQo+PiBBZGp1c3QgdGhlIFNQVEVfTU1JT19BTExPV0VEX01BU0sgYW5k
IGFzc29jaWF0ZWQgdmFsdWVzIHRvIG1ha2UgdGhlc2UNCj4+IG1hc2tzIGF3YXJlIG9mIFBURSBC
aXQgMTAsIHRvIGJlIHVzZWQgYnkgSW50ZWwgTUJFQy4NCj4gDQo+IFNhbWUgdGhpbmcgaGVyZS4g
ICJhd2FyZSBvZiBQVEUgYml0IDEwIiBkb2Vzbid0IGRlc2NyaWJlIHRoZSBjaGFuZ2UgaW4gYSB3
YXkgdGhhdA0KPiBhbGxvd3MgZm9yIHF1aWNrIHJldmlldyBvZiB0aGUgcGF0Y2guICBFLmcuIA0K
PiANCj4gIEtWTTogeDg2L21tdTogRXhjbHVkZSBFUFQgTUJFQydzIHVzZXItZXhlY3V0YWJsZSBi
aXQgZnJvbSB0aGUgTU1JTyBnZW5lcmF0aW9uDQo+IA0KPiBUaGUgY2hhbmdlbG9ncyBhbHNvIG5l
ZWQgdG8gZXhwbGFpbiAqd2h5Ki4gIElmIHlvdSBhY3R1YWxseSB0cmllZCB0byB3cml0ZSBvdXQN
Cj4ganVzdGlmaWNhdGlvbiBmb3Igd2h5IEtWTSBjYW4ndCB1c2UgYml0IDEwIGZvciB0aGUgTU1J
TyBnZW5lcmF0aW9uLCB0aGVuIHVubGVzcw0KPiB5b3Ugc3RhcnQgbWFraW5nIHN0dWZmIHVwIChv
ciBDaGFvIGFuZCBJIGFyZSBtaXNzaW5nIHNvbWV0aGluZyksIHlvdSdsbCBjb21lIHRvDQo+IHNh
bWUgY29uY2x1c2lvbiB0aGF0IENoYW8gYW5kIEkgY2FtZSB0bzogdGhpcyBwYXRjaCBpcyB1bm5l
Y2Vzc2FyeS4NCg0KSeKAmWxsIHRha2UgYSBzd2luZyBhdCBpdCBhZ2FpbiwgSUlSQyBJIGNvdWxk
buKAmXQgZ2V0IGl0IHdvcmtpbmcgd2l0aG91dCB0aGlzLCBidXQgSeKAmWxsIHBhZ2UNCnRoYXQg
YmFjayBpbiBhbmQgZmlndXJlIGl0IG91dA==

