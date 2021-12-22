Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E54747D834
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 21:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345398AbhLVUPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 15:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbhLVUPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 15:15:37 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7ACC06173F
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 12:15:37 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bp20so7776398lfb.6
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 12:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kg2IAg/CjcdsbtMVjYJaw+Xd6RBeV50zMt05f5cGIus=;
        b=h9iRtgJYSrRAdzsauBtw6VH5R3rdeWM8VHKPsOznvkXMaFPSuE7fJqrzmeCXNb1KJe
         EBOKs+IjLgwnV9of969DT+IEjaC6aoiBoTr66WgdNdz7wmlkKVzlzNA6RgqWj/p6qsaF
         oZa4brQjgwZRuyMs9D5IdkPvWszziDcZXV7mxLbtQ0kwRsJQm7T83Yb8cnFx8ZSbGtZQ
         FTq7uIQe4x2NJeUQ0Jnge+OzJOK4XEfyqOdbxRfsE5/3lCsaUo0wuxTiYzzU3nlXVatI
         KRAWEn0Prwl6KpSdYR1hhXe0pPXHQ9mp7m7LhLCuQ+0yoSExwMvyUJz+COi37aB5h/GV
         9ZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kg2IAg/CjcdsbtMVjYJaw+Xd6RBeV50zMt05f5cGIus=;
        b=W83MG+xp9VbPUA/IazFkglcEfZVBQB72qq/ahlXAl5A7R/4xYY7GabS4hgXXf77jiW
         BR+p35EuMo5z5xB2eHtw7IN0OEPhiwUY4ygJJSshQmeDSx5Ktdog8Kk2YOR1O+vvMAln
         vlOFX4vp5s52z88rldnb7ia9czYK5jEWXnhPG62FJdpdpNmWdgK8AgflugHW5v2R6XQZ
         6/NtSRFMrjV0RHmHEC9Puq8/6ZDUnBsOE3wQ5yxt7K2MFCmnPprRjWz1KLx6ZJgCVwh8
         lmn7t5pNn/HvX93Iqn/F3Do5fqL0jjD5o+X0vddmKeNstT3FZLpnf1Q7tH0iHl4RfoRz
         9tkQ==
X-Gm-Message-State: AOAM532CXDayN7rt2XPmhuaDXObGqRmumZADD5ALpzewpdlc1aYNai/3
        zZtTsnqygvhDf7gsrxqsvGRH3O2+01zp/3HwLGYh9A==
X-Google-Smtp-Source: ABdhPJyC+u8WRM0bOZNPMvJ++NmTfvPYfPT3kuEBqCeAY1BtqpBJh36SHPzkW61SYWmwM8zBd47NIOlA8/5LsJLHhwE=
X-Received: by 2002:ac2:52a3:: with SMTP id r3mr3501411lfm.580.1640204135378;
 Wed, 22 Dec 2021 12:15:35 -0800 (PST)
MIME-Version: 1.0
References: <20211214050708.4040200-1-vipinsh@google.com> <CAJhGHyDJ8XG6ZCC-NoATFgyeuyEq_A7zmF4TSFA5ubONv7Mx1g@mail.gmail.com>
In-Reply-To: <CAJhGHyDJ8XG6ZCC-NoATFgyeuyEq_A7zmF4TSFA5ubONv7Mx1g@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 22 Dec 2021 12:14:59 -0800
Message-ID: <CAHVum0cTEcSSNNJNKQEMEW=a11hay_VJMCzJ-7LRu81qBJZ22g@mail.gmail.com>
Subject: Re: [PATCH] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021 at 8:14 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> Hello
>
> Off-topic, can this kvm worker_thread and the thread to do async pagefault
> be possibly changed to use something like io_uring's IOWQ (fs/io-wq.c)
> created by create_io_thread()?
>
> So that every resource the threads used are credited to the process
> of the vm.
>

Sorry, I am not very familiar with it. Maybe someone from the
community knows better about this.
