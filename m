Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D99ACA08
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2019 01:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393691AbfIGXsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 19:48:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33276 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfIGXsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 19:48:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87NkxF5070522;
        Sat, 7 Sep 2019 23:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=a1Q/cZrBiYqtJgS1w+MNIlqMTk5J3IGv7ywqLf6HB3E=;
 b=rtj5kdv9FDAGURwQWvLJJDOOwwEDaK/sugbUq8/XcHoumftrrtaZWH+67Waa+qftYRso
 gK+XHItOhb6e0CaXtxiUf8+3fus3LF1IZ/elkjNI2TQuxkAUtb6YIjEc2RZtTq1ws8Kt
 ICA2PgJ7afEXkdrUAPv9dGUJnzUdmb8/uQliMiXOP8TaocWCgvFlgezSL3WajmuHMomf
 qhUJwooU69X0NKx933YiknFhORlfTaUtORNppOXZtm2AgL67Z2/yOK/Z6vuJDcKg8sAF
 1vpIckVgBZsvZ3pblLwbwM8q4aV3uhiybb6g5zqTibSgYlPFEDiQeCD9AQT0dbepecaQ MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uvpg28026-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:47:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87NhCmn145447;
        Sat, 7 Sep 2019 23:45:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2uve9bcsqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:45:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87NjsqO013728;
        Sat, 7 Sep 2019 23:45:54 GMT
Received: from paddy.uk.oracle.com (/10.175.163.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 16:45:53 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 0/4] cpuidle, haltpoll: governor switching on idle register
Date:   Sun,  8 Sep 2019 00:45:20 +0100
Message-Id: <20190907234524.5577-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070260
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=967 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070260
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

Presented herewith a series with aims to tie in together the haltpoll
idle driver and governor, without sacrificing previous governor setups.
In addition, there are a few fixes with respect to module loading for
cpuidle-haltpoll. 

The series is organized as follows:

 Patch 1: Allows idle driver stating a preferred governor that it
          wants to use, based on discussion here:

  https://lore.kernel.org/kvm/457e8ca1-beb3-ca39-b257-e7bc6bb35d4d@oracle.com/

 Patch 2: Decrease rating of governor, and allows previous defaults
	  to be as before haltpoll, while using @governor to switch to haltpoll
	  when haltpoll driver is registered;

 Patch 3 - 4: Module loading fixes. first is the incorrect error
	      reporting and second is supportting module unloading.

Thanks,
	Joao

v3:
* Fixed ARM build issues.

v2:
* Add missing Fixes tag on patches 3 and 4.

Joao Martins (4):
  cpuidle: allow governor switch on cpuidle_register_driver()
  cpuidle-haltpoll: set haltpoll as preferred governor
  cpuidle-haltpoll: return -ENODEV on modinit failure
  cpuidle-haltpoll: do not set an owner to allow modunload

 drivers/cpuidle/cpuidle-haltpoll.c   |  4 ++--
 drivers/cpuidle/cpuidle.h            |  2 ++
 drivers/cpuidle/driver.c             | 25 +++++++++++++++++++++++++
 drivers/cpuidle/governor.c           |  7 ++++---
 drivers/cpuidle/governors/haltpoll.c |  2 +-
 include/linux/cpuidle.h              |  3 +++
 6 files changed, 37 insertions(+), 6 deletions(-)

-- 
2.17.1

