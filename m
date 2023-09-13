Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB6C79E3B5
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbjIMJaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjIMJaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A0F10DD;
        Wed, 13 Sep 2023 02:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=BYNLXBo0bL67GPqYQl9HGYIz6cphXRkKLo87ZYOM0ns=; b=o+iKtUwmbYyLhUvUBpleugkAp7
        kOmB4pyjzNZKP88yrfQ3243OyFHKsZgnYr+3vhW3rAqNnQx6lcCi7Jy1ZTt631WiPcEr0Aoqj9AVs
        PXDISGpMnbPnq2ntOnMGbaRrfEqeIB9sk0Tz1Z83TvnQgQsprQuzmRTn54TsCuPlHT0uP7GWXQQ1P
        uSVnz1pc1LIkOGiQTJzunrK1kaViDH9P2InUKMNW5jsKpy+FY+TBRv7V+V+GjqqMnuvWOxMWVDg5M
        l0i6coOwFfbh3AQS/4upLtGog+jp8D02+BWC8ml1Y4Do5gaS/iYnAEiTfQzg7fvHQTl6q3Bbo6hIA
        4kiIqZkQ==;
Received: from [89.27.170.32] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qgMCF-00D0hd-Eq; Wed, 13 Sep 2023 09:30:07 +0000
Date:   Wed, 13 Sep 2023 11:30:06 +0200
From:   David Woodhouse <dwmw2@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5=5D_KVM=3A_x86/tsc=3A_Don=27t_sync_T?= =?US-ASCII?Q?SC_on_the_first_write_in_state_restoration?=
User-Agent: K-9 Mail for Android
In-Reply-To: <90194cd0-61d8-18b9-980a-b46f903409b4@gmail.com>
References: <20230913072113.78885-1-likexu@tencent.com> <e506ceb2d837344999c4899525a3490d8c46c95b.camel@infradead.org> <90194cd0-61d8-18b9-980a-b46f903409b4@gmail.com>
Message-ID: <461B7217-7AA7-479E-9060-772E243CB03D@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13 September 2023 11:17:49 CEST, Like Xu <like=2Exu=2Elinux@gmail=2Ecom=
> wrote:
>> I think you also need to set kvm->arch=2Euser_set_tsc() in
>> kvm_arch_tsc_set_attr(), don't you?
>
>How about:
>
>diff --git a/arch/x86/kvm/x86=2Ec b/arch/x86/kvm/x86=2Ec
>index c55cc60769db=2E=2E374965f66137 100644
>--- a/arch/x86/kvm/x86=2Ec
>+++ b/arch/x86/kvm/x86=2Ec
>@@ -5545,6 +5545,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *v=
cpu,
> 		tsc =3D kvm_scale_tsc(rdtsc(), vcpu->arch=2El1_tsc_scaling_ratio) + of=
fset;
> 		ns =3D get_kvmclock_base_ns();
>
>+		kvm->arch=2Euser_set_tsc =3D true;
> 		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
> 		raw_spin_unlock_irqrestore(&kvm->arch=2Etsc_write_lock, flags);

Yep, that looks good=2E


>> This comment isn't quite right; it wants to use some excerpt of the
>> commit message I've suggested above=2E
>
>How about:
>
>@@ -2735,20 +2735,34 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *=
vcpu, u64 data)
> 			 * kvm_clock stable after CPU hotplug
> 			 */
> 			synchronizing =3D true;
>-		} else {
>+		} else if (kvm->arch=2Euser_set_tsc) {
> 			u64 tsc_exp =3D kvm->arch=2Elast_tsc_write +
> 						nsec_to_cycles(vcpu, elapsed);
> 			u64 tsc_hz =3D vcpu->arch=2Evirtual_tsc_khz * 1000LL;
> 			/*
>-			 * Special case: TSC write with a small delta (1 second)
>-			 * of virtual cycle time against real time is
>-			 * interpreted as an attempt to synchronize the CPU=2E
>+			 * Here lies UAPI baggage: user-initiated TSC write with
>+			 * a small delta (1 second) of virtual cycle time
>+			 * against real time is interpreted as an attempt to
>+			 * synchronize the CPU=2E

Much better, thanks=2E But I don't much like "an attempt to synchronize th=
e CPU"=2E=20

In my response to Sean I objected to that classification=2E Userspace is j=
ust *setting* the TSC=2E There is no dedicated intent to "synchronize" it=
=2E It just sets it, and the value just *might* happen to be in sync with a=
nother vCPU=2E=20

It's just that our API is so fundamentally broken that it *can't* be in sy=
nc, so we "help" it a bit if it looks close=2E

So maybe=2E=2E=2E

Here lies UAPI baggage: when a user-initiated TSC write has a small delta =
(1 second) of virtual cycle time against the previously set vCPU, we assume=
 that they were intended to be in sync and the delta was only due to the ra=
cy nature of the legacy API=2E

>+			 * This trick falls down when restoring a guest which genuinely
>+			 * has been running for less time than the 1 second of imprecision
>+			 * which we allow for in the legacy API=2E In this case, the first
>+			 * value written by userspace (on any vCPU) should not be subject
>+			 * to this 'correction' to make it sync up with values that only
>+			 * from from the kernel's default vCPU creation=2E Make the 1-second
>+			 * slop hack only trigger if flag is already set=2E
>+			 *
>+			 * The correct answer is for the VMM not to use the legacy API=2E




>> Userspace used to be able to write zero to force a sync=2E You've remov=
ed
>> that ability from the ABI, and haven't even mentioned it=2E Must we?
>
>Will continue to use "bool user_initiated" for lack of a better move=2E

Why? Can't we treat an explicit zero write just the same as when the kerne=
l does it?
