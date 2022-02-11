Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF99D4B1B5D
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 02:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346929AbiBKBiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 20:38:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346851AbiBKBiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 20:38:04 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E0559F
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 17:38:04 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c8-20020a17090a674800b001b91184b732so7988017pjm.5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 17:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W+QLdexncrt7fssp35DFBBO0T/wYjktDkLUyIpTkao8=;
        b=G0ckz5tBVEkENDx+uCWl+CetVEKBKnH4ZssUmqpDWix/tycWaYeqdUR7fKBRgxb1bh
         c962bsq4OXWTp0p+ByctRCxBHQMZPA4gTpDofYRE9icSm+3BEu2rNIr4po/xNocOZhsN
         xXm75+4dZ6et5LACPG4HxiQWjWXZdmGo6Pm313WD3tZw4SWK+fw0Ovsgw7Ok3EKaRMx5
         mm/ARFPecrZZeDRXF/UX9VKMJV3+P54LkAuM5g0ONbwlalpvGtdFPd7vEmwCzUT76YlY
         h/BMmsZ+NGgsdpQJ+kYS1q5URt4PwPZWSRgLy8wkIdaUGROZu76l248xcdp+IXS1VsQD
         X34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W+QLdexncrt7fssp35DFBBO0T/wYjktDkLUyIpTkao8=;
        b=A2ljKkl8JGcstYFnzP5CnpQkP7i1CPjyM1BhguEzK1FsIgWfzi3xVzi089n+qD39Eb
         3LchZ5WB4g7Qwvl4Vy4dDQ5SnTO+zxS4UPdicpUuBy01NzpCINDGfQoLRgLLkUrYVuPM
         vfhnSHq9FBsffLfib1oZmJC0X0niVjIarrmB9OtILj1HyltxHp3F1NP874K+H0I2zcDK
         u0grKefSEqJaGjVErWTOUTsVFVVPiznC1Czrs3Yh2UlvlaKVyuXQLYThckB60C02dxKv
         IEuis/J7Lge86BiqBQ4QUbtFSF3396ukWQrVXeWz3CblObiIxSgEvVpjnQHfAKYCZEHs
         FEGQ==
X-Gm-Message-State: AOAM532DZVkgIz9obpCdMm8NOSiOKjyIyAJKJrBx2Uc+lY3hbQ9w9oYu
        2Y8cvvgiABzorC4+ltSTnD3q5A==
X-Google-Smtp-Source: ABdhPJzZwsLROLVe4WRLo+PMYfsO2P0bIGNPqrh6H136/3CTjPJj52B+Fi3F3zTmpIFoqG6quOmF0w==
X-Received: by 2002:a17:903:1ca:: with SMTP id e10mr10209291plh.138.1644543484104;
        Thu, 10 Feb 2022 17:38:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c11sm17214572pgl.92.2022.02.10.17.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 17:38:03 -0800 (PST)
Date:   Fri, 11 Feb 2022 01:37:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 09/12] KVM: MMU: look for a cached PGD when going from
 32-bit to 64-bit
Message-ID: <YgW99wRxczsAJ0jv@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-10-pbonzini@redhat.com>
 <YgW8ySdRSWjPvOQx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgW8ySdRSWjPvOQx@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 11, 2022, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> Hmm, so it doesn't matter (yet) because shadowing 4-level NPT with 5-level NPT
> is fubar anyways[1], but this will prevent caching roots when shadowing 4-level
> NPT with 5-level NPT (have I mentioned how much I love NPT?).  This can be:
> 
> 	if (VALID_PAGE(mmu->root.hpa) && mmu->root.hpa == __pa(mmu->pae_root))

Gah, that's wrong too, it will allow the pml4_root case.  *sigh*  I'm fine punting
this until the special roots are less special, pml5_root is completely broken
anyways.
