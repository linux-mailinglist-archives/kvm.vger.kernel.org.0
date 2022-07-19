Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98957A1F9
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbiGSOks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238487AbiGSOkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:40:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16C65C65
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658241377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11/azShuEZEI/EuIbU0yMWZXSljz9pWC8gA2m1rJI0w=;
        b=gGEqYmN16YrBGCiXomEUJ5Pu+jPkyiy6UNKuijzpXB8VjQRLA6OzTCJy5JBkfco+/KA6yU
        Foizn1KJIdZc/zd4+1fY39kujpn4PHSLbzXEASzok9/kC1EI4vAfSWsdb0ilIK4U5qbSna
        w4akp3oSbVctZqnGwYt2M/2lkRRAWd0=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-PkY2JvTHN8K8hlVgRg6AsQ-1; Tue, 19 Jul 2022 10:36:13 -0400
X-MC-Unique: PkY2JvTHN8K8hlVgRg6AsQ-1
Received: by mail-il1-f199.google.com with SMTP id j17-20020a056e02219100b002dc4e721203so9624028ila.22
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=11/azShuEZEI/EuIbU0yMWZXSljz9pWC8gA2m1rJI0w=;
        b=tCD3+YafjW4u/SiocTfsx8XeMckVW/yvbHwX/Fr6WVuRusl4XdoDDm9MufT9h1dJoB
         Bd6QK/NJapMQ+sRI1xeYjzYo++TrAHSZgQhnY/PxC+Pm+ft6kvtQmar8vYY7jzR0cK0G
         5TCO38XFBP3D+l6j31KtQDSL9O/wYv0WOMIozoQ0y9Qpg3ldwVAPI6WztOSnXDiNAuNp
         SR93obuGnCuZDf8yq7Rs/isTsQPqx6GiVnJxkMvIyYmOAkGuNfDfzctL6OjNId7nWmGL
         z9EpmYZ/TmxNymF14iAA92q781NuVMwXUCXPqbALeO+dXqyB7YSg7lkph6xqeQVmi/4a
         eynw==
X-Gm-Message-State: AJIora9AsLyaujBPhtd6ZuFbUdr+L8ebxs93fp3rQSryR/mX7pZ2V0MZ
        DDvJagKdtQqoMtwfRvSYTZd4wxIj240RMcJ4oN+O0L0RY9qMCW+VtWyaZ941TLBCwekq9Zz1wX+
        LOUva6egMjwfh
X-Received: by 2002:a05:6638:4513:b0:33f:680f:255 with SMTP id bs19-20020a056638451300b0033f680f0255mr17649202jab.232.1658241372288;
        Tue, 19 Jul 2022 07:36:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t10PPJ52rhwdzNoO0SKwZpL6nc+guMrZC0FGbTn7gnlFgZNfgV4R+nyq8qfgJNj5SU6XRSJA==
X-Received: by 2002:a05:6638:4513:b0:33f:680f:255 with SMTP id bs19-20020a056638451300b0033f680f0255mr17649189jab.232.1658241371987;
        Tue, 19 Jul 2022 07:36:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f5-20020a056638112500b0033f3ab94271sm6868471jar.139.2022.07.19.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:36:11 -0700 (PDT)
Date:   Tue, 19 Jul 2022 08:36:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "=?UTF-8?B?6ZmI6IO9?=" <chenneng@tsingmicro.com>
Cc:     "cohuck" <cohuck@redhat.com>, "kvm" <kvm@vger.kernel.org>,
        "Owen.Yan" <owen.yan@tsingmicro.com>,
        "=?UTF-8?B?56iL5paH?=" <chengwen@tsingmicro.com>,
        "Terry" <terry@tsingmicro.com>
Subject: Re: Clarify the functions of each version of VFIO
Message-ID: <20220719083610.6e009286.alex.williamson@redhat.com>
In-Reply-To: <tencent_64D724EC138B1F2238BD5AB4@qq.com>
References: <tencent_64D724EC138B1F2238BD5AB4@qq.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jul 2022 15:45:17 +0800
"=E9=99=88=E8=83=BD" <chenneng@tsingmicro.com> wrote:

> Hi Maintainers,
> &nbsp; &nbsp;&nbsp;We try to develop a user space driver based on
> VFIO, but we don't know the version of the kernel on host machine.
> Maybe it's a latest kernel(5.x) or an older kernel(3.x). However the
> kernel supports VFIO from version 3.6.And VFIO of the 5.10 kernel
> version has about 1000 lines of code more than VFIO of the 3.6 kernel
> version.we don't know the functional difference between VFIO of each
> version. For example, a driver based on the latest VFIO, can I run it
> on the older VFIO? Besides,&nbsp;Can you help provide the function
> list/release note of each version of VFIO? Thanks a lot.

You can certainly look at the commit log of the documented uAPI:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/incl=
ude/uapi/linux/vfio.h

In general the uAPI is backwards compatible, there's essentially a base
set of features along with capabilities and extensions that can be
discovered.  You can look at other userspace drivers like QEMU or DPDK
which also don't specifically rely on knowing the underlying kernel
version, they make use of features and capabilities as they're
available.  Thanks,

Alex

