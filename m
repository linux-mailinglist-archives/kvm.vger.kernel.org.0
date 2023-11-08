Return-Path: <kvm+bounces-1126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4647E4EB3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91F5E2815CF
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E317EED2;
	Wed,  8 Nov 2023 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EVxflofF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bsa0iVJx"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B47EBC
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:43:47 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25E2129;
	Tue,  7 Nov 2023 17:43:46 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LJnaG004895;
	Wed, 8 Nov 2023 01:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ZdrFldNX4Ozf1Wii0ShlofWCjmSE3T7JmGoslrn3NDU=;
 b=EVxflofFawauKB9IPG1FLj7ExXkLeutIbMbBYSXPDBWMgdkbjUtBe3QdYBmhtJbXSfRy
 CmGn4KhNLaI6G/4YObqzztKGx8fs14NLTY7pQtUd6sqWNKVX2ZT7DpIH4Vo3SVsbTFLz
 nbux1Zv5xV3wI/tfOkdOe/NYX5Z91luErIo3MMQWG/HZzPwXmAjHa6Ml0ezDlxNHVUkp
 StiJJRfzukvOz0RJt9spaLxGXcYKAmkVkmaW6PCPD13M2o8bwsobB7bWNk8vv+0b/qeR
 9rfkrlcFSUa2OHDD0u8U345r3nuWcfovOb+lx/2DNbYg41GrIY5AWVN+LKSCir+/hhnC AA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w22gbwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Nov 2023 01:43:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A81Dffg011114;
	Wed, 8 Nov 2023 01:43:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1u0t7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Nov 2023 01:43:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfZgPehcHMWyaO0uWsz2L3yBG2Cpzcs9n/FY+ZaASqCNcMCHpG7oJ+NEZnEkiDDt0xClQcYKCnP44vmlz4ZH0u9Na9al6Ey+gEzHZvcOGBsIYoasFdvPpY3f+PxiZbJf6cMHtSmw7uOzyR7MHwsz41fMdH0DgiFtNQiaGMKw/UNvEH0HsDjJzNmqSLI3gonqRADxUqglxz+MjBGHdaBdQLNcG4nGoo873lDgVW/Sato42++/Y0W6oybQ2EqNvJBPLnooUz/i0eyIv2ymW7R+9ZExJY9a19f3UGuxrPCyLYsCxJJuQ9GtKEUg71X5A7mMVJp1YVPyySnyCMtv1RXkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdrFldNX4Ozf1Wii0ShlofWCjmSE3T7JmGoslrn3NDU=;
 b=UD9CdCkFyf70UcE8VfzmA87WY5biL9PM35KnwQO42sOH5q8yVJ7nrr9p1vZYClcY9QRghC+rhFlLGwQXKByfMuVBfOK+Rdurvii8Qgc+HGVq8n5eQdchjrRf/8i1O8gD+vUAj2avti73dmumIJnduedwWNgM9avzU52qe+1O1Ls0uWgWB8n7AYew/oM2w9mhBbl35IuR3+wZB1E6Dh5T++2QyDOHXwS0KWa8S+lPSzjuVDIT5LLtbLprN8j0rp4owOmlK3gG8eS12pUZ3S5FG23VJObpNe6VXZRCJr394Sc7gBrABHRTAiy6U+UsSWe689GK2dNzcNNxi76FWUl3AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdrFldNX4Ozf1Wii0ShlofWCjmSE3T7JmGoslrn3NDU=;
 b=bsa0iVJxeGljFdnMfN8LLfjk/Kw1MtgnDkr2wzrqCRnT5JZTGuwj35KzkS+BNPl4kze5zBHDta2ymyte+fOScefc70KNo1HVYABYJYs3bexXC590dWigBo42+AYa8PISjETdIPGmz13oLh6m/5/9N36ToXKA+bmH1qa8QD6EQLg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 01:43:21 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 01:43:21 +0000
Message-ID: <33907a83-4e1a-f121-74f3-bde1e68b047c@oracle.com>
Date: Tue, 7 Nov 2023 17:43:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: x86/xen: improve accuracy of Xen timers
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
 <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
 <2bd5d543-08a0-a0f6-0f59-b8724a2d8d75@oracle.com>
 <12e8ade22fe6c1e6bec74e60e8213302a7da635e.camel@infradead.org>
 <19f8de0a-17f7-1a25-f2e9-adbf00ecb035@oracle.com>
 <37225cb2ab45c842275c2b5b5d84d1bb514a8640.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <37225cb2ab45c842275c2b5b5d84d1bb514a8640.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:256::14) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 96663d42-6d21-4382-54f9-08dbdffc16d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rFLVKHiQP4F0hms2sdDKWDdRvDigrqxZreZ9yB2CvND8K85FWc+ixvFKPxK3usAyjsLTzFY1ekGafU03bWGxjOOJ8/3LdqUScS/TjqhfjhwIX9EOdLK0NUqg+jdBFf/1FruAjVjDb29UPgcVQ6g9WxCSduk//YKwpUy0Lrsx7UDXTifctYz+L+MgSgyDPTabK2MC2ohMYrYmox1QjIsqzIvCnusTdruPjsr48Tsx4aqSUgQwWsoaK+F/cdKpYJjLkCs6I9Q9HMtJRc86OQBhTCVcAR/C89BtOgHW8do4jnLo0c7zXiBGVyXA0F3FEK7DlFZqiQeDq6xvZXU6YrzLyvUBYnE0/79iEv5SgbqdkBbY12Zzj+csKld0v4a6FgaPfdvqMaY0zz4JFX30yQpwC2THqgkaGqs/XSUbmBQMqzB53WX4Q/naaqtS7w/L180ZRdKLy/BgaUImhaQ7jADlmZTxb+168E5EHbpF3L80Q7iMjy+PNy90TG0/3KIx8cYZkqXTpoOQOE5UvhNGJCmTKfB2w2fsaEmVPaAERhF9/VI7Ag8Nxh3tn7Ckmx6NmcgL7y0sssx+9Jl0hP7Qqegacl++5/AKPqk8UIF2MGRzjHh4r38L/51Bxlg9uxwTGsXsL0G0k5buX5rdBOLV5tfPAA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(396003)(39860400002)(376002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(83380400001)(66899024)(316002)(44832011)(4326008)(8676002)(8936002)(5660300002)(7416002)(6486002)(6512007)(53546011)(6506007)(478600001)(38100700002)(41300700001)(6666004)(31696002)(31686004)(86362001)(2906002)(26005)(66476007)(54906003)(66556008)(2616005)(66946007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MVZtcGJNUEppcm5vQTdRQXZIcDJJRUdJdjZVZVFSUFdhVGxwd1FVeURyaDAy?=
 =?utf-8?B?WW8ycEQ4ZnI4d1ptektLVEFzak1IMndkZDd2SmcxNmt2OEpybmt1NUFMTG9M?=
 =?utf-8?B?QllOSFJHMnVZVzQvVkdYaVR3ZzQ4RHg5bzFVRWFoUitoSzV2a2tjaHBBY3Mr?=
 =?utf-8?B?RVBzTTVzVU5yM1U3Y3JVcjNabnM4QVY5WDBoaTh0aG45UUdMb3p2SmNFa3o5?=
 =?utf-8?B?b2pxM2FVL3BUZDNLdHN3bWs1YXJTMUs5TVI2aFVSQnAyazl3ODF3OXErNzB6?=
 =?utf-8?B?US92aXpaNDVwL29NWUJSY1NGcUlPeWdYMzhwVGlHZWJ0WlQ5bHZZVVBoV0lK?=
 =?utf-8?B?S2dxbndmNlZYNnVwdFZLYS9sRjJQSDJqTGttYmF3TjY3cU15dXA4b1RMajJa?=
 =?utf-8?B?V2k3aDZzS044SVhMa0x3TVNXWEFyTktIMWdpYlUwdldOTEc3NVp6Z0VlZm5M?=
 =?utf-8?B?VmRVTXNCcHJaeHVZcjY1UHdwYkdXbS9jYzdqYjVxVUFPTHFCazZ3aVdHMURH?=
 =?utf-8?B?eDVhQ1Z3RDdOdUtmd2JFbHU3Zm9iSmtQcFYxL0R6Ym05ZWVGRG1oeFlyNVhZ?=
 =?utf-8?B?ZlVzaTh4aTJodmVmOC9lMDcrK21GaW5mY0xBTmRBTmhtM1pnRXQ3aXVrVDVH?=
 =?utf-8?B?VlBTMjBaQWZpdlJlODNINkpuQlUyVHEzb0lPSkZ5Z2hNOEQ2V3lmcExVazJY?=
 =?utf-8?B?ZGs3eUFsZzQvd2FwdlF5QWsyWjlYcHhtTTBUd2JNSG52Z0xXZzZnMlFJY0Vo?=
 =?utf-8?B?elh0MzdORG9JNm9QejRmZ0hZOUNTUkxJVnNNTVloNUpxTFRJK0R3UjlGWXNO?=
 =?utf-8?B?WlVERVpobW5hQm52WHhKcUxVV0wrZTRNMHNLZzR1Y01OcE16c1dPbkhSWUg5?=
 =?utf-8?B?Y2FuSExQMmlMRWJnelpqWi9tWEgrRHBwd2U3WFUwMWRaSlVPMXZ0YkxaUDQ3?=
 =?utf-8?B?UU9TZU5aRmFNeENobDcyRWZVZzM4NndDRjVUWUcvWE5OTUFpOUdDZ0pSWnNi?=
 =?utf-8?B?YXNmQlRnSDJzSUpwTHhxUlVrb2JIbktCSE52azFuYWtVYVdzNWl1ZmZVanAv?=
 =?utf-8?B?d2hJS0w5UkRLbGNFeEloSlhKWThKa2oveEdsOW1aY2Z5VXF1NndqZGx1bkN2?=
 =?utf-8?B?b0NKLy9tSUV5LzdObDNPcWlDMXVNdHNPdERqSkxabGNXMFZnVXRzY2FRbmR6?=
 =?utf-8?B?ZnN0L2orTHpodStzV2w3MzFkM2FwZFVTbzdtZHB0MFpjV0hjVEtsakVWSGl1?=
 =?utf-8?B?YkVSTVc4ZGpBZnJzaGtNYTJLVHVYM244ckIyRDR1UjllblFDOElRL3hGMkVE?=
 =?utf-8?B?cFptM3UvS1pZRjlsNHV4L0ZCRmo0cDhwK0NSbXhzbTZTL0EwM05sSXNrcnFL?=
 =?utf-8?B?ZXBZZGcyL21jU2NQMGV2Z2JLaTh0KzlFVTB3cUZDMDZPYlkxMzlxWXFjbEJD?=
 =?utf-8?B?OWNmM0gvRG9TRFNOSzNYdCtaSUkvL3k4MFNmSVFhZTBQdkwrQ0tCdjdoY0Nv?=
 =?utf-8?B?OU10ZHRZZG90TzQyVXB3TWhZeWUzSWJGMzhMN0NUREwzNEJUd1gyQ0Y2U0Zo?=
 =?utf-8?B?SGNKSU0zdmFPdWF6QXkxb1ZsSDcvb2s3d1liMXJxbmRkNHlncnJSeVFyTUM5?=
 =?utf-8?B?V0ozY0xEK285R2xLNWZvRDVDNzBPZkN0RWRuQ2JiQmdFZ0xrL1RhRjZNYktp?=
 =?utf-8?B?VGZ6SEZZREdYR1JvSDZRdUR2a0txUWRqSVB3UDRBQktJRlZsd1Q0QU9XNlBm?=
 =?utf-8?B?WUJzOE1HNjVsR00xTDdCZXBHc2FQbEhLYzkzd3VyWVFFNVlFV3NXVE1jNUg4?=
 =?utf-8?B?Q1MzbjUzOVZLWXFHbXVzMXRRdkIyTEd3d0tPN1lKREdMTHRWMnpTTEluVEJQ?=
 =?utf-8?B?Wk43TTYzY2tLRVVxQlJHSkhxbDJYVGJMNGJtcGRhcndHR1JaYmhDdFNSM3dv?=
 =?utf-8?B?emxHQnVoUXBYajUrWmRrQXA5OFFsSGxRWU96QUprZmVXUU43dk02bHFDbFZ1?=
 =?utf-8?B?TmFMUjU4WEYxa3A5YmdxYS9oOHU5ZkxFc1F2Sk1MeDBtNjRIQUprSzcyUkNm?=
 =?utf-8?B?TmUxNTlJdlJmRU5zNWZSenhRSFJRSVEvUnJoTVlDZm5hSFVXUVVtSkRwc2xJ?=
 =?utf-8?Q?uJ8yzcEOIGisPcTseXKoe20BX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?RXFCaDdKd2hZR2pKUDhoS09xbk1DMWxGd0M0QzdsSWwvdmlEYUNLMkl4WndR?=
 =?utf-8?B?aXNJRHhMemtIMVZuOG0ycHEwNDRFSkMzSGtrdFlrRUZEKzdCMDJRUkRJZzhh?=
 =?utf-8?B?b2pKNmZ1ZlprRGhUQzNnYnJpMnMwWUJUWGd4YjBiU2lqTGhjeGFLWXRnTTRE?=
 =?utf-8?B?WmxIRE9TZlRMaWRBQVJFcVJvTlVuRDNaVFJOd3JPMGJxa0g4d1d5ZVIxcXEv?=
 =?utf-8?B?R0JsM000T251NmE0QWRDb1VFSC9oeDR4Qi9DMmI0Ky9YVDdSTmdVc0pXTm9n?=
 =?utf-8?B?dGpIRGZBaVhCcnhiSHhjMmUwMDRyd1JIUnphcFlvSGhVeXk3Zm1HL2VNWDIx?=
 =?utf-8?B?TjZmQ21oK1RXbG9NblhBQ256dE0vcHpjYWNteUtTcFErMzdIT2ExTU1IdzVZ?=
 =?utf-8?B?Um85NE05amdaTGkzMmpMWHF2amE5cVd2dDd6ZDFkeEgxQWxNc0R3NS90M1FV?=
 =?utf-8?B?VzdPL1Btd3ZpWVRVdTM2L2o0eW9oWWlKaWJ5WjFuZzhDV2xyTGZYVHNYK1do?=
 =?utf-8?B?RFhyWTV0Q1ZtYVl3NGhjNTlXZkppZE5YRi90UFF1L1ozcXYwY1hmWVdDTDAv?=
 =?utf-8?B?Sm9BSWlhOWJyNDQxaVQrcVJ5WktEcU90V05xZ0pwd1hsQ3VoblFneTE1bmYy?=
 =?utf-8?B?SDY0WG4vWmtjOW5aRGdEQ2NJbit0WE9jdEM1Tk85c3FpeHNXdlRFT2RsQ3dF?=
 =?utf-8?B?bGNpZm1KNi9UY3VPREJvelA5T1dQdHlzVTlIcGdjQkd5VkNPUzJOUEgwUjV6?=
 =?utf-8?B?VC8rQmgybVFldXNPYVZCUHc3eVp2N2NlajJqdVBPaGFjQ2tOOUpJNG80NU1n?=
 =?utf-8?B?RFJoQ25hZGFvODhrVmk3eit6TjBFcEhNOVhMa2xXL3FweVkvMEFiVE5IRElz?=
 =?utf-8?B?VzBSSVprTFA0bnBuV3hmWDJJZHBobXZUM0tmb3B1T2QzUDlaeXdyV3lta0FX?=
 =?utf-8?B?Rzl5bzBjbVBOV1NDdU9qY2hPUms0VDlWMTFIZWFYOCsrTUQ0N09sUnFLaGtD?=
 =?utf-8?B?TzdGY3BESVArejZBcXBVOWRqZTNsVlVVNzZOOVVmMWhVTTEybWdOZ3Q5TS9E?=
 =?utf-8?B?QXU4My8yR0xLRS83NHJpcFJzTGpXRmhLUThMbGdvWWlDUkc2WEtSejZPZ3ox?=
 =?utf-8?B?M2VJTzJRZVVPeGJvRTZ0MmdsaWdZV1BsRmNXc0RnczhLa2tiZlc4RjVRbjhw?=
 =?utf-8?B?NEFVQzVUYmx4ZFBzRVR3YXhDc0JjcWdzdlh3d1hRVlNZak9YRWpUREV3RGxO?=
 =?utf-8?B?b2ovNENJWm1WdG42N2VrSVU1ZEx1TTBPYzlxOWhUU1l6allJOVlxOFpwam1h?=
 =?utf-8?B?N1RYQldxR0U2RDhieXBOT1B0WEFJQ0dQMkoySVZMTkxBaVFEcWpjeXlyelNS?=
 =?utf-8?Q?J03gDEAmC9ABL4t11bAZqAWAEA8l4aDY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96663d42-6d21-4382-54f9-08dbdffc16d0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 01:43:21.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F74KdePnJ+giShCtOxvsdt8qtwGqw2bERbxxLPGKJy0ydUDgaV4eEm2PwaQi6zWB/w9NRUQzbu10D4581Y8+dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311080013
X-Proofpoint-ORIG-GUID: 4omk9noT76dVFovSJzDZ7UKFSQgXZREv
X-Proofpoint-GUID: 4omk9noT76dVFovSJzDZ7UKFSQgXZREv

Hi David,

On 11/7/23 15:24, David Woodhouse wrote:
> On Tue, 2023-11-07 at 15:07 -0800, Dongli Zhang wrote:
>> Thank you very much for the detailed explanation.
>>
>> I agree it is important to resolve the "now" problem. I guess the KVM lapic
>> deadline timer has the "now" problem as well.
> 
> I think so. And quite gratuitously so, since it just does:
> 
> 	now = ktime_get();
> 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> 
> 
> Couldn't that trivially be changed to kvm_get_monotonic_and_clockread()?

The core idea is to always capture the pair of (tsc, ns) at exactly the same
time point.

I have no idea how much accuracy it can improve, considering the extra costs to
inject the timer interrupt into the vCPU.

> 
> Thankfully, it's defined in the time domain of the guest TSC, not the
> kvmclock, so it doesn't suffer the same drift issue as the Xen timer.
> 
>> I just notice my question missed a key prerequisite:
>>
>> Would you mind helping explain the time domain of the "oneshot.timeout_abs_ns"?
>>
>> While it is the absolute nanosecond value at the VM side, on which time domain
>> it is based?
> 
> It's the kvmclock. Xen offers as Xen PV clock to its guests using
> *precisely* the same pvclock structure as KVM does. 
> 
> 
>> 1. Is oneshot.timeout_abs_ns based on the xen pvclock (freq=NSEC_PER_SEC)?
>>
>> 2. Is oneshot.timeout_abs_ns based on tsc from VM side?
>>
>> 3. Is oneshot.timeout_abs_ns based on monotonic/raw clock at VM side?
>>
>> 4. Or it is based on wallclock?
>>
>> I think the OS does not have a concept of nanoseconds. It is derived from a
>> clocksource.
> 
> It's the kvmclock.

Thank you very much!

Both xen clock and kvm clock are pvclock based on the same equations.

> 
> The guest derives it from the guest TSC using the pvclock information
> (mul/shift/offset) that KVM provides to the guest.
> 
> The kvm_setup_guest_pvclock() function is potentially called *three*
> times from kvm_guest_time_update(). Once for the KVM pv time MSR, once
> for the pvclock structure in the Xen vcpu_info, and finally for the
> pvclock structure which Xen makes available to userspace for vDSO
> timekeeping.
> 
>> If it is based on pvclock, is it based on the pvclock from a specific vCPU, as
>> both pvclock and timer are per-vCPU.
> 
> Yes, it is per-vCPU. Although in the sane case the TSCs on all vCPUs
> will match and the mul/shift/offset provided by KVM won't actually
> differ. Even in the insane case where guest TSCs are out of sync,
> surely the pvclock information will differ only in order to ensure that
> the *result* in nanoseconds does not?
> 
> I conveniently ducked this question in my patch by only supporting the
> CONSTANT_TSC case, and not the case where we happen to know the
> (potentially different) TSC frequencies on all the different pCPUs and
> vCPUs.

This is also my question that why to support only the CONSTANT_TSC case.

For the lapic timer case:

The timer is always calculated based on the *current* vCPU's tsc virtualization,
regardless CONSTANT_TSC or not.

For the xen timer case:

Why not always calculate the expire based on the *current* vCPU's time
virtualization? That is, why not always use the current vCPU's hv_clock,
regardless CONSTANT_TSC/masteclock?

That is: kvm lapic method with kvm_get_monotonic_and_clockread().

> 
> 
>>
>> E.g., according to the KVM lapic deadline timer, all values are based on (1) the
>> tsc value, (2)on the current vCPU.
>>
>>
>> 1949 static void start_sw_tscdeadline(struct kvm_lapic *apic)
>> 1950 {
>> 1951         struct kvm_timer *ktimer = &apic->lapic_timer;
>> 1952         u64 guest_tsc, tscdeadline = ktimer->tscdeadline;
>> 1953         u64 ns = 0;
>> 1954         ktime_t expire;
>> 1955         struct kvm_vcpu *vcpu = apic->vcpu;
>> 1956         unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
>> 1957         unsigned long flags;
>> 1958         ktime_t now;
>> 1959
>> 1960         if (unlikely(!tscdeadline || !this_tsc_khz))
>> 1961                 return;
>> 1962
>> 1963         local_irq_save(flags);
>> 1964
>> 1965         now = ktime_get();
>> 1966         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>> 1967
>> 1968         ns = (tscdeadline - guest_tsc) * 1000000ULL;
>> 1969         do_div(ns, this_tsc_khz);
>>
>>
>> Sorry if I make the question very confusing. The core question is: where and
>> from which clocksource the abs nanosecond value is from? What will happen if the
>> Xen VM uses HPET as clocksource, while xen timer as clock event?
> 
> If the guest uses HPET as clocksource and Xen timer as clockevents,
> then keeping itself in sync is the *guest's* problem. The Xen timer is
> defined in terms of nanoseconds since guest start, as provided in the
> pvclock information described above. Hope that helps!
>

The "in terms of nanoseconds since guest start" refers to *one* global value.
Should we use wallclock when we are referring to a global value shared by all vCPUs?


Based on the following piece of code, I do not think we may assume all vCPUs
have the same pvclock at the same time point: line 104-108, when
PVCLOCK_TSC_STABLE_BIT is not set.


 67 static __always_inline
 68 u64 __pvclock_clocksource_read(struct pvclock_vcpu_time_info *src, bool dowd)
 69 {
 70         unsigned version;
 71         u64 ret;
 72         u64 last;
 73         u8 flags;
 74
 75         do {
 76                 version = pvclock_read_begin(src);
 77                 ret = __pvclock_read_cycles(src, rdtsc_ordered());
 78                 flags = src->flags;
 79         } while (pvclock_read_retry(src, version));
... ...
104         last = raw_atomic64_read(&last_value);
105         do {
106                 if (ret <= last)
107                         return last;
108         } while (!raw_atomic64_try_cmpxchg(&last_value, &last, ret));
109
110         return ret;
111 }


That's why I appreciate a definition of the abs nanoseconds used by the xen
timer (e.g., derived from pvclock). If it is per-vCPU, we may not use it for a
global "in terms of nanoseconds since guest start", when PVCLOCK_TSC_STABLE_BIT
is not set.


Thank you very much!

Dongli Zhang

