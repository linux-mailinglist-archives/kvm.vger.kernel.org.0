Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90BEF1CFE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732492AbfKFR5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:57:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbfKFR5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:57:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6HsKGa015768;
        Wed, 6 Nov 2019 17:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=uBEGSNLJVxXMk9u64tP8o0TzUbcsZmdPCKdTVcSvJeg=;
 b=Z0gJMfyMXtJfFJvsCCk7dUZmTg2FxtLGV8ypVvVVh/r2U2ssB4M1JSKBCZ7ngUiSP63l
 TdlbQUPyRWyP6ztuSsDxHSmanSKzk6xbmNL7F9k60eduhnRKaZWaIT7iccE3JaaSVlDc
 YgmzhK8+aS0tRuuVYkD+6m3tuE6psYaKTD8q9+MJSVIpzYD/iLCj2feZBsnDdzsIQbEZ
 2GEscujetQ+ao/bCwK0nePNYneRimlznnObMkFA5mFK4rpd19CIKIbJ8giZO/k9rZrRd
 NsJLqYYIBn3R6Wq5a70K9RGXb5XAwtvBzcJhV2944sWfiSDAYu401kbJ6hFTFSuAYuH9 Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w10m56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:56:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Hreox022490;
        Wed, 6 Nov 2019 17:56:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w41wcvewg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:56:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6HuNS0003881;
        Wed, 6 Nov 2019 17:56:24 GMT
Received: from paddy.uk.oracle.com (/10.175.178.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 09:56:23 -0800
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
Subject: [PATCH v1 0/3] KVM: VMX: Posted Interrupts fixes
Date:   Wed,  6 Nov 2019 17:55:59 +0000
Message-Id: <20191106175602.4515-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=600
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=680 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060174
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

Joao Martins (3):
  KVM: VMX: Consider PID.PIR to determine if vCPU has pending interrupts
  KVM: VMX: Do not change PID.NDST when loading a blocked vCPU
  KVM: VMX: Introduce pi_is_pir_empty() helper

 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h | 11 +++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.11.0

