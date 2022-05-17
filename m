Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B8B52ACA1
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 22:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349536AbiEQUUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 16:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiEQUUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 16:20:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26F2351E6D
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652818836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7P2mQgNhNUcrdwDpBYwkfJTfzCOi5Z/s8BWNC8jYDjs=;
        b=AkoobAxJINnVHngH1uRurZWbUdX2bQmqZJITxrcvDNgiZ8hIO0DTrqVS3rvW5IbtPUqHAn
        opNmaLRiXZPoROVpPkaZH4nPopaaXNgGBKZw79Ar4N7/IBTkuyK38EHJtmXSYpCYPeWZvM
        hWLKSktgxzLBaJIhZu4RgqgvwO+AbOw=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-al-peeLROgm7nunwVRlwXg-1; Tue, 17 May 2022 16:20:34 -0400
X-MC-Unique: al-peeLROgm7nunwVRlwXg-1
Received: by mail-io1-f70.google.com with SMTP id ay38-20020a5d9da6000000b0065adc1f932bso13130744iob.11
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7P2mQgNhNUcrdwDpBYwkfJTfzCOi5Z/s8BWNC8jYDjs=;
        b=U2pcHj0V36XG4+8fFpWz9e1HpMAqdcvsuJhYWrQrmH6+oqYVZiDfl1i95Aol/BCG6j
         9BPiQW/8GH4zbJp8vRp2BxvNOdMaBT/7FqmdKEO0ob+0NZaMgRePXbfGXzNhtzU4UVsz
         Au1npSTDFOZ14SnKpYxWLmRjoNK12bG11ZIPYPg96npxWejMsoFNNDRkpdqnokMXrw9j
         KLQezRzWWFA3tLI5BL5ARUYW6tJkGwaaPdRDwPYQchSSrIzRdljLNN9ldg2xYhP01HYk
         y5naWdjhY1Gj2mPVvn1lkmSsZ8wYM75+U5LMm1mJR7CiAzdRWpRzPsEvB180iGUMGoi/
         XB0A==
X-Gm-Message-State: AOAM5329yr+WoO0v53020ALv3E3ytss06rDPAywoFCTh7kqo98U9b2NO
        6SSt/oBQBUX1GEmmW4xSCD3oXNDOvL2Ht4cLNvKmCMf4D2o30iQowDd/OQvjUF8yxeCZvX7yvMm
        ghZp1yxEbGGmL
X-Received: by 2002:a05:6e02:1a83:b0:2cf:522a:971c with SMTP id k3-20020a056e021a8300b002cf522a971cmr12478796ilv.282.1652818834262;
        Tue, 17 May 2022 13:20:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygq4OtuhRE5iHBdyNpxg0oovBxKxHYA8nsH9DbqUSfpfbkYiPCA+Ghmvsyhr80QKvqyM3l+w==
X-Received: by 2002:a05:6e02:1a83:b0:2cf:522a:971c with SMTP id k3-20020a056e021a8300b002cf522a971cmr12478785ilv.282.1652818834051;
        Tue, 17 May 2022 13:20:34 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id m7-20020a023c07000000b0032e422d3eeesm18338jaa.68.2022.05.17.13.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:20:33 -0700 (PDT)
Date:   Tue, 17 May 2022 16:20:31 -0400
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
Message-ID: <YoQDjx242f0AAUDS@xz-m1.local>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517190524.2202762-11-dmatlack@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 07:05:24PM +0000, David Matlack wrote:
> +uint64_t perf_test_nested_pages(int nr_vcpus)
> +{
> +	/*
> +	 * 513 page tables to identity-map the L2 with 1G pages, plus a few
> +	 * pages per-vCPU for data structures such as the VMCS.
> +	 */
> +	return 513 + 10 * nr_vcpus;

Shouldn't that 513 magic value be related to vm->max_gfn instead (rather
than assuming all hosts have 39 bits PA)?

If my math is correct, it'll require 1GB here just for the l2->l1 pgtables
on a 5-level host to run this test nested. So I had a feeling we'd better
still consider >4 level hosts some day very soon..  No strong opinion, as
long as this test is not run by default.

> +}

-- 
Peter Xu

