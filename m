Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8128513EEE
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 01:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350263AbiD1XRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 19:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiD1XRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 19:17:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C19C0F;
        Thu, 28 Apr 2022 16:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651187658; x=1682723658;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sj3XpADlCbglKpym9j5lm2lYu3giubWJ3sf+UJL2fdM=;
  b=XR/qniP/6RyJaOVNd/8RDZFANa0/dGgyrB7G2Gp80IxcSPP8uP02f0Cz
   Od1kv7fAEhng1yg9FfxQpCHS6utijtm/OqdwHeUi+NP5yNlxqKEYlyvgk
   BqRoRQ+wzeLSZQF75/PEQ84SPev6bHVVOVTzXj6DR7+JWhV2Qlrfj5Tnt
   sGN73xeAiQ02xY7FZda/u0qwXemd3pHKoqYCgzC5hhaGXqYWJDLeHRgat
   1qEJpXupIEzQRLbzoiRqxUBBn3MT03qvYi1uVLfvZyRjhHTuINGVr0jU7
   GlZQ1fpLNS+etc0w3NTQkrE4QMBFQmArROm7mmomBRUp7YUF12okWPEfM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266270749"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266270749"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:14:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="597021674"
Received: from gshechtm-mobl.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.191])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:14:14 -0700
Message-ID: <be31134cf44a24d6d38fbf39e9e18ef223e216c6.camel@intel.com>
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 29 Apr 2022 11:14:11 +1200
In-Reply-To: <98f81eed-e532-75bc-d2d8-4e020517b634@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
         <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
         <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
         <98f81eed-e532-75bc-d2d8-4e020517b634@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 07:06 -0700, Dave Hansen wrote:
> On 4/27/22 17:15, Kai Huang wrote:
> > On Wed, 2022-04-27 at 15:15 -0700, Dave Hansen wrote:
> > > On 4/5/22 21:49, Kai Huang wrote:
> > > > TDX provides increased levels of memory confidentiality and integrity.
> > > > This requires special hardware support for features like memory
> > > > encryption and storage of memory integrity checksums.  Not all memory
> > > > satisfies these requirements.
> > > > 
> > > > As a result, TDX introduced the concept of a "Convertible Memory Region"
> > > > (CMR).  During boot, the firmware builds a list of all of the memory
> > > > ranges which can provide the TDX security guarantees.  The list of these
> > > > ranges, along with TDX module information, is available to the kernel by
> > > > querying the TDX module via TDH.SYS.INFO SEAMCALL.
> > > > 
> > > > Host kernel can choose whether or not to use all convertible memory
> > > > regions as TDX memory.  Before TDX module is ready to create any TD
> > > > guests, all TDX memory regions that host kernel intends to use must be
> > > > configured to the TDX module, using specific data structures defined by
> > > > TDX architecture.  Constructing those structures requires information of
> > > > both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
> > > > to get this information as preparation to construct those structures.
> > > > 
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > ---
> > > >  arch/x86/virt/vmx/tdx/tdx.c | 131 ++++++++++++++++++++++++++++++++++++
> > > >  arch/x86/virt/vmx/tdx/tdx.h |  61 +++++++++++++++++
> > > >  2 files changed, 192 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > > index ef2718423f0f..482e6d858181 100644
> > > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > > @@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
> > > >  
> > > >  static struct p_seamldr_info p_seamldr_info;
> > > >  
> > > > +/* Base address of CMR array needs to be 512 bytes aligned. */
> > > > +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
> > > > +static int tdx_cmr_num;
> > > > +static struct tdsysinfo_struct tdx_sysinfo;
> > > 
> > > I really dislike mixing hardware and software structures.  Please make
> > > it clear which of these are fully software-defined and which are part of
> > > the hardware ABI.
> > 
> > Both 'struct tdsysinfo_struct' and 'struct cmr_info' are hardware structures. 
> > They are defined in tdx.h which has a comment saying the data structures below
> > this comment is hardware structures:
> > 
> > 	+/*
> > 	+ * TDX architectural data structures
> > 	+ */
> > 
> > It is introduced in the P-SEAMLDR patch.
> > 
> > Should I explicitly add comments around the variables saying they are used by
> > hardware, something like:
> > 
> > 	/*
> > 	 * Data structures used by TDH.SYS.INFO SEAMCALL to return CMRs and
> > 	 * TDX module system information.
> > 	 */
> 
> I think we know they are data structures. :)
> 
> But, saying:
> 
> 	/* Used in TDH.SYS.INFO SEAMCALL ABI: */
> 
> *is* actually helpful.  It (probably) tells us where in the spec we can
> find the definition and tells how it gets used.  Plus, it tells us this
> isn't a software data structure.

Right.  I'll use your above comment.

> 
> > > > +	/* Get TDX module information and CMRs */
> > > > +	ret = tdx_get_sysinfo();
> > > > +	if (ret)
> > > > +		goto out;
> > > 
> > > Couldn't we get rid of that comment if you did something like:
> > > 
> > > 	ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);
> > 
> > Yes will do.
> > 
> > > and preferably make the variables function-local.
> > 
> > 'tdx_sysinfo' will be used by KVM too.
> 
> In other words, it's not a part of this series so I can't review whether
> this statement is correct or whether there's a better way to hand this
> information over to KVM.
> 
> This (minor) nugget influencing the design also isn't even commented or
> addressed in the changelog.

TDSYSINFO_STRUCT is 1024B and CMR array is 512B, so I don't think it should be
in the stack.  I can change to use dynamic allocation at the beginning and free
it at the end of the function.  KVM support patches can change it to static
variable in the file.

Or I can add a sentence saying KVM will need to use 'tdx_tdsysinfo' so use
static variable.  However currently KVM doesn't use CMR so no justification for
CMR array.

But I am thinking about memory hotplug interaction with TDX module
initialization.  That may use CMR info.  Let me send out proposal and close that
first to see whether this series needs to use CMR info out of this function.


