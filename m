Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D727FA1F
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgJAHWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgJAHWl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:41 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=KqdZAW3ctfaEaauJwNsn/aYax9MeGE15O+1IM7VJsF0=;
        b=Vu6PuRXI3pnP3YcbWZpUtWJiqAZ7csB3//9U/tYLsHXWm56KQi34Ml7g04MdFxsFHxUiab
        kvE59BAf116JKpBWDHr3uNXrNME1x5F258D9yLrOgyF/WP6h9TXC2R2TFLDRM09Ql7CyGr
        MSQQp2liXWbmuEYdD89PCKM9wXSw6Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-zPhDjnU8MPSL710JJ2hOPQ-1; Thu, 01 Oct 2020 03:22:39 -0400
X-MC-Unique: zPhDjnU8MPSL710JJ2hOPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 286F51018F65
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:38 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3E35619B5;
        Thu,  1 Oct 2020 07:22:36 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 0/7] Update travis CI
Date:   Thu,  1 Oct 2020 09:22:27 +0200
Message-Id: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis now features Ubuntu Focal containers, so we can update our
kvm-unit-tests CI to use it for getting a newer version of QEMU and
the compilers. Thanks to this QEMU update, we can now run more tests
with TCG here.

Additionally, this series switches the second aarch64 build job to
use the native builder - this way we can use the Clang compiler
there to get some additional test coverage. This indeed already helped
to discover some bogus register constraints in the aarch64 code.
(ppc64 and s390x are not using the native builders yet since there are
still some issues with Clang there that I haven't quite figured out ...
that's maybe something for later)

v2:
 - The patch that changed "bionic" into "focal" and the s390x patch
   are already merged, so they are not included here anymore
 - Fixed rebase conflicts in the x86 patches
 - Dropped the hyperv tests from the 32-bit builds (they are going
   to be marked as 64-bit only)

Thomas Huth (7):
  travis.yml: Rework the x86 64-bit tests
  travis.yml: Refresh the x86 32-bit test list
  travis.yml: Add the selftest-setup ppc64 test
  kbuild: fix asm-offset generation to work with clang
  arm/pmu: Fix inline assembly for Clang
  lib/arm64/spinlock: Fix inline assembly for Clang
  travis.yml: Rework the aarch64 jobs

 .travis.yml             | 63 +++++++++++++++++++++++------------------
 arm/pmu.c               | 10 ++++---
 lib/arm64/spinlock.c    |  2 +-
 lib/kbuild.h            |  6 ++--
 scripts/asm-offsets.mak |  5 ++--
 5 files changed, 48 insertions(+), 38 deletions(-)

-- 
2.18.2

