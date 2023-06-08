Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89566727F05
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjFHLl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 07:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbjFHLl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 07:41:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153C9272A;
        Thu,  8 Jun 2023 04:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686224497; x=1717760497;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JIEyUpAEAWl/6gc2W02IseOhPJ0I3+IVQSnr6ctlzmY=;
  b=PR+kFdpAJeJKD0PHcv2bte9RZCxPO6DaWunt57J3QMf9FjWUywyl//FA
   0j38HhIykRdgGkBQ/uZbT08qy6EjpCmcSHulRFCaQQGP2v5TwLlgceTKu
   Vg8jS+ODpmhAZaImSWV1iF5GDrcetrJ/nGv5Y6g89Mby3wKUrpOpZV0BZ
   vuN5UPsHrufvUiR8LHAfvCyUbqd+YaEW/ie2JhJe/q5GXyWRpsKzXs9QV
   8otSGKypOQALWzCI2ozbK8O5ia7XsoTG1xzbnUK2RgACeaEWOspyO5fv9
   a7lM0Si1MFJgtqwlOlZEEAtKPdfRURl4GhGQfAbNUs5hM8xeixmArBD/n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="423134637"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="423134637"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 04:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="956672751"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="956672751"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 04:41:31 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id D1D3C10A676; Thu,  8 Jun 2023 14:41:28 +0300 (+03)
Date:   Thu, 8 Jun 2023 14:41:28 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
 <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
 <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 02:40:27AM +0000, Huang, Kai wrote:
> On Thu, 2023-06-08 at 03:27 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Mon, Jun 05, 2023 at 02:27:21AM +1200, Kai Huang wrote:
> > > For now both 'tdsysinfo_struct' and CMRs are only used during the module
> > > initialization.  But because they are both relatively big, declare them
> > > inside the module initialization function but as static variables.
> > 
> > This justification does not make sense to me. static variables will not be
> > freed after function returned. They will still consume memory.
> > 
> > I think you need to allocate/free memory dynamically, if they are too big
> > for stack.
> 
> 
> I do need to keep tdsysinfo_struct as it will be used by KVM too.

Will you pass it down to KVM from this function? Will KVM use the struct
after the function returns?

> CMRs are not
> used by KVM now but they might get used in the future, e.g., we may want to
> expose them to /sys in the future.
> 
> Also it takes more lines of code to do dynamic allocation.  I'd prefer the code
> simplicity.

These structures take 1.5K of memory and the memory will be allocated for
all machines that boots the kernel with TDX enabled, regardless if the
machine has TDX or not. It seems very wasteful to me.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov
