Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901BE1F6672
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgFKLSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:18:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728017AbgFKLSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 07:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591874333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aHs/k82DRtmbgpcekLlfLtqDNjfmaiN8XJYIsbpXYsw=;
        b=VW91jxQPg8wJngBkjghZOMdCiAPv7qvFXqWw2g9Kp+DAjqzrBsz085mv9Xtl+/NACReAvO
        aqmE+K7NCc1P+RdXEuTKQXexqIVSBj1miNnk3P8IMzxrg7de1ZP1zxcsubTOlbznpM4axs
        LrtLlsVpCcVYHx8d+Q8ASzvq8tTXb0E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-hLBVKRRtO_aztQRntsLroQ-1; Thu, 11 Jun 2020 07:18:51 -0400
X-MC-Unique: hLBVKRRtO_aztQRntsLroQ-1
Received: by mail-wr1-f69.google.com with SMTP id s7so2434867wrm.16
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aHs/k82DRtmbgpcekLlfLtqDNjfmaiN8XJYIsbpXYsw=;
        b=pNSZVMoTz6dby3VeRczFTAeQkKyaTXqS8q9rOp8H6wL0Pf4vExyw5X25bfYuFjf5lv
         ntrG1QMke3FTXXtmtCTy8yyoNVd2E+5IQi8XcgXQwqIcUWdftYPJkwoAGmXL0nA8U97E
         1l8vm/QAs+APLekMxB8qlm7V6rEiy8kjFMFlMR/Bdgh2Sv2HWRizigu3YjbL2Qvk7+dc
         GjI6SXVMYkSVEGtC9jRAD7V0Os+kV071RuM3oj1w+lyj76u1oH9kAoPqrNmvzxxe+ZpY
         nU1kvAfN6ZaBTLy2b4IJPmFKfFaMn+mMNYPj8E9gUHajiZLv9qZifiu+CLMhWckpcC9/
         FGTg==
X-Gm-Message-State: AOAM530/6tCdL7a+EfUgU4uxfAdwyvLp7kx4IZTUhnq8ODIKMtsxFQZx
        i+Qvewv2p/+ZjQORW+Bw97zzn8U37jM2oHT7iEKDxvElWDqfZpqMIkyuTxFrwbSgVOMxpZCCwnQ
        EnpsiVN/dLkm/
X-Received: by 2002:a5d:4008:: with SMTP id n8mr8881549wrp.82.1591874329748;
        Thu, 11 Jun 2020 04:18:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhY9t8eWTFTFU22DEN3RpHOgBvqdz12LnsClmOERlrFjUovn0BcztQcQ+mkBp5lkPjBXyAsg==
X-Received: by 2002:a5d:4008:: with SMTP id n8mr8881507wrp.82.1591874329286;
        Thu, 11 Jun 2020 04:18:49 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id z25sm3678047wmf.10.2020.06.11.04.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:18:48 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:18:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>
Subject: Re: [PATCH v1] virtio-mem: add memory via add_memory_driver_managed()
Message-ID: <20200611071744-mutt-send-email-mst@kernel.org>
References: <20200611093518.5737-1-david@redhat.com>
 <20200611060249-mutt-send-email-mst@kernel.org>
 <13ad9edf-31a1-35ee-a0b0-6390c3a0b4d9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13ad9edf-31a1-35ee-a0b0-6390c3a0b4d9@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 01:00:24PM +0200, David Hildenbrand wrote:
> >> I'd like to have this patch in 5.8, with the initial merge of virtio-mem
> >> if possible (so the user space representation of virtio-mem added memory
> >> resources won't change anymore).
> > 
> > So my plan is to rebase on top of -rc1 and merge this for rc2 then.
> > I don't like rebase on top of tip as the results are sometimes kind of
> > random.
> 
> Right, I just wanted to get this out early so we can discuss how to proceed.
> 
> > And let's add a Fixes: tag as well, this way people will remember to
> > pick this.
> > Makes sense?
> 
> Yes, it's somehow a fix (for kexec). So
> 
> Fixes: 5f1f79bbc9e26 ("virtio-mem: Paravirtualized memory hotplug")
> 
> I can respin after -rc1 with the commit id fixed as noted by Pankaj.
> Just let me know what you prefer.
> 
> Thanks!

Some once this commit is in Linus' tree, please ping me.

> -- 
> Thanks,
> 
> David / dhildenb

