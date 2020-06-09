Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321621F4005
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgFIP7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 11:59:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29446 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728888AbgFIP7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 11:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591718362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IvX4MY1gsw11baoE9fVtL/Xc+0OA1/v+Fa1wl7rhwsU=;
        b=cTHITxHE/tp+EPQJOZNaOnz+g/oL4jMjZesSFRhyOvIrbOzHXZVnJBFXUg2GVD4zCX8zK3
        8kALqT+FZ8VGUskZOrCW/3HF/+zRQcxtcNAj4t/MmpbMrQlWeyosa/Q8q914jhaydbo0mY
        DYP1MUA2Z9XiMZeoLBUMQoB0gNSPy5A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-M_F9r01vOA60jx8MR8YNAA-1; Tue, 09 Jun 2020 11:59:10 -0400
X-MC-Unique: M_F9r01vOA60jx8MR8YNAA-1
Received: by mail-wr1-f72.google.com with SMTP id a4so8772780wrp.5
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 08:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IvX4MY1gsw11baoE9fVtL/Xc+0OA1/v+Fa1wl7rhwsU=;
        b=IymAwM8zzC6If1U1KzVdF4OpPsBEVKxEjo3i+Fcxn04P9ta9rvKUbh1sHnSNOLa1Mo
         Ztc15eoEvSsxn6LXFgNISgO12Af7E7yqkrfLBxAXECFRLeqGI4fEZCbITQyDFPxuffsh
         FKvJShylkvgCx7ui/broptQpozhqRL6Q30DLzAUf44AyofJAjK+cgIrY7v+zFPR+00zj
         eVqtd5+FZsTXHVrAwfxxAvajqLjzgQEBEHz9RViSkxP8+1QLq8iN+dAPWFoLGFkREucc
         CyYobBvGpXwQu3bwOTQEBg6cl1S88JCI6UAIg+mMbkB8bRj0ZgWFE1ER5hqI+qQw/W2f
         p0ew==
X-Gm-Message-State: AOAM531L6ciW19bNBliJGtGQnrTsHBGiM83SpTHmYHoE0/CGWhDiMh1A
        wi52SQbL5hcozKE/jqcfyPxcrhEOpOoUBqNzM4Pl2SMY6mK+Akm5SvalO63uc1RbFxhVScVpJpl
        e2m4hRENIqIYN
X-Received: by 2002:a1c:9687:: with SMTP id y129mr4778348wmd.30.1591718349344;
        Tue, 09 Jun 2020 08:59:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyibN2lbUyKDvxytVLjKnsF4xx+IbA9pINaacVnINFW4dpxhMVQxcHP1bSrEeNrEprQ5mFQQA==
X-Received: by 2002:a1c:9687:: with SMTP id y129mr4778326wmd.30.1591718349147;
        Tue, 09 Jun 2020 08:59:09 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id j18sm3992059wrn.59.2020.06.09.08.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 08:59:08 -0700 (PDT)
Date:   Tue, 9 Jun 2020 11:59:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
Message-ID: <20200609115814-mutt-send-email-mst@kernel.org>
References: <20200603144914.41645-1-david@redhat.com>
 <20200609091034-mutt-send-email-mst@kernel.org>
 <08385823-d98f-fd9d-aa9d-bc1bd6747c29@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08385823-d98f-fd9d-aa9d-bc1bd6747c29@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 09, 2020 at 03:26:08PM +0200, David Hildenbrand wrote:
> On 09.06.20 15:11, Michael S. Tsirkin wrote:
> > On Wed, Jun 03, 2020 at 04:48:54PM +0200, David Hildenbrand wrote:
> >> This is the very basic, initial version of virtio-mem. More info on
> >> virtio-mem in general can be found in the Linux kernel driver v2 posting
> >> [1] and in patch #10. The latest Linux driver v4 can be found at [2].
> >>
> >> This series is based on [3]:
> >>     "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
> >>      buses"
> >>
> >> The patches can be found at:
> >>     https://github.com/davidhildenbrand/qemu.git virtio-mem-v3
> > 
> > So given we tweaked the config space a bit, this needs a respin.
> 
> Yeah, the virtio-mem-v4 branch already contains a fixed-up version. Will
> send during the next days.

BTW. People don't normally capitalize the letter after ":".
So a better subject is
  virtio-mem: paravirtualized memory hot(un)plug

and so on for all patches.

> -- 
> Thanks,
> 
> David / dhildenb

