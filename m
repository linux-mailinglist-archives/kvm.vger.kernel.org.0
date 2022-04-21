Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD066509440
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 02:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383402AbiDUA0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 20:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiDUA0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 20:26:31 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550901AD94;
        Wed, 20 Apr 2022 17:23:44 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2ec05db3dfbso35888427b3.7;
        Wed, 20 Apr 2022 17:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/6tjTikelc+DvD6SuOPR5OX/KDETCZdTqib8WzVGM6k=;
        b=J9+P2QcdFxTdNjI+911dj+CfKlzokjSU3cXmZi9MWP8ijq02O5okdNsan8eheLZyZH
         UVOCM4IO+PwLszE1eSTfQeqy3Y2FJdNypyCFQRyzhNLA6BmHvVFrmk3nRJY4QnH7vsxl
         BbQl0eKDpfEIiWxbckp5d21fN1iplmCAwGxF6XPq9HzfA7Mr/QDhxCKrkaV+Rw0vE8fv
         N6B8AM3+cLBWNbi/j/jXbMhajM5Mkzk7FZd6cC/C9bWf5Ls9ZNkWDvy73bYK0nSGFDrr
         xUU4zTSgGUQoEcXpc/HWeVT3D0cwDwfFbxnBGwFLNrgRE1likQDbWQW4gvzovcQLjQlX
         6k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/6tjTikelc+DvD6SuOPR5OX/KDETCZdTqib8WzVGM6k=;
        b=uvr0NXsbtic2HXDNDuH1JBGjDQqBCzjkFsFJJECE3kyaMUSHb3iQRDJROtsHG3Tkq4
         KbY8UpgTkYislRVOkWHedi8mMEmkAOURPznMqY0Abfzfh3xmt74igauM9EsesHWUXbQG
         458uZe8K+UwmJpMYcTYID2UhR6pe2ZY7TXrk4USUmnaq19dL6EEnwxUQNHjSSb7l9iXa
         xMSA78V6uGZnjftbydTcdc623+BM8gDKClmAekc2yerEyO4nzn82XSlkChnX0WJjZOS3
         QQwHHSgWF7XisrBtMi3L2S4OiqHo36sohRr5DN8YpF9pS4/I7l2JU2RZXPqHkIwyBQ8t
         Fotw==
X-Gm-Message-State: AOAM5310Qt/wMyw7h17OpRwfqCZB3635lptNgIuUBZfI9GAKcMlHlc0w
        ggzCVOtePKoiEVc2ZkWt94lhBhloUMlu9GF4IwM=
X-Google-Smtp-Source: ABdhPJxh4FIiwkC8UnFlBKLEY0wBQ9HXsKx09lA/608Freh+1YGN0z1iMdCE2drd101Ja4/ElvJtb40Pd+fncXlrROM=
X-Received: by 2002:a81:1e86:0:b0:2eb:66b9:3a93 with SMTP id
 e128-20020a811e86000000b002eb66b93a93mr22693995ywe.411.1650500623592; Wed, 20
 Apr 2022 17:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220420131204.2850-1-jiangshanlai@gmail.com> <20220420131204.2850-3-jiangshanlai@gmail.com>
 <3e6018ad-06b7-f465-7b74-aeb20bca9489@redhat.com>
In-Reply-To: <3e6018ad-06b7-f465-7b74-aeb20bca9489@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 21 Apr 2022 08:23:32 +0800
Message-ID: <CAJhGHyARz6rPZ+yJfkGPCbtZJnnMnODSD8szs7YYNVceCXhbSQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: X86/MMU: Introduce role.passthrough for
 shadowing 5-level NPT for 4-level NPT L1 guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 1:15 AM Paolo Bonzini <pbonzini@redhat.com> wrote:

>
> Looks good, and is easy to backport; thanks.
>
> However, once we have also your series "KVM: X86/MMU: Use one-off
> special shadow page for special roots", perhaps the passthrough sp can
> be converted to a special root (but now with a shadow_page) as well?
>

It will be much more complicated.

The current code allows fast_pgd_switch() for shadowing 5-level NPT
for 4-level NPT L1 guests because both the host and the guest are
64 bit. Using a special shadow page will disallow fast_pgd_switch().

And it will make using_special_root_page() more complicated.

It will require a different kind of special shadow page to make it
able to do fast switch.
