Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60599CD3E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfHZKZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:25:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbfHZKZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:25:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QANsM2180794;
        Mon, 26 Aug 2019 10:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=wE+aQuhohhsLT2Z0OcpD+5HotwrzSl3jHizphpm4ABk=;
 b=scv5mNbjjORLe7jmth49adhP/aICRH5W3vsJ/onOBV+fJ4FJzsyOSg1kcERTPZVQKzbv
 QSa1btA3tEx6RUxywBPeFj7AdKLlFEasSP0RogUh+FjVTlFdAjJPBr6BU6PgKNFvQfB8
 9xmkh39IaBzUtwIdZ+W9bySie1QBL+dAruLU/QX5+ZZhNkLlyGI5riAcA4RSR9byrS3V
 EU2dBE2eCs681+BBbrsQTFM8pnpd44x6PAwH+zuNsVlwpoOUeewyTu/XQSS3IedqURho
 Jf01aqBXBoonOzEgFjpx0YzH6C+IHJr7KovmpMZ6E/kQ0J65Z36907A67Q4g8fBxtbSw iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ujw700523-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:25:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QANW9G000788;
        Mon, 26 Aug 2019 10:25:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ujw79csj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:25:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QAP9Wt001547;
        Mon, 26 Aug 2019 10:25:09 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 10:25:09 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com
Subject: [PATCH 0/2]: KVM: x86: Fix INIT signal handling in various CPU states
Date:   Mon, 26 Aug 2019 13:24:47 +0300
Message-Id: <20190826102449.142687-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=902
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series aims to fix how KVM handles INIT signal in various CPU
states.

1st patch just introduce a new exit-reason that should be reported to
guest in case vCPU runs in VMX non-root mode and INIT signal is
received.

The 2nd patch is the fix itself. For more information, refer to
commit message of patch.

I have also writen kvm-unit-tests to verify this code. I will
submit it as a separate patch-series.

Regards,
-Liran


