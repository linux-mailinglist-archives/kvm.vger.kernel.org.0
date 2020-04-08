Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5F1A1F98
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 13:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgDHLLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 07:11:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgDHLLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 07:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CGYxPY0UmZ+KsvjUaaa1RrlD6l1Y5r/qTWBeIw/gLCU=; b=qL3pjtMbis9rU768jBizcb/Iy5
        lkgPZ7sOpK/DsPBuKBnqJPwEoh7EzhRMARN9MxfFoYYI+3cRY8PVXlVrCrA0udfxR5EDjqMc0V+re
        nLC3SDkLS8Utb2VXyecpgZfXVUU5LMrwtS04bHrIHbiRDeITZiyVdGtK48rrTsO5hjWT0m0UeuXg1
        tqHJFc/BZHLjSBL8q/xUAIWPg4h93yY40YdgaGCVageZbXlihC5CmwwZiGswbW56qbS7qUjqaFCUs
        xSCtdr8d62RmcMAbt4O+MdMpNnruGMaaKjQTvSpcNi0aZG7iWT2tmw1b7zea1c4rmvcajFYLhz76g
        i4M6h/2g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jM8c8-0005fM-F0; Wed, 08 Apr 2020 11:11:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C0CD1300130;
        Wed,  8 Apr 2020 13:11:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AC0CC2B120793; Wed,  8 Apr 2020 13:11:22 +0200 (CEST)
Date:   Wed, 8 Apr 2020 13:11:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        jpoimboe@redhat.com, namit@vmware.com, mhiramat@kernel.org,
        jgross@suse.com, bp@alien8.de, vkuznets@redhat.com,
        pbonzini@redhat.com, boris.ostrovsky@oracle.com,
        mihai.carabas@oracle.com, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 14/26] x86/alternatives: Handle native insns in
 text_poke_loc*()
Message-ID: <20200408111122.GT20713@hirez.programming.kicks-ass.net>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <20200408050323.4237-15-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408050323.4237-15-ankur.a.arora@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 10:03:11PM -0700, Ankur Arora wrote:
>  struct text_poke_loc {
>  	s32 rel_addr; /* addr := _stext + rel_addr */
> -	s32 rel32;
> -	u8 opcode;
> +	union {
> +		struct {
> +			s32 rel32;
> +			u8 opcode;
> +		} emulated;
> +		struct {
> +			u8 len;
> +		} native;
> +	};
>  	const u8 text[POKE_MAX_OPCODE_SIZE];
>  };

NAK, this grows the structure from 16 to 20 bytes.
