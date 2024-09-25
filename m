Return-Path: <kvm+bounces-27510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70662986993
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B43E4B2385B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4082D1AB50E;
	Wed, 25 Sep 2024 23:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nCSR7E/z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OMkXaU+n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924131A3BCE;
	Wed, 25 Sep 2024 23:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306736; cv=fail; b=fwT/cTb6arO/F/JyFUIMprYpykxT5yz7ouHKD/F4OtsF5Wl+5zb8eBTW45nQh2CLEHJl7jKVJpHCl9IC0PSqrRivEcmtsJEIQlhOHEt5BWi5+WMKUC1EqnmGTsmv9/aglfil0Zc2juOFrGuldj9BvxP2E9stLQgpQYlBOu9Y/j8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306736; c=relaxed/simple;
	bh=HKQF9VbzfrDmmNAi16NJj7zNQTs3mK9FPNV2eemLJC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L7Dh6D7FYtJx+zfSu1wpwsnrOhTIEYz3Ro2HsJmHGec2on/XCQtHK3KfOalY1gC0dZuRDlG8BWlBSHcOXgGoyM/iy0qc3PWCiS1buLVT68on0haxe9v/YWoGDITF0nhNmu08b1HHkewYNILIBYxSWhVwCbX/RPBd/+t4sGDYxZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nCSR7E/z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OMkXaU+n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLn1ft022966;
	Wed, 25 Sep 2024 23:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=B1X78YsN0cj8Fn6HaXRey6YxVjkXUcZi+iwMeNWnMkM=; b=
	nCSR7E/ziuHEnmWfpvEKs7cj/YOkjjEmAQjOumPrcwUsmPFBRqbYwBOQ/TqVDroX
	Gk7eNW8MVpBGpRSq19CWkeSxQXsoHmJpHD9XG05bThxmpJamWTEtu/nzdZ+odruS
	a5rByFQ9RCKeUKGngzg9mz/PALhtk6xUq4FBu0o11fMN8GVtj9+EdRsp0hpPG7d+
	3ZrOKlxRRmRnzXs1BbmdbX8Ab0L2VXN6abqZNh3rIAsqj0G/++k+KyBOEdfowEll
	sg0wXtNM529OSLs/8DPphivk01686tqAltPCVKZB6f5ZuhUpLjqaceVzlbFHnYIO
	3QEmLuDH4UrNVgbkCsCQBw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smr1bt13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMUr1W026114;
	Wed, 25 Sep 2024 23:24:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smkban7x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKPh2xgLTgPlY/o6K8VIB9OQtS+gDcDSvp6RlrTyGMks18iz9MZu87MfyWCu2d1IckJZyBIIcy20s+vUMMMytCJLFL6qeuh1eJARctH+VAP0APBMQSXd81YldKRYiliTosKcRjz/OgUNwSj/JbSLL1ZkVqqX3qCJR0AEKEzDm8/bhfIstqpSyFq9PO7MnHPhYyq87JI6PccUMV4LTbKWuGzulV8CXE0KrWbzE/HjSoAXsy+ZK8xvESArP/mwXpp24BrGtDD9adD8/EmUgFwfN8JSk/tRyUTUd0ZK+tqGS+LURBY8MxQDgOF/0X7YarAbMQi/i8+JVwAo+RT8vHYyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1X78YsN0cj8Fn6HaXRey6YxVjkXUcZi+iwMeNWnMkM=;
 b=OE/SGNuSqjJyXaPJQ+gzCs5gUzcy1UX6plgEGcVjUeqNd4s+mBfWonxvvcOZzil/Ttzt45H093ZYERh5lOKxNtduI0BbefVpFGcG8zpU1Mc/pacmBWlxUvzumojOSmJS/XIsX3P08vuSKWDtf8rdjNIbd2Ne7E7g760R3NYJICha9JHav8ogOEKTOYuTqqycyu1qHUzSvff83Zk909X+EojBeu26PPpyvDAP3k7H4OTtsaEBzZYOuWGSSnW5P/Cc8Q6syz1qKjE7DOTJfAgDod0loMVJ3UUDH7rFA7FwJJpqt0CPBuYMqjc7uvLXpAqyFlVcTyUeaaSh7e96pow1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1X78YsN0cj8Fn6HaXRey6YxVjkXUcZi+iwMeNWnMkM=;
 b=OMkXaU+nGAblIJAwTtDg/YpoBxmHveWyM2jFJbAHdbAODkqiiRuffpF80SwxZfRU2lHqjKpxQ73DqmXsawvGIiKL01olWdZStha4P7lrLqymKse2lna2mprcD2MyKfL2HgkBKMelyE2MyLLr87NOMbK6LTmZl1wwJlkD+o0vFRw=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 LV8PR10MB7943.namprd10.prod.outlook.com (2603:10b6:408:1f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.20; Wed, 25 Sep
 2024 23:24:56 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:56 +0000
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
Subject: [PATCH v8 11/11] arm64: support cpuidle-haltpoll
Date: Wed, 25 Sep 2024 16:24:25 -0700
Message-Id: <20240925232425.2763385-12-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:907:1::31) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|LV8PR10MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: ad64c0c1-981f-4f8c-ddc9-08dcddb9441f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W3ed6RVZUyP9KJdUvOkfjwXRlrLgx7auS+cAXbXmHKEWgclQshb8Pyk7Kio/?=
 =?us-ascii?Q?bjw4CCcK2htg7ju90BnPQbFPV+ogA4XUazGxQ2pwM2x1zY4iGIBDdY3IJwp2?=
 =?us-ascii?Q?cT0O02XPkjaNdhXDKUJPfNaN+ugnHuxP9xZwoqO+GsBbCuE2Qbyww3hGgV6v?=
 =?us-ascii?Q?DD5bUuv5XIUxrDi2nkl3u2k/UQQ9/XbS3nnByl6Nx2P907aU6OSBowyDbIyI?=
 =?us-ascii?Q?05pCoffDiMop+QyZJIIxBHNj35fTRK5Iaoy6DKL+Q5OyZiXeaOpD6/GehfiY?=
 =?us-ascii?Q?pO9AwGaboMMZW2Jtan+YMi0Rnot967Ej/oVWMgiJwqBfmLq6ZLxf7xU5mgeo?=
 =?us-ascii?Q?t0IwQG1vurlLxMfi6wB1cmIYXCNdTcJz9AY4FhvFeIKOFu0vci9kXv65hsY/?=
 =?us-ascii?Q?9pQa4K5HK1O6nIBMjKObBFAykA04C/XdMpfjSyCt2zePgpFpvtqRQFwk7jeC?=
 =?us-ascii?Q?f0O/bnTlm1Z+K8yrgfcMXpwK28qFrTO4i5HnL8Bkl54c91JpWpsOy7naaLAp?=
 =?us-ascii?Q?2L0i7B8sm4N6OT+bGbbsk4vXokIK7ss9cYgFChPb1NMmK/gzkfAcpqJDzPo8?=
 =?us-ascii?Q?dN2qK8nIVESSt2p3UTt8B9KpvyXByHemOUnDTm3iS8aSTPPfs+q2arour9DR?=
 =?us-ascii?Q?5FWt7G5dpWFQ48bnMHqFNQvKSZgIm/ir707aef/qQkFHLf+RF72PNLl6guOn?=
 =?us-ascii?Q?Ca6pqIZjObP566ckYP54akOqx4oycz9O36t90DSCEOqV0yX1Xcv9KLpaOk9+?=
 =?us-ascii?Q?e8uq2b1gZQiPutAJwaPOtuByTif3AyU+8RkY9idQTKh2BOp6J/8ZBd3h/4E/?=
 =?us-ascii?Q?7vRxUo2UdqepYLJPie/9RQzmG1w4IwEDPCIIZ7GTfzz+xW3t/zncocwNeGjb?=
 =?us-ascii?Q?WtBIuOysBGrdfejEk58BhgvhIQgCkMapjwWSKxT8m1SKbUtWZu42MlP7obgG?=
 =?us-ascii?Q?Bj48af+zFDxJq7eEF6OK/KObu7CJCvlHEBzOjZ8vwZzWM9X7ZABO6iH0Sl4M?=
 =?us-ascii?Q?u0/pPoAiXVaNjW5+z5JAmHYKov/Xlt04X1jud6QFqVdQRGMjaYZCkUUNGcy7?=
 =?us-ascii?Q?gE95L38r5j9eczJd54uh84Y/TSw/gk6ij4e+Qa1+zHlpMX07YZ0JRM3uFy6M?=
 =?us-ascii?Q?hwzTJRDbtcLt3++N3sQMi5mPqmCsUhPBITLJbiNxQ+vK7gM/B/UjqjsTxVLy?=
 =?us-ascii?Q?QtVQiliQPRjLAUfozcIdBwGab4WzXPBBDjrGo2mrru6G/a5IWplHRI11oY4c?=
 =?us-ascii?Q?YZsi0OHZSww0cYnJoT6L+KZvxOC2YoFRT/zguG4oQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FHRDxYc85y7OlGSezQSgD8VKlB71RRGVTiWzAZuXXBMpDV3NCmZlfmkgo6ky?=
 =?us-ascii?Q?Zl/VQrLCS8E+axXpq2WNkzEmEta6bo0l2YAOb5u68PaVu8FRZX6pkiPnDavX?=
 =?us-ascii?Q?fvKyvvHUJ4/KqY4OmaGsCXS7RS0k9H0ufoZEt5JgxoIAAsvp88qg6XTjNzss?=
 =?us-ascii?Q?ys6Xm+FCketATiUlt4wpYjHgcDV9T02G0TfP3WmklVPxHMVxAI2HJbEq4fYn?=
 =?us-ascii?Q?tOCup98B2ATcHB9t0Br12uOSH/ApunFA3X/0qvukGEsVO4mCyiwW3hl3vn+0?=
 =?us-ascii?Q?AakWG3yCBii999Dnm/HZpzSmMc9MI7cff8TBaqGu+W/Dq/K7IvR7lsCH7Mhu?=
 =?us-ascii?Q?l5XyYbtnEwFgl3Wc37M35l12h7bRFG3Es0rDUk1sINljF6ZvbNhLllj2oyMT?=
 =?us-ascii?Q?qMjIDwRulDiFiBq7ca6ZCY/JoXPPR9ij6VpbGWNDpjueCwpNYdyjBwlv6EJB?=
 =?us-ascii?Q?0mFKz8xtv3lwcEn5c3/hMv1mMOSsPgoHyKnh91yr2K8fVTu1900ZM5Rg7ruT?=
 =?us-ascii?Q?DzJqBtbYVMvO9Qp535cyj7cBPbUKA6x4oFMV29SLOZi5VgPqNxTS/DKn3xSV?=
 =?us-ascii?Q?Uo/r8AYwEiiX1g28zZDaHxijdTOMePBYtyWJJn1q9/Kqjb+cwf403Nbzd3ub?=
 =?us-ascii?Q?hNPsvwaLHe0DowZcgSWgMSEYJXi0/F2jSz2wUuFhbmZr7341In3DbX5jRPg8?=
 =?us-ascii?Q?VeYKB3s1iGACE00u/D6ncEbSrBIH2DvFyvyBB2mlX9biW7A4CkTVap9lI9H3?=
 =?us-ascii?Q?0WUiJ9G+AMfleGVhLCoGif3qCPKylFH/24QA6usDZgE8SVMJ15NrySOtdvAO?=
 =?us-ascii?Q?sqJOUrrHWrDnvzZvK7yN5ACdj6ubvArr4tGejfMh8bMsXsW+dSXPoX8KqvYD?=
 =?us-ascii?Q?nmO6K/1tswV5EBX0rfG8DAEV0S96aJQ/i4VoFlIB2DfZ1ZwYWdr7D29j9eDu?=
 =?us-ascii?Q?5iuixG/1j6qOCaVnAW8AT3nCv4wnprckD95joEcaYoCusZOHYmo/K0cqI3d4?=
 =?us-ascii?Q?mOHWD3Z6bhsGXvEWyqL5EGSbUGyV/cMqlJSIsNVoiT1zuu6hxubDvKaBhoqm?=
 =?us-ascii?Q?SkVXHXn0QQPzcrGjcHAe+o4dSwVhA07VhFygrDS5f30idfft6q14Nwdx3Key?=
 =?us-ascii?Q?vHm78s+FS+FzHfiQMjGH01paRSnl9/jqUzPY1lVI2imIZxxYZc8LDld0208Q?=
 =?us-ascii?Q?VPA2u6AkngoZzY2sDIm/HUcL7Nucd2Kqf5FFni6lyEAAHiB8pJaMCC4PgGt/?=
 =?us-ascii?Q?FvV80Mvmph1m1cuiTUpsrBr5MvibHdtMamiMoeLK2+3LMpJ5cFicF3JI9MZx?=
 =?us-ascii?Q?ANuxei8GmnXbgOE2gXvjPscSkTnxKsJ8RRfeyWTmMzfjKW5yfHEYf9AoUx9C?=
 =?us-ascii?Q?+pnBeSqu20EYaS3lc4QrxBAYWzCAVPfppw61MfciGiQQ/GB1d9Eesi4mkYcZ?=
 =?us-ascii?Q?YBQIM1HYARXf4pJSWx14ByiuAJJJAENfAY2FtzuqqpJgagbTCJ6nrKwqIDLp?=
 =?us-ascii?Q?BWkg7+SfELfGL0MzS0pzLrAQlpA57L5Ays/YuXtLmfh9koqVmA/9sIU0ddLb?=
 =?us-ascii?Q?lVst6rVY1I6aoMEd+Ul1ZzMoxb9qvmIXfFOaaOf5Bm1cYRWDlvazV2giB4Aa?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5lhf5fa9LFCK9wwmzu+mQSOkWZG5ET4YAPJC7pA+HcX6A8wl5H0mwhVZ7CqAZ/5mmeyjYljTeH/930AWhUsinp/LHSYorvjhSluEO/RyCM1EIJ5HLB8HIk+4G7jqRKPfSzyw9XVi7OKt/cXBlTATeywyuumqZ8L+zQ58PooNQ7ATp87Ss3juOnCrGN63CA7KR6yw3LMp3nFGzZT+H6nXMFezOWXjua85daPQxHCcq2KTVCIaMWBaXaKKdw4msX0ROZTgx84TbliyOz5gyPZesF9V2rO63PyHSevnWqoL7r727y+nT7hFGma4H+veMTNDmSWUmgZ5nTMuIR4iBrVNZN7zg4HxTIkBQGsurHxV+H1ahh7drU/otwE4JL3TZ7dJbgfoKt7oLfZ/NmGKA5SV8NGFKufTndaB+9Ar7aZRXCbfgocKLO+XOkIkiIt2bhLA81NI5xaqy7Luyd4UdhhRLrqoLhT3mmCyokHHpQKKOwnKYq0gWHPGyroPVrE5GFm7qksBs1e7VWNWOI3gZNRVCI1hUZ7iFkEnnIJAeJkbbfFvCJJwabxQLcWTuuqsaN3GWQgBlosiuuA9kRl3SsNouM78g+uqFfURcg8wa/HNHDM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad64c0c1-981f-4f8c-ddc9-08dcddb9441f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:56.2718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2xT34rneJ/1CHzgFGs6JOjgPsnHbU67geWcPgZptCQqjUgIW6i33zZamdX1LtX5POLrcXMmCPR+x1OrDLi4xLarNovydWuJ6wgQ5DMiysY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7943
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: 2wcIx7t27r2Q0zq_zn-7MQg59D1XUwjE
X-Proofpoint-GUID: 2wcIx7t27r2Q0zq_zn-7MQg59D1XUwjE

Add architectural support for the cpuidle-haltpoll driver by defining
arch_haltpoll_*(). Also define ARCH_CPUIDLE_HALTPOLL to allow
cpuidle-haltpoll to be selected.

Haltpoll uses poll_idle() to do the actual polling. This in turn
uses smp_cond_load*() to wait until there's a specific store to
a cacheline. 
In the edge case -- no stores to the cacheline and no interrupt --
the event-stream provides the terminating condition ensuring we
don't wait forever. But because the event-stream runs at a fixed
frequency (configured at 10kHz) haltpoll might spend more time in
the polling stage than specified by cpuidle_poll_time().

This would only happen in the last iteration, since overshooting the
poll_limit means the governor will move out of the polling stage.

Tested-by: Haris Okanovic <harisokn@amazon.com>
Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/Kconfig                        |  6 ++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 24 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ef9c22c3cff2..5fc99eba22b2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2415,6 +2415,12 @@ config ARCH_HIBERNATION_HEADER
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_CPUIDLE_HALTPOLL
+	bool "Enable selection of the cpuidle-haltpoll driver"
+	help
+	  cpuidle-haltpoll allows for adaptive polling based on
+	  current load before entering the idle state.
+
 endmenu # "Power management options"
 
 menu "CPU Power Management"
diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
new file mode 100644
index 000000000000..91f0be707629
--- /dev/null
+++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _ARCH_HALTPOLL_H
+#define _ARCH_HALTPOLL_H
+
+static inline void arch_haltpoll_enable(unsigned int cpu) { }
+static inline void arch_haltpoll_disable(unsigned int cpu) { }
+
+static inline bool arch_haltpoll_want(bool force)
+{
+	/*
+	 * Enabling haltpoll requires two things:
+	 *
+	 * - Event stream support to provide a terminating condition to the
+	 *   WFE in the poll loop.
+	 *
+	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_disable().
+	 *
+	 * Given that the second is missing, only allow force loading for
+	 * haltpoll.
+	 */
+	return force;
+}
+#endif
-- 
2.43.5


