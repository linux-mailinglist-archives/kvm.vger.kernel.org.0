Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8874D695C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfJNSXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 14:23:52 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:38864 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbfJNSXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 14:23:51 -0400
Received: by mail-vk1-f194.google.com with SMTP id s72so3754108vkh.5
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 11:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSbm597Gf81I9JKwx1mjpFgm8v53e7w/YVxe9kMybDs=;
        b=oM+ayx/B71SngcaUIXxwtxS0RwAWGmnHO8Hzo3v+NZ2x7r7CS2HVrIkO+r7LS3lj3l
         M+lX7+F3nCsYghbUPmFXN85rjq7ssvijX92INzqwBoHnCA84am5CDSSIMj7KP1ss3t2Y
         Ip1odrGejXZ9dJP9wNr6JO2UJ0Gl5pmb3jMHOXFEhznNVPRur1Qehofmy2+Am6n9BHMi
         SZ2XtcamVSwfZqRxJMtl6A21mkrPIZ0IQXmjzLQoEJlbcPlMQFgBLn0h3xZQQJwYw199
         G0fMI6sIwzjtkAcPK0SB3zPQ57kqPi0RQFHYxRFgRNzSKFmB17a/R54LcnzQtH5XaZoK
         ZKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSbm597Gf81I9JKwx1mjpFgm8v53e7w/YVxe9kMybDs=;
        b=p7FnD0y5ee8hG8yc9da4AHQIiaU7JA2AEbGx1OvgSRJk+OwbCYfKd5Cmm+R2Ac4fQp
         N44frpQDd7yCrPdk3eRG5mfE1QgTC3eueqD59NOfdgeqYhg56ZIwtemqQHffuSUekkCp
         I45tS2pJbUffy1i4JrXq/7rquhDlrDWYA77CXTacWx01YGxQyfKW/Gxkkz5BAL3/obkL
         nbnvjUCuDxCT0scbLUwTXo4p1P8GVIruasMK/W750+WvxoHreDdUNYKufwsiywKbzCJi
         bNPRtID4PBxtLbRSx9hYyzSO4xJtTgrXvf4zrUOx/qE5CmRBBwEvbCGnP9Gl5llxDnlu
         NC4Q==
X-Gm-Message-State: APjAAAVm9MkfMNoN/wes0ZdqaaB0z7cPWdGN0O12KelIOsYyAL1X3PY9
        ggXNZ6lZis63yHMqV2WinusMyz7jtMwxCUirNzEQ
X-Google-Smtp-Source: APXvYqwGUEtgq/LVskAw2UlHr4s2yXjasvHwrWltNpEYEJNC3TasMW2/dO06qLSjr+iy1zIZyHCMi58Zhb3nPJFDSmU=
X-Received: by 2002:a1f:7f14:: with SMTP id o20mr17023122vki.100.1571077430478;
 Mon, 14 Oct 2019 11:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com> <20191014162657.GB22962@linux.intel.com>
In-Reply-To: <20191014162657.GB22962@linux.intel.com>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 14 Oct 2019 11:23:39 -0700
Message-ID: <CAGG=3QX-dd3z4FeeFPuT0q43mFRR0nnEf8g7fHbdxWRzDL_YMA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] Use a status enum for reporting pass/fail
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 9:27 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sat, Oct 12, 2019 at 12:44:53AM -0700, Bill Wendling wrote:
> > Some values passed into "report" as "pass/fail" are larger than the
> > size of the parameter. Instead use a status enum so that the size of the
> > argument no longer matters.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
>
> The threading of these mails has me all kinds of confused.  What is the
> relationship between all these patches?  Did you perhaps intend to send
> some of these as v2?
>
>   [kvm-unit-tests PATCH 1/2] Use a status enum for reporting pass/fail
>   [kvm-unit-tests PATCH 2/2] Use a status enum for reporting pass/fail
>   [kvm-unit-tests PATCH 1/1] x86: use pointer for end of exception table
>   [kvm-unit-tests PATCH 2/2] x86: use pointer for end of exception table

Yes, the later ones are meant as v2. I'm not familiar with the patch
submission policy via emails. :-(

-bw
