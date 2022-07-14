Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C30574F2D
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiGNNbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiGNNbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D0F3B01
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657805458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3A2MgQ6BI+ZOeh/AAU41/XCV92zAyr9BTrgNi4g6/m4=;
        b=NJ9V6pr7/kJyhMRemq7jCz0bA6twonVXLFZSLAi5src8nlhMJKpL1yCK2RZoJG+IzadVcV
        aNCMHvu5zvbJ6DDEDpvdCmd8EANHM3D0rzbhGWCo9Qp6frIQWbdbd2MnJ1PQVicjAQ0GkB
        /GvOgzOt65tk3LdJGk8k/K/8MuMZDGg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-E8geG59JNpCXsKJ8_zEn6w-1; Thu, 14 Jul 2022 09:30:57 -0400
X-MC-Unique: E8geG59JNpCXsKJ8_zEn6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4F1F8117B0;
        Thu, 14 Jul 2022 13:30:56 +0000 (UTC)
Received: from localhost (unknown [10.39.193.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F239492C3B;
        Thu, 14 Jul 2022 13:30:56 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Gavin Shan <gshan@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
In-Reply-To: <Ysg38XZSzPk8tYwK@xz-m1.local>
Organization: Red Hat GmbH
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com> <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com> <YrwRPh1S6qjzkJMm@arm.com>
 <7a32fde7-611d-4649-2d74-f5e434497649@arm.com> <871qv12hqj.fsf@redhat.com>
 <b91ae197-d191-2204-aab5-21a0aabded69@arm.com> <87bktz7o49.fsf@redhat.com>
 <Ysg38XZSzPk8tYwK@xz-m1.local>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Thu, 14 Jul 2022 15:30:54 +0200
Message-ID: <87edynizxt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08 2022, Peter Xu <peterx@redhat.com> wrote:

> On Fri, Jul 08, 2022 at 03:03:34PM +0200, Cornelia Huck wrote:

>> I was thinking about a new flag that implies "copy metadata"; not sure
>> how we would get the same atomicity with a separate ioctl. I've only
>> just started looking at userfaultfd, though, and I might be on a wrong
>> track... One thing I'd like to avoid is having something that is too
>> ARM-specific, I think there are other architecture features that might
>> have similar issues.
>
> Agreed, to propose such an interface we'd better make sure it'll be easily
> applicable to other similar memory protection mechanisms elsewhere.

There's storage keys on s390, although I believe they are considered
legacy by now. I dimly recall something in x86 land.

>
>> 
>> Maybe someone more familiar with uffd and/or postcopy can chime in?
>
> Hanving UFFDIO_COPY provide a new flag sounds reasonable to me.  I'm
> curious what's the maximum possible size of the tags and whether they can
> be embeded already into struct uffdio_copy somehow.

Each tag is four bits and covers 16 bytes (also see the defs in
arch/arm64/include/asm/mte-def.h).

