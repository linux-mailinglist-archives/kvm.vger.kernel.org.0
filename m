Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF07D3EDA2F
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhHPPvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:51:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236889AbhHPPtI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629128915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eqGNycDCKHG3gHGbGWPwugw7NM25Pzy7TXVzDcO4Xdo=;
        b=XQ0BHpEusqcdEZEhw6PjbOy+4qv3N/tt/tnaiTciCgBvIm9grTkdBpWB4NdOaSxpSkOQTv
        Jiln9SYNafVg6Q65rA6Da1IDirSLao9G+5TgyhQsy9T63/MaDfB23lxmhpXhnQNWU/vUlH
        Ivl0RAzZpxVvw6non5DiaieLQh8eaQ8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-LwzUhEzzMEi4gjJSikfDRg-1; Mon, 16 Aug 2021 11:48:33 -0400
X-MC-Unique: LwzUhEzzMEi4gjJSikfDRg-1
Received: by mail-wr1-f69.google.com with SMTP id d12-20020a056000186cb02901548bff164dso5631535wri.18
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 08:48:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eqGNycDCKHG3gHGbGWPwugw7NM25Pzy7TXVzDcO4Xdo=;
        b=Dp6QpyAcvlswaVGor3WvbawzJy8GoWB3lO0odNkkehaJFWoaoljeaS+URKMidGIADx
         5+/WsSuWAH9OkeKH4ZsIWjAsA4wCyQhLn3rfovUkWXI23VZF3+F0lMHp29+z7QYKgy2p
         1ITe+fmXOQQgWVIfamNSPLnQrnNWBwRigniZP8FIyFNi95PwM12m1ZYzJXcT0K+WmyEu
         tYb34WRT9NTP2DB8S3AmJGaX3lCXW4r2da/ZRLw8n5nUADqJ3OdCaIwZXCz4x9fheq1f
         kQbdJUsbbZ0f9vTtnfPP2cEj2zB+yQcwJ1mxG/iFIgPq6BeQDgaQTQ3PVU07+zDb636B
         oyuQ==
X-Gm-Message-State: AOAM530d8QT0UkTbZ+o9nfkUu18UDVfNv9n7MZhQrkwv+qHjSB3KlXc9
        Cz4QEyEiDuKVWJMn0R/GT4DYxUfYZseKWc7HIBYteNdveI/YWsvF/LrEKAjBwvkHBvgOR6UwWB2
        AO3Msr0d/IrOq
X-Received: by 2002:a1c:3c8b:: with SMTP id j133mr16015218wma.9.1629128912358;
        Mon, 16 Aug 2021 08:48:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzic1CE5/4fFpbEDhx9cZg3AlxsIbchSr8P37vgecT5Us/BKgF6gpJ/21AQSbOiQvBw9bdd+A==
X-Received: by 2002:a1c:3c8b:: with SMTP id j133mr16015204wma.9.1629128912219;
        Mon, 16 Aug 2021 08:48:32 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id b13sm12098776wrf.86.2021.08.16.08.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 08:48:31 -0700 (PDT)
Date:   Mon, 16 Aug 2021 16:48:29 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        jejb@linux.ibm.com, tobin@ibm.com, dovmurik@linux.vnet.ibm.com,
        frankeh@us.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YRqIzcsQM2OhhXrg@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
 <20210816151349.GA29903@ashkalra_ubuntu_server>
 <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Paolo Bonzini (pbonzini@redhat.com) wrote:
> On 16/08/21 17:13, Ashish Kalra wrote:
> > > > I think that once the mirror VM starts booting and running the UEFI
> > > > code, it might be only during the PEI or DXE phase where it will
> > > > start actually running the MH code, so mirror VM probably still need
> > > > to handles KVM_EXIT_IO when SEC phase does I/O, I can see PIC
> > > > accesses and Debug Agent initialization stuff in SEC startup code.
> > > That may be a design of the migration helper code that you were working
> > > with, but it's not necessary.
> > > 
> > Actually my comments are about a more generic MH code.
> 
> I don't think that would be a good idea; designing QEMU's migration helper
> interface to be as constrained as possible is a good thing.  The migration
> helper is extremely security sensitive code, so it should not expose itself
> to the attack surface of the whole of QEMU.

It's also odd in that it's provided by the guest and acting on behalf of
the migration code; that's an unusually trusting relationship.

Dave

> Paolo
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

