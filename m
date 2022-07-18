Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36D9578687
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiGRPlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiGRPkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:40:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0511D13B
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:40:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g126so10982167pfb.3
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2cMWEzH+ndHC8450rlhcgrDegQ6VEB9Envd54B2eHQM=;
        b=nHIb9ilRkN+ScQRf4KAfdybqCJR4JlX3y4DhOKfTXgzb/3cl0+iJtHr4u/fcrizScf
         rb037cQsqbF8NwgHWnVOHL/0OtoSytKLszg6ieUHwGu/4UWBZIVnV11UZOpi89IsAF2p
         SREYybKwuibfl7/azpWvY3586mhEc2Cu9QtELy/t1J4NeB38i3+VQCrzhody3rWbkk/l
         KRAKXoTvTGCWgdgnNhHeFJCQscPWKuVLDWs+dJSc2oCctw+fgZuOU1Vck21foDcPREfH
         2P+wXyJMU3pr4tD6yvud7caJCYga/nP6fVtoVdnXACleiXMtaVBv1Zb1kymvyt4QwzXR
         WxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2cMWEzH+ndHC8450rlhcgrDegQ6VEB9Envd54B2eHQM=;
        b=AK5rUozSNOyeRBS+FhJXHn1gJE1HcuKP7h+Oglw30iKbYIgfpKdjxWGIa34C0Qx1fJ
         qCn6pgDZHpozxGfe2zCiWnFAe/7pBNrZLb615l/iSkgy63EdIhmshUn0I4viwZve923s
         z2S2kiWskrr2DfQL4RBX9Ua3vBocPcS1w93vbbthl6kT7zd2NXTfqxrQg7VEw6ikQDDw
         9EEYYrOubXUGCV5rLd+hd4Sii7kf9nePct7K6lAezWH55dVyoJ7PKkPIyNYfVrBvf2m6
         2Cur5ENuBjvKbIHnJlk1ijj8Ivcx+jkZTMbhqwo0l4GQEaAiZd2/Eaq14oTSIv1c5ioF
         VvHg==
X-Gm-Message-State: AJIora/N0YeIQsCH69daYtks/hS73+VgdtuPwCcQzCTRPgx0QKEhosmF
        DPaHsxIYi7g8aerh971xH51hGQ==
X-Google-Smtp-Source: AGRyM1veve2U62QrxA7Nk2HtioTqWAVXZhSf4GQ9SNLY+wx/A/uu2FyRIVMKkFvnDnsJHnEVLKUy9g==
X-Received: by 2002:a63:8342:0:b0:415:dde4:f5ec with SMTP id h63-20020a638342000000b00415dde4f5ecmr24201850pge.263.1658158854045;
        Mon, 18 Jul 2022 08:40:54 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id gg15-20020a17090b0a0f00b001ec932d7592sm9525989pjb.9.2022.07.18.08.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 08:40:53 -0700 (PDT)
Date:   Mon, 18 Jul 2022 15:40:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 12/21] KVM: x86: Make kvm_queued_exception a properly
 named, visible struct
Message-ID: <YtV/AbG1vyd4Leto@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <20220614204730.3359543-13-seanjc@google.com>
 <c558310c75367530948b6cccc45cbfe6522cd552.camel@redhat.com>
 <4692a0906554cf6f0473ad138da1b4d739388c89.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4692a0906554cf6f0473ad138da1b4d739388c89.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022, Maxim Levitsky wrote:
> On Mon, 2022-07-18 at 16:07 +0300, Maxim Levitsky wrote:
> > On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > > Move the definition of "struct kvm_queued_exception" out of kvm_vcpu_arch
> > > in anticipation of adding a second instance in kvm_vcpu_arch to handle
> > > exceptions that occur when vectoring an injected exception and are
> > > morphed to VM-Exit instead of leading to #DF.
> > > 
> > > Opportunistically take advantage of the churn to rename "nr" to "vector".
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > > 
> > ...
> > 
> > 
> > Is this change below intentional? My memory on nested_apf_token is quite rusty, but at least
> > if possible, I would prefer this to be done in separate patch.

Yikes!  It's not intention as of this patch.  It _is_ intentional for the "morph"
patch, as KVM can simply force "has_payload" in kvm_inject_page_fault() when
directly queueing the VM-Exit.  I suspect I botched this patch when splitting the
original changes into separate patches.

> Sorry, I replied to the wrong mail, but the newer version also has the same issue.
> (It should be v3 btw.)

Argh, sorry about the versioning mixup.  I distinctly remember thinking this
couldn't possibly have been only the second version...  Should have double-checked
instead of trusting my archive.
