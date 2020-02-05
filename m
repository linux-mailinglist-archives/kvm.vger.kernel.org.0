Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8041530C8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgBEMao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:30:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727963AbgBEMan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 07:30:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580905842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FZ3Fjj0BjzHheqix1bmWtGQyTCVbBm91zCQKiRJjeoc=;
        b=BPC80VCMg0sbdv86KZrDCm8HS8doLuNB3nmSjvc+qFAaU9+N6RIB0Ep3/FEu3AY8UKPniO
        QQonPk8pMm9zoY5S0AYIHHL6xQmp2XqBLlqJ/I0gOaCcQMgmk6X2P242nFHyyMhAmRV2HK
        nVxooeV/hU5u6eq10l5KOFodYyLG++Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-XinBh8uIM7qBiEPxQGmciw-1; Wed, 05 Feb 2020 07:30:38 -0500
X-MC-Unique: XinBh8uIM7qBiEPxQGmciw-1
Received: by mail-wm1-f72.google.com with SMTP id o193so923474wme.8
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:30:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZ3Fjj0BjzHheqix1bmWtGQyTCVbBm91zCQKiRJjeoc=;
        b=nlbrhc/Q0h4xLBFd7B6CSD0zqFJySBdH1JlBOauAceiyZka7+iLfIrdm59PyhBOUfw
         jq5nS1YimO5ssHdd0PzDysKHBLeUm0W4l0Z3NUCjcAo8EYcq7Pfkj35jIaszno2iKV3A
         xcWN5BLnmC4qW+AsO6wjuiGKgcCgp/7RBXVG8qgppsRI6JA467M9OQ+Y2KP6RmvzBLk0
         yenzLDkVdEw2eX5nUDpNQCY0XhSulM7PuyG48FioWGCsx3qHPHqXmTUR04QZp0P7Mv8g
         HRa+19ey/OqRmkvKvhFYiX1vx0DdEAXkblN4ulwpSXlYDA2oNz9cre76Qw5o1Y41MPv4
         TE8w==
X-Gm-Message-State: APjAAAWbu784A9NHpgzCcRiTHPwzXFkcoNW//jj9GWQeTR3C02pkxk4a
        9iFqkl4DZZd0I52/wpy+85NQM9kfA2N0RdwY8Mrus8hUWM7OHkjetmOzUvFlskyTQ9LWnUdMwPU
        Aa5ovtW9Sj0KG
X-Received: by 2002:a5d:6802:: with SMTP id w2mr27773562wru.353.1580905837104;
        Wed, 05 Feb 2020 04:30:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6xei4lJJtlxIHzm0eIiTXbZ2RJ6mzDj5iTZMvHZSp+m6YI7Hhbrz63uThgLSRStvcrZPzPw==
X-Received: by 2002:a5d:6802:: with SMTP id w2mr27773549wru.353.1580905836907;
        Wed, 05 Feb 2020 04:30:36 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g7sm34227251wrq.21.2020.02.05.04.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:30:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 0/3] x86/kvm/hyper-v: fix enlightened VMCS & QEMU4.2
Date:   Wed,  5 Feb 2020 13:30:31 +0100
Message-Id: <20200205123034.630229-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
with default (matching CPU model) values and in case eVMCS is also enabled,
fails. While the regression is in QEMU, it may still be preferable to
fix this in KVM.

It would be great if we could just omit the VMX feature filtering in KVM
and make this guest's responsibility: if it switches to using enlightened
vmcs it should be aware that not all hardware features are going to be
supported. Genuine Hyper-V, however, fails the test. It, for example,
enables SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES and without
'apic_access_addr' field in eVMCS there's not much we can do in KVM.
Microsoft confirms the bug but it is unclear if it will ever get fixed
in the existing Hyper-V versions as genuine Hyper-V never exposes
these unsupported controls to L1.

Changes since 'RFC':
- Go with the bare minimum [Paolo]

KVM RFC:
https://lore.kernel.org/kvm/20200115171014.56405-1-vkuznets@redhat.com/

QEMU RFC@:
https://lists.nongnu.org/archive/html/qemu-devel/2020-01/msg00123.html

Vitaly Kuznetsov (3):
  x86/kvm/hyper-v: remove stale evmcs_already_enabled check from
    nested_enable_evmcs()
  x86/kvm/hyper-v: move VMX controls sanitization out of
    nested_enable_evmcs()
  x86/kvm/hyper-v: don't allow to turn on unsupported VMX controls for
    nested guests

 arch/x86/kvm/vmx/evmcs.c  | 90 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/evmcs.h  |  3 ++
 arch/x86/kvm/vmx/nested.c |  3 ++
 arch/x86/kvm/vmx/vmx.c    | 16 ++++++-
 4 files changed, 99 insertions(+), 13 deletions(-)

-- 
2.24.1

