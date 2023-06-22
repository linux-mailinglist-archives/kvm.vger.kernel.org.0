Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2873A636
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjFVQie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjFVQiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:38:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A531FE6
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687451854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9JewwlfUhZBK+i/3ORJq58l+o9JnC1L/BGtep803e2U=;
        b=YpkdZtAu9W6PlyFT34KBT2BIAM+IKfVZpD+Kj3PMaRDCMMAqBOcTDNV20US5XDbKLyqd8/
        mWEEAefOZTEkrmwPQCX7goivBIwTvufuGv6YyvUWt2MOcfVTzKc3l7i1U452gMz5JBn2Kt
        GU08IpejKuPJYTO9LmvLtVZM6sKjNsg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-QVnZ_9IpPnKuHy4v_MeOdw-1; Thu, 22 Jun 2023 12:37:26 -0400
X-MC-Unique: QVnZ_9IpPnKuHy4v_MeOdw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-978a991c3f5so544373266b.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687451844; x=1690043844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JewwlfUhZBK+i/3ORJq58l+o9JnC1L/BGtep803e2U=;
        b=auyW+3bWhRw3tUx9GYoYaBZ5wL8HhxD3jKeCdnHaqbp3ONQH4sXhLOUJG4i+pB0eoz
         jSsmBp7BPwueSUObtAULU8JCd8uUKXHeFuLRJnpqFNyb3gnz3GIvWflqhVrpj8hnp/Ro
         mqqWOuUsKRC8F6GZxxfXoEURHOmJNYFuzWd2gg4XlAaKa6bAo6VoPI2pZu8ODc3E/xcr
         bmEsIYVn/qzHQQCYUSqBSte7klxPe39rKxqqzPMLu3c/d+UqpN6oIgpF9jzTW1LBB8hR
         46sbRdL0UoADT9gVeL1pA+UoiKnc7OcLSjibL+FUn+vZjWnP1eaLS2er0Ditf3G4BsuF
         q6Ew==
X-Gm-Message-State: AC+VfDyGJg4LyDYOZh+mH2J3EPH+w/pQuVLYs+1rGRdHbqKI84uAVKfe
        uuGMoQWhXBrnNv54VfieLcxyxBLzAKQ8IrAqL1yjnHsMd/MH7emiPZLh65LX0UOv0OdHIbuVatq
        siIadTMo0NqrE
X-Received: by 2002:a17:906:1d05:b0:98d:3b40:eecf with SMTP id n5-20020a1709061d0500b0098d3b40eecfmr1372780ejh.4.1687451844709;
        Thu, 22 Jun 2023 09:37:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6WBDrRLIvqjb1enN3k1BFXMWSMSHxFtm3j7J6yA27lcpfSf8BJASjPHEgLDkecnWxmEIbgwA==
X-Received: by 2002:a17:906:1d05:b0:98d:3b40:eecf with SMTP id n5-20020a1709061d0500b0098d3b40eecfmr1372763ejh.4.1687451844433;
        Thu, 22 Jun 2023 09:37:24 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id e22-20020a1709067e1600b0096f675ce45csm4808601ejr.182.2023.06.22.09.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 09:37:23 -0700 (PDT)
Date:   Thu, 22 Jun 2023 18:37:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
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
Message-ID: <6aif4uoucg6fhqwg2fmx76jkt6542dt7cqsxrtnebpboihfjeb@akpxj3yd2xle>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-7-0cebbb2ae899@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-7-0cebbb2ae899@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 10, 2023 at 12:58:34AM +0000, Bobby Eshleman wrote:
>Because the dgram sendmsg() path for AF_VSOCK acquires the socket lock
>it does not scale when many senders share a socket.
>
>Prior to this patch the socket lock is used to protect both reads and
>writes to the local_addr, remote_addr, transport, and buffer size
>variables of a vsock socket. What follows are the new protection schemes
>for these fields that ensure a race-free and usually lock-free
>multi-sender sendmsg() path for vsock dgrams.
>
>- local_addr
>local_addr changes as a result of binding a socket. The write path
>for local_addr is bind() and various vsock_auto_bind() call sites.
>After a socket has been bound via vsock_auto_bind() or bind(), subsequent
>calls to bind()/vsock_auto_bind() do not write to local_addr again. bind()
>rejects the user request and vsock_auto_bind() early exits.
>Therefore, the local addr can not change while a parallel thread is
>in sendmsg() and lock-free reads of local addr in sendmsg() are safe.
>Change: only acquire lock for auto-binding as-needed in sendmsg().
>
>- buffer size variables
>Not used by dgram, so they do not need protection. No change.
>
>- remote_addr and transport
>Because a remote_addr update may result in a changed transport, but we
>would like to be able to read these two fields lock-free but coherently
>in the vsock send path, this patch packages these two fields into a new
>struct vsock_remote_info that is referenced by an RCU-protected pointer.
>
>Writes are synchronized as usual by the socket lock. Reads only take
>place in RCU read-side critical sections. When remote_addr or transport
>is updated, a new remote info is allocated. Old readers still see the
>old coherent remote_addr/transport pair, and new readers will refer to
>the new coherent. The coherency between remote_addr and transport
>previously provided by the socket lock alone is now also preserved by
>RCU, except with the highly-scalable lock-free read-side.
>
>Helpers are introduced for accessing and updating the new pointer.
>
>The new structure is contains an rcu_head so that kfree_rcu() can be
>used. This removes the need of writers to use synchronize_rcu() after
>freeing old structures which is simply more efficient and reduces code
>churn where remote_addr/transport are already being updated inside RCU
>read-side sections.
>
>Only virtio has been tested, but updates were necessary to the VMCI and
>hyperv code. Unfortunately the author does not have access to
>VMCI/hyperv systems so those changes are untested.

@Dexuan, @Vishnu, @Bryan, can you test this?

>
>Perf Tests (results from patch v2)
>vCPUS: 16
>Threads: 16
>Payload: 4KB
>Test Runs: 5
>Type: SOCK_DGRAM
>
>Before: 245.2 MB/s
>After: 509.2 MB/s (+107%)
>
>Notably, on the same test system, vsock dgram even outperforms
>multi-threaded UDP over virtio-net with vhost and MQ support enabled.
>
>Throughput metrics for single-threaded SOCK_DGRAM and
>single/multi-threaded SOCK_STREAM showed no statistically signficant
>throughput changes (lowest p-value reaching 0.27), with the range of the
>mean difference ranging between -5% to +1%.
>

Quite nice. Did you see any improvements also on stream/seqpacket
sockets?

However this is a big change, maybe I would move it to another series,
because it takes time to be reviewed and tested properly.

WDYT?

Thanks,
Stefano

