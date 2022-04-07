Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B382A4F71BA
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbiDGBxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiDGBxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:53:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3C51760CE;
        Wed,  6 Apr 2022 18:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649296305; x=1680832305;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8DtzLU3U8hXDQVnsh7CjvEXB4QGvifxzFkJ+wv29zuU=;
  b=QR26ioWfJT5ew9sPXA2M7WJn8Uy62KorHKOqXFLtYiKg9qMJ56G0dFbX
   c6zqZh3QDa3RfNf20BYHkeX1A18bo1ZVB8gJoFIfec4JhzeUqZycDoM+2
   Iq9L4Qw5P+akM9MxD8bhke5kmWngX+VsU59r0hJsG7uGnpuc+MSxzmCt4
   ei3G3AV2JrZxJ269ECYffpp19+15janOT0+BOevo8erk8kJPqFIcDIRkc
   gmIh5mUCL59w0LkmA1WdksdOleeb779ltLHBpudsVJFTUXdLdMjZHOeht
   dCAHN7l4ndxAz1045Z7RUIPun7ZGAsuRMrnRMK+DdPJOgX4Y60m8aVZt3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="260898870"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="260898870"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:51:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="524176604"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:51:40 -0700
Message-ID: <34d773c8d32c8d38033aae7e0fee572d757e242c.camel@intel.com>
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX
 specific parameters
From:   Kai Huang <kai.huang@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 13:51:38 +1200
In-Reply-To: <a1052ec0-4ea6-d5db-a729-deec08712683@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
         <e392b53a-fbaa-4724-07f4-171424144f70@redhat.com>
         <a1052ec0-4ea6-d5db-a729-deec08712683@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-07 at 09:29 +0800, Xiaoyao Li wrote:
> On 4/5/2022 8:58 PM, Paolo Bonzini wrote:
> > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > +    td_params->attributes = init_vm->attributes;
> > > +    if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > > +        pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
> > > +            "host perf registers properly.\n");
> > > +        return -EOPNOTSUPP;
> > > +    }
> > 
> > Why does KVM have to hardcode this (and LBR/AMX below)?  Is the level of 
> > hardware support available from tdx_caps, for example through the CPUID 
> > configs (0xA for this one, 0xD for LBR and AMX)?
> 
> It's wrong code. PMU is allowed.
> 
> AMX and LBR are disallowed because and the time we wrote the codes they 
> are not supported by KVM. Now AMX should be allowed, but (arch-)LBR 
> should be still blocked until KVM merges arch-LBR support.

I think Isaku's idea is we don't support them in the first submission?

If so as I suggested, we should add a TODO in comment..

