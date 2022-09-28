Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575B65EE6C5
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 22:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiI1UpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 16:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiI1Uov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 16:44:51 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83520110D
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 13:44:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lx7so6563253pjb.0
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 13:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Vdbd3ulUXBGBc17CxMn5J69DULA+Of7+9gUX+29F9hg=;
        b=rRgYmA36A88TMq0xkAhH2g3RVfk7DGY20N2SAcxV76lx/Td1UXHyEj0WvIFdcrSVwO
         qS3yRzGMyD+kkje1aIUlU3+mf8anLceaq8CC9Oa92Ub67hFzqpRFpfdUpiQj/J01t+Q8
         P630ne57RF9w5e0sidUK3rBoFfAadHl0NX9NAkRIChI5x1iDfRooe/ullrP1wK/SfFo6
         +vX+TkZ4yo2d9ESnik1Mb5jbCaWGxMBCkdPIfxSb6oegrgtCjHnVI2YeQbTNcAsMi5Mq
         AJvIcEVPIf80ETgnDPNdpf9TfhZUUbjRS4aWpCGuhumkXJkEt1WCS3nHaLN2VBB3TN0J
         3plA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Vdbd3ulUXBGBc17CxMn5J69DULA+Of7+9gUX+29F9hg=;
        b=FE8CVXScQ6a5NTrTJCUglSUbNDuRr6qfmy4LjGT38jr38Y9/ITuJXkY+ZPP+FjLvKw
         YH9BtW8YTKQyQvSPTYEFz614QNcads77iAcU/wQV7oVtbsHldEsozOFSpY0UaUDoplng
         co3Xl1t6B/sY8oW8s9QxNmYIUhJT4uNc+KPR0HomeuSzMlYWpf1ccSbTVS7KiGrjWLmF
         rLMclCbLxi3luCrPzu2FOQzZ2bGlRD5Rb1RlUvxO3b9zwfhIx530TdaYO9Y6TvdTHbjf
         40PAHpijSf4OXwmiFPzfNJLOpqU8Qu6DEAFXb3SeFE7iU7pmlLx1G/9/4O1ULE06CePC
         x0RA==
X-Gm-Message-State: ACrzQf0KSFaZ2mnKyMRgCJXylP+a8Iy4b1C5ECdSQct3RNi/kORBdn2W
        OzM1zhwU2ZMK8cGNBTURoakbDQ==
X-Google-Smtp-Source: AMsMyM4ivm1mIffq+6jbSHGX7GyxSYZ5r/9aMnzoa8fPG673WUexpILjoZ7Bo3Su0MuOfE2tDm8VQQ==
X-Received: by 2002:a17:90a:2f43:b0:205:f4dc:a47b with SMTP id s61-20020a17090a2f4300b00205f4dca47bmr4555625pjd.62.1664397888386;
        Wed, 28 Sep 2022 13:44:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b0016ed8af2ec0sm1096143ply.29.2022.09.28.13.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 13:44:47 -0700 (PDT)
Date:   Wed, 28 Sep 2022 20:44:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
Message-ID: <YzSyPBjTeFVjxh3l@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-6-seanjc@google.com>
 <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
 <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
 <YzR7ezt67i1lH1/b@google.com>
 <1aea43e831cd7ed90c325b2c90bc6f3f9a1805b5.camel@redhat.com>
 <YzSMbSXQXyUY7M7G@google.com>
 <6fcec4adb331452c64adf255c367af86072bd9d3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fcec4adb331452c64adf255c367af86072bd9d3.camel@redhat.com>
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
> On Wed, 2022-09-28 at 18:03 +0000, Sean Christopherson wrote:
> > On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> > > On Wed, 2022-09-28 at 16:51 +0000, Sean Christopherson wrote:
> > > > > > It happens regardless of vCPU count (tested with 2, 32, 255, 380, and 
> > > > > > 512 vCPUs). This state persists for all subsequent reboots, until the VM 
> > > > > > is terminated. For vCPU counts < 256, when x2apic is disabled the 
> > > > > > problem does not occur, and AVIC continues to work properly after reboots.
> > > > 
> > > > Bit of a shot in the dark, but does the below fix the issue?  There are two
> > > > issues with calling kvm_lapic_xapic_id_updated() from kvm_apic_state_fixup():
> > > > 
> > > >   1. The xAPIC ID should only be refreshed on "set".
> > > True - I didn't bother to fix it yet because it shouldn't cause harm, but
> > > sure this needs to be fixed.
> > 
> > It's probably benign on its own, but with the missing "hardware enabled" check,
> > it could be problematic if userspace does KVM_GET_LAPIC while the APIC is hardware
> > disabled, after the APIC was previously in x2APIC mode.  I'm guessing QEMU does
> > KVM_GET_LAPIC state when emulating reboot, hence the potential for being involved
> > in the bug Alejandro is seeing.
> > 
> > > >   2. The refresh needs to be noted after memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
> > > Are you sure? The check is first because if it fails, then error is returned to userspace
> > > and the KVM's state left unchanged.
> > > 
> > > I assume you are talking about 
> > > 
> > >         ....
> > > 	r = kvm_apic_state_fixup(vcpu, s, true);
> > > 	if (r) {
> > > 		kvm_recalculate_apic_map(vcpu->kvm);
> > > 		return r;
> > > 	}
> > > 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
> > 
> > This isn't a failure path though, it's purely a "take note of the update", and
> > KVM needs to do that processing _after_ the actual update.  Specifically,
> > kvm_lapic_xapic_id_updated() consumes the internal APIC state:
> 
> Yes, I somehow blindly assumed that kvm_apic_state_fixup actually checks
> the new state and not the existing state.
> 
> Probably because my original code did that, I think it just checked the 'id'
> variable.. Oh well.
> Thanks for catching this bug!

This was indeed the bug Alejandro hit.  QEMU does KVM_SET_LAPIC and KVM checks
the stale vAPIC state.  Because the vCPU was in x2APIC mode, the 32-bit ID is
in bits 31:0, not bit 31:24, and so kvm_xapic_id() returned '0' instead of the
correct ID.
