Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3AC19F64E
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 15:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgDFNCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 09:02:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52331 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgDFNCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 09:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586178129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VPjD/qOa5eohxkp3ciJYq8E962y8rH1Z+TEQ1dfdaNU=;
        b=LIVgOdOL/H71WNHI6o90ZKZ+LyhODZU3q3afogGyvFjRXlAPPvL3ipCXzVo2FfjBG6GkAQ
        g9216cAy+xzFi+rIOBohXTlybg5OX3Nl73WkqmalatmzM9WhNoggwaClz7i7YOmnb9Upwh
        4aEol6VgOQiLIpykmU8hxnvHAzs5nl8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-bgmLxKKgN-ODrK9g8sXANA-1; Mon, 06 Apr 2020 09:02:07 -0400
X-MC-Unique: bgmLxKKgN-ODrK9g8sXANA-1
Received: by mail-wm1-f70.google.com with SMTP id w8so4875348wmk.5
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 06:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VPjD/qOa5eohxkp3ciJYq8E962y8rH1Z+TEQ1dfdaNU=;
        b=nSAliRSEuDsSEqGUQL5xm8n695Exvtwq0cKKrEk08Fvvcqbb4vTR2bZAhQ3K6i6q3j
         fWgoYyjJMmXoToji2rEtOJvqx7WQSjMVMrjTJsN0uqk+kq+AMN+qxswqf+RhYATxtRkr
         Uma25KUYccCkXM1rl+Qis5dDIEXaIAGyWXZLypIx3gZja27IyImO9TOo0Kd3kmDxq1eU
         vhM9nYWNR5Z+hQf1bu8NcQtiTVFEDNITD/t+wWpsI5lDCyiK15KaqCzSWB3SzZKOe3o1
         nWOykMwG3oTBWxWow4W1jfQqPU7fGIwVAm7XIdVcQTFTHTUOINU/OszKcCHTRVR0Eqwc
         qcJA==
X-Gm-Message-State: AGi0PuYAxhEmWirJN1IxWAKgLyb03YlQ6LnyD2Aqq/iJgd51CxnbNlZ7
        LuOaSK3iqJEgSaDBgzPtCxTbMw1WOXhTUs+IUdzovWCN3VBop39RtA2br+9d1i4l8rsO0dUTJjt
        sXY0x889z4GOP
X-Received: by 2002:adf:a350:: with SMTP id d16mr23217846wrb.277.1586178126526;
        Mon, 06 Apr 2020 06:02:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzhJTMgG+3y4mdFbTRg4CPv7sYAgX9HM+UKNa2TYFJhIuv1nrWp08PsZCLMr3COjkc520wRg==
X-Received: by 2002:adf:a350:: with SMTP id d16mr23217808wrb.277.1586178126236;
        Mon, 06 Apr 2020 06:02:06 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id n1sm13731659wrw.52.2020.04.06.06.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 06:02:05 -0700 (PDT)
Date:   Mon, 6 Apr 2020 09:02:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "christophe.lyon@st.com" <christophe.lyon@st.com>,
        kbuild test robot <lkp@intel.com>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        Jason Wang <jasowang@redhat.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] vhost: disable for OABI
Message-ID: <20200406085707-mutt-send-email-mst@kernel.org>
References: <20200406121233.109889-1-mst@redhat.com>
 <20200406121233.109889-3-mst@redhat.com>
 <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 06, 2020 at 02:50:32PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 6, 2020 at 2:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> >
> > +config VHOST_DPN
> > +       bool "VHOST dependencies"
> > +       depends on !ARM || AEABI
> > +       default y
> > +       help
> > +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> > +         This excludes the deprecated ARM ABI since that forces a 4 byte
> > +         alignment on all structs - incompatible with virtio spec requirements.
> > +
> 
> This should not be a user-visible option, so just make this 'def_bool
> !ARM || AEABI'
> 
>       Arnd

I like keeping some kind of hint around for when one tries to understand
why is a specific symbol visible.

-- 
MST

