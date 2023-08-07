Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BACA772C9C
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 19:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjHGRTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 13:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjHGRTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 13:19:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5657B1FFE
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 10:19:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d061f324d64so5396263276.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691428749; x=1692033549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=27WqhWvu/ZsxgO0eaScHpZFEDzQn0I8scFjtchyFjMc=;
        b=tdqLt24osgHVvtPDkbBoS3gs2oYLYwf78ndKbYVPt6nuRqasJvTqaqHOTtXRjyk6dB
         TLa32Y4FjbMlQUmMgakR+L9b7u2unem/+pECTeIrmzmM5/poCie23rtV/gvmk4MQEp74
         Ar7PDV1K4MGynfnCOGSPyHDwvrLh86FZKUUtLQ8Ec/sQ9yamEgcD83eWViiid2EFrMAM
         N4fM6cwbr1b5ApFSqs8OH15uoqDQYNQVCV8LNdaiEjZdN9m+twmh1JMr5eXxe/zT4YJh
         Oz8jknsiJLYGJZQ5IjHmfdUcLyKYzAn8638CMi8+lUY0jWEIOPzscXrnArwRiqNFoaR+
         XN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691428749; x=1692033549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27WqhWvu/ZsxgO0eaScHpZFEDzQn0I8scFjtchyFjMc=;
        b=MgW0puiSfLg4SRsvrFcW6wyRc4viYeK42cffC9W4a5K7IJGUASleoz/MOQ4+9uNAMM
         PQqtWSZGR/GzRmtNGxPOU9FdxcYv0cBIrzQFCIh7gMgau0cJzphABSk4K8VNWJGPMKJl
         L3mwAHU6L5SZHw624LyTX1PBCo1rrFN7xsSLVaLckcEIBbACInqLgSfFyDdGGlO7tj0Q
         0aXuLgartYRWa8wb+wsT9YnPrXyJotm4CIfS9aUskLTaJjvc32dWKE7pXJkvRQ1DcNiZ
         yEWx1pQP1Fq9RIvtlp4mbE7RNsvHiIIHqheS1HPuQTWQSApmLlzYxt4fqlhOYnOWLdRB
         Ol9g==
X-Gm-Message-State: AOJu0YzOr1CQzBt19hXHC5u6nrWztS65FDRmnboiX9O01LTvDHLCY0+h
        E1pausMg9iE6x03enDGexCq9s3jnD7U=
X-Google-Smtp-Source: AGHT+IFApew+XDb0Q4kYRgsV58wREJAAY6JgXAxkEQkzqnSpBI8akykTQqeF+k7dKfbQrCT3r/q5RrMz++U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa0e:0:b0:d0c:1f08:5fef with SMTP id
 s14-20020a25aa0e000000b00d0c1f085fefmr48511ybi.12.1691428749646; Mon, 07 Aug
 2023 10:19:09 -0700 (PDT)
Date:   Mon, 7 Aug 2023 10:19:07 -0700
In-Reply-To: <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com> <20221223005739.1295925-20-seanjc@google.com>
 <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
Message-ID: <ZNEni2XZuwiPgqaC@google.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 07, 2023, Like Xu wrote:
> On 23/12/2022 8:57 am, Sean Christopherson wrote:
> > +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> > +					const u8 *new, int bytes)
> > +{
> > +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> > +
> > +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> > +}
> 
> The kvm_mmu_track_write() is only used for x86, where the incoming parameter
> "u8 *new" has not been required since 0e0fee5c539b ("kvm: mmu: Fix race in
> emulated page table writes"), please help confirm if it's still needed ? Thanks.
> A minor clean up is proposed.

Hmm, unless I'm misreading things, KVMGT ultimately doesn't consume @new either.
So I think we can remove @new from kvm_page_track_write() entirely.

Feel free to send a patch, otherwise I'll get to it later this week.
