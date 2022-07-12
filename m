Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5461C5711B4
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 07:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiGLFHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 01:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiGLFHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 01:07:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A692F39E;
        Mon, 11 Jul 2022 22:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657602460; x=1689138460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sKkU5tclbj1atbJcHwSP7zmsBQzx3Y2Qup5ImaPKP18=;
  b=MpX7EFRD5i8eihkye77SKaTpIA0fT2J+pFPsd6ZZeNScq6eBtLTTrfS0
   jA51qwx56QUCK9EvfA0ve3ONJYHjty+kV56kEMHzZ/q1xR88sTDQaTTEE
   4G/G6usO9SSWzubKMocsXYd8uAAu4W8COCXwxQ5Eqs0zSz0uvG3YBOic+
   RuTE/ruL/vFvWTp7rgk3APc6YKnU/gpdE503xQaMSNkvcZwaFZcV9h7T1
   2MrhXbKABBjgisx5U8yJMkGv6Q9jRDGvGg25c7/idssLSwMxx9le4S/Yr
   z6uhJwLaAFh7jeMGS0fDuVERzcWm/qm/SQ0jdT5oHoF1CgTFO6Mzt5Cep
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="371147894"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="371147894"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 22:07:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="652757351"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 22:07:38 -0700
Date:   Tue, 12 Jul 2022 13:07:20 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        chao.p.peng@intel.com
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220712050714.GA26573@gao-cwp>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <20220711151701.GA1375147@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711151701.GA1375147@ls.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11, 2022 at 08:17:01AM -0700, Isaku Yamahata wrote:
>Hi. Because my description on large page support was terse, I wrote up more
>detailed one.  Any feedback/thoughts on large page support?
>
>TDP MMU large page support design
>
>Two main discussion points
>* how to track page status. private vs shared, no-largepage vs can-be-largepage

...

>
>Tracking private/shared and large page mappable
>-----------------------------------------------
>VMM needs to track that page is mapped as private or shared at 4KB granularity.
>For efficiency of EPT violation path (****), at 2MB and 1GB level, VMM should
>track the page can be mapped as a large page (regarding private/shared).  VMM
>updates it on MapGPA and references it on the EPT violation path. (****)

Isaku,

+ Peng Chao

Doesn't UPM guarantee that 2MB/1GB large page in CR3 should be either all
private or all shared?

KVM always retrieves the mapping level in CR3 and enforces that EPT's
page level is not greater than that in CR3. My point is if UPM already enforces
no mixed pages in a large page, then KVM needn't do that again (UPM can
be trusted).

Maybe I am misunderstanding something?
