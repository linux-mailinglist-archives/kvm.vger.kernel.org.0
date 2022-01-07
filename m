Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE34870E7
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 04:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345671AbiAGDEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 22:04:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3436 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345656AbiAGDER (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 22:04:17 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206Ku7CG031900;
        Fri, 7 Jan 2022 03:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=7OzrrBQA52Lck4uaLD2+1/yAMmR/QTSED/aGXRaZ2qU=;
 b=nBbYdABfJcnR0HrV8iSy7bzBJHI+2vE3y0sMXwmUX0C8s+CRppmZ4RG2ViEjU3LHGi2r
 58P90aZ5GVxf22bosz/XX2dohp9KGWZXJeQrWZLG1E0Wy+k+4Lcb9bLsh7i9eq+Mc/QH
 5adlrXzl4FSPGF6oPQgtY+S82SGg8fh2hJgB5+q3WTpeV/HpXS2CypDUT8iJ1ZUmJhkL
 zdYJwzPLtDbXFH06bR3fIU1C9eDoD5I/vVedZRaMtGrSth0OTbqW9lqA42MXC/MJbQ6h
 JwTlR4bGXdrT7+PuQlEa/2FZWmFY6o0QjMEbVAcJc9jb8YgPdkbEMl9Dkaju7MYohvJv 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v90xwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 03:03:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20731Spx014832;
        Fri, 7 Jan 2022 03:03:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 3de4vmw8v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 03:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i66l0MRL6TGhoCtFct0BpXoMDUY61ZlfAnCW/vm8RH6oHNkRMrNEJ4grjd0LLL13iJiQe9VEnHoYeGNTN/+hjVdjqoLqa3eg1ZhF28O0J0G0y0U+etL30vCA47nW2LKWOi/RQm/u4RXvPSmFKfgMKiVgOJ4qUepTXpsWJKaCekXMtX3fErHRtoLSAgXslw7c7IWtzSh8Jh66eaSppXJ+ecNTqfPC/ei+mVoSRD9uRvUDD3Gt47UsAbMM0a+rYLtrNpfvZUcW5XISQX1B/nuw32tCzAc+uQ5qEZG4tXYeSVyahmwUiASf1WammIwY3Q5EM2HMfL4SI+zN4F4IAEBpew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OzrrBQA52Lck4uaLD2+1/yAMmR/QTSED/aGXRaZ2qU=;
 b=i0uXxNXeOGv1QHkiF570ExyF5M/liVFVWrOzI1fpKBEF64K9Jdhi21zBWFfzSu7M3xtHnVox+uiqQwe3AlJaBDa4L6MHXG9jYjfuwwvra1bYZUQSnInE064uQJ+xKph0eVqAlkoQF40VrgWYdw98n3kTcvtlpjwXrYNEtw2Odrxk9trRW3xk/RFSf+jse/GRklrJmVxl2cRqPB2YXDd+W9T56KgOwFgq/sdw2dV5riOHxkllaIOJp2mflfkIU2WdvXluxonXJiuwkLczidTLwNZP1YCuNJ+QbdlfKS9wVu0ukAjaTykvdKfzjQuZ/KHxT6Ep6ffG5qinZ02g7K830Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OzrrBQA52Lck4uaLD2+1/yAMmR/QTSED/aGXRaZ2qU=;
 b=mfo/D+9kJDkqz1lt8j/qR9ENIj1/BqqUfBg4Q3sC+cCLOQY1/QNXyq2FEzXbN4dIPMl0Kd7MEsPzvWfxqpB7M5KJxmFVl4ZmGRz/B6jigZ3/MMXE/eqSIwfyg10lWlVT0mF21Jx4S4LL3UvQmJB/I3yDCOCcb2JKIRztkWQ9XCc=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by SN6PR10MB2575.namprd10.prod.outlook.com (2603:10b6:805:45::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Fri, 7 Jan
 2022 03:03:35 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%8]) with mapi id 15.20.4867.009; Fri, 7 Jan 2022
 03:03:35 +0000
Date:   Thu, 6 Jan 2022 22:03:30 -0500
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
Message-ID: <20220107030330.2kcpekbtxn7xmsth@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106011306.GY2328285@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106011306.GY2328285@nvidia.com>
X-ClientProxiedBy: MN2PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:208:239::32) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff466ccb-c697-4d95-892d-08d9d18a4b49
X-MS-TrafficTypeDiagnostic: SN6PR10MB2575:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2575E9E76F5FC891768F69C6D94D9@SN6PR10MB2575.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1a+hhQoRuQ+is6WGc4Ukqhlz4I0BaP3c5X0F1Sqa1k6c1S0kojI1Y1rT9d82ciXfe6UVCoA0ddhVPf5G+cEzBr369ZJU/TFAItklYSwtqMzsKvDxzvQ6pq94FHNKQW4RIasdMjqfhq++MMZb3t81O1SGWhW3pxkpk6RTz/2pnJoJEz77cy4lFW9fq5b9mPNj8Q+efQauvnw44fNIOl5k20DUEQEH/qVfRGBd0upY3FFwYlXJiPwur35yUe7SRRhkyVuuKcoKiJWudttL4u3T0tfaT+yrD0Jwgxh9p5w9qlYCPJEkVibJ/MI8wKe8agATGx97s28GTxycv/0Vxn+hS/VbzZpONTd8RibsEO7LsHPfHjcymOSzyiSjzBxVdkMgzo0yfnfeXonmEtq2GosmzdcFCj1hsCjzHbMENgCcTSN9Af4hKC7999jRZTu9SoixBQ/7JL4iSVJKgrA1ZAnROXhuQtfNv+LaK5JvIz4ZW0JZphZaCgoxcf4MXJvEBX01djSqJ2q/T22E9W+uSinhBhCd9YUbqC7Hw8unEM8OGOL26756J/dvCiW30TgThy97rsP90UDHgV4mqq1lC2amu05fia6GXc2nT13wYvbB3hlqTPPpambNre962tih9u7X2ljqBdxSjNPi7OlmCsA4rRzHUFdVM5XTxddaIfh6vBZDrmSESgwk3KDLrVXNp/gMZp5FQQBBdvVoD4q6EUAgbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(7416002)(1076003)(2906002)(66476007)(66946007)(54906003)(6486002)(2616005)(26005)(86362001)(6512007)(8936002)(36756003)(6916009)(508600001)(38350700002)(186003)(52116002)(6506007)(8676002)(38100700002)(6666004)(4326008)(316002)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IQhT1krZu2qjgPC/kaZt5f4kEnr53tQqZVOjCv+YJfb6whx+NHlcsALdMlPG?=
 =?us-ascii?Q?bdqBcYFtUin5cGX+MFU4SuI1U7kdPaPYIFfF7OEFzOUhJEjka26FNTrcLh3N?=
 =?us-ascii?Q?DqD4TSI2b9FDA+zqThHqD3XfGtuuWBgE9SMKyFWT4jmLBrzQ5c2SN4HseRx2?=
 =?us-ascii?Q?J2coKZjG+tpUBTqnim/l9QTpnZmHnSx/JJLLueRo24jXjtl90eO3OFKcfYa0?=
 =?us-ascii?Q?x0jSBFNxiMvz53+5pkcrepdRwAttSLtPSHKnRnsb1sugMmdq8HW0/NGidaDj?=
 =?us-ascii?Q?C92S0IZNQu1azswavfRVOoOoOGLMaENIIHYYTptrES2nzo8vuBLoI2pr2/JB?=
 =?us-ascii?Q?P/Nvs/aNat5ES+Jc0sha4+g+tJzYRFtc+T9iiueb5DDZ8TLearVDwsA9YFhF?=
 =?us-ascii?Q?sSP5KK0dRdCGIg7HBtdiuoRi+/gLkNBR+WqlFZAQHZR7Vk3rvUiI4laV3s4V?=
 =?us-ascii?Q?v4bvgwBDPlfmNgy0i6d51zkglJBCAnx0hbdQCl2bmLG2PwHfp+RR9G+HCNhX?=
 =?us-ascii?Q?nal9mhV3j/vUBO9JOlIGXUq1kZOwmyAA8i1DwvKJavscqUwzGx/Iy6jckquq?=
 =?us-ascii?Q?adbOnicU37od2xKlKpCv3X2pwMml+51IRWzZzoHtNFWgVn8BCjhwm2XdxZ/H?=
 =?us-ascii?Q?I9FAoh1SjhqcTHF6kWGZDNw6N5B4NYp7RfNxhK5nMZgw7GFC1oBHUYS1+9vZ?=
 =?us-ascii?Q?s2nRtE3KxnnS3cMlO14cxtOnrOgAyqSIxv3RTOz/oXFvpoW4yKotnymAmU+Q?=
 =?us-ascii?Q?PH+Tz6XqbII29FFGLko1YR6szIugEmtcf6C/UM98+hHS4ZlR//x7VnVA5D3p?=
 =?us-ascii?Q?F7qLszMdokIENgGiQ+ZWjpILMnUlG6LrHqOEV/crLRYeqWK2zaZ3FuiIEl1I?=
 =?us-ascii?Q?z3Ne5Rk9dySfvf9sBT6j4SSPR4XyPR4ZHNKwQeUk8XWJHpmsWIZpq6i9nADR?=
 =?us-ascii?Q?XCk6IbTYgGKkkR6KQXe1H4j5mirCqRzakA41o35V56rWTdhzDXgc/DYw5sV/?=
 =?us-ascii?Q?8yyIB1LmWE8u7+vxVlm+vLiWLN5Sof4JklhjMB+i9CxpukjxktvGz6EYpV4Z?=
 =?us-ascii?Q?PufVowPeCGago/8vBvjwPuPc4WIeHK06WVtRYPT+iTQCnMV8wyQE0d/2DtSo?=
 =?us-ascii?Q?I8YEpFfJHKOSbHmL/Pz7gtPrMXPT/sw7vgQjKpTDJ24hD0aT6T1fPmXZepP4?=
 =?us-ascii?Q?NVvei9uRRBDKEZIFTZ4EdCmpARH3JbpKSY9K+pdPiWYWSSL7OgLYaESWwOcg?=
 =?us-ascii?Q?xJsecD/67wjIzksjTpg9tNPNihWBWM6M9FnJzuKTdEszKNHtE7OtejKiJG/K?=
 =?us-ascii?Q?nqGPtaTYWSgW7fBBLxCSJca8eDogwYBKgQzf0E8XlIF6hvgxh6vZ5pcBnLAd?=
 =?us-ascii?Q?Z5Ef3EJBOGmFyxlT6SkV9zKYFx/P/Vh0q5wCbs/O+H86V7+i3Yz0Ozna7Yel?=
 =?us-ascii?Q?jfPrfo21fIbZC07nY8PJC83+klNIE99aXUk418E0kqHsxDTy3EI8tcXZ9KEF?=
 =?us-ascii?Q?cOXjt5bIUY9rpY/P3VAX38AxUslmau+b9r0tfNuiyoppS4yjU/+Upu7iXXCW?=
 =?us-ascii?Q?cxA+/2yeL6Z3v+VT6Y73EmGpHnwCp9u+KQ8yHe+raU36HUaYV/WBaGuz2l52?=
 =?us-ascii?Q?6hBUde4PzoSqXxRMkVpd89POJCMxplMG+sQ91Lnlx9d92PiZxvEuWBmnaNBS?=
 =?us-ascii?Q?qA2kVbAyesOlYdFc8nutZ/cUsKA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff466ccb-c697-4d95-892d-08d9d18a4b49
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:03:35.0469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OB/yrD+/F/xxu+to8H+R4Ut4eHZdWXvBSnsWBm5Q1n/FnfIG3QAVrpy0ictY2KUB6vBYeEgpIQ1ANtdmYEPbL4ZY3gWT1LRmSRZrZikLZ14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2575
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070018
X-Proofpoint-GUID: HjixY4w8_EUlWYQq2HSECfTkvO_PWh30
X-Proofpoint-ORIG-GUID: HjixY4w8_EUlWYQq2HSECfTkvO_PWh30
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 09:13:06PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 05, 2022 at 07:46:40PM -0500, Daniel Jordan wrote:
> 
> > Get ready to parallelize.  In particular, pinning can fail, so make jobs
> > undo-able.
> > 
> >      5  vfio/type1: Pass mm to vfio_pin_pages_remote()
> >      6  vfio/type1: Refactor dma map removal
> >      7  vfio/type1: Parallelize vfio_pin_map_dma()
> >      8  vfio/type1: Cache locked_vm to ease mmap_lock contention
> 
> In some ways this kind of seems like overkill, why not just have
> userspace break the guest VA into chunks and call map in parallel?
> Similar to how it already does the prealloc in parallel?
>
> This is a simpler kernel job of optimizing locking to allow
> concurrency.

I didn't consider doing it that way, and am not seeing a fundamental
reason it wouldn't work right off the bat.

At a glance, I think pinning would need to be moved out from under
vfio's iommu->lock.  I haven't checked to see how hard it would be, but
that plus the locking optimizations might end up being about the same
amount of complexity as the multithreading in the vfio driver, and doing
this in the kernel would speed things up for all vfio users without
having to duplicate the parallelism in userspace.

But yes, agreed, the lock optimization could definitely be split out and
used in a different approach.

> It is also not good that this inserts arbitary cuts in the IOVA
> address space, that will cause iommu_map() to be called with smaller
> npages, and could result in a long term inefficiency in the iommu.
> 
> I don't know how the kernel can combat this without prior knowledge of
> the likely physical memory layout (eg is the VM using 1G huge pages or
> something)..

The cuts aren't arbitrary, padata controls where they happen.  This is
optimizing for big memory ranges, so why isn't it enough that padata
breaks up the work along a big enough page-aligned chunk?  The vfio
driver does one iommu mapping per physically contiguous range, and I
don't think those will be large enough to be affected using such a chunk
size.  If cuts in per-thread ranges are an issue, I *think* userspace
has the same problem?

> Personally I'd rather see the results from Matthew's work to allow GUP
> to work on folios efficiently before reaching to this extreme.
> 
> The results you got of only 1.2x improvement don't seem so
> compelling.

I know you understand, but just to be clear for everyone, that 1.2x is
the overall improvement to qemu init from multithreaded pinning alone
when prefaulting is done in both base and test.

Pinning itself, the only thing being optimized, improves 8.5x in that
experiment, bringing the time from 1.8 seconds to .2 seconds.  That's a
significant savings IMHO

> Based on the unpin work I fully expect that folio
> optimized GUP will do much better than that with single threaded..

Yeah, I'm curious to see how folio will do as well.  And there are some
very nice, efficiently gained speedups in the unpin work.  Changes like
that benefit all gup users, too, as you've pointed out before.

But, I'm skeptical that singlethreaded optimization alone will remove
the bottleneck with the enormous memory sizes we use.  For instance,
scaling up the times from the unpin results with both optimizations (the
IB specific one too, which would need to be done for vfio), a 1T guest
would still take almost 2 seconds to pin/unpin.  

If people feel strongly that we should try optimizing other ways first,
ok, but I think these are complementary approaches.  I'm coming at this
problem this way because this is fundamentally a memory-intensive
operation where more bandwidth can help, and there are other kernel
paths we and others want this infrastructure for.

In any case, thanks a lot for the super quick feedback!
