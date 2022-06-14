Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82D054B420
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349086AbiFNPB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355467AbiFNPB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:01:57 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93540904
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i64so8794342pfc.8
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n3Z3Q/k7HSG6exH8gc+Mbf33wGJcooVYy9Jt7VeZHcI=;
        b=QHWQ4B9PyQb/+O8khCkKGr0oaWjZhpgcKi1DRpexHRDSvXnceHXOlYk/XFqoJp3mEn
         l/ofBKuQ91JYiOobjbnwRv4fVFc8e6M8FDiYzKwauqOHw0Fw/pFZUoL7rI8uLOtaivNX
         I8GG+1tkUHT3+nT61vTT8A0vOo/1CSclt1ZFZ5V9uR/WmkFC/tjZMRYh5T/pzn9rbcBj
         efZQQBs2qNq4t1oUVLuoS45krzaKbwF72JOXvG82Pn8a99pxNi9aYbEUT4OaPiWBSt7Z
         rIXHB0ZbPLjshKbe8NrqvHY685MKtIgJUe41q9WaKMa0taz1EJ09+Tmm8vb/1X6rkSNp
         xl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n3Z3Q/k7HSG6exH8gc+Mbf33wGJcooVYy9Jt7VeZHcI=;
        b=Y85b2NJ1ZAchCf5JQj0Sdm4oSMMevhl4OZmXWZf7caxTA7hgW5zA4yQzeETU3DSWHE
         78J5mUZlMuiPrWi+BPO608ql6/7Qw6YUD++Ac4AOhiHTekCdQ+rbk+e6op8L0j2DRf4X
         NynFIP0CVNgMg5daqFhn+SGo3ZRnkyOgCdqWZEhWGU4OIjyXWbou3XFz2cUdN00DFei7
         +sl0bRIA+fwXjQobgGk70cabwILOEqp6hlgMoNxJP/YR8DjAgjincOtS80uBrp+VNuuk
         hFpCmObG/JWUfd2z3saxbkdsY2uoGe8pM3loIS5n99bc2L9iX5mSO4F4BOnqMwKZrW70
         TAAw==
X-Gm-Message-State: AOAM531hHNgwkXInNYAifm52nfC5ExF+7zLoOsk09J/IHSTTycnO3fD9
        IdeCCO6l8OGqDVGPtIfKlifiZA==
X-Google-Smtp-Source: ABdhPJwqbY/FIuqnPZS/XB2QtEVx9V2a5opDXcVaLC9AisFWbCe7pmTcXRBhGD+BGFO+bm3wdv1pyw==
X-Received: by 2002:a65:4809:0:b0:3fc:878:49df with SMTP id h9-20020a654809000000b003fc087849dfmr4882582pgs.557.1655218916110;
        Tue, 14 Jun 2022 08:01:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z15-20020a170903018f00b0015eb200cc00sm7328151plg.138.2022.06.14.08.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:01:55 -0700 (PDT)
Date:   Tue, 14 Jun 2022 15:01:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kernel test robot <lkp@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: Re: [kvm:queue 5/184] arch/x86/kvm/svm/avic.c:913:6: warning: shift
 count >= width of type
Message-ID: <Yqii3+EN1SnQYnMJ@google.com>
References: <202206132237.17DFkdFl-lkp@intel.com>
 <7a5d48d0-d1b5-91aa-8966-54d9ac986126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a5d48d0-d1b5-91aa-8966-54d9ac986126@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022, Paolo Bonzini wrote:
> On 6/13/22 16:49, kernel test robot wrote:
> >     902	
> >     903	bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
> >     904	{
> >     905		ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> >     906				  BIT(APICV_INHIBIT_REASON_ABSENT) |
> >     907				  BIT(APICV_INHIBIT_REASON_HYPERV) |
> >     908				  BIT(APICV_INHIBIT_REASON_NESTED) |
> >     909				  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> >     910				  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> >     911				  BIT(APICV_INHIBIT_REASON_X2APIC) |
> >     912				  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> >   > 913				  BIT(APICV_INHIBIT_REASON_SEV      |
> >     914				  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> >     915				  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED));
> 
> Ouch, saw this right after sending a pull request. :(

KVM_WERROR=y is your friend.  Or in my case, my enemy for the last few days :-D
