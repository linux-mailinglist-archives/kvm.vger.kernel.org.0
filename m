Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6147A9D80
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjIUTiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjIUTh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:37:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4642EBFCF
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:10:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59beea5ce93so25729507b3.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695323438; x=1695928238; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=msCRqftjzvMka6Rl5V/NvDEz768neF2Qswneru1ptF4=;
        b=ANIsopKH6FB/YfeeiHhknjvBJ5XAITWb1M/gbs+yBeC/ao6mEHXNiCijAVIw3AUBEu
         /L10qRlBCqsFUCKjuQ13ougwWzehqWocSM7xFbHiwYegbOYJIt/J8GRTSphAAc/IXNxA
         o/QR0WmMt3Rr9/Z8RTFG6WRUg72slcENJ91CRvg4tLf3p19skDGjdSesRMqooJ1TxrwN
         kPhHasmtBgG5lahnT+KGJMN8FxVv+FrAn5x5/Kv9qYOj8nLmDk3goWg8x91Iiv6qr5n8
         fwxGc9VtkPBY6BwtxtcN575WzcMCKX9wO1T2K3HDKmiEMiuIAhwnOqpeTpRRAHJ8OTQF
         ea5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695323438; x=1695928238;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=msCRqftjzvMka6Rl5V/NvDEz768neF2Qswneru1ptF4=;
        b=P25ur8NKGvtTdP9LgWTPesjFQVNoaoyJWk3oEtp2UakQUiLEecoRYzhmv6REN1odUo
         EN4HqZup6FXp78vCv8KkWPMTPdhVlYhW/oXIUn4gXGnbOSoYs4tLy9QLeMyiIsRnrHlR
         DM2xzwD104gkSsVfQcwD21A/LVMr6lbZDvkJh12va/EYzi/9LfIJSDZJZvknJGyWt7lr
         oWJUNN3P/2pl8znqP8wPR3VjwEmfdOv2ZoIBB/6trE7FeauUTN+VEnOCK+bVCXVof5/3
         jri/MH23HB8Of82fW3kgb6gKVUO3uHKj7yTp41bIyDXj3zwkuIC28bFVwR7jj7GRB74T
         1Erg==
X-Gm-Message-State: AOJu0YzrBgIPbzbrfoI6yr7km05LF2erhj9plASJp0vRqA0Uu9TTB004
        BVThbxej0PDBKoXhdWsig9BIaiPvMgM=
X-Google-Smtp-Source: AGHT+IHW881nAqFnjABVXUT4908B5v4pAo/onJespz4HnG5MCVd8NLEq9DsMcDxqDXD3hJb4Zo/K0u0JOVE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:70a:b0:58c:e8da:4d1a with SMTP id
 bs10-20020a05690c070a00b0058ce8da4d1amr8361ywb.2.1695323438500; Thu, 21 Sep
 2023 12:10:38 -0700 (PDT)
Date:   Thu, 21 Sep 2023 12:10:36 -0700
In-Reply-To: <20230914015531.1419405-15-seanjc@google.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-15-seanjc@google.com>
Message-ID: <ZQyVLEKXbpJ9Wvud@google.com>
Subject: Re: [RFC PATCH v12 14/33] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, Sean Christopherson wrote:
>  virt/kvm/guest_mem.c       | 593 +++++++++++++++++++++++++++++++++++++

Getting to the really important stuff...

Anyone object to naming the new file guest_memfd.c instead of guest_mem.c?  Just
the file, i.e. still keep the gmem namespace.

Using guest_memfd.c would make it much more obvious that the file holds more than
generic "guest memory" APIs, and would provide a stronger conceptual connection
with memfd.c.
