Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA40E66A7C5
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 01:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjANAnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 19:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjANAml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 19:42:41 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311D28B525
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 16:38:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so10895970pjl.0
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 16:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MgBnQ26ItOkyYKiu1oV6JX0ska5GpfEn/0b8SeFBGOs=;
        b=fZz4bsSG6rplxu+/+bbAGu03TpfBRqzSERj11fI9gPC3YiJL/UeAPW98CKZYKTN7Ws
         j53XSFyQZNUTcXaOijVfFvsqXEfJGx6cLcfKMLjiLO/bW7eqi7LulykqxZENOBL1WwJN
         RayxBQjRABfgAcBUTV5MtEdBlwhGdejOfhp+6x1ylwnSaQw5/5CItg/TVLAvnSFoGFQD
         lbGhWsb6A9IEcn0SbTi5gMac6RtBt94MErdTeqH8q/FrYZ43WZq9AALzNfaHFxf2mxJm
         5DgARQXIRLPhEsnlbzOh8dlw4D9+iPLKzKCIvdG2Ml019sB1Ej5N2/v0hQswCEcOzBeL
         65NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgBnQ26ItOkyYKiu1oV6JX0ska5GpfEn/0b8SeFBGOs=;
        b=69FtEE8P3ijnvzHlpaeyKPyQ6AAOZXlnd4G4iK4cqYyQTicfGHxikf5hWPZws25FW0
         wXE1ozR259zPOrd/EGexNh4zA4x2olEDWb6mr0fQzIqrOOZW0XrEze7NQba53Mtsyo1D
         hzArw69Fpx7Qo297Ee2ZtVRcNXIinjvIp5rvYYJ034K+VluM8ct4US+cxGgrnIN7R+jZ
         fMonDXCqBYNOrIt/nDKFN7O+EjTslELc0KUZjSxlKnyGTXb9xjjcoIUwOrS3xMFSW1tK
         63CzjmARfAnFFjTkD2uylNCXePgFhQ15zoUNwjmv+MUsVbxCIKh/GJqi+rKwk+gwUxQA
         TNiA==
X-Gm-Message-State: AFqh2kokum9AVaNxHwQZFwJgVWVGiyFBFAAzAtWkQH/PQC6I+liYlcOY
        Vhy4u1ZLT2ijAhPkMTuAldPbwg==
X-Google-Smtp-Source: AMrXdXvO5lr0leGyzGM7js7Dp/RGVdcEkNK6lyE8EJsgzKqjTO8ro2/W2YgLE7h5m81d74tyNSIgGA==
X-Received: by 2002:a05:6a20:1394:b0:b5:a970:8d5a with SMTP id w20-20020a056a20139400b000b5a9708d5amr2026776pzh.0.1673656683660;
        Fri, 13 Jan 2023 16:38:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d12-20020a634f0c000000b0047829d1b8eesm9871303pgb.31.2023.01.13.16.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 16:38:03 -0800 (PST)
Date:   Sat, 14 Jan 2023 00:37:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Quentin Perret <qperret@google.com>, tabba@google.com,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v10 0/9] KVM: mm: fd-based approach for supporting KVM
Message-ID: <Y8H5Z3e4hZkFxAVS@google.com>
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
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

On Fri, Dec 02, 2022, Chao Peng wrote:
> This patch series implements KVM guest private memory for confidential
> computing scenarios like Intel TDX[1]. If a TDX host accesses
> TDX-protected guest memory, machine check can happen which can further
> crash the running host system, this is terrible for multi-tenant
> configurations. The host accesses include those from KVM userspace like
> QEMU. This series addresses KVM userspace induced crash by introducing
> new mm and KVM interfaces so KVM userspace can still manage guest memory
> via a fd-based approach, but it can never access the guest memory
> content.
> 
> The patch series touches both core mm and KVM code. I appreciate
> Andrew/Hugh and Paolo/Sean can review and pick these patches. Any other
> reviews are always welcome.
>   - 01: mm change, target for mm tree
>   - 02-09: KVM change, target for KVM tree

A version with all of my feedback, plus reworked versions of Vishal's selftest,
is available here:

  git@github.com:sean-jc/linux.git x86/upm_base_support

It compiles and passes the selftest, but it's otherwise barely tested.  There are
a few todos (2 I think?) and many of the commits need changelogs, i.e. it's still
a WIP.

As for next steps, can you (handwaving all of the TDX folks) take a look at what
I pushed and see if there's anything horrifically broken, and that it still works
for TDX?

Fuad (and pKVM folks) same ask for you with respect to pKVM.  Absolutely no rush
(and I mean that).

On my side, the two things on my mind are (a) tests and (b) downstream dependencies
(SEV and TDX).  For tests, I want to build a lists of tests that are required for
merging so that the criteria for merging are clear, and so that if the list is large
(haven't thought much yet), the work of writing and running tests can be distributed.

Regarding downstream dependencies, before this lands, I want to pull in all the
TDX and SNP series and see how everything fits together.  Specifically, I want to
make sure that we don't end up with a uAPI that necessitates ugly code, and that we
don't miss an opportunity to make things simpler.  The patches in the SNP series to
add "legacy" SEV support for UPM in particular made me slightly rethink some minor
details.  Nothing remotely major, but something that needs attention since it'll
be uAPI.

I'm off Monday, so it'll be at least Tuesday before I make any more progress on
my side.

Thanks!
