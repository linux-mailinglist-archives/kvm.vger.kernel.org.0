Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5025674021A
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 19:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjF0RZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 13:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjF0RZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 13:25:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2A326BF;
        Tue, 27 Jun 2023 10:25:17 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-666edfc50deso66937b3a.0;
        Tue, 27 Jun 2023 10:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687886717; x=1690478717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tAy3BdEspJlPeDmEFZs9sE+/cUDTXl7LmDXHAzonOMU=;
        b=sa7cziA981RYM/ui/S3lmxnf2XasU2ILz8wt9ERWgRTOfDc8m10TTwaKH7tB67XbCH
         7rsYn6l2vUVOJI8DO/5zIUA7bjt1BkIBwIlVBWeHDk1kLA4bo5oFXyYJZvhzsuFPwVSy
         oXOGIeJqge+hH5kCXtLNrR+10jqJiDozwyrh9KOvi6GzHFisaFpXGzPPIB3USUZKV6vF
         WlMT0Hdi5TTsTBtBwE5sUqvglm6w6aDskYJN9dYEAUld5giNWs9PpI97ONnvUQc4ZPu8
         yeB5G3lkyNtOSOCv5DMaGCx/cINWeGtp4fD2IDF2Y5+K792vy+cAl7n5TOfyTH/rM3VR
         7rMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687886717; x=1690478717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAy3BdEspJlPeDmEFZs9sE+/cUDTXl7LmDXHAzonOMU=;
        b=jw+S+2djQ9gPIUj1MeRTCtypl/t7/1Bkj+Y81iN95L1z5H8j1rsTEB48/TBTmzTSUW
         qD+V64OB+d6VIac1Tah9vPJL+e+/c2v8xS3OdECwH8h3rRueFpXaiQ5TOk8xGMkpWOJz
         u2Us4q8Y2xHtuLRDBwdfvW2KUxN+VkvdPisPVrUZbcWjb7mFUREXVJBR+wYzyt2UbYlL
         sEEaoJIvYmDiD3FzcIgTwuyk5ChUzcQQzB9JVSaJNoYsosE15TOjru8SAGSDp8XeSyw1
         dgoh3x6gyAod8lgcySX0uwVtOErG7HdAGflJVMo8PJWCD6uQX8ut/TRLC4v3OmlA80vu
         odgQ==
X-Gm-Message-State: AC+VfDzg7TzdDWmTNwYWdH9w235os9CsDjWd1bUqWq9cpZVALzBl1aEG
        kwSjPMGeFvOq0j8Hfqc98Bg=
X-Google-Smtp-Source: ACHHUZ7obCo50dBOrmWezxMqSsQT++fExXVdK6D/0djOUDPgv8ohuvHhxmDfmFkzxBZ//Y/o/SZ8ZQ==
X-Received: by 2002:a05:6a00:b4e:b0:67f:d5e7:4604 with SMTP id p14-20020a056a000b4e00b0067fd5e74604mr744066pfo.13.1687886716976;
        Tue, 27 Jun 2023 10:25:16 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id x21-20020aa793b5000000b00673e652985esm4265097pff.44.2023.06.27.10.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 10:25:16 -0700 (PDT)
Date:   Tue, 27 Jun 2023 01:19:43 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Simon Horman <simon.horman@corigine.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Vishnu Dasa <vdasa@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v4 6/8] virtio/vsock: support dgrams
Message-ID: <ZJo5L+IM1P3kFAhe@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-6-0cebbb2ae899@bytedance.com>
 <92b3a6df-ded3-6470-39d1-fe0939441abc@gmail.com>
 <ppx75eomyyb354knfkwbwin3il2ot7hf5cefwrt6ztpcbc3pps@q736cq5v4bdh>
 <ZJUho6NbpCgGatap@bullseye>
 <d53tgo4igvz34pycgs36xikjosrncejlzuvh47bszk55milq52@whcyextsxfka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d53tgo4igvz34pycgs36xikjosrncejlzuvh47bszk55milq52@whcyextsxfka>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 05:03:15PM +0200, Stefano Garzarella wrote:
> On Fri, Jun 23, 2023 at 04:37:55AM +0000, Bobby Eshleman wrote:
> > On Thu, Jun 22, 2023 at 06:09:12PM +0200, Stefano Garzarella wrote:
> > > On Sun, Jun 11, 2023 at 11:49:02PM +0300, Arseniy Krasnov wrote:
> > > > Hello Bobby!
> > > >
> > > > On 10.06.2023 03:58, Bobby Eshleman wrote:
> > > > > This commit adds support for datagrams over virtio/vsock.
> > > > >
> > > > > Message boundaries are preserved on a per-skb and per-vq entry basis.
> > > >
> > > > I'm a little bit confused about the following case: let vhost sends 4097 bytes
> > > > datagram to the guest. Guest uses 4096 RX buffers in it's virtio queue, each
> > > > buffer has attached empty skb to it. Vhost places first 4096 bytes to the first
> > > > buffer of guests RX queue, and 1 last byte to the second buffer. Now IIUC guest
> > > > has two skb in it rx queue, and user in guest wants to read data - does it read
> > > > 4097 bytes, while guest has two skb - 4096 bytes and 1 bytes? In seqpacket there is
> > > > special marker in header which shows where message ends, and how it works here?
> > > 
> > > I think the main difference is that DGRAM is not connection-oriented, so
> > > we don't have a stream and we can't split the packet into 2 (maybe we
> > > could, but we have no guarantee that the second one for example will be
> > > not discarded because there is no space).
> > > 
> > > So I think it is acceptable as a restriction to keep it simple.
> > > 
> > > My only doubt is, should we make the RX buffer size configurable,
> > > instead of always using 4k?
> > > 
> > I think that is a really good idea. What mechanism do you imagine?
> 
> Some parameter in sysfs?
> 

I comment more on this below.

> > 
> > For sendmsg() with buflen > VQ_BUF_SIZE, I think I'd like -ENOBUFS
> 
> For the guest it should be easy since it allocates the buffers, but for
> the host?
> 
> Maybe we should add a field in the configuration space that reports some
> sort of MTU.
> 
> Something in addition to what Laura had proposed here:
> https://markmail.org/message/ymhz7wllutdxji3e
> 

That sounds good to me.

IIUC vhost exposes the limit via the configuration space, and the guest
can configure the RX buffer size up to that limit via sysfs?

> > returned even though it is uncharacteristic of Linux sockets.
> > Alternatively, silently dropping is okay... but seems needlessly
> > unhelpful.
> 
> UDP takes advantage of IP fragmentation, right?
> But what happens if a fragment is lost?
> 
> We should try to behave in a similar way.
> 

AFAICT in UDP the sending socket will see EHOSTUNREACH on its error
queue and the packet will be dropped.

For more details:
- the IP defragmenter will emit an ICMP_TIME_EXCEEDED from ip_expire()
  if the fragment queue is not completed within time.
- Upon seeing ICMP_TIME_EXCEEDED, the sending stack will then add
  EHOSTUNREACH to the socket's error queue, as seen in __udp4_lib_err().

Given some updated man pages I think enqueuing EHOSTUNREACH is okay for
vsock too. This also reserves ENOBUFS/ENOMEM only for shortage on local
buffers / mem.

What do you think?

Thanks,
Bobby
