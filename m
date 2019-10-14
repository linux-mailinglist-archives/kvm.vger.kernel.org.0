Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5389BD5DA3
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 10:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbfJNIiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 04:38:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41627 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730429AbfJNIim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 04:38:42 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCF90C054C52
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 08:38:41 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id h4so2390300wrx.15
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 01:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zgV9pC+zt0gI/V422zTkhHPL1PoCXjjbpPu+KeAB0w0=;
        b=DsROxDEwDl7jQ3J0z8CybnPkxNv32GraX+j9CkakRzCNUtzaHQnYmElSO6bIqNi/F6
         vLSPcTeHCVToXWyQll5cR9NxLeVUvi7GpJlJNs1S8GizQe1tvLTFiFsPYtobKIwrJ/QI
         H+HoFOFNo6pRsQNCryQ4ykGnAVQBGXnmraPq6NeYIVyzhLuJYj6S5OdX9LaHgkYU6X5X
         AHgNv11sFHh6MeM7nhM2AUPPdvtLOy6379sb+ht3Ecj5mM6HTVmNDzx/VBR27SX8dm7e
         m/1NraHFe92tcsr964hoei5/K4Wp3hq+yut1oYUwCG0L0mQQXFOnqULhav11kmzraAtM
         lyoQ==
X-Gm-Message-State: APjAAAX9826HzpnLydCynXM3BER4IrOqZJ7sN9uhKYkvN4neQC0ZSLGx
        aVd2JH0I019I2tqz35RuR95ufzX5Eh5kvallozd9VeZCxOEEKANz24z6qQcLfOE7Dja8nPmZWcs
        oAHEOUGq+B54b
X-Received: by 2002:a1c:3284:: with SMTP id y126mr14533754wmy.164.1571042320314;
        Mon, 14 Oct 2019 01:38:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx7BekhhYUaPdPVvYSoK18HhJqtlF38AkAYk8aK0SjlT68meT4y2oI/uOqPx7iwjAspulu58A==
X-Received: by 2002:a1c:3284:: with SMTP id y126mr14533736wmy.164.1571042320048;
        Mon, 14 Oct 2019 01:38:40 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id x5sm22881456wrt.75.2019.10.14.01.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 01:38:39 -0700 (PDT)
Date:   Mon, 14 Oct 2019 10:38:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20191014083836.fumqbp4sfn5usys6@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190830094059.c7qo5cxrp2nkrncd@steredhat>
 <20190901024525-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fA5UtkuMQbOHHy0noOGZUtpepBNKFg5afD81bynMVUQ@mail.gmail.com>
 <20191014081724.GD22963@stefanha-x1.localdomain>
 <2398c960-b6d7-8af3-fa25-d75344335db7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2398c960-b6d7-8af3-fa25-d75344335db7@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 04:21:35PM +0800, Jason Wang wrote:
> On 2019/10/14 下午4:17, Stefan Hajnoczi wrote:
> > SO_VM_SOCKETS_BUFFER_SIZE might have been useful for VMCI-specific
> > applications, but we should use SO_RCVBUF and SO_SNDBUF for portable
> > applications in the future.  Those socket options also work with other
> > address families.
> > 

I think hyperv_transport started to use it in this patch:
ac383f58f3c9  hv_sock: perf: Allow the socket buffer size options to influence
              the actual socket buffers


> > I guess these sockopts are bypassed by AF_VSOCK because it doesn't use
> > the common skb queuing code in net/core/sock.c:(.  But one day we might
> > migrate to it...
> > 
> > Stefan
> 
> 
> +1, we should really consider to reuse the exist socket mechanism instead of
> re-inventing wheels.

+1, I totally agree. I'll go this way.

Guys, thank you all for your suggestions!
