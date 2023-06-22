Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4654773ACDE
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjFVXFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjFVXFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:05:46 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651591FE8;
        Thu, 22 Jun 2023 16:05:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b520c77de0so40402295ad.0;
        Thu, 22 Jun 2023 16:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687475145; x=1690067145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WHjYmH8s3fnZQ0PvCppw8g8ikfZuwN8TA2ENp2THW84=;
        b=eAOEFgW+SUOOsIZUBQ5ZgE642tNDIfwXJ6L4oP9aXgrupTZ1tUgw7T0wogkuR24dZQ
         YFv4qDDUtKFDzXgwpz1fBj0VnBv+ua+QMCHH/FmLIMYBZiY1SujXyo18j+gk7DO+UpYe
         jEfIz4q185Eyvv8vqBZjM1Fb1jfadiNxqXY6WkoD/qqUBwdWrF+T2RfxoWQNcrPlEiuv
         Ey4NNNHOK7dFmiNLCjQxd5nglDKSPPgTN6ROFRiMditQ/WwzXLrekvEjfZgDzjk921jd
         pwV94ilLj89ws35BYNAwLkVelhZEpdI+ZhjKudLjojGPWoHxGtNheCFh3WMOK4KP7cvs
         8UdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687475145; x=1690067145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WHjYmH8s3fnZQ0PvCppw8g8ikfZuwN8TA2ENp2THW84=;
        b=BFC1MFC1vyBvGIXBMOf/a+0MyNOIyHWQu7C5fWst+hOLxxkB+MAQNc9juKnlot9J1+
         L92xKYkCBHrdBXiOqLW1YN6xuSHz1tUIpKMj0bq9IhYoER0CbsYkzFhuIuyA2qIfGNlr
         qj6ohaMr/jJ8NktLioxXKoHAqiWTXnVDzKPF1/ztv6yseY+68Xp2q58dODkWSFw0PVzf
         zKIU5yUVjX4XbrQv+z7m/wMuuoRB589bHhTI8Vu8uQ58BLItdmtU2SFZ2ZNYcxt1I7xz
         4EZg+pXgWx+IIl3Ax5LmyiVBFQRtuUFDUqOFhGdwzjweKxjx6124LFtuu6UfsQRIBwi1
         0+Sg==
X-Gm-Message-State: AC+VfDwM3DWLYRncYhmd0CmPZKzVMzzx0UuQGNTqKPLglDXa3bdX6lb7
        04DQCGhe8D/wQ7kM9WY4nYY=
X-Google-Smtp-Source: ACHHUZ6ru+1v6NWpJmTylauOMEIvxwUyCaIvmtsUZQDPZJgoa1K4P8fvczx61Nf0/EvctdapOtXTqQ==
X-Received: by 2002:a17:90a:748f:b0:256:991a:19e with SMTP id p15-20020a17090a748f00b00256991a019emr9368441pjk.9.1687475144704;
        Thu, 22 Jun 2023 16:05:44 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id bv7-20020a17090af18700b0025edb720cc1sm235782pjb.22.2023.06.22.16.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 16:05:44 -0700 (PDT)
Date:   Thu, 22 Jun 2023 23:05:43 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 4/8] vsock: make vsock bind reusable
Message-ID: <ZJTTx0XJ2LeITNh0@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
 <p2tgn3wczd3t3dodyicczetr2nqnqpwcadz6ql5hpvg2cd2dxa@phheksxhxfna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2tgn3wczd3t3dodyicczetr2nqnqpwcadz6ql5hpvg2cd2dxa@phheksxhxfna>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 05:25:55PM +0200, Stefano Garzarella wrote:
> On Sat, Jun 10, 2023 at 12:58:31AM +0000, Bobby Eshleman wrote:
> > This commit makes the bind table management functions in vsock usable
> > for different bind tables. For use by datagrams in a future patch.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> > net/vmw_vsock/af_vsock.c | 33 ++++++++++++++++++++++++++-------
> > 1 file changed, 26 insertions(+), 7 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index ef86765f3765..7a3ca4270446 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -230,11 +230,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> > 	sock_put(&vsk->sk);
> > }
> > 
> > -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
> > +					    struct list_head *bind_table)
> > {
> > 	struct vsock_sock *vsk;
> > 
> > -	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
> > +	list_for_each_entry(vsk, bind_table, bound_table) {
> > 		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
> > 			return sk_vsock(vsk);
> > 
> > @@ -247,6 +248,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> > 	return NULL;
> > }
> > 
> > +static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +{
> > +	return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
> > +}
> > +
> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
> > 						  struct sockaddr_vm *dst)
> > {
> > @@ -646,12 +652,17 @@ static void vsock_pending_work(struct work_struct *work)
> > 
> > /**** SOCKET OPERATIONS ****/
> > 
> > -static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > -				    struct sockaddr_vm *addr)
> > +static int vsock_bind_common(struct vsock_sock *vsk,
> > +			     struct sockaddr_vm *addr,
> > +			     struct list_head *bind_table,
> > +			     size_t table_size)
> > {
> > 	static u32 port;
> > 	struct sockaddr_vm new_addr;
> > 
> > +	if (table_size < VSOCK_HASH_SIZE)
> > +		return -1;
> 
> Why we need this check now?
> 

If the table_size is not at least VSOCK_HASH_SIZE then the
VSOCK_HASH(addr) used later could overflow the table.

Maybe this really deserves a WARN() and a comment?

> > +
> > 	if (!port)
> > 		port = get_random_u32_above(LAST_RESERVED_PORT);
> > 
> > @@ -667,7 +678,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > 
> > 			new_addr.svm_port = port++;
> > 
> > -			if (!__vsock_find_bound_socket(&new_addr)) {
> > +			if (!vsock_find_bound_socket_common(&new_addr,
> > +							    &bind_table[VSOCK_HASH(addr)])) {
> > 				found = true;
> > 				break;
> > 			}
> > @@ -684,7 +696,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > 			return -EACCES;
> > 		}
> > 
> > -		if (__vsock_find_bound_socket(&new_addr))
> > +		if (vsock_find_bound_socket_common(&new_addr,
> > +						   &bind_table[VSOCK_HASH(addr)]))
> > 			return -EADDRINUSE;
> > 	}
> > 
> > @@ -696,11 +709,17 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > 	 * by AF_UNIX.
> > 	 */
> > 	__vsock_remove_bound(vsk);
> > -	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
> > +	__vsock_insert_bound(&bind_table[VSOCK_HASH(&vsk->local_addr)], vsk);
> > 
> > 	return 0;
> > }
> > 
> > +static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > +				    struct sockaddr_vm *addr)
> > +{
> > +	return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_SIZE + 1);
> > +}
> > +
> > static int __vsock_bind_dgram(struct vsock_sock *vsk,
> > 			      struct sockaddr_vm *addr)
> > {
> > 
> > -- 
> > 2.30.2
> > 
> 
> The rest seems okay to me, but I agree with Simon's suggestion.
> 
> Stefano
> 

Thanks,
Bobby
