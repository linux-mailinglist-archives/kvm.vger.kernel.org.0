Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A614C1056
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbiBWKfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 05:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiBWKfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 05:35:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73151674DD
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 02:34:53 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N9Cdps004525
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PpJSMSOT9djok2PkLNLEWRXr2KZB8F0HVsuthEQAgcc=;
 b=gOeQewcvp//yZI+KG6HNeUx46YueGK91y9nS+EB7lmylMuP25lIle/GJYQO97Abvmza5
 m+Klsa0HydzKNKGW0Xo4gs6KL/crZFqQ1RqDbtUm5I2HCqeAo+wJCzEIX5Z9TZKk5UH6
 M7oKg++9cPB8bJm0O8i/6pSSCUFhzyumDoURyz6wqnKJU2hBNxVJTqqc5MPsUhuBx9H7
 bEIiJZ74xwcC/gqnLCAFJs05LGx/oMUSskmo6zNaCy18kEREERZS9/7jDEOpCnVuavOw
 KQFSF06kN3N1i0XCyg6Da1lN0vwjIozEelMQuCb/o6jVrwy3K/3Yw7p1mxGZmjzhULYJ 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edj3fsk2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:34:52 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NA0FQB020645
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 10:34:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edj3fsk29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:34:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NAWSuI026204;
        Wed, 23 Feb 2022 10:34:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ear697kq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:34:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NAYlWX44761498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 10:34:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00123A4070;
        Wed, 23 Feb 2022 10:34:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1E15A406B;
        Wed, 23 Feb 2022 10:34:46 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 10:34:46 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests RFC PATCH 0/1] Detecting crashes in TAP output
Date:   Wed, 23 Feb 2022 11:34:45 +0100
Message-Id: <20220223103446.2681293-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EMR05esBJBuGbpw8fH_gY6hxxK35j_-W
X-Proofpoint-ORIG-GUID: s42us3yfs0-qNL9z1Yq2bK06yeki_aqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_03,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=959
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I recently had a test on s390x which caused an exception in the guest. As
expected, run_tests.sh reported it as failing:

    FAIL sometest (1 tests)

However, when I turn on the TAP output everything looks like it is fine:

    TAP version 13
    ok 1 - sometest: sometest: some report
    1..1

There is no way to see from the TAP output the test actually had an unexpected
exception. Our internal scripts rely on the TAP output and will thus believe
everything is fine, even though it really isn't.

In the logfile, one can at least see the exception backtrace, but if something
exits silently, there is no indication something went wrong there either.

TAP provides the test plan (the "1..1") as a solution to this problem. It
gives the expected number of test lines if all tests would run. The harness can
count test lines in TAP output and compare this to the number of tests in the
plan and report an error if it doesn't match.

This won't work with kvm-unit-tests, since there really isn't any way to know
how many report()s and thus test lines you will have without actually running
the tests.

That's why I came up with an alternative approach in the patch below. It
adds an additional test line to the TAP output and the logfiles which
states the overall result of a test.

With the attached patch, the TAP output of the test above will now look like
this:

    TAP version 13
    ok 1 - sometest: sometest: some report
    not ok 2 - sometest: (1 tests)
    1..2

This shows something went wrong.

Your feedback or alternative solutions to this problem are welcome.

Nico Boehr (1):
  scripts/runtime: add test result to log and TAP output

 scripts/runtime.bash | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.31.1

