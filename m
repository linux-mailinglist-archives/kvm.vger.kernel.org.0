Return-Path: <kvm+bounces-39917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7F0A4CB44
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01E6D1758EB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACF322FF38;
	Mon,  3 Mar 2025 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vWyzr8/E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC42322DFB3;
	Mon,  3 Mar 2025 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741027866; cv=fail; b=hOLlwITn9NFqyhRi+Jjdqyvh6dBIgdEZXgkKNdMdOQ0bKUjOq74o6suPmTRcOxhaWoM+zFpkrrQaIDDpT91OoMlvgqXi35LTiGcOKJZclz1e0DN9Y+71VDVf7bprXNfR4UTNbO5l3wieGfrr5baV+SpiUz0SH1wOr7sDq+fS/q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741027866; c=relaxed/simple;
	bh=a9PeB0B7zkqMyKDgDQbGcYNlDNa0I565Bfxyua8sa+8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FDe61rq6NT3BLEBLe3piBJKMij+8U1ylpVq24wilCSYg5i/JTRIvho7Axrw+BdgL6lfrXQK86SuADyCG4nWlTDhS/izs/NzmCREyit0jjye61dODa9e4+iEN7gwGwZEtz4M4kohW4D1YxVGiuSnbzg3D0lfAKNsK2wKU0pLBn/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vWyzr8/E; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e3fnIGjwEKibJLxluH43yBr75vIgWNc72SUCHY1S/RgPJ7mZstm0E3zaFt/fZKsRrUf2W4JK4VfJhVgkzbqsPpi25bu9oED4ZIqftVVgMpZB7Oco4rlfAkVmWC/I+t7AnSwOwpu70vL0Q7I9Cb3MRhamJlOSnw8B7XN2RhcrHCSDdpEguZwFU+0KOcF9c5wroNAgWMS3RZ/LJJVr95T0DFQ+9J8ChqIYrEv7C3wmlYdOnG5PUju52GOV2t+9+ANLHccXHpWDC9b0wjohGa3X1PdTkTOnQm3sRSTWDjS/2mRLgUH5g3QDDY9CvzBdsxvxn1QwD5vHRMDQfK+1EAxhwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnRafU7bc6aCdJm6vIWlJsBIH8vuAMPqV6Pannm7/AQ=;
 b=T0gVYVxEcc3t9Q/fHywQLpy3PVaYTAqgm+23eZB3mexIRupXegjYnziQgWWyv7fmS+ZjsHGq3mde8ybN3GZmSN3nx/jRzeXdg6AXOEmXa5/RTa6Qai3slsFWT4U4219Fcnejjc3IB1OQS8qyMxy922aSHxcqg0QEsCnlfrho/mD5nKIQRSNIQ3jHCVVr3/IasOoNdL9xaUhd/xlYsGDcLnDbGGJLKpcYt3fUbjUJk/fs7J25MU/mt9RCmRyb49gzrMfmXtsE6fHgKoWMx+AIqqdJeSaOQnMopmUX7kcs8OgHsry28A4drJWfCgU3FKaM1B0BQEK2KirHVZvS91NjIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnRafU7bc6aCdJm6vIWlJsBIH8vuAMPqV6Pannm7/AQ=;
 b=vWyzr8/EvzgR50UyWWNbBDEfoGwRhzGecoxqAiI+/ot1HeQM0sbZGTiMG+Wqk+WOkFXrjj6HRilkoCmcurgko3QzEh760yFc3nJOsjDRsMvrn1OqDkJutZC28ZZ7JBFReRgjuXybT09AzC2ib+ziAPGLi2PMt6INO+5vvj46HP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY5PR12MB6347.namprd12.prod.outlook.com (2603:10b6:930:20::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 18:51:02 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 18:51:02 +0000
Message-ID: <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
Date: Mon, 3 Mar 2025 12:50:59 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z8I5cwDFFQZ-_wqI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:806:22::32) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY5PR12MB6347:EE_
X-MS-Office365-Filtering-Correlation-Id: 44690163-d9b4-4948-7d4e-08dd5a845861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnAyVFozWXgrS050N0ljS0ZNTldzMVBqMnhuNDVkekV3ZHdSS25UbTRnWGxY?=
 =?utf-8?B?ekJrNUhieC8wVjNJYllHSkloZkxnS3o1WjlFYjdoN3pGVDh5NERLZjFkZFdB?=
 =?utf-8?B?dURYRVN3cVVURTRMUkNyRHN4Ymx0RXkyVTlVakZLM25vbG9qNHdSSmpMeVpx?=
 =?utf-8?B?cVg3VmdEZjdXb0pyb0x4amlRcWdmQTQ0NHFWVXVsL2tGN1Q0SmJVVEZ4Mzk3?=
 =?utf-8?B?UW4wZm0wZ3hlS0Y4MmhqNmdUOGIxWko2R0hJN01HTlJNS21vNnJ6L2VILzg2?=
 =?utf-8?B?MXo1WTJWOWZiNUZzWGMvOG1JRFhOakVPSkhQTHd2ejRWakgrTFI2TjRpSlZE?=
 =?utf-8?B?MFFBdlZEdzNpWnViazJEK0hER2dPc1R6SnBHL3E4K1NxWXF6OTNnelQrK3pT?=
 =?utf-8?B?SjdhK1BxTWxiekhUcENZYWduWE1FR3dEQnY4REkzNU0wcE16MDkrQVN6Z29S?=
 =?utf-8?B?N0NEL1RFOFBQS3cyYVdSa2xsVEVpaDdqL1ZMZGhHQlBvOUwwUDNrN3VsUGJy?=
 =?utf-8?B?SS8rZDVXK1pqdkY4dXAxc1g2cjMwMDdZa2NwbXBTTVFvV1FoTDZHOVdGcSsw?=
 =?utf-8?B?MGRmQ2U0dFBERW1DRFFyYUR4aDlOL0NuWStiM0dzNlJIUFg4MDJKQlN2cklI?=
 =?utf-8?B?OTRMYWtzRklLUktmWTY2d1ZpTWR4NDZ2MTYxY2I2Y2wzUHkzZjNmbGRRWXdT?=
 =?utf-8?B?Y3J3T0dBWGVXTFppeTNQQ0xzRklQbSsvWm1Tc1l4UWFSODg4dWZRODNmemJ5?=
 =?utf-8?B?cDNTNTlUWjMzT1pKaVl3eHQwODBjUjV1SSttS0lQckd1OXVPUVc2aUF5V0Zv?=
 =?utf-8?B?RmdpeGw4S05aL2Q3Y0swM3lNZElEdlpmMGRTWWR2dndqb1J5a2FIbUh3T01P?=
 =?utf-8?B?NEtHbWlHakNJcUFTcTZFS0h6VjJYM3lMM09QZURaMTkzZDFna3RGblcxbXlu?=
 =?utf-8?B?T2F3UU82TVdnZnJKR0sxZW1wRFVXTjZ3bnlBbytlVFl3OFlCZlpLNTdzeDlP?=
 =?utf-8?B?OXlUOWxEL1hRRHRMam9qTnZXb2ZKWkpMRW9mT0txZ2NSNXlqaGVXTUVrK2VY?=
 =?utf-8?B?eGh4UUJYc1VPNVlnUCtWWk5BczRwVGRMNzFVWDB4cWI2WWR4L0JGOGU3QTRs?=
 =?utf-8?B?WkllYnVNU2JBTnVnSGhKYUd1ellCSjlCMVAvSEgrREFXNUJib3F4RnhBTWg0?=
 =?utf-8?B?MXRLY1V1cmxzM1NCaXZXQmtPb1RadjM4TlBJSWZqSUJqU1Y4a0JybGVtM3p3?=
 =?utf-8?B?eHJyMXVLaTRSN3k1WW5YbDQyVHBXcExBd1FZRDV5ckF2UnRwYnBYcFJtaWl1?=
 =?utf-8?B?bEFYVkwvT2NuOUlJVHd2N0hPNURxQ0REZk9ERDlNUUZHb1NYY2JKWDhWWHJY?=
 =?utf-8?B?b3lsekw5TVFwdDd6a2ZMYjdIeU9ZRmU0UUVESDI2bUpYbDNMS2pUdVo1NW5N?=
 =?utf-8?B?RlJ1eTZrLzhNa3o5SmlHaHVmOWdNeW8rUkY5S09lUm5FVXRoL3V4aUhxSE82?=
 =?utf-8?B?RWwzTFFNS1FHOVQ4Umh4RmhUVGdUdXNZWHBCUnhBUk01ZFVFL3Z4eForT01H?=
 =?utf-8?B?amRvS1Y5YVlRMVcrdFBncStMTHpyektiNGZsYmgzU0U2TkJUeWtiZ005YnhY?=
 =?utf-8?B?NU1qUEwvNzN6UjgzMFF6bkc2b20wY0gwOE12ZmIvVHVUVk1zUWdZS1FiVjZ4?=
 =?utf-8?B?TDk1b245c0hPM3BKdnFuRDBsK0E1RVJ0OS8xTTN6U25RZm5QMElpbnFCS3U2?=
 =?utf-8?B?VXBwNkM1ZnNqOVNUQU1XSXJiRTZRL1dNcVhBZHdyNW9KR3o2VVYwZTZmRFNm?=
 =?utf-8?B?a1ByUkNHdDVFN1BvMXJtTmw5S2lxZDZqTE9lTjFZWjNOMGxZMElPRDgwMk1H?=
 =?utf-8?Q?RxDbt7nsZrzv/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUpPREZrSmtOa01qNS90di9MNmZhUUZmNnh6a1ZydUQ2OXU4anpZdzJZemZo?=
 =?utf-8?B?SndoTXVYN1pwZHpVL3ZGbjBlV1JsR1VONlBrUkFpVEx4N1ZSS0VTWDhyaDBM?=
 =?utf-8?B?M2FvNHU3ZGR4S2NUaCtZLzRxNXBtZTRoTGh5WWR6STF4azJpOURsVElCV2FS?=
 =?utf-8?B?TmdPQUdKRlFac0IyaEIrbCtiVy84bG9sZFRkdmpCamZvOGMxQTF2MHJzVjVT?=
 =?utf-8?B?RkVYRUN2QTdFek1Fb0lKUkJVczVKYzJJWnU0YUZPektNUm1FaFVlVThPQnBp?=
 =?utf-8?B?U0JUMU1na2ZKRmpISC9OdzZvVGxzUGwxbTE4MFRGbFVoUGppdi9KKzFLOVNX?=
 =?utf-8?B?RWNGOVU2OHFIS05JeXZYdThNUXY1UitSRWFZWFFHMnduOGhDekFITHEzdnc4?=
 =?utf-8?B?ZGIrcTBkdGtiZDNweFdoY2NNSkFvZWZmMEhYMjFsSlN1cHZUR3lMSHphdjVO?=
 =?utf-8?B?QkxCbWc1Um0wTzFRQjh4dkVwUll4Ui92R1RlN0oreE5KZ09id1RIb3Z4ZXJM?=
 =?utf-8?B?NEhVcVBZQUwxOWJXUUI4NGFObGd5OWp2eGU3ZjNhTFlobFR5NXo1OFZlOEpp?=
 =?utf-8?B?ZWdBK0FRdVhzMUJ3MVc2M0lidmlPUm53WUJNbkZoQXB0emFSUDRBK3dFcCtk?=
 =?utf-8?B?alJLTzE0VUdvYkppNkNvR2ZEL2pUTm5wQkw3dDF5L1hMTHE4QzM5M0h6WjRr?=
 =?utf-8?B?VHJ5Wkt6R3RMbjFiK1dHZmRGSUgrTUZ3c2dBWk9PQ3dnMzZQbExzTWFCSUtR?=
 =?utf-8?B?Z1U0VC84Vko5bmhjNnFYK1NjN0dvSGlCWlcyTWRSeDFZTmp1dnpWZG0zUmts?=
 =?utf-8?B?d0VTOStCdWNOM3pDVzBPUDBQeU9MYTBFdEdvd0I5UjF3UmEzVWFPRXB1QkFM?=
 =?utf-8?B?QUo1OW9JTmNaUUxFclBnZXdrNDVZekptVmJQeGxta3JxV0U5RFl3SkF0ZEYx?=
 =?utf-8?B?T25GMFU2Q3dCQkRxaDc0WUtuS3huWDFzaGJoOXQ3NEh5Q1A2Qk9MN05hMW5O?=
 =?utf-8?B?Q2lxTk9ycHJjU05qUlo5RWd4bmR5dk1zc3FvUzVQTXlBTTRBTE1ybmVaTGxB?=
 =?utf-8?B?eng3Qm9VeEpuREtkZGhBQ0hGU0FQcDFtcEVrRmlYVklXeXJpQzdIZEVDdmwz?=
 =?utf-8?B?bk43a21uYnkxOUJuWGU5M1FhRngzUmpvWDJOeEhMUVRMOU5aTDgxU2RkR2NE?=
 =?utf-8?B?S2QvTStBUDE0UjBSMjVFb2FMcWxYSFk2aFhzako2aStGczkza0xqeFgyWHZR?=
 =?utf-8?B?TG9yMXVnQjVaeWhJS2d5TC85ODhsc2h6bGNseEMrWkVsRlg4NWlrZVEweWxq?=
 =?utf-8?B?VDRoR21VeSsvRGRCQnpLOVQ1eDgrZEFjUzd5YWgwb0VxTTVza3lnK2tQNDFR?=
 =?utf-8?B?NVo3VlcxZW5OSGZBa0xHcVFGcmQydmpUT2VDZFBIVGlLaSs3M0Zhc1YzRTls?=
 =?utf-8?B?ejZYTXkxVGxFNkZSM3ZXbWJ6Zlh0VWNsV1NxNnFBTnI4a1JWWW53NTF1aDcv?=
 =?utf-8?B?MkJiTjJ5eExNWkRpQ1dxeTdtMVVHOUh3cFQyS1d2aW9xRXNod0FFZTJrd1VL?=
 =?utf-8?B?QXNLcjE2Q3MxTnplM1M1Yytob1ZTejF0c05IZzdlVFhidGV2TGFvRjduaWJi?=
 =?utf-8?B?MHJIaFNrMlVkVHljbWR0cTh5V2dkb203RGdHaVp0WDU4VHNLNVVCSm8xUkg2?=
 =?utf-8?B?dTc0eWJ0c1RUNnRLM3g4aG15TlRMYWtnYzI3S0MyOGpheXkyZVJhL2NiY3Zr?=
 =?utf-8?B?UVd5TkhRcWwzOVVKWlpGQ0g2cW56SDgzNEh3Ym5ON3Vpc0JoMXN2QWp4bnVH?=
 =?utf-8?B?OEs3S2kwaU1sSVZMMUR3NldwMU5xU0c1ajlaVDJlR0drMDIxb2RESnRKNjRv?=
 =?utf-8?B?TlFvNWRLSnJLc3BFdDVUaU1UYzAzekd2clY5c2NjamUvQWh1akNOTW5tUEg5?=
 =?utf-8?B?SE5Nb205SlpvaFNQY2I4aVpSejVZY1NnQ3pFSnJDSUNwL1lQOHZTRlVlODFk?=
 =?utf-8?B?NENSVG5ybzNqS2pMamtnVVEycm5jdWtGbEtncnZWenR5bmpnOEYxc2VyQlJa?=
 =?utf-8?B?S3RlRllxWjM0Y0QzZ0FmRnFlZ25kV2hJeXd6cUdrb1JKOFlvUVQvRnVDY25q?=
 =?utf-8?Q?mMwpk0PSdIZsskcrqY0O83L2f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44690163-d9b4-4948-7d4e-08dd5a845861
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 18:51:02.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjMTONvoLxhLWAyAjPFnuSlY+DRRsPi8qSHvW+BUsxl5pOuf31p7i+AltFOGX9F3o+3mF7fIsmGsnpsAnWYe0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6347

Hello Sean,

On 2/28/2025 4:32 PM, Sean Christopherson wrote:
> On Fri, Feb 28, 2025, Ashish Kalra wrote:
>> Hello Sean,
>>
>> On 2/28/2025 12:31 PM, Sean Christopherson wrote:
>>> On Tue, Feb 25, 2025, Ashish Kalra wrote:
>>>> +	if (!sev_enabled)
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * Always perform SEV initialization at setup time to avoid
>>>> +	 * complications when performing SEV initialization later
>>>> +	 * (such as suspending active guests, etc.).
>>>
>>> This is misleading and wildly incomplete.  *SEV* doesn't have complications, *SNP*
>>> has complications.  And looking through sev_platform_init(), all of this code
>>> is buggy.
>>>
>>> The sev_platform_init() return code is completely disconnected from SNP setup.
>>> It can return errors even if SNP setup succeeds, and can return success even if
>>> SNP setup fails.
>>>
>>> I also think it makes sense to require SNP to be initialized during KVM setup.
>>
>> There are a few important considerations here: 
>>
>> This is true that we require SNP to be initialized during KVM setup 
>> and also as mentioned earlier we need SNP to be initialized (SNP_INIT_EX
>> should be done) for SEV INIT to succeed if SNP host support is enabled.
>>
>> So we essentially have to do SNP_INIT(_EX) for launching SEV/SEV-ES VMs when
>> SNP host support is enabled. In other words, if SNP_INIT(_EX) is not issued or 
>> fails then SEV/SEV-ES VMs can't be launched once SNP host support (SYSCFG.SNPEn) 
>> is enabled as SEV INIT will fail in such a situation.
> 
> Doesn't that mean sev_platform_init() is broken and should error out if SNP
> setup fails?  Because this doesn't match the above (or I'm misreading one or both).
> 
> 	rc = __sev_snp_init_locked(&args->error);
> 	if (rc && rc != -ENODEV) {
> 		/*
> 		 * Don't abort the probe if SNP INIT failed,
> 		 * continue to initialize the legacy SEV firmware.
> 		 */
> 		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
> 	}
> 

Yes, i realized this is true and we need to return here if rc != -ENODEV.

So i will add a pre-patch to the series to fix this.

> And doesn't the min version check completely wreck everything?  I.e. if SNP *must*
> be initialized if SYSCFG.SNPEn is set in order to utilize SEV/SEV-ES, then shouldn't
> this be a fatal error too?
> 
> 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
> 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
> 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> 		return 0;
> 	}
> 

Yes, this is also true, we need to return an error here.

> And then aren't all of the bare calls to __sev_platform_init_locked() broken too?
> E.g. if userspace calls sev_ioctl_do_pek_csr() without loading KVM, then SNP won't
> be initialized and __sev_platform_init_locked() will fail, no?

Yes, we should be calling _sev_platform_init_locked() here instead of__sev_platform_init_locked()
to ensure that both implicit SNP and SEV INIT is done for these ioctls and followed by 
__sev_firmware_shutdown() to do both SEV and SNP shutdown.

> 
>> And the other consideration is that runtime setup of especially SEV-ES VMs will not
>> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
>> KVM setup time.
>>
>> This is because qemu has a check for SEV INIT to have been done (via SEV platform
>> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
>>
>> So effectively, __sev_guest_init() does not get invoked in case of launching 
>> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
>> sev_hardware_setup().
>>
>> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
> 
> In that case, I vote to kill off deferred initialization entirely, and commit to
> enabling all of SEV+ when KVM loads (which we should have done from day one).
> Assuming we can do that in a way that's compatible with the /dev/sev ioctls.

Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 

For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
DLFW_EX.

We still probably want to keep the deferred initialization for SEV in 
__sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
case.

Thanks,
Ashish


