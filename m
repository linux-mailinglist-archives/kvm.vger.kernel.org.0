Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388B8572986
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 00:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiGLWxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 18:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiGLWxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 18:53:53 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108F11F2F9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 15:53:53 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p11so2125579pgr.12
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HWyKOm/lcyOl8O084SO+nkGRnokYrR/9NGWVH+hUDX4=;
        b=h4tI4WQeJW4ZlggcTTxIV2rlia7CgUC+TlJS2Qn7HRmeUb6ioW4RQ+jAnFKRBDw3WD
         Tny5mKocjRuYN89ZNEv2dLFBqcRyeBVd7dfE2a5a1QSMGSytubKQYebtGc9q5Ph/LOIg
         bx76WIHxmOHQMtE0Aq0NmlLxSvSfWz2kvi+VTLmoo5CdsczV8sfwxM/EeD2e99t74vRS
         nEz0MpWixLmPkVsEIDaIceoLD0Xkbot2rf5EHLW/pye25u7lADX2BeiCVUcpkhP3Y2wC
         nt800T6U6m/S7IMp9MLELHxODFKkBFaeJmekb6Czx+L65wglqHqxneQ2p8FAr9VKEem5
         k8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HWyKOm/lcyOl8O084SO+nkGRnokYrR/9NGWVH+hUDX4=;
        b=Tfr2E+5QP24F3uDCNMjPjepvvkACvrJmw1mV1NZCGD8+Y6h5zfLuuYb7IsASXhrase
         Rz4ftF4cOQLgf9MRDb/2Gu4gN/lNS62AtlsHno7AvH80zeeW/2Hu5reF3uoakagnBsmh
         PicOnMui34wzDlLhwiNf1jZN2yWvrR1kDyVmN6Ogq+NcXKyAyRpLyMtGy7zid/ByV0UN
         fDgxOEOrlsQYlvqsWV/PPRP0ZU+JoElTKxbUeazSrSWsElG1u8y6FRNgdhmyQCYjRdoP
         +uxHb6rScG44RsEfHo8sJWrvCEA+TrPlUAbcfUqO0zbEtE+XEjtuxg8BK2YTKMFiz0DR
         A81Q==
X-Gm-Message-State: AJIora/8Zs4SSgoCt8FVO6bAA9tkQhqBCnG43c7B5mwxzqxaRPnfAzle
        B/yLm5q+d1N/WVXlbzd1s5bRrA==
X-Google-Smtp-Source: AGRyM1tUNzl8R21w5j4v3UwvX46aUMLMnpea0GKpu/4WmjWWElzK+uGAo21woDWYSl9jIPcvxCwQHA==
X-Received: by 2002:a63:ea45:0:b0:415:fa9a:ae71 with SMTP id l5-20020a63ea45000000b00415fa9aae71mr437116pgk.285.1657666432444;
        Tue, 12 Jul 2022 15:53:52 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id n30-20020aa7985e000000b00528d41a998csm7532065pfq.15.2022.07.12.15.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:53:52 -0700 (PDT)
Date:   Tue, 12 Jul 2022 22:53:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Shrink pte_list_desc size when KVM is
 using TDP
Message-ID: <Ys37fNK6uQ+YTcBh@google.com>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-4-seanjc@google.com>
 <Ys33RtxeDz0egEM0@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys33RtxeDz0egEM0@xz-m1.local>
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

On Tue, Jul 12, 2022, Peter Xu wrote:
> On Fri, Jun 24, 2022 at 11:27:34PM +0000, Sean Christopherson wrote:
> > Dynamically size struct pte_list_desc's array of sptes based on whether
> > or not KVM is using TDP.  Commit dc1cff969101 ("KVM: X86: MMU: Tune
> > PTE_LIST_EXT to be bigger") bumped the number of entries in order to
> > improve performance when using shadow paging, but its analysis that the
> > larger size would not affect TDP was wrong.  Consuming pte_list_desc
> > objects for nested TDP is indeed rare, but _allocating_ objects is not,
> > as KVM allocates 40 objects for each per-vCPU cache.  Reducing the size
> > from 128 bytes to 32 bytes reduces that per-vCPU cost from 5120 bytes to
> > 1280, and also provides similar savings when eager page splitting for
> > nested MMUs kicks in.
> > 
> > The per-vCPU overhead could be further reduced by using a custom, smaller
> > capacity for the per-vCPU caches, but that's more of an "and" than
> > an "or" change, e.g. it wouldn't help the eager page split use case.
> > 
> > Set the list size to the bare minimum without completely defeating the
> > purpose of an array (and because pte_list_add() assumes the array is at
> > least two entries deep).  A larger size, e.g. 4, would reduce the number
> > of "allocations", but those "allocations" only become allocations in
> > truth if a single vCPU depletes its cache to where a topup is needed,
> > i.e. if a single vCPU "allocates" 30+ lists.  Conversely, those 2 extra
> > entries consume 16 bytes * 40 * nr_vcpus in the caches the instant nested
> > TDP is used.
> > 
> > In the unlikely event that performance of aliased gfns for nested TDP
> > really is (or becomes) a priority for oddball workloads, KVM could add a
> > knob to let the admin tune the array size for their environment.
> > 
> > Note, KVM also unnecessarily tops up the per-vCPU caches even when not
> > using rmaps; this can also be addressed separately.
> 
> The only possible way of using pte_list_desc when tdp=1 is when the
> hypervisor tries to map the same host pages with different GPAs?

Yes, if by "host pages" you mean L1 GPAs.  It happens if the L1 VMM maps multiple
L2 GFNs to a single L1 GFN, in which case KVM's nTDP shadow MMU needs to rmap
that single L1 GFN to multiple L2 GFNs.

> And we don't really have a real use case of that, or.. do we?

QEMU does it during boot/pre-boot when BIOS remaps the flash region into the lower
1mb, i.e. aliases high GPAs to low GPAs.

> Sorry to start with asking questions, it's just that if we know that
> pte_list_desc is probably not gonna be used then could we simply skip the
> cache layer as a whole?  IOW, we don't make the "array size of pte list
> desc" dynamic, instead we make the whole "pte list desc cache layer"
> dynamic.  Is it possible?

Not really?  It's theoretically possible, but it'd require pre-checking that aren't
aliases, and to do that race free we'd have to do it under mmu_lock, which means
having to support bailing from the page fault to topup the cache.  The memory
overhead for the cache isn't so significant that it's worth that level of complexity.
