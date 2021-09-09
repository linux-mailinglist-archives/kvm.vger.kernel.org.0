Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E96405856
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354330AbhIIN5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:57:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350321AbhIINzr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 09:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631195675;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xFZbxgj8R3amtjBawkP8XVm2i9AJag/7vP3QeWu31hQ=;
        b=dyPLkmSfJkALI6Z8JihY3v+X3PmBfHddEAQlxUhWIdM8STaxRNeGHhLZHjMsMTDaRgePtt
        oaY3SZLOlbuliH0OsOwVSh8UOYBM8HS2rcp3MuVK7df44pRfqwgX5cQA5GdgK+rv/5uXgX
        A/t/CJJPSak5rark6/w9OPsbSHa1qAs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-Fr27dUagOZyolNhq_khidw-1; Thu, 09 Sep 2021 09:54:34 -0400
X-MC-Unique: Fr27dUagOZyolNhq_khidw-1
Received: by mail-wm1-f72.google.com with SMTP id p29-20020a1c545d000000b002f88d28e1f1so799171wmi.7
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 06:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=xFZbxgj8R3amtjBawkP8XVm2i9AJag/7vP3QeWu31hQ=;
        b=jxJHygvQfAK3JPrOiOO/eHBNErJOACB5B1qQzUN132e+ntg8+HIHFmhefbcV1RAaie
         z4Y4LA1O1bBO+bKEVf7f8J/YM8ZhOSlgQVGYAu7AOIah4N75sZCoQ6TkW9HIg782+ik5
         sdA1M48cMrw4aLJ5az6JcZwe90u9RtkbTk+v1LWYBkTMi0yjnLhJr2r1OPSqxoEz8TWB
         urtW5O8fjFw4SoavreWqKZJZGFBSBbOMPyaay1bPXfVUgzD4eofFBnrNEF59Vjw9LQ0s
         o9kSRfyWNR/AEDhrMBAXrJCTXlmACYc51OkluIVrROYITo9h1rkBK2MWwh/EuV2hoY/n
         MMSg==
X-Gm-Message-State: AOAM530chL9xC2nL2mHbHDJUdUGowlc9GksW8y4M5h3fRSLnYWtqytDR
        w8/pM6lO6edghQ407PlR0jolcBPfi7FUX4cmqwFfBoa3dBiynYPzu/VKVzY59/X91B4gb6wIpsG
        c9smN986dw3IQ
X-Received: by 2002:adf:ea0c:: with SMTP id q12mr3821519wrm.392.1631195673098;
        Thu, 09 Sep 2021 06:54:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRPTzKGXmbntvIGfNCpfEK2WxpRguCDUXFlVS1CKNB3zc/RmHvQ0VrA9rIG5hJQfEz4egnmg==
X-Received: by 2002:adf:ea0c:: with SMTP id q12mr3821500wrm.392.1631195672929;
        Thu, 09 Sep 2021 06:54:32 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i5sm1509373wmq.17.2021.09.09.06.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 06:54:32 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: test for vgic redist above the
 VM IPA size
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-3-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <83282104-ca04-c4f5-3570-c884a22ab667@redhat.com>
Date:   Thu, 9 Sep 2021 15:54:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210908210320.1182303-3-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/8/21 11:03 PM, Ricardo Koller wrote:
> This test attempts (and fails) to set a redistributor region using the
> legacy KVM_VGIC_V3_ADDR_TYPE_REDIST that's partially above the
> VM-specified IPA size.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 623f31a14326..6dd7b5e91421 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -285,6 +285,49 @@ static void test_vcpus_then_vgic(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +static void test_redist_above_vm_pa_bits(enum vm_guest_mode mode)
> +{
> +	struct vm_gic v;
> +	int ret, i;
> +	uint32_t vcpuids[] = { 1, 2, 3, 4, };
> +	int pa_bits = vm_guest_mode_params[mode].pa_bits;
> +	uint64_t addr, psize = 1ULL << pa_bits;
> +
> +	/* Add vcpu 1 */
> +	v.vm = vm_create_with_vcpus(mode, 1, DEFAULT_GUEST_PHY_PAGES,
> +				    0, 0, guest_code, vcpuids);
> +	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +
> +	/* Set space for half a redist, we have 1 vcpu, so this fails. */
> +	addr = psize - 0x10000;
> +	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL, "not enough space for one redist");
> +
> +	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
> +	addr = psize - (3 * 2 * 0x10000);
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);

I think you need to test both the old API (KVM_VGIC_V3_ADDR_TYPE_REDIST)
and the new one (KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION).

Can't you integrate those new checks in existing tests,
subtest_redist_regions() and subtest_dist_rdist() which already tests
base addr beyond IPA limit (but not range end unfortunately). look for
E2BIG.

Thanks

Eric
> +
> +	addr = 0x00000;
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> +
> +	/* Add three vcpus (2, 3, 4). */
> +	for (i = 1; i < 4; ++i)
> +		vm_vcpu_add_default(v.vm, vcpuids[i], guest_code);
> +
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	/* Attempt to run a vcpu without enough redist space. */
> +	ret = run_vcpu(v.vm, vcpuids[3]);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +			"redist base+size above IPA detected on 1st vcpu run");
> +
> +	vm_gic_destroy(&v);
> +}
> +
>  static void test_new_redist_regions(void)
>  {
>  	void *dummy = NULL;
> @@ -542,6 +585,7 @@ int main(int ac, char **av)
>  	test_kvm_device();
>  	test_vcpus_then_vgic();
>  	test_vgic_then_vcpus();
> +	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
>  	test_new_redist_regions();
>  	test_typer_accesses();
>  	test_last_bit_redist_regions();

