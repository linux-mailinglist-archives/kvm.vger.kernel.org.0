Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264131F400A
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgFIQBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 12:01:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29285 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730794AbgFIQBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 12:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591718494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i9mw0jwDqk9vebneZAm+rfcmH4lN//ILG94TBWdT15g=;
        b=jI1VvTgiOt/rdeNlYtQKiRcjCwMvv5xayFTf5zzsS/M9FNFc0B75EhBfnbHsnD43wE/Fn7
        XDdFFuXfkMpSaNdXDlYtTnLtzAkZ1CBOCCC8S1u3/tXxPkf79HmcfgiqPunoQUCuRR3V9/
        DXrNdvQJ6v3q4LByyqjfL7swbhFwEXc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-ECI9jYpSOWGHLakU--S8Fg-1; Tue, 09 Jun 2020 12:01:32 -0400
X-MC-Unique: ECI9jYpSOWGHLakU--S8Fg-1
Received: by mail-wm1-f72.google.com with SMTP id y15so747701wmi.0
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 09:01:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i9mw0jwDqk9vebneZAm+rfcmH4lN//ILG94TBWdT15g=;
        b=dUM2QxKBmgFSNezPxiToNIHZGTHgqN0nAABJLbEfOZnqU/JdH2hDc4vZ9bscTeb7FQ
         jVMb3q+opKA997jSCIyKkvaR57jMpfT2NFg7z87MnDlGzn4zGSrD88vtZ9d9RiELCHWR
         4E7lASMeTtPaopE1ej0ZJC/vfkgTgx1WJynMtmZ02JjVIAwwdBK0/+XeKnI6I2EWS5U/
         2v546cg2xXREdzrTUnTdVqexKhJvgc746mWNr+WONBolB6MI5oY4Jbv3vzu96a9aXjLy
         YrmVl5C9t5wdrxnVnhC6gtB7J0BILSNvg1HZqbApV36vMMdcaLMS0zMmqVq6+j9gvTHB
         RU5Q==
X-Gm-Message-State: AOAM532WIOTbBNAm+77Ds6MJu8WF7Tia/jbYm5teQrpuMKLSchNsQmMg
        47xUQnGotrZiUajHlB559mluWMGf6HYCGYLYVdDF6E/sdGy+FEPpwydtY8rGMSXJvVpU5i1Jx0j
        YBqkHzRxyicFw
X-Received: by 2002:a5d:408e:: with SMTP id o14mr5129555wrp.84.1591718491914;
        Tue, 09 Jun 2020 09:01:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN/kmT1mD5DAdfc2yIoMg5h96U9lEX8srTbHpB/HM+k7YK1UiWVh8jawTjEAAcaAaiezsmhA==
X-Received: by 2002:a5d:408e:: with SMTP id o14mr5129534wrp.84.1591718491702;
        Tue, 09 Jun 2020 09:01:31 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id c81sm3482604wmd.42.2020.06.09.09.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 09:01:31 -0700 (PDT)
Date:   Tue, 9 Jun 2020 12:01:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200609120011-mutt-send-email-mst@kernel.org>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-19-david@gibson.dropbear.id.au>
 <20200606162014-mutt-send-email-mst@kernel.org>
 <20200607030735.GN228651@umbus.fritz.box>
 <20200609121641.5b3ffa48.cohuck@redhat.com>
 <20200609174046.0a0d83b9.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609174046.0a0d83b9.pasic@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 09, 2020 at 05:40:46PM +0200, Halil Pasic wrote:
> For s390x having a memory-encryption object is not prereq for doing
> protected virtualization, so the scheme does not work for us right now.

It does make things much easier implementation-wise while just
marginally harder to use though.

-- 
MST

