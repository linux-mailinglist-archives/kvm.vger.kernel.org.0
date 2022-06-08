Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B8D5432BB
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbiFHOio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241587AbiFHOil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:38:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BB9812D172
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 07:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654699119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rutOmktasjwV4HOl7UXvH/z+BMbngERH3yOeS84tcJs=;
        b=LYN+DLb0Bkn6iYGo93Lv/texF9jGSjWImWNRBkdIyY2ykGv3AuQyVrzEZCiDknXHFOec2T
        /jCj+TyTjFVBC6bmN4TdV49gpWaNHQBAK9dUsyEbFN2sFTYRnHi23pgY5vLn8soZ3fQucq
        mUFb/h7wZEycBXVMHrfnoRNSM6c0NoU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-FfORUhHSOuOJgGWR-a5sBA-1; Wed, 08 Jun 2022 10:38:38 -0400
X-MC-Unique: FfORUhHSOuOJgGWR-a5sBA-1
Received: by mail-wr1-f71.google.com with SMTP id u18-20020adfb212000000b0021855847651so1323069wra.6
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 07:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rutOmktasjwV4HOl7UXvH/z+BMbngERH3yOeS84tcJs=;
        b=TNJT57xCSm1Ivww7Xa+xWhStG7s2Pd6XOG1lY1LGjP5MaiBRakHHoFPjW/lit3FocQ
         MhjBfkcT8j9Rd0EzXdYxxPBXV+D9Nnr2ytR3irg+/dVeO18l9OK6bpgwkRvHPkOZZA7q
         cACCi/eYO496zvmF/cLVDVwckB/VLhOM+6/uth3x/LXwTSHUolHnZbFAqD5NRcp8KCP2
         RltmLjnUoHMYoWIEMhu18BDItLSVeFnj/qxkVexsJm9fVebTipojB5UxHau1wULsoB0c
         pm/AX19UXjBR5/Q48t6P8x1XvXtyQzc73HBBrEGIxDNm1C9nu2tqZWHkoojMmkQuHLQn
         Uj+A==
X-Gm-Message-State: AOAM533RzzULkDJJ8ALDtgDmFONHRUPRnuEkUK+Md1un8TdJD1tptjkK
        njpWYeaRAHdMa6MTVOZYEwD3hypSow5xEaZW12H055srRmOBoC557E2zJA8spKGFTH5Jn+wjf/M
        qWPSS3lOJHkQ8
X-Received: by 2002:a1c:f314:0:b0:397:10a5:a355 with SMTP id q20-20020a1cf314000000b0039710a5a355mr35239225wmq.176.1654699117375;
        Wed, 08 Jun 2022 07:38:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRvEiZ3/11/o3JSbjmUEfu7+YYcdqjV0aJCIeBeXUTk7NEY8qk0uY4fnClcJYUh7Q0nmi+bg==
X-Received: by 2002:a1c:f314:0:b0:397:10a5:a355 with SMTP id q20-20020a1cf314000000b0039710a5a355mr35239207wmq.176.1654699117199;
        Wed, 08 Jun 2022 07:38:37 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id r19-20020a05600c35d300b0039c2e2d0502sm21813780wmq.4.2022.06.08.07.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 07:38:35 -0700 (PDT)
Date:   Wed, 8 Jun 2022 16:38:28 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 038/144] KVM: selftests: Push
 vm_adjust_num_guest_pages() into "w/o vCPUs" helper
Message-ID: <20220608143828.b7ggvuptlngmnqvp@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-39-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-39-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:41:45AM +0000, Sean Christopherson wrote:
> Move the call to vm_adjust_num_guest_pages() from vm_create_with_vcpus()
> down into vm_create_without_vcpus().  This will allow a future patch to
> make the "w/o vCPUs" variant the common inner helper, e.g. so that the
> "with_vcpus" helper calls the "without_vcpus" helper, instead of having
> them be separate paths.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1c5caf2ddca4..6b0b65c26d4d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -282,6 +282,8 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
>  {
>  	struct kvm_vm *vm;
>  
> +	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);

Hi Sean,

We should pass 'mode' here.

Thanks,
drew

> +
>  	vm = __vm_create(mode, pages);
>  
>  	kvm_vm_elf_load(vm, program_invocation_name);
> @@ -341,8 +343,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  		    "nr_vcpus = %d too large for host, max-vcpus = %d",
>  		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
>  
> -	pages = vm_adjust_num_guest_pages(mode, pages);
> -
>  	vm = vm_create_without_vcpus(mode, pages);
>  
>  	for (i = 0; i < nr_vcpus; ++i) {
> -- 
> 2.36.1.255.ge46751e96f-goog
> 

