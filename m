Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0523F85B8
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbhHZKm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241692AbhHZKm1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629974499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WUSm/I+IuKQjkjPbmUi8oDeiiUHMswrLJ2gKcEGs3AM=;
        b=a8dyIuJOw4rL8vmo6E6ikZGMwjFJeJpbEZRHkS1ueW7fUtmqHpsrt+S4kP9+u6BAEY4YoK
        kz4DCiS7sUar4TusebSRG8x4VaBP+u7uCbLUvhv9AKhWgBV6xIztFPkZ46Zgx2vkYiF82W
        vsa/XwpXlmUbiB6BdOswCiXjiPsLduY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-5eWfWPlyNSmcwndz2142DA-1; Thu, 26 Aug 2021 06:41:38 -0400
X-MC-Unique: 5eWfWPlyNSmcwndz2142DA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90114100806A;
        Thu, 26 Aug 2021 10:41:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 651D25C1D5;
        Thu, 26 Aug 2021 10:41:31 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id D420818003AA; Thu, 26 Aug 2021 12:41:29 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:41:29 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 15/44] i386/tdx: Add hook to require generic
 device loader
Message-ID: <20210826104129.ukhut4lnttybf3sy@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <c16cb881efabc16a94ff7c02cd8c7abe24411e3f.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c16cb881efabc16a94ff7c02cd8c7abe24411e3f.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +    /*
> +     * Sanitiy check for tdx:
> +     * TDX uses generic loader to load bios instead of pflash.
> +     */
> +    for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
> +        if (drive_get(IF_PFLASH, 0, i)) {
> +            error_report("pflash not supported by VM type, "
> +                         "use -device loader,file=<path>");
> +            exit(1);
> +        }

I suspect that catches only "-drive if=pflash,..."
but not "-machine pflash0=..."

Also: why does tdx not support flash?
Should be explained in the commit message.

thanks,
  Gerd

