Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4A5696AB0
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjBNRCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjBNRCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:02:33 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CBE2B280;
        Tue, 14 Feb 2023 09:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8B5ZElURr/XjF1AaFAx7TJ6oNbHocgBeCuJWbIFebVs=; b=eXMXdx1znonW4q50NOYWzJkWyq
        a+jULmeMnnppezZroud58fnN3XD5zk5eI819GkMaWEctmHh4ozFhd4Z/la2E0COxWuQ+go60pt81T
        aJBOUZJjMylcs7kB+PSMM9DTwxiTNGnDXBji+yKzp0TavV0UY6oXe0cJOnT+tu6oeiDimpA4A7/g+
        tf9SLdLWZqFhbNokMFD+8/K7GVdIdMsOXMOMsL1VAvjxqVujLtXikplmPAZKnSJXaX0YEUG+bKQ3G
        oT7OSCju7aCTes16uwoKl9UCvzYUH51sruL0L/khAsLmQRyJx3elYUlQpMd6NoBPN9cLVPyJvsuq0
        Kf0covuw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRyfy-009hH0-2l;
        Tue, 14 Feb 2023 17:01:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C14723033F7;
        Tue, 14 Feb 2023 13:46:45 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A9F5323BC86ED; Tue, 14 Feb 2023 13:46:45 +0100 (CET)
Date:   Tue, 14 Feb 2023 13:46:45 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v9 04/18] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Message-ID: <Y+uCtZ7itiNsbR4j@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <eb565156d84e35a846a886025513a712f2ac2f83.1676286526.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb565156d84e35a846a886025513a712f2ac2f83.1676286526.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 12:59:11AM +1300, Kai Huang wrote:
> Use a state machine protected by mutex to make sure the initialization
> will only be done once, as tdx_enable() can be called multiple times
> (i.e. KVM module can be reloaded) and be called concurrently by other
> kernel components in the future.

I still object to doing tdx_enable() at kvm module load.

kvm.ko gets loaded unconditionally on boot, even if I then never use
kvm.

This stuff needs to be done when an actual VM is created, not before.
