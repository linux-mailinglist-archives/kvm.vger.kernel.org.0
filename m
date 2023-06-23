Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2350473B282
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 10:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjFWIQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 04:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjFWIQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 04:16:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D26D269E
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 01:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687508129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vvP94iL0b14tTM53kZ2sYxqnmPo54a4UlF6JdzA9tVs=;
        b=ZBDjyIkaE/PFGh7HJb0czEmKU0tgCZDqhis18PtqOl0Gg7ske+txGakFvDKTW2nDzoXJX/
        Lo9Gk4nVBLCycZvkCwJKjB8MvniuvBt40EazpvB0Qnz9se2ODtLNjiUbQzkGwyauMP3NR/
        k4XsAHOBAXE6Hb2Qjy4Rr4H81PTa11c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-M-wRi40ANoiLAsjkExCH6A-1; Fri, 23 Jun 2023 04:15:28 -0400
X-MC-Unique: M-wRi40ANoiLAsjkExCH6A-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-95847b4b4e7so27251666b.3
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 01:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687508127; x=1690100127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvP94iL0b14tTM53kZ2sYxqnmPo54a4UlF6JdzA9tVs=;
        b=eLf8PrhoDd8y/SB8EI1s8mgxWlVUi0h4A2YHOlXGDG2SNSxvM+z9eeFNbI36RRYCHt
         bj/1WL1+8d/AJPBfceM1+OafjvRFWoce7Q3lEAYhPm2U/8LxcsqfRXqwmz4ssSsppj0z
         SdBTay4jKYKU2WTAz2JvKYhQePBlg3VY16QjlhCpFONTiVwiwz2PL7LiZRXujciSlDQu
         qWZBN6Vye2A4MFtafpPnRvcN7XbZEpybHI7jcChA3HBiaawCn5b0KrrQLFRp31KBwcRe
         gLJcDgXVsRJMJLLxz9WD+yoeHj5IDHDHvls6fLaOn/NHMhqLDPw+4fzm/a3xfLveidW0
         hrJg==
X-Gm-Message-State: AC+VfDwJ9hVtXwQaouOCxl0647TBf8P+R+626mn7U8aRgMKq2sZImVVO
        Q6/BYktyZDC2dXMAh4nAEdnpMGnPiBXNmW2exMtLK4FrhjqLrxEoOVGfsr2MG6xKUMl1r1gaqFi
        dRRooQ6YyyVnQ
X-Received: by 2002:a17:907:969f:b0:947:335f:5a0d with SMTP id hd31-20020a170907969f00b00947335f5a0dmr18564025ejc.62.1687508127032;
        Fri, 23 Jun 2023 01:15:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7sG50KKcb8/4d0k9Sa5DNa+zxv2rKJ2E9yej3gVqMAjHzgkvZGHjdevsBGJ9oYHGKr3rl2Pw==
X-Received: by 2002:a17:907:969f:b0:947:335f:5a0d with SMTP id hd31-20020a170907969f00b00947335f5a0dmr18563999ejc.62.1687508126768;
        Fri, 23 Jun 2023 01:15:26 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id o11-20020a17090608cb00b00985ed2f1584sm5635492eje.187.2023.06.23.01.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 01:15:26 -0700 (PDT)
Date:   Fri, 23 Jun 2023 10:15:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
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
Message-ID: <oq5c2c4snksklko6tmq44g73d6ihrbnqjyugsvfbhtdsnlrioi@hklfspvyjmad>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
 <p2tgn3wczd3t3dodyicczetr2nqnqpwcadz6ql5hpvg2cd2dxa@phheksxhxfna>
 <ZJTTx0XJ2LeITNh0@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZJTTx0XJ2LeITNh0@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 11:05:43PM +0000, Bobby Eshleman wrote:
>On Thu, Jun 22, 2023 at 05:25:55PM +0200, Stefano Garzarella wrote:
>> On Sat, Jun 10, 2023 at 12:58:31AM +0000, Bobby Eshleman wrote:
>> > This commit makes the bind table management functions in vsock usable
>> > for different bind tables. For use by datagrams in a future patch.
>> >
>> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > ---
>> > net/vmw_vsock/af_vsock.c | 33 ++++++++++++++++++++++++++-------
>> > 1 file changed, 26 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> > index ef86765f3765..7a3ca4270446 100644
>> > --- a/net/vmw_vsock/af_vsock.c
>> > +++ b/net/vmw_vsock/af_vsock.c
>> > @@ -230,11 +230,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
>> > 	sock_put(&vsk->sk);
>> > }
>> >
>> > -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> > +struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
>> > +					    struct list_head *bind_table)
>> > {
>> > 	struct vsock_sock *vsk;
>> >
>> > -	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>> > +	list_for_each_entry(vsk, bind_table, bound_table) {
>> > 		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>> > 			return sk_vsock(vsk);
>> >
>> > @@ -247,6 +248,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> > 	return NULL;
>> > }
>> >
>> > +static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> > +{
>> > +	return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
>> > +}
>> > +
>> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>> > 						  struct sockaddr_vm *dst)
>> > {
>> > @@ -646,12 +652,17 @@ static void vsock_pending_work(struct work_struct *work)
>> >
>> > /**** SOCKET OPERATIONS ****/
>> >
>> > -static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> > -				    struct sockaddr_vm *addr)
>> > +static int vsock_bind_common(struct vsock_sock *vsk,
>> > +			     struct sockaddr_vm *addr,
>> > +			     struct list_head *bind_table,
>> > +			     size_t table_size)
>> > {
>> > 	static u32 port;
>> > 	struct sockaddr_vm new_addr;
>> >
>> > +	if (table_size < VSOCK_HASH_SIZE)
>> > +		return -1;
>>
>> Why we need this check now?
>>
>
>If the table_size is not at least VSOCK_HASH_SIZE then the
>VSOCK_HASH(addr) used later could overflow the table.
>
>Maybe this really deserves a WARN() and a comment?

Yes, please WARN_ONCE() should be enough.

Stefano

