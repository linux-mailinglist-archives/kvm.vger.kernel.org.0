Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3574634E4A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfFDREj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:04:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37793 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFDREj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:04:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id h1so16637180wro.4
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onKpWgFhUSiiW/7bw+TGVWhxHFMA8ahI+2mNf5CbZi8=;
        b=YlEZRb6Gts7N9n4uBc/5W7AeEt+6HTasDahijX4iXKx1nNj5LJmaSEU5s+U0eYp15b
         i7A5t7PvxcJHwNnp9px+g6CYMefArR+vTELyhIeVSg0W+rgU4iTUJSouxRJfba3cr3Hw
         LCaz8mOet/Q10LO9Y5EWm8kx+B/4i6M0RiWV2HJUOfGkh4vrsc1LzNFBdz4mGuzNT5Ng
         ELnGFdxcaVeVNeg59O4YGuoWDUj2ej3TA/rweF2KW4N+xk6OHl4TvZJYVqgtl087gyeO
         VdUft30ee9YePky3feY/EUo9/MQwuSpFdeOR9VgdMLU3eLdBEIEOXj2NHvtGLLyddzGW
         9/Aw==
X-Gm-Message-State: APjAAAUmFRMUV720wtmT6j6g8bO45xJiqQ0LlRceWbxucogDC18sVyL7
        we9vyn8PJMz6mqKMrTwayxZIzA==
X-Google-Smtp-Source: APXvYqy70zuYpLK8YVAjoVTFKD745cdenEcuvKGXDyvAJJ+iYZkzkTOMBt3wdtkcTbHciyicZHsqcg==
X-Received: by 2002:adf:c541:: with SMTP id s1mr7284208wrf.44.1559667877367;
        Tue, 04 Jun 2019 10:04:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id z65sm24640576wme.37.2019.06.04.10.04.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:04:36 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: selftests: ucall improvements
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, peterx@redhat.com, thuth@redhat.com
References: <20190527123006.17959-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9f64e487-8ac0-e9e3-0b1e-c6d525b10bee@redhat.com>
Date:   Tue, 4 Jun 2019 19:04:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527123006.17959-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 14:30, Andrew Jones wrote:
> Make sure we complete the I/O after determining we have a ucall,
> which is I/O. Also allow the *uc parameter to optionally be NULL.
> It's quite possible that a test case will only care about the
> return value, like for example when looping on a check for
> UCALL_DONE.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> ---
> v2:
>   - rebase; there was a change to get_ucall() that affected
>     context.
>   - Also switch all unit tests to using a NULL uc if possible.
>     It was only possible for one though. Some unit tests only
>     use uc.cmd in error messages, but I guess that's a good
>     enough reason to have a non-NULL uc.
>   - add Peter's r-b
> 
>  tools/testing/selftests/kvm/dirty_log_test.c |  3 +--
>  tools/testing/selftests/kvm/lib/ucall.c      | 19 +++++++++++++------
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index fc27f890155b..ceb52b952637 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -121,7 +121,6 @@ static void *vcpu_worker(void *data)
>  	uint64_t *guest_array;
>  	uint64_t pages_count = 0;
>  	struct kvm_run *run;
> -	struct ucall uc;
>  
>  	run = vcpu_state(vm, VCPU_ID);
>  
> @@ -132,7 +131,7 @@ static void *vcpu_worker(void *data)
>  		/* Let the guest dirty the random pages */
>  		ret = _vcpu_run(vm, VCPU_ID);
>  		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> -		if (get_ucall(vm, VCPU_ID, &uc) == UCALL_SYNC) {
> +		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
>  			pages_count += TEST_PAGES_PER_LOOP;
>  			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
>  		} else {
> diff --git a/tools/testing/selftests/kvm/lib/ucall.c b/tools/testing/selftests/kvm/lib/ucall.c
> index b701a01cfcb6..dd9a66700f96 100644
> --- a/tools/testing/selftests/kvm/lib/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/ucall.c
> @@ -125,16 +125,16 @@ void ucall(uint64_t cmd, int nargs, ...)
>  uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
>  {
>  	struct kvm_run *run = vcpu_state(vm, vcpu_id);
> -
> -	memset(uc, 0, sizeof(*uc));
> +	struct ucall ucall = {};
> +	bool got_ucall = false;
>  
>  #ifdef __x86_64__
>  	if (ucall_type == UCALL_PIO && run->exit_reason == KVM_EXIT_IO &&
>  	    run->io.port == UCALL_PIO_PORT) {
>  		struct kvm_regs regs;
>  		vcpu_regs_get(vm, vcpu_id, &regs);
> -		memcpy(uc, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi), sizeof(*uc));
> -		return uc->cmd;
> +		memcpy(&ucall, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi), sizeof(ucall));
> +		got_ucall = true;
>  	}
>  #endif
>  	if (ucall_type == UCALL_MMIO && run->exit_reason == KVM_EXIT_MMIO &&
> @@ -143,8 +143,15 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
>  		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
>  			    "Unexpected ucall exit mmio address access");
>  		memcpy(&gva, run->mmio.data, sizeof(gva));
> -		memcpy(uc, addr_gva2hva(vm, gva), sizeof(*uc));
> +		memcpy(&ucall, addr_gva2hva(vm, gva), sizeof(ucall));
> +		got_ucall = true;
> +	}
> +
> +	if (got_ucall) {
> +		vcpu_run_complete_io(vm, vcpu_id);
> +		if (uc)
> +			memcpy(uc, &ucall, sizeof(ucall));
>  	}
>  
> -	return uc->cmd;
> +	return ucall.cmd;
>  }
> 

Queued, thanks.

Paolo
