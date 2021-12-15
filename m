Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10945476058
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245707AbhLOSL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 13:11:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59492 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233548AbhLOSL0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 13:11:26 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFHw5cU030510;
        Wed, 15 Dec 2021 18:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=beKlXv8VV5zGyjk66VMveuzHOWuVW1OizrwffhuXjWI=;
 b=EhDC8a84HSZ9NUE9b7GPpeokcAwie6VmUo7bLE3am2jHy7rk93N3fA4GzZ2ZVL1nLUJK
 b5BUhXbTsad6t4CXS0cT+HjzC7blwkmVSU+h++eNLi5cn2b91TULb0qfzYk56C795pRc
 dW8vaFJCEl1qAwPYaTdp1dcCuBFe0Lm3cA1uiJGqfuw38DVx0QRXT9jhdcA7VtzkxhKS
 UpFwAPqnEO6Mj/a1adq+fSZPtob+wH/rX1QJow9x4WvbPnCeBmfGQPZrlRZbyshM74SR
 V2M38+qp1/MezCKQ4NMbw4ulgjfFENG/IJI+zYZGMje1xKS9MfEZkw/i4tmEfHt9XeaY Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykm58e6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 18:11:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BFHtj00189969;
        Wed, 15 Dec 2021 18:11:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 3cvnesaeeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 18:11:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIGcrE4Cff9kKV9FhqVhm9X7E00HwH+IMcBDBBAUd4XtoOm0VmAQgL+fkW2XlVWgfYfBGdPPrtlI8IM5hZX5d1aYmDa1Z84Vv5DCBDu7YY62L1DKuz4i7m2CQYm086GEnsohXDIoZ125HoCvhh7Svfar8bPX6eVKzNg7K2xUjFtQKz195qb5r8pmnhYSoG2z1o9xzgQ5gqRecmiuX4jTbG3xfJaE5GQtbSgpxVqQ3b5FzoKg+mZtfS6LIXUm4JZzsLXyBPRel+8XJKK1JICMOMDVwwItK2yPFcm5Xg3nlVbKUE8N/DjbmEJ7lL1HlzuhBVfsLTiL5zqT/W9GzBhOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=beKlXv8VV5zGyjk66VMveuzHOWuVW1OizrwffhuXjWI=;
 b=SmEvtWj/Lm0AIn8reMbMGAS2Bacdc/4YfIt1qo/wDHgTTyhM6Ufg7qcPKQLBtyD0H/lUPnSgrnEa6g7/FHwY6UNKcyp/0KdkXRqspyM8jn+0kBuj+vu/ZUYIALGbyxnox7u/koXjQvLvDTCsUlC4/rbqY1auNwnrFWt8ixijHiQplLcBVf5ohIPwXylpTmfK0rK47IMFairDupYHyC2FtL+9/h6TFe1KZIfvMvxbD9jD9k8IPuXskoa3v2fe8nP75xJTA99IJUJQ9pBgpk9P8XBJO7MLYjg9U+WavW2cFbQA4siPCHUBGHjULZI+xvwiKzWD/04MxA4Y1PoVyWFBLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=beKlXv8VV5zGyjk66VMveuzHOWuVW1OizrwffhuXjWI=;
 b=GhhsEXfvk4K3McNgJ3/tg4mkMJBtLTybWz3HSQDdS46eV7GbPZbuCJmE9UWqLDOG/HbFMjgo3y1Eb5powollqGhO79sp9bb25rBxDlXKk6pjR/Yv0nt9jM2bzj6FJs1UqnjZHYE50ToOFncssl0BbTE+SxqD4ag7hwr9lShFPbo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1485.namprd10.prod.outlook.com
 (2603:10b6:300:25::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 18:11:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 18:11:20 +0000
Date:   Wed, 15 Dec 2021 21:11:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] KVM: Dynamically allocate "new" memslots from the
 get-go
Message-ID: <20211215181102.GC1978@kadam>
References: <20211215112440.GA13974@kili>
 <YboZE29SMR/EgLOL@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YboZE29SMR/EgLOL@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85b2ffde-1242-46bb-1b05-08d9bff64bf0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB14856627125678814FF6C2818E769@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sA5ggeVfkGrL5jioRaNEZr3IYmA5/vu48hYHzEMnZ3U6nfA0VfXOhGssRGOVdIqKGd1O+BmOBuopLB3f/vhB2csmWG/Y6DcKdltAyw9NtG0hFw+nKfrxGI6SEmQNVuQ2gZKQ0CVHgFSilL3v3bECkhflKn22cqWUjb6UFZyiOSxCktxk/RQbbzfYjqPmxKLSx8KoGXgLjBv5PTGRx8+DTL9Dycf7sBv0qaAYwV5HWmZ7Z1QYN41zClMh3bl795NuKRnBqV9hjI0dv/gEQHXiOTvVurzty+0LCTU2MlJzYH/8eQYe6WvDAnSOAi78K3t4u8VJ2ymukO4wp9vdOSJBMiBe7bmg+RYcbJQ1uZc2bQxnF5h2RSNVjx9sjKTHupg0Q/Uiqy7mOx1OuMqi8QQlSMdXZG/U0zKgnKc6fBO9BohwMlHVqYsF7Fn3ZjU4TexC1KfA1E3Nt2VSOomFSgumLN4HBG7DI42deq6yEAqNlW3faCO/4zcsV4eOVNN9Jgv5+4EVvgXhp2q3Z0mrmhStTvokzEy6l2Pri86Zl2NMiaTN/E8Lbd7O/gikFbY1AZ4CjppRSUXWddchNY6O1+rZPBJJjel2OJSkOAB+hxHuYll4Yzfgmsd0GO9e6pyt9iDrX7Ru6U/y/4FzoXyp0rH0UC+v5VGDwkT560pnLRghJ1t/eTrK6FPGyZPtw7Gb4kIxV3km/7fb7HUoxv0iDTayMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(186003)(86362001)(6512007)(66556008)(38350700002)(4744005)(8936002)(9686003)(33656002)(66946007)(508600001)(6666004)(66476007)(6486002)(316002)(33716001)(4326008)(6916009)(2906002)(6506007)(44832011)(1076003)(52116002)(8676002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0+uGOiR10+Kyn3zxBGR7TKFU6suQwFWrMt9D83jcjZupmNb7anS7X5n+EYC6?=
 =?us-ascii?Q?fGqRMCZlsUPnHzJy+ZyrzFMOW/Rnw2bxDlfVuXEGcKfgSQedQcexaj/uLhA9?=
 =?us-ascii?Q?px1bC98CwP+snzacLngv4fF+LiA8DRoio8gZ3QY2tThzyRcSEdrJDeXQJ5qj?=
 =?us-ascii?Q?jBEPLg0mJ3NYpGQzzFBX6Udh6hRaHRPWsXJuLZXggfOk4rNwhQkOjNEweL2v?=
 =?us-ascii?Q?NUVq21Gj0rQMtnPgpOvjEqf6UPoW6paMJG1GNZldMMvqCVxjeqNdfEMALIhe?=
 =?us-ascii?Q?zqTX80ZKWDiomzz76cOz7nno2Mf93M+qlGvFh+EvxNNBEwb/acpddX4MuFnR?=
 =?us-ascii?Q?q4wVFG2rxeECn84n0vkyyf4MFbd2g6fsoT66f4v1DqIw8uFn08Hms2s4WGxq?=
 =?us-ascii?Q?BQuJ6BsEK5gNkNockzhEu8nRce9YH2shhrhZj6ix3KcX+XGRNkYqEDDGe2li?=
 =?us-ascii?Q?aiV/eehwmu3QOh3ZQUgPGtmb7wP2hl3bupeuO2dGt3MbcAZLiCsqUcc4q7tl?=
 =?us-ascii?Q?TMJgwPzQkeFabFZ9w2rsVyks4VDpUdkMvbAYZlTfItJsStwSX3SuY0vlBxxQ?=
 =?us-ascii?Q?00GEDUPUooN+H2fosCmPyyVxuogHxY3Av/4m2hU1TbGj5FBNGb/Iz5iNjm/O?=
 =?us-ascii?Q?DB/xl387quV5FKFLA3NamGNQ1d7PiHqEnlW/d3kbT3wdwAj/aa7L+Y2/TtdA?=
 =?us-ascii?Q?BAdyszY+H/t01p0RqL7h3/6HkIjfsoYNDbtHRWrLQsQTJQRf53rF/jxJ/KV7?=
 =?us-ascii?Q?igAuGeUqdVWdumuu/1B+XzcobCmGRHfgNaQtdVctvgxVcUYrEBZHtFyCz1yW?=
 =?us-ascii?Q?/VaA2uRx7Ru0l6rv3JD5pd0NZa3YauMIvp0IxXqoePv1czTOIfwUiEGgH8x9?=
 =?us-ascii?Q?VRWTxn4ED7ZQNavBstskUHSNXU8T+L/mYqbjwl12WdKg+oXyTjv3DveWKlw8?=
 =?us-ascii?Q?jpxX75xk6E748+Z5y6CSL8PXXEP5ErzWqCcN3k1xEG1D6yiT1JPGcz4pZkK+?=
 =?us-ascii?Q?Af4qYJ4Ta7KGpTRF0NUv8F8EBjO1y3LFxnZr9ihO00xDftwPOqw/eYo07cHz?=
 =?us-ascii?Q?XqVVExPjZ5kEuwDm8VeSwb3l7EYM6PBH3ptVdZM3zVEDDJEVSOXekrFBYo2q?=
 =?us-ascii?Q?wTEfQYRGhittgcb9vGNTU6rM4oLu9++GFXTyAzsQa/UkKUrJ6xC63CjWOLNh?=
 =?us-ascii?Q?bfgQzFgVOJnO+OhJK7i9xImjP5mK9g5WbW7LPMR60xOucBK3nsv5Y7eqmhv7?=
 =?us-ascii?Q?JOX8pgkLjAvqQkz4Uihcm3xLFnrrr44VFTAovPLuc5JOM+gYT7p/Fy9B14eX?=
 =?us-ascii?Q?+i148N0g1z4mkv/P4ZMb8CjEwy4ufO1UaglxREUSsAoIjAlZeWI294cXycpG?=
 =?us-ascii?Q?4b7svnbd2zzBYO9OkDZh448mLR6ClPCgJZBu0bJ4sNSSi3FU9qp8sind0Ike?=
 =?us-ascii?Q?eFb3bCNswTDMoHuhWlYkJX98mCblMgqybCSytz1BipWA9K35njOpmy8Ocs1/?=
 =?us-ascii?Q?tmlDxqmM5JS3yqSokRAyEQIWCfycLUgyPMxiIExlbLbvnPl2Ger62kjOodu8?=
 =?us-ascii?Q?o5qLEhCG84LLGPuHNRDKqucOrp/lOxMLVzzBTPlCmlUo9zwgiBQoJDCklIHS?=
 =?us-ascii?Q?NUhh1ciWdOflW5l5nauE/BuObGVXysUJVmmQsvbLOSwMfGHYaudAG+APdR7g?=
 =?us-ascii?Q?jG+gUaVJ4lHYK6e2drEIBUS28ec=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b2ffde-1242-46bb-1b05-08d9bff64bf0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 18:11:20.8451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: baSvb3gjB9fWuXlA0EycujHgL+Hyy7R0s+GDmkKinQ51XkqVMeYds00oOudtX4DIISletNsSYTc7ZDtnSBHNV3fhWA1FbPnOqp77G3Ce030=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=590 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150101
X-Proofpoint-GUID: EfmLH_QLKkMoWLPr4iMO29FvEQ1Kfwxr
X-Proofpoint-ORIG-GUID: EfmLH_QLKkMoWLPr4iMO29FvEQ1Kfwxr
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15, 2021 at 04:34:27PM +0000, Sean Christopherson wrote:
> There's no true dereference, architectures are responsible for ensuring @old and
> @new are non-NULL, either via explicit checks on the pointer or implicit checks
> on @change.

Ah...  Okay.  Thanks.

Smatch tries to track these implicit checks within a function but the
relationships get lost at the function boundaries.  So, for example, if
there were three callers and two were non-NULL and one was NULL then
Smatch could figure it out.  But in this case there is only one caller
so the data gets squished together and the relationship between "change"
and "new" gets lost.

regards,
dan carpenter

