Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2A94A9B21
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 15:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359374AbiBDOlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 09:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiBDOll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 09:41:41 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13871C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 06:41:41 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k17so5355411plk.0
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 06:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dg20lHH+5hD5YQZ8GrVegKK1/VjQk9NXTtH1Zx4dOJI=;
        b=Q0O6T9mUzP6wJy9zhpgHJbkyvT10vvCO1wiEmaykAZR23D+4jFHhT8dkvhBY2lp6Yd
         kMAlLCr04o35/20X5iGzoiO9n672vtaUb9rr5gs7ZElqOxPpEopgPtaAV4GdDU0wlFkM
         ihj2/UrAuFCGA/jNATtlzzl4awHx2drn0ReV1ZGuXnq0zmG/iom8TvKZoVxVi9Yaczwz
         PqGPi/eTeQwWjqeu4gfbVMsnctKbwZebEDngDIYqtJIqDemnHoPipyI7iEyB1sZb7fEW
         C4FS6Pb653PwLX4O6Y6lQlO52zbpC8TddXFgxgGLdBQALrSUAWRawK6su8G/93ztDNzW
         BNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dg20lHH+5hD5YQZ8GrVegKK1/VjQk9NXTtH1Zx4dOJI=;
        b=x00d64DS7w3L4ot/AlZNicI/c0b4bX4+zfQQIBvK6vf6hR/M5XZ2eCvYc36fF+K2ap
         eLi8tWT/Qrr3hNEJiBSTLIuJsNf+VXe9xFVCdSON6SPc0guoW8pSUd9EuvJKAN7XjSyT
         +wTZ1Al2bzxSyvIifQDZguXqQiv4MWWeELHc/nhD2qzP9rDRhbG7pivf7vWiKWOiy7+L
         cBjM/UBCdYiTE4uyPp0dKmYwM2W1wTZ7tgeXdYW073yvTCueIR882mktEw1Z3PuIrbvx
         LJOXiDT/gpIo2/MsFF7qkitz7O2kEQdaj+RsTz+LKlNjZSeB0rOg4H2U54KP7cMEPQSk
         jvCg==
X-Gm-Message-State: AOAM532Kf3rPLH5zauePhQ2X5stJN6Ie71kANNmDd5PIR7/BRI54rvhs
        g3XWSSbiPFX/C1vaHUboQ+OG+g==
X-Google-Smtp-Source: ABdhPJxuZ3MRzFW5Hq5CFl1LOZ2xYN55KrXKqNYxi4zn6Kz1Gif+qEnOXKdqDWkXy6BdB1YNpaeU3Q==
X-Received: by 2002:a17:902:d702:: with SMTP id w2mr3264277ply.17.1643985697349;
        Fri, 04 Feb 2022 06:41:37 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h25sm2634724pfn.208.2022.02.04.06.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:41:36 -0800 (PST)
Date:   Fri, 4 Feb 2022 06:41:32 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
Message-ID: <Yf07HATXyDDeE68t@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
 <YfdaKpBqFkULxgX/@google.com>
 <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
 <Yfl+Pz4MWOyEHfhf@google.com>
 <CAAeT=Fx3oBoyUmJjyMWmeyzMJJxcAZAYWDQuv4DUqZztm8ooKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fx3oBoyUmJjyMWmeyzMJJxcAZAYWDQuv4DUqZztm8ooKQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 10:31:26PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Tue, Feb 1, 2022 at 10:39 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Hey Reiji,
> >
> > On Mon, Jan 31, 2022 at 10:00:40PM -0800, Reiji Watanabe wrote:
> > > Hi Ricardo,
> > >
> > > On Sun, Jan 30, 2022 at 7:40 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > >
> > > > On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> > > > > Hi Ricardo,
> > > > >
> > > > > > > > > +
> > > > > > > > > +/*
> > > > > > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > > > > > + */
> > > > > > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > > > > > +{
> > > > > > > > > +     int i;
> > > > > > > > > +     u32 id;
> > > > > > > > > +     const struct sys_reg_desc *rd;
> > > > > > > > > +     u64 val;
> > > > > > > > > +
> > > > > > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > > > > > +             rd = &sys_reg_descs[i];
> > > > > > > > > +             if (rd->access != access_id_reg)
> > > > > > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > > > > > +                     continue;
> > > > > > > > > +
> > > > > > > > > +             id = reg_to_encoding(rd);
> > > > > > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > > > > > +                     /* Shouldn't happen */
> > > > > > > > > +                     continue;
> > > > > > > > > +
> > > > > > > > > +             val = read_sanitised_ftr_reg(id);
> > > > > > > >
> > > > > > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > > > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > > > > > >
> > > > > > > I'm not sure if I understand your question.
> > > > > > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > > > > > userspace tries to modify a value of ID registers.
> > > > > > > With this patch, KVM just saves the sanitized values in the kvm's
> > > > > > > buffer, but userspace is still not allowed to modify values of ID
> > > > > > > registers yet.
> > > > > > > I hope it answers your question.
> > > > > >
> > > > > > Based on the previous commit I was assuming that some registers, like
> > > > > > id_aa64dfr0,
> > > > > > would default to the overwritten values as the sanitized values. More
> > > > > > specifically: if
> > > > > > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > > > > > KVM overwritten
> > > > > > values (arm64_ftr_bits_kvm)?
> > > > >
> > > > > arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> > > > > and arm64_ftr_bits_kvm doesn't have the sanitized values.
> > > > >
> > > > > Thanks,
> > > >
> > > > Hey Reiji,
> > > >
> > > > Sorry, I wasn't very clear. This is what I meant.
> > > >
> > > > If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
> > > > series:
> > > >
> > > >  static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
> > > >         S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> > > > -       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> > > > +       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),
> > > >
> > > > it means that userspace would not be able to set DEBUGVER to anything
> > > > but 0x5. But I'm not sure what it should mean for the default KVM value
> > > > of DEBUGVER, specifically the value calculated in set_default_id_regs().
> > > > As it is, KVM is still setting the guest-visible value to 0x6, and my
> > > > "desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
> > > > booted a VM and the DEBUGVER value from inside is still 0x6. I was
> > > > expecting it to not boot, or to show a warning.
> > >
> > > Thank you for the explanation!
> > >
> > > FTR_EXACT (in the existing code) means that the safe_val should be
> > > used if values of the field are not identical between CPUs (see how
> > > update_cpu_ftr_reg() uses arm64_ftr_safe_value()). For KVM usage,
> > > it means that if the field value for a vCPU is different from the one
> > > for the host's sanitized value, only the safe_val can be used safely
> > > for the guest (purely in terms of CPU feature).
> >
> > Let me double check my understanding using the DEBUGVER example, please.
> > The safe_value would be DEBUGVER=5, and it contradicts the initial VM
> > value calculated on the KVM side. Q1: Can a contradiction like this
> > occur in practice? Q2: If the user saves and restores this id-reg on the
> > same kernel, the AA64DFR0 userspace write would fail (ftr_val !=
> > arm64_ftr_safe_value), right?
> 
> Thank you for the comment!
> 
> For Q1, yes, we might possibly create a bug that makes a contradiction
> between KVM and cpufeature.c.
> For Q2, even with such a contradiction, userspace will still be able to
> save and restore the id reg on the same kernel on the same system in most
> cases because @limit that KVM will specify for arm64_check_features()
> will mostly be the same as the initial value for the guest (except for
> fields corresponding to opt-in CPU features, which are configured with
> KVM_ARM_VCPU_INIT or etc) and arm64_check_features does an equality check
> per field.  Having said that, as you suggested, it might be better to run
> arm64_check_features for the initial value against the host value so we
> can catch such a bug. I'll look into doing that in v5.
> 

Thanks Reiji. Looking forward to v5.

> Thanks,
> Reiji
