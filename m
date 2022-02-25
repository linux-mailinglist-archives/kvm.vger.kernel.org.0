Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855EE4C4293
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiBYKl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbiBYKlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 05:41:23 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AAF68FA6;
        Fri, 25 Feb 2022 02:40:51 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2870B447; Fri, 25 Feb 2022 11:40:49 +0100 (CET)
Date:   Fri, 25 Feb 2022 11:40:44 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v6 0/7] KVM: SVM: Add initial GHCB protocol version 2
 support
Message-ID: <YhiyLJOHyfA7sLMt@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping. Any comments on these patches?

On Tue, Jan 25, 2022 at 03:16:19PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Hi,
> 
> here is a small set of patches which I originally took from the
> pending SEV-SNP patch-sets to enable basic support for GHCB protocol
> version 2. Meanwhile a couple of other patches from Sean
> Christopherson have been added.
> 
> When SEV-SNP is not supported, only two new MSR protocol VMGEXIT calls
> are required:
> 
> 	- MSR-based AP-reset-hold
> 	- MSR-based HV-feature-request
> 
> These calls are implemented here and then the protocol is lifted to
> version 2.
> 
> This is submitted separately because the MSR-based AP-reset-hold call
> is required to support kexec/kdump in SEV-ES guests.
> 
> The previous version can be found here:
> 
> 	https://lore.kernel.org/kvm/20211020124416.24523-1-joro@8bytes.org/
> 
> Regards,
> 
> 	Joerg
> 
> Changes v5->v6:
> 
> 	- Rebased to v5.17-rc1
> 	- Added changes requested by Sean Christopherson
> 
> Brijesh Singh (2):
>   KVM: SVM: Add support for Hypervisor Feature support MSR protocol
>   KVM: SVM: Increase supported GHCB protocol version
> 
> Joerg Roedel (2):
>   KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions
>   KVM: SVM: Move kvm_emulate_ap_reset_hold() to AMD specific code
> 
> Sean Christopherson (2):
>   KVM: SVM: Add helper to generate GHCB MSR verson info, and drop macro
>   KVM: SVM: Set "released" on INIT-SIPI iff SEV-ES vCPU was in AP reset
>     hold
> 
> Tom Lendacky (1):
>   KVM: SVM: Add support to handle AP reset MSR protocol
> 
>  arch/x86/include/asm/kvm_host.h   |   2 +-
>  arch/x86/include/asm/sev-common.h |  18 ++--
>  arch/x86/include/uapi/asm/svm.h   |   1 +
>  arch/x86/kvm/svm/sev.c            | 169 ++++++++++++++++++++----------
>  arch/x86/kvm/svm/svm.c            |  13 ++-
>  arch/x86/kvm/svm/svm.h            |  10 +-
>  arch/x86/kvm/x86.c                |  12 +--
>  7 files changed, 137 insertions(+), 88 deletions(-)
> 
> 
> base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
> -- 
> 2.34.1
