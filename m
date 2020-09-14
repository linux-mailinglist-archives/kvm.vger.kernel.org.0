Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD670268534
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 08:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgING5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 02:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgING5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 02:57:09 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2F4C06174A;
        Sun, 13 Sep 2020 23:57:08 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h17so13974146otr.1;
        Sun, 13 Sep 2020 23:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M3lztHJyBuAkCA+eiG2skA0kVPp/UdnzOX3/EVQJ58M=;
        b=c2eeTVMqM6vwsjE4/Y+k756O2OHzXBtbHmd5vYI//w4CLJZNFUkz8lVfV3xQ1bEE34
         FJ8JWGiROaUIKI+/h72MGlLjda1nINgvtpkmgxUVWulRHvP33VRQBljFsYIqdwfBGc9A
         HlY7j+sOYdFlRFRuG4i92kBMsy4oyGVcKcmH9diiROwBqM/bj2DQQMuYKUw6ZWWXr3VG
         KTxJRA/ODSsBp9+A4gKUSef78+TDlHUMJ37RpbVcruRZ8mbprz9hptoWzLKQrBl4nflC
         CU05PnEfIEGwyNTKnQ2YdDXB2rxlVkyqQAwmjEcVWU3kybFoTOAftDnc9ClE6dbyeCiw
         syvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M3lztHJyBuAkCA+eiG2skA0kVPp/UdnzOX3/EVQJ58M=;
        b=R6kWJioILCQc1glGU+tEGYfbEYmGgQWgqLa05GvrejxHdT2llrjwY3/mf3PzvWh2Bb
         16D7DFOpPm+AyAOwDiXvWvZtr5Fo07z5TK21i5FHff6J2sYc4z6Xq6FeQABSroJt9FNB
         cBnN1BIAZHio+9fQVfF5l0Jy8X0bUzk9Hma11Qd7IV92FIES7hx1G39ZTg6+KwH3yKwO
         EjFwx2L0/0Zv8OZoiBjfuMrfy0IWarzObiQUlHzX6dxJNC4K5KFcTCuk9V3WA928lO13
         4tp7yepCvEvF8q8tu/VSsnvZ4ijeJL3OobsIbAmrbjcy6BlT4nIYi5Fz0A6gx1dnkOi5
         8P7Q==
X-Gm-Message-State: AOAM5338aLI5Aeanj/P5vqdny1FwKgo0KGXbJKJlFCfL/OWXcTieylaY
        VNfCJrbQMgpQLJ6/HzzfL8yhuyZsTidX1zhDSq4=
X-Google-Smtp-Source: ABdhPJx7izQYe3ulaf66DbqL4RgbNwxFT0b8i8vijkzANZ//Spy5qiJy/X8DQUwQ+hrM7VGTmFoa3Um0hDB6WUq3glY=
X-Received: by 2002:a05:6830:10c4:: with SMTP id z4mr7613377oto.254.1600066623740;
 Sun, 13 Sep 2020 23:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <1599620119-12971-1-git-send-email-wanpengli@tencent.com>
 <87eenbmjo4.fsf@vitty.brq.redhat.com> <CANRm+CxR=U1jYMsqGEUOJ+G6ekUs3igZxzNzrepHp17QYrcEnw@mail.gmail.com>
 <a9ae6d3d-e616-58c5-5db5-149fb702631f@redhat.com>
In-Reply-To: <a9ae6d3d-e616-58c5-5db5-149fb702631f@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 14 Sep 2020 14:56:52 +0800
Message-ID: <CANRm+Cz4hGibCuJLrhgBgnbVYKYXOsV4=qdZvmyJvY4DfxT06A@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 12 Sep 2020 at 14:20, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/09/20 10:47, Wanpeng Li wrote:
> >> One more thing:
> >>
> >> VMX version does
> >>
> >>         vmx_complete_interrupts(vmx);
> >>         if (is_guest_mode(vcpu))
> >>                 return EXIT_FASTPATH_NONE;
> >>
> >> and on SVM we analyze is_guest_mode() inside
> >> svm_exit_handlers_fastpath() - should we also change that for
> >> conformity?
> >
> > Agreed, will do in v2.
>
> Please just send an incremental patch.  Thanks!

Just sent out a patch to do it. :)

    Wanpeng
