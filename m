Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248DF6C38F5
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjCUSMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjCUSMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:12:30 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E1350996
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:12:29 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-53d277c1834so294838827b3.10
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679422349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FPozxaeZQPWyCpd0xbPfiSsnDcAAT2J9cKx1SPDRr9I=;
        b=X9t0a1zypAz79SHi2UyDEpKSW9JBfcjPYiD8oK9gusW1icc07Zj6V1WcyR2NhnNLkv
         +JnuaBSRbyDF0IaAkIMmzv4QMqQNh7s4bPg3190aJ6qFAyyK+iPm1ZSbtnji6gDniPQj
         b5ZNiGkaUzdqa6HCFLXlwAtMPAjGGIqu2ZkSFzaVJ+X4rJ5/k7CXqlnSuqpB9oubYnpU
         bCVb8Bhaf3upIUC1abbSypW8s800ThDEvG2l4VimVMpOt4oKD/dN/JgN3GefubgQ+qLf
         kcFHWO+0TQcvYe208YDghTK72N7o2mP1vI2fw2EKKlXWD4piIAfFSV40i6CjxAf/Lg03
         FKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679422349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FPozxaeZQPWyCpd0xbPfiSsnDcAAT2J9cKx1SPDRr9I=;
        b=bCNHR9Z5E51kKYjqviNzye8tqirXWGTbdm7eQfdJq8Iy6kC+89crQkG1CzkqbHvBZq
         OHYbxGbhdHxKwytE9EEjE7RAN/F7Ig2IJ8aB8yB8yDFqkBIItvU6sulf5JPMapmNBCUs
         oAUAh+ECW/r3VDv6TTCyjTH+QTiUZAnyAUZ6J5UuGZtlfn4+v64jdhM9jAV/au8MjG9Y
         r4X0yoQJmu2RP2+3ZWbwDv/YLWzQdwYKY6AHAzy2rDkbwyhOhJZV5TmMzEajzT9hKF8D
         lZxwFNIO1D6qoaWoslZhzzxL0e+etx9V+b4lLaeurlx6gzWgIpS2vki45hxro0dAd1f+
         ifOg==
X-Gm-Message-State: AAQBX9cXULSugdcuD029D05QVZ7kP7a4d46Kb79w5RJUCwAZUvpxySkZ
        qo2u4gGes5oJmmZcKV21E60EcMMsoquazfN3BcYlgw==
X-Google-Smtp-Source: AKy350a9AALo/UNCOhNQxiW/XrM+h7wC/4w+mnV5lmSryhb+xXp5pX4vZye1EgLkE5MKieToXDSBjJxyQKhUmAC3PKk=
X-Received: by 2002:a81:a846:0:b0:541:69bc:8626 with SMTP id
 f67-20020a81a846000000b0054169bc8626mr1695407ywh.10.1679422348661; Tue, 21
 Mar 2023 11:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <ZBTwX5790zwl5721@google.com>
 <ZBj9L2VUjEbWbgcS@google.com>
In-Reply-To: <ZBj9L2VUjEbWbgcS@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 21 Mar 2023 11:11:52 -0700
Message-ID: <CAHVum0feM8hnD-+dXF4jiug8tmpm9GBAh619Xf279LNSm=Jozw@mail.gmail.com>
Subject: Re: [Patch v3 0/7] Optimize clear dirty log
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 5:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Mar 17, 2023, Sean Christopherson wrote:
> > Did a cursory glance, looks good.  I'll do a more thorough pass next we=
ek and get
> > it queued up if all goes well.  No need for a v4 at this point, I'll fi=
xup David's
> > various nits when applying.
>
> Ooof, that ended up being painful.  In hindsight, I should have asked for=
 a v4,
> but damage done, and it's my fault for throwing you a big blob of code in=
 the
> first place.
>
> I ended up splitting the "interesting" patches into three each:
>
>   1. Switch to the atomic-AND
>   2. Drop the access-tracking / dirty-logging (as appropriate)
>   3. Drop the call to __handle_changed_spte()
>
> because logically they are three different things (although obviously rel=
ated).
>
> I have pushed the result to kvm-x86/mmu, but haven't merged to kvm-x86/ne=
xt or
> sent thanks because it's not yet tested.  I'll do testing tomorrow, but i=
f you
> can take a look in the meantime to make sure I didn't do something comple=
tely
> boneheaded, it'd be much appreciated.


Thanks for refactoring the patches. I reviewed the commits, no obvious
red flags from my side. Few small nits I found:

commit e534a94eac07 ("KVM: x86/mmu: Use kvm_ad_enabled() to determine
if TDP MMU SPTEs need wrprot")
 - kvm_ad_enabled() should be outside the loop.

commit 69032b5d71ef (" KVM: x86/mmu: Atomically clear SPTE dirty state
in the clear-dirty-log flow")
 - MMU_WARN_ON(kvm_ad_enabled() &&
spte_ad_need_write_protect(iter.old_spte) should be after
if(iter.level > PG_LEVEL_4k...)

commit 93c375bb6aea ("KVM: x86/mmu: Bypass __handle_changed_spte()
when clearing TDP MMU dirty bits")
 - Needs new performance numbers. Adding MMU_WARN_ON() might change
numbers. I will run a perf test on your mmu branch and see if
something changes a lot.
