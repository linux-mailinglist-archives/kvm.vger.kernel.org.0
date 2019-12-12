Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1B911D9BF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 00:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbfLLXAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 18:00:05 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44039 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731292AbfLLXAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 18:00:05 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so385942iof.11
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 15:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCJ7ZxXwgS+9RY8KtPwmKt5PjyIuKpAMa6t5nExF4bM=;
        b=i1J+z884+fGFa6WTQnFBApLNkqaOJHgfuKSBy1BswUEEEHDqHoOXylv4GjIJh6Hez1
         E+PAXIZa6XBY/JFobaMlZ3wpmWkkpLvuiCD3M8F8GIflw5CJQ7LEDV+AcWW67LUM2GDf
         J6iKE2iTTiTaeREl40sOhVypc2eQhIWhF6uYllXjLiSM5Mc0PRIbf4qYOHVBCSKfF8ez
         lQfroElIgIMWVTRomYXOSG4MoudsNcXKqPyu1YumzS76f8u1Y4IsD1FHIZ1zsEoAYfbT
         1O+4mkAhu2iiZoUz7sA1eNEDKK0pN1Ix6HQNqyCww901iCRBwuP3PqJ2NnPAR7Yo0dpC
         fWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCJ7ZxXwgS+9RY8KtPwmKt5PjyIuKpAMa6t5nExF4bM=;
        b=N2SFsGpqSVcOFDRkN30+irG5f+JEQ3nTRvEjjTPUMxcDWBj8n8p5vA0RbpeNkqO2JE
         TiAA5KUP6zQLiBoUt4GzhcprHB9rtAFZjm4STA2DlR/AvK33POi1kFKR2ZVsevsE397w
         8+EHD2PGsrw7QyMunHqUs87AkF887GHuKK/TDrh/U/aTABKQNPTGkeSiijxLNIMBoO8b
         kksqlvP8+Tnz23L670Gx/Pbo4y/L5tuvNIwVp5t2rcxxj9Y0e4Qv47gFMlXt1EwGkPJ+
         WeSi+pAz9GqsPu/yZqDKbDGfe2abXsvaXFlnApRpOVCl8ad42Iq8Lz5fkjesQ+/T8JJX
         6JcA==
X-Gm-Message-State: APjAAAXSx9YOdcrgWDkKXKUitciyPdGQPOgFLPVtIMvauBR0PyvehxjA
        RjphJEuz8vEkzBNr4kAu4DZbm6hZoFd3wRzm3zoaJA==
X-Google-Smtp-Source: APXvYqz02KVp5fnxaK/aDgjS37Ek6f+VytNKRRKi7353A7sSlXWkmigB3XcSDJYl/k12aofFSaWKz15KOp/lnxAgOuk=
X-Received: by 2002:a5e:9b15:: with SMTP id j21mr4909632iok.108.1576191604631;
 Thu, 12 Dec 2019 15:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20190518163743.5396-1-nadav.amit@gmail.com>
In-Reply-To: <20190518163743.5396-1-nadav.amit@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Dec 2019 14:59:53 -0800
Message-ID: <CALMp9eQOKX6m0ih6bH5Oyqq5hFbSs7vn0MAZXka3RcOCrC+sUg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index check
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 18, 2019 at 4:58 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> The test that checks the maximum VMCS field encoding does not probe all
> possible VMCS fields. As a result it might fail since the actual
> IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected value.
>
> Change the test to check that the maximum of the supported probed
> VMCS fields is lower/equal than the actual reported
> IA32_VMX_VMCS_ENUM.MAX_INDEX.

Wouldn't it be better to probe all possible VMCS fields and keep the
test for equality?
