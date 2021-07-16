Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053733CBE43
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhGPVRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhGPVRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:17:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D7FC061765
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:14:22 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a127so9932170pfa.10
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wHhC/u+Tz+YyCWTdNKVYJX34gL1qM4KNQ1J0r6VozT0=;
        b=AGRyq/qLXmbKze3lJ72pJN2QN/c76K/csTSS8PXICwMCVK/EaEAzMwZxA3o3PZ1Qtt
         gC0Bhr5bbahQFHLe/HTA6RMZAOcKRBBJeVVUC+uHdTDfBmW/V36F3wEFvo67Bt9rc8r3
         5HwAsQBrgzKeb91PrTNi048jDDwGveiQTTWtvGKvulqf0D3cOo9WsQCK1BD78rEMgTGJ
         cOfgcmwQiKsnj/PXZm6smL5sk3hlLIxtkYPebjodPnBHLoBG5088hMqzEaq2LfRwsuAq
         bP919qg9TSZR+H2/ajzxyrUq9XVZ59DW4JTE/NKIYZ8LNzjsMBfzte6WfHhE0oFyV2rN
         E0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wHhC/u+Tz+YyCWTdNKVYJX34gL1qM4KNQ1J0r6VozT0=;
        b=B8Iv0SUaJBFChk7C6z8FU6njrxe7CTGVdQ4fJILXrkaGwx8L+M4YOPUMxGFBRsbIym
         Td+Ag0KJ2Hw4XKC2DgYBe95g/luTG+Q7OMoZVw4LuYpjxcuKqlDtjYRVzKYlmxrNgprc
         472MWd7h+5d7K7WGPXHIpDLMXFOajSOCawmsjyQo8r3jfMDZfxms0GeeLVjKI8EXEaW0
         loQqtquuZNxjv4upXGfsaGn4vAanWUGcmHmpPhodGqqIw6LlsGLV4f8f6R+g9P6PigVc
         4NfkKAGOK5GFOb05cpEpUWwgkYh4qHA2kNb0rgSwBenjBxsRU2cyQUIQV+vSYLnkyVZW
         4V8w==
X-Gm-Message-State: AOAM531knFRBgoXp7CtMF4O3mjaF5gXtCszki9VgYqAtI374UfoXHNIY
        LHs0HJXK5kLWfOp6egUbP+0XpTmIrpZmiA==
X-Google-Smtp-Source: ABdhPJyy/03uRnhTJ2SiPB6qPk6MqOkswkGZYvq9jxHBfG5mcW0dG3s0jOK6gCGZRtU3oAwINdQ+HQ==
X-Received: by 2002:aa7:90cd:0:b029:333:baa9:87b7 with SMTP id k13-20020aa790cd0000b0290333baa987b7mr7471263pfk.23.1626470061392;
        Fri, 16 Jul 2021 14:14:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b1sm12659509pjn.11.2021.07.16.14.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 14:14:20 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:14:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 34/40] KVM: SVM: Add support to handle Page
 State Change VMGEXIT
Message-ID: <YPH2qRkkG6m0FT2X@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-35-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-35-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021, Brijesh Singh wrote:
> +static unsigned long snp_handle_psc(struct vcpu_svm *svm, struct ghcb *ghcb)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	int level, op, rc = PSC_UNDEF_ERR;
> +	struct snp_psc_desc *info;
> +	struct psc_entry *entry;
> +	gpa_t gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm))
> +		goto out;
> +
> +	if (!setup_vmgexit_scratch(svm, true, sizeof(ghcb->save.sw_scratch))) {
> +		pr_err("vmgexit: scratch area is not setup.\n");
> +		rc = PSC_INVALID_HDR;
> +		goto out;
> +	}
> +
> +	info = (struct snp_psc_desc *)svm->ghcb_sa;
> +	entry = &info->entries[info->hdr.cur_entry];

Grabbing "entry" here is unnecessary and confusing.

> +
> +	if ((info->hdr.cur_entry >= VMGEXIT_PSC_MAX_ENTRY) ||
> +	    (info->hdr.end_entry >= VMGEXIT_PSC_MAX_ENTRY) ||
> +	    (info->hdr.cur_entry > info->hdr.end_entry)) {

There's a TOCTOU bug here if the guest uses the GHCB instead of a scratch area.
If the guest uses the scratch area, then KVM makes a full copy into kernel memory.
But if the guest uses the GHCB, then KVM maps the GHCB into kernel address space
but doesn't make a full copy, i.e. the guest can modify the data while it's being
processed by KVM.

IIRC, Peter and I discussed the sketchiness of the GHCB mapping offline a few
times, but determined that there were no existing SEV-ES bugs because the guest
could only submarine its own emulation request.  But here, it could coerce KVM
into running off the end of a buffer.

I think you can get away with capturing cur_entry/end_entry locally, though
copying the GHCB would be more robust.  That would also make the code a bit
prettier, e.g.

	cur = info->hdr.cur_entry;
	end = info->hdr.end_entry;

> +		rc = PSC_INVALID_ENTRY;
> +		goto out;
> +	}
> +
> +	while (info->hdr.cur_entry <= info->hdr.end_entry) {

Make this a for loop?

	for ( ; cur_entry < end_entry; cur_entry++)

> +		entry = &info->entries[info->hdr.cur_entry];

Does this need array_index_nospec() treatment?

> +		gpa = gfn_to_gpa(entry->gfn);
> +		level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
> +		op = entry->operation;
> +
> +		if (!IS_ALIGNED(gpa, page_level_size(level))) {
> +			rc = PSC_INVALID_ENTRY;
> +			goto out;
> +		}
> +
> +		rc = __snp_handle_psc(vcpu, op, gpa, level);
> +		if (rc)
> +			goto out;
> +
> +		info->hdr.cur_entry++;
> +	}
> +
> +out:

And for the copy case:

	info->hdr.cur_entry = cur;

> +	return rc ? map_to_psc_vmgexit_code(rc) : 0;
> +}
