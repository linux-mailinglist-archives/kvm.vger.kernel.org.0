Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E6A1C1D6B
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 20:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgEASwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729767AbgEASwT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 14:52:19 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302B8C061A0C
        for <kvm@vger.kernel.org>; Fri,  1 May 2020 11:52:19 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id bm3so10995036qvb.0
        for <kvm@vger.kernel.org>; Fri, 01 May 2020 11:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dqyWkacoDk0SlzRjFvS5NPN8XWNRiCuxkwSEq7I48cE=;
        b=imuA6/8z7ACHxfkEWthb7/P9i0FIbUx1TzWmMDuksLp8MQLEZ+UyF6Dd/gVb/8HNO3
         FRTAiCh7aI6pBwt1fpQnw31soJT4j7jt14Af6kXssmRqkZMTX+V/7l5exOFE/oPvQaPj
         cUGXJljn1hLOse4sXdKVODzRkvMb7pf94EODSWF6gdpbo/4WjKVJo4mpBuyHRZRooFz9
         Jd8Q81eju937SW4h6De+ySrY87gjkxTzVAssbU6UYhyPqPoiExLSonj9mpXyFBq5vUXX
         YM9WBh/IQB9GxTD4fUXwpmwjcToZ66KYsQditCuN0hXCoKOfOa6Ahp7VGO1LKTlMYDCt
         1p8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dqyWkacoDk0SlzRjFvS5NPN8XWNRiCuxkwSEq7I48cE=;
        b=cHNXlHJ3yWPHwWVpRiRDwlzPLBPn8iuInfBkf1h5ScDViV9rM8H/zWp1PnY002FMbX
         lJkhCWOv68jsZsguwSjUTx6H4On9JZXckWfiCAwE6/zVC5t4CfCrhTJcvurdhEs5+UgG
         7ojN2G6HlMMsesuqZ/LYlO+5wXzalNsdOcRRla/EtsUBNo1pRS5m3p0jzWnvvaFGsh3l
         YsYkHJTrF5bkbcsrDzwp4/xwjTo6dPoe8t2tYZs2zK7Levkch1iHohAnx7udmP2OfKZ+
         SGtZksTlqraV2Zv9ZkRHt7gO2KYn1pQ/HJDrfnAusyHIK/MToPA3N6fsJ1/vvsOmYudt
         3/Jw==
X-Gm-Message-State: AGi0PuZcmVQ3N/rEWK7DxIq6KyEs/UPmeRv1kxB3xjDLAusH+ftXur28
        w+frKyzzofcxyj4r2sZrnGvQHvYN78/rH2HyXgJRZkgrNYS7ij0AmsjPpkAoU98F/+wCTjifa16
        peRZ1duAb5LuN+6BlFL2pw7v6N/Cz8/w3TSX+afmIxpDqx8i294KMX1QM0w==
X-Google-Smtp-Source: APiQypKhmBQD1Dcf+8aZNFzRU9wdT3IgF3rDC+ZBO5nnqqXi+E8aGtYFDJY58/KzvnbQLQkV7H55XYmVrQA=
X-Received: by 2002:a0c:efc8:: with SMTP id a8mr5133922qvt.153.1588359137619;
 Fri, 01 May 2020 11:52:17 -0700 (PDT)
Date:   Fri,  1 May 2020 11:51:46 -0700
Message-Id: <20200501185147.208192-1-yuanyu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH RFC 0/1] Hypercall UCALL for guest/userspace communication
From:   Forrest Yuan Yu <yuanyu@google.com>
To:     kvm@vger.kernel.org
Cc:     Forrest Yuan Yu <yuanyu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This RFC is to add a hypercall UCALL so that guest can communicate with
the userspace hypervisor. A guest may want to do this in different
scenarios. For example, a guest can ask the userspace hypervisor to
harden security by setting restricted access permissions on guest SLAT
entries.

Please note this hypercall provides the infrastructure for this type of
communication but does not enforce the protocol. A proposal for the
guest/userspace communication protocol will follow if this RFC is
accepted.

Forrest Yuan Yu (1):
  KVM: x86: add KVM_HC_UCALL hypercall

 Documentation/virt/kvm/api.rst                |  15 +-
 Documentation/virt/kvm/cpuid.rst              |   3 +
 Documentation/virt/kvm/hypercalls.rst         |  14 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/include/uapi/asm/kvm_para.h          |   1 +
 arch/x86/kvm/x86.c                            |  39 +++-
 include/uapi/linux/kvm.h                      |   1 +
 include/uapi/linux/kvm_para.h                 |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/hypercall_ucall.c    | 195 ++++++++++++++++++
 11 files changed, 264 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hypercall_ucall.c

-- 
2.26.2.526.g744177e7f7-goog

