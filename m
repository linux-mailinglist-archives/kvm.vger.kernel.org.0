Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24FB58C712
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 13:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbiHHLCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 07:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiHHLCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 07:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 317BF5F48
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 04:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659956526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dqSC8Z4HeQqm883ffB+WsfLf65IQJEdZYAKuOt873gg=;
        b=V5YqgD51quakaI+m6FGh71cy9/Wf9Pp/sgmrZafpgiGbe8sIYc6HK6lyO4zvBFVHdn/Jra
        GpdO4B7fE0a1lqHjQW5mFgwvbqov4wbr2k0vOjjA73LhOrBCmiq2WyrDRhWHf/Tvrw+M52
        eWUHbJpiiHDCFO83btklU1BGY2cX2YM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-ONwPdffsO-mIKYRO_Md7rg-1; Mon, 08 Aug 2022 07:02:05 -0400
X-MC-Unique: ONwPdffsO-mIKYRO_Md7rg-1
Received: by mail-qv1-f69.google.com with SMTP id dc13-20020a056214174d00b0047b6f9a1a9aso55956qvb.23
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 04:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dqSC8Z4HeQqm883ffB+WsfLf65IQJEdZYAKuOt873gg=;
        b=PGB1torw1aValQgmh2+aNtrbCwoH4kWK5HuzKLfsI8cixnE5sdxJmNc3JZBcbFhy1D
         uN/H0G81ymYq6uib5LvceFRzH7quJUV4xzRj1QW6tup54IHN26Nsbuc4T+k0LiadgQqf
         Eb6uocd+TFdWY+nmTWASODXZuUYPGt8xzdPtBipF5Cko0Eb4jpRrhb0Y2yx7g7Nl7Ycz
         TmiSd41Gu5WP6AFodlznlTY0qd0+EvfVgkEGJ7HIhz90Gjz4RfhSN3TPG+a+XtdyyoeH
         UMVvH4GcC/HPCvIE/pf7Id3wjNng5I12CKvc54QNL3JI4wBYSjMndLk4xQ0TzXjXQ6K0
         PTjQ==
X-Gm-Message-State: ACgBeo0vSD1EyKdGqXmiqWRstzYlC84a2zgtjYhp3AJGX5ks5b/IzsZr
        gi74t9XfyD+/wf7XSyzPHJuO5Dyog5kOXVyoUfCpEMl+CpEZDItEHSKrRn+AsbRQ/rKqYqKckn8
        uSiHE1GGx8/k/
X-Received: by 2002:a05:6214:20e8:b0:47a:e5b6:bcb3 with SMTP id 8-20020a05621420e800b0047ae5b6bcb3mr7619234qvk.38.1659956524315;
        Mon, 08 Aug 2022 04:02:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5af4E0jk6+7t6mFWBjWuptUfkOlYxy4pZL8QV5ftEnM5OWH42lAy5tmEXpZlpzsK0Juazm5g==
X-Received: by 2002:a05:6214:20e8:b0:47a:e5b6:bcb3 with SMTP id 8-20020a05621420e800b0047ae5b6bcb3mr7619210qvk.38.1659956524067;
        Mon, 08 Aug 2022 04:02:04 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a454c00b006b928ba8989sm885511qkp.23.2022.08.08.04.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 04:02:03 -0700 (PDT)
Date:   Mon, 8 Aug 2022 13:01:53 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 8/9] vmci/vsock: check SO_RCVLOWAT before wake up
 reader
Message-ID: <20220808110153.fkxwwqbbqxz7wvgw@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <5b7e133e-f8e1-1f71-9a3c-ac0265cffb63@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5b7e133e-f8e1-1f71-9a3c-ac0265cffb63@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 02:05:52PM +0000, Arseniy Krasnov wrote:
>This adds extra condition to wake up data reader: do it only when number
>of readable bytes >= SO_RCVLOWAT. Otherwise, there is no sense to kick
>user,because it will wait until SO_RCVLOWAT bytes will be dequeued.

Ditto as previous patch.

@Bryan, @Vishnu, plaese, can you review/ack also this patch?

Thanks,
Stefano

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/vmci_transport_notify.c        | 2 +-
> net/vmw_vsock/vmci_transport_notify_qstate.c | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/vmci_transport_notify.c b/net/vmw_vsock/vmci_transport_notify.c
>index 852097e2b9e6..7c3a7db134b2 100644
>--- a/net/vmw_vsock/vmci_transport_notify.c
>+++ b/net/vmw_vsock/vmci_transport_notify.c
>@@ -307,7 +307,7 @@ vmci_transport_handle_wrote(struct sock *sk,
> 	struct vsock_sock *vsk = vsock_sk(sk);
> 	PKT_FIELD(vsk, sent_waiting_read) = false;
> #endif
>-	sk->sk_data_ready(sk);
>+	vsock_data_ready(sk);
> }
>
> static void vmci_transport_notify_pkt_socket_init(struct sock *sk)
>diff --git a/net/vmw_vsock/vmci_transport_notify_qstate.c b/net/vmw_vsock/vmci_transport_notify_qstate.c
>index 12f0cb8fe998..e96a88d850a8 100644
>--- a/net/vmw_vsock/vmci_transport_notify_qstate.c
>+++ b/net/vmw_vsock/vmci_transport_notify_qstate.c
>@@ -84,7 +84,7 @@ vmci_transport_handle_wrote(struct sock *sk,
> 			    bool bottom_half,
> 			    struct sockaddr_vm *dst, struct sockaddr_vm *src)
> {
>-	sk->sk_data_ready(sk);
>+	vsock_data_ready(sk);
> }
>
> static void vsock_block_update_write_window(struct sock *sk)
>@@ -282,7 +282,7 @@ vmci_transport_notify_pkt_recv_post_dequeue(
> 		/* See the comment in
> 		 * vmci_transport_notify_pkt_send_post_enqueue().
> 		 */
>-		sk->sk_data_ready(sk);
>+		vsock_data_ready(sk);
> 	}
>
> 	return err;
>-- 
>2.25.1

