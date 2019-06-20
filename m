Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6241F4D9BB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfFTStX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:49:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35726 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfFTStX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:49:23 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so28920ioo.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 11:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81FbK2MGDTB2Q0Lt6NRfym4JTD/ft6H2LYFu0+BpVcc=;
        b=DflsZjsCnlZp08kXiOJJ6An2xdgV238TPGSiu9uyyUsm9OkUN9/kKo8e1beLAXMUbS
         qYuVZwvv6dE53Bwjs0e/+mlKTcc4RWSX9KTRRYn7tsr6nz4atgpQDZIU1e7F3pQscX7V
         xeY02wHBTNOq5EPowL5/HcAv8R6jLa6CCxKMQJ+/h4GXoyINhupnIQvG2/ZKFFPKAo6E
         uiKgoJD2/9di1J8WllMZyF1MLZ0ycEF9Q/mch1G52EvvfcJIhzDnzc6lLgffnA53jaAS
         +ZoRG4bMQrNjoDucqSIPk6YNxGNuNctcvOf5l1pnh9ikc514sEfEv/sRTm7MHgbcUXgk
         ZoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81FbK2MGDTB2Q0Lt6NRfym4JTD/ft6H2LYFu0+BpVcc=;
        b=IUOV+cdo4FUnMLiGqoSQB838lWTfdW4cRNyyJZjmEzVvO+3LDFrBHTzC05uuGYRAuz
         EQiBISZWA+2a42gwbIvxzvRhaAtm3UMvroPVhMuafxsKx7lIKqS1x6lc8TZvlTW3w0ow
         H2EghhE7z2bwtHbH5XGZWSpf+Gj5n9ZSYJDuVXR3oqEevguTNqCbUQwIHLKuu7taG4h8
         VZq+x2Zsq6UIgGxp/4n2o05w+5jRi/tdL7Ikvpo5Ief8xwJwg5Lyxy9/Eq52ITGYoukH
         pQbyA63cEl8nyGzCLDK/9O1+WADqSFxlQTPAQJ4/+lxK8cEmWGuIwijlCXISAEWtPyfl
         joMQ==
X-Gm-Message-State: APjAAAV7DRMXQ8jGqNPWhPZb73FlBCwgmwQJNJ6lyi5JWo0XJ3nv1fEh
        9PNYtfsI4GKMOD//5Nbd73gHdScLCeaaWVcXIRZ5uC3/5vkQmg==
X-Google-Smtp-Source: APXvYqw3T+wT6RqXErOCAGICJIb6qphtc1KJTX8sfmv5CUYrd3Eq+yqn3DloJYm0LiXeiKSznCHZUlDvmeyAD1VHIhA=
X-Received: by 2002:a6b:b40b:: with SMTP id d11mr10574591iof.122.1561056562075;
 Thu, 20 Jun 2019 11:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-2-vkuznets@redhat.com>
In-Reply-To: <20190620110240.25799-2-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Jun 2019 11:49:11 -0700
Message-ID: <CALMp9eTZSWA-7SOHS=2xrMKaXv_imKpURHGcDpfgusF+JDXFMg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/5] x86: KVM: svm: don't pretend to advance RIP in
 case wrmsr_interception() results in #GP
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> svm->next_rip is only used by skip_emulated_instruction() and in case
> kvm_set_msr() fails we rightfully don't do that. Move svm->next_rip
> advancement to 'else' branch to avoid creating false impression that
> it's always advanced.
>
> By the way, rdmsr_interception() has it right already.

I think I actually prefer the current placement, because this allows
the code that's common to both kvm-amd.ko and kvm-intel.ko to be
hoisted into the vendor-agnostic kvm module. Also, this hard-coded '2'
should be going away, right?
