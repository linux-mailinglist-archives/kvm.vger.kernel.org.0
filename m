Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7E67A07C
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 18:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjAXRts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 12:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbjAXRtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 12:49:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904F74F862
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 09:48:43 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so19385625pjg.4
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 09:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5xoN11pX4OSnajsl6E0NBnPLkwNq7Bwr0irfBiF1lwY=;
        b=ItrMDLIG/W96FYEM6q//zgLFYJO3d+CGzfX4g1QGRgww6FJF/s1qppSMFNPa+UPp5k
         8YW0T1ueCrox+4Na/HWnwCPiQIs4f6SpXXKdo3ADbbdupX7Pe8+5T0WyiVG4Ahrxj4ti
         DbIc9e1nOoU2PX9juVde04Fby/qMyGJJqr2w4mG/cwoF2Cwc1gqY92xe1Hq4zK9lE1xe
         1Byete1jdRfrjvhNWRCAsenKnwImkQ0dXxaIIOVS5z3sN2URSGnC6yRwRXjllSaSZ7u5
         Qe/36/dgMw9oUl+O9vqrZgisUNEx5HjdwHEipkA8qmSbLVkLy2E1aV7xe4VJjweZ51CU
         f9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xoN11pX4OSnajsl6E0NBnPLkwNq7Bwr0irfBiF1lwY=;
        b=ylNi5KdXovwgNa4jkNXgRJ0V0TmpyHEDcAJ3K3dzkslTmbxq/OlRxyeRAx8mwFoZEU
         BoTOFyV+62QSv2SOUSWbFfvH+V4u0M+wHrdIIaCorf2HeMW88WyrI5ob8oBlqvYR8Ry9
         D3m70bVgwxk6ND30ojgEpJ0bPh5rL4sTfhoBpA9UQ9/qgONcVeXeZX0LmWHDSJYwBZVt
         9W05iwEUDd+8CGJE6hecfWqHvrNwhnTdrkZa6uOWMpDlrjR/LUUjSA6mMSbNyepLHRLi
         wU5dzgejahcXEcwwoHzmhwdWhMjHwvklHaV/oxXUWCKCBAN306aGFrAQ0QuApDWkA2uA
         zXGQ==
X-Gm-Message-State: AFqh2krF1PUmUqjB8juo91VjXNOuETZJFP6D9pzYK4M/htkel6P0qn7g
        B9HnMuwT1wguiU/FJbI9ekTcm0cyyQrMLZSlqa0Dcw==
X-Google-Smtp-Source: AMrXdXvjEZDf2VJ18a62toCaDtf7dF86OPQzK4KO9QoB7HmzYCHrV7Wcnr/m/Gb08ScERGltCtKo+g==
X-Received: by 2002:a17:902:b413:b0:192:6bb1:ed5a with SMTP id x19-20020a170902b41300b001926bb1ed5amr26589093plr.38.1674582513517;
        Tue, 24 Jan 2023 09:48:33 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id o6-20020a1709026b0600b0019602dd94f1sm1962213plk.13.2023.01.24.09.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:48:33 -0800 (PST)
Date:   Tue, 24 Jan 2023 09:48:28 -0800
From:   David Matlack <dmatlack@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y9AZ7ORdmIPQ1YGL@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
 <Y9ALgtnd+h9ivn90@google.com>
 <Y9ARN5hWlAYVFBoK@google.com>
 <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>
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

On Tue, Jan 24, 2023 at 09:18:33AM -0800, Ricardo Koller wrote:
> On Tue, Jan 24, 2023 at 9:11 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Jan 24, 2023 at 08:46:58AM -0800, Ricardo Koller wrote:
> > > On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:
> >
> > [...]
> >
> > > > Would it be accurate to say:
> > > > /* No huge pages can exist at the root level, so there's nothing to
> > > > split here. */
> > > >
> > > > I think of "last level" as the lowest/leaf/4k level but
> > > > KVM_PGTABLE_MAX_LEVELS - 1 is 3?
> > >
> > > Right, this is the 4k level.
> > >
> > > > Does ARM do the level numbering in
> > > > reverse order to x86?
> > >
> > > Yes, it does. Interesting, x86 does
> > >
> > >       iter->level--;
> > >
> > > while arm does:
> > >
> > >       ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> > >
> > > I don't think this numbering scheme is encoded anywhere in the PTEs, so
> > > either architecture could use the other.
> >
> > The numbering we use in the page table walkers is deliberate, as it
> > directly matches the Arm ARM. While we can certainly use either scheme
> > I'd prefer we keep aligned with the architecture.
> 
> hehe, I was actually subtly suggesting our x86 friends to change their side.

Yeah KVM/x86 and KVM/ARM use basically opposite numbering schemes for
page table levels.

Level | KVM/ARM | KVM/x86
----- | ------- | ---------------
pte   | 3       | 1 (PG_LEVEL_4K)
pmd   | 2       | 2 (PG_LEVEL_2M)
pud   | 1       | 3 (PG_LEVEL_1G)
p4d   | 0       | 4
      | -1      | 5

The ARM levels come from the architecture, whereas the x86 levels are
arbitrary.

I do think it would be valuable to standardize on one leveling scheme at
some point. Otherwise, mixing level schemes is bound to be a source of
bugs if and when we are sharing more MMU code across architectures.
