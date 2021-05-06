Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15E4374EBE
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 06:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhEFFAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 01:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhEFE7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 00:59:21 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24815C061574;
        Wed,  5 May 2021 21:57:40 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p4so4273129pfo.3;
        Wed, 05 May 2021 21:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=NEErII2JPNmwZ0HM+qC85+Da9iM7biQE5PAgq2GlWcs=;
        b=JA3h4nikL5S3GcOofHtGGkkumWS55GMNpSLX3kR/+V2hQ7Csxx9yLw/NMFXfBtt4mr
         J0KNe/BmiTuEuULmIEOIQFGojW+xFqdzxUohljV8OFMJWlPFlEuJlYhjliaEk898Y55q
         IYxBu10dhE3V8WS+zVimLsQ4jOHGHqFVAnw/tRRNJUnWyM6jIv53sDqdppXRNg6h5C83
         yaHSOolDi/4VnsgfV7oZvt/03j/U5xsQoKq8nIbCzmygSaL5/dotB/iK7nyFp8xU+OJK
         ykkLCL2e1XJwio+4lwhLkgsdaKRvQMtIT/rTPmi+f80KBnnCNPAf570+xz/W8dzjUMoB
         VMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=NEErII2JPNmwZ0HM+qC85+Da9iM7biQE5PAgq2GlWcs=;
        b=unvN+26UutxDSXjWO1nEZwqpEu0bgvJUGpmtehdqlGHvYQHA97Pd226w1PRbDEMM2D
         l3Z06OgAdRI7e4qbe2oRmUjmzKmzJEFxjvJtF4+J0KRZjNkx0mPas4laAk3v9ltjUtiX
         of8vP1Qxo9NNIbc/sP25vJmXV0b+pvHxXXGUfl9NKNK+splHjkEMwwdenNIsRgQZiJEh
         b4cqu8aL3JuoZ8urRIMCrR1IOmJmXGyH0ZoMrgpEbSMQQ6cPRUU8WAQuXRH3Jt9F+JvD
         TfLwwguha9tZlOIiwPUa9HD1AyXXwSUL9D0hBZYiGBmbKIACbIr3M6W0kQqMVGCwUjJ5
         BXNA==
X-Gm-Message-State: AOAM532phiJiwaq3stck8GRoEJFQEkfjtd0Gis8lGMeiAlL+MWTW3Ti0
        /4SEeuGOKA7s6MSlj3JFHVA=
X-Google-Smtp-Source: ABdhPJz9NL4N4fHdHeuCc9+RFXATcTPpEI3bqGMMAw7XOGgVt24XScWDkVdRIznhxdvFnlT25I9+/g==
X-Received: by 2002:a65:4185:: with SMTP id a5mr2355473pgq.388.1620277060476;
        Wed, 05 May 2021 21:57:40 -0700 (PDT)
Received: from localhost ([61.68.127.20])
        by smtp.gmail.com with ESMTPSA id c6sm8565221pjs.11.2021.05.05.21.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 21:57:40 -0700 (PDT)
Date:   Thu, 06 May 2021 14:57:34 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU
 notifier callbacks
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20210505121509.1470207-1-npiggin@gmail.com>
        <YJK/KDCV5CvTNhoo@google.com>
In-Reply-To: <YJK/KDCV5CvTNhoo@google.com>
MIME-Version: 1.0
Message-Id: <1620276952.ug51qrzrc1.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Sean Christopherson's message of May 6, 2021 1:52 am:
> On Wed, May 05, 2021, Nicholas Piggin wrote:
>> Commit b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier
>> callbacks") causes unmap_gfn_range and age_gfn callbacks to only work
>> on the first gfn in the range. It also makes the aging callbacks call
>> into both radix and hash aging functions for radix guests. Fix this.
>=20
> Ugh, the rest of kvm_handle_hva_range() was so similar to the x86 code th=
at I
> glossed right over the for-loop.  My apologies :-/

No problem, we should have noticed it here in testing earlier too.

>=20
>> Add warnings for the single-gfn calls that have been converted to range
>> callbacks, in case they ever receieve ranges greater than 1.
>>=20
>> Fixes: b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier ca=
llbacks")
>> Reported-by: Bharata B Rao <bharata@linux.ibm.com>
>> Tested-by: Bharata B Rao <bharata@linux.ibm.com>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> The e500 change in that commit also looks suspicious, why is it okay
>> to remove kvm_flush_remote_tlbs() there? Also is the the change from
>> returning false to true intended?
>=20
> The common code interprets a return of "true" as "do kvm_flush_remote_tlb=
s()".
> There is technically a functional change, as the deferring the flush to c=
ommon
> code will batch flushes if the invalidation spans multiple memslots.  But=
 the
> mmu_lock is held the entire time, so batching is a good thing unless e500=
 has
> wildly different MMU semantics.

Ah okay that explains it. That sounds good, but I don't know the e500=20
KVM code or have a way to test it myself.

Thanks,
Nick
