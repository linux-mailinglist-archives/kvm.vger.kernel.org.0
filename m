Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97C054AB0B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 09:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355464AbiFNHwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 03:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355433AbiFNHv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 03:51:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBA6541615
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 00:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655193072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uPRneHusWliPXCUnYK+9EGAAe+6/D9lx6nqXCclDon0=;
        b=YtvBKDnoym0MKUUfrrqjEdCMU/0vISMzR5YGM5orPBHltcq0U1wbUiG9ad+jGA3/mJRgWx
        f0LmmnQAM7IsGSQ7lhgkM4sj9XTDFHAJAZQ6DWT2M0FgfDtuP390wYpmk4YKmil74ucQxa
        gT8AGoD21wM3iWM+6ZK+EUFTCDos8RE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-yYEzbACpOuGCp62VDh75rg-1; Tue, 14 Jun 2022 03:51:10 -0400
X-MC-Unique: yYEzbACpOuGCp62VDh75rg-1
Received: by mail-ej1-f69.google.com with SMTP id t15-20020a1709066bcf00b0070dedeacb2cso2507705ejs.9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 00:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uPRneHusWliPXCUnYK+9EGAAe+6/D9lx6nqXCclDon0=;
        b=EDRjt5SiDDwERZbkC6bPUDgGQYFPW4nDYwVP3Fp7iDHZngVz4mK7N5ARJWv16+6DCw
         NeUM4ywGep2xW3PavD883BeyooSzGPr7UUwxkQ04FmN+JI/MgGJGxNzg6Gj0r5cga0mV
         TCSRG2XTD8dBgwR761ZpJAz2Tj+42YiYG+ZFUPQyFEBHQ9ft8VdDOZswQzAvfOoE5lnF
         +VlJ8TtAGkwEJhrScq5IjsxT94vRQrWNfkV2G+ZK83ig3gvfhJTZKQL1dD/dGV05rWbK
         8U+vDA+3z+uD5N0vrmWgRcd4dxTKMFb1xeDZ3LNTVAtciteMWh3ebeZHYIWEXXMo0jQc
         jygg==
X-Gm-Message-State: AOAM53138WLuSXdYO5fITttWHfGRFwRuselsMLf1npaTyzJls58rFb6k
        NYfug4EvrP6uU6qOSPFngzGwcIeiWiSJwkENC+uYFPcJF4RfaJ4565Tj7pflW97lcpEyfxlA3QC
        98b+kQVE1/3ue
X-Received: by 2002:a17:906:dff9:b0:6ff:2f22:7d0 with SMTP id lc25-20020a170906dff900b006ff2f2207d0mr3047021ejc.198.1655193069521;
        Tue, 14 Jun 2022 00:51:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYEBUBc3BcXt1o4i05+IBpQ9wsv7cQh/xs3361eCZbAaltmofH+eb4wYomMNNzbwzZC/8iMg==
X-Received: by 2002:a17:906:dff9:b0:6ff:2f22:7d0 with SMTP id lc25-20020a170906dff900b006ff2f2207d0mr3047008ejc.198.1655193069312;
        Tue, 14 Jun 2022 00:51:09 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id m26-20020a056402051a00b0042dd2f2bec7sm6539259edv.56.2022.06.14.00.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 00:51:08 -0700 (PDT)
Date:   Tue, 14 Jun 2022 09:51:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: selftests: Fixups for overhaul
Message-ID: <20220614075106.463oqkerlaximxfl@gator>
References: <20220613161942.1586791-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613161942.1586791-1-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 04:19:38PM +0000, Sean Christopherson wrote:
> Fixups for the overhaul, all of which come from Drew's code review.  The
> first three should all squash cleanly, but the kvm_check_cap() patch will
> not due to crossing the TEST_REQUIRE() boundary.
> 
> Sean Christopherson (4):
>   KVM: selftests: Add a missing apostrophe in comment to show ownership
>   KVM: selftests: Call a dummy helper in VM/vCPU ioctls() to enforce
>     type
>   KVM: selftests: Drop a duplicate TEST_ASSERT() in
>     vm_nr_pages_required()
>   KVM: selftests: Use kvm_has_cap(), not kvm_check_cap(), where possible
> 
>  .../testing/selftests/kvm/aarch64/psci_test.c |  2 +-
>  .../selftests/kvm/include/kvm_util_base.h     | 57 ++++++++++---------
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  6 +-
>  .../selftests/kvm/lib/x86_64/processor.c      |  4 +-
>  .../selftests/kvm/s390x/sync_regs_test.c      |  2 +-
>  .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
>  .../selftests/kvm/x86_64/sev_migrate_tests.c  |  6 +-
>  tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
>  .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
>  9 files changed, 42 insertions(+), 41 deletions(-)
> 
> 
> base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

All these patches look good to me. For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

There's still one more comment I made on the overhaul though, which
is that the expressions using i and j in kvm_binary_stats_test.c
for the vcpus and vcpu_stat_test indices have i and j swapped.

Thanks,
drew

