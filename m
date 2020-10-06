Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0609284EE5
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJFPZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgJFPZA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601997899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZL08bNRgmcXboDsDLfB4r/vwPMC+a0Y4m0HSS5QKZQ=;
        b=gWMrjvI4eLiOTvsgGf6wkjjKzg/NPKamGE+plnkp4pTm52HmEKObUK9PKIjfBnQ4xLX+Sx
        abFnnZFBPiKxmiuN5z0zWR8Cl4szjlGiTdFZ/iE3iBMdUlvgJiEZJV3Jbaf3IGDKoMBbxf
        xSruizhXKYC69laNrnYn8P4McIu8J4g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-K2SetijsNYGi47KJpQWUjw-1; Tue, 06 Oct 2020 11:24:58 -0400
X-MC-Unique: K2SetijsNYGi47KJpQWUjw-1
Received: by mail-wr1-f70.google.com with SMTP id y3so5487433wrl.21
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 08:24:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wZL08bNRgmcXboDsDLfB4r/vwPMC+a0Y4m0HSS5QKZQ=;
        b=hWXihHraSBsCoIje+Zvc9ndqMTSF8nuDYV3H9H6IfQZ4gEibI+UNg+Kfcui+OSOPdO
         bNkTcnf0Jo1Rg1v4rAatBDJ/Junrstry3FA58LyAxdkxfsi+OiTyhaxsRczsIi6IlpvD
         TZsGpGmm+hiUOkZeCIrSROUe59QWTKoqWjrvYzvnF79l+txOt/dLnnLk96YMVZ7GOcT/
         F7YyrC+4dfKrm+FgRPduA7zQ/C59SHvwefcjcthx7N/EoFe92c6iY5B3nJ3d2n3zX5E0
         JdGPYujWQVKBPjFv/zrVO4z7qEaRf+Moe+HHm2Nq1x5aD5sBhm6FVhFP5NcxIx1Xfwlq
         HT/g==
X-Gm-Message-State: AOAM530WVNWUUmQjrmpjRSG9OdaAE/yxa0e4MFzmzVYFRa9H8act7qRN
        uQ/dxalbiL1l9rWH0CMWBvgxwRuDqAz1UzCje4Shy/Lbk/2KDT8am3l2NkipWeKEFxltgioGjAq
        neXcbbm5cmFWM
X-Received: by 2002:adf:e952:: with SMTP id m18mr5504913wrn.171.1601997896533;
        Tue, 06 Oct 2020 08:24:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxc4aYABuI5yFB8wdeYFoHGPUQyNo8C3QPiC1wUe6Dh9KjA55FXC/fZPBeYEyt2rp+jvimxNQ==
X-Received: by 2002:adf:e952:: with SMTP id m18mr5504887wrn.171.1601997896255;
        Tue, 06 Oct 2020 08:24:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l5sm2459791wrq.14.2020.10.06.08.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 08:24:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
In-Reply-To: <20201006150817.GD5306@redhat.com>
References: <20201002192734.GD3119@redhat.com> <20201002194517.GD24460@linux.intel.com> <20201002200214.GB10232@redhat.com> <20201002211314.GE24460@linux.intel.com> <20201005153318.GA4302@redhat.com> <20201005161620.GC11938@linux.intel.com> <20201006134629.GB5306@redhat.com> <877ds38n6r.fsf@vitty.brq.redhat.com> <20201006141501.GC5306@redhat.com> <874kn78l2z.fsf@vitty.brq.redhat.com> <20201006150817.GD5306@redhat.com>
Date:   Tue, 06 Oct 2020 17:24:54 +0200
Message-ID: <871rib8ji1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Oct 06, 2020 at 04:50:44PM +0200, Vitaly Kuznetsov wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Tue, Oct 06, 2020 at 04:05:16PM +0200, Vitaly Kuznetsov wrote:
>> >> Vivek Goyal <vgoyal@redhat.com> writes:
>> >> 
>> >> > A. Just exit to user space with -EFAULT (using kvm request) and don't
>> >> >    wait for the accessing task to run on vcpu again. 
>> >> 
>> >> What if we also save the required information (RIP, GFN, ...) in the
>> >> guest along with the APF token
>> >
>> > Can you elaborate a bit more on this. You mean save GFN on stack before
>> > it starts waiting for PAGE_READY event?
>> 
>> When PAGE_NOT_PRESENT event is injected as #PF (for now) in the guest
>> kernel gets all the registers of the userspace process (except for CR2
>> which is replaced with a token). In case it is not trivial to extract
>> accessed GFN from this data we can extend the shared APF structure and
>> add it there, KVM has it when it queues APF.
>> 
>> >
>> >> so in case of -EFAULT we can just 'crash'
>> >> the guest and the required information can easily be obtained from
>> >> kdump? This will solve the debugging problem even for TDX/SEV-ES (if
>> >> kdump is possible there).
>> >
>> > Just saving additional info in guest will not help because there might
>> > be many tasks waiting and you don't know which GFN is problematic one.
>> 
>> But KVM knows which token caused the -EFAULT when we exit to userspace
>> (and we can pass this information to it) so to debug the situation you
>> take this token and then explore the kdump searching for what's
>> associated with this exact token.
>
> So you will have to report token (along with -EFAULT) to user space. So this
> is basically the 3rd proposal which is extension of kvm API and will
> report say HVA/GFN also to user space along with -EFAULT.
>

Right, I meant to say that guest kernel has full register state of the
userspace process which caused APF to get queued and instead of trying
to extract it in KVM and pass to userspace in case of a (later) failure
we limit KVM api change to contain token or GFN only and somehow keep
the rest in the guest. This should help with TDX/SEV-ES.

-- 
Vitaly

