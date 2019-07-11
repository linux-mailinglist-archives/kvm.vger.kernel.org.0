Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D11266071
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 22:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfGKULp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 16:11:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:27718 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728194AbfGKULp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 16:11:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 13:11:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="171342617"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.137])
  by orsmga006.jf.intel.com with ESMTP; 11 Jul 2019 13:11:43 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 681A83007D3; Thu, 11 Jul 2019 13:11:43 -0700 (PDT)
From:   Andi Kleen <andi@firstfloor.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com, graf@amazon.de, rppt@linux.vnet.ibm.com
Subject: Re: [RFC v2 02/26] mm/asi: Abort isolation on interrupt, exception and context switch
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
        <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
Date:   Thu, 11 Jul 2019 13:11:43 -0700
In-Reply-To: <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
        (Alexandre Chartre's message of "Thu, 11 Jul 2019 16:25:14 +0200")
Message-ID: <874l3sz5z4.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexandre Chartre <alexandre.chartre@oracle.com> writes:
>  	jmp	paranoid_exit
> @@ -1182,6 +1196,16 @@ ENTRY(paranoid_entry)
>  	xorl	%ebx, %ebx
>  
>  1:
> +#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
> +	/*
> +	 * If address space isolation is active then abort it and return
> +	 * the original kernel CR3 in %r14.
> +	 */
> +	ASI_START_ABORT_ELSE_JUMP 2f
> +	movq	%rdi, %r14
> +	ret
> +2:
> +#endif

Unless I missed it you don't map the exception stacks into ASI, so it
has likely already triple faulted at this point.

-Andi
