Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805F0699AE6
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBPRNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPRNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BA24E5CE
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:03 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GF7WJ1018237
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=QpTHR2ZOWZwdlMf0y7OHKOAR6pZArI1zA+1S5YDI9YU=;
 b=Js/ddu5+gB3c8gptH4Dx4m3S8UTzD/9md3TQEVSc3lvgtm1auXBsWXx7yr7B5+JP7Q/j
 L4mYPEcErj84/+ppTyfCPQs0hxtCDpcciMIR16vk+6DWiEzzvLZ1/1iZgfa5NbBt0Yf5
 Lzy9bAEC0jwRo72heZ08dFcCyCkBJh1MUdx4ZJFGPkLMWu9Jjm7j5eKN2yFjvpuXjT6N
 IaPhA5NVfeCH3HekLwClxIGyhGoqjDa0YjXwHLXBIjwgp6or+hPQWVZNzhEATje3Zcia
 +Xc7xqyGUaCjhQaSFxO13AYqFLNJO0YbNLzwS3K+0CR7quOy57XLi296wQYsyZIlsVjz VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nskd8s386-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GF7YQ5018368
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nskd8s37f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:02 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G0ujpA022275;
        Thu, 16 Feb 2023 17:13:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3np29fd52b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCvBU35651846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E88520043;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44DE12004B;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 08/10] lib: s390x: sie: Set guest memory pointer
Date:   Thu, 16 Feb 2023 18:12:53 +0100
Message-Id: <20230216171255.48799-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216171255.48799-1-imbrenda@linux.ibm.com>
References: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4LeZM5PP1FpIWyVTPEyFaRAXLiKorwhF
X-Proofpoint-ORIG-GUID: sL71eJcqb0M2favuxRF6N9S9MQs4XWuo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Seems like it was introduced but never set. It's nicer to have a
pointer than to cast the MSO of a VM.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230112154548.163021-6-frankja@linux.ibm.com
Message-Id: <20230112154548.163021-6-frankja@linux.ibm.com>
---
 lib/s390x/sie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index a71985b6..9241b4b4 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -93,6 +93,7 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 
 	/* Guest memory chunks are always 1MB */
 	assert(!(guest_mem_len & ~HPAGE_MASK));
+	vm->guest_mem = (uint8_t *)guest_mem;
 	/* For non-PV guests we re-use the host's ASCE for ease of use */
 	vm->save_area.guest.asce = stctg(1);
 	/* Currently MSO/MSL is the easiest option */
-- 
2.39.1

