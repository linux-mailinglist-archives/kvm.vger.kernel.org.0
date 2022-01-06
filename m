Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36085485D8C
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344274AbiAFAtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:49:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45590 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344013AbiAFAsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:10 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N50I7009819;
        Thu, 6 Jan 2022 00:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gvnI0ILzdOkq2SPBmAdOe7bmdVxk5DSoROBSRpypnCc=;
 b=GVOVquoc6I1WaCBQgvMKECfM4NLwJrcWozdNf5LeaXw4nv8gIh+bUBTGvko+2aoprc/W
 slFJaNrxlwFc2FDFqgFsvF+R1QkIKDfYU5EvpfCPvdQlaLgsYUj18a2qwvV3Jvz8rrlG
 35muNecWWTdsir1kM9Tnxi2pjzaD6GzDoWnlK1Nmz6nndXtKfEylbgKfMvRU6m3W8mST
 WeKQ59saS7wFwtkaKs+q7wnHdGRCw5+A9jGVmzHk/DkUBm+e0e5nRQfeW/HgnJFmTdSu
 E8/lZZJgiSw2O30gzQaRY1EOp9ozZY8pSAfAsUofNng+HLwQEiF3coChLYqspSHM4Z5A gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpp83u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VnTC086823;
        Thu, 6 Jan 2022 00:47:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by userp3030.oracle.com with ESMTP id 3ddmqbvt3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLWmc1CHR4Fdg0/qwbaxAhmAgT71bGLEtV7e21uDnWh2UXRPdEFYyTrzyEryE34RqXZ8EN1OSZ2ni2YcjTLlrGe+dAAe3qgs8vw4gTzn4OX2ssKK+cFQHJ6Duq2+Sv0paGL0K17s8mUbIckQ314rEPvB1d2MuGnVtIzhacydXrLTotbSv3uIVPPaMomXz/KH3ZlY2IIvaNhMrUwuLPiffzImzBcmm5eT+4yCpLzeITW9LzgD2NyqI5nUOBZh0QXomXs90DErwrYg0FeFUrP2/1N1gxP8BDjkr+bv8EQ3NS0AkH1E9AYQKiFJGTCuLD9rDXXGwpxDHRuTfjdhmAz/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvnI0ILzdOkq2SPBmAdOe7bmdVxk5DSoROBSRpypnCc=;
 b=UMCKscuh5zs694rKWDt1GONHBqp6hR4nuwnLn4M4q/tcdowv6B41J/9CumO+mDVc6OE60fEJI8a+LdSFadl2jjGi+zR5Nttp0wOlHu7g+1WGxUvExJ7HZUQsiA9r3B/8pfJCsMsFDu+vTdDRyCmGHh+7XWZaWJSGKyP2pqyLTvy+Uup/JJFFJ544kH4uhGOh0Xb6JVOVmL3ltyJttvr9t9QW01CZRIVoB/q8jjxInqAXiQDmUZgzib/SbbkpwRNsBiA5scH4HPU3dR9FDq2W3p5Jw8dsiBCaIT/FmDdfzUu0ZwCP+GgX5UMMiwwP8c1VpbZi8Jmn3ZLY4u0lAB0HQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvnI0ILzdOkq2SPBmAdOe7bmdVxk5DSoROBSRpypnCc=;
 b=v84o2jlkW2cEy6biUqy61SLTKfVpxZ1cx2yc6J5qc7U/2vfwcyw6sxWMddblZpz1UGyiFLxCv194P2sRUY50tBZJ5IafZDf2WOQlOBeVZp8VD6a5AfQdIVProgzCpt6YYqj6vktMFffUnyfXOSlN/W2Z7sdWUZ3mbvfqLPQpORY=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:35 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:35 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock contention
Date:   Wed,  5 Jan 2022 19:46:48 -0500
Message-Id: <20220106004656.126790-9-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4df35cf5-1c23-425a-16ef-08d9d0ae2146
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB442252ED7C612364398A7E72D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TscjkaAKYe0kdSgHZPuf0DDR8Y+iYi7qRG+nOw27/ctCNcm1ADqkM81qGEmvZekWru+D/tLzPtF5+zYjZPHncAb3IteqbYZlI/yokIsV5gYgUvnKAsCoL2jXm5GtQvrgP0Ae4k+7c8hI679dHc/Tnh4MMff+XFxbIBdMaD0eiPPXfTL1E3WqMmG4KLOGDwAu0hUTRGbPxR9IcLWqzj9F8s2D5pkqC2fYUfi3O4rq+/6960+yz/+5zhJLvzCQ1Xh3lENeA5vVBXCRxnGc17xKjQTRlox/11zGJl5yWDdDAABe/qsyvG5p/HnjTzcM8Jcvu8YGkwhPj1JY3mxq9NRK4adq+9njABLvH/v8OhZFLD2QQ4zifsjTz9Yc9MzvhpDUvgqWMMu80QrgV9eB7H5dGOq+CQHUHbx+8JvAZFUFXyv3QxDddlXP8JpaJBdM+W1z8H31cSPXFasD39mLwbleNDXm3a0cft2tZdOYIOW9QrGYfDWs84yjNPSdYHLIWAShsDtM5zHaHZ+2YdaG1ZjwPzkaF/zPfnde7kSS1YyshD/0YVSiuW/J4l0AtOu66Fon2pPFfgRQsOu7VTiTyIJ0wBJ3jOqdokmQUvRRiMcZl3SUs7JJbCaUTdn9yRd/vFhawMnctTBFecsMsF/LyEkDzt2dbvi7K47MF+QEBHp/OBs7KfcO2gdt7XEOTDXMgj47MjaBoQiCdLpwHHIri912HFYNfpfHnw8RYh6QaLOnt0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(30864003)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8F702XA9Vdx4KKKPBDkzM/nTdA2Hm+Tl6HHIWV8dacc07Vwab3jwCLrmAtrp?=
 =?us-ascii?Q?K6AHDRiQ3bNnGpu0M0myCydCUtgQfj52doteIoSOtUzBBcXBUKvDkcCYHW82?=
 =?us-ascii?Q?p9+aJGsNNI/s199w8SL8IodFHeP9TlLVpgTk1AMb6taAFeW/Y+UHobMurlXR?=
 =?us-ascii?Q?LSMSYqFw5HREn/0pg0CjPSGbG775XWKoil/Yghq+94R6qUoREQxtbR63JxON?=
 =?us-ascii?Q?8lgoUsGwpuZv7pk4qaUlu80l362i7SFtsJJJJGpyXIPVUJMHt3cv7X+wBneN?=
 =?us-ascii?Q?O3ceLnVz+WQzNmUjVDDCa6eW9kife9Hlp7tsVshcKmMZmF87CvhD5LBxCFxz?=
 =?us-ascii?Q?ttCYI2LY0D0cS/qOqPzcidilSLyEacW00kyUMNbrIyowYocqP14p4ADZyhwH?=
 =?us-ascii?Q?YiKCI2N/7iXPgkNpH9383nXXUZEzPFPaG0cRkWm9pZNxhtAK2psCAp99hX09?=
 =?us-ascii?Q?/x7Ly5ODPTxniacQ7JARuHmgen1B/7mDShymMG98Rtn4U94YVFMe7YF9uJoC?=
 =?us-ascii?Q?ZqG8HxvL/RzwBYgqYdlcWF/apMqOFWTrIuBVZm3sJow1MCeeDNNgOMqZ/MJh?=
 =?us-ascii?Q?DqNIenXcdjWuDC/+wqZyWVkKx+jBpWd1CTlQul+htkLyXc9Y49uMSxxHKOkY?=
 =?us-ascii?Q?dE2JzabT0wPcO9MFURnno4GIlOdEgkzdDtvjFS5HvXtvxqBAaXUvVCk9UuLX?=
 =?us-ascii?Q?EaxkxUixaT0hlBc1XlayW/2ZpJau9+4cwXorOpV725IF/TpuuA6pLC/bepLP?=
 =?us-ascii?Q?FckNMOG5rKyoHOO34ogsSCAukrksYO9hlOk7A29hAv37Ny4AuYMZSrrCYW/F?=
 =?us-ascii?Q?SmCc76KszHjMxK2CKlAvnGlR+9Z5NKzNmVsBLJVcwn9OTJQQmiPh4UBwd3dK?=
 =?us-ascii?Q?UfWT7U72mFB1vIpCM9tfy5IAMdv0FATWpavZ2CGn9pu+TS/zFsLvbsBGPReZ?=
 =?us-ascii?Q?G5zQG/lvWbZWElXBx72Y4F50iqt3NMnUGf6BD+PPfTrICVnN5B9+j4c36o9Q?=
 =?us-ascii?Q?3wwVJB+GEZhMnIyPNqpcKfRzumgfnD/qMlxl9J2ZDDaf/Z7VuCOUAAIM1/Qk?=
 =?us-ascii?Q?TBICa8I7y78YaXCe2/YO5NbMLjKnmxMDLvr02AV0/Z1s1chk5jFfrnzfrtmP?=
 =?us-ascii?Q?J2m2iSiaFX8QRTt3Wa0YVzdowCPwZWfPSk2rLFRkj46RpB+kKex0Fef5oLdz?=
 =?us-ascii?Q?YvrZKA+2+eY4tpf70dULJRs6c6rwnHoEtQSLv2WgFUfwJxu7U+4tYLHnoed4?=
 =?us-ascii?Q?nIOEqdvmimCQHaFPjBcoM0T0L+d9Bi8sFzlkT+vC25p0P31Ru/5UTVgUAXRB?=
 =?us-ascii?Q?lWCIFTT8ay96zUOpOpAHQOo6/F3mKxdMg0heRlGSbdCUvEUATPtrpOfBxP3g?=
 =?us-ascii?Q?+qLRgr8/qCWv64iHS/l9rKgBSLuvs0VdAVidyfSmer/wCJFrnz/8XR0rxUR8?=
 =?us-ascii?Q?lciGlzvV3R+ThK71FSnJwPOuP3e/wxBoHs+6bPavi7qSyoifxd5uRAD5O0be?=
 =?us-ascii?Q?/Hg7xUuSXn0iPMf8mMZTGpQ6frWTDjTRfKApadBk0aiNgKTPKYIdW7R+kgdv?=
 =?us-ascii?Q?885sNvfnB8vsrIIldwv58WmCjME4ZuKKGUxxuRZ/N+HFfs+s9XM4MWeuQtM/?=
 =?us-ascii?Q?OYyj3lpbTZr0ykaBZUy71vHYH6ZpQ/Sy42JkARaGfYc8Vgu4Dzb6f+tQVNWK?=
 =?us-ascii?Q?oRIv2/7dXHp3h7QorCoQUZWNK+E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df35cf5-1c23-425a-16ef-08d9d0ae2146
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:35.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Yb7p1nBYzwhZliJRsQU352xpyg2JZAhoTS4ug+5/rGGwqOF8s3kkOvxeVKHQAwR/KS+DPCIBvv09LXMxwYbyAnOOFR4Xo4aaVrsKr7BRXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: nOxwIalNXqSvuYj1Dve3zqXah1nGdb0e
X-Proofpoint-GUID: nOxwIalNXqSvuYj1Dve3zqXah1nGdb0e
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

padata threads hold mmap_lock as reader for the majority of their
runtime in order to call pin_user_pages_remote(), but they also
periodically take mmap_lock as writer for short periods to adjust
mm->locked_vm, hurting parallelism.

Alleviate the write-side contention with a per-thread cache of locked_vm
which allows taking mmap_lock as writer far less frequently.

Failure to refill the cache due to insufficient locked_vm will not cause
the entire pinning operation to error out.  This avoids spurious failure
in case some pinned pages aren't accounted to locked_vm.

Cache size is limited to provide some protection in the unlikely event
of a concurrent locked_vm accounting operation in the same address space
needlessly failing in case the cache takes more locked_vm than it needs.

Performance Testing
===================

The tests measure the time from qemu invocation to roughly the end of
qemu guest initialization, and cover all combinations of these
parameters:

 - guest memory type (hugetlb, THP)
 - guest memory size (16, 128, 360-or-980 G)
 - number of qemu prealloc threads (0, 16)

The goal is to find reasonable values for

 - number of padata threads (0, 8, 16, 24, 32)
 - locked_vm cache size in pages (0, 32768, 65536, 131072)

The winning compromises seem to be 16 threads and 65536 pages.  They
both balance between performance on the one hand and threading
efficiency or needless locked_vm accounting failures on the other.

Hardware info:

 - Intel Xeon Platinum 8167M (Skylake)
     2 nodes * 26 cores * 2 threads = 104 CPUs
     2.00GHz, performance scaling governor, turbo enabled
     384G/node = 768G memory

 - AMD EPYC 7J13 (Milan)
     2 nodes * 64 cores * 2 threads = 256 CPUs
     2.50GHz, performance scaling governor, turbo enabled
     ~1T/node = ~2T memory

The base kernel is 5.14.  I had to downgrade from 5.15 because of an
intel iommu bug that's since been fixed.  The qemu version is 6.2.0-rc4.

Key:

 qthr: number of qemu prealloc threads
 mem: guest memory size
 pin: wall time of the largest VFIO page pin (qemu does several)
 qemu init: wall time of qemu invocation to roughly the end of qemu init
 thr: number of padata threads

Summary Data
============

All tests in the summary section use 16 padata threads and 65536 pages
of locked_vm cache.

With these settings, there's some contention on pmd lock.  When
increasing the padata min chunk size from 128M to 1G to align threads on
PMD page table boundaries, the contention drops significantly but the
times get worse (don't you hate it when that happens?).  I'm planning to
look into this more.

qemu prealloc significantly reduces the pinning time, as expected, but
counterintuitively makes qemu on the base kernel take longer to
initialize a THP-backed guest than when qemu prealloc isn't used.
That's something to investigate, but not this series.

Intel
~~~~~

              base                    test
              ......................  ..........................................
                          qemu                                 qemu   qemu
       mem    pin         init             pin    pin          init   init
qthr   (G)    (s) (std)    (s) (std)   speedup    (s) (std) speedup    (s) (std)

hugetlb

   0    16    2.9 (0.0)    3.8 (0.0)     11.2x    0.3 (0.0)    5.2x    0.7 (0.0)
   0   128   26.6 (0.1)   28.0 (0.1)     12.0x    2.2 (0.0)    8.7x    3.2 (0.0)
   0   360   75.1 (0.5)   77.5 (0.5)     11.9x    6.3 (0.0)    9.2x    8.4 (0.0)
  16    16    0.1 (0.0)    0.7 (0.0)      2.5x    0.0 (0.0)    1.1x    0.7 (0.0)
  16   128    0.6 (0.0)    3.6 (0.0)      7.9x    0.1 (0.0)    1.2x    3.0 (0.0)
  16   360    1.8 (0.0)    9.4 (0.0)      8.5x    0.2 (0.0)    1.2x    7.8 (0.0)

THP

   0    16    3.3 (0.0)    4.2 (0.0)      7.3x    0.4 (0.0)    4.2x    1.0 (0.0)
   0   128   29.5 (0.2)   30.5 (0.2)     11.8x    2.5 (0.0)    9.6x    3.2 (0.0)
   0   360   83.8 (0.6)   85.1 (0.6)     11.9x    7.0 (0.0)   10.7x    8.0 (0.0)
  16    16    0.6 (0.0)    6.1 (0.0)      4.0x    0.1 (0.0)    1.1x    5.6 (0.1)
  16   128    5.1 (0.0)   44.5 (0.0)      9.6x    0.5 (0.0)    1.1x   40.3 (0.4)
  16   360   14.4 (0.0)  125.4 (0.3)      9.7x    1.5 (0.0)    1.1x  111.5 (0.8)

AMD
~~~

             base                     test
             .......................  ..........................................
                          qemu                                 qemu   qemu
       mem    pin         init             pin    pin          init   init
qthr   (G)    (s) (std)    (s) (std)   speedup    (s) (std) speedup    (s) (std)

hugetlb

   0    16    1.1 (0.0)    1.5 (0.0)      4.3x    0.2 (0.0)    2.6x    0.6 (0.0)
   0   128    9.6 (0.1)   10.2 (0.1)      4.3x    2.2 (0.0)    3.6x    2.8 (0.0)
   0   980   74.1 (0.7)   75.7 (0.7)      4.3x   17.1 (0.0)    3.9x   19.2 (0.0)
  16    16    0.0 (0.0)    0.6 (0.0)      3.2x    0.0 (0.0)    1.0x    0.6 (0.0)
  16   128    0.3 (0.0)    2.7 (0.0)      8.5x    0.0 (0.0)    1.1x    2.4 (0.0)
  16   980    2.0 (0.0)   18.2 (0.1)      8.1x    0.3 (0.0)    1.1x   16.4 (0.0)

THP

   0    16    1.2 (0.0)    1.7 (0.0)      4.0x    0.3 (0.0)    2.3x    0.7 (0.0)
   0   128   10.9 (0.1)   11.4 (0.1)      4.1x    2.7 (0.2)    3.7x    3.1 (0.2)
   0   980   85.3 (0.6)   86.1 (0.6)      4.7x   18.3 (0.0)    4.5x   19.0 (0.0)
  16    16    0.5 (0.3)    6.2 (0.4)      5.1x    0.1 (0.0)    1.1x    5.7 (0.1)
  16   128    3.4 (0.8)   45.5 (1.0)      8.5x    0.4 (0.1)    1.1x   42.1 (0.2)
  16   980   19.6 (0.9)  337.9 (0.7)      6.5x    3.0 (0.2)    1.1x  320.4 (0.7)

All Data
========

The first row in each table is the base kernel (0 threads).  The
remaining rows are all the test kernel and are sorted by fastest time.

Intel
~~~~~

hugetlb

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0   16        --    0          --    2.9 (0.0)         --    3.8 (0.0)
              65536   16       11.2x    0.3 (0.0)       5.2x    0.7 (0.0)
              65536   24       11.2x    0.3 (0.0)       5.2x    0.7 (0.0)
             131072   16       11.2x    0.3 (0.0)       5.1x    0.7 (0.0)
             131072   24       10.9x    0.3 (0.0)       5.1x    0.7 (0.0)
              32768   16       10.2x    0.3 (0.0)       5.1x    0.7 (0.0)
             131072   32       10.4x    0.3 (0.0)       5.1x    0.7 (0.0)
              65536   32       10.4x    0.3 (0.0)       5.1x    0.7 (0.0)
              32768   32       10.5x    0.3 (0.0)       5.1x    0.7 (0.0)
              32768   24       10.0x    0.3 (0.0)       5.1x    0.7 (0.0)
             131072    8        7.4x    0.4 (0.0)       4.2x    0.9 (0.0)
              65536    8        7.1x    0.4 (0.0)       4.1x    0.9 (0.0)
              32768    8        6.8x    0.4 (0.0)       4.1x    0.9 (0.0)
                  0    8        2.7x    1.1 (0.3)       2.3x    1.6 (0.3)
                  0   16        1.9x    1.6 (0.0)       1.7x    2.2 (0.0)
                  0   32        1.9x    1.6 (0.0)       1.7x    2.2 (0.0)
                  0   24        1.8x    1.6 (0.0)       1.7x    2.2 (0.0)
             131072    1        1.0x    2.9 (0.0)       1.0x    3.8 (0.0)
                  0    1        1.0x    2.9 (0.0)       1.0x    3.8 (0.0)
              65536    1        1.0x    2.9 (0.0)       1.0x    3.8 (0.0)
              32768    1        1.0x    3.0 (0.0)       1.0x    3.8 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  128        --    0          --   26.6 (0.1)         --   28.0 (0.1)
             131072   24       13.1x    2.0 (0.0)       9.2x    3.0 (0.0)
             131072   32       12.9x    2.1 (0.0)       9.2x    3.1 (0.0)
             131072   16       12.7x    2.1 (0.0)       9.1x    3.1 (0.0)
              65536   24       12.3x    2.2 (0.0)       8.9x    3.1 (0.0)
              65536   32       12.3x    2.2 (0.0)       8.9x    3.2 (0.0)
              65536   16       12.0x    2.2 (0.0)       8.7x    3.2 (0.0)
              32768   24       11.1x    2.4 (0.0)       8.3x    3.4 (0.0)
              32768   32       11.0x    2.4 (0.0)       8.2x    3.4 (0.0)
              32768   16       11.0x    2.4 (0.0)       8.2x    3.4 (0.0)
             131072    8        7.5x    3.6 (0.0)       6.1x    4.6 (0.0)
              65536    8        7.1x    3.7 (0.1)       5.9x    4.8 (0.0)
              32768    8        6.8x    3.9 (0.1)       5.7x    4.9 (0.1)
                  0    8        3.0x    8.9 (0.6)       2.8x   10.0 (0.7)
                  0   16        1.9x   13.8 (0.3)       1.9x   14.9 (0.3)
                  0   32        1.9x   14.1 (0.2)       1.8x   15.2 (0.3)
                  0   24        1.8x   14.4 (0.1)       1.8x   15.6 (0.1)
             131072    1        1.0x   26.4 (0.2)       1.0x   27.8 (0.2)
              65536    1        1.0x   26.5 (0.0)       1.0x   27.9 (0.0)
                  0    1        1.0x   26.6 (0.3)       1.0x   27.9 (0.3)
              32768    1        1.0x   26.6 (0.2)       1.0x   28.0 (0.2)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  360        --    0          --   75.1 (0.5)         --   77.5 (0.5)
             131072   24       13.0x    5.8 (0.0)       9.9x    7.8 (0.0)
             131072   32       12.9x    5.8 (0.0)       9.8x    7.9 (0.0)
             131072   16       12.6x    6.0 (0.0)       9.6x    8.1 (0.0)
              65536   24       12.4x    6.0 (0.0)       9.6x    8.1 (0.0)
              65536   32       12.1x    6.2 (0.0)       9.4x    8.3 (0.0)
              65536   16       11.9x    6.3 (0.0)       9.2x    8.4 (0.0)
              32768   24       11.3x    6.6 (0.0)       8.9x    8.7 (0.0)
              32768   16       10.9x    6.9 (0.0)       8.7x    9.0 (0.0)
              32768   32       10.7x    7.0 (0.1)       8.6x    9.1 (0.1)
             131072    8        7.4x   10.1 (0.0)       6.3x   12.3 (0.0)
              65536    8        7.2x   10.5 (0.1)       6.2x   12.6 (0.1)
              32768    8        6.8x   11.1 (0.1)       5.9x   13.2 (0.1)
                  0    8        3.2x   23.6 (0.3)       3.0x   25.7 (0.3)
                  0   32        1.9x   39.2 (0.2)       1.9x   41.5 (0.2)
                  0   16        1.9x   39.8 (0.4)       1.8x   42.0 (0.4)
                  0   24        1.8x   40.9 (0.4)       1.8x   43.1 (0.4)
              32768    1        1.0x   74.9 (0.5)       1.0x   77.3 (0.5)
             131072    1        1.0x   75.3 (0.6)       1.0x   77.7 (0.6)
                  0    1        1.0x   75.6 (0.2)       1.0x   78.1 (0.2)
              65536    1        1.0x   75.9 (0.1)       1.0x   78.4 (0.1)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16   16        --    0          --    0.1 (0.0)         --    0.7 (0.0)
              65536   24        8.3x    0.0 (0.0)       1.1x    0.7 (0.0)
              65536   32        6.3x    0.0 (0.0)       1.1x    0.7 (0.0)
             131072   32        4.2x    0.0 (0.0)       1.1x    0.7 (0.0)
              65536    8        4.2x    0.0 (0.0)       1.1x    0.7 (0.0)
             131072   24        4.2x    0.0 (0.0)       1.1x    0.7 (0.0)
              32768   16        3.9x    0.0 (0.0)       1.1x    0.7 (0.0)
              32768   32        3.5x    0.0 (0.0)       1.1x    0.7 (0.0)
              32768   24        4.0x    0.0 (0.0)       1.1x    0.7 (0.0)
              32768    8        2.6x    0.0 (0.0)       1.1x    0.7 (0.0)
                  0   16        3.1x    0.0 (0.0)       1.1x    0.7 (0.0)
             131072   16        2.7x    0.0 (0.0)       1.1x    0.7 (0.0)
              65536   16        2.5x    0.0 (0.0)       1.1x    0.7 (0.0)
                  0   24        2.5x    0.0 (0.0)       1.1x    0.7 (0.0)
                  0    8        2.8x    0.0 (0.0)       1.1x    0.7 (0.0)
             131072    8        2.2x    0.0 (0.0)       1.1x    0.7 (0.0)
                  0   32        2.3x    0.0 (0.0)       1.1x    0.7 (0.0)
              32768    1        0.9x    0.1 (0.0)       1.0x    0.8 (0.0)
             131072    1        0.9x    0.1 (0.0)       1.0x    0.8 (0.0)
              65536    1        0.9x    0.1 (0.0)       1.0x    0.8 (0.0)
                  0    1        0.9x    0.1 (0.0)       1.0x    0.8 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  128        --    0          --    0.6 (0.0)         --    3.6 (0.0)
             131072   24       13.4x    0.0 (0.0)       1.2x    3.0 (0.0)
              65536   32       11.8x    0.1 (0.0)       1.2x    3.0 (0.0)
             131072   32       11.8x    0.1 (0.0)       1.2x    3.0 (0.0)
              32768   32       10.4x    0.1 (0.0)       1.2x    3.0 (0.0)
              32768   24        9.3x    0.1 (0.0)       1.2x    3.0 (0.0)
             131072   16        8.7x    0.1 (0.0)       1.2x    3.0 (0.0)
              65536   16        7.9x    0.1 (0.0)       1.2x    3.0 (0.0)
              32768   16        7.7x    0.1 (0.0)       1.2x    3.0 (0.0)
              65536   24        7.6x    0.1 (0.0)       1.2x    3.0 (0.0)
             131072    8        5.7x    0.1 (0.0)       1.2x    3.0 (0.0)
              65536    8        4.9x    0.1 (0.0)       1.2x    3.1 (0.0)
              32768    8        4.6x    0.1 (0.0)       1.2x    3.1 (0.0)
                  0    8        3.9x    0.2 (0.0)       1.1x    3.1 (0.0)
                  0   16        3.1x    0.2 (0.1)       1.1x    3.1 (0.1)
                  0   24        2.9x    0.2 (0.0)       1.1x    3.2 (0.0)
                  0   32        2.6x    0.2 (0.0)       1.1x    3.2 (0.0)
             131072    1        0.9x    0.7 (0.0)       1.0x    3.6 (0.0)
              65536    1        0.9x    0.7 (0.0)       1.0x    3.6 (0.0)
              32768    1        0.9x    0.7 (0.0)       1.0x    3.6 (0.0)
                  0    1        0.9x    0.7 (0.0)       1.0x    3.6 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  360        --    0          --    1.8 (0.0)         --    9.4 (0.0)
             131072   32       15.1x    0.1 (0.0)       1.2x    7.7 (0.0)
              65536   32       13.5x    0.1 (0.0)       1.2x    7.7 (0.0)
              65536   24       11.6x    0.2 (0.0)       1.2x    7.8 (0.0)
             131072   16       11.5x    0.2 (0.0)       1.2x    7.8 (0.0)
              32768   32       11.3x    0.2 (0.0)       1.2x    7.8 (0.0)
              32768   24       10.5x    0.2 (0.0)       1.2x    7.8 (0.0)
             131072   24       10.4x    0.2 (0.0)       1.2x    7.8 (0.0)
              32768   16        8.8x    0.2 (0.0)       1.2x    7.8 (0.0)
              65536   16        8.5x    0.2 (0.0)       1.2x    7.8 (0.0)
             131072    8        6.1x    0.3 (0.0)       1.2x    7.9 (0.1)
              65536    8        5.5x    0.3 (0.0)       1.2x    7.9 (0.0)
              32768    8        5.3x    0.3 (0.0)       1.2x    7.9 (0.0)
                  0    8        4.8x    0.4 (0.1)       1.2x    8.0 (0.1)
                  0   16        3.3x    0.5 (0.1)       1.2x    8.1 (0.1)
                  0   24        3.1x    0.6 (0.0)       1.1x    8.2 (0.0)
                  0   32        2.7x    0.7 (0.0)       1.1x    8.3 (0.0)
             131072    1        0.9x    1.9 (0.0)       1.0x    9.5 (0.0)
              32768    1        0.9x    1.9 (0.0)       1.0x    9.5 (0.0)
              65536    1        0.9x    1.9 (0.0)       1.0x    9.6 (0.0)
                  0    1        0.9x    1.9 (0.0)       1.0x    9.5 (0.0)

THP

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0   16        --    0          --    3.3 (0.0)         --    4.2 (0.0)
              32768   32        7.5x    0.4 (0.0)       4.3x    1.0 (0.0)
             131072   32        7.6x    0.4 (0.0)       4.3x    1.0 (0.0)
              65536   16        7.3x    0.4 (0.0)       4.2x    1.0 (0.0)
              65536   32        7.5x    0.4 (0.0)       4.3x    1.0 (0.0)
             131072   16        7.2x    0.5 (0.0)       4.2x    1.0 (0.0)
              65536   24        7.0x    0.5 (0.0)       4.1x    1.0 (0.0)
             131072   24        6.9x    0.5 (0.0)       4.1x    1.0 (0.0)
              32768   16        6.3x    0.5 (0.0)       3.9x    1.1 (0.0)
              32768   24        5.7x    0.6 (0.0)       3.8x    1.1 (0.0)
              32768    8        5.0x    0.7 (0.0)       3.5x    1.2 (0.0)
              65536    8        5.4x    0.6 (0.0)       3.4x    1.2 (0.1)
             131072    8        5.7x    0.6 (0.0)       3.5x    1.2 (0.1)
                  0   32        2.0x    1.6 (0.1)       1.8x    2.3 (0.1)
                  0   24        1.9x    1.7 (0.0)       1.7x    2.5 (0.1)
                  0   16        1.8x    1.8 (0.3)       1.6x    2.6 (0.3)
                  0    8        1.9x    1.7 (0.3)       1.7x    2.5 (0.3)
                  0    1        1.0x    3.3 (0.0)       1.0x    4.2 (0.0)
             131072    1        1.0x    3.3 (0.0)       1.0x    4.2 (0.0)
              65536    1        1.0x    3.3 (0.0)       1.0x    4.2 (0.0)
              32768    1        1.0x    3.3 (0.0)       1.0x    4.2 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  128        --    0          --   29.5 (0.2)         --   30.5 (0.2)
             131072   24       12.9x    2.3 (0.0)      10.3x    2.9 (0.0)
             131072   32       12.8x    2.3 (0.0)      10.2x    3.0 (0.0)
             131072   16       12.5x    2.4 (0.0)      10.0x    3.0 (0.0)
              65536   24       12.1x    2.4 (0.0)       9.8x    3.1 (0.0)
              65536   32       12.0x    2.4 (0.0)       9.8x    3.1 (0.0)
              65536   16       11.8x    2.5 (0.0)       9.6x    3.2 (0.0)
              32768   24       11.1x    2.7 (0.0)       9.1x    3.3 (0.0)
              32768   32       10.7x    2.7 (0.0)       8.9x    3.4 (0.0)
              32768   16       10.6x    2.8 (0.0)       8.8x    3.5 (0.0)
             131072    8        7.3x    4.0 (0.0)       6.4x    4.8 (0.0)
              65536    8        7.1x    4.2 (0.0)       6.2x    4.9 (0.0)
              32768    8        6.6x    4.4 (0.0)       5.8x    5.2 (0.0)
                  0    8        3.6x    8.1 (0.7)       3.4x    9.0 (0.7)
                  0   32        2.2x   13.6 (1.9)       2.1x   14.5 (1.9)
                  0   16        2.1x   14.0 (3.2)       2.1x   14.8 (3.2)
                  0   24        2.1x   14.1 (3.1)       2.0x   15.0 (3.1)
                  0    1        1.0x   29.6 (0.2)       1.0x   30.6 (0.2)
              32768    1        1.0x   29.6 (0.2)       1.0x   30.7 (0.2)
             131072    1        1.0x   29.7 (0.0)       1.0x   30.7 (0.0)
              65536    1        1.0x   29.8 (0.1)       1.0x   30.8 (0.1)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  360        --    0          --   83.8 (0.6)         --   85.1 (0.6)
             131072   24       13.6x    6.2 (0.0)      12.0x    7.1 (0.0)
             131072   32       13.4x    6.2 (0.0)      11.9x    7.2 (0.0)
              65536   24       12.8x    6.6 (0.1)      11.3x    7.5 (0.1)
             131072   16       12.7x    6.6 (0.0)      11.3x    7.5 (0.0)
              65536   32       12.4x    6.8 (0.0)      11.0x    7.7 (0.0)
              65536   16       11.9x    7.0 (0.0)      10.7x    8.0 (0.0)
              32768   24       11.4x    7.4 (0.0)      10.3x    8.3 (0.0)
              32768   32       11.0x    7.6 (0.0)      10.0x    8.5 (0.0)
              32768   16       10.7x    7.8 (0.0)       9.7x    8.8 (0.0)
             131072    8        7.4x   11.4 (0.0)       6.8x   12.4 (0.0)
              65536    8        7.2x   11.7 (0.0)       6.7x   12.7 (0.0)
              32768    8        6.7x   12.6 (0.1)       6.2x   13.6 (0.1)
                  0    8        3.1x   27.2 (6.1)       3.0x   28.3 (6.1)
                  0   32        2.1x   39.9 (6.4)       2.1x   41.0 (6.4)
                  0   24        2.1x   40.6 (6.6)       2.0x   41.7 (6.6)
                  0   16        2.0x   42.6 (0.1)       1.9x   43.8 (0.1)
             131072    1        1.0x   83.9 (0.5)       1.0x   85.2 (0.5)
              65536    1        1.0x   84.2 (0.3)       1.0x   85.5 (0.3)
              32768    1        1.0x   84.6 (0.1)       1.0x   85.9 (0.1)
                  0    1        1.0x   84.9 (0.1)       1.0x   86.2 (0.1)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16   16        --    0          --    0.6 (0.0)         --    6.1 (0.0)
              65536   32        3.9x    0.1 (0.0)       1.1x    5.5 (0.0)
              32768   32        3.9x    0.1 (0.0)       1.1x    5.6 (0.0)
             131072   24        3.9x    0.1 (0.0)       1.1x    5.6 (0.0)
             131072   32        3.9x    0.1 (0.0)       1.1x    5.5 (0.0)
              65536   24        3.9x    0.1 (0.0)       1.1x    5.6 (0.0)
              32768   24        3.9x    0.1 (0.0)       1.1x    5.6 (0.1)
              65536   16        4.0x    0.1 (0.0)       1.1x    5.6 (0.1)
              32768   16        3.9x    0.1 (0.0)       1.1x    5.6 (0.0)
             131072   16        3.9x    0.1 (0.0)       1.1x    5.6 (0.1)
              65536    8        4.0x    0.1 (0.0)       1.1x    5.6 (0.0)
             131072    8        4.0x    0.1 (0.0)       1.1x    5.7 (0.1)
              32768    8        4.0x    0.1 (0.0)       1.1x    5.6 (0.0)
                  0   32        1.6x    0.4 (0.0)       1.0x    5.9 (0.1)
                  0   24        1.6x    0.4 (0.0)       1.0x    5.9 (0.0)
                  0   16        1.5x    0.4 (0.0)       1.0x    6.0 (0.0)
                  0    8        1.5x    0.4 (0.0)       1.0x    5.9 (0.1)
              65536    1        1.0x    0.6 (0.0)       1.0x    6.1 (0.1)
              32768    1        1.0x    0.6 (0.0)       1.0x    6.1 (0.0)
                  0    1        1.0x    0.6 (0.0)       1.0x    6.2 (0.0)
             131072    1        1.0x    0.6 (0.0)       1.0x    6.2 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  128        --    0          --    5.1 (0.0)         --   44.5 (0.0)
             131072   32       16.5x    0.3 (0.0)       1.1x   40.4 (0.3)
              65536   32       15.7x    0.3 (0.0)       1.1x   40.4 (0.6)
             131072   24       13.9x    0.4 (0.0)       1.1x   39.8 (0.3)
              32768   32       14.1x    0.4 (0.0)       1.1x   40.0 (0.5)
              65536   24       12.9x    0.4 (0.0)       1.1x   39.8 (0.5)
              32768   24       12.2x    0.4 (0.0)       1.1x   40.1 (0.1)
              65536   16        9.6x    0.5 (0.0)       1.1x   40.3 (0.4)
             131072   16        9.7x    0.5 (0.0)       1.1x   40.4 (0.5)
              32768   16        9.2x    0.5 (0.0)       1.1x   40.8 (0.5)
              65536    8        5.5x    0.9 (0.0)       1.1x   40.5 (0.5)
             131072    8        5.5x    0.9 (0.0)       1.1x   40.7 (0.6)
              32768    8        5.2x    1.0 (0.0)       1.1x   40.7 (0.3)
                  0   32        1.6x    3.1 (0.0)       1.0x   43.5 (0.8)
                  0   24        1.6x    3.2 (0.0)       1.0x   42.9 (0.5)
                  0   16        1.5x    3.3 (0.0)       1.0x   43.5 (0.4)
                  0    8        1.5x    3.5 (0.0)       1.0x   43.4 (0.5)
              65536    1        1.0x    5.0 (0.0)       1.0x   44.6 (0.1)
              32768    1        1.0x    5.0 (0.0)       1.0x   44.9 (0.2)
             131072    1        1.0x    5.0 (0.0)       1.0x   44.8 (0.2)
                  0    1        1.0x    5.0 (0.0)       1.0x   44.8 (0.3)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  360        --    0          --   14.4 (0.0)         --  125.4 (0.3)
             131072   32       16.5x    0.9 (0.0)       1.1x  112.0 (0.7)
              65536   32       14.9x    1.0 (0.0)       1.1x  113.3 (1.3)
              32768   32       14.0x    1.0 (0.0)       1.1x  112.6 (1.0)
             131072   24       13.5x    1.1 (0.0)       1.1x  111.3 (0.9)
              65536   24       13.3x    1.1 (0.0)       1.1x  112.3 (0.8)
              32768   24       12.4x    1.2 (0.0)       1.1x  111.1 (0.8)
              65536   16        9.7x    1.5 (0.0)       1.1x  111.5 (0.8)
             131072   16        9.7x    1.5 (0.0)       1.1x  112.1 (1.2)
              32768   16        9.3x    1.5 (0.0)       1.1x  113.2 (0.4)
             131072    8        5.5x    2.6 (0.0)       1.1x  114.8 (1.3)
              32768    8        5.5x    2.6 (0.0)       1.1x  114.1 (1.0)
              65536    8        5.4x    2.6 (0.0)       1.1x  115.0 (3.3)
                  0   32        1.6x    8.8 (0.0)       1.0x  120.7 (0.7)
                  0   24        1.6x    8.9 (0.0)       1.1x  119.4 (0.1)
                  0   16        1.5x    9.5 (0.0)       1.0x  120.1 (0.7)
                  0    8        1.4x   10.1 (0.2)       1.0x  123.6 (1.9)
              32768    1        1.0x   14.3 (0.0)       1.0x  126.2 (0.9)
              65536    1        1.0x   14.3 (0.0)       1.0x  125.4 (0.6)
             131072    1        1.0x   14.3 (0.0)       1.0x  126.5 (1.0)
                  0    1        1.0x   14.3 (0.0)       1.0x  124.7 (1.2)

AMD
~~~

hugetlb

           lockedvm                                    qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0   16        --    0          --    1.1 (0.0)         --    1.5 (0.0)
             131072    8        4.3x    0.2 (0.0)       2.5x    0.6 (0.0)
              65536   16        4.3x    0.2 (0.0)       2.6x    0.6 (0.0)
              65536    8        4.0x    0.3 (0.0)       2.5x    0.6 (0.0)
              65536   24        3.8x    0.3 (0.0)       2.4x    0.6 (0.0)
              32768   32        3.6x    0.3 (0.0)       2.3x    0.6 (0.0)
             131072   32        3.6x    0.3 (0.0)       2.3x    0.6 (0.0)
              65536   32        3.5x    0.3 (0.0)       2.3x    0.6 (0.0)
              32768    8        3.4x    0.3 (0.0)       2.3x    0.7 (0.0)
             131072   24        3.0x    0.3 (0.0)       2.1x    0.7 (0.0)
             131072   16        2.8x    0.4 (0.0)       2.0x    0.8 (0.1)
              32768   16        2.6x    0.4 (0.0)       1.9x    0.8 (0.0)
              32768   24        2.6x    0.4 (0.0)       1.9x    0.8 (0.0)
                  0   32        1.3x    0.8 (0.0)       1.2x    1.2 (0.0)
                  0   24        1.3x    0.8 (0.0)       1.2x    1.3 (0.0)
                  0   16        1.2x    0.9 (0.0)       1.2x    1.3 (0.0)
                  0    8        1.1x    0.9 (0.0)       1.1x    1.4 (0.0)
              32768    1        1.0x    1.1 (0.0)       1.0x    1.5 (0.0)
             131072    1        1.0x    1.1 (0.0)       1.0x    1.5 (0.0)
                  0    1        1.0x    1.1 (0.0)       1.0x    1.5 (0.0)
              65536    1        1.0x    1.1 (0.0)       1.0x    1.5 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  128        --    0          --    9.6 (0.1)         --   10.2 (0.1)
             131072   32        4.5x    2.1 (0.0)       3.9x    2.6 (0.0)
             131072    8        4.4x    2.2 (0.0)       3.7x    2.8 (0.1)
              65536   16        4.3x    2.2 (0.0)       3.6x    2.8 (0.0)
             131072   16        4.2x    2.3 (0.1)       3.6x    2.9 (0.0)
              65536    8        4.1x    2.3 (0.0)       3.6x    2.8 (0.0)
             131072   24        4.1x    2.4 (0.1)       3.5x    3.0 (0.1)
              65536   24        3.8x    2.5 (0.0)       3.4x    3.0 (0.0)
              65536   32        3.8x    2.5 (0.0)       3.3x    3.1 (0.0)
              32768   32        3.6x    2.6 (0.0)       3.3x    3.1 (0.0)
              32768    8        3.3x    2.9 (0.1)       2.9x    3.5 (0.1)
              32768   16        3.2x    3.0 (0.3)       2.9x    3.5 (0.3)
              32768   24        2.5x    3.8 (0.0)       2.3x    4.4 (0.0)
                  0   16        1.2x    7.8 (0.1)       1.2x    8.4 (0.1)
                  0    8        1.2x    8.3 (0.1)       1.1x    8.9 (0.1)
              32768    1        1.0x    9.6 (0.1)       1.0x   10.3 (0.1)
              65536    1        1.0x    9.6 (0.0)       1.0x   10.3 (0.1)
             131072    1        1.0x    9.7 (0.0)       1.0x   10.3 (0.0)
                  0    1        1.0x    9.7 (0.0)       1.0x   10.4 (0.0)
                  0   24        0.9x   10.2 (0.6)       0.9x   10.8 (0.6)
                  0   32        0.9x   10.5 (0.5)       0.9x   11.2 (0.5)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  980        --    0          --   74.1 (0.7)         --   75.7 (0.7)
             131072   16        4.7x   15.9 (0.1)       4.3x   17.4 (0.1)
             131072   24        4.6x   16.0 (0.0)       4.2x   18.1 (0.0)
             131072   32        4.6x   16.3 (0.0)       4.1x   18.4 (0.0)
             131072    8        4.4x   16.9 (0.1)       4.1x   18.5 (0.1)
              65536   16        4.3x   17.1 (0.0)       3.9x   19.2 (0.0)
              65536   24        4.3x   17.4 (0.0)       3.9x   19.5 (0.0)
              65536   32        4.2x   17.7 (0.0)       3.8x   19.9 (0.1)
              65536    8        4.1x   18.2 (0.0)       3.7x   20.4 (0.0)
              32768   24        3.7x   19.8 (0.1)       3.4x   22.0 (0.1)
              32768   16        3.7x   20.2 (0.2)       3.5x   21.8 (0.2)
              32768   32        3.6x   20.4 (0.1)       3.4x   22.5 (0.1)
              32768    8        3.4x   21.6 (0.5)       3.3x   23.1 (0.5)
                  0   16        1.2x   60.4 (0.6)       1.2x   62.0 (0.6)
                  0    8        1.1x   65.3 (1.0)       1.1x   67.6 (1.0)
                  0   24        1.0x   73.1 (2.7)       1.0x   75.4 (2.6)
             131072    1        1.0x   75.0 (0.7)       1.0x   77.3 (0.7)
              65536    1        1.0x   75.4 (0.7)       1.0x   77.7 (0.7)
                  0    1        1.0x   75.6 (0.7)       1.0x   77.8 (0.7)
              32768    1        1.0x   75.8 (0.0)       1.0x   78.0 (0.0)
                  0   32        0.8x   92.9 (1.2)       0.8x   95.3 (1.1)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16   16        --    0          --    0.0 (0.0)         --    0.6 (0.0)
             131072   24        5.6x    0.0 (0.0)       1.0x    0.6 (0.0)
              32768   16        4.6x    0.0 (0.0)       1.0x    0.6 (0.0)
              32768   32        4.8x    0.0 (0.0)       0.9x    0.6 (0.0)
             131072   16        4.6x    0.0 (0.0)       1.0x    0.6 (0.0)
             131072   32        4.3x    0.0 (0.0)       1.0x    0.6 (0.0)
             131072    8        4.5x    0.0 (0.0)       1.0x    0.6 (0.0)
              32768    8        4.4x    0.0 (0.0)       1.0x    0.6 (0.0)
              65536   24        3.7x    0.0 (0.0)       1.0x    0.6 (0.0)
              65536   16        3.2x    0.0 (0.0)       1.0x    0.6 (0.0)
              65536    8        2.8x    0.0 (0.0)       1.0x    0.6 (0.0)
              32768   24        3.0x    0.0 (0.0)       1.0x    0.6 (0.0)
              65536   32        2.6x    0.0 (0.0)       1.0x    0.6 (0.0)
                  0   32        2.1x    0.0 (0.0)       1.0x    0.6 (0.0)
                  0   16        2.3x    0.0 (0.0)       0.9x    0.6 (0.0)
                  0    8        2.2x    0.0 (0.0)       0.9x    0.6 (0.0)
                  0   24        1.2x    0.0 (0.0)       1.0x    0.6 (0.0)
             131072    1        1.0x    0.0 (0.0)       0.9x    0.6 (0.0)
              65536    1        1.0x    0.0 (0.0)       0.9x    0.7 (0.0)
              32768    1        0.8x    0.0 (0.0)       0.9x    0.6 (0.0)
                  0    1        0.9x    0.0 (0.0)       1.0x    0.6 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  128        --    0          --    0.3 (0.0)         --    2.7 (0.0)
             131072   24       10.4x    0.0 (0.0)       1.1x    2.4 (0.0)
              65536   16        8.5x    0.0 (0.0)       1.1x    2.4 (0.0)
              32768   24        7.7x    0.0 (0.0)       1.1x    2.4 (0.0)
              32768   32        7.6x    0.0 (0.0)       1.1x    2.4 (0.0)
              65536   24        6.1x    0.0 (0.0)       1.1x    2.4 (0.0)
             131072   16        5.8x    0.0 (0.0)       1.1x    2.4 (0.0)
             131072   32        5.6x    0.0 (0.0)       1.1x    2.4 (0.0)
              32768    8        5.2x    0.1 (0.0)       1.1x    2.4 (0.0)
              65536   32        4.8x    0.1 (0.0)       1.1x    2.5 (0.0)
              32768   16        4.9x    0.1 (0.0)       1.1x    2.4 (0.0)
             131072    8        4.4x    0.1 (0.0)       1.1x    2.4 (0.0)
              65536    8        4.2x    0.1 (0.0)       1.1x    2.4 (0.0)
                  0    8        2.9x    0.1 (0.0)       1.1x    2.4 (0.0)
                  0   16        2.9x    0.1 (0.0)       1.1x    2.5 (0.0)
                  0   24        2.8x    0.1 (0.0)       1.1x    2.4 (0.0)
                  0   32        1.2x    0.2 (0.0)       1.0x    2.6 (0.0)
              32768    1        1.0x    0.3 (0.0)       1.0x    2.7 (0.0)
             131072    1        1.0x    0.3 (0.0)       1.0x    2.7 (0.0)
              65536    1        1.0x    0.3 (0.0)       1.0x    2.7 (0.0)
                  0    1        0.9x    0.3 (0.0)       1.0x    2.7 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  980        --    0          --    2.0 (0.0)         --   18.2 (0.1)
             131072   32       11.2x    0.2 (0.0)       1.2x   15.7 (0.0)
             131072   16        9.4x    0.2 (0.0)       1.2x   15.7 (0.0)
              65536   24        9.2x    0.2 (0.0)       1.1x   16.3 (0.0)
              65536   16        8.1x    0.3 (0.0)       1.1x   16.4 (0.0)
              32768   16        7.1x    0.3 (0.0)       1.1x   15.8 (0.0)
             131072   24        7.1x    0.3 (0.0)       1.1x   15.8 (0.0)
              65536   32        6.2x    0.3 (0.0)       1.1x   16.4 (0.0)
              65536    8        5.7x    0.4 (0.0)       1.1x   16.5 (0.1)
              32768   32        5.6x    0.4 (0.0)       1.1x   16.5 (0.0)
              32768   24        5.6x    0.4 (0.0)       1.1x   15.9 (0.0)
             131072    8        5.0x    0.4 (0.0)       1.1x   16.0 (0.0)
              32768    8        3.0x    0.7 (0.0)       1.1x   16.3 (0.1)
                  0    8        2.8x    0.7 (0.0)       1.1x   16.2 (0.0)
                  0   16        2.7x    0.8 (0.1)       1.1x   16.9 (0.1)
                  0   24        1.6x    1.2 (0.4)       1.0x   17.4 (0.4)
              32768    1        1.0x    2.1 (0.0)       1.0x   18.1 (0.0)
                  0   32        1.0x    2.1 (0.0)       1.0x   17.7 (0.0)
              65536    1        1.0x    2.1 (0.0)       1.0x   18.2 (0.1)
             131072    1        1.0x    2.1 (0.0)       1.0x   18.3 (0.0)
                  0    1        0.9x    2.2 (0.0)       1.0x   17.7 (0.0)

THP

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0   16        --    0          --    1.2 (0.0)         --    1.7 (0.0)
             131072    8        4.3x    0.3 (0.0)       2.4x    0.7 (0.0)
             131072   32        3.1x    0.4 (0.0)       2.1x    0.8 (0.0)
              65536   16        4.0x    0.3 (0.0)       2.3x    0.7 (0.0)
              65536    8        3.9x    0.3 (0.0)       2.3x    0.7 (0.0)
              65536   24        3.3x    0.4 (0.0)       2.1x    0.8 (0.0)
              65536   32        3.3x    0.4 (0.0)       2.2x    0.8 (0.0)
              32768   16        2.6x    0.5 (0.0)       1.9x    0.9 (0.0)
             131072   24        3.3x    0.4 (0.0)       2.1x    0.8 (0.0)
              32768   32        3.3x    0.4 (0.0)       2.1x    0.8 (0.0)
             131072   16        3.1x    0.4 (0.0)       2.0x    0.8 (0.0)
              32768   24        2.5x    0.5 (0.0)       1.9x    0.9 (0.0)
              32768    8        3.2x    0.4 (0.0)       1.9x    0.9 (0.0)
                  0   24        1.3x    1.0 (0.0)       1.2x    1.4 (0.0)
                  0   32        1.2x    1.0 (0.0)       1.1x    1.5 (0.1)
                  0    8        1.2x    1.0 (0.0)       1.1x    1.5 (0.0)
                  0   16        1.2x    1.0 (0.0)       1.1x    1.5 (0.0)
             131072    1        1.0x    1.2 (0.0)       1.0x    1.7 (0.0)
              65536    1        1.0x    1.2 (0.0)       1.0x    1.7 (0.0)
                  0    1        1.0x    1.2 (0.0)       1.0x    1.7 (0.0)
              32768    1        1.0x    1.2 (0.0)       1.0x    1.7 (0.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  128        --    0          --   10.9 (0.1)         --   11.4 (0.1)
             131072   16        5.0x    2.2 (0.0)       4.3x    2.7 (0.0)
             131072   32        4.8x    2.3 (0.0)       4.2x    2.7 (0.0)
             131072   24        4.6x    2.4 (0.0)       4.1x    2.8 (0.1)
             131072    8        4.7x    2.3 (0.0)       4.1x    2.8 (0.0)
              65536   24        4.4x    2.5 (0.0)       3.9x    2.9 (0.0)
              65536   32        4.1x    2.7 (0.1)       3.7x    3.1 (0.1)
              65536   16        4.1x    2.7 (0.2)       3.7x    3.1 (0.2)
              65536    8        4.0x    2.7 (0.1)       3.6x    3.2 (0.1)
              32768   24        3.8x    2.9 (0.0)       3.4x    3.4 (0.0)
              32768   32        3.6x    3.0 (0.1)       3.3x    3.5 (0.1)
              32768    8        3.5x    3.1 (0.0)       3.2x    3.6 (0.1)
              32768   16        3.3x    3.3 (0.2)       3.1x    3.7 (0.2)
                  0   16        1.3x    8.3 (0.4)       1.3x    8.8 (0.4)
                  0    8        1.2x    8.8 (0.4)       1.2x    9.3 (0.4)
                  0   24        1.1x   10.1 (1.2)       1.1x   10.7 (1.3)
                  0   32        1.1x   10.3 (1.3)       1.1x   10.8 (1.3)
             131072    1        1.0x   10.9 (0.0)       1.0x   11.5 (0.0)
              32768    1        1.0x   11.0 (0.1)       1.0x   11.6 (0.1)
              65536    1        1.0x   11.1 (0.0)       1.0x   11.6 (0.0)
                  0    1        1.0x   11.1 (0.2)       1.0x   11.6 (0.2)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

   0  980        --    0          --   85.3 (0.6)         --   86.1 (0.6)
             131072   16        5.2x   16.4 (0.0)       5.0x   17.1 (0.0)
             131072   24        5.1x   16.7 (0.1)       4.9x   17.4 (0.1)
             131072   32        5.0x   17.1 (0.0)       4.8x   17.8 (0.0)
             131072    8        4.7x   18.3 (0.1)       4.5x   19.0 (0.1)
              65536   16        4.7x   18.3 (0.0)       4.5x   19.0 (0.0)
              65536   24        4.6x   18.5 (0.0)       4.5x   19.2 (0.0)
              65536   32        4.5x   18.8 (0.0)       4.4x   19.6 (0.0)
              65536    8        4.3x   19.6 (0.0)       4.2x   20.4 (0.0)
              32768   16        3.9x   21.6 (0.0)       3.9x   22.4 (0.0)
              32768   24        3.9x   22.1 (0.3)       3.8x   22.8 (0.3)
              32768   32        3.8x   22.4 (0.1)       3.7x   23.1 (0.1)
              32768    8        3.8x   22.7 (0.0)       3.7x   23.5 (0.0)
                  0   16        1.3x   64.6 (2.7)       1.3x   65.4 (2.7)
                  0    8        1.2x   70.0 (2.7)       1.2x   70.8 (2.7)
                  0   32        1.0x   82.4 (5.7)       1.0x   83.2 (5.7)
                  0   24        1.0x   83.4 (6.9)       1.0x   84.1 (6.9)
             131072    1        1.0x   84.2 (0.3)       1.0x   85.0 (0.3)
                  0    1        1.0x   84.8 (1.3)       1.0x   85.6 (1.3)
              65536    1        1.0x   84.9 (0.4)       1.0x   85.7 (0.4)
              32768    1        1.0x   85.6 (1.3)       1.0x   86.4 (1.3)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16   16        --    0          --    0.5 (0.3)         --    6.2 (0.4)
             131072   32        4.9x    0.1 (0.0)       1.1x    5.6 (0.0)
              65536   16        5.1x    0.1 (0.0)       1.1x    5.7 (0.1)
              65536   32        5.0x    0.1 (0.0)       1.1x    5.6 (0.1)
              32768   16        5.0x    0.1 (0.0)       1.1x    5.7 (0.0)
              32768    8        5.8x    0.1 (0.0)       1.1x    5.6 (0.0)
              65536   24        5.7x    0.1 (0.0)       1.1x    5.7 (0.0)
              32768   32        3.9x    0.1 (0.0)       1.0x    5.9 (0.1)
             131072   16        3.7x    0.1 (0.1)       1.0x    6.0 (0.3)
              65536    8        4.0x    0.1 (0.1)       1.1x    5.9 (0.1)
             131072   24        3.6x    0.1 (0.1)       1.0x    5.9 (0.5)
             131072    8        2.5x    0.2 (0.1)       1.0x    6.0 (0.6)
              32768   24        1.7x    0.3 (0.1)       1.0x    6.5 (0.2)
             131072    1        1.8x    0.3 (0.0)       1.1x    5.9 (0.0)
                  0   32        1.6x    0.3 (0.0)       1.0x    6.2 (0.2)
                  0    8        1.0x    0.5 (0.0)       1.0x    6.2 (0.1)
                  0   24        0.9x    0.5 (0.3)       1.0x    6.3 (0.5)
                  0    1        0.9x    0.5 (0.4)       1.0x    6.2 (0.5)
              32768    1        0.8x    0.6 (0.3)       1.0x    6.5 (0.4)
                  0   16        0.7x    0.7 (0.7)       0.9x    6.6 (0.8)
              65536    1        0.6x    0.9 (0.5)       0.9x    6.7 (0.7)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  128        --    0          --    3.4 (0.8)         --   45.5 (1.0)
             131072   32       11.7x    0.3 (0.1)       1.1x   42.1 (0.2)
              65536   16        8.5x    0.4 (0.1)       1.1x   42.1 (0.2)
              32768   32        8.6x    0.4 (0.2)       1.1x   43.0 (0.2)
              65536   32        8.9x    0.4 (0.1)       1.0x   43.6 (0.3)
              32768   24        7.9x    0.4 (0.1)       1.1x   42.3 (0.3)
              32768   16        6.5x    0.5 (0.2)       1.1x   42.5 (0.5)
              65536   24        6.7x    0.5 (0.2)       1.1x   42.6 (0.5)
             131072   24        5.8x    0.6 (0.5)       1.1x   42.5 (0.6)
             131072   16        5.0x    0.7 (0.6)       1.1x   42.4 (0.8)
             131072    8        3.8x    0.9 (0.4)       1.1x   42.7 (0.5)
              65536    8        3.2x    1.1 (0.5)       1.1x   42.9 (0.6)
              32768    8        3.1x    1.1 (0.4)       1.1x   43.3 (1.0)
                  0   32        1.1x    3.0 (0.2)       1.0x   45.1 (0.2)
                  0   24        1.2x    2.9 (0.1)       1.0x   44.6 (0.2)
                  0    8        1.0x    3.5 (1.1)       1.0x   45.5 (1.2)
              32768    1        1.0x    3.6 (0.9)       1.0x   45.5 (0.7)
             131072    1        1.0x    3.5 (1.1)       1.0x   45.6 (1.4)
                  0    1        0.9x    3.6 (0.5)       1.0x   45.6 (0.4)
                  0   16        0.9x    3.6 (0.2)       1.0x   45.7 (0.2)
              65536    1        0.9x    3.6 (1.0)       1.0x   45.8 (1.0)

           lockedvm                                     qemu   qemu
      mem     cache              pin    pin             init   init
qthr  (G)   (pages)  thr     speedup    (s) (std)    speedup    (s) (std)

  16  980        --    0          --   19.6 (0.9)         --  337.9 (0.7)
             131072   32        9.7x    2.0 (0.4)       1.0x  323.0 (0.7)
             131072   24        8.8x    2.2 (0.4)       1.0x  324.6 (0.8)
              65536   32        8.4x    2.3 (0.2)       1.0x  323.1 (0.5)
              32768   24        7.9x    2.5 (0.1)       1.1x  319.4 (1.0)
              65536   24        8.1x    2.4 (0.1)       1.0x  322.3 (0.8)
              32768   32        7.4x    2.6 (0.2)       1.1x  321.2 (0.8)
             131072   16        6.9x    2.8 (0.3)       1.0x  331.0 (8.8)
              65536   16        6.5x    3.0 (0.2)       1.1x  320.4 (0.7)
              32768   16        5.9x    3.3 (0.5)       1.0x  328.3 (1.5)
              65536    8        5.3x    3.7 (0.4)       1.1x  320.8 (1.0)
              32768    8        4.8x    4.1 (0.2)       1.0x  328.9 (0.8)
             131072    8        4.7x    4.1 (0.2)       1.1x  319.4 (0.9)
                  0    8        1.2x   16.9 (0.7)       1.0x  333.9 (3.1)
                  0   32        1.1x   18.0 (0.7)       1.0x  336.1 (0.8)
                  0   24        1.1x   18.0 (1.6)       1.0x  336.7 (1.7)
              65536    1        1.0x   19.0 (0.5)       1.0x  341.0 (0.3)
             131072    1        1.0x   19.7 (1.0)       1.0x  335.7 (1.0)
                  0   16        1.0x   19.8 (1.8)       1.0x  338.8 (1.8)
              32768    1        0.9x   20.7 (1.5)       1.0x  337.6 (1.9)
                  0    1        0.9x   21.3 (1.4)       1.0x  339.5 (1.8)

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index faee849f1cce..c2edc5a4c727 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -651,7 +651,7 @@ static int vfio_wait_all_valid(struct vfio_iommu *iommu)
 static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
 				  unsigned long limit, struct vfio_batch *batch,
-				  struct mm_struct *mm)
+				  struct mm_struct *mm, long *lock_cache)
 {
 	unsigned long pfn;
 	long ret, pinned = 0, lock_acct = 0;
@@ -709,15 +709,25 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			 * the user.
 			 */
 			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-				if (!dma->lock_cap &&
+				if (!dma->lock_cap && *lock_cache == 0 &&
 				    mm->locked_vm + lock_acct + 1 > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
-			}
+				/*
+				 * Draw from the cache if possible to avoid
+				 * taking the write-side mmap_lock in
+				 * vfio_lock_acct(), which will alleviate
+				 * contention with the read-side mmap_lock in
+				 * vaddr_get_pfn().
+				 */
+				if (*lock_cache > 0)
+					(*lock_cache)--;
+				else
+					lock_acct++;
+				}
 
 			pinned++;
 			npage--;
@@ -1507,6 +1517,13 @@ static void vfio_pin_map_dma_undo(unsigned long start_vaddr,
 	vfio_unmap_unpin(args->iommu, args->dma, iova, end, true);
 }
 
+/*
+ * Relieve mmap_lock contention when multithreading page pinning by caching
+ * locked_vm locally.  Bound the locked_vm that a thread will cache but not use
+ * with this constant, which compromises between performance and overaccounting.
+ */
+#define LOCKED_VM_CACHE_PAGES	65536
+
 static int vfio_pin_map_dma_chunk(unsigned long start_vaddr,
 				  unsigned long end_vaddr, void *arg)
 {
@@ -1515,6 +1532,7 @@ static int vfio_pin_map_dma_chunk(unsigned long start_vaddr,
 	dma_addr_t iova = dma->iova + (start_vaddr - dma->vaddr);
 	unsigned long unmapped_size = end_vaddr - start_vaddr;
 	unsigned long pfn, mapped_size = 0;
+	long cache_size, lock_cache = 0;
 	struct vfio_batch batch;
 	long npage;
 	int ret = 0;
@@ -1522,11 +1540,29 @@ static int vfio_pin_map_dma_chunk(unsigned long start_vaddr,
 	vfio_batch_init(&batch);
 
 	while (unmapped_size) {
+		if (lock_cache == 0) {
+			cache_size = min_t(long, unmapped_size >> PAGE_SHIFT,
+					   LOCKED_VM_CACHE_PAGES);
+			ret = vfio_lock_acct(dma, cache_size, false);
+			/*
+			 * More locked_vm is cached than might be used, so
+			 * don't fail on -ENOMEM, i.e. exceeding RLIMIT_MEMLOCK.
+			 */
+			if (ret) {
+				if (ret != -ENOMEM) {
+					vfio_batch_unpin(&batch, dma);
+					break;
+				}
+				cache_size = 0;
+			}
+			lock_cache = cache_size;
+		}
+
 		/* Pin a contiguous chunk of memory */
 		npage = vfio_pin_pages_remote(dma, start_vaddr + mapped_size,
 					      unmapped_size >> PAGE_SHIFT,
 					      &pfn, args->limit, &batch,
-					      args->mm);
+					      args->mm, &lock_cache);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
@@ -1548,6 +1584,7 @@ static int vfio_pin_map_dma_chunk(unsigned long start_vaddr,
 	}
 
 	vfio_batch_fini(&batch);
+	vfio_lock_acct(dma, -lock_cache, false);
 
 	/*
 	 * Undo the successfully completed part of this chunk now.  padata will
@@ -1771,6 +1808,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	struct rb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
+	long lock_cache = 0;
 
 	ret = vfio_wait_all_valid(iommu);
 	if (ret < 0)
@@ -1832,7 +1870,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 							      n >> PAGE_SHIFT,
 							      &pfn, limit,
 							      &batch,
-							      current->mm);
+							      current->mm,
+							      &lock_cache);
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
-- 
2.34.1

