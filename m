Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447733BE812
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhGGMhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:37:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231452AbhGGMha (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:37:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167CXr5A100912;
        Wed, 7 Jul 2021 08:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dpgIKtDcn8zrecEuBSEe1Ts+6aPIYw5UAjR+mQFVNKo=;
 b=Ch75lnsoXqtWSgNYIkyodTJtc64/w4/bbMLW9Uq2rJYiGTT1myR+NPPxtCziK4DeWhVe
 sG9+KLN1j+BaVQzCVuzAQlLAmTbIB12NOSIqNHc4xjc7WoufllNiPTLoa21kREj4qirr
 6iMmzldcyhZ1SVLn5mkSs71DU697foyMssrB0Y6Hc0DjBe9qQKJpHRpluTt8cXEEV5UA
 uPhy41fKYpI+ina7TDOL9fAY7Oo3lWMzeZyDDeQy7phJXf9yFnUrZ2blSuaM9qtPdsR7
 6bI13H61jntzxJgG7Xrky2e6BLzxSVv3HyHsrJ3xa5JrxqFekROfo+diKhS+dx1u3XuD Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n28jf2j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:34:09 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167CY95i101949;
        Wed, 7 Jul 2021 08:34:09 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n28jf2h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:34:08 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167CI8Fl029258;
        Wed, 7 Jul 2021 12:34:06 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9rad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 12:34:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167CWC0E31588798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 12:32:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B809611C052;
        Wed,  7 Jul 2021 12:34:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3CF411C04C;
        Wed,  7 Jul 2021 12:34:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Jul 2021 12:34:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 4C591E07F4; Wed,  7 Jul 2021 14:34:03 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     peterz@infradead.org
Cc:     borntraeger@de.ibm.com, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
Subject: [PATCH 0/1] Improve yield (was: sched: Move SCHED_DEBUG sysctl to debugfs)
Date:   Wed,  7 Jul 2021 14:34:01 +0200
Message-Id: <20210707123402.13999-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Uy4gkWTNOJy0ybSoKjspsd4ECeo2iRLs
X-Proofpoint-ORIG-GUID: ocIIzvYN2ltTj-8JPMka8KdU9wHs2rop
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxlogscore=830
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I did a reduced testcase and assuming that the reduced testcase has the
same issue, it turns out that a lower sched_migration_cost_ns does not
solve a specific problem, instead it seems to make a different problem
less problematic. In the end the problem seemed to be worse on KVM hosts
(guest changes did also help but much less so). In the end what did help
was to improve the behaviour of yield_to from KVM.
See the patch for more details. The problem seems to be real, my
solution might not be the best one - I am open for better ways to
code things.
