Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA809574B4F
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbiGNK6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 06:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiGNK6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 06:58:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A42F6564CD
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657796301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nM5yVanzRJTIfs3jtPwCWDlU85jtUwSjBS8/j3385bI=;
        b=ZKq1Of6Mpec9NSGo7VabF21JWTRy/CkKeAx5Wi411faPjdwFa6XENFQV1J0LLk2ITG8SZM
        MHNZF5bLz/16cn5upjISBLwHXGd9VvAKvH3391kgrgTgXGlzl/cRsHVxTsMMQA6B8a77UT
        otoy4NbuY5Kj5HMN66dhIu5r1sbztFQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-DAmkMQ29MS2II3Vz6NJgjg-1; Thu, 14 Jul 2022 06:58:20 -0400
X-MC-Unique: DAmkMQ29MS2II3Vz6NJgjg-1
Received: by mail-wm1-f71.google.com with SMTP id v123-20020a1cac81000000b003a02a3f0beeso2488200wme.3
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nM5yVanzRJTIfs3jtPwCWDlU85jtUwSjBS8/j3385bI=;
        b=mqhIlWtuteK3yiH5XCfoIhJCKNdcsr5NqM4FOsKpIpT0aCiN0Kv7HDIHyYb6nSzWVg
         kt7Ycox7nFaXE1N9KcAzsHzouGMFp+N4RrT7Jb6zIHyzOjNOyBkkQHo5HsORIGAkZGbH
         VTi4j46Sela1+h/YOUOQN9N51qt1Nqv9GNI7y9w0OKVY4PpfbMRgLZbiwn+Aht58XuBl
         iATvLmfLZuIUfwy/SqnYHgYfdDSsyvz/fXqK7LIjYAWhkx4xy/Re3zoNN7ifi81BO6Rf
         rNvMN51F+D/WCiCx3DOHrhkpt9IX42TJlHsv/ls/ZKu+xwA/ff4SuV9GtVRwGI4h8WPk
         KrLA==
X-Gm-Message-State: AJIora+7KpfKBomqNiTiU/YuC0+NxvWK6J/aYmHkQDT+9Sg2zFwNr8M6
        Xvac2bnUfOPnm/WGSOBYSNaGh2D209xZmNp+TuOK2AXoEgkzCnkvdOVpzEEohC8wAmnfN1NwfhY
        W/FBL8A5Zb1dg
X-Received: by 2002:a5d:5985:0:b0:21d:b6b6:4434 with SMTP id n5-20020a5d5985000000b0021db6b64434mr7579271wri.111.1657796299359;
        Thu, 14 Jul 2022 03:58:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uAEUQ0kwm+yiiE9dw/IiB5F2EY4Xbq86kJCUcxpug/0Urvuhaq7E6wyYQ1FXFo7snQYDcNxg==
X-Received: by 2002:a5d:5985:0:b0:21d:b6b6:4434 with SMTP id n5-20020a5d5985000000b0021db6b64434mr7579253wri.111.1657796299087;
        Thu, 14 Jul 2022 03:58:19 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id d13-20020adffbcd000000b0021d9591c64fsm1212994wrs.33.2022.07.14.03.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:58:18 -0700 (PDT)
Message-ID: <087db845684c18af112e396172598172c7cc9980.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Add dedicated helper to get CPUID entry
 with significant index
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 13:58:17 +0300
In-Reply-To: <Ys2qwUmEJaJnsj6r@google.com>
References: <20220712000645.1144186-1-seanjc@google.com>
         <8a1ff7338f1252d75ff96c3518f16742919f92d7.camel@redhat.com>
         <Ys2i2B/jt5yDsAKj@google.com> <Ys2qwUmEJaJnsj6r@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-12 at 17:09 +0000, Sean Christopherson wrote:
> On Tue, Jul 12, 2022, Sean Christopherson wrote:
> > On Tue, Jul 12, 2022, Maxim Levitsky wrote:
> > > On Tue, 2022-07-12 at 00:06 +0000, Sean Christopherson wrote:
> > > > +               /*
> > > > +                * Function matches and index is significant; not specifying an
> > > > +                * exact index in this case is a KVM bug.
> > > > +                */
> > > Nitpick: Why KVM bug? Bad userspace can also provide a index-significant entry for cpuid
> > > leaf for which index is not significant in the x86 spec.
> > 
> > Ugh, you're right.
> > 
> > > We could arrange a table of all known leaves and for each leaf if it has an index
> > > in the x86 spec, and warn/reject the userspace CPUID info if it doesn't match.
> > 
> > We have such a table, cpuid_function_is_indexed().  The alternative would be to
> > do:
> > 
> >                 WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT &&
> >                              cpuid_function_is_indexed(function));
> > 
> > The problem with rejecting userspace CPUID on mismatch is that it could break
> > userspace :-/  Of course, this entire patch would also break userspace to some
> > extent, e.g. if userspace is relying on an exact match on index==0.  The only
> > difference being the guest lookups with an exact index would still work.
> > 
> > I think the restriction we could put in place would be that userspace can make
> > a leaf more relaxed, e.g. to play nice if userspace forgets to set the SIGNFICANT
> > flag, but rejects attempts to make guest CPUID more restrictive, i.e. disallow
> > setting the SIGNFICANT flag on leafs that KVM doesn't enumerate as significant.
> > 
> > > > +               WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> 
> Actually, better idea.  Let userspace do whatever, and have direct KVM lookups
> for functions that architecturally don't have a significant index use the first
> entry even if userspace set the SIGNIFICANT flag.  That will mostly maintain
> backwards compatibility, the only thing that would break is if userspace set the
> SIGNIFICANT flag _and_ provided a non-zero index _and_ relied on KVM to not match
> the entry.

Makes sense as well.

Best regards,
	Maxim Levitsky

> 
> We could still enforce matching in the future, but it wouldn't be a prerequisite
> for this cleanup.
> 
>                 /*
>                  * Similarly, use the first matching entry if KVM is doing a
>                  * lookup (as opposed to emulating CPUID) for a function that's
>                  * architecturally defined as not having a significant index.
>                  */
>                 if (index == KVM_CPUID_INDEX_NOT_SIGNIFICANT) {
>                         /*
>                          * Direct lookups from KVM should not diverge from what
>                          * KVM defines internally (the architectural behavior).
>                          */
>                         WARN_ON_ONCE(cpuid_function_is_indexed(function));
>                         return e;
>                 }
> 


