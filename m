Return-Path: <kvm+bounces-16256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53C58B7FDF
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4AD61C22395
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7B01A38EE;
	Tue, 30 Apr 2024 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AVxZ2szj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bDSJZHAM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77D194C79;
	Tue, 30 Apr 2024 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502311; cv=fail; b=m91NVfwWhQNmrl/9uRC1zyGwcBQBbb0j89vGF+naCBuY96sDfhmoPGbUVNf4/UhFW71BLh/bSdTFUhQmccZlmbYELDHnAwI+ZxWM2tyUc6FXTQesZG15BJWfbQ4E/6bg52oECsg+oLdQHpb9Q0UvLaFdR6WnOyYLuQ8AywYajJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502311; c=relaxed/simple;
	bh=1tSPop/Aa40C5eMqd405zd9D5szO6qZPEGJ47AVD5Xc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UXWnZ/Nbe6DLt+N6NuLPlO3iowjWdEdmqxtmezfXpPe45SB1V5hKEkaHDOW8S6kSKXtgu91c9C//f9jy6Mc233sFJypSMkTaT4iT/ge+KqwH4NSuXrtna8puOJ7vFPl9SzkNZpSGqWHoU08a/5lh6YZeq0RDibzTWFVD+c8dcPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AVxZ2szj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bDSJZHAM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIhsY012703;
	Tue, 30 Apr 2024 18:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=PFKGe3msmS9uypHg1D4NVF1g24szXb61m885m1UIas4=;
 b=AVxZ2szjlL4LiGM78wePEozoPWZt4kIMIDJll7DaCvteGKIGtoDb4t311UY3qExXdUhd
 +nxeCyK0Vy2yWI2CINFlSqedPTs/P5aA6V54s5ZkT+PK+rIvNCmIrZ2s0lIFlFfoetSy
 u4Xg3mj08RzUsP2g09P4b9qbYdIP1rXnosGlW1uhCYkOVlQXioZBN/WObI+hJl6JBDb5
 ckPPBDhBvrosXSpxlmNI0jbS8B92/vpxPcPRYsiVk+uW6fas7inyLCW9MzqqpPaoZPFj
 PrqISrW2W1NI0khjqVg1nSdRQGQ4r911K+ct32bqSkZxXY7XoC2EZepBxJqdPLp9LykS pw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrqy2wxcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UH3kuB016678;
	Tue, 30 Apr 2024 18:37:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqteckhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSSj4E38oe60WvtCj1SG7aL9A7iSfkR6lb1bT7dTwM3PQLszrCycHffL7B66l+JHbGyXe+nbWpxoAjQsds4dzVb6MumV2/xiZ2RX5UT4WPm0la5A3n0wVHxMnXNkgfE7IhC3pup8ceE+2ZimsRRR4cgwVH+mFMTfwSIDs8bE7iym/QttH5WOI31i5QcSPBFHxXnlYEpOHpdEjMMn7I5dhTHrAR2sDmgDcI/l4QRJ8RI5L7kVC4bFfFWM6e5R3Zu3YFLN/t9Jg2ioUDnRGY+3K/R17+rTVXphROcYhDK+ApY6BvxkRvWG3/+Wy/PNRcznyo9EgiPIf3Cf/JPnIwcPqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFKGe3msmS9uypHg1D4NVF1g24szXb61m885m1UIas4=;
 b=WFJ4u2oN0p2miHchSKbt1DZl1kHl+XlLg6BccYLOuRqeb3LUxqPu5IkBO29fM+fvs0ihCDYSuxcs/G8n3z2uxAWizR9ffYzC9jsHUGp8y1QENxVYiPFueesM2hKr4DAT2RAHuHNJHtfjgs2emHRuXxK9+kB3mWTXp22CM8aZNBQyExemL77JA+12c1ZqRwIYatyB9vevzQh3I35OMdhCu5dZpJwn1XIR2ZH43OGMcGfMZu229AdWvUlmIzKgvCtvRRhrfCREovYGdmLEbnO57PRRNpsx9qTZvsRJ8vq+u+MP3SFa37j65v2Icso4WH2NTQToRC7aMZFnM6GF73VdUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFKGe3msmS9uypHg1D4NVF1g24szXb61m885m1UIas4=;
 b=bDSJZHAMRWt/1v02dvr28bIystqLbRMhay5bsbGotM3WzByZZEgLE7Lt9hIQGmVDpBTIC3ZNBR/RSbb7DvNldl8DBGuUj4FofTK01fyv0hV72vo2lkjeWTFzaSYmVBk6TH5cbFsB/hwAyomnBKtOBdSEk2pgiCeXYqnj+pNElCw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:42 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:41 +0000
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
Subject: [PATCH 3/9] cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
Date: Tue, 30 Apr 2024 11:37:24 -0700
Message-Id: <20240430183730.561960-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0130.namprd04.prod.outlook.com
 (2603:10b6:303:84::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f28dcc2-dcb5-40f6-e168-08dc69449e51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?jAVzqO66WwhlLyb5tq8OlEP1d3+RZQxNlLniN5S3CfnySjtcTLeyMRZX+AsG?=
 =?us-ascii?Q?q6WNTWv9D1bYf5xC0s+g08jZyrffn7UdTb1kdtlkT2QxDdueOVkx4/kRka8/?=
 =?us-ascii?Q?yz5u0fyszT2hp2MwYEqxBEfvQZCHRb4NnZhCmskupyKQwfPnGgg/S0yRLmv7?=
 =?us-ascii?Q?FlyhxpDbEaIM/cTVEo1gE/Y/LtMOCzLH7ZPL3bDd/JZ+I4zrhxJP0J3UnGK8?=
 =?us-ascii?Q?1pnlFFy38yDpHPDupro2dIc6XhGAU4lDZvC7cTn13Cv8RR0GW7JRYWg/2IgH?=
 =?us-ascii?Q?g8HqmvuNqFy2Ieywui8RaQoPciabJNsI0ernGI4evn+kNgBkgwaB+i6pdFCF?=
 =?us-ascii?Q?IcbdjJazwOInwHCmeJSDgJrqognV1R/pypy6dHhSzr4nb4W7KFLiiuB0cQon?=
 =?us-ascii?Q?uXYjTxrFU6IiaI18oEIu17P6HH+VRGnGkLMsec5SsaRqPeZZFM4VYqdbLkB+?=
 =?us-ascii?Q?gloaZgXf1dikGH+i3+GKFYjiYcv59YuvSH5/kc3MFGJnuCuNw6g2XFtfM8A4?=
 =?us-ascii?Q?h8yR8cb4B4OJAUSE+wUCeY39yHYWHWDxHwi1J/GVBYmJ/zazmG9RME/KYqwn?=
 =?us-ascii?Q?n1bOjZkLXg70tINkBFXRcuwBrS5Ou7QPErSdoKsx2vevAk0D+D3fNj1jvj/0?=
 =?us-ascii?Q?HyAu2OaVqE9SpOr1YPXeyxHOGYa9VLJc5QqbZx7YEn0Kg1oNgnP7S8Clw4oA?=
 =?us-ascii?Q?WAjdeScvxxkGLakEBXHnTZ9NDD+3QhOwfLyM6f4ELdr4GEdkozyeR7Q7McP1?=
 =?us-ascii?Q?qNvG/8m7Zh+eNhjnclAMBhRdiIBavysvfOV4RAgCroyfttj5qVsbwSXO0c3W?=
 =?us-ascii?Q?YTF1Jn3qOHg1od38bQeEU9l5pBSsf6ZItf5bm5/+nc11OI06YET/Ya80P36s?=
 =?us-ascii?Q?PFRbVvKe08hs9s0fzLBqysq+ezvjXl9ruFF9AREFv/02ZH8H/7UPlSY3FYex?=
 =?us-ascii?Q?/7FSKcfUVMmjGYcOVdXFvugYtMqueyetKW9zgM4GvwdNfqy70z3Toxn7hxrG?=
 =?us-ascii?Q?jf3vOsM+oec9nRtgc26Phqzd0NXJKGW/VXD2Lcx7P+ZDxsj5EyGX8eDc9lua?=
 =?us-ascii?Q?8dKprLKQPWuJueeQKNMXFN2QEDBlbB4Ia3xqN0fFMyjRhMQgi+Mh4ZLeK6A8?=
 =?us-ascii?Q?Q/U+OXfBTWVxdMkLYIjTdsAvKbOf6qrtQbYw4gJSARXrgovce/9hzbjDioUs?=
 =?us-ascii?Q?KOPiJhdJGl/sScNqoLXp19nnC8+c8M2f/TGJ2kZm22RhbzlqEVkY1PFZmaGo?=
 =?us-ascii?Q?B0SEFYI7/rhFMhKOCI80+COkHTqnyLaIPaHCLsidmA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?g8Y9twu4ewG5T437auRGiw8sI6v67wkJxDyezDnQEwiL+iDbbsK1G8onuL8J?=
 =?us-ascii?Q?KsiKqrjmt4sm3SJo4Zi4CyawIYisLs4xJDyHBICxUQAyUP8dT9DlDYgA5Jwg?=
 =?us-ascii?Q?BWMItk088fxKDh1lQfPy+uDiLdbaEMSl3dr0ED8TYxFKIsy7LJowN6US5Yaj?=
 =?us-ascii?Q?yoQsi33PR6j8VlAjdsLUYRun0cSjSmTEmQah04lZHkZiXfRPITjDcUk1YUbi?=
 =?us-ascii?Q?Ifvbev6IMSt7D+aV8gp+/pMT5fLzKfbCBiLSQiUVKZharFAIusDmm1qlZr7N?=
 =?us-ascii?Q?2lHpJK7y3vb0HXNU0AlNbXBq2BO7bz/A5+Ixsq+IzKabFKbWzQQxBnncjV62?=
 =?us-ascii?Q?19yb4nb2aYeUjvRyyG9vvzyFeHXpbigTq+O5V4xDuQdKa2MnD3BoAsquhlAv?=
 =?us-ascii?Q?WKz8uN0CYmX4K0ofk3HM9HrRz8rsglOTmRN8AcQxlfm5rjesFJcPiWeg2pMl?=
 =?us-ascii?Q?3QQI2B0V7GbPwX2+c09EGLiz6/ipt+lVt9ZyGNGxXqV7XvKeEKybjP2nQNvH?=
 =?us-ascii?Q?YU9bbVH1A7JL1SMsC68ZwPZsf+qd1xch4d59Gh4hSEBHIeoTcs1rr44y7CfQ?=
 =?us-ascii?Q?lamipT2U/meyPdYBrcQzsHWPeVoRtnk0SoR7EhJjhbPbMD88n1Wc89YXOxby?=
 =?us-ascii?Q?5SPG+yTFS5BZpMFdUC6IUEd1h5HRzHYqTJbSGkjIWXCRGHf498B5l4cN26gP?=
 =?us-ascii?Q?0Qkg00G9aGwyqyioDLrBMNVRHk+iw3h0Mgkk7OBlIIedmo3G/j+doz+V6y8a?=
 =?us-ascii?Q?LHoQKKBGeN26+WT0wrpD3NNpILJzLgeehjxVaS6JpubqTmYmB9cJJEPTwXSs?=
 =?us-ascii?Q?dNJWn3qEjmHepg9CiivvTeF8izXs4FJyKDUvdY4u1d/jqACtbqHlUgkULlCg?=
 =?us-ascii?Q?6siACCH/m1hnSmX5iymvjp4kUoJMudKcL6Vs80GTUAhLkOqka7W8kT9f/cmi?=
 =?us-ascii?Q?eWPLPsaZZQoAL9OaYKN46fUdxUPPcHAIFKvbVW5IB96h33nD3BxR6benNQXt?=
 =?us-ascii?Q?ebETfkXEG0Ued/Se3ELxYNLZuPvUuzUIp+18tOYX1FMZfqj2WxUhY42yNAQ3?=
 =?us-ascii?Q?QHaPkMWYl8zfg/I7HWSVta9Dfo8T6pmMSvg1HdLxd1is9gWWIep92WbvEXyC?=
 =?us-ascii?Q?ipciLKv33zy8L6wLzmBB8C5CzaG+5L1YiyYwp/xU+K4OPULyrJyroDrMvH9k?=
 =?us-ascii?Q?/Kx0E8sG+6LKtRBjMLvvdR4hxbuR4yZ4VdgMosUETAp12TJP26E0j60DtEBS?=
 =?us-ascii?Q?xQMBVvMp42sS81pvMkatPX4kpXix6MKbOqRggxZZrh6kpQCoQEdGPUMhweMG?=
 =?us-ascii?Q?PNiDOqDYSi1mGwpj2Il75Tt7CTQbAb7EuDaJAt3ZYxXlnwfBSyQmcmNpMsNh?=
 =?us-ascii?Q?Y0liewIqajfjJcAX2OFs9P9jc/gEvzzLyjdEP906ZjwhBOxBN99w/WVrSi1o?=
 =?us-ascii?Q?TuLIzXB5uHc/4DlVp8d1SQXJisM8ekwpQ5AZK+7vaIOOfflKYhDPjSnEqp21?=
 =?us-ascii?Q?5sE89NKxPXMvIeYR8crBGN5cSIAgZ9Xn46Z1k9ud6fl/whlURb66nhd8az8e?=
 =?us-ascii?Q?wwd+Qm9PIpGD0NMoS2LWGAi5e61th4W7q+8DSToapyVvmk6Yf6CPjTvRX/r4?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/TrnSrw0lGbxiPPXD29ZFtVPznn+x7ZBW+w3cgZdBT4YfCRUoMoX8NM23jGKlIyLIN9L1ZYb4GKu/pUoRxaFFZPmfRQP37Q/2T2Y0v9x1kc9beLTA90iiY279/s8A57BPESvS3YTlu3CYi3dW5oPRnrYdb/7x4rB7IX1rknw+GD6sOOUHwZ5KkDLrBoaIlRDjSIQ0z2iPPjFaGKozUau7m0xroXNPl8e8GwI4itTs08LuU2zUEZop/JWOgivjsYqjdR1QQUWCvS3Hyfb0omha0tV1MVbfdBheUK3IdmVEjQwSjYfDh/Rhgy4GeqkyaFL+CTQ/5o8ANgaCq0SWvGl+1TqPsvth2bdME9o/MK1tkOzqF6q0VVl1/7Wfk5rwScWRpQVAl5XaVJvxP47QVCA4+bEcvc3cHNlwdNeZ47vHVqFCvOd0RvOkG7LjaQGlYKsxoElezAemXc/KaRXdsTWirYbnmMR659H+obeK4B5BZNVDptOBxdcJ/xA4j7kXvbT76U3gJZQJCCwvX8wVS8CJ0VeXraHzOPVy53E7jAOdI9pSVZTgYZsNDvWUSU017EhPa+TEBUsZtW+1Uow6UehlkP7leKFXG5dApRfyiKaWAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f28dcc2-dcb5-40f6-e168-08dc69449e51
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:41.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8MZdkIGkZPFzPeVkv1ic5NottTU+i8e5cDg7ttJ30qTOfq0yGYGI2DeYHBL90hsvoCcRF5c9JBT9BtePNohVUxRW75XwKfL14zseTfv9xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300134
X-Proofpoint-ORIG-GUID: _0TmJ7kzjgoAimFU5vVoQmCnp4D64Ffl
X-Proofpoint-GUID: _0TmJ7kzjgoAimFU5vVoQmCnp4D64Ffl

The cpuidle-haltpoll driver and its namesake governor are selected
under KVM_GUEST on X86. In addition, KVM_GUEST also selects
ARCH_CPUIDLE_HALTPOLL and defines the requisite
arch_haltpoll_{enable,disable}() functions.

So remove the explicit dependence on KVM_GUEST, and instead use
ARCH_CPUIDLE_HALTPOLL as proxy for architectural support for
haltpoll.

While at it, change "halt poll" to "haltpoll" in one of the summary
clauses, since the second form is used everywhere else.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 75f6e176bbc8..c1bebadf22bc 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -35,7 +35,6 @@ config CPU_IDLE_GOV_TEO
 
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
-	depends on KVM_GUEST
 	help
 	  This governor implements haltpoll idle state selection, to be
 	  used in conjunction with the haltpoll cpuidle driver, allowing
@@ -72,8 +71,8 @@ source "drivers/cpuidle/Kconfig.riscv"
 endmenu
 
 config HALTPOLL_CPUIDLE
-	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
+	tristate "Haltpoll cpuidle driver"
+	depends on ARCH_CPUIDLE_HALTPOLL && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
-- 
2.39.3


