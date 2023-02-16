Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043476998FB
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBPPfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBPPfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:35:15 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEC1FF2B
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 07:35:14 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m12-20020a1709026bcc00b001963da9cc71so1206452plt.11
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 07:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P+K39a3lkrPjb6Ydk4juAr//fb/UufwN2Ojf6Pmvl1Q=;
        b=U6i2lq71o0LoinifN89TRqcSO7jBk66D/3XlkJT1Awz8zponDsAC5Q2OfOepE+7Ktr
         nhn63FGwu9mF5frMM1VFlhPa7SMQIbOe+utlAJKvdh30k80X4urjdLeBc+owwEUYLBRb
         i1dhtdx51M10zwT24fjYKWu2yuDdqOnZJziHVHSfEqJZogJeRfBR7THsTjePROboe4zZ
         Ml44HynvoCeROMJbaUsfw+7j9QdXikEZ7Q1iWd39LsR2+a+6GFg0FqnDVfLxS7h+VnDZ
         6QptISnbVVrVFCWQN5808t2mIuCz4iIP5tatWd64WjbMrcd8wlP9gIGaCt7IgVmLAn4U
         FQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P+K39a3lkrPjb6Ydk4juAr//fb/UufwN2Ojf6Pmvl1Q=;
        b=sTxr1vgKWZhQKAgbFv7S2A69D8rzrEL4IUd86IaxFfRxn1pZ+A8o+RL9kGt6onEgUi
         INsKumdrIznqyf+NmcvnO9cLzBjTS9bDBkeq3My4UVuc/TAdxd4IxZBdeRVN5IOVw1rA
         AyvdGEazt8I2Z/J1yRovj988L0FNK0wpDwSqHiaiQyiiWGrm1nT06uwVFQx8VSifqCAs
         3jzWUwKJaZevJpXtkHzy3zcj9M3ktxZnmWImDzJaOa63xU8CRWX2li5MuWsML7gIAkPF
         xA0C4+eBj65NFZmf2n8I9q3kTVga5A1rhvftoo5nYJ8/0lkLSG033wXLGvmWahkW2CTb
         qXdQ==
X-Gm-Message-State: AO0yUKWLmGqXsLwsRvaDnRwCCWKgwNmjfqv6PE4pXffgw1npmFaBxAXo
        nApm6hb1uZHjHNkfcffsfTBV1IUfnQw=
X-Google-Smtp-Source: AK7set+0KpS/3BByzwJjbMd1b3QtHZYAHcnMMVYpmV87uSLEsvO0MhQ2JYNGmmvhfzDqzH/plWADL3DlLAo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:64c9:0:b0:5a8:17f7:2c1f with SMTP id
 y192-20020a6264c9000000b005a817f72c1fmr992059pfb.9.1676561714138; Thu, 16 Feb
 2023 07:35:14 -0800 (PST)
Date:   Thu, 16 Feb 2023 07:35:12 -0800
In-Reply-To: <CALzav=c06gXZme+t5tE3eFgbeKNO+hjFox=sRyU8oiC3VMB3zw@mail.gmail.com>
Mime-Version: 1.0
References: <20230213212844.3062733-1-dmatlack@google.com> <Y+18f7go7J98XbzR@google.com>
 <CALzav=c06gXZme+t5tE3eFgbeKNO+hjFox=sRyU8oiC3VMB3zw@mail.gmail.com>
Message-ID: <Y+5MH5NPOWCV7+vQ@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Make @tdp_mmu_allowed static
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023, David Matlack wrote:
> On Wed, Feb 15, 2023 at 4:44 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Feb 13, 2023, David Matlack wrote:
> > > Make @tdp_mmu_allowed static since it is only ever used within
> >
> > Doesn't "@" usually refer to function parameters?
> 
> Oh is that the convention? For some reason I assumed it was used when
> referring to any variable.

Yes?  My experience with it is entirely in the context of kernel-doc syntax, where
it's used to document function params and struct field.  Global symbols don't
need additional reference because they are the focus of the comment/documentation.
