Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD337A6556
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 15:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjISNg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 09:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjISNgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 09:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B79F4
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695130561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQmRjXCmgAQl3a6tpa/J+d//osgH4H/G1TUy2TGbM10=;
        b=enFmpdmPnDJUjCGdFo2A+7ljU6lVl06QBRf4XfQhtrxaUVwKsHRoWSV+7i9iVDfpwhyY6i
        29utuKROz4Fz2xuWWGsdyX6yx2zoVL6xdDqJVQEUMrtY1OQ1Ssrv+2Xd/dSNnH+nTIGzaS
        LHj14iahnvgWIw7pomcemw5UDyvxLxM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-ERlllHtSP5mnHAyRXQqVqA-1; Tue, 19 Sep 2023 09:35:59 -0400
X-MC-Unique: ERlllHtSP5mnHAyRXQqVqA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-773c03f2bdaso374236085a.2
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 06:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695130559; x=1695735359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQmRjXCmgAQl3a6tpa/J+d//osgH4H/G1TUy2TGbM10=;
        b=SIsYvEd9ByjbccpnadDSXgqw6BA1xNBfCaPe2ocHvTbmoOET175QCFmobRMiXaCChf
         5obTJzQ6YnI2bv//JlkRqnC50jfh6wqUShglynb6coWrOWo1O60AirFXr8UkdL5jTH3p
         FjjBI6jumIBdHmZbbliWrB1ulmaVXt939UShJeNtgqQXmV1djR/Z9g/RmZUIW09RM1Zp
         o3OBTsvVoaXKqr0NPh1pbH45ceSSUg2TkqT1kUTGmcKlN6qPdPgWLpDgKW/wt1I5ywZc
         jIBOVjHCHSTc0LmI4m+NMIXjIMpnVKxY9wvvETgwQ/RE8iu0atd1gfTwygBNI4NbRDHN
         vujw==
X-Gm-Message-State: AOJu0YwN+/Nofs2T3GPut8ceSqDMTyuWHTAmdSsfnJzV61yvpBFObDKU
        EQjLC5M64bEdO2OogOcMdPhu0CMSzeHyrjhbXYhMjo9Catu8zpllCSmfolUzJqN5hLhDqCb5yP/
        WVWDAmQ3y+0vP
X-Received: by 2002:a0c:f001:0:b0:656:4a25:2080 with SMTP id z1-20020a0cf001000000b006564a252080mr7874556qvk.14.1695130559371;
        Tue, 19 Sep 2023 06:35:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELog22rYA2MEE9wvtU9k2iQ0qP5GVCV4XB9+NFnOEeZMlYRp+cnMnNZiRhNH7IqEct7Tt4FA==
X-Received: by 2002:a0c:f001:0:b0:656:4a25:2080 with SMTP id z1-20020a0cf001000000b006564a252080mr7874542qvk.14.1695130559155;
        Tue, 19 Sep 2023 06:35:59 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.165.38])
        by smtp.gmail.com with ESMTPSA id g28-20020a0caadc000000b0064d6a81e4d4sm1773184qvb.113.2023.09.19.06.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 06:35:58 -0700 (PDT)
Date:   Tue, 19 Sep 2023 15:35:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arseniy Krasnov <avkrasnov@salutedevices.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <hq67e2b3ljfjikvbaneczdve3fzg3dl5ziyc7xtujyqesp6dzm@fh5nqkptpb4n>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
 <b5873e36-fe8c-85e8-e11b-4ccec386c015@salutedevices.com>
 <yys5jgwkukvfyrgfz6txxzqc7el5megf2xntnk6j4ausvjdgld@7aan4quqy4bs>
 <a5b25ee07245125fac4bbdc3b3604758251907d2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a5b25ee07245125fac4bbdc3b3604758251907d2.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 03:19:54PM +0200, Paolo Abeni wrote:
>On Tue, 2023-09-19 at 09:54 +0200, Stefano Garzarella wrote:
>> On Mon, Sep 18, 2023 at 07:56:00PM +0300, Arseniy Krasnov wrote:
>> > Hi Stefano,
>> >
>> > thanks for review! So when this patchset will be merged to net-next,
>> > I'll start sending next part of MSG_ZEROCOPY patchset, e.g. AF_VSOCK +
>> > Documentation/ patches.
>>
>> Ack, if it is not a very big series, maybe better to include also the
>> tests so we can run them before merge the feature.
>
>I understand that at least 2 follow-up series are waiting for this, one
>of them targeting net-next and the bigger one targeting the virtio
>tree. Am I correct?

IIUC the next series will touch only the vsock core
(net/vmw_vsock/af_vsock.c), tests, and documentation.

The virtio part should be fully covered by this series.

@Arseniy feel free to correct me!

>
>DaveM suggests this should go via the virtio tree, too. Any different
>opinion?

For this series should be fine, I'm not sure about the next series.
Merging this with the virtio tree, then it forces us to do it for
followup as well right?

In theory followup is more on the core, so better with net-next, but
it's also true that for now only virtio transports support it, so it
might be okay to continue with virtio.

@Michael WDYT?

Thanks,
Stefano

