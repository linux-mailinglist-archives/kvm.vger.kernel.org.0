Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF46552937F
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348541AbiEPWR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241699AbiEPWR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:17:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E21F2C123
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652739445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=imxTZzYwbTYEuaWIQntGf3CSN6NcONGApVhW3W81C6o=;
        b=P+E2xibsJUjCZoOd4p/CUr/8K5JNFlt/kqk2dNjnOWQveMsMZu+7M3Epxwx8Dy8Lhn4ofs
        kwWy2KdiT+mniNJ7o/doG4FFWhm5Wkl6DZBj5ACLOops3uCn0wC25IuX290Bv35P4VzHZ7
        JdyizbfmlfJfk5ZXiTe6mLjQjnLySv4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-6TojwjReMmaf9CprfXUTOg-1; Mon, 16 May 2022 18:17:24 -0400
X-MC-Unique: 6TojwjReMmaf9CprfXUTOg-1
Received: by mail-io1-f70.google.com with SMTP id l3-20020a05660227c300b0065a8c141580so11232145ios.19
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=imxTZzYwbTYEuaWIQntGf3CSN6NcONGApVhW3W81C6o=;
        b=3xea5QjeuthRwlPgHMvp/D+SNldWKs7N29aiQ9pm+BO0xuM0TQOfiWbz5pVNwGhUeM
         EspEEnmYXtCOcdBT+USox6Aiyln885udITJojgAM9y8iZkDphjX6s/9+DpzwsCy8CtRf
         Ho4Cka9TI2ZD7vFtpuNnFSm6RfrJmyTZWZ8gVfNd35y6bxWb4eMADl3Jb8BQ01icw0Nq
         eaM0eN27hrrs/qqtD7hucCIT2191ECRDmpeDDAp/muUp2f1KCm+enVjEoyIMqXSULDP3
         fkyvjZc4wKgbpPlzNzs0Wsm7wMwWKkuPkmPoaid4MHRAhzzyqSMK383sfBW8IySXXq7s
         fy0Q==
X-Gm-Message-State: AOAM531ftIbMrG/LFk0ACVeyjquCIGzWXdKXcLW4dyGDbmaMKBrk2kft
        MpXB25y+ycZijPN1JaAoHd/20ydjsvE+7uxFH8fSdxhA/kYGvS9GE9hwju8TEzxugKLA+ze1l+r
        Ua5rpCGGXJOSU
X-Received: by 2002:a05:6638:8f:b0:32e:3c8d:be91 with SMTP id v15-20020a056638008f00b0032e3c8dbe91mr2674223jao.174.1652739443384;
        Mon, 16 May 2022 15:17:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzh13JjC225eUDBXEheiply3iyL4EcX+W1a9qGSqrfpG/eEwHo5XSTYsN0V8PMtIbm5+sfV5Q==
X-Received: by 2002:a05:6638:8f:b0:32e:3c8d:be91 with SMTP id v15-20020a056638008f00b0032e3c8dbe91mr2674218jao.174.1652739443201;
        Mon, 16 May 2022 15:17:23 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id z5-20020a02ba05000000b0032b52f27d73sm3133396jan.57.2022.05.16.15.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 15:17:22 -0700 (PDT)
Date:   Mon, 16 May 2022 18:17:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 9/9] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
Message-ID: <YoLNcd1SQMSNdSMb@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-10-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:35PM +0000, David Matlack wrote:
> +static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
> +{
> +#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	unsigned long *rsp;
> +
> +	GUEST_ASSERT(vmx->vmcs_gpa);
> +	GUEST_ASSERT(prepare_for_vmx_operation(vmx));
> +	GUEST_ASSERT(load_vmcs(vmx));
> +	GUEST_ASSERT(ept_1g_pages_supported());
> +
> +	rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
> +	*rsp = vcpu_id;
> +	prepare_vmcs(vmx, perf_test_l2_guest_entry, rsp);

Just to purely ask: is this setting the same stack pointer to all the
vcpus?

> +
> +	GUEST_ASSERT(!vmlaunch());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> +	GUEST_DONE();
> +}

[...]

> +/* Identity map the entire guest physical address space with 1GiB Pages. */
> +void nested_map_all_1g(struct vmx_pages *vmx, struct kvm_vm *vm)
> +{
> +	__nested_map(vmx, vm, 0, 0, vm->max_gfn << vm->page_shift, PG_LEVEL_1G);
> +}

Could max_gfn be large?  Could it consumes a bunch of pages even if mapping
1G only?

Thanks,

-- 
Peter Xu

