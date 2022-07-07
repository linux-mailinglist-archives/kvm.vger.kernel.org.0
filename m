Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3811F56ADD4
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiGGVjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbiGGVjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:39:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF6A2CCB6
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:39:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x184so8517761pfx.2
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pfzUOZFFSsLuWvtbAH4LMoUMhR9nzwLEUQr6Uj+RyfE=;
        b=BSa2kJoprXwY2CZT2npE1CSWSjmIwWOpFZWlvkar8d8Gl16Ryhzpl8WN3rwPjgTDh4
         HJ1wT+OV1RSHfhBhU3wvcb5bdBdiTRRgoz12ZminSlgYmz8YIn27FYiykjJ5NCu+c5Qc
         57FMJh3kCzsZIP+wVshzI1LiNCghBoOJxCKSgEqtK8vARyPgLz/IPxqkpVKAtDwDOsnx
         CKqeEybQjMOCHWWVGXxTubXH6lWBBR09m+9JrbQixkuuDubznA2QyL3JeCUC+ERweCWC
         0wH3Van6zZQKjSUKOhKWyRckl5AyDB+8NfQuF4zy4wLXYLNlf0qpqiEenD8tOWzpDj6d
         qLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pfzUOZFFSsLuWvtbAH4LMoUMhR9nzwLEUQr6Uj+RyfE=;
        b=k4XQX96eR/I0SqoYOH4y2Ky4Fak/JQQ0OxS4uIuc6+t4iGwi0ei75324tNwOAxwsCZ
         bn8MKvbE6qIhGSdwEGs4gz/VvD9j8+8g9NeSgc35bv2etuiTZt9DK2KruXNfrTXlchzR
         alcxyJ3WuM5T3w9AY+1YD6rWPXZ/IN6S/ck2zroAeoUqqRMboA2ea9I49zXBSD/qIueo
         w/rk3w73G0t3mGVyVIRQCa7AmvGnfRIQF2qtXc2GHtkioWRydsKEVu0kaZ1dviRrW74i
         Oos4GDILiFGxE7JUMuHdV12ubZpOj0tPDToMyJxAjODx0aeRDeZR8i1l7A7Y0G/7oDOP
         CF/g==
X-Gm-Message-State: AJIora9Zmt7jnugqmtHt/fida5ZC8cGyr5LxwxnKcTlp/LaniBC7VUNK
        LQU5rIuwuJGjeHPgKS2salfivQ==
X-Google-Smtp-Source: AGRyM1v0b4TB8z5Yib0OBicqva9fHv7fzJ05f2ZcgN8F2o28eBsrArs6y1FIInujqLJXHKLQWGjxLA==
X-Received: by 2002:a63:87c6:0:b0:415:f6f:4469 with SMTP id i189-20020a6387c6000000b004150f6f4469mr122283pge.491.1657229952597;
        Thu, 07 Jul 2022 14:39:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u13-20020a62790d000000b0052896629f66sm2085630pfc.208.2022.07.07.14.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:39:12 -0700 (PDT)
Date:   Thu, 7 Jul 2022 21:39:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 22/28] KVM: VMX: Clear controls obsoleted by EPT at
 runtime, not setup
Message-ID: <YsdSfP7xmMcLv8i9@google.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-23-vkuznets@redhat.com>
 <CALMp9eRA0v6BK6KG81ZE_iLKF6VNXxemN=E4gAE4AM-V4gkdHQ@mail.gmail.com>
 <87wncpotqv.fsf@redhat.com>
 <Ysc0TZaKxweEaelb@google.com>
 <CALMp9eTrtFd-pcEeWvyAs7eYe1R1FPvGr0pjQNP8o8F0YHhg8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTrtFd-pcEeWvyAs7eYe1R1FPvGr0pjQNP8o8F0YHhg8A@mail.gmail.com>
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

On Thu, Jul 07, 2022, Jim Mattson wrote:
> On Thu, Jul 7, 2022 at 12:30 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jul 07, 2022, Vitaly Kuznetsov wrote:
> > > Jim Mattson <jmattson@google.com> writes:
> > >
> > > > On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > >>
> > > >> From: Sean Christopherson <seanjc@google.com>
> > > >>
> > > >> Clear the CR3 and INVLPG interception controls at runtime based on
> > > >> whether or not EPT is being _used_, as opposed to clearing the bits at
> > > >> setup if EPT is _supported_ in hardware, and then restoring them when EPT
> > > >> is not used.  Not mucking with the base config will allow using the base
> > > >> config as the starting point for emulating the VMX capability MSRs.
> > > >>
> > > >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > > Nit: These controls aren't "obsoleted" by EPT; they're just no longer
> > > > required.

Actually, they're still required if unrestricted guest isn't supported.

> > Isn't that the definition of "obsolete"?  They're "no longer in use" when KVM
> > enables EPT.
> 
> There are still reasons to use them aside from shadow page table
> maintenance. For example, malware analysis may be interested in
> intercepting CR3 changes to track process context (and to
> enable/disable costly monitoring). EPT doesn't render these events
> "obsolete," because you can't intercept these events using EPT.

Fair enough, I was using "EPT" in the "KVM is using EPT" sense.  But even that's
wrong as KVM intercepts CR3 accesses when EPT is enabled, but unrestricted guest
is disabled and the guest disables paging.

Vitaly, since the CR3 fields are still technically "needed", maybe just be
explicit?

  KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not setup
