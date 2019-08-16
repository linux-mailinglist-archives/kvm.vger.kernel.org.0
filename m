Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD3590A6A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 23:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfHPVpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 17:45:52 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46963 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfHPVpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 17:45:51 -0400
Received: by mail-io1-f65.google.com with SMTP id x4so9082609iog.13
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2019 14:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJfTLw9HSdNJm60I6uHAdDZzXWuRnU4z9y6bRN6cjWc=;
        b=bR6jRalCIevq0ABoPuEl+Eq5L3NPtBnWeWiPN6gDyoSRG9W3Oug49waSn0b2wcOuqE
         mLn5q9cZWGTUD2uCOQsX/3YyybikGIdtBpKTFbQSl6WODe6Qj5V8LQxMDhl2J8/8Mlqe
         PB+MIDgCC2Cb10JGUeb55QghgaT4OQeE3CiTjNfW+aHvh88Vb0u/01ioxETMCcUETfhM
         pUY0CDbvV1ZrmexMFsrb1Ua5cm7yg5FHv+xdNqj2Kk5nMw4AghSrmNQthLlw2jB9mdgT
         B7k+ODKNuu+0SAP5EIxWAl1wFjzVkoqlDnPYldXHEhU/yDFA9uAFuFKiZiaDpYwuxElg
         OBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJfTLw9HSdNJm60I6uHAdDZzXWuRnU4z9y6bRN6cjWc=;
        b=mNNw8LPGcnwquP3g/CuTjP1GhtQGY8HxsTvPODKoAto4bQ7S5KKFtLn/St3Z8Or+e9
         AHuANBApco5g2U0l5B2+dkIgS0RHaDQiDI/cjgWo5TmEshegUJSIjYDuuMwJJ1syAGtm
         aXoBQ2/5EpkKpayIwbC63USkE6bxurDLtG3s+QegxldBvhd16jdtt02HM2L1FOloOh47
         1Ud3/COW93JK07qof28S+36I6WvI6DdCoqtcc3usRXXOtlywuOax2RO4F/PydY70HaSu
         CGfFh2LkeH9TyHY9VPSCNI/MCp9Sp328Mt14sskVSRErfUKgS731N8X++qfKmn6tOcpG
         R4sw==
X-Gm-Message-State: APjAAAVwzj2n37XfZp+6nWlhCQW0pbOXarksAS//qY1KlhQetngi7M/0
        wPv5lCqD2ONlFZWy3Sh2FooBsZk0WVjOnSLA8ZLLfNBivVXJfQ==
X-Google-Smtp-Source: APXvYqxPtkxRLjKQu3ETL2kWtt1SS8e+n/w7xSU/d4dfUkR3+vCZ9D/nhCKQcpgFlNue3llsyg8JXJW8rPcBEHgWmno=
X-Received: by 2002:a02:a405:: with SMTP id c5mr13413575jal.54.1565991950591;
 Fri, 16 Aug 2019 14:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <1565854883-27019-1-git-send-email-pbonzini@redhat.com> <1565854883-27019-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1565854883-27019-2-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Aug 2019 14:45:39 -0700
Message-ID: <CALMp9eQcRbMjQ_=jQ=qaYmh1Lavc3PYvm4Qcf3zY+N8j3zZe-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix reporting of AMD speculation bug CPUID leaf
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 12:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The AMD_* bits have to be set from the vendor-independent
> feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
> about the vendor and they should be set on Intel processors as well.
> On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
> VIRT_SSBD does not have to be added manually because it is a
> cpufeature that comes directly from the host's CPUID bit.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

On AMD systems, aren't AMD_SSBD, AMD_STIBP, and AMD_SSB_NO set by
inheritance from the host:

/* cpuid 0x80000008.ebx */
const u32 kvm_cpuid_8000_0008_ebx_x86_features =
        F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
        F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);

I am curious why the cross-vendor settings go only one way. For
example, you set AMD_STIBP on Intel processors that have STIBP, but
you do not set INTEL_STIBP on AMD processors that have STIBP?
Similarly, you set AMD_SSB_NO for Intel processors that are immune to
SSB, but you do not set IA32_ARCH_CAPABILITIES.SSB_NO for AMD
processors that are immune to SSB?

Perhaps there is another patch coming for reporting Intel bits on AMD?
