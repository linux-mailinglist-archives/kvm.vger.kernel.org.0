Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E1A7410EA
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjF1Mcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:32:41 -0400
Received: from mga06b.intel.com ([134.134.136.31]:29059 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbjF1Mck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687955560; x=1719491560;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LwuLIpTDFUZ3/oZliTaoWA+Y3rIbrn82/cfQFTII+Yk=;
  b=HWXc8hTO8paMLqWai/0CIeMf5PIibitKUZH+PjhEeb5QlNQaKiJHzyvJ
   Hnteen2FlEmpsV05ea7+Y1o5nxD+DGYCJCqI8EkWyLuB7mnV+SKMMZOl+
   4gIHiTpsIXyPLA0EDrQFeIvwBmn5PtLaG4L+Z6kfGv7Pmh2ACSwOnDD2E
   pbbJOwx7cj3oLUq+g+ChboEb8JgBfHzAtwxS3HNFXdFt6TzhRWuHQzAKm
   cm+O+dO8Pg2qWPosHbfDAnLT2Rgky8Gp8vLT0sx2TKE+yQu3LehlnNiiR
   SgixExSf27vurrbVwyoRQ/rJJVgtekuTMBOMh8oHfqnt1YxP8rtb9ybxj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="425502900"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="425502900"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="806875831"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="806875831"
Received: from rajritu-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.187])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:32:32 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 2F9271095C8; Wed, 28 Jun 2023 15:32:29 +0300 (+03)
Date:   Wed, 28 Jun 2023 15:32:29 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230628123229.byp3bl7husxt6eso@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:50AM +1200, Kai Huang wrote:
> On the platform with the "partial write machine check" erratum, a kernel
> partial write to TDX private memory may cause unexpected machine check.
> It would be nice if the #MC handler could print additional information
> to show the #MC was TDX private memory error due to possible kernel bug.
> 
> To do that, the machine check handler needs to use SEAMCALL to query
> page type of the error memory from the TDX module, because there's no
> existing infrastructure to track TDX private pages.
> 
> SEAMCALL instruction causes #UD if CPU isn't in VMX operation.  In #MC
> handler, it is legal that CPU isn't in VMX operation when making this
> SEAMCALL.  Extend the TDX_MODULE_CALL macro to handle #UD so the
> SEAMCALL can return error code instead of Oops in the #MC handler.
> Opportunistically handles #GP too since they share the same code.
> 
> A bonus is when kernel mistakenly calls SEAMCALL when CPU isn't in VMX
> operation, or when TDX isn't enabled by the BIOS, or when the BIOS is
> buggy, the kernel can get a nicer error message rather than a less
> understandable Oops.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
