Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B27C1D616F
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 15:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgEPNxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 09:53:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23485 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbgEPNxS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 May 2020 09:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589637197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ep9D2qqK6+qK8aTeKNlThkLGrmRLOSgUAyG+oSRZmkg=;
        b=FPbXjX7UN5gLrFERnkJyp5O4j0d5qXeb9bGDx8FXhYTcLdiU4cNhYyToQ0ZEJGFByAyWXN
        zUPlyAr3zSroj6eTvqAE86wnKVr4HDwI5Jf6Qam7iXlWzhS3+49qnHY3NKGqtY9/kxOZJp
        ty6x/UoCySZ1C4eouDpaMuKB7NuQfsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-7Y79A0jqPZWvj67vgBJgtQ-1; Sat, 16 May 2020 09:53:16 -0400
X-MC-Unique: 7Y79A0jqPZWvj67vgBJgtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 390F91005510;
        Sat, 16 May 2020 13:53:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3036F5D9D3;
        Sat, 16 May 2020 13:53:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH 0/4] KVM: nSVM: more svm_check_nested_events work
Date:   Sat, 16 May 2020 09:53:07 -0400
Message-Id: <20200516135311.704878-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves exception injection to svm_check_nested_events, which is very
pleasing: it cleans up the recently introduced #DB handling, removes
exit_required, and fixes #UD trapping in the guest (for example
from an RSM instruction, as tested in kvm-unit-tests).

As a bonus, the last patch adds INIT vmexit injection to
svm_check_nested_events as well.  Note that there is no test case for
that yet.

The patches have small conflicts with those I posted yesterday, so
they are on top of them.

Paolo

Paolo Bonzini (4):
  KVM: nSVM: fix condition for filtering async PF
  KVM: nSVM: inject exceptions via svm_check_nested_events
  KVM: nSVM: remove exit_required
  KVM: nSVM: correctly inject INIT vmexits

 arch/x86/kvm/svm/nested.c | 159 ++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.c    |  23 ------
 arch/x86/kvm/svm/svm.h    |   4 +-
 3 files changed, 75 insertions(+), 111 deletions(-)

-- 
2.18.2

