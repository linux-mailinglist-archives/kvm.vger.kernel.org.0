Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470EF4ECED0
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351236AbiC3V3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 17:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbiC3V3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 17:29:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED2344747
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 14:28:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso1464145pjh.3
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 14:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vN9uvU8bkhJgYN2OitlbKPDgRCZok2QbVcUF878z/wM=;
        b=IQx0L5aQf66UczNgN+LhtlzuJS+bkdz06vFPIbaVx2DkCEsgyaiqgwWD12MNZnV/Yq
         xOnU8wHckgHeP/bGT8Q2CJ04mfHIN2Kze6HWqGKcrCfR0U1ajWKW40gEylNf8Bj0L5Lc
         6RyiZMmFWgZ/8qJ1QiQLjmUcxcApOgbZWj3eT1Dnue1RCjw6nki5rmx1M3/dgOPLLsCE
         hC6JbHVF0KV9EuwXX7+5Y0Mr7b/CmQBnoe7+rkZqgR9gQI6f2dO3ovALr0wVtch1bvnY
         t9iWYq/WS2stSleglwtuhLXr1uteXlTMXBhv1ZHGhvp4CmoGj27HnP0xzsvE6pP7Lsp6
         8gCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vN9uvU8bkhJgYN2OitlbKPDgRCZok2QbVcUF878z/wM=;
        b=VtHrGYZyIQf5XlezlL06thkP/gxNHHE4VDOhu7KG9WWHViHL0l0JG+I1UVqUvKOn54
         M8bjtYosC8b97DTy7w1VKp+lyoc/g3KjRaTqatFsXPD/j4kvxcxIbvQEQnXBtpMJ1aZ0
         Nd+7ibXFkrbeShPJLLhHP4wz+fnH6EEKTplTr2v9UGAzOqYqoMyeVuZMb1OJpJ9j3sAW
         FWdNu2joQSJ/B8ODD+Ejn6u7SOJyL24SvPWQ1BWJc+TceyxozlwYN7U8oXyWmpHoALix
         xxm3YaW4Sx1Z08GCDNx71Adhm45+fX7sRJDrGDWyDW2L5LorEmtdWn1qP3CphFafrUdY
         RF/w==
X-Gm-Message-State: AOAM533jWZNPnuN6A+1H5w1+RrTffXTfMpkNlQDgLNUkMC1k3kfjAipc
        7SRU9py16Yh4zqhwWtETVw8xsQ==
X-Google-Smtp-Source: ABdhPJzPeMqomGyqG5K2JJ7uvrWHjl5jOr+EIfR8eIBr6A/CxG+NwQt7TKETjTc2mUy8h1bL4A+Y7A==
X-Received: by 2002:a17:90a:380d:b0:1c9:d9bb:7602 with SMTP id w13-20020a17090a380d00b001c9d9bb7602mr1770709pjb.216.1648675680717;
        Wed, 30 Mar 2022 14:28:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a63b54a000000b00380ea901cd2sm19845176pgo.6.2022.03.30.14.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 14:28:00 -0700 (PDT)
Date:   Wed, 30 Mar 2022 21:27:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/7] KVM: MMU: Add support for PKS emulation
Message-ID: <YkTLXGdu2I9i44ti@google.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
 <20220221080840.7369-6-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221080840.7369-6-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Chenyi Qiang wrote:
> @@ -277,14 +278,18 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>  	if (unlikely(mmu->pkr_mask)) {
>  		u32 pkr_bits, offset;
> +		u32 pkr;
>  
>  		/*
> -		* PKRU defines 32 bits, there are 16 domains and 2
> -		* attribute bits per domain in pkru.  pte_pkey is the
> -		* index of the protection domain, so pte_pkey * 2 is
> -		* is the index of the first bit for the domain.
> +		* PKRU and PKRS both define 32 bits. There are 16 domains
> +		* and 2 attribute bits per domain in them. pte_key is the
> +		* index of the protection domain, so pte_pkey * 2 is the
> +		* index of the first bit for the domain. The use of PKRU
> +		* versus PKRS is selected by the address type, as determined
> +		* by the U/S bit in the paging-structure entries.
>  		*/
> -		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +		pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : kvm_read_pkrs(vcpu);

Blindly reading PKRU/PKRS is wrong.  I think this magic insanity will be functionally
correct due to update_pkr_bitmask() clearing the appropriate bits in pkr_mask based
on CR4.PK*, but the read should never happen.  PKRU is benign, but I believe reading
PKRS will result in VMREAD to an invalid field if PKRU is supported and enabled, but
PKRS is not supported.

I belive the easiest solution is:

		if (pte_access & PT_USER_MASK)
			pkr = is_cr4_pke(mmu) ? vcpu->arch.pkru : 0;
		else
			pkr = is_cr4_pks(mmu) ? kvm_read_pkrs(vcpu) : 0;

The is_cr4_pk*() helpers are restricted to mmu.c, but this presents a good
opportunity to extra the PKR stuff to a separate, non-inline helper (as a prep
patch).  E.g.


	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
	if (unlikely(mmu->pkr_mask))
		u32 pkr_bits = kvm_mmu_pkr_bits(vcpu, mmu, pte_access, pte_pkey);

		errcode |= -pkr_bits & PFERR_PK_MASK;
		fault |= (pkr_bits != 0);
	}

	return -(u32)fault & errcode;

permission_fault() is inline because it's heavily used for shadow paging, but
when using TDP, it's far less performance critical.  PKR is TDP-only, so moving
it out-of-line should be totally ok (this is also why this patch is "unlikely").
