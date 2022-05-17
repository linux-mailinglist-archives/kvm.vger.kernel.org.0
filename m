Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3B852ACB0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349725AbiEQU1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 16:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346758AbiEQU1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 16:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1F005253D
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652819241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H9Gp+dDSwtJppHQmYp9g4XPZwV0qyZ021lD469dqbsw=;
        b=YE+MT+syGVX5pMBD0leSisz3CoqBqT1YhQ1Re9BVt0uS+rEiHjFB7dYI1McjAcgkjd3hTq
        ByB37wd5NWOAdMIe3GYixlqG+7qlzStYStur4mRQUegcqu4P2LoUQb1ZUFJUqyBBjjhbgE
        6NoMeulIwuplQlL/Zq84nggAAq8obr8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-xgau_vJpPQ6sPovCAYk9kw-1; Tue, 17 May 2022 16:27:19 -0400
X-MC-Unique: xgau_vJpPQ6sPovCAYk9kw-1
Received: by mail-io1-f70.google.com with SMTP id q12-20020a0566022f0c00b0065af7776ee7so13121912iow.17
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H9Gp+dDSwtJppHQmYp9g4XPZwV0qyZ021lD469dqbsw=;
        b=y2k3MyfvBsQi3mPfq0PI5PFWvsJCCqop0ngrNtzquUwgfZnuYPO9fadPVuBWjSvY8v
         xrRE17DWWp4xDEly1IESF+fpPQYVjoAdVZ6FusrZWzXDF0778fKk4P2LOTat8dWAIRbk
         940+sr5evm0ptJN7nQyM239hDmz4ueCNf+BrHOyLoeHj8HFwictBKWxjiTj+CKQnwOAY
         HFTaLEGmF/Wou38PeBHuC6nh2SFRacuCD/gnGnJrnp+EFNodeIj6IsWzONV/zog9gS4E
         jqZCxJd4CkSuJtF97/ZBwaLpSpXyAT0DcQQNzn1AnL+t0gjqmzOjuRphOrWf0RW2vaQf
         aXWw==
X-Gm-Message-State: AOAM531xcqCt9Y4iYDlSW9rD+Oc9lqAx+0DV8au5Y7tAjA5YUnqzujvg
        QBBU2x1fEWAcQKSnYyk1usBKN43FcFd9zIzpc+pviZTwnRDU4vrsiHtb+NIkCQcKc7KhYcQNa9Q
        wusFfJxQ3XECk
X-Received: by 2002:a6b:b755:0:b0:657:b849:dbaa with SMTP id h82-20020a6bb755000000b00657b849dbaamr10916625iof.84.1652819239119;
        Tue, 17 May 2022 13:27:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPqFKvChYUimSMo0Nk7767ZWGf04/7uYezFZD+CeU/gk9puYnZRGWL3T/L3E3JMaR42ldx8w==
X-Received: by 2002:a6b:b755:0:b0:657:b849:dbaa with SMTP id h82-20020a6bb755000000b00657b849dbaamr10916614iof.84.1652819238922;
        Tue, 17 May 2022 13:27:18 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a66-20020a029448000000b0032e3c89558asm19461jai.94.2022.05.17.13.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:27:18 -0700 (PDT)
Date:   Tue, 17 May 2022 16:27:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] KVM: selftests: Add option to create 2M and 1G
 EPT mappings
Message-ID: <YoQFJPVnO2F9ZN9g@xz-m1.local>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517190524.2202762-3-dmatlack@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 07:05:16PM +0000, David Matlack wrote:
> The current EPT mapping code in the selftests only supports mapping 4K
> pages. This commit extends that support with an option to map at 2M or
> 1G. This will be used in a future commit to create large page mappings
> to test eager page splitting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

