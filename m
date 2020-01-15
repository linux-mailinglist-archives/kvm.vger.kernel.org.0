Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD46F13CA76
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgAORKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:10:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43780 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729057AbgAORKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 12:10:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579108223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oh8syvO3W6gUaj5dvdzY+X7LicIsoPtaC11FOH1zRXg=;
        b=MV03FqL2S9SPquadi0qA/KKu43ahwCdDHUURU24ujMtcXSoZ10ypeN/RSqAaQVrLxlJdIb
        XUMuvDkojhoYXa9n0R6Sju4COA7BuEu3QAXYN4oRyN93365hQko1jmQS9ObrjV8f3i1A6l
        9QWvHp4NvKkyAf8OpDfutd+5UNCAhNk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-cQfE8RhiMVW02hXz8o0yyQ-1; Wed, 15 Jan 2020 12:10:18 -0500
X-MC-Unique: cQfE8RhiMVW02hXz8o0yyQ-1
Received: by mail-wr1-f71.google.com with SMTP id z14so8309679wrs.4
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 09:10:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oh8syvO3W6gUaj5dvdzY+X7LicIsoPtaC11FOH1zRXg=;
        b=tQ3eDes8++4eWL0Amp2BIGBut7KFq3oA+Nv+KiTmTn1BEEPlcuVT0sWZzp+sSBDVry
         K2QgLvZTIy2PcfBXp7jbxihdpz/AeIh0d0pGH+8cpA7/cn/rJWOhu8lkPLM/dFkGJtND
         b4pSAtH6+XnOPrdOBgaUvlfrpRsIYUg1DtF0iJesDpgzeDIrC97oA1s+rzqKZpPkxZ7H
         V87kTCycKA8xfjH6tQ2p26IvLt+ea25Ke5W0ei7HPcO5yY83In7vKfFxkzmdUEJLwe3w
         2rLWdjgUMHlH9Mzafj+zUCgi9UWIsRy5XNXWCg5SURB3pcIIagohJJRdsi0Y5hzIJXjr
         hubw==
X-Gm-Message-State: APjAAAWDQ3m2kRldGHtUazF6neRGqA97IgzYrPfpCzcmzWsF0pkNNXIP
        xC0sGP94BZkgFc0bUPySdi2iPZBYBxrDzYRt0VDGZ5T3REEn78XSbKKlYozltlPehSeKiu5Atz/
        gkn7wHF0Gr54j
X-Received: by 2002:a05:600c:54b:: with SMTP id k11mr868450wmc.63.1579108216783;
        Wed, 15 Jan 2020 09:10:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxAUtkMeLimE0mSVgQTbE8fcqGapcKBRgSHFCBxThX2YfhrLDkFqEnKuSGULrLXasq18IvZA==
X-Received: by 2002:a05:600c:54b:: with SMTP id k11mr868433wmc.63.1579108216524;
        Wed, 15 Jan 2020 09:10:16 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y20sm525071wmi.25.2020.01.15.09.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 09:10:15 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH RFC 0/3] x86/kvm/hyper-v: fix enlightened VMCS & QEMU4.2
Date:   Wed, 15 Jan 2020 18:10:11 +0100
Message-Id: <20200115171014.56405-1-vkuznets@redhat.com>
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
supported. Genuine Hyper-V, however, fails the test. In particular, it
enables SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES and without
'apic_access_addr' field in eVMCS there's not much we can do in KVM.

The suggested approach in this patch series is: move VMX feature
filtering to vmx_get_msr() so only guest doesn't see them when eVMCS
is enabled (PATCH2) and add a check that it doesn't enable them
(PATCH3).

I can't say that I'm a great fan of this workaround myself, thus RFC.

My initial RFC sent to qemu-devel@:
https://lists.nongnu.org/archive/html/qemu-devel/2020-01/msg00123.html

Vitaly Kuznetsov (3):
  x86/kvm/hyper-v: remove stale evmcs_already_enabled check from
    nested_enable_evmcs()
  x86/kvm/hyper-v: move VMX controls sanitization out of
    nested_enable_evmcs()
  x86/kvm/hyper-v: don't allow to turn on unsupported VMX controls for
    nested guests

 arch/x86/kvm/vmx/evmcs.c  | 99 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/evmcs.h  |  2 +
 arch/x86/kvm/vmx/nested.c |  3 ++
 arch/x86/kvm/vmx/vmx.c    | 10 +++-
 4 files changed, 100 insertions(+), 14 deletions(-)

-- 
2.24.1

