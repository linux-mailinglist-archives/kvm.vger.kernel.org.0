Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2C542A2B7
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 12:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhJLK7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 06:59:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236036AbhJLK7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 06:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634036234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jxLfujbKXdx96upt5Ex3rPh2ayhKNjcG6TV0Iacz4Iw=;
        b=TxlhzH395FNVSXozpC7n7txdXpbDPVriGLy5aEDJ+MycPPknHSSdXGdNcymDnelT9avvyO
        3vwDgxcQSn0KYOO7rYuVyVdbzhaRkuGCh/Q8LGKZD+5BpnzMvRkfGKaPo2d/4S2oiHcnzN
        999HNMULJCh8e+RjVb3slXfmX14xZqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-Ed2bY93-MfWNoRnlmixODw-1; Tue, 12 Oct 2021 06:57:10 -0400
X-MC-Unique: Ed2bY93-MfWNoRnlmixODw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75FC2BBEE0;
        Tue, 12 Oct 2021 10:57:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFF6F5D6D5;
        Tue, 12 Oct 2021 10:57:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: [PATCH v2 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all pages
Date:   Tue, 12 Oct 2021 06:57:06 -0400
Message-Id: <20211012105708.2070480-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add to /dev/sgx_vepc a ioctl that brings vEPC pages back to uninitialized
state with EREMOVE.  This is useful in order to match the expectations
of guests after reboot, and to match the behavior of real hardware.

The ioctl is a cleaner alternative to closing and reopening the
/dev/sgx_vepc device; reopening /dev/sgx_vepc could be problematic in
case userspace has sandboxed itself since the time it first opened the
device, and has thus lost permissions to do so.

If possible, I would like these patches to be included in 5.15 through
either the x86 or the KVM tree.

Thanks,

Paolo

Changes from RFC:
- improved commit messages, added documentation
- renamed ioctl from SGX_IOC_VEPC_REMOVE to SGX_IOC_VEPC_REMOVE_ALL

Change from v1:
- fixed documentation and code to cover SGX_ENCLAVE_ACT errors
- removed Tested-by since the code is quite different now

Paolo Bonzini (2):
  x86: sgx_vepc: extract sgx_vepc_remove_page
  x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl

 Documentation/x86/sgx.rst       | 26 +++++++++++++
 arch/x86/include/asm/sgx.h      |  3 ++
 arch/x86/include/uapi/asm/sgx.h |  2 +
 arch/x86/kernel/cpu/sgx/virt.c  | 69 ++++++++++++++++++++++++++++++---
 4 files changed, 95 insertions(+), 5 deletions(-)

-- 
2.27.0

