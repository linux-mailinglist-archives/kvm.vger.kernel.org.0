Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FF7A21AC
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 19:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfH2RDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 13:03:00 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34826 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbfH2RDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 13:03:00 -0400
Received: by mail-io1-f68.google.com with SMTP id b10so8415512ioj.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 10:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwPL6xoGHGxOsB7Q95Jm62SElJ5e0zCDnAP1cyrY2Q8=;
        b=cfqlNNjbBAYqytfMW2bkgmz3EoIB2N/MnOcO3cXyF3Ledyxe4fzU1UHZnML9RWEmbc
         URBHj3ZdiP47LfFivZfWs2X6ZgHKvGYMzrdhrGInEeIw8AJPgZ3BFsLWqWYlHHDYprmC
         7d4kAk3uUV8Kc40i/8ddkSiHWtLq30VwporU8cZnJN58TAUm8HXnFeiLdOXMdhEr3Blg
         FXT5/1EGzzAWqm/4iOMjgowSH31Cf1tRyxaQ2RPgMLADwkxyuXORnY9u/4p9dcZ3nMAk
         VZsqo7tViO5JN3oC5YzFXNP9mkATJMSESO4dmJxkdSqO8rpiZBxRPXcIdvyOS491nqlh
         nung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwPL6xoGHGxOsB7Q95Jm62SElJ5e0zCDnAP1cyrY2Q8=;
        b=kO9jmrgcuN1L1u6GefVinPqXtqGb1dlcOu5odODuRf/YnqDxH6ZLizYpzo1shAM8+P
         VJt98KMCdoADNSD8ZidDxtfislwksbPUKRxWM8WseivONCYmGkkTHHbaMES8x1GHsaWS
         RlSp19EozoTv07eNibMwIESa65pzYvlACjEkdu2bDba2tQdCQodWNIoDMar1mFE81UiN
         vtGliYUnDSTbcASNwUg5BjNag761iFNXuSAMuPHj4W4S6+mZeRSstVugrl8y7sn2rYnK
         vOs6SKybU8WwOXKPBrrUDYnVMG0j06BpLG+ewx0t+dtcFcBY5tkzC0hmYH7RHReFR6L5
         vaTQ==
X-Gm-Message-State: APjAAAVTyixIeiu9FQ1H1OotTbbrL194O507/KL4t9kVftervQvmFPk2
        bEfu+y79B59DrLKfFLH9eU3USIfsn2PA6KjY4giKAQ==
X-Google-Smtp-Source: APXvYqxIBM3+kyjmmZTsqTpXgcwIxXLP7QRnVcGeFBJ102YvAraSEQjT2wcNZoYRNZlzBV41ytYlUo3LaFRrmUWIHsw=
X-Received: by 2002:a6b:5116:: with SMTP id f22mr106380iob.108.1567098179502;
 Thu, 29 Aug 2019 10:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com> <20190828234134.132704-2-oupton@google.com>
In-Reply-To: <20190828234134.132704-2-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 10:02:48 -0700
Message-ID: <CALMp9eRbvKp-OkLWfCHbiRKY4Nf6u+UAzmX=WRwhzXU0JQN0vA@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: nVMX: Use kvm_set_msr to load
 IA32_PERF_GLOBAL_CTRL on vmexit
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 4:41 PM Oliver Upton <oupton@google.com> wrote:
>
> The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
> on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
> could cause this value to be overwritten. Instead, call kvm_set_msr()
> which will allow atomic_switch_perf_msrs() to correctly set the values.

Also, as Sean pointed out, kvm needs to negotiate its usage of the
performance counters with the Linux perf subsystem. Going through
kvm_set_msr is the correct way to do that. Setting the hardware MSR
directly (going behind the back of the perf subsystem) is not allowed.

[My apologies for the double mail some of you will receive.]
