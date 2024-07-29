Return-Path: <kvm+bounces-22520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D63A93FD16
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 20:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BAC428315E
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 18:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1DF185606;
	Mon, 29 Jul 2024 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fKgMa1d7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M0kUNnZh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E96158DC6;
	Mon, 29 Jul 2024 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722276249; cv=fail; b=K1xT3/E778oWqW1huNrJU5qCQYN4rBVtK5LCwfxs7J44Qp26sHoTmMwE4ylZj1u/mABp8ALA+TUHpbQTr4uKGo68zJSAStzpAhZ3tO8iwB+nMc2wnq/MWYCZg37xoCANc8E+34wLFKPWiFsOAhcy4PNGwYUM6EXYS2pdXez0k9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722276249; c=relaxed/simple;
	bh=um3N/OoTBF9lzkzbx7IEvv0JtNe0JAiPmLP+g2p812c=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=KaA6RfdQz5EH8Ux5BxsPTwZYJ5H03WTEcThMuFwG/Kqs5Ca/tB7K3wewCK3dl1HdRfGk2q1PPIXf03qo0RrWrwDPwGhl389hJ6L3qBzkkPYAvBLR1W1IwQ2WiQgkvwy39yhqsrThM8C1m+/Do7/hEtdZzfd1HdzEf3PM1NMV/Zc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fKgMa1d7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M0kUNnZh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46TFMqfk020491;
	Mon, 29 Jul 2024 18:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=cGsVhOMONEvxwy
	tK3ZFADhkaWToZ+9VbxUvCho/1EX4=; b=fKgMa1d7fb/fqNmmmaJT1ct4fweSfI
	+EccE5ertj54aTSkv4dj8aQdILmFfA39cgi/cPQYVBlDNH0H07tKpBVmc5qs9BJu
	XlTIxua0DVe/PkbOjp4XRdssbzHti+WvhHy/bpVla5iReliIxSzbeudcbZqPae56
	cY85q3DD4XbvqjuSj25xHaEgPaFBYetj2nmLvtG38d4rXQmu+0IUpWrjvVqO2WWG
	GX++qQQ8gga0NELjObZolirtbiXYw/E4FrhXIOwn8uIHqF3cPPpur1AIkJ8LIx3a
	u97cJxB4tjXIJMHE0cwWApzEQLOHsjSZjsh+ntdmrppF+LU+DTlLraMQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40mqfybahm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jul 2024 18:03:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46THIgcL012271;
	Mon, 29 Jul 2024 18:03:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40nkh5ja23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jul 2024 18:03:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sbdyNWp37pjR4XBCHbEGSL2qY+S/KccXc9Qxy611mQD3BTY9afr+8KZHQw/dB+O5OVYL2KhIStBJSJMWMyj6bpsly/4cEOC6vKoGIEcxyPxpjkdzZYxffP38uEbImn4XijqWuFycEuGvoOVV51xqyqVaUYZHYZJHtzkxxGFKW3pBZD20V6ELczHxGKrdd6K26dawV3R1/ttNSbayNx/9fopafYavcf3k03Hi0o48wAFRq8uRwKxvNb/3bOlK+MevLij4dO5I9SBwSX/EGFfzo9W4U7EoHDioqdchrOKqoCjTsb0GiRayyjfE1pi24HfjTlBjloHE8nnAo9HD94KnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGsVhOMONEvxwytK3ZFADhkaWToZ+9VbxUvCho/1EX4=;
 b=RzkT5fh1trzOFDoaxMMMYpSa6t2DoJww/s3wNhaQ8i+56vunL1Ds86Jj/rN1/oiWdUMFN6Luhu0cPN5zTOyNn20yP1OQMh622n2o2A9SbXjwPPhEpAyEGfOU4/FDyHdtw0SpAP043FylYiwSTwG18QMCMHKsmsSROW2LmAYduTxSbPJPLVdUzOXL+1Qff1BZBg4rcbv4u+GjMDEvuLEwZIzTL/o5bDN9glcWFTg4zfcwvLalirHQ7+3f3cTEXC4bJa1GaO1zGcKVttr1MbW5wUVK9/ErrMSuf3CkZLJP4PPVHVOQDGJrKxdEduWQ152c8XfWsIRKzLxQFRZ40eDqEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGsVhOMONEvxwytK3ZFADhkaWToZ+9VbxUvCho/1EX4=;
 b=M0kUNnZheNEq5liwbfcRUwkfoISXifWMBc2yhfYu8CrLe7aR0bau83DLNjp8jJnoLOYM24VhwXwhEQg2e7hDxqSZfxZa4MAqJ7GOkXefmDxCJrQO3PaRNuUnIOwK8QMnxAvTlsuFElLXWR8e9subP9EPVeB+lyiY+/CkVN9CwKk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BL3PR10MB6114.namprd10.prod.outlook.com (2603:10b6:208:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Mon, 29 Jul
 2024 18:02:48 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7807.026; Mon, 29 Jul 2024
 18:02:48 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-7-ankur.a.arora@oracle.com>
 <5ba1e9b9bba7cafcd3cc831ff5f2407d81409632.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "ankur.a.arora@oracle.com"
 <ankur.a.arora@oracle.com>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "cl@gentwo.org" <cl@gentwo.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "pbonzini@redhat.com"
 <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "arnd@arndb.de"
 <arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>,
        "will@kernel.org"
 <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org" <rafael@kernel.org>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "mtosatti@redhat.com"
 <mtosatti@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
In-reply-to: <5ba1e9b9bba7cafcd3cc831ff5f2407d81409632.camel@amazon.com>
Date: Mon, 29 Jul 2024 11:02:46 -0700
Message-ID: <87ikwors8p.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:303:b5::17) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BL3PR10MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4e43e8-fd4f-42c6-a844-08dcaff8a7dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wMt1CMXxjmPqo38jH4rFMAbG6ju4x2TTYsRimI6mEjAo8NidHBcAFKkhuuse?=
 =?us-ascii?Q?VrRraTT/dsSdGQm8NVSIHB4KoCkHSvpuCLcnAoEEPFtKpZzoFJtHj0FJRnnt?=
 =?us-ascii?Q?NQs3RhJlLoAUWizBQvY/mCXUB/nHJ7+fUJawfXtCTgIUO5QWcvXPYC5/9Ndl?=
 =?us-ascii?Q?rn04cCDtTgsXYgrTSv0IPdn+OleR1SmE0q+xoGYQZfnhuD13ZHTk7sg+wIl/?=
 =?us-ascii?Q?N23hIx8DNt6MA9FJRkpjqDIPkSP2qhD3j7mZWpY6aXfagxovGvWA6x81ughT?=
 =?us-ascii?Q?TMU1pqsN+VV0NTTnbJxqvZK+kRqkSZUa9sjNuVDhxnzvUgbsIVAjyh3VSr95?=
 =?us-ascii?Q?fTBzQ753vrzIPduJEvID9eBMa98LuOcJSkMFy9MFSP8cDR2QuVyCsqeC58qJ?=
 =?us-ascii?Q?M3OXqAGud5DCHokGxQ03BWEn2rQmhG9MLMjjGAhBe5ZyYj1w+GBRa1dzuYFH?=
 =?us-ascii?Q?ElU7+uVSI/Wj35zqKS5Jbovw4A5KXgAeHgAaRvOjLENp43PzYk7xQ07y4OVA?=
 =?us-ascii?Q?CUjoQChaLTHCESnAbnHRyTiCzJVrpbaCZYJq12hNt4bxncXGPPhAyE532XFx?=
 =?us-ascii?Q?ttBGvCR+iSNSE2o3GIY3n+WKOXBeYCbCwj+TGYF13iCFr78DN1UJTv/mffqR?=
 =?us-ascii?Q?c0PAYirCVP3UsTCZuzWkn+hSejhluHaHaTw0twzBsTBTlOGYDlMTbDqufnMt?=
 =?us-ascii?Q?HNNRB0guNQ1i5lmpomDZ9RAtcM7ATbnUzJDHxI0i5BdiXCPRft2lJJMxz83X?=
 =?us-ascii?Q?tQ+Uqb0nWhGIQ6Weygps7MKJM/HQGTN/FZNEyjHjceGElsxNJUQIxS0hEnnX?=
 =?us-ascii?Q?ny+RI0Luk6YBz3IkEcaHe9hFHoWVENiYACZgSXCb2tMxcDjUO/GJViNxwtML?=
 =?us-ascii?Q?OHRaaSyybR8eKVa7af24O9qqB0zHwOyIqV530wettl1Ws5tc0Q6MNKKR9pr3?=
 =?us-ascii?Q?oLq2+zZ/ya54oLTRZtd+Y9IXE+ED3aVP1LiASIzMopNwcva7EMow19cxlNjq?=
 =?us-ascii?Q?Va+xFTVcVEMLZp0VbLL6puYVRxwGrk4WLGRHFlUeQB3F9Gm1gilvq8dSkQQP?=
 =?us-ascii?Q?urumI8MYljoSyd/iQkaWPTOb1c+0VxGo8a8n7tmg2AeXsyNI7lM2nS8jZJIA?=
 =?us-ascii?Q?nZwaHHvAoE7Zs9r87e/14MpTIxBfdkROP/oaF5Rb2KkFdE/JKU6dpTsnw2Gz?=
 =?us-ascii?Q?28JF+6Kbdg+9foCgPHdwUmMeg7hcGJMLPnF4X0dz/9/4J3PBeORZ9qFK8ktN?=
 =?us-ascii?Q?23H4/vprg8MCmymDwA5pEtbVVq8RPYCMQdNjV+xmZWtyup7SlH6WBk80MIxt?=
 =?us-ascii?Q?NRZR4VEn6MSHIAOZBJZZ31Rqr4pFNEpTrenb0hLxnpPz7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U/6Z41fZNAwmSqEtCVnmq/9lsOdx6JErgr6wXuev9Dwri3jkNH6PN8vih0bE?=
 =?us-ascii?Q?N2rfUFray74h4ClUY/kg1Ac+yQ93AFtSE4v8WTDPZFIAKz3+cdlQ89tGGj3m?=
 =?us-ascii?Q?jhNDBhgRbqXFdoCezSwAUjgJej/H5IgFoQGI1+5iK4C6FE6DqvEsKHNUsxo7?=
 =?us-ascii?Q?AW/VPZbCd0yGHLyew8bSt5tnRLdmxKSoZLyYt6LVpsYPSLZPveoFtf8h/IFf?=
 =?us-ascii?Q?czQFkJc2XPuKFR+Mjzy+X/JMjlWSRR49K4Wg9tpB+BUbZAdNhci7v98zt5lX?=
 =?us-ascii?Q?USe3Kx0smzovZemToWEz1FRh3Dn49HNrBqOKjuBxPVeyzv3abM4Ddgrx5ifG?=
 =?us-ascii?Q?rfQPVNw47CM8myESyfeLpsAMAor4Ztcole5RHE+SJqLcmzmJ+75Qvx5nev/w?=
 =?us-ascii?Q?77HRPAq/AgP+pa3FQC8be7a5zoJ4n6KDnFeEGNfC1FAZwoqzgNCPgFzYWdcx?=
 =?us-ascii?Q?CTOaiAUznCvvksIFdtThLEP/k4BNKEcHraANvjUgNs3tmmOY2sSFFgqkwQw5?=
 =?us-ascii?Q?TzTO8w9DQ/4SNEfAqbrh+FQPTZTQoetbiWaVG9RiFR/y7rDkTCtekzMRUUjU?=
 =?us-ascii?Q?XrV6sd8ZupIc7MctVS9bnB6YEPRKWt3q1YZKr4tWGcNJgyxFglycYD2Byf8y?=
 =?us-ascii?Q?yKDI8uflU+7Aino5GJRtXG5kvXXcrcJrxT3+3/ox3ZpdGR2ZcnVyLoEodkQg?=
 =?us-ascii?Q?TXPtSPZdhCe3YCZ8xaGkQCedxvoX0TULsqmSca3+tshjusPnxbtasUeaHwmy?=
 =?us-ascii?Q?LKtQZr/UxDa1XzihJvBUqGFJlIC5AfejVjhLQ+6NUPfJYxG+4YepnGrwlhmz?=
 =?us-ascii?Q?4zu7NCpafUQA2jgrj9z8wrhMo4CL/547nDmKkb7+YBZOXk8wmShhZZ3OwEA+?=
 =?us-ascii?Q?1xGoouXkDV8sGr0ldf0dQvgdghVSnKbTjyTxU6v2eERj5i659E1cyCnjKtHb?=
 =?us-ascii?Q?N1WoTFX8Mz9eKwwXAUJ9tIRiEZww+KLq1ztf45eZOEDRL9wP+SXRKbrCKOxN?=
 =?us-ascii?Q?OnDtoqgXFrlFGwhsitDMP1RUcHD8kZr66TFVbEIgpLTOL53v7t+sq9Ed3nZ4?=
 =?us-ascii?Q?Wfg4zPq6ldhoSdYaOLsqs/F2XIiElmKZk9KPw7ciasksVv7UGHAW1j+593z+?=
 =?us-ascii?Q?N1zcAAqfFi/w2uXX0wLQuAqan3GfZEeONevZ+vLs2j8I7fW7SEG/6mMSp8Vz?=
 =?us-ascii?Q?fcQzN5D2w57ag6JeY4beawzkCS6eCPuXa4igy8PffVUur8CHlvOMsNckjXLq?=
 =?us-ascii?Q?qucciOsiEWDDUx3QvZP4XkAP9aIblrlvu+kaKRQSmDdjcMtocPROxUUxxI0q?=
 =?us-ascii?Q?pLp+VKiulF3G3EzrW5nY8nfR+FObseAeTjdpT5taZbcm/m7vAjBgdd4FNiPi?=
 =?us-ascii?Q?uv+s6C81PlLa2Zi89MPvrVh6KcM5Q2CCHVgM3JdP1S7cjtY4G3NVao9fcfJA?=
 =?us-ascii?Q?1KG6AcU7rwJd3cmTRalqJgKkk7YJEc+pBWCdyiBL6rOOV5RWwPGFT7ej1gKE?=
 =?us-ascii?Q?I2fRuL10NLVTCoExWpdYo8eJULOv3UGTpKKOt3aYCgmAVJ2vMt4/QQCAx7uw?=
 =?us-ascii?Q?6XkEQ06Yug7LtjOoGgbN+19qHwxdNBirwf0saIPu7vDyRsSuT+sA02kLSeeR?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b3Qlv8WWb9f09mXc2Ch+dAStVYOeQE1VeIJWODBNQXQk5uAwMrZT15Bd+8NO93Jro7uVmcO8cu0sNICKB+28f6+nnAmzCyVuuMOjK7Ar0e2Ot8Y/BIXMeorh3ZgZuTDC/Xfuo1dyzILstXnOG4W+0fW60lt7al9NlW7S1zRZMAZuo7Pe1v5worRUBCHVHcVDq3pWoWPRHiXunzGMxDzoD15gw5z+7+SlfedI2pHfGOZ+ATL743lqkPrs/6/t4DsVE8mcBeQ5Ms9RV1UHJS2oYZOETI7TR5ILaNJTiOBwKkwS4PkXA1JKijlUxtMOehj8vPyGwm4PBYuRM3ntnErmGzC4ZYthlGzfo3YMwOY5/XLWYB+tgI11HbCXFd3Ia+t5ofAD+qQpA/VYpKhjhFUUebFdo8i/W0C6Nk2mM94UGnzsrs8efgOqmrGCONYmkcm7Ia5ybFuHCrKbCZMafg1QbeKIYZUFi5358r3pSUZ4Iv+nHENuww0PH48U24GxB/83ZRfCrkjb1XselFIOD5IN0nC6VVCj9l98uBNGi86c2FxA8bfvqLGYAxSF8xY9TlNsARh/vFczXRMcI+i19d5E6bLxztxgInRSR45Ju9IpauA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4e43e8-fd4f-42c6-a844-08dcaff8a7dd
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2024 18:02:48.4019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54SBI1tolZvtMANS5z6WXIizUhNwwfSmifFs7A6WMjU2TNdz/PXenplf6jYyU8+NtpQzptVkwbWrj1nFW/fXU32Ndd9aTNOH00ftjWAQsiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-29_16,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407290121
X-Proofpoint-GUID: ne5awkAc9zYQnwH8_G10JRBB3Yt8xfYo
X-Proofpoint-ORIG-GUID: ne5awkAc9zYQnwH8_G10JRBB3Yt8xfYo


Okanovic, Haris <harisokn@amazon.com> writes:

> On Fri, 2024-07-26 at 13:21 -0700, Ankur Arora wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> Add architectural support for cpuidle-haltpoll driver by defining
>> arch_haltpoll_*().
>>
>> Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
>> selected, and given that we have an optimized polling mechanism
>> in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
>>
>> smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
>> a memory region in exclusive state and the WFE waiting for any
>> stores to it.
>>
>> In the edge case -- no CPU stores to the waited region and there's no
>> interrupt -- the event-stream will provide the terminating condition
>> ensuring we don't wait forever, but because the event-stream runs at
>> a fixed frequency (configured at 10kHz) we might spend more time in
>> the polling stage than specified by cpuidle_poll_time().
>>
>> This would only happen in the last iteration, since overshooting the
>> poll_limit means the governor moves out of the polling stage.
>>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  arch/arm64/Kconfig                        | 10 ++++++++++
>>  arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
>>  arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
>>  3 files changed, 42 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 5d91259ee7b5..cf1c6681eb0a 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -35,6 +35,7 @@ config ARM64
>>         select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>         select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>>         select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>> +       select ARCH_HAS_OPTIMIZED_POLL
>>         select ARCH_HAS_PTE_DEVMAP
>>         select ARCH_HAS_PTE_SPECIAL
>>         select ARCH_HAS_HW_PTE_YOUNG
>> @@ -2376,6 +2377,15 @@ config ARCH_HIBERNATION_HEADER
>>  config ARCH_SUSPEND_POSSIBLE
>>         def_bool y
>>
>> +config ARCH_CPUIDLE_HALTPOLL
>> +       bool "Enable selection of the cpuidle-haltpoll driver"
>> +       default n
>> +       help
>> +         cpuidle-haltpoll allows for adaptive polling based on
>> +         current load before entering the idle state.
>> +
>> +         Some virtualized workloads benefit from using it.
>> +
>>  endmenu # "Power management options"
>>
>>  menu "CPU Power Management"
>> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> new file mode 100644
>> index 000000000000..65f289407a6c
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> @@ -0,0 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ARCH_HALTPOLL_H
>> +#define _ARCH_HALTPOLL_H
>> +
>> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
>> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
>> +
>> +bool arch_haltpoll_want(bool force);
>> +#endif
>> diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
>> index f372295207fb..334df82a0eac 100644
>> --- a/arch/arm64/kernel/cpuidle.c
>> +++ b/arch/arm64/kernel/cpuidle.c
>> @@ -72,3 +72,26 @@ __cpuidle int acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
>>                                              lpi->index, state);
>>  }
>>  #endif
>> +
>> +#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE)
>> +
>> +#include <asm/cpuidle_haltpoll.h>
>> +
>> +bool arch_haltpoll_want(bool force)
>> +{
>> +       /*
>> +        * Enabling haltpoll requires two things:
>> +        *
>> +        * - Event stream support to provide a terminating condition to the
>> +        *   WFE in the poll loop.
>> +        *
>> +        * - KVM support for arch_haltpoll_enable(), arch_haltpoll_enable().
>
> typo: "arch_haltpoll_enable" and "arch_haltpoll_enable"
>
>> +        *
>> +        * Given that the second is missing, allow haltpoll to only be force
>> +        * loaded.
>> +        */
>> +       return (arch_timer_evtstrm_available() && false) || force;
>
> This should always evaluate false without force. Perhaps you meant
> something like this?
>
> ```
> -       return (arch_timer_evtstrm_available() && false) || force;
> +       return arch_timer_evtstrm_available() || force;
> ```

No. This was intentional. As I meniton in the comment above, right now
the KVM support is missing. Which means that the guest has no way to
tell the host to not poll as part of host haltpoll.

Until that is available, only allow force loading.

--
ankur

