Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C5149ADBF
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 08:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446926AbiAYHpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 02:45:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1446690AbiAYHmv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 02:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643096567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lroAuQ9KwUUuf3SkYzmdVj0qTqXFnUMeQK3AGcniNQw=;
        b=JxvSgzxyKA4x43XUUIZya3yOrxHV1O0jMN9R7ivUKg0HXZfYBsBWqW4AaD7tIvO2S881sP
        fXuQPs3yOS4kTlDNLsTz8PJgDk8NGFhXM+QKraYyGdahNB6SaD1f7CFQh43espb2IHSn0w
        iPPp8KI44udNaG4r9a1INW3kdMW59Uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-XWiGIoLcNc2-O2okqRgknQ-1; Tue, 25 Jan 2022 02:42:44 -0500
X-MC-Unique: XWiGIoLcNc2-O2okqRgknQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C987946860;
        Tue, 25 Jan 2022 07:42:42 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A9BF62D44;
        Tue, 25 Jan 2022 07:42:27 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 9170518000B2; Tue, 25 Jan 2022 08:42:25 +0100 (CET)
Date:   Tue, 25 Jan 2022 08:42:25 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Laszlo Ersek <lersek@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Message-ID: <20220125074225.sqxukflp3vat7ilu@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
 <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
 <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
 <20220110110120.ldjekirdzgmgex4z@sirius.home.kraxel.org>
 <8793aa69-3416-d48e-d690-9f70b1784b46@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8793aa69-3416-d48e-d690-9f70b1784b46@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Regarding what interface should be used to load TDVF, there are three
> options:
> 
>   1) pflash: the same as how we load OVMF.
> 
>   Suppose TDVF support will finally get into OVMF, using this
>   interface, it's full compatible with normal VMs. No change required
>   to QEMU command line and TDVF binary is mapped to the GPA address
>   right below 4G, but they are actually mapped as RAM.
> 
>   Of course, we need several hacks (special handling) in QEMU.

What kind if "hack"?

>   Of course, they don't work as flash, the change made to it doesn't
>   persist.
> 
>   2) -bios
> 
>   exploit "-bios" parameter to load TDVF. But again, read-only is not
>   supported. TDVF is mapped as RAM.
> 
>   3) generic loader
> 
>   Just like what this series does. Implement specific parser in generic
>   loader to load and parse TDVF as private RAM.
> 
> I'm nor sure if 1) is acceptable from your side. If not, we will go with
> option 3, since 2) doesn't make too much sense.

Yep, Daniel (Cc'ed) tried (2) recently for SEV.  Didn't work due to
differences in -bios and -pflash reset handling.  So that option is
out I guess.

SEV uses (1), and there is some support code which you should be able to
reuse (walker for the list of guid-sections with meta-data in the ovmf
reset vector for example).

So TDX going for (1) too is probably the best option.

take care,
  Gerd

