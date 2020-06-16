Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258E11FBAE7
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbgFPQPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:15:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731536AbgFPQPQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 12:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592324115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DZiLPWz8tGyf2nq5zcM61Q3toxd9Lry4Lg91Iu4Wmfo=;
        b=RJChc1jZd3AqYs2oLWQSog9jzaonM1tWv3UhwirdTSRAev4Pw1Xbnuu3LmRUMjfZlgY1NH
        ovO90e5fv8ZOArwmytoLIrZAdFSx2CPIyy3ozwo/mwoxTvPlCndtoivhACTRPx6FxyH4zx
        vWUFSj60lOXN8ehiKy0iWugc2uaxVEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-wKsb1WAUP1yyDdZj35nrQg-1; Tue, 16 Jun 2020 12:15:13 -0400
X-MC-Unique: wKsb1WAUP1yyDdZj35nrQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D869D5AEC7
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 16:15:12 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-9.gru2.redhat.com [10.97.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C0457CAA0;
        Tue, 16 Jun 2020 16:15:12 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 622D041807CE; Tue, 16 Jun 2020 08:47:41 -0300 (-03)
Date:   Tue, 16 Jun 2020 08:47:41 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2] KVM: x86: allow TSC to differ by NTP correction bounds
 without TSC scaling
Message-ID: <20200616114741.GA298183@fuller.cnet>
References: <20200615115952.GA224592@fuller.cnet>
 <646f0beb-e050-ed2f-397b-a9afa2891e4f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <646f0beb-e050-ed2f-397b-a9afa2891e4f@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


The Linux TSC calibration procedure is subject to small variations
(its common to see +-1 kHz difference between reboots on a given CPU, for example).

So migrating a guest between two hosts with identical processor can fail, in case
of a small variation in calibrated TSC between them.

Without TSC scaling, the current kernel interface will either return an error
(if user_tsc_khz <= tsc_khz) or enable TSC catchup mode.

This change enables the following TSC tolerance check to
accept KVM_SET_TSC_KHZ within tsc_tolerance_ppm (which is 250ppm by default).

        /*
         * Compute the variation in TSC rate which is acceptable
         * within the range of tolerance and decide if the
         * rate being applied is within that bounds of the hardware
         * rate.  If so, no scaling or compensation need be done.
         */
        thresh_lo = adjust_tsc_khz(tsc_khz, -tsc_tolerance_ppm);
        thresh_hi = adjust_tsc_khz(tsc_khz, tsc_tolerance_ppm);
        if (user_tsc_khz < thresh_lo || user_tsc_khz > thresh_hi) {
                pr_debug("kvm: requested TSC rate %u falls outside tolerance [%u,%u]\n", user_tsc_khz, thresh_lo, thresh_hi);
                use_scaling = 1;
        }

NTP daemon in the guest can correct this difference (NTP can correct upto 500ppm).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---

v2: improve changelog (Paolo Bonzini)

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

