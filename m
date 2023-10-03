Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E857B6530
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjJCJOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjJCJOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 05:14:30 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89985B4;
        Tue,  3 Oct 2023 02:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=3fkeKLu8eKsK/dT8AEb6sGG8jQihJxdjqGhWs7rpjjo=; b=dcIgzB49dsVS4CJ4I13EIALnoH
        xwjOHX2P+qvbaPZ4imstnQaHVFHiw8eibyGT8BpPoP5/FsDAd/IkGmPBuULL3MwaGI5o4J9/kx4nq
        EHBqPbtScHTE6/DF4Rvb8cH7eANHI5A1EtSurce1kIGblPvfNsFZDqBx4/Fp3/AOjJYrqui+YAiMT
        gjbQ5DnNhnE5j+k8IkA+UgXryxJoil+v+K/2LDh0vAwvDqRw/TBAwgUXF5926d7wislBnXxNaI2am
        RIwTy4Nf5TzW9SWYAX0nxo0YdcQTbxUX3h1H1fYf07D5zA6r99xfSUPsLM6bQETreGysoy2gtZhb0
        LE0KFDxw==;
Received: from [2a00:23ee:1830:6abb:c7c0:8714:54ca:8840] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qnbRt-009m9t-03;
        Tue, 03 Oct 2023 09:14:17 +0000
Date:   Tue, 03 Oct 2023 10:12:09 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC_1/1=5D_KVM=3A_x86=3A_add_par?= =?US-ASCII?Q?am_to_update_master_clock_periodically?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ZRtl94_rIif3GRpu@google.com>
References: <20230926230649.67852-1-dongli.zhang@oracle.com> <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com> <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com> <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org> <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org> <ZRtl94_rIif3GRpu@google.com>
Message-ID: <20EAA3C4-A9F4-4EC1-AE0C-D540CC2E024A@infradead.org>
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



On 3 October 2023 01:53:11 BST, Sean Christopherson <seanjc@google=2Ecom> =
wrote:
>I think there is still use for synchronizing with the host's view of time=
, e=2Eg=2E
>to deal with lost time across host suspend+resume=2E
>
>So I don't think we can completely sever KVM's paravirt clocks from host =
time,
>at least not without harming use cases that rely on the host's view to ke=
ep
>accurate time=2E  And honestly at that point, the right answer would be t=
o stop
>advertising paravirt clocks entirely=2E
>
>But I do think we can address the issues that Dongli and David are obvers=
ing
>where guest time drifts even though the host kernel's base time hasn't ch=
anged=2E
>If I've pieced everything together correctly, the drift can be eliminated=
 simply
>by using the paravirt clock algorithm when converting the delta from the =
raw TSC
>to nanoseconds=2E
>
>This is *very* lightly tested, as in it compiles and doesn't explode, but=
 that's
>about all I've tested=2E

Hm, I don't think I like this=2E

You're making get_monotonic_raw() not *actually* return the monotonic_raw =
clock, but basically return the kvmclock instead? And why? So that when KVM=
 attempts to synchronize the kvmclock to the monotonic_raw clock, it gets t=
ricked into actually synchronizing the kvmclock to *itself*?

If you get this right, don't we have a fairly complex piece of code that h=
as precisely *no* effect?=20

Can't we just *refrain* from synchronizing the kvmclock to *anything*, in =
the CONSTANT_TSC case? Why do we do that anyway?

(Suspend/resume, live update and live migration are different=2E In *those=
* cases we may need to preserve both the guest TSC and kvmclock based on ei=
ther the host TSC or CLOCK_TAI=2E But that's different=2E)
