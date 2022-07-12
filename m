Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256925725AB
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbiGLTfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 15:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiGLTer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 15:34:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AE9104027
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 12:11:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fz10so8797920pjb.2
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 12:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Kx2yFOxzNDMjpBzKe/G+nv6YKHvbcis123ack/xGb8=;
        b=HGlxE9Rz4W0J6kVtnkAh8fcUr/Nk/Uqp1oaw5BT+iq1uOc7rsVlbH3FukGyC6+WbHk
         TXK+occhAfQ6mxrZCbfEaxbg0/f3dSDjkANb8N5Aih4ImLN0GQk4EF+r3APirlfzqGcc
         +eHQjCk0EoovEQPi1w473gD5JVDcRHCTqzoVHuQxBoOrlqma2o/curvEOaJSttYp3cVm
         vxQsIFQtKBT1uK/e77ZMwnL8xlMfkhe+ZnfhIqc9JkIQYF1veJ0orcI+KfXeG1QMwqb4
         NjkrnrfTIadvbCH8yDVpgbePBJRnkMotsmBOhYLlfZjCIshqdJwR8fMhVz2B4U5Lx4LM
         chsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Kx2yFOxzNDMjpBzKe/G+nv6YKHvbcis123ack/xGb8=;
        b=niAYB09t6Lv/2JqkBttB1/xCjZb/1U/x7PhMZCIXgDCP67unXtIT9BNUbJYDFbKJgw
         CMWQf0UyefEr8gWpnfvanCNfTTxwWoAVMTW9LdWtnUN9NWS6Gn0m85LYq9wwjhYCAqD5
         Gu4rkBkpFnq9jdXPKUoU6PleCI25l4sD/qpnjHmcrOxbbIXIhwXP3SLABfsSiQ1iLWhy
         zSilDvJMebyxuyFJPxmMGAge9dHKtNrz/rI6l6f1N973O42x7qMlFd2zCNwlhrH+z5p9
         imBx34OBbKf3MrRMI+CjRvSSNVuiINcz3j9gI6BNOpQOEQuIrBcdYvyp9petb053Lo9+
         qvQQ==
X-Gm-Message-State: AJIora8r8l64RFmhLSb5IieB64/hUmvcs+Kv3SZudQX/Bt/2ettGJ9zS
        L4zglYpr54wor5pIbCBFmwZdArMkkQAoCw==
X-Google-Smtp-Source: AGRyM1urLDiZlzyBakk+qZSDiXiE8047kWogHiKlJjZOIslbpuen/Xm89HrUvGCqP2lwOOjujkGNpw==
X-Received: by 2002:a17:902:d5c7:b0:16c:131:7409 with SMTP id g7-20020a170902d5c700b0016c01317409mr25057483plh.80.1657653060211;
        Tue, 12 Jul 2022 12:11:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902e88c00b0016bdc520f8bsm7233414plg.299.2022.07.12.12.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 12:10:59 -0700 (PDT)
Date:   Tue, 12 Jul 2022 19:10:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Always enable TSC scaling for L2 when it was
 enabled for L1
Message-ID: <Ys3HQDuAO63uOV3f@google.com>
References: <20220712135009.952805-1-vkuznets@redhat.com>
 <ee479e42605d3ed3276b66da69179dbfbcb05dbc.camel@redhat.com>
 <871quqpcq4.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871quqpcq4.fsf@redhat.com>
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

On Tue, Jul 12, 2022, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Tue, 2022-07-12 at 15:50 +0200, Vitaly Kuznetsov wrote:
> >> Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
> >> hang upon boot or shortly after when a non-default TSC frequency was
> >> set for L1. The issue is observed on a host where TSC scaling is
> >> supported. The problem appears to be that Windows doesn't use TSC
> >> frequency
> 
> ^^^ scaling ^^^
> 
> >> for its guests even when the feature is advertised and KVM
> >> filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
> >> L1's. This leads to L2 running with the default frequency (matching
> >> host's) while L1 is running with an altered one.
> >
> > Ouch.
> >
> > I guess that needs a Fixes tag?
> >
> > Fixes: d041b5ea93352b ("KVM: nVMX: Enable nested TSC scaling")
> >
> 
> I dismissed that because prior to d041b5ea93352b SECONDARY_EXEC_TSC_SCALING
> was filtered out in nested_vmx_setup_ctls_msrs() but now I think I was
> wrong, SECONDARY_EXEC_TSC_SCALING was likely kept in VMCS02 regardless
> of that. Will add in v2.

Yep, it would have been kept in vmcs02 even though the feature wasn't advertised
to the L1 VMM.  A Cc for stable is warranted as well.

I added this (with the tags and s/frequency/scaling) to the queue of patches for
5.20 I have lined up for Paolo to consume on his return.  Paolo and I haven't
hashed out how we'll actually manage anything, i.e. my list is speculative, but
unless you hear otherwise, no need to send a v2.
