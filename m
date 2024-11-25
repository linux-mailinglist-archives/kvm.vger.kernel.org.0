Return-Path: <kvm+bounces-32447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1C89D87EA
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD970291034
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC741B21B8;
	Mon, 25 Nov 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AT6SSnju";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tDsTUzP+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01191AF0CD
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544863; cv=fail; b=IRTlK0Cuc898EKCp7Gy3k5wBJc//fJkMZkoykBvCocJ1eirQ5jh5jCKzqCSUi6JFBctsM5ACf7XfqDoBO/AdEjzIriBimONsPvvtTK1B+RYJI3DPnM+DucMgKyED30B4qOJRTahE54fjZA7OwqDDIA+GAUEBCQBpKnVHgI/utRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544863; c=relaxed/simple;
	bh=qP6OKFamsgaM6eO+4QseQKm5iVHFaVU9LSr2ic1szMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SCdKAtMDYQz/f9DzOSsIqG0t9aeaTEaL64Jyd8QEggkeLi3Hrdc+g7oWybJRze5PKvZLxNEiXEXzcHGjdiRQYfv9XQYr0Y2JpMLocrWZ6cIcgSEIE2gpqSWAX+IDj6k+aq7Xw5jFCWzxylXHB/yCmz+TqqxC+VrMFkU4VrKS/S0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AT6SSnju; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tDsTUzP+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6gLWS000436;
	Mon, 25 Nov 2024 14:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JcRMedMtEYbr8ozp5sl/bwsH+cuZg7qQXXPH/ikOmRA=; b=
	AT6SSnju/WbW9exwfTcIuI+FYJzHL+kAk/Ka5JmQxA4714EGqJPeWIx5Uh/ZSRJl
	9B95tiFQZUlG7DEIeDL/je+bU8FEqmOSiF+7JCcZL8yyDiXqa2ZguMF3X2AgNLt4
	bGLY5+lEwWR471Pe+U6Nb2XiO1WcJheo0b3vjjGtK+W8/30jShUDYFpb+q2W7FSA
	mY7ND0FxHa0Wr3U294J9Y442Idu5G08wy2q0OlanA8QSou67pCxv6J4AE4MEcZra
	tzibzvcQXGjwpQuI6oBBqxPTvUr/ynBVvk3p5sT62VFET+UeELR9lE1Yh6czILgu
	e7jhAMuaoG9dpelO/j8zFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 433838k8h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APEPXkA002706;
	Mon, 25 Nov 2024 14:27:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7tdjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkbSbYjLhd1vdMiQdoGaM1FlIfwsp5ntbJUi6oB4qa/I9sGNQRpdkAiu4Tx4Ev9gk3m+reuka8+/WrgmZDIDtI12zmfQ8GTb9vm2eGzLrclR1qWiKeFscyOEgmSp+1FqXR8yUWu6DHY/EQFUFuiiioGScJflkWPvx1fTbKaS97djWT4l00A7vmMnKaowxcvQH3eKyQlvIKXgw9zmkXT32Z+zdowje4+kJfP6ABZbcGCFeiGVypGgfK1hBRUvhYPvKRkSp0MFmFi4rzXktKpuqihs03Rkl1A+Dxw5vGCrToZ+A8SwthbsyW96W7t9y9Qr+H/VBM6u7tVhnmdmjFQFJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcRMedMtEYbr8ozp5sl/bwsH+cuZg7qQXXPH/ikOmRA=;
 b=rYZvCKLYKj7XmM2ke9ETaX7xXruBuHtEWA6Oa3MNettnMYwlPS1sz0NmBbVqdZtTlsfaKEV6wqnW61d816b2QPRtHK1wd2c7R37WUfTvwC72CXzDVnBQ3ZN3DTPMZ9kmeFTwg8i+bwk7fSERSZ1yfePHCzhHXar7FvE0WaRIj/ZHA5GVo5Om/Cs8pyZwSK0iJ04qUMe8ciL7ysslh2qW4UsHoiEH5okq134Q5SvRC3eH2/NaBe5R6mpWC27frOzK8s+SYxBNva3Gen+fw5qD8p3SbyrDoRayvkX03cLZdxd48tfQme5AMRmc6SPFa0AzjGTaWElj6b2d2QEu4ZSGyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcRMedMtEYbr8ozp5sl/bwsH+cuZg7qQXXPH/ikOmRA=;
 b=tDsTUzP+3Y9JlloBE3k/g5/5FOworzw3t+ALqo+d4gd/Uaw4ntYUouDxdrx6GFQlVdQ3llWlscePjFG+yWOE1Drzgboc+TuJsSYooJD3fx/iTp3SWnQbjm17kSf4oSuG0MgMZLIfpX4x8/wvZQxd3f2BkId5NaSjgZiAYdnKk5U=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:20 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 0/7] hugetlbfs memory HW error fixes
Date: Mon, 25 Nov 2024 14:27:11 +0000
Message-ID: <20241125142718.3373203-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR15CA0249.namprd15.prod.outlook.com
 (2603:10b6:930:66::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1bccf9-144c-4f0f-4543-08dd0d5d450c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pmuq3TKqk5O2o6ZOelBEw8pjjQLgJ4UG4A+UxIopKVpV9+i/IQdlwe56Bl4z?=
 =?us-ascii?Q?TKChZ1A7W0RPVAZl8qi03wJnN6VB3Q7CBZUxo+eJdwK6TIZCBTpzKuWTCbvK?=
 =?us-ascii?Q?s63R/mZQQE5u6Wj+mcdnX5meN0UWJ/qj4UpvSknsAqp4/dusMxl+hZPTzNtr?=
 =?us-ascii?Q?GrzPkQWImrJuJFI8vBe39jPhWszIP5QAOBapqTyL5zONH/E7wQcT6P+6ysD+?=
 =?us-ascii?Q?5P90D0SmCXK7snc7NfnsPwtrxDGUxtQNs8B69N06/Y6NjU5/vjVt6moGCAxM?=
 =?us-ascii?Q?nPpBIlT+Kw63l+7zFx69ZdgXdHMSLGFT16AMlxIp1L54NgBgCTW8wZ83R2lZ?=
 =?us-ascii?Q?GsshRWhj+Bz+7ENW3wPRasFktO/nRtP7l6DNTlG2nbdiKR4poIKFaQj8LaS7?=
 =?us-ascii?Q?IsgCt2DMX+bhGTPqMuso5NYOBv4VFT2AHWiZMNnb/1CN33wWm11mBph20NK/?=
 =?us-ascii?Q?R3WfHFj88+SZqBRxNR4rCPZvt2di+jhkn9r+FDFHTknZ4G+TMth4+DUjXaCS?=
 =?us-ascii?Q?PfITBRp4hTaM4MdyDy4LGoPf/XAvcXvsGOkh578iQFtKCFhd7mwy8YWwJRlN?=
 =?us-ascii?Q?Fft4mqgzO/XmK5fCDfPcBEb3HqlXcK7bQWeI6FPrQe95fG+kCsguDbUKrSsA?=
 =?us-ascii?Q?brfaNwYs6ua7/FKX1KRNd7u1TFPCSelcq1+7LXxYVWSNumvwNqJfM5FKsPj9?=
 =?us-ascii?Q?vsdsmcGDfnm+DA1NAlDFyGmdh+UkxorSvrQ/kXKNSiXFMNFpZBG1u+wY5x9O?=
 =?us-ascii?Q?3F6NQic6KvfCZMhE1eKHY4U0px3MPgS+aXLGEf0/DONaB1jFZhEYe55ZKsUq?=
 =?us-ascii?Q?yjqsX4RGxnvQGNTfiXt2Lz7ar03apGd7hBdObAL1EKmO5/d0elfk1cTjlpTf?=
 =?us-ascii?Q?RfN6hj+l1Ag1jfuRnN7VAaTOyhnX04IjK4ZWTeU7hqrAAH5Ex24c3EyXyPmA?=
 =?us-ascii?Q?wbQ3jM0OF2K8pu6WlZwORIVublmUZ69bilJgybVUespI7KteLGIUh56BX+lV?=
 =?us-ascii?Q?f1lwYzzhGNp2nVpB6c7VCmh2T9tRvP5lmImGIGayGu2ADH48EdSWmDuXaivg?=
 =?us-ascii?Q?pcbH3DZRPUOW/UNKavujED97wVhzOQCwSYkyek45M9nw1R1n1oZnEgi0+xgI?=
 =?us-ascii?Q?g+pYCxFJKAIaik/5zi2oKSI2cmE9DX21aWXqzgZsnqW5QVBu8oOqfHx0OMZf?=
 =?us-ascii?Q?cmi4N5JzM1agI2cA6d+RnUpwZqMmKq+yJx78POadeDiyo5DbSUGgOT4NO3IZ?=
 =?us-ascii?Q?SlB6HqaKV9FP3b4ZU+BAwpmKfLaLTaJn2646ksDn5iUtu5sKYRi1ZLAcnzFW?=
 =?us-ascii?Q?u1a/2f4k6MQAFgdFXLCdQuS5/bcHfHc4hbAI+gZnFg7DEw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C2PlQ3whfquiM7IM/U7tjlDTDf4dYnxfCPQCW8aLgiwvn+zUtMf+MLoxiG7U?=
 =?us-ascii?Q?EXih2uPj7NKP0dHY8OYMHGyRueqUr+fRiKqtooZbu7aWtp/oPLDNrEMKKFei?=
 =?us-ascii?Q?DB1l8XpawrNKiqSrAKM3c2zMqFtkAWzAqzvn+9wFh/EGnhl51Bz/bLVwLsM3?=
 =?us-ascii?Q?/0JH7aB1Vi7sXIB8ejT6LnvOO7iI/am4O0G+TWBnkyXTVq0Uyz3M+g6UO6XB?=
 =?us-ascii?Q?UyO+Th2GWIPT4nHUacBNrfcYi3+JO3ZTw2eNDDUuXZetOJvQijIkkmLh4KiH?=
 =?us-ascii?Q?WHiP23+r87U3clUE/f+K0t7SGhW937ZzNdBFX9tcbgZqQuNu2yE+AwitAY6C?=
 =?us-ascii?Q?A5G0jb/EdnStiuipZazNGdFog9ubSyhUQtFAqbw2DIQVoeQCOy56GjUIbbqS?=
 =?us-ascii?Q?EGN3ECFjVWAUy0H1L6U1iwX/40TI1pN5ErqfBZuPOgJeQfQscgEuSLmW7+et?=
 =?us-ascii?Q?oPD8c7VLzTRNW6fvcpKhE136CxHFv0TlpTaUjCKt4KiTezC/VxWscsd2QIhe?=
 =?us-ascii?Q?Tp3axB5ZSAfKV1E78TN+AYqmSC5udecW6Av8eLC+GcasX+hHZ6mttPx6lNeD?=
 =?us-ascii?Q?yY+Qns7xRpfvn8LCIWslIzMp1EkDqSwzx61xn/1ujao6aZREnuFeh4DqeiK5?=
 =?us-ascii?Q?pFvw9JboC17yw2YuYPGE8pDALrxK3OLtqUL5Z4oIO1awGEAYk1stm79YsIwR?=
 =?us-ascii?Q?CkFZrRpDng+rFUgi9DfAkZvjqqPk8Ogk/6tl8249g/DfSoWk4tN+ACHFmKFN?=
 =?us-ascii?Q?85pNPkL7pqQSzFmWN8PDFIT2wNaKMIVhWj7l47fCA5zqFTtSbl9qOxw5J9J1?=
 =?us-ascii?Q?UP6A3cCSf4qtgvTK1Weqi6m9s6dTd5lKWAmVBqlbvNg7i+PD9Hg6q+zlhM95?=
 =?us-ascii?Q?/oPnp/HAPnPhjX8XxU02N5RG3+xa02Dxl0L9S3l96n+mDXQKSG+yArEMPtns?=
 =?us-ascii?Q?kUmoxVtMjf8veFWGNizTiPao3AZKENxZvmadn4s17JMsgFaDwMswzMTMexGp?=
 =?us-ascii?Q?ugRK+WvXaGSs12Ua56z6oIO14hJrgaKAUfmeZo7ZgaCGip/PR76KmJ1ZM/Hn?=
 =?us-ascii?Q?n0VoyXHmmEcaixG4dtoq62npiglpLeT0pCoIK2iDmBOYL2JB9fF5XGQfUAlh?=
 =?us-ascii?Q?Xyhvbl+y91i2mb2UD4Dv/8w6DLkLV6kdi1Ngq7OBB6dsxG5N3q41q9Nc37da?=
 =?us-ascii?Q?TefGqjQ8s+dn0ASPpet/wLHAhPGhzZHlGQ5mPmKNFWF4L96yU1/4xsPE5rU6?=
 =?us-ascii?Q?O8+LTT7+1Mub/47MJ00ch3KU/Tia2QK1IBLsEreBKxd+5xdnCUvZdI6y/Ui0?=
 =?us-ascii?Q?xrgMxhPxUcjvDXd0mva/jlL/aidbpeEfGBZLewlNska7M69GihiVS04cAbyl?=
 =?us-ascii?Q?L58kFQCCbHF08g+w8lKhzlAztpAtDh4OTGphmfHvLGnY9ReNcZ0R7oVgzvlX?=
 =?us-ascii?Q?xoB4a8xMnnzhW6saZHpfjmWk5BKOqCniONDNbVJc0KQCcjiWDX9+jWhPJvxw?=
 =?us-ascii?Q?X7QeL1bi4z9gtfFWR+FPxBvcrytE+wZDnAZmt/54BhJMy2IezWU1xl1Rnj8H?=
 =?us-ascii?Q?2XqtdXE6VUBPomghMD+cwK95D2MI0SpCamEBJP/mbnS5uB1IvVLUkCNLTVxl?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HurKueISPYM0AF8FiJB6dyp2lpoxkhDYZfs0rN2DYkkEQwABBsq/d2WuZl+WihcuqJ5L2zkrfjuSCs8Tj9K/oikSgypnCvBHAqOhqTY3gok0/HYNjfhJRWlOcynoPazrgOT7yQOOIZ/mKszgSMoaB5FMK33YovWMY0FaM0c2pLt+nD5RsAYmzuSzu1qfSU/nUXh9sgE/OGu+8ZVtt1vtYnUYWidwEKBAg85AHK3CSnN062Vact4P+cSvG9jdb6r760rhVlZ3vrpOW8gz4dfx6a0W3tP7U7cM4T/FqfUdGO4J0nBahnRSAByFfm+OSqEBJulJXgSVFueFni8Q6Tmd0GjSlOHnP1c7+QusCLss4zPvDZdjoFE4vA9BXEu8aaCm5EmJlS8YhKRffKRaUHIB6T2AwYQrLhC91aFw8LUhurCsvN7d4uHnxCYZ1JuRl5GlCqTJlo31Mw93wDSViay3uqol/5SwZOFTLKkVgkTsnu9TtcBHMXUG1f7MVtk9bq2OOadiqoOImADWkKnJREiJ6nccYsq57htQXYMm+W/KhuSvmjlYaThQZBT7rOOyIc9hBgXU9zpqxzeRXEi28unTlb716MeTxc1XItF9W84YijA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1bccf9-144c-4f0f-4543-08dd0d5d450c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:20.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/VCXBGjfMX8QR2U5Hzh9w4SQCbPnWpCQjh5DLe2fKpCs5+Sywfm4Q0u4cEeloD/WvI2fiGl8Kj83Tox2E3p99ZJ5RdaEfWrWFSRnNmcjUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411250122
X-Proofpoint-ORIG-GUID: sS7UwvZIaR-RdY23RIDqkFzJcO_X56TI
X-Proofpoint-GUID: sS7UwvZIaR-RdY23RIDqkFzJcO_X56TI

From: William Roche <william.roche@oracle.com>

Hi David,

Here is an new version of our code, but I still need to double check
the mmap behavior in case of a memory error impact on:
- a clean page of an empty file or populated file
- already mapped using MAP_SHARED or MAP_PRIVATE
to see if mmap() can recover the area or not.

But I wanted to provide this version to know if this is the kind of
implementation you were expecting.

And here is a sligthly updated description of the patch set:

 ---
This set of patches fixes several problems with hardware memory errors
impacting hugetlbfs memory backed VMs. When using hugetlbfs large
pages, any large page location being impacted by an HW memory error
results in poisoning the entire page, suddenly making a large chunk of
the VM memory unusable.

The main problem that currently exists in Qemu is the lack of backend
file repair before resetting the VM memory, resulting in the impacted
memory to be silently unusable even after a VM reboot.

In order to fix this issue, we take into account the page size of the
impacted memory block when dealing with the associated poisoned page
location.

Using the page size information we also try to regenerate the memory
calling ram_block_discard_range() on VM reset when running
qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
file is regenerated with a hole punched in this file. A new page is
loaded when the location is first touched.

In case of a discard failure we fall back to unmap/remap the memory
location and reset the memory settings.

We also have to honor the 'prealloc' attribute even after a successful
discard, so we reapply the memory settings in this case too.

This memory setting is performed by a new remap notification mechanism
calling host_memory_backend_ram_remapped() function when a region of
a memory block is remapped.

We also enrich the messages used to report a memory error relayed to
the VM, providing an identification of memory page and its size in
case of a large page impacted.
 ----


v2 -> v3:
. dropped the size parameter from qemu_ram_remap() and determine the page
  size when adding it to the poison list, aligning the offset down to the
  pagesize. Multiple sub-pages poisoned on a large page lead to a single
  poison entry.

. introduction of a helper function for the mmap code

. adding "on lost large page <size>@<ram_addr>" to the error injection
  msg (notation used in qemu_ram_remap() too ).
  So only in the case of a large page, it looks like:
qemu-system-x86_64: Guest MCE Memory Error at QEMU addr 0x7fc1f5dd6000 and GUEST addr 0x19fd6000 on lost large page 200000@19e00000 of type BUS_MCEERR_AR injected

. as we need the page_size value for the above message, I retrieve the
  value in kvm_arch_on_sigbus_vcpu() to pass the appropriate pointer
  to kvm_hwpoison_page_add() that doesn't need to align it anymore.

. added a similar message for the ARM platform (removing the MCE
  keyword)

. I also introduced a "fail hard" in the remap notification:
  host_memory_backend_ram_remapped()


This code is scripts/checkpatch.pl clean
'make check' runs fine on both x86 and Arm.


David Hildenbrand (3):
  numa: Introduce and use ram_block_notify_remap()
  hostmem: Factor out applying settings
  hostmem: Handle remapping of RAM

William Roche (4):
  hwpoison_page_list and qemu_ram_remap are based of pages
  system/physmem: poisoned memory discard on reboot
  accel/kvm: Report the loss of a large memory page
  system/physmem: Memory settings applied on remap notification

 accel/kvm/kvm-all.c       |   2 +-
 backends/hostmem.c        | 189 +++++++++++++++++++++++---------------
 hw/core/numa.c            |  11 +++
 include/exec/cpu-common.h |   3 +-
 include/exec/ramlist.h    |   3 +
 include/sysemu/hostmem.h  |   1 +
 system/physmem.c          |  90 +++++++++++++-----
 target/arm/kvm.c          |  13 +++
 target/i386/kvm/kvm.c     |  18 +++-
 9 files changed, 227 insertions(+), 103 deletions(-)

-- 
2.43.5


