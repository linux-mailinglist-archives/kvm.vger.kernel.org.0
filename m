Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0029CA223A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfH2R2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 13:28:24 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40030 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfH2R2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 13:28:23 -0400
Received: by mail-io1-f65.google.com with SMTP id t6so8486584ios.7
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 10:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o689EmO8aKfK+1gCqs5i9iAjNnZoS76K3rmvLbdspcY=;
        b=RuaW8xOmkeFJ/gPUm3s7Imt9+4IBI+H0wLSqEAtmwZccZWigN3qni3KEqfqiiqjakc
         86iFyvfy8jPdSg1fJZBUEGdZlukwUzdjs7Iq65jSXQvtsjwmfEovu13pRiq2T3eCiS+O
         2azT7aLR/RSqGrvpIbwFBKUfxpAZBCQyEcdbS80+53eA56TThs8dNewJRZh9af/1Wmsu
         HUugVnI4KKRzpdsXntc3HQKD/QRASmbA9IgA6pebl6kGAR/EB5CerI1H498MP+ypxEc/
         7T+NrdsnZYNoLGoa1P5jkXKweg+GiEO1+R9HmZ6E8Z47j+5NbHT7LH92qM7FZd7C4Glp
         ffow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o689EmO8aKfK+1gCqs5i9iAjNnZoS76K3rmvLbdspcY=;
        b=H9pToCgcZZZiVEageIOt8Dd4b8VY3DNNKELe066FYm7qJeXbwUsN+W/CkoyNi1moL0
         O3VHECkRXK3zglygjbr9oCP2xx4WwPHQxTlHHYpIow41DPOc9/3M3YsHIjZ9CEJQ6fsV
         OE2CgnJemEfiXDharE/K+ZUNetVa0UDHgaYa/+kR4oRb8wqDhtcOU0oPVmWFRpgdja5/
         YNCEX9CdZEizrpJHr/cj/uiLzq8ISSczDkfJ9N9LkuI5/DyoPNnVwQlrNNYyLhE9IoWt
         CighyxZknj/kT5K+dVED7t08xHlkbHyZ36ofKNIbbBEuhglJuTpqw5xL8e8rdli0WpRv
         YmlQ==
X-Gm-Message-State: APjAAAUA2NVV33aVl1GyjV9d6kGNoAryUV7HKYiD2csE2qP0F/CyfyhK
        CEyifK28lVsWDmok/bTh78JtAp4YmhXoULhKKKiQPRqSQMw=
X-Google-Smtp-Source: APXvYqxOt/jRa8kgHlziWDR2Cox071CoBZ17d16UGZFvrMm5VYLbqkqoTUQ4MX9HTMf5Ibbhb6mOyOkb/k3zvpzwix4=
X-Received: by 2002:a05:6638:348:: with SMTP id x8mr11823177jap.31.1567099702498;
 Thu, 29 Aug 2019 10:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com> <20190828234134.132704-7-oupton@google.com>
In-Reply-To: <20190828234134.132704-7-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 10:28:11 -0700
Message-ID: <CALMp9eStyUUtzNqs6Fxcr6aQcSJvvXQzNPrrGJy7N+To=nrz=Q@mail.gmail.com>
Subject: Re: [PATCH 6/7] KVM: nVMX: Enable load IA32_PERF_GLOBAL_CTRL vm
 control if supported
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
> The "load IA32_PERF_GLOBAL_CTRL" high bit for VM-entry and VM-exit should only
> be set and made available to the guest iff IA32_PERF_GLOBAL_CTRL is a valid
> MSR. Otherwise, the high bit should be cleared.
>
> Creating a new helper function in vmx.c to allow the pmu_refresh code to
> update the VM-entry and VM-exit controls. This was done instead of
> adding to 'nested_vmx_entry_exit_ctls_update' as the PMU isn't yet
> initialized with its values at the time it is called, causing the
> 'is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)' check to fail
> unconditionally.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

One thing that's clear from this change (though it's not anything new)
is that KVM_SET_CPUID should be called before KVM_SET_MSRS, or
unexpected things might happen. Perhaps it's worth adding a note to
api.txt?
