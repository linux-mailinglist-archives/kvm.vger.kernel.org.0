Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CBB45EDC9
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352644AbhKZMYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:24:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhKZMWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637929129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0gJzqrck3v1vyh9Rd3m0qUSDukMkHpVtZczwHo7Q5o=;
        b=CSS4kJu6xZ1g+/85OXAoAESv05STwM6XNWWqKYmZdW2Z3TnAgcWvlrU/9TUhF2TR1uqJTu
        8cOaHItRW/Oj7siV/vuhacXkbNsyLxMvYHEoaOOHjaCIc95bR4rcihIKSEkknuIY3AfeNu
        6db6CKHBtBVbY2lY77gdD3tUHYdGrCg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-DQ8zUiPXOVOLxKhEcZdGnQ-1; Fri, 26 Nov 2021 07:18:48 -0500
X-MC-Unique: DQ8zUiPXOVOLxKhEcZdGnQ-1
Received: by mail-pl1-f197.google.com with SMTP id q13-20020a170902edcd00b00145280d7422so3857372plk.18
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 04:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H0gJzqrck3v1vyh9Rd3m0qUSDukMkHpVtZczwHo7Q5o=;
        b=7rnCRHmn7YfKaVlg9TMWZwR/gzutQjfrACfjCqvRl/HdHRMPn2p6aFt4XmaBC/E2mw
         MKxKnm47VX9uNlO7YGIZ2yvEHX+SiwiQMDbv/I93waMP1B0fz+RFWrhUplUBKZnHB6bO
         V1hZQSEniqOKmnge0VNwj1ytPPhIGM3237AwRJk1wIVV4becLDZhlp6FHkimJ5Wu+ufe
         f+FxzIJ5iLyPoVv+I0dcLMZCEXYHKTp/mKJ+L+rpsLaGVy9CUHAa772CGRIFru5gWLnY
         EeBUBC95KrtEhgrN0YCX/sqEJTH5nJrIl/E6wenRZcGaATpcoT4NFgjK8DEpYBuovo0x
         haxQ==
X-Gm-Message-State: AOAM530+WV5goGktV6CUsVWc6UAQ7aouwNc9Lep9DPFRi+I6543jszYP
        AVFOxHlnHnZyQajA0C7LMjHcjh96ak8Y17X5n2j/4ntZbnttCt2wWLkMOEzTya50HROBXfY3oms
        RwP2aBO8xBPmU
X-Received: by 2002:a63:fe45:: with SMTP id x5mr21273254pgj.300.1637929127139;
        Fri, 26 Nov 2021 04:18:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy85Z1R31dmsZQZAGE7c1QOySH5iCeOO1C3o+7PrcstOUW+MEpxn8kwtKDbR9sdMf5bapHqyw==
X-Received: by 2002:a63:fe45:: with SMTP id x5mr21273228pgj.300.1637929126822;
        Fri, 26 Nov 2021 04:18:46 -0800 (PST)
Received: from xz-m1.local ([94.177.118.150])
        by smtp.gmail.com with ESMTPSA id h5sm2956229pfi.46.2021.11.26.04.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:18:46 -0800 (PST)
Date:   Fri, 26 Nov 2021 20:18:38 +0800
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
Subject: Re: [RFC PATCH 01/15] KVM: x86/mmu: Rename rmap_write_protect to
 kvm_vcpu_write_protect_gfn
Message-ID: <YaDQntkX9dLZ0B8K@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-2-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 11:57:45PM +0000, David Matlack wrote:
> rmap_write_protect is a poor name because we may not even touch the rmap
> if the TDP MMU is in use. It is also confusing that rmap_write_protect
> is not a simpler wrapper around __rmap_write_protect, since that is the
> typical flow for functions with double-underscore names.
> 
> Rename it to kvm_vcpu_write_protect_gfn to convey that we are
> write-protecting a specific gfn in the context of a vCPU.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

