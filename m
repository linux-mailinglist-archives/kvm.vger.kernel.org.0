Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D247D72C37A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbjFLLwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjFLLwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:52:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D410F3;
        Mon, 12 Jun 2023 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686570532; x=1718106532;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+22Jf0EMHFPnCqknPTx9ZddJNhv2p1ffZekjkOO7nn4=;
  b=YiV/3bOPs0pkrntYdJieKyPSpH3Jjo8IXP6LxHKbnhB0rFMDavZo6wXo
   tA8I94qCnB2jhrJ0N4WLA/sK1CIccZ2nE3TeqxYTD57wlpXac4BrZWgqP
   klUdPq79oPz7HYQ5cS7TZoo9qRSA5lwmZSIHbHxDcL88wstkpZJQGsuCJ
   5iXYwfF1sjpoGuUfpo3+rf7iCYhpkr2sPZya7yEcUvzP5+2HJQiJihPLW
   0bP6J0eJZc7S4v/iMFCQ5CyeviurnU9qzVlYYRjNiM8AXCuXcw7t9FY9T
   ih2ITg+4voHD9d+xKFVETSkupf7NJe0/WLDaG0iPEnugYF3EdC1UnB/kV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="360501371"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="360501371"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 04:48:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="740998332"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="740998332"
Received: from smizr3x-mobl3.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.127])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 04:48:46 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 4FE6610CC1C; Mon, 12 Jun 2023 14:48:43 +0300 (+03)
Date:   Mon, 12 Jun 2023 14:48:43 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230612114843.n7vvoh7m2rk4la56@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 10:27:44AM +0000, Huang, Kai wrote:
> Does it make sense?

I understand your logic. AFAICS, it is correct (smp_mb() instead of __mb()
would be better), but it is not justified from complexity PoV. This
lockless exercise gave me a pause to understand.

Lockless doesn't buy you anything here, only increases complexity.
Just take a lock.

Kernel is big. I'm sure you'll find a better opportunity to be clever
about serialization :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
