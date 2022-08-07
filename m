Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7937258BB01
	for <lists+kvm@lfdr.de>; Sun,  7 Aug 2022 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiHGN1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 09:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiHGN1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 09:27:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1170A1A9
        for <kvm@vger.kernel.org>; Sun,  7 Aug 2022 06:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659878830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kWN2+XtBy7D+eIoeR0CwA7v9KmusYi195gp46RwIqnc=;
        b=gQgXaS/7yJ2D1IWEwJNyNpQH9K5d42xv5JQv+9PeCqZhYLovQMYBcvJxR6DkS4IU8ULpU5
        63RYA+G/9J/dh4YkvPD6yizaXJd9XToFqfP9DB4oP8HoyDl0AkaTcPFhuLwDI/DJ5L3AJx
        QyiTclOMGs7Qiz1mp3aRfN9QSfWiDRM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-pMq4tQmaPFuWLzQO7MU9pg-1; Sun, 07 Aug 2022 09:27:09 -0400
X-MC-Unique: pMq4tQmaPFuWLzQO7MU9pg-1
Received: by mail-wm1-f69.google.com with SMTP id i10-20020a1c3b0a000000b003a537031613so1411246wma.2
        for <kvm@vger.kernel.org>; Sun, 07 Aug 2022 06:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kWN2+XtBy7D+eIoeR0CwA7v9KmusYi195gp46RwIqnc=;
        b=m9Z6TOEKV9hiEF/K0xkBAQVmRbLCMTzFmkLe4gEaSF7dlOOoG4EzrO3LRFGllw5ARW
         JLBxTghJlujoSzNacXq/OlU3Cj480yNdKQQm9TF9jqBMvSN9nMbMBiudxbevGUuV6fK2
         uhZJHQlF6ZI5i7WC6co+ol3vsTgnLJoHfA3Nm9IzlRHYHeHLYiJa/xz9hT/2rvsxaxiV
         13hKJpdz7yz/P3UEbVk0GvCHaLjX9Doa9/PM0LvKPcnnsOEEVfvvBpCCz9t767WmIVdD
         vK35kU1GgiBqTDpK7BjXPvRHGXcA8oHNbEza+0kJltVhxo7+3OoPM/9iCEAJksbAG+i3
         PUYQ==
X-Gm-Message-State: ACgBeo2OnRJ/YpQ4TrqcQ0HORr7IBU0GARNq6VIe+1qfB7+1Y1uT0F98
        zBMkYqefI469EFQM9UypXmeM09OmLIEhvJAQUqrpxqgZqYOJgAOsgI7mtH7Pr3nvmFyro6iP8O9
        OGjYjP7tDNerR
X-Received: by 2002:a5d:4e52:0:b0:21f:15aa:1174 with SMTP id r18-20020a5d4e52000000b0021f15aa1174mr8959074wrt.106.1659878828292;
        Sun, 07 Aug 2022 06:27:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4PyGIbZ+3Zk1aEnQjWqF7U3soahzcZWTwqegYNF9JB2kgqFNme3tS807SILWNR3wTzZIMDGg==
X-Received: by 2002:a5d:4e52:0:b0:21f:15aa:1174 with SMTP id r18-20020a5d4e52000000b0021f15aa1174mr8959067wrt.106.1659878828086;
        Sun, 07 Aug 2022 06:27:08 -0700 (PDT)
Received: from redhat.com ([2.52.21.123])
        by smtp.gmail.com with ESMTPSA id d14-20020adfe84e000000b0021badf3cb26sm10887722wrn.63.2022.08.07.06.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 06:27:07 -0700 (PDT)
Date:   Sun, 7 Aug 2022 09:27:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Will Deacon <will@kernel.org>, stefanha@redhat.com,
        jasowang@redhat.com, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220807091455-mutt-send-email-mst@kernel.org>
References: <20220805181105.GA29848@willie-the-truck>
 <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wip-Lju3ZdNwknS6ouyw+nKXeRSnhqVyNo8WSEdk-BfGw@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022 at 03:57:08PM -0700, Linus Torvalds wrote:
> And hey, it's possible that the bit encoding is *so* incestuous that
> it's really hard to split it into two. But it really sounds to me like
> somebody mindlessly re-used a feature bit for a *completely* different
> thing. Why?
> 
> Why have feature bits at all, when you then re-use the same bit for
> two different features? It kind of seems to defeat the whole purpose.

What can I say? Hindsight is 20/20. The two things are
*related* in that IOTLB in vhost is a way for userspace
(the platform) to limit device access to guest memory.
So we reused the feature bits (it's not the only one,
just the one we changed most recently).
It bothered me a bit but everyone seemed happy and
was able to refer to virtio spec for documentation so there
was less documentation to write for Linux.

It's not that it's hard to split it generally, it's just that
it's been there like this for a while so it's hard to change
now - we need to find a way that does not break existing userspace.

-- 
MST

