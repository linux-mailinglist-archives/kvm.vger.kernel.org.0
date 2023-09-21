Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C53C7A9F53
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjIUUVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjIUUU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:20:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FB55B8DB
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=euGyxfvn6xH67AeWq/hogwCBGT3EWUuZanu0YmGfM6A=;
        b=Y533RcLj8e5h1Nk86olA3Ag3lu0Gh00YV1t+tb1kXmHyjGZgaXjmCebpb3nDjV4FHVyEYY
        qyKXa6JYApHv/dljn0Sw3cmtkKIroRnKiM3hfqhCYcKIIaklvttVs9YMXLa7EmqE/wHE7j
        /e8O+858WgY5nnwFxCIXZBb8Be8BPnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-O0vRPV8IM2eUicDLLTfj6Q-1; Thu, 21 Sep 2023 05:56:25 -0400
X-MC-Unique: O0vRPV8IM2eUicDLLTfj6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40E16811E94;
        Thu, 21 Sep 2023 09:56:24 +0000 (UTC)
Received: from localhost (unknown [10.39.195.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0448E51E3;
        Thu, 21 Sep 2023 09:56:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v10 02/12] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
In-Reply-To: <20230920183310.1163034-3-oliver.upton@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-3-oliver.upton@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 21 Sep 2023 11:56:22 +0200
Message-ID: <871qer26k9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> From: Jing Zhang <jingzhangos@google.com>
>
> Add some basic documentation on how to get feature ID register writable
> masks from userspace.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 43 ++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

