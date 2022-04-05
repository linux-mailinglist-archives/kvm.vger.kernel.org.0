Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B088B4F4967
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiDEWOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443905AbiDEPk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D515D14DFCE
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649167327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJYEigw7gcZXWEyFZUr/9QDtSTka9JkbzhfWwkRGDd4=;
        b=hOpDRQghpVeyVJnRZi6pPt5LDyWPt0GDS3xutIDt4N22Am4v5LGHULtyJg9ReKGcHhTXdj
        BxDQbbS86WQ4lvpDhX1WLxIkAY3OPHTzhD8U/k9VYJGCEH1yiUzGOatmZ3rlP61n5zExsP
        nh8zicYOWdZVJ7uynezC/dUP+Dui5Ak=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-3UWQlF-dO8GK9s7MXytdOw-1; Tue, 05 Apr 2022 10:02:06 -0400
X-MC-Unique: 3UWQlF-dO8GK9s7MXytdOw-1
Received: by mail-wm1-f72.google.com with SMTP id bg8-20020a05600c3c8800b0038e6a989925so2075478wmb.3
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nJYEigw7gcZXWEyFZUr/9QDtSTka9JkbzhfWwkRGDd4=;
        b=m/iPFI4Cp/HfMqCzqn7zRNlBSOeqOoEtAeJFcAFkceOp7EbUJC7sx26PiQo866vVB/
         bglNMC9c2QdHfAfKaxBUARyVdJx/2jYTEmgcnkqX5RcVP4MG4uRR4O8dHsTVTxWHijDD
         6BwF7/nJX5BY+NIJYBAvvVpLwXtG+fekqp9CFbr/ZKQxZkccUNmgTSQ9bEkG5tTzpUTU
         cANNB+ln47PvO9L2py/gf1nW8ZSA/dw1O0fCOfQDLhj8Z2SnKt71K0NAibThkDO6yJ5E
         rrtfNc2+vuQ5nd5DScqEaRoEHeMaMIX5QsVGD5GRSUVDUgiPgGfLEURLJmnT1BUZ5JGR
         cXOA==
X-Gm-Message-State: AOAM532WwRV/jy842D00vYoD4AMbTOVOP2snNnZ4zi+FUQFIQ7+1LfZR
        9rBHHJh3m1z3jDVZG6/UUKfK0I32An1wE8m3bQ+azaVU2W8ncIc1uIOJ9/CLJGZ5E7hQUsX48iU
        jO1KX0AfrXQ2C
X-Received: by 2002:a1c:f415:0:b0:37f:ab4d:1df2 with SMTP id z21-20020a1cf415000000b0037fab4d1df2mr3179619wma.75.1649167324788;
        Tue, 05 Apr 2022 07:02:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqPGd+rNCrPBb3Q21XRMUvq4vybPEOtd0ya7GXcUXL9gILlofg8Ok3vTZuptV9jgnNtmqezw==
X-Received: by 2002:a1c:f415:0:b0:37f:ab4d:1df2 with SMTP id z21-20020a1cf415000000b0037fab4d1df2mr3179606wma.75.1649167324553;
        Tue, 05 Apr 2022 07:02:04 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id j2-20020a5d6182000000b00206134c3225sm5083632wru.67.2022.04.05.07.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:02:03 -0700 (PDT)
Message-ID: <240599a4-47f0-fe7e-1270-5ec7fbc0da0b@redhat.com>
Date:   Tue, 5 Apr 2022 16:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 033/104] KVM: x86: Add infrastructure for stolen
 GPA bits
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <a21c1f9065cf27db54820b2b504db4e507835584.1646422845.git.isaku.yamahata@intel.com>
 <2b8038c17b85658a054191b362840240bd66e46b.camel@intel.com>
 <20220401023426.GF2084469@ls.amr.corp.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220401023426.GF2084469@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 04:34, Isaku Yamahata wrote:
> Sure, this patch heavily changed from the original patch Now.  One suggestion
> is that private/shared is characteristic to kvm page fault, not gpa/gfn.
> It's TDX specific.
> 
> - Add a helper function to check if KVM MMU is TD or VM. Right now
>    kvm_gfn_stolen_mask() is used.  Probably kvm_mmu_has_private_bit().
>    (any better name?)

I think use of kvm_gfn_stolen_mask() should be minimized anyway.  I 
would rename it to to kvm_{gfn,gpa}_private_mask and not return bool.

> - Let's keep address conversion functions: address => unalias/shared/private

unalias is the same as private.  It doesn't seem to have a lot of uses. 
  I would just inline "x & ~gfn_private_mask", or "x & 
~kvm_gfn_private_mask(kvm)"; or the same with gpa of course.

The shared and private conversion functions should remain.

> - Add struct kvm_page_fault.is_private
>    see how kvm_is_private_{gpa, gfn}() can be removed (or reduced).

Agreed.

Paolo

