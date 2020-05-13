Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9A71D2180
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 23:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgEMVwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 17:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729487AbgEMVw3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 17:52:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D25C061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 14:52:29 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s19so626252edt.12
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 14:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4rv/roqgpjqLbHTwqTjvid9FAIr09s5ZjF8tms98eMA=;
        b=V+nh301UZ/ur7zWno1GxaFezDezSjJSczI02ARYYdPRbESE8KXHafJvoDtEl4Ldn1i
         8UtNSmeLTLfnvbZgVBMJjsLCjNsW/09GzX4waCCyTIzseWR28N9sI/6Fuq1Z2wi8PqXn
         mwjmvNrGeAJzFt8m/9v3s9+nMyM8hjVDBc0fM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4rv/roqgpjqLbHTwqTjvid9FAIr09s5ZjF8tms98eMA=;
        b=NWbzDfJsykWf7NNpazoJM03nMMlYEvjlna6aW/I6NGeArKSonx0WsarYHFTjcIw4s7
         BPhOxDM31ZJANf85PDug75kL39XdsIXYbXW5c/f7z7V6CfJzGIM1F1rLWfgYs60v3Mve
         gYJCVZhrqI/mrUz47FjHP+Xm6iT2YIcTvgYAJTzRIA0x2tAF2n+ovfDSTNmYaJ0zqj32
         O4nws0OvsgEWq5azwQJWPoB65V0D3DUFNT2CEdxTJHtiIldHkCdPhDiV3J1SrHy9PaVP
         r/1FR5vtOd8S2mSUldvjKTBkGR2cBSe2t2A+S+UHubwlWFCsCgSvYC/utU5vvK2pTOOS
         IkNQ==
X-Gm-Message-State: AOAM533zYvT0vrRt/U8sfkJJBOsmtbxqIn5pZ6oDZO2VR62lF/37QJ6Z
        rIHMhLg2/TSY8wU26PcTFh4K3Hl/4qkmsxVW3kpl/w==
X-Google-Smtp-Source: ABdhPJzcE5ZE76Mkxf+tz0n52jypKRVuWBYk/VHvPD+HyAyLdnFPji8yXgOR7+4cw7xqZWuazutkuQTSEC42FA0qgjo=
X-Received: by 2002:a05:6402:8ca:: with SMTP id d10mr1552953edz.167.1589406747702;
 Wed, 13 May 2020 14:52:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200511220046.120206-1-mortonm@chromium.org> <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
In-Reply-To: <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
From:   Micah Morton <mortonm@chromium.org>
Date:   Wed, 13 May 2020 14:52:15 -0700
Message-ID: <CAJ-EccOFUTZiOg_GvQKVyeVWvh04=eRYWvPMZW3LXyPWBOrS9g@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 12:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/05/20 19:14, Alex Williamson wrote:
> > But why not assign the individual platform devices via vfio-platform
> > rather than assign the i2c controller via vfio-pci and then assembling
> > the interrupts from those sub-devices with this ad-hoc interface?  An
> > emulated i2c controller in the guest could provide the same discovery
> > mechanism as is available in the host.
>
> I agree.  I read the whole discussion, but I still don't understand why
> this is not using vfio-platform.
>
> Alternatively, if you assign the i2c controller, I don't understand why
> the guest doesn't discover interrupts on its own.  Of course you need to
> tell the guest about the devices in the ACPI tables, but why is this new
> concept necessary?
>
> (Finally, in the past we were doing device assignment tasks within KVM
> and it was a bad idea.  Anything you want to do within KVM with respect
> to device assignment, someone else will want to do it from bare metal.

Are you saying people would want to use this in non-virtualized
scenarios like running drivers in userspace without any VMM/guest? And
they could do that if this was part of VFIO and not part of KVM?

> virt/lib/irqbypass.c is a special case because it's an IOMMU feature
> that is designed to work in concert with VMX posted interrupts and SVM
> AVIC, so in guest mode only).
>
> Paolo
>
