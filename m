Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C93E3AD53D
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 00:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhFRWe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 18:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhFRWey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 18:34:54 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B19CC061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 15:32:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f10so3310052plg.0
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 15:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0rUwRfBUHrHLvZvsLWPVoaLuHADjZ54lSdldCH09ZAQ=;
        b=BytKoG6Emmj6iKoOKTxIMi78cx4sQNJy7WdPqnlo7jHNM113MEGOGKCHwnlyLtDD54
         gGLK/nbfZPocek0Gi/n2hjTjWvIJpBvVEcMRf0XQbp0V7lfs5/DHBQjuVHiRwcPjucMS
         IkFM3fn+M7mwiP4Lk1NkgKcoM/OYNINvGKyI/161fxcJn7MAKfcrhwGLjCezlNI0bJK/
         TqPff4TvY/+NtmBlAntrQJdCY50GyhhSzAsPJOKexqkPnoWIS5whVmOHZufqjj/mTWDY
         xyS7CpZ6+r630T6vv8GBBL/FmvuU8bo4uOyYMofxQhgOJROcFIyKzSYszFkzUONr9YDF
         B43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0rUwRfBUHrHLvZvsLWPVoaLuHADjZ54lSdldCH09ZAQ=;
        b=Q5idmICaC8qISVhrzyhDtumMTDkP6ic95lO++fRcsgCp5kYi2Bn5/ToLb7FLXBpZH9
         gPurFP0wOZzZ/FOTsXtgAAWfOH2DbPNTpCJRMrrEEf+HOuJZgZNCxL0ms/C71K+lWMTO
         SMnIHvFik60HzB/+CpcejR/bx6oxpNsfx6F1HKZ1qyv3L61WbR/d6h/az4UJIUAiXdAL
         Lgr28KS3SKMrFBiIBuFRk1I2agctgoPyHdvfD0qgSLQwv08VkksnKxEkEZHz9arN9eAh
         3pl9TXTnl15eLzKxXoHeHaZaiRP0xSqjuSwjRiwfH5sAVS+KrQn13aDiw6o/hOM5J2T6
         Prlg==
X-Gm-Message-State: AOAM533MUYCRaq41G5XyzN7BLGdHA/wSjWIeuxLp9BvsEX6iyFl2VVNx
        TxDjc9Z+zC7TBEW/e53TEo4dyQ==
X-Google-Smtp-Source: ABdhPJzF1tJD2B2YBVSVpkuGcrA3Q1jKdf/m9r13MqGmDqW9aq5tBIq/06SPurJ/qU8h5JzEek25rA==
X-Received: by 2002:a17:902:a987:b029:11f:d50d:3077 with SMTP id bh7-20020a170902a987b029011fd50d3077mr6658904plb.63.1624055562930;
        Fri, 18 Jun 2021 15:32:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q23sm8929503pff.175.2021.06.18.15.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:32:42 -0700 (PDT)
Date:   Fri, 18 Jun 2021 22:32:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     stsp <stsp2@yandex.ru>, kvm list <kvm@vger.kernel.org>
Subject: Re: guest/host mem out of sync on core2duo?
Message-ID: <YM0fBtqYe+VyPME7@google.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
 <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021, Jim Mattson wrote:
> On Fri, Jun 18, 2021 at 2:55 PM stsp <stsp2@yandex.ru> wrote:
> >
> > 19.06.2021 00:07, Jim Mattson пишет:
> > > On Fri, Jun 18, 2021 at 9:02 AM stsp <stsp2@yandex.ru> wrote:
> > >
> > >> Here it goes.
> > >> But I studied it quite thoroughly
> > >> and can't see anything obviously
> > >> wrong.
> > >>
> > >>
> > >> [7011807.029737] *** Guest State ***
> > >> [7011807.029742] CR0: actual=0x0000000080000031,
> > >> shadow=0x00000000e0000031, gh_mask=fffffffffffffff7
> > >> [7011807.029743] CR4: actual=0x0000000000002041,
> > >> shadow=0x0000000000000001, gh_mask=ffffffffffffe871
> > >> [7011807.029744] CR3 = 0x000000000a709000
> > >> [7011807.029745] RSP = 0x000000000000eff0  RIP = 0x000000000000017c
> > >> [7011807.029746] RFLAGS=0x00080202         DR7 = 0x0000000000000400
> > >> [7011807.029747] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
> > >> [7011807.029749] CS:   sel=0x0097, attr=0x040fb, limit=0x000001a0,
> > >> base=0x0000000002110000
> > >> [7011807.029751] DS:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff,
> > >> base=0x0000000000000000
> > > I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers:
> > >
> > > * If the guest will not be virtual-8086, the different sub-fields are
> > > considered separately:
> > >    - Bits 3:0 (Type).
> > >      * DS, ES, FS, GS. The following checks apply if the register is usable:
> > >        - Bit 0 of the Type must be 1 (accessed).
> >
> > That seems to be it, thank you!
> > At least for the minimal reproducer
> > I've done.
> >
> > So only with unrestricted guest its
> > possible to ignore that field?
> 
> The VM-entry constraints are the same with unrestricted guest.
> 
> Note that *without* unrestricted guest, kvm will generally have to
> emulate the early guest protected mode code--until the last vestiges
> of real-address mode are purged from the descriptor cache. Maybe it
> fails to set the accessed bits in the LDT on emulated segment register
> loads?

Argh!  Check out this gem:

	/*
	 *   Fix the "Accessed" bit in AR field of segment registers for older
	 * qemu binaries.
	 *   IA32 arch specifies that at the time of processor reset the
	 * "Accessed" bit in the AR field of segment registers is 1. And qemu
	 * is setting it to 0 in the userland code. This causes invalid guest
	 * state vmexit when "unrestricted guest" mode is turned on.
	 *    Fix for this setup issue in cpu_reset is being pushed in the qemu
	 * tree. Newer qemu binaries with that qemu fix would not need this
	 * kvm hack.
	 */
	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
		var->type |= 0x1; /* Accessed */


KVM fixes up segs when unrestricted guest is enabled, but otherwise leaves 'em
be, presumably because it has the emulator to fall back on for invalid state.
Guess what's missing in the invalid state check...

I think this should do it:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68a72c80bd3f..a753b9859826 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3427,6 +3427,8 @@ static bool data_segment_valid(struct kvm_vcpu *vcpu, int seg)
                if (var.dpl < rpl) /* DPL < RPL */
                        return false;
        }
+       if (!(var.type & VMX_AR_TYPE_ACCESSES_MASK))
+               return false;

        /* TODO: Add other members to kvm_segment_field to allow checking for other access
         * rights flags
