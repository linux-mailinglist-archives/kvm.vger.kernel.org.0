Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6A86297
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 15:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732919AbfHHNF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 09:05:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36996 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732885AbfHHNF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 09:05:27 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so92037345qto.4
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 06:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=9m6QChW1Hz/Ce2TOg5A9I+Mvna5Z6uz7U57CNrS3DMc=;
        b=UsXVcz/0fx+mbrQVrDfthdHqx/TQAG6mZCOjIrVyOeqqQ52UZpnPAoCRoyaHnv8XhS
         myAYX36Qc07br0W255vMKbULw2ztt1SK9LCxY6t+qNSGUH8lgf/3KrkhNmVLhnuXPk75
         8NKhNYfOP0paEoLotKXkfyPj6WC9fRZDjL/390dyyF/8bhzq6seIlrIR7AftrabVSUCt
         9CsyV03odYVVSHvklvyseXwr4U05s7IrXQRwta90NNKp3g9VPyivRSNNHC+ZMXAvgadj
         C7aT5FJ9sAlB+caYQhcUKnsovzehTBq/uSqC2bLHwecFVaJ/O/Uv9sooTvOk7mSYFNNc
         0qyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9m6QChW1Hz/Ce2TOg5A9I+Mvna5Z6uz7U57CNrS3DMc=;
        b=ekkGLH/Qhi32zxjbv+vP4HHxYC2y4rgtJ+rBmVKrI5N5GKSLX9yJReMveoZe+NA60u
         BdYIL40xFODBY5i/cv0+NqIQ/rLvfEw4z0p2qoL+jNEtrSw0iIe8hbjDMjM5MqghPrYD
         fxxEbcGdZ7HLze3/Ur0CpwxtMmt/7vnCWYPv/Vw1k2PMoS1dOhcvluUntVStGDNp4Fqf
         AFn1A90V6hqGcddY9xzjc/QBiE0Drw1Q1LKGC2ViAeglkX29HevmwRdg1hb2ukPQxSxn
         pqM51QwdOXSe0UFqb6D78C0c88kK9BOyiJLNnI+hyD1bea4jVu2i/GCcgWwfyT3HzNnM
         fHdQ==
X-Gm-Message-State: APjAAAU1x4Itvj7zeyYCukDN8s0Itiq8JtzJajGYUtW0TAOltlgQiruP
        YC3/cEA79xGCESoRXuinnHLb7hpV0X4=
X-Google-Smtp-Source: APXvYqxk+1+rmZi904v8k29c8RjsPTgNO19TH+tlNz6F8hGZWv6LBYxggtUeflQkroZ7XbRUiUsHTA==
X-Received: by 2002:aed:3ed8:: with SMTP id o24mr12601256qtf.252.1565269526793;
        Thu, 08 Aug 2019 06:05:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id b1sm15328088qkk.8.2019.08.08.06.05.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Aug 2019 06:05:26 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hvi6f-0003Ih-LV; Thu, 08 Aug 2019 10:05:25 -0300
Date:   Thu, 8 Aug 2019 10:05:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V4 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190808130525.GA1989@ziepe.ca>
References: <20190807070617.23716-1-jasowang@redhat.com>
 <20190807070617.23716-8-jasowang@redhat.com>
 <20190807120738.GB1557@ziepe.ca>
 <ba5f375f-435a-91fd-7fca-bfab0915594b@redhat.com>
 <1000f8a3-19a9-0383-61e5-ba08ddc9fcba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1000f8a3-19a9-0383-61e5-ba08ddc9fcba@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 08:54:54PM +0800, Jason Wang wrote:

> I don't have any objection to convert  to spinlock() but just want to
> know if any case that the above smp_mb() + counter looks good to you?

This email is horribly mangled, but I don't think mixing smb_mb() and
smp_load_acquire() would be considerd a best-practice, and using
smp_store_release() instead would be the wrong barrier.

spinlock does seem to be the only existing locking primitive that does
what is needed here.

Jason
