Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4677CAD0E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjJPPMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJPPMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:12:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC81B4;
        Mon, 16 Oct 2023 08:12:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D4BC433C7;
        Mon, 16 Oct 2023 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697469138;
        bh=g/bXGDF5OR5KCvzXVNH6/8DzHZo5VWjQwH7GIxQdFGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUjpChg+DY8uoKKxuO37VkQ3GE8rbf6ymwFIvFCkv8p745HE4Bjh9F8cbGoimqPAT
         f0TIUWGiTDTPW11LBccodll0AkMU4Um0KsgxhnOpDeXPNmPy0Oe2FXMpguW19nkY28
         hHtnug/xdUzQNhwERiwzB/grgOfc6G3Xoz1xoPP0=
Date:   Mon, 16 Oct 2023 17:12:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v10 01/50] KVM: SVM: INTERCEPT_RDTSCP is never
 intercepted anyway
Message-ID: <2023101627-species-unscrew-2730@gregkh>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-2-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-2-michael.roth@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 08:27:30AM -0500, Michael Roth wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> svm_recalc_instruction_intercepts() is always called at least once
> before the vCPU is started, so the setting or clearing of the RDTSCP
> intercept can be dropped from the TSC_AUX virtualization support.
> 
> Extracted from a patch by Tom Lendacky.
> 
> Cc: stable@vger.kernel.org
> Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (cherry picked from commit e8d93d5d93f85949e7299be289c6e7e1154b2f78)
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

What stable tree(s) are you wanting this applied to (same for the others
in this series)?  It's already in the 6.1.56 release, and the Fixes tag
is for 5.19, so I don't see where it could be missing from?

thanks,

greg k-h
