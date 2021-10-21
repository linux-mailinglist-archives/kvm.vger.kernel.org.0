Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7CE4360BB
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhJULvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:51:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbhJULvc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eqVRrmGmBcp5eJmDVwaXly4JMFwree0jbnxIoRxC58M=;
        b=EZzrLsN9tY3hR+yvItwnD2HoKhjibuQpP3llRpepz91ltHh5OvG0jmviHUWG2eDtDu3DFV
        I5TrAVDt0cLhiFXlJ+UGMWB4ugqohT+7ik3gLkGVYZCU0mO2uu/7/o+tVHo5c9HJpO7icG
        w8CF1BYQSmESgiRb93WbK2kglnWBwf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-0fUBYPqVNh6KHMEWatwURw-1; Thu, 21 Oct 2021 07:49:12 -0400
X-MC-Unique: 0fUBYPqVNh6KHMEWatwURw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31FB293C;
        Thu, 21 Oct 2021 11:49:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7858D5FC13;
        Thu, 21 Oct 2021 11:49:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Subject: [PATCH v3 kvm-unit-tests 0/8] x86: Move IDT, GDT and TSS to C code
Date:   Thu, 21 Oct 2021 07:49:01 -0400
Message-Id: <20211021114910.1347278-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 1-4 clean up tss_descr; it is declared as a struct
descriptor_table_ptr but it is actualy pointing to an _entry_ in the GDT.
Also it is different per CPU, but tss_descr does not recognize that.
Fix both by reusing the code (already present e.g. in the vmware_backdoors
test) that extracts the base from the GDT entry; and also provide a
helper to retrieve the limit, which is needed in vmx.c.

Patches 5-9 move the IDT, GDT and TSS to C code.  This was originally done
by Zixuan Wang for the UEFI port, which is 64-bit only.  The series extends
this to 32-bit code for consistency and to avoid duplicating code between
C and assembly.

Paolo

v2->v3: cleaned up handling of 16 byte descriptors (new patch 1)
	get TR limit from GDT
	rename high four bits of segment limit to "limit2"
	included Zixuan's work to port GDT/TSS/IDT to C, extended to 32-bit

Paolo Bonzini (8):
  x86: cleanup handling of 16-byte GDT descriptors
  x86: fix call to set_gdt_entry
  unify field names and definitions for GDT descriptors
  replace tss_descr global with a function
  x86: Move IDT to desc.c
  x86: unify name of 32-bit and 64-bit GDT
  x86: get rid of ring0stacktop
  x86: Move 32-bit GDT and TSS to desc.c

Zixuan Wang (1):
  x86: Move 64-bit GDT and TSS to desc.c

 lib/x86/asm/setup.h    |   6 +++
 lib/x86/desc.c         | 116 +++++++++++++++++++++++++++++++++++------
 lib/x86/desc.h         |  31 +++++------
 lib/x86/setup.c        |  49 +++++++++++++++++
 lib/x86/usermode.c     |   9 ++--
 x86/access.c           |  16 +++---
 x86/cstart.S           | 115 ++++++----------------------------------
 x86/cstart64.S         |  97 ++++------------------------------
 x86/smap.c             |   2 +-
 x86/svm_tests.c        |  15 ++----
 x86/taskswitch.c       |   4 +-
 x86/umip.c             |  19 ++++---
 x86/vmware_backdoors.c |  22 +++-----
 x86/vmx.c              |  17 +++---
 x86/vmx_tests.c        |   4 +-
 15 files changed, 244 insertions(+), 278 deletions(-)
 create mode 100644 lib/x86/asm/setup.h

-- 
2.27.0

