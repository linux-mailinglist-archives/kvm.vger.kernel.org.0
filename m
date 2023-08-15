Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D99777CFD5
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 18:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbjHOQBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 12:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbjHOQA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 12:00:59 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB0127
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 09:00:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5257d67368bso4827a12.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 09:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692115257; x=1692720057;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XpJb+OJfG+8YyFrgPemLQHLQMcBP2sLxedbL+4WkyQI=;
        b=12OED/nj8x27vkzaTPH4huvtjj1jVfmU0hALhPhRV6AHmDCTdQhEw61qFu0CiIfn5o
         xv23dzfwiXjilKF2V4mskgtYOlyAItz4mGPTN2wpAueITgQOP78cOJbBTI5T+qpxeb1D
         i+enASWV3RDnzBDsM9sJhV1dKddbywFKKUa61O57PtAiIAuwyGiXXM14LOto23UpYAxE
         PGemjOd/8RRrs6Lx5h5wH0joSWfAVxRthE6BXEwns8z2BhGRUhYJtOemEbyDvBnO44s/
         oV7zywqJBfWLvArDGYmw2b/xFekU2Hy5QZ25lKkvn+5v2YLe42/YEkzYEm+UrksNlC2f
         uQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692115257; x=1692720057;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XpJb+OJfG+8YyFrgPemLQHLQMcBP2sLxedbL+4WkyQI=;
        b=R9GtHQnihrCkiRQxUVkP7zqs3XD55xW71xdqIhzCb3OW1HIr4P2QAx+aSpsoErvMnO
         HJG+gQ/bDjotW73TpBIqiCFzNZ1kcRdXluQqbQGcW9gHIfZXn/rj2uZnq/z7RYwtvsep
         fFYz8OhC687VGwvcoFPnaiHFDvZcLUnSAJq+o9Ff3cB4vXXaJL19Spam8gGzZpR+9fGL
         VMRTO1K862WY5QbpehFBV+JOSknyrUbevZSzMiN/eEJU4xUIqlVLfRHXfEdlzm1bfe3W
         HpowjcMh8fRsMLy7NSmBkxMop0jqG5paeLUVwxHvJuDVp+CEPCQuE2dRly+CbT4Am+1Y
         Muaw==
X-Gm-Message-State: AOJu0YxOEbthlxYVjRctFi4npQyVZWzklh6WpDqBWkmM9y+Fqfuq+SM5
        Vk4CyJTYQrHQFAJWwCVs00Ufl1Mubq4MhDbOZPP/GQ==
X-Google-Smtp-Source: AGHT+IEdGhK9M3JtHIkjAkwh3xNQNLfzowgWF508z3Uj0qlA890h/RB4apOdF96xxD3sICYqpWEaeKcnTbjgLEFFWtk=
X-Received: by 2002:a50:9fa4:0:b0:506:b280:4993 with SMTP id
 c33-20020a509fa4000000b00506b2804993mr363704edf.2.1692115256934; Tue, 15 Aug
 2023 09:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230612042559.375660-1-michael.roth@amd.com> <20230612042559.375660-43-michael.roth@amd.com>
In-Reply-To: <20230612042559.375660-43-michael.roth@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 15 Aug 2023 10:00:45 -0600
Message-ID: <CAMkAt6r9noa7NCukf213cpmTOFgUSvowEOoGwRaGH+E4vxL20g@mail.gmail.com>
Subject: Re: [PATCH RFC v9 42/51] KVM: SVM: Support SEV-SNP AP Creation NAE event
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +
> +       switch (request) {
> +       case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> +               kick = false;
> +               fallthrough;
> +       case SVM_VMGEXIT_AP_CREATE:
> +               if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
> +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
> +                                   svm->vmcb->control.exit_info_2);
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +
> +               /*
> +                * Malicious guest can RMPADJUST a large page into VMSA which
> +                * will hit the SNP erratum where the CPU will incorrectly signal
> +                * an RMP violation #PF if a hugepage collides with the RMP entry
> +                * of VMSA page, reject the AP CREATE request if VMSA address from
> +                * guest is 2M aligned.
> +                */
> +               if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
> +                       vcpu_unimpl(vcpu,
> +                                   "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
> +                                   svm->vmcb->control.exit_info_2);

In this case and maybe the above case can we instead return an error
to the guest instead of a #GP?

I think Tom suggested: SW_EXITINFO1[31:0] to 2 (meaning there was an
error with the VMGEXIT request) and SW_EXITINFO2 to 5 (The NAE event
input was not valid (e.g., an invalid SW_EXITINFO1 value for the AP
Jump Table NAE event).

This way a non-malicious but buggy or naive guest gets a little more
information and a chance to retry the request?

> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +
> +               target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
> +               break;
> +       case SVM_VMGEXIT_AP_DESTROY:
> +               break;
> +       default:
> +               vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
> +                           request);
> +               ret = -EINVAL;
> +               break;
> +       }
> +
