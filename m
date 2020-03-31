Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13330199F58
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgCaToN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:44:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55068 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727768AbgCaToN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585683852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mcpjr22EubvpvBv5U1Nr7UCjm49Gd0MVWUusU3L0BO0=;
        b=FDGCzUwU6vM5CNSPQQe1037cgWkeeXubKUqlK6RE5HzlETqTctOcXCaPGiWO3+4w9DIZRK
        R6LaZhDPNjbFF0YA8RtUXpk/J8FKhfY1LHjso8dDmj03cDPO15kzaEgYwsiTsmBdNRyXZr
        JR62L4ez/QlYklQyzoeMnl7xkq3GKzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-mi-6gqLsPvy_dhd7NAlIvA-1; Tue, 31 Mar 2020 15:40:30 -0400
X-MC-Unique: mi-6gqLsPvy_dhd7NAlIvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E35C11084426;
        Tue, 31 Mar 2020 19:40:28 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-184.phx2.redhat.com [10.3.118.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38C945C1BB;
        Tue, 31 Mar 2020 19:40:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6A6F42202D7; Tue, 31 Mar 2020 15:40:20 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, aarcange@redhat.com,
        dhildenb@redhat.com
Subject: [PATCH 3/4] kvm: Always get async page notifications
Date:   Tue, 31 Mar 2020 15:40:10 -0400
Message-Id: <20200331194011.24834-4-vgoyal@redhat.com>
In-Reply-To: <20200331194011.24834-1-vgoyal@redhat.com>
References: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, we seem to get async pf related notifications only if guest
is in user mode, or if it is in kernel mode and CONFIG_PREEMPTION is
enabled. I think idea is that if CONFIG_PREEMPTION is enabled then it
gives us opportunity to schedule something else if page is not ready.

If KVM_ASYNC_PF_SEND_ALWAYS is not set, then host will not send
notifications of PAGE_NOT_PRESENT/PAGE_READY. Instead once page
has been installed guest will run.

Now we are adding capability to report errors as part of async pf
protocol. That means we need async pf related notifications so that
we can make a task wait and when error is reported, we can either
send SIGBUS to user process or search through exception tables for
possible error handler.

Hence enable async pf notifications always. Not sure if this will
have noticieable performance implication though.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/kvm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 42d17e8c0135..97753a648133 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -336,9 +336,7 @@ static void kvm_guest_cpu_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
 		u64 pa =3D slow_virt_to_phys(this_cpu_ptr(&apf_reason));
=20
-#ifdef CONFIG_PREEMPTION
 		pa |=3D KVM_ASYNC_PF_SEND_ALWAYS;
-#endif
 		pa |=3D KVM_ASYNC_PF_ENABLED;
=20
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
--=20
2.25.1

