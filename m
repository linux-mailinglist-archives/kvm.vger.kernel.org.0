Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB061FB11
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiKGRTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiKGRS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:18:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964AC2229D
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eyB5XQfj8X8XBN5oEWy4ddR/NP8TDNQi/nS/qaNxnEg=;
        b=AdFkNEnIEk4TsqY+hktc3GooKu4KcFSnaZdG4L5wsAQbTeshwaMOwE7keYejnhPMlQM/SR
        SCi6Cw8g6E4YvXrwYRUwyrqPSUTfF24SiFEjWuZypoLcpgSbnCYRIh6C7QIWRjFJtnaS3p
        Hlh+MpfbCdW9BC/HHLMh5JnX+ZwXrUg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-2W73CXHrMeGqDp9ENr3LVg-1; Mon, 07 Nov 2022 12:17:52 -0500
X-MC-Unique: 2W73CXHrMeGqDp9ENr3LVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52D8B85A5B6;
        Mon,  7 Nov 2022 17:17:51 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 085DD1121314;
        Mon,  7 Nov 2022 17:17:50 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v5 6/8] KVM: arm64: unify the tests for VMAs in memslots
 when MTE is enabled
In-Reply-To: <20221104011041.290951-7-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-7-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 07 Nov 2022 18:17:48 +0100
Message-ID: <87fseu3cqr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03 2022, Peter Collingbourne <pcc@google.com> wrote:

> Previously we allowed creating a memslot containing a private mapping that
> was not VM_MTE_ALLOWED, but would later reject KVM_RUN with -EFAULT. Now
> we reject the memory region at memslot creation time.
>
> Since this is a minor tweak to the ABI (a VMM that created one of
> these memslots would fail later anyway), no VMM to my knowledge has
> MTE support yet, and the hardware with the necessary features is not
> generally available, we can probably make this ABI change at this point.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/mmu.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

