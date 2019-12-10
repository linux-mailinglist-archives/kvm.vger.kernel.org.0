Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2C117C53
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 01:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfLJATp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 19:19:45 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45884 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbfLJATo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 19:19:44 -0500
Received: by mail-ot1-f68.google.com with SMTP id 59so13928979otp.12;
        Mon, 09 Dec 2019 16:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=60+QgCgw8vt+YT/q6Y2nZ7XC1HzMmBFoYG6QdI4GklA=;
        b=LBbC3vW1X1omIxlXzcj7xmETpWRo19olNS3nE/82lpmbi/SuAEf23MecepOZi0JDiN
         v+cigQynx0gYVJcNeyqgNi6BDtILnLHlKSz7aj5okMVE2w+4SmoRNheiYnpQ6W8P3z+Y
         uvu8XZgW9lzTs1T3jXCcAtpTpzGnk9sI33gTLKbpVZz7lppxsgBgWwtvd0MV/ykl6B9y
         JTSzV7tzx0CnU+raTywCryCQEudt4ox1OiMrCSQMtHvQaeYRBqENpG+HOG2LWgguXE0v
         gI8fG8l29qq9wvou9OnQqvfIMkCFLq6be3biUfGT/El4LddfuJJmjYwdBNyTgwRuFfcA
         DjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=60+QgCgw8vt+YT/q6Y2nZ7XC1HzMmBFoYG6QdI4GklA=;
        b=AQz8/TfXvq73b4GGb+zWZOeRSpDsxDj01dScimXGBZWqSZWZ7SQljVSFesCv4GrlVh
         tMNdFjPJE5RLin3CtJM9ze3bZnpm9/Ek4uv34H0J/iivw83JG03VQ71U3biNhH8VgW3D
         KD+g/UxjHnBRW2d8o0we7zGG94YckVisL6zGdXX+LNGebY0d9Db59rUuAmv5StIeQF3y
         OkBHB4os/EsIp3RdDLck49/yUGycyux1gcw1kklrhEbyzOb8sbJS39reb0WAK5OKFCHk
         o6GH9UFZlzJkQGkmtXKhLnuQeYRCtAcXRvwmtESeb+unz/z3wns9cuD4YVe9i0+2ClyY
         7dEQ==
X-Gm-Message-State: APjAAAXVqzHlWwaKQ4/SkEdB71YpmGhUPOSp1C0MosJd3iaIiCp4Mg8B
        lZkgKQ2cKUkHXn7nFpSKYJKV9Kx2jPSn8t2o/Dk=
X-Google-Smtp-Source: APXvYqznaOLfbotYRFwvBn/hpfU1xQ1ZGU8r9VUPs46CWnjqgd3ypzFgy3DsIDTkUF3ElpA64wUfN2s0WhNbcJ5RCN8=
X-Received: by 2002:a05:6830:18cd:: with SMTP id v13mr22626160ote.118.1575937183378;
 Mon, 09 Dec 2019 16:19:43 -0800 (PST)
MIME-Version: 1.0
References: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CxYpPftErvk=JJdWZikKSn-PYsVRVP3LpF+Q3yBF8ypxg@mail.gmail.com>
 <CANRm+Cy_Aq4HY9vYDtBfoNyo8wikf8Mi3u7NBm=U78w1VtTFMA@mail.gmail.com> <9bc78a4c-6023-2566-d5ce-af611b199603@redhat.com>
In-Reply-To: <9bc78a4c-6023-2566-d5ce-af611b199603@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 10 Dec 2019 08:19:32 +0800
Message-ID: <CANRm+CxXnNs+fBgECK4JWS3zqhyLY27v_SbuAm6DTq2o3gY9+g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Dec 2019 at 01:03, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/12/19 09:15, Wanpeng Li wrote:
> > kindly ping after the merge window. :)
>
> Looks good.  Naming is hard, and I don't like very much the "accel"
> part.  As soon as I come up with some names I prefer I will propose them
> and apply the patch.

Great! Thanks!

    Wanpeng
