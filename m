Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA2173ACC3
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 00:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjFVW5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 18:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjFVW5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 18:57:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC021BE3;
        Thu, 22 Jun 2023 15:57:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-666eef03ebdso3632542b3a.1;
        Thu, 22 Jun 2023 15:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687474658; x=1690066658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ube1u5c4NbZrOXQ7QZi7ovBKihafwkeYJORY+Y8lW+M=;
        b=mkqvlA3vHLj9PdKFBBsnZec/uAiIUF/jFFYftf9skrHkHzyhzPQvyhABZOiFqbCpUd
         oPIhTDJTYBfQXsT3anymepENrdZqK+7gO/ph5KHMVBQnC03cstvVk7BgHPsjvW9e6Gbb
         511JnXa8HipVIqGGj0zIbx2raQvU2q076gO5eNaftkv4z5uE2C7kcJBmySBx7tAwLbAv
         tV8aAHl9LurW7xUgBBnojm+1N9624YIRxv1vwuHMo+vtxm7yDAEVdDZPAF3WSqOk8uAu
         4FEih+f7ZYavMXd4cyzX5SgFVURC4v7HWLxmMRX42/rsZr3XwFo/Ppxy+OPhbG5f/YiA
         72hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687474658; x=1690066658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ube1u5c4NbZrOXQ7QZi7ovBKihafwkeYJORY+Y8lW+M=;
        b=IcfXFCgBBF/frGWVX+4G7PzYGSUgJzXmZ9HTSOH/lDtizJeW72QQBZ/xnWxE1sJPcP
         xv5RyvgHErz/c4rhjuUaqwjjttxWSd3Isp9iSOU/f4VvGErtbOn7cKg66d3iIlboevg3
         pXcMklwjK5CXFLYNGe0eOgDZW6poWj/FhxGd7EYQqTU74GdTJkFIJK/uoTDsvlLJx2/q
         6fkfA6D5R2xHyePc8Qh1bXz2FxrBMrJUvPKt32EfxTYeTqThW5tJPf6vjpFYWBab4Cyp
         t/DUCs8TnjOalBMC5xhhu3R9RjmrHIbLvCjf0eQcQVaMpiOH1+UfiR3VMYtpY4dRr1yq
         MvbQ==
X-Gm-Message-State: AC+VfDwMAqWguLK/hP5JJi/kE5V83jhW7KNLcAkVi9UVg/4uKrNIaFAk
        0LwcWud9oSJrkB7PevNym+s=
X-Google-Smtp-Source: ACHHUZ6c0nBStl7QEKFb5zgGeWuLmbj4hPVuLRFH+2iitNhqtiuX93S0i6zk95rQFLuyEdlgacRuoQ==
X-Received: by 2002:a05:6a20:3cab:b0:106:c9b7:c932 with SMTP id b43-20020a056a203cab00b00106c9b7c932mr11574804pzj.1.1687474658304;
        Thu, 22 Jun 2023 15:57:38 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id o9-20020a170902bcc900b001b526ec4a84sm5797042pls.279.2023.06.22.15.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 15:57:37 -0700 (PDT)
Date:   Thu, 22 Jun 2023 22:57:37 +0000
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
Subject: Re: [PATCH RFC net-next v4 7/8] vsock: Add lockless sendmsg() support
Message-ID: <ZJTR4bl7JGmEakUL@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-7-0cebbb2ae899@bytedance.com>
 <6aif4uoucg6fhqwg2fmx76jkt6542dt7cqsxrtnebpboihfjeb@akpxj3yd2xle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aif4uoucg6fhqwg2fmx76jkt6542dt7cqsxrtnebpboihfjeb@akpxj3yd2xle>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 06:37:21PM +0200, Stefano Garzarella wrote:
> On Sat, Jun 10, 2023 at 12:58:34AM +0000, Bobby Eshleman wrote:
> > Because the dgram sendmsg() path for AF_VSOCK acquires the socket lock
> > it does not scale when many senders share a socket.
> > 
> > Prior to this patch the socket lock is used to protect both reads and
> > writes to the local_addr, remote_addr, transport, and buffer size
> > variables of a vsock socket. What follows are the new protection schemes
> > for these fields that ensure a race-free and usually lock-free
> > multi-sender sendmsg() path for vsock dgrams.
> > 
> > - local_addr
> > local_addr changes as a result of binding a socket. The write path
> > for local_addr is bind() and various vsock_auto_bind() call sites.
> > After a socket has been bound via vsock_auto_bind() or bind(), subsequent
> > calls to bind()/vsock_auto_bind() do not write to local_addr again. bind()
> > rejects the user request and vsock_auto_bind() early exits.
> > Therefore, the local addr can not change while a parallel thread is
> > in sendmsg() and lock-free reads of local addr in sendmsg() are safe.
> > Change: only acquire lock for auto-binding as-needed in sendmsg().
> > 
> > - buffer size variables
> > Not used by dgram, so they do not need protection. No change.
> > 
> > - remote_addr and transport
> > Because a remote_addr update may result in a changed transport, but we
> > would like to be able to read these two fields lock-free but coherently
> > in the vsock send path, this patch packages these two fields into a new
> > struct vsock_remote_info that is referenced by an RCU-protected pointer.
> > 
> > Writes are synchronized as usual by the socket lock. Reads only take
> > place in RCU read-side critical sections. When remote_addr or transport
> > is updated, a new remote info is allocated. Old readers still see the
> > old coherent remote_addr/transport pair, and new readers will refer to
> > the new coherent. The coherency between remote_addr and transport
> > previously provided by the socket lock alone is now also preserved by
> > RCU, except with the highly-scalable lock-free read-side.
> > 
> > Helpers are introduced for accessing and updating the new pointer.
> > 
> > The new structure is contains an rcu_head so that kfree_rcu() can be
> > used. This removes the need of writers to use synchronize_rcu() after
> > freeing old structures which is simply more efficient and reduces code
> > churn where remote_addr/transport are already being updated inside RCU
> > read-side sections.
> > 
> > Only virtio has been tested, but updates were necessary to the VMCI and
> > hyperv code. Unfortunately the author does not have access to
> > VMCI/hyperv systems so those changes are untested.
> 
> @Dexuan, @Vishnu, @Bryan, can you test this?
> 
> > 
> > Perf Tests (results from patch v2)
> > vCPUS: 16
> > Threads: 16
> > Payload: 4KB
> > Test Runs: 5
> > Type: SOCK_DGRAM
> > 
> > Before: 245.2 MB/s
> > After: 509.2 MB/s (+107%)
> > 
> > Notably, on the same test system, vsock dgram even outperforms
> > multi-threaded UDP over virtio-net with vhost and MQ support enabled.
> > 
> > Throughput metrics for single-threaded SOCK_DGRAM and
> > single/multi-threaded SOCK_STREAM showed no statistically signficant
> > throughput changes (lowest p-value reaching 0.27), with the range of the
> > mean difference ranging between -5% to +1%.
> > 
> 
> Quite nice. Did you see any improvements also on stream/seqpacket
> sockets?
> 

The change seemed to be null for stream sockets. I assumed the same
would be for seqpacket too, but I'll run some numbers there too for the
next revision.

> However this is a big change, maybe I would move it to another series,
> because it takes time to be reviewed and tested properly.
> 
> WDYT?
> 

Sounds good to me, I'll lop it off and resend on its own.

> Thanks,
> Stefano
> 

Thanks!
Bobby
