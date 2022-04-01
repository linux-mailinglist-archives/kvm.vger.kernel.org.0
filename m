Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE34EF740
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349210AbiDAPzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353823AbiDAPLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 11:11:07 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BB6196092
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 07:54:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p17so2636507plo.9
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 07:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pOFOAOjZHkVIM9Cf5IEXbes0u5Uh/OQeAWWXMddS0Bg=;
        b=iOsOoSV9OQblL4p1l3OUbmwl/JF8l0v7RCPmXqxWk4Jw8wnbSyNT+BVb9QU8KK/O7S
         EAHlhqMl9mdfUxz90N4rt8NWEC9EeE2UHAdi47b9XQfmcMgIrx3Bb7PJA9qeWjjGolzJ
         wk/BjvuXiRgn6TX1CwSGlF36Phq+jBcYdv59dPSjbO0y+6Tg7dcLW6eCJqz7NgFqEzbr
         7VNiOESgpDBZKYDQkvYlbXD3BoX2hMUvn7/xM0mYTHGhVQT0g5MMEMy97ZdwVwqkqCPX
         mxMT7CdHBr7N98iviXLuf1gKPvATXJmvPdKo5kt6EjN6u2zGY3eIHf+6RMKqPGNDAmiG
         uEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pOFOAOjZHkVIM9Cf5IEXbes0u5Uh/OQeAWWXMddS0Bg=;
        b=Ug79VIq2Nfwy77Akpgcd+oNaAt5WV/pfHCIZtNGDkTLOcH7P6OTEW3I4bdMSbMzxsx
         0GOiMRLP3amN3bHt5APTAZOmYtuvB20XPRiMeCmqTKXUGZG4Fx4jpd6gwE798j0MnQtl
         MLAQTIn06gkHaK1gB5qfjj2tornA3YsP2MdQ37JGXIRYh5Xg2htvqJyAO3BXCzDBcUPp
         ZQ3KekEGO9vppONxlcInui+Tkwd+BaGxFPe+DqAC1xEPSIfkVgc0MNHTIDcug4fh0u/z
         A6wPIe3uL4Ed2FU3ocybg/eL0VmgpNXFxRIDLogG7BA86TfFkSldtzbduT/dxXo4DR7x
         I67A==
X-Gm-Message-State: AOAM530PhzBTvYyglsHzZw7EzLjjUoPpZWYqZ6LKfJ/AYVZhXaZkPOfB
        mdVncfUEluJxTNCWaoNdcuMYJw==
X-Google-Smtp-Source: ABdhPJxQYmCfdKoFloacVpLGDsq+pXMzsTYr3YdN943LhaTj99Is7YEwhGgGHX+l57f4aLJsWy1z1g==
X-Received: by 2002:a17:902:7c0d:b0:155:d507:3cf0 with SMTP id x13-20020a1709027c0d00b00155d5073cf0mr10344247pll.103.1648824849356;
        Fri, 01 Apr 2022 07:54:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm3012243pfi.75.2022.04.01.07.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:54:08 -0700 (PDT)
Date:   Fri, 1 Apr 2022 14:54:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Message-ID: <YkcSDeJDHOv+MZA7@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com>
 <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
 <YkSz1R3YuFszcZrY@google.com>
 <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com>
 <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
 <YkX6aKymqZzD0bwb@google.com>
 <a1fe8fae-6587-e144-3442-93f64fa5263a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1fe8fae-6587-e144-3442-93f64fa5263a@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, Nikunj A. Dadhania wrote:
> 
> On 4/1/2022 12:30 AM, Sean Christopherson wrote:
> > On Thu, Mar 31, 2022, Peter Gonda wrote:
> >> On Wed, Mar 30, 2022 at 10:48 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
> >>> So with guest supporting KVM_FEATURE_HC_MAP_GPA_RANGE and host (KVM) supporting
> >>> KVM_HC_MAP_GPA_RANGE hypercall, SEV/SEV-ES guest should communicate private/shared
> >>> pages to the hypervisor, this information can be used to mark page shared/private.
> >>
> >> One concern here may be that the VMM doesn't know which guests have
> >> KVM_FEATURE_HC_MAP_GPA_RANGE support and which don't. Only once the
> >> guest boots does the guest tell KVM that it supports
> >> KVM_FEATURE_HC_MAP_GPA_RANGE. If the guest doesn't we need to pin all
> >> the memory before we run the guest to be safe to be safe.
> > 
> > Yep, that's a big reason why I view purging the existing SEV memory management as
> > a long term goal.  The other being that userspace obviously needs to be updated to
> > support UPM[*].   I suspect the only feasible way to enable this for SEV/SEV-ES
> > would be to restrict it to new VM types that have a disclaimer regarding additional
> > requirements.
> 
> For SEV/SEV-ES could we base demand pinning on my first RFC[*].

No, because as David pointed out, elevating the refcount is not the same as actually
pinning the page.  Things like NUMA balancing will still try to migrate the page,
and even go so far as to zap the PTE, before bailing due to the outstanding reference.
In other words, not actually pinning makes the mm subsystem less efficient.  Would it
functionally work?  Yes.  Is it acceptable KVM behavior?  No.

> Those patches does not touch the core KVM flow.

I don't mind touching core KVM code.  If this goes forward, I actually strongly
prefer having the x86 MMU code handle the pinning as opposed to burying it in SEV
via kvm_x86_ops.  The reason I don't think it's worth pursuing this approach is
because (a) we know that the current SEV/SEV-ES memory management scheme is flawed
and is a deadend, and (b) this is not so trivial as we (or at least I) originally
thought/hoped it would be.  In other words, it's not that I think demand pinning
is a bad idea, nor do I think the issues are unsolvable, it's that I think the
cost of getting a workable solution, e.g. code churn, ongoing maintenance, reviewer
time, etc..., far outweighs the benefits.

> Moreover, it does not expect any guest/firmware changes.
> 
> [*] https://lore.kernel.org/kvm/20220118110621.62462-1-nikunj@amd.com/
