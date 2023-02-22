Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE78669FDFF
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 22:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjBVVxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 16:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBVVxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 16:53:21 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CA92279C
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 13:53:20 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5376fa4106eso47972497b3.7
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 13:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vw/kaBZELDn3iRLryB4mmdN5p7w2c/XEDF0NvAc29OA=;
        b=lxoHUtiZD2a0lkFM1BjQCq6yxSLFOIYuWQzolUrNyKa2FSIrxH8LVVfQtq9f5R/afK
         LHQpddlnFrOzOB60DXpCwlJJw63AzRfX5jLu5Id0pSE95MxYIsHOiRMLmY5+eU+D3dNu
         ISieEqZtTt7V23yoxD/xPf7/3fga5CcMm+ewnI7GoqsPeiEDxyu5fgTeEv68la2saMCH
         djvTvh7dGkVnNbuuTGqlzh9NJbQdVF3quszT4E0e+TCktqOo19NSlqE9gEsehIyDyrqF
         4K9oJAEiTWIdzJKlakhzoBeyFOaEj14vWK7iNd4k7zj5V9qLb9MFJbOpw5pQ3v+f49KY
         Vb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vw/kaBZELDn3iRLryB4mmdN5p7w2c/XEDF0NvAc29OA=;
        b=Ejuhhon/9BxKjPrzlwt4nEmv0oyztuC9X662lCD4JKmimfDsNyk4pSfjaEF7sLqzfJ
         Lz0Di9XjdPVVAcxWPd6d6z8zUnvpuCLFrpmAFdcpLHcbQIP+xv65KVgKqFYNLKuXxMot
         jUZ32OjTTBigS7IHD+KeQL7fi1T0BcD48Rbk/kpv4MT+zHMwAzrynun3wlMgezVd8pdp
         Cm4d/heWJ95rHVGcEbAHT5iBT7wHoycp7haavc2DYUnbHEt7iM5sqf2KS5mNNOS1znIs
         MyoPP3JNsThIrg8WbgPXanjj+B4fyJ1f2T/8HuObUIbDBsn2SLgWq09Bx9s5ayVq4cRw
         VxaQ==
X-Gm-Message-State: AO0yUKW2wDFKpoAYMF3nAUiXBkUgv6W7fPc67kEXgYXfjIL3h+OS7eb2
        zBDFOyIdcYATHFb1CBt4PIm42myaiEo=
X-Google-Smtp-Source: AK7set94YqDAGISpJ88nU9GpVOq8HahVScAJcl3isAOv812VxstdjXukBVCA+QkJjTDNRjuqp0jo+ZxoQ0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1183:b0:a27:3ecc:ffe7 with SMTP id
 m3-20020a056902118300b00a273eccffe7mr460686ybu.3.1677102799291; Wed, 22 Feb
 2023 13:53:19 -0800 (PST)
Date:   Wed, 22 Feb 2023 13:53:17 -0800
In-Reply-To: <62c84fa8-d7c4-5163-fe1e-f2c7e5a2c7aa@redhat.com>
Mime-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <Y+27kRxJoXlMcbtH@kernel.org> <62c84fa8-d7c4-5163-fe1e-f2c7e5a2c7aa@redhat.com>
Message-ID: <Y/aOzY15UmR+zDpQ@google.com>
Subject: Re: [PATCH v10 0/9] KVM: mm: fd-based approach for supporting KVM
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
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
        Shuah Khan <shuah@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        mhocko@suse.com, wei.w.wang@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023, David Hildenbrand wrote:
> On 16.02.23 06:13, Mike Rapoport wrote:
> > Hi,
> > 
> > On Fri, Dec 02, 2022 at 02:13:38PM +0800, Chao Peng wrote:
> > > This patch series implements KVM guest private memory for confidential
> > > computing scenarios like Intel TDX[1]. If a TDX host accesses
> > > TDX-protected guest memory, machine check can happen which can further
> > > crash the running host system, this is terrible for multi-tenant
> > > configurations. The host accesses include those from KVM userspace like
> > > QEMU. This series addresses KVM userspace induced crash by introducing
> > > new mm and KVM interfaces so KVM userspace can still manage guest memory
> > > via a fd-based approach, but it can never access the guest memory
> > > content.
> > 
> > Sorry for jumping late.
> > 
> > Unless I'm missing something, hibernation will also cause an machine check
> > when there is TDX-protected memory in the system. When the hibernation
> > creates memory snapshot it essentially walks all physical pages and saves
> > their contents, so for TDX memory this will trigger machine check, right?

For hibernation specifically, I think that should be handled elsewhere as hibernation
is simply incompatible with TDX, SNP, pKVM, etc. without paravirtualizing the
guest, as none of those technologies support auto-export a la s390.  I suspect
the right approach is to disallow hibernation if KVM is running any protected guests.

> I recall bringing that up in the past (also memory access due to kdump,
> /prov/kcore) and was told that the main focus for now is preventing
> unprivileged users from crashing the system, that is, not mapping such
> memory into user space (e.g., QEMU). In the long run, we'll want to handle
> such pages also properly in the other events where the kernel might access
> them.

Ya, unless someone strongly objects, the plan is to essentially treat "attacks"
from privileged users as out of to scope for initial support, and then iterate
as needed to fix/enable more features.

FWIW, read accesses, e.g. kdump, should be ok for TDX and SNP as they both play
nice with "bad" reads.  pKVM is a different beast though as I believe any access
to guest private memory will fault.  But my understanding is that this series
would be a big step forward for pKVM, which currently doesn't have any safeguards.
