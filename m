Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8278240856D
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbhIMHgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:36:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237661AbhIMHge (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 03:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631518518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=txB9+Bj+JLchSp76fL8uLRsQPIdKrDGsk0rjMYnMz1Q=;
        b=g5fjXr+hbJ/pZN9W62g8OheXyK4If3mhGcMd2Ewe/ZENGdv3Bn3/+BGMb6ZpoNk7+1RrrP
        t4p7zXmYZP4ZYa3UZWB2sT+rgcVIJ4ehKppaclbRIiDRZgikCwJJC/V+aq9/u+H6tLO6ew
        2fOkpt1Ff57+U3ZmRxB8v8e4YwSb/n4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-dOlznkucOJeAOpD1TimwXQ-1; Mon, 13 Sep 2021 03:35:16 -0400
X-MC-Unique: dOlznkucOJeAOpD1TimwXQ-1
Received: by mail-ed1-f70.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so180400ede.16
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=txB9+Bj+JLchSp76fL8uLRsQPIdKrDGsk0rjMYnMz1Q=;
        b=ZMsp7/sTXVMG7QD8oDe5Na/OMmrJIno4+TXpsZiNg/eEt1z6lt6r6HCVlDJTnDbNn9
         q/xlWWVLuc8QyEYoVb1cFmQmRrPidx7VERTAOLTa+BWtc9s0OoJbolEsxXJFxZjBB9kK
         j3F6eFju+n8WZnyM50FNRhonk21VUx3YAFTbQFspN6F2yRsP5wzyr7PeP5Xqeih7th9Y
         ISBcI2brn5H+MCEd3DKPr1i1IFocfAkMFmyUMF+PXHj4VcLnmwfSO3o83yZnulbcmIxR
         19byKZA53vTFoRITehbQG/T4I7IGZHZd8G01oB+VxOr+h/tmbwCbGaq9NN/sPM/V0l7a
         QkkQ==
X-Gm-Message-State: AOAM530giD6m7nXaRFgeHcN2aaJZ7L44jA7t5wQ/r7vZbvHSPN0DEH/P
        tV4rTr5y6kSIKH/YJ1Vmi4xzTA1wpq5iqqIgT7joTSboQmIkJ9RyRl26yggrQCD577mkP8RYQtc
        KFowGYP1pRfMl
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr11894397eds.27.1631518515111;
        Mon, 13 Sep 2021 00:35:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVgB6s5bJyAZu+VmEyjboOiIjrZIP1yaryEsV7Gwlmg0qg2QOLW//vgArN2DC67y9ypKSyXA==
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr11894369eds.27.1631518514975;
        Mon, 13 Sep 2021 00:35:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i6sm2978691ejd.57.2021.09.13.00.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 00:35:14 -0700 (PDT)
Date:   Mon, 13 Sep 2021 09:35:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210913073512.x774i5hi3s4wmopx@gator.home>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 12, 2021 at 12:05:22AM -0700, Reiji Watanabe wrote:
> Hi Raghu and all,
> 
> On Wed, Sep 8, 2021 at 6:38 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > At times, such as when in the interrupt handler, the guest wants
> > to get the vcpuid that it's running on. As a result, introduce
> > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > initialization and exports the map to the guest for it to read.
> 
> How about using TPIDR_EL1 to hold the vcpuid ?
> i.e. have aarch64_vcpu_setup() set the register to vcpuid and
> guest_get_vcpuid() simply return a value of the register.
> This would be a simpler solution to implement.

That is a great suggestion. It's arch-specific, but maybe the
other architectures can mimic it with their own capabilities.
And, in the unlikely event a unit test wants that register for
itself, then it can build its own mpidr-vcpuid map if necessary.
Ship it :-)

Thanks,
drew

