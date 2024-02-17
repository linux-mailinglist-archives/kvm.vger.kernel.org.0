Return-Path: <kvm+bounces-8943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA59F858CDA
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3761B1F22A01
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0461B7E2;
	Sat, 17 Feb 2024 01:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ctXsDqDA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QrVeZ+Me"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084D25381;
	Sat, 17 Feb 2024 01:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708134143; cv=fail; b=ALJ9y7o78ozFbcuuCulSzHRJi78rZWXKTf9pEX+UukaGUuW1eQ7rvSINLHX48/xuWjcD8982Js7kEG79gofBh5I4eqBdRPm187D4LtAROQCu4qNvQ8KW18IMOFzhMOyMR+QUzgtbhBb4M91XM7O7c94gd3TtnivO7471lS7ggq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708134143; c=relaxed/simple;
	bh=2jo48XZSAhz04zU9lCzw5hGnTnx56UcMsLr5lWWD3UY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=eNhdTcNQpyB6NQ92Bmt+jJSszvz6B4Hp/VSZ56IyYjsVvla9enp08oLfPDFRdVSZam62OtKFei+/qBqvYgTnHJhnSZXGUg3wC8SkQcLdf7U61kMmiKDfH6uXY757yoyXeGsZcaGI2QMYyphZRa5W2ISIGQ2bX7rvUXPAgOiV5U0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ctXsDqDA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QrVeZ+Me; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GKEKra029625;
	Sat, 17 Feb 2024 01:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=9VG/ND5ygNkd0nVI/R4sbjSyG1mc87rXXwpPnWDiDwo=;
 b=ctXsDqDATA9riiI8tovG9eDhgtZZFIdDriV4p/JOmFKN1H8JZtLQjlKwWArSr/YBpWFW
 3vVIxsp0Cl6hMTRKyIfcoZM52U4Kel3gSxAsISrildjCTy3JD75Xvb/yLA4SImGkA/pM
 2PoFWA3CQanxmfzXXKW7zELxIrnFus2QIHGSgsgjC5vfWBEYTYLlxf/qB3T6IiG15xib
 O3CLeCs6n+RhRjCqc/4K9mmgT931GNTMKl7soC98pvU2NropKP/5GYquZMAkohOLzxMH
 RllxiB2IEZ7/BYlTS5UfEU7aKpuT/cZ8f+zt6e2KJREs7AAte3Y1OcgTRMGFNm2vw6Cm OA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91f06ut8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:42:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1XEtR029128;
	Sat, 17 Feb 2024 01:42:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak83r55m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:42:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLGOLwedfjBEab8rp06qlsLH33oAh7MINyQB6mv8ROlw2llg5/qVWBfJH5vOUOIEVldAbzlz4GbDKzRnHFUpixJ9tEwdDMjCURizWyt08ofu8RlZBr+zRXopM6W7UjlAbZnlvf4rvVF+yftX9MWfcUpIz8CuTwkvZEBXyQ9/mXZz+Q1mldijr4jbGZ+soqQ5Dg1r2bnb/H6b0vBLyzL0HD08qmzo5SH1eXe1Beetb9MyjLre6At4rXeUHsnPleDzZxf+Hrqal4fuLjJGpLPob6eEIpcgJmUgh3mXbokMfr7EabpUQ0+kTRmpNrvzB+VlLXg4sroHIBEX1KGKjA+h7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VG/ND5ygNkd0nVI/R4sbjSyG1mc87rXXwpPnWDiDwo=;
 b=aKDkCAGeGFH8tS6CEvXUrPvtmhU7o3LNIDaB7HWtcxSH9+16FAItipRtcqcLRlU+Ye7dBB4+aFl5pOBh7Qj/nKkELJAyZSa/D0uN9Y/rTkIfxZTbIoVz+PdGOHFhoMSlTcQgdWFgQJv5lxNxIdIIBp+G5IeGd+F6CCWFYjEfDjxVnBmE6JI0I3Uo50I+aU+3dXweiCzRQjF/Z6QsUW+32Ky4ZawdqlGNhzWjhqKBaJVLuGFs0Xp6bAM/oE+TPmBwB1kkFJRhf3jz8Xn3XAS3YyZJAd4ILVajUsd8bm0daWTX6FDckdmNUDHesIYcMYwMlfxjk0rV93rKuJ3gbKyygg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VG/ND5ygNkd0nVI/R4sbjSyG1mc87rXXwpPnWDiDwo=;
 b=QrVeZ+MeIOqRY3fIIN6/7e1McpX9WfuPw/6pZH35gEiVB54Ce2zflv3zFlOwr2F6SGxUjHpurNbAjUmQF4KKNPgOufTH+D+suY2OqKbAANlcz8SKgMe+Az/SPa5MUvPUso3szdheVPG5QtM7RqYHyeGnLnh1hfY3vGvjJubCryU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7299.namprd10.prod.outlook.com (2603:10b6:8:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.31; Sat, 17 Feb 2024 01:42:14 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.029; Sat, 17 Feb 2024
 01:42:14 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: VMX: MSR intercept/passthrough cleanup and simplification
Date: Fri, 16 Feb 2024 17:41:38 -0800
Message-Id: <20240217014141.7753-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:510:e::35) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f52195b-5012-4444-192f-08dc2f59aace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	aXZ9bbrwX5++x+b32Z6Q1nFbAaJWsJa01I3CLSr7/M0iY/8hiKyohh8W7ipFcMJDRztZ9vimydJ7dXvpxc5f85oij9lh2WM2ESJZSybYkbqF0xE/Sj8tBDFOYu7OxSDFIjP6sDbeaD/XHOOiaYH4Jr/frbNdFGNVwGmPcx5sFKrgcpJl9IRIY1xo7gtWdC+1oi7CGyslqFots/cBLPay6B5oDZRYBYQu1Bq/tDUX7nQhVIfdxTym37v4SPy1wchT+pXfkzVvoIHY3hypE5fDD6Ya4ZvenYLssJY0LbmK7tW8p4jxhZwImTa+sSOlMfRBAfvZgNtFJztIpBgkNFvYIGIYB78zRkOEPMomIjsbc9NVAjw4zoSxDYmbONb6ny88A6UvW89SqhyB80uBKbHi3qW0P2PrFnZcM5dq4ebmquHx7wceQzAfvmWbxu15fUm6MKl9E6TJ0sNigFD7prXw2IcSWo8Nelm8jdV0wkc7XLfH06OXKKU4clOaDP1KdvqlKHmdTf+Fh/zmI8RI5bZvfZmUwoszzEAYBByvxqi/d+JG5krKjTC7oY0zmmkEtrT5
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(44832011)(5660300002)(4744005)(2906002)(83380400001)(1076003)(8936002)(41300700001)(66476007)(4326008)(8676002)(66556008)(6916009)(478600001)(6666004)(66946007)(2616005)(316002)(26005)(6512007)(6506007)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5QaH98QqvnR7t5ycYKJYsNfxpWChPFBeU4Ix51LyDMeEVAtD+Dn29wRVjkK/?=
 =?us-ascii?Q?mcIQOvXqZ3sx41KBLU3THBFdgGC6PP9bOWCcA1uJCMhwzlF2hPEnalNd9pu4?=
 =?us-ascii?Q?JCYBOhYkzm58W0eom/8gxekMdoIta9Q4PsMEK9bg/f9rMIs3e7e6LQUwtNjm?=
 =?us-ascii?Q?xh7r2WWIwyZhA2xCh6e/PfupRDShs89f1l4/2Ga4wCgOiCuVXYKqlI0EBINH?=
 =?us-ascii?Q?FuMozP1apA6qVN3lco7LB4IIM77zgcQXjHanSNCJdZHHp7q8qhckxYKmgaEm?=
 =?us-ascii?Q?Ljiih1tqafUwKIC6Jqm42u/iAR3py7QzcTL6+PQSMLd2Ph6jGz3rKTECQhMc?=
 =?us-ascii?Q?pMmHn6Z4hcIsyNp3qOifw2K2G7myG6BvL8viTRwnvLDnqH84BCtCvjXmGRPj?=
 =?us-ascii?Q?mLjHVquw4tWtzPhVq0J6Q97+p5I7EWl8RCVTEFv0h+iYdiRNARDwTghxsJBT?=
 =?us-ascii?Q?mozOurytyg16CsGdMmqDY1X//TXedhSWWm4d/+FZ+9zG/58hga7+3K1Lu86U?=
 =?us-ascii?Q?QObXVjTMnExH4TZWQrKMO7ZI0qAlI8nW73V2rp/w4Y0X4K57bhjJpjE63urX?=
 =?us-ascii?Q?FsF5HAjbS0KxfcEwR9n6stS8sdPkD8tPwDfTSqtZvyvnRYqZ9sPwn2cWufFY?=
 =?us-ascii?Q?Cj/c/tk0BzEa9vVaT5gVI30wwKHy7rn8jmCsxQes+ItLaEuVpdhyE7TEQjx1?=
 =?us-ascii?Q?5YniA4y5vudOHoTILpNir9HlM1xCIsxXmdxMtHgmn2wr/P6exPXyTBNW67xa?=
 =?us-ascii?Q?33rzCd54swI7IUNSuwi1Wejk3g5ITAc0fhwAIlUAbHeZu0sn2w7hO7abXwpu?=
 =?us-ascii?Q?4UWOpVxj+wRSEIzbSBvPlO6IATYMICkBpb3J9hXJ8nyL7X9CuXoAJl/TJLMb?=
 =?us-ascii?Q?ijOekH8azuIUEJwUzxGwSU2YcOPySQXpgFDq7v6731D0qNqluAWoCygC35lR?=
 =?us-ascii?Q?SLxWltil0Ka3ZQG9pqzFxnQpoG6TDW85t0kk4TtiPMIGEAFMzFMIPLHK60ca?=
 =?us-ascii?Q?DIEfhWCGgtG1GvQN/31/u9q2dmBIPHs7Spu9Hf/XvUTfxs1CdK3T4TepsD6H?=
 =?us-ascii?Q?+Vmydb85Tr0BqqF881oxhhHHJKhDBBra7bfZyGIptTllWQy9GV6SuenhVlnj?=
 =?us-ascii?Q?bu45tM8pgP/995QFfqjP50DHQDKqil23RGhQHtL+DRz8xQXz2BeTU/LPnZ+m?=
 =?us-ascii?Q?fJeelL1D/OWtr5wx4sldLFmJy7UsXbJRcgwxtb64Ox9PkeKLdC4TDR+vE/bi?=
 =?us-ascii?Q?9L6YIFZfguylpn60Jh6lod4IEZvRhaGZISiv16CkR5tHAFmbHZKdgnXi6OFm?=
 =?us-ascii?Q?H7SoF7n/PbWm7UydJjd/s0pGLXiEvbK5+txKRs0EQdovhemZSj796422FZLF?=
 =?us-ascii?Q?zQjri+q8uXRHoBx9aAzYpeTY+A9bqLvaLcW39YVgSwtjx2rbwabDncwqawAN?=
 =?us-ascii?Q?awUN6nkynhdZmdkBghEt478eN19tmspycuI7dx3QClU6p1tJ1Lc9UbudAdTa?=
 =?us-ascii?Q?ggdZP3NBqSKAC6i6LAnMUlhpSn7LdsaxgylWcsVT0t6QPce9kXBCpjqAOMCK?=
 =?us-ascii?Q?XHLijZpIEFnkFJzuq0zISXHngutAkODAdPkGLuua?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CouKW5ob0c7wO4BhsUvXesZYlPF1/GEMWSTrympSfKGAISGypRZp5cxF9F5E35n/+r3Fd3GdsdVCC9KMgIrljZdtkZq7Sek8ccv1CKtlPV2JWNPq9T9rb9m9IhPCKkGH6yTRnRlKppiIpOOQE3lA3Z4MYB8eJ7V41cmFVnTk77izThpylZ5dr8MNdaXyL5+nDTZsOzPUYrPO3D0BNNY61CzmOSGYeADQpXlD7etjtHp0DKXj4u7vir8u9XMzN/twshVQ24E2UBzh+c8S8ITh/slivL0LGLbH0rlST9x8++Na8ozMmSEVnGF0JR8/gsMHnpbPTD2PrRObKPhX9uj0sIF535OCx2dVYkNtFtsN5wT8CJ3ExAvqoHasi/8jC8tesXIYGG7ZIRddQf6Er2gi9I2KbtTm7h63hTYBcMYwyZZqGbmBmPENPRCZeLHfI8rpuJy5+H/up2sVx2eAPXC2ngr3KlmI9LeRW7GIw7NqSe+a2fVKnEerr4WsL91aMfPYaA05IwtYwudq9nIsXqejSIT/dPJwNY0npfFY+stjtF0Pjc+hQ9l7WbD1Kh9Xk196ptG54cx7dna5Tx3NAEHKgv/AfpqsPQtrb8yjx7jUWVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f52195b-5012-4444-192f-08dc2f59aace
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 01:42:14.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llfBHQQqpu6eSf6OAl4XT5nPbldlsJg8dSIsrFOaoUQuMtQaUrJUs713s1WQIRkngAPtOBWXYmn7svmXRT87Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_25,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=951 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402170009
X-Proofpoint-ORIG-GUID: OFph1EIwYze8FlRlE49rjAKACUYmxZy2
X-Proofpoint-GUID: OFph1EIwYze8FlRlE49rjAKACUYmxZy2

The 1st patch is to fix a comment.

The 2nd patch is to avoid running into many vmx_enable_intercept_for_msr() or
vmx_disable_intercept_for_msr() that may return immediately, when
vmx_msr_bitmap is not supported.

The 3rd patch is to simplify vmx_enable_intercept_for_msr() and
vmx_disable_intercept_for_msr(), to avoid calling
possible_passthrough_msr_slot() twice.

Thank you very much!

Dongli Zhang (3):
  KVM: VMX: fix comment to add LBR to passthrough MSRs
  KVM: VMX: return early if msr_bitmap is not supported
  KVM: VMX: simplify MSR interception enable/disable

 arch/x86/kvm/vmx/vmx.c | 60 ++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4



