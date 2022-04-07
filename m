Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C249F4F78F6
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242716AbiDGIFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbiDGIFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:05:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBB41AFE91;
        Thu,  7 Apr 2022 01:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649318532; x=1680854532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+8nqlOCnM4E5EVS5AkBvLJ/A45G+Z1LOHwhaoO9GbkI=;
  b=dXCJ4TdlYelFD5FsXphADvDLSBS614XUTrZRluvhTdgI2kkzDeJKKhja
   Wr7DeBwSpR1ivDu8NKO8OyvG8ipqjuzEduidYBMyA36kUmEMtuexZgXxw
   PBuzEsYYp0+mR71kNdL6j6hWl3Lt0ByIvQ205e94SscUOZM/0eHbE2z16
   LSY6xh/ByIlOD6s1NU1KWhnmS1s5hgGFHyjTZahtZk5bM/h3deyDrm16n
   pn8HKJ8VK8VLFckVQTRkQLpoO11/2X2v4CEqQPlKxrw6lo1VkRl8pwPJm
   FaIahhUTYnkkbvuEDBq1ZiOC5yVxgK7qPXta+7svDN8KWKlEyl9D8UD70
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="241850734"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="241850734"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 01:02:12 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722857740"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 01:02:09 -0700
Message-ID: <a23077a5-777f-85fb-05fa-b91e21aca0e7@intel.com>
Date:   Thu, 7 Apr 2022 16:02:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 3/3] KVM: nVMX: Clear IDT vectoring on nested VM-Exit for
 double/triple fault
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20220407002315.78092-1-seanjc@google.com>
 <20220407002315.78092-4-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220407002315.78092-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/2022 8:23 AM, Sean Christopherson wrote:
> Clear the IDT vectoring field in vmcs12 on next VM-Exit due to a double
> or triple fault.  Per the SDM, a VM-Exit isn't considered to occur during
> event delivery if the exit is due to an intercepted double fault or a
> triple fault.  Opportunistically move the default clearing (no event
> "pending") into the helper so that it's more obvious that KVM does indeed
> handle this case.
> 
> Note, the double fault case is worded rather wierdly in the SDM:
> 
>    The original event results in a double-fault exception that causes the
>    VM exit directly.
> 
> Temporarily ignoring injected events, double faults can _only_ occur if
> an exception occurs while attempting to deliver a different exception,
> i.e. there's _always_ an original event.  And for injected double fault,
> while there's no original event, injected events are never subject to
> interception.
> 
> Presumably the SDM is calling out that a the vectoring info will be valid
> if a different exit occurs after a double fault, e.g. if a #PF occurs and
> is intercepted while vectoring #DF, then the vectoring info will show the
> double fault.  

Wouldn't it be a tripe fault exit in this case?

> In other words, the clause can simply be read as:
> 
>    The VM exit is caused by a double-fault exception.

