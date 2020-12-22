Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B9E2D9F3E
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440922AbgLNSee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:34:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440906AbgLNSe0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 13:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607970777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xkuYtdLf6aD5g/AJsimLnGfHqBLSAGTfbX/Ao9PPeSQ=;
        b=RnVucHFdLC0A99DyxRTSP16UrOSV/zU9pvEhF1l5LHw8z3gd4O5+wUg/MsyqdmCVHS2h8R
        bbSBIm4f8YtfCyoPcmYBoi0yS7C+2E/XqQhVDiJl/JzTxNYMFMBmJHALRAeZBcnEUosp/v
        jyPrhmQrm3/TstZvZwcI9eqEUn6FTT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-xMThsjC3OO66Xqsd14h6wA-1; Mon, 14 Dec 2020 13:32:53 -0500
X-MC-Unique: xMThsjC3OO66Xqsd14h6wA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 005D6180A0AA;
        Mon, 14 Dec 2020 18:32:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67D73100AE36;
        Mon, 14 Dec 2020 18:32:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/3] KVM: x86: MSR completion refactoring for SEV-ES
Date:   Mon, 14 Dec 2020 13:32:47 -0500
Message-Id: <20201214183250.1034541-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches remove kvm_inject_gp from the RDMSR/WRMSR emulation
path, with the purpose of letting SEV-ES inject the #GP through
the GHCB instead.

The main idea is to introduce a complete_emulated_msr callback
that is call-compatible with kvm_complete_insn_gp, so that svm.c
can just call kvm_complete_insn_gp in the common case.

I have more patches to use kvm_complete_insn_gp instead of
kvm_inject_gp in other paths, but they are not necessary for
SEV-ES so they can be delayed to 5.12.

Paolo

Paolo Bonzini (3):
  KVM: x86: remove bogus #GP injection
  KVM: x86: use kvm_complete_insn_gp in emulating RDMSR/WRMSR
  KVM: x86: introduce complete_emulated_msr callback

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mtrr.c             |  6 +----
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 42 +++++++++++++--------------------
 5 files changed, 20 insertions(+), 31 deletions(-)

-- 
2.26.2

