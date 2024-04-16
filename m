Return-Path: <kvm+bounces-14787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D5D8A6F58
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF8FCB210DF
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF101304B0;
	Tue, 16 Apr 2024 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="p3xzfmyO"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2114.outbound.protection.outlook.com [40.107.135.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22603B78D;
	Tue, 16 Apr 2024 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713280122; cv=fail; b=UbSN6fH0EUC7Yb7DfpLDsVRPSMPvRNeL1vd/+5hjOlGvIYNB2wARpUkos9Fzvry+GFzQ5ww3D8vxC1GjnDzW0eXjWdUCH61/BrTdjgsXGMvBj9Gfj9XoduSf0UIWTUwf61TDdEsumMCNwuHz46EqcON4QwX3OUICyGAz1R6CSyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713280122; c=relaxed/simple;
	bh=ozaxA30o0AtC/uvjpNFsbvUXCbNbiFak6BYnQoNswt4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dq23a1nSLlEog2JOqMIXqPf/JkXl1AFnudZjUVrv+uecKhVXUxNV4afxJ16si5GJdbQx+6docwjc4ggGeDTdbZ2/zz2sChjOEDAjtzPud1D4dKf1dBPkJTP8vutMsz9vSNHDnk5J/jSUXbKMhVmn4Alx0EylWwzbyI8P1LPLoIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=p3xzfmyO; arc=fail smtp.client-ip=40.107.135.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFZyMl3srDlRaZzZv/Tr/Qm0ZjUJrPmDjoyJiymEcBBkCvHlrnW9oeyltgvPHjOY8eE6FH0QCUABKaCGfJC1PD8FrfEHkIg+gYv8UhZ8ycG2A4n7Wq3LUBqtZMS5Sdx4bI7NWkG2CH2+1YZwG4FKUiTF9YrfVv+SvW6QA6jtXTjKKdWQmCf4dI/auEUolfAroAHANUo29AQLzi0qwhRkI0iX+ot2YphDpilFVIE95RfVwUntXfSTj9+opbuf7Oro53ft/fvGTUCXzFTkUVwOjOh0IpfbEYAImEWOsIOfXk9FPtWUxZZWapTMcDkzlQGPzKDPoXfU5a7I1rE0ayKyKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozaxA30o0AtC/uvjpNFsbvUXCbNbiFak6BYnQoNswt4=;
 b=G6HqvAWEyhP6fJapISYQrvmsHTdTqVzUYitOHdw4WTb0L3VmXwds4nbUEr35bxj1hGW4qUpjS47b0k9CbE4SKK61lx95EIGBrK48EvsyUJ7myaM6mjHXe082nznJGJt9d+atlx18sJb55+Hbv6/vXZYH7hscnYsuxoaD0f6VNGixuOsUmiGYmDNLYu72/bbRplzN2eCNFLOgd913TIXCIqqR8tOFQ/1r4AwSdWGtocCvUyX1Y75fylML/oBa0nwZeWJ3aZuxOmKj8ehD4tYtYNqCoMkADkhYpLmnAYqyA8LnuUOaHA0M/POwnWHj7gZqkQKzIYrRtzTMmn+1ghJgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozaxA30o0AtC/uvjpNFsbvUXCbNbiFak6BYnQoNswt4=;
 b=p3xzfmyO3R1Ofc56baBK8nfviHFTVz0qomMVkoF/oJq53QoOHADogU7GfNgXsElbcj6ahfn2SzfKJ0G12HwZfMZc1byEJLjSsNoRI7GQExZogLHb0eaFkuTKrP9zYZ4Cjy4zGWVMTX1G6fXcZ8D6ZQgY9SYMiLRDVuSMG4aecvFtmApg6KjkEbjvXfPPK+BXplCYKF0uHzQsX5YM4rE6WbmSJ5zB9yAdHCy/mMsFHnvmghlxOEScmmN19hTjZc62N/+KMNkJ8sdf+ichWszn2H6kDblOr5IbPUPuPOUzmVG/s4j3tI6hlkYXNDxrrJFydUiNYCy7yc0EdfQ70361Ng==
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c3::11)
 by FR2P281MB3247.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:62::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 15:08:36 +0000
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75]) by FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 15:08:36 +0000
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>, Julian Stecklina
	<julian.stecklina@cyberus-technology.de>
CC: "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Topic: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Index: AQHaj/q7SvbB6thKm0KGE0qK9A01DLFq9pcAgAAJW4A=
Date: Tue, 16 Apr 2024 15:08:36 +0000
Message-ID:
 <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
	 <Zh6MmgOqvFPuWzD9@google.com>
In-Reply-To: <Zh6MmgOqvFPuWzD9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR6P281MB3736:EE_|FR2P281MB3247:EE_
x-ms-office365-filtering-correlation-id: dbf11c85-d5af-483d-b092-08dc5e27171a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?TzhzZEhSWi91c3hrRFNrL2syVEQ2RVlWcTJDU3pqUm80bzhzWWJjYzhVWkEy?=
 =?utf-8?B?OUY4bTdSTlE2eTdUcjVNSUoyQTRDdmtjOW1KbjNkb29veTJZQzBNV2RUK0k1?=
 =?utf-8?B?OE5qSGx4R2dBK3R6Q1VQODNYRlFvUDFwUGUyd2pHSGg4YWE3WGVxbVNMYXF4?=
 =?utf-8?B?RnFFclpzZXBEWHV6U1dMajJXZGxHVkQ2cUFscTB0ZGwvSGhmV0lPTG9aOU1S?=
 =?utf-8?B?ckllLzBMNTJpa0lpSXhaWU9RZHdya0ZmaWNtaHVyNjRzVXpqZWJDckNaUCtB?=
 =?utf-8?B?UXJkRFFtZ0o4V1dOYVRncXNrYSt2NUtsYUZvanVISTdxQVdPT2JmMjQ1b1RM?=
 =?utf-8?B?Z1Y3VGNxallsTWw4N0VIb291QWlpUXN3ZCt5KzRyOEN1Q1pnTHBuT0l0QXBK?=
 =?utf-8?B?TGYxVXM3dDVPbktGbW5WeGR1L0FOUWVXWHQ5aklVbkVqaVk2QWNrMlhtZnlH?=
 =?utf-8?B?YTZxVDJLeVExeE1tc1hhbmUvMGIyeE9QcWFyb09aRmR2dlUxUWw0VWdGczMy?=
 =?utf-8?B?VEY1bGNrSXVYeHY1OERvRExMR2tPN1lZM3JoR2M5MlhmcGUvSFpiNE5iYnJp?=
 =?utf-8?B?aWNNblpaM2VnaWcxZHNpbmVWakFxb3BJc21MelU4aDdUSWdwMTBYOXdTZFNQ?=
 =?utf-8?B?YlB2Q0ppZlVzSG5SNUJCVmFlZXJkYWlwZ1ZhMGtNaDVtaU9PcUY0VGhmdStZ?=
 =?utf-8?B?U21jRmsxS3RpNExBREIyU1NWTGF2YVFlMGg0OXp1RStnYXBncEVyYnRYeDZV?=
 =?utf-8?B?RXFieGtiaUo2S1F1YVIzM2Z4NWNmZHpUVHRKR0NlVkw4NmJGTlVDRmhEN1NS?=
 =?utf-8?B?OGtBVm9PeGE1SDU0d0Z0Sm5nWnY1dFVIL28xdTZjQUxzWlVISlhuWEQ2cnlX?=
 =?utf-8?B?cHVlL1NydU1oWTN0bWp5QlpDcFJldkVyeThrWjRkMVFPYzhvRUs3RnJjVFEx?=
 =?utf-8?B?Qlg0eEdMeWhSMkQxV3RQV21QczRNcHl6aEJuc1l2dU45ODZRZ2RsOUI1NHFI?=
 =?utf-8?B?ME01dXR2QzdQQk0zSGtnRzRUdE40dmM2TFhBUFFDR1JMRXUvL3UvL25oaWxF?=
 =?utf-8?B?UkpsQkZ0cWM4cjM5bCtRb3hYaGpOTlJQcjJWNzZDL0RqSWtWOVZaZ3dhTnE2?=
 =?utf-8?B?Q2o0dFpWaGRnWHFRVno5VFVUcDduMkFCclJXdzIvU25sWHdyRThwNHU4YXdk?=
 =?utf-8?B?QTYrM0VlMDhPOTBSUStuMHROMjZ0Q1BKNWxZeWJsanZXVnRNbVRjeCtsdTlm?=
 =?utf-8?B?aDlyT2U1NS8yaU9FUEdsTGxIN0lFY1M0QkFMWWw2R1o4NElEaThBY3dFbGIy?=
 =?utf-8?B?a0NMbkpMeUtET0tmajdEUDZPWTFxU3U2V0dxY0NFaTZoZzF4LzE3M1BvYnJm?=
 =?utf-8?B?SVF3UVlqY3J2VmJNZ2tMNi82d08yZndTNHVCTUhacTBwdWJjYVUyZ3dsT25x?=
 =?utf-8?B?b1dpTkh5bzI5eDBEMXVTZXBudVBLT0trcUgzZyt1ZDJRb0lRYTFBMFJxVVdj?=
 =?utf-8?B?OCtjaFE3UHpZb1BEcDFsb3NSU21QTFIzSTJ2ZWxudG1heUhGSGJYNnlZWm1P?=
 =?utf-8?B?dHZYNTh4NVFMTG5NUm9lOEoxenRhamUyaEZtYlhkTFJEMlczemhDRVZ0WnFS?=
 =?utf-8?B?T0hOZ1VVeUpyOFEyaFp1bGR4MEw0NUQvaDYvT3BGaEJ0WmwvWmpzVERGdDRS?=
 =?utf-8?B?d3N0a3N4elR5YlFyTncwV29ueXRjclVlWVc5ZkwzSHhnQkcvMDhabTBnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SGJ5VXFJZWpNRXFXV2tHYWllRERIbGFTVXRkNHFkdlhvc0F1bDFVbWk4QjJB?=
 =?utf-8?B?VzI0cGJnTXZ0b3pqZkYzdzRDV2FwUzg1YThyWjg0am5aelJZS1FIcGQyZmFs?=
 =?utf-8?B?OHovTEdob05QZ1NVbmh3dzhIUWoxSGFYTkFPUXZ0TG5mZFJiZ2tDb09Mb2VF?=
 =?utf-8?B?UDRGcUI2Qm1yai9HcXpIOXVLaWNxRVZ6OHpIU1ZSQXkrWEttRHY0OUk0UWVE?=
 =?utf-8?B?azJOMWFFVDVEbjVaU0tGVUdFelp1YTd3RGlGU1M2dC9iU2MzVXFTQnM0STJN?=
 =?utf-8?B?ZzJ5T21aRHVpMWdrNnZDcTNnRkJ6cDAyZGE1YXpRNk1NZ1RHTGVpWjZrOU5K?=
 =?utf-8?B?VHpwSWJlS3ZueEFYOVhnQXZ0RUFmZVFuc2V5akxwbUlIbUIzbFRTNXI4U1ZE?=
 =?utf-8?B?ZHJrM3Q1NklzSkMzRXJqK2ZnaEhXYVk0Y1dNNzBKbXVqaGpYUFhjdVRYc28z?=
 =?utf-8?B?OXBPU2dVR2o4R1hnbERmOHVjQWQzNHI3M0NwK0ozUW5iSTcrVm9tdWo5c1Iy?=
 =?utf-8?B?Z2hmWlJiR0JicWlhZWpERmZ2WVlYMDM5Ym40V0MzV1lLSVZUU1BXd3U4d0R4?=
 =?utf-8?B?QW5GQVd3UTl4STJSNFBtQ201T3lBM0l2NXVnVGtxQjhjWjBqNzlmWThFUmZG?=
 =?utf-8?B?RTQrc3dNamJacFZxbnRFTTZtMzZ6Q1Q5cDlYdDZUOWxjZkYxamFMZVcxTjhM?=
 =?utf-8?B?OWxBM1d1N1R6akg2UDYwcGxFOVdFczdTOVI2aEMrbnVjOUFPMFdnZHlZdkl4?=
 =?utf-8?B?THl1Y0ROTjRpcGNSVE0zNmhYbzZ6dkRvVGNEcVNKRjU1eEJ0R0pNQW5jdWo3?=
 =?utf-8?B?d1kzN2xaMGZXeEkxZStXLzkvOWRUUVg4dlJmV0ljQXlSejF3MWN1a2xTdDlX?=
 =?utf-8?B?SlJoSEo1a055SmcwdTRSeFd0N2tWR3RJNlVsZ245aUpGSGtUSFhFOHI1K1Fw?=
 =?utf-8?B?dWNsMkM1K1VRbE1zaU8vUFl4ZjdReDAzOWJwQ0YxU0NNT1MzODlFY0pIUGx6?=
 =?utf-8?B?RklzYkUzOG9JRFlNM3VrNlFsbGFSc3JYVnpINUROMDFxV05MUjVVU3FONy9S?=
 =?utf-8?B?ZHNZbENXM3g1Rmp2WTJ0SVk1K05GMENzSThKNXZ1YmczaVZPY3hlaHVodWJl?=
 =?utf-8?B?S0xzeU9QekJFaVRUbjNjYnpYQytLZ2VqaVVHNHFlazUya0xzVWRDM2pnbTJ1?=
 =?utf-8?B?R1ZxYkRSY2xuR0pSbituYjVydTFhN0V3VzNaM2l2RG9PYlVYSndQV1dld1Ur?=
 =?utf-8?B?YVhFaG5RaXIya0d5Smcwa0psa2MyU1lRTHhqdmlybm5pOUpZcEV1Z25TSWhP?=
 =?utf-8?B?cnh3eG83Z0cxTlRtZS96SVFZOTg3c1N6aXp6cXg0UVVZOHRQZU5RZDg5V0th?=
 =?utf-8?B?ZGh4TDhaWnBnSDkyK05lUWlQZ0F1UUhEcGFlU3E1b1J0SW5xQmNlM3RRSlNt?=
 =?utf-8?B?ZC94cEdpU3pGYWJNaG5DYlY4WW5PSDd3TVdqbkNEQU1YOWppamdTL1RJNmRO?=
 =?utf-8?B?cU95VVNSenNRUEI1UnEycnRjVEhUWmRzWFFqS0krcXhXMG1RNVBKNG1JV3pE?=
 =?utf-8?B?WE5OY3l1M3VIL0RhOTB0d1VEOTlLSGNkY2tjNG1rZVY1UGs1eW45QmVlQkQ0?=
 =?utf-8?B?ZFlCbFg4NWNrTVlsNUkzYlJ2UkRCT2l4KytSMlgvMkR0V3YyeFRQRENKWUxV?=
 =?utf-8?B?TVZFakwvN2h3bVBiN0FnMzZxeVBYRHlWNGhHbE4wNXhCR1pOTDUxdmlZK3Np?=
 =?utf-8?B?NU1qTnAwTTJCNHlmTWF0YUhGOGwva0xPRUQ5bXdXcnFqdm5MajZyM1VOL0xo?=
 =?utf-8?B?K250QUVTZDg3ak1POFNwYWljZFhaQy9EVmd6eFVTVHZ3YVNQcEhHOVJpS2Rz?=
 =?utf-8?B?M2NpVWJ2SWZKYldFK0YxTnp2MWN3U25iNDVzWWtSNnpZVGVGRW9LVmFXRG5M?=
 =?utf-8?B?eEdTcmFmREpOcU5XSktMUDFnTlhhTXBxcWt0SFBrVjU3WTEvSERWbndQWDdj?=
 =?utf-8?B?NzltNnJ0ODh1Nis4dW16ODhXcmRBY0lBMUhJS253Qmx2eGRpWFd3MjJpSHFS?=
 =?utf-8?B?WmJCZnNwZkRGdVh0K0Z5NDZvVmowZzJhUnc4aWtEOFA1ZVFDbDZSbWROU3V0?=
 =?utf-8?B?MC9pZlI2blQzRmV2M1dPT2NudTd5UEVGR1AyS0cvQmhGdkhxNHpqaHprZElm?=
 =?utf-8?B?djNPTmZhbENqR0NYRjFRL3daemFpVmFEZENNczcyMHBuUEoyZWVVZkR2QXB0?=
 =?utf-8?B?QVdKVXAzL1JKdGhkbmJFVTNrdXFnRGd3Wno5TmN0UDN2Tmd0VmJ2bmpvTU1K?=
 =?utf-8?Q?KVi2NktxxEHL7KlbpC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57C66DC9CAB5164287E239AFC5BA85B6@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf11c85-d5af-483d-b092-08dc5e27171a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 15:08:36.3831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3ek5maAduvbpTTcdzCOJhVQQC9z8lXP4DzL4oWRstv9HOG9gmbuPRKtGBvFQyuQq90ssSSgv+UEy2YI33u2YkLkkEydnyVkQ7b31t7pol5yIvpzBjY7533WC868npuk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB3247

SGkgU2VhbiwNCg0KT24gVHVlLCAyMDI0LTA0LTE2IGF0IDA3OjM1IC0wNzAwLCBTZWFuIENocmlz
dG9waGVyc29uIHdyb3RlOg0KPiBPbiBUdWUsIEFwciAxNiwgMjAyNCwgSnVsaWFuIFN0ZWNrbGlu
YSB3cm90ZToNCj4gPiBGcm9tOiBUaG9tYXMgUHJlc2NoZXIgPHRob21hcy5wcmVzY2hlckBjeWJl
cnVzLXRlY2hub2xvZ3kuZGU+DQo+ID4gDQo+ID4gVGhpcyBpc3N1ZSBvY2N1cnMgd2hlbiB0aGUg
a2VybmVsIGlzIGludGVycnVwdGVkIGJ5IGEgc2lnbmFsIHdoaWxlDQo+ID4gcnVubmluZyBhIEwy
IGd1ZXN0LiBJZiB0aGUgc2lnbmFsIGlzIG1lYW50IHRvIGJlIGRlbGl2ZXJlZCB0byB0aGUNCj4g
PiBMMA0KPiA+IFZNTSwgYW5kIEwwIHVwZGF0ZXMgQ1I0IGZvciBMMSwgaS5lLiB3aGVuIHRoZSBW
TU0gc2V0cw0KPiA+IEtWTV9TWU5DX1g4Nl9TUkVHUyBpbiBrdm1fcnVuLT5rdm1fZGlydHlfcmVn
cywgdGhlIGtlcm5lbCBwcm9ncmFtcw0KPiA+IGFuDQo+ID4gaW5jb3JyZWN0IHJlYWQgc2hhZG93
IHZhbHVlIGZvciBMMidzIENSNC4NCj4gPiANCj4gPiBUaGUgcmVzdWx0IGlzIHRoYXQgdGhlIGd1
ZXN0IGNhbiByZWFkIGEgdmFsdWUgZm9yIENSNCB3aGVyZSBiaXRzDQo+ID4gZnJvbQ0KPiA+IEwx
IGhhdmUgbGVha2VkIGludG8gTDIuDQo+IA0KPiBObywgdGhpcyBpcyBhIHVzZXJzcGFjZSBidWcu
wqAgSWYgTDIgaXMgYWN0aXZlIHdoZW4gdXNlcnNwYWNlIHN0dWZmcw0KPiByZWdpc3RlciBzdGF0
ZSwNCj4gdGhlbiBmcm9tIEtWTSdzIHBlcnNwZWN0aXZlIHRoZSBpbmNvbWluZyB2YWx1ZSBpcyBM
MidzIHZhbHVlLsKgIEUuZy4NCj4gaWYgdXNlcnNwYWNlDQo+ICp3YW50cyogdG8gdXBkYXRlIEwy
IENSNCBmb3Igd2hhdGV2ZXIgcmVhc29uLCB0aGlzIHBhdGNoIHdvdWxkIHJlc3VsdA0KPiBpbiBM
MiBnZXR0aW5nDQo+IGEgc3RhbGUgdmFsdWUsIGkuZS4gdGhlIHZhbHVlIG9mIENSNCBhdCB0aGUg
dGltZSBvZiBWTS1FbnRlci4NCj4gDQo+IEFuZCBldmVuIGlmIHVzZXJzcGFjZSB3YW50cyB0byBj
aGFuZ2UgTDEsIHRoaXMgcGF0Y2ggaXMgd3JvbmcsIGFzIEtWTQ0KPiBpcyB3cml0aW5nDQo+IHZt
Y3MwMi5HVUVTVF9DUjQsIGkuZS4gaXMgY2xvYmJlcmluZyB0aGUgTDIgQ1I0IHRoYXQgd2FzIHBy
b2dyYW1tZWQNCj4gYnkgTDEsICphbmQqDQo+IGlzIGRyb3BwaW5nIHRoZSBDUjQgdmFsdWUgdGhh
dCB1c2Vyc3BhY2Ugd2FudGVkIHRvIHN0dWZmIGZvciBMMS4NCj4gDQo+IFRvIGZpeCB0aGlzLCB5
b3VyIHVzZXJzcGFjZSBuZWVkcyB0byBlaXRoZXIgd2FpdCB1bnRpbCBMMiBpc24ndA0KPiBhY3Rp
dmUsIG9yIGZvcmNlDQo+IHRoZSB2Q1BVIG91dCBvZiBMMiAod2hpY2ggaXNuJ3QgZWFzeSwgYnV0
IGl0J3MgZG9hYmxlIGlmIGFic29sdXRlbHkNCj4gbmVjZXNzYXJ5KS4NCg0KV2hhdCB5b3Ugc2F5
IG1ha2VzIHNlbnNlLiBJcyB0aGVyZSBhbnkgd2F5IGZvcg0KdXNlcnNwYWNlIHRvIGRldGVjdCB3
aGV0aGVyIEwyIGlzIGN1cnJlbnRseSBhY3RpdmUgYWZ0ZXINCnJldHVybmluZyBmcm9tIEtWTV9S
VU4/IEkgY291bGRuJ3QgZmluZCBhbnl0aGluZyBpbiB0aGUgb2ZmaWNpYWwNCmRvY3VtZW50YXRp
b24gaHR0cHM6Ly9kb2NzLmtlcm5lbC5vcmcvdmlydC9rdm0vYXBpLmh0bWwNCg0KQ2FuIHlvdSBw
b2ludCBtZSBpbnRvIHRoZSByaWdodCBkaXJlY3Rpb24/DQoNCj4gDQo+IFB1bGxpbmcgaW4gYSBz
bmlwcGV0IGZyb20gdGhlIGluaXRpYWwgYnVnIHJlcG9ydFsqXSwNCj4gDQo+IMKgOiBUaGUgcmVh
c29uIHdoeSB0aGlzIHRyaWdnZXJzIGluIFZpcnR1YWxCb3ggYW5kIG5vdCBpbiBRZW11IGlzIHRo
YXQNCj4gdGhlcmUgYXJlDQo+IMKgOiBjYXNlcyB3aGVyZSBWaXJ0dWFsQm94IG1hcmtzIENSNCBk
aXJ0eSBldmVuIHRob3VnaCBpdCBoYXNuJ3QNCj4gY2hhbmdlZC4NCj4gDQo+IHNpbXBseSBub3Qg
dHJ5aW5nIHRvIHN0dWZmIHJlZ2lzdGVyIHN0YXRlIGRpcnR5IHdoZW4gTDIgaXMgYWN0aXZlDQo+
IHNvdW5kcyBsaWtlIGl0DQo+IHdvdWxkIHJlc29sdmUgdGhlIGlzc3VlLg0KPiANCj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2FmMmVkZTMyOGVmZWU5ZGMzNzYxMzMzYmQ0NzY0OGVlNmY3
NTI2ODYuY2FtZWxAY3liZXJ1cy10ZWNobm9sb2d5LmRlDQo+IA0KPiA+IFdlIGZvdW5kIHRoaXMg
aXNzdWUgYnkgcnVubmluZyB1WGVuIFsxXSBhcyBMMiBpbiBWaXJ0dWFsQm94L0tWTQ0KPiA+IFsy
XS4NCj4gPiBUaGUgaXNzdWUgY2FuIGFsc28gZWFzaWx5IGJlIHJlcHJvZHVjZWQgaW4gUWVtdS9L
Vk0gaWYgd2UgZm9yY2UgYQ0KPiA+IHNyZWcNCj4gPiBzeW5jIG9uIGVhY2ggY2FsbCB0byBLVk1f
UlVOIFszXS4gVGhlIGlzc3VlIGNhbiBhbHNvIGJlIHJlcHJvZHVjZWQNCj4gPiBieQ0KPiA+IHJ1
bm5pbmcgYSBMMiBXaW5kb3dzIDEwLiBJbiB0aGUgV2luZG93cyBjYXNlLCBDUjQuVk1YRSBsZWFr
cyBmcm9tDQo+ID4gTDENCj4gPiB0byBMMiBjYXVzaW5nIHRoZSBPUyB0byBibHVlLXNjcmVlbiB3
aXRoIGEga2VybmVsIHRocmVhZCBleGNlcHRpb24NCj4gPiBkdXJpbmcgVExCIGludmFsaWRhdGlv
biB3aGVyZSB0aGUgZm9sbG93aW5nIGNvZGUgc2VxdWVuY2UgdHJpZ2dlcnMNCj4gPiB0aGUNCj4g
PiBpc3N1ZToNCj4gPiANCj4gPiBtb3YgcmF4LCBjcjQgPC0tLSBMMiByZWFkcyBDUjQgd2l0aCBj
b250ZW50cyBmcm9tIEwxDQo+ID4gbW92IHJjeCwgY3I0DQo+ID4gYnRjIDB4NywgcmF4IDwtLS0g
TDIgdG9nZ2xlcyBDUjQuUEdFDQo+ID4gbW92IGNyNCwgcmF4IDwtLS0gI0dQIGJlY2F1c2UgTDIg
d3JpdGVzIENSNCB3aXRoIHJlc2VydmVkIGJpdHMgc2V0DQo+ID4gbW92IGNyNCwgcmN4DQo+ID4g
DQo+ID4gVGhlIGV4aXN0aW5nIGNvZGUgc2VlbXMgdG8gZml4dXAgQ1I0X1JFQURfU0hBRE9XIGFm
dGVyIGNhbGxpbmcNCj4gPiB2bXhfc2V0X2NyNCBleGNlcHQgaW4gX19zZXRfc3JlZ3NfY29tbW9u
LiBXaGlsZSB3ZSBjb3VsZCBmaXggaXQNCj4gPiB0aGVyZQ0KPiA+IGFzIHdlbGwsIGl0J3MgZWFz
aWVyIHRvIGp1c3QgaGFuZGxlIGl0IGNlbnRyYWxseS4NCj4gPiANCj4gPiBUaGVyZSBtaWdodCBi
ZSBhIHNpbWlsYXIgaXNzdWUgd2l0aCBDUjAuDQo+ID4gDQo+ID4gWzFdIGh0dHBzOi8vZ2l0aHVi
LmNvbS9PcGVuWFQvdXhlbg0KPiA+IFsyXSBodHRwczovL2dpdGh1Yi5jb20vY3liZXJ1cy10ZWNo
bm9sb2d5L3ZpcnR1YWxib3gta3ZtDQo+ID4gWzNdDQo+ID4gaHR0cHM6Ly9naXRodWIuY29tL3Rw
cmVzc3VyZS9xZW11L2NvbW1pdC9kNjRjOWQ1ZTc2ZjNmM2I3NDdiZWE3NjUzZDY3N2JkNjFlMTNh
YWZlDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogSnVsaWFuIFN0ZWNrbGluYQ0KPiA+IDxqdWxp
YW4uc3RlY2tsaW5hQGN5YmVydXMtdGVjaG5vbG9neS5kZT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBU
aG9tYXMgUHJlc2NoZXINCj4gPiA8dGhvbWFzLnByZXNjaGVyQGN5YmVydXMtdGVjaG5vbG9neS5k
ZT4NCj4gDQo+IFNvQiBpcyByZXZlcnNlZCwgeW91cnMgc2hvdWxkIGNvbWUgYWZ0ZXIgVGhvbWFz
Jy4NCj4gDQo+ID4gLS0tDQo+ID4gwqBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jIHwgNiArKysrKy0N
Cj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2
bS92bXgvdm14LmMNCj4gPiBpbmRleCA2NzgwMzEzOTE0ZjguLjBkNGFmMDAyNDVmMyAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3Zt
L3ZteC92bXguYw0KPiA+IEBAIC0zNDc0LDcgKzM0NzQsMTEgQEAgdm9pZCB2bXhfc2V0X2NyNChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gdW5zaWduZWQgbG9uZyBjcjQpDQo+ID4gwqAJCQlo
d19jcjQgJj0gfihYODZfQ1I0X1NNRVAgfCBYODZfQ1I0X1NNQVAgfA0KPiA+IFg4Nl9DUjRfUEtF
KTsNCj4gPiDCoAl9DQo+ID4gwqANCj4gPiAtCXZtY3Nfd3JpdGVsKENSNF9SRUFEX1NIQURPVywg
Y3I0KTsNCj4gPiArCWlmIChpc19ndWVzdF9tb2RlKHZjcHUpKQ0KPiA+ICsJCXZtY3Nfd3JpdGVs
KENSNF9SRUFEX1NIQURPVywNCj4gPiBuZXN0ZWRfcmVhZF9jcjQoZ2V0X3ZtY3MxMih2Y3B1KSkp
Ow0KPiA+ICsJZWxzZQ0KPiA+ICsJCXZtY3Nfd3JpdGVsKENSNF9SRUFEX1NIQURPVywgY3I0KTsN
Cj4gPiArDQo+ID4gwqAJdm1jc193cml0ZWwoR1VFU1RfQ1I0LCBod19jcjQpOw0KPiA+IMKgDQo+
ID4gwqAJaWYgKChjcjQgXiBvbGRfY3I0KSAmIChYODZfQ1I0X09TWFNBVkUgfCBYODZfQ1I0X1BL
RSkpDQo+ID4gLS0gDQo+ID4gMi40My4yDQo+ID4gDQoNCg==

