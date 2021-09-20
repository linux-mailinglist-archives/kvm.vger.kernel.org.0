Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949B24113F9
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhITMHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 08:07:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233852AbhITMHO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 08:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632139548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SLOLWNm02X4Mui1rci1jLq1ySgqr2JokjVYJ8tIlNc8=;
        b=Ffmr5B4l+d05+jEtDQagUpq/u9Xb3tDwAp8fRx77gC/0r+S/wMXmRzM2KzOjnqP9A3iRfJ
        wFTKLzTVTvPCD2/ThOjqO4iSbp2GNoEYuFQbP1j9blH0iG0SKYIT5WdpIKk0qpMk28WLGy
        p7YAOaudFf97UGEEmx4Zkdl/VoSAdak=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-46saZFRpMl-e4DIfIe6GZA-1; Mon, 20 Sep 2021 08:05:46 -0400
X-MC-Unique: 46saZFRpMl-e4DIfIe6GZA-1
Received: by mail-wr1-f70.google.com with SMTP id i16-20020adfded0000000b001572ebd528eso5879420wrn.19
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 05:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SLOLWNm02X4Mui1rci1jLq1ySgqr2JokjVYJ8tIlNc8=;
        b=5zs7DanPke5lK7opARP8LlTDf5AIyzBALX4AAHZXlUn2omjMZCRhcXFTALfbh3SZUo
         lEv6fWAPbQ869c+tAwpFjNfWZH94UoGFBIDIV6iEmBy+c63+FAd/hs/u1gqKyR7NCISH
         L3iv6cgNPqhYvZwAjPHmVz6ux05ejbkBkXrgexEipQMsEYTcb0mrnay4FnslfqNJWa21
         U1vXe5xhOFllfmrPWdKQtn7pWF0fNSrKkltfZXGy9BeM9YxpCGujDmL+3M9r/y8vLYjP
         8sEoGv4vd0MRE65uzK03veJlCNr7ByFi2iWGTolomzIPAcIBV0nBDkVAgT/n7JlChdEv
         fMuQ==
X-Gm-Message-State: AOAM532jhA+yqr+wM7zwtYbJRd4M/Wrb1uYwBnN8l2cORJrf3aIPz8vB
        hoplAaL/PpgqEj0rEp1OjrXEI/VmTveKzbShGWJpCl/i3psK6/iH7vWFwizPBFGf7iZp3Cp67Yy
        EjYFI33fTtwYt
X-Received: by 2002:a7b:c20f:: with SMTP id x15mr16688717wmi.59.1632139545663;
        Mon, 20 Sep 2021 05:05:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDw2HHyLOqpc2AtNquIarBLqvnR5TgEoTbVz5w2g3AebzRZVai6P4AEllUg7MmO6jaAse9Ug==
X-Received: by 2002:a7b:c20f:: with SMTP id x15mr16688701wmi.59.1632139545458;
        Mon, 20 Sep 2021 05:05:45 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id v21sm10771612wrv.3.2021.09.20.05.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 05:05:45 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:05:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Create a separate dirty bitmap
 per slot
Message-ID: <20210920120543.qhav26qttqc3impa@gator>
References: <20210917173657.44011-1-dmatlack@google.com>
 <20210917173657.44011-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917173657.44011-4-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 17, 2021 at 05:36:57PM +0000, David Matlack wrote:
> The calculation to get the per-slot dirty bitmap was incorrect leading
> to a buffer overrun. Fix it by splitting out the dirty bitmap into a
> separate bitmap per slot.
> 
> Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 54 +++++++++++++------
>  1 file changed, 39 insertions(+), 15 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

