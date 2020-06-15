Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABFE1F9617
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgFOMK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:10:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728285AbgFOMK0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 08:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592223025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=UZ63vXCgEw6WAGyH4uprnPcFrCOxEXqlq7oGooz1Q4U=;
        b=aA7NvU+kBwtDOQTP68UR+24et4gS4T2BnwqWtRp0hi824e8I7GKWjjj6yzrNR4JIcXMClM
        UtpX6Op/E9m4UOorePJoVzKCZfgGAg+KAaiH0HHg29mm2b3ktMo9RNxdL3Q2dHeq/Ag4cg
        eGbItaU/Z2VZDgBLiEAc7lQMDm1LRoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-yEsnVqOkN4i-qY-2bLIasw-1; Mon, 15 Jun 2020 08:10:21 -0400
X-MC-Unique: yEsnVqOkN4i-qY-2bLIasw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AFF8107BF05
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 12:09:52 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E9155D9DA;
        Mon, 15 Jun 2020 12:09:52 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 0A0E341807D1; Mon, 15 Jun 2020 08:59:53 -0300 (-03)
Date:   Mon, 15 Jun 2020 08:59:53 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: x86: allow TSC to differ by NTP correction bounds
 without TSC scaling
Message-ID: <20200615115952.GA224592@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux TSC calibration procedure is subject to small variations
(its common to see +-1 kHz difference between reboots on a given CPU, for example).

So migrating a guest between two hosts with identical processor can fail, in case
of a small variation in calibrated TSC between them.

Allow a conservative 250ppm error between host TSC and VM TSC frequencies,
rather than requiring an exact match. NTP daemon in the guest can
correct this difference.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3156e25..39a6664 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1772,6 +1772,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 
 	/* TSC scaling supported? */
 	if (!kvm_has_tsc_control) {
+		if (!scale)
+			return 0;
 		if (user_tsc_khz > tsc_khz) {
 			vcpu->arch.tsc_catchup = 1;
 			vcpu->arch.tsc_always_catchup = 1;
@@ -4473,7 +4475,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 		user_tsc_khz = (u32)arg;
 
-		if (user_tsc_khz >= kvm_max_guest_tsc_khz)
+		if (kvm_has_tsc_control &&
+		    user_tsc_khz >= kvm_max_guest_tsc_khz)
 			goto out;
 
 		if (user_tsc_khz == 0)

