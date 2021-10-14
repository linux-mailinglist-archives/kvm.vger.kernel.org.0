Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB9742DBDD
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 16:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhJNOjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 10:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhJNOjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 10:39:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7D7C061753;
        Thu, 14 Oct 2021 07:37:09 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634222228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p+nJrEG4PcleBtVRR25FuZrlO9AVg9SUVua2dfzwMis=;
        b=Z6ghuxRyh4SUmWyR5e7Yfp7QU6Joy2YiYhUMVduVVKtCljp4JfhaJhEey5rIKBYZHo+cjJ
        jqfEr+g0Qiqc/Yovd4FtPkjjzYsYXChBVRu/AcGNFd4X5STa5rRiSpNDLxqm+df4MlnfAO
        kv7YXc/hyzkGDwWQMhUxwBtTCrxzZ/rjzeXpBewtMjnP0G3xndJwlT5zDgpEOf6dM33cs5
        jIQOaDTq42vJbyEzMv0vED1aCryDlxzmS1mfrWfVNy7VWVAWJ4+wG31qSGht4xn6ZnTWD8
        who7zJ4XSrnlUzpcFWVLA7RnGlMSGyQbop7okOq4hyVWdiEGQKMxHtaUvliANQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634222228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p+nJrEG4PcleBtVRR25FuZrlO9AVg9SUVua2dfzwMis=;
        b=/+rBl5UYDgSGFSh7tJfNhGlgZUvEkJO+++CqBqRn25D7pjASlPxgFaby7Sw11UVyvXHOMI
        9L/Nt//47/l3CkCQ==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <87wnmf66m5.ffs@tglx>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
Date:   Thu, 14 Oct 2021 16:37:07 +0200
Message-ID: <87o87r65bg.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14 2021 at 16:09, Thomas Gleixner wrote:
> On Thu, Oct 14 2021 at 11:01, Paolo Bonzini wrote:
>
> Also you really should not wait until _all_ dynamic states are cleared
> in guest XFD. Because a guest which has bit 18 and 19 available but only
> uses one of them is going to trap on every other context switch due to
> XFD writes.
>
> So you check for
>
>    (guest_xfd & guest_perm) != guest_perm)
>
> and
>
>    (guest_xr0 & guest_perm) != 0
>
> If both are true, then you reallocate the buffers for _all_ permitted
> states _and_ set XFD to pass through.

And for that to work we must write XFD _before_ XSETBV in the guest boot
phase.

Thanks,

        tglx
