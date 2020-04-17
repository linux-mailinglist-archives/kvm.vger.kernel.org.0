Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C561AE26B
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 18:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgDQQoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 12:44:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725877AbgDQQoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 12:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587141858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=1zf3L5Eiqysm5g8uOwD9B/4Ckh+3dv+ZAttkjbtK7fY=;
        b=bzU57dht5BUeyZfKDGye9e1/HoMzY9FkAYptVMOQw6gYxoFzUy0XL9TcRztI8fJC18hXYu
        iWuj4UMiYquYKyVKLandXY9xdJ7K73TQPvTrjJDNP/gVFdQesU2KFJwW+povlfd36y0jZj
        3OBmd62xLOjxkDdgzZBneS9VEA63V1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-Pev9DEbNNVW3-99nIAHpJg-1; Fri, 17 Apr 2020 12:44:16 -0400
X-MC-Unique: Pev9DEbNNVW3-99nIAHpJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4133B800D53;
        Fri, 17 Apr 2020 16:44:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE81D10016E8;
        Fri, 17 Apr 2020 16:44:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 1/3] KVM: x86: check_nested_events is never NULL
Date:   Fri, 17 Apr 2020 12:44:11 -0400
Message-Id: <20200417164413.71885-2-pbonzini@redhat.com>
In-Reply-To: <20200417164413.71885-1-pbonzini@redhat.com>
References: <20200417164413.71885-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both Intel and AMD now implement it, so there is no need to check if the
callback is implemented.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59958ce2b681..0492baeb78ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7699,7 +7699,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	 * from L2 to L1 due to pending L1 events which require exit
 	 * from L2 to L1.
 	 */
-	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
+	if (is_guest_mode(vcpu)) {
 		r = kvm_x86_ops.check_nested_events(vcpu);
 		if (r != 0)
 			return r;
@@ -7761,7 +7761,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		 * proposal and current concerns.  Perhaps we should be setting
 		 * KVM_REQ_EVENT only on certain events and not unconditionally?
 		 */
-		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
+		if (is_guest_mode(vcpu)) {
 			r = kvm_x86_ops.check_nested_events(vcpu);
 			if (r != 0)
 				return r;
@@ -8527,7 +8527,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events)
+	if (is_guest_mode(vcpu))
 		kvm_x86_ops.check_nested_events(vcpu);
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
-- 
2.18.2


