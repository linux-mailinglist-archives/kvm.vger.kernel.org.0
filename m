Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E5117BBE0
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCFLm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:42:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbgCFLm6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:42:58 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026BdqUB123878
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:42:57 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yk4jpyrc1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:57 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:54 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026BgqHp59310254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4240D42041;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 195C242047;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 0/7] tools/kvm_stat: add logfile support
Date:   Fri,  6 Mar 2020 12:42:43 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20030611-4275-0000-0000-000003A8F1EF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-4276-0000-0000-000038BE045B
Message-Id: <20200306114250.57585-1-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_03:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=906
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 clxscore=1011 spamscore=0 suspectscore=1 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series provides a couple of new options to make logging to
files feasible.
Specifically, we add command line switches to specify an arbitrary time
interval for logging, and to toggle between a .csv and the previous
file format. Furthermore, we allow logging to files, where we utilize a
rotating set of 6 logfiles, each with its own header for easy post-
processing, especially when using .csv format.
Since specifying logfile size limits might be a non-trivial exercise,
we're throwing in yet another command line option that allows to
specify the minimum timeframe that should be covered by logs.
Finally, there's a minimal systemd unit file to deploy kvm_stat-based
logging in Linux distributions.
Note that the decision to write our own logfiles rather than to log to
e.g. systemd journal is a conscious one: It is effectively impossible to
write csv records into the systemd journal, the header will either
disappear after a while or has to be repeated from time to time, which
defeats the purpose of having a .csv format that can be easily post-
processed, etc.
See individual patch description for further details.


Stefan Raspl (7):
  tools/kvm_stat: rework command line sequence and message texts
  tools/kvm_stat: switch to argparse
  tools/kvm_stat: add command line switch '-s' to set update interval
  tools/kvm_stat: add command line switch '-c' to log in csv format
  tools/kvm_stat: add rotating log support
  tools/kvm_stat: add command line switch '-T'
  tools/kvm_stat: add sample systemd unit file

 tools/kvm/kvm_stat/kvm_stat         | 434 +++++++++++++++++++++-------
 tools/kvm/kvm_stat/kvm_stat.service |  15 +
 tools/kvm/kvm_stat/kvm_stat.txt     |  59 ++--
 3 files changed, 384 insertions(+), 124 deletions(-)
 create mode 100644 tools/kvm/kvm_stat/kvm_stat.service

-- 
2.17.1

