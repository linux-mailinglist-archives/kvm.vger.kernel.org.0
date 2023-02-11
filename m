Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C29692D89
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBKDMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBKDMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:12:43 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF68D2A6FE
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676085161; x=1707621161;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SQS7Cp+9rTI43kMj1y0cqtLZZpNDV4DXYVic59DthvY=;
  b=DUyX3xA/fMQa3QLkpZjrG58crvzXRzZttWWstXeWSLwbxvqsPziEf/DV
   +x5FlT7GyoTNn+yBPs0gKe3AG9PyL1c6JTQ+9swJAbulYV9f4TZXfVtlQ
   AbgsULLcSF/Nau+uGPNGPQ3DvLf4vVCfVTzcl2PBrMQbJdj0enL7vev5b
   Yxule5bVIMNsgUnWMiAH23on7HmuzJzmF1tybTXzt0je/K268lMS6iwoY
   Thu8oH8yeQu3z5LGfTG2ss3Ip0qgyoN2LyZymwJaHEcGXv3cPGXOLl80N
   IoiKiupEs+VdlCI9jFdCKbZCO2TaI8eGHFPPgxxN+MFFwS8kzavjHgJUV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="330586305"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="330586305"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 19:12:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="645830134"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="645830134"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 10 Feb 2023 19:12:35 -0800
Message-ID: <ed1462784624c7dc094fb6992de9be441b641be5.camel@linux.intel.com>
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Date:   Sat, 11 Feb 2023 11:12:34 +0800
In-Reply-To: <817d2f5d-79f9-2e2e-ba7d-8e643c75e37b@intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-3-robert.hu@linux.intel.com>
         <817d2f5d-79f9-2e2e-ba7d-8e643c75e37b@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 11:38 +0800, Yang, Weijiang wrote:
> On 2/9/2023 10:40 AM, Robert Hoo wrote:
> 
> [...]
> 
> 
> > -
> > +#ifdef CONFIG_X86_64
> > +	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 |
> > X86_CR3_LAM_U57);
> > +#else
> >   	root_pgd = mmu->get_guest_pgd(vcpu);
> > +#endif
> 
> I prefer using:
> 
> root_pgd = mmu->get_guest_pgd(vcpu);
> 
> if (IS_ENABLED(CONFIG_X86_64))
> 
>      root_pgd &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> 
> I looks more structured.
> 
OK, thanks, both look all right to me.
Just don't quite understand the "structured" meaning, would you
elaborate more? Same as 8d5265b1016 ("KVM: x86/mmu: Use IS_ENABLED() to
avoid RETPOLINE for TDP page faults")?

