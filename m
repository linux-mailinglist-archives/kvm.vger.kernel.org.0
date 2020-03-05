Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A0C17ADDD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 19:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgCESHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 13:07:53 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40787 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgCESHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 13:07:52 -0500
Received: by mail-io1-f66.google.com with SMTP id d8so4324912ion.7
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 10:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wW0Vx9wAf9kliO11TUHuTABMuWhBJDP4gg7/87y3NTQ=;
        b=NEY++R9ID9WS4I+fJ6Wg6e22O+l026S/CxdI/U1mjEbaF7OiSLpkwNvhHLkJllqF8t
         qY2CQTvNuNJiCzWwNGOb5psE2vGDjwZTQ899XbI9eum14ung4gUCbN5RoNVWW00zKGok
         ifSV/8Ka5hp1CSKKn5q8Ld8KFT//0ha9lzFX28cF+JdEU/FfmgRBpt8i8sqTbCtPc7Co
         oVIeaYLJWVvx+4QHZrX+vMOc5zDx4DobLWKeRiujdotmEQ/l9Fu9QivIgDgis6kvQyPn
         fcMfIisFGw4g4AkEU2nN6hLQuYizcvNGD24FcbzZvE3MlzkZr6rdPVaEkk8WrYWkPyht
         wF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wW0Vx9wAf9kliO11TUHuTABMuWhBJDP4gg7/87y3NTQ=;
        b=GU96Y7xg1AsMAmVTQPT+RQFZrJPrs0I93Fk+HXLMvX7a4QKu7UcXz9wbTvOUJpO1vn
         1Y64XEmKpBL9YhmOXJvp4w9R/uPqdLbsQxiXrCuE5+wiN7C+IfdmR12CPMFszRL8jXFl
         YbX+0kcCKAhdYoSLwqrPpmZB87D7n2z6kNwYyCOoUhMha5BjtGy26XcMqnJ5arDa7d3i
         DZfzAFbI7bNPYJism/94M6NfOQzbWOQ02MUheWdXFsnWE8u94haEW5Uh9eUkA3LJiWKf
         Z6GExMfirGJTRuu1JFjHUUjuq32dY+wsfFu95b7aoZYRImmJO4SmB/5/1OZOdzqYp/FG
         76JA==
X-Gm-Message-State: ANhLgQ3o5pgN5SkTaOdsjZ7LGru1DcVYzwDi0pGDTWgVCB9rRKXMHbDM
        g1xSwzjlzcNMhwf4zN2EQJ85xKfBgUaju40MLxIZKQ==
X-Google-Smtp-Source: ADFU+vvN1q9pRd3JcvfRB56xAOLPFAk6RGPNot5ql5bO1pky7Paw8JYj0wH8F367GJ4Lza8zjqveixVAXn0z33UerZw=
X-Received: by 2002:a02:cf0f:: with SMTP id q15mr9049550jar.48.1583431672070;
 Thu, 05 Mar 2020 10:07:52 -0800 (PST)
MIME-Version: 1.0
References: <20200305013437.8578-1-sean.j.christopherson@intel.com> <20200305013437.8578-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200305013437.8578-3-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Mar 2020 10:07:41 -0800
Message-ID: <CALMp9eQ0=2MYHOezMZ31TMQCBc6s=nZWF7PWJ8F0DzTAvwSmOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Add helpers to perform CPUID-based guest
 vendor check
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 4, 2020 at 5:34 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add helpers to provide CPUID-based guest vendor checks, i.e. to do the
> ugly register comparisons.  Use the new helpers to check for an AMD
> guest vendor in guest_cpuid_is_amd() as well as in the existing emulator
> flows.
>
> Using the new helpers fixes a _very_ theoretical bug where
> guest_cpuid_is_amd() would get a false positive on a non-AMD virtual CPU
> with a vendor string beginning with "Auth" due to the previous logic
> only checking EBX.  It also fixes a marginally less theoretically bug
> where guest_cpuid_is_amd() would incorrectly return false for a guest
> CPU with "AMDisbetter!" as its vendor string.
>
> Fixes: a0c0feb57992c ("KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
