Return-Path: <kvm+bounces-57920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C08B81301
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC31625E49
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668F02FE589;
	Wed, 17 Sep 2025 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ULBX1ZNC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8492FBE1E;
	Wed, 17 Sep 2025 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758130483; cv=fail; b=f3KVIHBpMMySECNrYhW9V4DoErqoZh40KTMs46plINq+NSUEKoFIpcA/KjpYJSujzMylEmm7JnAVsQvD3rde/2ulK08UyvQeuum8mm4fYr8MmHjvkGqoXbWM7XRFmKAp4JPI8ajVEOpQ9wDUF801P7WOCDwTgEf7BUEc3o/n5FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758130483; c=relaxed/simple;
	bh=JNLgvaG7W5x/ILlp7i3J82r72ZudPtL9qm5Oznk0Xxk=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=ubVBbPXJpLxbX0shBrJPOclhDyCwYozU9XU6XEWcfsmsd9wWJwgjSGAFodGt1t9Mge8h/LLqRfRbo2MsIA2FjkUFy9p1R+fi+syslDoOlUNE/JW5+7DqGZm9TUbbEsLTRCoHyA3HVZP6CUNMAZfEUGpZewB2XIK03vSKm0nAKiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ULBX1ZNC; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9T6X9024759;
	Wed, 17 Sep 2025 17:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=JNLgvaG7W5x/ILlp7i3J82r72ZudPtL9qm5Oznk0Xxk=; b=ULBX1ZNC
	1Ib2WrR44HJODoresxhElxNj0SVk9x8EPpM4fdaAUbBTQC/kouDOWViEWcgJbypU
	HX3TchulDrs3SYj8UEyqU5HsVK7b0pRWBdg1Cgc7/386+NlXSYHMvUKmmjJBXoPv
	Te80AX/yqzLn8Guhcn5Qb62uTQeItcy8UvsyrFr/3gLF0sjyQdPVfetvnf14B2PJ
	JIqXxQ5XlfHoSXXd9xydeu//+O0bQpycmApYrQ2HVStUmW3Ly5Va0ZCQzauDN5IC
	fGDoibMYa3k6TpWZcSLUMzHWAxE1TXuwVd1jKUWR/A7cvwByw7v52kIBBFXLVhdv
	LEUd9wRvbWwDqw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qn11j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:34:34 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58HHOFUW010559;
	Wed, 17 Sep 2025 17:34:33 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010049.outbound.protection.outlook.com [52.101.201.49])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qn11f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:34:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+q0kjdD/wqWKz67SUmnVLAdVGY+3QpntpTnz/zauOlOGkQP0JxRO+7wAro5dMRFDSdWjaRAvnGRwuHHI1NNporEwiD8vBlJE/rdfIO3VE9lVhIaA5y0sPo01QTu9Wrc3c8yB8o1GdTwhq4gCNxz5MCM1b1J891zXbOsOz5GL4w6FHfijpsydXGCcw5QDH/awvDfFdf17wWvPm+WVgdJSRUsTgK3z8sjLq05EVNAmtO5hoZlw4+sX1LLcS60X5JXqb/S5kJ//AltEHXUrpAZ/xrUzcOHCOq/nJuTHZ+GOYbiH6qK5hrWwa3Tei1sZk5QLpc5nOyZ21OKWaJo4C+1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNLgvaG7W5x/ILlp7i3J82r72ZudPtL9qm5Oznk0Xxk=;
 b=IseAvnHRfVaRM/qSs3Bz7AazDbA/lIbzXoF2sK4UjYWluCmKNOl+pjmxJLZ+wevuuFPtSYRNKQS2//aYdtEq4Z0+yoy50rLjLGHxqnKmUOlRsqHAGHoGCJw58VchI9+8C5CyrUBVI5Vg5NMfQg/ioqeg2sgkittc1iv5Wn7RWL7hwzt03yw1q+pTlcsBlw+OxIb3JxXfvGm6lvV1Ow1dUdZSAaaiaTNRmtC8jd58dRfy7IW70otylA6dWVNk80eSlLEQe1bbK7Rs52s+UHQGd37pd7KNya8kUyI9Dd1SmTXP01YOY8ZiNHgOIxz75qELy5VfiWTYLWNXdYNL6VQB+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4990.namprd15.prod.outlook.com (2603:10b6:510:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 17:34:30 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Wed, 17 Sep 2025
 17:34:29 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "seanjc@google.com" <seanjc@google.com>,
        "lyican53@gmail.com"
	<lyican53@gmail.com>
CC: "jejb@linux.ibm.com" <jejb@linux.ibm.com>, Xiubo Li <xiubli@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sboyd@kernel.org"
	<sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [RFC] Fix potential undefined behavior in
 __builtin_clz usage with GCC 11.1.0
Thread-Index: AQHcJ7qN40myisAgqESBOssMDrJb57SXoy6A
Date: Wed, 17 Sep 2025 17:34:29 +0000
Message-ID: <1c6b3cd74e303fa8ab8b4853986fd4cb8c7c8541.camel@ibm.com>
References:
 <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
	 <80e107f13c239f5a8f9953dad634c7419c34e31b.camel@ibm.com>
	 <FF69D584-EEF9-4B5A-BE30-24EEBF354780@gmail.com>
In-Reply-To: <FF69D584-EEF9-4B5A-BE30-24EEBF354780@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4990:EE_
x-ms-office365-filtering-correlation-id: cfdff2db-4d9b-4238-c606-08ddf61074d4
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bU5TWDdzbW5ucjYxMzQxR0JicmprUXIwK3NpNC9uTmphL1Z6QW9hZHlPVjRv?=
 =?utf-8?B?emxzSjdyY1g4cGlTcVBoNkFMMXgvaDlHTUVJN3dOdFZYMTIvYkhjTloxSnVD?=
 =?utf-8?B?VXpmTkN4ZkdTcEtaZ3VhNmJhSFBLb0NFMlZ6SEgza3BjYjNMaHpmbmZaRzBV?=
 =?utf-8?B?MnNVRzdIMnFMSnZnZlpIYnd6MkhJczJ3TTYxcGpZdThZdk9YZ1ErRThqMlJM?=
 =?utf-8?B?WHp6djV0bzU2bHkxd2xpOC80dFBUYzFTWWtkWkpYUStIMnZkMXFsKzNoQ2Uv?=
 =?utf-8?B?eG91Q3RBUGxrMDZ0eFRDMENMVE0zOTRwSkR1S2JRZ3padDVHbG5qb0E2SXRw?=
 =?utf-8?B?Z2RvelNEclpIVFRzL2JrU3paWWJsUGtDR0VLMkFCeVRLS3BmdEpNMXYvZEVM?=
 =?utf-8?B?ME02L1pFZmpvSFlWZENFa1MzVFI3cEVMZEx2NFlrN2xISzJsd2dTWnVUYWZa?=
 =?utf-8?B?S3gyNWFabWdRWnJHeXFkTjdBZllJMkUzK2xXK1B5QUdqRTdqejNNWThXZklH?=
 =?utf-8?B?SU5IYTZ1TEIyN2JtTER6TmdGVGN1c0JBcHR2U3daa3pLYUJ2bjVXSFBPcFdw?=
 =?utf-8?B?ck5vZ3JVUVFPRzVtYUprUWtBVTFJYytQOFJ4UGJuWXNSelhPRlJvSkVZVjVt?=
 =?utf-8?B?c2pTakxDbXY1S2d1WmZnb2l5ZVEycnRTam96L3VoU2tPckkvaUxJUXVvQjB5?=
 =?utf-8?B?c2kwY2lNbTF3dG1sNHdseFQ0WFJ3ejdSUjI1aFMza1ZEYVVDVFBVd3BwUzht?=
 =?utf-8?B?S0hIeWFSY09raFM4QUZyVHQxMGlhekltNmtINWlOTGNNbUFtZHF5UkJ4aGVD?=
 =?utf-8?B?UjE2QVZmTTQwcWZMNEpOL3RNZFM4cFNVRGROTDc5THZrelE2Yk5yWVFwcmxi?=
 =?utf-8?B?MlpzaDAwbTFUMXUwNVkyck5rU1ozelUxOFgyZm9hQVYvZmtQWStLa3RaQTd1?=
 =?utf-8?B?VThPUG5xeXBLUnpvUHZSR3lJc2VHdWJWendyS1FrbjNSaUdBRG5wU0VVWFdy?=
 =?utf-8?B?dWFnYzR0d05leFdUNjV6RXk0emFSU3g4OTZqWEdkZDVsTURNQWJhZ0xhQzBT?=
 =?utf-8?B?aU5PZlRZVnlZZGZxWDhlS0tHOUcvK1dnaTZWSUQrZ0RLM1RHNXFlcWJIOFN2?=
 =?utf-8?B?RS9CWjdrTUFoODc0SzdhcDgzM1ZPbEE0M2J1MHp1Z2hUTnNTNnM4TjE0eW5r?=
 =?utf-8?B?eEh2UFM0YlBXT0tyRGdyb1lIdkpsc09lNXFPeENVNGtVdUd5R3gyNDlieS9x?=
 =?utf-8?B?UEZUNzBCdTREamZCTGZwVDYzd3UrbkNGUW1MSUQ3Y2Qrd2N2TVNoVUdsR0l0?=
 =?utf-8?B?Nk5DYno2QUVUK1B0N0g4RVdyWUN1dDJlK0p0WFlVU1pYWHAvUm5JM05YUHhE?=
 =?utf-8?B?ZGY2L3QzUUhLWDArRmh4NDlIbld5czBZRnNNa1VReTlzYWxWNU1tK21ZV2xu?=
 =?utf-8?B?VXFGQjUxbGRQalJiTnNoWS9pcUg5S0hMTXo3UEhtY2lzZ25xVnl5S3lFVDIv?=
 =?utf-8?B?QkFLOGZDN0w2cWxUSmhFRFhtZDJPSVkxSFZvUDJTZ1UrMjFmUDM3MlV2Wngr?=
 =?utf-8?B?ZThNdWxWakxpSjJ2VXJ2V3ErZ2pJSE5WR1Zwc3RrZ2pZOEdVbG1Sc0ZPVmNZ?=
 =?utf-8?B?dks5T1dYOEt1SmNtVDNVWk00SU1TTXk3dm8wd2tGZVI4R1daTzdxTUx6K1Nw?=
 =?utf-8?B?R3lMcHd6VGxicGgvdDhQc0RFSmZxU05xMFNmZ2Y1Wkg1VTFyWnUrVmFEOTRL?=
 =?utf-8?B?MERjZTFDZkJ5ZnJ1VEJHaWREb0JRWmRTK25Pem50ajNQRWlWdVRLWm5WRWZM?=
 =?utf-8?B?VmVQUVpNTHovc09scXptN3hsbWluZUxsOHZiQ2ZKOWJiQnEyQU9rWWFqWHZX?=
 =?utf-8?B?ZCtpaTZYbDNLYmw1TGpSME50anpKWk91Z1RQOGExU0ZQVzF2bFUyekpVM0pR?=
 =?utf-8?B?VzdKUk5seWUwTVpYYmJwM2Q0V1cwSnJIc2hjTzNXYUxYZXUrRmFkM2pmbi9Y?=
 =?utf-8?B?RUl5Y1F4VXBBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkpwalVpeWlGMVZKbWExQ3pTTUErNlg5K1JkSUx5NXJiRHRYS0NCMUtqUVpR?=
 =?utf-8?B?S3FDQm5NQ1JDYWlGV3VyK3RqMElpOEQ5aDVTY2ZSdTNXWWtnTnFuTHRtbkxO?=
 =?utf-8?B?S2c1TjFabGwwemdweVQwZjVybEMzVUlZaWhOZjJrZzRtRDFSVDBobU5aMllY?=
 =?utf-8?B?Y01XbGcwWUtuRDA2QmwzUXZpcUdDMkdtWUpLZzl5R0dhYkR5UmpuUkdDYWF2?=
 =?utf-8?B?T096TjJEL1huWXJDNmV5ajRmTU9CbWR3S3JrUFN1TlRTT1JwNmJReUhoWG1w?=
 =?utf-8?B?cmdOVGVKVml1Q1plTkZ5K0svOWtNWEFnQlU4dTN4VkE2cmFraVFydXZYYUtL?=
 =?utf-8?B?MjlzbHA1MXBhWEJvMlJIMjh3MlFmRHFkZFRROEkzZUpLaTFjb0pqdkRSbTlv?=
 =?utf-8?B?SkwzNkpSZHF0dGdCaW8ydFNMZ0hvaXpUamh0OFhNbERlb2ZvWkF6bzZmYmRx?=
 =?utf-8?B?Ym50K2tqZVIwdmpGeGlHWG1FQjE0Vno2Yms1a2tlb0hyQXhhZHlxMm1FQ2ls?=
 =?utf-8?B?WWRUMG1vbFVJUHh4K1BKbTB3bGZTYzR1Z21ZWExoVER5UEQzMzJZREsvdStl?=
 =?utf-8?B?d2p6ZG1pV2pZTFpadTNMZHMwdVNQNkc5VlpJRnZTaWpNVHVZaDY5Y2pMd3J0?=
 =?utf-8?B?SzRtMGdpY2w1azZKOVR4NERBSmtjY2RmUjZES2RwTDBXMzFwNFpCRjAyK0ps?=
 =?utf-8?B?UDd2b3Y2UVdMalVuMDhmMk1OSkhBRlZkVGdPTDlDNVZoOWNHTjNTZ1o2SC9z?=
 =?utf-8?B?czBPWkE1TkZZb291Yk9zTmVMWFZrc3p5a2gyRmYySzBoUGJpR3hXRDRhYlUw?=
 =?utf-8?B?UmZPVFZIWkpIN2ViNkloN3Qxbko2U1laUTF4T0J4R2N0aFVQTUd5aUxQbEVY?=
 =?utf-8?B?QTkyU0JLR25HUjZnY0t1L08zMkVKdmJENytsKzNhZW54RGdBeUw3UXlWSzcv?=
 =?utf-8?B?MGFoTzhzUS9FWVpqZFZEN0R1MXNVbEZNOWw3TWtQTHdXL29hc2U5djhWaEtL?=
 =?utf-8?B?eUtVVFk5OWdLbHZtZEFsUklBU2tUTTJsc3paT1FMcVZLaUlGRFVOZ2RLSzNz?=
 =?utf-8?B?ZUpmOGpyUU53NmU2NSsxL09BTUpja2lQY0J0VXFZb1duWHZHeTFFdXlMeldn?=
 =?utf-8?B?ajBZWmRVc0RVRnlqSG9lTGRJbHJnbloxTmNHNjZvM3ZJUE9EcUNQeWd4c1Jp?=
 =?utf-8?B?U2xEdXR0Z3Evam1WallTMEttcElaTlUybVhSelJCUVlsVVVWdk93RUJDMzV6?=
 =?utf-8?B?dHk5VlR1dXl3MUlIVkV4VTZ2THBxcWZnT1d5Y1MvRld4aVYwSWlaSXBSSTUv?=
 =?utf-8?B?NjhkcjBqZDV6N1dyclpGeUFrK2JEQ3BFeEdSaW8wRXZiblU1Vk9wWmFGNUNZ?=
 =?utf-8?B?N0diNlR3ZWZoUUFEUFZuRVNoMG1yVnZBTE9HUmJtaXR4Y3ZPSWNNOHpESGJF?=
 =?utf-8?B?WGtjM3c0ZFlTUFJrQ0lZdDVmOHFJVzlmYlhwQW1tQUlMTjVINUpHOG1vMFAw?=
 =?utf-8?B?ZWYrR3ZjYXMrUlliVER6YWtPMnpDbDgrdVRjUTNta2lNUWJpYytyT1grdHha?=
 =?utf-8?B?Ri9vamlJUmJXY0xpaDFNaFNZNlV4c0dLZU9vUXZRZlVFQVVqNGt2YzBrczlD?=
 =?utf-8?B?SkRCK1FGZ2QybkdiaWQwd2ZwS2hyVm9BVkdYY3h0RkFidnE4aEZRRVdZRlZN?=
 =?utf-8?B?S29pc1hmc29tOXZ1YjZXZngwMWpIa3p4N1U0T1lPR2VZSURTZkRyQXg0OTEy?=
 =?utf-8?B?STNGTE5mR1FKRVUwM2FUTS9JbDgrOEFhd2xrcEFlTUpZbFh5eG5HTVA1MFhw?=
 =?utf-8?B?UCtFRjBvRHJsa2NkeW56ZlYyQVA5VXJXY3VSK1BHSk9RbVh2T1VIc3lrdUNr?=
 =?utf-8?B?cjdqY2crRHFlb3VsRVc2RDI4c205SlQ2OWgyMjJTSU0zNjRmS1Y1Z3FGTy8w?=
 =?utf-8?B?ei9JM0dNUURGUjBmMzdva0Y1OGR6Z3Z5aGdTOUlscllpaVplSjVqTnpnY2tp?=
 =?utf-8?B?Q0JSY0NDUTVhLzNJMUxSZU1XVDhFc0hHMXJvdFZOaGlBZGY1TWdiTTFjbFdm?=
 =?utf-8?B?SDlQeGhZeGFOTWRkRDFQTGxUNmR6b0N2YlZCZ3RPbDg5Uk5KcmZqQkVrcjNj?=
 =?utf-8?B?UmFoQ1RoMnhndEM0Sm8vdHJ0MnlPRmdscVNHQXZGbXlCcEZtRmFsenlkVmkv?=
 =?utf-8?Q?/YjVEgN46UwEcMnj5TW1wKc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0381E871DC88748A900FC80149100F6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdff2db-4d9b-4238-c606-08ddf61074d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 17:34:29.5848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +QTpz+HmgmcU+JZGQ0F9GZgJkkYXygxFv8tgoqhpjlSynbg6Xk8XQ8hIIRRPGHcZEsR6wQtsGrY0ACBdf+C4lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4990
X-Proofpoint-ORIG-GUID: c9x38newTd40aVV2DnCcW41v5NxlekzM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX/TcGvsVjJ2QF
 PWCjw3OwYnZDXAHs1VhK4TdB0PEPCMviF/DKN1s8Yyeo+48pdj0Lc4vGIeYlUK5Rp3YPIV0amwJ
 9TMPo5YMNNZpJKkPzulwM1Lw1qvJL+K7Nte7pqVdV6cVWwevTpVUQoDQKS6zSzjaYewk1zg/kYB
 JVmmVgCKrHJjjgEvWwSGYClUCiezLy9IGfKPWWQs8Sqb16BFhp1PZQEdzUY9rGetctFrBre6atb
 jFf9fzYXvUmMmgNM2iVPZ0ncwDzxobVq3D/xtdwt0GsBaeIYq4LAAoxrn6OlLycX4bMGya78+Bi
 g/oVPwuE0VKkLBK09hn/ADoKiN6E0p/iKvOT7a1HbgY32NjWhAgz/JZA71as/eJ091oHp7L8ZZs
 xw06gGNt
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68caf12a cx=c_pps
 a=Gv32SYzo0qTo49aZOIuVGw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=pGLkceISAAAA:8 a=MOF353iUi4_pyoSSqBcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: pRIW852nNtJTUlXLI0wqK3nUBjeVq3Na
Subject: RE: [RFC] Fix potential undefined behavior in __builtin_clz usage
 with GCC 11.1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

T24gV2VkLCAyMDI1LTA5LTE3IGF0IDE4OjA0ICswODAwLCDpmYjljY7mmK3vvIhMeWljYW7vvIkg
d3JvdGU6DQo+IA0KPiANCj4gDQo+IEhpIFNsYXZhIGFuZCBTZWFuLA0KPiANCj4gVGhhbmsgeW91
IGZvciB0aGUgdmFsdWFibGUgZmVlZGJhY2shDQo+IA0KPiBDRVBIIEZPUk1BTCBQQVRDSDoNCj4g
PT09PT09PT09PT09PT09PT0NCj4gDQo+IEFzIHJlcXVlc3RlZCBieSBTbGF2YSwgSSd2ZSBwcmVw
YXJlZCBhIGZvcm1hbCBwYXRjaCBmb3IgdGhlIENlcGggY2FzZS4NCj4gVGhlIHBhdGNoIGFkZHMg
cHJvcGVyIHplcm8gY2hlY2tpbmcgYmVmb3JlIF9fYnVpbHRpbl9jbHooKSB0byBwcmV2ZW50DQo+
IHVuZGVmaW5lZCBiZWhhdmlvci4gUGxlYXNlIGZpbmQgaXQgYXR0YWNoZWQgYXMgY2VwaF9wYXRj
aC5wYXRjaC4NCj4gDQo+IFBST09GLU9GLUNPTkNFUFQgVEVTVCBDQVNFOg0KPiA9PT09PT09PT09
PT09PT09PT09PT09PT09PQ0KPiANCj4gSSd2ZSBhbHNvIGNyZWF0ZWQgYSBwcm9vZi1vZi1jb25j
ZXB0IHRlc3QgY2FzZSB0aGF0IGRlbW9uc3RyYXRlcyB0aGUNCj4gcHJvYmxlbWF0aWMgaW5wdXQg
dmFsdWVzIHRoYXQgY291bGQgdHJpZ2dlciB0aGlzIGJ1Zy4gVGhlIHRlc3QgaWRlbnRpZmllcw0K
PiBzcGVjaWZpYyBpbnB1dCB2YWx1ZXMgd2hlcmUgKHggJiAweDFGRkZGKSBiZWNvbWVzIHplcm8g
YWZ0ZXIgdGhlIGluY3JlbWVudA0KPiBhbmQgY29uZGl0aW9uIGNoZWNrLg0KPiANCj4gS2V5IGZp
bmRpbmdzIGZyb20gdGhlIHRlc3Q6DQo+IC0gSW5wdXRzIGxpa2UgMHg3RkZGRiwgMHg5RkZGRiwg
MHhCRkZGRiwgMHhERkZGRiwgMHhGRkZGRiBjYW4gdHJpZ2dlciB0aGUgYnVnDQo+IC0gVGhlc2Ug
Y29ycmVzcG9uZCB0byB4KzEgdmFsdWVzIHdoZXJlICh4KzEgJiAweDE4MDAwKSA9PSAwIGFuZCAo
eCsxICYgMHgxRkZGRikgPT0gMA0KPiANCj4gVGhlIHRlc3QgY2FuIGJlIGludGVncmF0ZWQgaW50
byBDZXBoJ3MgZXhpc3RpbmcgdGVzdCBmcmFtZXdvcmsgb3IgYWRhcHRlZA0KPiBmb3IgS1VuaXQg
dGVzdGluZyBhcyB5b3Ugc3VnZ2VzdGVkLiBQbGVhc2UgZmluZCBpdCBhcyBjZXBoX3BvY190ZXN0
LmMuDQo+IA0KPiBLVk0gQ0FTRSBDTEFSSUZJQ0FUSU9OOg0KPiA9PT09PT09PT09PT09PT09PT09
PT09DQo+IA0KPiBUaGFuayB5b3UgU2VhbiBmb3IgdGhlIGRldGFpbGVkIGV4cGxhbmF0aW9uIGFi
b3V0IHRoZSBLVk0gY2FzZS4gWW91J3JlDQo+IGFic29sdXRlbHkgcmlnaHQgdGhhdCBwYWdlcyBh
bmQgdGVzdF9kaXJ0eV9yaW5nX2NvdW50IGFyZSBndWFyYW50ZWVkIHRvDQo+IGJlIG5vbi16ZXJv
IGluIHByYWN0aWNlLiBJJ2xsIHJlbW92ZSB0aGlzIGZyb20gbXkgYW5hbHlzaXMgYW5kIGZvY3Vz
IG9uDQo+IHRoZSBnZW51aW5lIGlzc3Vlcy4NCj4gDQo+IEJJVE9QUyBXUkFQUEVSIERJU0NVU1NJ
T046DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gDQo+IEkgYXBwcmVjaWF0ZSB5b3Ug
YnJpbmdpbmcgWXVyaSBpbnRvIHRoZSBkaXNjdXNzaW9uLiBUaGUgaWRlYSBvZiB1c2luZw0KPiBl
eGlzdGluZyBmbHMoKS9mbHM2NCgpIGZ1bmN0aW9ucyBvciBjcmVhdGluZyBuZXcgZmxzOCgpL2Zs
czE2KCkgdmFyaWFudHMNCj4gc291bmRzIHByb21pc2luZy4gTWFueSBfX2J1aWx0aW5fY2x6KCkg
Y2FsbHMgaW4gdGhlIGtlcm5lbCBjb3VsZCBpbmRlZWQNCj4gYmVuZWZpdCBmcm9tIHRoZXNlIHNh
ZmVyIGFsdGVybmF0aXZlcy4NCj4gDQo+IFNUQVRVUyBVUERBVEU6DQo+ID09PT09PT09PT09PT0N
Cj4gDQo+IDEuIENlcGg6IEZvcm1hbCBwYXRjaCBhbmQgdGVzdCBjYXNlIHJlYWR5IGZvciByZXZp
ZXcNCj4gMi4gS1ZNOiBDb25maXJtZWQgbm90IGFuIGlzc3VlIGluIHByYWN0aWNlICh0aGFua3Mg
U2VhbikNCj4gMy4gU0NTSTogU3RpbGwgaW52ZXN0aWdhdGluZyB0aGUgZHJpdmVycy9zY3NpL2Vs
eC9saWJlZmNfc2xpL3NsaTQuaCBjYXNlDQo+IDQuIEJpdG9wczogQXdhaXRpbmcgaW5wdXQgZnJv
bSBZdXJpIG9uIGtlcm5lbC13aWRlIGltcHJvdmVtZW50cw0KPiANCj4gTkVYVCBTVEVQUzoNCj4g
PT09PT09PT09PQ0KPiANCj4gMS4gUGxlYXNlIHJldmlldyB0aGUgQ2VwaCBwYXRjaCBhbmQgdGVz
dCBjYXNlIChTbGF2YSkNCj4gMi4gSGFwcHkgdG8gd29yayB3aXRoIFl1cmkgb24gYml0b3BzIGlt
cHJvdmVtZW50cyBpZiB0aGVyZSdzIGludGVyZXN0DQo+IDMuIEZvciBTQ1NJIG1haW50YWluZXJz
OiB3b3VsZCB5b3UgbGlrZSBtZSB0byBwcmVwYXJlIGEgc2ltaWxhciBhbmFseXNpcyBmb3IgdGhl
IHNsaV9jb252ZXJ0X21hc2tfdG9fY291bnQoKSBmdW5jdGlvbj8NCj4gNC4gQ2FuIHByZXBhcmUg
YWRkaXRpb25hbCBwYXRjaGVzIGZvciBhbnkgb3RoZXIgY29uZmlybWVkIGNhc2VzDQo+IA0KPiBR
dWVzdGlvbnMgZm9yIG1haW50YWluZXJzOg0KPiAtIFNsYXZhOiBTaG91bGQgdGhlIENlcGggcGF0
Y2ggZ28gdGhyb3VnaCBjZXBoLWRldmVsIGZpcnN0LCBvciBkaXJlY3RseSB0byB5b3U/DQoNCkNv
dWxkIHlvdSBwbGVhc2Ugc2VuZCB0aGUgcGF0Y2ggdG8gY2VwaC1kZXZlbD8gWW91IGNhbiBhZGQg
bWUgdG8gY2MuDQoNCkkgZG9uJ3QgcmV2aWV3IHRoZSBhdHRhY2htZW50cy4gOikNCg0KVGhhbmtz
LA0KU2xhdmEuDQoNCj4gLSBBbnkgc3BlY2lmaWMgcmVxdWlyZW1lbnRzIGZvciB0aGUgdGVzdCBj
YXNlIGludGVncmF0aW9uPw0KPiAtIFNDU0kgbWFpbnRhaW5lcnM6IElzIHRoZSBkcml2ZXJzL3Nj
c2kvZWx4L2xpYmVmY19zbGkvc2xpNC5oIGNhc2Ugd29ydGggaW52ZXN0aWdhdGluZyBmdXJ0aGVy
Pw0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBIdWF6aGFvIENoZW4NCj4gbHlpY2FuNTNAZ21haWwu
Y29tDQo+IA0KPiAtLS0NCj4gDQo+IEF0dGFjaG1lbnRzOg0KPiAtIGNlcGhfcGF0Y2gucGF0Y2g6
IEZvcm1hbCBwYXRjaCBmb3IgbmV0L2NlcGgvY3J1c2gvbWFwcGVyLmMNCj4gLSBjZXBoX3BvY190
ZXN0LmM6IFByb29mLW9mLWNvbmNlcHQgdGVzdCBjYXNlIGRlbW9uc3RyYXRpbmcgdGhlIGlzc3Vl
DQo+IA0KPiANCg==

