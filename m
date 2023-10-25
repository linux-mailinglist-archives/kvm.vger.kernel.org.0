Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330707D725A
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 19:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjJYRe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 13:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJYReZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 13:34:25 -0400
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AFA137;
        Wed, 25 Oct 2023 10:34:23 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 05B4C40E00B1;
        Wed, 25 Oct 2023 17:34:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7Pf1WCNFuvJb; Wed, 25 Oct 2023 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698255257; bh=cWIDMNOmR3ejJPcU9ueROUfewQ1CyI98mmrkHIjnZ44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g6VLSRnRm5zCmwYW7CVRcW/eVYsEK3mhd4c3sl/AfsohA2o2R1IXnFQaZk8uvMonR
         xUnzHqJaAxFj6ztSQ29uPqXt/mVG0zKrfKKr3+unht/AshxNaXRxKIccmGS3l+8Ckm
         QEx1rfg9VC7PTlrPV9la72GosU9iwiSVuIG8KwsbAhHLsAtOSRWlO9pPq5NuriOzWu
         KzIyf/6JQjTe9YgoEt39cyJprQp4aeue5zmmjF3nhG59IjNztQ9xkuxNre/qEKJQrU
         HsGxkqT2V6+6DFhClTwx/qHV5J1BHDnnItTn4CM5EaY/lPPW1zZYgFMCN/k29KJK3l
         xKizx5105HyvvpFZ+aq87XaKSH9dvbrWxo3J1CG/YWCAfBr8cF4WwFBheWLW6R91+v
         fgjtzs77e3LuESXRQnLNSXKSmScZFqNeXvGDTUglNtPLOAzRoeRHEXV5RpveuAKx59
         7AwfyjPkdIzBUKBSTC6KkKe9x1ZNgJqRUj6RdSLxYnVItRqoqrpN2CrNx9Hz5KsxFw
         n1zVRlT8bSixc2z4YX4Ea4utNAqf/RYC3Y27/Ei7NGc6OOXqA7jWXBr1X3IfSrKmoA
         s6xwu3gstPtxWNXyYcB9b9X9i925IhMy0522+oreqktadtrynCM2YYc4tdtHa+CTtt
         agJepz0t8AYaGiH8fapHIGKY=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AAE5E40E0199;
        Wed, 25 Oct 2023 17:33:36 +0000 (UTC)
Date:   Wed, 25 Oct 2023 19:33:31 +0200
From:   Borislav Petkov <bp@alien8.de>
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
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v10 05/50] x86/speculation: Do not enable Automatic IBRS
 if SEV SNP is enabled
Message-ID: <20231025173331.GCZTlRa3Tzfc1fHvCu@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-6-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-6-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 08:27:34AM -0500, Michael Roth wrote:
> From: Kim Phillips <kim.phillips@amd.com>
> 
> Without SEV-SNP, Automatic IBRS protects only the kernel. But when
> SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
> host-side code, including userspace. This protection comes at a cost:
> reduced userspace indirect branch performance.
> 
> To avoid this performance loss, don't use Automatic IBRS on SEV-SNP
> hosts. Fall back to retpolines instead.
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> [mdr: squash in changes from review discussion]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
