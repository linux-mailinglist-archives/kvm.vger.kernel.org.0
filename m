Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E31C4713ED
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 14:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhLKNKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 08:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhLKNKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 08:10:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE33C061714;
        Sat, 11 Dec 2021 05:10:54 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639228252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cX98JZxDcKVWuJ5tNuqLqmGqazKuG5pDuxGDjTIGz9Y=;
        b=OT0qyZqH2e2mTkPLrh43pRlj/5Jfku8XfdG0AsDweaI5/4xY4dnjQSf5nm5sZFwh4Niy7t
        tfjBoC9ZYUnRP3G3eew2TTNCcwYwyJYklD8efnpxqMp0Wyyl1ZK98/YF+sYShjXEB+CPkQ
        puAzOIzXLQifTSX1lV4E7U7lVWNKgJX3Ywm3ejOE4wzD5fqAH8v1xfxmjwHx9dyyeWgGfJ
        czMGBjeWG4HG26rJx0DZRB88oy4kqN1lL+EuKsF+efDJm0MZ3wE+qaNTiYE3wJhiQfIrNA
        8ikMHDqRlk3Cjw32NaKMaW3BakEinOiKDtH+lYXalZTZXNy2tujSyO8Se+rmNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639228252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cX98JZxDcKVWuJ5tNuqLqmGqazKuG5pDuxGDjTIGz9Y=;
        b=xTXqn7Yh6p1HbY+c/ZQttdBrC63GDZ5MCw0q0uEl0jQHNLocPXetvLjxZXtj62Xp2CG/nt
        ixCX3NPw9AoBz3DQ==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
In-Reply-To: <87c26050-9242-e6fb-3fce-b6bde815f76a@redhat.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
 <87c26050-9242-e6fb-3fce-b6bde815f76a@redhat.com>
Date:   Sat, 11 Dec 2021 14:10:52 +0100
Message-ID: <8735mzwalf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11 2021 at 02:31, Paolo Bonzini wrote:
> On 12/11/21 01:10, Thomas Gleixner wrote:
>>      2) When the guest triggers #NM is takes an VMEXIT and the host
>>         does:
>> 
>>                  rdmsrl(MSR_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>> 
>>         injects the #NM and goes on.
>> 
>>      3) When the guest writes to MSR_XFD_ERR it takes an VMEXIT and
>>         the host does:
>> 
>>             vcpu->arch.guest_fpu.xfd_err = msrval;
>>             wrmsrl(MSR_XFD_ERR, msrval);
>
> No wrmsrl here I think, the host value is 0 and should stay so.  Instead 
> the wrmsrl will happen the next time the VCPU loop is entred.

I assumed this can be handled in the fast path, but either way.
