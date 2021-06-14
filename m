Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B623A7121
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhFNVXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 17:23:07 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:36468 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbhFNVXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 17:23:06 -0400
Received: by mail-oi1-f173.google.com with SMTP id r16so15469553oiw.3
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 14:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbXsJ3eOeCcBLeSFCAHEUsr96YUafQfXz2w1OefbdRA=;
        b=KsMlempr8UdjV4tBNzzoYYZTu0ecnVXAT6CveqXkZepj8L2W2SLdKRH06h744uPaqL
         dp+CRgnJq1PbUoKdY0fBbtFZKz0CpY1iheQfptn+Ylg5btTXQGgEU+IQxMWqD2ZUYCkc
         FRgV+Df7OXHAhiaHKDf991UkYgEEh6MKdPz9vSIDcn6KK54IkP5ANlwFy7SaZnJWrFOi
         ztXeRya8DfKyVa+apnmlC30PxIZEs9q7orTf0bFsvmqe1JsQyLFwSyJNUnzmXvzOWMBt
         vLjQMcZSbTfwhjyxcqF4o6iiTFe5A/fYYupgcwYAeVSY2VrAOcvmv1obblMPDNLWmCXi
         kegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbXsJ3eOeCcBLeSFCAHEUsr96YUafQfXz2w1OefbdRA=;
        b=nK9DIVPPqY6duHGuyImv0qimBxS2En1ES7QgqpJd5CDSCNV3Fdb79PIFP7QT1nS1uj
         5wb408z/46PPoehrhQwlaiDnGqlhGUVFtJpQHtOuLtSjqJyGAcm/3YIwPlrME/dN07Xj
         jX5kGVJRV7z3zRZuZMLvGyNkI/TAQEIZhJ2j5ROg8krOkkrm/mPjWzwnEDHHArMkIp5a
         /4kVNtHrKWMx8lY12VfVqtd8Rn/Y8ZOktZmtjdwHTDJbssyAQgt9cscbZ+O5XWM4w0kM
         +u+TwE20EdI8Z7eM/PwcprjOxRQ1v9MKLxt3TQjM1Wf20KXjb71QM/9iMaqaVT4dgqFd
         QaXw==
X-Gm-Message-State: AOAM532HEtmS1rHd29vJ17KYyT05xdD9KC5Y0++sI/6T824EaPbSqRp9
        J0KCPUlTGhNAaGZvRWL7Ehg9UjqGkEdYg+8cdDlCkuas/O4=
X-Google-Smtp-Source: ABdhPJzgQ+WtAfMjO5Ih+flBlcvzrBy/UYUcTZzdRWWC9TeRj8iacJtLZepheLF8PbYsM/389Wwm6QXpf1pfHyejHkQ=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr11575758oic.28.1623705602859;
 Mon, 14 Jun 2021 14:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRWBJQJBE2bxME6FzjhDOadNJW8wty7Gb=QJO8=ndaaEw@mail.gmail.com>
 <50c5d8c2-4849-2517-79c8-bd4e03fd36ad@redhat.com>
In-Reply-To: <50c5d8c2-4849-2517-79c8-bd4e03fd36ad@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Jun 2021 14:19:51 -0700
Message-ID: <CALMp9eRXrXo3HznH7OnwRyPg3NKuH2FK720HYGADNfbWApQeAA@mail.gmail.com>
Subject: Re: [RFC] x86: Eliminate VM state changes during KVM_GET_MP_STATE
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 3:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/06/21 22:39, Jim Mattson wrote:
> > But, even worse, it can modify guest memory,
> > even while all vCPU threads are stopped!
>
> To some extent this is a userspace issue---they could declare vCPU
> threads stopped only after KVM_GET_MPSTATE is done, and only start the
> downtime phase of migration after that.  But it is nevertheless a pretty
> bad excuse.

I agree that this could be fixed by documenting the behavior. Since I
don't think there's any existing documentation that says which ioctls
can modify guest memory, such a documentation change wouldn't actually
constitute an API breakage.

BTW, which ioctls can modify guest memory?

And, while we're at it, can we document the required orderings of the
various _GET_ and _SET_ ioctls for save and restore?
