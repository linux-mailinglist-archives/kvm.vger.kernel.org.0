Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F925631A9
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiGAKnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiGAKmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:42:46 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0147BD1B;
        Fri,  1 Jul 2022 03:42:45 -0700 (PDT)
Received: from zn.tnic (p200300ea970ff648329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:970f:f648:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 856321EC059D;
        Fri,  1 Jul 2022 12:42:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1656672159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SWhCxOJUAdsvqOpxyv8QTMa/YznelRxtMa+3KCBAmCU=;
        b=VfMj79baSekma4xFxVrkmV7L+rj6Z2maopnfrFmPEjLleGOALxaW+uTtB/VaB/rc6JrFGe
        QSa+TzpouUp17YdzBr1v5gYQ4aUh8yCBG2g5HBWefZ4qFd+8Jf7s7Vy21LRImaayFJasOj
        mDBhXy2Dcy9SCUdJdWZpwx/+FjBmdwc=
Date:   Fri, 1 Jul 2022 12:42:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, michael.roth@amd.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Message-ID: <Yr7Pm/E9WsAjirV0@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 10:59:19PM +0000, Ashish Kalra wrote:
> +bool iommu_sev_snp_supported(void)
> +{
> +	struct amd_iommu *iommu;
> +
> +	/*
> +	 * The SEV-SNP support requires that IOMMU must be enabled, and is
> +	 * not configured in the passthrough mode.
> +	 */
> +	if (no_iommu || iommu_default_passthrough()) {
> +		pr_err("SEV-SNP: IOMMU is either disabled or configured in passthrough mode.\n");
> +		return false;
> +	}
> +
> +	/*
> +	 * Iterate through all the IOMMUs and verify the SNPSup feature is
> +	 * enabled.
> +	 */
> +	for_each_iommu(iommu) {
> +		if (!iommu_feature(iommu, FEATURE_SNP)) {
> +			pr_err("SNPSup is disabled (devid: %02x:%02x.%x)\n",
> +			       PCI_BUS_NUM(iommu->devid), PCI_SLOT(iommu->devid),
> +			       PCI_FUNC(iommu->devid));
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(iommu_sev_snp_supported);

Why is this function exported?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
