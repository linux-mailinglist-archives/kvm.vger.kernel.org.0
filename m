Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2505EF79D4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfKKRXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:23:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfKKRXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 12:23:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABHMP3G063050;
        Mon, 11 Nov 2019 17:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=7DYyc0HKUvhmhki/GKWIXwRXBdqmCRZi8t0JYXW172o=;
 b=Cu6DizQr7mrB2x9AYC2mbyI/B67FuRS3Pguz45JWuKT6w2yVbm1v30GR0ZWnBr1xbaOV
 ecBLrRhlf5oCc3ZWQyOhzb2G4rDO5Pf75kzFX7cogsEkT5aznvqhf9cpeAe1ajT2h+xr
 /duWA2Bdci0SYV6AywAuA/2+CuXhzzKi+A0vuaZOvoqMEp9A4ZqRL0q2qkQceI66hzpA
 y1sISo7Oy9AxK2Jsyac7zinrwL7O1iJ5r3+dWlFv84qMBmqfWTcq00AS1MOcxe0eLeJp
 5StJ0n6V7zxqA2nNueW2OEKaQ6Ugoe0tW9KtfOWxKhqjqABIaCicIGcgP0WV343iwMmA qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndq069x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:22:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABHEa9Z136831;
        Mon, 11 Nov 2019 17:20:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w67kmc980-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:20:24 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABHKNmS032343;
        Mon, 11 Nov 2019 17:20:23 GMT
Received: from paddy.uk.oracle.com (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 09:20:22 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: [PATCH v2 0/3] KVM: VMX: Posted Interrupts fixes
Date:   Mon, 11 Nov 2019 17:20:09 +0000
Message-Id: <20191111172012.28356-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=602
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=669 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

This mini-series addresses two bugs plus a small cleanup: 

 1) Considering PID.PIR as opposed to just PID.ON for pending interrupt checks
    in the direct yield code path;
 
 2) Not changing NDST in vmx_vcpu_pi_load(), which addresses a regression. 
    Prior to this, we would observe Win2K12 guests hanging momentarily.
 
 3) Small cleanup to streamline PIR checks with a common helper.

The cleanup is done last to simplify backports.

	Joao

v2:
* Fixed missing Tb/Rb tags;
* Fixed broken Sob chains (on first two patches)
* Only test PID.PIR if PID.SN=1 (third patch)

Joao Martins (3):
  KVM: VMX: Consider PID.PIR to determine if vCPU has pending interrupts
  KVM: VMX: Do not change PID.NDST when loading a blocked vCPU
  KVM: VMX: Introduce pi_is_pir_empty() helper

 arch/x86/kvm/vmx/vmx.c | 21 +++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h | 11 +++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.11.0

