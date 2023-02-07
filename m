Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A849268DE0D
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 17:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBGQiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 11:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBGQiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 11:38:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D3A4
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 08:38:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e19so8290956plc.9
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 08:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2So4hv1hi8BG5UUukFb3+REHHKPjn28YFwULPpBOJLk=;
        b=WD7a0RXfAR2IFHAOllVUw8jakwuoLsXLLs6ixFHKdmY+6Wus3qK8CD/1XDZtC1dIUg
         RooS0coMvNT1WjlROoiAdP0pX0azC1wONTrncHHJ3s9oDsVzX5WXfUl/lYQkxZheCUEA
         Jml0u0duRfANlAvmzewqFgpOfW+rkz1gSU4tsz+swQJG9Fo3+BlQXRlbIYkDD+rMNUEw
         mHlGLJ3F9McQ0HaPNCq0GYqhXdpVom79f1QGeNqqStbsu/5XIrOM7xRen4LQngq5iJSx
         RLP2fUvsyYdFP0Cep+OZiRVLnmprzZPt/iciVhmbmrAMMNhHek0DJI16UFfCxDFkR///
         790A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2So4hv1hi8BG5UUukFb3+REHHKPjn28YFwULPpBOJLk=;
        b=PbtOm+6OHjQrfni4Yg9BPAAP0hE+6gFaJPzhhx/0zWOCpUlC7/L/c7YGm5ppaOyxKV
         VMkb6q/Bx7ZK051xzmML2avKZqEdEG8eX2xNxHXb1axTx+N81ivrjBqBQEZTGr6hlEV2
         DlQHknSY3S9YQUMYT1mhwlaEkbVss8TGbwnDhV61+kPdWvyI6GlXYYhiOMFRmWerQquA
         +U9vgiJ5rBwbyh3wkargRXEzY/Uhxy3HHyDA7NVSBk8xWcYzTbY1iddEOV/+Bv7Ai4UX
         KUKmGeNfopsGKruwvTMgUHnKzyrum6uYz0WO+r4+iAf1OK0htyDkZJnRb7vmrIkcexS4
         jswQ==
X-Gm-Message-State: AO0yUKXBlSzqetBoeI4PpG5PXVwNzyFoqSMG8u6J1TOZCykT3ytVt74K
        upDBLcaALrHPyiVP8aNHOyvpPw==
X-Google-Smtp-Source: AK7set8T2dPADRrjmHIwQIhOi9y6Kjuq37Aqt8tThmQ4Y9zHFhM0wAaRxTzdegYDmj8jOjGAFntBsg==
X-Received: by 2002:a17:902:8697:b0:198:af4f:de0b with SMTP id g23-20020a170902869700b00198af4fde0bmr213146plo.11.1675787897388;
        Tue, 07 Feb 2023 08:38:17 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z11-20020a17090a170b00b0023087e8adf8sm6542524pjd.21.2023.02.07.08.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 08:38:16 -0800 (PST)
Date:   Tue, 7 Feb 2023 16:38:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 2/3] KVM: SVM: Modify AVIC GATag to support max number
 of 512 vCPUs
Message-ID: <Y+J+dS8ZRX07kgt7@google.com>
References: <20230207002156.521736-1-seanjc@google.com>
 <20230207002156.521736-3-seanjc@google.com>
 <20230207093350.5db155ca@imammedo.users.ipa.redhat.com>
 <0e12d654-d388-a0f9-e7f9-7e96921786b7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e12d654-d388-a0f9-e7f9-7e96921786b7@oracle.com>
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

On Tue, Feb 07, 2023, Joao Martins wrote:
> On 07/02/2023 08:33, Igor Mammedov wrote:
> > On Tue,  7 Feb 2023 00:21:55 +0000
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> >> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> >>
> >> Define AVIC_VCPU_ID_MASK based on AVIC_PHYSICAL_MAX_INDEX, i.e. the mask
> >> that effectively controls the largest guest physical APIC ID supported by
> >> x2AVIC, instead of hardcoding the number of bits to 8 (and the number of
> >> VM bits to 24).
> > 
> > Is there any particular reason not to tie it to max supported by KVM
> > KVM_MAX_VCPU_IDS?
> > 
> > Another question:
> >  will guest fail to start when configured with more than 512 vCPUs
> >  or it will start broken?
> > 
> 
> I think the problem is not so much the GATag (which can really be anything at
> the resolution you want). It's more of an SVM limit AIUI. Provided you can't
> have GATAgs if you don't have guest-mode/AVIC active, then makes sense have the
> same limit on both.

Yep.  The physical ID table, which is needed to achieve full AVIC benefits for a
vCPU, is a single 4KiB page that holds 512 64-bit entries.  AIUI, the GATag is
used if and only if the interrupt target is in the physical ID table, so using
more GATag bits for vCPU ID is pointless.

> SVM seems to be limited to 256 vcpus in xAPIC mode or 512 vcpus in x2APIC
> mode[0]. IIUC You actually won't be able to create guests with more than
> 512vcpus as KVM bound checks those max limits very early in the vCPU init (see
> avic_init_vcpu()). I guess the alternative would an AVIC inhibit if vCPU count
> goes beyond those limits -- probably a must have once avic flips to 1 by default
> like Intel.

I don't _think_ KVM would have to explicitly inhibit AVIC.  I believe the fallout
would be that vCPUs >= 512 would simply not be eligible for virtual interrupt
delivery, e.g. KVM would get a "Invalid Target in IPI" exit.  I haven't dug into
the IOMMU side of things though, so it's possible something in that world would
necessitate disabling (x2)AVIC.

> [0] in APM Volume 2 15.29.4.3 Physical Address Pointer Restrictions,
> 
> * All the addresses point to 4-Kbyte aligned data structures. Bits 11:0 are
> reserved (except for offset 0F8h) and should be set to zero. The lower 8 bits of
> offset 0F8h are used for the field AVIC_PHYSICAL_MAX_INDEX. VMRUN fails with
> #VMEXIT(VMEXIT_INVALID) if AVIC_PHYSICAL_MAX_INDEX is greater than 255 in xAVIC
> mode or greater than 511 in x2AVIC mode.
