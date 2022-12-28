Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA8065767D
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 13:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiL1Mfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 07:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiL1Mff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 07:35:35 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB54C10040
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 04:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=Fe2KS6xRbCs2zahdofprgybwYcDFofclyPqCyQ+q/xY=; b=d9i3SbT7AslHwzEBSpZrv5VRNx
        K41NiIpPVDl2B5oJY15uCPbZU20wqybJmgOmkgalGZ1HtCpRmhDQu0mx9gYmfQvhFgp/0aPCVJoAg
        LL/FucWS0LCn6RFt/CxRDSkxEuJdXzFBWwnt+xD17C7Rsh8QAjoYxkqkQymxDU2S6OCNeMckwK8ac
        iUsf112RIk4vTxDGuBypq3TtyqT5S7M0LdvQkXhCeY/5HNX1pSszrdwoaBTwaapwbtHhEkxmdcF8O
        UEDfPxQBXbymDwOcaCynIbCF8EEmmcV/R2ZKJA11BkHEObkRRq227hRo0NAf95+wa+IX11nhMWu9i
        1slSK68w==;
Received: from [2001:8b0:10b:1:fc23:4bca:1305:932b] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pAVeV-00FylU-12;
        Wed, 28 Dec 2022 12:35:23 +0000
Date:   Wed, 28 Dec 2022 12:35:24 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
CC:     paul@xen.org, seanjc@google.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_1/2=5D_KVM=3A_x86/xen=3A_Fix_us?= =?US-ASCII?Q?e-after-free_in_kvm=5Fxen=5Feventfd=5Fupdate=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
References: <20221222203021.1944101-1-mhal@rbox.co> <20221222203021.1944101-2-mhal@rbox.co> <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com> <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co> <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com> <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co> <4ed92082-ef81-3126-7f55-b0aae6e4a215@redhat.com> <9b09359f88e4da1037139eb30ff4ae404beee866.camel@infradead.org> <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
Message-ID: <50978768-2699-4D70-8AA9-1BBC82961BA9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28 December 2022 11:58:56 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wr=
ote:
>On 12/28/22 10:54, David Woodhouse wrote:
>>> Yes, I imagine that in practice you won't have running vCPUs during a
>>> reset but the bug exists=2E=C2=A0 Thanks!
>> If it's just kvm_xen_evtchn_reset() I can fix that =E2=80=94 and have t=
o
>> anyway, even if we switch the Xen code to its own lock=2E
>>=20
>> But what is the general case lock ordering rule here? Can other code
>> call synchronize_srcu() while holding kvm->lock? Or is that verboten?
>
>Nope, it's a general rule---and one that would extend to any other lock t=
aken inside srcu_read_lock(&kvm->srcu)=2E
>
>I have sent a patch to fix reset, and one to clarify the lock ordering ru=
les=2E

Can we teach lockdep too?
