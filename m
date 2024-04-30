Return-Path: <kvm+bounces-16251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0978B7FD2
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED6E01C226C6
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03EE199EA7;
	Tue, 30 Apr 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AnkW4YDC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J09BEEFe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B0417B509;
	Tue, 30 Apr 2024 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502309; cv=fail; b=B69Arf/zkiSyKb03AsDX4iPkrOtQrdhQOGlhQHhRi/L8k39HJbqGm1KAMtYwOfoqmPPKqODn2mCyt1yDGVTrNjXAoo59vgtX7mOjTl38rA65tKudLUHU7p7umt4ltBy6iTj9nsVF/Pvl66Y9LLF+CB2pcaCIYFXXaeyyS45jLK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502309; c=relaxed/simple;
	bh=0HC3Oy8V0Ibd8uWiTBvva1JyLZIP4eTtiWSq9DL1o40=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sffG7XpKpWXlirYYSCpGOWu5vZAyJOgb1uYe+DKQLIFbAYlJHjuqTn1Rw9iCRFmfpEnqxnC6Lu62PWnSD87oKCZXdIuz3NdkWMGAC3IToHY+KHNhkE043D+k1TvA1Mw2cKJco7ri4Ih6xoMxeMJj49rREKsYDWEfRlJFCqZ5wXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AnkW4YDC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J09BEEFe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIbDv015449;
	Tue, 30 Apr 2024 18:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=n73fTaTDWK899CwwgEbSj2lPuVttzM5z90YLOVqfO3U=;
 b=AnkW4YDCW6zm9D5NqO39HNZIcwEVaHKOYjySMiwiYIE9lwKwjVBKffhuH6MQJImayOBh
 S9qsoICBJqvH2xSmH2a2pyR0gy25jXQUiBynoLYHKe0Ov6DuIhJ/28plw7XYJwv0JrXc
 EeAzyZYKPlmuYKevopBIUafzmN+IH54At35jp9UvSOg+LVUpSAfyPVlg1EYAo87KLtf4
 P/xeh4SHfW+8EFNue1T514XzvaGizYKQUi5qTM+fiDAnDjMMBjmNTqUfM6K9VUziVuQq
 5dDVR2J1IeHao1DHIy2HophOU8/2lJnQilHbP5PYmFgfnirDPeYwBdRDJMuZxj7X+/MF Gw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr9cnxgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UH3ZUi011336;
	Tue, 30 Apr 2024 18:37:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt8cffx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMaAsPBoSvofRBpRHTKPXYyTRHQZKmbsjqgIoubwoQT+kr2etkHJa9UQGk9I6s+UkL0Dpx4RXfA1dYZ0Jm8eVQxty3WvMNem7kse9HC2AZiYZU5TzltqRykq/1FfEN+s2wWYdlxPDXYHDWZohNu/9LRFzLnME5VZvGTsZ6GWYAD92+Kc9MRMgaiH+WACHnK3f4mLr/ZmWYQnQq8PHwE9OVUAMyql02Hkl0QWGgS7Hhe+4s4mMNBRMkYfJtvrWn4OEgudhazCpE9D8We7dkcgFDvUeBJ5sufxjbo40S8Qzga92srrcMSWbUVM6Y9rhqoTYRyTBnL2TSlhBJJSVVw7Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n73fTaTDWK899CwwgEbSj2lPuVttzM5z90YLOVqfO3U=;
 b=YoWhTX3UD0uwa7fR2+DbfEuG3carlVZunmp6T1vbXXzlVAhPY9iSIFNhJACEjhkdpYs5zHF/hbpA2AdcHEeJXqB9o+cd5bxjkcLBqu9I2owHGyA4hm3yCTL/Y3xOIvunhAXmhiFkQqSCugz8xKNikL5U9ruQzPeUmNJW/KSEIHR4IQVh6W1MsGVtF51hTVSaDojijea/6vzowwmtDne6CSjoYKoJiO8B0s1A5FiOLR6yJJGstNuySm2kbNau6sIYUdiwX/smIbcx94CzFlJvEeTXQHmCja54ULXPe+mLDkdoGKhV9x8O0I3YzUMWTDbaZh23VDYwhfOIXuD3kY/QnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n73fTaTDWK899CwwgEbSj2lPuVttzM5z90YLOVqfO3U=;
 b=J09BEEFekSUz0M93vdzudOfC47OY8Aw/RaU7NyPsKjHz9+atb6CTXUceHGXhTkNOJa0HOxWexXlwsBMOnuWiuWJJp8Qa40z0IK+58lLWSyEQRhJxtk5eJUYqKm+2HxnJRsjp+NfuNc6cQSVJkkTfmVyip1OrLX70jJ7H7XFrAVs=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:53 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:53 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH 8/9] arm64: support cpuidle-haltpoll
Date: Tue, 30 Apr 2024 11:37:29 -0700
Message-Id: <20240430183730.561960-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0334.namprd03.prod.outlook.com
 (2603:10b6:303:dc::9) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 43cf9dc7-bd75-406b-e896-08dc6944a562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?6LdFhwglhNqepU6yqsoTSdCnpKiuItV7snCCW0Qu64wDZ22PnmEejrE1al1J?=
 =?us-ascii?Q?xmQCjmt7XSXRwsbdm9PxjUjMpXlgmD1S2NAswMDhpEsaakp45OihUq32od5v?=
 =?us-ascii?Q?fQDEPS5Mn+1tPUxhqe2CG9mwDlqsYMMK64hkdVKB+PO479VGiIF/KQ01Z7Y0?=
 =?us-ascii?Q?xG+xlfVZRxkCgzCwkfZSf8LAYuAWxhzAzv81E29VdJw3fB8ZmBV3esvVdICW?=
 =?us-ascii?Q?gxAsoF3bEum4KswLmY/tpQWYXR4Ay+05AJ278X2d8xfrve1UGqcqvLmhZTz1?=
 =?us-ascii?Q?j8lA7vUliDBV+Vfu7X+c3eL0pzC2HRPM1Xg2m4Tm6wLOI4cTwEQgBixibLyN?=
 =?us-ascii?Q?/ysdNK41sn6IgpYlXGiz7lYKExKXubYBBIt+SLZEDd5nLUagdwTpEdslxkha?=
 =?us-ascii?Q?wVz95F0hOMeK8xEe13jnzqAx6C/rSO47UZZP9U438wN2wDopNM4n/8qwwFX8?=
 =?us-ascii?Q?gP7n3eE6RaS4zpD/Ji4GSJI9c0qebMjZ7lwIsmx5bHU0yY19RNrRtfFB/7/i?=
 =?us-ascii?Q?7dEimGeVaAAZR5EYbRzbgAGTEa1CJcd3kB8ZfuF5KyYhdQjtQEe2AtsPiiGy?=
 =?us-ascii?Q?8uFXsCr6BNjz74BNi+udAE8BdefoXCohwIUaUGBrb+iEs/cQd4Da+f2KbxVx?=
 =?us-ascii?Q?vM7FCQuVxqry66KWmC5BGeuvRgUumFcKGTpj3FRfskLPJSFomkeFARbz4kqF?=
 =?us-ascii?Q?ean8gCOBROOH67FwpNSVWIt9HBy6ULpeNDasBJHxa71vp6KsNe5Px7szRhh5?=
 =?us-ascii?Q?DIqtq4uhSUQrJDvXDTsrLn6nby+NSxwkrHp/cNe3UAFuAqgyPazQpSPuRy1p?=
 =?us-ascii?Q?Ntjq4P3qPOD4gVCR6dUjavGdqGlIM95zKT4b2o3sAX17THCDzVq3AVWx1jOT?=
 =?us-ascii?Q?LuHhLJpB5GsBPoOwFIIJ1GJPaXtfsvoJ9Cai/j6iVpKpa0+YSjnAJRPhYikc?=
 =?us-ascii?Q?1VLTvl4RsluDZCy08DQNpeKJZWmdG5LSzqCtjtonupW+Sl6iDYPB/zaOKaJa?=
 =?us-ascii?Q?ib9EcUa90ouqlaIY4r6QcPdKtmV8ilkhJSto9g8JX9Pg3u4y4JTn9K03SmdA?=
 =?us-ascii?Q?bkiaoBENkchzFroO+6CHEaKg1rLh+uXtWHbe0IYZkGrNW6BwyLaeSfvdwzG6?=
 =?us-ascii?Q?wDVvis3qqAfoZnGkTZkyQp/AY1HfZ4c4VCeVbvgGSaIGrpPLV9GxjpByb9Fw?=
 =?us-ascii?Q?4Wg5+Wr91W7OZH0U7aoUhcFJ7wiRD5oSYw4OOAnNAHyGjTbUZw9xvSztkeYZ?=
 =?us-ascii?Q?7B8CsVcuz0ysdqDC5w7/Vgj1qouY0PiF2mL0kzigNA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?J6m/VrUz04NEfdvUNZRome9kSqrURaKWoZhvTp8957WdiTZLGsGc9XEIzdIW?=
 =?us-ascii?Q?90MD0bVaXQbn+eZfdU4I/oTXCskpLWB7xmyX8UUx0RE4jLF0K8OhsWJ5sEbM?=
 =?us-ascii?Q?T85NdARhpj+8nS5gOQQByFqZFhIALQulJaTDf/vU1V8dVfTdwXML3eLp+jws?=
 =?us-ascii?Q?s8q/SYNHqKpyIu5w+n1gheunRwUVd84pRcP5mr7ZKMzJVE1LtP/oq2FGCTlu?=
 =?us-ascii?Q?OhrJ1YcQtJLh+d++gTIz/Ijcs9aXsS9bOISn8PKPZrMHJ5qcMAUowxjPjtHh?=
 =?us-ascii?Q?CpnaPyTXy2CJ77FQeesPwNFaFDmV4PLnmZ/AHVU04aJhsPtwG7dF7Niq58Ze?=
 =?us-ascii?Q?XTEdDeBDaUgtz6G9xUzBWppOtD1U2m2a8dZgAxR2HKZ9ujjIkxCqai6n0kVu?=
 =?us-ascii?Q?MEQw55t6G1bBocryCaPN67XGdESmg5jlZVoU/XlYNot8d5a7dOTzKFyjsIzq?=
 =?us-ascii?Q?60a0RfLcSQ/goP+DD1R0PducjZnNnz1UMowaPsuWzhyQeYEEA+PDhFduGpC8?=
 =?us-ascii?Q?IgIFFVDC4JCCm/jSl8Fxv3dPp6GR0EgIz3niz7MKKBSKlNonlUdYMJJhvmOq?=
 =?us-ascii?Q?g3R/arEdmc+jvLb9bTP2nenW70ueDBpKUzjfBOF17Z8k30WnEFPJrOCIt3oO?=
 =?us-ascii?Q?KwtQCD3EhWPfLAD0o4W+4gAd0Kuqhyq47XQ/rBMA9mSXipuQa/cdt3S10AQ2?=
 =?us-ascii?Q?4XZFyswGzWNFbHHWbSnpeX19/vv2F+zxsT9SmfH1Sk4z8o7nL+eQ3NyiD0xD?=
 =?us-ascii?Q?sRxN0moGTRGPr4pZDU13Wsud6cQswAEhoFY7SeFaWeFqiRDQ5ZVszv5OHEfU?=
 =?us-ascii?Q?52LmfdwlhZDoiUbfVNCUsGMTbc9WD+0erImf+oFbTReUhXvjsYzGptorbn6r?=
 =?us-ascii?Q?ayjVra97QFP1SCesiB+Vumn0iZf9iocJrkR9wYKpf+uXTJCAJ7IR+Dfy2NJv?=
 =?us-ascii?Q?2bnKdrKAVU6drAsHWGwZas2rX4Jwa6DfP5WP5rXYIDeUmHrB5k+Mi3VmLklG?=
 =?us-ascii?Q?bF4+E2HmNlZuMZSAna4Y9wK9NlLq7dngroDCpF8v6oPiR+Sj1udZUQIDI+El?=
 =?us-ascii?Q?EhHUSGWfUWDG2QjNbLsP7IMv7SxTBAOtlyEdrIzyj9HAD2NTMpq+IZUI/nIq?=
 =?us-ascii?Q?27uKa/kxLo7lUCG+JOPzU1YdHYZR9Zh7EIM5WLL2xv2fG7NPQTecqgAVy8KO?=
 =?us-ascii?Q?KV+mpaAGgqaUNv1CIf41S1p9Ew9cFI2JdqlzZzEp4/Y4QAwP+Duu5837tlgD?=
 =?us-ascii?Q?GgUSeI1nhaOus/7wBmFHx2TEREUVyUK3QW0kt7awDImmPYVO43MVnbhhYAsW?=
 =?us-ascii?Q?TXpWrRt+3ifGa0Ne4ht3UAxM52k6w5STkcrKPzUh86FOOMrII8kb5IpjldX8?=
 =?us-ascii?Q?h0A+jkhTmVcuU6d7IsRE5/W2aRh+98TYNi7U0Yt13I2MtwP5WSyjXMOgm5Jp?=
 =?us-ascii?Q?NmFc1bfCzqVNm3OPydDxxwKh2BPu8bsXXvt3mzVx84RiJ/mPnsmKorMD3wqH?=
 =?us-ascii?Q?yS4toOg6DRp5MR3eJ0V7cdcXc940QO7C8BZhjD2sPW99urI6IWSvlFDotQu5?=
 =?us-ascii?Q?bik67GR4Bu1ZwYmAnqtr8G8mVREaeOYOsVFgGlnz0+jYOhTAAniPWqGZDEy5?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LKNORSDji+mluv+1OLeN8be2yWn225OUL5BVyOl92SMa9qZTSy0rtorS+QtORh1y937NUie6Wdgkp3EvtmttF/sS3XKWLuxRvfvks4b7Yhvi8QHNP2MwwBZipTVuAKhbWMyQVM+WwCreNaRv09MbfG8P38YzLHksht2loh85Op2n1dQJzOVvMJX2vmMrp8bN/SY52pYDDTTl2modiWz7zGbQjCgW3k034Y4L1OE2b/go5yBcrYtUbsGcS1JKto7YOtMo5aBp08WaY2saqzCesSt6LjrvLRDguko/k9jkgY2otgO0lZpRQnNc0zJWKbaV1ozWliJwJWJvXr1K6DBWBjUQophagaFRZ6OIGEBSnYf55dnS0kD+ngNyF2B0umCJd9en9tlDBqgNRd90QIPfNsKBmPkp3s9/zxAJ6BhMxNcdtl8D+ldkyQMDSnz6SwcT/EBuS4ITaWI4KRfKx0HORm75hdF2rspSb6+UPFTinXXppeD8cSBHrCuvbi0ZDXkzSWnvwluYO0HWtulrC6xwfxB7RNEIJf0OXP4oOMhpxz5biDI0YDZoPfDKQmku5r0HjHM3J85mayGu3f5CMnb1d8+eRl77fmiTAHGYxYO4vOk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cf9dc7-bd75-406b-e896-08dc6944a562
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:53.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOqZs0X4Vsl51wpB1AHw5exGWvrCeRqb3lV3XucoK4L29iPoQJvX6XlsQBjMCBQjzzogtqxNy+40iIf4wb+xBUKuvw+tqbzL4UhQ0Cc4YOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300134
X-Proofpoint-GUID: Unu0M4hw8FftoV0SKgs_ypO1t1R3gUE_
X-Proofpoint-ORIG-GUID: Unu0M4hw8FftoV0SKgs_ypO1t1R3gUE_

Add architectural support for the cpuidle-haltpoll driver by defining
arch_haltpoll_*(). Also select ARCH_HAS_OPTIMIZED_POLL since we have
an optimized polling mechanism via smp_cond_load*().

Add the configuration option, ARCH_CPUIDLE_HALTPOLL to allow
cpuidle-haltpoll to be selected.

Note that we limit cpuidle-haltpoll support to when the event-stream is
available. This is necessary because polling via smp_cond_load_relaxed()
uses WFE to wait for a store which might not happen for an prolonged
period of time. So, ensure the event-stream is around to provide a
terminating condition.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/Kconfig                        | 10 ++++++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 21 +++++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7b11c98b3e84..6f2df162b10e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -34,6 +34,7 @@ config ARM64
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
@@ -2331,6 +2332,15 @@ config ARCH_HIBERNATION_HEADER
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_CPUIDLE_HALTPOLL
+	bool "Enable selection of the cpuidle-haltpoll driver"
+	default n
+	help
+	  cpuidle-haltpoll allows for adaptive polling based on
+	  current load before entering the idle state.
+
+	  Some virtualized workloads benefit from using it.
+
 endmenu # "Power management options"
 
 menu "CPU Power Management"
diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
new file mode 100644
index 000000000000..a79bdec7f516
--- /dev/null
+++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_HALTPOLL_H
+#define _ASM_HALTPOLL_H
+
+static inline void arch_haltpoll_enable(unsigned int cpu)
+{
+}
+
+static inline void arch_haltpoll_disable(unsigned int cpu)
+{
+}
+
+static inline bool arch_haltpoll_supported(void)
+{
+	/*
+	 * Ensure the event stream is available to provide a terminating
+	 * condition to the WFE in the poll loop.
+	 */
+	return arch_timer_evtstrm_available();
+}
+#endif
-- 
2.39.3


