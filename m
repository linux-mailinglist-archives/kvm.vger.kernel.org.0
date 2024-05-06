Return-Path: <kvm+bounces-16767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 006788BD6DE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 23:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D9001F215FC
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 21:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0B315B990;
	Mon,  6 May 2024 21:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mIp5BI2f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FG5EsZzu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16E15B969;
	Mon,  6 May 2024 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715030929; cv=fail; b=VuAyeq/uwWaOx0oJhlpZhEjCc8vY9UKf2q0bd8iJSbPaWwplJw86NIyBVHimqZ0colprJxw/eM6LrzKb8RVd0NukL1U0cCg10vKYpLjL6XQ93xg+FNwD47aFfO5EGFlnJNEaojYxPMvb+a2P0b0MEbfKMI0iedRteCwf5Vu6TY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715030929; c=relaxed/simple;
	bh=l9PS2Y3V43tUJRN5Z6BjHJenAIV2/9D5/Koz//McnrU=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=C7sdzHunw86IQSw/sNYyvFAZ1IdUCa4yMQ4MSlOo3RY4A2iO+sUM0Hslyp2FVFZobEnfSTWwjyQciF0KeLYyjMPa+OlQxkxnh5S0HO8rBuW/6c1XmHQ09RCLIKhS9St+WHoCsCk+ri6WoH5BhcUu2Y0FZJXeDP8Q57Mfx79isCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mIp5BI2f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FG5EsZzu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446IArIT018894;
	Mon, 6 May 2024 21:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2023-11-20;
 bh=m0ZbFGthWOXnUsR/90EWxDlWf63I/6xKq+J0xV2mNxw=;
 b=mIp5BI2fkZXpFb4Bm7eof0YiSveURwuSpVWMEt9kIFpW7q7FcqUYqCMIL2z/XokOXglG
 kEiCj7g+kU3BiSJye/h26t1PxJexB2hewVtViJJyEyhsBQHpssfs4sS0oVKl+4uy5qRQ
 eZXWfNnawAr7L7yerBJZju15rd8SNGwzRFLE/n1S+hFVCCItx/xeSYCrX89b8o/8ajPg
 KWK5tFkue/zo6u+mZSyksapMugZ8peS/E1AoK48YfiaRASPn/nQQqVQfCB58R+ZlhfjF
 b4GQrn6WhjYH30r6C6CahLYwhpsjHxUIgJLR7KPOU6Kz2mz2PrpxZ/7dTnG9WSTFmtHt eA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcmvbkm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 21:28:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446L9b1A014099;
	Mon, 6 May 2024 21:28:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6jp11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 21:28:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+t65Rm9y+v0SQZRw+ckqr/OoAd4sr64BwbZUOy4rRLzaBoD/s8GYl9nXPtW9MeF1Is0M0vn7DWlNidW/dg2eItB5YhbqNCalXQrBIKu43+KVdJ24dFfBwZMFAQmj4+BfTshj8o/5/3ux01gJ/bAOOIObW10qae0+yKGPbRbRN9lDJ4VTYWYTmDGTWhAAQVC0rYg9sw4WPMt7eKhAQ1LrA+/unFr16CARAqyBcCIWxXc51FkwVZ6r8Uc+9gUi8xGLscvroxZHzEWGqSr/MxaXKoRLS+Nc68usmDsVoS6cX1SThIIroZYagsGfmaDoD+ZDscDfh5Uva7TfZcjnc8JYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0ZbFGthWOXnUsR/90EWxDlWf63I/6xKq+J0xV2mNxw=;
 b=Dr3k04Wih/kVjAxIS0ufJmdTDrLS0OdA2pi2f6ECvzaHUzOEDIISu+iuZPk1lwAlaWPprdbzLYsMUERhFVpp/H2k/dkExjLXqV1E6x6G4Y6I9PtT8ZtS8cubPEIywcJUAT8FNcQv6jccSuw/hH/8v/MJiJ5E8QOwUQpId2nEGF28+znt9p474zvAGu3nzYpfaK+x2FIYw4fCOUjzD1BFqBcepPBUWyz1PgAIByPDM6LaPCFJ8IdeM15t9QY6Vuyv0c6NE9sDpHRGRZLC29ZOjCZQ7tSxkZ8sbaBORCswF8wE/okG8zHyfh2qsK/XTSxMHBIFmJf9G/hxLtuhwCOP0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0ZbFGthWOXnUsR/90EWxDlWf63I/6xKq+J0xV2mNxw=;
 b=FG5EsZzu91ZxHUVLpUO79OXsqhusl0t8ikeFozt+GrXq/GJe+U1hwKafWarLhbf2CHaY51JpOL46N6mUnf6QqZGD+s90XXlLoDcaJtBT7I1v6SbAjGjsCpWDcVZ4ZftwAwEP2FJ9eR+Nj9RqUl2C6+G9LyPMlJ//4V7SciGumxg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY8PR10MB7314.namprd10.prod.outlook.com (2603:10b6:930:7b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 21:28:02 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 21:27:55 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-2-ankur.a.arora@oracle.com>
 <7473bd3d-f812-e039-24cf-501502206dc9@gentwo.org>
 <877cgba5xn.fsf@oracle.com>
 <f72de572-bf9c-7b1c-194d-6e2de9d4c9b5@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
        mark.rutland@arm.com, harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 1/9] cpuidle: rename ARCH_HAS_CPU_RELAX to
 ARCH_HAS_OPTIMIZED_POLL
In-reply-to: <f72de572-bf9c-7b1c-194d-6e2de9d4c9b5@gentwo.org>
Date: Mon, 06 May 2024 14:27:54 -0700
Message-ID: <87edae3a1x.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0063.namprd03.prod.outlook.com
 (2603:10b6:303:b6::8) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY8PR10MB7314:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f7ec6a-04e6-44be-ae3c-08dc6e1364e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Oun7pX5v+OHdZAR5Amvqu7oCLeoIHeoWa2EkLLgvnvB8mn6uoEE8Tn+gwB3Q?=
 =?us-ascii?Q?JXhFlW8ybPQbb9nBpVK14WieEJHPIzDMGxj+J0dYO9Dh2LhvVnxKdXxwbPfc?=
 =?us-ascii?Q?UBadMF1ryaebASY4gVBcrk0cO1P+v3h+1wFIyt/oVDt+VVm+eXDI907XIspG?=
 =?us-ascii?Q?2kKwxdehFFVT+wKfZAEbQXwnma5UqdVSWxpnNIgcoVZZvrvKGlHgHs6qR/ua?=
 =?us-ascii?Q?4hrKUg51nNlPmPW0U9vWIv9/JQNhE/kf/R+BBB4hGVk2sXuiKB8AB3CFSS3X?=
 =?us-ascii?Q?WFN1Ds5A1pbMCS8mBRZKFJh/4xWz52epYMZdaLQEPVzDg3VHRoiIoDuGXElp?=
 =?us-ascii?Q?wxGoFpBJlcpevBNdMhF8tuRfsAtZFJNpoMO7ck1cg3amWo4m30mPgCCauMVz?=
 =?us-ascii?Q?7dMKstkbl5DLXm5Retrp5Jqazy9uaoggqQqO3npjS8cs7YesCtkcAtVbZn6u?=
 =?us-ascii?Q?s8WDPxtxaAhDP+gpmsM9X58cxi9hIVTsr+aQ/+Wh4Idsr//sJJawpNt9fiJU?=
 =?us-ascii?Q?APYNUxH8CPvPguCLUckiTR/OTb5S4tLIevFIgDQYJFm5KguYYLT+flaZkILX?=
 =?us-ascii?Q?23xdrSKAghNeX6lOHezIvWwj9BN8SPzbwHyF8kaWnY6ti0AQYdmnqnaBk1mE?=
 =?us-ascii?Q?5htWru92ZNfrxAx/HZtvmypBSUv4CgPYHjt/PQf0nhmQLFHQvW2tQos7lR96?=
 =?us-ascii?Q?aqKv3Ar2Dcj52kNbLfKUuPz9GT+87HezOfpQlrGY3F6i+OrVnId0ztW+mPgb?=
 =?us-ascii?Q?Gc+teoNPQA5e1wHhReG0qh7RcyyeaQdRQW0booBA0KFSPGPzRkN0WHPZMjRc?=
 =?us-ascii?Q?cRX9ztDEp7Tx+DkA6WMZacno36fljfitWykacktcwgHdZ5BOYHsnEl6a5Twr?=
 =?us-ascii?Q?oqkv96hOMYv/hDbsfLhpEan9g7hemTIiBlW0Z3XWeEiXl8OMgXiRe8u+A6ux?=
 =?us-ascii?Q?SL4oMs2TurtrWICK4eZWeZW7mQiP9eyjW5mTB6hFoUsVxhhkBXYwZZAqSzjj?=
 =?us-ascii?Q?7/1g0QhaX6829H8Uix/smcxKszNjt/8o7iMvZ9YZf5iwfEgjQlq3tv+1SljY?=
 =?us-ascii?Q?G4IWYsd6t0UMtXBT0qWwDiW/F/tGo6CbRSe+p9pJYwGILLsTI/tWwHQLyaQ9?=
 =?us-ascii?Q?RzanE36s5QbkQ7Hu+KIiYp4HILlhTDXJHsiTh1aSBGOM3FF6nXbZczGIlm0y?=
 =?us-ascii?Q?+XMDRTOgGdzc48mz2A/go1XWMePwJb9x9+GURh1o+mHLdZ9YEPJ3cMT0Gxrm?=
 =?us-ascii?Q?1B6Z/MDn9RY244zlnF9sVL9kYlNu78ys/vBPDWJdfQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pAIrkw8eZKC++t8qPO3DuY2eRdSwQ53Me15ZWtvggGfK7shpKw/OFR982FvQ?=
 =?us-ascii?Q?noPDzjf3IM84c1R19Ah3Jf1yZFgs5abrFN5lOZEbY7wFd6HBo1gRwvEH604V?=
 =?us-ascii?Q?8pikT95eVmgTKFqmxadwEs+zm105rhZquCE8r9bLswYpTlUHhu35IdTS85Jj?=
 =?us-ascii?Q?RJYzlI3Kol+FP+KDLvTcHd1iFzQQISccCTKHk5gkUEMXYaGmFY3U6XrLVV0j?=
 =?us-ascii?Q?1jWRn4H4FPPm/gyuGPd3YoiJeqAIpeIIH0j8XphnSadNoj5QbHkDAoasNVZB?=
 =?us-ascii?Q?33TmwEVP+L9sBJ55qPVIatYPPjgGyZ1CmCzZ8wmst51+gRq5sieIfS3Z7UId?=
 =?us-ascii?Q?JhEwGw6geOamc5xyhpTwG9KAyDTqtFh0V93Gu5kii/QmR1cDsVt+IMe5IxqT?=
 =?us-ascii?Q?ZA3jHUdUC16PJ2+O4NbTLbQBCarKscgOAKlOXu2CLCVKakg91fem6lfY1oUG?=
 =?us-ascii?Q?nCylDYMcD0qvfeY0/M8YGl7whIRD0W8CKfsRFlic9+pR/0wVhIqs3WlCtp00?=
 =?us-ascii?Q?ZFvpud0KWiYC6XPi4ssFHfGUBnv/W0c5p2qiE9nu/D4oYC/11yH4PwAVHwyY?=
 =?us-ascii?Q?3jtO+HowI9M/RkfO9J9GpmjEQkqG/rtGjGJEnU6Y8V5tNsBvbR4j8j9EcqMs?=
 =?us-ascii?Q?hXO2Fh178a/b+j2f44hiYpTI3uuX+CclmlhwiTwMCWpt9paV9860DVz1s2h4?=
 =?us-ascii?Q?cuwngupx3DADgcUpgh7tV/mUHx+mIajIVU8Dfn2pkC9Lo9ancHM/Zdrc50iQ?=
 =?us-ascii?Q?veYgi9mCUG+kNSV8fVWJWC8o4q9+hfJ8sr1eU17NgiSoqXIMxQYemZkVWTZD?=
 =?us-ascii?Q?URYJIiPmAdyo4SoRHYi+RhXnI7694o7VURxrSBv58TXFQ5448Wx8KGbVyAmb?=
 =?us-ascii?Q?Ou6/ECGDVXqJxC4U8iJrA+d+sbVSSvRU8vXI9eWGK4R3mHIShUilb5xOflvt?=
 =?us-ascii?Q?bPiErJ3YDU5/u3sRnDIXTj7y+Io2V9oU3P5nYGyV+dmZYcSX3xeYBd2Qtlur?=
 =?us-ascii?Q?YfpKtZvdaXK0wm9fKQvyW4b52EHl03wvC2s+A9lXIVcye7wV4YGHE9SdtN3g?=
 =?us-ascii?Q?MKx5DTM2uV2KaP1467etzZJzoTb0+TCbMiuNiU0D2meWtF8V08ZjHbruN1Ps?=
 =?us-ascii?Q?/Sv4MWggyxwNLr+wHvK7chjIpmckGPSrcs4vu5Q5+uWzvghLsfnksE1jAPF1?=
 =?us-ascii?Q?0+0/MvrV0bpdnZXL+/CDW9rXJqnmQktzxUU23XfTUIzj/mRC0CHfwREt4Wkc?=
 =?us-ascii?Q?etAlUh0uwBql46+wW6AZtQnF0Z48gEMS0dqnjq7r0SRZz75HNEpomw/1oq9u?=
 =?us-ascii?Q?r//EU1QFkya30pmySsCs2l66HiKUOw89csIYuefwP6aaaIGv9O68VW5dehlY?=
 =?us-ascii?Q?BEpTbUHAMjm1aJroHbCTyEWBzLgHB3rBlOZy2mYOjEapwc1z2WRxT0lYJunI?=
 =?us-ascii?Q?T28wyISMfOePKQ+L/lD1ldsgsDHNsiL6h7K3BiYMWBcUmhLdMTR92GApl5uQ?=
 =?us-ascii?Q?jTu9nVN5f9wb/Qyklv4c7o4n9yhEL4vj48qSm+KmKF+81ata6FsVcFD0z5Uc?=
 =?us-ascii?Q?9TWJDY/DYgSJ7rSfQyog2KBiOBrADHbES67Vn5kpKqAxu73wYz3CDzeE9AOn?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jHixWgxI+42G367T6AG9ZiaXuBoV7aLm1aF9308UoENAIIRuTu1GbEDfMFNf28z/5LBCO8uRfrcsYJwzqxW9osddmcMld+MxHCUcIRulV+QMG93UIBkCItY2hktfE8RtJGl0/zElIaXmw9+VithsPOsQtkeFv97lOwnv04qcXIfUrkBYCY77bt4a0bLc37epdokQgIqCN21kpv9pBULjJuffOe9zroSKe/orrjWg2zezmzPfMq98+8nMAMqrz6Dg19fYVsXGVyevvzx5iswF0jBayN62y12cQtb0TRgWaV2dap7MxtMgzswERHCx+oOU48ZR58mpRZlp1A+RGkMbIIUF5np7WsxFfXkw9QEI82DD+WrKSOqktW4diXn+DOxDwoABA1dSN3Kh1mlSZXrSaeCtKNF63tEQWFycYna+Y4Xg1BF8I0rqcXeO+YysM5aT6Z41xpyTfLIU84E5erI9tB/py9pb4yU/4ZcBrzewfesoaMuJ0R9u3RTAHqL9clIcbSWSFb5UXARcKOSf4hRwQ6m68ONqh14qA3VX6l1QAhyPBHWn3sj9cE2Ztcb/eu/FM+HNxGDOMc0GhCzkVxcvNVZdhkUPQmA0khlWACEr7w0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f7ec6a-04e6-44be-ae3c-08dc6e1364e7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 21:27:55.8105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cIx0UmI8/mbVX0Pd+8kTXriDVkohwQmeb6kQK6XJnq0Fu+cTqTWsS0LUU4w2VF+t9WQNbqb8ef7W0c7JiJ21o2UI/59Ia3RblAebFXsH/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7314
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_15,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060155
X-Proofpoint-GUID: vNbiwRkz2cZU9GTn9Q9W9If_eZdA-wLe
X-Proofpoint-ORIG-GUID: vNbiwRkz2cZU9GTn9Q9W9If_eZdA-wLe


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> On Thu, 2 May 2024, Ankur Arora wrote:
>
>>> The intend was to make the processor aware that we are in a spin loop. Various
>>> processors have different actions that they take upon encountering such a cpu
>>> relax operation.
>>
>> Sure, though most processors don't have a nice mechanism to do that.
>> x86 clearly has the REP; NOP thing. arm64 only has a YIELD which from my
>> measurements is basically a NOP when executed on a system without
>> hardware threads.
>>
>> And that's why only x86 defines ARCH_HAS_CPU_RELAX.
>
> My impression is that the use of arm YIELD has led cpu architects to implement
> similar mechanisms to x86s PAUSE, This is not part of the spec but it has been
> there for a long time. So I would rather leave it as is.
>
>
>>> These are not the same and I think we need both config options.
>>
>> My main concern is that poll_idle() conflates polling in idle with
>> ARCH_HAS_CPU_RELAX, when they aren't really related.
>>
>> So, poll_idle(), and its users should depend on ARCH_HAS_OPTIMIZED_POLL
>> which, if defined by some architecture, means that poll_idle() would
>> be better than a spin-wait loop.
>>
>> Beyond that I'm okay to keep ARCH_HAS_CPU_RELAX around.
>>
>> That said, do you see a use for ARCH_HAS_CPU_RELAX? The only current
>> user is the poll-idle path.
>
> I would think that we need a generic cpu_poll() mechanism that can fall back to
> cpu_relax() on processors that do not offer such thing (x86?) and if not even
> that is there fall back.
>
> We already have something like that in the smp_cond_acquire mechanism (a bit
> weird to put that in the barrier.h>).
>
> So what if we had
>
> void cpu_wait(unsigned flags, unsigned long timeout, void *cacheline);
>
> With
>
> #define CPU_POLL_INTERRUPT (1 << 0)
> #define CPU_POLL_EVENT (1 <<  1)
> #define CPU_POLL_CACHELINE (1 << 2)
> #define CPU_POLL_TIMEOUT (1 << 3)
> #define CPU_POLL_BROADCAST_EVENT (1 << 4)
> #define CPU_POLL_LOCAL_EVENT (1 << 5)
>
>
> The cpu_poll() function coud be generically defined in asm-generic and then
> arches could provide their own implementation optimizing the hardware polling
> mechanisms.
>
> Any number of flags could be specified simultaneously. On ARM this would map
> then to SEVL SEV and WFI/WFE WFIT/WFET
>
> So f.e.
>
> cpu_wait(CPU_POLL_INTERUPT|CPU_POLL_EVENT|CPU_POLL_TIMEOUT|CPU_POLL_CACHELINE,
> timeout, &mylock);
>
> to wait on a change in a cacheline with a timeout.
>
> In additional we could then think about making effective use of the signaling
> mechanism provided by SEV in core logic of the kernel. Maybe that is more
> effective then waiting for a cacheline in some situations.
>
>
>> With WFE, sure there's a problem in that you depend on an interrupt or
>> the event-stream to get out of the wait. And, so sometimes you would
>> overshoot the target poll timeout.
>
> Right. The dependence on the event stream makes this approach a bit strange.
> Having some sort of generic cpu_wait() feature with timeout spec could avoid
> that.

Thanks for the detailed comments. Helped me think through some of the details.

So, there are three issues that you bring up. Let me address each in turn.

1) A generic cpu_poll() mechanism that can fall back to cpu_relax().

> I would think that we need a generic cpu_poll() mechanism that can fall back to
> cpu_relax() on processors that do not offer such thing (x86?) and if not even
> that is there fall back.
>
> We already have something like that in the smp_cond_acquire mechanism (a bit
> weird to put that in the barrier.h>).

Isn't that exactly what this series does?

If you see patch-6, that gets rid of direct use of cpu_relax(), instead
using smp_cond_load_relaxed().

And smp_cond_load_relaxed(), in its generic variant (used everywhere but
arm64) uses cpu_relax() implicitly. Any architecture that override
this -- as arm64 does -- get their own optimizations.

(Maybe this patch would be clearer if it was sequenced after patch-6?)

2) That brings me back to your second point, about having a different
interface which allows for different optimizations.

> void cpu_wait(unsigned flags, unsigned long timeout, void *cacheline);
>
> With
>
> #define CPU_POLL_INTERRUPT (1 << 0)
> #define CPU_POLL_EVENT (1 <<  1)
> #define CPU_POLL_CACHELINE (1 << 2)
> #define CPU_POLL_TIMEOUT (1 << 3)
> #define CPU_POLL_BROADCAST_EVENT (1 << 4)
> #define CPU_POLL_LOCAL_EVENT (1 << 5)

I agree with you that the polling logic does need to handle timeouts
but I don't think that we need a special interface.

Given that we are only concerned about poll_idle() here and that needs
to work with the scheduler's set_nr_if_polling() machinery to elide IPIs,
the polling on a cacheline is needed anyway. That also means we poll_idle()
doesn't need to handle interrupts.

For the rest, the architecture could internally choose whichever
variation they perform best at -- so long as they can either spin-wait
or have some kind of event driven mechanism (WFE/WFET, MONITOR/MWAIT[X])


The timeout is something that I plan to address separately. I think we can
straight-forwardly extend to smp_cond_load_timeout() to do that at least
for WFET supporting platforms where others depend on the event-stream.

  #define smp_cond_load_relaxed_timeout(ptr, cond_expr, time_check_expr, \
                                  time_limit, timeout) ({   \
          typeof(ptr) __PTR = (ptr);                              \
          __unqual_scalar_typeof(*ptr) VAL;                       \
          unsigned int __count = 0;                               \
          for (;;) {                                              \
                  VAL = READ_ONCE(*__PTR);                        \
                  if (cond_expr)                                  \
                          break;                                  \
                  cpu_relax();                                    \
                  if (__count++ < smp_cond_time_check_count)      \
                          continue;                               \
                                                                  \
                  if ((time_check_expr) > time_limit)             \
                          goto timeout;                           \
                                                                  \
                  __count = 0;                                    \
          }                                                       \
          (typeof(*ptr))VAL;                                      \
  })

arm64, for instance, can use alternatives to implement whichever variant
the processor supports (untested, also needs massaging).

  static inline void __cmpwait_case_##sz(volatile void *ptr,              \
                                  unsigned long val,                      \
                                  unsigned long etime)                    \
                                                                          \


          unsigned long tmp;                                              \
                                                                          \
          const unsigned long ecycles = xloops_to_cycles(nsecs_to_xloops(etime)); \
          asm volatile(                                                   \
          "       sevl\ n"                                                \
          "       wfe\ n"                                                 \
          "       ldxr" #sfx "\ t%" #w "[tmp], %[v]\n"                    \
          "       eor     %" #w "[tmp], %" #w "[tmp], %" #w "[val]\ n"    \
          "       cbnz    %" #w "[tmp], 1f\ n"                            \
          ALTERNATIVE("wfe\ n",                                           \
                  "msr s0_3_c1_c0_0, %[ecycles]\ n",                      \
                  ARM64_HAS_WFXT)                                         \
          "1:"                                                            \
          : [tmp] "=&r" (tmp), [v] "+Q" (*(u##sz *)ptr)                   \
          : [val] "r" (val), [ecycles] "r" (ecycles));                    \
  }

And, then poll_idle() only need be:

  static int __cpuidle poll_idle(struct cpuidle_device *dev,
                               struct cpuidle_driver *drv, int index)
  {
        u64 time_start;

        time_start = local_clock_noinstr();

        dev->poll_time_limit = false;

        raw_local_irq_enable();
        if (!current_set_polling_and_test()) {
                u64 time_limit;

                time_limit = cpuidle_poll_time(drv, dev);

                smp_cond_load_relaxed_timeout(&current_thread_info()->flags,
                                              VAL & _TIF_NEED_RESCHED,
                                              local_clock_noinstr(),
                                              time_start + time_limit,
                                              timed_out);
        }
        ...

On x86, this generates code pretty similar to the current version and
on arm64 similar to the WFE version.

3) Dependence on the event-stream for the WFE variants

> Right. The dependence on the event stream makes this approach a bit strange.
> Having some sort of generic cpu_wait() feature with timeout spec could avoid
> that.

Not sure I agree with that. Seems to me, the event-stream is present for
exactly that -- so we don't wait in a WFE or WFI forever. The spec
say (section D12.2.3)

  "An implementation that includes the Generic Timer can use the system
  counter to generate one or more event streams, to generate periodic
  wakeup events as part of the mechanism described in Wait for Event.

  An event stream might be used:
   - To impose a time-out on a Wait For Event polling loop."

The overshoot is a problem, but I don't think it is a huge one. Most
of the time that haltpoll is in effect, it should wake up with work
to do in the guest_halt_poll_ns duration. The times, it doesn't it
would exit poll_idle() and exit to the hypervisor.

So, this is only an issue in the last iteration.

And, I'm not sure how a generic cpu_wait() would work? Either the
generic cpu_wait() spins in cpu_relax()/YIELD which is suboptimal
on arm64 or it uses WFE but sets a timer for 50us or whatever. Seems
like unnecessary overhead when the overshoot is relatively uncommon.

Or is there another mechanism you are thinking of for enforcing a
timeout?

Thanks

--
ankur

