Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F711525933
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 03:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357632AbiEMBDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 21:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359860AbiEMBD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 21:03:29 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3279240913
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:03:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x12so6087885pgj.7
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yhdX1EL/sWCz5vJoug+D2WrNzRnzdgksXTuD2mvaEPE=;
        b=VDI9xOkNKnEokzk8xUh4JyQX+Yo006IxdyOCXuWDTE0qkS6LZ/bo2zcSHasiEdI1U2
         c7qHNu2EXwJkXha5TxAgbRCpy7iFg0MSX9FUACYYgIm4l+d5zkSECCApXjn1Q4Xks/ME
         hekKe9IZ/YzFZUnKHkSLZfqeVzia4h/B3HHlw9LyOYgRceHjA0QTFuok0EAiyievqFry
         GQV63bihxwfmUxM88kHArPmj6FIjbVk1S6BEiadN6tyiasy5SQP2yhqi8Ln4VECCPuto
         Wap2+ixLdbE07JfNNqGouV7cQNosdDRuTM1Vu1vMSkJicY9+brKkqSIkxDFlPWlyijAB
         J4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yhdX1EL/sWCz5vJoug+D2WrNzRnzdgksXTuD2mvaEPE=;
        b=pHVwqjkNTfyhGRro7BJTru4oqZKvcCwJzAOMIkJ3fglaYUrUz+BhSrjmVbn5cJWQCm
         YhADM6iki5DnnEJhzSKSU0hsewuND37Up4lSQygBR+QXkw6w1nQ3KsshemxLvv9j0NcV
         CeEaDGI2qJdHXrl/PR+8pkm3I1xb0iraCHkifz3SOnypaqJKL258qQ9spE/3c38wOWyJ
         l0U/AphvNSylrkMB5Xy11C+5yACMdrHDmZDJEMnGny/4zP5DbiojG6eRUtoaF/9TZeH4
         PCeutGkUYXnA/QsaR1xc9U2pRIZL7yACAEMxV5m9ELtQtZ1MOfGivCVkFL4CLUH+c6pX
         b7jw==
X-Gm-Message-State: AOAM533A1vPkVeaAlJTiQ1jNKApReqHCDGjlx+iKXD6ZzwC2VPVaECIr
        WmLWSgePZVcP0wQkipcZMeLIEQ==
X-Google-Smtp-Source: ABdhPJzP8QtZ6ZkiVz6FrHZg1aCTdDrF4Bg9uDZaDvtm2YaM/rA3cvXwo4MwPuEgNfYvb3txDVILbA==
X-Received: by 2002:aa7:84d1:0:b0:510:8796:4f38 with SMTP id x17-20020aa784d1000000b0051087964f38mr2017729pfn.8.1652403807512;
        Thu, 12 May 2022 18:03:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902650200b0015e8d4eb264sm491423plk.174.2022.05.12.18.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:03:27 -0700 (PDT)
Date:   Fri, 13 May 2022 01:03:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v2] kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test
Message-ID: <Yn2uW0C+48fnDgfj@google.com>
References: <20220503064037.10822-1-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503064037.10822-1-guang.zeng@intel.com>
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

On Tue, May 03, 2022, Zeng Guang wrote:
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_enable_cap cap = { 0 };
> +	int ret;
> +
> +	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +
> +	/* Get KVM_CAP_MAX_VCPU_ID cap supported in KVM */
> +	ret = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);

Because it's trivial to do so, and will avoid a hardcoded "max", what about looping
over all possible values?  And then some arbitrary number of the max?

	max_nr_vcpus = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
	TEST_ASSERT(max_nr_vcpus > ???, ...)

	for (i = 0; i < max_nr_vcpus; i++) 
		vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);

		vm_set_max_nr_vcpus(vm, 0);
		vm_create_invalid_vcpu(vm, 0);

		vm_set_max_nr_vcpus(vm, i);
		vm_set_max_nr_vcpus(vm, i);
		vm_create_invalid_vcpu(vm, i);
		vm_create_invalid_vcpu(vm, i + 1);

		vm_set_invalid_max_nr_vcpus(vm, 0);
		vm_set_invalid_max_nr_vcpus(vm, i + 1);
		vm_set_invalid_max_nr_vcpus(vm, i - 1);
		vm_set_invalid_max_nr_vcpus(vm, max_nr_vcpus);

		close(vm->fd);
	}

	for ( ; i < max_nr_vcpus + 100; i++) {
		vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);

		vm_set_invalid_max_nr_vcpus(vm, i);

		close(vm->fd);
	}
> +
> +	/* Check failure if set KVM_CAP_MAX_VCPU_ID beyond KVM cap */
> +	cap.cap = KVM_CAP_MAX_VCPU_ID;
> +	cap.args[0] = ret + 1;
> +	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);

A helper or two to set the cap would be, uh, helpful :-)  See above for ideas.

> +	TEST_ASSERT(ret < 0,
> +		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID"
> +		    "beyond KVM cap!\n");

Please don't wrap quoted strings.  Shorten the string and/or let the line run long.
For the string/message, prioritize information that the user _can't_ get from looking
at the code, and info that is highly relevant to the expectations.  E.g. print the
the return value, the errno, and the allegedly bad value.

It's definitely helpful to provide context too (KVM Unit Tests drive me bonkers for
their terse messages), but for cases like this, it's redundant.  "Unexpected success"
is redundant because the "ret < 0" conveys that failure was expected, and hopefully
most people will intuit that the test was trying "to enable" KVM_CAP_MAX_VCPU_ID.
If not, a quick glance at the code (file and line provided) will give them that info.

E.g. assuming this ends up in a helper, something like

	TEST_ASSERT(ret == -1 && errno == EINVAL,
		    "KVM_CAP_MAX_VCPU_ID bug, max ID = %d, ret = %d, errno = %d (%s),
		    max_id, errno, strerror(errno));

IMO it's worth checking errno to reduce the probability of false pass, e.g. if the
ioctl() is rejected for some other reason due to a test bug.

> +
> +	/* Check success if set KVM_CAP_MAX_VCPU_ID */
> +	cap.args[0] = MAX_VCPU_ID;
> +	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
> +	TEST_ASSERT(ret == 0,
> +		    "Unexpected failure to enable KVM_CAP_MAX_VCPU_ID!\n");
