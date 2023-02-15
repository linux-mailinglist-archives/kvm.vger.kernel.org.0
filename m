Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BE8697D24
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 14:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjBONZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 08:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjBONZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 08:25:33 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED87274BF;
        Wed, 15 Feb 2023 05:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o8nHcYwdgi5dYAVXOPCLhYnFf1f1EfIQ8SqfEDzFWkw=; b=AN6OHde5imKffEHRQZGWI+RwRR
        6jBGeGjqpJRGHRGwxDVfcgNpyqZKP1iCZVhPVwowJcyendmftvAi1fi7mlDy0Gu4ShxswIpI6wMyh
        WEuAccn5HT6TPEoeVoItrOWro323eZEeHWbwWmXbQO6mvk/3gW70yXwufNDPpns3VnshexH70DVm7
        iEbqhVhtS476shYMSaanJgV8crimum8tHuXZeCkSAlHLwUgmh1d+enALIGldFaLFfjVmF/Tgf1mCu
        zMikJHfb/jH/6z11YeU7gBSFd6TPmzOziIhx5fULKoOzjzvyaFaDqb5Cy9Nu0DCjvO5NbPeInnyhP
        zxrxyYZg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pSHlo-009wmA-1H;
        Wed, 15 Feb 2023 13:25:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6509E3001D6;
        Wed, 15 Feb 2023 14:25:05 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 490822CEE165F; Wed, 15 Feb 2023 14:25:05 +0100 (CET)
Date:   Wed, 15 Feb 2023 14:25:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Message-ID: <Y+zdMZjApMWJ97GP@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
 <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
 <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
 <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
 <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
 <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
 <Y+yi4B+P9K2FXNqt@hirez.programming.kicks-ass.net>
 <24bd9d546d07b57387ecd990746061ae35ce5fa5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24bd9d546d07b57387ecd990746061ae35ce5fa5.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 09:46:10AM +0000, Huang, Kai wrote:
> Yes agreed.  Your code below looks indeed better.  Thanks!
> 
> Would you mind send me a patch so I can include to this series, or would you
> mind get it merged to tip/x86/tdx (or other branch I am not sure) so I can
> rebase?

Just take the patch, add your comments and test it.. enjoy! :-)
