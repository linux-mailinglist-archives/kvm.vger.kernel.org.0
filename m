Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369BC48CAEB
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356191AbiALSZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 13:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356219AbiALSYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 13:24:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C3EC06175B
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:24:35 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id pf13so6774571pjb.0
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZmWNRIqHpgfFlpkzNid2AC/wsgEhhdjKgSthxqzupr0=;
        b=Hu0l1zFFoYveGm/teMMMLzjdYZZ9zlHgOwE5BiAa/3z6diZCXc1oZ+E0g3Wm2YT3T4
         zMZkwh6IK/rLwGDBUppTCSQwiB69w1v1Cv8Zr47GFjUlpUkHTF3/rvPZNi4YJH2B8TEZ
         Lyv7xmvISTTPRvYjZtNac+DUiLid4AEGwCa5xnmYyRz/c/jylydiABnVDFOnS7fNFFtD
         FOeyhg327siqhBuHgRQ9qcTdfQg76s8e3XPQUwRWNYi1FBbiPP3WL11PfBg6cJEkL1S6
         KkxJxDKOa/ryCIPaNWK/05qGqzmQdrQ6FQiyNHCRRx3A8OR3nVgXU4hU7ZlR7ZJu9jJJ
         hZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZmWNRIqHpgfFlpkzNid2AC/wsgEhhdjKgSthxqzupr0=;
        b=6nApn9GXtzN98vd5NLekyzZcqWSIneudKn9fUPUZXpgcRnQvci+XZnphAyM05a2dYx
         XbIP5KIEaeQ8mtMgGrSDwTACmGBXxb10chmmysAX5hBLde8WwTuAC0fJvBclYFEL7YUS
         eazvvNAB749mDWDNcLbTnDPVMcsRgoIzv3TIwTK9O8f2BwfWx56WO35kvzviAumhzZgC
         c3H0DfKlqgimumyNpZVhll83P8TvY44i6iPdQMfLHAqwlvRv9DRkAaBrxYSJ2k0+5VKj
         H91TtYYSoUfRbau+4A+Ws52/YJcb5cwlFd5CpBBbKpA2nhttkKgbu/6d4x43F2ACE1sE
         J5JA==
X-Gm-Message-State: AOAM5317Rfr8wvDayriBbTAbQ/e4s455524kf9x4WA3sZw+mife7o3gP
        PZJMwBL+l1dg37Q/Eg2wk6C3Gg==
X-Google-Smtp-Source: ABdhPJxC3Spy6jAzawZZkjc8A2flGmd3z5F+VR5mfljb/8geqt6+8TviA+FPYekZyzWdSxeA0zZurA==
X-Received: by 2002:a17:902:8346:b0:149:d1c7:fdc0 with SMTP id z6-20020a170902834600b00149d1c7fdc0mr689096pln.166.1642011875155;
        Wed, 12 Jan 2022 10:24:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n15sm6311862pjj.12.2022.01.12.10.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 10:24:34 -0800 (PST)
Date:   Wed, 12 Jan 2022 18:24:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <Yd8c3zlTweSGhwtt@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com>
 <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
 <Yd3UymPg++JW98/2@google.com>
 <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> Understood. I'll move it to arm64 and we can refactor it if there's a
> need for any other arch(s).

Before you do that, can you answer Jim's question on _why_ arm64 needs this?
