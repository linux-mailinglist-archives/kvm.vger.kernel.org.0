Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59377CC8BD
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbjJQQ1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjJQQ1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:27:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEEAA4
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:27:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7b9e83b70so44466457b3.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697560034; x=1698164834; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/hJkp0YS8fbA60ZiTgrrQsXxvsEIWpcMYoRPyADSAvk=;
        b=jrTMKvDr1Hg704ewDQlJ+UCCk/hnsJ7RVeMNwG4u/vTQ1e5UOmgndiqAF0kiuY7L0o
         nzlvNGzkO1tJGUS4dxrI417G7xVLDSNEUz26YJXIo8Qfiawf2E02c8s5F/wIqvnRqrVR
         DtKldZha+539ZyJXzamt+VnlluQzv2Yw6M3Ao54WBLCwTJ09yUqdTsV0lXH6UFAxXGpr
         vPRb3io31z7NYbfyS1c9VCBBWtxyD2Y8itQZGxB/76w7ZeebS0fE3DdHB5WT7LDeFD/y
         shGb0kqg+opv/0vNhAw/WdrMUfF15nGh+YZzB6zQIr/2O31z3uGSO8YJbYX04mGe0Taa
         HWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697560034; x=1698164834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/hJkp0YS8fbA60ZiTgrrQsXxvsEIWpcMYoRPyADSAvk=;
        b=s5y2zuTdO6QTM3/gFBfXtPkgYfBQHIsEvVHDIbs0onKNbMMOhKdiCIDD6yK938r1HX
         qlw/7uACKBHa39niH0RoLaIis+k3sYgBU9ImVt8gGyUIJO+SrL4SkB6YKcgZ5SfrdQay
         DtveSiXNU/jNsxJKAboyYME2ZVjITnBPDfWaL7fqyKx9MQeD4UwyI5yQR25ZW7atCNun
         0CAdT/Z2K23JSjOOUPRYWHrvzUMV61g9/KaHOWKsChPg+Mb4ap7EejgPUM6ZIhBPYQPg
         QjFqiB0qi2JoSedU8oI3oLHQAAOdPIvhDy/RNHJhFVGhTiYKXPK9fiqUze0NDszDX0IB
         T5xQ==
X-Gm-Message-State: AOJu0Yx9eF+Rb4K4/ykQtFhoTJyUU10msHPEZKaGOU+BTBy/guYrkfdV
        6C17EXRuTbRgCvqwrrZWqmZwkzNnmmM=
X-Google-Smtp-Source: AGHT+IHTqfMaDOaUACBBNjywMbrRhxv3au8SZnqO5B/WdcHe7acDDk0Hy7ETXXqWEiO/SZnVQovTmDtZn3c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:88a:b0:5a7:b87d:9825 with SMTP id
 cd10-20020a05690c088a00b005a7b87d9825mr74938ywb.5.1697560034031; Tue, 17 Oct
 2023 09:27:14 -0700 (PDT)
Date:   Tue, 17 Oct 2023 09:27:12 -0700
In-Reply-To: <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
Message-ID: <ZS614OSoritrE1d2@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
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
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
> > +
> > +       /*
> > +        * If a VMM-specific certificate blob hasn't been provided, grab the
> > +        * host-wide one.
> > +        */
> > +       snp_certs = sev_snp_certs_get(sev->snp_certs);
> > +       if (!snp_certs)
> > +               snp_certs = sev_snp_global_certs_get();
> > +
> 
> This is where the generation I suggested adding would get checked. If
> the instance certs' generation is not the global generation, then I
> think we need a way to return to the VMM to make that right before
> continuing to provide outdated certificates.
> This might be an unreasonable request, but the fact that the certs and
> reported_tcb can be set while a VM is running makes this an issue.

Before we get that far, the changelogs need to explain why the kernel is storing
userspace blobs in the first place.  The whole thing is a bit of a mess.

sev_snp_global_certs_get() has data races that could lead to variations of TOCTOU
bugs: sev_ioctl_snp_set_config() can overwrite psp_master->sev_data->snp_certs
while sev_snp_global_certs_get() is running.  If the compiler reloads snp_certs
between bumping the refcount and grabbing the pointer, KVM will end up leaking a
refcount and consuming a pointer without a refcount.

	if (!kref_get_unless_zero(&certs->kref))
		return NULL;

	return certs;

If allocating memory for the certs fails, the kernel will have set the config
but not store the corresponding certs.

	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
		if (ret)
			goto e_free;

		memcpy(&sev->snp_config, &config, sizeof(config));
	}

	/*
	 * If the new certs are passed then cache it else free the old certs.
	 */
	if (input.certs_len) {
		snp_certs = sev_snp_certs_new(certs, input.certs_len);
		if (!snp_certs) {
			ret = -ENOMEM;
			goto e_free;
		}
	}

Reasoning about ordering is also difficult, e.g. what is KVM's contract with
userspace in terms of recognizing new global certs?

I don't understand why the kernel needs to manage the certs.  AFAICT the so called
global certs aren't an input to SEV_CMD_SNP_CONFIG, i.e. SNP_SET_EXT_CONFIG is
purely a software defined thing.

The easiest solution I can think of is to have KVM provide a chunk of memory in
kvm_sev_info for SNP guests that userspace can mmap(), a la vcpu->run.

	struct sev_snp_certs {
		u8 data[KVM_MAX_SEV_SNP_CERT_SIZE];
		u32 size;
		u8 pad[<size to make the struct page aligned>];
	};

When the guest requests the certs, KVM does something like:

	certs_size = READ_ONCE(sev->snp_certs->size);
	if (certs_size > sizeof(sev->snp_certs->data) ||
	    !IS_ALIGNED(certs_size, PAGE_SIZE))
		certs_size = 0;

	if (certs_size && (data_npages << PAGE_SHIFT) < certs_size) {
		vcpu->arch.regs[VCPU_REGS_RBX] = certs_size >> PAGE_SHIFT;
		exitcode = SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN);
		goto cleanup;
	}

	...

	if (certs_size &&
	    kvm_write_guest(kvm, data_gpa, sev->snp_certs->data, certs_size))
		exitcode = SEV_RET_INVALID_ADDRESS;

If userspace wants to provide garbage to the guest, so be it, not KVM's problem.
That way, whether the VM gets the global cert or a per-VM cert is purely a userspace
concern.

If userspace needs to *stall* cert requests, e.g. while the certs are being updated,
then that's a different issue entirely.  If the GHCB allows telling the guest to
retry the request, then it should be trivially easy to solve, e.g. add a flag in
sev_snp_certs.  If KVM must "immediately" handle the request, then we'll need more
elaborate uAPI.
