Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9669D366CA3
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 15:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbhDUNWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 09:22:16 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:42763 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242420AbhDUNUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 09:20:40 -0400
Received: by mail-wr1-f51.google.com with SMTP id p6so34674669wrn.9;
        Wed, 21 Apr 2021 06:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n+4ksnXPTGxUVOIW+qyHuupy0kwqtpOF8lF9ySVgvLs=;
        b=eS3135WxHXgT3W/iSiR7Yc7xiDy7xvwfNY5zwmD8Xx5OUTOUYAgb85IXUOw396DD7t
         qXN6m+gt2PdMJB7lTHY3E+ybEVJU4Y+SQI+pQ0KHcbJBRy9wjjZm9ltvJY4eYCQjgZCM
         jeCApUX50nwZT4PbYbpRdOLT2bRhW0du02dr71IY1DwplWLFdBA0CAjwXhMMlAneHO+D
         b1j8zW/TpQtv+aT6liYRYrrz8bbaAivQn4bmWGlczhTkTOU7vrRn0NCTXtyPBspy6tUH
         pao0SDwsSifeivLHnkb3BPYUlg9tuAg8fllEiuFo0Ux+RPECT6BD4egZhjhVjO/ChK+o
         NTZQ==
X-Gm-Message-State: AOAM533kubjMAoLW2JeM0ZVemsWYorbepl7FMDyrKMJGFhwbeqxK9Ef9
        XZg6tjIA06R/0UIxu/AK96A=
X-Google-Smtp-Source: ABdhPJzlEAihJohG8iDjY9nVyV4gAQ7PzfTX13jEc5dsfvRiGypGAL0Zr47IexoY49GCSd/ZQVmBWg==
X-Received: by 2002:a05:6000:18ae:: with SMTP id b14mr27026149wri.211.1619011205131;
        Wed, 21 Apr 2021 06:20:05 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id v2sm3061922wrr.26.2021.04.21.06.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 06:20:04 -0700 (PDT)
Date:   Wed, 21 Apr 2021 13:20:03 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 2/7] hyperv: SVM enlightened TLB flush support flag
Message-ID: <20210421132003.cfnqxdy2vcb24pnp@liuwe-devbox-debian-v2>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <3fd0cdfb9a4164a3fb90351db4dc10f52a7c4819.1618492553.git.viremana@linux.microsoft.com>
 <20210421100026.4hcgrxeri444if45@liuwe-devbox-debian-v2>
 <4a57cd2b-43b5-2625-3663-449ffa715b51@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a57cd2b-43b5-2625-3663-449ffa715b51@linux.microsoft.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 07:15:54AM -0400, Vineeth Pillai wrote:
> 
> 
> On 4/21/21 6:00 AM, Wei Liu wrote:
> > On Thu, Apr 15, 2021 at 01:43:37PM +0000, Vineeth Pillai wrote:
> > > +/*
> > > + * This is specific to AMD and specifies that enlightened TLB flush is
> > > + * supported. If guest opts in to this feature, ASID invalidations only
> > > + * flushes gva -> hpa mapping entries. To flush the TLB entries derived
> > > + * from NPT, hypercalls should be used (HvFlushGuestPhysicalAddressSpace
> > > + * or HvFlushGuestPhysicalAddressList).
> > > + */
> > > +#define HV_X64_NESTED_ENLIGHTENED_TLB			BIT(22)
> > > +
> > c
> > This is not yet documented in TLFS, right? I can't find this bit in the
> > latest edition (6.0b).
> This would be documented in the TLFS update which is soon to be
> released.

Okay.

> 
> > 
> > My first thought is the comment says this is AMD specific but the name
> > is rather generic. That looks a bit odd to begin with.
> I thought of of keeping the name generic to avoid renaming Intel
> specific ones also. If I understand correctly, the TLFS would also
> be having generic name for this and just translated the generic
> name here in this header.

Okay. Let's match what is written in TLFS.

Wei.

> 
> Thanks,
> Vineeth
> 
