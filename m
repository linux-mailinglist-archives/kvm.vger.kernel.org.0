Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F0B79C7
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbfISMwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:52:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbfISMwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:52:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnVKU151063;
        Thu, 19 Sep 2019 12:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=Yy1xBvxcpFEBS2osp67zPm6WU06C8m2M9p0BlIWsEbA=;
 b=FPCOUs+zlcmEvQlZJGR+nO8irbP43kNfAJMmGOmlU769H1d/cNrALPZuso+DdEqGqRKb
 t8DowOGy1sPIQi/GNV4azc2PKeDDuifENLgdM/BAOEwQABq6wazxMhM5/oey63R2K4kK
 eVfGi74AEYxoYp8tDwAhvhonIZheSl4h66gQCUrH5gtmMr9M5EVe6/IJEPJu45dPrYHW
 7aSYk33O9MC6rR4rHT/8nzpaM3idRNle7eC+wCjBFQTlixsw+Y6271CsXfmj4U2rknW5
 Nw97G+pBVoLfVFt2iSq9yaQ6Sf+Ee5OvI/cFB6t7MDy+IGvxSvyxtcxPBUDmE94x+fEi NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v3vb4kpt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCmC2N178710;
        Thu, 19 Sep 2019 12:52:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v3vbs1kbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8JCqQGv012161;
        Thu, 19 Sep 2019 12:52:26 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:26 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com
Subject: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in various CPU VMX states
Date:   Thu, 19 Sep 2019 15:52:03 +0300
Message-Id: <20190919125211.18152-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=961 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series aims to add a vmx test to verify the functionality
introduced by KVM commit:
4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")

The test verifies the following functionality:
1) An INIT signal received when CPU is in VMX operation
  is latched until it exits VMX operation.
2) If there is an INIT signal pending when CPU is in
  VMX non-root mode, it result in VMExit with (reason == 3).
3) Exit from VMX non-root mode on VMExit do not clear
  pending INIT signal in LAPIC.
4) When CPU exits VMX operation, pending INIT signal in
  LAPIC is processed.

In order to write such a complex test, the vmx tests framework was
enhanced to support using VMX in non BSP CPUs. This enhancement is
implemented in patches 1-7. The test itself is implemented at patch 8.
This enhancement to the vmx tests framework is a bit hackish, but
I believe it's OK because this functionality is rarely required by
other VMX tests.

Regards,
-Liran


