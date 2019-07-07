Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372AF60CEF
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 23:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfGEVHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 17:07:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfGEVHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 17:07:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L3vPY025585;
        Fri, 5 Jul 2019 21:06:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=bJXeKOcF+TXIe3UVh8CqtegBOh7vgPVZcG5BmVQ7yYo=;
 b=lxvSAqcyHOyvap1hgeVAXdOQJwkuhzOJQ5byYPPrkz1FN46j49qsuSeFmYFfarc3OiAP
 v3xCAiARWGXMUB+FYAmBWfZki/+EqH4fBIizVCVF4OJW09IgK+VTD5iq16Jj8f4faVAg
 PYI1UV/lmmhFkSNwfmXd5jYlWOtbZIDX7kvqLTauablF+WVq+xjcg5b7Yc4JtyreDbm/
 H6sV6GRAKlPlwacBTfcKoU1mOWixifdJhNafEqBrIIUW8fZ6e2IZZ3zR9Faj5eqr0CiT
 XY8DhgPrt1rTVLIiTNxyu/Ayl+DlJmVdkYocsK9ILniSAVId6oDpidPbl6mv3nWy2iNt jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2te5tc4j6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:06:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L2X1t107403;
        Fri, 5 Jul 2019 21:06:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2thxrvm47h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:06:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65L6tgQ030839;
        Fri, 5 Jul 2019 21:06:56 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 14:06:55 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 0/4] target/i386: kvm: Various nested-state fixes
Date:   Sat,  6 Jul 2019 00:06:32 +0300
Message-Id: <20190705210636.3095-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050266
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050266
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series is just a bunch of small fixes to recent QEMU nested-state
migration support.

1st and 2nd patch can be considered as trivial refactoring patches.

3rd patch fixes a bug of requiring to save VMX nested-state when it is
not needed.

4rd patch removes migration blocker when vCPU is exposed with VMX and
instead demand nested migration kernel capabilities only when vCPU may
have enabled VMX. To provide for better backwards-compatible migration
scenarios. For more info, refer to relevant commit message.

Thanks,
-Liran

