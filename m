Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E99242C6E8
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbhJMQ6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:58:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237619AbhJMQ6Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 12:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KTXsB7y98qjD44G3XE71PU+BjMImn/7agIimOiEWzwY=;
        b=NSa5YJTbI9rMwVVkvpczLGOoPEn0MwxqP5rbT2Qpk57odmOc23sRjMAxii94GH2DR21hcB
        xUn92gQd8sgY99M+KJnWvYLABtzJKe3PU+qr7MKgeE388pkOehFoGX51x1CWHyIjCqi9zf
        fBlqwe4k3S+i84NyA2Nq9F7gYO05Ui0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-N_dHGBNIN4qREs7u67X3nw-1; Wed, 13 Oct 2021 12:56:18 -0400
X-MC-Unique: N_dHGBNIN4qREs7u67X3nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AE04801FCE;
        Wed, 13 Oct 2021 16:56:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CC715DA60;
        Wed, 13 Oct 2021 16:56:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com
Subject: [PATCH 0/8] KVM: SEV-ES: fixes for string I/O emulation
Date:   Wed, 13 Oct 2021 12:56:08 -0400
Message-Id: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series, namely patches 1 and 8, fix two bugs in string I/O
emulation for SEV-ES:

- first, the length is completely off for "rep ins" and "rep outs"
  operation of size > 1.  After setup_vmgexit_scratch, svm->ghcb_sa_len
  is in bytes, but kvm_sev_es_string_io expects the number of PIO
  operations.

- second, the size of the GHCB buffer can exceed the size of
  vcpu->arch.pio_data.  If that happens, we need to go over the GHCB
  buffer in multiple passes.

The second bug was reported by Felix Wilhelm.  The first was found by
me by code inspection; on one hand it seems *too* egregious so I'll be
gladly proven wrong on this, on the other hand... I know I'm bad at code
review, but not _that_ bad.

Patches 2 to 7 are a bunch of cleanups to emulator_pio_in and
emulator_pio_in_out, so that the final SEV code is a little easier
to reason on.  Just a little, no big promises.

Tested by booting a SEV-ES guest and with "regular" kvm-unit-tests.
For SEV-ES I also bounded the limit to 12 bytes, and checked in the
resulting trace that both the read and write paths were hit when
booting a guest.

Paolo


Paolo Bonzini (8):
  KVM: SEV-ES: fix length of string I/O
  KVM: SEV-ES: rename guest_ins_data to sev_pio_data
  KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
  KVM: SEV-ES: clean up kvm_sev_es_ins/outs
  KVM: x86: split the two parts of emulator_pio_in
  KVM: x86: remove unnecessary arguments from complete_emulator_pio_in
  KVM: SEV-ES: keep INS functions together
  KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if
    needed

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/svm/sev.c          |   2 +-
 arch/x86/kvm/x86.c              | 136 +++++++++++++++++++++-----------
 3 files changed, 95 insertions(+), 46 deletions(-)

-- 
2.27.0

