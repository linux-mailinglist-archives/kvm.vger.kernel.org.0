Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D8D45EDC6
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhKZMWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:22:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235463AbhKZMUg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:20:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637929043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEUxagCsCPIMaLdnoQlxqx2zww18oJ+q29sTjR/bfNw=;
        b=jINgch4gcAz4kbUOAADSdv04vOMTpIpfc7FhcN4dx6f/7R9YvWSb81UVcmFC9SgSioN+Jc
        Jsc+v/Jsm3ZowqOz/2cFtTcsSFfUp6KYuRBCS+419Cgtj0+t+w0Z1TO8I2kazurf6yKUVW
        cI0lNEsPlEKLmXQoOdvgfpJB6WeudkY=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-PsHweNdnMfOiinWX0zBZ-Q-1; Fri, 26 Nov 2021 07:17:22 -0500
X-MC-Unique: PsHweNdnMfOiinWX0zBZ-Q-1
Received: by mail-pl1-f198.google.com with SMTP id i3-20020a170902c94300b0014287dc7dcbso3859228pla.16
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 04:17:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEUxagCsCPIMaLdnoQlxqx2zww18oJ+q29sTjR/bfNw=;
        b=LmkvuAXljuPI2IU9iuubS4Lv0MucLG+7yFaO5u8hjrK4IXAwaOoPBOa+vraDFzsgv1
         inypq4xqE/sCtGEwsF+tAvhzeq4HS17QdjbSfgZqfJF+1BHAyByy6PE4qUJVIpsvTmhQ
         LtMDzYaGIhruZX3CZFr3MIBIL3u8ulXpSjDRoNtTTSr/MAKhl1lmVAcSYaNXa2WI8TnP
         HREvBw5SihUzcHUltg2rwlwHyLspR+7lo1l5krcEhNTVDyLj8Iu2V2sG7B+9o9D+6a5I
         dp+QDfPKhs1i883tbxV25m9f7kdoHUg2dqH8NQYbNN81HsCUkfjGsBhIOU8zUU3dvwEe
         wV2g==
X-Gm-Message-State: AOAM533z/dz3cncltJef58B6poLAmVrCTZyZj22hIaVUoQv/YrkFMSvA
        xHPEWIwgMine5Usk2fLp4n6Mbk8GK7kSQDm+n5bniNc5qQPJDteVp3ZIfSDeQNFLFeCSJkn6mpO
        4J3Sj3mcGa7iR
X-Received: by 2002:a17:90a:3488:: with SMTP id p8mr15375523pjb.114.1637929041272;
        Fri, 26 Nov 2021 04:17:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCoQPatXa+vC/hGYknRMLQ+bjbpC+wqD1H3FLma9t7LvDXa9kL+6En97IOwQT0BRI6lpwCbQ==
X-Received: by 2002:a17:90a:3488:: with SMTP id p8mr15375497pjb.114.1637929040997;
        Fri, 26 Nov 2021 04:17:20 -0800 (PST)
Received: from xz-m1.local ([94.177.118.150])
        by smtp.gmail.com with ESMTPSA id v1sm6487810pfg.169.2021.11.26.04.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:17:20 -0800 (PST)
Date:   Fri, 26 Nov 2021 20:17:12 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during
 CLEAR_DIRTY_LOG
Message-ID: <YaDQSKnZ3bN501Ml@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-14-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-14-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 11:57:57PM +0000, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6768ef9c0891..4e78ef2dd352 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
>  		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
>  
> +		/*
> +		 * Try to proactively split any large pages down to 4KB so that
> +		 * vCPUs don't have to take write-protection faults.
> +		 */
> +		kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
> +
>  		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
>  
>  		/* Cross two large pages? */

Is it intended to try split every time even if we could have split it already?
As I remember Paolo mentioned that we can skip split if it's not the 1st
CLEAR_LOG on the same range, and IIUC that makes sense.

But indeed I don't see a trivial way to know whether this is the first clear of
this range.  Maybe we can maintain "how many huge pages are there under current
kvm_mmu_page node" somehow?  Then if root sp has the counter==0, then we can
skip it.  Just a wild idea..

Or maybe it's intended to try split unconditionally for some reason?  If so
it'll be great to mention that either in the commit message or in comments.

Thanks,

-- 
Peter Xu

