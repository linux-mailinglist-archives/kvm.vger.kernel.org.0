Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB291510DD4
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356647AbiD0BTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiD0BTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:19:47 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5BF2E6B1
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:16:38 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s14so289122plk.8
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6jFJtCmRVi276uO+VGW/oZwgeFrr/SjrfPgb9kCh74I=;
        b=Ejd4R30p2LtyMa6p1euHblC5a1PVQG8JIbo3FgFvBREIipq68XnWsPcVw3rbNVlVRa
         CYj87Ri/LwP/YWntee2iUJqvqxwWFM3jAusTkeJfiv8yq9O8OvyGsQgrTL1UTj05O+km
         YacRIRrHQGJ+covG3L+RjDcC0IcLAAm0+KNZh2/AQ5bDgpj9Inpi9my7dWTK3D3NjLFC
         Xw7p+j7POZgPmFxHPIO0N/CnNquhCXal967FLD6DN355ExH/wgFEaziKN8XZCjlKTESm
         X7zL532ggJvHsq5PEf+o9o5LDBz2JSjOcZrYR1bcVR2VzLSGPRkQXIm5pk4pF5ubp6Nn
         hycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6jFJtCmRVi276uO+VGW/oZwgeFrr/SjrfPgb9kCh74I=;
        b=PdYDDsxZHcHszB+DOyhh5Phcefg/7wJWkdH9Z7IIXwR/aZN2pYcKt/qUPsxBfFpQJF
         ODPSKJCiLs8S7uEVQIBZeinXW7+gyA2vFG9sW1nTwRXJnPuzkqhR+bKSDLzfr+UT8zBs
         odGkQweEKPNdw2vm3h9fH0MMHcRqAXzMH8I/Di+V/HMk0JeM97GzU9WYrSrM29xGpPVT
         rlqOuhII1z1ttP4gW7mSiqvY2M5wBgWyOARmAM8gaIE0ZC/idYzp/7MGdbqKx2adzImz
         bEjAXqS9k1LHAvMVOvJc+fUoZCBrN8yCH3vgDyzjBqjYMMD80QYDX3hF3RfvYeQNExJ2
         aUPA==
X-Gm-Message-State: AOAM532+BWmwUe/sMtx1iIGBQZ4NTx5nmpn2AYCgHCBSr4CBJFHhJria
        BxMgY/GoCWTg3pFuqb36K75Weg==
X-Google-Smtp-Source: ABdhPJyJeG+jCHswMiFsLr+KMoQRT+wuqnbu0rLT1G337/GLjVem5pDjXGgenb11IZ0toAkWne8LxA==
X-Received: by 2002:a17:90a:d3d1:b0:1bb:fdc5:182 with SMTP id d17-20020a17090ad3d100b001bbfdc50182mr41137810pjw.206.1651022197458;
        Tue, 26 Apr 2022 18:16:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a637204000000b00398522203a2sm14599905pgc.80.2022.04.26.18.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:16:36 -0700 (PDT)
Date:   Wed, 27 Apr 2022 01:16:33 +0000
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
Message-ID: <YmiZcZf9YXxMVcfx@google.com>
References: <20220327205803.739336-1-mizhang@google.com>
 <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com>
 <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
 <Ymg1lzsYAd6v/vGw@google.com>
 <CAL715WK8-cOJWK+iai=ygdOTzPb-QUvEwa607tVEkmGOu3gyQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WK8-cOJWK+iai=ygdOTzPb-QUvEwa607tVEkmGOu3gyQA@mail.gmail.com>
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

On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > I completely agree that lookup_address() and friends are unnecessarily fragile,
> > but I think that attempting to harden them to fix this KVM bug will open a can
> > of worms and end up delaying getting KVM fixed.
> 
> So basically, we need to:
>  - choose perf_get_page_size() instead of using any of the
> lookup_address*() in mm.
>  - add a wrapper layer to adapt: 1) irq disabling/enabling and 2) size
> -> level translation.
> 
> Agree?

Drat, I didn't see that it returns the page size, not the level.  That's a bit
unfortunate.  It definitely makes me less averse to fixing lookup_address_in_pgd()

Hrm.  I guess since we know there's at least one broken user, and in theory
fixing lookup_address_in_pgd() should do no harm to users that don't need protection,
it makes sense to just fix lookup_address_in_pgd() and see if the x86 maintainers
push back.
