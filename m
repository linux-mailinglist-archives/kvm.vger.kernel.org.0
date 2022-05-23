Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07046531839
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbiEWR20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbiEWR0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:26:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898BB41F83
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:21:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so13693162plg.7
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VcVFk3FcEgzfyMwYD0aU10qnYcHMUzYlGb8aE1VELAQ=;
        b=sq3P/fw7RUx9aBXoSaVhkvBFulT5vCvnYlKSTPsTothpsy2pNOKALFyKKhn9W44OlL
         +cZjRjNgRJKzURqhNHFr0bUheleEFwIHlJUOjHe6+8/H6czcQuaTKrXLrynQfLXa1OF7
         yUB2nwoJ+3wh0pucpP+eqxwtGsKcnBiHhM/w+W1JdgmtzaTY+2NwOkQaG6/PtzHj0GWT
         bVT25LrcpTLBknZo92GNsZz5UoQm3/XU+3fhcdLnlT4+qGXOXOpf5/bXgmbXK5zaHcwr
         jCsXk2nSI0snXcDdnj6SEgHzF+u1KK7yHVrsA2Gf0yoGU3gPFccu7ykntQLChDo2pHOe
         QTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VcVFk3FcEgzfyMwYD0aU10qnYcHMUzYlGb8aE1VELAQ=;
        b=gxubxTLTJTc5iihMUhObqtoajgP0J4Fu5hzZ53/oCgrHs09nURpwEK5yVksjkiIucy
         KI0mLxtEYM2FmXcsGXrW6hQiYoLRPT2MZpSaEv8OzToGlB9/cPw6Vn9pj7E+W75ZlkA1
         aCSneJyP9Ee9ywFQnKnV6PR7QrYd+1YMbpJS8NpQxV7FGPkEwDcD2jMbfcdYcb002LKk
         YP373+75Kkr2+ytn8oLMsabv2JhycSCQHkpmKFp0HPkgjy1pdYZTjlf6Mnwn4NrK2lOU
         aJ+D0ubTD8fPcAcbiQ8QoCIfDkRiLxjl18Qzmh4moJ2H6GS6Svmfe7j5bnsQ4H2bhEjN
         L1gw==
X-Gm-Message-State: AOAM5321F7Ftcw+5Pn4Evxnqkv1irbcXt+iZFIDjAIwgqIwRVCv09K4k
        L9I1GYV17NYBCkzgk3ivckBkXZd88z9u8w==
X-Google-Smtp-Source: ABdhPJz0WtrjOJCip7mt3F57oMADC6YJYPp4ap9cajQlDw45E7nedRqS2OqtCHvUvpJcdnhIjwCnKw==
X-Received: by 2002:a17:902:8501:b0:15f:173:40e1 with SMTP id bj1-20020a170902850100b0015f017340e1mr23539994plb.74.1653326361089;
        Mon, 23 May 2022 10:19:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902e84200b0015e8d4eb273sm5392051plg.189.2022.05.23.10.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 10:19:20 -0700 (PDT)
Date:   Mon, 23 May 2022 17:19:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 03/19] KVM: x86: SVM: remove avic's broken code
 that updated APIC ID
Message-ID: <YovCFBn5cKcv3iwD@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-4-mlevitsk@redhat.com>
 <YoZr9wC2KjTFHrQ7@google.com>
 <d1df82a17e6e89ab58d5f6aa911ee2d532efee31.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1df82a17e6e89ab58d5f6aa911ee2d532efee31.camel@redhat.com>
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

On Sun, May 22, 2022, Maxim Levitsky wrote:
> On Thu, 2022-05-19 at 16:10 +0000, Sean Christopherson wrote:
> > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > AVIC is now inhibited if the guest changes apic id, thus remove
> > > that broken code.
> > 
> > Can you explicitly call out what's broken?  Just something short on the code not
> > handling the scenario where APIC ID is changed back to vcpu_id to help future
> > archaeologists.  I forget if there are other bugs...
> > 
> 
> 
> Well, the avic_handle_apic_id_update is called each time the AVIC is uninhibited,
> because while it is inhibited, the AVIC code doesn't track changes to APIC ID and such.
> 
> Also there are many ways it is broken for example
> 
> 1. a CPU can't move its APIC ID to a free slot due to (!new) check
> 
> 2. If APIC ID is moved to a used slot, then the CPU that used that overwritten
> slot can't correctly move it, since its now not its slot, not to mention races.

The more the merrier :-)  Any/all of those examples are great, just so long as it's
obvious to future readers that the code truly is busted.

> BTW, if you see a value in it, I can fix this code instead - a lock + going over all the apic ids,
> should be quite easy to implement. In case of two vCPUs using the same APIC ID,
> I can write non present entry to the table, so none will be able to be addressed,
> hoping that the situation is only temporary.

Very strong "no", let's keep this as simple as possible without outright killing
the guest or breaking ABI.  Disabling APICv/AVIC is perfect.
