Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96F54E9EBE
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 20:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245121AbiC1SQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 14:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238455AbiC1SQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 14:16:52 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24E6443F8
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:15:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i11so15393610plr.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yx9kLPZnDKhG+ivFoq+Z75QS1wPbQ4/wxiiI/bt3KCk=;
        b=BTPpWTU8xrIwoxNqU6R1SSY0gPXLBH+zjlrIdX/FdmWY88Uj0bMGhuiEPCRpNq794v
         TB3d6mGf0oczE0OzBTfSNngIUHBFcfRbJvzVl6w4k7sBIziwW/A6CCsTDRMNdPpVSsVq
         JE5xGaF3bi7sLoGDWWg9L7lyMuX/Gi2LyW7sQG34e4NeAAh9M75FVZN7lZe36yHNivVp
         VaRoHiYlDBkxao5T6kbaNsY4O15oyN2NClhmmqZq/gxx2UmRid59HwKLcKZYj77aTZc3
         D13YfxDBj346PkTGdKndOIxCFIHEhROiPEGagSCxXpcdqrW7ssGDTg/Ne1mdyIxGXa9f
         mOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yx9kLPZnDKhG+ivFoq+Z75QS1wPbQ4/wxiiI/bt3KCk=;
        b=PElhV8jtQgbmUhJmpE+cg+EXfo8vRHeEOk4bY60Q7IJfpvnrOhnipBHhQlRkCB1hlp
         WLU8H/aSCKXfw7PKIQZGGGBx/MJdzkWSHff3VvA9ot9y1pB6iZEIibeCFAJYCAxOG68H
         x/5C0/sgWRvF0TlGUDJlxt8DXyl0pMGUAKVBoxjlOJWyq3zwj/ySbx7QSHGoEy6njfFJ
         O7jy6gyy+83nXuRoBwm6yONpcFVm/2LOshS2IT9E+qSv5xNvD/BOerE4mNsVRXfITDlr
         /WEO2DiNqhHt6hLG/aaIKB+w/nIx4QN4xmxYErDdRAfvjD1zfHCMfqVKylRFPF8N3GU8
         BiNw==
X-Gm-Message-State: AOAM532ciW6V1ZaTeOoIbn9fBZe+eUp1zDJBBv/t8NyjnXkC8iI2g6n0
        N8/4CnOu3BWEa6XPkNcUcf+RFQ==
X-Google-Smtp-Source: ABdhPJyxl/grzo9wrN4NyoMupFLzcrY8lyyPwkdDjRKFBM0KgUaIFFSabfBfzkW8SlJl1Ha/MHGT9g==
X-Received: by 2002:a17:90a:3b06:b0:1c6:7140:348d with SMTP id d6-20020a17090a3b0600b001c67140348dmr418330pjc.99.1648491310293;
        Mon, 28 Mar 2022 11:15:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm18399890pfl.141.2022.03.28.11.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:15:09 -0700 (PDT)
Date:   Mon, 28 Mar 2022 18:15:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before
 lookup_address_in_mm()
Message-ID: <YkH7KZbamhKpCidK@google.com>
References: <20220327205803.739336-1-mizhang@google.com>
 <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022, Mingwei Zhang wrote:
> With that, I start to feel this is a bug. The issue is just so rare
> that it has never triggered a problem.
>
> lookup_address_in_mm() walks the host page table as if it is a
> sequence of _static_ memory chunks. This is clearly dangerous.

Yeah, it's broken.  The proper fix is do something like what perf uses, or maybe
just genericize and reuse the code from commit 8af26be06272
("perf/core: Fix arch_perf_get_page_size()).

> But right now,  kvm_mmu_max_mapping_level() are used in other places
> as well: kvm_mmu_zap_collapsible_spte(), which does not satisfy the
> strict requirement of walking the host page table.

The host pfn size is used only as a hueristic, so false postives/negatives are
ok, the only race that needs to be avoided is dereferencing freed page table
memory.  lookup_address_in_pgd() is really broken because it doesn't even ensure
a given PxE is READ_ONCE().  I suppose one could argue the caller is broken, but
I doubt KVM is the only user that doesn't provide the necessary protections.
