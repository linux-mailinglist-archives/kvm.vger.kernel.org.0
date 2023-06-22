Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E524673ACD0
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjFVXA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjFVXA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:00:27 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479E31BE7;
        Thu, 22 Jun 2023 16:00:26 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-543ae6ce8d1so77428a12.2;
        Thu, 22 Jun 2023 16:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687474826; x=1690066826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/gUgtCMqYn0BEVYUGz1fELi84ouQU1vkS6xfwxCrOBU=;
        b=rzotDp/kE7nSqn5vzRqJehlC0VBklhAosprw6i8pu1ENpnT2BjyN9lsqYCFDQXVq+E
         BZ++5ZJ+xjIRn4lKuCRq3TmbM+0W3xGwWUnT3Z1AGaH+1nSR+R7XGyOjMx+WE0UG9pab
         pI3J09PUejvgoVgq6J3ha1L2TRTMuHE3+Xp4l+MaZiIyIn/ElBLjUoFoOmestcbKfzoI
         tODcr4Hku/TCfwFJZAMydiPoPPwKo7JR2eiunyMI+3C8AMMeioNqLgZiAKCXSLquYt6Q
         yp37SSgAQASSYmdV8JGsRX6bBEDmQUGyhE6VUgadJ9diRm1SX4owfw62CVkiRLM8bL1+
         eRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687474826; x=1690066826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gUgtCMqYn0BEVYUGz1fELi84ouQU1vkS6xfwxCrOBU=;
        b=Y5Hpw0rDxC02flG0heZapAmulF1r4S15SDslOU5HUSbarR+MRrclqw78XUuwbNeZC3
         2p/BTFrCsBfxVnWvtVwatkjMeOCnfa5A5xq9Y/2t7H2nCjFGjzP9H3AJXP5pxJEmR9sm
         Ud2cUtCkKcIpKM8v6h9pHWGEOflnjkUAK0OR8I5zBINQWCrHuxQmKylFoTXrqvgiY3Y2
         yi291Xo6+jNOHqTaYAoAxS8s8MsxpPwL06iKDrBN1XXe8flBD66Y70KpX42NvDy/UXrx
         tE+9Vmh1a4nu5H98tYd3wWuGFxBsdKpRcopz/R8M8S9R52+kz3BkRIMaLWcuIODDwawI
         2n7Q==
X-Gm-Message-State: AC+VfDx1bRZM1RftS9OC+fmjlbrX1/EqO1CpS7oTiiOPmXPQdasxYC+b
        ccd3peQSKkHiHQAhx85FOVY=
X-Google-Smtp-Source: ACHHUZ7wvdcEdVOXN1Tpg0tF0aDch62ga/MzP3cuYpsRpGok/9Tk1Nx9L24zjf8weRaYN9LZw96XIg==
X-Received: by 2002:a05:6a20:4402:b0:125:11da:f951 with SMTP id ce2-20020a056a20440200b0012511daf951mr3850477pzb.45.1687474825574;
        Thu, 22 Jun 2023 16:00:25 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id s34-20020a635262000000b0053f2037d639sm5236111pgl.81.2023.06.22.16.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 16:00:25 -0700 (PDT)
Date:   Thu, 22 Jun 2023 23:00:24 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 4/8] vsock: make vsock bind reusable
Message-ID: <ZJTSiFsUA96MoYx9@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
 <ZIbqRXYMbYsdq874@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIbqRXYMbYsdq874@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 11:49:57AM +0200, Simon Horman wrote:
> On Sat, Jun 10, 2023 at 12:58:31AM +0000, Bobby Eshleman wrote:
> > This commit makes the bind table management functions in vsock usable
> > for different bind tables. For use by datagrams in a future patch.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> >  net/vmw_vsock/af_vsock.c | 33 ++++++++++++++++++++++++++-------
> >  1 file changed, 26 insertions(+), 7 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index ef86765f3765..7a3ca4270446 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -230,11 +230,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> >  	sock_put(&vsk->sk);
> >  }
> >  
> > -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
> > +					    struct list_head *bind_table)
> 
> Hi Bobby,
> 
> This function seems to only be used in this file.
> Should it be static?

Oh good call, yep.

Thanks!
Bobby
