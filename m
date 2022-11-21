Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486406330F1
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiKUXrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiKUXqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:46:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E7D13DD3;
        Mon, 21 Nov 2022 15:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669074399; x=1700610399;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ChUK9z0fO3txURJegQq1Ot4LtVL2rrlg1GScs2p04DM=;
  b=iS/hwFUaKLgyruDqKWzqHOdXSputqjWHzKeC6GpTTPpfoqupCYLMfiUn
   i0NV7PmYkMy1jDrJlk5wQsnoWOJHm9u8vWJ+DzwuOLiWWqieDyK8k5JUM
   yOqDrCFLOgxwb8aWYLn5Dex6qoMghI52OFQsIwdwiXWUHtmuL/1PLMIgh
   C9Rnn8dquzVX/MQlx+6X6/tKtq+jXrajCEFBbCKbQNuAr4yQcf56plsW5
   M2m3u1+lGfYy0omhStuR1c2gfxVG1jUKV+kQPNWMgsIYfk4kx/Qz/3HlD
   7Dg8my0MtgrkH4q440owC3tYMzvucNY16uyH51AtXIMQ2sQ1IfLnvmKdu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="293397329"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="293397329"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:46:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747109361"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="747109361"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:46:36 -0800
Message-ID: <87e17024-755d-e195-d9ea-ef62a4de6aa8@intel.com>
Date:   Mon, 21 Nov 2022 15:46:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> The MMIO/xAPIC interface has some problems, most notably the APIC LEAK
> [1].  This bug allows an attacker to use the APIC MMIO interface to
> extract data from the SGX enclave.
> 
> TDX is not immune from this either.  Early check X2APIC and disable TDX
> if X2APIC is not enabled, and make INTEL_TDX_HOST depend on X86_X2APIC.

This makes no sense.

This is TDX host code.  TDX hosts are untrusted.  Zero of the TDX
security guarantees are provided by the host.

What is the benefit of disabling TDX from the host if x2APIC is not
enabled?  It can't be for security reasons since the host does not help
provide TDX security guarantees.  It also can't be for SGX because SGX
doesn't depend on the OS doing anything in order to be secure.

So, this boils down to the most fundamental of questions you need to
answer about every patch:

What does this code do?

What end-user-visible effect is there if this code is not present?
