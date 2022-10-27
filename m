Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19131610123
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 21:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiJ0TJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 15:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiJ0TJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 15:09:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DA9FACF
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:09:31 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l2so2518317pld.13
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcsG6Lpz86NDdXCXxaPnNHQBPM6Izrd1LxxhOme0rdg=;
        b=RpAv17GfbyizrETcKPzbPLSPEuqfINiMIe/xj9cCq6vRXjwf0nYzMNPSc4bqvkVBJl
         XwWqeSP4stXmFHJL94dcnmsw1gTk+oAOJOKMt0woiDHXSyFK0EgjgV+l9Pvqzk0GPCB5
         VDTb3IDOKZ8Oo9u6D7BnXim5Mww2EPS6WNa76ndfvQC6CFPkO+zJBs+sXw+DsNTQrj6c
         rFLckgEV1rDUzkEJ7bPe7Cfxk+1m6UddG9A1tv0OPSnZ8qleLTbJlVdm1YTYqvi8krNF
         3VxUfwWHAA1A0/HT3mnDZReVLS7FacP/aS8dULbCZfp0v1MMHM6T4v9lYUgbshzj/CL2
         hz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcsG6Lpz86NDdXCXxaPnNHQBPM6Izrd1LxxhOme0rdg=;
        b=sWxxIvf4RS3ut5hxCumSQ7DxJWYlpCOuu+PeDYCxJNAubltj9xL/TQWtcRP8z2Xs4l
         XUqUP+fczpL9uPQOPK38ZQ9FNNruCLWZoT+iPwkHho/PnCMPVSc19UDhpU7AgC/qb1iI
         MvQ09irL/SHZ0ZAU2nXAqq1o1+iPWTAQqAVPx7ycuWA9Qc1GPWE7dosKDUX0goB/WD+F
         nZotr4aHzQ/RroNeDw26/GMjo5XxvQc+4ctDDNH9QabY8oa0O8lVE5YVeegVCY/PSwFX
         7RVx7bY1kqgoFGaw5nGwIOiwj+ejrX+GF51tShCjc2Zk7oRhsMaXTKB1Zbqub/P3BroM
         r24g==
X-Gm-Message-State: ACrzQf3zAa8IOjTGlUB3ltgY36QizLO4AoGVJKFPh8nrmQtjGCWyKu7V
        RDnk1I3eSZwb4Vtx08zs9FRDDRVezrUPww==
X-Google-Smtp-Source: AMsMyM68Ggi+CLlU0LelIxfDVS4J21qnnT+diZNuQGCktyMfBzQNILLH68pVNB2niDUECUSeKxAxhQ==
X-Received: by 2002:a17:90b:4b09:b0:213:655c:158b with SMTP id lx9-20020a17090b4b0900b00213655c158bmr8134972pjb.119.1666897770908;
        Thu, 27 Oct 2022 12:09:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p19-20020a170902c71300b00186b758c9fasm1513521plp.33.2022.10.27.12.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 12:09:30 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:09:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1rXZshBbXGjPpTa@google.com>
References: <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
 <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org>
 <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yg5glvk.wl-maz@kernel.org>
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

On Thu, Oct 27, 2022, Marc Zyngier wrote:
> On Thu, 27 Oct 2022 18:44:51 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Thu, Oct 27, 2022, Marc Zyngier wrote:
> > > But in the long run, with dirty bits being collected from the IOMMU
> > > page tables or directly from devices, we will need a way to reconcile
> > > the dirty tracking. The above doesn't quite cut it, unfortunately.
> > 
> > Oooh, are you referring to IOMMU page tables and devices _in the
> > guest_?  E.g. if KVM itself were to emulate a vIOMMU, then KVM would
> > be responsible for updating dirty bits in the vIOMMU page tables.
> 
> No. I'm talking about the *physical* IOMMU, which is (with the correct
> architecture revision and feature set) capable of providing its own
> set of dirty bits, on a per-device, per-PTE basis. Once we enable
> that, we'll need to be able to sink these bits into the bitmap and
> provide a unified view of the dirty state to userspace.

Isn't that already handled by VFIO, e.g. via VFIO_IOMMU_DIRTY_PAGES?  There may
be "duplicate" information if a page is dirty in both the IOMMU page tables and
the CPU page tables, but that's ok in that the worst case scenario is that the
VMM performs a redundant unnecessary transfer.

A unified dirty bitmap would potentially reduce the memory footprint needed for
dirty logging, but presumably IOMMU-mapped memory is a small subset of CPU-mapped
memory in most use cases.
