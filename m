Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75307EF0F4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbfKDXA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730061AbfKDXAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9AzTCz7VYWqu+O1g8R1BaaHUGHR9Ucr0dBlgPM9xNc=;
        b=c3AwT9wTorKhHR+cO934uPMWZUuPu+W1r+w4qYWQGca7kO2qWmNPKtDtbyCnIdntrz8a1c
        4BqRwtj6kNIZBWUJjDgzPnV1Bmg1/uIonMhPhZAt0VbMIBO9uiav9x/IQfPNQj3nIq/aRM
        3c1gQvswYkCfW91FvjK8sP32BKAdVeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-eiOOitc7MEmU_eGNTeYP_g-1; Mon, 04 Nov 2019 18:00:10 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADA66107ACC3;
        Mon,  4 Nov 2019 23:00:08 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9224600C6;
        Mon,  4 Nov 2019 23:00:02 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
Date:   Mon,  4 Nov 2019 17:59:51 -0500
Message-Id: <20191104230001.27774-4-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: eiOOitc7MEmU_eGNTeYP_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_x86_set_hv_timer and kvm_x86_cancel_hv_timer needs to be defined
to succeed the 32bit kernel build, but they can't be called.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bd17ad61f7e3..1a58ae38c8f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7195,6 +7195,17 @@ void kvm_x86_cancel_hv_timer(struct kvm_vcpu *vcpu)
 {
 =09to_vmx(vcpu)->hv_deadline_tsc =3D -1;
 }
+#else
+int kvm_x86_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+=09=09=09 bool *expired)
+{
+=09BUG();
+}
+
+void kvm_x86_cancel_hv_timer(struct kvm_vcpu *vcpu)
+{
+=09BUG();
+}
 #endif
=20
 void kvm_x86_sched_in(struct kvm_vcpu *vcpu, int cpu)

