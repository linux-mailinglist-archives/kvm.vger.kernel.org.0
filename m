Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A0B6A70A6
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 17:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCAQQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 11:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCAQQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 11:16:09 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC8B3E08D;
        Wed,  1 Mar 2023 08:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677687366; x=1709223366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1VIcxlNqALCE6K076ogEvaaxbdQU5+tCvUM4TI9dvy0=;
  b=ZPg5gHIgj79GGF8IRo1tX0Ox2n6RKvpufBC/+hGXZ5+wggI82A5msyUQ
   Lmsew0eQv3mxsrraRoJPUoQp0JSr45/81/TsliGTjMMwIonBRE80bt+pn
   vsLwqP7Fnfo4EEcL/L6tv6ow+q1n5FNYch9gfqPyp6hAhtuLbmqwD+MPl
   Ryo+gxvjxLPZXEdjdAGNWotrP+89E3IZmIY44iKRvkbiL0MnwaM2zOU6c
   l2VcZZYl55k9V6kZeKElCnFyAn6QsfHbx2/6br+ffxCgZRtuoGfLXEUfQ
   LnBjYE7xgbq8GDNBdvrFUGeNZmM6ki98DTlqyDGUeyeLPp0R4cpGP4EuR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322714281"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="322714281"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:15:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="817622794"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="817622794"
Received: from asaha3-mobl1.amr.corp.intel.com (HELO [10.251.12.67]) ([10.251.12.67])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:15:47 -0800
Message-ID: <140c3675-376a-be37-56da-878b08df5507@intel.com>
Date:   Wed, 1 Mar 2023 08:15:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct
 map when adding them to the RMP table
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
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
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-16-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230220183847.59159-16-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 10:38, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The integrity guarantee of SEV-SNP is enforced through the RMP table.
> The RMP is used with standard x86 and IOMMU page tables to enforce
> memory restrictions and page access rights. The RMP check is enforced as
> soon as SEV-SNP is enabled globally in the system. When hardware
> encounters an RMP-check failure, it raises a page-fault exception.
> 
> The rmp_make_private() and rmp_make_shared() helpers are used to add
> or remove the pages from the RMP table. Improve the rmp_make_private()
> to invalidate state so that pages cannot be used in the direct-map after
> they are added the RMP table, and restored to their default valid
> permission after the pages are removed from the RMP table.

This is a purely "what" changelog.  It doesn't explain the "why" at all.

Could you please elaborate on why this unmapping operation is necessary?
