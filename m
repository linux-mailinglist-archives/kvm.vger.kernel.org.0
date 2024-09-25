Return-Path: <kvm+bounces-27504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB748986986
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 762F02871A1
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8341A4AA8;
	Wed, 25 Sep 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l1ztnxZh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YVXMMIca"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE3F12BEBB;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306734; cv=fail; b=G1K9Why2djUwPLJwu31Gox14zaI466BMV0tuW5PT0khdWFK67EHQVG6ubiItVED/uQlJtYQNp7HjXUGvl5aX2TujmN9pxHo8A1greWTqZHmunxBTKVD9UpViwdAQanrCy+rFVxFj9zGT3XM4m0EUrWH2Uq0e9ulie74g2ZTmGEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306734; c=relaxed/simple;
	bh=9XQIlePaofN4OHj0PuXElLnV0ilP14vRjC7yLrrN/ys=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=EFNYEkj6peMA50pp1kT3acVh/hbdb/N00feMgc2SAw1aRpPNzlRb3gS9/wnV9yiTrJIF39r3AyZWGU/UMWQvHbnHXHolMiqD9ZzCRJS1objd+58PLlOZrx9SJluYIKaJL4WZ6JSy3RqGxysk7tuWdiCEN51mfeSFwp//76Qf3CQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l1ztnxZh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YVXMMIca; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLn13Z022971;
	Wed, 25 Sep 2024 23:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=V5z5ELDn0qNKsz
	/3ip3qkx+L2h8ENRIkNzoP4s1g5AA=; b=l1ztnxZhDoBYTCKkP77gGeKRjR1CUh
	L1sXIWrJR18H84IXPKQ+mBZLoGq+zr97JbQUOXMXkb/uUoE3jRayJ2kdr9i/+kz/
	aEgszCaCoMMTOatXOxRj69rqjik2qidsRQ24ZCc+v4diezpI1jPulJ0iNxmUtFD5
	cesLRC64XXRgB0G331C66OpIDxi9+/VUGgIw7dCvkEf5c2OzG6C6xacS2IAZwgog
	ugqtCT15Kzu4P0GVKy8QKY/w1SIYt2z0yzlslScfHMXS8+TGxM8DqVNRt3XaSuNO
	EBGbi17GzHp+ssIYFKPseUrLqTR6p/A+z/W4k3QUFK89ykEqR+2KWcdw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smr1bt0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMpuRH032835;
	Wed, 25 Sep 2024 23:24:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkhnpff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8gPWjyRl+P1yo54iOCJKT1uhqVCSi9ZP4eZ+XbcgFUb6nHK2OUZif7np4/49xHtYFvSekivg7l3Ahk16gZ48Dcg+ZtEMXRqqCWrJ3t0l2H0gR/lk1/ySkA/MOpDMYqCU8Gfe+jDVX1VEHh8HAoB2lDvg4DMvf4nicLX6HDj4iS0ZZCaHxdWVI9OmGpKQktEazJMvO+nPfwvQvRdJ84Spbu42ghmPJyfGRpPhpS7PcrxWOP8PI7tXaysQragZ/tv5gxVNZ0VUIICkC5k9rG/UBwgPu0BzQaT1o+vsVm0j/Hmful7UYQHi1uNFPk5BoBGMrX35U/xrXguybAHFwKSYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5z5ELDn0qNKsz/3ip3qkx+L2h8ENRIkNzoP4s1g5AA=;
 b=KejX43LzofSmP7SRBbi5zoHYr+0fDqpe6ZLIo5u6ELBz35mvzoYHOcegqcV2I8MTCJ4fxU9iHySOQtuAqcvkhUonahmZ6FuVPZrpStR83RdenKW0VnFlCR7E8Nd+o3zH9hW0Ncf/bSm4ksA6MMEvTp5vdW0p0EF6/AZcqZSlRLCTi7yD4REqQi6C+ghuzGINs4Oz/ySUU3sb4kpM1uPh+ftZ+79fYhqoEAUXHcupD++k1quNt5j9l83oPBfRzQrOft02s23BhhwwGuUDveGQqnXGBPfhOk71gYOqXsnv8ncsmo0PD8+hHdYoLeG5MX4FYgymYbRfhsVJLddz7w5OFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5z5ELDn0qNKsz/3ip3qkx+L2h8ENRIkNzoP4s1g5AA=;
 b=YVXMMIcacKEBlRAW4W4SDpjPCKL2uX5shrtsNwbo25ELZn74sTWCXkNbNH8F+6om70b+26NZ/69AYXK1IdPAKYfRSa9QZNl4D5NCbXuH1/XQI7kak5xB+naQzylrovojh0pqjnNThhZYqUKhYcy0C8LGf9bnvO9YTmCeG0YWGc8=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:30 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:27 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v8 00/11] Enable haltpoll on arm64
Date: Wed, 25 Sep 2024 16:24:14 -0700
Message-Id: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0135.namprd04.prod.outlook.com
 (2603:10b6:303:84::20) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 62927e3e-7d87-48fd-7df7-08dcddb932f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6/fvo32LtbVJPXXpDm8a0P0fYW6sLMl/Gn4IHSxTFf9+4O+rKSykTPNiYf9p?=
 =?us-ascii?Q?Y2ByMODDPeokz72Ll2CA5k4PXf/1wWqtXRNsFBqQZToz8qFqzyWFu7gIsT0F?=
 =?us-ascii?Q?AL2lkaKT5rSAI6cgZtrGIZbIk36QDZmZKfXr16OlHYiPhPtEeVGuvn7j926j?=
 =?us-ascii?Q?8HqwlCH/r9lhfDxVYhOBzQReBaHEodKx4moPj03czyopD6Ywx75t6ks2cAfb?=
 =?us-ascii?Q?g9MRtT7YBmd9J8iN8ENlVZVPB5rA/gACabVCpbs0IooSJn29YajYR6MILqdj?=
 =?us-ascii?Q?2hDzrRqgeR18W/YYtIyC5QkLT/KOdMix+R3SQi1g4EbvPYIDgSNLxN6ylB7q?=
 =?us-ascii?Q?5hdGDJaWJjnKAUK8rTUpWAvWGODN3WgkmvIUD2muF1QGB87yvQ5n405Ffz3t?=
 =?us-ascii?Q?P+VDpURBAH/YmGppSoAClPi2Q+QoJtsYzlmyFZglwr6+roecmGAUpJPkaGsX?=
 =?us-ascii?Q?V2Y0noTpxRkiWcU6nEnxzLksK4CnbDXe8l0D0GP/5qO2GUB9NWg3XB+itZ8s?=
 =?us-ascii?Q?DhopELMmdWmYK9RShYKNx6GOq5wrhc+Tg5N2G5LHKyN3kiaH9IOe7Xpearal?=
 =?us-ascii?Q?St8rIo1RTtvn4HW6SobXkVpwh7XtDoxKhlCVwZtrYYoXdBM8KwAuGLFXgcrM?=
 =?us-ascii?Q?/tvtgCh+1JQsmZzvOEkNcCjh0ddjXdtKLTOSSeEU8FudcqD9qwbV8VdhMyNt?=
 =?us-ascii?Q?tRMzz0a2YpJf861ByaxQ/sLK3gMua+s0dPiP8AVMf5jS50+nJxSx66CWDeg3?=
 =?us-ascii?Q?pMpweHCgWPk1E5QBrnRTNgZlI19do+Tgq/t3DOrnWQefGa977qC+7LJ6cCqU?=
 =?us-ascii?Q?QBmMab2Y+wrnFEG7KNHL5WXKWkmZduxQO5mA2MswQ3gSQnaeagruyUM2NQQh?=
 =?us-ascii?Q?PWMwnhTXA7h4aWqSOLEeoWBQthQEA20UbB5IeRsA/PvAgHYTMoZ96btNaB28?=
 =?us-ascii?Q?EW7BwjDTdYnnwBcB+ssmxDhmQuowYv+iUQr+yd/IpQLwcNSVi5yrkBflOtxH?=
 =?us-ascii?Q?WqrCoV0DWttJejAzGxHjMUMo6Vy/nxZxKZ9FjyxzFnAkF2crUxNdOrDxxdNN?=
 =?us-ascii?Q?fgR2OxLsJ2zXkL8llMCvIXyQxYg3o4sY7wV/OYMWYNP0ScFlNUzFv6ESFbTp?=
 =?us-ascii?Q?7W+SlmS7O7B8fT3tZO6gbg3CU0ULIEkhx7jk/WImgqEbZl5bX1aGNRJ20lL4?=
 =?us-ascii?Q?+LD2rGeODxGOuUGLujoZptUhGzS5Ld4Qz32glC10CtVJhXSXN+R82r73tNF6?=
 =?us-ascii?Q?xCjx7W9ukNG0JP2L1WONAfl3Bdx0P72K8i93f36H9enAlYo1R0zlge4IYvfS?=
 =?us-ascii?Q?BWo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vfjiC6PETwFQUUXTdjEas86b+7pgECmOsLHcpe+z+hF2j933GNLV8mVD9PXn?=
 =?us-ascii?Q?Bm1KOBLbak1696uMkALNy+SCwxzovA+rbgMxRJtK3linphihc/TtFBW/q+p2?=
 =?us-ascii?Q?/ErC2pqT6UtwnMRGFdAfUS60MIVjMwwNhwBoz+E21qMa8tQVKJY8cL4Mh9IQ?=
 =?us-ascii?Q?QBYkpKeM2ytZXRg5ZSdbLfFbFpeMDRzoRwY+ZZDo+ZQiudmVczAO3YBAeI3e?=
 =?us-ascii?Q?j/mxGgomb7IOqX8aieKp07lUdPaZzOKy+IuPGFsdba6ijVqhezvywt4rGQct?=
 =?us-ascii?Q?t2zz/F9J3mqfn0VD3c10ZzmMmMmLT+bGI2T5WfiXhZ3gulCKT3Oj2KGQxFgE?=
 =?us-ascii?Q?8zkwzoB3n3ubHWqKn3V5nxFvPt2K4R2xi+2tnnq94ZCFUZOW71th0IAJRf2k?=
 =?us-ascii?Q?JOnzbPlMV0LdJt4CoCsE13X8ip3JSsUNk1nTEZ+ZknkSsyn/dETM8bD770Dm?=
 =?us-ascii?Q?LeFwzEweauMB9q+PkBDBS3HnqCjAKAFTVQY2dSoW/pukOAjUploIrdJ4Wvve?=
 =?us-ascii?Q?TRueYYJWYB7giQFfGZipwxXhy/LUccqlKgirJ9W5bA4aq5HlnoX5pE0OLV/8?=
 =?us-ascii?Q?Sb8ZN4h4BGoM41+z4dH3i/GVfydBfBMuG9cY+qxtp2RG2jcCnr9vbiryyJ2X?=
 =?us-ascii?Q?LYKKRzOHXXqR21uVkFwOw/ltwxsFWtpTHrxTaMUa+fdaLQBFR6/U2NdIIkLE?=
 =?us-ascii?Q?sNEVmQT3iPUYisHYR5+lVl8iaggvSPRGyyyaRvMbiFKY3/H/R/IBxzogFatc?=
 =?us-ascii?Q?QOHTdLke4VoeSh+elJgzvpJsiqdJPmibkIFLfussxBvO6tz0n8zWjA4bpgsF?=
 =?us-ascii?Q?phnSQK80NS0rdyxn06Qlph0ggj1N3+bgNiD7Ex8Q5w7KT9GQMOlgdPl9dnTo?=
 =?us-ascii?Q?MtkKmUqQ+EsSLBDwLyoGUuEgUx5CicBsEhyvUgUosw14vwAX+IIYW0oiAet+?=
 =?us-ascii?Q?C0nOLzigJjrgK3tHP7FBDD0YZ6B5W/dnzTpkr0BnVYENncBb2VOF67qgclbj?=
 =?us-ascii?Q?ObnEiEW9dPoKa1ddRU+GDaWebNwyS2KySnWQq4YnS7rhTc4ac+CpNnsPWyw7?=
 =?us-ascii?Q?KSzvA5FI4nhTB2FL7zHYLWL1VaK7Zh9gNLl+1REMwVHtv7VhnhUoJ1/ujmLn?=
 =?us-ascii?Q?DxkN4LARnOdaRDcZr+9PMgkxCLSmdtMiFinGV7WSb8W9yphe2iM8Lw086exn?=
 =?us-ascii?Q?uKwtbdObZZ7NwNTGevLAgKlivfsO/OVWHXur8y68dX0wpn2A3OHcMgBRSvq8?=
 =?us-ascii?Q?xxRijMcSO/VPrJ2+PRkb0j2gg6AzDlvo3F8dm6smbLp0Ez079M+TdP1fbRg0?=
 =?us-ascii?Q?HzY2tbMLFcfBrnERQojHeCiGgpwHej6wGR8zUPBfgLrTNgZbNAvTjaGKLFoR?=
 =?us-ascii?Q?sZKyJ9O6gUUvXRimQb3aU7TV2f5OQ+OwWHfc1e4Y7C428crAayBDNKXmXwKc?=
 =?us-ascii?Q?gAGlXRTUvVdZ2Q3fBoVCgXBNOdvreE4qY8BrgTAnP6oM56gRILEX3W46cziS?=
 =?us-ascii?Q?Ol2mVav+EZrcCIDQbF2TwEouNjsLA5QqDVq7HYRf2q8YfpvdFvGGGC23f/w0?=
 =?us-ascii?Q?sBBPGXfviaE4WbxNG8X8G0hlQH9txE5ey+2V1cywyJeeqsx5vJTE8HZXcue5?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LKqjVvEob2nnQJZCgG6roB1CBQW4INUyR/1QGPcop5YD+SFB2Dcg/uVwACqXQryCBHhdD8/FVzHVUrctTjWArNvGllTtSZhn+GW962WpKb2Kd802gC7MdfWF20GeUaleajRzcsmtCCmSYYnLtRalSOCOJ7USNue0/hAJnKmz4BLkg2hTPtuOjtv4wnbeqWbHanU/YEbgR/PRPXFnsk+ZYUK/hL5TwqchyblCKNXuadqZJ0ZtSRLQtsMlAKo8beZbKNRO4XAL024yt58GLZkkw6rpAz6ozY19eh/h/4xFxZpiYDT+fP8LIoAb8Lo58cOawhZIghbFbhxe12qDmSiGwy3LKXnw70nBTzhTXBWOEMtBQgtqgjg70I6rYiiNwibxmItGrtrtnzUeMmMpQ/iY7CvpDTwAEOeWHfDmDqr4TNjAcFmIBauLV+Joyg1mCgMtZHBB+SK91Cyf3+Z4OF4jttPAziaHnMF1xfceZy7FlO/TjIYH5++Cdxm8kaCA0sADyVP4Ym4H1lMJh2eqWdiI+c92D0f58cPzW+g0foE+htJfGM4dEjR2ZVtCsTtvMcuKqotr4sDqLgPk2iC++mxnon7rC8dwV8DF98/72/eSMhk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62927e3e-7d87-48fd-7df7-08dcddb932f8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:27.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcG0ZU7HZpRZDRIiaJFAeK1/dOd9wDBh14U+51UAwNfbiDpmk5zxdSW4D3J8YMNlpeqbxYaSh3pLNqhsrhSRYKzmCE+0xO36z/Z95CJaUKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: JqMlYiDHGneGDlZRuKuoyrRFo3-T1wzd
X-Proofpoint-GUID: JqMlYiDHGneGDlZRuKuoyrRFo3-T1wzd

This patchset enables the cpuidle-haltpoll driver and its namesake
governor on arm64. This is specifically interesting for KVM guests by
reducing IPC latencies.

Comparing idle switching latencies on an arm64 KVM guest with 
perf bench sched pipe:

                                     usecs/op       %stdev   

  no haltpoll (baseline)               13.48       +-  5.19%
  with haltpoll                         6.84       +- 22.07%


No change in performance for a similar test on x86:

                                     usecs/op        %stdev   

  haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
  haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%

Both sets of tests were on otherwise idle systems with guest VCPUs
pinned to specific PCPUs. One reason for the higher stdev on arm64
is that trapping of the WFE instruction by the host KVM is contingent
on the number of tasks on the runqueue.

Tomohiro Misono and Haris Okanovic also report similar latency
improvements on Grace and Graviton systems (for v7) [1] [2].

The patch series is organized in three parts: 

 - patch 1, reorganizes the poll_idle() loop, switching to
   smp_cond_load_relaxed() in the polling loop.
   Relatedly patches 2, 3 mangle the config option ARCH_HAS_CPU_RELAX,
   renaming it to ARCH_HAS_OPTIMIZED_POLL.

 - patches 4-6 reorganize the haltpoll selection and init logic
   to allow architecture code to select it. 

 - and finally, patches 7-11 add the bits for arm64 support.

What is still missing: this series largely completes the haltpoll side
of functionality for arm64. There are, however, a few related areas
that still need to be threshed out:

 - WFET support: WFE on arm64 does not guarantee that poll_idle()
   would terminate in halt_poll_ns. Using WFET would address this.
 - KVM_NO_POLL support on arm64
 - KVM TWED support on arm64: allow the host to limit time spent in
   WFE.


Changelog:

v8: No logic changes. Largely respin of v7, with changes
noted below:

 - move selection of ARCH_HAS_OPTIMIZED_POLL on arm64 to its
   own patch.
   (patch-9 "arm64: select ARCH_HAS_OPTIMIZED_POLL")
   
 - address comments simplifying arm64 support (Will Deacon)
   (patch-11 "arm64: support cpuidle-haltpoll")

v7: No significant logic changes. Mostly a respin of v6.

 - minor cleanup in poll_idle() (Christoph Lameter)
 - fixes conflicts due to code movement in arch/arm64/kernel/cpuidle.c
   (Tomohiro Misono)

v6:

 - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
   changes together (comment from Christoph Lameter)
 - threshes out the commit messages a bit more (comments from Christoph
   Lameter, Sudeep Holla)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - moved back to arch_haltpoll_want() (comment from Joao Martins)
   Also, arch_haltpoll_want() now takes the force parameter and is
   now responsible for the complete selection (or not) of haltpoll.
 - fixes the build breakage on i386
 - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
   Tomohiro Misono, Haris Okanovic)


v5:
 - rework the poll_idle() loop around smp_cond_load_relaxed() (review
   comment from Tomohiro Misono.)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
   arm64 now depends on the event-stream being enabled.
 - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
 - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.

v4 changes from v3:
 - change 7/8 per Rafael input: drop the parens and use ret for the final check
 - add 8/8 which renames the guard for building poll_state

v3 changes from v2:
 - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
 - add Ack-by from Rafael Wysocki on 2/7

v2 changes from v1:
 - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
   (this improves by 50% at least the CPU cycles consumed in the tests above:
   10,716,881,137 now vs 14,503,014,257 before)
 - removed the ifdef from patch 1 per RafaelW

Please review.

[1] https://lore.kernel.org/lkml/TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com/
[2] https://lore.kernel.org/lkml/104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com/

Ankur Arora (6):
  cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
  cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
  arm64: idle: export arch_cpu_idle
  arm64: select ARCH_HAS_OPTIMIZED_POLL
  cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
  arm64: support cpuidle-haltpoll

Joao Martins (4):
  Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
  cpuidle-haltpoll: define arch_haltpoll_want()
  governors/haltpoll: drop kvm_para_available() check
  arm64: define TIF_POLLING_NRFLAG

Mihai Carabas (1):
  cpuidle/poll_state: poll via smp_cond_load_relaxed()

 arch/Kconfig                              |  3 +++
 arch/arm64/Kconfig                        |  7 +++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 24 +++++++++++++++++++++++
 arch/arm64/include/asm/thread_info.h      |  2 ++
 arch/arm64/kernel/idle.c                  |  1 +
 arch/x86/Kconfig                          |  5 ++---
 arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
 arch/x86/kernel/kvm.c                     | 13 ++++++++++++
 drivers/acpi/processor_idle.c             |  4 ++--
 drivers/cpuidle/Kconfig                   |  5 ++---
 drivers/cpuidle/Makefile                  |  2 +-
 drivers/cpuidle/cpuidle-haltpoll.c        | 12 +-----------
 drivers/cpuidle/governors/haltpoll.c      |  6 +-----
 drivers/cpuidle/poll_state.c              | 22 +++++++++++++++------
 drivers/idle/Kconfig                      |  1 +
 include/linux/cpuidle.h                   |  2 +-
 include/linux/cpuidle_haltpoll.h          |  5 +++++
 17 files changed, 83 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

-- 
2.43.5


