Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0581555987D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 13:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiFXLXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 07:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiFXLXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 07:23:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F79220C3;
        Fri, 24 Jun 2022 04:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656069799; x=1687605799;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xgjsDnXlP1t2rfiijqMLMBJUg2+1poD5XRUpahbyPQg=;
  b=Jqd9q9VFUcoYY6jbavLgMCdoec9vsTV9KX1a/LSVv31u/7/YWRIaaguK
   yz9n9KEh38VC1Jy4y1pYgn2+jhx0rj9Fb1b+84R2QSC/9I5hMBod40Onq
   eWNCCL6PyRo01vByjWb/PTaW9/msOl3A1284DDTdqpGo36JJ5um77AFkA
   N56rmK+koN/KfMAnowkEiUghMn4fl5gBoEXTJbh4jAE95Jx3NkIsPgKMM
   C2lS4Sp0jtMvD4aSnR+4wOZe0vD6WFqS042Vi2cG1eO/J2aa5Yy4WC0JY
   jzEQcKGHaPYIFvyO4uQ3NbpWPtrSqFHuIh8Qyk5vwLFKhANGFQUDS+uds
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="264020161"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="264020161"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:23:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="915645909"
Received: from jvrobert-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.99.67])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:23:15 -0700
Message-ID: <97945fb19901f6ec11c72b015f55f6bb42cbc7c1.camel@intel.com>
Subject: Re: [PATCH v5 05/22] x86/virt/tdx: Prevent hot-add driver managed
 memory
From:   Kai Huang <kai.huang@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org
Date:   Fri, 24 Jun 2022 23:23:13 +1200
In-Reply-To: <20220624021200.GB15566@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
         <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
         <20220624021200.GB15566@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 10:12 +0800, Chao Gao wrote:
> On Wed, Jun 22, 2022 at 11:16:19PM +1200, Kai Huang wrote:
> > @@ -55,6 +55,7 @@
> > #include <asm/uv/uv.h>
> > #include <asm/setup.h>
> > #include <asm/ftrace.h>
> > +#include <asm/tdx.h>
> >=20
> > #include "mm_internal.h"
> >=20
> > @@ -972,6 +973,26 @@ int arch_add_memory(int nid, u64 start, u64 size,
> > 	return add_pages(nid, start_pfn, nr_pages, params);
> > }
> >=20
> > +int arch_memory_add_precheck(int nid, u64 start, u64 size, mhp_t mhp_f=
lags)
> > +{
> > +	if (!platform_tdx_enabled())
> > +		return 0;
>=20
> add a new cc attribute (if existing ones don't fit) for TDX host platform=
 and
> check the attribute here. So that the code here can be reused by other cc
> platforms if they have the same requirement.

Please see my explanation in the commit message:

The __weak arch-specific hook is used instead of a new CC_ATTR similar
to disable software CPU hotplug.  It is because some driver managed
memory resources may actually be TDX-capable (such as legacy PMEM, which
is underneath indeed RAM), and the arch-specific hook can be further
enhanced to allow those when needed.


--=20
Thanks,
-Kai


