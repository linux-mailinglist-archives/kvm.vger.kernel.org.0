Return-Path: <kvm+bounces-8043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5259D84A700
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:20:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA6B9B26852
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 21:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458015D8E2;
	Mon,  5 Feb 2024 19:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UEXeiM8v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UdPnZyLt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6009E5D75A;
	Mon,  5 Feb 2024 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707161646; cv=fail; b=cUWht9K2W0LVLSVw4oDpORfuMBj/Soh0BDL4L2RIoxvIpJpr2SN1qjhUmBt5QD1wX907I46ONOZgfIYlNGrPYlcQO37NL841exwWJrX/X4fRTczametr2LZHIuYgHs1zJe8issd1XyE/cSfYhtDJe/Zw9ZmigaBWRglZt90DfN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707161646; c=relaxed/simple;
	bh=+S6MY1j3WdTBTyHJ7I3fxBeDoT2oqL3LDd6ZIAnDjCw=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=bIAliXqDeh6tIty6HY8EhsiVdDIJDoXp/o1ZaQ104WkstGfmu7CamebHbDOdXSSxDUanNR0tXhWbBpqeF9UR/VwhAPxA90MqTTOYqChR+UHB1/il0wzDZtjnwZdsDlh426BGQyG+AtruZblrHHgDEcFOPRxrDiYZDT6czsvrvzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UEXeiM8v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UdPnZyLt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415J41xj019251;
	Mon, 5 Feb 2024 19:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2023-11-20;
 bh=U5aqUBUpelIeMjha9AyN6uIel7EPdOhfDHReH6xNHkY=;
 b=UEXeiM8va0XC2zIjl5JppJk4x2/e8ABOLgpD46ei2ZYzuObY0QmOW9R8Zcu10q7Nms5X
 2vLWBAJvfj1lJ8nkroght8fGdRxYLxoxoudeMiJpoUzk39HmJJ/1WUqfU4y5dq5vQGyT
 70vWK3ZNwPPEGh2dJ4CMH49HBddXP6bREK6XktQW24aVgyBFmcSuDBT44u29p5MWHo8i
 aDoZTgFg9371zdn1zZHEbktvxgGA7GQj05l2tb5NoHxD2yZ5+KQ+r4PiZBnQy7f2Tp9u
 oBVqMs/h9S1tu3RzpPrzqpLtYY2RLo/WrFjUi9UkN3tJ1iMZfo1DvPptxnXhZPjPpi0K hA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwemv68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Feb 2024 19:33:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415JQJhL007040;
	Mon, 5 Feb 2024 19:33:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6cjs3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Feb 2024 19:33:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bl2uasSH3UtEFMo21TVVLkU8RleewhbScxkIafselUGeUNJCO7qkuJziR0E9T8DMPvta7rRlWBnKKees5+nmjlslLYy4Rdx9qmwCUYNpo3jrdMLxFg9evZmuKOUg1ej8cBhNNxn/IFE5Y61w/m9kH0rU4oVwrXqzqV+8YWo86XCWLgPK+sxTtwGpQI92y0FqdRTNuP6PDslzOhgLw3PBZrZ10alwdS0im/WChh+aWyPOyuftMEY63gDuNwm39bW8Nr6BkTwfHejOl6LW1fMAXxsaTivzRcpXxDgJkBZg4KkJLNkCBGjVOJWyajMEAkhTniNLgzY+iFrQzRoqZeBAPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5aqUBUpelIeMjha9AyN6uIel7EPdOhfDHReH6xNHkY=;
 b=Mh+V+EomOvtE0LPaLjtk5DEWwhEBM3bEmNUJKIAcgnGzdKoCHT0HZi8nKvpeOWpe7LwLcZxYAXtoHLcln7aNBz3xAB4fn3oRKB+BppGIVjLgUgWtboaqVyYOfY5GKi42Oiu6SaMttuymulZdd835hpwbORLr2wTATCPTPf5PJ56RyN0x0UNHxYG3FMILKd7GQ9QgktvrwdUoGrV6OtLXn3b61f99kOEvtULAtb6IjMcwZSeTTTbgJsbjUybnZCuvLX0ANTnignnWUXTCSuiRAtYQuvqWWbjF6tQK68LmMC4XFVQXgabsPA9q9SgL+GBbJKqB5OLM8YrRW20/GSeuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5aqUBUpelIeMjha9AyN6uIel7EPdOhfDHReH6xNHkY=;
 b=UdPnZyLtnE/evIdau59sBSzHmDkbR9WxwW+0XTCY/+OoqJwQ35QMyBsyfM2QnxCyjP4zB8IlreA1cdrkHYGGUpPHc49Gcv9pP0B2HegzEZ9qRR7a2wepINNHwTMBwJxP99MJ0/iDsgjIlwgloaM8lRTgQmX1kHTzQnBam/H0iD8=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY8PR10MB6852.namprd10.prod.outlook.com (2603:10b6:930:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Mon, 5 Feb
 2024 19:33:12 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::91b3:fd53:a6ee:8685]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::91b3:fd53:a6ee:8685%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 19:33:12 +0000
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
 <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
 <20231211114642.GB24899@willie-the-truck>
 <1b3650c5-822e-4789-81d2-0304573cabd9@oracle.com>
 <20240129181547.GA12305@willie-the-truck>
 <1b25b492-b9e7-4411-90d1-463d44084043@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, pmladek@suse.com, peterz@infradead.org,
        dianders@chromium.org, npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, arnd@arndb.de, ankur.a.arora@oracle.com
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
In-reply-to: <1b25b492-b9e7-4411-90d1-463d44084043@oracle.com>
Date: Mon, 05 Feb 2024 11:33:23 -0800
Message-ID: <87ttmmu2nw.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0096.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY8PR10MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 0251e63c-771d-4854-bf50-08dc26814a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4aHx+RVdaYqEdyqAQV9tnT/j52KbmhSxjG9qGAWfjd36Kwon5EAIigLiEC1fzgwH8eoxsZZdGh4Cfc/HI/z7ihMIWeDCxVth2aYMWqNlaCKDsOibeKq4tvPNcVOIHMghYp/Lw5wAThLOkyQV2Ke2otfCYABmhfyzUOeLaXnruTwU4DPVVDXIQa9MBuSAj22+qpd20iqK+UJhek52JNQPJvgjEZQ19uY859E2JuUcGO9CUApDH9mQNTdDMK2C/8qYdTU2R4o7S31u9ugPpIPgHgDfWBIxkJ+vddgn0i8/FBB35qKjuPbQBG8BuCEumTRrYaBwXR/OJ6koNLsK6o5CYLS9EsECt1BM1W1zvO2M55/YQEZiI0IOUUp3RAv4SOkJNCacrMmpkWb/6sRb/3kfKW37IcIx/epQrK2OOD+nk2dCkzN7Pl+mMhsTsvOziHCd48Hsy5BmC4BoZj+u/norOzRsrlg9cACfQIctkHvjM5CqQXiFM/03l7hATaUczWZ3s8kbOkZnCAIoycsQ2NdSLVe8iZdq3cKz1D7LuT98bBUphxBcohLqa5P+xjEajEf4
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(136003)(366004)(39860400002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(41300700001)(66556008)(66476007)(66946007)(36756003)(37006003)(6636002)(316002)(7416002)(5660300002)(2906002)(6862004)(4326008)(8676002)(8936002)(83380400001)(38100700002)(6666004)(6506007)(6512007)(478600001)(6486002)(26005)(2616005)(107886003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?h82tS+rvyE5MwJ0SVKoUuuRIgtpLVCGVVoPTfrfFvpjyWdmNdstoosYloYH7?=
 =?us-ascii?Q?4G4Ps28c5aoCIYsfQYBTKvi6fk4V1QhOYT8EzuErdPlulkcLeGMChRFyRyX+?=
 =?us-ascii?Q?mzGl+TXiSS+ZNoXR4D/wJ5pICGVH12duNf+7o3U5jJ5GOUQmjGFqoFhu7vlY?=
 =?us-ascii?Q?/6YobxRO4oCfq1NHvF+EabsQNj6GIgzGFkYR0LSxzRppO5JdOnA7fUwsBAe9?=
 =?us-ascii?Q?91phnn2cJ4oyY+iC5pKGYKWviyxv27+ehYbXig/WU8lxjJZQq1Kl/hMMz1Ch?=
 =?us-ascii?Q?vmdAkzo4u9RdXycAh0ZtDx5oylefF1fOpiRoH/sNbF1NtqaVmohrut0hbxG7?=
 =?us-ascii?Q?53enZXytiz9+otZ8cOd6yt9mEPqakral9r2JtS9ZfFiS/I2B7hDz1bzOY0eu?=
 =?us-ascii?Q?LOyWVB58wJyseuqu2lTJhExRGbSJiPVvf9bsVC+CML3tIS4yG/6GbboLblP9?=
 =?us-ascii?Q?itHd6iC+pe+me+DiEJlMv86PvHpYi0bMroRhdVAQKLA4kjEI2FY7/VH5kTNP?=
 =?us-ascii?Q?o2jao+LxRMcevoJfI8DlB4j5/1ifxhAoQ8jGae3j8l8fmd+W8xHV/U/px8PR?=
 =?us-ascii?Q?rk4R+p09aDJsMV6A6z17yasv3ljVqKxSbfD/kR+oS0I4sLw+LOgVS7WH2jHd?=
 =?us-ascii?Q?iZ+tFYW/pm430z+X9D2xAP+VUYNxkkGBAyb4oY3tsIvRswhSiAQZz6Htp7W4?=
 =?us-ascii?Q?DcFyCMTQDlYN9dLwPAxzJw69mZV+BWVwZ5DH0MfVK1bMiXoA/WcIrlPLdz1D?=
 =?us-ascii?Q?wTCP1uHx+OjQx8/k8gIOa8NsoNqJgOEb4S2zLASl59RR5DM2tlM4E2MBWAHV?=
 =?us-ascii?Q?yna6sxHXtqPlXdkqe00urHJieMxV+5YhGQQQg592VL3FMetfqMTlg1hh/MdI?=
 =?us-ascii?Q?m3FLMk9XBLkYWEaYZdG4nXf9bIy49J6/0XArumUkModdxIXSDVufJQnVNhkZ?=
 =?us-ascii?Q?PJKf8NeMAeUytjJ1rsrdAvN+J4t/aLDmgm4M4NfHEn1opV+Y8fNYBZtqzp/5?=
 =?us-ascii?Q?yUOoNUEFJuopHaxPFf2aibap96IECqXr4Lk3uIoi9r8wH3QYKBIfy+7ACMFH?=
 =?us-ascii?Q?8jeCKvrhkUcn0jJnSlShNf9ZXjb4K+G0Fxr3R7K5WN6dfslBJiSiy2ObqWhJ?=
 =?us-ascii?Q?0GRByQGGBvgcKb1y4PDgHcLSUk4hkEOyv0VzspIa3ZvelTy3/pJuYyWCf+IA?=
 =?us-ascii?Q?vmJJDedhdjKI41At0lFN4NNpikDqgoHX4Wq+r5stIat+Stz308BjopXR41yl?=
 =?us-ascii?Q?bO0qn+KQ2+Sz+N4LK7MMbTTORTnLjDTRfoN6QA5XPQIrZBOoCWOpmiBEU4cV?=
 =?us-ascii?Q?706cFZjyM0mRgpQAPvhU0DeYb1fjs4NtFXl2/8LRPgAclfy4VOrAf5wUsFh6?=
 =?us-ascii?Q?dXikXGcsdbvdiaMBaRGxgjDsiswHirT61vhVIoRNYYoqDpY24JQ0rTsVcyhy?=
 =?us-ascii?Q?LCqH482IPA85BHes+nA4sJpA25cqoJeC4csrMcSgWJiInZbMITkh3qQR4ppp?=
 =?us-ascii?Q?+moL9+KXqpBXDfcZCrzNG7vk5obnzyAr460uIuEYSI1ScjRy0CMgi2CcuEYR?=
 =?us-ascii?Q?cV3ayC/OmzEplf+8RvGMoUl25L7r9b0gPM9jDTVg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZjYhGo1LBqYeQhbbkwIfTpu3Kot298LdXS0YCN96JBzElh6Fj9GohYF/q+jTqr+PMjODnqZfD1NEvhdBbijxPAMUXVWp4NG5bdKwds7CLGf5BzHvu/uBBBGuNsNkocZbfOh/pWvebPn5DgloHAULmsLD+FKA+6KlaKY1QeVCu5ZUswD/Cyb8KMuz5JvNngDUnKPocj1o1ghyJuIRDn9LrrKUQ1iLBBjmlyBqDLeoXDVeU5CUvWN7aJPKbpFh9HVduUKyPiUvjOc2+pnF6Byctxk4M3qeUObYVpKPtnn9ewHI7SXOv1ixnqyyzWN2gqJwvc4HkB++DrjyBk1dxJESaZWlRqOU4sNZPl/2YSNHKG142RweCioC87XwK+WXqzikhDrU8D/MiditkfzOi0Za6RZcwH21rCraP/mM/Wy189utWCn82QHtkCv7hav3ionG4FWbT6F4+YOiL4OLpZtRK4eVKATA9F/OOAxIdR5aCjUYqLN+Kb7yZTaGJcLmn2kwRvBPCNKfPoxGljA6fOQwkwvGjZyIHCPpTPfMbNMKjzFneSKtH21dMKOMTE9IJn3kUQXfqtZsm4TfX9c45KuBIQwtrEwKQ0QmYMJGGseCvuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0251e63c-771d-4854-bf50-08dc26814a5c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 19:33:12.2581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJlDIXnGa/dwZJGF8tR24Rv867GcYvLEcBuv05T/1/op0TieuOfc726EIn6F+vwJHMyjuOF9hQEYDZNzeYD94jI3E5ID/YrH/SW2ecEk87g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_13,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050145
X-Proofpoint-ORIG-GUID: aH0LwGCI1vwOTtGkBwAT7rwWBpk_wEtO
X-Proofpoint-GUID: aH0LwGCI1vwOTtGkBwAT7rwWBpk_wEtO


Mihai Carabas <mihai.carabas@oracle.com> writes:

>>>>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>>>>> smp_cond_load_relaxed which basically does a "wfe".
>>>>>
>>>>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>>>>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>>>>> ---
>>>>>    drivers/cpuidle/poll_state.c | 14 +++++++++-----
>>>>>    1 file changed, 9 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>>>>> index 9b6d90a72601..440cd713e39a 100644
>>>>> --- a/drivers/cpuidle/poll_state.c
>>>>> +++ b/drivers/cpuidle/poll_state.c
>>>>> @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>>>>    		limit = cpuidle_poll_time(drv, dev);
>>>>> -		while (!need_resched()) {
>>>>> -			cpu_relax();
>>>>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>>>>> -				continue;
>>>>> -
>>>>> +		for (;;) {
>>>>>    			loop_count = 0;
>>>>> +
>>>>> +			smp_cond_load_relaxed(&current_thread_info()->flags,
>>>>> +					      (VAL & _TIF_NEED_RESCHED) ||
>>>>> +					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
>>>>> +
>>>>> +			if (loop_count < POLL_IDLE_RELAX_COUNT)
>>>>> +				break;
>>>>> +
>>>>>    			if (local_clock_noinstr() - time_start > limit) {
>>>>>    				dev->poll_time_limit = true;
>>>>>    				break;
>>>> Doesn't this make ARCH_HAS_CPU_RELAX a complete misnomer?
>>> This controls the build of poll_state.c and the generic definition of
>>> smp_cond_load_relaxed (used by x86) is using cpu_relax(). Do you propose
>>> other approach here?
>> Give it a better name? Having ARCH_HAS_CPU_RELAX control a piece of code
>> that doesn't use cpu_relax() doesn't make sense to me.
>
> The generic code for smp_cond_load_relaxed is using cpu_relax and this one is
> used on x86 - so ARCH_HAS_CPU_RELAX is a prerequisite on x86 when using
> haltpoll. Only on ARM64 this is overwritten. Moreover ARCH_HAS_CPU_RELAX is
> controlling the function definition for cpuidle_poll_state_init (this is how it
> was originally designed).

I suspect Will's point is that the term ARCH_HAS_CPU_RELAX doesn't make
a whole lot of sense when we are only indirectly using cpu_relax() in
the series.

Also, all archs define cpu_relax() (though some as just a barrier()) so
ARCH_HAS_CPU_RELAX .

Maybe an arch can instead just opt into polling in idle?

Perhaps something like this trivial patch:

--
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5edec175b9bf..d80c98c64fd4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -367,7 +367,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y

-config ARCH_HAS_CPU_RELAX
+config ARCH_WANTS_IDLE_POLL
 	def_bool y

 config ARCH_HIBERNATION_POSSIBLE
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 55437f5e0c3a..6a0a1f16a5c3 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -36,7 +36,7 @@
 #include <asm/cpu.h>
 #endif

-#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX) ? 1 : 0)
+#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_WANTS_IDLE_POLL) ? 1 : 0)

 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0400);
@@ -787,7 +787,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	if (max_cstate == 0)
 		max_cstate = 1;

-	if (IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX)) {
+	if (IS_ENABLED(CONFIG_ARCH_WANTS_IDLE_POLL)) {
 		cpuidle_poll_state_init(drv);
 		count = 1;
 	} else {
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc..23f48d99f0f2 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,7 +7,7 @@ obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_DT_IDLE_GENPD)		  += dt_idle_genpd.o
-obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_ARCH_WANTS_IDLE_POLL)	  += poll_state.o
 obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o

 ##################################################################################
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 3183aeb7f5b4..53e55a91d55d 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -275,7 +275,7 @@ static inline void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev,
 }
 #endif

-#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_CPU_RELAX)
+#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_WANTS_IDLE_POLL)
 void cpuidle_poll_state_init(struct cpuidle_driver *drv);
 #else
 static inline void cpuidle_poll_state_init(struct cpuidle_driver *drv) {}

