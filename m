Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0133B167B8D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 12:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBULLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 06:11:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726325AbgBULLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 06:11:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582283498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohzBP3K+Mt0fsuxycfty2Ga3uEJUsh8gIu8OmX1I0WU=;
        b=eHwKSJIJRfXjMXk/1PHQ0PT9GMeJd34EYvK8XFLwLLk9yxLDrJG5idQlKkfjwM/DFgI5la
        EE/Jbqb5kgb/VGqjGhfYx/XqmZwo0TSVeCTal08b6sZZrWjCL1sOUfyowlv0jR5w8fFPFf
        3cEzcFjFJsGApLw2C5MvrNr/0QnMRX4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-AKVTRVVaODeSP_Ce4PlBnQ-1; Fri, 21 Feb 2020 06:11:33 -0500
X-MC-Unique: AKVTRVVaODeSP_Ce4PlBnQ-1
Received: by mail-qt1-f197.google.com with SMTP id l1so1403136qtp.21
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 03:11:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ohzBP3K+Mt0fsuxycfty2Ga3uEJUsh8gIu8OmX1I0WU=;
        b=cDbtvnTbeep7e0WfNLtSHBqOe8Ojryj4aP79uaOMiZpPDUvkh9WbDpyKY02LyxGfVd
         dql5LqCKRB/JBdcYSBUclICgICxnJKSaglN6MYjqlE6NC6bPR87HEAPKUGQRp0NT2L1z
         7fgd0lOgsOrGPXX7Nuy1nG3lZojwviIt72SsiCV1zK6aESXd+W02ILtpJISE5mHSBpc1
         tohUnmaFiIRlEB+d62y33X7YeI7RZY3hUg4vaFtf4ztwqNypeZSAlikgADuQ7ApcYaj6
         8Klags0GkU9M+OVUe3d1OJ1f1MzTMnfDAvIAL9D2o/AX+FRndOdtvkvchTzvaaNvePNz
         2J5A==
X-Gm-Message-State: APjAAAUrQfrFmlaFR/tgPtSpJEu8fbAEQDLAY15hTthhtZwRjxDGDEzN
        qkBLWDsHBGMphqcvchiH8KP87Hd5xuoTb9n8BA9FrcbQ+DPl0ZnEDje0//oK8sgTF+6mRkpa04k
        Gw/05lpd2E/xD
X-Received: by 2002:a05:620a:62b:: with SMTP id 11mr7833804qkv.90.1582283493404;
        Fri, 21 Feb 2020 03:11:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6Q2uUzX1S2mVtdvc2ob5KdYLc4+DO8jko69GJDeSg1gBJ4/I2Q4F8j8Rk9Q5ly0Cjqk3+Zg==
X-Received: by 2002:a05:620a:62b:: with SMTP id 11mr7833775qkv.90.1582283493157;
        Fri, 21 Feb 2020 03:11:33 -0800 (PST)
Received: from redhat.com (bzq-109-67-14-209.red.bezeqint.net. [109.67.14.209])
        by smtp.gmail.com with ESMTPSA id m23sm1336239qtp.6.2020.02.21.03.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 03:11:32 -0800 (PST)
Date:   Fri, 21 Feb 2020 06:11:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org
Subject: Re: [PATCH] vhost: Check docket sk_family instead of call getname
Message-ID: <20200221060916-mutt-send-email-mst@kernel.org>
References: <20200221110656.11811-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200221110656.11811-1-eperezma@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 12:06:56PM +0100, Eugenio Pérez wrote:
> Doing so, we save one call to get data we already have in the struct.
> 
> Also, since there is no guarantee that getname use sockaddr_ll
> parameter beyond its size, we add a little bit of security here.
> It should do not do beyond MAX_ADDR_LEN, but syzbot found that
> ax25_getname writes more (72 bytes, the size of full_sockaddr_ax25,
> versus 20 + 32 bytes of sockaddr_ll + MAX_ADDR_LEN in syzbot repro).
> 
> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> Reported-by: syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>


Thanks for debugging this!

Acked-by: Michael S. Tsirkin <mst@redhat.com>





> ---
>  drivers/vhost/net.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e158159671fa..18e205eeb9af 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1414,10 +1414,6 @@ static int vhost_net_release(struct inode *inode, struct file *f)
>  
>  static struct socket *get_raw_socket(int fd)
>  {
> -	struct {
> -		struct sockaddr_ll sa;
> -		char  buf[MAX_ADDR_LEN];
> -	} uaddr;
>  	int r;
>  	struct socket *sock = sockfd_lookup(fd, &r);
>  
> @@ -1430,11 +1426,7 @@ static struct socket *get_raw_socket(int fd)
>  		goto err;
>  	}
>  
> -	r = sock->ops->getname(sock, (struct sockaddr *)&uaddr.sa, 0);
> -	if (r < 0)
> -		goto err;
> -
> -	if (uaddr.sa.sll_family != AF_PACKET) {
> +	if (sock->sk->sk_family != AF_PACKET) {
>  		r = -EPFNOSUPPORT;
>  		goto err;
>  	}
> -- 
> 2.18.1

