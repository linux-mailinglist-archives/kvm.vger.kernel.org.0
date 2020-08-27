Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7E254AAE
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 18:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgH0Q1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 12:27:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgH0Q1e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 12:27:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598545653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nAUeeK2BuQYFsQta/IVHJijuZ4P+QQy9wWHlAAEXfrY=;
        b=Y4UDiw3sg3FznLLDwU4U00+ASlZciptZROty1CO3ED7S+cBVPIZOAmWjvWo9CMuaIkwPYH
        a5doYTIoqJ8cWfrw/NYLFvsR7HCvrq/yufuTbYY7tNwZpxNrtjRNyBLgHtbTHEsgrcUpaw
        1RXxa5K9freqsXpOrXiLeIRzHryuskk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-48E3qiZPMbekZUWy7CI_mA-1; Thu, 27 Aug 2020 12:27:31 -0400
X-MC-Unique: 48E3qiZPMbekZUWy7CI_mA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8CB718B9F14;
        Thu, 27 Aug 2020 16:27:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07B735C22E;
        Thu, 27 Aug 2020 16:27:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/3] Few nSVM bugfixes
Date:   Thu, 27 Aug 2020 19:27:17 +0300
Message-Id: <20200827162720.278690-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series contains few nested SVM fixes from=0D
testing I did this weekend.=0D
=0D
Patch #1 fixes issue where we were setting the GIF (global interrupt flag)=
=0D
on first nested VMexit, after migration thus making the nested guest crash=
=0D
from unexpected interrupts.=0D
=0D
Patch #2 is my observation that we never setup nesed msr bitmap on nested=0D
state load after migration.=0D
=0D
Patch #3 was 'migrated' ;-) from my other patch series to make it smaller,=
=0D
which is about more strict checks when we about to return to a nested guest=
,=0D
from SMM.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  SVM: nSVM: correctly restore GIF on vmexit from nesting after=0D
    migration=0D
  SVM: nSVM: setup nested msr permission bitmap on nested state load=0D
  KVM: nSVM: more strict SMM checks when returning to nested guest=0D
=0D
 arch/x86/kvm/svm/nested.c |  7 ++++++-=0D
 arch/x86/kvm/svm/svm.c    | 29 ++++++++++++++++++-----------=0D
 2 files changed, 24 insertions(+), 12 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

