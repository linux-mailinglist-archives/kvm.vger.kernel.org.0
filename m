Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3835A6344A4
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiKVTdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiKVTdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:33:32 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D1B25C54;
        Tue, 22 Nov 2022 11:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ewJjoQL0S/lNHIZz4LCupDwv1iWHwoScCQKkcN/XzFc=; b=XGQjjLHE+GaPoNGTYy+4Y4JZUB
        4pNmj0d+J/kKV64iJu24lV5KDMwqdkvtAcBsOeTU8BCoVLEX80t8HT/mXERtoMZoszHaSyl46vXgR
        qqSGV/dVD4Lm2ESzNtDhKR4dthTkq9qiaqDY71OMiGA2JQM/aVK+KDaOAXv88pgeIU01UjyeSVbza
        J4bKeyIlTTfz/J9MMOB0GIXNiWF9aY5neZuJ4k+wSGl0gj8mgZ61Dn/rnymADGESZbiCUYdSDbDMf
        gZihxDBp/9gFFZbubVMwJdacxj3Ul1WYGqlMYPNYD9WZbK+ENe9VkGDNZZm0Idh333+OohG04qCKS
        +G76noiQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxZ1A-003Z8D-VR; Tue, 22 Nov 2022 19:33:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 50A20300445;
        Tue, 22 Nov 2022 20:33:16 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 349572D2BCFAF; Tue, 22 Nov 2022 20:33:16 +0100 (CET)
Date:   Tue, 22 Nov 2022 20:33:16 +0100
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
Message-ID: <Y30j/EJ9Y1/gWcXo@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 11:24:48AM -0800, Dave Hansen wrote:

> > Not intialize TDX on busy NOHZ_FULL cpus and hard-limit the cpumask of
> > all TDX using tasks.
> 
> I don't think that works.  As I mentioned to Thomas elsewhere, you don't
> just need to initialize TDX on the CPUs where it is used.  Before the
> module will start working you need to initialize it on *all* the CPUs it
> knows about.  The module itself has a little counter where it tracks
> this and will refuse to start being useful until it gets called
> thoroughly enough.

That's bloody terrible, that is. How are we going to make that work with
the SMT mitigation crud that forces the SMT sibilng offline?

Then the counters don't match and TDX won't work.

Can we get this limitiation removed and simply let the module throw a
wobbly (error) when someone tries and use TDX without that logical CPU
having been properly initialized?
