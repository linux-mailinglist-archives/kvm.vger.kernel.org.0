Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC06529378
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348487AbiEPWPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237155AbiEPWPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:15:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 021513DDD2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652739317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JuW3QwsjLnIHzexmcbuxOT/copWJfJvLB7O2eT/trZ4=;
        b=D5op1Cd4QYE32yjBIhPSbg/iEI2Q4gY8PoAq61pf5bHYDsj5dnQG+2iaxbjx1WyzPAFw/d
        dr+czpWsAEsczLyweUMlyMSbR7A+I5c3r2tRzVhGS9e4t/Z0zILU1n8u2KO5lQ7fKWw2hm
        L0FvQWW4u8+Q12P7jHsSIA8e3moDHaI=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-i3CWzPmuMP-ifVafeBPbIA-1; Mon, 16 May 2022 18:15:15 -0400
X-MC-Unique: i3CWzPmuMP-ifVafeBPbIA-1
Received: by mail-io1-f72.google.com with SMTP id i66-20020a6bb845000000b00657bac76fb4so11262381iof.15
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JuW3QwsjLnIHzexmcbuxOT/copWJfJvLB7O2eT/trZ4=;
        b=yvjsbo3+JzqCvqDnOoUdWnln/WsoZpI8dOmWg4+sebH/o4jx8OiJgu5Z1kuyWRWkYV
         gRtYbdi1Kdi5+buwWfXmE8qgniJDhqzHsi1NHu9zfgoTsktEYC7X6qj4kB8mJJnDow1Q
         fb9Ipb8Tpw74Wvl+LxEOs6fnTryHJpVV7Nxx8P+XD24q5RMcPYmt6lf2M2pU8X5sCGg5
         74Qv+iLFibtrhvxfWyQTf0688kfAYJ50rxphylJSPlAaozPK43sPFDsTNSb/zQbAoE+p
         wd59KUfklAlF6R2ewhsF8ubKit0BIvTKgtBF3JlM8EpGZCxYQ4f+/oXqE2Y+vufMOKyg
         ruMA==
X-Gm-Message-State: AOAM5315DDY8bjsm+GiarvJE7kNKs2ofOg0IbSLqspU00Qle/BJqmA4K
        OcpaMMyssXegKtagU7AGrtaZQUQLFtbDMdo9eTDdpQb0xNCWrvv1N/A5o2bgo5FE9tjt9yZez0+
        2GXd0KE9HZjK9
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id h2-20020a056e021b8200b002cf199f3b4bmr10333976ili.71.1652739315248;
        Mon, 16 May 2022 15:15:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU5MqDz5nPjCYc5Fc9BEuaQ7eNqXAkawkwSryJxJKorC6GSl5odnhdDAn1S1vWiFrkAF3ATA==
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id h2-20020a056e021b8200b002cf199f3b4bmr10333964ili.71.1652739315034;
        Mon, 16 May 2022 15:15:15 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id y24-20020a5ec818000000b0065a47e16f47sm154436iol.25.2022.05.16.15.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 15:15:14 -0700 (PDT)
Date:   Mon, 16 May 2022 18:15:13 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 8/9] KVM: selftests: Clean up LIBKVM files in Makefile
Message-ID: <YoLM8eerTvmuJ3QZ@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-9-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:34PM +0000, David Matlack wrote:
> Break up the long lines for LIBKVM and alphabetize each architecture.
> This makes reading the Makefile easier, and will make reading diffs to
> LIBKVM easier.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

