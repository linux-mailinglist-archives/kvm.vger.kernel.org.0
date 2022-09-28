Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183D15EE248
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiI1QvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiI1QvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:51:13 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D17D62EE
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:51:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id bh13so12735883pgb.4
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=h0/015q9L2PTjIc0Q6cg/qKsJjdE+BVvbhky4mrZGZM=;
        b=PMsN7p0cKAT4VWUKKy/cQ5tldNzUKfl8S/iKkTeJd2YgRdYeuJp+T5PUfCv+fHny+d
         hqnF0i1t43QpVhk6oUsPKh3o8uGSWVEn7Vf8ngPTvhmR6R4Bz8UtguBd+nlIiNUSiN/5
         pHzNa2j6eGOH2COHhtWC71kdLHGPo0teUkL0IyAblnYmo3DPb2XaivaHU6ia0G6w5fBg
         WRqrZfMSFPs71USTIU21Zzfjv0PGrOsXfaCHZ31OmS7Xt5Nm4pAoANf34lbGcM6Z2gBN
         EK2Bn5+0ChzxYBRq9pBBOzxbP+1doa6IHmGaJ/0lS1RaPf1/XGlOzBCQX9FPYwisqp85
         m7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=h0/015q9L2PTjIc0Q6cg/qKsJjdE+BVvbhky4mrZGZM=;
        b=HrSPOllMVEA+1+KvEHk92yo5Rilsmu3owIpwbS4rWS5VG9647DgE3JjF4uS/LMZd4e
         lmM9daKx8MU6nmgthxBXSXP+YAi9kO7NAAqwDsDrvMWyCjjkdRkAjfxy4hEAivQBEvmA
         GgCUJvCs3sxdxiET4dWjb+uPQ+n0kNtGltOrGdtRAM1vOqPZuSx6VMVwJgTA4OcJT6v9
         RpWNhTfDql8RFsQEYta33FChRX0bt+VaS/HjMtXXiWhfFToXKflS8eWFATPJZhDCeqrw
         u3vesCtJgTA3DBjkPZrkEEvPk4BbmmO4TtOAuAThSSHhmlKsg5VRwp1xdJIMyyNvpadK
         khKw==
X-Gm-Message-State: ACrzQf3gcKFeFsisrkfxUxgrGkEoA5rf/1ChPc2ZL3NM7RUjyRNEH1nO
        XjC1FF6HsoQzZZQKNhDITYuHHg==
X-Google-Smtp-Source: AMsMyM5vVHEoIsYqOLkieF1u6g8g4gr3wk24/aXYtDofpThSTalf0iOgDSoFGIk5R3jqzqOF3L5cHA==
X-Received: by 2002:a63:50e:0:b0:438:d16d:e8c1 with SMTP id 14-20020a63050e000000b00438d16de8c1mr28317051pgf.505.1664383871552;
        Wed, 28 Sep 2022 09:51:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d2-20020a170903230200b00176677a893bsm617874plh.82.2022.09.28.09.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 09:51:10 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:51:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
Message-ID: <YzR7ezt67i1lH1/b@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-6-seanjc@google.com>
 <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
 <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> On Tue, 2022-09-27 at 23:15 -0400, Alejandro Jimenez wrote:
> > 
> > On 9/20/2022 7:31 PM, Sean Christopherson wrote:
> > > Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
> > > it against the xAPIC ID to avoid false positives (sort of) on systems
> > > with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
> > > APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
> > > it's original value,
> > > 
> > > The mismatch isn't technically a false positive, as architecturally the
> > > xAPIC IDs do end up being aliased in this scenario, and neither APICv
> > > nor AVIC correctly handles IPI virtualization when there is aliasing.
> > > However, KVM already deliberately does not honor the aliasing behavior
> > > that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
> > > resulting APICv/AVIC behavior is aligned with KVM's existing behavior
> > > when KVM's x2APIC hotplug hack is effectively enabled.
> > > 
> > > If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
> > > piggyback whatever logic disables the optimized APIC map (which is what
> > > provides the hotplug hack), i.e. so that KVM's optimized map and APIC
> > > virtualization yield the same behavior.
> > > 
> > > For now, fix the immediate problem of APIC virtualization being disabled
> > > for large VMs, which is a much more pressing issue than ensuring KVM
> > > honors architectural behavior for APIC ID aliasing.
> > 
> > I built a host kernel with this entire series on top of mainline 
> > v6.0-rc6, and booting a guest with AVIC enabled works as expected on the 
> > initial boot. The issue is that during the first reboot AVIC is 
> > inhibited due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED, and I see 
> > constant inhibition events due to APICV_INHIBIT_REASON_IRQWIN as seen in 
> 
> 
> APICV_INHIBIT_REASON_IRQWIN is OK, because that happens about every time
> the good old PIT timer fires which happens on reboot.
> 
> APICV_INHIBIT_REASON_APIC_ID_MODIFIED should not happen as you noted,
> this needs investigation.

Ya, I'll take a look.

> > It happens regardless of vCPU count (tested with 2, 32, 255, 380, and 
> > 512 vCPUs). This state persists for all subsequent reboots, until the VM 
> > is terminated. For vCPU counts < 256, when x2apic is disabled the 
> > problem does not occur, and AVIC continues to work properly after reboots.

Bit of a shot in the dark, but does the below fix the issue?  There are two
issues with calling kvm_lapic_xapic_id_updated() from kvm_apic_state_fixup():

  1. The xAPIC ID should only be refreshed on "set".

  2. The refresh needs to be noted after memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));

and a third bug in the helper itself, as changes to the ID should be ignored if
the APIC is hardward disabled since the ID is reset to the vcpu_id when the APIC
is hardware enabled (architecturally behavior).

---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 804d529d9bfb..b8b2faf5abc7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2159,6 +2159,9 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 {
 	struct kvm *kvm = apic->vcpu->kvm;
 
+	if (!kvm_apic_hw_enabled(apic))
+		return;
+
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 
@@ -2875,8 +2878,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
-	} else {
-		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}
 
 	return 0;
@@ -2912,6 +2913,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+	if (!apic_x2apic_mode(vcpu->arch.apic))
+		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
+
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);

base-commit: 0b502152c0b8523f399bdb53096e2d620c5795b5
-- 

