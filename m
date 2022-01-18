Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3034492C92
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347466AbiARRky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:40:54 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27566 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347431AbiARRkw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:40:52 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHT0m4017890;
        Tue, 18 Jan 2022 17:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=9uEEeWtWw7ryJZUxa/uNdkzbnzz4d3lzGCLnaphoqkE=;
 b=S6uKgzYLIPMPB0j5Oo8sc9OKZ8N4jRfycpgcrdQ5EY7Xinl6Gwa3A3SG2DLWO2nVVh9z
 +lPk5UDssFbOiFP4a+/oEBrQVegCcxQsHf7El4dqp7fUOFih4dJMQPyoDzxH52PmV6H5
 M0EZtp6GKsh8RQRA0wLa3uZf6mAzopJmKFBKOk88vGUrDPcoO/uzR55YASUP0u2WwBZe
 RhRS4xdvM6s9pO7vg+0IiyYa+rsu/baaSnhGRCn1Ytmy39HY5PC/lgkHegiBrJt8plCr
 dB+eGv86ecvJVFSw2OM94kR1iKModkehfTfJjMyHIxrJIe2h8y8oc33DXWEnfxYge18Z vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f2k0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:40:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IHUZgR081428;
        Tue, 18 Jan 2022 17:40:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 3dkkcxnt6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:40:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1KBCD2WV1ZpcVnYNYEv6aRWLKmVTl5oUKi17YNEHgWPvta+Wtv8xqhX5qhqi/54Eck9SQKEuGUo2AIqNCH5DN7Cm6Z9QlqnLj7wHZ1g/Ru1Ea9aPPHGJdzvzT9J4KkFpCACbjAq+9e87JZv5pHMvu+Zi4k4ofOWkJT8M7Z9viyxi42OEvgZyPuOtKpkYpuDqLBsV/yRJPUg+at41RAvdtzrdZ45a5L/ZACRF1xT0ntmIJUP5/+SuXNN727u38SIdz0YOdy85BLOgaTfCPYUn7CofaQGlKNhOoQ/dO29xJyAa7Cl5aVpRY1YczIWqUXX75/zxE+zumXBZ8w8ME4zrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uEEeWtWw7ryJZUxa/uNdkzbnzz4d3lzGCLnaphoqkE=;
 b=oF3mbltRk4IsGD+7Z3dt+7a0w1qovIr52wWXSKTntpV0afxsce5bJGbqyS9RPdy96A1r4HAMr8jGSmo/wB/PY0F6PNw3/oxCZ2vugNRgDym//MrAqmqUKfZR1jWL1XVDfMjbS5iv2tFY5JU6v37yhF5JAhR8mu6o3TjsbU3T9utcNFBZmiB01CIcgs8Oy7UJX/37WwrQdfV8B9Bq3ChwXm+/H5/IzSRbR1lLQj3QaKrkDBWDdRJ7KXQG/gZvn0gb+42qm8YRQFMGmBq85+dTftVC3ilYmmmyAVY+wvl+5GNWn83w0+jXECQyKwCHjcybeY/wc/JbeCqSyOJJRKjAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uEEeWtWw7ryJZUxa/uNdkzbnzz4d3lzGCLnaphoqkE=;
 b=BKUpRoExkjBeTt8tK59/Rb9xHEpk/x/5G1DhgrC2WQWZ3cOhywH/WaNyY2CEMSjVejaTvIEBgzg4RRcJ/P0qswJDXuGNnaTO7hS/1318MapjKrUbf7d/Ka1WOGQ6XjKEK3D4HK82KWM0nOK7eL6UIDymOeFN0P3d2/38K90ZuMg=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by PH0PR10MB5547.namprd10.prod.outlook.com (2603:10b6:510:da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 17:40:13 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%9]) with mapi id 15.20.4888.013; Tue, 18 Jan 2022
 17:40:13 +0000
Date:   Tue, 18 Jan 2022 12:40:08 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <20220118174008.22bdwhxeg5qdc3xq@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
 <YeFE9j4Qynp9sNXS@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFE9j4Qynp9sNXS@hirez.programming.kicks-ass.net>
X-ClientProxiedBy: MN2PR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:208:19b::38) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 230e1646-d3bb-4f79-d5ba-08d9daa9948b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5547:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5547072241CCCE7B9C96F910D9589@PH0PR10MB5547.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zE7h1P3Bu0VavJufZZnKoNcwJd92GhX8NVTooqxb6KcdoQavEF5DJbxRRKIU+HV/abC/Fk4bew4YLNnDzJfyMKtq5gHyIKpSx7cN+d3PZ1+ZsveRER26a0FwnF7dGKKfynF22gYgjnkYMxBMtYDtpjJWY8CaWZst1cV9GSRHk06LaG0rrl7upmqPfRx6XA8G/R78J+TGLR9ZdlXL7SG2FUzcpyTRa7HzxxK7Ap+qfEpdoSZa4+KWDl/mABd0geX8NAAFwsmRBtQhvZaOasC0SFnAAuxi7JXcSJNUJrC3VGxXJP3DahBE7WezLH6PwijU88WL9I29SKzQFvioiMDUXIe8mfXtEJBX3DY8ItoYHDIVDFJiZw1fgqrNA1uxozl2C2xHppWSTyA5Vv/p7qAeP2BF01mUWvUtDMpfbQvAznqbvi7n5700Q3dQIXUv8MaxprsIjJEz3hlwBR/EDeM/REACj8dBe5w3MDNsrv87A2oKTWX2xN4AzANUFulr9yBjpiuaql9LOY3p4tfvB3zCdGqHONQ+mKmtMahIpokXkhG11oI1vdczVXqXsU08VfmH2kx1Q5coxlOgk3dFw0RsSd83XJYoA6m7tNyFUNPEcTj9oAGzSfpUMC/KGLtvnTUJV3ix1pjDd8g76SqkwEnTF7tLUkgNTiYIwHk2OMYbT0g6iFl5lMInWEVG8YmgjLtmdNdn1W04y+Fa5eNnmtz8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(66946007)(15650500001)(66556008)(6666004)(508600001)(66476007)(2906002)(6506007)(5660300002)(7416002)(86362001)(36756003)(26005)(6486002)(4326008)(83380400001)(186003)(6512007)(8936002)(52116002)(38100700002)(38350700002)(8676002)(2616005)(316002)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uLeSl4yF2pAhgNqQgIVe6iaHnn5QzXzGdRu69RkblvLXk9D15O3ptazYem2M?=
 =?us-ascii?Q?7vbd9tuZcRjRajyWO2pBV8wHuAza8SIWxxnlvMG4GbyEOJgHV6r8xfHs1Sog?=
 =?us-ascii?Q?oqfNyPEy4N6jZJdsPIK9WVnBDcuNvBL0kqjohfryqFuRYjAP0Aw8f/zTGPFZ?=
 =?us-ascii?Q?wztrmrSY2dZRBYQqcPEVsc8CGFj4UZAE4SMfZz+ZvYdmZF1UEBWIV2/8WxJr?=
 =?us-ascii?Q?hHmFLx8qN5JImEsm+cIJPtedl9NMXnfEoDxBtvgtln2L2eFFeFinNEQzIpfX?=
 =?us-ascii?Q?aBAeLund+1vGE5HN0XexnItYYYHfCtvSpcpDIyw2zHsZWhNLWktQfte/cIX6?=
 =?us-ascii?Q?GO9MOhYKcz08WVz5BQHGYLKp2H2yW4/gr0siP4Wem45h6jylAJlYh6VUm4hx?=
 =?us-ascii?Q?72KyttK1g2C491Ep8QEP3aHdvPbjv3l8cf0AD1NwLgoZlzd1KVZIr1ruFEHn?=
 =?us-ascii?Q?8EULbX/ADUCjERqudjKZq1E2A/9nI0Nw5NG+iFBNpXzFb1u9j3LvnpF+WmxP?=
 =?us-ascii?Q?5IaVy+xJhZ7zK6wocSmX1BtGF926UaVkb4LbYKf2N9B8pYX2rTry02i/fgW9?=
 =?us-ascii?Q?HtN+abtaFBgMHF8ojkvqKR51PUiuwXa7I8Ccg7VLl/G501VgjN4KcgAh0yPa?=
 =?us-ascii?Q?4uUxSsAX1AhHovPDCTxJuqH6R50CE8W4bb9cZSnmg1dba9oetYDxzGOrgxc9?=
 =?us-ascii?Q?4fIZzG8qRuDyI95566cmILNBBPfOF4k452KLuj/Jw1Wam6wONFB5PH/HGhzF?=
 =?us-ascii?Q?jvC9Ntsx7rxSOn0ai+sTnU6KRB2CnzcVku0whormz2phIs+lGoQLbTGG+/vM?=
 =?us-ascii?Q?NPObxNjfrGRWgx0KJVePjYdMCey87HrsdEfzgS5ddEbHGLLRwwvqMghZ0FFH?=
 =?us-ascii?Q?a+OqIJV9KkfCFlfTJZWW8YUZ15MkNAk9gVhVazT79s3ESB56GnSccM0DO/E4?=
 =?us-ascii?Q?FUhbjNB8WoPVr9L01YHFZRNSVem46QBSGRegJL+ju0r0XfRrybDBDGp/D3vi?=
 =?us-ascii?Q?lQTieoOJEW2UcE81QJwKcIBkRbwaKaO/VEnmZfxqeIPfSGwjRb0HlwOM8BLk?=
 =?us-ascii?Q?W2U+FAPFjgzdW7UvJQBwWlZgBHdG4Iw71qs0JMZumIDSza0K/eQeYC9923iG?=
 =?us-ascii?Q?lTxCGyrRBf9U6HkDHy/jx4ZLkWw8jw+76Q1oFU8BMvVWL9zfh9iX8Gp0HaBW?=
 =?us-ascii?Q?MnOXy0TzaxCiD2tucDJvXDGfEikE51aKTDbqITOvIflPLxulQtke4I/xYcb9?=
 =?us-ascii?Q?RXlnQ4f7410igeXFIFA3KQxtKRFnYmvjD+mZmwBARQgeCRUgDM/MC2MN82ps?=
 =?us-ascii?Q?bjvWhYubZeGdVlZz9IsR32NeMpXSsEMwEWp1Ve22xdRkxc6jhpmHmDm1DS7z?=
 =?us-ascii?Q?+666e5qNafGpNc95VmLBr5/ifBPNciIHPDQucye7MQe9yqDOC+7RzqABGiBy?=
 =?us-ascii?Q?mZmaafc+O2642v0M7QVq/P6uKY/ebDVBo+IY9jI3tCEq65dbx0O0mo/uiAHR?=
 =?us-ascii?Q?gM1VjQf+CcYj8rUAatcTOzwt7rTgP+IGqPZ9NmQOUkUaI//eWM48vBvMfQjv?=
 =?us-ascii?Q?ZupXGPVU+tSFQWGM3zL+uQ+T6nBwITvUB+fRDTTojsHQUNEoA+AQvjb5xsDi?=
 =?us-ascii?Q?MZ3cmIGt8eer1OYjgAqnWbJ62HFV0lTP5Ke/dXua8Uo6SE/65W5NJaeQxixC?=
 =?us-ascii?Q?YwMiRnYtoozD4QwG8sL5h1JDu2o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230e1646-d3bb-4f79-d5ba-08d9daa9948b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 17:40:12.8655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYUd2SGYamkj6QeD3yoIpeKQI8hPisRgEmluwKcEA+faeYVswbeYJnnJigEhCJEMPrsSfasyD8cbJKc1liaCmMWleZtZ8755dCwoXlaIElw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=735 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180105
X-Proofpoint-GUID: _2Xqkn3ZY5_XqapE5CBooO2qhUti_0Zj
X-Proofpoint-ORIG-GUID: _2Xqkn3ZY5_XqapE5CBooO2qhUti_0Zj
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 10:40:06AM +0100, Peter Zijlstra wrote:
> On Fri, Jan 14, 2022 at 10:31:55AM +0100, Peter Zijlstra wrote:
> 
> > Also, by virtue of this being a start-stop annotation interface, the
> > accrued time might be arbitrarily large and arbitrarily delayed. I'm not
> > sure that's sensible.
> > 
> > For tasks it might be better to mark the task and have the tick DTRT
> > instead of later trying to 'migrate' the time.
> 
> Which is then very close to simply sticking the task into the right
> cgroup for a limited duration.
> 
> You could do a special case sched_move_task(), that takes a css argument
> instead of using the current task_css. Then for cgroups it looks like
> nothing changes, but the scheduler will DTRT and act like it is in the
> target cgroup. Then at the end, simply move it back to task_css.

Yes, that's one of the things I tried.  Less new code in the scheduler
this way.

> This obviously doesn't work for SoftIRQ accounting, but that is
> 'special' anyway. Softirq stuff is not otherwise under scheduler
> control and has preemption disabled.

It also doesn't work for memory reclaim since that shouldn't be
throttled in real time.  Reclaim and softirq seem to demand something
that doesn't move tasks onto runqueues, that's external to avoid getting
pushed off cpu.
