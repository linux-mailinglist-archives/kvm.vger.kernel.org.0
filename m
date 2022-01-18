Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0173E492C71
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347357AbiARRd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:33:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63070 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbiARRdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:33:51 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHSZln006913;
        Tue, 18 Jan 2022 17:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=N+sOCTJy7nMADx2ATXWHgLNwyOMTpazSjDSe3FxX8MU=;
 b=qajqFHYZxtTYb+/m57CMUqB+ziXcAiVELMvbueXMxyE3AgKtaX3+bxQm6WuRo5nbIvnU
 G0mpSxn6vG+F3cF6qZMRihkPka+xqwkEASByri7k+nWnP6tTIIFtKuoN4qc0+n3YBlhw
 PD2Fzb2xjus6C2wzxN8rkU2x4s7mzJAPvIku2rxu2oe4H0KDB42jyo/Af3LoxQT1MBBT
 DiP4OusP72mqi1wtG37GFc3CCXzJFoA03dQwCW8KB/Fr2E3YkBtDYkb3fCM00VtN/1DH
 v+TG9dMJO2v9WktZQl4s97x0Deqir3J01RCyb83qn7N2eDxqzDf3c/J4S1uZd6XCGDW2 Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnbrntksg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:32:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IHUZdp081476;
        Tue, 18 Jan 2022 17:32:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3dkkcxndvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:32:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2sGoDtNkQkxtHc/5CUm0A6y3WqlxY/1trAgCIop8XEnUxLJSRK7VKvxZ1gKcvTkhL3TblgaFXvJ4FudmjwcLaRvNXMXoJQ4ws+5HtSbX1yQHrzavTGMr8AVA+jP97PkMZPPSG1U4WrVQtPgBHMkDNIxUgDq4BaojOwhhpJS5TGhG7gU3sAoG6pKj8GefRoP4F/7SxR62ZcVtAXdCoegOzBLBRnXK+Wt7g61A+8J6AzstbmWuM0JTZzViz96TsjSkjDrGEmlw5x0KqPhW/vu9jaAJRVEWZPyJG3EuEOxFkAeknC3uC+3nJe3qvsLQhxCIj0hW4J7t/nG3hQkdsIIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+sOCTJy7nMADx2ATXWHgLNwyOMTpazSjDSe3FxX8MU=;
 b=HfLmdBFXq4HXAbp0UwcVqkk2cl6p7mqPv2SA2h3B+OpjEIZjOBo4Goie3BzQq/Vf1YcqdTM7lOpTHsGd4sXbiFQ9s1UsCH4Z3gn7hff5S/klsq2QTNjb/LwhqT4GM724iQIe6CRy4vV9psr2n4cd9ocNMEFQrnUQT1jyrV3p6H6qJqzR7GDzd7Qm5GF6ViU8UCtG36dFsFa707z5pGDBMrKvCa7j8Q1zJbugu1TV7lI9mZg5RR/40Y8McRIkCIp6RFK9YpocPgeodG9bx+lrEfMFm1iDmyUS/5hHbCHr5wVXFw40noQxshT5R2zmTR0DeT8lEZwjSbxbE9x3sEzvvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+sOCTJy7nMADx2ATXWHgLNwyOMTpazSjDSe3FxX8MU=;
 b=zTjQZmGa+dsDXITWqhFpKcpF3Ma6JNYBmkf2tyP4daEaPk9MB4vvicUHKvGyN7v/v9TstuoNnfJe8MiOV6e+9cKxoV4hRUmOVJcsCjHQSKSBbe4LjEQQU2VjxC1Q+lUZqRK7tgCSrYcCjP/EjifsXCaa7WUqrH3uoTJvhSlUsH4=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by DM6PR10MB3737.namprd10.prod.outlook.com (2603:10b6:5:156::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 17:32:53 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%9]) with mapi id 15.20.4888.013; Tue, 18 Jan 2022
 17:32:53 +0000
Date:   Tue, 18 Jan 2022 12:32:48 -0500
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
Message-ID: <20220118173248.amqd3qwyuqc33egk@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
X-ClientProxiedBy: BL1PR13CA0318.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::23) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9415b92e-334a-48c8-a7f4-08d9daa88e81
X-MS-TrafficTypeDiagnostic: DM6PR10MB3737:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB37378794243FCCCBD336EE00D9589@DM6PR10MB3737.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Gj+cLchzogR8OiQUKKS2XAlCdXtmkgI8YwMt1YiEj0wzCJii96CwDuwsz8yxxCUQMusatgWhiWLX1xaUaV2sA4nnhPPj7s12Ww5gj5JczzIEHfxUPufBk0QnyYPSa/2woh0NDZuGjrMZZ1J++ZMt0Inu9G6DdHwsW7QHze1Zqx2OOoJtbhmRbkscXhmCAhUqxezMcMZVMPGaJCHzMEoz18TRicY5CbEjcoXJMld+bO4bOXIs9c0hk5Nz4jhDaIn0SgZqx2WmhBuVWi89Tt28TjgZRnX3GuTmZwmUu7mllXA1nRiThla7hIvPHCbdmzFtZRgt/qR4AC+7KVlF+hQgjGAVCYQ2c5A0sivhySARoam+sIgckBscbfJy83mreEysL2WiLK2TR5T+sPV+1HmQFERzWTyrTvYqSMEey3GX4xX8j28jN2Lw3mnafT56ocyscsD9CyH+qtIgzxExZ3wyUHGaXnO/4BSrXKTh1XPM2exX5jriddO+1DArnPoNktRnN6PWKdCBqXP1o3hNrncQZ3Cs/U+52F6ChEwWmQ2G0AWzoyN0B1wYfVtAmuJHwEscHvcxpo+0RZWhZusqH60LYeGRdErC4dXMOfxdPvkz8xvqLk+9FTLoZ6f9czkkhxxjQWHq64rltTOcDhzc6pd2Se53ghAckHOF734zBM9E96tcZbinZZdPTLEjFkFAra7Qqfvi63jCEZkQyW+gxirgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6916009)(66556008)(508600001)(5660300002)(7416002)(6666004)(38100700002)(38350700002)(2616005)(36756003)(66476007)(83380400001)(86362001)(186003)(2906002)(6512007)(1076003)(4326008)(6486002)(8676002)(8936002)(6506007)(66946007)(54906003)(26005)(316002)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LuSWc2/GFn3h6tZFXdHHTNiuBkGOcNfC3TYwV3r2gfllAA8Gz0vJzx45tpRk?=
 =?us-ascii?Q?dYiM0QAoG9AuM88AvirnMDhJvH8aldDB8dxefRIXC3uYfroZTvwk3r2S4hEJ?=
 =?us-ascii?Q?X4ANBRyCc9WihYXoOiGVFyrPf/fqoXYt7SZ1YwFzXbDRjQzTtpO9rrv3KdEB?=
 =?us-ascii?Q?+EPO5nt8Ta6orekZegc0nJYKMpr40aBTDTq6JgAM581PFhgAQ/xG1pszrKsL?=
 =?us-ascii?Q?o9EoQ6ZTvX1IsTWCv1LLpzaj28cCzp0SZpugFPnwt6oqcKCo1Hd1dEV2xY4y?=
 =?us-ascii?Q?2aU+/R2Hz684vTDqEDaLSW6bJ0ZYnnnd0uktbYl7+XiquPm6yGhwpEz6NKFD?=
 =?us-ascii?Q?vrFt0HR4H4pYtVQrZQiV7TwmVwUsW7i3IuGK0uULVwCmwFpcIPveh6X9mJl9?=
 =?us-ascii?Q?MAr0nZ9O0if4Fc5xoC/8giSZgaxKFaXHRnkkX5zwLF4hAxAc6GyKzt33BynL?=
 =?us-ascii?Q?9WtSBP4uXFp7UjN4yjgjLFULVf4odUWhLFOpcymAJPs7Tc0Hjm9EzeHXZPsR?=
 =?us-ascii?Q?CnDgz6yqSfl3XV2AZ5Yaz4GCTYEk3NDDIC0boOt3sRpA1FrVsU8vPpHv1K/L?=
 =?us-ascii?Q?0j/vhycUuJBG/e0vdhG5hpXDc1I7X6/uQpYzONLFK5RtyyCqHXzwD2OEfreS?=
 =?us-ascii?Q?vjC2iah2qGUdPkBPos6UUV0OvUQaUyLjNvX2w3caiLtByMIzkVPSiUcVM2vM?=
 =?us-ascii?Q?OhArxnxilcmNqsB2Z6VlFe4AC9qulYm+A7bZYGBbTj19RufRXGstitChTrhZ?=
 =?us-ascii?Q?FgfZvkIiJpIOuabJjn12TR30bsjUgtDWUASYcLcQAHsR6jhExsBs51ejjOLl?=
 =?us-ascii?Q?Iwe1dM/5PIfknSUE1asmuWMEisZTe8a++UiM5C2wcyhmiKHDAqddELAjzRdp?=
 =?us-ascii?Q?LkVRBiCRLSkYRT60cLQN+l7IvaSxU5TrgwI+5gmxhfUa9yj3p+67hlcWt4TL?=
 =?us-ascii?Q?8QP143lX1ZDHe3srvcyj7jUwvPgGOYzwYcFstmfhn7l/e1sp0NR/5K9sX2qh?=
 =?us-ascii?Q?Xn74qbLGmkWPtU14cW3qkD3r1G3AGUdnfnIIJPkblyQ4QJabjBI2/aom/mzn?=
 =?us-ascii?Q?VYMCD5aRkmqUX8V+WR7Qge4nNlkIx885QVhh+XPZvCF3fAJCcowi9lGsibqs?=
 =?us-ascii?Q?iWaROHFyyvn5hSaY8R/seoNirEu1+nw6TN2/Q5Czzv1sLoCTJU3lTzrVncbr?=
 =?us-ascii?Q?nh6+OA851ss6CUOO4LTdIeIVXme9Dh6yMcvpY1P2f/EmpWgm2QgCTlfjNkyZ?=
 =?us-ascii?Q?tjfs9zQckah23PcoPyasFxeHa33sX3p4UrAuQSu/Zsh2NEL6MH8OqpBYciVh?=
 =?us-ascii?Q?qiiuIMlM/c8dvWmhCKdlXShRleJN0nLcQN8HpdUZHY2Ys1tUtAkWOBmcZCJJ?=
 =?us-ascii?Q?zLDnMqfbyKMN2M6htQNoTTBS6ixKVICifOqwTABK7rGqZjr9SCXiuCgBKGOt?=
 =?us-ascii?Q?4QSkhyYF36WCUcyEn0Pfb9sDp4GBSZlFiC9fLQwDsHwdTRyDGAR5W+5r07qQ?=
 =?us-ascii?Q?tFEMcKSAwnO/4zbVKrpcMrQmVzhmOAihjTCTxcm+aNRIr+cTUOXPh+iC5rRN?=
 =?us-ascii?Q?if5disxZl+ze63R4DexeR8c6LaNPmojT4q9htcfggZ/HLJyjquu3vxeEHXLb?=
 =?us-ascii?Q?+VS0K9kcqPQ7o+Fk/OSOQIlsaFoSLYwH+kyuZlR/c3h6zqUWBnKbXWrnLgj+?=
 =?us-ascii?Q?cXfvfQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9415b92e-334a-48c8-a7f4-08d9daa88e81
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 17:32:53.4076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5QQpR2WxBJ/+RU5EcjtJaky8cC7mpPlNIQnjTCdEbZUkj62PK4H2128stnOLoiRhcxSS9KkY2u9TX1G5OUCkEVtPACr7fHETwaW3KoB1IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3737
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180105
X-Proofpoint-GUID: PYFz-HiM05rExjYRUWUzg3U34vB4yhCj
X-Proofpoint-ORIG-GUID: PYFz-HiM05rExjYRUWUzg3U34vB4yhCj
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 10:31:55AM +0100, Peter Zijlstra wrote:
> On Wed, Jan 05, 2022 at 07:46:55PM -0500, Daniel Jordan wrote:
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 44c452072a1b..3c2d7f245c68 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4655,10 +4655,19 @@ static inline u64 sched_cfs_bandwidth_slice(void)
> >   */
> >  void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
> >  {
> > -	if (unlikely(cfs_b->quota == RUNTIME_INF))
> > +	u64 quota = cfs_b->quota;
> > +	u64 payment;
> > +
> > +	if (unlikely(quota == RUNTIME_INF))
> >  		return;
> >  
> > -	cfs_b->runtime += cfs_b->quota;
> > +	if (cfs_b->debt) {
> > +		payment = min(quota, cfs_b->debt);
> > +		cfs_b->debt -= payment;
> > +		quota -= payment;
> > +	}
> > +
> > +	cfs_b->runtime += quota;
> >  	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
> >  }
> 
> It might be easier to make cfs_bandwidth::runtime an s64 and make it go
> negative.

Yep, nice, no need for a new field in cfs_bandwidth.

> > @@ -5406,6 +5415,32 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
> >  	rcu_read_unlock();
> >  }
> >  
> > +static void incur_cfs_debt(struct rq *rq, struct sched_entity *se,
> > +			   struct task_group *tg, u64 debt)
> > +{
> > +	if (!cfs_bandwidth_used())
> > +		return;
> > +
> > +	while (tg != &root_task_group) {
> > +		struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
> > +
> > +		if (cfs_rq->runtime_enabled) {
> > +			struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
> > +			u64 payment;
> > +
> > +			raw_spin_lock(&cfs_b->lock);
> > +
> > +			payment = min(cfs_b->runtime, debt);
> > +			cfs_b->runtime -= payment;
> 
> At this point it might hit 0 (or go negative if/when you do the above)
> and you'll need to throttle the group.

I might not be following you, but there could be cfs_rq's with local
runtime_remaining, so even if it goes 0 or negative, the group might
still have quota left and so shouldn't be throttled right away.

I was thinking the throttling would happen as normal, when a cfs_rq ran
out of runtime_remaining and failed to refill it from
cfs_bandwidth::runtime.

> > +			cfs_b->debt += debt - payment;
> > +
> > +			raw_spin_unlock(&cfs_b->lock);
> > +		}
> > +
> > +		tg = tg->parent;
> > +	}
> > +}
> 
> So part of the problem I have with this is that these external things
> can consume all the bandwidth and basically indefinitely starve the
> group.
> 
> This is doulby so if you're going to account things like softirq network
> processing.

Yes.  As Tejun points out, I'll make sure remote charging doesn't run
away.

> Also, why does the whole charging API have a task argument? It either is
> current or NULL in case of things like softirq, neither really make
> sense as an argument.

@task distinguishes between NULL for softirq and current for everybody
else.

It's possible to detect this difference internally though, if that's
what you're saying, so @task can go away.

> Also, by virtue of this being a start-stop annotation interface, the
> accrued time might be arbitrarily large and arbitrarily delayed. I'm not
> sure that's sensible.

Yes, that is a risk.  With start-stop, users need to be careful to
account often enough and have a "reasonable" upper bound on period
length, however that's defined.  Multithreaded jobs are probably the
worst offender since these threads charge a sizable amount at once
compared to the other use cases.

> For tasks it might be better to mark the task and have the tick DTRT
> instead of later trying to 'migrate' the time.

Ok, I'll try that.  The start-stop approach keeps remote charging from
adding overhead in the tick for non-remote-charging things, far and away
the common case, but I'll see how expensive the tick-based approach is.

Can hide it behind a static branch for systems not using the cpu
contoller.
