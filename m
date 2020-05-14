Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2E31D3D70
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgENT1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:27:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728191AbgENT1U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 15:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=+PaQYWYn8bHUvQxqPmgnXPvMwkxGZAfGAiUQ0e3SRuw=;
        b=KN4bDDVB0bMuqP/2LoqoTJ19+bXhOW+Vwrgvqb6GNoeJR/pnH9OKR2bnYugYJFK/NWiBb4
        Uo29TNviL8X6Z8glRZ0I+6RWnm8dOLyc+xaeGYaOZEkLFjnG3kQuKeHiPR6owPEbu10JPt
        GtzcjXvZMguLwzZtj+a9SDasI3cP6y8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-hzjHhuGcPtO65kOAudSq0A-1; Thu, 14 May 2020 15:27:17 -0400
X-MC-Unique: hzjHhuGcPtO65kOAudSq0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9464F1005510;
        Thu, 14 May 2020 19:27:16 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B19F35C1BE;
        Thu, 14 May 2020 19:27:13 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 11/11] Compile the kvm-unit-tests also with Clang
Date:   Thu, 14 May 2020 21:26:26 +0200
Message-Id: <20200514192626.9950-12-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To get some more test coverage, let's check compilation with Clang, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 13e1a1f..3af53f0 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -80,3 +80,16 @@ build-i386:
      cmpxchg8b eventinj port80 setjmp sieve tsc taskswitch umip
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
+
+build-clang:
+ script:
+ - dnf install -y qemu-system-x86 clang
+ - ./configure --arch=x86_64 --cc=clang
+ - make -j2
+ - ACCEL=tcg ./run_tests.sh
+     smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
+     vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
+     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
+     eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
+     | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.18.1

