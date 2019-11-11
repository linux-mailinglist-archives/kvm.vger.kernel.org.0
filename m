Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3C9F704D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 10:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKKJRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 04:17:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKJRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 04:17:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB9EKQd066873;
        Mon, 11 Nov 2019 09:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=03zTnro/aWw9SqBuIjuhI8TAe/31sLbeZimtP650p0c=;
 b=cPX4W/3W/cToXmXNYXm9VOxP3ahgWMAQ1s1RGewFcfBWNYhg4N7A7xByUCjzzs5cfrVL
 +AnrJbkKtHWO35vjX6295fZY6eMSmMN/rA8FAIJs0jlkG5ECe8FWWAKfILksVOpRCKUN
 e/4Euy22idfY64Xwsy8BS4ATXnycEY51vrGKZMZFzVnm74+Mls1pl8jyjnIe8Gzrud58
 3nmJlnDfdtIJjAGaMoSL3ehixSVFrZo0uwwLtisV2fSa3UH8e1z+RSYY5Qx4F96LJcQG
 Ug5fvbfPFPZB6cl1pRdSE5lD0OSy3TAmyWZBjgEUxZt2aCjs6iZYY8+xB7v8TKqWD49s PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvtdtd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:17:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB9Dx7I025793;
        Mon, 11 Nov 2019 09:17:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w6r8j20jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:17:00 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAB9Gxo6032360;
        Mon, 11 Nov 2019 09:17:00 GMT
Received: from localhost.localdomain (/77.139.185.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 01:16:59 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com
Subject: [PATCH 0/2]  KVM: x86: Fix userspace API regarding latched init
Date:   Mon, 11 Nov 2019 11:16:38 +0200
Message-Id: <20191111091640.92660-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=826
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=893 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
This patch series aims to fix 2 issue in KVM userspace API regarding latched init.

1st patch makes sure that userspace can get/set latched_init state
regardless of if vCPU is in SMM state.

2nd patch prevents userspace from setting vCPU in INIT_RECEIVED/SIPI_RECEIVED
state in case vCPU is in a state that latch INIT signals.

For further information, refer to patches commit messages.

Regards,
-Liran

