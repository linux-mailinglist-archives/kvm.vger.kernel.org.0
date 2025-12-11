Return-Path: <kvm+bounces-65785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C88CB66D1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 17:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 362D230142C5
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 16:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F6F313541;
	Thu, 11 Dec 2025 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VXRZlz5h"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAF22068A;
	Thu, 11 Dec 2025 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765469352; cv=fail; b=O2AwmXGuTDrFQXkOMS/7pkRhL796FrlK+visb88P3mKYfk9MitOSCCvkysssee3gDP7AgAF3B2WdVF/klCm00gY8aZfs7q1wFkP023EFa8u2LKiEBBc41ZN8cpsQO+t2MQU4/v6RFe8TA8Y2XkI0pMSTAVRScOXH6O0/opGdzO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765469352; c=relaxed/simple;
	bh=Y9M+cRKm9+9nuC2oXlaXnVGn3N+TLfnuUsaVzjdYsXY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WD74im7Ou21IB1gCAkK+oyifm/CJFvlq778AdU10ua1QTtRYzZ+CxsEirTtZpRS77bemgauYqS6maHmXSqPHE0dWV0AB5Wo5Nwy6HPnw0lJRL+VsrGCXR5+I1bS8RxWKoYHkrKy6cxzic2T3x1OPfuWxgO1FBYb3mVnuGyxICBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VXRZlz5h; arc=fail smtp.client-ip=40.93.195.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iaKr8GRrxE4FFly66zdOXJbzwirnz/6B/SNLm9ECCrfwR+gAu6mixCcIrD3+fYY+ZFWGaVlmOvh1uM6Te1KKzb2LzhFyYGc3rSpUqX/Z/MIRtWD0NetJkIRDsqVlnALeZbb8vmVOTbG2vak1MF9yawwBqndpQHs3vhuHTxmCWyiddOGQ5bugYuZvKeMV9IcrDgHzjhUz1ExrUe0PPqAji6Zhw/ECoeZ/I5ODmaRfvAGds8CjXkYeX6dtJ0d9EDjitSaumm+67sUhG8LiHRF7vFEaxw/PhxLBDLhjx7Fzma1dn46qC32JXQrkwhrw7qyDhd5zonaVSt3zLEUFQMaDAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9M+cRKm9+9nuC2oXlaXnVGn3N+TLfnuUsaVzjdYsXY=;
 b=cBxHo5tegwDipUP8EVqp4BUSGP5esTjLt+oRcStLPBdWrDkirXPVd9uowpg/BGTZuSwkSrwSt9aj1REg9SUYqEdBT1rZWk/SYEKEW41NRsQWj8qPQHAgR1NjJbkdhdtRw4SKAF7f6Oaan+HHhg5dAiWrgxzKE20FvHicFxKHaoryxDWX2BvIHnGbQYtv+mtrT6OhuVDMk5drn2H7HcAmt9XZtGb1Kv2x83Axjy8Ry7TCXjLCRbjkjdZRg+hhv+p2YEApt2p+ycurCxVksdi6mUoYnUHHSoJcyXSKpd+dfSBAJgR6otm+vNuPv+sdxwIzLftcx1qagCoB44pjJTasPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9M+cRKm9+9nuC2oXlaXnVGn3N+TLfnuUsaVzjdYsXY=;
 b=VXRZlz5hVg6YrYBfQUk/Avlw7MtkBzyr0VtobeE6IiOJff1tKx3MhhxnV5m+RtUt2oPO1TnI3osvfy04TYFZpDOIF2KNCpDIbylDkEPVTw5g20n28bx+ybYmxHkNpkQd4q7nvZVZXsID6neBhJNGzQHsDxtBbzJC/yIU9yGrLL4=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by DM6PR12MB4339.namprd12.prod.outlook.com (2603:10b6:5:2af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Thu, 11 Dec
 2025 16:09:06 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 16:09:06 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "seanjc@google.com" <seanjc@google.com>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Thread-Topic: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Thread-Index: AQHcT8mMnd7JB9P6okicpWg0VkazobT8FAuAgAYHjoCAAAcAAIAarsYA
Date: Thu, 11 Dec 2025 16:09:06 +0000
Message-ID: <08826b5879e2d9c354424279763d3ce5556f44cc.camel@amd.com>
References: <20251107093239.67012-1-amit@kernel.org>
	 <20251107093239.67012-2-amit@kernel.org> <aR913X8EqO6meCqa@google.com>
	 <db6a57eb67620d1b41d702baf16142669cc26e5c.camel@amd.com>
	 <4102ede9-4bf7-4c0a-a303-5ed4d9cca762@citrix.com>
In-Reply-To: <4102ede9-4bf7-4c0a-a303-5ed4d9cca762@citrix.com>
Accept-Language: en-US, de-DE, en-DE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|DM6PR12MB4339:EE_
x-ms-office365-filtering-correlation-id: 3edc79b8-1422-4883-9306-08de38cf9c7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RDR1RHo1VTNrOWxrbjA0eEhXK2ZxckVTdklTQlJNVXN3YjVCVW1GZDMrRkc5?=
 =?utf-8?B?WEtOSTNOTGR4eStRMWhxNkNwVFBKWm52Y2VXdjd3cHNhYThlWWRuVUs2QUpX?=
 =?utf-8?B?ZlE5TXN0dDlKaXhMMnUzcUlXSXlBOU5vU25pYWcxZGxiM0FwaFM5Wi9ZbkUv?=
 =?utf-8?B?U1dVOW1uY1N1bExoYTFBazFybjNXdmtObjRNYXNNNzVlRWxRRWl5OUVuVThB?=
 =?utf-8?B?RkxDbFQwc0NlcjFMd1U5cDRvMUtTdTB4Z0NqbVNTS1pac0t6a0hSUUZieWRu?=
 =?utf-8?B?eXIxWkR0Zk11Mk0rSHZFSitVMUVFb3J1VkRWeHljUFNPSVhiYlcrcmF4Mm5Q?=
 =?utf-8?B?RjlzYTNwWm1nb3JDclVMbVdlb2MwY1FxRFJkTC83YThFOEVPV0FqZGd6U3pK?=
 =?utf-8?B?QktGSFgvVGJNaVVrQWhtZVJ3TTRtbjF2T2RKWlR2T0p1YWVUZmRGbXJsTmFh?=
 =?utf-8?B?WFNqVE1XRHc4Y1QyVTBmTVVQSFROckVlSUtrMFpwSE9KWFBoYmFZc1owN0VV?=
 =?utf-8?B?NlRWTC9pb1hwVStCdFJEMTIwU1dSYkQyL1V2cWZoRmNEZHFSbTBXeVVxSUY0?=
 =?utf-8?B?Q3RFdS9qVWxMc3d5dmhtdkZNZjIxTEtCc2hCdi9aUVhnaTFqUmUwRXlMWUxu?=
 =?utf-8?B?NnhzUDJjZFo3MityTWRaZGExaG1yM0Rwd21Mc3U5bDNSYVNQMUpUeHhJcFB3?=
 =?utf-8?B?aWhDQm9iWGhoeGNNR3ZBRGtQZWZhbGowcDVFZCtvWGpzMWdPV0dwSlhFSVpQ?=
 =?utf-8?B?N1owL0NjU0VBc3luK1BQN1U5cEZuWHBDM1dReVZUakpQQ1ZrU0hwQVlCa3Q5?=
 =?utf-8?B?eUdob0k2RkYraVJhRWNjRjFBb0lYSGdHb2szYXF6a0htaGZJSEJ1U1hTbVNy?=
 =?utf-8?B?aW1Wb2VtZUh1eDVBVjNTeFNJd0hxMmhVVGZQMi9qczVnemZYS2pXaWpXWHFK?=
 =?utf-8?B?NEwyelBJSEE4RHZNOVJhUG4ybTkrNDFrblRGWHl6dW45RU11ODlPVENiWDBW?=
 =?utf-8?B?cFEwYk1vdWR4WForNGd4OHdTMHdKU04rb1RZR3Y4NHJueWgyR3VqRTRUWlVa?=
 =?utf-8?B?TllYWFVPdUN6dnFLWkxkYVJDamNOT3lRVUhid1FqZmF2ZDljOUJqUE5VOFFj?=
 =?utf-8?B?UGxsYk82bVMvblhEOWNFWk5CZnFFQ1ZUd3BnRktPNmhlVGFJWkJuQmdmYnZX?=
 =?utf-8?B?cVAweExmWEhsc04yK0RjeFJjZGxHaFNiTjZSY09VL2lQL2duNm5GVm9RcGt4?=
 =?utf-8?B?cGZrRmJWK2xNTllhUmtNaUx2SHlzTjRCK2FseURnNW5SK2pZelI4eUhsald1?=
 =?utf-8?B?djE3c3FMTkRJS25mYVpWeGM1UUdFWjc0dWtzNXNIRDFjMEN6RUN5cmxKWlhY?=
 =?utf-8?B?b2tqNnZsTWhVTUZ1cmlBOWovSFpWenZBbDhzQit5a0NRME9QcFRxbUNoOFFP?=
 =?utf-8?B?Qi9LZmlOSzRMcHg2cHZCeXNINDRCVkNTaWZqVlhjMmV3aGRDRGxtTFhJQjVs?=
 =?utf-8?B?WTM2VXNHL1AwNU5YWmMxcFR4elZZQkZWYm93b09yZlZIZ3RSTGhXd1cwN25r?=
 =?utf-8?B?cUhBTm1YUmZxS0kxZUtqajlvL09jVkdtaUE3cmJpYk9EL1J5OVFpRC8xWFFK?=
 =?utf-8?B?N2xNRVlSMXVDN3l1NVltMHd0TmNEV2VOSlppeVJ5cjNUV1Z3MHdaQkpFZkRi?=
 =?utf-8?B?WWhCMW1FVk52djIrZUpvd2U0dzZtNjkvaExlL2ROeWJOandPWU9IdzVaUmpC?=
 =?utf-8?B?WHBTRFJtb0VBQW12TEtFcFB4ZURkQ2ttcGZxWXNWb08zTXVBMHl1cDh1ZHc5?=
 =?utf-8?B?NEMyYTZlTG9KalpqTDBIeXk0VXl3Tjl1aU1wKzRzZmp6WWhVM2htV2ZyQWhO?=
 =?utf-8?B?dXMrdmZJeC9LRUhaZHZYTnZWWXhEbzhSVmdLMHBNRnVoMUZ1M3pTK2M4OXQ0?=
 =?utf-8?B?SVcvVm5NaVEzZWhYS1pPVnkvTFBOMHo1ZlZkbHZSaWczNGhCa1ZJY3ZpQ2tK?=
 =?utf-8?B?UTJHUStCUTZzRzNFczV0QzI1NFFBdHdSZFpzeU1lUnVGeDZZRnVKZGdiVkRD?=
 =?utf-8?Q?/GvXsc?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SFpJdjMxR25QNStrZU5lbkJaNE9VV1l1S09rbityZTN5Z0cwcmluTGJWbzVi?=
 =?utf-8?B?ZTZjbGdpazYvV0h1cUtuWDNDaUQrbEpOQmxmek94VEdIWFA2eVZaWmRXU0p3?=
 =?utf-8?B?c08zWmd1bWpUOEJlcUoxRnBsZDlJN29acDdZM09razRNMFBsdm5EVkdoK1By?=
 =?utf-8?B?QUNJNFJkZytkYm5iNDZHR1lxZmRnR1VOVDZGRTVCRE1aTWtWY3hLR0pLMFVT?=
 =?utf-8?B?Z2FzMHp1OVAwZjBRVW9DeVpXc3lKRnVHNkhrRUtLbURQZzhTcHcxL21MbHpz?=
 =?utf-8?B?Yy8vS3BhWFBqdFZ6OUJ2NWExazlGdi9vanZzU2ZUSi9wQ0hLRUpIWmpsaEVG?=
 =?utf-8?B?eWpKQWxnVEQxWG9HSUV0TkU5M1htTHN5S3B5aXNQSDJqQnovcHpFK0RzUjYv?=
 =?utf-8?B?Q0lmWFk0ajFyYUhUYVVMbzM0SW83STdKcVhuZ3FwTi9UTlFwVEc2SXVEa3Nu?=
 =?utf-8?B?VndhUHMzMC85VGZnR3o4byt0VXBFVFUvQzR1djRBNDh4eTNiVlVkczIyWlF0?=
 =?utf-8?B?M1lSNUVXWmRYTmxlb3NNODhkNHVYcEt3cmlNUm1adVBubEgwL2FzNXNSMlJR?=
 =?utf-8?B?d2UzRElmdmhnZUY1NDZVNlJkeWM1MWNpZ0haVitvRWJuVytiYlRPck8weWtp?=
 =?utf-8?B?bXdQQlY4aHh0OVRYQnR3NS9kSEhHaVgxbmJRTERSNzRpTkdFekM1cWxjY0t4?=
 =?utf-8?B?eHBuaFd6T3ZjTFNWL1EydVA0UUFPd0ZKbGRqWnBCeTBwWnBNbXhBTXpPZ3Rj?=
 =?utf-8?B?aWQwUjVHRVF2WUhxb1JyVGFBN1VvT1VCZFhuK1dvang2eXJkM1Q1d0wrM05v?=
 =?utf-8?B?RU9Eck5YckNUQ0N5dlRieGI3NXg1RGQ1cU1EQWVZSnlLZGhTaUZOeFdnQ29L?=
 =?utf-8?B?SVE2MlhoVkdPTUd0OEJjUDYzRStiUTJlaXRIM080ckJXRDhLSmJiMEI0M0xR?=
 =?utf-8?B?dWNzb2NqVUhaRXpaSG9YTU5JT1NOZEhOZW9mMEZ5NkJKOEZtaG52R29PYWVq?=
 =?utf-8?B?UXU2SDZUR1pjZUkzN3Y1UGdrQmpWbG1sM1gvd0dlRUtUZmxTRHFFRlVuUStP?=
 =?utf-8?B?WGRCMGxyaGI5Vlp2RTNVZGFQemFDNHZkdHdmRWx3VCt2RUExeVdXTklxRFhP?=
 =?utf-8?B?K3pUcTg0ZnRmYWRhaGVDN2Jhcm1iZlRMZkRGSmpxend2OExUSXFUSllSdVNr?=
 =?utf-8?B?OU1ETW53NkNmQWp1Sk9DS24yVGFtajl6YjFncEtXNmVGY3U5aTgrc05YR1Vn?=
 =?utf-8?B?YU1kT21UMEZhbzFpM2NzYXZTdE5TMGo2bUpOcGRTYUpuT2pCZk9uWmVNcFla?=
 =?utf-8?B?ZVlkaFUvYXNDSnM1T2orYmtxU0xsMlFFRHJacUxUa2JLTEE3NitpeEFaWUdC?=
 =?utf-8?B?b0htMzBNcEluWTdyaUN0bUFNWmVicE4yMHRJQkNhYkd4UThFS2Rab2xqMkhC?=
 =?utf-8?B?bnFrSDVpNFBwMEs2ajY0QVdOTmp1dWh0Y0RSUEE1Z00wV1BXeno5OVM3RkJp?=
 =?utf-8?B?M0RDL1ljSStSbUdxOTRST3R4Zkl6VStSUFNoblRXbTFCWnVDbFdPYjFsWCtW?=
 =?utf-8?B?TW8vOVJscXdGcjdERktlQkNTeVpTMWZFVUlNdWQwN21JeE5XL1Bzc25OSG5T?=
 =?utf-8?B?UDY0QkFGeUlDZ05ZZkl1cnQzcW41aVdVRDRaRHptVnZ4bE5RVGFDVWUvaXR2?=
 =?utf-8?B?a29uTURjSmtrbGJlbUp1SWx1dEJDd0I4SnpydWx2cTRZbFFNMTVZZzZhSW9J?=
 =?utf-8?B?ZXFPc20xNjdzQld4U0ozQW5GUGNReDVBMUREYmlvNGUzNk5FbXhGcjZkVDNM?=
 =?utf-8?B?d2ZyL01tV3hEc3lGUDlpeTZQdDQxVi80eS9sem1oRDlvZjY5OWFoaS9zd3Mv?=
 =?utf-8?B?Mjg3a2FXN2MvWjN0KzVjV1MzYWloOXJoSWhKVVlxdVBKeXc0WmVTbmRUQm9h?=
 =?utf-8?B?UjBsS0txZnVvbk9Jek5yazJ5ZHBjL2RxOTFaR3RLMWxRSFlJU0dMWXNlcGFw?=
 =?utf-8?B?Wk1ZQVU2U0xkbFFsQWtlMjdBVy9IbjVucnpkRGhpNXpibHZzbzZoWXY3dVg1?=
 =?utf-8?B?blJSVmNqNGY5M0JEczJlc29IZHA1akc5cU03bTVkMTJNMGtoTlhZaHlrZys5?=
 =?utf-8?Q?je4X7NTx8G1KAhj/5nEXV5Dec?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F62FD5075278954DB6B27A4E24B00704@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edc79b8-1422-4883-9306-08de38cf9c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2025 16:09:06.7651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: luZzGLvQeIvIHfM7yq7WDW+dKJ14vIygicFGAdJfhXwZC9juAwyHiky2DkE4L77CjZNDJNxbAxX5I4+vHj35AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4339

T24gTW9uLCAyMDI1LTExLTI0IGF0IDE2OjQwICswMDAwLCBBbmRyZXcgQ29vcGVyIHdyb3RlOg0K
DQoNClsuLi5dDQoNCj4gQnV0IHRoaXMgKmlzKiB0aGUgcHJvYmxlbS7CoCBUaGUgQVBNIHNheXMg
dGhhdCBPU2VzIGNhbiBkZXBlbmQgb24gdGhpcw0KPiBwcm9wZXJ0eSBmb3Igc2FmZXR5LCBhbmQg
ZG9lcyBub3QgcHJvdmlkZSBlbm91Z2ggaW5mb3JtYXRpb24gZm9yDQo+IEh5cGVydmlzb3JzIHRv
IG1ha2UgaXQgc2FmZS4NCj4gDQo+IEVSQVBTIGlzIGEgYmFkIHNwZWMuwqAgSXQgc2hvdWxkIG5v
dCBoYXZlIGdvdHRlbiBvdXQgb2YgdGhlIGRvb3IuDQo+IA0KPiBBIGJldHRlciBzcGVjIHdvdWxk
IHNheSAiY2xlYXJzIHRoZSBSQVAgb24gYW55IE1PViB0byBDUjMiIGFuZA0KPiBub3RoaW5nIGVs
c2UuDQo+IA0KPiBUaGUgZmFjdCB0aGF0IGl0IG1pZ2h0IGhhcHBlbiBtaWNyb2FyY2hpdGVjdHVy
YWxseSBpbiBvdGhlciBjYXNlcw0KPiBkb2Vzbid0IG1hdHRlcjsgd2hhdCBtYXR0ZXJzIGlzIHdo
YXQgT1NlcyBjYW4gYXJjaGl0ZWN0dXJhbGx5IGRlcGVuZA0KPiBvbiwNCj4gYW5kIHJpZ2h0IG5v
dyB0aGF0IHRoYXQgZXhwbGljaXRseSBpbmNsdWRlcyAidW5zcGVjaWZpZWQgY2FzZXMgaW4gTkRB
DQo+IGRvY3VtZW50cyIuDQoNCkknZCBsaWtlIHRvIGNsYXJpZnkgYW5kIGNvbmZpcm0gdGhlIGRl
dGFpbHMgYXJvdW5kIFRMQiBmbHVzaGVzIGFuZA0KdGhlaXIgZWZmZWN0cyBvZiBFUkFQUyBoZXJl
IGFzIGFuIG9mZmljaWFsIEFNRCBzdGF0ZW1lbnQuIEZpcnN0LCBJJ2QNCmxpa2UgdG8gY2xhcmlm
eSB0aGF0IElOVkxQR0IgZG9lcyBub3QgZmx1c2ggdGhlIFJBUC4NCg0KU2Vjb25kLA0KDQpSZWZl
cnJpbmcgdG8gdGhlIEFQTSBhdA0KDQpodHRwczovL2RvY3MuYW1kLmNvbS92L3UvZW4tVVMvMjQ1
OTNfMy40Mw0KDQpTZWN0aW9uIDMuMi45OiBtb3ZlIHRvIENSMyBhbmQgdGhlIGV4ZWN1dGlvbiBv
ZiBJTlZQQ0lEIGFyZSB0aGUNCmluc3RydWN0aW9ucyB0aGF0IHJlc3VsdCBpbiB0aGUgZmx1c2hp
bmcgb2YgdGhlIEVSQVBTLg0KDQpUaGUgcmVmZXJlbmNlIHRvIHNlY3Rpb24gNS4zLjMgLSBUTEIg
TWFuYWdlbWVudCAtIGFuZCB0aGUgaW1wbGljaXQgVExCDQpmbHVzaGVzIHRoZXJlIHdhcyB1bmNs
ZWFyIHdoaWNoIGxlZCB0byBtb3N0IG9mIHRoZSBzcGVjdWxhdGlvbiBpbiB0aGlzDQpkaXNjdXNz
aW9uIGVhcmxpZXIgaW4gdGhpcyB0aHJlYWQuICBGb3IgdGhlIHNlY3Rpb24gNS4zLjMsIHdlIHdp
bGwNCnVwZGF0ZSB0aGUgQVBNIHRvIGNsYXJpZnkgdGhhdCB0aGUgIndyaXRlcyB0byBjZXJ0YWlu
IE1TUnMiIHJlbGF0ZXMgdG8NCm1pY3JvYXJjaGl0ZWN0dXJhbCBiZWhhdmlvci4NCg0KVGhlIHVw
ZGF0ZWQgd29yZGluZyBmb3Igc2VjdGlvbiA1LjMuMyB3aWxsIG1ha2UgaXRzIHdheSBpbiBhIGZ1
dHVyZSBBUE0NCnVwZGF0ZS4NCg0KKEZvciB0aGUgY3VyaW91cywgdGhlIGxpc3Qgb2YgdGhvc2Ug
TVNScyBjdXJyZW50bHkgaXMgQVBJQ19CQVNFLA0KUFJFRkVUQ0hfQ09OVFJPTCwgU1lTQ0ZHLCBJ
T1JScywgVE9NL1RPTTIsIFNNTUFERFIvTUFTSywgRUNTX0JBU0UsIGJ1dA0Kb2YgY291cnNlIHRo
aXMgaXMgc3ViamVjdCB0byBjaGFuZ2UuKQ0KDQpDb21pbmcgYmFjayB0byB0aGUgcGF0Y2ggaGVy
ZSB3aXRoIHRoZXNlIGNsYXJpZmljYXRpb25zIGZyb20gQU1EDQphcmNoaXRlY3RzIC0gSSBhbSBo
YXBweSB3aXRoIFNlYW4ncyB1cGRhdGUgdG8gdGhlIHBhdGNoLiAgSSd2ZSBhbHNvDQp0ZXN0ZWQg
dGhlIHBhdGNoIGFuZCBpdCB3b3JrcyBhcyBleHBlY3RlZCBvbiBhIFplbjUgQ1BVLg0KDQpSZXZp
ZXdlZC1ieTogQW1pdCBTaGFoIDxhbWl0LnNoYWhAYW1kLmNvbT4NCg0KVGhhbmtzLA0KDQoJCUFt
aXQNCg==

