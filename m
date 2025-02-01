Return-Path: <kvm+bounces-37066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 574C0A2480D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3420A3A3783
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 09:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C101514C5AE;
	Sat,  1 Feb 2025 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TiNpkg6d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dnKBhqX+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57A149DFA
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 09:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738403872; cv=fail; b=JOuAlIiDQR3fa6VlcAowq73sRGlTdXLBwEd2c4H1dsw61GgtdlMPk++yRIKb24wkEbLzlScp2QvMlsqMtTf5UX4wquoI7ZCfid0Mc+9zY3i+HrJ+4S1gJH7XtzJEhhNqtVQZS061b3aZlGK8CBEDy8VJyhn+dC3hc4MyJ2aIIm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738403872; c=relaxed/simple;
	bh=rfIe1NYLX3k3cNFlLIW5ebJZWGZJMQcdqp8Cq6X5bKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uAk5bGNLs0Hn8I51XLtGryAyIUVfFPFaut+gU1CjZBKmrEyHiPqEIBoseG8sSsXjMlgkPC2IvnB5PeSeEAseKydoF+zdBIksvKrJ/CUV9ANgI6cYGfmVu95gxF+gEUXBd1xC2IfSQx7N67aL9Pc8z4CDRmnwd5DLMFuCTzUhFdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TiNpkg6d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dnKBhqX+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5117bTQp013468;
	Sat, 1 Feb 2025 09:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=NRPGY2xL24KNpo5IRIvaBIs3SCCk698KFm1h6Tc1JHQ=; b=
	TiNpkg6dmMoplC5ovVNhZYu9fU/eFwi+4ybH2m9T425Q8HzZTID1na4TUmQXkdMn
	dsJfrSwCzZ4KXeaBmO99j7KjR0pz8fESPRm1ol3SvWNtx2I14k1536V7OM0iNfky
	ZHV1CenYx4YHFuul56Jjlk3FJoBhio+6vId8QYy3P9IdaeET2D/3TghtW07MHEnx
	GkGrToEMHr8DIK6ywUP2Us53FCmWjfOejGmyCEvdOQlsZPUMFSYcGsQKN3cD9Qg0
	MamNFNOnC1/kJ4Pnzx1IE61v9niUSElxqQOBe5xFiklTVVWP58MbLumSVXgku+Nd
	KwT9wstLf6siu+XmfBItyQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgr3be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 511959fk029933;
	Sat, 1 Feb 2025 09:57:35 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44ha25fbkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkX9hDl5tnCjU6JR3uuIDfffLLI5IwVVlADOfxo2xBQxK0058tTQw0MiZXJih28Ix+2n1/AVbbleaF6GIf647jqKgVemGVB+CbzWxtCxg9zKkVRcqsBX/VJ8N6SIUY7fpc1hw8880jpMq5ELYd0HGkgdYeJBpAot1yffrRQIJYRXpWhGFioyr9BgXbCDNLIdnLo5fBXYrWitfw3aN8NRW8rzk7Tsp0mP3ehlbMJPtHOXNc8dWkmHrKEkimuxftp2JwUshZHebubYXMDyxPzqWd2352J2LJW/2nOP+cFoa41yc6vEXwOZDr1FJlIl3CcKr836NKuIwBDBsWa8uXO1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRPGY2xL24KNpo5IRIvaBIs3SCCk698KFm1h6Tc1JHQ=;
 b=JAU93XIwqbZQLYZyGZCGCEsAkweQYJQEpGi+fl4wwNHbAQtE9AFhqLRoIJFzThRfJoy8howPrDwdxE9WbA1qIPZxhDQa2mz667rsibw5WZLFzearIi/5ll+ybNMZWOVTfWkv0XeOR3wL5vt8vRKbB7D4tdRJrExVBFUiNKx9Imih8vxhcejIbH8V1Rpul3D2Zwk9G+Z8vUn1dRy0Ceu8MlwLbh4sVKGuuWJfJ5VCGXIwMHg2UgiJi8x/8h3UargrYiB/F1XQOFBk7pMouPDAakGdB5/1oE4MFk1/qILr7UJp8+g/wwVLswX96h6/BXLCia9kiLCQNRKyf9Tce1d/8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRPGY2xL24KNpo5IRIvaBIs3SCCk698KFm1h6Tc1JHQ=;
 b=dnKBhqX+4WORQjfZevhm3JZ0gDE68lHNNEc96RuXiOaXoCZtG+6zjjuJM23pem71mqAzXabFREoYshmYMksUm2EW0rRT95UEbFg13PiEEQKblEd5YoDmhmKso6F8Pew4ZZNM18x0to1U30wgY5oXzTZ5VfVw0jrFyPP0N2+8Kg0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:32 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 2/6] system/physmem: poisoned memory discard on reboot
Date: Sat,  1 Feb 2025 09:57:22 +0000
Message-ID: <20250201095726.3768796-3-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250201095726.3768796-1-william.roche@oracle.com>
References: <20250201095726.3768796-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 8025aa18-7e66-425d-436f-08dd42a6d8a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nk3Qk25FrRVADUDNOpui4GBEkiZhEwQogZLBpibr9Keus2J6B+FFl3Gi7Hwy?=
 =?us-ascii?Q?d3JR9uzNZs1MqCauQfEnN8bE8EagO8v1zvCmJroCZPA2Dfs4Vzdlp2VSw5a/?=
 =?us-ascii?Q?c87EBl5cHOmt8buwF7HEyxk3B5UsXrLJS5bDfmlzyTA62th55+VibChn1JAX?=
 =?us-ascii?Q?2H6VFHJ78dQzrgbqVsZYg1Ubn5GtCiDuZ7aePbMEv6gC7aiwQ9nGCEC7wKEh?=
 =?us-ascii?Q?o2zFrvpxSTT7el+g4StKkHRQ5+lU7Krj9qXcNhAwpQ67ToQdjhY/gZnvazlp?=
 =?us-ascii?Q?tCLXpLpKs+BONx2tE7/73abmgW+0Uay8t+YKzm+wpldHfYn5KvGyqtWIqbsp?=
 =?us-ascii?Q?ZimjIgAcMH8a69U0XKeN58jb1E2hRDG8ElWvZicRNizgUgP8ZF1ni7MgsUvR?=
 =?us-ascii?Q?yf/leTjF9LhfHFW8Ba82BGf10qTFOUy+Pl3NYAqZmEr0mZxs8KB/HCIRjIoA?=
 =?us-ascii?Q?ckRrhBMMo3RgiPwoRXleIcyKLtCytIHqnxd1aEMN1iHSRwwUW6993DoRHGD7?=
 =?us-ascii?Q?ujpC5dfSzfe+pV918njGPkwc4RlDc73D+HpX/1wxU1qh+2S6RLFYPJ8YanHS?=
 =?us-ascii?Q?SKjP2lzk7IC2lE/lGgKq2r4C5WqdGNhRfP2bkbE2UWGW2D9a0gi+Q/FuDESE?=
 =?us-ascii?Q?sKVPqiYqCsInN/R6MhAivt1WZeFXsmjmp0Iq6nyMI3RG5pvyud2MryOGTEi9?=
 =?us-ascii?Q?buE6+YYXJH/YkUxqniLu+W4rYu+KWR58mSdxtCRPvqJsVy+11pYGOEkfjhlQ?=
 =?us-ascii?Q?HvAwVRWNFlXh9r5EdP5cVFYobN7f8b2P+rkWtpwIE37OxHQC24SvERdOeJdZ?=
 =?us-ascii?Q?t3dyoBv7HJ12zfUJw/ZzA0jPtNq0ghQ1IY5iu3xjEwXoNQglsetcyRIrUfg3?=
 =?us-ascii?Q?IIE8u/5NnvLwlsYYTa1Sb0+Pdj03H231oZlz12lds7x1rUPgns+fyFNkxmcE?=
 =?us-ascii?Q?OkTIXh/OXSKkwPeED4UiNOk0UN2lbejwfBFtcqlRrrzpQZJXF2V5c023RNLq?=
 =?us-ascii?Q?GC/K9/Z4dpeEI1bfgW6vfSCb0p7wCk75J4vyrpSgOaxvazH/pldLhTy7zm8P?=
 =?us-ascii?Q?cxOG/WoOA/XhyiO/5sg9G42T7DNqAarHzFfYiTVoxN7Srad876FL0nBFOw1y?=
 =?us-ascii?Q?cz47Coyodd0wph5J8Ku7fnwxv3ool8DCQcmsX6Li5aRAbwvslra7iubF3seg?=
 =?us-ascii?Q?ZwIRQhqP53pA7WNX9IUfYaPbsXwX+x9KPOg7qIp+QTylh65awTSrlD1io7c6?=
 =?us-ascii?Q?gJ87GCpe1QBACWUZkJZDcRS5YsSK9SsgKRHoCcMXOFBh8GMOZ1HPMlNdqszG?=
 =?us-ascii?Q?sNFH8ImZkv4KglKkcq6EJ0LgfY0fbHrBI17/GJdsAgjkyZ8FNPVz0NlPdZ3D?=
 =?us-ascii?Q?Sk+Ogy7phrp9fAxGz/kbq7LkdtLX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FWrf5L9+pjNVN9h5hDioU/+XVzdWap6taheZRQObOwHa0mjq72E5jLOefgqJ?=
 =?us-ascii?Q?e+lVA5WddhEkox28Cuxt6nFzpBIfh4c+YWEZuca2TKVpTzBghC8Mo/gM+5e2?=
 =?us-ascii?Q?m4DbCc1ncNbdYII2kBoTOV7rpsVWZgdawoFHU//99RkKVM+/VMjLlwKNilEs?=
 =?us-ascii?Q?vuox8RtgGYRTUnAEv3wutYFSRJANQf2cm2E1iQNQOGN3euV99wDs2R1aJRnH?=
 =?us-ascii?Q?1Rf17GUfXTHWRhwJQumjPDMMrCRdsWUmmomRP7rAtutyDbAkVoKz1dgkDndL?=
 =?us-ascii?Q?E7ge0ZoGBr/0FoTqOyDgnh063y58nSi8botst5DCeI1okBwSiIM9KP5f/6T3?=
 =?us-ascii?Q?iWXo4Gp3+3ESPusshrMJYWg6mDVGcntgpzNGQK5MYliiMlbLSwbRoPVt87Fj?=
 =?us-ascii?Q?yaqOC55VJYe5MwFb0FdOm8xTl5sk5KhQBUm/szg43YTNnV3N6YlLC4KtKLrQ?=
 =?us-ascii?Q?VonqiXAxNn5hh9cl/s/BF0WWkXiDmr+4Y7UB93WCS9XXkaCM7Tcv/mxdUzZH?=
 =?us-ascii?Q?7KJAq6HmVa/oydUrfQFutIac08vI5iYz7/g1sk5SojTb8ZfF6rw4YwnSuHBG?=
 =?us-ascii?Q?1LKwDx9L3mJNVZGkxA9SJhCCte/kHdH4PMKoTD8Ii/PnI/BY0fOriRrNPNWL?=
 =?us-ascii?Q?01siLhrcD1dIBYdmudjUIhxkIJzWZ4aVGRcncXJKFkKxKA7gulmm5fMLGx+o?=
 =?us-ascii?Q?iEGuFWibNA608zLv0qV3GBa7BXEAvEOjbBArcQz1+3Kb8L0DyvbwpGPtHnNF?=
 =?us-ascii?Q?OEIjhLxb30ttGA4z4ntONkzxNKgkIAni/aubV4CVkcJ9gK6+ykclT6WNEX50?=
 =?us-ascii?Q?K8Fbyi2lXiy5Ha+wJmwcKNmR/vhuXCzBMoHYEWTy+J6lOcslTh1DngfONC1I?=
 =?us-ascii?Q?JwlUnV4a3PWxORy7vEizNjmyrma9cwybYyNtbBBn8hiZgu1CuNDOwNG6jTkm?=
 =?us-ascii?Q?1tvOARWjCNDF9OS9oFzJ1cak6NcG6gzTLpSBgkDc7A/jZq7EpRlwM1I/AVOq?=
 =?us-ascii?Q?SyIAW2LhMQ7Srttrl21Yks4mQZ2Y3lu+Ol0tUi3ZN67T4TdXpaHjXRVN3AY0?=
 =?us-ascii?Q?D6YdO19H93sS3Ea74tkUbPcSl8ttNvw3MU2cQqbD4JxH5Wf2lbwMHuk2c20T?=
 =?us-ascii?Q?ZRqLPJl/tB5QmL9vZri5SyB6K2Y4n5H97OTddRamkXxAP/QxwShzLnJzzLvj?=
 =?us-ascii?Q?KbV/V2ZjvQtqKjphE2DQ2K8acsjg4goCBDSjcPqxXlKBJpDp635Cg0dZQH0h?=
 =?us-ascii?Q?YZ+6SedEdI3O1WYCgr6W1L996HrDAtVTLk6QBL2L+GhxDXPrqnrcN6VS1OJ2?=
 =?us-ascii?Q?CTnintpdvZOYox20XdmJv7aKkKnaz7aOUCwspeAgMEWLnri9hTcWswJbX6HB?=
 =?us-ascii?Q?yJe8chwJlwB0gRgtHY2wnlcUkFXurNq98VAq6xrtN8PepOqHz9JlNY6xlXX4?=
 =?us-ascii?Q?w5PnCKrhlNXUH0vKJYUP7bqz+q/Sh5cb34cYFBZgdAjJrSlvYT19huFyw7mX?=
 =?us-ascii?Q?GpI9P7L19oq0il9StM4J3WB0kOoy5rtTJk74brL2xxEzaqZPhblnzvWtsc+7?=
 =?us-ascii?Q?jvYs0dXYt1oKAX/qrLN4PYMIdHlYvhh6zhubVcgvMBWYTfoa7Lw317EO9PiG?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fMOf+H62nyBJAdJsMCGBFjF12C0MP66N6wcM1XnFgcZ+IMe3RywLTAzYGFz2ToXK8E7ZpBxIfsPpVAYqSOOLm/Q/rgz7P52p0wp0YKfZVNCsJuOKH29jg+8N633fKgT1ym5Hw531ajDCZ3K6mtXyA+kqLjGCzszfboouYbtKW9fq5WFB1/hpHAjjXSPWH6mDSWZBMud9JkM0e0YZykVYXezuExKkW1LPFXwjhG9fzZfRrLPbJMZdSML5XzeztUv6VN6z8xgmiZ5jE1jJx0O6hD7Yuv8SnGROS6PnkyzDu4x1xB74ziVc7P+XjKTb9ag2c49vl90QtYEY4VffS2z8MDmk/kOI6gakQWQg7qNsU+85Uuo1x/12pVyCNHi7GrJI0i6SuRrGQ8RDWUaRRExPxgbIeulY8YEcGNjCtfxD9e+HsDZikJZgFa4b4BXvTrhquccvc5XsFvwdu1ACRtJnZOSS6hPJ+1S0AFDyVVxJ+gi//ADFOZY/E/aEmhUJmNkH+bvMto8BJPesm/1KvJw+4FlKAdXHdiTwYMNQcH3oV5Xb+lhnAxI1meu20DiUZtzM7lVjgqydcHmXyCVDXJLSwfUtYMaJLG8EkPxovZzcTSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8025aa18-7e66-425d-436f-08dd42a6d8a5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:32.4810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYOrIKifDkOZEeQlrFdAVTv8I5Pub2heAuWEhuHnNT5dQreSBpvMhTWGPMNf0llO6npOTMJCEtnpMX2Kz6/cBfZYAQlCXAQ+NkkjZ+tolrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502010085
X-Proofpoint-GUID: VaZMT_kxOODyQ7tnaWm3OIXGN_IPsxF3
X-Proofpoint-ORIG-GUID: VaZMT_kxOODyQ7tnaWm3OIXGN_IPsxF3

From: William Roche <william.roche@oracle.com>

Repair poisoned memory location(s), calling ram_block_discard_range():
punching a hole in the backend file when necessary and regenerating
a usable memory.
If the kernel doesn't support the madvise calls used by this function
and we are dealing with anonymous memory, fall back to remapping the
location(s).

Signed-off-by: William Roche <william.roche@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 system/physmem.c | 58 ++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 3dd2adde73..e8ff930bc9 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2167,6 +2167,23 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
+/* Simply remap the given VM memory location from start to start+length */
+static int qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, size_t length)
+{
+    int flags, prot;
+    void *area;
+    void *host_startaddr = block->host + start;
+
+    assert(block->fd < 0);
+    flags = MAP_FIXED | MAP_ANONYMOUS;
+    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
+    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
+    prot = PROT_READ;
+    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
+    area = mmap(host_startaddr, length, prot, flags, -1, 0);
+    return area != host_startaddr ? -errno : 0;
+}
+
 /*
  * qemu_ram_remap - remap a single RAM page
  *
@@ -2184,9 +2201,7 @@ void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     uint64_t offset;
-    int flags;
-    void *area, *vaddr;
-    int prot;
+    void *vaddr;
     size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
@@ -2201,25 +2216,24 @@ void qemu_ram_remap(ram_addr_t addr)
                 ;
             } else if (xen_enabled()) {
                 abort();
-            } else {
-                flags = MAP_FIXED;
-                flags |= block->flags & RAM_SHARED ?
-                         MAP_SHARED : MAP_PRIVATE;
-                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
-                prot = PROT_READ;
-                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
-                if (block->fd >= 0) {
-                    area = mmap(vaddr, page_size, prot, flags, block->fd,
-                                offset + block->fd_offset);
-                } else {
-                    flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
-                }
-                if (area != vaddr) {
-                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
-                                 " +%zx", block->idstr, offset,
-                                 block->fd_offset, page_size);
-                    exit(1);
+                if (ram_block_discard_range(block, offset, page_size) != 0) {
+                    /*
+                     * Fall back to using mmap() only for anonymous mapping,
+                     * as if a backing file is associated we may not be able
+                     * to recover the memory in all cases.
+                     * So don't take the risk of using only mmap and fail now.
+                     */
+                    if (block->fd >= 0) {
+                        error_report("Could not remap RAM %s:%" PRIx64 "+%"
+                                     PRIx64 " +%zx", block->idstr, offset,
+                                     block->fd_offset, page_size);
+                        exit(1);
+                    }
+                    if (qemu_ram_remap_mmap(block, offset, page_size) != 0) {
+                        error_report("Could not remap RAM %s:%" PRIx64 " +%zx",
+                                     block->idstr, offset, page_size);
+                        exit(1);
+                    }
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
-- 
2.43.5


