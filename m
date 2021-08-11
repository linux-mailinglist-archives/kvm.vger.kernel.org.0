Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787263E8E80
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbhHKKYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:24:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236935AbhHKKYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 06:24:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628677440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=02M9SPT/tVkQe2EZC3upUifeAeMGBAPUwTh4S8nOgjc=;
        b=eOYaIDwy43rXOFajv/RyroBZvwMIf2fK1/I93MEbI2m0xyRczM5V6BvlvTsxn0IkEA7lmV
        wPCOgFEFtttmQa3fWHAQitsy8ohSuBFj9X2qB7TyekCZ6NtNpqfavcdjJEsy3HKL92KI+/
        LpSd0XFO7tFD/tqmLxGPgET+aUJKPXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-BqK6L89KMEmE5_KO-_jsUA-1; Wed, 11 Aug 2021 06:23:59 -0400
X-MC-Unique: BqK6L89KMEmE5_KO-_jsUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B0CE801B3C;
        Wed, 11 Aug 2021 10:23:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F09265D9C6;
        Wed, 11 Aug 2021 10:23:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mtosatti@redhat.com
Subject: [PATCH 0/2] KVM: x86: abstract locking around pvclock_update_vm_gtod_copy
Date:   Wed, 11 Aug 2021 06:23:54 -0400
Message-Id: <20210811102356.3406687-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two cleanup patches that factor out the handling of
KVM_REQ_MASTERCLOCK_UPDATE and KVM_REQ_MCLOCK_INPROGRESS.  I have another
patch actually to remove KVM_REQ_MCLOCK_INPROGRESS, but I don't have time
to finish testing it right now; so here are only the cleanups leading
to it.

Paolo Bonzini (2):
  KVM: KVM-on-hyperv: shorten no-entry section on reenlightenment
  kvm: x86: abstract locking around pvclock_update_vm_gtod_copy

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 67 +++++++++++++--------------------
 2 files changed, 27 insertions(+), 41 deletions(-)

-- 
2.27.0

