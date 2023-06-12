Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5872CBF7
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbjFLRAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 13:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbjFLRAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 13:00:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDEAE71;
        Mon, 12 Jun 2023 10:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686589204; x=1718125204;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lINzTdir4qaEtcszrtUnYr0rUxQ02JyprEtg0yNn6yc=;
  b=dqLy3sYwmsF1OXoEq0bTn9CWWw9UsVt5jEjeQm7XXbPbOlfNhp+4Mwno
   q+aTCdCTkAOftj3CKvj0iobt3U81xun6JIIBph3qCMHBp4+azKQMU2Iph
   mcTiyIOpJnp07u9LAOWVCbzfiK8Ag3S/gass2kBu+dY5dLkV54KGanltP
   eD/DjwIJRc8mV9PIaWzbn8td3OywsQ9iIv5BkRKsZ97IVHV2UZErXyf69
   rNDALd3WGX2H6Y1V39y/qG89XPu/Bf3Smm+D3+YKSht4ZgbvyrSBkDhgJ
   UktnezFh1kOatvaPfVlq5dg6GKfrtmn27ozsdRqgpRegolcjCnfOo7rJt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="355600413"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="355600413"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 10:00:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="741098047"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="741098047"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 10:00:01 -0700
Message-ID: <d627220d-e8e0-7a8d-73a7-ce3633359f57@intel.com>
Date:   Mon, 12 Jun 2023 10:00:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 14/51] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
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
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-15-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230612042559.375660-15-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/23 21:25, Michael Roth wrote:
> +/*
> + * Assign a page to guest using the RMPUPDATE instruction.
> + */
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
> +{
> +	struct rmp_state val;
> +
> +	pr_debug("%s: GPA: 0x%llx, PFN: 0x%llx, level: %d, immutable: %d\n",
> +		 __func__, gpa, pfn, level, immutable);

Is this needed *EVERY* time a page is assigned to a guest?  As in, if I
create a 4GB guest, I'll see a literal million of these pr_debug()s in
dmesg?

