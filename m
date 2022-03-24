Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2214E6914
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 20:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbiCXTLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 15:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243953AbiCXTLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 15:11:15 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6805FB82D7
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 12:09:43 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id p22so6539997iod.2
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 12:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gSZ1pFD9J4Ey3fBqKMQXdfkMWuB8SzWWcZFXgR7CDmU=;
        b=KbNwuLbtmroLbV/WPhZIS7MWpRxJdgcodENrRGGtuXYJ2kcPLWrk8T9eUB6sB/OJEy
         fMIGDaVXYLat4ddvRV4bYOlfRqWVQzsyZe1Dyd0l4Sb7v7kd7qrpqMqi1RvH0I3tVQGK
         038FuOUKslrBSY9MP4VVzvVmJaZcz8O/Hvh70ki5owWEatnJDTJx8C5LBTxauuCwTfne
         sNBJhH7rFELxhLf+MfbsPJcZoplJpqfCPftiEF7EGE9gznqORzvuh2DEgkfg2IHOKgb7
         zquVF63XztGkCYmyCS82xwK75ShQLioG6uA/Ektur2AGSBLYGqV4ohEVR1YRT/U6l7bQ
         nMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gSZ1pFD9J4Ey3fBqKMQXdfkMWuB8SzWWcZFXgR7CDmU=;
        b=pu8vT3s7C2MeA+taOOVOA5587Vd4ku/gph73acg5jOLkt/XfwM0UITkOhK+NlpZOdS
         aAw2E/fU5UECnQ1woed2aSw5UYOrMoTk3sl0zpeQc/FWtKZ9t8Ak/erfw/vESpFHkDUK
         G3byYrAoto+l+rlflMiNXyyeULNgiGgco9UeX3OJVR0Qs2dNd9Lx/5Z/G0nfyMiS0UNi
         8HxhcusgyN8de50CuGFw5+se11BaFyZxfhjm1/uL2pTfO0JGjQ/EvF/DA6i62IdJKCGY
         FQX+HrcBw6gI2XygdPmBO0u208D63tkX9hinSSCRSHWA6b9Oju0wXMZulPDQ01hyz/e4
         HDWQ==
X-Gm-Message-State: AOAM532b7+odk9/sQDSUakzcyr+fkjsBU8bsAsfzLbvvXSx0IMnlh2/2
        zRNeCAb6l/CaBQjqZTR1emB7JPxhB6iy1w==
X-Google-Smtp-Source: ABdhPJwlGrNB/9M7rNP8xG8XNp0T9F0Qp6jw+Ld5x7Wl9rWI2wmDqBdGoi8CggOXVbA4FlmwoBCf6Q==
X-Received: by 2002:a05:6638:1692:b0:321:2495:2c79 with SMTP id f18-20020a056638169200b0032124952c79mr3728135jat.72.1648148982308;
        Thu, 24 Mar 2022 12:09:42 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id i3-20020a056602134300b0064620a85b6dsm2034021iov.12.2022.03.24.12.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:09:41 -0700 (PDT)
Date:   Thu, 24 Mar 2022 19:09:38 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN
Message-ID: <YjzB8nMugCPCNtKH@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316005538.2282772-3-oupton@google.com>
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

I realized there was some leftover debugging residue in this test, and
some blatantly obvious copy/pasting. I'll address in v2, but as an FYI:

On Wed, Mar 16, 2022 at 12:55:38AM +0000, Oliver Upton wrote:
> Add a test that asserts KVM rewrites guest hypercall instructions to
> match the running architecture (VMCALL on VMX, VMMCALL on SVM).
> Additionally, test that with the quirk disabled, KVM no longer rewrites
> guest instructions and instead injects a #UD.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/fix_hypercall_test.c | 170 ++++++++++++++++++
>  3 files changed, 172 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 9b67343dc4ab..1f1b6c978bf7 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -15,6 +15,7 @@
>  /x86_64/debug_regs
>  /x86_64/evmcs_test
>  /x86_64/emulator_error_test
> +/x86_64/fix_hypercall_test
>  /x86_64/get_msr_index_features
>  /x86_64/kvm_clock_test
>  /x86_64/kvm_pv_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 6d69e196f1b7..c9cdbd248727 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -48,6 +48,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
>  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
> +TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
> diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> new file mode 100644
> index 000000000000..1f5c32146f3d
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020, Google LLC.
> + *
> + * Tests for KVM paravirtual feature disablement

Oops.

[...]

> +	case UCALL_SYNC:
> +		pr_info("%s: %016lx\n", (const char *)uc.args[2], uc.args[3]);
> +		break;

This was for debugging, there are no ucalls in the guest any more.

--
Thanks,
Oliver
