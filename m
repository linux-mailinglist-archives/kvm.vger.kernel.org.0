Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586A517BD71
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCFNCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:02:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23670 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgCFNCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 08:02:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583499741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9kyJgQMNNTtILNB3efmK9JnspOevwrPmN1Q1JAEBpAU=;
        b=ZVZZH3KEegGKb7gGBcYxrD1JWwJZgUR40LY0l6V6CZ5GWKbBxGkXF5me4MNdvtLFxXyOnO
        uMLTlnP+WY7BUdW2olEkgFjRycF1yCfg6huR0F/cefB3UdPvV4S9P2ovGW/BaP43ynsYCB
        Vsyr6rnbDotfErU0C2CQJH6lp48NO5M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-jUFJfcEZPgC7HIE4ySuW5A-1; Fri, 06 Mar 2020 08:02:19 -0500
X-MC-Unique: jUFJfcEZPgC7HIE4ySuW5A-1
Received: by mail-wm1-f71.google.com with SMTP id c18so865283wml.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 05:02:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9kyJgQMNNTtILNB3efmK9JnspOevwrPmN1Q1JAEBpAU=;
        b=M+Y+jLIQtQdDLsPfLofe97wJshvjW+QIzZmsbIWt9b6sPjB7SKca8/GmCAbG6pO9Qp
         1/1CuFvX0RYrR3mtvtpILGcOImzAfINqnat82zUWYPmxgu9Td/jlNCYTsUcf0nUtwj+9
         Kelg8cWq5bhxlANUcX9LU1L/R4H3qDPT64/2nE7yFLS58B++ZMaDB4j6EWme4LznfDZ7
         FruGAtQPBiI4mX1RBRHrIiL2o7EP7cal9VGQ8tex16qBmHQAPjOtz2CIumnDWonoDXqF
         b695BS1f6vqqjoPYlFKyKwURAkA1mRWcA9jaNOxgdjGElbfmX92U+bp7Rbe5K9akT5ZC
         7HkQ==
X-Gm-Message-State: ANhLgQ2YRBTdG5Q4xuUEpEeQlPU1l3O9BOO3ecTG7WJt5QetQP55j+cm
        c+XCCfm9H7w21mrENX8RUrjnCeP9erMVty273HES+pyrOA22aLBzB9JCbEcxGu2OcC6mdUTL2dO
        RI02nqF2E2MBt
X-Received: by 2002:adf:de0d:: with SMTP id b13mr3989698wrm.297.1583499738505;
        Fri, 06 Mar 2020 05:02:18 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsKYoaK09agc4K6ttjmJfCHwezyd4P5yvpgDy7QZx84bx8Hc+dQIFutDBEvtnkB7At6SeYHAQ==
X-Received: by 2002:adf:de0d:: with SMTP id b13mr3989672wrm.297.1583499738253;
        Fri, 06 Mar 2020 05:02:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i67sm26613243wri.50.2020.03.06.05.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:02:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] KVM: VMX: cleanup VMXON region allocation
Date:   Fri,  6 Mar 2020 14:02:13 +0100
Message-Id: <20200306130215.150686-1-vkuznets@redhat.com>
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

Changes since v1:
- Pass 'enum vmcs_type' parameter to alloc_vmcs() too [Sean Christopherson <sean.j.christopherson@intel.com>]

Vitaly Kuznetsov (2):
  KVM: VMX: rename 'kvm_area' to 'vmxon_region'
  KVM: VMX: untangle VMXON revision_id setting when using eVMCS

 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 44 ++++++++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.h    | 12 ++++++++---
 3 files changed, 30 insertions(+), 28 deletions(-)

-- 
2.24.1

