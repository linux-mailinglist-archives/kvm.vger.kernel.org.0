Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F727BF82A
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjJJKEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 06:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjJJKEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 06:04:06 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4978693;
        Tue, 10 Oct 2023 03:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=0VuAuXHjC6TcrB2Upe0J5kYBATdZNMJL7jMHDwWl1Oc=; b=lNdGO3IQ0dDFm7Nxs4ZgXMdgpL
        KJozlc2DyNANXv8kN+v0JoGHveW2KI3SmTqQ8lF6pv4fPzNstjiCR/QbxzzQWXnSXM32hqHu9ZiKe
        nqp8OJsifwiqTiXlM7oFIiq3tDEhie4E1TIe2FNcKGckePUE7qGpFi5RBpBzzP6XMefB8BMw95YQj
        RPhoml90CO5ZTXLBNfIVp8fQLxpKhulFeMKbLkxE+J4xfrb1ROEXsrsaH+cf07joo4H62b42W7Iq2
        OuU03P04e6PBTDh7GLgWTqK2r1+v3PMaztXArg3lgcdr+MgZXCf4iQbuBv4a1qRyV/Xn+StFItrsE
        1BqsBUBA==;
Received: from [46.18.216.58] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qq9ag-00GlJC-2H;
        Tue, 10 Oct 2023 10:03:53 +0000
Date:   Tue, 10 Oct 2023 11:03:50 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
CC:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v7=5D_KVM=3A_x86/tsc=3A_Don=27t_sync?= =?US-ASCII?Q?_user-written_TSC_against_startup_values?=
User-Agent: K-9 Mail for Android
In-Reply-To: <169689823852.390348.16203872510226635933.b4-ty@google.com>
References: <20231008025335.7419-1-likexu@tencent.com> <169689823852.390348.16203872510226635933.b4-ty@google.com>
Message-ID: <D764860F-5DBC-49DD-8909-D08A3C24BC42@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10 October 2023 01:44:32 BST, Sean Christopherson <seanjc@google=2Ecom>=
 wrote:
>On Sun, 08 Oct 2023 10:53:35 +0800, Like Xu wrote:
>> The legacy API for setting the TSC is fundamentally broken, and only
>> allows userspace to set a TSC "now", without any way to account for
>> time lost to preemption between the calculation of the value, and the
>> kernel eventually handling the ioctl=2E
>>=20
>> To work around this we have had a hack which, if a TSC is set with a
>> value which is within a second's worth of a previous vCPU, assumes that
>> userspace actually intended them to be in sync and adjusts the newly-
>> written TSC value accordingly=2E
>>=20
>> [=2E=2E=2E]
>
>Applied to kvm-x86 misc, thanks!  I massaged away most of the pronouns in=
 the
>changelog=2E  Yes, they bug me that much, and I genuinely had a hard time=
 following
>some of the paragraphs even though I already knew what the patch is doing=
=2E
>
>Everyone, please take a look and make sure I didn't botch anything=2E  I =
tried my
>best to keep the existing "voice" and tone of the changelog (sans pronoun=
s
>obviously)=2E  I definitely don't want to bikeshed this thing any further=
=2E  If
>I've learned anything by this patch, it's that the only guaranteed outcom=
e of
>changelog-by-committee is that no one will walk away 100% happy :-)

LGTM=2E I forgive you for not respecting my pronouns=2E :)

Thanks=2E
