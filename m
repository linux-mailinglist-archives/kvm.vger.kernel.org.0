Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C16135CB2
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgAIP0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:26:33 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:40520 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgAIP0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:26:33 -0500
Received: by mail-qv1-f65.google.com with SMTP id dp13so3096852qvb.7;
        Thu, 09 Jan 2020 07:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DZMO869N9atXGGz83vPVHWIh7S4cACUuHiNhHyOZd68=;
        b=ccSAmgpRYS3JuU+Saqy5TN2ryGO5qQ2sWpu4ahtfSrJ2R/vsFZNZzgwx7xKwejvUmd
         i552h8XAx9Fjqhm9YR1o/jL5XERp4/1cGhkas4dVz/maI3blz44/kx8UQK9kuAnxw4F+
         l00lQfaKest6JttZkBORklRnifkGQAtE+SkoFLxzw9XWvVl7xwCmVqZp+pPx3n+9acZR
         5rOB88870Dh3CiV4GEFmrPWG80pO7vAlDRkek61EwQjPpUVFx5lWxlkvjN0tBBhl1+di
         E5rH1CZVGNOjykxnvE6vJXRcjuP6kd5z/xzSGVm788NO1hKkzhTV4SNvt7M08lInDniV
         U7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DZMO869N9atXGGz83vPVHWIh7S4cACUuHiNhHyOZd68=;
        b=n1n3Lxz3ePC2MmXZJoT7qoBJmWS1JUuj8xohi2vrkxTdNNHgLOzePYj2K8SDwcgvZi
         lm7QwYE8/dhjGyzovcnsm6d9/4uSMFhTjplrT7xeVcU/j6dK5GXk5E7Ed06T2sZQnOhq
         HzREhHaDuGSBduD5q1cv/RyNKQEf4Np29A5vw9Rfb8u/mgUxcoZrnE12cPiN6F4+U2F5
         kxgbW1eD0ZG7MVnHDmyj1/RbRnVJOLYhguFInFQgYV1yZARAbWdl5pdkgt06ioGdobmV
         lEVrykIeaGL+EyKb57GSNNY5XRWBsp5Xbs/Nk/uH2OcTZqaDlHiA3icbbLmr2MaZXBfc
         C7aA==
X-Gm-Message-State: APjAAAWK9qtI7S8P2AfcUgFcY2dAT2ZqD3Hs+7GO/GpmZze6AXKIndu0
        OPAWatWn2zn2NrBbTp86V/w=
X-Google-Smtp-Source: APXvYqx3RuvAT9wjM40JZ1XavIkf8uBi4ENIt2ba5QEc7qaayoAA/hZW6F5XZUnmejjX+W4JxBdVYQ==
X-Received: by 2002:ad4:4354:: with SMTP id q20mr9398920qvs.103.1578583592611;
        Thu, 09 Jan 2020 07:26:32 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id d26sm3159020qka.28.2020.01.09.07.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 07:26:32 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 9 Jan 2020 10:26:30 -0500
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Sean Christopherson' <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
Message-ID: <20200109152629.GA25610@rani.riverdale.lan>
References: <20200108001859.25254-1-sean.j.christopherson@intel.com>
 <c716f793e22e4885a3dee3c91f93e517@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c716f793e22e4885a3dee3c91f93e517@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:13:48PM +0000, David Laight wrote:
> From: Sean Christopherson
> > Sent: 08 January 2020 00:19
> > 
> > Use a Logical OR in __is_rsvd_bits_set() to combine the two reserved bit
> > checks, which are obviously intended to be logical statements.  Switching
> > to a Logical OR is functionally a nop, but allows the compiler to better
> > optimize the checks.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 7269130ea5e2..72e845709027 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3970,7 +3970,7 @@ __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
> >  {
> >  	int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
> > 
> > -	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
> > +	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) ||
> >  		((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);
> 
> Are you sure this isn't deliberate?
> The best code almost certainly comes from also removing the '!= 0'.
> You also don't want to convert the expression result to zero.

The function is static inline bool, so it's almost certainly a mistake
originally. The != 0 is superfluous, but this will get inlined anyway.

> 
> So:
> 	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) | (rsvd_check->bad_mt_xwr & (1ull << low6));
> The code then doesn't have any branches to get mispredicted.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
