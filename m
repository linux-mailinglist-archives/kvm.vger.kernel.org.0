Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65F258B51C
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 12:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiHFKxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 06:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiHFKxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 06:53:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5437CE008
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 03:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659783189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HoXZYNXSL5fLTvts22bXZSeKXcAG3hKrGWdYE5IH2uY=;
        b=Nr3qZza7tnQQZcddDs4nPi5bcyObj+3I7XA+5DZloDGmmNViI40aF1VDCmkW+jkhhQXrN3
        t1JZH0lTJAnuPqMgp/zhxOeSf+wf2tkC7OuFhROAPnzADNIQ+Y8HBF4XtozyHjk+mhySBk
        W4VwerI1SVQN6xt7zaixUV7+6rGASWQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-g7s6nzs8N3ybkrcOAQlRag-1; Sat, 06 Aug 2022 06:53:08 -0400
X-MC-Unique: g7s6nzs8N3ybkrcOAQlRag-1
Received: by mail-lj1-f200.google.com with SMTP id u7-20020a2e2e07000000b0025e4fbba9f0so1461430lju.13
        for <kvm@vger.kernel.org>; Sat, 06 Aug 2022 03:53:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HoXZYNXSL5fLTvts22bXZSeKXcAG3hKrGWdYE5IH2uY=;
        b=0HEqdODtd+iU/Tdaf5h2GmW+BKGfAaNZFT2Gap0j4B5pmIXGmpjWbF2+lcJ6YXipfq
         B0SdRld4P0TEHvIE+CF34+hhSAKio+3Ww51fh1M22nbHXdWhxgWYxl48/qXrO5QsdNgL
         +2A4p0A7ic4t59GozacdyaIu1VPxQCzVVpguYGlUyIhG72GRG6q4ocrqD+XFaJpKG8D7
         3qLOEZJHRUbYQL+Fjs9BcWa+aI8KWt+xmTPeUtulT/H/SXO7Raj6rWQxty2Vhbhd8Are
         MwDb2uzRnN8wfoBecPUiODWz87HZUTHXjpm1GJCtl1r0izsZdeNVFs1oObxBfXjF3T7h
         FFFQ==
X-Gm-Message-State: ACgBeo0yJEc+XlJJu4THJ9VBCTtpJC5he7AZ8FdX6NdiM1or4bsb9Rxr
        GiLj3/6YJtgB+e0rtv52rUXrhLJ4sDPkS8Ea2IQxdKGEb2BylHAvQFhXIXDRGGfDvchMWpUwygx
        jO7oMqMRrV0GkMkD71xbTskTWRyIE
X-Received: by 2002:a19:ab02:0:b0:48b:3f9:add1 with SMTP id u2-20020a19ab02000000b0048b03f9add1mr3725684lfe.329.1659783186774;
        Sat, 06 Aug 2022 03:53:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR68ndpqPOOxRv2oo+THbpQNjgqPKLoS/uiP2MJpF6wKiapM7segimQKmjhNFxOTs1KVU4EO6HP0z4kLPfWE/JQ=
X-Received: by 2002:a19:ab02:0:b0:48b:3f9:add1 with SMTP id
 u2-20020a19ab02000000b0048b03f9add1mr3725668lfe.329.1659783186556; Sat, 06
 Aug 2022 03:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220805181105.GA29848@willie-the-truck> <20220806074828.zwzgn5gj47gjx5og@sgarzare-redhat>
 <20220806094239.GA30268@willie-the-truck> <CAD60JZMbbkwFHqCm_iCrOrKgRLBUMkDQfuJ=Q1T-sZt59eTBrw@mail.gmail.com>
In-Reply-To: <CAD60JZMbbkwFHqCm_iCrOrKgRLBUMkDQfuJ=Q1T-sZt59eTBrw@mail.gmail.com>
From:   Stefan Hajnoczi <shajnocz@redhat.com>
Date:   Sat, 6 Aug 2022 06:52:55 -0400
Message-ID: <CAD60JZN2rTWAXoSVtpOVGABw+rLGuQn=DLTEsN+UnHOMEEiLQA@mail.gmail.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
To:     Will Deacon <will@kernel.org>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, mst@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/vhost devices are full VIRTIO devices/vhost devices are not full
VIRTIO devices/

