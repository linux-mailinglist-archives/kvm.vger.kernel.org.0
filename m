Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B751E1A72B
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 10:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfEKI1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 May 2019 04:27:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32775 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbfEKI1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 May 2019 04:27:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id d9so1740146wrx.0
        for <kvm@vger.kernel.org>; Sat, 11 May 2019 01:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SdcIkrLxlvfbUBZr0Qh6I0nrjoSmAfdYaMwVRnCWFzs=;
        b=HEsYnwiwLAo9byln/eXX3WuyINi6FM/rK3L6KqdNMztQzTirfX1rqXS9iC9iS8C6BS
         RyDX9RwWek7VfI5Bgc8WdBxAIOERL8r74JPRuvA7RukcEIqjfiatE1vCUPp4B3H0bY01
         H5JQqwjXUkTI8AJksSXpdmhSOSfARnODgV1W9SSxnPKkZQT34yeO75kg7D5HIPmRdjOy
         LRekRbGruELomRcXYU/XqbzFDeUau8/jZzJvvTjwAmotY9hdAvKjpWj3QGCiikV2qq2x
         68bJUiCykP1y9BmUBkfS6GQwoJc1s8ueu2IxZX16vgHa3Qbnkhu7+YaW67So3EP48trJ
         DD0w==
X-Gm-Message-State: APjAAAWIELqHC4+xgw37qQMCMH+Egn3SKqhP93xoWLx8ZbhIQWFYvq96
        nUtJcJkWTK3QNXCG0+dl7sbz0g==
X-Google-Smtp-Source: APXvYqyj/9N4bztXCrHILbAbwp3dJCqyNjuLPc0pwjnIPNQl6TcYclEpkJFlN8NEOxoqcXldXr0PfA==
X-Received: by 2002:a5d:49c1:: with SMTP id t1mr10376967wrs.247.1557563228981;
        Sat, 11 May 2019 01:27:08 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id g10sm8043541wrw.80.2019.05.11.01.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 11 May 2019 01:27:08 -0700 (PDT)
Date:   Sat, 11 May 2019 10:27:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v2 2/8] vsock/virtio: free packets during the socket
 release
Message-ID: <20190511082705.t62d3rfbgibc4zxi@steredhat.homenet.telecomitalia.it>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-3-sgarzare@redhat.com>
 <20190510.152008.1902268386064871188.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510.152008.1902268386064871188.davem@davemloft.net>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 10, 2019 at 03:20:08PM -0700, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Fri, 10 May 2019 14:58:37 +0200
> 
> > @@ -827,12 +827,20 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
> >  
> >  void virtio_transport_release(struct vsock_sock *vsk)
> >  {
> > +	struct virtio_vsock_sock *vvs = vsk->trans;
> > +	struct virtio_vsock_buf *buf;
> >  	struct sock *sk = &vsk->sk;
> >  	bool remove_sock = true;
> >  
> >  	lock_sock(sk);
> >  	if (sk->sk_type == SOCK_STREAM)
> >  		remove_sock = virtio_transport_close(vsk);
> > +	while (!list_empty(&vvs->rx_queue)) {
> > +		buf = list_first_entry(&vvs->rx_queue,
> > +				       struct virtio_vsock_buf, list);
> 
> Please use list_for_each_entry_safe().

Thanks for the review, I'll change it in the v3.

Cheers,
Stefano
