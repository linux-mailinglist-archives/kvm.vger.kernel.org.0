Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF667BC7D7
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 14:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbjJGMve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 08:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343929AbjJGMvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 08:51:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E07ECF;
        Sat,  7 Oct 2023 05:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=obdwrwxZYCfd4O2706K9Nbiv4OXDuY3UC+HGjSQEhP8=; b=OqNSPuOdhwJs5PDzpJij286zEc
        teT9k+55Kn0B4cZT2Kl9a+LR8mw6HmEBjluquXc29i9nY3qtU0Pk6KAapRVHd7ooVjnJI+eAzxHbT
        HfFRVTavjwO0Z5lxwuadGAWOBMm97GLitjOmz9K/EZT2pBrXNlwZWVJCqnpRY3dA3b1tQ/B9jGkJu
        b0JkKWFK/TfxB1sxOIz73/73UmwGTs8xrFlSzqf7DhGm4RRh/0bLJvCs9fBXjV5Fv1odyzAmGAM4E
        vSMJsrCseXKsnMlcHIad8JXjybohLzM+RBC2PYP8LSYLIyKzId4vIDLFA1EPZjedpj58LS/zCzAsT
        mtcK9YRQ==;
Received: from [2001:8b0:10b:5:476f:e459:7471:892b] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qp6m8-00DhEa-0F;
        Sat, 07 Oct 2023 12:51:21 +0000
Date:   Sat, 07 Oct 2023 13:51:17 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6=5D_KVM=3A_x86/tsc=3A_Don=27t_sync?= =?US-ASCII?Q?_user-written_TSC_against_startup_values?=
User-Agent: K-9 Mail for Android
In-Reply-To: <9c5274f4-9c8a-2de8-46ed-b3a3268dd6ea@gmail.com>
References: <20230913103729.51194-1-likexu@tencent.com> <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org> <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com> <ZQHLcs3VGyLUb6wW@google.com> <3912b026-7cd2-9981-27eb-e8e37be9bbad@gmail.com> <7c2e14e8d5759a59c2d69b057f21d3dca60394cc.camel@infradead.org> <fbcbbf94-2050-5243-664a-b65b9529070c@gmail.com> <b6661934-53d1-f7ca-d3d6-31b32a2ebb05@gmail.com> <4ACB424D-F9F4-4233-89A4-61CC5B4E5A77@infradead.org> <9c5274f4-9c8a-2de8-46ed-b3a3268dd6ea@gmail.com>
Message-ID: <B2377326-B58D-4D23-9E6E-72C6FB672EB3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7 October 2023 08:29:08 BST, Like Xu <like=2Exu=2Elinux@gmail=2Ecom> wr=
ote:
>On 25/9/2023 4:31=E2=80=AFpm, David Woodhouse wrote:
>>=20
>>=20
>> On 25 September 2023 09:36:47 CEST, Like Xu <like=2Exu=2Elinux@gmail=2E=
com> wrote:
>>> Ping for further comments and confirmation from Sean=2E
>>> Could we trigger a new version for this issue ? Thanks=2E
>>=20
>> I believe you just have a few tweaks to the comments; I'd resend that a=
s v7=2E
>
>OK, thanks=2E
>
>Since I don't seem to have seen V7 yet on the list,
>just let me know if anyone has any new thoughts on this issue=2E

Ah, the end of my sentence was intended to mean, "(if I were you) I (woul)=
d resend that as v7=2E"

I didn't mean to suggest that I was actually going to do so myself=2E So i=
f you didn't post a v7, you won't see it on the list yet :)
