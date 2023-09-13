Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476BB79E423
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbjIMJv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbjIMJvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:51:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDD7199E;
        Wed, 13 Sep 2023 02:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=XfpygDLDkqB2bwEWEf6mvs152AUbfDN+/5uofqP+Y+4=; b=rJLiFqQX9ZPumgfMZxt3b77mMh
        kIqTT4KTKSGUgbDG5vzpSb9mupJ1p96HhW+8tiuP28tk1ljHJ1ExjTTLvk6yfh+9DVKeKfj8P73WE
        pmevE3lxRaFzWYnJHgAcV1r26jsdlVt/iW1gkPakyiaTkM8/L5ajiqbt/cmXyt8KrHVEcgamAxN7l
        UbqMLNgW7Vf2QroqVaWkLQq0kQcFkurRughS7zVBWj76y+DXYBGE0Xx1MzdajsNsi6i58E5B1BN6Y
        ThvYdpBJ/n5H21gOylcQB8Swhv47v93TyaQyafKIJ30T+tFdnZ9WnZ5wh1kvIND9peZ326C5Mn/Tf
        qOd09D8w==;
Received: from [89.27.170.32] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qgMXD-00D5yH-3s; Wed, 13 Sep 2023 09:51:47 +0000
Date:   Wed, 13 Sep 2023 11:51:46 +0200
From:   David Woodhouse <dwmw2@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5=5D_KVM=3A_x86/tsc=3A_Don=27t_sync_T?= =?US-ASCII?Q?SC_on_the_first_write_in_state_restoration?=
User-Agent: K-9 Mail for Android
In-Reply-To: <38859747-d4f1-b4e2-98c7-bd529cd09976@gmail.com>
References: <20230913072113.78885-1-likexu@tencent.com> <e506ceb2d837344999c4899525a3490d8c46c95b.camel@infradead.org> <90194cd0-61d8-18b9-980a-b46f903409b4@gmail.com> <461B7217-7AA7-479E-9060-772E243CB03D@infradead.org> <38859747-d4f1-b4e2-98c7-bd529cd09976@gmail.com>
Message-ID: <6E4A54F1-B8C0-44AD-B2A9-6EDF7059D0EC@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13 September 2023 11:43:56 CEST, Like Xu <like=2Exu=2Elinux@gmail=2Ecom=
> wrote:

>> Why? Can't we treat an explicit zero write just the same as when the ke=
rnel does it?
>
>Not sure if it meets your simplified expectations:

Think that looks good, thanks=2E One minor nit=2E=2E=2E


>diff --git a/arch/x86/kvm/x86=2Ec b/arch/x86/kvm/x86=2Ec
>index 6c9c81e82e65=2E=2E0f05cf90d636 100644
>--- a/arch/x86/kvm/x86=2Ec
>+++ b/arch/x86/kvm/x86=2Ec
>@@ -2735,20 +2735,35 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *=
vcpu, u64 data)
> 			 * kvm_clock stable after CPU hotplug
> 			 */
> 			synchronizing =3D true;
>-		} else {
>+		} else if (!data || kvm->arch=2Euser_set_tsc) {

If data is zero here, won't the first if() case have been taken, and set s=
ynchronizing=3Dtrue?

So this is equivalent to "else if (kvm->arch=2Euser_set_tsc)"=2E (Which is=
 fine and what what I intended)=2E

> 			u64 tsc_exp =3D kvm->arch=2Elast_tsc_write +
> 						nsec_to_cycles(vcpu, elapsed);
> 			u64 tsc_hz =3D vcpu->arch=2Evirtual_tsc_khz * 1000LL;
> 			/*
>-			 * Special case: TSC write with a small delta (1 second)
>-			 * of virtual cycle time against real time is
>-			 * interpreted as an attempt to synchronize the CPU=2E
>+			 * Here lies UAPI baggage: when a user-initiated TSC write has
>+			 * a small delta (1 second) of virtual cycle time against the
>+			 * previously set vCPU, we assume that they were intended to be
>+			 * in sync and the delta was only due to the racy nature of the
>+			 * legacy API=2E
>+			 *
>+			 * This trick falls down when restoring a guest which genuinely
>+			 * has been running for less time than the 1 second of imprecision
>+			 * which we allow for in the legacy API=2E In this case, the first
>+			 * value written by userspace (on any vCPU) should not be subject
>+			 * to this 'correction' to make it sync up with values that only
>+			 * from from the kernel's default vCPU creation=2E Make the 1-second
>+			 * slop hack only trigger if flag is already set=2E
>+			 *
>+			 * The correct answer is for the VMM not to use the legacy API=2E
> 			 */
> 			synchronizing =3D data < tsc_exp + tsc_hz &&
> 					data + tsc_hz > tsc_exp;
> 		}
> 	}
>
>+	if (data)
>+		kvm->arch=2Euser_set_tsc =3D true;
>+
> 	/*
> 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
> 	 * TSC, we add elapsed time in this computation=2E  We could let the
>@@ -5536,6 +5551,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *v=
cpu,
> 		tsc =3D kvm_scale_tsc(rdtsc(), vcpu->arch=2El1_tsc_scaling_ratio) + of=
fset;
> 		ns =3D get_kvmclock_base_ns();
>
>+		kvm->arch=2Euser_set_tsc =3D true;
> 		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
> 		raw_spin_unlock_irqrestore(&kvm->arch=2Etsc_write_lock, flags);
>
>
