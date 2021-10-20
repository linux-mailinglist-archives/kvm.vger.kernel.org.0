Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063A543533A
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhJTSzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:55:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47202 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230347AbhJTSzk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 14:55:40 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KHvn25019155;
        Wed, 20 Oct 2021 18:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=5HeKJwk4Xkm4yMC6JHnfuYkR3OZolfo170zV9C3tl1Y=;
 b=Bp64VMWrG3QkTaD9Gr03XJHgIA6Db9a+/Nhr5ha8One563AjmW7PbCJrSQM0ik9EXQYb
 FOHhmUIIpCKRR9Ay29OIXQwgA7AZtcKrl4kxxl7r7NPuYSxCwB9jnsPnBrlXYuUNf8Ov
 AY75iX5UsY7ZLtTr1vEzjq/IQn3hJH6tz3e4tm/efMTWf7Wx3/sk+Ylyp0GKvViTVfQl
 7D0uTWldd8ofx7T1OZunt9HZfcOhVku+/b6INmSV+5kMXxIbJwZN/tOwnyPmuh3z6b9W
 QSg1XpcUaWPxA9HgNsF0o51lEIPgpYkfmSUcXuazsHCXUG5jkNc/WpeG7kOK9Gzbuv6O OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypgbmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 18:53:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KIorMI120919;
        Wed, 20 Oct 2021 18:53:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmsgwr0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 18:53:06 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19KIr6ST134042;
        Wed, 20 Oct 2021 18:53:06 GMT
Received: from monad.us.oracle.com (dhcp-10-159-132-124.vpn.oracle.com [10.159.132.124])
        by aserp3030.oracle.com with ESMTP id 3bqmsgwqxu-1;
        Wed, 20 Oct 2021 18:53:06 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 14/14] x86/cpu/intel: set X86_FEATURE_MOVNT_SLOW for Skylake
Date:   Wed, 20 Oct 2021 11:52:55 -0700
Message-Id: <20211020185255.19009-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Tq1cliHmJo0EStHyne1ildEXugGQmY-g
X-Proofpoint-GUID: Tq1cliHmJo0EStHyne1ildEXugGQmY-g
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

System:           Oracle X8-2
CPU:              2 nodes * 26 cores/node * 2 threads/core
                  Intel Xeon Platinum 8270CL (Skylakex, 6:85:7)
Memory:           3TB evenly split between nodes
Microcode:        0x5002f01
scaling_governor: performance
L3 size:          36MB
intel_pstate/no_turbo: 1

  $ for i in 2 8 32 128 512; do
	perf bench mem memset -f x86-64-movnt -s ${i}MB
  done
  # Running 'mem/memset' benchmark:
  # function 'x86-64-movnt' (movnt-based memset() in arch/x86/lib/memset_64.S)
  # Copying 2MB bytes ...
         6.361971 GB/sec
  # Copying 8MB bytes ...
         6.300403 GB/sec
  # Copying 32MB bytes ...
         6.288992 GB/sec
  # Copying 128MB bytes ...
         6.328793 GB/sec
  # Copying 512MB bytes ...
         6.324471 GB/sec

 # Performance comparison of 'perf bench mem memset -l 1' for x86-64-stosb
 # (X86_FEATURE_ERMS) and x86-64-movnt:

              x86-64-stosb (5 runs)     x86-64-movnt (5 runs)      speedup
              -----------------------   -----------------------    -------
     size            BW   (   pstdev)          BW   (   pstdev)

     16MB      20.38 GB/s ( +- 2.58%)     6.25 GB/s ( +- 0.41%)   -69.28%
    128MB       6.52 GB/s ( +- 0.14%)     6.31 GB/s ( +- 0.47%)    -3.22%
   1024MB       6.48 GB/s ( +- 0.31%)     6.24 GB/s ( +- 0.00%)    -3.70%
   4096MB       6.51 GB/s ( +- 0.01%)     6.27 GB/s ( +- 0.42%)    -3.68%

Comparing perf stats for size=4096MB:

$ perf stat -r 5 --all-user -e ... perf bench mem memset -l 1 -s 4096MB -f x86-64-stosb
 # Running 'mem/memset' benchmark:
 # function 'x86-64-stosb' (movsb-based memset() in arch/x86/lib/memset_64.S)
 # Copying 4096MB bytes ...
       6.516972 GB/sec       (+- 0.01%)

 Performance counter stats for 'perf bench mem memset -l 1 -s 4096MB -f x86-64-stosb' (5 runs):

     3,357,373,317      cpu-cycles                #    1.133 GHz                      ( +-  0.01% )  (29.38%)
       165,063,710      instructions              #    0.05  insn per cycle           ( +-  1.54% )  (35.29%)
           358,997      cache-references          #    0.121 M/sec                    ( +-  0.89% )  (35.32%)
           205,420      cache-misses              #   57.221 % of all cache refs      ( +-  3.61% )  (35.36%)
         6,117,673      branch-instructions       #    2.065 M/sec                    ( +-  1.48% )  (35.38%)
            58,309      branch-misses             #    0.95% of all branches          ( +-  1.30% )  (35.39%)
        31,329,466      bus-cycles                #   10.575 M/sec                    ( +-  0.03% )  (23.56%)
        68,543,766      L1-dcache-load-misses     #  157.03% of all L1-dcache accesses  ( +-  0.02% )  (23.53%)
        43,648,909      L1-dcache-loads           #   14.734 M/sec                    ( +-  0.50% )  (23.50%)
           137,498      LLC-loads                 #    0.046 M/sec                    ( +-  0.21% )  (23.49%)
            12,308      LLC-load-misses           #    8.95% of all LL-cache accesses  ( +-  2.52% )  (23.49%)
            26,335      LLC-stores                #    0.009 M/sec                    ( +-  5.65% )  (11.75%)
            25,008      LLC-store-misses          #    0.008 M/sec                    ( +-  3.42% )  (11.75%)

          2.962842 +- 0.000162 seconds time elapsed  ( +-  0.01% )

$ perf stat -r 5 --all-user -e ... perf bench mem memset -l 1 -s 4096MB -f x86-64-movnt
 # Running 'mem/memset' benchmark:
 # function 'x86-64-movnt' (movnt-based memset() in arch/x86/lib/memset_64.S)
 # Copying 4096MB bytes ...
       6.283420 GB/sec      (+- 0.01%)

  Performance counter stats for 'perf bench mem memset -l 1 -s 4096MB -f x86-64-movnt' (5 runs):

     4,462,272,094      cpu-cycles                #    1.322 GHz                      ( +-  0.30% )  (29.38%)
     1,633,675,881      instructions              #    0.37  insn per cycle           ( +-  0.21% )  (35.28%)
           283,627      cache-references          #    0.084 M/sec                    ( +-  0.58% )  (35.31%)
            28,824      cache-misses              #   10.163 % of all cache refs      ( +- 20.67% )  (35.34%)
       139,719,697      branch-instructions       #   41.407 M/sec                    ( +-  0.16% )  (35.35%)
            58,062      branch-misses             #    0.04% of all branches          ( +-  1.49% )  (35.36%)
        41,760,350      bus-cycles                #   12.376 M/sec                    ( +-  0.05% )  (23.55%)
           303,300      L1-dcache-load-misses     #    0.69% of all L1-dcache accesses  ( +-  2.08% )  (23.53%)
        43,769,498      L1-dcache-loads           #   12.972 M/sec                    ( +-  0.54% )  (23.52%)
            99,570      LLC-loads                 #    0.030 M/sec                    ( +-  1.06% )  (23.52%)
             1,966      LLC-load-misses           #    1.97% of all LL-cache accesses  ( +-  6.17% )  (23.52%)
               129      LLC-stores                #    0.038 K/sec                    ( +- 27.85% )  (11.75%)
                 7      LLC-store-misses          #    0.002 K/sec                    ( +- 47.82% )  (11.75%)

           3.37465 +- 0.00474 seconds time elapsed  ( +-  0.14% )

It's unclear if using MOVNT is a net negative on Skylake. For bulk stores
MOVNT is slightly slower than REP;STOSB, but from the L1-dcache-load-misses
stats (L1D.REPLACEMENT), it does elide the write-allocate and thus helps
with cache efficiency.

However, we err on the side of caution and mark Skylake
X86_FEATURE_MOVNT_SLOW.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/kernel/cpu/bugs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4e1558d22a5f..222d6f095da1 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -96,6 +96,21 @@ void check_movnt_quirks(struct cpuinfo_x86 *c)
 	 * to worry about any CONFIG_X86_32 families that don't
 	 * support SSE2/MOVNT.
 	 */
+	if (c->x86_vendor == X86_VENDOR_INTEL) {
+		if (c->x86 == 6) {
+			switch (c->x86_model) {
+			case INTEL_FAM6_SKYLAKE_L:
+				fallthrough;
+			case INTEL_FAM6_SKYLAKE:
+				fallthrough;
+			case INTEL_FAM6_SKYLAKE_X:
+				set_cpu_cap(c, X86_FEATURE_MOVNT_SLOW);
+				break;
+			default:
+				break;
+			}
+		}
+	}
 #endif /* CONFIG_X86_64*/
 }
 
-- 
2.29.2

