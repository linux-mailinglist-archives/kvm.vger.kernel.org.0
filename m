Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3450F6F867D
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 18:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjEEQSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 12:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjEEQSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 12:18:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF0718153
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 09:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683303432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wGr64MThf8eyQJ6hvxFtE5QioFd//XUYDgkdlAcvB8=;
        b=bK9okzWhYo3XiZFvkQUVrDSqf2NdVtstVgXB+nbOnlyJ7T3MJwyBMA93/OgWuWIFOdOZYL
        HiQx6XAaP2dk3fXrV7gxas4sQmk9NhBIkQ5DMQbJY1gDoEH1WpgH/uffpHmJzkU2YpQr64
        YFpyncihXHVLmfHWeYwVnHLqo/JW1qU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-hzRzDU1bMsOGsZqMxOasLw-1; Fri, 05 May 2023 12:17:11 -0400
X-MC-Unique: hzRzDU1bMsOGsZqMxOasLw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3313d6bcc76so12153985ab.2
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 09:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683303431; x=1685895431;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7wGr64MThf8eyQJ6hvxFtE5QioFd//XUYDgkdlAcvB8=;
        b=Y0anHeUuKF2tlfQsCz1oQ/oyQZoesSQPKOaEAVqiQLEDz1B8Js+FLSBmCEP9ap2sGi
         x6bUBXV5uP/2m2fZJxXnO1LCY3S0GY9GRvBheHJK5+VeVRSiS51WB2QqGWV+kLN5GIqM
         txNzPe8syZxNtMUTjBoCiyinYKjpwRoq3OsnC9pgfxNYXXEKy9i7DJpOQhkh/udVHMMJ
         zcxWjOpHhzLFwHjkGGcPdaMj89Rv2MkJw2+1n9ckawubDRth66pZG7X8MQXWT0zJszzW
         n+douluWPdyRexoWi6Cc0ruQOjAx4HcQmEK0PqspNld/UlFRRuqJhqmc9NY537cErdef
         01uA==
X-Gm-Message-State: AC+VfDwl8rvU7dUtbiaDjtNlZZICw6luehAqoafQzgobDGLrxm8EUE3j
        51rh6qZYHbWnKYY1xkgtmf8kFOJj5nnUpO+Xg8wwuvFfC74xCLqARgBqKF38LCHUnqxm9aIGuC1
        BbVJFLcDxerEr
X-Received: by 2002:a92:c08b:0:b0:329:5a6e:3a18 with SMTP id h11-20020a92c08b000000b003295a6e3a18mr1168461ile.4.1683303430841;
        Fri, 05 May 2023 09:17:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5P3fZICW/H7ZI6jk+krVPYZW3rGKDqjPiM4OgrXBjyIlB77r7wTQCObHECwSWiwZY3F2YOdA==
X-Received: by 2002:a92:c08b:0:b0:329:5a6e:3a18 with SMTP id h11-20020a92c08b000000b003295a6e3a18mr1168442ile.4.1683303430588;
        Fri, 05 May 2023 09:17:10 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f11-20020a6b510b000000b0076140f7918dsm30372iob.49.2023.05.05.09.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 09:17:09 -0700 (PDT)
Date:   Fri, 5 May 2023 10:17:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PTACH v2 1/6] update-linux-headers: sync-up header with Linux
 for KVM AIA support
Message-ID: <20230505101707.495251a2.alex.williamson@redhat.com>
In-Reply-To: <20230505113946.23433-2-yongxuan.wang@sifive.com>
References: <20230505113946.23433-1-yongxuan.wang@sifive.com>
        <20230505113946.23433-2-yongxuan.wang@sifive.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  5 May 2023 11:39:36 +0000
Yong-Xuan Wang <yongxuan.wang@sifive.com> wrote:

> Update the linux headers to get the latest KVM RISC-V headers with AIA support
> by the scripts/update-linux-headers.sh.
> The linux headers is comes from the riscv_aia_v1 branch available at
> https://github.com/avpatel/linux.git. It hasn't merged into the mainline kernel.

Updating linux-headers outside of code accepted to mainline gets a down
vote from me.  This sets a poor precedent and can potentially lead to
complicated compatibility issues.  Thanks,

Alex

