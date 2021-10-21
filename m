Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A216435CDE
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 10:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhJUIbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 04:31:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhJUIbX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 04:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634804947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4JuYHXLurOfqijb4LKCDA9YAjVucJv/Dn6KjwrrYW6I=;
        b=hdEwQ2njb3mISt/+Yvgz1+1lZ5EZRA5eRzf4Hmssl5pxrDlU0NxEzr45QLtHg2UTgJurJT
        Z3H+JKg+kabDONneGdGM4T4ZW5SlLp48HQua81eSL7bb1Di+1ZjypuXJ+NR33V7NQmsVXS
        ecUbYCd2N4eM/XpkHkZhLh25aOOUKDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-mJ1fyG-sOx2omIqKaNdshQ-1; Thu, 21 Oct 2021 04:29:03 -0400
X-MC-Unique: mJ1fyG-sOx2omIqKaNdshQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8728D81441B;
        Thu, 21 Oct 2021 08:29:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BCCA19D9F;
        Thu, 21 Oct 2021 08:29:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com,
        aaronlewis@google.com
Subject: [PATCH v2 kvm-unit-tests 0/4] remove tss_descr, replace with a function
Date:   Thu, 21 Oct 2021 04:28:56 -0400
Message-Id: <20211021082900.997844-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tss_descr is declared as a struct descriptor_table_ptr but it is actualy
pointing to an _entry_ in the GDT.  Also it is different per CPU, but
tss_descr does not recognize that.  Fix both by reusing the code
(already present e.g. in the vmware_backdoors test) that extracts
the base from the GDT entry; and also provide a helper to retrieve
the limit, which is needed in vmx.c.

Patch 1 adjusts the structs for GDT descriptors, so that the same
code works for both 32-bit and 64-bit.

Paolo

v1->v2: correctly handle segment descriptors
	remove duplication between struct definitions

v2->v3: improve handling of 16-byte GDT descriptors
	rename limit bitfield to limit2
	retrieve guest TR limit from the GDT
	new patch 2 adds another cleanup

Paolo Bonzini (4):
  x86: cleanup handling of 16-byte GDT descriptors
  x86: fix call to set_gdt_entry
  unify field names and definitions for GDT descriptors
  replace tss_descr global with a function

 lib/x86/desc.c         | 52 ++++++++++++++++++++++++++++++++----------
 lib/x86/desc.h         | 23 ++++++++++---------
 x86/cstart64.S         |  1 -
 x86/svm_tests.c        | 15 +++---------
 x86/taskswitch.c       |  2 +-
 x86/vmware_backdoors.c | 22 +++++-------------
 x86/vmx.c              |  9 ++++----
 7 files changed, 67 insertions(+), 57 deletions(-)

-- 
2.27.0

