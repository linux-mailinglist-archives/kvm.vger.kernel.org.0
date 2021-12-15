Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB91475585
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241328AbhLOJxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 04:53:07 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46990 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbhLOJxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 04:53:06 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639561984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oau7jCYfBdBYROeD7Owz/+LjhRP3Vbms6S4ap0c3gs=;
        b=hEZ/97hPNRJtwloIF0nKKojFCRx+qPz81Nps6qQ0v1vm6/etH/w1VCfRixVI/yNjknhAR2
        /yFK/MxE+ZN3jduN6CLoVfvggUwLcqatQCN47lihtSTkmaFD7fsvaaRHaFvgVNm+rqUQoK
        H7eCOPYtGR2IZc4qW7rlYMSP2wS5S2YQkgjTbSh0d74VnP7nXTSOGdoM9ht2kbRRYADkHL
        Hg2iPMa0tHwnAIuexQ3xe5YvDy1I0MPINFyexqpReqvc96SX8MBRavJ+AmNvRbN5z4uVV2
        M7R06EoVsvHmwoTzeTkpkLrrM7hzplCZpLYKe8rQtD1AmnO7TnocGvF2r7Q2yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639561984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oau7jCYfBdBYROeD7Owz/+LjhRP3Vbms6S4ap0c3gs=;
        b=MxdHtnZWHTDID3dvN/sZb79p2xnNfWp5BxqWZcdSP1xI6Bb11QEAjm/2K3c73FlwygWuTE
        x9baBlGkTu6DKaCA==
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
In-Reply-To: <BN9PR11MB52760A4BC211148D875D3F358C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.991506193@linutronix.de>
 <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f49f9358-a903-3ee1-46f8-1662911390ef@redhat.com> <87a6h3tji8.ffs@tglx>
 <BN9PR11MB52760A4BC211148D875D3F358C769@BN9PR11MB5276.namprd11.prod.outlook.com>
Date:   Wed, 15 Dec 2021 10:53:04 +0100
Message-ID: <87bl1iry7z.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15 2021 at 05:46, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> +	if (guest_fpu) {
>> +		newfps->is_guest = true;
>> +		newfps->is_confidential = curfps->is_confidential;
>> +		newfps->in_use = curfps->in_use;
>
> What is the purpose of this 'in_use' field? Currently it's only
> touched in three places:
>
>   - set when entering guest;
>   - cleared when exiting to userspace;
>   - checked when freeing a guest FPU;
>
> The last one can be easily checked by comparing to current fps.

I added it for paranoia sake because the destruction of the KVM FPU
state is not necessarily in the context of the vCPU thread. Yes, it
should not happen...

>> +	if (guest_fpu) {
>> +		curfps = xchg(&guest_fpu->fpstate, newfps);
>
> This can be a direct value update to guest_fpu->fpstate since 
> curfps has already been acquired in the start.

Indeed.

Thanks,

        tglx
