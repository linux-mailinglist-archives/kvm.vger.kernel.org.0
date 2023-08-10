Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D903777C3D
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 17:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbjHJPdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 11:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbjHJPdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 11:33:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD832690
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 08:33:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a55650so1850277a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 08:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691681632; x=1692286432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yItIGd+VziiCMmIsL5VeGcajb1T1QATLpzjnEH/QeZs=;
        b=5c5+Pp3d7b+YdcZY1ukYNHFXTfwAdOq+c04n6t/aoc99s8WTG4K/VPMxmTbUJ92g+y
         pOYUpoQfh2N9ecuS5vUqE3Cpt8Qa3uSkWtWg+hEygCUDYTiXzUbiJ+SGdoYHiSVQHKcP
         MEYFB+2LsEAqWAJPzJVPGNQCAjb0GttzgIhVKm9uRsxtXxijPqpkTn+PCxGUn2EmD78d
         oOpj/dD2WGH4XtFI0D5jjxS1uH5OxtiLDLwCZZN5QfE5ITZKehl9GL8mcYsZyZZPwsXL
         gEh4+KpMb6C100UF8mtgp+n3d+ybXrJt/BIL1+/2c+xQ2CUkWU0kE2NX2avh4aGjOgvI
         zT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691681632; x=1692286432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yItIGd+VziiCMmIsL5VeGcajb1T1QATLpzjnEH/QeZs=;
        b=Ij3gsuK0wrEqIR8vo/xCG/ENY3GEpv3FEpSJFyGptZHK5HQ6fHUIpQGT+ltFaZop4l
         /9walpsP2VATaY62nAKimOfJpvg07Y9x2D0EBlMSdbRhaQyFC4Oiy6IMOp6G9fDQnt6P
         qRhpeG+TFV8qCgbnoerQLM++5+c2PRmodX/5CIV0VxeODdVGs9Hpv5RnWE6C0/CbnQ4Z
         TF3gC+OLW9wLyUPZVwnCkmcMNyLWdWYYNmTkawDYjrjoS0/spiEp/iep6gWhnVD+O46L
         nO8hdR4gLhaLlCeJpwIa1LvWrddYvuW7+kjuq4vQe8VNWWzG38/nv26GDK07KHh4JXRB
         r4BA==
X-Gm-Message-State: AOJu0YzyQEYjeYYNBte2dgYj84iF8paqJ45Rg4LFiFwU2nRwfVmYxvQG
        Xhaqi/bcN5Hhf+iA7vMh6ehkcZa2QEc=
X-Google-Smtp-Source: AGHT+IHKhYxH5S9RrnoM3uQHS7d8tGMo4ZXMcinB6EjHqqeLwSbbMdP+1FKkI4jmCpHkYqkToW72SMhnX1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:77c2:0:b0:563:8d36:5d8a with SMTP id
 s185-20020a6377c2000000b005638d365d8amr495418pgc.3.1691681631744; Thu, 10 Aug
 2023 08:33:51 -0700 (PDT)
Date:   Thu, 10 Aug 2023 08:33:50 -0700
In-Reply-To: <941e45b1-49eb-fcba-20d4-71b1db8041c5@redhat.com>
Mime-Version: 1.0
References: <20230808232057.2498287-1-seanjc@google.com> <941e45b1-49eb-fcba-20d4-71b1db8041c5@redhat.com>
Message-ID: <ZNUDXsDaRwczONAu@google.com>
Subject: Re: [PATCH] KVM: x86: Remove WARN sanity check on hypervisor timer
 vs. UNINITIALIZED vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yikebaer Aizezi <yikebaer61@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023, Paolo Bonzini wrote:
> On 8/9/23 01:20, Sean Christopherson wrote:
> >   		/*
> > -		 * It should be impossible for the hypervisor timer to be in
> > -		 * use before KVM has ever run the vCPU.
> > +		 * Don't bother switching APIC timer emulation from the
> > +		 * hypervisor timer to the software timer, the only way for the
> > +		 * APIC timer to be active is if userspace stuffed vCPU state,
> > +		 * i.e. put the vCPU into a nonsensical state.  Only an INIT
> > +		 * will transition the vCPU out of UNINITIALIZED (without more
> > +		 * state stuffing from userspace), which will reset the local
> > +		 * APIC and thus smother the timer anyways, i.e. the APIC timer
> 
> "Cancel" is probably more understandable to non-native speakers, though
> undoubtedly less poetic.

I intentionally avoided "cancel" because there is no guaranteed the timer would
actually be canceled (if KVM switched to the software timer).  I am/was trying to
call out that even if the timer expires and pends an interrupts, the interrupt
will ultimately be dropped.

Maybe "squashed"?
