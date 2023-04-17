Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C986E4E9B
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDQQv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 12:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDQQv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 12:51:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7D77AB9
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:51:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54ee12aa4b5so236946517b3.4
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681750313; x=1684342313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPGXtfoj8zWfrxnDm8mfNpTrHIS3T28NNHxcP0q+UvU=;
        b=fHPvgnEZ9Q20W163j2WeKhNLShLbrOCT756OhTAsT7XfjoUgvtomSsUpCGjDP2jzKt
         zJPjwyFsFZfWNtkXYd/+JgC17JTwMEJsrxsN/pUJ+kRta3Bcm+RkPVGiNlSHDx7xFxAR
         zqUjOzHidTSeHcSGw/qu4K+dwuH58vO6kfrCts0GQ7AMEE5xgUlg4JUlItGyTyGDaGad
         odbrhY2zgcepvi2XnmxdpNr5lITeZ/NPbmyyLpDxvhxeaBP4fBk2nQA/YdNocWQ7TWdk
         iE3n/LVcWOyPbX6Abiw5jMyZS9uTUtkYXvFNuGx3mrODqW27jzEszuAzRgpAv+9s6n7H
         EA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681750313; x=1684342313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xPGXtfoj8zWfrxnDm8mfNpTrHIS3T28NNHxcP0q+UvU=;
        b=iSIyrYkJeGCGTu1mAIsPhshQ5FWI6CKnNcBuyzwQG1dqEF60hNrQanMq5wL9w9Rz23
         XaanzKqDiezXRC/+U4gArBaomrJsaMW8i6rnIFXDKodp8WzBRXikNvFvFJyV+W0xaPkg
         2wLozwz0bAYay8HrbHcDX4BSd++xrbO9WqFxg8kuTDg6kPwiH5nQ3DEx5j96T4h1hB2Y
         +ch407WsgmXkjPtl51hCFln8E+lnZr6VDyVoYql2RWXLzxFJICtyK9jGhr/pJFOxHd4l
         1WC/ECBgjOEVSYHerdnS8FprqzwjFp7x2kXSSGf6+37N+ftcNQ6S4QBIEVHD5gpZlgcx
         uJeQ==
X-Gm-Message-State: AAQBX9ce0IoJ2pEeD/Yy44BCEZj+gbKvFdbwWZaUE4eR3jfPchNGT6Q0
        Umf4iMcVNTxIbbwFcjqEJfES9h0a8ug=
X-Google-Smtp-Source: AKy350ZrfKImkrnKZQlURSg7UI6PwCvqyet7zKKn2r62aQROPOQaP8MBSBy9i/kch4Xb/n5OAMaqLBYeXEs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e503:0:b0:54f:40fe:10cc with SMTP id
 s3-20020a81e503000000b0054f40fe10ccmr9678583ywl.9.1681750313800; Mon, 17 Apr
 2023 09:51:53 -0700 (PDT)
Date:   Mon, 17 Apr 2023 09:51:52 -0700
In-Reply-To: <20230415033012.3826437-1-alexjlzheng@tencent.com>
Mime-Version: 1.0
References: <ZDmSWIEOTYo3qHf7@google.com> <20230415033012.3826437-1-alexjlzheng@tencent.com>
Message-ID: <ZD15KFZO9J33Eodj@google.com>
Subject: Re: [PATCH v2] KVM: x86: Fix poll command
From:   Sean Christopherson <seanjc@google.com>
To:     alexjlzheng@gmail.com
Cc:     alexjlzheng@tencent.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 15, 2023, alexjlzheng@gmail.com wrote:
> On Fri, 14 Apr 2023, Sean Christopherson <seanjc@google.com> wrote:
> > On Thu, Apr 13, 2023, alexjlzheng@gmail.com wrote:
> > > Fix the implementation of pic_poll_read():
> > > 1. Set Bit 7 when there is an interrupt
> > > 2. Return 0 when there is no interrupt
> > 
> > I don't think #2 is justified.  The spec says:
> > 
> >   The interrupt requests are ordered in priority from 0 through 7 (0 highest).
> 
> This is only true when don't use rotation for priority or just reset the 8259a.
> It's prossible to change priorities, i.e. Specific Rotation Mode or Automatic
> Rotation Mode.
> 
> > 
> > I.e. the current code enumerates the _lowest_ priority when there is no interrupt,
> > which seems more correct than reporting the highest priority possible.
> 
> The practice and interpretation of returning to the lowest priority interrupt
> when there are no active interrupts in the PIC doesn't seem reasonable, as far as I
> understand. For #2, in my opinion, the correct interpretation of the current code
> may be that a spurious interrupt is returned(IRQ 7 is used for that according to
> the 8259 hardware manual).
> 
> For #2, the main purpose of returning 0 is to set Bit 7 of the return value to 0
> to indicate that there is no interrupt.

Is there an actual real world chunk of guest code that is broken by KVM's behavior
for the "no interrupt" case?  Because if not, my strong preference is to leave the
code as-is.

I have no objection to setting bit 7 when there is an interrupt, as that behavior
is explicitly called out and KVM is clearly in the wrong.

But for the "no interrupt" case, there are a lot of "mays" and "seems" in both of
our responses, i.e. it's not obvious that the current code is outright wrong, nor
that it is correct either.  Given the lack of clarity, unless there's a guest that's
actually broken by KVM's current implementation, I see no benefit to changing KVM's
behavior, only the potential for breaking existing KVM guests.

And if the "no interrupt" case really does need to be fixed, please split it to
a separate patch.
