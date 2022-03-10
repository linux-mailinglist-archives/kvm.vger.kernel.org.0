Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAED4D4779
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 13:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbiCJM7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 07:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbiCJM7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 07:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0489846667
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646917081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pQET2MPPoFWIolLulpf9vgE2ol9UeRG3d/CiXthk1lc=;
        b=SJ2Wmd88gO6+pKr9vLfPbaeaavTZzgnrNRBi4P7bjptKaY96JzAkFAkZRLXg92ZUe8urX1
        RvRI0w7bWDt5v3NYR3VxbINoVad7RNPsV17p5FUqnNV93si0ufaWGkW5sMc7DUGVDQjKJE
        2Ip7EZ8iL3vq6+VUUsOsv6aRAnbBbjI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-a0b3-hReMPOYxJXKL5XVOQ-1; Thu, 10 Mar 2022 07:58:00 -0500
X-MC-Unique: a0b3-hReMPOYxJXKL5XVOQ-1
Received: by mail-wr1-f69.google.com with SMTP id t15-20020a5d534f000000b001f1e5759cebso1675301wrv.7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:58:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pQET2MPPoFWIolLulpf9vgE2ol9UeRG3d/CiXthk1lc=;
        b=w/ubUDooWzXkTyP7x5/NoPu69yLi8dsvfdI7FzmUMIM3UlmkLnwUC1wOp+oEuhBQvX
         xEdRvznbVEGF9328/w1lJ7ESV6XcwurJ/kDbjGe75k0uk+1SJfCAMx/ael+LQx9NmbsI
         +hCvLiSU+sxixEjnciM5OSLv8QgKl5b/OJv3AbbM7uXFAGWPmGGcnox8sMMqklPWDDzk
         jbrlFl/Xz1HRVfeCwWuKrOX0d+ulSipLhK1A0dCtzxNLPXIuEZ9E4aIiN8zL7TGBW1Cg
         08UtKakFhTzv9pbQ6/RKfzIYBH8eWx00RGIVZF4GbzVkPtBMTmuVQYO6WEW87kxrgwNl
         ZHcg==
X-Gm-Message-State: AOAM532vN40umiWBmZoTP1dKTQu9ChPVYvEmJOQGBy+2kVK2vnRohOp0
        Vlpm92NSjQiLfp0miolRoZa7NAbJdrDUkOkMR7/3b5A6XOu2kTyhssyYDHk26PdyFQJ1mWk74IQ
        6g71uhADuPfR6
X-Received: by 2002:a5d:5846:0:b0:203:6b34:37af with SMTP id i6-20020a5d5846000000b002036b3437afmr3679522wrf.58.1646917078730;
        Thu, 10 Mar 2022 04:57:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNy/izqOOZPKvRpP+GlT6cO3sQtQvas8NEWLfQ+g6cahHLf6mWcq6HAOBus4EAcYOUh56YBg==
X-Received: by 2002:a5d:5846:0:b0:203:6b34:37af with SMTP id i6-20020a5d5846000000b002036b3437afmr3679501wrf.58.1646917078395;
        Thu, 10 Mar 2022 04:57:58 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id u4-20020adfed44000000b0020373d356f8sm4119668wro.84.2022.03.10.04.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 04:57:57 -0800 (PST)
Date:   Thu, 10 Mar 2022 07:57:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     sgarzare@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vsock: cycle only on its own socket
Message-ID: <20220310075554-mutt-send-email-mst@kernel.org>
References: <20220310125425.4193879-1-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310125425.4193879-1-jiyong@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 09:54:23PM +0900, Jiyong Park wrote:
> Hi Stefano,
> 
> As suggested [1], I've made two patches for easier backporting without
> breaking KMI.
> 
> PATCH 1 fixes the very issue of cycling all vsocks regardless of the
> transport and shall be backported.
> 
> PATCH 2 is a refactor of PATCH 1 that forces the filtering to all
> (including future) uses of vsock_for_each_connected_socket.
> 
> Thanks,
> 
> [1] https://lore.kernel.org/lkml/20220310110036.fgy323c4hvk3mziq@sgarzare-redhat/


OK that's better. Pls do include changelog in the future.

Acked-by: Michael S. Tsirkin <mst@redhat.com>



> Jiyong Park (2):
>   vsock: each transport cycles only on its own sockets
>   vsock: refactor vsock_for_each_connected_socket
> 
>  drivers/vhost/vsock.c            | 3 ++-
>  include/net/af_vsock.h           | 3 ++-
>  net/vmw_vsock/af_vsock.c         | 9 +++++++--
>  net/vmw_vsock/virtio_transport.c | 7 +++++--
>  net/vmw_vsock/vmci_transport.c   | 3 ++-
>  5 files changed, 18 insertions(+), 7 deletions(-)
> 
> 
> base-commit: 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
> -- 
> 2.35.1.723.g4982287a31-goog

