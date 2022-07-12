Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9785D571944
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiGLL61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiGLL6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:58:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F082F59D;
        Tue, 12 Jul 2022 04:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B93B81819;
        Tue, 12 Jul 2022 11:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C170DC3411C;
        Tue, 12 Jul 2022 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657627058;
        bh=I2isUddvIfyYxIILfJHOITCIxJP3S9I3oDgIC7Pbt48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UP4OLaoPDWXgj0dQ5SMvidVyDcHYo0UKYj4XJOmtvCHOPh6dezwodkVVzqkSuOAhO
         mjIPVQxOA5IeO7i1+9fa9Zeu5RmHUNS5KUgNXFtbnPV/C6cWiMx0Psfe8dLKB9vYpI
         WR8Ww4F8fyYRVQ+p+hIc0kMhJETRI7O4hef8Uum+8SA9UiuzFV8I9jxqZyqCx+j5zo
         0ojzM6fGKuuJbz/CcLv2U0MKM71XellXJdmbtvgp0vV8yMnUv7hEQzT60hN662MMRz
         JxrDUpqzXzqqQDOhjjWSpmX/J6GokjnlgFKZkHzYgBq/Xd1HO8KzPT3W0eYBxJRo1C
         a8EB/1Zu3bP8A==
Date:   Tue, 12 Jul 2022 14:57:34 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <Ys1hrq+vFbxRJbra@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> +/*
> + * Return 1 if the caller need to retry, 0 if it the address need to be split
> + * in order to resolve the fault.
> + */
> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
> +				      unsigned long address)
> +{
> +	int rmp_level, level;
> +	pte_t *pte;
> +	u64 pfn;
> +
> +	pte = lookup_address_in_mm(current->mm, address, &level);

As discussed in [1], the lookup should be done in kvm->mm, along the
lines of host_pfn_mapping_level().

[1] https://lore.kernel.org/kvm/YmwIi3bXr%2F1yhYV%2F@google.com/ 
|
BR, Jarkko
