Return-Path: <kvm+bounces-15973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3834E8B2A11
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3947CB221D4
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF1F1552EE;
	Thu, 25 Apr 2024 20:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FPlKKW9I";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cwu0LeVo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71F72E642;
	Thu, 25 Apr 2024 20:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077967; cv=fail; b=Boni63osvPiCXpve2XVN93KeFV8arR+nZcaIh+y9FBl1wfPV2qPCjnmwFHrGUhAPRSq+ubo2L2u1CfRM0HsYvxOcLpkDW5tDo7r/x2XncngDXmpmESNVjleT0HnDShk1CSvFORy/LudYm1wi7xFdDfY0DLMZa9bbgjuNNpriRF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077967; c=relaxed/simple;
	bh=rE7BAvCDw3DLdqYJk7ZLPqw3+4j9BEyS16KlTLKJI0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C78EV8cBsvPSaDvieCxvbj3aWlGvyBlZ69yRpPuQ8vySFw8wKnuoZsfASJ0VJZXhkigGReGYFOAEVC+bu7hOhZCpUW/nprmNLd7SlMlqEYwrvQWZ25zEDfU2r4hYn6NkL2YiPIqh6OuwwMJpNt1ccnWAXEVikQM6tyvuAQgd1to=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FPlKKW9I; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cwu0LeVo reason="signature verification failed"; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PHNxbd023616;
	Thu, 25 Apr 2024 20:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2023-11-20;
 bh=NFnxvq6yuJNhLi9fs9d2caUblpwui7XHcf5JlEpB6Yc=;
 b=FPlKKW9IR3h9CLs01N4TZCOlkx/8WMp1fmgJFV9n6CFub3RS+JTiX1FAh6WdcRBJPggz
 4RitNfHzRy5hX/HVz5xbzTSJ+zaX0YOR5lkK87bu8JHaerHKdSL02u7Dscg2VuykysZ9
 jkIeaqxF4OY4zxk+nz5kFax1D4lnIbYSvddMr4Hu3vDKH75gxhI56UElUKDoU80vbRL5
 E/0kvwJs5KGKXsfH1D1RJQsQhhIzZq8KDbwdt2g3woWJEEw9U8DPcVWFhIpsJIz9OljU
 vUccbnLrqvE4y2KujtTm1pojEqtpYrA5T8xP9Y6qQH+Idv4SPygWWU01KB2pHexGc78I jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm44f42mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 20:45:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PJfjKX001776;
	Thu, 25 Apr 2024 20:45:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45bm42b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 20:45:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEWoaJ9gI6Pc0YueeMkjw2mimRr+iJIZ6JibAopcWPLNUFTGSN8Zcr2iLmAE0klFkBj1CCaR38EDLSTSWBnWzD30JtGTkZp9hYFLilHgHZedenWFd3fUkRLUu6Y1UoC4uYLPM7TLj/rQOWtzX4h3UjKNPEPXi05GBNS5i2U51fHeDyphkNCCbyORNaqanZmo1B+zC3CRX+5G3psRM2PkfA50Q9HN8mrT/mU5U4d1NK9UKECyg3HptZun3onEvvaSun+RGlvy5EZFq76oSjapDjUJu741UMZEL0erUtTgagHv9dzflZxDEmdB4GMYeYiYS1RkLFNN+2I8CFVvz2N2bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eAyx7izIMa3oGKZKw6g3j3a/peIce7BeoH4lIMT3NY=;
 b=aFO4YxRUKQLwl01Y3ylFyxn1//eFWQ8A67Uc9eExDnZ2wijLidq7neb+ngI32yq5ozvHFWC9oGRrSsey1LtEFxbVl3xA/ZlcrvqPT/Pedh/skRezT63eTqDaSGrMXdIy045O4AWeg6nb/hPQdwfFJe8rz81r6FX42+ITfpd27OI6wwYjBail1np+HxzX/j5zx9VGr9GjH+pOHC4tVyu9lpkE29mKnOBQAnXgnW8RFDUbNko8Wive9Lh/KeNanuDCEKb8VNFi/xVH0/I0GJZ3pYoc2RqyOMSPFwyvp9LkpXGhMeUeoxeveOqEzEaUft2/2ojpOHY+1f06+BU0PD231A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eAyx7izIMa3oGKZKw6g3j3a/peIce7BeoH4lIMT3NY=;
 b=Cwu0LeVoPl4YMWg0VRMjuINW35g2czmoPN89vEnjN8FLyePQ0tkIdlmDt+1PeffbaYs5Fsq3e1QmL/MuDi4l4gT+mOjwUujS42xMRHMrM6IyHSoxKh5oCqLqJXJYD3nUOr0TGHTxpr6ZD9exk+iLora0AwNEYh0n6++il8F5GaA=
Received: from DM4PR10MB6719.namprd10.prod.outlook.com (2603:10b6:8:111::19)
 by DM3PR10MB7909.namprd10.prod.outlook.com (2603:10b6:0:45::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.23; Thu, 25 Apr
 2024 20:45:27 +0000
Received: from DM4PR10MB6719.namprd10.prod.outlook.com
 ([fe80::4581:e656:3f19:5977]) by DM4PR10MB6719.namprd10.prod.outlook.com
 ([fe80::4581:e656:3f19:5977%7]) with mapi id 15.20.7472.042; Thu, 25 Apr 2024
 20:45:26 +0000
Date: Thu, 25 Apr 2024 16:45:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alexandre Chartre <alexandre.chartre@oracle.com>, dave.hansen@intel.com,
        x86@kernel.org
Cc: Dave Hansen <dave.hansen@intel.com>, Chao Gao <chao.gao@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, peterz@infradead.org, gregkh@linuxfoundation.org,
        seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
        kpsingh@kernel.org, longman@redhat.com, bp@alien8.de,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <ZirA1v5VL7Tdk0ej@char.us.oracle.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
 <ZhfGHpAz7W7d/pSa@chao-email>
 <95902795-0c2c-43cc-8d87-89302a2eed2b@oracle.com>
 <2af16cb4-32ed-4b91-872b-f0cc9ed92e59@oracle.com>
 <a8af757b-a40a-40dd-a543-99a39a0fe8ad@intel.com>
 <2154b190-9cd1-4b24-83bb-460a708a45a3@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2154b190-9cd1-4b24-83bb-460a708a45a3@oracle.com>
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To DM4PR10MB6719.namprd10.prod.outlook.com
 (2603:10b6:8:111::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6719:EE_|DM3PR10MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: cd781d24-c00d-4d77-973a-08dc6568a2d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?iso-8859-1?Q?CuWYGUz071w2PVKhnp7+TShBRn93vBtR6Ale4taA6oQNVTp64sHqFGO8kY?=
 =?iso-8859-1?Q?/vUq45B6v4tZMCM93FQgn8CBUYuIu00Cvu9bIxaSbuBaaOUy7VI0a/SRqL?=
 =?iso-8859-1?Q?br5U5HhI836k7N7rStdCUbqUcGCy3tVZZsys0PyQ+HT0mz0mnW94OBK/vo?=
 =?iso-8859-1?Q?sAbBCb/NtUf8EVOiI4+BLvbrHbEOHayhmB+hMfsf7dhnjaWtoYxHA4C6O2?=
 =?iso-8859-1?Q?WEcv7rTWI+DML3Ooj2rR/m9nBHLPemBjteMBjWMZce33VProoNNdfB0b9h?=
 =?iso-8859-1?Q?fckz3HysBFSpjApgWJfU8qNJDtPDXY/kRuzVAVt9k1fm0p6T10NP9FGGcx?=
 =?iso-8859-1?Q?rEijQLcRSL9N9Yseo1SjTBMinfFnBYM2eXRHXAlqlHpckzMtrO+2XxiXrO?=
 =?iso-8859-1?Q?k7rOoty/x0UVgkMWR6Fk+WKB2v4aoIJWr/0TFdoUwJMAZsXvX/7M2h38mm?=
 =?iso-8859-1?Q?XcB/x0q0Srwn2wBezfWp6m2oxKyxRH/B7gQZtPhrh/8SxuZh9Wk8pTdxhD?=
 =?iso-8859-1?Q?X6zVNn9qXIDO1ND/oaYGrv8WM7SQ7HXzoVyB3txE4psxEFJUmyIJZkkPeD?=
 =?iso-8859-1?Q?L2FPh4XAKwlgTIadcFQDSRVrknQ/Sfc2QCWC0GJ8EOIo9pV7UjxF1wuf6p?=
 =?iso-8859-1?Q?k5OO5DwYEnbaMBz+BB9QN/E4iVwX575X3hmBPBRxl7rwd1d1gjsV53EIpi?=
 =?iso-8859-1?Q?CDM7hzLs9odQIoojiDvxlkWb9NWruDaAodjb6LQWFnoZsYITTvWCH7fd0X?=
 =?iso-8859-1?Q?U5nopKTkgwGcMuYPKsgeeLtyYVB3LJo4YhS0igjQywt/50ye6kKUW7i1cx?=
 =?iso-8859-1?Q?77fSJg074kQYFvN0uqH002RRNa6JgiqanPPnU3boN5xS7rGQHUnjlPghvE?=
 =?iso-8859-1?Q?ybXjlzoU27wfnyNtG4JAvhivQ48c50sSoRXAIpD8zZOmIQLM56lAe+rLn5?=
 =?iso-8859-1?Q?hoXnV1tbInRwA02VbBy1M3xkt8B76NNUTpcQUKo3S5t1N7UobERkya0ubS?=
 =?iso-8859-1?Q?l8sReEEPSFepJk5wSBiYpzt7Icb5+E3+9VNM/qkeZ9oak39IjvrxdnT7UE?=
 =?iso-8859-1?Q?KTDRiD96sHBxsmub5qrRxMc1TsUbFKgEhHf2uLYQSN/X3UpOG3teZysI1f?=
 =?iso-8859-1?Q?fMNkHLmm+Po3dBdDfXE4Upql+DUU8HT1eqJ6bCT/gbv1JknR+Y24hWAJVU?=
 =?iso-8859-1?Q?DPuzdHRCNo3/y8iikHJrbZpSa7jgm5mIf5ibrdvgvZAdlIE5w/bJ8qVziK?=
 =?iso-8859-1?Q?SZoq0sKVW5JkPfrBQsI6e+QBXpWYvGCFMbLiZKkAHj2fSPgkQ5uGXU26Hz?=
 =?iso-8859-1?Q?4X6ja5TM+R3AvdPd6opnHASHvA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6719.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?iso-8859-1?Q?46CspKdV+bAYrcssCnQt3thOpYOiXzJteHRFN/G+18mskR0shXjyJJ4aiq?=
 =?iso-8859-1?Q?lBEVBakBBj6yK6DLBdQFvTkhN734rmmZL4VgbXd9CSOPtlBXkrVTHT/M5i?=
 =?iso-8859-1?Q?vCWx+jgdLnnFnGv1E8m/Q2paHFbF3V4H73Cpg9huM12wuc37I8EK9yA0wE?=
 =?iso-8859-1?Q?cDCU1h2ZL0KZHhINjSDuEPGKE00/ej9K7xHjYWA+BNucdULBm0AOI5BvCo?=
 =?iso-8859-1?Q?FVCB3F8ma+XvZZkpqFhmcDpBsitIqbeTs2ZwMVxZZawIJVxkzFQGE/rnhl?=
 =?iso-8859-1?Q?H04WsDDkilGDe+Xhg/B3RgfVczS22MRGIICpmWl7YUjNu5we1VJ1hAfH1E?=
 =?iso-8859-1?Q?NQaDUQz9zBZ5RjxIAWGl6e49wIqmb2szKeSGcGS0XtkzGheZm6bJUX85Li?=
 =?iso-8859-1?Q?bdM7RhQRgUez1b+T+/SY15RdzWLwGBNC6B2inQ05sC5EApyAOmpjzK/nTL?=
 =?iso-8859-1?Q?3wdMGvrEWTpfmGclouvdfs28gsZqr/x6gLYn8DaUxb0mlFz2uM74mdz45/?=
 =?iso-8859-1?Q?PXmQrpnxejvtwgLTqYZ6eAeIYMby20FwLa8cJljnf5lqkFweJl86R1GmZW?=
 =?iso-8859-1?Q?E0wgZh0Eu1WZT92+Q90Wz37xKtzbWhq6sS+nFI3ku9t8n4MZHqG/SGaZfv?=
 =?iso-8859-1?Q?+Jis836UAkP8T3j+y+628PonimaOcd231A6q0UR+xYADDCjKHrSNUC4f9+?=
 =?iso-8859-1?Q?/POh8KeFRH1241YKUYx0RYZ/kMoQevzx4Bp2OLLs+OwmzxsmptyCneO0Bm?=
 =?iso-8859-1?Q?F/Qy/AYRrNmJBoZXIsYliC9Ow+yyKOp44SA8sTXmrOow78pZN9+w9U45Yv?=
 =?iso-8859-1?Q?b0nBFFGQ6Fh+qMN0UU9Ct5p7y8N1inbHJJoMVMIQlYV/nZVbNN1dDfZNEg?=
 =?iso-8859-1?Q?NPqZpSiD+cwoJ5pldJH3LKvR/FrxXNGjTXZrdfq4ehc1mzPcaRG8uGNzEm?=
 =?iso-8859-1?Q?yUdEiCpYejYuNMksDIYIlf6O4qYTfvzk0S/67KyJ3AJfolrx6+/HDFWTW6?=
 =?iso-8859-1?Q?30U2zR6fxSnH7u6uwdFow1UPV3y9GD37ikqRr/g01avAlC3RvXFsPKVGPw?=
 =?iso-8859-1?Q?eslxpAYIRJolX3vWniifQz/7+IgKOkGNS92weP2xRUt4zoJollulBQIddN?=
 =?iso-8859-1?Q?pfIvrPJSJgy8AN4Mk4qTFNgRgEqakgv5fYjKn3PPf71BrcMvM03BZwQTaO?=
 =?iso-8859-1?Q?EveeybUcfCw4ajMN7Qf/O7tu7hF8sSHbBzXdWJVw14B5BcGZfLPMKmbMsw?=
 =?iso-8859-1?Q?ammPt+XvglTT4yqGGyMIKjL+oKRGwHBnu+nmRLDV/AtAYSoT/tQ+5+Y21R?=
 =?iso-8859-1?Q?ftQ5aWD7OhN5VmeSMQ6delyXXJYkeT2OEzvz8UX0YZZtX4LWTMUC/na3yP?=
 =?iso-8859-1?Q?LNCdksnJLzSkRhOLcWCNBHVwNXNkfsORbD7ZrqO3AjPdq6/oLPn3lvxZFc?=
 =?iso-8859-1?Q?N5umLXGDOfCdhegUdSqj2Q4quUm9pBbjYkuJtA/+GOcd8ECrocbDY+OQRX?=
 =?iso-8859-1?Q?X+ryajvylSXX6RtFjXhvS1hFvaOGUS2/y7l5UuZwoSvH74/AQrWOTcnt6z?=
 =?iso-8859-1?Q?xnPey3cG1dVjIqZNnSJmqOlxxy7ndZLFNDEUkPFqRJ4frKpIW6RRCX5NQt?=
 =?iso-8859-1?Q?3DnEpB9RDRjSlZjB8eWHZ2uRNH3omf773Hg1o2a7rujsJDS+Rkcj7ksA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Sh1NY996jFSnJbSVRHMpDT/khwi/OCUGH8kp4fvswjzeSG+V/nyp45NXGlCpmtYwQIE6mDMKFsP16ajMaq3CwQPaJVI9w0Pr9KwviOgyIlI1yZtRocVSIUoreT6E/p8cPS6f33ebt8ky7djECtxSUlYQyTXSM3yuflGL8bXNE3lwO/voepuwkZKaCkBDRwiGPrHseIqFmJ+wlGfyaX3TDdWVJe9TVAfkUw+7mdYPhBiA+uBlGRC75uQVx0bem6BE/9r5adkTdNjW2q9xMC55ew7rmUe8tNzIO6WSoQLWwU2/UPgUDiwJEXkkrVAem9wpI3YYgvv0NcxUKGUPoPZyl2j6HyD8ryOLYvA6OZG8NKwquzP+Qg9yNmEz7weQTkDPxBTOqx61hCx/LfMyM7nCVmeOk7LqbQUAhMbdSZvPae+q8fNBvb8EU7vW9gllPeC95xbt6Ekl8XC49oV10m16T7kxO+5c5f7PTvJ6NM2DGXhmJzJorxyOxjcPp+oOk4PiszL3GAnlI57NSU7vJtJ0xLaqd2yxLCAwfZdjC6KjYb0cfJhWW/DYr1lx7XD5g65xZtCEPavywRUL6mNLtUzlD7x0kQyn763tvTExtQr8RlM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd781d24-c00d-4d77-973a-08dc6568a2d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6719.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 20:45:26.5076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTheU/iARQWGjLiHEyItKV+uZZd/oETdLQ+Eh8qfy4QYFxDhjcZ83vAvKGHcYHAIuF6Jwxcw8TLEB9RMQuP3bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_20,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250150
X-Proofpoint-ORIG-GUID: -OZK4OrK-yyzX-InlIerqv16xC7bbg0J
X-Proofpoint-GUID: -OZK4OrK-yyzX-InlIerqv16xC7bbg0J

On Tue, Apr 16, 2024 at 10:41:58AM +0200, Alexandre Chartre wrote:
> 
> On 4/15/24 19:17, Dave Hansen wrote:
> > > +       /*
> > > +        * The following Intel CPUs are affected by BHI, but they don't have
> > > +        * the eIBRS feature. In that case, the default Spectre v2 mitigations
> > > +        * are enough to also mitigate BHI. We mark these CPUs with NO_BHI so
> > > +        * that X86_BUG_BHI doesn't get set and no extra BHI mitigation is
> > > +        * enabled.
> > > +        *
> > > +        * This avoids guest VMs from enabling extra BHI mitigation when this
> > > +        * is not needed. For guest, X86_BUG_BHI is never set for CPUs which
> > > +        * don't have the eIBRS feature. But this doesn't happen in guest VMs
> > > +        * as the virtualization can hide the eIBRS feature.
> > > +        */
> > > +       VULNWL_INTEL(IVYBRIDGE_X,               NO_BHI),
> > > +       VULNWL_INTEL(HASWELL_X,                 NO_BHI),
> > > +       VULNWL_INTEL(BROADWELL_X,               NO_BHI),
> > > +       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
> > > +       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
> > 
> > Isn't this at odds with the existing comment?
> > 
> >          /* When virtualized, eIBRS could be hidden, assume vulnerable */
> > 
> > Because it seems now that we've got two relatively conflicting pieces of
> > vulnerability information when running under a hypervisor.
> 
> It's not at odd, it's an additional information. The comment covers the general
> case.
> 
> When running under a hypervisor then the kernel can't rely on CPU features to
> find if the server has eIBRS or not, because the virtualization can be hiding
> eIBRS. And that's the problem because the kernel might enable BHI mitigation
> while it's not needed.
> 
> For example on Skylake: on the host, the kernel won't see eIBRS so it won't set
> X86_BUG_BHI. But in a guest on the same platform, the kernel will set X86_BUG_BHI
> because it doesn't know if the server doesn't effectively have eIBRS or if eIBRS
> is hidden by virtualization.
> 
> With the patch, the kernel can know if the CPU it is running on (e.g. Skylake)
> needs extra BHI mitigation or not. Then it can safely not enable BHI mitigation
> no matter if it is running on host or in guest.

Where do we want to go with this one?

The problem (which I think is not understood) is that on Skylake there
is no Enhanced IBRS support. There is either IBRS or retpoline - and when IBRS
is enabled it does the job of mitigating against BHI.

And as of right now on Skylake guests we enable BHI _and_ IBRS for extra
slowdown.

We can't disable IBRS as it mitigates against other bugs too, so how do
you folks want to disable automatically BHI on Skylake with the least
amount of code?


