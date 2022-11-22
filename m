Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118E8634464
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiKVTOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiKVTOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:14:35 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE118D481;
        Tue, 22 Nov 2022 11:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oIW+mez/TFEcYehOEAG21RzQumZyO2HavfYb/Bz1UQw=; b=lzR3kl2UCxAuBYbI6TPTxCTPmT
        EMf/yFp1NbWNALLVOLdkkie9U2ANZW7evhz2eJDhYvxmSY3wtY2NbstsRgX90A4kTqJfqHp5nPYj4
        TrvfblYjfgTCGTPwE7MG+voWZEuJpwPHW2FlFOUf/xiA/WC85XD0J3h3PEgwaITBTWaU9GcYaBoDV
        ZGUzJPUqp9ZAoiV1+mR5x8pMmQxyJIYCdkHPwTINApKngLvrdmp31bcFVj7km1x3MFCqqV3BxeOsy
        ym5BHgz0yQuVzAiafUHrzKnHN0NzuPtwII2f7hZqysFyyB+ziBgZ3acHRhzJABzq/9EiXpR3chCho
        sKN6e6/w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxYis-003Yt6-Dn; Tue, 22 Nov 2022 19:14:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E0F5A300445;
        Tue, 22 Nov 2022 20:14:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D1DDC20B64111; Tue, 22 Nov 2022 20:14:21 +0100 (CET)
Date:   Tue, 22 Nov 2022 20:14:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y30fjcRlXiWFhnym@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <bea49f7f-8411-662f-9fa8-97c98f61ce8b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bea49f7f-8411-662f-9fa8-97c98f61ce8b@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 10:57:52AM -0800, Dave Hansen wrote:

> To me, this starts to veer way too far into internal implementation details.
> 
> 	Issue the TDH.SYS.LP.SHUTDOWN SEAMCALL on all BIOS-enabled CPUs
> 	to shut down the TDX module.

We really need to let go of the whole 'all BIOS-enabled CPUs' thing.
