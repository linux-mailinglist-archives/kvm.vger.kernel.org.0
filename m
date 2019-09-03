Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F18AA69BD
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfICNZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 09:25:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33554 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbfICNZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOEr4042572;
        Tue, 3 Sep 2019 13:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ewpAgye3E1YENYXsQuKLPVZrT2BZqpOWcte4zXSaAu8=;
 b=om/BDeOctOz/ZjjyrHuIuC+vuB/rE5VF68is/CgdMSsXCkglWZNBuJzE+oTRXPGwfyBq
 7XAgv453S1jZbySLJ5xiIkkZlEiiH13dJwxM1umJhqQMzF9gpBCnDaVI5J+14Sh2H9IK
 JVCeIhEAwYstvCLt0ia2xI2u2ihgBRbD37SMot+M4z2wN9sNZdBbQxggkYNb4A/DR+ZF
 +vFzu5GMH9eepPi84ZWpmY2zeQBy622iRs5jz/d9bbnY32PMLOxJqud0numBRl+Brpci
 3tdIspeut1/zmywX6c9/l7k7rjD9EVR1/DYdebGE6vW+I8gUjy/EFykp/3+8xFLhNZtG 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2usrw8r1e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOFIe129260;
        Tue, 3 Sep 2019 13:24:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2us5pgutx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x83DOsWH000492;
        Tue, 3 Sep 2019 13:24:54 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 06:24:53 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 0/4] cpuidle, haltpoll: governor switching on idle register
Date:   Tue,  3 Sep 2019 14:24:40 +0100
Message-Id: <20190903132444.11808-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=891
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030142
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

Thoughts, comments appreciated.

Thanks,
	Joao

v2:
* Add missing Fixes tag on patches 3 and 4.

Joao Martins (4):
  cpuidle: allow governor switch on cpuidle_register_driver()
  cpuidle-haltpoll: set haltpoll as preferred governor
  cpuidle-haltpoll: return -ENODEV on modinit failure
  cpuidle-haltpoll: do not set an owner to allow modunload

 drivers/cpuidle/cpuidle-haltpoll.c   |  4 ++--
 drivers/cpuidle/cpuidle.h            |  1 +
 drivers/cpuidle/driver.c             | 26 ++++++++++++++++++++++++++
 drivers/cpuidle/governor.c           |  6 +++---
 drivers/cpuidle/governors/haltpoll.c |  2 +-
 include/linux/cpuidle.h              |  3 +++
 6 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.17.1

