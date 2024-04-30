Return-Path: <kvm+bounces-16259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 628418B7FE4
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A00E281CEF
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6D219066C;
	Tue, 30 Apr 2024 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gxLNRpFW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zOa1MnpZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32C21BED72;
	Tue, 30 Apr 2024 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502314; cv=fail; b=iKya7Ag+YoGCxgfyMkZNxv05MwAYNS1nSiY0PXE17pQR/Je6d1as68gxXcv3u7NANVMJIsLOFNn/BneetYEsrG54m2XM/L43cd7YoXyNzoy/JX1JOYBS2TiXqb0m6sl8u9K1qbsyA52LKQ+aUEQF96q8tfs0AYodmXek3JKDytM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502314; c=relaxed/simple;
	bh=AeGn1trKCVc+6iz5L/MFvIjh1g7tD+Rw8YPPwOEvlcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H0vbZ1jrHTPCfV5A4mahSfkDzeAWo2OkP3jQ8CIQyyWMlSS1X/zja5YvPF/oWZ5OWKM6UD9Pn9hgNlYWJtQcFxtD4LjMNoOdVhQPlhBuGJEZPO59Q1uecl6QEg+BwoASNM6Y5goXYgluNLJvTAUv1pDQb2UDFX5KTzwGKZxd2f0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gxLNRpFW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zOa1MnpZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIe1N014225;
	Tue, 30 Apr 2024 18:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=0jYPmxlQLlR57Tk0Hp9NfbW34AvEBNpgzAF0tyq6clI=;
 b=gxLNRpFWJfyiL2xwvILd4GRgLDl32fvHBz8Ip30xUNWKJmGtWe5EqIBM6zccJw/q4vC8
 LVsVp/jfwn+Q7dGiG1CJaKrKHTah4bnzhQyflcKMvyN9d1xuQnZ+s4M9SnU3KulsjDVO
 tqSzVYX6fHjk6PV6aR99rQDnigwX5XA7gVq3/QDEPQZb0pvK9kt1aefzF1g3GrbhXQHn
 RhO+sjp+ccZouc4c8eMje+fkr1YRoc7U1Z7dHpB+yo54Q6Hys/ZA5tq9i798Du6jPIl2
 zmKzRE9t+1okcYNWqPosoZ065B+Z4LR2vkyoJaBopLhe2z264bVCP9DNh3QZxIzXaAkj tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrs8cntj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UISs8Q005044;
	Tue, 30 Apr 2024 18:37:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt7vk17-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKPbwMJN1iR3j7l4s1jorg4Blz6zFeyq8ELLckweY2KeMvtX8SlZwcx3guCKSOmQtMQ8jnAD0+mxddqA4mJWX+hEU15ThwufhQUsP3oOOp+toZRxlvZQx1in0sNyniFwtzXMqNQnUrbBGLaTk1vKHByINoZVyjpRha5XXChlMrqdKYms9sTfLZHKMki7mMHaJAsCEdcQTUcvW9uRq4szuofdzQ38EtUScYwE9BH+TgD4HlyM6ChuVcgiw8F3kKKA6LcbSF2Whz5bnDbWL+H/m4p1jv9k/YxIZZQTjYzHEiDyikP0SVkisVqWXQ4SJxXOb0rK8k95B5JEhD8afIf8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jYPmxlQLlR57Tk0Hp9NfbW34AvEBNpgzAF0tyq6clI=;
 b=AG/FfEJMcCdNUTjzXZpKcKdTQqS1wz7SK6U+/ule5Whcom3fDfacavPy6vvUsD+djU7Z+WeEFa4/tsoWfFLndSj4cXFCs44SaNSF+N/dQ7+7uSzhFlwqWd9shDGWgk801GH1fs8lcgisRpxQGGM6B0LDT+/VKFQP9RRHduRWsIQ37sExc5i8G589ALQ3QzPDVZR/ioOMYVxmxebhk1s/+ifUiwj3jh9zKc/I2xgbIXwe1t+IxF78tJAwYlrnBD0DoNmw+F3kvYtRFvZrRgqJmkuDytdN/WXXKtY00+9l7z/X26/LdkQUdEzBXlYWaBKVZCgA0be7PeQhXfDr/lw9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jYPmxlQLlR57Tk0Hp9NfbW34AvEBNpgzAF0tyq6clI=;
 b=zOa1MnpZq58Ru3n9pOBJOHCSVx7uSfBh0j/p/2Cn2Equ7WxwDtoGAgow71j4WwSCkDjT5c4kOmuTh72O1bya/cSSd14pckZPti/IuZTFVpolRCsj5PS1wYx2lEO4A7aNyuHyA2ZNEHWNZ9X96bd/I12BpEbyEPDPmxjoKSwSag4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:51 +0000
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
Subject: [PATCH 7/9] arm64: define TIF_POLLING_NRFLAG
Date: Tue, 30 Apr 2024 11:37:28 -0700
Message-Id: <20240430183730.561960-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:303:6b::8) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 60596754-9082-4f68-0924-08dc6944a46c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?G0e21h9Q4ZaUoIgwwNqlTlOZ1uzVpQLiyBnNtkbK6eCgBnA9opNFo5kH0qYR?=
 =?us-ascii?Q?6ZkIoKcrghIv4ipSn9UkyJU47DFzswn3IqgoA0tRIw82Dc47uUu8efEg6+1b?=
 =?us-ascii?Q?7DEPfAWwy1rhf9YKAgqIZBc+6EHprMDPksWGaE/gI6oyqOSRxh8psL8fXx6a?=
 =?us-ascii?Q?PCgbXb43KutaKNzo73RlRxQIPfLvC5yEayw9nQAJdw8RavKt5Yg+N65VYSmI?=
 =?us-ascii?Q?sGjwqf+ind0/G2IYPuamr29FtQ/aSrHj+1m3MnHiBeoxYg8QdJIXxRPNleOg?=
 =?us-ascii?Q?vZzG7j3mKv7r7mSeJf5yX+QzleGaWkB6nDgCfIaRBImYolnRVge/Srzu55jr?=
 =?us-ascii?Q?Dgjc4altzdB/0FnqTIAjpAmhF9aK4Vpmg7Aw87M6esGh8eCKSuV5r4ZJx822?=
 =?us-ascii?Q?c1hDrhi79XLYtfcVxYi4R0Mnue8kcVix4FsrKH1r7MIZmgtp+rzbtDrQ6cRN?=
 =?us-ascii?Q?8vhH5XVE8p6DRVczuNkGwcu/qSImaRt1Dia1Jfg0G3UTt/ZXtDEENu3JQR/C?=
 =?us-ascii?Q?+gOedJ1QFvAduMHd36GaS93w28f92hfyDoexgy7m4iTIqOPuWPxHX6lkTcpT?=
 =?us-ascii?Q?elBNfI8y/5KdR6fKau7mO6M0rtERCICXrXGmckX09/GaKe2slJDDFvNHf+g/?=
 =?us-ascii?Q?oo29I3DDaS0Pi2TDgI20VmDiKJpFEcpjYHM2KpzyGUPi2k5Tt6utodNKoBwj?=
 =?us-ascii?Q?wml9vErP5leAD9dsNsAogYzprcQoKNy3BPKxg+3goO6VB4Z7naGtyN/Xxuxz?=
 =?us-ascii?Q?em4DsgYFzzf2jjKUCLwy6sGwzsougQudRnehdepH9ImQ8pScusuBT2dHq2bQ?=
 =?us-ascii?Q?rRx1X/98XRifQSEZL87Mmpxgqy8KmBqaKGlzgs0sgqIXXWXhbFs2beuBoUkz?=
 =?us-ascii?Q?l0Hks2GJREPaZXBBiDsVh+T0FM9LNLkmAZW+1KOy37MiKxZ2SAlaKg0LVQwZ?=
 =?us-ascii?Q?Z/VO9PeGLpUaWlxnCY98IJAQD8W/xv2wYZ0lBzwhmCgQkmnS3jumUg/ZVcEn?=
 =?us-ascii?Q?60cc3XT4jjNQwFg3EA5oT1G3MVdrMAxD9u9wa5AHfKY59E+62qWHMimLQh7E?=
 =?us-ascii?Q?48ZnAgfoWVa/xpa1VG8FeC7gHmrS54zv1NjmYBxdmzqZdw742hQB19wNXAaM?=
 =?us-ascii?Q?ue4s1jD+T24yRdFCo+JY9oZIGa4JUWc2+nNpShvJJqc1OMxvw+HWxFJfPmB8?=
 =?us-ascii?Q?zs7UhM2z26PM843FKlHIU0KSp0VldwJCbhgEezU+Kjp5FZcwjh9av65Q4aLW?=
 =?us-ascii?Q?SKzzdlUsT5es5eW463XGbBvVDIGupssoAnINhGAXLQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cZoB7ZJboMyvXO0oWAR3PZXj5YnwleFo3pKiBPY/HqX+ZVqU+NMT95z0HHcY?=
 =?us-ascii?Q?uaIpuNAyoYTF1yOp1yWIpmSyj98j149uU1M2FlU5jrv5WeBpF/2u/r+33OkB?=
 =?us-ascii?Q?n6Jhx4qEjDRNhexUsiUMwqlhiz99Ix/0EyVwnLt+KJZuv0Sdfv7kpuw+wsXX?=
 =?us-ascii?Q?uRM3FLoHDqPgY0X8cq2kFaDwmQnl/FEXoaYfI/ebwow0+mHLkS5SHs4VHban?=
 =?us-ascii?Q?K/oVO4QSxjoLOFcU/4x44ichmkniOP+rnm/0vY6WrbNQWZOKAw5Clvu6Kn+E?=
 =?us-ascii?Q?jhePfuVynqbwwqz3z1xWmgO5JGq2z1I0qGX+qko2v4I+U+UbKg7iAS4OgvU6?=
 =?us-ascii?Q?FTjHuBqgQ+0wIHPbulaqVnUI5zW52DyzcLQnM0ksld3+RqaKJp14HnWdyg3M?=
 =?us-ascii?Q?0At/G2QmAl9SlSRU2d9w05l6ipTP8mx0xoek1lPZnKNa13zUUsYkVL16ZXOc?=
 =?us-ascii?Q?EPjjMA7uwHCDUSennnPtMlcX/rxAiT+qQuzsXi84lzWqWtdgbpHdRFtz4b9R?=
 =?us-ascii?Q?wepObSq6bIheKfv/ulhJm7kkLxw3gBLCavO9mnqrRWz2OXA74pZBJJ8Z2gWA?=
 =?us-ascii?Q?ZC1P8vuuXY+FuwpLu0iaKec+UEXVgQooORNH9kqgwxUlABCsOFIADr4TwJe/?=
 =?us-ascii?Q?9OMXwafbm/ttcXXQfBz8CKnnPHSN+BfJ51cAnHWbYAL6l6872MCviqbEdSrB?=
 =?us-ascii?Q?8BCNlCMFnmYJedWsPophz3EBRcRJ5MOT/bPhj2jBx8KgcOZ6J4VgUTgdXBaJ?=
 =?us-ascii?Q?GnCODGZgsN11ZTxcKfIjeEYvQJiPWXLot6eLBisEMFF5mHvtCHtn2vMliDbl?=
 =?us-ascii?Q?v4vxrdpWYj8dGsSUmDU7ACdUihO+5WajZqOAdr5SVVQodFDO+lmHAJuIniaf?=
 =?us-ascii?Q?xHA+/fxryUkDNswKd1f1PhW0lM9NAEyjBvaKNVUev8pnrMuIoUqSq3ndwXLG?=
 =?us-ascii?Q?sYSDvLkoHaK25PbpTNdmMNKxfLrLT78V52ajfZWN7SgTYRB3nbDlyGJRuMb9?=
 =?us-ascii?Q?G94iOkFmRv0kkt5qJGvEfvwUbNKA0jqourzJqR0q/zSGgSs/8XmYdYA6Aq11?=
 =?us-ascii?Q?8MOY09q/Es6WGXLwE8szOrqIjWLOGV2bRbcqgUJR0hqPAShcsXVtzmvnon0L?=
 =?us-ascii?Q?AeN81TmgRHzleU7ABeOW0AiR1uvKCwdiZJLvS2AL/o7oqDxdgkQihVEf4VOe?=
 =?us-ascii?Q?iI0AumYZil2u8bCgeUDYqDOISCoL5CdwsznYmcBhts6wTrljg6AY41bigLYG?=
 =?us-ascii?Q?ThhKq6BJgIIz25/o4+ErvaGjpJur33ZGsHoKnmdrDP3hGhvPcGaiQYqdXC33?=
 =?us-ascii?Q?X8jeqh+6Hp+e7EhG1o29f5aTS84LQneJASPiHwHctg2UtF2Tj6hNHDYRl81S?=
 =?us-ascii?Q?qVLaM5XY8proBCCgMSoRkQsou+disvcahIY7hkEXHUexU0562tmMrz4991zv?=
 =?us-ascii?Q?1dUhXy82zOnpx+mE0s3oxTa35MAMvqxXuU2luxGTvrnJKoTu2PlLw/8iCNck?=
 =?us-ascii?Q?3hEjyCJBVMsa+3TY2bxrEFQavmZc64oYwHr9ufM+cawmcJyWOhSW+RkpYZ++?=
 =?us-ascii?Q?rRwbWxl/4J5CpCNj8ScH/VA4aU1EKc0oHTMdHxmJf0Rcr853o6ZOV00FjxCa?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WxINAY9bsvlhTxlVjnNwPfeQtu5JsbCQXuLea9gLClvVrQK/70tKFtvwb+STb7tO+4P3Lu27utQ4A9WQzS014f32g1BdHwm4qejhroaS0vTDSYigOk/H+7BMRQFCQlaxKOy9cytg2kdTQqxPJi77ZGHLswRXB3P1/0H8AsDEIm6ZoYNOSViPeQcw/AhaHCgRc7b5ZzWTFqpXzrXiSnE/CFEYPBGj47SGrhovHuYD8XzHfbT1RposarbaJu36uYBZvPg8DvpBzRtt8Un5Uyd146Ap0WwZvhT9eEJhq7Gg9u9/J+mSc8MSjqcLGk5FqDKuHWGrOFvZ8Z18TY1ki2hZwSHcuuXtKAv8IBhQ2cFo7uDhftRXbI6qcSx0BDwHl2RnaxDReZHiAdogz/99lOLKO83GbSEKRHkK7RXY49D2kLK50gzGbtFwl0OrcedoE3RVUl21188fxfTonfXHW03ryUoaGFTQrKksdZT2t46CVhzabamQLvmRBQ40qkjYtvmpf+6t1sPkhV5tT/m10Ifji4SH5WgYTlhkQhEigPY/TEdXEabLlfrbpMZdG6RRJlcnenRk5xPBPSNS/ooUyVp1SEiukBTwzNxY/J/mfm89teg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60596754-9082-4f68-0924-08dc6944a46c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:51.8022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTF8w+uokm9DjlGgrHBOVqwpyOg9UobMFmeywD/mCj6/ed19VNiniRVGPbBqFTPJWXYjterAfi8fa9a+Y4y1zXuRdUfeJax8JEGxEuIbg90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300134
X-Proofpoint-GUID: VTgAoIDHJw88LwEhztUsgl2f8VHMkhGA
X-Proofpoint-ORIG-GUID: VTgAoIDHJw88LwEhztUsgl2f8VHMkhGA

From: Joao Martins <joao.m.martins@oracle.com>

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
cpu_do_idle().

To add support for polling via cpuidle-haltpoll, we want to use the
standard poll_idle() interface, which sets TIF_POLLING_NRFLAG while
polling.

Reuse the same bit to define TIF_POLLING_NRFLAG.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e72a3bf9e563..23ff72168e48 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#define TIF_POLLING_NRFLAG	16	/* set while polling in poll_idle() */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -91,6 +92,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
2.39.3


