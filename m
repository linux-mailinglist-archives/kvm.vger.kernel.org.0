Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C376D6CA2
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbjDDSvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjDDSvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:51:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85433588
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:50:58 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334Ho1hB020784;
        Tue, 4 Apr 2023 18:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=WSGbwrXUn2mmsC0XQpPiLUid1Oyd9tyqG3XNS83s0hk=;
 b=VviS+9lc9xIARmv7zLUdCJQ6/cZT4IUQ227A1VZCM9ciXzXwpCZcaGtD6fajpNQ5AZqv
 btdDe5jtFb9xA8cZqI8Xrw8PaWGYoPUEf+9qHoUT8+ecicxG4KtQcRn+sTMIIPOVWsur
 gHD6D5Y1GlxzmW7HFnIMq69h4lH28DLzcdUd3odXtsIo3TivJuGk4qyWsRLBNZHlHZB9
 na4PN9s7qq7c4LOaKRXE/mpB0Vh/NHYSyP2JCDh3H2vMyc2UKAr47AKo184xS0qQ8QPM
 VaS/vmD+WID4RrHA8XZ1JzvGgHk7taS8x9eANb/ywUI6NQAZjmGkg0b70XZu6hr+ItQ/ gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prrn01fg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:55 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334Iaoq1024244;
        Tue, 4 Apr 2023 18:50:55 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prrn01ff9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3340jPGU009260;
        Tue, 4 Apr 2023 18:50:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2qax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334Iopa523593676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 18:50:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDE6D20043;
        Tue,  4 Apr 2023 18:50:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B361E20040;
        Tue,  4 Apr 2023 18:50:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 18:50:50 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Andrew Jones <andrew.jones@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/3] Improve stack pretty printing
Date:   Tue,  4 Apr 2023 20:50:44 +0200
Message-Id: <20230404185048.2824384-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: himtX2RjEAVvAllqg6OK5WBiKVigvSqT
X-Proofpoint-GUID: lyJNlXcOMIHUdTCXD3V2yKWfoL8r9ryS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_10,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=971
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040168
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I noticed some bugs/deficiencies in the pretty_print_stacks script.
Namely, it doesn't cope with 0 addresses, which might occur on s390x
when backtracing through a interrupt stack frame. Since an interrupt is
not a function call, the calling convention doesn't apply and we cannot
tell where the stack is.

Additionally, the script stops printing the stack if addr2line cannot
determine the line number, instead of skipping the printing of the
source.

Lastly, the file path determination was broken for me because I use git
worktrees and there being symlinks in the paths.
The proposed change works for me and fixes the issue.
I HAVE NOT TESTED THIS ON OTHER PLATFORMS/OSes, so I don't know if the code
is portable.

v1 -> v2
 * Cc kvm list (get_maintainers.pl doesn't list it for the file)
 * pick up Tested-by (thanks Thomas)

Nina Schoetterl-Glausch (3):
  pretty_print_stacks: prevent invalid address arguments
  pretty_print_stacks: support unknown line numbers
  pretty_print_stacks: modify relative path calculation

 scripts/pretty_print_stacks.py | 35 ++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)


base-commit: 5b5d27da2973b20ec29b18df4d749fb2190458af
-- 
2.37.2

