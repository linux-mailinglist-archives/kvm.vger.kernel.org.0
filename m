Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB51B2C85BD
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgK3NkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 08:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbgK3NkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 08:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606743536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5sWo7oHI2vIdCqH/ZBIudC4hEIMfpuKFF5jtRagIg90=;
        b=MR483c4XTRPtaa1lXunZShYKyoegJ2znJilbCvJOCyEciTussSo/JPM7rmRAphqgE++5UB
        PBMyzbSwgme6Ho3uBk8tLkSr7BBiHhGyvSGlwBq5nck3vXxT6ga4iyW3LDxKVhPXNb7s4V
        yBmUTfCNoLpdEEInp+c85X0h46QxBR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-WK7D0nzVMpySt2bDnigDVA-1; Mon, 30 Nov 2020 08:38:54 -0500
X-MC-Unique: WK7D0nzVMpySt2bDnigDVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFCDB805BE0;
        Mon, 30 Nov 2020 13:38:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2D5760867;
        Mon, 30 Nov 2020 13:38:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] RFC: Precise TSC migration
Date:   Mon, 30 Nov 2020 15:38:43 +0200
Message-Id: <20201130133845.233552-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note that to use this feature you need the kernel patches which are=0D
posted to LKML and kvm@vger.kernel.org=0D
=0D
Currently the feature is disabled by default, and enabled with=0D
x-precise-tsc cpu feature.=0D
=0D
Also I changed the TSC and TSC adjust read/write code to go though a specia=
l=0D
function kvm_get_tsc/kvm_set_tsc regardless of enablement of this feature.=
=0D
=0D
The side effect of this is that now we upload to the kernel the TSC_ADJUST=
=0D
msr only on KVM_PUT_RESET_STATE reset level.=0D
This shouldn't matter as I don't think that qemu changes this msr on its ow=
n.=0D
=0D
For migration I added new state field 'tsc_nsec_info', where I save the=0D
'nsec since epoch' timestamp, which is the only new thing that was added to=
 the=0D
migration state.=0D
=0D
First patch in this series is temporary and it just updates the kernel=0D
headers to make qemu compile.=0D
=0D
When the feature is merged to the kernel, a kernel header sync will bring=0D
the same changes to the qemu, making this patch unnecessary.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  Update the kernel headers for 5.10-rc5 + TSC=0D
  Implement support for precise TSC migration=0D
=0D
 include/standard-headers/asm-x86/kvm_para.h |   1 +=0D
 linux-headers/asm-x86/kvm.h                 |   2 +=0D
 linux-headers/linux/kvm.h                   |  70 +++++++++-=0D
 target/i386/cpu.c                           |   1 +=0D
 target/i386/cpu.h                           |   4 +=0D
 target/i386/kvm.c                           | 141 ++++++++++++++++----=0D
 target/i386/machine.c                       |  20 +++=0D
 7 files changed, 211 insertions(+), 28 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

