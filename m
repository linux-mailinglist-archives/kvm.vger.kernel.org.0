Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDEC557689
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 11:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiFWJXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 05:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiFWJXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 05:23:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1561FCC7;
        Thu, 23 Jun 2022 02:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655976227; x=1687512227;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QDlGykX9O0/coZOraXMV7FheH9yMt2KDusOcdgjN3go=;
  b=nVcdfs1NIeVz+iySynOaGgAJNTlMjyWLtup03oaODlb5MeMBCAYQC/Qp
   bE1zI9QEIYXMcOi1uduWbcB+/prJIreznE75AGdFPhRcnFOEnznajNZNi
   Pg0qlrpj9hJMjrG6R97vy3TFtMXAPOUjVnHoYL/jrGHeyHgg/8q3SndUi
   mQxzJaR/XljszRyeLIZ1c1DrKM5azeugDavzAkGXpdFPya34QBn6aSV6K
   3JPKZzX3c98fmF6kX6gW8xTLogh7LFRwCo7sbGmBAPxO7Ych9uRsNj1//
   55IY2IBJEoPgIdqFxiLybQYZKbIOzNzkRBI1wP/tTz0zt3PyaL/fHZoWY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="261102373"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="261102373"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 02:23:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="834556443"
Received: from mjalmada-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.144.88])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 02:23:43 -0700
Message-ID: <d6d7d42f494320500ce3fbbdd4810482348dc5d4.camel@intel.com>
Subject: Re: [PATCH v5 01/22] x86/virt/tdx: Detect TDX during kernel boot
From:   Kai Huang <kai.huang@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 23 Jun 2022 21:23:41 +1200
In-Reply-To: <20220623055658.GA2934@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
         <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
         <20220623055658.GA2934@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-23 at 13:57 +0800, Chao Gao wrote:
> On Wed, Jun 22, 2022 at 11:15:30PM +1200, Kai Huang wrote:
> > Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> > host and certain physical attacks.  TDX introduces a new CPU mode calle=
d
> > Secure Arbitration Mode (SEAM) and a new isolated range pointed by the
> 						    ^ perhaps, range of memory

OK.  The spec indeed says "execute out of memory defined by SEAM ranger reg=
ister
(SEAMRR)".

>=20
> > +static int detect_tdx_keyids(void)
> > +{
> > +	u64 keyid_part;
> > +
> > +	rdmsrl(MSR_IA32_MKTME_KEYID_PARTITIONING, keyid_part);
>=20
> how about:
> 	rdmsr(MSR_IA32_MKTME_KEYID_PARTITIONING, tdx_keyid_start, tdx_keyid_num)=
;
> 	tdx_keyid_start++;
>=20
> Then TDX_KEYID_NUM/START can be dropped.

OK will do.

>=20
> > +
> > +	tdx_keyid_num =3D TDX_KEYID_NUM(keyid_part);
> > +	tdx_keyid_start =3D TDX_KEYID_START(keyid_part);
> > +
> > +	pr_info("TDX private KeyID range: [%u, %u).\n",
> > +			tdx_keyid_start, tdx_keyid_start + tdx_keyid_num);
> > +
> > +	/*
> > +	 * TDX guarantees at least two TDX KeyIDs are configured by
> > +	 * BIOS, otherwise SEAMRR is disabled.  Invalid TDX private
> > +	 * range means kernel bug (TDX is broken).
>=20
> Maybe it is better to have a comment for why TDX/kernel guarantees
> there should be at least 2 TDX keyIDs.

"TDX guarantees" means it is architectural behaviour.  Perhaps I can change=
 to
"TDX architecture guarantee" to be more explicit.

This part is currently not in the public spec, but I am working with others=
 to
add this to the public spec.

>=20
> > +
> > +/*
> > + * This file contains both macros and data structures defined by the T=
DX
> > + * architecture and Linux defined software data structures and functio=
ns.
> > + * The two should not be mixed together for better readability.  The
> > + * architectural definitions come first.
> > + */
> > +
> > +/*
> > + * Intel Trusted Domain CPU Architecture Extension spec:
> > + *
> > + * IA32_MTRRCAP:
> > + *   Bit 15:	The support of SEAMRR
> > + *
> > + * IA32_SEAMRR_PHYS_MASK (core-scope):
> > + *   Bit 10:	Lock bit
> > + *   Bit 11:	Enable bit
> > + */
> > +#define MTRR_CAP_SEAMRR			BIT_ULL(15)
>=20
> Can you move this bit definition to arch/x86/include/asm/msr-index.h
> right after MSR_MTRRcap definition there?

The comment at the beginning of this file says:

/*
 * CPU model specific register (MSR) numbers.
 *
 * Do not add new entries to this file unless the definitions are shared
 * between multiple compilation units.
 */

I am not sure whether adding a new bit of one MSR (which is already defined=
) is
adding a "new entry".  Perhaps it is not.  But I'd like to leave to maintai=
ners.

--=20
Thanks,
-Kai


