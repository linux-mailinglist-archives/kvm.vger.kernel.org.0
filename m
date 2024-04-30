Return-Path: <kvm+bounces-16250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8387F8B7FCD
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A385E1C22555
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7266C194C77;
	Tue, 30 Apr 2024 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PBZj239P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dspAs57H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3A317BB1E;
	Tue, 30 Apr 2024 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502308; cv=fail; b=eorCZI8f6X4r/eQ3LrbwV9ziKYpKBnI8wembQWpTx4dhReAHdlXRUngYEl72GMmtsyMPc2RWdPRGIhBF3Bc2x38EWdcqWyM/97QRslJD960eq54uww+kZUSr86XOUtATFI/A3BvKS6bQeMLUE+MHJSlxPRUgfj0Fq27wnGZUu/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502308; c=relaxed/simple;
	bh=RB25v8iDSmKsZ4TrmsbTOiWNYMVuW+7I0GPPGgOpr3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g8AqqXzr+AeupSXjUtT1iIWMSTgla0yM0mf+HZTnkMEShm6TMJEAUUOwmTUhsVh2LtOYus1iExF1fqr+LQC7FUUARJH/1xI7WaqEUR4DS7dQYoVe8Sc7wSSuxcCqPvd/mc1qvZn+aSCnCAEF5Fb9u9w4zC1FY1/cJjnlNgwG2yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PBZj239P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dspAs57H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIgfI015489;
	Tue, 30 Apr 2024 18:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=3KL0ovtz5J1V9K6QyEbhTNrrab1knK22ZJGGfS7NQtI=;
 b=PBZj239Ph2o5iNs3hmzxTgjKRY9d4TodkyCHRRjmrZrSbtYg3JtiVSXpYLazrKWGs/YR
 BscfiOj51bBteY+yljhuygX5l6gsgY56Jgj8ryewHyZVCf3PLq+kBgoBxRTehRuVVhI+
 5ApIHARvOft67nUtx1IuOMmk66bxLfajME+3LrwoPdcpAOYfmzezqpVZSlnGyonhzf0W
 17M8vkAufFF84LGmi3Ceo8fcuNMIQNJZFBP0U4Fo9m/3BMyT9tgt0A4z6sGr9NevRzHc
 WXUmTffV1mzVOTckjfRCF5Jnih5KNYIgO2AaeQQlmT3k43Tv7RBdyFUOqhSLl9hLY73o +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr9cnxfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UI09Gw011468;
	Tue, 30 Apr 2024 18:37:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt8ceyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ0gIxWvbcctVC6z8qZGggnN/+b7LPuRarGTUk56qh1627+eEHVErVU7+a9Yty28aH9r4+EvfLxds9kBCnbSZFnG0YyVMfDdvDBOSwKaJ+zAaebX9YtlTtbNTXBBq4Oxyl6zhtEviy+axIGGTRBcrmRDdOvq2RwEtLadypFv5Xl7xoXVaB0DUGNS9L7zJ3Rp5Cyceif44G5T517BkAy4v+WoK6N/QQkRG17YXGJ8jIxsOricblajDpydf5U9v7kow6PQhaqVcVn60IO0WImv1RSeL0p9Hm5gWLgeu9SxvuIlIAIlOklFMPYJGvs3Yc0vmQxMmYj8XsGekW5An9S4pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KL0ovtz5J1V9K6QyEbhTNrrab1knK22ZJGGfS7NQtI=;
 b=e6Q7Zd3zQqdDSGPp0QK3g5GYbjRhvDyqthlpnTMN9Ba3/q8TSTVIjErdqWDX1cxqiygUS2A06nUvzCdo3GGmbvgs0zhcEXjkc9CIkdp/5vP4c1I9GSn/PUSLtrFp15m2R0nbn82vPTOTt1TrijNZ8fT8dnOwArQOQ66UZ8o4PcNaJKbhk7U2z26hGJweQiEcnDJdSJ5XazTkUfwGj0S4s5vMemXpRfLrM6hL79jK+KhgQfw/ex3Pt/x3bEc4dXSx3f15BrAwAq3wfzzA8/0ujzBgNrJ7kWfJUz7SBZxTSTVZTu1xlHW3MsHTFAtWUZAixUNyjlZe05Nr3AqdmduK8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KL0ovtz5J1V9K6QyEbhTNrrab1knK22ZJGGfS7NQtI=;
 b=dspAs57Hi/JznBOVJR5sN5f3qJeAZpgKxA2tg4N9uIX+SGXdHuVNnLGv2do3KEa2qUA1ljCSMjo88+1JW3M7Q7/TlWoEd43H5YhQwl9c2Y3fk5EpWgcFWvioPYrFyLQk1oCCtg0KqMHk1bj5oF1l+Ca/K3A4D5SwNMbW4WXSm7g=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4733.namprd10.prod.outlook.com (2603:10b6:a03:2ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 18:37:36 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:36 +0000
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
Subject: [PATCH 2/9] Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
Date: Tue, 30 Apr 2024 11:37:23 -0700
Message-Id: <20240430183730.561960-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0138.namprd04.prod.outlook.com
 (2603:10b6:303:84::23) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4733:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e1e601-464b-48f2-c745-08dc69449b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?4goZLogfzvalpY1oxe+U4aHf6IS4GCUl/lO33HWLsLkVxqI9cErwi5I0FNyu?=
 =?us-ascii?Q?i9ZAKz/dOoHZoq3J5ASMxa2LbRIO6qelB4Efw7pWEyDiNtqc81zOgVfmfEuC?=
 =?us-ascii?Q?px+fH+JeW33jqO0BjtcX2JXwgDeArZyi3ePtZtvqFe3C0s4cS+RajTQpRxX+?=
 =?us-ascii?Q?i7LJsIaGXPKdvtIZS5HtkqY9GbiCDcZTeo4UqDdAnEABxzNwVpjzz50nvaQb?=
 =?us-ascii?Q?1JWYsPgzOF4Rh4ciKWxiOixeQ+t5B9Qrv4x5CmLkjUp4TxPouUwEbw1jc+vB?=
 =?us-ascii?Q?TjusicuPFt8+OJMB5Te/eXSNoKnLaLWm/WZqA4PcAnHNyt0v33RyWjmmHMtK?=
 =?us-ascii?Q?PbsWGiqT08AEYlm5vfqt69BZ9CzNYEkKKh9wSvaPdGlMv9ipI+R8A/GXRly3?=
 =?us-ascii?Q?vRWTbBrBI0P1zCPHSYBIgxzQMj8SR7jRLsLQNNhRv95rln8It2BjF6HaZgiN?=
 =?us-ascii?Q?LybzOVH1MkqgxCMbeV5Bk5X1hCeX2AAH6AFscvDz4HE/utKXNkmosZ+ZszZJ?=
 =?us-ascii?Q?BcMTF6thRZNvYdWuh2/fJnPyqXJaJDCQwg4XuVnuoYsea29oeNBljDjsHjh4?=
 =?us-ascii?Q?ofjLrs2R69Sd8c0lQoZckcnqnk7UczYZD0bBQWuxQjMql2kuiRa5wsaHg3Go?=
 =?us-ascii?Q?1/zcFQWjJBx0amdMVd/eNYb4iwjTMNS+2savHkJx9oHriwUhCnzTaqGXeA8X?=
 =?us-ascii?Q?+7Y9HebCjNp/SiwIhosq7Jbvls9VY60YH6lzIQpOSGjMUymXf4fIy6dbMu1b?=
 =?us-ascii?Q?9HWLLRXFxcczONdgbSYXOffTAp5sGECgcqMjZ4cuvCYbCzFHdknuukWZ+76h?=
 =?us-ascii?Q?KMhbMYMa9sl5+tcGTFYtYUteJRg/wVy55+OLdwQ8A7eBQ32dpKAv3W/S3VVp?=
 =?us-ascii?Q?MhCeGr+EKLxlTGKvfq5siCtt9jZXMur4mcAAdxmbXYk+6zis+2MoFsySNq4p?=
 =?us-ascii?Q?R9J6DQUCe1cASUVyIWLQBx2myuGyG5AwBRo3vvevxWpo7oNlGTu5cutibV3F?=
 =?us-ascii?Q?mhsCEtVzgwAUrngtsvA/XxmwAwa8mXzJ8ghQNp2ejY1/BeBosPaR4xFdZjAl?=
 =?us-ascii?Q?TK2ffC+D8+DztYv/zsok3xRVuPB3ocN8TV33kUIHrd+EukRSytErPS/+GDGH?=
 =?us-ascii?Q?yVfq3X8gC0yD8i7PUvojSowlKUq5vJHC1t0iUEp6AcEOmMY/DjokeoZ1Fyg6?=
 =?us-ascii?Q?Rr3yXgh40ser0WgyRbMYUMlp86NRFtFd5HobBSsutpTHuW1Liv4lkHcH0xBv?=
 =?us-ascii?Q?57mASfDk7dg6xj+BsbLGof2/C17sHTIU4ie6WZIHOQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?O9pnGEr8HXfxjz0gvQxxit++cjaE7lkt2ZkROYRgyZzSfwjmXzpvmBw+xG3M?=
 =?us-ascii?Q?Lpj/Sx9jZIjTuh/yHDvA8Bz0yBbFKhLSFms2qbJWl8/JZQcAtVjutPmwt2OR?=
 =?us-ascii?Q?iHIeuj4lhVHrL5TIAs/UzmwgdJYOdrLUAr/BYAn1rY1FDQzomD1MlXQFQAyF?=
 =?us-ascii?Q?FDqLXfs4KodCKLHUgjqcvldNfQeKjxSNOIscYiOd/c4vnjC3zMjUMVEGNlgf?=
 =?us-ascii?Q?uELG4u37iQz+u/YfwuUXTuYGRdzX3LdosgPRiwy+ka+Nt/peDQ4R52k+wLgB?=
 =?us-ascii?Q?PqPa2j1UMrVt7eQeZVGMm2kYsr+Gxi0jzZTs1gfVs57UR+Qc6Twrq7EAFadz?=
 =?us-ascii?Q?tfzh+zv+sJ1FopysbYyB5RYe1fEuCXQVIOaL1v5FdhXUsLHcrOXXxSlxEjGj?=
 =?us-ascii?Q?+MRWLoiiimwlX3mn7waI1c8utq9U+GTydeTpUg7jgviEAm/tvDKA+oSsd2iL?=
 =?us-ascii?Q?7snewOAT5QyrYANrIw0/IW3GXYHlVSp3AoVH3NzEnJuAOs695mRwtMHhJstR?=
 =?us-ascii?Q?jwZpyZN4mQz3lRMn9ZncF7rD2kvAhg6efORKfIk0TX2rJuwC5xwB2lgi9yyI?=
 =?us-ascii?Q?Wy0Ts49TKPRh/3JgeNkWm7Yem1Z76QTSfIZW5tLR7rkXyFl8lH4vSM13Lx6b?=
 =?us-ascii?Q?KxvY5VigVQTTiCWjf49VVk+a/bmWp92qKT2pEj5bbo69FXLCsqRXQZIXyHIZ?=
 =?us-ascii?Q?4mlIOfcPdPGYFGcxsPM4C7SJs1C7WLboGRGpN/81j84ns7q/97YHOLregCcH?=
 =?us-ascii?Q?lXZCS2Vh5NN4g2I/3QM1a2dLrj17zr+T3IMoSR91uIa8f0ddiF+Rknsa7sLY?=
 =?us-ascii?Q?kcc4zlYWWbgs13+u146Vwjv910rcnVcVgUvoTrw7Wjd3Gt/Bmv+UBW5OSIMW?=
 =?us-ascii?Q?G4Kax3EcZ4u7DFkWooHjXzcV6vlvj8D7Pc1ONxzE7asEvDYHaZeNi8rahTcc?=
 =?us-ascii?Q?8XQlN9HWW5YtBBOsbcUl8kYqlP+fkg9YuRXshAoo5CM6C3KqqnNrxCOjrZRa?=
 =?us-ascii?Q?PoUeuy/WZNrncbuVtzh4yxlib0czOPYHhAUhQB3k2ND9nT0kkup3kZfBYxcL?=
 =?us-ascii?Q?Mqdx6p23+8n04u9qEdx9I/lqiolN/v4N3dbkI0gR+SCNfcRicUewVdW6a3wr?=
 =?us-ascii?Q?dHek+Cgx794IYumFJodN9r6qpVFEfikvuAIrP7FsstDe/0iWgDPrFvAlTjXt?=
 =?us-ascii?Q?VfyZKB8whphGt2ePeWOPRLW8nhOMAgXAySzPRhpPK6m5DM2A22ld9EtNyexZ?=
 =?us-ascii?Q?Xb6yD5loCi0cZiaZJtatSVoJ1BdCZT1omop4/U/I8gVeBMgeuzFr97iAH5+H?=
 =?us-ascii?Q?feF+/qsXTSZVEr6QrqtRSlSNxnWGfnyYDSLfFcPdIr7/UxUrg9IyBhJj27jH?=
 =?us-ascii?Q?Ops6wkbP2a2OfucMZEXymPw5mK54vISmuBYfjCE4tFFoN7l7WP0+VJKLaOhL?=
 =?us-ascii?Q?ZjY3WpzUEoTr8BZDfkjLO0T+7sFtQQHWzMXcEHoi762Bu9UAS8aU0rIfnCd8?=
 =?us-ascii?Q?ahyyRyCQViyD4ydl70A94iGDhge46cgFf0ZCh2tacXWNUCacGsTQKRaAKzvl?=
 =?us-ascii?Q?p8/qv6etvbbqAfZBeoUNHikcT1em4+o2g44fTSUaJUhbAtg2Y61Sy8fuXkgX?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0hUNArs6M1ZBNXc41G+yuAfaalAcnQMnwvUY8+wmhA9r3veex1sKWjiRJB5EHbpN7UOAO+YDznAh9kbLnejCWt2BUqTJ76DPZEsdikMbv9Vps8ZbIM3rQ7cHl5reiIzx1QNll7xwv/yKIJS9S5Jm42pBX0Y+boi68Ap+B0Qw8G+E6/mA/gbZTuHhCUZ6a0tKvsMY7k0jitDe3hBPxuwYWg11jrC2LlDOlqHIq7IufKf2E/1ZnKoNiBVt299pZQzvbpn+djPKSNtSojO7Y2QcZFA8ZbxYzX5DokQSW6MXG7XSs8D6FulUFcZSY2GbJ4mQKu60uIRhAJJcnuga7PV6hWjN7CtoFUQPHmjXIx0Te/GKTAbSatwLjnIu+HPFhh5RqahgJWJQhMB9qqy5g02KZrQUyuQnZFKO/T6o7HhRc4ittD8AtR7+OJinqfr4pngEZSZ0huoxP0BHwJb4sbdiW6YhMtIRCg4FwWX+3kbgpoWsMyP4js9xU8bk6bN6UEkmyOVGwZScBFQmMNnWTUdhE6P5wiyP8rGJ7FFHpA285awrA+71rhJZpOW7jBxyD1pIIZondxEHA+olkIm6yXseS9k68qFyYNT+Ys5rpe788hg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e1e601-464b-48f2-c745-08dc69449b4f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:36.5817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: re5leCCu+TRX+XgLBul1aqdzpuUd0U5HKUc0HlGZ7qGZRecqvPBmqlBvdFCgQvRCo9XhGqY+SP7s6a19ah8E+TMubzaRji/uLYGflSZ5tjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300134
X-Proofpoint-GUID: CLA18znf-xxv9ApHPjPuEpq6z09K-fkY
X-Proofpoint-ORIG-GUID: CLA18znf-xxv9ApHPjPuEpq6z09K-fkY

From: Joao Martins <joao.m.martins@oracle.com>

ARCH_HAS_OPTIMIZED_POLL gates selection of polling while idle in
poll_idle(). Move the configuration option to arch/Kconfig to allow
non-x86 architectures to select it.

Note that ARCH_HAS_OPTIMIZED_POLL should probably be exclusive with
GENERIC_IDLE_POLL_SETUP (which controls the generic polling logic in
cpu_idle_poll()). However, that would remove boot options
(hlt=, nohlt=). So, leave it untouched for now.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 65afb1de48b3..6d918c19a099 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -256,6 +256,9 @@ config HAVE_ARCH_TRACEHOOK
 config HAVE_DMA_CONTIGUOUS
 	bool
 
+config ARCH_HAS_OPTIMIZED_POLL
+	bool
+
 config GENERIC_SMP_IDLE_THREAD
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b238c874875a..670ec5d5d923 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
@@ -368,9 +369,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_OPTIMIZED_POLL
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
2.39.3


