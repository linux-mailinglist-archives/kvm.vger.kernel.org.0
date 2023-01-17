Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DB66E0C4
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 15:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjAQOdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 09:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjAQOdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 09:33:00 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C813C2A3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 06:32:58 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id x40so2327937lfu.12
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 06:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7yhLGsprr4iGbKzba+JN1VXXF3TeC3cedN8+F9epKwY=;
        b=BWKfON0ONcZ0E/73kUupX7eOFbsTtnf5zb0RLvmJL0YAhZl6oEvSZL3c/NoN0rNReU
         TIh5gjrwA6Bj/3YkDzJiL+Gls11L2i8ze76yowGZvwzeuvcwTzbo+PdTF5RRopZcOu67
         rqK/5DXAz0Cu8iK48baqurCP3Q8SHLQ3+La3MGi7OSiOLM50rap2pv9+NepuA7fvXVkZ
         JbAIYTYmlyf3SaXzCtregYhzAezlqMgzZgLa7aRWrX3Ls8Vi1NxO2mSedec1z7gAhtZm
         CjRS/N1ff7V0fQ/RSJMzu/O50kqFBmQcx8Ep1MMWXZfAdBITG7gqeNKqSuVwb7ryK8UD
         4kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7yhLGsprr4iGbKzba+JN1VXXF3TeC3cedN8+F9epKwY=;
        b=WOYvW/9i7P33ImscKyKf9OLQO69mhWOl7V0nDK2aD2KSC4z08iyxpLuo3SMyxkzQ9g
         wwNtFObtRBqWeRCWliAm9QBzVr9Ib7YWUZINFHCHgI+ggCwwGAE75In5vbE2/C/KM73b
         5z1hBSaL9/5Gh2XiKyrO/6D/5iR9RCmHFcLoPcVlKrWyE7eT4ay3WS3obDce9sMv9k5B
         sv8+PTDvEEo25vbeMTz9aJuETsIVrG7cN/ls2k6CaOnDViaJqlAKpSkKfaNivOk/2Fav
         ghK44UP3hPv7EWuP3QomG8ZkN4jc7JbzojGJM6+XCmDnI57eLqlTqLhVSrMTzjO/Pk6F
         ygsQ==
X-Gm-Message-State: AFqh2kofx76NjDjNyKpLExMnBZeiHR5dDne2LBkYRl4y+brPPiOaGHDD
        AW8+Xdb2LYV7Bcdn194HP5Vg1L5sPT70KcmMGKY3Ew==
X-Google-Smtp-Source: AMrXdXsPS/EHa9ll4sjoGtdooNfVuEuQvNaydQDhDfaDKMnyvvZ6mWGGNpzl0ThBONl2d+/I1rYOtZu/xqsiIx9Cz3Y=
X-Received: by 2002:a05:6512:3b9b:b0:4d5:850a:8330 with SMTP id
 g27-20020a0565123b9b00b004d5850a8330mr128086lfv.665.1673965976657; Tue, 17
 Jan 2023 06:32:56 -0800 (PST)
MIME-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com> <Y8H5Z3e4hZkFxAVS@google.com>
In-Reply-To: <Y8H5Z3e4hZkFxAVS@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 17 Jan 2023 14:32:19 +0000
Message-ID: <CA+EHjTyVfm5L0kch2rT1HwaDHjVOxnZozV2PKWViKY00igHawg@mail.gmail.com>
Subject: Re: [PATCH v10 0/9] KVM: mm: fd-based approach for supporting KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com, aarcange@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        wei.w.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Sat, Jan 14, 2023 at 12:38 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Dec 02, 2022, Chao Peng wrote:
> > This patch series implements KVM guest private memory for confidential
> > computing scenarios like Intel TDX[1]. If a TDX host accesses
> > TDX-protected guest memory, machine check can happen which can further
> > crash the running host system, this is terrible for multi-tenant
> > configurations. The host accesses include those from KVM userspace like
> > QEMU. This series addresses KVM userspace induced crash by introducing
> > new mm and KVM interfaces so KVM userspace can still manage guest memory
> > via a fd-based approach, but it can never access the guest memory
> > content.
> >
> > The patch series touches both core mm and KVM code. I appreciate
> > Andrew/Hugh and Paolo/Sean can review and pick these patches. Any other
> > reviews are always welcome.
> >   - 01: mm change, target for mm tree
> >   - 02-09: KVM change, target for KVM tree
>
> A version with all of my feedback, plus reworked versions of Vishal's selftest,
> is available here:
>
>   git@github.com:sean-jc/linux.git x86/upm_base_support
>
> It compiles and passes the selftest, but it's otherwise barely tested.  There are
> a few todos (2 I think?) and many of the commits need changelogs, i.e. it's still
> a WIP.
>
> As for next steps, can you (handwaving all of the TDX folks) take a look at what
> I pushed and see if there's anything horrifically broken, and that it still works
> for TDX?
>
> Fuad (and pKVM folks) same ask for you with respect to pKVM.  Absolutely no rush
> (and I mean that).

Thanks for sharing this. I've had a look at the patches, and have
ported them to work with pKVM. At a high level, the new interface
seems fine and it works with the arm64/pKVM port. I have a couple of
comments regarding some of the details, but they can wait until v11 is
posted.

Cheers,
/fuad



> On my side, the two things on my mind are (a) tests and (b) downstream dependencies
> (SEV and TDX).  For tests, I want to build a lists of tests that are required for
> merging so that the criteria for merging are clear, and so that if the list is large
> (haven't thought much yet), the work of writing and running tests can be distributed.
>
> Regarding downstream dependencies, before this lands, I want to pull in all the
> TDX and SNP series and see how everything fits together.  Specifically, I want to
> make sure that we don't end up with a uAPI that necessitates ugly code, and that we
> don't miss an opportunity to make things simpler.  The patches in the SNP series to
> add "legacy" SEV support for UPM in particular made me slightly rethink some minor
> details.  Nothing remotely major, but something that needs attention since it'll
> be uAPI.
>
> I'm off Monday, so it'll be at least Tuesday before I make any more progress on
> my side.
>
> Thanks!
