Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1189B4353D4
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 21:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhJTT35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 15:29:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231584AbhJTT34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 15:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634758061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oPdcQkpNZP73LfuDNc2ZyY2+8oB4ABlfaYY8b1cJ7bg=;
        b=GFMM0hkwS2Qs367F6hEe4qYlKlF1CIzcwau/hXRe7XGBbMASIHMiXSAGexep/g4Zv/Y6Hw
        SDKecBZPyxaHVPvD7+p4iAPiQA9x8RLOCneNSNrfb8gRW9wV2x5JWowh2qzDPdOO+O+zMS
        sEOHtLCQ49/zSuI7DMtbIdeO200fcyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-0hECiUWPOMen9HDDYQ1drQ-1; Wed, 20 Oct 2021 15:27:34 -0400
X-MC-Unique: 0hECiUWPOMen9HDDYQ1drQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65EAB80A5C8;
        Wed, 20 Oct 2021 19:27:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC41769FBB;
        Wed, 20 Oct 2021 19:27:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
Subject: [PATCH v2 kvm-unit-tests 0/2] remove tss_descr, replace with a function
Date:   Wed, 20 Oct 2021 15:27:30 -0400
Message-Id: <20211020192732.960782-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Paolo Bonzini (2):
  unify field names and definitions for GDT descriptors
  replace tss_descr global with a function

 lib/x86/desc.c         | 38 ++++++++++++++++++++++++++++----------
 lib/x86/desc.h         | 22 +++++++++++-----------
 x86/cstart64.S         |  1 -
 x86/svm_tests.c        | 15 +++------------
 x86/taskswitch.c       |  2 +-
 x86/vmware_backdoors.c | 22 ++++++----------------
 x86/vmx.c              |  9 +++++----
 7 files changed, 54 insertions(+), 55 deletions(-)

-- 
2.27.0

