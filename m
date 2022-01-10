Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3794896E4
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 12:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiAJLBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 06:01:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244382AbiAJLB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 06:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641812488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+PA8Vg//oTzHEGQwEE7hFyLmXJdElvmOjQHkElYPEaI=;
        b=QeRbGIDMhn+rUGFpDOdHOPidtTxCn/3ZdHvl/+GQS/46Z5xf23mQu7q1hseZ3kB9t6M707
        8sUZvmREV+VUY3MonjX61pFMlO0q1tQiRN2yS3Y5uueAg5rNvnpJiiXk9KLdzONHYYFJ2Y
        W/lTpQ20A/zMebdBxMWSeqv5ePyJfm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-sjwusAxaPwCaUnHnsW-kDA-1; Mon, 10 Jan 2022 06:01:24 -0500
X-MC-Unique: sjwusAxaPwCaUnHnsW-kDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF98E69737;
        Mon, 10 Jan 2022 11:01:22 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FEE0752AA;
        Mon, 10 Jan 2022 11:01:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id A76E818003A0; Mon, 10 Jan 2022 12:01:20 +0100 (CET)
Date:   Mon, 10 Jan 2022 12:01:20 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Laszlo Ersek <lersek@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Message-ID: <20220110110120.ldjekirdzgmgex4z@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
 <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
 <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > If you go without pflash, then you likely will not have a
> > standards-conformant UEFI variable store. (Unless you reimplement the
> > variable arch protocols in edk2 on top of something else than the Fault
> > Tolerant Write and Firmware Volume Block protocols.) Whether a
> > conformant UEFI varstore matters to you (or to TDX in general) is
> > something I can't comment on.
> 
> Thanks for your reply! Laszlo
> 
> regarding "standards-conformant UEFI variable store", I guess you mean the
> change to UEFI non-volatile variables needs to be synced back to the
> OVMF_VARS.fd file. right?

Yes.  UEFI variables are expected to be persistent, and syncing to
OVMF_VARS.fd handles that.

Not fully sure whenever that expectation holds up in the CC world.  At
least the AmdSev variant has just OVMF.fd, i.e. no CODE/VARS split.

> > Regarding pflash itself, the read-only KVM memslot is required for it.
> > Otherwise pflash cannot work as a "ROMD device" (= you can't flip it
> > back and forth between ROM mode and programming (MMIO) mode).
> 
> We don't need Read-only mode for TDVF so far. If for this purpose, is it
> acceptable that allowing a pflash without KVM readonly memslot support if
> read-only is not required for the specific pflash device?

In case you don't want/need persistent VARS (which strictly speaking is
a UEFI spec violation) you should be able to go for a simple "-bios
OVMF.fd".

take care,
  Gerd

