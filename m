Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D57394D91
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 19:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhE2Rvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 13:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhE2Rvp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 29 May 2021 13:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622310608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mrWvrqIAhcEy96XyBpdIpilGC4jUDh9O1RbAnpp75IY=;
        b=MCWx0Ip/SbeIPxDTOiLMCSADyBz351CudBw42nSk9saastEY8mFVIvPDc9rS9WsWm+P4Et
        oYlLE/DeTuSsFQqhwiZ+VPV3kVMjsroD9BMMvEab1IocuhlaHinyuUW71p0SW08B2DqK4W
        LPb2By12ozphMWu4ATFV4TA39Llg+NI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-9j9UjlRVOfuBZagL6l8uTA-1; Sat, 29 May 2021 13:50:03 -0400
X-MC-Unique: 9j9UjlRVOfuBZagL6l8uTA-1
Received: by mail-wr1-f71.google.com with SMTP id p11-20020adfc38b0000b0290111f48b8adfso2597428wrf.7
        for <kvm@vger.kernel.org>; Sat, 29 May 2021 10:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mrWvrqIAhcEy96XyBpdIpilGC4jUDh9O1RbAnpp75IY=;
        b=XrqiTSR9zHBfdZrpUZ4BqKuBIJL4lsLBsr9dpXX6+ULKkQH+MwhG+Ox4Y1Z1l8rrZ+
         WDOXOsUGeeyfVM/clEbCM+HhuWIN5cdWZQpY5lvr+NkAhr5subYGzOpumLYn/l711zwI
         lCjrcehiL0WB2MonMZTws5uEpepwNbbAdScChgsVxl7ObEyzpxfLTjJcynoqTKZbqCjs
         5DTzgfaYPVmlkuBMcI42nu3NutrhsXFMywNC5PkOxWnCvEic3ZLHaVqAU92c+no2GDnh
         o4k6jktLdXeONNa3aghfwL1q3L1PaZI7b5snoJ1qiHnLl/Cg7C5EDyAPYuNLUZRap74g
         NRjw==
X-Gm-Message-State: AOAM5326nl1PFk/hVf1mrT5VbOjwhdI4t30UumFbIopOy6xt9DkUFscu
        FSyzEcsqrVZ03pnpfdehs7BZArv2OGa2QkyTwIwXjehncktH5gpOTj6G2WqS8SklRTY1OrcwST9
        Sez5DTSB7yhBx
X-Received: by 2002:a5d:6484:: with SMTP id o4mr14109477wri.8.1622310601849;
        Sat, 29 May 2021 10:50:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo3e7yKf5MVxMB5PF7HdlBui/UOcIPiMuU10E1z/Gxod0C57HWLEi0mTREdeLVXjD6g/JlQg==
X-Received: by 2002:a5d:6484:: with SMTP id o4mr14109457wri.8.1622310601651;
        Sat, 29 May 2021 10:50:01 -0700 (PDT)
Received: from [10.0.1.105] ([77.137.128.120])
        by smtp.gmail.com with ESMTPSA id z12sm11163024wrv.68.2021.05.29.10.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 10:50:01 -0700 (PDT)
Message-ID: <a59c8a53d30ef67afef87841031ed98a98f40ccf.camel@redhat.com>
Subject: Re: [PATCH v2 0/6] Introduce KVM_{GET|SET}_SREGS2 and fix PDPTR
 migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Sat, 29 May 2021 20:49:57 +0300
In-Reply-To: <YK6M4UwNGn1Gc5Sa@google.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
         <YK6M4UwNGn1Gc5Sa@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-26 at 18:01 +0000, Sean Christopherson wrote:
> On Mon, Apr 26, 2021, Maxim Levitsky wrote:
> > This patch set aims to fix few flaws that were discovered
> > in KVM_{GET|SET}_SREGS on x86:
> > 
> > * There is no support for reading/writing PDPTRs although
> >   these are considered to be part of the guest state.
> > 
> > * There is useless interrupt bitmap which isn't needed
> > 
> > * No support for future extensions (via flags and such)
> > 
> > Also if the user doesn't use the new SREG2 api, the PDPTR
> > load after migration is now done on KVM_REQ_GET_NESTED_STATE_PAGES
> > to at least read them correctly in cases when guest memory
> > map is not up to date when nested state is loaded.
> > 
> > This patch series was tested by doing nested migration test
> > of 32 bit PAE L1 + 32 bit PAE L2 on AMD and Intel and by
> > nested migration test of 64 bit L1 + 32 bit PAE L2 on AMD.
> > The later test currently fails on Intel (regardless of my patches).
> > 
> > Changes from V1:
> >   - move only PDPTRS load to KVM_REQ_GET_NESTED_STATE_PAGES on VMX
> >   - rebase on top of kvm/queue
> >   - improve the KVM_GET_SREGS2 to have flag for PDPTRS
> >     and remove padding
> > 
> > Patches to qemu will be send soon as well.
> 
> How did you want to handle integration with the removal of
> pdptrs_changed()?
> 
> https://lkml.kernel.org/r/68ff1249-2902-43d5-3dfd-35b1f14c4f90@redhat.com
> 

Hi!
Sorry that I missed your mail. I will take a look in a day or so at
this, and I don't envision any significant trouble with removal of
pdptrs_changed, since it is only an optimization anyway.

Thanks,
	Best regards,
		Maxim Levitsky

