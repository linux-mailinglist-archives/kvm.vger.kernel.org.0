Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035BCA25D0
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 20:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfH2Scg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 14:32:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51244 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbfH2Scd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 14:32:33 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i3PDc-0004Xe-Cp; Thu, 29 Aug 2019 20:32:24 +0200
Date:   Thu, 29 Aug 2019 20:32:23 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Borislav Petkov <bp@suse.de>
cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] mm: x86: Invoke hypercall when page encryption
 status is changed
In-Reply-To: <alpine.DEB.2.21.1908292018500.1938@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.1908292031480.1938@nanos.tec.linutronix.de>
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-11-brijesh.singh@amd.com> <20190829180717.GF2132@zn.tnic> <alpine.DEB.2.21.1908292018500.1938@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Aug 2019, Thomas Gleixner wrote:
> On Thu, 29 Aug 2019, Borislav Petkov wrote:
> 
> > On Wed, Jul 10, 2019 at 08:13:11PM +0000, Singh, Brijesh wrote:
> > > @@ -2060,6 +2067,14 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
> > >  	 */
> > >  	cpa_flush(&cpa, 0);
> > >  
> > > +	/*
> > > +	 * When SEV is active, notify hypervisor that a given memory range is mapped
> > > +	 * encrypted or decrypted. Hypervisor will use this information during
> > > +	 * the VM migration.
> > > +	 */
> > > +	if (sev_active())
> > > +		set_memory_enc_dec_hypercall(addr, numpages << PAGE_SHIFT, enc);
> > 
> > Btw, tglx has a another valid design concern here: why isn't this a
> > pv_ops thing? So that it is active only when the hypervisor is actually
> > present?
> > 
> > I know, I know, this will run on SEV guests only because it is all
> > (hopefully) behind "if (sev_active())" checks but the clean and accepted
> > design is a paravirt call, I'd say.
> 
> No. sev_active() has nothing to do with guest mode. It tells whether SEV is
> active or not. So yes, this calls into this function on both guest and
> host. The latter is beyond pointless.

Oops. sme != sev.

But yes, can we please hide that a bit better....
