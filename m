Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430355A04F9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 02:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiHYAHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 20:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiHYAHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 20:07:50 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD807268A
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:07:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 20so17070675plo.10
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=WlReJOzXIhJda4pOzoMrXx4sIl9Gr6GJEZHVhKhAxDw=;
        b=sFLM7eUbKU/KhGvAGerbONDAG9bYO8/C6iet2osSA5CKkfGBb8b3bsLDxlswjPndHA
         r6K/vHYr9o0JjM3YZPhD0ZjM1cHtKkRuI7O5u0h1ALQeilZjCr+FYFMA9PBmYz+X9rCO
         9RDi0Oy4cXT2WHXflnou1PkrhNwAsg6rC8l0VsnPuKsFpnKXxS2kCxsFmjCWXiKq9H4s
         RlTSNCw/AyhD68xJ02R2MP2wKtu2EF0dG3OUsg2/Y9i3UD6gnmBy7b9wnx57So54GGoA
         lvzAnwgti2JmeFcyJsmx/rEiXXqJujLacGGj7NMtVBcZHxWLexWVNTAqwhOH7XDUIaym
         M5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=WlReJOzXIhJda4pOzoMrXx4sIl9Gr6GJEZHVhKhAxDw=;
        b=0iKR10kbDp5L80ixjXnfX26jujp60cQMkr1ZqlnZFon6NoLJeXFubaiafrmUrtXfCK
         sovIjyRdtuFUtOgyjzGYpyV+T8xrAkxdjXsv63g5pCoCPNBV4PmFC7y8r5gj3EDI/eH+
         KJS2ylM8fEdnEzvjmiSQw8kcF7JF1mC9UJoQQlyVIaSAcRmCnRewj8K94VmORB1Re2C7
         vaV/kLC5IECfpF6cPifTp2cvT3Gt64B0UgvitDd86WETCwyR4R8r4cJrf8IweNMGtP20
         Y3OFICOxXVLWuhx4S38U6A33YPANd9IMtMD3iGyn1u+6svvkXuW6n1L/awym8T6zGTWB
         OA9w==
X-Gm-Message-State: ACgBeo3YUhiF6QDSi8VOXWhgzayEKYh7wnmgbJzf1GFI65e4cSqqnK9i
        ksYHiUKHLnVwIBls501b2x6iXA==
X-Google-Smtp-Source: AA6agR7zyFfJLWQrfdcZw9WG1Kf4ywDr9plgd+qVapIXnOH6WASsi2qbJZUwIlN1QobfxpJpuzdzLg==
X-Received: by 2002:a17:90b:3655:b0:1fb:8ef:5da6 with SMTP id nh21-20020a17090b365500b001fb08ef5da6mr1584603pjb.81.1661386067904;
        Wed, 24 Aug 2022 17:07:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s124-20020a625e82000000b0052d87b76d12sm13671415pfb.68.2022.08.24.17.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 17:07:47 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:07:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        shuah@kernel.org, yang.zhong@intel.com, drjones@redhat.com,
        ricarkol@google.com, aaronlewis@google.com, wei.w.wang@intel.com,
        kirill.shutemov@linux.intel.com, corbet@lwn.net, hughd@google.com,
        jlayton@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, chao.p.peng@linux.intel.com,
        yu.c.zhang@linux.intel.com, jun.nakajima@intel.com,
        dave.hansen@intel.com, michael.roth@amd.com, qperret@google.com,
        steven.price@arm.com, ak@linux.intel.com, david@redhat.com,
        luto@kernel.org, vbabka@suse.cz, marcorr@google.com,
        erdemaktas@google.com, pgonda@google.com, nikunj@amd.com,
        diviness@google.com, maz@kernel.org, dmatlack@google.com,
        axelrasmussen@google.com, maciej.szmigiero@oracle.com,
        mizhang@google.com, bgardon@google.com
Subject: Re: [RFC V3 PATCH 4/6] selftests: kvm: x86: Execute hypercall as per
 the cpu
Message-ID: <Ywa9T+jKUpaHLu/l@google.com>
References: <20220819174659.2427983-1-vannapurve@google.com>
 <20220819174659.2427983-5-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819174659.2427983-5-vannapurve@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Vishal Annapurve wrote:
> Add support for executing vmmcall/vmcall instruction on amd/intel cpus.
> In general kvm patches the instruction according to the cpu
> implementation at runtime. While executing selftest vms from private
> memory KVM will not be able to update the private memory of the guest.
> 
> Hypercall parameters are fixed to explicitly populate hypercall number
> in eax. Otherwise inlined function calls to kvm_hypercall would call
> vmmcall/vmcall instruction without updating eax with hypercall number.

Can you send a seperate non-RFC series to clean up the selftests mess?  kvm_hypercall()
isn't the only culprit.

  git grep \"vmcall | wc -l
  16

I'm pretty sure things work only because of KVM's dubious behavior of patching
VMCALL/VMMCALL by default.

Note, svm_vmcall_test.c intentionally uses the wrong instructions and shouldn't
be converted.  Actually, we can and should just delete that test, it's superseded
by the wonderfully named fix_hypercall_test.

> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> ---
>  .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 53b115876417..09d757a0b148 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1254,10 +1254,21 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
>  		       uint64_t a3)
>  {
>  	uint64_t r;
> +	static bool is_cpu_checked;
> +	static bool is_cpu_amd;
>  
> -	asm volatile("vmcall"
> +	if (!is_cpu_checked)
> +		is_cpu_amd = is_amd_cpu();

This can be done using a single int, e.g.

	static bool is_cpu_amd = -1;

	if (is_cpu_amd < 0)
		is_cpu_amd = is_amd_cpu();

Although... what if we declare main() in lib/kvm_util.c (or maybe a dedicated
file?) and rename all tests to use __main()?  Then add an arch hook to do global
initialization and avoid the "did we check CPUID?!?!?" altogether.

That would allow us to dedup all of the hilarious copy paste:

	/* Tell stdout not to buffer its content */
	setbuf(stdout, NULL);

and we could turn is_amd_cpu() and is_intel_cpu() into bools.

E.g.

int main(int argc, char *argv[])
{
	/* Tell stdout not to buffer its content */
	setbuf(stdout, NULL);

	kvm_arch_main();

	return __main(argc, argv);
}

void kvm_arch_main(void)
{
	is_cpu_amd = cpu_vendor_string_is("AuthenticAMD");
	is_cpu_intel = cpu_vendor_string_is("AuthenticAMD");
}


And then we just need macro magic to emit the right VMCALL/VMMCALL instruction.
