Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7998C6946CA
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 14:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjBMNQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 08:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjBMNQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 08:16:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3B61B32F
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 05:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676294177; x=1707830177;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CpV0vSoxZJ/nZ3SIpvvN3iZsl2HwfVvX/fhASLemtYM=;
  b=ZO39v1U95OaU1etgTau3kcjd7V+u8h0p6MZ5X9t0DGIwpPJT/kvhvTTH
   Xl1wE56hB5c4rsqo6yCE1Jm9CpgpyQm46xgieTR776vLqf4oSVMITL3hX
   zWbxjy3hRLYskK1P0K8n48AxbsFfO/C0G/xwEpPdJohmhrP0rb7DigVXM
   lXF00J3qic7saKlmfAnai93fY65Jp2trs2qZD9AyfOA4AM5VsZlN280Vb
   wI1+gZMYw7T6YU/Funu+HgHTA+fEM2JNrVdB39Hs7BAftPzxqSEMA4r0h
   VYb8E+FFW9IezU9pTqVuzR3L1glpoKAKepGqVy1PqesXaLpDMef9/XN7b
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="310518756"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310518756"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 05:16:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="668803285"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="668803285"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 13 Feb 2023 05:16:12 -0800
Message-ID: <2111f65546b65ecadb0660d094698d51b9ad474c.camel@linux.intel.com>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Mon, 13 Feb 2023 21:16:11 +0800
In-Reply-To: <f6db6ca0-8ed8-857d-5115-e22bf7d596fc@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <f6db6ca0-8ed8-857d-5115-e22bf7d596fc@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-13 at 17:02 +0800, Binbin Wu wrote:
> > 3. For user mode address, it is possible that 5-level paging and
> > LAM_U48 are both
> >     set, in this case, the effective usable linear address width is
> > 48, i.e. bit
> >     56:47 is reserved by LAM. [2]
> 
> How to understand "reserved by LAM"?
> 
> According to the spec, bits 56:48 of the pointer contained metadata.
> 
Emm, looks it's superfluous words, I'll remove it in next version.
I meant the same as your understanding: bit 56:48 could be used by
metadata,  and cleared before translation, therefore not usable by 5-
level paging, "reserved by LAM".

