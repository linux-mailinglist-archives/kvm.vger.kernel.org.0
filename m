Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4DB4E5A5D
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 22:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbiCWVIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 17:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240876AbiCWVIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 17:08:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32958CCCE;
        Wed, 23 Mar 2022 14:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6Op/HW7FahWIa5b2pzltH3d7JbhxTR87IMPNy0kIjzw=; b=QDoM+9poGmPAZ1FaZX88O+1PVi
        zk+uv36rDHRvGx99WvtWvIBechJyI8ZNdBDD7xPlmFqcBH/VYHnZC6TGxf5aSrgaLpCqybWN6TUcX
        C2mkKTbTR8gYTd/r+WOzP2ftxi7ClKObbdj4Bk8ySpHdxUkT6QrYSDqLYw0wSwxRhR7C+ck1/5puf
        9hnONzfGJrVDtIBthpBBJm9gzVqvZZx2C4Z+8IHpHJ39giWaPh8CEoruzoLddOWdEqrch7Klo9n7u
        HqQPRMQEtrnlWfmalFlVIOD3mgMJXKuQUvT5H0bIsWGcxlvbfRUekTO5IeECBZc+f86+iprJ5Ux6u
        ip2svXVw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nX8C4-00CqUV-06; Wed, 23 Mar 2022 21:07:00 +0000
Date:   Wed, 23 Mar 2022 21:06:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Junaid Shahid <junaids@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 10/47] mm: asi: Support for global non-sensitive
 direct map allocations
Message-ID: <YjuL80tuvUbAWWKW@casper.infradead.org>
References: <20220223052223.1202152-1-junaids@google.com>
 <20220223052223.1202152-11-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223052223.1202152-11-junaids@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 09:21:46PM -0800, Junaid Shahid wrote:
> standard ASI instances. A new page flag is also added so that when
> these pages are freed, they can also be unmapped from the ASI page
> tables.

It's cute how you just throw this in as an aside.  Page flags are
in high demand and just adding them is not to be done lightly.  Is
there any other way of accomplishing what you want?

> @@ -542,6 +545,12 @@ TESTCLEARFLAG(Young, young, PF_ANY)
>  PAGEFLAG(Idle, idle, PF_ANY)
>  #endif
>  
> +#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
> +__PAGEFLAG(GlobalNonSensitive, global_nonsensitive, PF_ANY);

Why is PF_ANY appropriate?

