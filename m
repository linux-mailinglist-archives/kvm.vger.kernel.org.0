Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ABE52BDFB
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbiEROzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 10:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbiEROzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 10:55:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8A463524
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:55:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y199so2357868pfb.9
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o7tY6ZcRmC6gYAakiOEfUJCGVoPD3Xvj9BL1UezKdDA=;
        b=VPhKTi9d8w7lwf065MCuP6kWcomDghzJDkfvBQwDM9ND2AbNAeIZk20nTc63vu6Mos
         wag31H9GOQNSydzbC5RipG22vzckeEC+ITBUZzqhHq7mDWtPnoKq5jo2cTUqWpLKrTe4
         WRkoKwzSZ6uhDh9PaswEQCSHJIPI22M/PAjIqhjrXaGjT3XGB75hvtpifewTVXtoWVmn
         iJ0qdKOWoGkCWpDZrLhex/I5t0AlklSTgtp4IWxeJ0JihjReGg8FJ+USEvlJmqa8Esfi
         i6NlWqbaVKThA/yt171mlYyO0TUSCPiXvO14Ex5U20QOp72xCVt484SU7jhaoMdIof0b
         LBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o7tY6ZcRmC6gYAakiOEfUJCGVoPD3Xvj9BL1UezKdDA=;
        b=r4rEEQ/3dGrdmr6Xbc8J1Czpy8VkuWNUU8YzOTNonOXfqE18Oi5XQY7FXY3hj8JTLH
         PGNSA5l7gATqncO78O44x/gzxDbwVYGDzxYEKRwI3vuxSDbx1fsXGidSsU9YwIsKfzMM
         jB9PV4qOGvAMHZLMojeoGEqOnqRcthoj5Yo94apsQWunUsZf+fBTbfnXuq76pid0PL64
         UV5lZU6cbQTplFiP8IL6qaADLhB369vfH5EN9MjX6b5GGxO+0RkeeoUCX4LDzA75JIf5
         0AXnXxL5UFaYlYs/OdZCgbOFQAgvmSBBfvSeetxyNS+WOH87Q16BWYSx3XVtnTesRVfF
         TQDA==
X-Gm-Message-State: AOAM530wT+cNBVFvQ16zuyt840+6frOPa5WwVHJhSuHkjQJvo8+V8lvW
        z+MWbHtSHQiGNquinDKdWpTRa0/TIiMWtw==
X-Google-Smtp-Source: ABdhPJysEejWXF06hcE4vW/aCi2q+cxS02x/9DLbVEAvnOwBC9SO7Q3PrJUwsB/1bty7W3/d06HCcQ==
X-Received: by 2002:a05:6a00:2908:b0:4fa:9297:f631 with SMTP id cg8-20020a056a00290800b004fa9297f631mr93240pfb.3.1652885720016;
        Wed, 18 May 2022 07:55:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id jh1-20020a170903328100b0015e8d4eb269sm1781608plb.179.2022.05.18.07.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 07:55:19 -0700 (PDT)
Date:   Wed, 18 May 2022 14:55:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 04/34] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <YoUI03NDdMPYTiSO@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-5-vkuznets@redhat.com>
 <165aea185dfef1eba9ba0f4fd1c3a95361c41396.camel@redhat.com>
 <877d6juqkw.fsf@redhat.com>
 <YoUAM9UtfQlGOZxl@google.com>
 <87y1yyucis.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1yyucis.fsf@redhat.com>
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

On Wed, May 18, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, May 18, 2022, Vitaly Kuznetsov wrote:
> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
> >> > Or if using kfifo, then it can contain plain u64 items, which is even more natural.
> >> >
> >> 
> >> In the next version I switch to fifo and get rid of 'flush_all' entries
> >> but instead of a boolean I use a 'magic' value of '-1' in GVA. This way
> >> we don't need to synchronize with the reader and add any special
> >> handling for the flag.
> >
> > Isn't -1 theoretically possible?  Or is wrapping not allowed?  E.g. requesting a
> > flush for address=0xfffffffffffff000, count = 0xfff will yield -1 and doesn't
> > create any illegal addresses in the process.
> >
> 
> Such an error would just lead to KVM flushing the whole guest address
> space instead of flushing 4096 pages starting with 0xfffffffffffff000
> but over-flushing is always architecturally correct, isn't it?

Oh, duh.  Yeah, flushing everything is totally ok.  Maybe just add a comment above
the #define for the magic value calling out that corner case and why it's ok?
