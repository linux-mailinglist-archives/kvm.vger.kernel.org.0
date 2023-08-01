Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4624676B957
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjHAQFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjHAQFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1665390
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690905893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rZTW9cojqSQW2bZi6sZ+IdoqRlKJXkCjqyxPfvTXPbg=;
        b=fUpd+S2i/lsHkkHCaxLPaEkksy5NPZM7sTy/Kfr7gF27Xuvp78NOBnlZtH57gisTiGssGM
        aRbF8nX9A3FRnCS93DMdgbhiUxKEcolzgVL1Hfs5GT3zUbEr1M4MCRDzacrrv3BhYDTecy
        vbpZLpbJzuAaMxm3jjELbJhX3VyX/EI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-zdafeHFOM5-w1rfzlBDaVw-1; Tue, 01 Aug 2023 12:04:51 -0400
X-MC-Unique: zdafeHFOM5-w1rfzlBDaVw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe1bef4223so15374925e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 09:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690905890; x=1691510690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZTW9cojqSQW2bZi6sZ+IdoqRlKJXkCjqyxPfvTXPbg=;
        b=gj5/0eSEAUcVdBycydidVltNYIoQwOeSkIaHR8ybZzHlG/TnshuRpgOaK6PGQg8j2l
         LXTBN5yz4hqb5ZVTR7vgGl8VuIWqJJWVNKxPiFbpIWXrB4TU+9TERVRphWo9NWzHYCg1
         hlgacX+q4TIoqyQVmLq7bCfxtVsuAiirwExJTH13hAFQ0nQ/EvdJDjvh9UTMHXNG8xWg
         ZxOwln+oxFmFRSmJoQOaYE1G+fKjLAwwB2dJzUTlpguB3jZ8e1tNGXytC7af+q7vjQW+
         3x7SkjNUDi66OMLtL2wEu+KljrQ/RfcH3ASZH5CxJ8cCCZu4mTnDSq3tXcuSHQnvBGBr
         kf7g==
X-Gm-Message-State: ABy/qLaGxaX+oQQBp1SQVCLVA+JIi8GOwNzQ4i+7X6R3e6+kXVEXLAjJ
        9qYVW/FGwupYCXqqG/8Kbmdo703SWwGDH3WzI39KXR4V8CnLfkPxu2IRT85UX9xDZJNSZQ8VGMu
        wp+eciPF2N+dS
X-Received: by 2002:a1c:7310:0:b0:3fb:e189:3532 with SMTP id d16-20020a1c7310000000b003fbe1893532mr2701267wmb.20.1690905890721;
        Tue, 01 Aug 2023 09:04:50 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHNvxPggY+ulCpxWm153ryyCBd6qp7Nemz78JW1jh60aRTALT7If6+aYqQcQ/iizAk261YnOw==
X-Received: by 2002:a1c:7310:0:b0:3fb:e189:3532 with SMTP id d16-20020a1c7310000000b003fbe1893532mr2701225wmb.20.1690905890321;
        Tue, 01 Aug 2023 09:04:50 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-214.retail.telecomitalia.it. [82.57.51.214])
        by smtp.gmail.com with ESMTPSA id d7-20020adfe2c7000000b00317ac0642b0sm3078341wrj.27.2023.08.01.09.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 09:04:49 -0700 (PDT)
Date:   Tue, 1 Aug 2023 18:04:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        linux-hyperv@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
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
Subject: Re: [PATCH RFC net-next v5 10/14] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <nnftjp3ek3hpiqlvz6ajbxcjswraclrayei2wi2qwgxzi7gpl6@yxdcz5eknofy>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-10-581bd37fdb26@bytedance.com>
 <20230726143736-mutt-send-email-mst@kernel.org>
 <tpwk67lij7t7hquduogxzyox5wvq73yriv7vqiizqoxxtxvfwq@jzkcmq4kv3b4>
 <ZMiKXh173b/3Pj1L@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZMiKXh173b/3Pj1L@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 04:30:22AM +0000, Bobby Eshleman wrote:
>On Thu, Jul 27, 2023 at 09:48:21AM +0200, Stefano Garzarella wrote:
>> On Wed, Jul 26, 2023 at 02:38:08PM -0400, Michael S. Tsirkin wrote:
>> > On Wed, Jul 19, 2023 at 12:50:14AM +0000, Bobby Eshleman wrote:
>> > > This commit adds a feature bit for virtio vsock to support datagrams.
>> > >
>> > > Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>> > > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > > ---
>> > >  include/uapi/linux/virtio_vsock.h | 1 +
>> > >  1 file changed, 1 insertion(+)
>> > >
>> > > diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> > > index 331be28b1d30..27b4b2b8bf13 100644
>> > > --- a/include/uapi/linux/virtio_vsock.h
>> > > +++ b/include/uapi/linux/virtio_vsock.h
>> > > @@ -40,6 +40,7 @@
>> > >
>> > >  /* The feature bitmap for virtio vsock */
>> > >  #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>> > > +#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
>> > >
>> > >  struct virtio_vsock_config {
>> > >  	__le64 guest_cid;
>> >
>> > pls do not add interface without first getting it accepted in the
>> > virtio spec.
>>
>> Yep, fortunatelly this series is still RFC.
>> I think by now we've seen that the implementation is doable, so we
>> should discuss the changes to the specification ASAP. Then we can
>> merge the series.
>>
>> @Bobby can you start the discussion about spec changes?
>>
>
>No problem at all. Am I right to assume that a new patch to the spec is
>the standard starting point for discussion?

Yep, I think so!

Thanks,
Stefano

