Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA084486759
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240985AbiAFQHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 11:07:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240974AbiAFQHl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 11:07:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641485261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oq0ZYNEWv05QgZ2ulzFybJmZTsc1Zcs14l8IHQyWXp4=;
        b=CROde50KwDZ8ekaSJ4Syeo/iZB8h7JxbhdLRIG16Jmdh3DMZVmmnIs8eSjxjGegtPWKDew
        J0kONJ0wCODqtWxnHQismScYGMwTPxsSUGjWX7Cb0lsZMO1B5vc1gK3xVNfYU5fOd2fK9B
        GbdS3kbhrbTkthM7DGSnIczJP/Ny2tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-7MEq4A_POYWlMeDD6-WiNw-1; Thu, 06 Jan 2022 11:07:37 -0500
X-MC-Unique: 7MEq4A_POYWlMeDD6-WiNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8CAA10144E0;
        Thu,  6 Jan 2022 16:07:35 +0000 (UTC)
Received: from lacos-laptop-7.usersys.redhat.com (unknown [10.39.192.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94E3E10911BE;
        Thu,  6 Jan 2022 16:06:52 +0000 (UTC)
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
From:   Laszlo Ersek <lersek@redhat.com>
Message-ID: <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
Date:   Thu, 6 Jan 2022 17:06:50 +0100
MIME-Version: 1.0
In-Reply-To: <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/22 14:08, Xiaoyao Li wrote:

> + Laszlo,
> 
> Regarding laoding TDVF as pflash, I have some questions:
> 
> - pflash requires KVM to support readonly mmeory. However, for TDX, it
> doesn't support readonly memory. Is it a must? or we can make an
> exception for TDX?
> 
> - I saw from
> https://lists.gnu.org/archive/html/qemu-discuss/2018-04/msg00045.html,
> you said when load OVMF as pflash, it's MMIO. But for TDVF, it's treated
> as private memory. I'm not sure whether it will cause some potential
> problem if loading TDVF with pflash.
> 
> Anyway I tried changing the existing pflash approach to load TDVF. It
> can boot a TDX VM and no issue.

I have no comments on whether TDX should or should not use pflash.

If you go without pflash, then you likely will not have a
standards-conformant UEFI variable store. (Unless you reimplement the
variable arch protocols in edk2 on top of something else than the Fault
Tolerant Write and Firmware Volume Block protocols.) Whether a
conformant UEFI varstore matters to you (or to TDX in general) is
something I can't comment on.

(I've generally stopped commenting on confidential computing topics, but
this message allows for comments on just pflash, and how it impacts OVMF.)

Regarding pflash itself, the read-only KVM memslot is required for it.
Otherwise pflash cannot work as a "ROMD device" (= you can't flip it
back and forth between ROM mode and programming (MMIO) mode).

Thanks
Laszlo

