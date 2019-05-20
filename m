Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD50241CD
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfETUKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 16:10:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:23437 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfETUKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 16:10:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 13:10:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 20 May 2019 13:10:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: nVMX: Alternative no-EPT GUEST_CR3 fix
Date:   Mon, 20 May 2019 13:10:27 -0700
Message-Id: <20190520201029.7126-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As an alternative to forcing early consistency checks in hardware (to
avoid reaching nested_vmx_restore_host_state() due to a missed VM-FAIL),
stuff vmcs01.GUEST_CR3 with L1's desired CR3 prior to nested VM-Entry
so that nested_vmx_restore_host_state() loads the correct L1 state when
EPT is disabled in L0.

Code complexity in the two approaches is roughly similar, although the
GUEST_CR3 stuffing is definitely more subtle.  The primary motiviation
is performance, e.g. VMWRITE is less than 30 cyles, whereas doing
consistency checks via hardware is several hundred cycles.  Arguably
performance may be somewhat of a moot point when EPT is disabled, but
Nehalem hardware isn't *that* old.  :-)

Sean Christopherson (2):
  KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on nested entry w/o EPT
  Revert "KVM: nVMX: always use early vmcs check when EPT is disabled"

 arch/x86/include/uapi/asm/vmx.h |  1 -
 arch/x86/kvm/vmx/nested.c       | 27 ++++++---------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

-- 
2.21.0

