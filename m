Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7B47989C2
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbjIHPWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 11:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbjIHPWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 11:22:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6430C1BFA;
        Fri,  8 Sep 2023 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694186556; x=1725722556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2pJ1Njghwnio74sizFtHiEiT47JWSloBF6ZeODCQUuk=;
  b=I62EFaqQu7H/M/Oi29LP/SSkK3ZKnTP4Nhcwx8mNH3BFoF4auStjT+Dh
   AkgzEL2qq/T3g/KEQPWAtB/wL0o0uW7qS6J8BX7dar3zTzKtulWrfMteK
   iKhhsvPoal4E8oMC2IhEd23uV0b7O6AzjlQLR10VpLjzR/nFDSL7lbWPO
   PLMSrH9fuFHS+17T3lO+MymoGR94gTtcnBj0kuX9PNCnec47Al5ZcuVev
   X/kS2hLQLMZGbiPfk74xpsHZtTHu0gJJrcZ/KPfong/x4Sn88nZydUjhl
   UpsTPKtJqnwWy6/UxK9qG8eJU9AVrILcQnXKvi4+GEQOugR++P7GOKiug
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="380406584"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="380406584"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 08:22:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="719185891"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="719185891"
Received: from fgilganx-mobl1.amr.corp.intel.com (HELO [10.209.17.195]) ([10.209.17.195])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 08:22:34 -0700
Message-ID: <cbc3aabb-6a38-37f0-81aa-1cbfba445d95@intel.com>
Date:   Fri, 8 Sep 2023 08:22:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v13 04/22] x86/cpu: Detect TDX partial write machine check
 erratum
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
 <b089f93223958c168b5abd8eef0f810d616adb99.1692962263.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b089f93223958c168b5abd8eef0f810d616adb99.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 05:14, Kai Huang wrote:
> TDX memory has integrity and confidentiality protections.  Violations of
> this integrity protection are supposed to only affect TDX operations and
> are never supposed to affect the host kernel itself.  In other words,
> the host kernel should never, itself, see machine checks induced by the
> TDX integrity hardware.

This is missing one thing: alluding to how this will be used.  We might
do that by saying: "To prepare for _____, add ______."

But that's a minor nit.

...
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
