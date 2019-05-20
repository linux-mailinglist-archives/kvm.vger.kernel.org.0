Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24DC2325B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfETL3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:29:10 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37011 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732780AbfETL3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:29:10 -0400
Received: by mail-oi1-f196.google.com with SMTP id f4so9697838oib.4;
        Mon, 20 May 2019 04:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onzwvJLUNwe0tWvgSEunaBZym2f6MEvnymYOXu8PZTc=;
        b=XPSutS1fgOBzduwfcEdvoMGN7eiR5RjYzCc3yVB6O62+sh9qZtnHqPbKK7C7w2Qfsm
         YHZN8gE9DvpmyRlGYqfyIrR/5vi2eWgYBYLnOCfOmnTX9k/DDu4ZikWREC+ooX7R4foK
         rNPfpqatFV2CnZwzyYsPe6Ekhv0U+9jYsINQBP3tuCIuWcvK2kv9R9Bhg4nDzy39cEIA
         ZMSw+SuOr5X1LCquO7l1HDanelknIXzGmCw2c6dLp7uhguE0SrTOUV544f8o1+JssRXT
         KIV184MzsSyVUUAdrpqS4o7AbUTpyfD3B5aS73454ajKJQROcYHyMbkD1ogvAx5ACZcs
         hLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onzwvJLUNwe0tWvgSEunaBZym2f6MEvnymYOXu8PZTc=;
        b=DhFsXWnyWKYGTaATPecwpRx+FJ2uix5srA4UrwbyXo63jtg0z3B6YciC95wp46lL9y
         eh6201jVX5gO4OjUhC9vfBMMbMMuB6U4TDTsaS+qUqpo2TNlyQZ9FHIUQoSUM1Dcy5cc
         aikaZwGm9gp0qWMx5HkgNgH1/zC6jkvg0Pm6qPRusPp58sGJezDJCqW3xT6SSCwRcYEf
         RBkXQLCkIyDbbqbEYJO/gEXSsfD2NCN8AIC+NcNRcH3pd5p6eyX0IVgSOJjD93N5emYq
         3ZAnF/HNqv5Sk0Li21YGwoRZmPOq1biBU1dlnuQGBWwp2vqaznHLft0vz55UlTyh48bh
         ALAA==
X-Gm-Message-State: APjAAAV/8W092Pp0YkUtT2odDKPHdsKIllpHONOGB5NBuXRUZ4N3oICl
        6ophnbwU0dxuxeiiylrpOaNX4jVD+rP1q7tBUvs=
X-Google-Smtp-Source: APXvYqzRcUfDaCOUplEFInlgfcgHnuVtZ0nlftSWZkfKmix84/CuuE3Z5iycSFo+aSpCZHC962yEJJ1dj0SQSMHVSU8=
X-Received: by 2002:aca:bf83:: with SMTP id p125mr22591298oif.47.1558351750026;
 Mon, 20 May 2019 04:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com> <7787e0cb-2c46-b5b5-94ea-72c061ea0235@redhat.com>
In-Reply-To: <7787e0cb-2c46-b5b5-94ea-72c061ea0235@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 20 May 2019 19:29:01 +0800
Message-ID: <CANRm+CzD1Sc5bYk9B7yzfXnWkUZwB3cr_86a9x3h9W0ROEoksQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: x86: Disable intercept for CORE cstate read
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 at 18:30, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/05/19 10:49, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Allow guest reads CORE cstate when exposing host CPU power management capabilities
> > to the guest. PKG cstate is restricted to avoid a guest to get the whole package
> > information in multi-tenant scenario.
>
> Hmm, I am not sure about this.  I can see why it can be useful to run
> turbostat in the guest, but is it a good idea to share it with the

Yeah.

> guest, since it counts from machine reset rather than from VM reset?

I also saw amazon expose these in their nitro c5 instance.

>
> Maybe it could use a separate bit for KVM_CAP_X86_DISABLE_EXITS?

It could be.

Regards,
Wanpeng Li
