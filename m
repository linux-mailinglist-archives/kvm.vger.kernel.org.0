Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC074300C6
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 09:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbhJPHQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 03:16:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243732AbhJPHQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 Oct 2021 03:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634368481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=epo8FkbKumUh4/PY5u+tj5FLsgZXMrvzAoyvu5liQGY=;
        b=Sc8muRSO0MdAHDMDZEJoSSNVl6qQSJEBaMhwwUt/simDR3pTm2pF2AwpPFLdTekvHSxieX
        1Z8/uLfjl7pNfp11cL4yuQOJ8m8epy0avv4niJIzBdrYB3YA/taf18TrRJzxDAByL5S8m8
        Gk9OBKvk8nByApa3lYsxJPM4nHbLn1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-q-aaPm65Px-e7Yhqdfa0LA-1; Sat, 16 Oct 2021 03:14:37 -0400
X-MC-Unique: q-aaPm65Px-e7Yhqdfa0LA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 145CF180831B;
        Sat, 16 Oct 2021 07:14:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCF711980E;
        Sat, 16 Oct 2021 07:14:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org, bp@suse.de
Subject: [PATCH v3 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all pages
Date:   Sat, 16 Oct 2021 03:14:32 -0400
Message-Id: <20211016071434.167591-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Changes from v2:
- return EBUSY also if EREMOVE causes a general protection fault

Paolo Bonzini (2):
  x86: sgx_vepc: extract sgx_vepc_remove_page
  x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl

 Documentation/x86/sgx.rst       | 35 +++++++++++++++++++++
 arch/x86/include/uapi/asm/sgx.h |  2 ++
 arch/x86/kernel/cpu/sgx/virt.c  | 63 ++++++++++++++++++++++++++++++---
 3 files changed, 95 insertions(+), 5 deletions(-)

-- 
2.27.0

