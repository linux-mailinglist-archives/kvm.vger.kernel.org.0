Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33B752BD2E
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiERNwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiERNwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:52:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AB7019FB31
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 06:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652881922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EKw4iy3BMuqDoyggmUTxBRT/GHkx+aBTY4EpUYLbSQ=;
        b=afV5YJiXMEDv+tR6LBqmRiwprp769Bf/aGyjPO+T+60sbv0vEI/Q3hECFtRzUkUfJjG+de
        GKjaFdglitacQQFPjYYfKr/xeo0Z+VMbUqVvCoXoSJCS4Wn7sw1zMJ2LpxflJtGoFkQtSF
        4DOa52siWoXaV8uXrCNPcMYLfdNecnM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-1niOc7LfMru6LbSYTo48Yg-1; Wed, 18 May 2022 09:52:01 -0400
X-MC-Unique: 1niOc7LfMru6LbSYTo48Yg-1
Received: by mail-il1-f198.google.com with SMTP id i11-20020a056e02152b00b002d115c069efso1282973ilu.22
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 06:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0EKw4iy3BMuqDoyggmUTxBRT/GHkx+aBTY4EpUYLbSQ=;
        b=psgfPpDu+kSurkLWXhRC97IATXle86WZ/vdHYJQXk6ErcY0v80eTv+mXy/BRTae69l
         f61RCNKEqI+RnzRK+d8MOhiPg8R+m6JXpc74c/tKUelaG5evkZYYwBKXCDx9nmSh75fB
         TM+CbwVUqvCHT0KYP+r+eoN1p3Bi/1ac6ZvedtNcXcc52cAymvCs3xXL36AOYzeN2+ny
         yLB7bk+w5fFIgz72CaibqplPi4Rr1cPfA76D9rS9GRGEcaD650hi6MJ3eN5U8VKQ7CtB
         4N/7k44ph/hSGsw5JSWkz1r54gQET7/NXA13krL9a0Fys8/f9tEqiFAuvehxikcFGeXI
         SToA==
X-Gm-Message-State: AOAM533rfKiXc1tgbeD2L+BP/M2Aql2kws5v6Y2GdAruIu81QYwVIVon
        AXPMZyDwvrjJzgowXDsuLrun8i1QUoazs0dLTJmwoQjBMPzFEnhH/XdOdrpQtVYYMbDpyyRfQTH
        oSlqlVB5iA+Oe
X-Received: by 2002:a05:6638:3287:b0:32b:5df3:c515 with SMTP id f7-20020a056638328700b0032b5df3c515mr14831756jav.48.1652881919948;
        Wed, 18 May 2022 06:51:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI2weGvexl+W6I5Ot2sdfIJuiSvrQCvVGofefHGGIcHKo7Eoy8+/9xC61H/TSQ1YI6vOvobw==
X-Received: by 2002:a05:6638:3287:b0:32b:5df3:c515 with SMTP id f7-20020a056638328700b0032b5df3c515mr14831749jav.48.1652881919719;
        Wed, 18 May 2022 06:51:59 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id d41-20020a026069000000b0032b5f1108a5sm525626jaf.131.2022.05.18.06.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:51:59 -0700 (PDT)
Date:   Wed, 18 May 2022 09:51:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
Message-ID: <YoT5/TRyA/QKTsqL@xz-m1.local>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-11-dmatlack@google.com>
 <YoQDjx242f0AAUDS@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YoQDjx242f0AAUDS@xz-m1.local>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 04:20:31PM -0400, Peter Xu wrote:
> On Tue, May 17, 2022 at 07:05:24PM +0000, David Matlack wrote:
> > +uint64_t perf_test_nested_pages(int nr_vcpus)
> > +{
> > +	/*
> > +	 * 513 page tables to identity-map the L2 with 1G pages, plus a few
> > +	 * pages per-vCPU for data structures such as the VMCS.
> > +	 */
> > +	return 513 + 10 * nr_vcpus;
> 
> Shouldn't that 513 magic value be related to vm->max_gfn instead (rather
> than assuming all hosts have 39 bits PA)?
> 
> If my math is correct, it'll require 1GB here just for the l2->l1 pgtables
> on a 5-level host to run this test nested. So I had a feeling we'd better
> still consider >4 level hosts some day very soon..  No strong opinion, as
> long as this test is not run by default.

I had a feeling that when I said N level I actually meant N-1 level in all
above, since 39 bits are for 3 level not 4 level?..

Then it's ~512GB pgtables on 5 level?  If so I do think we'd better have a
nicer way to do this identity mapping..

I don't think it's very hard - walk the mem regions in kvm_vm.regions
should work for us?

-- 
Peter Xu

