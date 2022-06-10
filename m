Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D40254649D
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 12:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349204AbiFJKwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 06:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349044AbiFJKwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 06:52:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A82D305444
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 03:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654858136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CWkh+WwrOXy+lr72hI3IJZ1D1qWbN8stgCGKeJESz34=;
        b=gGq4dDHqSufI7C9l1JOdGZ/CCHcFxjqbsXRN1w5jAtKPj2NMJ8ws/iPaoNCnLSrCN7z8Iy
        SiQZwcgmriQLUbwbi3R6tconEK74STg/rWIUi8JkFnCdZA3CVRjAQYjEdP+UhQSM3dJoS5
        oxfhMkZP3p5ZdvaQe3Uh5x6xrRMdLFg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134--I4Fxo28NiWOVxFIIWP4Hg-1; Fri, 10 Jun 2022 06:48:55 -0400
X-MC-Unique: -I4Fxo28NiWOVxFIIWP4Hg-1
Received: by mail-wr1-f70.google.com with SMTP id r13-20020adff10d000000b002160e9d64f8so4606171wro.0
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 03:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CWkh+WwrOXy+lr72hI3IJZ1D1qWbN8stgCGKeJESz34=;
        b=Oj+S4Nx339Vp1mqJnJ24QJHxk0QaSgv61/L5NA2XCBEqtrCPLDYdyG3Bi4qowceXwt
         Q+qz5wF5NuL30/whKFIXogCSV6Nr/GcYXyQMJnWGYA+fu+fvm0UFtyDLfWchu7O/B3D1
         Vh01GFeFQNJ1x+CE7Xy5SiubAluadd7wOkAsXK2WI09vHSkKlRp1kCPs02wvI2hyO3p8
         MdU4mwswwozbvGRYNKXJkjSktooDlx0lFf82GfimH46/kojK3fCGR6Fv7MFn7UGqtKGP
         h6dXQ0GjU1ErIr5pg9ywtWWdQzYOaN53MsRv8yPVxK6tTiTHwmWQ1YWAgp7eq2KqxHk+
         AS7Q==
X-Gm-Message-State: AOAM530W+VkHBa3xzzZ6gwXP1NoU9ADH2qdZfkWG3PpgPcNNycw0OoT+
        OYWKUohedA8UbP6ztdlGo+TnmZTdRJNG5fkWbYD0p2iSQ73+FVg1mQvi1mdEUJyxK14ppMpLfHV
        mJUynZYwAei+4
X-Received: by 2002:a7b:c310:0:b0:38c:f07a:e10d with SMTP id k16-20020a7bc310000000b0038cf07ae10dmr8284541wmj.110.1654858134639;
        Fri, 10 Jun 2022 03:48:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0W/iRnqZGok+Dtln1QGHn4dkyrs5LOr4eKgyWhEe1ws2y4/hUtrhhuo/t9QkujNnxNRICuw==
X-Received: by 2002:a7b:c310:0:b0:38c:f07a:e10d with SMTP id k16-20020a7bc310000000b0038cf07ae10dmr8284516wmj.110.1654858134365;
        Fri, 10 Jun 2022 03:48:54 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id d12-20020adff2cc000000b00215859413f3sm20414628wrp.107.2022.06.10.03.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 03:48:53 -0700 (PDT)
Date:   Fri, 10 Jun 2022 12:48:51 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 126/144] KVM: selftests: Convert kvm_binary_stats_test
 away from vCPU IDs
Message-ID: <20220610104851.g2r6yzd6j22xod6m@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-127-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-127-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:43:13AM +0000, Sean Christopherson wrote:
> Track vCPUs by their 'struct kvm_vcpu' object in kvm_binary_stats_test,
> not by their ID.  The per-vCPU helpers will soon take a vCPU instead of a
> VM+vcpu_id pair.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/kvm_binary_stats_test.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 407e9ea8e6f3..dfc3cf531ced 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -172,9 +172,9 @@ static void vm_stats_test(struct kvm_vm *vm)
>  	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
>  }
>  
> -static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> +static void vcpu_stats_test(struct kvm_vcpu *vcpu)
>  {
> -	int stats_fd = vcpu_get_stats_fd(vm, vcpu_id);
> +	int stats_fd = vcpu_get_stats_fd(vcpu->vm, vcpu->id);
>  
>  	stats_test(stats_fd);
>  	close(stats_fd);
> @@ -195,6 +195,7 @@ static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
>  int main(int argc, char *argv[])
>  {
>  	int i, j;
> +	struct kvm_vcpu **vcpus;
>  	struct kvm_vm **vms;
>  	int max_vm = DEFAULT_NUM_VM;
>  	int max_vcpu = DEFAULT_NUM_VCPU;
> @@ -220,17 +221,21 @@ int main(int argc, char *argv[])
>  	/* Create VMs and VCPUs */
>  	vms = malloc(sizeof(vms[0]) * max_vm);
>  	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
> +
> +	vcpus = malloc(sizeof(struct kvm_vcpu *) * max_vm * max_vcpu);
> +	TEST_ASSERT(vcpus, "Allocate memory for storing vCPU pointers");
> +
>  	for (i = 0; i < max_vm; ++i) {
>  		vms[i] = vm_create_barebones();
>  		for (j = 0; j < max_vcpu; ++j)
> -			__vm_vcpu_add(vms[i], j);
> +			vcpus[j * max_vcpu + i] = __vm_vcpu_add(vms[i], j);

The expression for the index should be 'i * max_vcpu + j'. The swapped
i,j usage isn't causing problems now because
DEFAULT_NUM_VM == DEFAULT_NUM_VCPU, but that could change.

>  	}
>  
>  	/* Check stats read for every VM and VCPU */
>  	for (i = 0; i < max_vm; ++i) {
>  		vm_stats_test(vms[i]);
>  		for (j = 0; j < max_vcpu; ++j)
> -			vcpu_stats_test(vms[i], j);
> +			vcpu_stats_test(vcpus[j * max_vcpu + i]);

Same comment as above.

Thanks,
drew

>  	}
>  
>  	for (i = 0; i < max_vm; ++i)
> -- 
> 2.36.1.255.ge46751e96f-goog
> 

