Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A451C48A2B9
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 23:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345408AbiAJW22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 17:28:28 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35124 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345394AbiAJW21 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 17:28:27 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlhbQ011416;
        Mon, 10 Jan 2022 22:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=1Aq7V2S90CCkiUtYjNrVeW7xB7JHgsccxssyxcxk7VE=;
 b=Uj1nZP/UA+Lg96bwp1QRMqhnsqAklPyiP0+qPh6LaCm8klJL3yfAePQHAtXN2m7/uDEs
 30xv1nYqCle9nT8V3hSVr3A0PYPpDUsQ11cUfFyAlfY3puUqQ7WkLAFLR16b5wY8ifnR
 Rj3M4+BqE9gwMsmlTwajYgR/sF4mMh/+fE8GKgV5WuA1jRy5whIzSosT6jPel3z+Ie9G
 ljwMhkDRsISoLdY0a00E+iPKPz3trN15E0fwgUII3GVmJNq5JPdMx50YkpOYIFOzg6vm
 Ul75lJxer3ZLbGo8vnxmJvnsCogbf4mrayYWes6vgRXmx84WW/PsNa1fMFKnQL7G8O4A 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjdbsv9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:27:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AMFvXF012826;
        Mon, 10 Jan 2022 22:27:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 3df2e3wkx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz4sFvxlDCtqI87IvAj4pAH5YNr2KQhPmlZrYwW6tt2OpZk6dRDDR90JGyyYY/XAks4hOGDSrtr501KJ554e0/h4H5Mx8f2l6I5uE622eVDfc+RWPrJg6Soe+/7QUCpyXfxSN76FJassY9X6AxLVsBzCkbHRrnpNaixrN09EuM4K5MehZwCWS4tm8MxQxNHtRsWgoQHvs4t1KwoL5WCLz6NSDW8EuMZKfBZl6NkXQAdx2YgR94uxmkNGZHhLxq6dD9x7PekL1+OFfukxC9lRFxjNQzrw1oYDICOkJHr4aUUDJmtl6tCu9xDynTkbIdP0I9CYY53H2mNkH+bz4OY5Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Aq7V2S90CCkiUtYjNrVeW7xB7JHgsccxssyxcxk7VE=;
 b=DH8F+T+QvBl+eSAeC8+npckR+g93xJU/aaKfXWFcuvG5ZPtGrZzL3Oa+gX9bDK9dwASOTFz8oDPyA2yLju0+HBL9l/jQ4n2gE8DSNrTsUh3q/574ya9HMC59PoLlnHWk0EdS+C8yvIMEPr1br/kWKtWQbi9nyv2jbWc5QI0DwMEF44xDzHE+t3IXbWiOq9hzwXJ4CwvfG0u9DDdy5JVyMDf6dCPQYArIEGowN+H47dwpZ1aglSjA+M6pxpg10osoVRV3K50hLNYSbaAKlI9qSgSdxOmCuSoaF0V5WVqzIkkLWM462A7cL3PBWtWbkRUCO/2xprTdLTVF4Kfx3qQ0Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Aq7V2S90CCkiUtYjNrVeW7xB7JHgsccxssyxcxk7VE=;
 b=iofO7UGMs74sCLu5tAxNi/yd7BTjINnByDVCklKUIPvOMO65OFWmyHFtzGwPQDeBYIBHvQsAusnb+o0a5Id9xgq2ZfbhxPcufBOPlMQjIjO8Jy1DCW+SVol9NvGsgODhn72FN1JwO8e2+veB/RS2dHqIK1rUb4FgQvPUpuG4d/I=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 22:27:31 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%8]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 22:27:30 +0000
Date:   Mon, 10 Jan 2022 17:27:25 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
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
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 00/16] padata, vfio, sched: Multithreaded VFIO page pinning
Message-ID: <20220110222725.paug7n5oznicceck@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106011306.GY2328285@nvidia.com>
 <20220107030330.2kcpekbtxn7xmsth@oracle.com>
 <20220107171248.GU2328285@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107171248.GU2328285@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:208:236::20) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c77b6065-a497-4eca-7372-08d9d48863cd
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB25105E2D88056986DD60A35CD9509@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0e4WuPE3DvTfCt85FzK1QfH/ThiDv0s3rrwL5Y4XxlwgqK50AD6TSZpivGrZsVgl/Is9erLhq+l8pMJDhDLdTK/eBB17QTxjhHntVW10Qn9E/f6trNi6l0CklSFtwn30kgI4hQ8urZPCts0syIh7VZR6ZZarJZ9Bvx0TShsuPUC7QCq/w4R54Kqnbd5scb0nTSyV1XIrd32wdDNqPMhoTzMNSFVVHitq2rUTKYi00/MFyUrA90fLIl0rxScx//tD+QiEVSM2xBJkTCesP9cG+cWqQ11xhW09Ymv79cOqGlsodLNHg+UzGTI3pIS3qEf9FIU8zSi56eoYefygUUcPuRkzCounc01+zM638ybVuSpEE+LGCtDgvd7015JNdJBh+kQ+KmgdJHmdXKYQP2wVymgOTvHZuvotQlKEsIqh0t5hwZ3Wn2B1e1oPhzYhaMDNkfp9xYF3tYSXP4/zD/3ZgvMsZep4o+4LkgqH9Y0Yp8VqiXQSClm1Cn8uhtuiuaaWhNArKdmtO0tmyig/XXh0jA1FD9krGh55yfNthM+6HnzngNz6XU76adFFCdJ4xPYhk+VvergkKzwy2My4SyeKbtFPlfQXrnP6ilD3uRfgFHvilCtTWb4PU2QYAKT1oEpvaozRTo8qXhX6x6LXTq1tZXD4V0K9qr85NH93KwF7LM7k7MIu2QKbTPtkROxDk1tARUhReMw4XxtIR01uL8yUSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(508600001)(54906003)(38350700002)(38100700002)(83380400001)(6506007)(316002)(36756003)(6916009)(2906002)(52116002)(2616005)(6666004)(66556008)(1076003)(66946007)(5660300002)(86362001)(6512007)(8676002)(66476007)(6486002)(4326008)(186003)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bhXKWfx/ue3loX72yMGWf5yw4xmvHx/hzoTOgd4iH0vdfThfIhCrujFEQqvg?=
 =?us-ascii?Q?hLDFpthbwyT7X8X3y8P5lEBkfWTWgtOuJ5Bak1S62riI7gXJNadZPXkClWMw?=
 =?us-ascii?Q?3O/bZlcZZqA1jVctkSLuZ5FEQA6VPwwzsWbagh9fUyRPXVC5snCiTbKfMb7E?=
 =?us-ascii?Q?kvP58ZL3ZmzLhRhrgrfEAWAD9mVqCRddtE0h7WJWEHwHVnaiem1iukSJeOPy?=
 =?us-ascii?Q?hYBvRyQMdtsQJXkUwDG2HFwVuNIbRWjnYiKqEr3Qt5ZqlNdkSKUdZozRWnSK?=
 =?us-ascii?Q?eFrhEeUT6DAETLKTfF0DLvV50JGjHOmi6QdSipafsR+lIGtInE03QyIEql6X?=
 =?us-ascii?Q?tMs41BZwwPThAUZMdKHRJ0USQjrQ+dkEQrmG5NYX3VDrJIHEdrIMYbSu3l7H?=
 =?us-ascii?Q?puhS9NdFpGctnJT+rnmezmwp41tkvtxHf++YOfdTYu6NeEv186uhLo5X2UJu?=
 =?us-ascii?Q?l2k/V2mNZnf55J4/CweO2CXy92+IeHKj++N8D2BQda/gL7bh6Yjx1JzAkFGW?=
 =?us-ascii?Q?7tr/rNGcWkiNyvTsn/15maQE136QZj+m4DsxIDG0k2iY474tPUkS9Ykkjvxk?=
 =?us-ascii?Q?V4thCaHe3FFkcGm32r2/eJHOIaC4tCw7uYQr4tEnx5eJDcjaKLzOnLF5PeTt?=
 =?us-ascii?Q?os6/RiKRyUL0gBRiGkp7S7wnC3ImOKeMjt47DrGy13rYOeTKEZjQKvnnlCyr?=
 =?us-ascii?Q?j/wOMZRBjiQM++J/9Hwp2hIev2utfUO7Xsc+TEZwkdRw7NaCcWHwzFiiK3EI?=
 =?us-ascii?Q?8iqEFNM3gZOiVHqoDJtL1duleIIQLj33PPkcV5X3Zhl/LTHuqW6anmTnlG9E?=
 =?us-ascii?Q?U4fIhy5OmxAJkeeOqg4NsbPrvB0m4Eo0ar0JEZ/YbjhvLVQV7lY6M484Phiy?=
 =?us-ascii?Q?hateiJG9OKK04Yu+K/Sc34Fgh+rCI4FIDbJ7XXgO3ahJb3+XjI1eNt+c3p+g?=
 =?us-ascii?Q?mdXErlbjhdc6+c3nHrBrfzMIY+tkR59H0uHvwLll+JDwcl7JTuMbuXq6KAS0?=
 =?us-ascii?Q?Eu4JZYRdyxzfT2nFQmbiIj1l3Cxv1lxY/rK2qaU5Z+dkTz5C+aUhlDoXtyDU?=
 =?us-ascii?Q?68pf/0yelCarp3/1qfP1E4avp/++3APXmI0yMwnEfTip8KnQiS7JoCYVLcMT?=
 =?us-ascii?Q?KS8Zgj9gag17uufIbdc+ctfXBFBYme9XPCKDtyAx4/uZgjVn3yVUGfmxTRZ3?=
 =?us-ascii?Q?MoBadj/MuAyE/n6+RR7krDqNEqcdk0faDJ19/fPasK9ON2G5jZmkcaObgpGR?=
 =?us-ascii?Q?FFnG/eaJBNk/dI6ojiEMkfGEFzLnZbzez/KQYskEupO1H17UUXPedrVf1cPC?=
 =?us-ascii?Q?76TiNkQRg9gBDQM218WiTVVsLJgQSfLs2vbxrmWtT2OIiwj+VMzJ2Hzcgc0u?=
 =?us-ascii?Q?Hpj40T2a7TjbUQdx8flhXJYBNWSV3PvGyZlc83ZbB20jZAQGiMtGNXAmXNYv?=
 =?us-ascii?Q?sLjRVQI7GI/M6vSpMhGOSj43CVDM9S85N/8cIvev28KCFvnP5CWzZDbetgBs?=
 =?us-ascii?Q?A8BKItBinPuyIq+tsmmyL5oa6hQhvzvKi+UGlr4OziCVkYwenYP3xOdAOFwe?=
 =?us-ascii?Q?7ebTKR8QkV+Cs410l3TyWi7stG25N8vBK+a7GLgBPMgW9K4UcAtmJ9Chwsh4?=
 =?us-ascii?Q?opfe5zYeBRkNL44GP5e9XJbsBCuclMCDHl6oJz6DAO1TcMlzxY7ZY5DlAbLF?=
 =?us-ascii?Q?GomU7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77b6065-a497-4eca-7372-08d9d48863cd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 22:27:30.8903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Br3MiFv4/Xa41SmhZmQ0HO/PDsfNo0CpH0HqIc3dDCuu+NvB7VMXZmSV4JQvufKYpAczr4i86O34WDPOP2N29mO4Ik+W/6IcG6oTWdZe/z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100145
X-Proofpoint-GUID: ZqhLWtfzeQI8DBuX-uyjY66UNSvH1Zbu
X-Proofpoint-ORIG-GUID: ZqhLWtfzeQI8DBuX-uyjY66UNSvH1Zbu
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 01:12:48PM -0400, Jason Gunthorpe wrote:
> > The cuts aren't arbitrary, padata controls where they happen.  
> 
> Well, they are, you picked a PMD alignment if I recall.
> 
> If hugetlbfs is using PUD pages then this is the wrong alignment,
> right?
> 
> I suppose it could compute the cuts differently to try to maximize
> alignment at the cutpoints.. 

Yes, this is what I was suggesting, increase the alignment.

> > size.  If cuts in per-thread ranges are an issue, I *think* userspace
> > has the same problem?
> 
> Userspace should know what it has done, if it is using hugetlbfs it
> knows how big the pages are.

Right, what I mean is both user and kernel threads can end up splitting
a physically contiguous range of pages, however large the page size.

> > Pinning itself, the only thing being optimized, improves 8.5x in that
> > experiment, bringing the time from 1.8 seconds to .2 seconds.  That's a
> > significant savings IMHO
> 
> And here is where I suspect we'd get similar results from folio's
> based on the unpin performance uplift we already saw.
> 
> As long as PUP doesn't have to COW its work is largely proportional to
> the number of struct pages it processes, so we should be expecting an
> upper limit of 512x gains on the PUP alone with foliation.
>
> This is in line with what we saw with the prior unpin work.

"in line with what we saw"  Not following.  The unpin work had two
optimizations, I think, 4.5x and 3.5x which together give 16x.  Why is
that in line with the potential gains from pup?

Overall I see what you're saying, just curious what you meant here.

> The other optimization that would help a lot here is to use
> pin_user_pages_fast(), something like:
> 
>   if (current->mm != remote_mm)
>      mmap_lock()
>      pin_user_pages_remote(..)
>      mmap_unlock()
>   else
>      pin_user_pages_fast(..)
> 
> But you can't get that gain with kernel-size parallization, right?
> 
> (I haven't dug into if gup_fast relies on current due to IPIs or not,
> maybe pin_user_pages_remote_fast can exist?)

Yeah, not sure.  I'll have a look.

> > But, I'm skeptical that singlethreaded optimization alone will remove
> > the bottleneck with the enormous memory sizes we use.  
> 
> I think you can get the 1.2x at least.
> 
> > scaling up the times from the unpin results with both optimizations (the
> > IB specific one too, which would need to be done for vfio), 
> 
> Oh, I did the IB one already in iommufd...

Ahead of the curve!

> > a 1T guest would still take almost 2 seconds to pin/unpin.
> 
> Single threaded?

Yes.

> Isn't that excellent

Depends on who you ask, I guess.

> and completely dwarfed by the populate overhead?

Well yes, but here we all are optimizing gup anyway :-)

> > If people feel strongly that we should try optimizing other ways first,
> > ok, but I think these are complementary approaches.  I'm coming at this
> > problem this way because this is fundamentally a memory-intensive
> > operation where more bandwidth can help, and there are other kernel
> > paths we and others want this infrastructure for.
> 
> At least here I would like to see an apples to apples at least before
> we have this complexity. Full user threading vs kernel auto threading.
> 
> Saying multithreaded kernel gets 8x over single threaded userspace is
> nice, but sort of irrelevant because we can have multithreaded
> userspace, right?

One of my assumptions was that doing this in the kernel would benefit
all vfio users, avoiding duplicating the same sort of multithreading
logic across applications, including ones that didn't prefault.  Calling
it irrelevant seems a bit strong.  Parallelizing in either layer has its
upsides and downsides.

My assumption going into this series was that multithreading VFIO page
pinning in the kernel was a viable way forward given the positive
feedback I got from the VFIO maintainer last time I posted this, which
was admittedly a while ago, and I've since been focused on the other
parts of this series rather than what's been happening in the mm lately.
Anyway, your arguments are reasonable, so I'll go take a look at some of
these optimizations and see where I get.

Daniel
