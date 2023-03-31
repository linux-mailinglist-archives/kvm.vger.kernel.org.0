Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD266D183E
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 09:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjCaHOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 03:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjCaHOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 03:14:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163DB1A453
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 00:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680246791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pbj2AVGF1WXOqLTCXZnSczyZWz0UiEcYEZC2FxVEVpY=;
        b=M/QKdNdjjRnkia57R9A055baDBZ0MFLZoY+a039ltJuUGMUwFZYWq4SXCpilozOqc4Qzoa
        Z+ikyFbTmqFJObBh0M7eTjbN7aptvHhV1zvwwkAt7zR2bxJOwB6Fdk86H6yYIAEz7lgxKI
        55IQA8lDkryb+jdaTFRtaTTrSy1B1Ls=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-lFm-6ebaNLykn0kALk42gA-1; Fri, 31 Mar 2023 03:13:02 -0400
X-MC-Unique: lFm-6ebaNLykn0kALk42gA-1
Received: by mail-ed1-f69.google.com with SMTP id k14-20020a508ace000000b005024a8cef5cso19424424edk.22
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 00:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680246781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbj2AVGF1WXOqLTCXZnSczyZWz0UiEcYEZC2FxVEVpY=;
        b=BedlT3Wf/DhIgiyjaF10ru2vhvbyCLg1nmhfMK940nrxKpY41zp80JWmLFibCm9rOf
         YTlLxggqRrkaeyctHDzDQhfKhejMkBoLP/nFBwaXauj1BgNCJW/kQQaa8E28dgAz33oO
         KU0PO2dnmWoVlXWWdAoyDWSKm6RHPi/6eQq/Hn7jttTnPNqcjfODl6X/loPHQfzjtyYN
         BsPXDPyidi072mOp2mJrUufynAkbv9YmInrhtGMvVgu8gran38lsBQnqBOEU7POh1vbI
         K7ICqqX/BZg+dzCWmb83f3FSXUfYmu4fH//I+HYcS+QKs6//6EP/fhDQ3PjIda7vCeN/
         731Q==
X-Gm-Message-State: AAQBX9ejXt43wn9llukYtHfbW0PWGqEg4SyCBuvpxmtWAhzt1A1dQcwc
        WxciGxgk65d4yDocc4RT/9mAt8Lf7rEdlGDcIBsPe5UwkVA6kgnSoqzC495ql2Q3hip4tCmnkCe
        UO22yZR2/Ycia
X-Received: by 2002:aa7:c786:0:b0:4fb:eda4:c093 with SMTP id n6-20020aa7c786000000b004fbeda4c093mr24871258eds.13.1680246781232;
        Fri, 31 Mar 2023 00:13:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y/r5+oajO+A5DGt7yB7jTmm7QBPI4K7mKeRbZE0bW0nNZD4Ae6DGvs+vyDmX8r4UvfHK6pig==
X-Received: by 2002:aa7:c786:0:b0:4fb:eda4:c093 with SMTP id n6-20020aa7c786000000b004fbeda4c093mr24871241eds.13.1680246780883;
        Fri, 31 Mar 2023 00:13:00 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id h27-20020a50cddb000000b004c19f1891fasm688400edj.59.2023.03.31.00.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 00:13:00 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:12:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, pv-drivers@vmware.com
Subject: Re: [RFC PATCH v3 2/4] vsock/vmci: convert VMCI error code to
 -ENOMEM on receive
Message-ID: <7pypi573nxgwz7vrgd2cwcrtha4abijutlsgtnxrwcgaatdjbz@cwnq5dlurfhs>
References: <4d34fac8-7170-5a3e-5043-42a9f7e4b5b3@sberdevices.ru>
 <9fd06ca5-ace9-251d-34af-aca4db9c3ee0@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9fd06ca5-ace9-251d-34af-aca4db9c3ee0@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 11:18:36PM +0300, Arseniy Krasnov wrote:
>
>
>On 30.03.2023 23:13, Arseniy Krasnov wrote:
>> This adds conversion of VMCI specific error code to general -ENOMEM. It
>> is needed, because af_vsock.c passes error value returned from transport
>> to the user, which does not expect to get VMCI_ERROR_* values.
>
>@Stefano, I have some doubts about this commit message, as it says "... af_vsock.c
>passes error value returned from transport to the user ...", but this
>behaviour is implemented only in the next patch. Is it ok, if both patches
>are in a single patchset?

Yes indeed it is not clear. In my opinion we can do one of these 2
things:

1. Update the message, where we can say that this is a preparation patch
    for the next changes where af_vsock.c will directly return transport
    values to the user, so we need to return an errno.

2. Merge this patch and patch 3 in a single patch.

Both are fine for my point of view, take your choice ;-)

Thanks,
Stefano

