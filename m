Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619C61FBE9D
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgFPS4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60822 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730564AbgFPS4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=wRxffG2T1M8BwN6SCZlk4oZyZzZlp0cjW2MQ3OpWouU=;
        b=KKkorSO7zwv0dsVZPriwkHeeWTASFBX36BQqdQ63l+r35RHMtOms/150chNCMpQEtN2E2m
        rg2NDba/KcVy6WRyp4UYmTOiM2xAMSODNkK/xpL4ZUppypcxpqwxLM0aGebnaWqUYQsVyh
        2uC7Teul2VnCvNmn+p/LfG47uMHou9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-KWkFFZS2NQK9B3kCPxdXDg-1; Tue, 16 Jun 2020 14:56:42 -0400
X-MC-Unique: KWkFFZS2NQK9B3kCPxdXDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDBED18A8228
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:40 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F8F27CAA8;
        Tue, 16 Jun 2020 18:56:39 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 10/12] Compile the kvm-unit-tests also with Clang
Date:   Tue, 16 Jun 2020 20:56:20 +0200
Message-Id: <20200616185622.8644-11-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To get some more test coverage, let's check compilation with Clang, too.

Message-Id: <20200514192626.9950-12-thuth@redhat.com>
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

