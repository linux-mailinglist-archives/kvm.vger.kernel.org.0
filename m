Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF801EC37E
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgFBUKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 16:10:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgFBUKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 16:10:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JvxMj163024;
        Tue, 2 Jun 2020 20:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=Zy+9hIUOD1wHoEjv0iqcOdN6XDgnng/gMIII196nKXk=;
 b=z+tGXNWXcpe4kITTBT32god173s9pokQEK6VzOFsdQ3siX5keWyR1QMHN2W70Ff8C+B+
 rxDToZRd+1zqTyC8u7HAggP6i0MWWS1eFES8BEs89ChlGn/sNu3YsWQNVQEBTjR3B12M
 42Cd8MmRWKocBTsEMS+W6DVOgSBuLlazO9u2LU9tXUA6uFuUodnU44Z/MNnxnPJJG7IC
 F8Nc/DsSHdVA7XEEGea7sxqM8frdxX6LX63nW5EX5tCDlwm6Sv3WFfVwc/8E5sJevIzi
 lV7fVZAsi9s3tlf7LNo/knOZz3+7H2bV0+pbbyAUJ6+zgfC+Lb9XkwWxVW5OOkteWklk jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqwyhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:09:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JxIK9135342;
        Tue, 2 Jun 2020 20:07:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31c1dxtrmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:07:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052K7b5o013919;
        Tue, 2 Jun 2020 20:07:37 GMT
Received: from ayz-linux.us.oracle.com (/10.154.185.88)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:07:36 -0700
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        steven.sistare@oracle.com, anthony.yznaga@oracle.com
Subject: [PATCH 0/3] avoid unnecessary memslot rmap walks
Date:   Tue,  2 Jun 2020 13:07:27 -0700
Message-Id: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While investigating optimizing qemu start time for large memory guests
I found that kvm_mmu_slot_apply_flags() is walking rmaps to update
existing sptes when creating or moving a slot but that there won't be
any existing sptes to update and any sptes inserted once the new memslot
is visible won't need updating.  I can't find any reason for this not to
be the case, but I've taken a more cautious approach to fixing this by
dividing things into three patches.

Anthony Yznaga (3):
  KVM: x86: remove unnecessary rmap walk of read-only memslots
  KVM: x86: avoid unnecessary rmap walks when creating/moving slots
  KVM: x86: minor code refactor and comments fixup around dirty logging

 arch/x86/kvm/x86.c | 106 +++++++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

-- 
2.13.3

