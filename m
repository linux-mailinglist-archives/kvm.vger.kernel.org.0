Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A02A22FB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 20:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfH2SHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 14:07:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:36698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfH2SHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 14:07:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0342B67A;
        Thu, 29 Aug 2019 18:07:23 +0000 (UTC)
Date:   Thu, 29 Aug 2019 20:07:17 +0200
From:   Borislav Petkov <bp@suse.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20190829180717.GF2132@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-11-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-11-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:11PM +0000, Singh, Brijesh wrote:
> @@ -2060,6 +2067,14 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	 */
>  	cpa_flush(&cpa, 0);
>  
> +	/*
> +	 * When SEV is active, notify hypervisor that a given memory range is mapped
> +	 * encrypted or decrypted. Hypervisor will use this information during
> +	 * the VM migration.
> +	 */
> +	if (sev_active())
> +		set_memory_enc_dec_hypercall(addr, numpages << PAGE_SHIFT, enc);

Btw, tglx has a another valid design concern here: why isn't this a
pv_ops thing? So that it is active only when the hypervisor is actually
present?

I know, I know, this will run on SEV guests only because it is all
(hopefully) behind "if (sev_active())" checks but the clean and accepted
design is a paravirt call, I'd say.

Especially if some day other hypervisors should want to run SEV guests
too...

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
