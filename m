Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B840422057
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhJEIO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233076AbhJEIOt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 04:14:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633421578;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XjQ1/3iE4M+xISPrEkRaQBTN9sLKqhZlK9JKGdWWFPA=;
        b=AG0Uo0VIpxM4s+F97dNTcZ8j1TDr2kZkdgRs7ALvt2LpRabjnFLuWlBZSYiQAjNBIIPEvD
        bHKgpJCao7gTW8ZOAoVRuSXDVEkexxbqucn+wB9C0/1dgkPkBdooFlvIB85WpUvf8GLNUR
        Xip0lSGbXRV/HXKs9OvWSgHAzkknTSU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-4YD03XnjPGCd5vd5UdE5_g-1; Tue, 05 Oct 2021 04:12:56 -0400
X-MC-Unique: 4YD03XnjPGCd5vd5UdE5_g-1
Received: by mail-wm1-f72.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso1549385wmc.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=XjQ1/3iE4M+xISPrEkRaQBTN9sLKqhZlK9JKGdWWFPA=;
        b=NbV+BUfZsttbVtqpfAe6IsGoI7rw+zhVVQtTDKXEI9O39R0wakcmNQEZJB2RJs4ScX
         1r966y8S+OHjPlG7h0dJPdh7F8hUgCM45uqaKD+g6xKmVE/Zd+RL9V3KuS7wf0fEr/69
         ooFAJG3R/CdadG7ZCDNCcYHxE1h7NF0U8y1IOXhGZjQD6BLz/R3GqEjphMOs+/6WKdBW
         a1zgQ8BXiKHtl7mAPojbmgvPSftGZVfWrAFSNYWaI0OBycyipnyfOckUa5nijB9BAx0m
         A4HOSkjLuFEmhlQFm/bG5ifPIszOy48lPcNPZX/+bBjj8Q5eNXlH345zFAy78bKoWge7
         u6jA==
X-Gm-Message-State: AOAM531zCSiYuy0TNQEJwCTBOA3nXpPkkXuwjxBxNQhMdPDc+3Ri0915
        bzGhiz3GCYQpFIlDvctp5Me9rsVUMqBHwDlWbv7O1Q99Kuae1/PxmF+BtHHQhPekCAw/VnyDG/h
        44ry5UerYOoxG
X-Received: by 2002:a7b:c314:: with SMTP id k20mr1932043wmj.50.1633421575677;
        Tue, 05 Oct 2021 01:12:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5JjnFWO0IRALy8LbJuimfozYaSNNcNoqrFLt/UG8KArCfpQH6NJkJJjBCnwWe/cUNT8ynDA==
X-Received: by 2002:a7b:c314:: with SMTP id k20mr1932016wmj.50.1633421575476;
        Tue, 05 Oct 2021 01:12:55 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id z18sm10150526wro.25.2021.10.05.01.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:12:55 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 09/11] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-10-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <741f4f59-c4e7-1bd8-f517-9d2536968772@redhat.com>
Date:   Tue, 5 Oct 2021 10:12:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-10-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,
On 10/5/21 3:19 AM, Ricardo Koller wrote:
> Add tests for checking that KVM returns the right error when trying to
> set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> addressable IPA range. Also tighten the IPA range by replacing
> KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> guest (i.e., the default).
>
> The check for the GICv3 redistributor created using the REDIST legacy
> API is not sufficient as this new test only checks the check done using
> vcpus already created when setting the base. The next commit will add
> the missing test which verifies that the KVM check is done at first vcpu
> run.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 38 +++++++++++++------
>  1 file changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index cb69e195ad1d..eadd448b3a96 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -31,7 +31,7 @@ struct vm_gic {
>  	uint32_t gic_dev_type;
>  };
>  
> -static int max_ipa_bits;
> +static uint64_t max_phys_size;
>  
>  /* helper to access a redistributor register */
>  static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
> @@ -152,16 +152,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
>  	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
>  
>  	/* out of range address */
> -	if (max_ipa_bits) {
> -		addr = 1ULL << max_ipa_bits;
> -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 dist.attr, &addr, true);
> -		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
> +	addr = max_phys_size;
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 dist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
>  
> -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 rdist.attr, &addr, true);
> -		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> -	}
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> +
> +	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
> +	addr = max_phys_size - dist.alignment;
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +			"half of the redist is beyond IPA limit");
>  
>  	/* set REDIST base address @0x0*/
>  	addr = 0x00000;
> @@ -250,12 +255,19 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
>  
> -	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
> +	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
>  	TEST_ASSERT(ret && errno == E2BIG,
>  		    "register redist region with base address beyond IPA range");
>  
> +	/* The last redist is above the pa range. */
> +	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		    "register redist region with top address beyond IPA range");
> +
>  	addr = 0x260000;
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> @@ -610,8 +622,10 @@ void run_tests(uint32_t gic_dev_type)
>  int main(int ac, char **av)
>  {
>  	int ret;
> +	int pa_bits;
>  
> -	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
> +	max_phys_size = 1ULL << pa_bits;
>  
>  	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
>  	if (!ret) {

