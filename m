Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4434A50A834
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391394AbiDUSie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391410AbiDUSi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:38:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98E1A369EA
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650566137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lD3idtDd7NCL34P0gct5UJAjxUjJHC0DJflfQTN0p9Y=;
        b=WzXq+PslL/uK2s+w2SYpZXdGM+XcEn6iMP7qyOzwR1SaJ5kO0w4CzxVQnSvL/TTKyd3Re6
        lrq6MEaVfFPbKbyCvQXgQO9xOMYM39t7qFWAfYmYXg6vZ5eU0DZ2Z+l+flBVHIxXBIWZYi
        2PLPfliNIRDbzeQeXUJIBzcyoD4uETc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-LOXGJtNkOPmxprWKkSTQ8g-1; Thu, 21 Apr 2022 14:35:36 -0400
X-MC-Unique: LOXGJtNkOPmxprWKkSTQ8g-1
Received: by mail-io1-f70.google.com with SMTP id j6-20020a5d93c6000000b0064fbbf9566bso3854453ioo.12
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lD3idtDd7NCL34P0gct5UJAjxUjJHC0DJflfQTN0p9Y=;
        b=4uGLsvqc7gq3mdNdcxHeB3PYL8K85HIl042YlH2Sw4HfOBfutNlZfGr5C3C03nxmdC
         ERbs55FuOTvPWwlcd1vnZxb9kihMCwlePNdzj9FJMUixw2TZpTZZB1SE2ODGIr+apOJW
         Pg5upzyM3UrxaZ8E8y0eEagKvyh//bxiPKz0Og0xTdU1quARVuT6i62Pp0DODbuF3LzB
         aEGDvNZadttq7zngCTWt81DI/Fmzelze8qV7bDbA/esiL8XDeD9/0Ibqz9VYuajFl+KS
         AnDj2YAfnCKluLO80Kl7kx19/XYQd940X10+n7rsXbLoeghAAgMEpneVq4EFpE5YOp1T
         +pJg==
X-Gm-Message-State: AOAM533f592B7JoZ5nW+VM02E4XQr+KbrxANcc4MmgfFHjHoDDWkI6mQ
        6NQi+WNL8TXDW2ZH/Yvnx24WmK3C8fzUK/0C6FA4dXr4k/EPrahx3o52kf8umPQCKV/GG21mdz1
        PVXnkgOb+ouU5
X-Received: by 2002:a92:ca48:0:b0:2cd:63e9:81b1 with SMTP id q8-20020a92ca48000000b002cd63e981b1mr423943ilo.17.1650566135745;
        Thu, 21 Apr 2022 11:35:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzjxVMafCVT6sXTxD41ACNCtxSKenuGT1XbA+oKeoBEXeyn+wkrOZt3LF1GmIC5S2VnNfh3Q==
X-Received: by 2002:a92:ca48:0:b0:2cd:63e9:81b1 with SMTP id q8-20020a92ca48000000b002cd63e981b1mr423934ilo.17.1650566135540;
        Thu, 21 Apr 2022 11:35:35 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id h8-20020a92d088000000b002cbe5d18e21sm12325242ilh.31.2022.04.21.11.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:35:35 -0700 (PDT)
Date:   Thu, 21 Apr 2022 14:35:33 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v6 07/10] KVM: x86: Fix errant brace in KVM capability
 handling
Message-ID: <YmGj9dXMuIKLVJpj@xz-m1.local>
References: <20220420173513.1217360-1-bgardon@google.com>
 <20220420173513.1217360-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420173513.1217360-8-bgardon@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 10:35:10AM -0700, Ben Gardon wrote:
> The braces around the KVM_CAP_XSAVE2 block also surround the
> KVM_CAP_PMU_CAPABILITY block, likely the result of a merge issue. Simply
> move the curly brace back to where it belongs.
> 
> Fixes: ba7bb663f5547 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

