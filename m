Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87847CFD69
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345800AbjJSO6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 10:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbjJSO57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 10:57:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13A5119
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 07:57:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9c4ae201e0so778531276.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 07:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697727477; x=1698332277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NoyDzNpmGMgG5vgnElNw+7wjvKQootkU5+NZTuzV+xg=;
        b=Gm6Qujx2s3EY83BV15eUeFcUqAef5IzNanVHwEQKSMwkYUZhwHtMI1CBTcaAjLscOv
         Asxymdyuh5WM5kAmXD3PlbMiZyORfahnX1iJMkqtXtoI2n/vCkt4ZF1Hzo+XMplrVLgB
         kDn8sIa8BDM8hvzdQfztTy8op70DcFUvR9V4qQCw0yIX5H8BDZsVDBgWELP+rUYtfVsy
         G+HebzaqlTZ30KZphvY3Tzgb5nk32VUBwY06OlOKzawj+yPr5CEsHypA3F7pMUZMKVeW
         8b6QOMPcQ5MM7oEilfJHfFbzOGn5ztKJgPk16qT6J+z9Zyoxha4EYCwBEcJKtxAKpCa/
         3CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697727477; x=1698332277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NoyDzNpmGMgG5vgnElNw+7wjvKQootkU5+NZTuzV+xg=;
        b=jePf7sQyaNt/Fmprd/cooSJBrM4N+viFtNYYwNMbAAJ+eflpHv1GGvWfofUWxPNlHb
         +FByjD55n8EW7sAq4aZS45t3hwaIPsTkszJF1FTUk/icjWO344UzZ21VPNz/gJJQubtU
         h1mehMjAxmr6sxF7ZqbPzIWox9u5acbRLufN228i/QYFrfwVgRFyBdvW5eYkgxHqXGX+
         3PLzlMixRIvqETEQIHTaZTzazwnYTY6gJ8Hyaa+8V063u+rBZfQ07fr9XA44mLC8S/zt
         uySgqRQ1qqpe2ax8EDcejSARZRbaooW7zVG4xaZc4Bo6FGVRG6Kawlvv1jtWZv6/aFSf
         W2xg==
X-Gm-Message-State: AOJu0YylucSjNvU770VluDsA1Z8rBH5D2J+lm6xHLIjs6xCNHNVPkxjb
        WNzusDh83MS8e8wZz1EfYlJDgrI7mhM=
X-Google-Smtp-Source: AGHT+IGGSi1A+odVH3et/CwWq4QLFvjNrU7TNfsn6fh/fjXnuZNCRYjqcrZpE1GRu0FMfXKhYQGxJgbQ8Z4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1202:b0:d9a:b81b:fd66 with SMTP id
 s2-20020a056902120200b00d9ab81bfd66mr66949ybu.2.1697727477216; Thu, 19 Oct
 2023 07:57:57 -0700 (PDT)
Date:   Thu, 19 Oct 2023 07:57:55 -0700
In-Reply-To: <924b755a-977a-4476-9525-a7626d728e18@amd.com>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <924b755a-977a-4476-9525-a7626d728e18@amd.com>
Message-ID: <ZTFD8y5T9nPOpCyX@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023, Alexey Kardashevskiy wrote:
> 
> On 19/10/23 00:48, Sean Christopherson wrote:
> > static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
> > {
> > 	struct kvm_vcpu *vcpu = &svm->vcpu;
> > 	struct kvm *kvm = vcpu->kvm;
> > 	struct kvm_sev_info *sev;
> > 	unsigned long exitcode;
> > 	u64 data_gpa;
> > 
> > 	if (!sev_snp_guest(vcpu->kvm)) {
> > 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
> > 		return 1;
> > 	}
> > 
> > 	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> > 	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> > 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
> > 		return 1;
> > 	}
> > 
> > 	vcpu->run->hypercall.nr		 = KVM_HC_SNP_GET_CERTS;
> > 	vcpu->run->hypercall.args[0]	 = data_gpa;
> > 	vcpu->run->hypercall.args[1]	 = vcpu->arch.regs[VCPU_REGS_RBX];
> > 	vcpu->run->hypercall.flags	 = KVM_EXIT_HYPERCALL_LONG_MODE;
> 
> btw why is it _LONG_MODE and not just _64? :)

I'm pretty sure it got copied from Xen when KVM started adding supporting for
emulating Xen's hypercalls.  I assume Xen PV actually has a need for identifying
long mode as opposed to just 64-bit mode, but KVM, not so much.

> > 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
> > 	return 0;
> > }
> 
> This should work the KVM stored certs nicely but not for the global certs.
> Although I am not all convinced that global certs is all that valuable but I
> do not know the history of that, happened before I joined so I let others to
> comment on that. Thanks,

Aren't the global certs provided by userspace too though?  If all certs are
ultimately controlled by userspace, I don't see any reason to make the kernel a
middle-man.
