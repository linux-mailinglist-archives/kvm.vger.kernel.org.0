Return-Path: <kvm+bounces-28830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C8899DBEC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E9911F23A58
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778C715956C;
	Tue, 15 Oct 2024 01:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lPYoco90";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uFqIAlDb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C53042AA1;
	Tue, 15 Oct 2024 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728957272; cv=fail; b=LUqwcGjM3jIw0IfAZZmoqk5K7iDX9tGjK8apqcijteXS07kcS7A6zulQxizMcR9pxOEeu9WjZYMrVRYrAKGbUjNy5TbdIDBuZ0JTcIhg8qaJJYwlDio1+Lbc0TnsxUWNN0l4ULGgTQdj3gDLUbnjtujcBkuzaCahc1emvjYOHSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728957272; c=relaxed/simple;
	bh=mvhVCTTkPvpHvhWOAKSbAtG536D+Aq6N5OIwMEn5hWE=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=R7Uu3IEKpVkKmRS6zKp8IF71LhAaKsmlZDLUwjju+eqYgyKoJcRyXLXYS73YT8rEXIwraWRFYI6PQ+j5kdmXeZUHMa2bGmyqijJnbAaMWK/DXoL99nDu/zaM6W7XEo25R+gbv38fgnmteBYp9hxh/PkH5mrYaAIBdj28sY3V91k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lPYoco90; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uFqIAlDb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F1BhX7018854;
	Tue, 15 Oct 2024 01:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=FjSTT7NoChQMki3PYA
	pSH8N3HhDLTzFxBgpRpjQQko8=; b=lPYoco90ejOCWgeXZF9Uijlo5wC96mJJAZ
	m19UoYNu5EvZRLMI9k+ZfELT+DFBIhdXXXpPBjj/9kE24em4VN07hwkWFqT1YQkf
	pNDhIrt+2SuPAPU63KERBb3zmj4/Hs2w3IwEVexycdcHsxNVADaCXPqsHfw00iY5
	jc+WJ34ClwqIb91UjwkZ6ma2vg5pENeird9jm4T4UKYiXHjzHQcseGZuKjGP7YdL
	WxYqqzex0sWX3+S/2zbDBOpqzg3ZxZXJgwjyXHdl3b6AOIQ0UunkBgGAINFNwE+l
	ZJMGmKCWYIowWTub80ls3V1I/vvgb5+l5WFI5IbSjNaaONsfyg4Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427g1afh2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 01:53:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49F1Iveu011009;
	Tue, 15 Oct 2024 01:53:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjd3ha0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 01:53:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUU+C2QUfAa/PlZlaafdCwo8PxGHxSSTnsBNwwxjMhVfvaNJ2aad3R2gXaNXOqMkEAlX4qBzXDe86+woTt6bPZUvs+UjeJQHAz1lDiybLirhigQ2RIqhQEyN46PVN5NZGcVjCOcYhTsHH/XosWx6I9qv9HSvTB3Bu9o2OrTPKOAOYd1B3obvX67kVvW6vyGGdS4eY990OQU77XAzwntkrKE3eKK3lPzBs6X20jjdX6kIel3NlFtQQmuyfgc54SNYGdK4o42iAU2z3Sjt8yfixxBp2uAy52UX76WIVFzJlIBF481+42LPkaJEFR3nDbmMb2F6/d4E8CRKc9onCEE5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjSTT7NoChQMki3PYApSH8N3HhDLTzFxBgpRpjQQko8=;
 b=b+BbhA6ZDdDM6OsHhIm8j48Q38wfw2A6G9Fwdxg7/G26V+3siUY4Ain0TbyAZ86+m9ezxP5A/O2MpS1kBi/V2rFrW/MeWcfh1xEVkAcmNeR/haraK0nLivDD0+hPVf6YJIw4293Pmp0AzF/i4tyLSr2b6WE+0ShTC8Ie6v0RIxDAhYmJ8mVCYrM2CEhhPcagQKh74bBBvACYabNHJ5hFGghbHEJ8LWtFvjmFUTaTmAvZIAjn7nYEMtrGQ8nJUv+QRoCRqPZ5mMI4LCIorx9SvLsC3erqKnIm0/AcxJjDCgodLKFuRiUF9YYopdJhW7tK6zrzILvr/h+nSh8S3SCC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjSTT7NoChQMki3PYApSH8N3HhDLTzFxBgpRpjQQko8=;
 b=uFqIAlDbO4IlbBvmxNMqkYZMDpl1RESq3fzBPsyiStKWGkTLz/NTmwo0Ic0I44hFbNvSqsvbvg51liZB1oq1lPUkqVBULnU/B6OL+3QSHnlXlWJkh1acgouhZo4aOg6fLLqxjAVFTtym/d+0RKaXtKoEmecewxw8Oq2p1pSBw3Y=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7143.namprd10.prod.outlook.com (2603:10b6:208:3f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 01:53:27 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 01:53:27 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "zhenglifeng (A)" <zhenglifeng1@huawei.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, Jie Zhan <zhanjie9@hisilicon.com>,
        lihuisong@huawei.com
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
In-reply-to: <f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com>
Date: Mon, 14 Oct 2024 18:53:22 -0700
Message-ID: <87ldyqt9m5.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0215.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7143:EE_
X-MS-Office365-Filtering-Correlation-Id: 339cc372-d911-4073-d06d-08dcecbc2962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k61cvYfWHPFOyku4AuX1O6Sc97kO08X8MiAydPELXtpdA3JwNcv7z8kZ/P7/?=
 =?us-ascii?Q?fciHUI0Yy6A5fZhNKw46Gyv/yT1ZandBzuD9I3CdIDm54Nr0gzE4UBVQXnUE?=
 =?us-ascii?Q?z6T5GZ0uDW0uU3zp6lqn3rITcN7zztcoGi52Xxr8qXqunpi0WzcibPjDC8cG?=
 =?us-ascii?Q?uK+xC0hm/zDyDdvwSfqhYnw76eXzxKUMEfkdOraN9TryMEoTPCobfbgnDmzz?=
 =?us-ascii?Q?SZ+2C4VttXetOfsSpgIri+WiyZ/f8kmnGi18icrtA7Xyqzx/M0ZmH2ENho2n?=
 =?us-ascii?Q?GzgzgefYw6bzL2rtHFMrx2e+/Z6O64r89aHYGxtvzM6ZrK0I1p5icMFheHXZ?=
 =?us-ascii?Q?inYOqoLUeyoDv2wVsDCu9A62N5gm2/9C2ajoyi2Fno2qhWKdaJ5Y92zbqAD3?=
 =?us-ascii?Q?McIaaxEuntyR5Wzbst6NA81imhBYlHvlHG0W8hPtMyWTlHb/eApRADm5fA0y?=
 =?us-ascii?Q?wAwlW41QTxliSQDCBbb3nfax9UJl3csiJFuWaAiy8DLXEvypW+CP4mkn/brX?=
 =?us-ascii?Q?5Ll7NWN/pHkJyijVpzkmpUGg5y3izxSCA4uzBaEmzPUcEjQLt/86byJpaggV?=
 =?us-ascii?Q?E+XGjlk0K700n2BN1REnAvWt6SXsCYZpXACGSX5rC3+1vQwU03mBUxudoubs?=
 =?us-ascii?Q?kyUiqoKqJFRa60gjoVMOol4vglqXhqX2U31TfI8jFTgoFF9dWhNigrTiGGNt?=
 =?us-ascii?Q?HYP7Z3wWxIIw7GY966Dh0ZZNTBFOliHyqqF8TFrDkYyDJi+X/eEP1ZABZhdV?=
 =?us-ascii?Q?IQpMbSO1F79VVDFQHGtJYZfjK9F/v1WEks6U4NmwwX3ry7xje4r2gul6C/xU?=
 =?us-ascii?Q?MqoZG4PkBFCc/qKZro0Eu9wZM+4BUg3WWk9TKBwo2xC8KovDbQHh3sIbMOg4?=
 =?us-ascii?Q?QAThU+6ufZlJqdsQM4pNva3EWcNzGS2/q/3Layds48rlC4ne0nfXTN6aczov?=
 =?us-ascii?Q?OZ/emP3YPG8rArceIT27m50ot+92JIj4zWLQJoS/RD15g+nYeqyzpIp7Px67?=
 =?us-ascii?Q?UwuM1v9haJiQvS3G7Q0515aFG1i6QcVy//HXQU7+cjC0QzzdxcIQtSEzMehm?=
 =?us-ascii?Q?Xc/b8T+ArNkArD5Fbwp1FFbPCkiKmbPpSm8Ngy2L9ZPneOhinQ+UFndmzAg2?=
 =?us-ascii?Q?cR8vmdBU7yFdi3rBzGKjn+ucQuxqN48JwIz0LPb3DKsM8oD0bBZgp2/OGSWQ?=
 =?us-ascii?Q?Sr3YY+qJSs65HcS6pvPCpDYhTnJ4z9nV9YVMj03S14Di+cWs52SArxOXcB9t?=
 =?us-ascii?Q?TuSlW8QnglugPYu9hL84dSod7UA7bEnMr+WlRqNGYKraiiwNVPfYlOAREW2p?=
 =?us-ascii?Q?zhE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zVlmkpSt+nQeKQoXv3LywatssnxbYdX+jAmIp52KigsT+4mqH/Ol/x87K5Y9?=
 =?us-ascii?Q?dTYX+RbDEbAi2kber6OtGr5IN8YFXr/uTVWw9yQsLYcH62kFH3QKM6xMA3gh?=
 =?us-ascii?Q?N7kmM4i7cHepuKgb0MWCvd5t3Dt8TdWFRGCiXtpOFIoRK8k9CvJq5QLwGnMs?=
 =?us-ascii?Q?vG6DKFRbN8QPlUlYJQ7w08OQXBipKe+ZfMB6sXkfHH6psORH3DysK5USoyF8?=
 =?us-ascii?Q?ZRjm3Dq6xshRgcMtVEwKPXj5wKC4OF4XdJ1EwKfIfFlXeZ9jcnn39SQ9k30s?=
 =?us-ascii?Q?HTajZtWDldOmRH/ZNHbsX4gkLgUWGhGKU2GonoEahrQcfie/L+GBegddaT1p?=
 =?us-ascii?Q?TBu7fo8bRYM2cIKKAAsViUjzSt7Auf4WQd4znFj6FH1oaPgjcrXGv75ZyH10?=
 =?us-ascii?Q?11zPy8EyGy/5hQ9VZYnJzhZT6Uu8BCsH3bgWZqgoD2JNPJG7CtKocxMgxdEK?=
 =?us-ascii?Q?gf9d8DzzRDvxgslFqHy8dJsfb4oN3oNPevX9atDDf2/ZRCh4LunXKy4LAgC+?=
 =?us-ascii?Q?GgfLNguB06vszLaRBEoRDCarOFzIwZXGs1U/0I8MKo/VEYDMeOcffOm1Y0HF?=
 =?us-ascii?Q?+7cA/6aqjCAq76Re3mMmMqu9IhlGjXgDHGbMIXOMf8KjMfsilFB/z21VHqVn?=
 =?us-ascii?Q?j9Xp6jnGB3qE9lcH9BGUxN0cXnvbqKfwkuz9M9pgcJ1aicRidKmupZjJMxN3?=
 =?us-ascii?Q?A6PWhtzUaUbTKHurReVcvY2fuSnzdAhu4CSl0u6Znx6eGjOMlzItdWqOia6Y?=
 =?us-ascii?Q?uBpllRUiZ6eSpq7vB6V1kCerySvpfRpH8itiiowbThUNwGHKtKWLEY+j4QG9?=
 =?us-ascii?Q?bAYmQHzKMSuZ94kgo/tg5+xywINpDhFMDWEWCR0eAbA9dqjx4L23LNQrbXug?=
 =?us-ascii?Q?E57mCSOUIaiBmdoZ+LK2MubgTWJKcNQj+Vb5HPru/3vdTK9ZWoVobjbyHYcG?=
 =?us-ascii?Q?8fXabAlfmC8YV8BhN/AslV/4ZnKahZ4QVZTx9nWjNHo5c0BMqkywyICjkUBK?=
 =?us-ascii?Q?ea5BJ1+W8eZgqdSMqZqCkSGrjhitaa2dRrgLxzZ9TIK25SG1+uZ9kwv5lC6V?=
 =?us-ascii?Q?Ql0mC8XqEsPwPueadpKtzs5mmZPCV4ZvNPjPWZqS+lpyrbpVnWscQMUyv2B+?=
 =?us-ascii?Q?JfUeAqvl2lEbr7rlNLUa8SnJwAEn7rSkewSAbkqNrc3pvr8Mx+VhuzLRAOJg?=
 =?us-ascii?Q?p0sfapm1DJDDiLoaQYTXltq+vljKwwiXyytdDOThQoq+KyjXiUZb+MWzY555?=
 =?us-ascii?Q?+8BhGwI9UnwwpDFeb5vxWZwxmm4SUvguizRowI8MDFnnLhouu2vryj25AuO1?=
 =?us-ascii?Q?Lflwz/D5dyyluA3xW5xiyprR0v/sUHXxDYbQ27FKML+nwhN+NYM2z3yNC4CC?=
 =?us-ascii?Q?VKyWJu7IcjlwL4+2hnzPAxbU/ikO9TN4O+/S39PMcgACxXbrGPCHsCPQhmFn?=
 =?us-ascii?Q?F33WEI9LO2n0Ae1VaoerCeuEbBrk8K9RlArFhpTlYIUJVOo14EdqJ7GZpbVQ?=
 =?us-ascii?Q?2+3PBILjszyA4JvRHWzqHE1tzv787/ROw5uD82VqnJYEE1nBxfH7rDN+7gV/?=
 =?us-ascii?Q?P4I1SH+M/6JH7LR6h3wbdMQDI+pblxtvhlM3wecS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o4BXEzgqgh34/74XUDIGlQz3PTh9aFLTXeFAagoh/5h7Gf9Sx44Y9H1COZ9SzWSWVYjMziHgTc6qnlJhL0oBwUWH5m/Y8yPSTSfcobeH9TezO7p6M5SMyXN6ZGWYx4DUOAK6Y+JNJXb3ZKoMncuRm9rqkFyy0n7DXOuAJDi9ap2zl7sPQQY4I8CC33xoqJTrAU2/+jS7x2+iWXezSdg5oByLdbBHvualadEsA5xOfHZPOSrv5OOagAeR9E3tJN8bIG3mUMSEZN0pkBCv3NcfI8DxdeeF4BgJnhiYoqwoqplpwVn+Dt7RS1Lp9RMJdfyCHPnDz7xj1XY81fMiJWhp7eBYkKUbgPqb/HYa5WAmNspeqQvYQQVKV5PRgTsIivvQXKIUWkqzu9eDRmI3kYPbqxsU7msUBQD9KANCL1USJCnKsembqO0E8lJuxzZxulYDiGE8x/RKEMU4xbEUIvyVc2qVBdYDFEcwEPB0meQI30UIdfWDE74qliP9fWOqAMX7g6fxzjwtjcPCL/ySEQ7vZfTv5BTUC3Yo4SnZClqxtN35qJ7m/SKkJ875ZCdidXdJOsA2Kf4OmL+bTL8RxnJuM/9XbcUX97AbiXjz7QhG5Aw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339cc372-d911-4073-d06d-08dcecbc2962
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 01:53:27.4469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4E1VIEKcCVoxJ3kFvG7yMbvQHw2KDH/E7xvh+9Sf8FBhD19vaL38T2ZhpUXWE1OjcIETdfNKYFn8dS7P/ubPSUUR6C7yIqAgKVY4ECEe84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_19,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410150012
X-Proofpoint-GUID: QQqUX4nAnGl_ujpUffH9znKm5uGMp-XP
X-Proofpoint-ORIG-GUID: QQqUX4nAnGl_ujpUffH9znKm5uGMp-XP


zhenglifeng (A) <zhenglifeng1@huawei.com> writes:

> On 2024/9/26 7:24, Ankur Arora wrote:
>> This patchset enables the cpuidle-haltpoll driver and its namesake
>> governor on arm64. This is specifically interesting for KVM guests by
>> reducing IPC latencies.
>>
>> Comparing idle switching latencies on an arm64 KVM guest with
>> perf bench sched pipe:
>>
>>                                      usecs/op       %stdev
>>
>>   no haltpoll (baseline)               13.48       +-  5.19%
>>   with haltpoll                         6.84       +- 22.07%
>>
>>
>> No change in performance for a similar test on x86:
>>
>>                                      usecs/op        %stdev
>>
>>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
>>
>> Both sets of tests were on otherwise idle systems with guest VCPUs
>> pinned to specific PCPUs. One reason for the higher stdev on arm64
>> is that trapping of the WFE instruction by the host KVM is contingent
>> on the number of tasks on the runqueue.
>>
>> Tomohiro Misono and Haris Okanovic also report similar latency
>> improvements on Grace and Graviton systems (for v7) [1] [2].
>>
>> The patch series is organized in three parts:
>>
>>  - patch 1, reorganizes the poll_idle() loop, switching to
>>    smp_cond_load_relaxed() in the polling loop.
>>    Relatedly patches 2, 3 mangle the config option ARCH_HAS_CPU_RELAX,
>>    renaming it to ARCH_HAS_OPTIMIZED_POLL.
>>
>>  - patches 4-6 reorganize the haltpoll selection and init logic
>>    to allow architecture code to select it.
>>
>>  - and finally, patches 7-11 add the bits for arm64 support.
>>
>> What is still missing: this series largely completes the haltpoll side
>> of functionality for arm64. There are, however, a few related areas
>> that still need to be threshed out:
>>
>>  - WFET support: WFE on arm64 does not guarantee that poll_idle()
>>    would terminate in halt_poll_ns. Using WFET would address this.
>>  - KVM_NO_POLL support on arm64
>>  - KVM TWED support on arm64: allow the host to limit time spent in
>>    WFE.
>>
>>
>> Changelog:
>>
>> v8: No logic changes. Largely respin of v7, with changes
>> noted below:
>>
>>  - move selection of ARCH_HAS_OPTIMIZED_POLL on arm64 to its
>>    own patch.
>>    (patch-9 "arm64: select ARCH_HAS_OPTIMIZED_POLL")
>>
>>  - address comments simplifying arm64 support (Will Deacon)
>>    (patch-11 "arm64: support cpuidle-haltpoll")
>>
>> v7: No significant logic changes. Mostly a respin of v6.
>>
>>  - minor cleanup in poll_idle() (Christoph Lameter)
>>  - fixes conflicts due to code movement in arch/arm64/kernel/cpuidle.c
>>    (Tomohiro Misono)
>>
>> v6:
>>
>>  - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
>>    changes together (comment from Christoph Lameter)
>>  - threshes out the commit messages a bit more (comments from Christoph
>>    Lameter, Sudeep Holla)
>>  - also rework selection of cpuidle-haltpoll. Now selected based
>>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>>  - moved back to arch_haltpoll_want() (comment from Joao Martins)
>>    Also, arch_haltpoll_want() now takes the force parameter and is
>>    now responsible for the complete selection (or not) of haltpoll.
>>  - fixes the build breakage on i386
>>  - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
>>    Tomohiro Misono, Haris Okanovic)
>>
>>
>> v5:
>>  - rework the poll_idle() loop around smp_cond_load_relaxed() (review
>>    comment from Tomohiro Misono.)
>>  - also rework selection of cpuidle-haltpoll. Now selected based
>>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>>  - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
>>    arm64 now depends on the event-stream being enabled.
>>  - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
>>  - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.
>>
>> v4 changes from v3:
>>  - change 7/8 per Rafael input: drop the parens and use ret for the final check
>>  - add 8/8 which renames the guard for building poll_state
>>
>> v3 changes from v2:
>>  - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
>>  - add Ack-by from Rafael Wysocki on 2/7
>>
>> v2 changes from v1:
>>  - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
>>    (this improves by 50% at least the CPU cycles consumed in the tests above:
>>    10,716,881,137 now vs 14,503,014,257 before)
>>  - removed the ifdef from patch 1 per RafaelW
>>
>> Please review.
>>
>> [1] https://lore.kernel.org/lkml/TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com/
>> [2] https://lore.kernel.org/lkml/104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com/
>>
>> Ankur Arora (6):
>>   cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
>>   cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
>>   arm64: idle: export arch_cpu_idle
>>   arm64: select ARCH_HAS_OPTIMIZED_POLL
>>   cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
>>   arm64: support cpuidle-haltpoll
>>
>> Joao Martins (4):
>>   Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
>>   cpuidle-haltpoll: define arch_haltpoll_want()
>>   governors/haltpoll: drop kvm_para_available() check
>>   arm64: define TIF_POLLING_NRFLAG
>>
>> Mihai Carabas (1):
>>   cpuidle/poll_state: poll via smp_cond_load_relaxed()
>>
>>  arch/Kconfig                              |  3 +++
>>  arch/arm64/Kconfig                        |  7 +++++++
>>  arch/arm64/include/asm/cpuidle_haltpoll.h | 24 +++++++++++++++++++++++
>>  arch/arm64/include/asm/thread_info.h      |  2 ++
>>  arch/arm64/kernel/idle.c                  |  1 +
>>  arch/x86/Kconfig                          |  5 ++---
>>  arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
>>  arch/x86/kernel/kvm.c                     | 13 ++++++++++++
>>  drivers/acpi/processor_idle.c             |  4 ++--
>>  drivers/cpuidle/Kconfig                   |  5 ++---
>>  drivers/cpuidle/Makefile                  |  2 +-
>>  drivers/cpuidle/cpuidle-haltpoll.c        | 12 +-----------
>>  drivers/cpuidle/governors/haltpoll.c      |  6 +-----
>>  drivers/cpuidle/poll_state.c              | 22 +++++++++++++++------
>>  drivers/idle/Kconfig                      |  1 +
>>  include/linux/cpuidle.h                   |  2 +-
>>  include/linux/cpuidle_haltpoll.h          |  5 +++++
>>  17 files changed, 83 insertions(+), 32 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>>
>
> Hi Ankur,
>
> Thanks for the patches!
>
> We have tested these patches on our machine, with an adaptation of ACPI LPI
> states rather than c-states.
>
> Include polling state, there would be three states to get in. Comparing idle
> switching latencies of different state with perf bench sched pipe:
>
>                                      usecs/op       %stdev
>
>   state0(polling state)                7.36       +-  0.35%
>   state1                               8.78       +-  0.46%
>   state2                              77.32       +-  5.50%
>
> It turns out that it works on our machine.
>
> Tested-by: Lifeng Zheng <zhenglifeng1@huawei.com>

Great. Thanks Lifeng.

> The adaptation of ACPI LPI states is shown below as a patch. Feel free to
> include this patch as part of your series, or I can also send it out after
> your series being merged.

Ah, so polling for the regular ACPI driver. From a quick look the
patch looks good but this series is mostly focused on haltpoll so I
think this patch can go in after.

Please Cc me when you send it.

Thanks
Ankur

> From: Lifeng Zheng <zhenglifeng1@huawei.com>
>
> ACPI: processor_idle: Support polling state for LPI
>
> Initialize an optional polling state besides LPI states.
>
> Wrap up a new enter method to correctly reflect the actual entered state
> when the polling state is enabled.
>
> Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
> Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
> ---
>  drivers/acpi/processor_idle.c | 39 ++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 44096406d65d..d154b5d77328 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1194,20 +1194,46 @@ static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
>  	return -EINVAL;
>  }
>
> +/* To correctly reflect the entered state if the poll state is enabled. */
> +static int acpi_idle_lpi_enter_with_poll_state(struct cpuidle_device *dev,
> +			       struct cpuidle_driver *drv, int index)
> +{
> +	int entered_state;
> +
> +	if (unlikely(index < 1))
> +		return -EINVAL;
> +
> +	entered_state = acpi_idle_lpi_enter(dev, drv, index - 1);
> +	if (entered_state < 0)
> +		return entered_state;
> +
> +	return entered_state + 1;
> +}
> +
>  static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
>  {
> -	int i;
> +	int i, count;
>  	struct acpi_lpi_state *lpi;
>  	struct cpuidle_state *state;
>  	struct cpuidle_driver *drv = &acpi_idle_driver;
> +	typeof(state->enter) enter_method;
>
>  	if (!pr->flags.has_lpi)
>  		return -EOPNOTSUPP;
>
> +	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
> +		cpuidle_poll_state_init(drv);
> +		count = 1;
> +		enter_method = acpi_idle_lpi_enter_with_poll_state;
> +	} else {
> +		count = 0;
> +		enter_method = acpi_idle_lpi_enter;
> +	}
> +
>  	for (i = 0; i < pr->power.count && i < CPUIDLE_STATE_MAX; i++) {
>  		lpi = &pr->power.lpi_states[i];
>
> -		state = &drv->states[i];
> +		state = &drv->states[count];
>  		snprintf(state->name, CPUIDLE_NAME_LEN, "LPI-%d", i);
>  		strscpy(state->desc, lpi->desc, CPUIDLE_DESC_LEN);
>  		state->exit_latency = lpi->wake_latency;
> @@ -1215,11 +1241,14 @@ static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
>  		state->flags |= arch_get_idle_state_flags(lpi->arch_flags);
>  		if (i != 0 && lpi->entry_method == ACPI_CSTATE_FFH)
>  			state->flags |= CPUIDLE_FLAG_RCU_IDLE;
> -		state->enter = acpi_idle_lpi_enter;
> -		drv->safe_state_index = i;
> +		state->enter = enter_method;
> +		drv->safe_state_index = count;
> +		count++;
> +		if (count == CPUIDLE_STATE_MAX)
> +			break;
>  	}
>
> -	drv->state_count = i;
> +	drv->state_count = count;
>
>  	return 0;
>  }


--
ankur

