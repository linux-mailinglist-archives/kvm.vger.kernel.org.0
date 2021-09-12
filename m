Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE7407B0C
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhILAM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 20:12:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhILAMV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Sep 2021 20:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631405467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3+SDhPhtAI0lMP2x6bWgWzq+CLAgxnBUNxlCJNh5kE4=;
        b=L2deUqhhQJG0CXS6J1KCqX3RXpEyyAAtLjJx45pNGLrgxdI5OdecjGeW4qrfA9dMxpCrnW
        Yk+mcLp0hOgEN5rRGdMnSqMcoI+n/JfteqAL6whLPafvehQokmgFzOI7ADsMlGlrukULLM
        4Hv35wk6X34WzD8kz3fynS4nfLFB2zw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-Qv4cyRaRPDe-uvDISVcWYA-1; Sat, 11 Sep 2021 20:11:06 -0400
X-MC-Unique: Qv4cyRaRPDe-uvDISVcWYA-1
Received: by mail-wm1-f69.google.com with SMTP id f17-20020a05600c155100b002f05f30ff03so2298002wmg.3
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 17:11:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3+SDhPhtAI0lMP2x6bWgWzq+CLAgxnBUNxlCJNh5kE4=;
        b=GZ5m+WdLm6y+kFxLKHNOyC7x6/BNC+LdBRZEI4G+1YAG28WelPejX+ljsxrZQt9Tzt
         eGSN7wWpYfutRzWQMVCVWZDyd9g4W3niA5+N6MNxpH6FfubTk2RqnYu16CFw5C1BDQzR
         PSrBIUWjcxdTt3o75ExTP+M4et4EhkMcphu0vBoskLg+qAmkusFvlTEwFIqJ6OebujeK
         HvcuFPY+HisNU1YN6DstwDMYgTUGwTQtFPLljgoTqOYJ3fJV38mRJjs5PiY8IAohkhzN
         ljSSMRgMDlP/4uk4nemz1e2CdwYOmOvtnffxtI/fSqaY+Jl8ONpJiqRvsmQtAq/lh7Oy
         zSGA==
X-Gm-Message-State: AOAM530tTvikUogHAHMJsiJj1DTeFU2d4CD53rolY1cNrRaAoEd4Ugb2
        VqQ2bl0JsBTwdEE1N0r8zoFb/oxdeMvOWRqWrjxcE6eDrK03mmDXf8PPIMH0GNJTn2dcx9EOwP6
        rz/ulcEOAKR7R
X-Received: by 2002:a5d:5262:: with SMTP id l2mr5073429wrc.190.1631405465074;
        Sat, 11 Sep 2021 17:11:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2+nnpLXmYFqlcNrQEQIkvzkPNcBX1WRDEr9J/3GszOIhA0ueiLnvdBJ8sEzBojCIcdylSgw==
X-Received: by 2002:a5d:5262:: with SMTP id l2mr5073418wrc.190.1631405464938;
        Sat, 11 Sep 2021 17:11:04 -0700 (PDT)
Received: from redhat.com ([2.55.27.174])
        by smtp.gmail.com with ESMTPSA id o13sm214409wri.53.2021.09.11.17.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 17:11:04 -0700 (PDT)
Date:   Sat, 11 Sep 2021 20:11:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, Jason Wang <jasowang@redhat.com>,
        lingshan.zhu@intel.com, mgurtovoy@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>, Wolfram Sang <wsa@kernel.org>,
        xianting.tian@linux.alibaba.com, xieyongji@bytedance.com
Subject: Re: [GIT PULL] virtio,vdpa,vhost: features, fixes
Message-ID: <20210911200508-mutt-send-email-mst@kernel.org>
References: <20210909095608-mutt-send-email-mst@kernel.org>
 <CAHk-=wgcXzshPVvVgGDqa9Y9Sde6RsUvj9jvx0htBqPuaTGX4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgcXzshPVvVgGDqa9Y9Sde6RsUvj9jvx0htBqPuaTGX4Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 11, 2021 at 02:56:12PM -0700, Linus Torvalds wrote:
> So you are hereby put on notice: next time I get this kind of
> half-arsed garbage pull request, I won't spend the energy on trying to
> figure out what is actually going on. I will just throw it in the
> trash.
> 
> Because honestly, that's where this pull request belonged.
> 
>               Linus

OK so I was worrying about these patches anyway, and that
is why I put them on top. So I just sent GIT PULL V2 which
includes all the same commits except for the last 13 patches,
so they all have been in linux-next.

It's in the tag for_linus_v2 - the point of keeping for_linus
intact was so anyone can compare these two.

Hope that clarifies rather than confuses things even more.

Mea culpa, etc.

-- 
MST

