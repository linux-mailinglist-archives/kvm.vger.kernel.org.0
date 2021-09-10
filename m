Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED103406829
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 10:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhIJILS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 04:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231685AbhIJILR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 04:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631261406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=04dg9eLo5DobwnbTP7RmzFwFoUSaWkodvk2ic+H8548=;
        b=LItJBSy3DHmwpkZiTV8nTOaBEjmbjBx0MM7KbZrNZMAez1LrJIGSPPcqEHbwiV8aeJyN5g
        kHpSk6RZdlMFc4q2syUlTgELQewXUazzSyz+cwJIKNPrSue0+00Gd0zaPEQ8RFxRcv4ky8
        S6AQE+ufAUYsv0K5Ts66rbsL+Wix1LI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-malsKmChPSexKUp_y6CmNQ-1; Fri, 10 Sep 2021 04:10:05 -0400
X-MC-Unique: malsKmChPSexKUp_y6CmNQ-1
Received: by mail-wm1-f72.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so598298wml.5
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 01:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=04dg9eLo5DobwnbTP7RmzFwFoUSaWkodvk2ic+H8548=;
        b=d9fPkyaWYp+g4Gde4oYl2Mswi3STDs0cLz/7JFnIpkwYN5jJgGwEXydzvwe2ClGvor
         fIr+jdejwL3BUKFPyWgDOIX7duavH/TkrUd3wL7be/UpjnLeKZSMerZKs6lnKaqEKg6W
         Yd9w0kAbbjPIXjTkmoWBoVqEkZTdyYTSN4T6pjsjS5sjLsvE619b5KVSnRarRO7S+FJW
         Rew0ymv5Hzt+PIzHuv2YExg4wNOmvqYndnqR4HI7Edo2u91nnrFmuaj3a5LdVIKtawZu
         fC7LFbV12ZADyvto5FnDLlDfftkccxBvEvhdmHFXZlQwfvL+In+t7YwHutVEJdb9bcK1
         DOVw==
X-Gm-Message-State: AOAM532AsB50s81DnNsS3cV0jQ1Ynpcq4dEjli7/NJmP6UoIk36NFWMy
        yn2pRfNIz5+Y6qvp+svYQBApzcKuBuY9pDBBdXN4s31VrUnQxtfEDTMuLhYXFPyZgnq2Vgq64GQ
        F2aENphFbZGk4
X-Received: by 2002:a05:600c:3b0e:: with SMTP id m14mr7171008wms.118.1631261403851;
        Fri, 10 Sep 2021 01:10:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznq/1Zr/LhNYqj/gZ4OdPBVawbvoIodEWaQXNr0cQS5ZYlI1VWvjYdpXqwAPwN0hOtTSUxVw==
X-Received: by 2002:a05:600c:3b0e:: with SMTP id m14mr7170994wms.118.1631261403703;
        Fri, 10 Sep 2021 01:10:03 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id j7sm322322wrr.27.2021.09.10.01.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 01:10:03 -0700 (PDT)
Date:   Fri, 10 Sep 2021 10:10:01 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210910081001.4gljsvmcovvoylwt@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator>
 <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 10:10:56AM -0700, Raghavendra Rao Ananta wrote:
> On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
...
> > > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > > +             vcpuid = vcpuid_map[i].vcpuid;
> > > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> >
> > We don't want this assert if it's possible to have sparse maps, which
> > it probably isn't ever going to be, but...
> >
> If you look at the way the array is arranged, the element with
> VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
> elements would lie before this. So, I don't think we'd have a sparse
> array here.

If we switch to my suggestion of adding map entries at vcpu-add time and
removing them at vcpu-rm time, then the array may become sparse depending
on the order of removals.

Thanks,
drew

