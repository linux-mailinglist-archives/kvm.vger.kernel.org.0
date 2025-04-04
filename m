Return-Path: <kvm+bounces-42684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A8FA7C30F
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BD89189F26A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1488321A437;
	Fri,  4 Apr 2025 18:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UytyKvrY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dMsoSUE+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63291166F1A;
	Fri,  4 Apr 2025 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743789977; cv=fail; b=jpGe/Zgy2+zPw4aqXGnQ6K596lGAhA/q+/K1M2nL3Hpe2cSKYQl1fjfo7lEuR923r1PeuLf4JJ8hzc2gl15o7DZSZU0MZUqiE9E/sjKSftsGIepGHuWah4ysOWz6ASg2jqvYbEUhr7vYrFAHgOXpDSVWfnCsSxAreM6lfkVW5+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743789977; c=relaxed/simple;
	bh=dFYuddz7HTWjgRnL/tnDQYl9ZHZh6PptnkA3ej4eGF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XNfG2+TJCo7Tu6cgkX09ULg7/cx+HS2BYQyiQZde4Se7LQJexj1khmKxPUyLLvCF2br508KLxdSm//WX/ZHoupE11efPGSz/sN3zMtIfgAsDSEuW4Q/kJ+3SbolDB0lE6k9VUVLWK4p+DIlKQ1YbgLyld6Fb2AVu8TGa1ZLgyFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UytyKvrY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dMsoSUE+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534Du7UK002760;
	Fri, 4 Apr 2025 18:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=3ivg9sVJVD2b08kXsN
	GLg/3JH3nyGiyJRcjZwqjT644=; b=UytyKvrYVje2JgRlNniokqksc08oatPQDn
	qlHtwyG+vU2LZxDhFle1Q0iCV21rdZ7Pa7P3IuE1UqUoqyQSz8WlV9FshJq8GOAf
	HPBnEkRub9zDBMWp7ODbD+dp4PsYcMtUQBPnryU0wiF2aC+VcPQhww4Cn/idEjVS
	xZbQNVatRacjYwOO7AIrjpYnKbUQQwDluIP4+xqzjkl42UxayKRhj7f6lj0TPb+b
	OjMDSoJ8KbKzoVCOddDZKhcXn1mjc6LteKkLKd/DHqCgzuUPUcgZb2mpWf3VlPLe
	jgMLPk8/iXc+0ck1BaP2a8ibOtLwoJtcsb237ENCU+PGvUVhbUfw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p9dtqkhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 18:05:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 534GQ1Mt013712;
	Fri, 4 Apr 2025 18:05:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45t31fk7bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 18:05:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADFguy8nXrhknBy1zNJrmd0E+98RFwLS9QWbOxhkTIm/QKagm1mD4knB79N2vDbH6fnQ56Z7nNtZinOtknuLEnxNk/BmdtcD26OAgcMZY5uFnpm0RGZfyNWuP8Ce3LdoXBAM6T9PFk7kk5pOI7At82KOJbVHvmw9w7MX3xHHSzrJbdlt/Hevk/SavisJCrveRHBh5gHYFLzVYtUU4lBvJMpsooiuwBmFGKVNf16KPZai7f0siCse+95pZq3HrPW7cRA7dksN7YZ5K4JDmzHqvV7lZCpAbpR5XbGBz3DIjy66/9++cKSXfS9OqWvaigBb92nOZR3AW7+xoxO8I2eObg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ivg9sVJVD2b08kXsNGLg/3JH3nyGiyJRcjZwqjT644=;
 b=CRMmbhBz75rcM7JwVlTa7Q0xkpSSX62NsyIDPHfT3TvphXfAEkKO6kdLrwiWlgwBjip6xA2ZoHNOYllmPtdDYfltMZ3H5zoH3BUCoD9DTat/U11F+LhTXstu3lS/ZOlR5Te44HEQhNdIC/4Zl9Vhtdb30f7w01aefb7qZSRIHRiJk+qQyKS+hOJ7x6liR3eACLltA32mXVMmU7xEj5IYG/x4fZpc0/7xjuyQYqB4xU2Yh8SUoz/oLLYleyG4swR3lMt7T6c147NsliS0XNNZYTUU5HUo/hzZNduZZ5aIEKjrfErIXRP2waE0372usM1/5ashjExcok5d37ZzV2s72g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ivg9sVJVD2b08kXsNGLg/3JH3nyGiyJRcjZwqjT644=;
 b=dMsoSUE+B82CwJ5HiPepl34Ui7QdD6nPQ4LqEP4uxYmaxPiaiqtCT/5pjA38zHmJg5qQ3ssG3gEZ6mJwbSC9VworNyqdpzfz602Ay3V5U9th1IFFhsdtbitDL+4dwWw+4WMzoQk/yM/q62P+J53ohvMe7bLVQkRhB6xhgihKIu0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4221.namprd10.prod.outlook.com (2603:10b6:208:1d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 4 Apr
 2025 18:05:27 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.8583.041; Fri, 4 Apr 2025
 18:05:27 +0000
Date: Fri, 4 Apr 2025 14:05:19 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
        anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
        xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
        jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
        isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
        vannapurve@google.com, ackerleytng@google.com,
        mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
        wei.w.wang@intel.com, liam.merwick@oracle.com,
        isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
        suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
        quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
        quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
        quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
        catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
        oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
        qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
        shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
        rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
        hughd@google.com, jthoughton@google.com, peterx@redhat.com,
        pankaj.gupta@amd.com
Subject: Re: [PATCH v7 0/7] KVM: Restricted mapping of guest_memfd at the
 host and arm64 support
Message-ID: <egk7ltxtgzngmet3dzygvcskvvo34wu333na4dsstvkcezwcjh@6klyi5bjwkwa>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250328153133.3504118-1-tabba@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328153133.3504118-1-tabba@google.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT1PR01CA0058.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4221:EE_
X-MS-Office365-Filtering-Correlation-Id: d8942d07-c977-4218-d75e-08dd73a34769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1jz+RzpJutJu2wXA/cRSOVcuXRFH9p6ig2t3laGyxNgNuXFAXMOZK+4re9Cj?=
 =?us-ascii?Q?Ho6eNTORva1tS3QJCBHRij2mdJwmhm7eQNVwUML2DsJOlqJyUoRY5CybFa2/?=
 =?us-ascii?Q?iMtVtlWIAegedD/6BHllJlQ99Vak9z3L3TS5f162+x0h96b/GOdz7XjvwReS?=
 =?us-ascii?Q?Fert9LyI5xs2qpkkGDkgNFfz2cWVgj8wna7RQZAZEI92Lna0CcnGOmw5F7nV?=
 =?us-ascii?Q?aJ5dbvosDx6DUMyaQXByOCLsoBn1Apzef6a93sihhA52rfCm22b32mKaG7oa?=
 =?us-ascii?Q?KR6OoEUrBV60GclKipl9LvqRCCMnOqlRL+2SnClPcpkFEU+2YcwRKGMokBSv?=
 =?us-ascii?Q?QEFzaoEug2jdi81v+wQ3mlkOu1JrJAtF/WcQabAtLTerPNz3mOZHkqsp/gA1?=
 =?us-ascii?Q?xaEot4jGmbNYavcLwEdAyJxpVyKdHie+uerzDm6zu5cEpZ18Fo8buDzvC1K+?=
 =?us-ascii?Q?jspiQ6Hy3m7Wwtk71+k8UxJi48Ee0/TkoGtW6Bjh+b6/YH+7phYYxGOugCzK?=
 =?us-ascii?Q?cuWt2mriEaZKHPrKnZsnfSSxN9S0bxtjXVWireU7U2xAKL1Pgp280oHTjut6?=
 =?us-ascii?Q?Ia2I56tw3mxbxgRRMQD9xWjS1pDtC135urGzliuwNijzTka3/kmWl5SWtpub?=
 =?us-ascii?Q?441akka2MPiHlSi1ET2+bMkY+2IohjCHU+4HisGetFEVowgsYDk0rMqw6d8i?=
 =?us-ascii?Q?bJVAooxsCbhAPNcT59US0gPOgrY795+wnFIbnkDMD3RTKRE4RYeIzfWiZsTY?=
 =?us-ascii?Q?7HFFssFmCklnBt3KTMivJlPshrQk6IuV34CaKIQXjBwOcH9slUBkM8H1103J?=
 =?us-ascii?Q?0zoASktfevJ9V4eDuF4b91r3sGTHN3Ne7a/kbA2lXNRzv9m1IVZh72jk/Tz2?=
 =?us-ascii?Q?ZH946AvN0JYjBngz583lZaKsQEJH2FejbMEvjXBU+fas97WmAbHPDE2/Qteh?=
 =?us-ascii?Q?yRRhsX0Ddzdd3y4VtZ1lxeOP/fRhcb7Eb4XnuYRzm+wG8q/wDe2+RTU/vC2q?=
 =?us-ascii?Q?XCB3axwpo/1P4rkIppVzmVQXxImXAzYxgfvFW+DUAj6oQ+001hgiQ6YecYmf?=
 =?us-ascii?Q?88TcjBEow1Vvnwns0qqdkRwt3iktRNXKstxmuTgq3orMi28jhvvB9LRLnthp?=
 =?us-ascii?Q?K2curlsEkmSYTVP3LM+5HX7Sa9S2dfcoJcksODjemrxaOkfWzzARtdPkcqXA?=
 =?us-ascii?Q?q6FjnzoFcTC1/ZoXtG+zBxaTi4e0nFM5WpawQsYafCiHB8BEJN36JP39poFu?=
 =?us-ascii?Q?3eM+j168L/kYHUfy3osLjR9Ujf6LFPd8SmaSLWLhiLV+TqJZIgD519/9WsA9?=
 =?us-ascii?Q?oSsemcrEo2TPau18y3Qqrz30VN9WIEUQBe0Pp425YrUbeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pa0wP0DSFkmZPiavSUJHATOmKkF07p0dyYnpVE2Eu54/mVtLMxGvXWtvWPoy?=
 =?us-ascii?Q?/CCHbitvpsnZ3cADvd6/boHMRAyQz4kGlTI00SwjEbihwp03y/kMY0v6HNm/?=
 =?us-ascii?Q?2G/66ApsSkYOsGpZ+E3ddrgkmLP1Hl6K18jwOigLNykkxDgQhvVPLJrDyR0Y?=
 =?us-ascii?Q?eaoOmXbRXKpxQSwv62duP/+BCKF+TFd7ay1ktjv0I5No6P0DMfXs3Y/hd59I?=
 =?us-ascii?Q?rM5Jyr+UKd0sSozDHS3xPY1/p4YMhmUNJkA2mGfhzKE//kdT4g5RH8RI74J7?=
 =?us-ascii?Q?wFLwTvYMmGSomu07D1q4X4A88oaAbgHVkUJMIK8RErQ/zWOsaZr31oaDtblR?=
 =?us-ascii?Q?BryjlJFh12uI0KzIrufzTz7V4Tn6QVGaoTqTRLI4dXMWEafFFNsMpOIFZTub?=
 =?us-ascii?Q?9tPJAj2XcsiYlpno2FT5n5mYqITtC0+ML9jrbyqyGozgn5VyNvPaByR5zCIh?=
 =?us-ascii?Q?YLxWGjKGRAu73fhw7q7iY510gMHx8qxfwMqFvDZmSy1VSMGfVg753m4hAGYK?=
 =?us-ascii?Q?KNPnVGAiw48dVaykWsvsjLWaQ+VeJo2JDpJK37Q5f2Ab2opqLE4vz7pXYkav?=
 =?us-ascii?Q?cVjl8IEp+hqOdzPuUxdYED2eDIelwPDGnLFaAQJzsdofs/hCr8JhFpMiyhgX?=
 =?us-ascii?Q?0mgdVQJHve37b1v4824nfwDK81RB7o5kuNfPVxCLAkGjRmN6en0W5BY/h5ny?=
 =?us-ascii?Q?69HDMRJQE9PBkYx5+Rv/2i6vebLBIyXAQGq9oLCOrlFpREJW5d9gWsHaDSLm?=
 =?us-ascii?Q?Obtpw8lPBrISBrE6zJbQ/gNyVt4e8CMijOrgjTr9Na0OQNkZeSC8bCy1HZUc?=
 =?us-ascii?Q?v+1ulIqeb2r8w3l4SawhURQzuuP89DLsgSpL+z1+7n7JerRGSwUpW5IYJPx5?=
 =?us-ascii?Q?uVzXCHxPdtX/NFJ+qAZb3d0u//axUL4Atju+uZgu8OfxwSLqglohGNyTh0mO?=
 =?us-ascii?Q?Aew3LQbBLn3iKQ6L7btM6HNijBrZtvxrdFv+PWPrCNSj3TXUJCUoA0MVPMlT?=
 =?us-ascii?Q?k1WTbqSlAcnvnsKwO9bw02LWhamFX6drSH+PQqFfwNx60VsJYxZ9JUyphUc2?=
 =?us-ascii?Q?Mkcf3VnTlJ5C0J/sNw/I0YZy3YYAk8dBNcfSntbh804fUhwWiCgTDVyrLXDs?=
 =?us-ascii?Q?OHWppS49mOJ1XUU2CnTKo11T9phhlkBXsw9ZVhaTOCuQpoHIFvh5sz7FdNF7?=
 =?us-ascii?Q?gP5smI1mpyjeBpIydJCcg55upDnjL8vKQk2IR7sqgeSul24CiTU4MKmkIQqn?=
 =?us-ascii?Q?Uiu6ka2r+6657tp2C7I6KbTYLgaB7QuTQdwvcE29t8vmk0pIjxL1LXBiWuQj?=
 =?us-ascii?Q?HnC4JNAU+OnnVLi8c46s6SuUvav7aiqM5fTAmzDG86vngLzE861ib/r5t+u5?=
 =?us-ascii?Q?Gmi+nwSPE7g38ECURNSMo5eSqzkqmT1ULl1GTsPiWYyazgUQ5xhzM4EIo4HH?=
 =?us-ascii?Q?W4PxwaKMySA6xyTRTpv1l3gYFdxHTNhZ6WMLELzXBS5ddmnmEsJdaVBYFBuw?=
 =?us-ascii?Q?S2v067F/VJsPtFPSDtWfy6QSrHHn5GDyUVUBSJNeM+Yjefm7uYyhWydQesmO?=
 =?us-ascii?Q?Ms5JGHoNSFljVAWCQNrQpSa3xj/yVQCCEi21hIZk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zkzXh8NNp6P7G5mRmIIBotK8A1bMnWafXJgcI21JYKFdGV6vamoXEbN74D8LGI8r742NUts5ZQtzaJ5SY9dVxAfxfxbUHDdKmtfixyK0+5LK+V0NvizwqYF8GJqJckQYji6DddhBa4AzbeMj3TF4jPaHhiOD16HQztjlfRG7NlsuiuP9PblfsOA6/d6SOaJFEdEN8yTys0EMmBUuX3o1Rs57qf5I4BVO8b9zxmKG/LNJtFMXjNkmEY4InkhkPnArrSJhNIGey6C4rG9w6Sf4XqJhlHo+Zw3nyZEXnKvyXOVupBeInqbASdF7i9VViVLrlxGqKcjyk44W5mmzr0KvAtpSsEvia+Yf+52y/Vh0UmcboHK3b6cgDlR/TiXxXRFCUqVHw6NvwARrAqWD9aNkgxJPOzzuA7msOXMt1rwkhacFRBL5U4Q5qjnQtBGPPoe0X7LF0BLy8XFchuQiwokPJLlQzpgfZOAtL26TKGE0k1G476Re0x2lgPivgNPmZ8o3urpfuLCAWuII7Gae8CDU1I2y9a9eVpDBG0w6rwIj6tRXjmuuLicAwL4HOOmu+BaAIoHA6zRrhrHxH+Hc8ENki5pBBsfV4njbkA7P6aykPnU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8942d07-c977-4218-d75e-08dd73a34769
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 18:05:27.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yHbaVRKaD/Gjh97t7zIwD59qO7EYUwaw0sYhsDsWlXKxtiDHvm7UbM4a/2JxLGCrw6voiRg8Zck9LfelETLWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4221
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_08,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040124
X-Proofpoint-ORIG-GUID: LuMgqhHoLtQREz3K9tPPwok4Yryg114s
X-Proofpoint-GUID: LuMgqhHoLtQREz3K9tPPwok4Yryg114s

* Fuad Tabba <tabba@google.com> [250328 11:32]:
> This series adds restricted mmap() support to guest_memfd, as well as
> support for guest_memfd on arm64. Please see v3 for the context [1].

As I'm sure you are aware, we have issues getting people to review
patches.  The lower the barrier to entry, the better for everyone.

Sorry if I go too much into detail about the process, I am not sure
where you are starting from.  The linux-mm maintainer (Andrew, aka
akpm), usually takes this cover letter and puts it on patch 1 so that
the git history captures all the details necessary for the entire patch
set to make sense.  What you have done here is made a lot of work for
the maintainer.  I'm not sure what information below is or is not
captured in the v3 context.

But then again, maybe are are not going through linux-mm for upstream?


> 
> Main change since v6 [2]:
> Protected the shared_offsets array with a rwlock instead of hopping on
> the invalidate_lock. The main reason for this is that the final put
> callback (kvm_gmem_handle_folio_put()) could be called from an atomic
> context, and the invalidate_lock is an rw_semaphore (Vishal).
> 
> The other reason is, in hindsight, 

Can you please try to be more brief and to the point?

>it didn't make sense to use the
> invalidate_lock since they're not quite protecting the same thing.
> 
> I did consider using the folio lock to implicitly protect the array, and
> even have another series that does that. The result was more
> complicated, and not obviously race free. One of the difficulties with
> relying on the folio lock is that there are cases (e.g., on
> initilization and teardown) when we want to toggle the state of an
> offset that doesn't have a folio in the cache. We could special case
> these, but the result was more complicated (and to me not obviously
> better) than adding a separate lock for the shared_offsets array.

This must be captured elsewhere and doesn't need to be here?

> 
> Based on the `KVM: Mapping guest_memfd backed memory at the host for
> software protected VMs` series [3], which in turn is based on Linux
> 6.14-rc7.

Wait, what?  You have another in-flight series that I need for this
series?

So this means I need 6.14-rc7 + patches from march 18th to review your
series?

Oh my, and I just responded to another patch set built off this patch
set?  So we have 3 in-flight patches that I need for the last patch set?
What is going on with guest_memfd that everything needs to be in-flight
at once?

I was actually thinking that maybe it would be better to split *this*
set into 2 logical parts: 1. mmap() support and 2. guest_memfd arm64
support.  But now I have so many lore emails opened in my browser trying
to figure this out that I don't want any more.

There's also "mm: Consolidate freeing of typed folios on final
folio_put()" and I don't know where it fits.

Is this because the upstream path differs?  It's very difficult to
follow what's going on.

> 
> The state diagram that uses the new states in this patch series,
> and how they would interact with sharing/unsharing in pKVM [4].

This cover letter is very difficult to follow.  Where do the main
changes since v6 end?  I was going to suggest bullets, but v3 has
bullets and is more clear already.  I'd much prefer if it remained line
v3, any reason you changed?

I am not sure what upstream repository you are working with, but
if you are sending this for the mm stream, please base your work on
mm-new and AT LEAST wait until the patches are in mm-new, but ideally
wait for mm-unstable and mm-stable for wider test coverage.  This might
vary based on your upstream path though.

I did respond to one of the other patch set that's based off this one
that the lockdep issue in patch 3 makes testing a concern.  Considering
there are patches on patches, I don't think you are going to get a whole
lot of people reviewing or testing it until it falls over once it hits
linux-next.

The number of patches in-flight, the ordering, and the base is so
confusing.  Are you sure none of these should be RFC?  The flood of
changes pretty much guarantees things will be missed, more work will be
created, and people (like me) will get frustrated.

It looks like a small team across companies are collaborating on this,
and that's awesome.  I think you need to change how you are doing things
and let the rest of us in on the code earlier.  Otherwise you will be
forced to rebase on changed patch series every time something is
accepted upstream.  That's all to say, you don't have a solid base of
development for the newer patches and I don't know what interactions
will happen when all the in-flight things meet.

I'm sorry, but you have made the barrier of entry to review this too
high.

Thanks,
Liam

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
> [2] https://lore.kernel.org/all/20250318162046.4016367-1-tabba@google.com/
> [3] https://lore.kernel.org/all/20250318161823.4005529-1-tabba@google.com/
> [4] https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf

