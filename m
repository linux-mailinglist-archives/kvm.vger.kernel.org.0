Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EAB3BE814
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhGGMhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:37:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231487AbhGGMha (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:37:30 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167CY0n8065487;
        Wed, 7 Jul 2021 08:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qUBomOGMkaPz4mUsHgGsmORJDgTsyhMG8t1InoNsxBg=;
 b=SdyVfYdWlGqPnqic97Ab45vLW0NXGOzJMOxz9y7tL13ukx34Gs9h3gm2Dp9xyJqGiFDr
 Cr5K8IoovCF1RiN8RY6b9hoffFtdS0cY8uQvPJPjQGGbY8KztvXWYWifXwWdJNRKWn8q
 B4MJdiDfYt2wwPbcIBKpalxzVLvl6fLx43enBhw54fLMhR9O8SAkkD2/+qIkcC27peUp
 IKMiIPB4OW3urMsoF+IctVxJ/Fdl5CSYhLbNctgZieTtDodZl8RzZqZoucHZeJdCzgfs
 WLEhtam+CVK1K2lLLR8FmZGq8DfnUJT4R6BpUAS4te/N2pgYvuJ5zk0AR4ZcTnqhHD2P Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n28675yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:34:09 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167CY9EM066215;
        Wed, 7 Jul 2021 08:34:09 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n28675xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:34:09 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167CIqQN000323;
        Wed, 7 Jul 2021 12:34:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgxpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 12:34:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167CY4IR21758424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 12:34:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1598AE056;
        Wed,  7 Jul 2021 12:34:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCEADAE045;
        Wed,  7 Jul 2021 12:34:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Jul 2021 12:34:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 8E6BEE07F6; Wed,  7 Jul 2021 14:34:03 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     peterz@infradead.org
Cc:     borntraeger@de.ibm.com, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
Subject: [PATCH 1/1] sched/fair: improve yield_to vs fairness
Date:   Wed,  7 Jul 2021 14:34:02 +0200
Message-Id: <20210707123402.13999-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707123402.13999-1-borntraeger@de.ibm.com>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xCn7DVbx7ijO_S1xkjxATaN1uHKmeASW
X-Proofpoint-ORIG-GUID: SMYdEvRWwpuQpkQSdYpaTGcfax00DCxe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After some debugging in situations where a smaller sched_latency_ns and
smaller sched_migration_cost settings helped for KVM host, I was able to
come up with a reduced testcase.
This testcase has 2 vcpus working on a shared memory location and
waiting for mem % 2 == cpu number to then do an add on the shared
memory.
To start simple I pinned all vcpus to one host CPU. Without the
yield_to in KVM the testcase was horribly slow. This is expected as each
vcpu will spin a whole time slice. With the yield_to from KVM things are
much better, but I was still seeing yields being ignored.
In the end pick_next_entity decided to keep the current process running
due to fairness reasons.  On this path we really know that there is no
point in continuing current. So let us make things a bit unfairer to
current.
This makes the reduced testcase noticeable faster. It improved a more
realistic test case (many guests on some host CPUs with overcomitment)
even more.
In the end this is similar to the old compat_sched_yield approach with
an important difference:
Instead of doing it for all yields we now only do it for yield_to
a place where we really know that current it waiting for the target.

What are alternative implementations for this patch
- do the same as the old compat_sched_yield:
  current->vruntime = rightmost->vruntime+1
- provide a new tunable sched_ns_yield_penalty: how much vruntime to add
  (could be per architecture)
- also fiddle with the vruntime of the target
  e.g. subtract from the target what we add to the source

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 kernel/sched/fair.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 23663318fb81..4f661a9ed3ba 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7337,6 +7337,7 @@ static void yield_task_fair(struct rq *rq)
 static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
+	struct sched_entity *curr = &rq->curr->se;
 
 	/* throttled hierarchies are not runnable */
 	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
@@ -7347,6 +7348,16 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
 
 	yield_task_fair(rq);
 
+	/*
+	 * This path is special and only called from KVM. In contrast to yield,
+	 * in yield_to we really know that current is spinning and we know
+	 * (s390) or have good heuristics whom are we waiting for. There is
+	 * absolutely no point in continuing the current task, even if this
+	 * means to become unfairer. Let us give the current process some
+	 * "fake" penalty.
+	 */
+	curr->vruntime += sched_slice(cfs_rq_of(curr), curr);
+
 	return true;
 }
 
-- 
2.31.1

