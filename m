Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31CC6A5E48
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 18:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjB1Rff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 12:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1Rfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 12:35:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E379C17163
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 09:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677605689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/AGn97AI8YGBk4aLDSy0vGS4XOOuR9v1pJVC2xh3L4=;
        b=GWKEogZO+CTxOCv30EgVvTVlG1CIQDuHPJ05sedwPaWHhS+jhjK/s/zJa9WyHfirTLj3fB
        wyQnKnEiyY0EtZYmZBATxvja5UxdqW9oX3dzwOKb+yHY+PIpsIdbOzvJ2SF/q6NLmYkemE
        lWHhZjZKqH4onQwsSVRQ17DJ3ra3GCs=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-u_gRZzNoMBO6rujaVf6nFw-1; Tue, 28 Feb 2023 12:34:44 -0500
X-MC-Unique: u_gRZzNoMBO6rujaVf6nFw-1
Received: by mail-pg1-f198.google.com with SMTP id y1-20020a631801000000b00503696ca95dso2039253pgl.1
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 09:34:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/AGn97AI8YGBk4aLDSy0vGS4XOOuR9v1pJVC2xh3L4=;
        b=Z3AkoMf/tNgSpaNMCA47B5cYeuBYgr9fJbPCpqVydEfINh+z8NtSdTIbkWZ2jaZv/L
         Rg5wwIJvKjrLikG3JUox/s8qpvNqk1LQLQYMUsjOXput6qRSEzYSqQnxt0BHafjHndfO
         q0etySI6BwCTTl4+KiAHk4Hk7HByuOzjk3NXwCNzHgmcOAR0xnvUXYDOHM37Deh+bMH1
         CAqrLQkeiOmUkkKzjehjHvwV8LNhOz3WiZC1jIPfSuP+xNmSCaYjjMMU9hQFZ8Yc9Qlu
         RHZkOJZdz18Pi3N3SrHl+6cn0nlDY2Hk4w6InMKUCNpDeuQfE7y3/uTvO2IrcaWGAep6
         IzPg==
X-Gm-Message-State: AO0yUKXLg2oPxK5ldAG+aCyyQ5p+i/5npkIWx9fl+zD+0p6fd093HnDk
        WvpHX/SHGZRe8EhTde4TjffYm83MP9nEem3CQTx/i3yPJbCuts0lOWi3AzF32PmnbxVWSTRP64a
        b+pwXptmQyGGz0aI6t+XYJyC2tcfV
X-Received: by 2002:a17:90a:d3ca:b0:237:9cbe:22ad with SMTP id d10-20020a17090ad3ca00b002379cbe22admr1447600pjw.5.1677605683449;
        Tue, 28 Feb 2023 09:34:43 -0800 (PST)
X-Google-Smtp-Source: AK7set9HBdfALl9hzkys09ig8qmlnSHkfeZ6cIjUfNir/WVqf5tyDK6+if2qahCLYc4pe5NO434js9PXHlT/9uuJsZs=
X-Received: by 2002:a17:90a:d3ca:b0:237:9cbe:22ad with SMTP id
 d10-20020a17090ad3ca00b002379cbe22admr1447585pjw.5.1677605683150; Tue, 28 Feb
 2023 09:34:43 -0800 (PST)
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 28 Feb 2023 09:34:42 -0800
From:   Andrea Bolognani <abologna@redhat.com>
References: <20230228150216.77912-1-cohuck@redhat.com> <20230228150216.77912-2-cohuck@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20230228150216.77912-2-cohuck@redhat.com>
Date:   Tue, 28 Feb 2023 09:34:42 -0800
Message-ID: <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 04:02:15PM +0100, Cornelia Huck wrote:
> Introduce a new cpu feature flag to control MTE support. To preserve
> backwards compatibility for tcg, MTE will continue to be enabled as
> long as tag memory has been provided.
>
> If MTE has been enabled, we need to disable migration, as we do not
> yet have a way to migrate the tags as well. Therefore, MTE will stay
> off with KVM unless requested explicitly.
>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  21 ++++++
>  hw/arm/virt.c                    |   2 +-
>  target/arm/cpu.c                 |  18 ++---
>  target/arm/cpu.h                 |   1 +
>  target/arm/cpu64.c               | 110 +++++++++++++++++++++++++++++++
>  target/arm/internals.h           |   1 +
>  target/arm/kvm.c                 |  29 ++++++++
>  target/arm/kvm64.c               |   5 ++
>  target/arm/kvm_arm.h             |  19 ++++++
>  target/arm/monitor.c             |   1 +
>  10 files changed, 194 insertions(+), 13 deletions(-)

I've given a quick look with libvirt integration in mind, and
everything seem fine.

Specifically, MTE is advertised in the output of qom-list-properties
both for max-arm-cpu and the latest virt-X.Y-machine, which means
that libvirt can easily and reliably figure out whether MTE support
is available.

> +MTE CPU Property
> +================
> +
> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> +presence of tag memory (which can be turned on for the ``virt`` machine via
> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> +proper migration support is implemented, enabling MTE will install a migration
> +blocker.

Is it okay to use -machine virt,mte=on unconditionally for both KVM
and TCG guests when MTE support is requested, or will that not work
for the former?

> +If not specified explicitly via ``on`` or ``off``, MTE will be available
> +according to the following rules:
> +
> +* When TCG is used, MTE will be available if and only if tag memory is available;
> +  i.e. it preserves the behaviour prior to the introduction of the feature.
> +
> +* When KVM is used, MTE will default to off, so that migration will not
> +  unintentionally be blocked. This might change in a future QEMU version.

If and when this changes, we should ensure that the new default
behavior doesn't affect existing machine types, otherwise we will
break guest ABI for existing VMs.

-- 
Andrea Bolognani / Red Hat / Virtualization

