Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2881D4EE1AF
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240685AbiCaT3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiCaT3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:29:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B71911E016A
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648754882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UI8qEHAbkpwLvW7bt2Ub22ogltHl59gfjOTw6tTvytQ=;
        b=QuScXhTzdgeHIIzadvz40MMJhZJ0CLv4JxIgbdJDpAt0YcX8cYNLcvINwZce4asLZ6b0L5
        jM9a+5f7mL2nGu1CEcX0y9XrDAmuCWic7MAwZmzJwxdg7uFBp1Nhq50yEPaB9PXsWOt1z/
        y0WAypzO9zrjNR27gEIqHLIdGLeokJM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-syZuncLmO2GXpZwoh0thbg-1; Thu, 31 Mar 2022 15:28:00 -0400
X-MC-Unique: syZuncLmO2GXpZwoh0thbg-1
Received: by mail-lf1-f70.google.com with SMTP id u29-20020ac251dd000000b0044a245bcc1aso177563lfm.7
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UI8qEHAbkpwLvW7bt2Ub22ogltHl59gfjOTw6tTvytQ=;
        b=gMvOiJJudAv7wvTxM/NwHX8X+3fD2cnhyKvtz3SQhAzhsaiJdyDWl60n7gIOFTpAlS
         juYPVk86FYA4uUH33SkgG3sulBQ5Sn2dl3uwIQcIZKTq6PfRMJB/Pd7X8oWQKy/7EpG7
         VT9NVp/3vdnL3phmajgdC7qX7SJcJT8d45CTkp9GP6fFJICksNpOZ+xSIdJPGSHBTEZF
         ZCO7qie3KxFe6oaRGHx/KmRNEaYmNTGTczDhdNUIzqHO2F2m6SWJLzCnqaoyCDIloOPD
         ANO26DTFbS8ROcF+UYWzl98Ua93bKie1gHjhoGpO+PufC+K+acc3NEcU6Pb5285tuwjK
         QbxA==
X-Gm-Message-State: AOAM531yx3lkFDvBm1sMh6tiKBcPaPytD3dh7teAXyoGilBklFxKb2QR
        JPfycxzuVUNhBI6+KWPHH851FXFeNt1WtIePtLnn9q23iNVuIyRv11/nCy8h4+fILGMV2jYPHJT
        3/1b0fKsnXJvZWUqwpV1+mFKA4sdl
X-Received: by 2002:a2e:1546:0:b0:24a:c194:ba39 with SMTP id 6-20020a2e1546000000b0024ac194ba39mr11236994ljv.65.1648754879215;
        Thu, 31 Mar 2022 12:27:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwag+5InsydWAKAYNXSgt39wabMKxHIRvyZYQqUozjzTMie0M2/x5p5RcXPPjKScZOWzCpZnkanZi3QF7SnJuQ=
X-Received: by 2002:a2e:1546:0:b0:24a:c194:ba39 with SMTP id
 6-20020a2e1546000000b0024ac194ba39mr11236988ljv.65.1648754878993; Thu, 31 Mar
 2022 12:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4q7K-pkAbMt3br_7O-Lu2OWyieLfyiju0PNEiy5YdKYzg@mail.gmail.com>
 <CAASaF6yhTpXcWhTyg5VSU6czPPws5+sQ3vR7AWC8xxM7Xm_BGg@mail.gmail.com>
 <YkXv0NoBjLBYBzX8@google.com> <YkX20LtaENdOOYxi@google.com>
In-Reply-To: <YkX20LtaENdOOYxi@google.com>
From:   Jan Stancek <jstancek@redhat.com>
Date:   Thu, 31 Mar 2022 21:27:42 +0200
Message-ID: <CAASaF6xxscL+Zd1dqsykGOEvKwTJ5nDFvv6tOmWN5Mt-GH1QuA@mail.gmail.com>
Subject: Re: RIP: 0010:param_get_bool.cold+0x0/0x2 - LTP read_all_sys - 5.17.0
To:     Sean Christopherson <seanjc@google.com>
Cc:     Bruno Goncalves <bgoncalv@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Li Wang <liwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 8:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 31, 2022, Sean Christopherson wrote:
> > On Wed, Mar 30, 2022, Jan Stancek wrote:
> > > +CC kvm
> > >
> > > Issue seems to be that nx_huge_pages is not initialized (-1) and
> > > attempted to be used as boolean when reading
> > > /sys/module/kvm/parameters/nx_huge_pages
> >
> > Ugh, CONFIG_UBSAN_BOOL=y complains about a bool not being 0 or 1.  What a pain.
>
> Side topic, any idea why your traces don't have the UBSAN output?  I verified

I guess that's because CONFIG_UBSAN_TRAP=y is also set.

# grep UBSAN -r .config
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
CONFIG_UBSAN_TRAP=y
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
CONFIG_UBSAN_BOOL=y
CONFIG_UBSAN_ENUM=y
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set

> that it's not a panic_on_warn thing.  Having the UBSAN output in future bug reports
> would be very helpful.
>
> [   13.150244] ================================================================================
> [   13.150780] UBSAN: invalid-load in kernel/params.c:320:33
> [   13.151192] load of value 255 is not a valid value for type '_Bool'
> [   13.152079] ================================================================================
>

