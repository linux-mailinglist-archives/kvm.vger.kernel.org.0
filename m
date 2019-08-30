Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50C4A40D3
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 01:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfH3XPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 19:15:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38103 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfH3XPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 19:15:20 -0400
Received: by mail-io1-f68.google.com with SMTP id p12so17409552iog.5
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 16:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5BdbNptKoZ5RdUVPmAaMERbP6sEWIzDqViEwn1vBHA=;
        b=EWr3JWoWn/5gqytNAlNslwWTCpaaq1DSWFsXBGvmocCuyWYXSZZIRdcMsselYzhN8q
         FFYu8waFyygEZEl27QIcKuAOfB+f8jNT/cVrkRaS8W5TL6D++p1A+22y9W9WK6Q0BH6O
         fFUaplGXfAZUqeBOdJAJn8v3aVF7FzOfuUmZgHLM0FKRl8qb8U2upGllrPxcJUErvYd3
         L60JfPdAhVl5Zs58HolSb1jSTK99NjGrVxf2j/ABitbCBC/4H0D8TvukIUuUAd1MWz1f
         NLSsNjMHVZ45OAsKhWj46B7RkE5vbSXtg9ZX23UMnTzQcgupoXUtwWniAWvYfOuSBhoe
         xO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5BdbNptKoZ5RdUVPmAaMERbP6sEWIzDqViEwn1vBHA=;
        b=kAtOeUYsamvtrH0z/0cKB21A3YxiIXgvJWypol+HpaFkx2V+hthGmyQMTJFBUzeODB
         GIjUZxP6n6F+zj+Ys586dSnpTlgRcLnBZpip9PDrFMi+4G//O1MyjkFFJMXC125/EbyY
         p3e4OoldlIxyy8O+le1Gj5e7zGx1Ze2RvYFiKyQho9eDHezO9zFwhrRLl3mLjv39MZ+Y
         u8gLLTSvOnRnoL32Lkn/WQx0W8zTvQ/rIQ/D8JItfc9Pu1gAMTNRwrReZhiJcNNa+Zug
         QL1OsgJ7J1qctUOa5a2sJ7fTIOn4+8ZjiT8vMT3aRkTblsqKgd1+RdpLFNRPZTQljzIe
         fPNw==
X-Gm-Message-State: APjAAAVi7yu9HjAdJ7MtWDTQzllJIC97lWTvcBJGaxYoG2jDEJt7W4f5
        EZGCDt6lQpFPuBF772NS6ts8/FgMkkXGiPcc333D0/ylYyo=
X-Google-Smtp-Source: APXvYqw/WzB05K39kYChSpyMEzIYT/wPkpA16/sSmFJS96wUVdRz7O41ubYzYiW4M8AtKiVGW871dHBDHw1krA9+UWQ=
X-Received: by 2002:a05:6602:103:: with SMTP id s3mr12639605iot.119.1567206918934;
 Fri, 30 Aug 2019 16:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com> <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com>
In-Reply-To: <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Aug 2019 16:15:06 -0700
Message-ID: <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 4:07 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 08/29/2019 03:26 PM, Jim Mattson wrote:
> > On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section "Checks on Guest Control Registers, Debug Registers, and
> >> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> >> of nested guests:
> >>
> >>      If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
> >>      field must be 0.
> > Can't we just let the hardware check guest DR7? This results in
> > "VM-entry failure due to invalid guest state," right? And we just
> > reflect that to L1?
>
> Just trying to understand the reason why this particular check can be
> deferred to the hardware.

The vmcs02 field has the same value as the vmcs12 field, and the
physical CPU has the same requirements as the virtual CPU.
