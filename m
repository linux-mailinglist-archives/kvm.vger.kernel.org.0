Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6A555B7C1
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 07:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiF0F1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 01:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiF0F1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 01:27:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05075FB0;
        Sun, 26 Jun 2022 22:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656307662; x=1687843662;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2D93qOLka+Gpjz16jAW/W1nPcGyL/5WlDEew9HTSVUs=;
  b=P82NCG4PzLYJao+a2r7hyNYz4MH7LgkMuOle415IA8ZkUCg2gFFqgg8R
   LFpk/vUs4Mm2eK8Nw4RN6Z08+WaBw6IhSWHxKsK4lyjhYSvF+JLd6UNGA
   sIiTrx+r9WX3CgFNghanZNieKgm4HJzER3VgNoHwQOEUNgtWuPxaN2yqm
   15KjxuCEkWPsyfctMQdZilwJA23Vj3gzdiljLnXHEcTRF9/Y7Io3TIbCq
   6oT1qsSRaAUaEa2/IqVnnC00pHfAFXZIVfdZqkdmIsukaST0OGsXqWFhW
   GMLPb69/knm8XT5n8m2Jh5qyyDujEE6Qvy4P1B6YeQneXRM/sfwl5kulx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="282451605"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="282451605"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:27:42 -0700
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="539986307"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:27:38 -0700
Message-ID: <8ce8bd5792f44348e5e7384c93389bd0be5336b1.camel@intel.com>
Subject: Re: [PATCH v5 05/22] x86/virt/tdx: Prevent hot-add driver managed
 memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org
Date:   Mon, 27 Jun 2022 17:27:36 +1200
In-Reply-To: <9a4ff92a-1d79-d91e-0dbc-a1cbde215184@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
         <9a4ff92a-1d79-d91e-0dbc-a1cbde215184@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 12:01 -0700, Dave Hansen wrote:
> On 6/22/22 04:16, Kai Huang wrote:
> > @@ -1319,6 +1330,10 @@ int __ref add_memory_resource(int nid, struct re=
source *res, mhp_t mhp_flags)
> >  	if (ret)
> >  		return ret;
> > =20
> > +	ret =3D arch_memory_add_precheck(nid, start, size, mhp_flags);
> > +	if (ret)
> > +		return ret;
>=20
> Shouldn't a patch that claims to be only for "driver managed memory" be
> patching add_memory_driver_managed()?

Right given the ACPI memory hotplug is handled in a separate patch.  Will m=
ove
to add_memory_driver_managed().


--=20
Thanks,
-Kai


