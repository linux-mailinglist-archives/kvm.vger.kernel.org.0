Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706464CC6D2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 21:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiCCUMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 15:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiCCUMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 15:12:50 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF96158E84
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 12:12:05 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id z2so5762083plg.8
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 12:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=74mI5brqou3RUxTj+v2SBWWpS/KYRzu9iwcD5bBTkwY=;
        b=tEQr+tebSKrR5fFwdqe6r21auuROLTSUTl02V6Vp0HbvnjFWZiDdcSMxBSJI3OgGQh
         CL2VlDuK4w1TfodyTflvCweg/f9y6Jifp+8nQHqbIRpjO4H2FSbH1Sq3umM2xgw53Fkc
         cxkxd4SSjOI3vIg6T4OnOBrcngzbz8uawCaErKg5SnTXwryPfeakK+Gzx2cPeM6CeGBQ
         qKVIqdLsjOrRyEQbgF6BS2DerCVhIEzIVO3gFUHGZ+j0FK1mddOtMt9tl6YxbNlbbx0k
         aztRU7/Iy9zIjelzd5tl3M+Q/CJYfP9i6oG133zLaPqUuExGuGO2cwQqgxRQsViqZ3mw
         //ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=74mI5brqou3RUxTj+v2SBWWpS/KYRzu9iwcD5bBTkwY=;
        b=L2egg2OgyMgGyAYkiwxFM3yV6qRf4fL34BglQVEFSRQmvr6GjkVNzV7CGPuxD5rstH
         PUvnPG9AVUulNHWJA7M9pXelp8bveuHKSQ5MFXXzliWr/zxZfDhURz8+XaQG3/iIXjsD
         ji2id3CKZwCBExDN0NBFQ7N8EmE/JEPgTGqWAdSl/p0pcHDGE+NaxNUKZoEB+yHviulN
         OMDxTtCVcHr4HaeJaUUYmmHhPrCbSBFB3ObS378GNkJYHJEZyWNBdIsKPQM7CxDmN7Mh
         TDOn/VG7a1JqHI1DTjgdbz0IhqI5e6LfiK0Tc/gxU/KthEO+hjReZE8GcM5zximlsbmX
         74BQ==
X-Gm-Message-State: AOAM5321/RJVCe5YVYxDKYa+56zbXIyMIgCiBM711WdKLYQi7BaIS1hm
        1YOBAGkwx/6RkBTBlLOvcnPBzQ==
X-Google-Smtp-Source: ABdhPJxpoGdJZNuV5Uv9w+Fr1NUn9u1znC64pYXgJJyWBXyxaOmBT6Lu13femBMXlv3h6k4oHq3DeA==
X-Received: by 2002:a17:902:9687:b0:151:7b31:9a57 with SMTP id n7-20020a170902968700b001517b319a57mr16853363plp.146.1646338324364;
        Thu, 03 Mar 2022 12:12:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 15-20020a63174f000000b00368e62da013sm2736387pgx.56.2022.03.03.12.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 12:12:03 -0800 (PST)
Date:   Thu, 3 Mar 2022 20:12:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 07/30] KVM: x86/mmu: do not allow readers to acquire
 references to invalid roots
Message-ID: <YiEhEJtKyRAVtlRP@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-8-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> Remove the "shared" argument of for_each_tdp_mmu_root_yield_safe, thus ensuring
> that readers do not ever acquire a reference to an invalid root.  After this
> patch, all readers except kvm_tdp_mmu_zap_invalidated_roots() treat
> refcount=0/valid, refcount=0/invalid and refcount=1/invalid in exactly the
> same way.  kvm_tdp_mmu_zap_invalidated_roots() is different but it also
> does not acquire a reference to the invalid root, and it cannot see
> refcount=0/invalid because it is guaranteed to run after
> kvm_tdp_mmu_invalidate_all_roots().
> 
> Opportunistically add a lockdep assertion to the yield-safe iterator.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
