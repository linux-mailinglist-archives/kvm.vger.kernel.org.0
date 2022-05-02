Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56BD516AD9
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 08:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358005AbiEBG3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 02:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357979AbiEBG3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 02:29:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFE5162F9
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 23:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651472744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a1t7gKaGVXLmNQruqNmUAUrRE9yjzEf9Cg1uf2jYQi0=;
        b=J8cu/KgRFnIkeVl8ltPPESaKDnFQIXzJZCG197qQarbzWX1uoEBQWFBGrVrvc51flEojOX
        Qpq4XCn2FpF4vbApDFtveFCWgXDpRpcggNIQftwYK2kY3XuydyPksaJ98ZOSYa2C6xz87D
        +LW8gIyyqt8mh4NFFhUX0/pVG8Uz3FQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-dg64glcCOyaCxyyKNrC07Q-1; Mon, 02 May 2022 02:25:43 -0400
X-MC-Unique: dg64glcCOyaCxyyKNrC07Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5732D802803;
        Mon,  2 May 2022 06:25:43 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6266D40D1B9F;
        Mon,  2 May 2022 06:25:42 +0000 (UTC)
Message-ID: <a3868519e825075169e8f53620f18bdea9c6b5de.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: work around QEMU issue with synthetic CPUID
 leaves
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Mon, 02 May 2022 09:25:41 +0300
In-Reply-To: <54adc4a3-6b66-8ddf-db92-9630089da2dd@redhat.com>
References: <20220429192553.932611-1-pbonzini@redhat.com>
         <1dcfb3d243916a3957d5368c2298e3f8fd79a9f2.camel@redhat.com>
         <54adc4a3-6b66-8ddf-db92-9630089da2dd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-05-01 at 19:37 +0200, Paolo Bonzini wrote:
> On 5/1/22 13:16, Maxim Levitsky wrote:
> > > +		 * However, only do it if the host has CPUID leaf 0x8000001d.
> > > +		 * QEMU thinks that it can query the host blindly for that
> > > +		 * CPUID leaf if KVM reports that it supports 0x8000001d or
> > > +		 * above.  The processor merrily returns values from the
> > > +		 * highest Intel leaf which QEMU tries to use as the guest's
> > > +		 * 0x8000001d.  Even worse, this can result in an infinite
> > > +		 * loop if said highest leaf has no subleaves indexed by ECX.
> > 
> > Very small nitpick: It might be useful to add a note that qemu does this only for the
> > leaf 0x8000001d.
> 
> Yes, it's there: "QEMU thinks that it can query the host blindly for 
> that CPUID leaf", "that" is 0x8000001d in the previous sentence.

Yes I see it, but it doesn't state that qemu doesn't do this to other leaves in the affected range.

I had to check the qemu source to verify this to be sure that checking for 0x8000001d
is enough.

Just a tiny minor nitpick though.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


