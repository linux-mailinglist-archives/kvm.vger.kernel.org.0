Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720C358895C
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 11:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbiHCJZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 05:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbiHCJZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 05:25:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2442B6477;
        Wed,  3 Aug 2022 02:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659518724; x=1691054724;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Mpc9ql9WljDPRP7txCzjpWEnWSBDud0g9AFs6lsLb7c=;
  b=MiiwfjDEd8BwyOcV3SblIIuRghZBoLGnTsjLuq7SInxneDHdy/S2Yiel
   +jHKwgKwFN1PGG/LBEPZv0tkRzMSpByPyodzth7zEKE5O1SYCwjjIFwkp
   Ntxcjv/RaI/t7bpF+1Nsd89tnMdZghtnMyvq/UjsLJYdGn47mO8iThqjO
   hCv29smHg7n1g2AHOWsXFux5SpKxO35lDEOYSZeRJAvEQFvidLf+Ia1Ca
   rtPipAqsyv8kKKyZKK7+8S5I0Ld7ZklY+Ley/C7a04dyf47qg2djFqu4u
   P5B9ZfOpAchK7KrxoFP6aFVOX2qFwnG9fxwUKL9xr9DZFCwMQI/tLw88W
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="353631315"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="353631315"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:25:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="606323582"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:25:18 -0700
Message-ID: <49bdec04ae962e25d9c9dbce61a8098beba1682e.camel@intel.com>
Subject: Re: [PATCH v5 1/22] x86/virt/tdx: Detect TDX during kernel boot
From:   Kai Huang <kai.huang@intel.com>
To:     "Wu, Binbin" <binbin.wu@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 03 Aug 2022 21:25:16 +1200
In-Reply-To: <7bd30975-fdcc-7d87-af4a-448b92bb6e02@linux.intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
         <7bd30975-fdcc-7d87-af4a-448b92bb6e02@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-02 at 10:01 +0800, Wu, Binbin wrote:
> On 2022/6/22 19:15, Kai Huang wrote:
> > +	/*
> > +	 * TDX guarantees at least two TDX KeyIDs are configured by
> > +	 * BIOS, otherwise SEAMRR is disabled.  Invalid TDX private
> > +	 * range means kernel bug (TDX is broken).
> > +	 */
> > +	if (WARN_ON(!tdx_keyid_start || tdx_keyid_num < 2)) {
> Do you think it's better to define a meaningful macro instead of the=20
> number here and below?
> >=20

Personally I don't think we need a macro.  The comment already said "two", =
so=20
having a macro doesn't help readability here (and below).  But I am open on
this.

--=20
Thanks,
-Kai


