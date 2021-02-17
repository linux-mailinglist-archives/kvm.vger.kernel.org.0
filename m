Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7710331E206
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 23:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhBQWXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 17:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231570AbhBQWXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 17:23:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6302864DFF;
        Wed, 17 Feb 2021 22:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613600580;
        bh=lHNU9mVhT/pVy2b7C4Y3frk8o8QuKxNaR6mCHbj+k40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBu0RSZGI8FLiGipnyjTms3YJmNNruJ8BGPErJW3L262PSSO4FwtXgyvt0VLtcjHV
         iayIlYTFL0jkWE/BSplVo4x155ZdWMVztdUwaq1CIwB6vaMiKQdZhm/tjmWv8RirdO
         Qq0fKrzkpNpsPr3PxSKMcCv+UsYScfQbxsOLe/ofo5JQBcRyIsn3sX/yxpTntXeFTG
         Ae1+mzA+fKpr8M0fRdqEROZnmzL9xs2Zb9MZsb/dsfKznw50+R+Pd15aAgwjrCZQos
         8466YPCodNiO81Qpqb/fFaHCBWbLeOyuec4ZHCYHz2nHlyVlSDRgKnaHJ7j281Ngcv
         /7hpOHam4JjDg==
Date:   Thu, 18 Feb 2021 00:22:48 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v5 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YC2XOC2bsALZi5NC@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4813545fa5765d05c2ed18f2e2c44275bd087c0a.1613221549.git.kai.huang@intel.com>
 <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 10:38:42AM -0800, Dave Hansen wrote:
> On 2/13/21 5:28 AM, Kai Huang wrote:
> > SGX driver uses misc device /dev/sgx_enclave to support userspace to
> > create enclave.  Each file descriptor from opening /dev/sgx_enclave
> > represents an enclave.  
> 
> Is this strictly true?  Does dup(2) create a new enclave?

No.

> > Unlike SGX driver, KVM doesn't control how guest
> > uses EPC, therefore EPC allocated to KVM guest is not associated to an
> > encalve, and /dev/sgx_enclave is not suitable for allocating EPC for KVM
> 
>   ^ enclave
> 
> > guest.
> 
> 
> > Having separate device nodes for SGX driver and KVM virtual EPC also
> > allows separate permission control for running host SGX enclaves and
> > KVM SGX guests.
> 
> Specifically, 'sgx_vepc' is a less restrictive interface.  It would make
> a lot of sense to more tightly control access compared to 'sgx_enclave'.
> 
> > More specifically, to allocate a virtual EPC instance with particular
> > size, the userspace hypervisor opens /dev/sgx_vepc, and uses mmap()
> > with the intended size to get an address range of virtual EPC.  Then
> > it may use the address range to create one KVM memory slot as virtual
> > EPC for guest.
> 
> This paragraph doesn't really explain anything important to me.  Both
> devices require using mmap().
> 
> With typos in the changelog fixed, I'm OK with the rest:
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> 
> BTW...  A lot of this patch is just a skeletal device driver.  I'm a
> horrible device driver writer, so take this ack as "everything seems
> explained well" versus "I promise this will pass muster with the guys
> who review device drivers all day long."
> 

/Jarkko
