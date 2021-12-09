Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1346E050
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 02:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhLIBkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 20:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhLIBkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 20:40:41 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EABC061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 17:37:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so3602806pjb.1
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 17:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uub+IbSwvrL8++vPLHy04nVi4lIQuX6pueB0R7vJJ2U=;
        b=iHwPfvXwbAm6nakAlsdpYwrT0RIU8jrGpjgoLneEfTM5vIUaoB0f6Pb1UpM6tETwX2
         aCJikC5Vfr+/Qk4u+4KXRa/2H9AdK2V2ip1H1doX0T7+cU2W9lUcvbGCJ6viyybWGYV5
         wIQhcWIUPsGn3E4dbsyVRMtahM/9GjICVYpwSz/R3j9evKuev0PZYmC6M4G958QNbWEX
         OECU3Wj9J3umEN2suXvmzUMdROlZUYvb4GVrHW+LIcJmBv2alcrtOMCuR+Xh+gSC57IT
         apbqVK1Gfq04kvNfWwShKfXCgqVO0kmDM51NYNa8a/m4OnsPBGbqQ+vyiH8I6B/E31Gf
         vwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uub+IbSwvrL8++vPLHy04nVi4lIQuX6pueB0R7vJJ2U=;
        b=TrQKGVObvVQTRkhi6+77yIqKOx/rCXOV1VRXbsNeMHtUgABf3o5E7z5TZmAuUsNJfA
         yuCMXcmmKy5iDHBOlPtc62YYRIXKelx3WDG+Eg2uRyA26im+D+gu/7rbn0/6lBi/bhBc
         Tmr6zr0uWJ2kh5tO+hw6igHSVHSfRbr3GuJ3KGE3f88X44LnYGjjg2OOdqmAvBtvkq6Q
         vwnz8dg+Hhg5yrwLDV9v5Zuul1dn7ViO/uzOyo/2BqTGuOHY7PG+T0Xigy2KHzbUERjf
         Af9X35ABaRM5SL5IkLsRUv4NzO5TQvozdYmYEJ8ejvfnxTmCwLcVCIjxoCs/94RM3Sk0
         qZSg==
X-Gm-Message-State: AOAM533c4E5U6/ZdYs8sxqJGnCWL5A2UDxcUUyDxWqmBaWuN9ARJbMzX
        HcZU999te7y/nXr+NKyTNHWBmA==
X-Google-Smtp-Source: ABdhPJwIMJr5dFbwijfg8NpzqGkN3MdYDUBGuiollfpqkvGJuDCIdMQ7nXvJJkacj26B4AVhBVPxuw==
X-Received: by 2002:a17:902:a60b:b0:142:7621:be0b with SMTP id u11-20020a170902a60b00b001427621be0bmr62849052plq.58.1639013827911;
        Wed, 08 Dec 2021 17:37:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x14sm4023275pjl.27.2021.12.08.17.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 17:37:07 -0800 (PST)
Date:   Thu, 9 Dec 2021 01:37:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Message-ID: <YbFdwO3RZf6dg0M5@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
 <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> On Thu, 2021-12-09 at 01:00 +0200, Maxim Levitsky wrote:
> > Probably just luck (can't reproduce this anymore) but
> > while running some kvm unit tests with this patch series (and few my patches
> > for AVIC co-existance which shouldn't affect this) I got this
> > 
> > (warning about is_running already set)

...
 
> Also got this while trying a VM with passed through device:

A tangentially related question: have you seen any mysterious crashes on your AMD
system?  I've been bisecting (well, attempting to bisect) bizarre crashes that
AFAICT showed up between v5.15 and v5.16-rc2.  Things like runqueues being NULL
deep in the scheduler when a CPU is coming out of idle.  I _think_ the issues have
been fixed as of v5.16-rc4, but I don't have a good reproducer so bisecting in
either direction has been a complete mess.  I've reproduced on multiple AMD hosts,
but never on an Intel system.  I have a sinking feeling that the issue is
relatively unique to our systems :-/

And a request: any testing and bug fixes you can throw at the AVIC changes would be
greatly appreciated.  I've been partially blocked on testing the AVIC stuff for the
better part of the week.  If the crashes I'm seeing have been resolved, then I should
be able to help hunt down the issues, but if not...
