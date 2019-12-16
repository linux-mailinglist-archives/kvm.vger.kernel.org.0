Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF211211FF
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 18:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfLPRnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 12:43:33 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41218 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfLPRnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 12:43:33 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so7868847ioo.8
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 09:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKv1p/pEYfBtWBudqB+SSQzQVWvAibCFBVJQpX9fd4I=;
        b=UMD10dTuSt3UX2gc8T2J62G0qBPCKPqe+ZPH1IzUI1axj64NzCCitYixAZ3HlYkEQl
         zyoRcVn6DdDaBBVG3XqwArJPvATzuAPWMYVxeXsN8B8HVNx6i0PMTikXOZPkaaVc+35t
         nnN6Wv7myUHRBkH1sR9CjZ6nzontW/49+qDnX3/94lOI7+rg7WQVdqZxRg0Dfo9QHCbk
         Hno8tgRiVgTWotoFjBdU9FohOZ50LV/YKkidDLu3Y7jza0MEwd6DQf36Bn+f4gF+TcFx
         WM5Z2GFVrHgimrijFN7c4jfcJwg1NJ5c4kJLgPSENF1BvInpchlD39Sk4zCxM3ql6Wd+
         cjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKv1p/pEYfBtWBudqB+SSQzQVWvAibCFBVJQpX9fd4I=;
        b=ad+hWegxZNkGjBG6xb+tF+fihZvro/crNMk3dmAiYqrb8wZqmQgXOfulG+Lvf6qXRw
         DGv1ata373Np/45Qw+iAXklqdq6jsaUcZBtoXZIa2wzdWR6yCrO1CgxiVQTHxQNTfXr6
         VtQtlPqo/jtMGnyj6t2O3FCYy3Rl/vW330Lxc+3EEVgxyPfF+wC4QJfngsqhCbFs0l24
         DhTkz3kKhi8smjFAWbN2zN4sGaVAwrM/bVjasj5AqBtfmiw10nvSwqW1+Zwkr2TeDuVf
         fUv6NQ5p49/P+2Zz8g62JhTOiK7xtz7bAR1atYPmdrre4GwShw7vI+QGDsXMYo5lhlbN
         Gw/Q==
X-Gm-Message-State: APjAAAVGZb7gnVGzvNl4qfcUGeX8vmbG1IEcz7MbmMCWXpE6KG+ZddFu
        Hqg2s/kgvEFThSadB+50+T5eKh3wFjsF9ahrqTGw3g==
X-Google-Smtp-Source: APXvYqzO32fKgFCS4VBa2gtmywPj84cL2jpDJsoaCHEFzKHvNLV+bgmAj0ozMIkDbBcgzuS2ziT6uQp7+ARlGMxpH+U=
X-Received: by 2002:a5d:9953:: with SMTP id v19mr186528ios.118.1576518212072;
 Mon, 16 Dec 2019 09:43:32 -0800 (PST)
MIME-Version: 1.0
References: <20191214002014.144430-1-jmattson@google.com> <81C338F8-851B-471C-8707-646283167D57@oracle.com>
In-Reply-To: <81C338F8-851B-471C-8707-646283167D57@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 16 Dec 2019 09:43:21 -0800
Message-ID: <CALMp9eTQf-htu-6R=VM+r8VmeBPwrVZArJaU6MnGD2m3hn+6jQ@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 5:10 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 14 Dec 2019, at 2:20, Jim Mattson <jmattson@google.com> wrote:
> >
> > More often than not, a failed VM-entry in a production environment is
> > the result of a defective CPU (at least, insofar as Intel x86 is
> > concerned). To aid in identifying the bad hardware, add the logical
> > CPU to the information provided to userspace on a KVM exit with reason
> > KVM_EXIT_FAIL_ENTRY. The presence of this additional information is
> > indicated by a new capability, KVM_CAP_FAILED_ENTRY_CPU.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> BTW, one could argue that receiving an unexpected exit-reason (i.e. KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON)
> could also only occur in production either from a KVM bug or from a defective CPU. Similar to failed VM-entry.
> Should we add similar behaviour to that as-well?
>
> -Liran

That's a good point. We had one case of numerous VM-exits for INIT,
and I'm pretty sure that was a defective CPU too.
