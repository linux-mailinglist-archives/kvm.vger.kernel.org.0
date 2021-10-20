Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A8D4350F6
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhJTRIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50728 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231200AbhJTRIM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:12 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGHwX9029734;
        Wed, 20 Oct 2021 17:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=FoaNTSoBuTx1QJCJRqBZ4DKv9jeEYfJqcRpDlexPldw=;
 b=ewnZFbrzfRdjcy9Da9ELvg0+sMOc7dG4sCimaZW1eJBJimhiK617lcesH6BhS7arIA28
 srDwxe0Cf6jVqgcYbgOlYUcdEYMG4Ref7oWKO04slQ2NCOnQogbLd+3SIf6/zvNUtvQE
 be/C/qoP14bh6c2wnDdG6MdtGGIBHkWIYXq32Q4a1BwLG37YZ4CLuKu5YOSGI1CdAIaI
 HiapuL+nHAlvvHuViGu+FDv+3eC0Aoa/8AcYYr8rplo6ZqxonXHpRJpq7PKCmkMylfTd
 c2DyBHVuJrXu8S3+tH7HWtZBOUQPzFfgUv0kDS4UYHxHwhL+sRbO48cLF/hvUJvR8YRB 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj1b8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGurhQ024723;
        Wed, 20 Oct 2021 17:05:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 3bqmsgs3ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=algjdDwIfxqilY+PFCg1oQ5p5DBl8NuSIJvvSz6vHXj6TZK50GPMfvwcTFPtVc77hG6CqJbE6hsGBp+V3Wcb9CznTz15WkGVSuLFgYkU0pKCD0owjndTf5SmRvWwx04F4B3Prn9173mORwcoLUL9GgH+moVbBabcrzILm7Wi8ZNYtVKHFD4akVThHaBGa3uy7O/ZlBrrg97RaiBxRt/Dbn61nsYoVrTdLX5my4HGMfH93sAMlYyVfUoH7SDWhB/H3OUBDMZNFgUABtnfqkZW4+OFMoDDNapq7uBpSruJL0mPq3Y54ndungou28DYQ2JXT5a3zan64oMtK1mCZ/4fcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoaNTSoBuTx1QJCJRqBZ4DKv9jeEYfJqcRpDlexPldw=;
 b=N0/7kBOZRHXAyI9D2RnXXsxlrTbyJiUZ3Q3en7uxK6WUDFV7Me3i0t8m/eHZTvPceyn+7sZQyd4xyL6SK77DAdurqXiEiFdNtbvdyo2ohw6seidi4vlklwzOkckHVYr5YcmxVHcuuV98Re+0N9EnxXEI7lja5TERYWAKq/MoId/0no2GJiWuYmoBJmHzSSlWh2o2nFfvgJGf/N78zNgSth7WqrKJqyVsei9DtfVZqUXBC3x/I+Qe2T7oqvl4mKsxUQexPTBNZJKHkZpl8r6m4TP6djKRBbBA193WkOafmaMaoGyP2O0rJsNDXh8H9ojQ8Xo62NQkYJoRUq6ggtmr5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FoaNTSoBuTx1QJCJRqBZ4DKv9jeEYfJqcRpDlexPldw=;
 b=KeHP7FLCENw66GP+1BRv18W+Y+yPwNJwJCSWkeQC/Xc51GkfQK2etlX0WuHlTOR8Wvz9ZXqhVrOLcf1MFmcirP8/IIDrYJJh8uRBEYw8cuJIdpQ6kySPNbyEWJFg22UUr4Qisw7FL4pSDENsvMvAfNxVGWbRIE301TLsqLhdgDM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:44 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:44 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 12/14] gup: use uncached path when clearing large regions
Date:   Wed, 20 Oct 2021 10:03:03 -0700
Message-Id: <20211020170305.376118-13-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0370.namprd04.prod.outlook.com
 (2603:10b6:303:81::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW4PR04CA0370.namprd04.prod.outlook.com (2603:10b6:303:81::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:05:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f1db659-0c67-4432-bad9-08d993ebda63
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB457701A018E77286EF08665DCEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?q1yAhQqnk9CHQDM9DOC988T8/4sHGxfTBpa7xGwcbU7BB74x9seG+G1EzlMD?=
 =?us-ascii?Q?gAPT2h06fuCGg2BJ59lcO6JiZh+/7zuA956m3DkAlFq8he847o7vYOcVuCS0?=
 =?us-ascii?Q?QpSEbeEizGz07SUpvrNjEGBa8cSY4+4Zh3BaQ+JzwoYUIH0uGKIt0rnK6ZfS?=
 =?us-ascii?Q?xm9zIHTDzrqxL68oTbsN8PPD0IK6WdUczANWnBkR7eLY4f65D5of6SoNN+e+?=
 =?us-ascii?Q?1Yx/84rB5w9COBDR+DxX0jQdoZCwkGSG1Ep2GCzG88pmzdQCDZjqEbo8LW9T?=
 =?us-ascii?Q?kODLHlSzmLWYm7cJ4mBApUjjCXBKRiXoqDTURQrXPHOwT68XK2AZ+31zIXrR?=
 =?us-ascii?Q?IwBW9ih9c1h45neuBGTSE6e8Dic2uEUWSnv0KTd2qhJJS7WNco1MRFXV4Mto?=
 =?us-ascii?Q?1FcS4T6FtwZkUhVOjKV1uadaL+D9aQy/UFT9M7bB4ErFVR/OxkulAM9bES9z?=
 =?us-ascii?Q?1uHJ6ml2VPA8/jQCvaY8aImoYbonul1eTQeR0vW2Z0gduc+PlmWiHzVcKTLr?=
 =?us-ascii?Q?pfWGt5gDOCuZNI9Vg9+Or8lOqxbnHeAACWK9wZK7F31t7dNMnoQWTxEwpFY1?=
 =?us-ascii?Q?t74Bwiv4gyuF9nqZ5G4BM7a3as2sy2+7c0/l08mlYCUrvqdV+s2WQOnEQ2aJ?=
 =?us-ascii?Q?ZbVwPXw/QkSZODeShTPXrATeImkcl/ubC7pzlE9AdOaA0bprDnKas66qBCcy?=
 =?us-ascii?Q?EK/KGbFx8WQg3R/DsPPrCrsVR+gDs9LoI36pJOlW3VlkGeTAWII1qoKna2W8?=
 =?us-ascii?Q?t0mGvkhl8bNcn80RAU4wTtcIXu2haN8fGnJjEJqDIkT/Uu66T3h1GYjSOK2k?=
 =?us-ascii?Q?8iUWNA11HJLVuwxpoSMpLSg5PLzK4CqgPyo5/g2X+ZMEGIKiTvxPlUAr+3b2?=
 =?us-ascii?Q?6KmzbNYLXfS0fardH14KsOjLv3ckWdbBN06xm8m+D0H9afUG2Ng0+CzACx1u?=
 =?us-ascii?Q?kkq/+VyiehDpAxJYHdXdWXGki5yHzXHw9PjAvhv/jn3glJJgVtYqBaGKcmcQ?=
 =?us-ascii?Q?DYTbKjWutapmxEUayitl7FEkPfZsisSIRH1KWkzPjHIJkVs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(30864003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pYk/LLhy9XcQOJM+ORsB9/z+5Mozj3NsluEDv3dVqJtFq66HUAQWps5Gd3n5?=
 =?us-ascii?Q?OiyAayNTEmaDNEhyCiKZoh8CkMnS6D1QVGqiKWiRNUtsW5kZwSTNmhK8RQ5z?=
 =?us-ascii?Q?rm4CkyN0psdfuTwz32XJDWHL87ruMhS8B9Kl39CCogbRpZpdzYWMxp/YuB5P?=
 =?us-ascii?Q?19MpXL8svYgo/7D0ZlCXbmCE/Ir0UNyftBXU23M5REjFjIqlUbG0X8rqsfN0?=
 =?us-ascii?Q?6GhhG6Q/0PVHh7UbaSPz7l7cqfWkVxCLIZy4fjmdy2ZfEa5zz7WrPEBbK5bF?=
 =?us-ascii?Q?v8Rt/lDCIIwhINZyUQMr+j0mFpJciFu4GmXWGzk4iM6nCvHvqGf1xUrQ9QZL?=
 =?us-ascii?Q?0v7Q8NW202cNzAoa7wIdDd5DGLJZ/8d0CLlyIH3X4R4oK/iIrko7D+tLhD7I?=
 =?us-ascii?Q?Sh+amW5sAZKaJPmSRdOFK+7SHVOFNwFrsfqReSbocwzdmMFzP92B9VXJ2Vev?=
 =?us-ascii?Q?ez7pO5Dc2GdYlDmSK/UzEwJOc/Yo8bifhuzZVgYrXqRQcfr3EeW/MoQi55Ee?=
 =?us-ascii?Q?Dsh2j6hUuFMoRM3foGTkcxzDF9Qu4TP8PBBmqOA/bx2Sjn5LvPxCpLsAG1RI?=
 =?us-ascii?Q?sb9bCBnXTbDI9WljlhCUkmG4lRJFhoNdvA82Ul2N+2trGhV8HYYsVdCyUnyV?=
 =?us-ascii?Q?gP3LWLqBaehnOZ1g9T2D3Wm79GVsfjya96zIwrBAwoQJBKjfDkt1l5dxhECT?=
 =?us-ascii?Q?Cc4qzSYUQd69fowI2/FCU5rkGYB4qG5wmnHV8z7Z0AN4e3m+fqgI6QhSxVvp?=
 =?us-ascii?Q?y2mWo+ispLkOR+H5Bap4xiL4588tNxgZz10UNavG9UWf2b3sfF1Nz48WEEPA?=
 =?us-ascii?Q?STl3Id5d+42yX4HrvlF+f/wKjs6RgqG9bEeN2pueHX6lHp6loAN++j+I7CA5?=
 =?us-ascii?Q?JnZuphaJvfirZPitKY++kDKaGTDLRtitVu/vxVLCuyZcw6Wyzb+V8YilSV42?=
 =?us-ascii?Q?EeXgqulGDgm3Y7/7HrPsPhAUxW0aspIKO8OA1FcjBZ1qz/wA/n1Eb5jbTZ7p?=
 =?us-ascii?Q?qufU0m78AhiBbQU2TObFRcH8spMawqbo5/8FU9JsR8eV1YDu5gT5sfbxLpd1?=
 =?us-ascii?Q?AJn6Xnn376Muzcb6GY35SE2W6iowglpBGDsf04nmBbT22UiarsS1RPuAYucl?=
 =?us-ascii?Q?ZWeCdMde7rm2WSQcWSg9HeBoQehY7Ht4BW+ZWKpALEwXD2iCpGszhx/FbIWV?=
 =?us-ascii?Q?uINbTujOFu7/kcS03bkd7InISmZyeD++7I3wVzlDvOmsxSwD0MYzPH3IGRLq?=
 =?us-ascii?Q?/PYV7A4e+46vPD99tsgqdKKmZWUswEFagQNMbzBIqkrQnjKo2oSNcipnRyx2?=
 =?us-ascii?Q?O8pfIOJVz1IZvo9kYrVzIyo2u5o7Rrm2xKMK6vx1LoSRxINFehKm7tiecW7A?=
 =?us-ascii?Q?3eNny9c6i6Xj1/X5M/iDGsDT/RgYRRtUjsQb49IUgHqEiFWnUjDg3ad+ZBdr?=
 =?us-ascii?Q?X3Fcg6fxkVD3WIqfo5plOTpR+596ywct?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1db659-0c67-4432-bad9-08d993ebda63
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:44.2810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200095
X-Proofpoint-ORIG-GUID: ZszxLX3Hg5isEak-i03V8si5xKxi4TrX
X-Proofpoint-GUID: ZszxLX3Hg5isEak-i03V8si5xKxi4TrX
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When clearing a large region, or when the user explicitly specifies
via FOLL_HINT_BULK that a call to get_user_pages() is part of a larger
region, take the uncached path.

One notable limitation is that this is only done when the underlying
pages are huge or gigantic, even if a large region composed of PAGE_SIZE
pages is being cleared. This is because uncached stores are generally
weakly ordered and need some kind of store fence -- which would need
to be done at PTE write granularity to avoid data leakage. This would be
expensive enough that it would negate any performance advantage.

Performance
====

System:    Oracle E4-2C (2 nodes * 64 cores * 2 threads) (Milan)
Processor: AMD EPYC 7J13 64-Core
Memory:    2048 GB evenly split between nodes
LLC-size:  32MB for each CCX (8-core * 2-threads)
boost: 0, Microcode: 0xa001137, scaling-governor: performance

System:    Oracle X9-2 (2 nodes * 32 cores * 2 threads) (Icelake)
Processor: Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz
Memory:    512 GB evenly split between nodes
LLC-size:  48MB for each node (32-cores * 2-threads)
no_turbo: 1, Microcode: 0xd0001e0, scaling-governor: performance

Workload: qemu-VM-create
==

Create a large VM, backed by preallocated 2MB pages.
(This test needs a minor change in qemu so it mmap's with
MAP_POPULATE instead of demand faulting each page.)

 Milan,     sz=1550 GB, runs=3   BW           stdev     diff
                                 ----------   ------    --------
 baseline   (clear_page_erms)     8.05 GBps     0.08
 CLZERO   (clear_page_clzero)    29.94 GBps     0.31    +271.92%

 (VM creation time decreases from 192.6s to 51.7s.)

 Icelake, sz=200 GB, runs=3      BW           stdev     diff
                                 ----------   ------    ---------
 baseline   (clear_page_erms)     8.25 GBps     0.05
 MOVNT     (clear_page_movnt)    21.55 GBps     0.31    +161.21%

 (VM creation time decreases from 25.2s to 9.3s.)

As the diff shows, for both these micro-architectures there's a
significant speedup with the CLZERO and MOVNT based interfaces.

Workload: Kernel build with background clear_huge_page()
==

Probe the cache-pollution aspect of this commit with a kernel
build (make -j 15 bzImage) alongside a background clear_huge_page()
load which does mmap(length=64GB, flags=MAP_POPULATE|MAP_HUGE_2MB)
in a loop.

The expectation -- assuming the kernel build performance is partly
cache limited -- is that the background load of clear_page_erms()
should show a greater slowdown, than clear_page_movnt() or
clear_page_clzero().
The build itself does not use THP or similar, so any performance changes
are due to the background load.

  # Milan, compile.sh internally tasksets to a CCX
  # perf stat -r 5  -e task-clock -e cycles -e stalled-cycles-frontend \
    -e stalled-cycles-backend -e instructions -e branches              \
    -e branch-misses -e L1-dcache-loads -e L1-dcache-load-misses       \
    -e cache-references -e cache-misses -e all_data_cache_accesses     \
    -e l1_data_cache_fills_all  -e l1_data_cache_fills_from_memory     \
    ./compile.sh

      Milan               kernel-build[1]          kernel-build[2]            kernel-build[3]
                          (bg: nothing)            (bg:clear_page_erms())     (bg:clear_page_clzero())
  -----------------     ---------------------      ----------------------     ------------------------
  run time              280.12s     (+- 0.59%)     322.21s     (+- 0.26%)     307.02s     (+- 1.35%)
  IPC                     1.16                       1.05                       1.14
  backend-idle            3.78%     (+- 0.06%)       4.62%     (+- 0.11%)       3.87%     (+- 0.10%)
  cache-misses           20.08%     (+- 0.14%)      20.88%     (+- 0.13%)      20.09%     (+- 0.11%)
  (% of cache-refs)
  l1_data_cache_fills-   2.77M/sec  (+- 0.20%)       3.11M/sec (+- 0.32%)       2.73M/sec (+- 0.12%)
   _from_memory

From the backend-idle stats in [1], the kernel build is only mildly
memory subsystem bound. However, there's a small but clear effect where
the background load of clear_page_clzero() does not leave much of an
imprint on the kernel-build in [3] -- both [1] and [3] have largely
similar IPC, memory and cache behaviour. OTOH, the clear_page_erms()
workload in [2] constrains the kernel-build more.

(Fuller perf stat output, at [1], [2], [3].)

  # Icelake, compile.sh internally tasksets to a socket
  # perf stat -r 5 -e task-clock -e cycles -e stalled-cycles-frontend \
    -e stalled-cycles-backend -e instructions -e branches             \
    -e branch-misses -e L1-dcache-loads -e L1-dcache-load-misses      \
    -e cache-references -e cache-misses -e LLC-loads                  \
    -e LLC-load-misses ./compile.sh

  Icelake               kernel-build[4]         kernel-build[5]            kernel-build[6]
                        (bg: nothing)           (bg:clear_page_erms())     (bg:clear_page_movnt())
  -----------------     -----------------       ----------------------     -----------------------

  run time              135.47s  (+- 0.25%)     136.75s  (+- 0.23%)        135.65s  (+- 0.15%)
  IPC                     1.81                    1.80                       1.80
  cache-misses           21.68%  (+- 0.42%)      22.88%  (+- 0.87%)         21.19%  (+- 0.51%)
  (% of cache-refs)
  LLC-load-misses        35.56%  (+- 0.83%)      37.44%  (+- 0.99%)         33.54%  (+- 1.17%)

From the LLC-load-miss and the cache-miss numbers, clear_page_erms()
seems to cause some additional cache contention in the kernel-build in
[5], compared to [4] and [6]. However, from the IPC and the run time
numbers, looks like the CPU pipeline compensates for the extra misses
quite well.
(Increasing the number of make jobs to 60, did not change the overall
picture appreciably.)

(Fuller perf stat output, at [4], [5], [6].)

[1] Milan, kernel-build

  Performance counter stats for './compile.sh' (5 runs):

      2,525,721.45 msec task-clock                #    9.016 CPUs utilized            ( +-  0.06% )
 4,642,144,895,632      cycles                    #    1.838 GHz                      ( +-  0.01% )  (47.38%)
    54,430,239,074      stalled-cycles-frontend   #    1.17% frontend cycles idle     ( +-  0.16% )  (47.35%)
   175,620,521,760      stalled-cycles-backend    #    3.78% backend cycles idle      ( +-  0.06% )  (47.34%)
 5,392,053,273,328      instructions              #    1.16  insn per cycle
                                                  #    0.03  stalled cycles per insn  ( +-  0.02% )  (47.34%)
 1,181,224,298,651      branches                  #  467.572 M/sec                    ( +-  0.01% )  (47.33%)
    27,668,103,863      branch-misses             #    2.34% of all branches          ( +-  0.04% )  (47.33%)
 2,141,384,087,286      L1-dcache-loads           #  847.639 M/sec                    ( +-  0.01% )  (47.32%)
    86,216,717,118      L1-dcache-load-misses     #    4.03% of all L1-dcache accesses  ( +-  0.08% )  (47.35%)
   264,844,001,975      cache-references          #  104.835 M/sec                    ( +-  0.03% )  (47.36%)
    53,225,109,745      cache-misses              #   20.086 % of all cache refs      ( +-  0.14% )  (47.37%)
 2,610,041,169,859      all_data_cache_accesses   #    1.033 G/sec                    ( +-  0.01% )  (47.37%)
    96,419,361,379      l1_data_cache_fills_all   #   38.166 M/sec                    ( +-  0.06% )  (47.37%)
     7,005,118,698      l1_data_cache_fills_from_memory #    2.773 M/sec                    ( +-  0.20% )  (47.38%)

            280.12 +- 1.65 seconds time elapsed  ( +-  0.59% )

[2] Milan, kernel-build (bg: clear_page_erms() workload)

 Performance counter stats for './compile.sh' (5 runs):

      2,852,168.93 msec task-clock                #    8.852 CPUs utilized            ( +-  0.14% )
 5,166,249,772,084      cycles                    #    1.821 GHz                      ( +-  0.05% )  (47.27%)
    62,039,291,151      stalled-cycles-frontend   #    1.20% frontend cycles idle     ( +-  0.04% )  (47.29%)
   238,472,446,709      stalled-cycles-backend    #    4.62% backend cycles idle      ( +-  0.11% )  (47.30%)
 5,419,530,293,688      instructions              #    1.05  insn per cycle
                                                  #    0.04  stalled cycles per insn  ( +-  0.01% )  (47.31%)
 1,186,958,893,481      branches                  #  418.404 M/sec                    ( +-  0.01% )  (47.31%)
    28,106,023,654      branch-misses             #    2.37% of all branches          ( +-  0.03% )  (47.29%)
 2,160,377,315,024      L1-dcache-loads           #  761.534 M/sec                    ( +-  0.03% )  (47.26%)
    89,101,836,173      L1-dcache-load-misses     #    4.13% of all L1-dcache accesses  ( +-  0.06% )  (47.25%)
   276,859,144,248      cache-references          #   97.593 M/sec                    ( +-  0.04% )  (47.22%)
    57,774,174,239      cache-misses              #   20.889 % of all cache refs      ( +-  0.13% )  (47.24%)
 2,641,613,011,234      all_data_cache_accesses   #  931.170 M/sec                    ( +-  0.01% )  (47.22%)
    99,595,968,133      l1_data_cache_fills_all   #   35.108 M/sec                    ( +-  0.06% )  (47.24%)
     8,831,873,628      l1_data_cache_fills_from_memory #    3.113 M/sec                    ( +-  0.32% )  (47.23%)

           322.211 +- 0.837 seconds time elapsed  ( +-  0.26% )

[3] Milan, kernel-build + (bg: clear_page_clzero() workload)

 Performance counter stats for './compile.sh' (5 runs):

      2,607,387.17 msec task-clock                #    8.493 CPUs utilized            ( +-  0.14% )
 4,749,807,054,468      cycles                    #    1.824 GHz                      ( +-  0.09% )  (47.28%)
    56,579,908,946      stalled-cycles-frontend   #    1.19% frontend cycles idle     ( +-  0.19% )  (47.28%)
   183,367,955,020      stalled-cycles-backend    #    3.87% backend cycles idle      ( +-  0.10% )  (47.28%)
 5,395,577,260,957      instructions              #    1.14  insn per cycle
                                                  #    0.03  stalled cycles per insn  ( +-  0.02% )  (47.29%)
 1,181,904,525,139      branches                  #  453.753 M/sec                    ( +-  0.01% )  (47.30%)
    27,702,316,890      branch-misses             #    2.34% of all branches          ( +-  0.02% )  (47.31%)
 2,137,616,885,978      L1-dcache-loads           #  820.667 M/sec                    ( +-  0.01% )  (47.32%)
    85,841,996,509      L1-dcache-load-misses     #    4.02% of all L1-dcache accesses  ( +-  0.03% )  (47.32%)
   262,784,890,310      cache-references          #  100.888 M/sec                    ( +-  0.04% )  (47.32%)
    52,812,245,646      cache-misses              #   20.094 % of all cache refs      ( +-  0.11% )  (47.32%)
 2,605,653,350,299      all_data_cache_accesses   #    1.000 G/sec                    ( +-  0.01% )  (47.32%)
    95,770,076,665      l1_data_cache_fills_all   #   36.768 M/sec                    ( +-  0.03% )  (47.30%)
     7,134,690,513      l1_data_cache_fills_from_memory #    2.739 M/sec                    ( +-  0.12% )  (47.29%)

            307.02 +- 4.15 seconds time elapsed  ( +-  1.35% )

[4] Icelake, kernel-build

 Performance counter stats for './compile.sh' (5 runs):

           421,633      cs                        #  358.780 /sec                     ( +-  0.04% )
      1,173,522.36 msec task-clock                #    8.662 CPUs utilized            ( +-  0.14% )
 2,991,427,421,282      cycles                    #    2.545 GHz                      ( +-  0.15% )  (82.42%)
 5,410,090,251,681      instructions              #    1.81  insn per cycle           ( +-  0.02% )  (91.13%)
 1,189,406,048,438      branches                  #    1.012 G/sec                    ( +-  0.02% )  (91.05%)
    21,291,454,717      branch-misses             #    1.79% of all branches          ( +-  0.02% )  (91.06%)
 1,462,419,736,675      L1-dcache-loads           #    1.244 G/sec                    ( +-  0.02% )  (91.06%)
    47,084,269,809      L1-dcache-load-misses     #    3.22% of all L1-dcache accesses  ( +-  0.01% )  (91.05%)
    23,527,140,332      cache-references          #   20.020 M/sec                    ( +-  0.13% )  (91.04%)
     5,093,132,060      cache-misses              #   21.682 % of all cache refs      ( +-  0.42% )  (91.03%)
     4,220,672,439      LLC-loads                 #    3.591 M/sec                    ( +-  0.14% )  (91.04%)
     1,501,704,609      LLC-load-misses           #   35.56% of all LL-cache accesses  ( +-  0.83% )  (73.10%)

           135.478 +- 0.335 seconds time elapsed  ( +-  0.25% )

[5] Icelake, kernel-build + (bg: clear_page_erms() workload)

 Performance counter stats for './compile.sh' (5 runs):

           410,611      cs                        #  347.771 /sec                     ( +-  0.02% )
      1,184,382.84 msec task-clock                #    8.661 CPUs utilized            ( +-  0.08% )
 3,018,535,155,772      cycles                    #    2.557 GHz                      ( +-  0.08% )  (82.42%)
 5,408,788,104,113      instructions              #    1.80  insn per cycle           ( +-  0.00% )  (91.13%)
 1,189,173,209,515      branches                  #    1.007 G/sec                    ( +-  0.00% )  (91.05%)
    21,279,087,578      branch-misses             #    1.79% of all branches          ( +-  0.01% )  (91.06%)
 1,462,243,374,967      L1-dcache-loads           #    1.238 G/sec                    ( +-  0.00% )  (91.05%)
    47,210,704,159      L1-dcache-load-misses     #    3.23% of all L1-dcache accesses  ( +-  0.02% )  (91.04%)
    23,378,470,958      cache-references          #   19.801 M/sec                    ( +-  0.03% )  (91.05%)
     5,339,921,426      cache-misses              #   22.814 % of all cache refs      ( +-  0.87% )  (91.03%)
     4,241,388,134      LLC-loads                 #    3.592 M/sec                    ( +-  0.02% )  (91.05%)
     1,588,055,137      LLC-load-misses           #   37.44% of all LL-cache accesses  ( +-  0.99% )  (73.09%)

           136.750 +- 0.315 seconds time elapsed  ( +-  0.23% )

[6] Icelake, kernel-build + (bg: clear_page_movnt() workload)

 Performance counter stats for './compile.sh' (5 runs):

           409,978      cs                        #  347.850 /sec                     ( +-  0.06% )
      1,174,090.99 msec task-clock                #    8.655 CPUs utilized            ( +-  0.10% )
 2,992,914,428,930      cycles                    #    2.539 GHz                      ( +-  0.10% )  (82.40%)
 5,408,632,560,457      instructions              #    1.80  insn per cycle           ( +-  0.00% )  (91.12%)
 1,189,083,425,674      branches                  #    1.009 G/sec                    ( +-  0.00% )  (91.05%)
    21,273,992,588      branch-misses             #    1.79% of all branches          ( +-  0.02% )  (91.05%)
 1,462,081,591,012      L1-dcache-loads           #    1.241 G/sec                    ( +-  0.00% )  (91.05%)
    47,071,136,770      L1-dcache-load-misses     #    3.22% of all L1-dcache accesses  ( +-  0.03% )  (91.04%)
    23,331,268,072      cache-references          #   19.796 M/sec                    ( +-  0.05% )  (91.04%)
     4,953,198,057      cache-misses              #   21.190 % of all cache refs      ( +-  0.51% )  (91.04%)
     4,194,721,070      LLC-loads                 #    3.559 M/sec                    ( +-  0.10% )  (91.06%)
     1,412,414,538      LLC-load-misses           #   33.54% of all LL-cache accesses  ( +-  1.17% )  (73.09%)

           135.654 +- 0.203 seconds time elapsed  ( +-  0.15% )

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 fs/hugetlbfs/inode.c |  7 ++++++-
 mm/gup.c             | 20 ++++++++++++++++++++
 mm/huge_memory.c     |  2 +-
 mm/hugetlb.c         |  9 ++++++++-
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cdfb1ae78a3f..44cee9d30035 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -636,6 +636,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	loff_t hpage_size = huge_page_size(h);
 	unsigned long hpage_shift = huge_page_shift(h);
 	pgoff_t start, index, end;
+	bool hint_uncached;
 	int error;
 	u32 hash;
 
@@ -653,6 +654,9 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	start = offset >> hpage_shift;
 	end = (offset + len + hpage_size - 1) >> hpage_shift;
 
+	/* Don't pollute the cache if we are fallocte'ing a large region. */
+	hint_uncached = clear_page_prefer_uncached((end - start) << hpage_shift);
+
 	inode_lock(inode);
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
@@ -731,7 +735,8 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			error = PTR_ERR(page);
 			goto out;
 		}
-		clear_huge_page(page, addr, pages_per_huge_page(h));
+		clear_huge_page(page, addr, pages_per_huge_page(h),
+				hint_uncached);
 		__SetPageUptodate(page);
 		error = huge_add_to_page_cache(page, mapping, index);
 		if (unlikely(error)) {
diff --git a/mm/gup.c b/mm/gup.c
index 886d6148d3d0..930944e0c6eb 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -933,6 +933,13 @@ static int faultin_page(struct vm_area_struct *vma,
 		 */
 		fault_flags |= FAULT_FLAG_TRIED;
 	}
+	if (*flags & FOLL_HINT_BULK) {
+		/*
+		 * From the user hint, we might be faulting-in a large region
+		 * so minimize cache-pollution.
+		 */
+		fault_flags |= FAULT_FLAG_UNCACHED;
+	}
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
 	if (ret & VM_FAULT_ERROR) {
@@ -1100,6 +1107,19 @@ static long __get_user_pages(struct mm_struct *mm,
 	if (!(gup_flags & FOLL_FORCE))
 		gup_flags |= FOLL_NUMA;
 
+	/*
+	 * Uncached page clearing is generally faster when clearing regions
+	 * sized ~LLC/2 or thereabouts. So hint the uncached path based
+	 * on clear_page_prefer_uncached().
+	 *
+	 * Note, however that this get_user_pages() call might end up
+	 * needing to clear an extent smaller than nr_pages when we have
+	 * taken the (potentially slower) uncached path based on the
+	 * expectation of a larger nr_pages value.
+	 */
+	if (clear_page_prefer_uncached(nr_pages * PAGE_SIZE))
+		gup_flags |= FOLL_HINT_BULK;
+
 	do {
 		struct page *page;
 		unsigned int foll_flags = gup_flags;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ffd4b07285ba..2d239967a8a1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -600,7 +600,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 	pgtable_t pgtable;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	vm_fault_t ret = 0;
-	bool uncached = false;
+	bool uncached = vmf->flags & FAULT_FLAG_UNCACHED;
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a920b1133cdb..35b643df5854 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4874,7 +4874,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
-	bool uncached = false;
+	bool uncached = flags & FAULT_FLAG_UNCACHED;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5503,6 +5503,13 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				 */
 				fault_flags |= FAULT_FLAG_TRIED;
 			}
+			if (flags & FOLL_HINT_BULK) {
+				/*
+				 * From the user hint, we might be faulting-in a large
+				 * region so minimize cache-pollution.
+				 */
+				fault_flags |= FAULT_FLAG_UNCACHED;
+			}
 			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
 			if (ret & VM_FAULT_ERROR) {
 				err = vm_fault_to_errno(ret, flags);
-- 
2.29.2

