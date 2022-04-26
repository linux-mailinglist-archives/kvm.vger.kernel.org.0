Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46496510AC9
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355170AbiDZU4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344812AbiDZU4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:56:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352604889D;
        Tue, 26 Apr 2022 13:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651006398; x=1682542398;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yl/Zc0AZRDi45jgsJfvzClqb0ZXk0tbOP5iYoO41XQE=;
  b=mRLNP6R/p7L4XU3trXExAY5dJUd87aHdGOBGNITel4g3HWs1UPvJ1O3D
   hhDPs6fqukIdruoNikJXECg56i8Ur5eo76w9h9otvLrVWRC85xMOJNwpH
   wqnbgbYAsqNgO48Ku5jKFxibddR59/xM/Vcw86R5tm+RHdx229eDCUJnf
   h3NIz843Lhecg2ldX40sfaj3sjl8yjbiFS+uDKMfU+7njlOsJQ0E8UsEF
   EwYd0l5mmx8zqFhSkJwUJ932h8BuMYEJ5cLMKcb8IkHHSxnVD6KBnzxyw
   FX3WmZXLWuQIWF3l0wi+inI+SRpl+JVRcT5irIlYwcmPVN+uREyVFjEJ7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="326207692"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="326207692"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:53:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="580152884"
Received: from dsocek-mobl2.amr.corp.intel.com (HELO [10.212.69.119]) ([10.212.69.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:53:16 -0700
Message-ID: <104a6959-3bd4-1e75-5e3d-5dc3ef025ed0@intel.com>
Date:   Tue, 26 Apr 2022 13:56:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 05/21] x86/virt/tdx: Detect P-SEAMLDR and TDX module
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <b9f4d4afd244d685182ce9ab5ffdd0bf245be6e2.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b9f4d4afd244d685182ce9ab5ffdd0bf245be6e2.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> The P-SEAMLDR (persistent SEAM loader) is the first software module that
> runs in SEAM VMX root, responsible for loading and updating the TDX
> module.  Both the P-SEAMLDR and the TDX module are expected to be loaded
> before host kernel boots.

Why bother with the P-SEAMLDR here at all?  The kernel isn't loading the
TDX module in this series.  Why not just call into the TDX module directly?
