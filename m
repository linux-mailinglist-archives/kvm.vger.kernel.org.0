Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A3161FB1C
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiKGRUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiKGRUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:20:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86B23BCD
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vj6jKgV57HR3Syp9+ASZUDM7wgYRBqwk96cC1Kgx8ZM=;
        b=Dhg4Wgs7kve2rEk9jRcUkvI9NTN1JpcFASrKgKn7vitmkBf6AuGp9QXzX2gFnr/6JcR6rA
        SVnJYwqKfW0540CW8dWFFaS7+778IE9cPbyO7eLM1lgy6wN+HkUpFJqTAHmKBi/ScTPnf0
        ZiQ/jDLUCAvAJ1yE/9YSg+b8fjfRS9g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-5I8FLPu2M7CS5gN_-WeOdA-1; Mon, 07 Nov 2022 12:19:15 -0500
X-MC-Unique: 5I8FLPu2M7CS5gN_-WeOdA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D34CF101A52A;
        Mon,  7 Nov 2022 17:19:14 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87685492B05;
        Mon,  7 Nov 2022 17:19:14 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v5 7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
In-Reply-To: <20221104011041.290951-8-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-8-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 07 Nov 2022 18:19:13 +0100
Message-ID: <87cz9y3coe.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

> Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
> on being able to map guest memory as MAP_SHARED. The current restriction
> on sharing MAP_SHARED pages with the guest is preventing the use of
> those features with MTE. Now that the races between tasks concurrently
> clearing tags on the same page have been fixed, remove this restriction.
>
> Note that this is a relaxation of the ABI.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/mmu.c | 8 --------
>  1 file changed, 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

