Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8301156969D
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 01:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiGFXwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 19:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiGFXwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 19:52:02 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23F2D1E1
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 16:52:02 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id w62so54998oie.3
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 16:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BL7W23oHq0JL/M8TNGzxaqsF4OCN+5iCjxJ+fwRF/M8=;
        b=W7Bxxt3rS48fnDgjqLePmCkjfVy8mPWiRP1Ek/okWVaAlUCn9Beu2Yhhpq72FX22vI
         2clQpJeMjPH/7FGZvt/ndKFWuhQAp2+/Rdk+EBYzZwwF26S9vXx0yJPTmat8wT8VtZ6x
         MSIy3jbrFXJEuTg8x394WsVqxD3/olXhh5Hw19OancK78mDmiOxvuSoXhPhHZaMo3lSa
         fx91Gj1tf35/hxtpIRDHBpqSRJbvJlebuNDuE6RBjb2poG9ivmkGPHEIFSlscl4uJklc
         6SA3V8WcYy35GE5a9VgfKvV9f1/fsFP2re5yYG11rwR4X97SI/LY5CBo+ezoqqpjwwnD
         I6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BL7W23oHq0JL/M8TNGzxaqsF4OCN+5iCjxJ+fwRF/M8=;
        b=Mlf8nKxnD/vnzozDIr1y3H9nTVALFwXqgy3dk7UwKajoZOvx+h+OmKSn/ybAsPsEMt
         gl1tpKk5/2gepPbh/+xwY/QPwH3qsJXOCVDUJ+VwUODoV4aZnsn0jqijmTxXcal+l6Nn
         V+ghvVncek1vKNa1Gx6y0Vgv7vCaMwjtR57atqdyZJ+x98QLLsFvv6aI/+K8HqDwWogd
         ERYnvIOyT9cf9iF8yMBEh+7wsWegdoHlv/+r3Y+bUeShEliZCO9BU+Z/6ruhms/BLNls
         JhzE87EY9J2Ldhk0PdgmpfgMWQkInCPm5nqZs2tSTyRQzO4RNWbW176SWJjn3HvB1vRI
         QRXg==
X-Gm-Message-State: AJIora8OIg8d4kjgDOj+nNbgSAKXRPWYT5XAMJbbEryM7BxC3luT0xYm
        zIwYB2RKgj/w7xtb1dNTmsA57LW5JVNJlb98Cp+esg==
X-Google-Smtp-Source: AGRyM1uu9XjOrKLX28cVqi4dnKMz2RP55IVUsLf3ms+qDAp/4RaMrlk+119BjbDPEHCq2pfyEQKg2yD6xs8AXxbxhNc=
X-Received: by 2002:a05:6808:2124:b0:335:7483:f62d with SMTP id
 r36-20020a056808212400b003357483f62dmr764472oiw.112.1657151521323; Wed, 06
 Jul 2022 16:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <20220614204730.3359543-6-seanjc@google.com>
In-Reply-To: <20220614204730.3359543-6-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 16:51:50 -0700
Message-ID: <CALMp9eSH1O8keAVxZzfdvV1vu0AJBhaXVUfkSgYgCPOoSB5=Jw@mail.gmail.com>
Subject: Re: [PATCH v2 05/21] KVM: nVMX: Prioritize TSS T-flag #DBs over
 Monitor Trap Flag
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 1:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Service TSS T-flag #DBs prior to pending MTFs, as such #DBs are higher
> priority than MTF.  KVM itself doesn't emulate TSS #DBs, and any such

Is there a KVM erratum for that?

> exceptions injected from L1 will be handled by hardware (or morphed to
> a fault-like exception if injection fails), but theoretically userspace
> could pend a TSS T-flag #DB in conjunction with a pending MTF.
>
> Note, there's no known use case this fixes, it's purely to be technically
> correct with respect to Intel's SDM.

A test would be nice. :-)
