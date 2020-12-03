Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395322CDC38
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbgLCRR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:17:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbgLCRRY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607015757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cR3WCJq9d7LvMDlf7M0tIlYK9KyXcPJkybrgmwJqmcM=;
        b=ESZ2rLiE7RBB4RMYrrPjdRZy1yD4vyl3qnN/WfyYBFRJ0y8te99/ePSTu8VH3XYvZ64OSS
        H9hC6NjNDO/wjyuhMAH4/XAyAxrmaBfuhs5b2CWRGLKoQQArL4xdw+QoS5ccwM8XYVx2Fk
        8QbOpC6Xy9Xcan/GcHWhOVIZ3ugztV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-tW323KgXM-6_kPnBfxoCwQ-1; Thu, 03 Dec 2020 12:15:56 -0500
X-MC-Unique: tW323KgXM-6_kPnBfxoCwQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 979AB858180;
        Thu,  3 Dec 2020 17:15:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 084AC5D6AC;
        Thu,  3 Dec 2020 17:15:47 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/2] RFC: Precise TSC migration
Date:   Thu,  3 Dec 2020 19:15:44 +0200
Message-Id: <20201203171546.372686-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note that to use this feature you need the kernel patches which are=0D
posted to LKML and kvm@vger.kernel.org=0D
=0D
The feature is disabled by default, and can be enabled with=0D
-accel kvm,x-precise-tsc=3Don.=0D
=0D
I changed the TSC and TSC adjust read/write code to go though a special=0D
function kvm_get_tsc/kvm_set_tsc regardless of enablement of this feature.=
=0D
=0D
The side effect of this is that now we upload to the kernel the TSC_ADJUST=
=0D
msr only on KVM_PUT_RESET_STATE reset level.=0D
This shouldn't matter as I don't think that qemu changes this msr on its ow=
n.=0D
=0D
For migration I added a new state field 'cpu/tsc_ns_timestamp',=0D
where I save the TSC nanosecond timestamp, which is the only=0D
new thing that was added to the migration state.=0D
=0D
First patch in this series is temporary and it just updates the kernel=0D
headers to make qemu compile.=0D
=0D
When the feature is merged to the kernel, a kernel header sync will bring=0D
the same changes to the qemu, making this patch unnecessary.=0D
=0D
V2:=0D
=0D
- switched to -accel for enablement=0D
- sync with updated kernel patches=0D
- minor cleanups, renames, etc=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  Update the kernel headers for 5.10-rc5 + TSC=0D
  Implement support for precise TSC migration=0D
=0D
 accel/kvm/kvm-all.c                         |  28 ++++=0D
 include/standard-headers/asm-x86/kvm_para.h |   1 +=0D
 include/sysemu/kvm.h                        |   1 +=0D
 linux-headers/asm-x86/kvm.h                 |   2 +=0D
 linux-headers/linux/kvm.h                   |  71 +++++++++-=0D
 target/i386/cpu.h                           |   1 +=0D
 target/i386/kvm.c                           | 140 ++++++++++++++++----=0D
 target/i386/machine.c                       |  19 +++=0D
 8 files changed, 234 insertions(+), 29 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

