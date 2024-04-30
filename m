Return-Path: <kvm+bounces-16258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 227EE8B7FE2
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F6EDB237EE
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0DC190663;
	Tue, 30 Apr 2024 18:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BNM6y3T+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lS5CCDTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9BE199E97;
	Tue, 30 Apr 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502312; cv=fail; b=j7FrIzwYG1wHGqvZOQMNtB/D07+VoAi8LMLMEF1YH0ZHIsTbovRlwKhGl+RQNjmz96j1R9iU/S+AgCgWumRIxauRMaS7LAMcxe/fCkKgfskPob8e8s1Cy8zVg6raWYRaQtE8qpw6i8BWlw7mWz/u/2oKGB/uGD1MBtu738bjsxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502312; c=relaxed/simple;
	bh=TFxGFHQCBMaqvdP9/VY6E1q5d7d9ZRCVgrmsIATtYEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NThpJrzuacgYLmfOme1wL/E4Qe7B7c0pInzGrqnO+4BTvkh0CMbG+Wus/5atNQ2gSM/0VFD9WO7FSEVJtW/3+cdpdUBj0IRxCBOSoMfnM6gGzwpqgZmTXZbR5qeUX8xPhyMjj76LLTEvp5ypePgrPr/CfNRR8cZW9nfHYCIIDqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BNM6y3T+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lS5CCDTQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIkon026936;
	Tue, 30 Apr 2024 18:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=HdAczQ+ZjtCAM9TckgmMgIcWtHoJTvXFQ4LSTfKD6q0=;
 b=BNM6y3T+AlRAgWd+pfWrKMPmknMO3BFXvosPw+JRbM6n0jxXd03xnD4LwowwK9obM8+2
 62WgI9eVGieFDPOQnVsyTDjB5k29LoOuY/OUcK4GUJhHo1TgHh0aNXKT9t0srVdcru97
 ZcA2yhgNd86wc4bxYKrVe246J/M+IMHFsBtRbqfJukZKjqKo2Gc+Gqe7cJsN7uEX7C/4
 SUgv5LcIXJpWpPN6TDk2dYEOBYxuGM5/kKovhZO90APm28PqYg7nvwZWSRtdlKyu/nYN
 94TPUQBf1AQQxMP1qrdiNN/D4fABOA5UgiIxW8HvXTo19N1nYrirQXBHkGH/+w7/zqr4 iA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr54dujt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHdbKf033207;
	Tue, 30 Apr 2024 18:37:37 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt84r38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMFkFYH6QT7duh4W3AgwOAJYUX3bNoi3MJ9MZfUn96R600nVBbf63bUVtDwSIrLbUIjV5ELEFRtZMQp5EMGoTQokgaVLhVkMMLjm+PZBw6JfBr4OjzKMurKcsbFOjtVdlWcyUKDBRKxd+6ry3sfrWlGwnQOSfJXtmYijvorm+QeS1/cQjYKJBBch1Bqprcc59AVZ3FWJGf90+sAr3kYHRAlC4ZW7KNVR1fiLD/5Pn5TzfIdX6VU6zdj5H0TgHD39K7FMIwW+QxHiqlojbxuLcGe2RDrHxSc1yI6WvxUbuMY1G2rn10XmAAaaBy7vXQzEYwRMDyGf9ixlekwuPAvtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdAczQ+ZjtCAM9TckgmMgIcWtHoJTvXFQ4LSTfKD6q0=;
 b=ejUeJhM0S3TAj1JF+WLmAceyHwq1YRNaM7mn4NDJssu5riByl8rOpTODnZZ2DsXuW8+Xj5rc9FuSISw1DJPFwGBZWb3wiIxm7wG0kcUDrjBNHjaWDMxRSHy/theJuzln6b2vdPMorhohzoCWQvRPOqyIM1dhjVvEkQHE6xPwgd58W3T2m1vfBXHORaE+p0/W4or+fDFfxiTpN08UQ9VentKvtk9056X53GUWPIxZWfs6shcPh8Sa3f/3dfKUW/Fpj3xct+sGT/qE3IQCUzs7UYpnpLRXQ+62OnNFFQkr9AcAsdwFhMvEAm+gcdAYH9xeSHKIr3zbBxjVLWxmWUNCrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdAczQ+ZjtCAM9TckgmMgIcWtHoJTvXFQ4LSTfKD6q0=;
 b=lS5CCDTQQwMHOf4zd+MYuGNWcGR/1MTKqoAescrgX1vjDT4zBm8jtaI78sqKIH0Mm7DvnW3cR9qzsv94Y+nUQkqhMSUzRE9Fwl7M08cPz6g293VZahFGNmZyoKhPyIXDmw5HJXlcph6gTk7B0ad5adVH4OvfIVWWGIc5iZwqtfo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB6152.namprd10.prod.outlook.com (2603:10b6:8:c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25; Tue, 30 Apr
 2024 18:37:34 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:34 +0000
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
Subject: [PATCH 1/9] cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
Date: Tue, 30 Apr 2024 11:37:22 -0700
Message-Id: <20240430183730.561960-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0136.namprd04.prod.outlook.com
 (2603:10b6:303:84::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 8137e8b5-a426-4cf5-d90e-08dc69449a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?6CrgJ3VHAu2/anMk6DlpLrzTADspspjxExO6dt/WFBhTqcCfi/qoPevSiszM?=
 =?us-ascii?Q?5oIDGOaGo4VSV5f/TSCNK00gH6Ml2BxMeoqqgSVMOeHpeAW5cpQ0U8IzdgSK?=
 =?us-ascii?Q?6EBt6bXv3PQphOPdrIKzKwQ0/Kq2AnnbBp6AwxXr9g8CmbrBQ3mXuGemXNqy?=
 =?us-ascii?Q?DASwafsX2f3gWsLdUD9phthZBwEnm2AaGBSAblM8vhdxGuDPj8SXxMP/d5q3?=
 =?us-ascii?Q?qxbtt9ltDY191EYRz3mQjXdH6nBRQgVZPK5q6RrGiY6NZdPcW++tAJtu294d?=
 =?us-ascii?Q?g6b2ymjSElYDyCA47kvwwumyvjOeP+W3YE5VBTPPsmjTaf0xEu92ufG81UbP?=
 =?us-ascii?Q?SbR7TNzUHVj+8ZYAl+8jwi+8sfbjByhZi6Mq8703VpYWmVfF/pXCM1JltpGX?=
 =?us-ascii?Q?U+bhDi3A4W6MUiQW2yRMVYSO8KhrwUhje8jSqsrt6jusW3XYzPHdAXdEgHvh?=
 =?us-ascii?Q?ANnedILf/gg/Qsf4gL8ETzycrkJqCe1ARc9E6Gn912lWXz1rrqn//Chh4Y+4?=
 =?us-ascii?Q?6/4SBMgHv+umdxnud33j3uWqxhnpD37kGNQofCAi5+0Fx5GPNu6+V7EP5DyV?=
 =?us-ascii?Q?uJXzU5/iX7gFZ2TCLAK/AirMmjJJ0JPyVFS6rMzn9jp+ZqXC4LmwKt/JrO1N?=
 =?us-ascii?Q?8Ud9mGj977zKFJ3rmUGKcGOq8ibx/J+2YYejihNSNYalcaNo2Wf1w8dNT4JE?=
 =?us-ascii?Q?cYPbXms3MYWfrwo9E76AOdsQFdbsOBjM3Ws7DmC3wbRKLMI3mHmXi+Fza/yA?=
 =?us-ascii?Q?/LNY+uI4Eo6wqQXbIs2bUnoMXpCemilohgmU1Zt4FRyQvzzahL3lMpzg3C3u?=
 =?us-ascii?Q?s3JTGfWWtcHLt2SS0BCvwK6/Ou+DloVQRyJA81NN17Zz1Y25UbzUUx10VN3j?=
 =?us-ascii?Q?7xeXndjd5u5zAmXgHuZLIA9XKzVSYT9k2xsaP8SCCbg2jUgz/UjyutLNUIbn?=
 =?us-ascii?Q?sqZdLTqizNbTpeLZ3/syZvPmx/rc2ES+SFn6bZiIMr7zQkGS0IWehV0q5HoN?=
 =?us-ascii?Q?5KSrImXIrLViZgV7vlSQGH5YFm/G8LOzu2cfYKcvADeffTfSWB1/8pDdwr9t?=
 =?us-ascii?Q?SEKAti5IiJpYztDO2Hl4QDycpMGQ0mHKfzCZN5MXNqGsGdXjlNZASLzPTb7j?=
 =?us-ascii?Q?f4ZiMFjkSOB/wCbbL4Ht4sYbsl4YxnENzYKAoAoWbPw9vXgFIYczy4iRK8rz?=
 =?us-ascii?Q?v8FiqCSw72KDSLgCVsljaPjQv5qdsfRjSc4wOJg2bmETNu/iF/xVIkkYbrH/?=
 =?us-ascii?Q?EUiHnEFOByq5SYIVGdtQIdbvihO+J3sNFHioHMKT2Q=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SiHcbhCbjWP9MRHGuPU9tJZbGcpysBZ5gMyq49Nir37xBlMXCvtvICqnM2Vq?=
 =?us-ascii?Q?dxK5tsR2TqhZVQHyHs0fRZGOFnd9IT35fpzC40NiFOWbDbE/0SMqJmgEioy0?=
 =?us-ascii?Q?BjhL8keiWPNreNSeLB9mVXYbyg9yy26vxKbo/Werkd8uX892PseHGzqgFn79?=
 =?us-ascii?Q?qjL4lLMUfbgk6FCF/IRp3cQs+95/kzMSCpLhCRsLSj1CFSwLLUPihWyTjH7J?=
 =?us-ascii?Q?YE25t+XQbVehl9IipQ2Pr0VlKXK4zVATO0TnRtUakXpvyZlgGg0zWFS6O9tB?=
 =?us-ascii?Q?YILLJ2t2qwbdnfBmD9vasNHPYQ6BdAZB7/3esVMP5xYM4mCqC/w+cS397C9w?=
 =?us-ascii?Q?Y6V/tdule+kSGypx04il+aFl06sxPM6baMP/FoMxQBye2R3krOWlvmGcGxYE?=
 =?us-ascii?Q?vjxkSTukZUyN90azcXKXZpQgywar6yujQYsjfUOBua9GEarLDvH383VNYMsJ?=
 =?us-ascii?Q?OAf5aEyWxAvy1LjlAIUcTJjekTnrFm+KH+WfUConkkFtWc0qrmgm+On+UJoX?=
 =?us-ascii?Q?Kpg164SQ1kdU2SM7TE0EaYfmZAX4Cazlf+b7nEnlJI2iJBFjx2fYbJvgsIPT?=
 =?us-ascii?Q?7Qxuhh//uiXt56+y/PYWS0K3dH+ZEWL3884ZTGDmY37S7ybBhQAMASWaxGRI?=
 =?us-ascii?Q?C6eAvVKecZpLELPEh7oisUcrx6zhF5oJtus7qP3WeZCuC+Xhg3kdvcNcr026?=
 =?us-ascii?Q?WdamJVUvjq830J99Lgw57XkB3j7TYQsT6DnnoD8fZqOrsmEjSRkWzgDl6R34?=
 =?us-ascii?Q?40VCCosVHJWAMUvyeLjKzqTRjigefsA+LyVqqBPTYE6xw1Jdif2aD/MqKOBl?=
 =?us-ascii?Q?rVn3Pz4HKI5EBk5nDpU9qWUJ1BUQZ6K6cyX4NiJ4pojgznP5cVLlMntHxMQd?=
 =?us-ascii?Q?vOfLt8hZmajlsOmVzHG57ISk70WenHMITd1JKycMJjBIa7zGiZ2woWUHjSjW?=
 =?us-ascii?Q?U+VpUwBEHCAv9d19N70ni3iPl0aU5PW9D4V5Dx9ZIUXauyAJBVcsYxlw5u+F?=
 =?us-ascii?Q?LA6wWgbWWe8FwuQ/HDGDsV5vbqK0zhu9x9+Swb3XcaD8553tqERtPD8ZBI+u?=
 =?us-ascii?Q?9G/Sht5w15zmtkRzunp8iEljv+uo2qxcpimvupRYyxlGNpcAZw6aAavf8lAC?=
 =?us-ascii?Q?3NH3GI5el15hdM0RT5F75j90cV+rUGs6/UKu/zbgx6o+oUSpsvfBfUgLTCen?=
 =?us-ascii?Q?cavee/vzZ7HDcNKtXQBTg7EbyoNbsHQ/oYwlIfUzaI+6W7Qmh8cd7atNVOYt?=
 =?us-ascii?Q?uLhaH9nsI82xusY0wlz5x0GvjRyensjU5ihqMiAkUD9lvr/mSfFHhs8FJvnE?=
 =?us-ascii?Q?VfnyYpVftbB3j+wqfztFWhorBJDvpwCJDw3j+Gu3Wfy8iuBFn5QRjU5r2F5s?=
 =?us-ascii?Q?LmhV6Fso7fCsFcu9BUZFIyOL4ZKSJNwCjHUOSVHLksvsrCwR3Inhpx3xpwfk?=
 =?us-ascii?Q?cteHJapbnaQPw4uOUL3wg0Lr8iY6zxsIV9NqReNro3lualDD8a10cuVyFXWF?=
 =?us-ascii?Q?8/GCtFkDEOrsJuh6O5+y7W92WCD2rzXilxVjjBjcsbbgEq2/KDGtuSFqox72?=
 =?us-ascii?Q?D4h2GSiDyPaT7W+8LQSEctVlIgL4we1RH0naCPOIkkZkMLWEv/Y+M4/Dbqx6?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZawfO1jtLZqmvb57fkJ9WSpZNaOeXqKc007eP+p+WEva3UcwDR85WPKSnGw7rx3gGCpl24ujlBHlQtBzhIeZEtktBoP9gNNWSp7+FGASP8I54UDRxp2MnQuzcaoFytktdxIUw7BMBnkDufkG86ChSG0ZXMheAvso4DOma/p3GLwQkjwt7pVMyBN+dNJxonec0DcOU+1wuQdTRkPPLQDlNBbwuulv24DNKrQefsDqN0xQMew1drpSCjNSc4xyu4V0jdc2JbW2hCYtYYiEfQy11BDpJfvo761fzOpmfPkGrHQBvjCIYFBdL8p1pKeNYIAAfNybKlOazpkmbMy9KOWVWV+Bn+AFOsu1vZBnh7sCv35E9cI73K0wy5G6y/Us4HqvO1Lc9ndQ6eXIAGMf7wmZbzZGNnF58MN8N4qYaYHrPXyIuTXGJRj8RT165tUI2AuqncACV0fj9KrKtoO0b7oavAhE4qMJVu9XPh7ci4Jky88G1Q49ug5/4PnVJx/Uy0lHsATofI/b46hsBEi+hFoLO3zDUKjEiKCN1Wm05qM8cgEIMoJTsYs9qS0jSxoHSOspuxPflyFkEQEeT4MWSiWSX67jvqTo1SiJFnFrJtpUlj4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8137e8b5-a426-4cf5-d90e-08dc69449a3d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:34.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADpbbicc2JBLdomVubigKLYIPMQKwbHHeTu1k+OuJCsEtFwBJLLaWYWqXcL8UNaGPLm49uq1pPc2u+bnggkdSxsXjze+ECf4r4Uj2DzkFGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300134
X-Proofpoint-ORIG-GUID: LhFNlWfvRqGAFUQPWhshBlxXW3zQ8tCE
X-Proofpoint-GUID: LhFNlWfvRqGAFUQPWhshBlxXW3zQ8tCE

ARCH_HAS_CPU_RELAX is a bit of a misnomer since all architectures
define cpu_relax(). Not all, however, have a performant version, with
some only implementing it as a compiler barrier.

In contexts that this config option is used, it is expected to provide
an architectural primitive that can be used as part of a polling
mechanism -- one that would be cheaper than spinning in a tight loop.

Advertise the availability of such a primitive by renaming to
ARCH_HAS_OPTIMIZED_POLL. And, while at it, explicitly condition
cpuidle-haltpoll and intel-idle, both of which depend on a polling
state, on it.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig              | 2 +-
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/cpuidle/Kconfig       | 2 +-
 drivers/cpuidle/Makefile      | 2 +-
 drivers/idle/Kconfig          | 1 +
 include/linux/cpuidle.h       | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4474bf32d0a4..b238c874875a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -368,7 +368,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_CPU_RELAX
+config ARCH_HAS_OPTIMIZED_POLL
 	def_bool y
 
 config ARCH_HIBERNATION_POSSIBLE
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index bd6a7857ce05..ccef38410950 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -36,7 +36,7 @@
 #include <asm/cpu.h>
 #endif
 
-#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX) ? 1 : 0)
+#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL) ? 1 : 0)
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0400);
@@ -787,7 +787,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	if (max_cstate == 0)
 		max_cstate = 1;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX)) {
+	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
 		cpuidle_poll_state_init(drv);
 		count = 1;
 	} else {
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..75f6e176bbc8 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -73,7 +73,7 @@ endmenu
 
 config HALTPOLL_CPUIDLE
 	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST
+	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc..f29dfd1525b0 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,7 +7,7 @@ obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_DT_IDLE_GENPD)		  += dt_idle_genpd.o
-obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_ARCH_HAS_OPTIMIZED_POLL)	  += poll_state.o
 obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 6707d2539fc4..6f9b1d48fede 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -4,6 +4,7 @@ config INTEL_IDLE
 	depends on CPU_IDLE
 	depends on X86
 	depends on CPU_SUP_INTEL
+	depends on ARCH_HAS_OPTIMIZED_POLL
 	help
 	  Enable intel_idle, a cpuidle driver that includes knowledge of
 	  native Intel hardware idle features.  The acpi_idle driver
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 3183aeb7f5b4..7e7e58a17b07 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -275,7 +275,7 @@ static inline void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev,
 }
 #endif
 
-#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_CPU_RELAX)
+#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_OPTIMIZED_POLL)
 void cpuidle_poll_state_init(struct cpuidle_driver *drv);
 #else
 static inline void cpuidle_poll_state_init(struct cpuidle_driver *drv) {}
-- 
2.39.3


