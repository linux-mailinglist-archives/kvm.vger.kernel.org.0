Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B3973ACC9
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 00:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjFVW70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 18:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjFVW7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 18:59:25 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488031BE3;
        Thu, 22 Jun 2023 15:59:24 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b6da72d5e2so89927a34.1;
        Thu, 22 Jun 2023 15:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687474763; x=1690066763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWPY8k9L840OD62Ue8PL7iZKL+dQfszwnxeEIHODVBc=;
        b=Q7bzN6LbCulUU0WhmtUFRMdr/KvNmTdC4ACMgPyX8gLelGdIi1s+bvxXqxaD1V8TOZ
         ab7xY74HKayq/Fg5dL+bKssUf79P5oAfRuccfkVkuR/W9V9fPXlqMfqMdBUpRov3Zjh2
         32VnT+tGBCnq37L0EzYYom69surB55s7nMprbUPv4FB3fhNiVYBk95iPhV3kuzDnJftB
         +QUPH1mpVD+e8Y91wKSGiLYmtK1nPQ8XRkLMpDsc/7j8YVTa3qnVz8rJN2tAkBC4K3ws
         5H7zz58/Ws5YBjN7bbPIDSX61jxPfrJyWQRlLos8QHxDifYOha73gMZOOXBUZ7YoM9cm
         KJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687474763; x=1690066763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWPY8k9L840OD62Ue8PL7iZKL+dQfszwnxeEIHODVBc=;
        b=DvrjJ7IQ1cGYGIYKIzdM9b0xBu5CRpELwqWGGq5bg1mmD0Ry4nk5px+7rmzQELcriq
         Ht/WoYhZRJuFLAfSrpxVrHTD9Tj24lcobUxUXeNlyA5OxLOq+2nUpi7SW7Mzjc/HS+Gt
         q1ZVFJzKpKdYpLaKZ0jgXSd+oGArVXoY9wnJC2BNhDql5fxs0YA3uD/KXeiNL0tLTn24
         yDZ2jko3iMFszzTMWrFV5kzvlbG19G4Dbn3oz+OUf3mRGdhwiPdQyiE72M9s0i7cBFA8
         +YPZEGjJoQEez+8oCu0jT8XrdYRJqIKQshQ94K5WPmEBvn/Nw/BzOTc2fbQbzW+wiV13
         G3eA==
X-Gm-Message-State: AC+VfDwdV5SPhTiyX2PpUHaCikEhBXS9SSSYwdO2B66cK20hpZmbDpUc
        V0Rqa0WS+OUNdiofW9ua9p0=
X-Google-Smtp-Source: ACHHUZ5HZ5+9OoRofgTAwYouOOwETNaZfLN7OvRc/XYLG8ZwPagH5q3m/sPPoXBvzLM22SVLraJMgQ==
X-Received: by 2002:a05:6358:7059:b0:132:d3c1:6d20 with SMTP id 25-20020a056358705900b00132d3c16d20mr2272951rwp.6.1687474763163;
        Thu, 22 Jun 2023 15:59:23 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id h8-20020a63df48000000b00548fb73874asm5347229pgj.37.2023.06.22.15.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 15:59:22 -0700 (PDT)
Date:   Thu, 22 Jun 2023 22:59:22 +0000
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
Subject: Re: [PATCH RFC net-next v4 7/8] vsock: Add lockless sendmsg() support
Message-ID: <ZJTSSqXL+IXoRK3x@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-7-0cebbb2ae899@bytedance.com>
 <ZIbq/CeWowEq+nvg@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIbq/CeWowEq+nvg@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 11:53:00AM +0200, Simon Horman wrote:
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
> 
> Hi Bobby,
> 
> a minor nit from checkpatch --codespell: signficant -> significant
> 

Thanks! I'll fix that and add that argument to my pre-commit hook.

> > throughput changes (lowest p-value reaching 0.27), with the range of the
> > mean difference ranging between -5% to +1%.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> ...
