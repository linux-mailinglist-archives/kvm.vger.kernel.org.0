Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEC145B89
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfFNLfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:35:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37794 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfFNLfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WWQ52tqaiCP0C1KYMNijF1HDqWlxTu5XvaRlCuBtZ3g=; b=fijeBxJqngGRNGgiX1l6dheAA
        g0a+TA0qsbMnKPf3UF9mnTF+NJ8o2HHDxZGyQokqmbnkrBWxh2nwJAMMhedacfoexc3lD+yUgcstb
        b58/Ies68J3GZLFKZdMLki9pYdHx5s9bTGYQntRYkltMpfp80uHWFFwUnBfxeqzhumHdFR1jsim+Q
        Fcvnxn8kZXVv9SmjYvxD82ay1KdB3V7FWOTlZPdCFHVficpEuxVn3l5p4ZgEs+myHgUEcfUwux4Y/
        xrCDihiDGQ2n0gR2hsnJIoV+HwI5A4h+me8DTlf+jEwCC3bHxoTlS1/sjfQOuLkYYJyhSLIyuA12r
        fc9HqHw7w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkUO-0007E2-VL; Fri, 14 Jun 2019 11:35:25 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7156220A15636; Fri, 14 Jun 2019 13:35:23 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:35:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 26/62] keys/mktme: Move the MKTME payload into a
 cache aligned structure
Message-ID: <20190614113523.GC3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-27-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-27-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:46PM +0300, Kirill A. Shutemov wrote:

> +/* Copy the payload to the HW programming structure and program this KeyID */
> +static int mktme_program_keyid(int keyid, struct mktme_payload *payload)
> +{
> +	struct mktme_key_program *kprog = NULL;
> +	int ret;
> +
> +	kprog = kmem_cache_zalloc(mktme_prog_cache, GFP_ATOMIC);

Why GFP_ATOMIC, afaict neither of the usage is with a spinlock held.

> +	if (!kprog)
> +		return -ENOMEM;
> +
> +	/* Hardware programming requires cached aligned struct */
> +	kprog->keyid = keyid;
> +	kprog->keyid_ctrl = payload->keyid_ctrl;
> +	memcpy(kprog->key_field_1, payload->data_key, MKTME_AES_XTS_SIZE);
> +	memcpy(kprog->key_field_2, payload->tweak_key, MKTME_AES_XTS_SIZE);
> +
> +	ret = MKTME_PROG_SUCCESS;	/* Future programming call */
> +	kmem_cache_free(mktme_prog_cache, kprog);
> +	return ret;
> +}
