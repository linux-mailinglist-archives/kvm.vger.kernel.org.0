Return-Path: <kvm+bounces-65757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 112BBCB5983
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A593130321EC
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320DD23D7CA;
	Thu, 11 Dec 2025 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ktS4+LfN";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pucFaydh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104A323EA86;
	Thu, 11 Dec 2025 11:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450907; cv=fail; b=JAS4m2YUqyFc5mS58rgFK+ESP9F1aoSslUZwI2B24veCSV1h/XeOSdcxkvFVB9QqXdxsTv1SN2BZwoUZ1MqkDdI8KJRsZ/uhPeEV5rfkFjm25JAarxuFwLtTkUi+H9kIc8M6aEw4eRjyyel5CWZeVAu49llWbGQDQ6pNJMsxALI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450907; c=relaxed/simple;
	bh=JK/A4GLcpY2K6356gaXQ8xSOWKI7KFcyTXzBaQY8VYI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=S6MYFVRXwUoE98G8ZIt6OJL4LNa4G2NEDn3g4DpkC0ys+autG5J9aSJpdFqylCNickRJTjsUM9044kouMdZpNGQ9mHDEu+FDlA/x/uEOQFiucOoh8wBOMnQO9BidPFzNceEBQuPYWFcBiP4b+QpyD+Qchv1kjAABOwWxE9je5JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ktS4+LfN; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pucFaydh; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BB928Pw1751255;
	Thu, 11 Dec 2025 03:00:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=jxF8UEQg1zgye
	4S88Ry0Tf4QNiukRIk5LuNiCQ+Fkgg=; b=ktS4+LfNrzStpeb7jfclBHa77CFB7
	5KzkvisebBjc6t+7tLa/Mp4Y5t1zjRD1i3cAccxIRkOY/crPfB1KBz7lLdwJjYE3
	y2fVjQFa+8jOKUAKrGoIfD14Mpaz1YhIfLICVk1fv0xS7k1r2hKIwg8Opbwhy8Yy
	uWmAExwQA5FaQq9keYHw33t0wM+LGSaaNJDh9n6uCsN23SVAQRxkZCDWglg8mGdV
	zjk0u4s32ljY+2RV2tI22QueV3cfSfEDH3uvCJwdeHuvBY6aXInlovVb1WcKGPwn
	EApl3hWd8QR+INqQjy2/0JVo8oOySGWSdfbxN8LizHN41DYs0SE75kn2Q==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023099.outbound.protection.outlook.com [40.107.201.99])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4aytyk094e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Dec 2025 03:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fdGuGpoUqZuuoX1q+7ibeF0hX8ctF2LDBYA1lPjZ+H/1Cbz1+Xn4gXekGWfb1gQ1i1onFxmxdyOiu5LdLDh0Unz/UnVcBRTUzmy4olCqWvPYBFJUIdAfceoy2DRM5JnnqNyWGDy4gryokIv3gNxT/kzv7o3kLJ3ncr+1VGF9Oo2V7KHB7aFHvxQ7MT4OlUUHSfTE52LWkZnhWUAcGZb6ruftEpMD1d10HsWiLrNjPRggX4RVTPUl+i30zX+/nB5MNUz0yQ31vlVhEVm3lCLUS7cmJa2oevfZGDWDvkuT+Q1g9ZunfecqNtxJatcVuQJt1VC+t11aEZYeHuh/OThDXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxF8UEQg1zgye4S88Ry0Tf4QNiukRIk5LuNiCQ+Fkgg=;
 b=G7IAidZtRY/ua8uqm3Hcz+3lOcWqpJU78APdo11fLGbP5Y8EHlz46b7k3Eqyl3XGS+HUHEy+e44ZUaZRLvsypyW9sld7KyE/QvquUPhXAk+QSOviamijKXvLwUU3RcAy0BGhNp8zq9Y+m86ofYaXa3w88mPZNMZ43GXMgvuoSLvgrn1EyDT6jg3KEdKcAUzZGkTZsReW15e1Z3HFaKxkc9Ho4NI6cwWpLWG11OoDAMiZByVM84UJX7l/qvTKCRCtv6DSHF6SSY8rRMCBO0GN8e1ApGgwgGAjPy9h7wBVRkbXWxaGL0LiPuFYjJT4f0WmGanV8i7vZ7YzzlDB/6m6YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxF8UEQg1zgye4S88Ry0Tf4QNiukRIk5LuNiCQ+Fkgg=;
 b=pucFaydhnNSbGXmzobFOlwOZAs8GqqpEZ5oowgezus364Q/5+SCm6ck0ZAnO1K6fpww90gj68OTrC2aRFFbVAhzxGcNPCsQP/lO+Iysh6vTyXqTpIT2aC0hrAn5EK/LPJv4L+Vm83dw7ONq02Do91b0UsdK/vHII76y/k5sKU36hKOu0tN+N/wPD8aGrrB523khXKy2HOk22uzJtzWs2Z5zH3s1xFDhsEAKROd/y5X/epcETUw+UBOlg6o30W1k/+UL5prsKMrkTGKmcDT2OfXysXRF+ncKs9hlGj7h2cciB62142t56CMA69Vx53AVqkzhSqploIWOXLWWdXt+ESg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7774.namprd02.prod.outlook.com (2603:10b6:a03:323::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Thu, 11 Dec
 2025 11:00:47 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 11:00:46 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, dwmw2@infradead.org,
        Khushit Shah <khushit.shah@nutanix.com>, stable@vger.kernel.org
Subject: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
Date: Thu, 11 Dec 2025 10:59:39 +0000
Message-ID: <20251211110024.1409489-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0101.namprd07.prod.outlook.com
 (2603:10b6:510:4::16) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7774:EE_
X-MS-Office365-Filtering-Correlation-Id: e7523cd1-6e0d-4c25-d3f0-08de38a48930
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R2lqRKz52nHY85TCqyIR4fiQVq89TG8G6q/Pj6dkykrKX8OLEf5x9yt0btIs?=
 =?us-ascii?Q?H8eqHoHy+6aoKedmFWGcL2Jq8/Xe+Y+djhSDLPzxlewO+X2H6sMvEjqpWYsN?=
 =?us-ascii?Q?rW7NsMTRJrw9vQZM8r7ThvliLtF6BsnobA26FWH4/AGyEExvETCdHXPIeaGC?=
 =?us-ascii?Q?OP2unG/g4WNLSGyxhgOxwtSSYR0LA0/d+RNiFMwFzQoxnwMJNn/c9ZhzcEF4?=
 =?us-ascii?Q?iEncG2++bLw4o07n1G/zB+AXfqEJOXH2/a4UtR9cs0tOrmffqCYlqtUbXQ0/?=
 =?us-ascii?Q?GJs1pRITrE58RKsu1R8fIGldBtbVoZHd9uoTSKABcbBuN808yhSAhcGTbqcU?=
 =?us-ascii?Q?kNOAcREb3SITvLa6WhZLkuhN5I4bx8sdhI1BkvLrc2CZR9b3jGJvp+pl+xR8?=
 =?us-ascii?Q?XzuHl/XmU9r/RrYSu08QRfxGKGGuTkWZTTQLgnn/SGDmV5E8gvSacwymnI5A?=
 =?us-ascii?Q?a1/zZcSLT5nV9yQbCcA+83WO8AlYV16OJKEB9PRqTCMLR3yPe41yEKe/XrVF?=
 =?us-ascii?Q?AVj4vY84UARzbaEgxF5pd6McB+pyjUTs8iQdSkNWXqdrDmHDtimOrRt01U7C?=
 =?us-ascii?Q?rLjKQ3CSC1tsj6EO5v0tjXOUYLDs4a5dBJzg84mfosIiqmEhNKRKbwFrZfD1?=
 =?us-ascii?Q?CkGrhqPgNeYm14IpsRmc1qlZCNPMwf5zuk8aImb6gQa5StiKW3rNIdo0WguZ?=
 =?us-ascii?Q?hYTMysdc3uh1Af0C/+ryO8RQSxvXJRPBKiqo7NsmFqc88q+n+8O2KmE4TmgB?=
 =?us-ascii?Q?Yo9v7zN7vOWtC/qiteHdt9HttXkMH2EjW8IoCRuyLC1//FnOXAmTl/HHo0Is?=
 =?us-ascii?Q?PqYiLb7v7epYBh3mqSGfUvniLqhm7BIK+tsM4qQOP/6mZdcGZ+ATsG7Avn5M?=
 =?us-ascii?Q?qHMv1sMajHNTKnbg5xJtn9+fvyxdoIxc25Ml5/7TtlySstG3GM9qTC6nB600?=
 =?us-ascii?Q?jNUrq2Il6Nr823XULWcaBelB4bH/DRIhpegiWMKhTkg7BOXYZO8Lx8pt6EbG?=
 =?us-ascii?Q?EQm6kJc6ic2jDGnBDFzG2vEU8PBAPT5NYxQVm0h1uwS1mPIke9elNXEE9sj7?=
 =?us-ascii?Q?WbDMGE7oEtqUxIEGR1+bLP8t3rBxSea3xdEsQ44Nh3fw5w/SIbc1JNpqm99z?=
 =?us-ascii?Q?x6rXKQao8cuWoxcsfDVtP/RZRsMZKEfCE1QK5zWfd4lYQYZEPmeUW0O6c0RS?=
 =?us-ascii?Q?j2hm0w9RRiuaKNCIPe2E4jR9VRbnZYrls1qlCCQ31Adt0BWwrh2GyTws9hCg?=
 =?us-ascii?Q?gOdyxDIcb8ZXAVHAx0p2IABCpCc4GzXw+TxxOhF4fiX7w3N04YQsmpWAR/yG?=
 =?us-ascii?Q?28+q5UfdL+9YWlzZBDU+EadfFAy6qgjhe/nlsPDOqfoFSZpKrFG5kJhf3/T9?=
 =?us-ascii?Q?Kxy7ytPmgytoPPWFTQQ+hEvvQ/CCgEdZUkVlFxYp1gLBt2dVG55YzYDKNQSX?=
 =?us-ascii?Q?t5GVl5B1zGe1to4OIRHTL65OaLs6uaj7PmWsX3xfZ7Va1RCrz4z6rQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L4IctqUrTV5mMIE+SjfTG57AlArYdg5FU6IXZ7NJqtJSmcd3KtwnENBcRF7I?=
 =?us-ascii?Q?aNbHZuG4hmOfm+4m0a13v+oAUdH3rRFDp+kaqNTalaBDVEbppAz554cR94SK?=
 =?us-ascii?Q?bg5Qiw6BhU4fDoTxauQr7HETFGbCjFDJwB38s5m0WtY1GoZjak5UvxV8O8P3?=
 =?us-ascii?Q?FGT3vnB6Fc1+rCpAo6hvMQikPz0bvPcrIs0i3aBH1V+cTRUDhXjEGLxLLIh0?=
 =?us-ascii?Q?hN+wCSB87HW2+eEc4C7oVzXszj7qDdETDOe0rKHv6rWFq68mj7hNdBLBqCdx?=
 =?us-ascii?Q?SEM1kBFJ1b/Cw3LBEphCP8PE8dGcJO42CGZ29d1ykvj9kileg+j0cNyJIT9t?=
 =?us-ascii?Q?oXD4S6hWTd8OuO/RG6BGl7hm7i9Y73CQoNR71rjRcEuI8rMhn4v8T5LZUS6M?=
 =?us-ascii?Q?0ktOfjImV+zwZfv6bPRVN27nSYkHtV2Hykde+qHYNOaF8qVN3O9NewO5E14W?=
 =?us-ascii?Q?esbi/5p+Amk8r1bFpf6o4W3D4tgFOpZfCjDpQDwyu9s3BPj8/YDrsrlokXi6?=
 =?us-ascii?Q?sgmJZMgiBD7e9tHn8CIvSW3ZkmLwhomCyKJzz/2pEHf01hFV7tVYvbauWySD?=
 =?us-ascii?Q?Fy+lnBxkDJFbSAz/qN6Ve4tmw4oprC2Zt06JWLldIPq8mS5SLWaLybbPvShd?=
 =?us-ascii?Q?GcuRlQchmRJIgDow1J7O1zveGJPvisuE2EhHxcnZZ8ywoA/w8w+c3aUfQ2UT?=
 =?us-ascii?Q?olizFvP6Ve44ei2XLOghUgs2pGWSrVMKgbTuSr7gdbNH43FvQaM0aRFv1SsE?=
 =?us-ascii?Q?uyVqcMNziQeMVaxpQi6nEuwCJouu7RFfZL4TOx6pRKE/riya8u3gSVNVxckA?=
 =?us-ascii?Q?PQHY1nBezhMpdtaXpURzjj3aO09woZ+3CDMKGdeBPLxFn3SD4ZThteDsCN1E?=
 =?us-ascii?Q?J1QQGqA26LbFTPi/o3+7AQZwNX5tW5hgD0aT5tUTW/XOWJSPTV00rejM2mmA?=
 =?us-ascii?Q?HQzFHe6526chjOLcJcbx9VibuS90Tf4R5xSh0K6cC/m3Z3zaEltPeCChYvew?=
 =?us-ascii?Q?6JC2h3MBWjDziXPdopEGLPQg9chm8G+k22NXPBDqOOGk24FuQSgT9LBSqmBz?=
 =?us-ascii?Q?sbodFLgSSM9+uEOO/RhTvtxceWqdCV+Rf3hHidbjnzviwHGVo6mtDEC1onp9?=
 =?us-ascii?Q?bJew3M1KZGONopZL+pAS6z9QV6O5yQjvoaJbrdtfb0OGuZrbaMemS8Bxudhk?=
 =?us-ascii?Q?+Qi17OAsuISzeeCGpoeRl0DIyzu0ubdYmRdK6FPIT+3gvRl9bpF8ZNZr9Ucy?=
 =?us-ascii?Q?xtzBDOcOc+xOI7c3q4C1eIDD+bWy6oS8vO3eZpI8hAlr+VsjXTBlTanuYz6s?=
 =?us-ascii?Q?UBPh8Y7T2eIUPJSQBRNohuoWZKkjHJTeiQlzLRSn6Ika+KvuByRwKV/7LeH+?=
 =?us-ascii?Q?q+RN75U08LPgxglix5fshUZefUHceiFterQtLaZTlL89eY+kJCCsBkBzeus3?=
 =?us-ascii?Q?Y4myGrpqlBqAsoqg5pSOYf0m1zosu6LfNsHxjPaGqvCO9/Ri83HEhsQKIi7j?=
 =?us-ascii?Q?lArsTKB0/InlNy9ufGUntAjV+pqT6hgeHtQgER48zhn4QQs58tmsn14MFl5v?=
 =?us-ascii?Q?jGp6+xvgjdW6MAQk3y+kJquxBxOjz59UizKGsn78+mKM3tB036dS2MXj3H/d?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7523cd1-6e0d-4c25-d3f0-08de38a48930
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 11:00:46.1925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eozm018rRkNnuHpu23kRrJHkZrjZPdBC2MxKRSOVO2MRk6Lupue/d++d/94gacR6U6JjkTYwa5rvlmIm55F/1+WatMpnrCIaj76qSO1kPII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7774
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjExMDA4NCBTYWx0ZWRfX5fBGG1mqR+9K
 PGVdok3TywLU8IyxRXYujZYLGGaB5W5+1tbk+UEFy6gnyzRzBkjsvbIxlCFdGjNjmiwTS2zAlXQ
 gI/gAFtc47pELp8GJJNK+AJq+Rhcx8pEaWn1Xh7M+ohNVMWAAMI0lb6Q7JXMJdSMyxMZMx1t+6I
 PH8xgFBgw8Cn1TBaXa8o6WCTlA77YNvmmkwcnBjSadfxwYp7uFeE3cZzVINTY0UCaTa4UJCDfzW
 1fRwQGtxElW/arNOm1IzVcbWAC4nd2URjBU0LWpUtxM0VY1WL48bP4PWPt5IfWIaprZF9mjYq9N
 fsS5gVyG7vyJkDtErdbszC7jgNBM3FhavghDWWfAa+f7JAhsNvEvforkFXfqP9kwuIDvS4qOyE2
 0hWMAmSM7Qq20fQztCisC+62A5HU8A==
X-Proofpoint-GUID: 6P3tG4_d2VOfTn5ZQNXwWUnhaGpNk7lt
X-Authority-Analysis: v=2.4 cv=TbSbdBQh c=1 sm=1 tr=0 ts=693aa461 cx=c_pps
 a=swu9HWZHTc4gAW/9Xzq+iQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=JfrnYn6hAAAA:8
 a=1XWaLZrsAAAA:8 a=keI5GBHPOURiXqRPUDQA:9 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: 6P3tG4_d2VOfTn5ZQNXwWUnhaGpNk7lt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_03,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
for Suppress EOI Broadcasts, which KVM completely mishandles.  When x2APIC
support was first added, KVM incorrectly advertised and "enabled" Suppress
EOI Broadcast, without fully supporting the I/O APIC side of the equation,
i.e. without adding directed EOI to KVM's in-kernel I/O APIC.

That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
support for Suppress EOI Broadcasts irrespective of whether or not the
userspace I/O APIC implementation supported directed EOIs.  Even worse,
KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
support for directed EOI came to rely on the "spurious" broadcasts.

KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
didn't do anything to remedy userspace I/O APIC implementations.

KVM's bogus handling of Suppress EOI Broadcast is problematic when the
guest relies on interrupts being masked in the I/O APIC until well after
the initial local APIC EOI.  E.g. Windows with Credential Guard enabled
handles interrupts in the following order:
  1. Interrupt for L2 arrives.
  2. L1 APIC EOIs the interrupt.
  3. L1 resumes L2 and injects the interrupt.
  4. L2 EOIs after servicing.
  5. L1 performs the I/O APIC EOI.

Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
storm, e.g. if the IRQ line is still asserted and userspace reacts to the
EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
until step #4, and doesn't expect the interrupt to be re-enabled until
step #5.

Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
of knowing if the userspace I/O APIC supports directed EOIs, i.e.
suppressing EOI broadcasts would result in interrupts being stuck masked
in the userspace I/O APIC due to step #5 being ignored by userspace.  And
fully disabling support for Suppress EOI Broadcast is also undesirable, as
picking up the fix would require a guest reboot, *and* more importantly
would change the virtual CPU model exposed to the guest without any buy-in
from userspace.

Add KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST flags to allow userspace to
explicitly enable or disable support for Suppress EOI Broadcasts while
using split IRQCHIP mode.  This gives userspace control over the virtual
CPU model exposed to the guest, as KVM should never have enabled support
for Suppress EOI Broadcast without a userspace opt-in. Not setting
either flag will result in legacy quirky behavior for backward
compatibility.

Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD's
APM.  But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.

Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com
Cc: stable@vger.kernel.org
Suggested-by: David Woodhouse <dwmw2@infradead.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
v4:
- Add KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
  KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST flags to allow userspace to
  explicitly enable or disable support for Suppress EOI Broadcasts while
  using split IRQCHIP mode.

After the inclusion of David Woodhouse's patch to support IOAPIC version 0x20,
we can tweak the uAPI to support kernel IRQCHIP mode as well.

Testing:
- Setting both the flags fails with EINVAL.
- Setting flags in kernel IRQCHIP mode fails with EINVAL.
- Setting flags in split IRQCHIP mode succeeds and both the flags work 
  as expected.
---
 Documentation/virt/kvm/api.rst  | 27 ++++++++++++++++++++--
 arch/x86/include/asm/kvm_host.h |  7 ++++++
 arch/x86/include/uapi/asm/kvm.h |  6 +++--
 arch/x86/kvm/lapic.c            | 40 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 19 +++++++++++++---
 5 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..b26528e0fec1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7800,8 +7800,10 @@ Will return -EBUSY if a VCPU has already been created.
 
 Valid feature flags in args[0] are::
 
-  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+  #define KVM_X2APIC_API_USE_32BIT_IDS                               (1ULL << 0)
+  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK                     (1ULL << 1)
+  #define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST                   (1ULL << 2)
+  #define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST                  (1ULL << 3)
 
 Enabling KVM_X2APIC_API_USE_32BIT_IDS changes the behavior of
 KVM_SET_GSI_ROUTING, KVM_SIGNAL_MSI, KVM_SET_LAPIC, and KVM_GET_LAPIC,
@@ -7814,6 +7816,27 @@ as a broadcast even in x2APIC mode in order to support physical x2APIC
 without interrupt remapping.  This is undesirable in logical mode,
 where 0xff represents CPUs 0-7 in cluster 0.
 
+Setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST instructs KVM to enable
+Suppress EOI Broadcasts. KVM will advertise support for Suppress EOI Broadcast
+to the guest and suppress LAPIC EOI broadcasts when the guest sets the
+Suppress EOI Broadcast bit in the SPIV register.
+
+Setting KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST disables support for
+Suppress EOI Broadcasts entirely, i.e. instructs KVM to NOT advertise support
+to the guest.
+
+Modern VMMs should either enable KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST or
+KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST. If not, legacy quirky behavior will
+be used by KVM, which is to advertise support for Suppress EOI Broadcasts but
+not actually suppressing EOI broadcasts.
+
+Currently, both KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
+KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST must only be set when in split IRQCHIP
+mode. Otherwise, the ioctl will fail with an EINVAL error.
+
+Setting both KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
+KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST will fail with an EINVAL error.
+
 7.8 KVM_CAP_S390_USER_INSTR0
 ----------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..4a6d94dc7a2a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1229,6 +1229,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
+enum kvm_suppress_eoi_broadcast_mode {
+	KVM_SUPPRESS_EOI_BROADCAST_QUIRKED, /* Legacy behavior */
+	KVM_SUPPRESS_EOI_BROADCAST_ENABLED, /* Enable Suppress EOI broadcast */
+	KVM_SUPPRESS_EOI_BROADCAST_DISABLED /* Disable Suppress EOI broadcast */
+};
+
 struct kvm_x86_msr_filter {
 	u8 count;
 	bool default_allow:1;
@@ -1480,6 +1486,7 @@ struct kvm_arch {
 
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+	enum kvm_suppress_eoi_broadcast_mode suppress_eoi_broadcast_mode;
 
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..d30241429fa8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -913,8 +913,10 @@ struct kvm_sev_snp_launch_finish {
 	__u64 pad1[4];
 };
 
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+#define KVM_X2APIC_API_USE_32BIT_IDS (_BITULL(0))
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK (_BITULL(1))
+#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST (_BITULL(2))
+#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST (_BITULL(3))
 
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..1ef0bd3eff1e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -105,6 +105,34 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 		apic_test_vector(vector, apic->regs + APIC_IRR);
 }
 
+static inline bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)
+{
+	/*
+	 * Advertise Suppress EOI broadcast support to the guest unless the VMM
+	 * explicitly disabled it.
+	 *
+	 * Historically, KVM advertised this capability even though it did not
+	 * actually suppress EOIs.
+	 */
+	return kvm->arch.suppress_eoi_broadcast_mode !=
+			KVM_SUPPRESS_EOI_BROADCAST_DISABLED;
+}
+
+static inline bool kvm_lapic_ignore_suppress_eoi_broadcast(struct kvm *kvm)
+{
+	/*
+	 * Returns true if KVM should ignore the suppress EOI broadcast bit set by
+	 * the guest and broadcast EOIs anyway.
+	 *
+	 * Only returns false when the VMM explicitly enabled Suppress EOI
+	 * broadcast. If disabled by VMM, the bit should be ignored as it is not
+	 * supported. Legacy behavior was to ignore the bit and broadcast EOIs
+	 * anyway.
+	 */
+	return kvm->arch.suppress_eoi_broadcast_mode !=
+			KVM_SUPPRESS_EOI_BROADCAST_ENABLED;
+}
+
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_has_noapic_vcpu);
 
@@ -562,6 +590,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	 * IOAPIC.
 	 */
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
+		kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm) &&
 	    !ioapic_in_kernel(vcpu->kvm))
 		v |= APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
@@ -1517,6 +1546,17 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
+		/*
+		 * Don't exit to userspace if the guest has enabled Directed
+		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
+		 * APIC doesn't broadcast EOIs (the guest must EOI the target
+		 * I/O APIC(s) directly).  Ignore the suppression if userspace
+		 * has NOT explicitly enabled Suppress EOI broadcast.
+		 */
+		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+		     !kvm_lapic_ignore_suppress_eoi_broadcast(apic->vcpu->kvm))
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..81b40fdb5f5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -121,8 +121,11 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
-#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
-                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
+#define KVM_X2APIC_API_VALID_FLAGS	\
+	(KVM_X2APIC_API_USE_32BIT_IDS |	\
+	KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
+	KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST |	\
+	KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
@@ -6777,12 +6780,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = -EINVAL;
 		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
 			break;
+		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
+		    (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST))
+			break;
+		if (!irqchip_split(kvm) &&
+		    ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) ||
+		     (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)))
+			break;
 
 		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)
 			kvm->arch.x2apic_format = true;
 		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 			kvm->arch.x2apic_broadcast_quirk_disabled = true;
-
+		if (cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode = KVM_SUPPRESS_EOI_BROADCAST_ENABLED;
+		if (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode = KVM_SUPPRESS_EOI_BROADCAST_DISABLED;
 		r = 0;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-- 
2.39.3


