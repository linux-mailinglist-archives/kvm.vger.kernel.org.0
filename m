Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A160A18A160
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgCRRR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:17:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30361 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgCRRR6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 13:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584551878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1tmYrjNBPlfS8Oz+KPrbLzllyHIAIh5B4HPxuEUJj2k=;
        b=KAEdYPmHElhrsGgEW1Nfnc1wgjL/RifeSa+HORDnsU05M/yShr74lm25w1+mPOiJxVnR5R
        KzgAmsLd4jGiBs4N0B4Kcv0Tj3UH0rwY6xSGkuwWMyhHy9nNUFutXkNA2qyVRNUHhU0rwy
        zRQLkyKzzsLxnM5w2z/QiuaPKL6Oh/g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-CXuIpPxuPS6QkbNjE9NrDg-1; Wed, 18 Mar 2020 13:17:56 -0400
X-MC-Unique: CXuIpPxuPS6QkbNjE9NrDg-1
Received: by mail-wr1-f70.google.com with SMTP id t4so8385329wrr.1
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 10:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tmYrjNBPlfS8Oz+KPrbLzllyHIAIh5B4HPxuEUJj2k=;
        b=M09a/QFPxAiQQ/0xTRYfuvsEmGZCIoynqZGqOQ9svDlaTOhnUSYLzBoTYDQe0+CL4O
         FJPdzpKPXTg6QaV/TooG6mAnzcqR7PWSfabz6WHd9VXLrHXUT9bdPzmte84eJyYa7xQS
         gnij679N7Pj18UgaMngKba3K1vZQi3z3FpZMaZf4JpULlpQI5NBemmR7NZ9IalZTB23c
         juexapzLhJZMhO1palB6Mm0qLY5pFtjdCrRCp3CndFh2k1dw/GQ8GZlg1Ng7U2qa1Na7
         0aBqNSaC9EojZNGAy+bCXVFJ8sc8t1/AaQdxAgyvtFHqufebxR5TCU2eTz0bwPOeYkcZ
         A66A==
X-Gm-Message-State: ANhLgQ3KcoPmxVOjwQ/H7ZSw2cZPzzrfDfG23BXPKyLjLp//bMz7gZup
        Dz+rzenYkc8kjTm2zhnG/fwGX2V+eEURyOZcsJubO+MSRMaP1jwe0qrVzZt4K7IWdBJKhZsv+8j
        VRc837cJnlUKb
X-Received: by 2002:a5d:680d:: with SMTP id w13mr6619018wru.227.1584551875099;
        Wed, 18 Mar 2020 10:17:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuV4gL9NnrUrL3uhgtDnC8jCR+eQZlEHteghQ1cIvY0SDIXvFJgPy1bqpym7Ng4rNGsdr2PWA==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr6618996wru.227.1584551874821;
        Wed, 18 Mar 2020 10:17:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r3sm10531597wrw.76.2020.03.18.10.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 10:17:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] KVM: VMX: cleanup VMXON region allocation
Date:   Wed, 18 Mar 2020 18:17:50 +0100
Message-Id: <20200318171752.173073-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor cleanup with no functional change (intended):
- Rename 'kvm_area' to 'vmxon_region'
- Simplify setting revision_id for VMXON region when eVMCS is in use

Changes since v3:
- Rebase to kvm/queue
- Added Krish's Reviewed-by: tag to PATCH1
- Re-name 'enum vmcs_type' members [Sean Christopherson]

Vitaly Kuznetsov (2):
  KVM: VMX: rename 'kvm_area' to 'vmxon_region'
  KVM: VMX: untangle VMXON revision_id setting when using eVMCS

 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 44 ++++++++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.h    | 12 ++++++++---
 3 files changed, 30 insertions(+), 28 deletions(-)

-- 
2.25.1

