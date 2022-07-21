Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3DA57C7E8
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiGUJnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiGUJnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:43:33 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC81880F6C;
        Thu, 21 Jul 2022 02:43:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u5so1454246wrm.4;
        Thu, 21 Jul 2022 02:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIAx8IOYG+ZSZkE6NQmk+nGqyL9Rc9OjhPo6OZTKiOQ=;
        b=Rg2CnC9S5k5h+qaWOGDFhJ4t9LVz2iHoD3pVZuPdtwah798amJ/pu0aOPrgPEKULOn
         37GjMRDhMGorH/g/eBI9yzu7DoUXUYw2FoQD+jHn8HunXpUp4sskcRRCbI3WGDeOtGef
         poylSkG3lzK4CSSH24iP9IBIyTMOciV//tm2zO/SDHqYoNxSRLp+3Siza0HlsLPX83q7
         lgBjjC30gIcOT5ivwldQXbRhcFolMu4ssSQItRimTH3Hb2INjWir30xfeI5Xl56X6RRv
         lblOOqFWnFiEuBnLkEmU4hDMe3wLowaJBA4Oedm+J7GtTaWWkx3jWj+gD++ATsJNlw9z
         ZMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIAx8IOYG+ZSZkE6NQmk+nGqyL9Rc9OjhPo6OZTKiOQ=;
        b=fjLSlbcLuHHr7ZxgDC9P92EDu9hrOP0fYjj3W/aIMgXLEDRBR+3YqxqTHbDcdM216x
         AIeULZ/V/65RWz0lvsdGRp94S4jWBHCwGkFRUfwAulCEYKAtU7f0Cx4GfKvgYURhQfcp
         npeotUDDO0zFNSRtpk8iZZTMYfQDy4Bc4maPLcnTfl3WaMoHTDUiqlgTADkY0priRD3Z
         uW8vioWxZfwB4hzPL/9M3c3yiR3RewvRLEOjqtAilUNIfHl43NARFHS2fUHEDhVnNhGM
         OW4y0vvkAd/uCQtz89xmz/Mb+xaZJ9CL/OurFonA2ZRNAmLhiPE1fjcnAF6SfMaLU11p
         4qWQ==
X-Gm-Message-State: AJIora+4ROlorfNgYPBieOp2jsclo4fZqeputwVPc2l4+q2xthvBhZKr
        LDnLsfmC8syXG5lLpp8ptb4fq1HV8vmwCewu0Ensomac3LY=
X-Google-Smtp-Source: AGRyM1uILqimEasuk5GZJTKIV7K2wFwZ10DKBDXlsSdpXXIwMi7EE9u7sR8An7mBaIfye1ZP8+egC+AFe5phT0oSFaw=
X-Received: by 2002:a05:6000:2cb:b0:21d:7760:778c with SMTP id
 o11-20020a05600002cb00b0021d7760778cmr35033252wry.329.1658396611355; Thu, 21
 Jul 2022 02:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-8-jiangshanlai@gmail.com> <YtcQ1GuTAttXaUk+@google.com>
In-Reply-To: <YtcQ1GuTAttXaUk+@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 21 Jul 2022 17:43:20 +0800
Message-ID: <CAJhGHyB=-bGrguLKtTh+EAr5zr--H97HUgR3WP=JTovQLkoevQ@mail.gmail.com>
Subject: Re: [PATCH 07/12] KVM: X86/MMU: Remove the useless struct mmu_page_path
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
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

On Wed, Jul 20, 2022 at 4:15 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Nit, s/useless/now-unused, or "no longer used".  I associate "useless" in shortlogs
> as "this <xyz> is pointless and always has been pointless", whereas "now-unused"
> is likely to be interpreted as "remove <xyz> as it's no longer used after recent
> changes".
>
> Alternatively, can this patch be squashed with the patch that removes
> mmu_pages_clear_parents()?  Yeah, it'll be a (much?) larger patch, but leaving
> dead code behind is arguably worse.

Defined by the C-language and the machine, struct mmu_page_path is used
in for_each_sp() and the data is set and updated every iteration.

It is not really dead code.

Defined by the sematic that we want, gathering unsync pages,
we don't need struct mmu_page_path, since the struct is not used
by "someone reading it".

>
> On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > struct mmu_page_path is set and updated but never used since
> > mmu_pages_clear_parents() is removed.
> >
> > Remove it.
> >
> > Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > ---
