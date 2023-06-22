Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4576B73ACE5
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjFVXGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjFVXGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:06:21 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DBD2128;
        Thu, 22 Jun 2023 16:06:11 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6b5915d0816so94715a34.1;
        Thu, 22 Jun 2023 16:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687475171; x=1690067171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ouszZxBWK4Y/7BnPKGCua1rglERmrS5y1sP9g0y1NxU=;
        b=aTB1pvy0DXHIer0JV5RF4ky0pZJjqqTMNLnoz3OJFDzXR2M1WhUq1IKpMh911OPGMb
         GMIL5ZdCS66V+dz0MCNHe4rkphypdFwdgBQCmUh4+dakL9F8ZzsSktXpbYbB5/PQEfNx
         LvyxoJc2bw34I8JQ8y3cbCwykwlJhcf5QjI2Rtp3ntF6yVvu2+mAGffWnayVss1LIXTC
         Tb2vpZD7lnViDjTmWqiEw8mVm1czpGyLzU3KIxLsI2txruv50G1S/vLnHIqvYVAEHrzA
         y4NtmYcKzNJV6ek3hEP52Nph+NwmjCZ3jaCgPE58l9O7MvMPzTPFFMP05eXoxWQeMyTR
         GbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687475171; x=1690067171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouszZxBWK4Y/7BnPKGCua1rglERmrS5y1sP9g0y1NxU=;
        b=FokVQ9Uf2+NiSpLsC2zV4o2XRRoRkHtMSpl3RRLZcu6Ig35ud17bV5fcsoP039Wc0f
         5304GaWW2emDWL55ypFIo7rzG70thnNs/85hAVpxgj5xo0CaoFKO1trWTLeFpZi+sLRj
         tljApsf1DIMvLzx7sWWRzr/gz5GctICf/rl1XOCGe5Lm0tFHtGkH7rWGNmduZ/NVfnQ/
         U8JYcCL2YlfUcjdL/fTEKpGkUJVz2pDBgaPiD2djIHMFrDX+sygk1ljFpK5BPF9Y+WR/
         u/ZlAazBEOjSD1ZO2kjgRXW7wiwIbQpSgX4CK3IjLh871v1pG2d6jDhQnweqAnzoUH9Z
         Zpgg==
X-Gm-Message-State: AC+VfDzacCbw9FTP+6lYAVO8KrmoTpkoC9f45Cc0cVdZ/Odv5TLizrlk
        OPjThx1ro7z119Y/Al0WeUw=
X-Google-Smtp-Source: ACHHUZ5BE2JaRf9U/RJpZMsASVAr/InFv9I3p6UcUaGtwKesvlbWrLfzH9LHqG+tmTWYjJCn3wl8NA==
X-Received: by 2002:a05:6359:b95:b0:12b:d23d:f5bf with SMTP id gf21-20020a0563590b9500b0012bd23df5bfmr15658173rwb.0.1687475171058;
        Thu, 22 Jun 2023 16:06:11 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id d18-20020a63f252000000b0054febe8a5f6sm5348113pgk.82.2023.06.22.16.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 16:06:10 -0700 (PDT)
Date:   Thu, 22 Jun 2023 23:06:09 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        linux-hyperv@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Simon Horman <simon.horman@corigine.com>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v4 5/8] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <ZJTT4QTwD824pBsh@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-5-0cebbb2ae899@bytedance.com>
 <med476cdkdhkylddqa5wbhjpgyw2yiqfthvup2kics3zbb5vpb@ovzg57adewfw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <med476cdkdhkylddqa5wbhjpgyw2yiqfthvup2kics3zbb5vpb@ovzg57adewfw>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 05:29:08PM +0200, Stefano Garzarella wrote:
> On Sat, Jun 10, 2023 at 12:58:32AM +0000, Bobby Eshleman wrote:
> > This commit adds a feature bit for virtio vsock to support datagrams.
> > 
> > Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> > include/uapi/linux/virtio_vsock.h | 1 +
> > 1 file changed, 1 insertion(+)
> 
> LGTM, but I'll give the R-b when we merge the virtio-spec.
> 
> Stefano
> 

Roger that.

> > 
> > diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> > index 64738838bee5..9c25f267bbc0 100644
> > --- a/include/uapi/linux/virtio_vsock.h
> > +++ b/include/uapi/linux/virtio_vsock.h
> > @@ -40,6 +40,7 @@
> > 
> > /* The feature bitmap for virtio vsock */
> > #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
> > +#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
> > 
> > struct virtio_vsock_config {
> > 	__le64 guest_cid;
> > 
> > -- 
> > 2.30.2
> > 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
