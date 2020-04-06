Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C310819F6C5
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgDFNVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 09:21:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728308AbgDFNVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 09:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586179279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dt00ToAjgq6odVjJUr2HynAfwKXr6ghEKV21ZUG8JdU=;
        b=hY0rOC0QrIzGeqgzbZYVXIVPqHhozD+4+nGJ79s+3yiNTiRYe5gMkD7FpotYG37r5gQ4gM
        oXIW4vC00ld2oGs83hyoiLVuoJr4dfX1YIOxludLs7TS9atheVC1MYbBHYxxVj03pyD6ka
        tr+1XnzbD+4rGFB7VtDwMOHilQDxaHI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-eLehHpuXMxuXk0nbw6P3sg-1; Mon, 06 Apr 2020 09:21:15 -0400
X-MC-Unique: eLehHpuXMxuXk0nbw6P3sg-1
Received: by mail-wr1-f70.google.com with SMTP id q9so1241680wrw.22
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 06:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dt00ToAjgq6odVjJUr2HynAfwKXr6ghEKV21ZUG8JdU=;
        b=TKwJ28qYWQa+K3pmQ9tKzQY/cH55G3w6RP7qlpMXTDrFoWFY98JVaC0wOFK8wGDelV
         mrX1jft+eSc8Av3Bdb/HN8Eg8x5SdYzpX2Bc+NIFWP4YrU5GB6hCcNNwvLwm7nLyUVhZ
         FdR8iFqMk48Y+KxIQFzPCG1duwecEJE7Gmodc57wqTMsGb3vzoKuJ4r5RgDjwPC3bM5R
         xYoWvXqy1mD+YqOAVJeSMUWsGtPMDhJrJ9qIJfzEkT9skmHqS41XBs1zNs942Ml8PWPr
         9hpv73Z2QfrebfozsXNdpnKH2ylboO3BQdj9nA749A5SJ9jf1MdlYufXwJ6RDrrqdWSx
         I4QA==
X-Gm-Message-State: AGi0Puav33iLYtzJNFNoBywm58e7JQilNJcymf4f2wbSgjM97jy8mG8i
        skRWnPt0qwywPeCMN3HAGalOENb/WldX4uADVQkE8jLPktD8zvEqI3QH72jVT/L+bO0YQvBR7lG
        QjwDPOWsiHYSt
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr11428318wrr.215.1586179274432;
        Mon, 06 Apr 2020 06:21:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypLTm0wN4Ob+KU8r6bjP+vUj5Sc5r+ElDJG7FGW/nVL32K8rRyDddIp810vWUMYetH05ffupWw==
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr11428298wrr.215.1586179274273;
        Mon, 06 Apr 2020 06:21:14 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id z11sm11162174wrv.58.2020.04.06.06.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 06:21:13 -0700 (PDT)
Date:   Mon, 6 Apr 2020 09:21:10 -0400
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
Message-ID: <20200406092056-mutt-send-email-mst@kernel.org>
References: <20200406121233.109889-1-mst@redhat.com>
 <20200406121233.109889-3-mst@redhat.com>
 <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
 <20200406085707-mutt-send-email-mst@kernel.org>
 <CAK8P3a1=-rhiMyAh6=6EwhxSmNnYaXR9NWhh+ZGh4Hh=U_gEuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1=-rhiMyAh6=6EwhxSmNnYaXR9NWhh+ZGh4Hh=U_gEuA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 06, 2020 at 03:15:20PM +0200, Arnd Bergmann wrote:
> On Mon, Apr 6, 2020 at 3:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Apr 06, 2020 at 02:50:32PM +0200, Arnd Bergmann wrote:
> > > On Mon, Apr 6, 2020 at 2:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > >
> > > > +config VHOST_DPN
> > > > +       bool "VHOST dependencies"
> > > > +       depends on !ARM || AEABI
> > > > +       default y
> > > > +       help
> > > > +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> > > > +         This excludes the deprecated ARM ABI since that forces a 4 byte
> > > > +         alignment on all structs - incompatible with virtio spec requirements.
> > > > +
> > >
> > > This should not be a user-visible option, so just make this 'def_bool
> > > !ARM || AEABI'
> > >
> >
> > I like keeping some kind of hint around for when one tries to understand
> > why is a specific symbol visible.
> 
> I meant you should remove the "VHOST dependencies" prompt, not the
> help text, which is certainly useful here. You can also use the three lines
> 
>      bool
>      depends on !ARM || AEABI
>      default y
> 
> in front of the help text, but those are equivalent to the one-line version
> I suggested.
> 
>      Arnd

Oh right. Good point. Thanks!

-- 
MST

