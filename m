Return-Path: <kvm+bounces-28954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F0699FA16
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 23:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D2AA1C20B49
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 21:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE24E2003BF;
	Tue, 15 Oct 2024 21:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kQa0ZQJ0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CBZgCo/2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5912003A5;
	Tue, 15 Oct 2024 21:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729027979; cv=fail; b=M+lqxecYelJKv5ZlbwFFOfSMpZjCRGi/ztVmt78iOMTHvxWsw4xc62LZ48wBx6KvHDvF1zUTJdXwr7jjE/LqJgWxVKWVaHi0g9lBFDBVMHwoAy84lLMTIPEoP+JsG6kTEdc3F5kNNpGjaeo5CTHQaa/dJBIWkiNuWyNQL3XOT5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729027979; c=relaxed/simple;
	bh=tf7Uv35Op3eZ2Kc7OI/uJxWxNkVJIQJ6ojgXwUijiRE=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=IgBRhPNgblGSWbO/a5zN1QHsABXRlYkfxn1nGNEvKi/rb7t9FR2Kk3b9E0j4k5nsk7We3lROIGJvwCTaJolhCkrE/QViCBmWctjaHuu2NNBgufis8FcMk8B+y48kBlGYWSM8YKwCNVIxhhe9s/+LEUuS+iaNWsSITL+yvyBC8ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kQa0ZQJ0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CBZgCo/2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtimm001626;
	Tue, 15 Oct 2024 21:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=8DFRwJkfA8RGSO7DeQ
	KG8HG22t+qaBwX5/jRl2oflwM=; b=kQa0ZQJ0ofBuTam5sl1wDFfBzJLGYi1K+4
	FKHXnW7AnVgLcs35oOk279BIJOAPVw+z78Gt0OkhRA7TpX0C1qJnYFj4uhs8WEMr
	cpDTHy6TXMo/+LZHA8Sl5aNZasjbkBx5RvpFvjH7utuSr1+InHGJQJ7BtUV6c9o+
	1N1jrhVR0H3A6TXE4ONV6EdYQJxcNQBxl9YrteE2VXwdmmebZ3cojPLbT34/au+O
	RGD8FV7OFo4+/SrewK5mIrii5UIbkexA59MVw8tgpLOy0dFsRLamQeeIkbieXnLz
	6cX1ydCU/WGzVkDLWAxSQOBXiCBuh3lj0DWlU3fS4eZ+3bJRMQTw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427g1aj4b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 21:32:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FK5lAD019857;
	Tue, 15 Oct 2024 21:32:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj81uq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 21:32:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ozzdr5OhNo/02SFamJZ4MWiyeppJpGX192fYqXkRPH3eB2J0kvIztiPT96A1gV//DT50JYZ6xHKPAA/rtSlndVdlqvEEpv28Tkn5BW/J2viuWiOXuIdnrQSjAOgizd8azL9NtO71JPQCjD/UD/flgwRc5llW9SuP/RHX0V4/vor9b/cpnE5KNRqrBMujlKDBDKuCIyU3HbW6ePS/XCP3yZSidDSllgHs9ZCvBjwLcE19jE2Wix8V3GcwdoJk/Xg/RqP5B59dzSqfNC7uwcwXfAVITbOeFyLeexCL2yt8MBaiMKje20b7KxggbrD8VEB5RMo29CnakdA44GjLIH270Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DFRwJkfA8RGSO7DeQKG8HG22t+qaBwX5/jRl2oflwM=;
 b=ioDlSBA1GLNUREPLkPbMBKbsohOF/gE34oLTHg3MEZBKmEdrjW2JF+Drb3dl9zZvLMI4HCz6GDUXJrqhqdVP+kTZVd0H86Yo61uUDAYSRS1hjX2dacPkZg3v08IKjXlVr6ggmafEe1zjIHY/oHt+XgqSGNcYX8Lhu7iG4CFEiLyLSgIZmTkzV7pbPJ3C7Qib322o00lpFoqTXvanoxJ1G6mbzvj+fMoiqEkdafyxG1Xgi8z4IDwCc5iSnXfDSDG31p32pkKl1y9LMjJ412oWR8dYDVvB73FzKM2fu1AMZnstoFvUyhLxGrdviPs8gKtbJRE8Ch4wlyhfJ29QxDKDng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DFRwJkfA8RGSO7DeQKG8HG22t+qaBwX5/jRl2oflwM=;
 b=CBZgCo/249VjckM+2adDXFnmv+dTnruz3ueYmJVSiSo/P/LbHyD/ixcQa+Yi9fJsBWnyAJ++2e/wppWdIsaHlNL98tccPe7ENgFH0HiXvZipOCP2J95ajAw6E2Jv8fgMhmPteO2VJrQQ0D+DMjwTFBaGwnF0nrJ4ShCrxiZh1cM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BY5PR10MB4146.namprd10.prod.outlook.com (2603:10b6:a03:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.28; Tue, 15 Oct
 2024 21:32:03 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.016; Tue, 15 Oct 2024
 21:32:03 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <Zw5aPAuVi5sxdN5-@arm.com>
Date: Tue, 15 Oct 2024 14:32:00 -0700
Message-ID: <87ttddrr1r.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:303:b4::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BY5PR10MB4146:EE_
X-MS-Office365-Filtering-Correlation-Id: af1af1fa-6b47-4d44-69ec-08dced60ceaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZN7SRT/fZd+1PVtUOn6SGCrpm5LP5fswPecTAFpUz6LNzlLz1r54qSO/x5t8?=
 =?us-ascii?Q?oO8m74UM64ChCgb2NB0XNvJAwf2FyMVxDrMtZWm3eJ/+j1os3QiBRmiayLZX?=
 =?us-ascii?Q?6XjaVgDukuSnxC42KtbJKkB4sH5kJJW+vd27+y9RdVYxArcpsosEA92PKV5G?=
 =?us-ascii?Q?QLxgs6YJP3rf26UQB7wWpSyrxYy6iTyzQ49UqsWV6FIbfd+Nf+LGsUcxOXlh?=
 =?us-ascii?Q?fpeuV33ZU6yfkRJe+1Eo+KULWjU6CFuoGw9Fe9yTU2/SGlwq0Mf2uzNVKqs9?=
 =?us-ascii?Q?fi64j1UYqtvYJOx0HXxHGex+RRMt6kCBdBN839096mjpNqCGsGLbxXClZ77L?=
 =?us-ascii?Q?ohWdUy712ewdSDr0DxOdDtSxgVXAFqrrrDW4cKQts/LDRCXDzporCILEssRd?=
 =?us-ascii?Q?ei61Qv3B5abnhlw14ufRNyU4I2OMKzeh0mRGNswarHKVadKg/QB2rPH7uRT4?=
 =?us-ascii?Q?tkN4hqtMPqS4P1r9C5Ewb6+NsYvDfd4UPb9JZuyMCSKIOL0U1+o5LuhzTFdx?=
 =?us-ascii?Q?UkFkKAb0OjC04trNf68yucpQ6kA1plyvlwyZE4b8jMc/0PgQPmpkK61o6Ly1?=
 =?us-ascii?Q?8zwMu5ilYzHe0w8tXOwvB0SVLuxVVoASiMbw+X4xMz3HnFIGL4l3cHPqQOkR?=
 =?us-ascii?Q?mKRycSUB51ORQlDrchhBPIOm2UDPVgBdOMlNKRDboL63qqEQSGf3dkXD5TKi?=
 =?us-ascii?Q?TLQOK85fGDKtDUXasjGLul/GseUu7mcyL8DK+3EwtDQFI9c9TVIPkkEaEnv5?=
 =?us-ascii?Q?Jcj97A7e8BNj7KlGYFdf+kKayVsHgPsshnx8rpvSH8r63fzWlHOUqRv6Oogf?=
 =?us-ascii?Q?BlQF9sD5AhIbI3Bw3Nxsh8pjcZWKwb1GvrF9cPBhnM2VxfaIWzId1znImhj+?=
 =?us-ascii?Q?LnNviZ8PgW7yycL+BRdE+8O1XEmIgo5cIwhXiGdCSQPKhc1ywCe9asNl0Lab?=
 =?us-ascii?Q?nBa22gnmSh10XF3EJaC98m3lL+ZlRNUNPJ+yHwmmAotAxDT3NRgEPX8yiiiU?=
 =?us-ascii?Q?dcARZI8w4ciU2FwrY+M/y6BTdIAa7LIyxlxXQS6fUQ09ZcyZ2WzzN3gOFaTx?=
 =?us-ascii?Q?iG6LKGITS/DgyCvLS091gXRDQGtXcKoAQEBfPCs4HpDWC5vFJ18S8ZaZWHy8?=
 =?us-ascii?Q?D0ejhtgfZarrUua3PsF/e2BTzBiKTIruH841Rbl8MH8BfnIWlVhZwbM1VAqc?=
 =?us-ascii?Q?9wmK6DWCnHZVCu6xYW65aKJb9veblPm9e6gVqYwR0nqQZnnHmj3U/A9Q8xlM?=
 =?us-ascii?Q?N6lSiKSXVxbClDdztogQh51h+Grd1C1UEkj5KPdGLg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rdRrbV24b3WeHXhoQGPtUq9NJv60toPNLUIcP7rgLai9EBIa+nvp7oKRvB8g?=
 =?us-ascii?Q?YRHDyBqFo9hvKHLKwBWg8bxEODeR91UivVtBDQXT5C1xgppjAryyQ9zyVNlX?=
 =?us-ascii?Q?djqnqk5ps6VsxbQpKtaDmtcdLaT9op6p5uD43EXlZ4h5T18IBfbsFtzlUSf8?=
 =?us-ascii?Q?wAC7XDa8/eXGPevc0pOHWGof8/eU/tpjT69eSmE5CnmbyNvVC7XK7OuCG7zD?=
 =?us-ascii?Q?zT6VpC4g4Muj1HuOgduwt+AbDseWgChM84dDCXSpVio4/jNVXKVtd0mci32d?=
 =?us-ascii?Q?bx0N1FqLxEP2qKWJ4gMxJHRaygsOC7wOA8zE6T6KNL5UFdtgfJ7doFKJOCxJ?=
 =?us-ascii?Q?RtxXEu4C/Gx5I/KTn/M6ETzPivqhuhegmddhabzzeGdvBiEAUiXeH78gnre1?=
 =?us-ascii?Q?y2CVGX1SUEjhQ3tBpbJ2f7P8FU+W71Yrwpfdc1QMpe6Gt99ORus34/oyOG74?=
 =?us-ascii?Q?8egJxGlymoIc080M73uykVIRqJVzN7kvYTiW653Cfwe9/uj8zyJcoP7t3sBB?=
 =?us-ascii?Q?oAdJX7+92F6PIeDNhVHLVRO1UyXSi1lzpDmUdFwJ24SlFBi2IGW2mqr0LQ/O?=
 =?us-ascii?Q?5qRQeTvN8Av37styfF84BXuUN+1o6qQpuzcbo3YK1Ehj0tMqgpXM2T7u1aW/?=
 =?us-ascii?Q?jfYssiNJ67l37qHPNtJ4vdY3fBkXLcAqkIa6ZkH7xEhst7zwJ+Yv1XAp69c7?=
 =?us-ascii?Q?ziOQd/re+lh7Areesadc8BSg/SKJ4gSBDPKubx7CEYrVTOeKd3ZNLvROuSy6?=
 =?us-ascii?Q?HyYyoVT2/MqqZh+dF2P3lf2NFAyodaOpvfUSz2lpBLOQiXUCK2RJbUKY4YCz?=
 =?us-ascii?Q?VRI1pr6W0C9z790cMlD8PO5AFJMFxuuW4/i1gEMjm81J/3Eh22iAGKRQ+jcy?=
 =?us-ascii?Q?6Q2q4RM+jInwCeoQf2UA+qyCJ49iE4ByXPvVyPX2oWn2wrz8zpSb1+QjRmni?=
 =?us-ascii?Q?UEcy12ZMjiOUCnKnDyh+fgjJWIXEWMO9yosjiBgQEFUK9p9vZ4sN3ZeDvemY?=
 =?us-ascii?Q?ImJaoWB++Zt70ug44WRnIsbW+z4DC7mIShGFsGkJE8pJvf8ctzEpDEvgA2Q7?=
 =?us-ascii?Q?cCBglqRUn49jQcDIcDOrsweP7AvTasSe+A+9ezx+YS8mfzf/VPdYI4lsu93q?=
 =?us-ascii?Q?Q1/stb2eskQkoP4kMnlmZO5y56UFXNKS1/AzeENvwS45NW2qGibx1roY5Yfv?=
 =?us-ascii?Q?nTXrgpqg4aJJ7SpMzk7QiFQ/E5eC0vHqGHi/mULB/6uiredhpnB32JA8C0KE?=
 =?us-ascii?Q?pXBDr8CcBr9p2tqY9F4MYgyTrtk2OdK5PnVeS1IzwHox1BbfZ3CNA+45HPIS?=
 =?us-ascii?Q?qbUpKcqC7AsRFKnErhxwSn/s4NegL42jASZ9bJQ2ef3dmooO+uweCyhwExFK?=
 =?us-ascii?Q?vaFUTPfr/SasXcFBo4or3YC7hnEiuvrh8IDq70tF4VuKgsYBT7Ipn3iS877P?=
 =?us-ascii?Q?UNqGJmhkTjOe5TTfHOMjsZmcr5Pu0C2x53QuBNrQvMfeONxfzdJuF/emEig5?=
 =?us-ascii?Q?u7j5gBtuQCMmG5eErkdfDgIoOZhptkyJx+BK6ngFxHu5WK+z19oeAChBiiZL?=
 =?us-ascii?Q?uJ3sG+SKoIEgGpbLOlGEdiB35ovMY9kp2BvV9lhoF+FTb/2ClErOe+/n0WX4?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WQ8AQjinYFs00cqgM78/xAN1Nzs7RtfguQrxRq/r1e1fwnyR1Dm70m+2zKJGGK4xtcnDpqKC5v4cqTOUjOWuxEFBP+iXn9YULtqsJeYwx8Mz3RD7iCPkXBe/JeO8TbQNzqCD+jJkz0Sfa4JG49Sw+k9u7pSiS85KwK36HdIK7TYS02De8g22mSsdhSj9q7K1pGM8CDZPGy9D2hERUe50skXXKSkM1VeesL/GYyElgtvShg1nfZZTHHYQCmu1RW8Jaj8UxcDfpzdCE2MWhJNYJfrztPVrGy8bmX+Q8dQ+munH5oSI+dFrd6OvhVFTg6jGcDe84zW3XS6cP9OkKaq15YU8EJYE4CbmB+tz4lUuqy5siRngRPN0wuYEsJySeFiS58NT6PLvo2Sy7fC+EYzjG8PL/W9A0jTzaQtLYRGxU/i+KkRf83v8kEUl5Vvvuathzd987ufyFWDHhm4Pi0NlZOZzQM+0PjBRz5hRKjT1DIfqHexzJOkG6q+CzMCcoSPhzNGFHMCapdNq7ByjHlAbhGiB0CcgCSjWaqsVF6VTiaziJ55qJVx685Z1dRJtYC8WM1yrr0Zb4R+sjxrHRyB6RS1O8Y825XnAsiCKtt3zJB4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1af1fa-6b47-4d44-69ec-08dced60ceaa
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 21:32:03.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Z09ZRq9cLxvHF3YNT/AdcKLkNp/bEvUwZtmGuvIWwvymDSF/id/DiVR8YLgYDPnA+bKzTy9TLv8PNldOktBZ8XOKxE1CO2N3p1UJ707dtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_16,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150142
X-Proofpoint-GUID: VlWPORKwmN_wGXfIcHoskGlho3oeM54O
X-Proofpoint-ORIG-GUID: VlWPORKwmN_wGXfIcHoskGlho3oeM54O


Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> index 9b6d90a72601..fc1204426158 100644
>> --- a/drivers/cpuidle/poll_state.c
>> +++ b/drivers/cpuidle/poll_state.c
>> @@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>
>>  	raw_local_irq_enable();
>>  	if (!current_set_polling_and_test()) {
>> -		unsigned int loop_count = 0;
>>  		u64 limit;
>>
>>  		limit = cpuidle_poll_time(drv, dev);
>>
>>  		while (!need_resched()) {
>> -			cpu_relax();
>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> -				continue;
>> -
>> -			loop_count = 0;
>> +			unsigned int loop_count = 0;
>>  			if (local_clock_noinstr() - time_start > limit) {
>>  				dev->poll_time_limit = true;
>>  				break;
>>  			}
>> +
>> +			smp_cond_load_relaxed(&current_thread_info()->flags,
>> +					      VAL & _TIF_NEED_RESCHED ||
>> +					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
>
> The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
> never set. With the event stream enabled on arm64, the WFE will
> eventually be woken up, loop_count incremented and the condition would
> become true.

That makes sense.

> However, the smp_cond_load_relaxed() semantics require that
> a different agent updates the variable being waited on, not the waiting
> CPU updating it itself.

Right. And, that seems to work well with the semantics of WFE. And,
the event stream (if enabled) has a side effect that allows the exit
from the loop.

> Also note that the event stream can be disabled
> on arm64 on the kernel command line.

Yes, that's a good point. In patch-11 I tried to address that aspect
by only allowing haltpoll to be force loaded.

But, I guess your point is that its not just haltpoll that has a problem,
but also regular polling -- and maybe the right thing to do would be to
disable polling if the event stream is disabled.

> Does the code above break any other architecture?

Me (and others) have so far tested x86, ARM64 (with/without the
event stream), and I believe riscv. I haven't seen any obvious
breakage. But, that's probably because most of the time somebody would
be set TIF_NEED_RESCHED.

> I'd say if you want
> something like this, better introduce a new smp_cond_load_timeout()
> API. The above looks like a hack that may only work on arm64 when the
> event stream is enabled.

I had a preliminary version of smp_cond_load_relaxed_timeout() here:
 https://lore.kernel.org/lkml/87edae3a1x.fsf@oracle.com/

Even with an smp_cond_load_timeout(), we would need to fallback to
something like the above for uarchs without WFxT.

> A generic option is udelay() (on arm64 it would use WFE/WFET by
> default). Not sure how important it is for poll_idle() but the downside
> of udelay() that it won't be able to also poll need_resched() while
> waiting for the timeout. If this matters, you could instead make smaller
> udelay() calls. Yet another problem, I don't know how energy efficient
> udelay() is on x86 vs cpu_relax().
>
> So maybe an smp_cond_load_timeout() would be better, implemented with
> cpu_relax() generically and the arm64 would use LDXR, WFE and rely on
> the event stream (or fall back to cpu_relax() if the event stream is
> disabled).

Yeah, something like that might work.

--
ankur

