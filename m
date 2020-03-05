Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F9117A2C3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgCEKBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:01:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52046 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727130AbgCEKBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583402490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qpugOFYl5V3c99FSliIabsi6Xzso9YXY154ETSWVrWk=;
        b=PBWXocnqIjC4gdmyz9dumOqje10wq5Z9bRaQw+HSXxrY2zRRR7vzHYyp2jO5kqPXnEKXDJ
        h2BIMwwtD8jPM8fnOkX+S1Z86RwGl+wKqlASYijeJHkUFEtCaWcVuYlB4d5alb9y63cl4R
        pJ/yOs4RJykSPzBookM0lzjMxdGxAas=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-7vStS2C1NgydXGE7oDazEg-1; Thu, 05 Mar 2020 05:01:26 -0500
X-MC-Unique: 7vStS2C1NgydXGE7oDazEg-1
Received: by mail-wr1-f72.google.com with SMTP id n12so2079326wrp.19
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 02:01:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qpugOFYl5V3c99FSliIabsi6Xzso9YXY154ETSWVrWk=;
        b=hqO2SyHWstjx4yfNj2Wol29G3IGo5k7DFRl7xddxpSK9WiyoPVUc0or+cgYCBA28UJ
         LIh88mAgrzzvf//kZAq3dvHJrG0CyWuPdWnrJJPfn2YFqBmvDm9T/AGwVl8ZbZ3oqBWu
         D1z1ADE79Xx3Bv5V8XBtbJAsa0qkc0C/moUvraQGYZP3CoQSTs/pEnuz9fmZOnczlxZf
         EZEL4RaHMBcvKaKhAAq10xrrcUOSdZHAFzfq33JdXaXl/F/IngtP4koFQh6aIWfbRXH/
         e5hRI+kYAU1Hc19t9qY5oWf3G98yt2y1l+T3QhJLyR2O/HyhcWj7oGwbL1+0WqPN1fhA
         HbIA==
X-Gm-Message-State: ANhLgQ2eu3SGYSXDMLvO4U9qjdUAzCpOioncOH0EtbYsoZZV2MX7Annc
        N1JpHP5MPI4iyrrg3bLLv5xKSTv0VNDaBsBOb5pKNlLF/2BMe8BFSGXhYQgE8NEBoITWQQ8AWZs
        XlZ1ofGpG+ahI
X-Received: by 2002:a1c:df07:: with SMTP id w7mr3298018wmg.7.1583402485696;
        Thu, 05 Mar 2020 02:01:25 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuz6dICjFPBTcnmSBIcEQjdYGYqDapQCmvmzoB8Kk/sgxpi35ZXSbrUoVQzUwpjoTnnS8XQNw==
X-Received: by 2002:a1c:df07:: with SMTP id w7mr3297996wmg.7.1583402485531;
        Thu, 05 Mar 2020 02:01:25 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f207sm10440025wme.9.2020.03.05.02.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:01:24 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: VMX: cleanup VMXON region allocation
Date:   Thu,  5 Mar 2020 11:01:21 +0100
Message-Id: <20200305100123.1013667-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor cleanup with no functional change (intended):
- Rename 'kvm_area' to 'vmxon_region'
- Simplify setting revision_id for VMXON region when eVMCS is in use

Vitaly Kuznetsov (2):
  KVM: x86: VMX: rename 'kvm_area' to 'vmxon_region'
  KVM: x86: VMX: untangle VMXON revision_id setting when using eVMCS

 arch/x86/kvm/vmx/vmx.c | 41 ++++++++++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.h | 12 +++++++++---
 2 files changed, 27 insertions(+), 26 deletions(-)

-- 
2.24.1

