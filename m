Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D9F411502
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 14:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhITMzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 08:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236310AbhITMze (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 08:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632142447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fDLQq5MvPSzAt6PnqUmCdhsPlz4Motg42ahab6MSZ50=;
        b=VNGQsxRNGL4E5hwxYCeASpM5JDblbMPW1k7H5k+vNlMN70gFfvHeJlCKiqyeHVZ+wrU8KJ
        5CyGfOMuy+r+1jlAJcoCAWNmwcITEU8+iFZfLlYl2Ap3f4VQ0B2CDlnQZzgxNYP1pbXfW4
        kIU0OeIsSk01Hh+LbVrz6QntRhakF1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441--bOW6NYZO16OJnQqaNzPsg-1; Mon, 20 Sep 2021 08:54:04 -0400
X-MC-Unique: -bOW6NYZO16OJnQqaNzPsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0A6619253C3;
        Mon, 20 Sep 2021 12:54:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F3311346F;
        Mon, 20 Sep 2021 12:54:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all pages
Date:   Mon, 20 Sep 2021 08:53:59 -0400
Message-Id: <20210920125401.2389105-1-pbonzini@redhat.com>
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

Paolo Bonzini (2):
  x86: sgx_vepc: extract sgx_vepc_remove_page
  x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl

 Documentation/x86/sgx.rst       | 14 ++++++++++
 arch/x86/include/uapi/asm/sgx.h |  2 ++
 arch/x86/kernel/cpu/sgx/virt.c  | 48 ++++++++++++++++++++++++++++++---
 3 files changed, 61 insertions(+), 3 deletions(-)

-- 
2.27.0

