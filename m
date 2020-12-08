Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1252D3503
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgLHVL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:11:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgLHVL7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 16:11:59 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8L3YvX124516
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 16:11:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=NUKTl7y3bzATptUYlxKPLeunh5t4ViwNFw7VQPU2MUg=;
 b=NWiMM7J6+OXuyg0WfY+fIkH1V3M/MIodNybKzWmbQyclVmS/E/yAEnenONU30WNbJkc+
 UYER2ak0aDV+768bT4LvC0YpjmGZaSBcC9yksYzfvIMV5Nt3o3KmjisJxD3JSorDjtD0
 sZvxHM3T12ZpJQIYcujfc+ftMnzVkYQlmyIKv0DASkitpeZUzGwUkdToncU0HYKRp+ZL
 x+eon6i/an/o22lVCX1HidjUE56wvAs9Yr7QlOfXSsdCubLvwRylnti12hJZkSJ8ltic
 tVo9yk0b1YqAbcG4NVYAYDIlyK5csQxQwjTOXZY8jmBSdxLxImfGdxze7XGyNBU2ijmO Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359s0s9uxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 16:11:17 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B8L5Ix5139378
        for <kvm@vger.kernel.org>; Tue, 8 Dec 2020 16:11:17 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359s0s9uwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 16:11:17 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8L86Z4007820;
        Tue, 8 Dec 2020 21:11:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8nt3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 21:11:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8L8gZ752625740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 21:08:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6225A405F;
        Tue,  8 Dec 2020 21:08:42 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9030BA4054;
        Tue,  8 Dec 2020 21:08:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 21:08:42 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, pbonzini@redhat.com
Subject: [PATCH] tools/kvm_stat: Exempt time-based counters
Date:   Tue,  8 Dec 2020 22:08:29 +0100
Message-Id: <20201208210829.101324-1-raspl@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_15:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1011 mlxlogscore=940 lowpriorityscore=0
 suspectscore=1 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012080126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

The new counters halt_poll_success_ns and halt_poll_fail_ns do not count
events. Instead they provide a time, and mess up our statistics. Therefore,
we should exclude them.
Removal is currently implemented with an exempt list. If more counters like
these appear, we can think about a more general rule like excluding all
fields name "*_ns", in case that's a standing convention.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Tested-and-reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index d199a3694be8..b0bf56c5f120 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -742,7 +742,11 @@ class DebugfsProvider(Provider):
         The fields are all available KVM debugfs files
 
         """
-        return self.walkdir(PATH_DEBUGFS_KVM)[2]
+        exempt_list = ['halt_poll_fail_ns', 'halt_poll_success_ns']
+        fields = [field for field in self.walkdir(PATH_DEBUGFS_KVM)[2]
+                  if field not in exempt_list]
+
+        return fields
 
     def update_fields(self, fields_filter):
         """Refresh fields, applying fields_filter"""
-- 
2.17.1

