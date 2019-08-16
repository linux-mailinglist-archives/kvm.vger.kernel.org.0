Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2324907BA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 20:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfHPSZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 14:25:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42429 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfHPSZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 14:25:17 -0400
Received: by mail-io1-f66.google.com with SMTP id e20so8043032iob.9
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2019 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F3S+OzCu1yWNtyjcTHvpsq8kAfwz2WK26QR/yvCAhDU=;
        b=IN9VuSV7Ibz7E3uVf36DPoeJdSpkGxFHLj6dYNXmXyvQUe4qrojb6pxghaMlkgzjjW
         fnLDH3LqQ/rIcKzF+XvRbXESIepDNxB0cACcWUEPUQrFp/mKpC4tAvvDNkDxQhKvZLAv
         DAH75Tga2mmL1lUplWY5DATKzyAhP35VRFzMLyLQQiSEDtmaM2PNRNtsQObBmj2X1jyM
         OqOQzpQlHmCFChzBmZfGVp14m6nq/gwXheIIWaCvNIrK5qsq8wleodU9gr3l8yGtCweJ
         Ovi03mGWOzfTMuSzyYAAq9bZRLCKKTeVZHcv13F64CzQqKly7IjGma4x+S84NYwpq6ML
         4ePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F3S+OzCu1yWNtyjcTHvpsq8kAfwz2WK26QR/yvCAhDU=;
        b=LRDFboYFT8QJGFS5xlSoQGMTQrapAp0nzkeiuMH98DOTEWwTi7Zmti2walVxkiq3cq
         ILIhrl5JEBKznBB/P59D7K+JlmWAzvXSjh8kAcM8VJN83yW6KGaoc4ehlFM+IY0NQgqh
         +fUw1WdcsxyiGgBHsXpk6ULY96mggXr2oznPVqRWmtMgXwdtjOBV6H3jtz40HkSMCLD4
         2HchSlwh/49PgAYxukFxU7KFxYVjMmIc0Y93qpV0gMIuPkQdMf0NDZQ+679JKB2pXPan
         axzHVBFsG+0/aRv9jOU3ruhGYvhGmZA9iXLfjcfRJyQVoL3BueFF38rm+gdM9BCRdP5T
         sOiw==
X-Gm-Message-State: APjAAAWxjV98gx3/5uAADpjquwhJCJP+lIcyCPr0AZutUV+TZU/qQypD
        VpyHVhmViJwv9jxayTj0Se2C5i9Tqc07GKdRCsHdwQ==
X-Google-Smtp-Source: APXvYqy/pQ68ktJraZx2OOVpVJ8kHPldt0Y3rCKUg8hxUR6Vc+ePWJRCAjjILHp6RQ68WRLW89S+fyHYBIDZKbwX06U=
X-Received: by 2002:a02:a405:: with SMTP id c5mr12489114jal.54.1565979916097;
 Fri, 16 Aug 2019 11:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190815172237.10464-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190815172237.10464-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Aug 2019 11:25:05 -0700
Message-ID: <CALMp9eQZ=c4nkKmJQr4omdCmB=P1Yug+g_XK_fqZ0YZuEt0Pkg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Assert that struct kvm_vcpu is always as offset zero
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 10:23 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> KVM implementations that wrap struct kvm_vcpu with a vendor specific
> struct, e.g. struct vcpu_vmx, must place the vcpu member at offset 0,
> otherwise the usercopy region intended to encompass struct kvm_vcpu_arch
> will instead overlap random chunks of the vendor specific struct.
> E.g. padding a large number of bytes before struct kvm_vcpu triggers
> a usercopy warn when running with CONFIG_HARDENED_USERCOPY=y.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
X86 parts:
Reviewed-by: Jim Mattson <jmattson@google.com>
