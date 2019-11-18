Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42959100B4A
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 19:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfKRSRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 13:17:53 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37675 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRSRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 13:17:53 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so346984wmj.2;
        Mon, 18 Nov 2019 10:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=UHVmj17X5I97BtGdOpQHVSrZpwkyodA+Uw+toEe9ceM=;
        b=cPW6MV8KJLW7M2YTVyqiYmE2Nl606qjFWgljH4qSErWNWVHim8rZby2mSQpjvc3ST9
         mYGXQ4AKQat8J0GqsiVdm3CJ4SxKB3fBsYMZ1lyX9T9CdckDFD2NV9sDFuHYUjVXilW6
         o08r5tHgtDMdyhQPGJDC5+HJEJWxitIBD4G8RfpS8Cph4v+zScQDfnmJMJJB6uroOwdW
         1Cxc29en4+/8DeLkIMFgFosVz5Ku4E++4Ddr2KE4z7yZrZtV4fCmuqask3S6N1LYVZuY
         d76TWYsDBN5gOsbma+2EZjItqK2aoqdGL4qv7dkmbV8J1RyK0qfK7ezfg+MTMchHYDLU
         OGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=UHVmj17X5I97BtGdOpQHVSrZpwkyodA+Uw+toEe9ceM=;
        b=YmMhJPEcxIL/L8ArBOmiIDrKPfh5UKU81t4cYxELLeHtqeHXW6WEnxWTwWAl9h2MoX
         Bs8kesOyP/dV9e+hnL6jqvdWdlEROemXluNLa7fTxT6Ufdb1S4fyKRSObMbFhL9IewdT
         wS7h21N28KPeoU8tvToEXKeXD0C5L3K/LVQgtLjGQmHI2JRbGnbAL6Rxobwx2ZxTxLFJ
         W4yT1YCPBmE+ms/8Xfux8RttZ+ymhnao7+e6ZYuaQ+KJjrrG6hvNwPXfgxI00fW+WJ1e
         2/cfc/JUHpKmD5yLjAUacHNygEMYO1Z7JTEh5ntvXxyPz4+Q9Sw4GN5bgCCr0Rwx9Dwh
         q6cw==
X-Gm-Message-State: APjAAAUfXNuHjJ6fwJBKhG3dfo1yzI9rVSZj5hcfTobRwUJNrp5NUlcR
        esBlZd7cHP/iz8M1hwtWK8FpDfuu
X-Google-Smtp-Source: APXvYqzqAAHTKIDQfKYRhTR26Z/txO0yzIIJfqBYR3tKEzIR+8n7zqljh0TP349Ri4tzP/Cy80vtlQ==
X-Received: by 2002:a1c:f317:: with SMTP id q23mr426754wmq.97.1574101071329;
        Mon, 18 Nov 2019 10:17:51 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v81sm233794wmg.4.2019.11.18.10.17.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:17:50 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 0/5] KVM: vmx: implement MSR_IA32_TSX_CTRL for guests
Date:   Mon, 18 Nov 2019 19:17:42 +0100
Message-Id: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current guest mitigation of TAA is both too heavy and not really
sufficient.  It is too heavy because it will cause some affected CPUs
(those that have MDS_NO but lack TAA_NO) to fall back to VERW and
get the corresponding slowdown.  It is not really sufficient because
it will cause the MDS_NO bit to disappear upon microcode update, so
that VMs started before the microcode update will not be runnable
anymore afterwards, even with tsx=on.

Instead, if tsx=on on the host, we can emulate MSR_IA32_TSX_CTRL for
the guest and let it run without the VERW mitigation.  Even though
MSR_IA32_TSX_CTRL is quite heavyweight, and we do not want to write
it on every vmentry, we can use the shared MSR functionality because
the host kernel need not protect itself from TSX-based side-channels.

Patch 1 is a minimal fix for MSR_IA32_ARCH_CAPABILITIES for stable
kernels.  The other four patches implement the feature.

Getting some help testing this series with the kvm-unit-tests patch I
have just sent would be great; I could only test this on a machine that
I couldn't reboot, and therefore I could only work on an older kernel.

Paolo Bonzini (5):
  KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
  KVM: x86: do not modify masked bits of shared MSRs
  KVM: x86: implement MSR_IA32_TSX_CTRL effect on CPUID
  KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM functionality
  KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable TSX on guest that lack
    it

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  8 +++--
 arch/x86/kvm/vmx/vmx.c          | 78 ++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/x86.c              | 34 ++++++++----------
 4 files changed, 82 insertions(+), 39 deletions(-)

-- 
1.8.3.1

