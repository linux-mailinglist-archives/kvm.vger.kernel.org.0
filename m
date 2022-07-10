Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6E56CFE2
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiGJP6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 11:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJP6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 11:58:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7844A12A80
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 08:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657468695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcSBWuPanw+MSnwNJ3oSObjsYDtvUnp4dMZLTgyW6kg=;
        b=hOBHFsLW8RYFWfMFS31r8eAdsla7qwGSbl2QdNwvctKprH6IEWFtD65kEA4jHBfEbxrpYy
        XIWG0fS7npYRzF/du7B4pqSEKMvgkAqPNH5qZqbdtnXhItL0ygdL5deYjDjnhYkOWZCHEv
        LJjcqsC8UhMu3g5uK5vcYTsnOqGiNto=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-hfGJnngzN6Cz-QVcSiGrKg-1; Sun, 10 Jul 2022 11:58:11 -0400
X-MC-Unique: hfGJnngzN6Cz-QVcSiGrKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED8772A59547;
        Sun, 10 Jul 2022 15:58:10 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7413D2026D64;
        Sun, 10 Jul 2022 15:58:08 +0000 (UTC)
Message-ID: <527713984b43e372e569209f394c54520d3b3e60.camel@redhat.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Sun, 10 Jul 2022 18:58:07 +0300
In-Reply-To: <CALMp9eRrm7B_6MyNxuBGxm8WvgvkDcC=XrZ9dRK4pi=qQ=BuRw@mail.gmail.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
         <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
         <cab59dcca8490cbedda3c7cf5f93e579b96a362e.camel@redhat.com>
         <CALMp9eT_C3tixwK_aZMd-0jQHBSsdrzhYvWk6ZrYkxcC8Pe=CQ@mail.gmail.com>
         <YsXL6qfSMHc0ENz8@google.com>
         <CALMp9eRrm7B_6MyNxuBGxm8WvgvkDcC=XrZ9dRK4pi=qQ=BuRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 13:11 -0700, Jim Mattson wrote:
> On Wed, Jul 6, 2022 at 10:52 AM Sean Christopherson <seanjc@google.com> wrote:
> 
> > Hmm, I'm not entirely convinced that Intel doesn't interpret "internal to the
> > processor" as "undocumented SMRAM fields".  But I could also be misremembering
> > the SMI flows.
> 
> Start using reserved SMRAM, and you will regret it when the vendor
> assigns some new bit of state to the same location.
> 
This is true to some extent, but our SMRAM layout doesn't follow the
spec anyway. This is the reason I asked (I posted an RFC as a good citizen),
in the first place all of you, if you prefer SMRAM or KVM internal state.

Anyway if this is a concern, I can just save the interrupt shadow in KVM,
and migrate it, its not hard, in fact the v1 of my patches did exactly that.

Paolo, what should I do?

Best regards,
	Maxim Levitsky

