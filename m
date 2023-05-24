Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1E870EFF0
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 09:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbjEXHxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 03:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239656AbjEXHxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 03:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20A191
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 00:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684914781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/SzYaK85eaBFe9kZW8XCykIez6pdcUrYWu5ue5PqKI=;
        b=He0fVcI8l/5jiBBNanFrpe0isghVJxYzDce6IDbKOQ719Wh5YXY2HaTziAE+iGBb2Ym8uz
        nQNlTbG9shpwBfH2dKoanjtXWaZDf+Ods2kZrMzULs6ka4+La2XN2A+A+hjdlSPjOJK66t
        ttqlNbiprXEDFxSKV/+wvyJORt50GnU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-OsNDrSsMND6Pcprxu3utlg-1; Wed, 24 May 2023 03:52:59 -0400
X-MC-Unique: OsNDrSsMND6Pcprxu3utlg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30950eecbc0so171667f8f.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 00:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684914778; x=1687506778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/SzYaK85eaBFe9kZW8XCykIez6pdcUrYWu5ue5PqKI=;
        b=jNZgZT1C7ZZBWDynvftmCuUNMzHH7UyWpfuowy3aXZDuANjrshLlrv9+SBbV/8/TQk
         hhL/vEZu5ZBrMcI7LEhNtgeWYwTrmyYjQ9bn7LdHRqO9MLoXAUDYc8nVx+7JJVz5RU9F
         h3fdmFQdqwiAVdLUz3/ne0TnzFPiliTf/Zn3Jju/XWPlVhdZCl0D2NypEcNrzpvZNVJW
         tIAFKt4jxmHmZc6DBpikw2WWhIgeh7DtNU7UslMqID1jC3u2iNpHFcZrIsaKP+G4BZxt
         KukmwFDHlhKwGb4ZNDOCpJmEztlP7B+kuQFeT8pKHWyLl/LayMlLk1IiX9ygejg8q5gb
         gwBg==
X-Gm-Message-State: AC+VfDx55hUI7xy8id/AOdezARAZ+Srxoep23pFqioJynRhf6Y/P8UvE
        iBOO3Gpibjvh7gfinW18YAtnpkTqx7R5CTvmJQyRqt8jkUYZ2KcoRoktn2nSvCx2I/nWJ7vuujy
        1zM4o/IfVEaXu
X-Received: by 2002:a5d:40c4:0:b0:306:2a1a:d265 with SMTP id b4-20020a5d40c4000000b003062a1ad265mr11134058wrq.58.1684914778610;
        Wed, 24 May 2023 00:52:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7bVbSA5tm91BTjYYNjcmpGiBhyA/kX2X5RpdEUBeWNkG4IHqN5ECI4wEf/Px8eljALlg9Seg==
X-Received: by 2002:a5d:40c4:0:b0:306:2a1a:d265 with SMTP id b4-20020a5d40c4000000b003062a1ad265mr11134046wrq.58.1684914778310;
        Wed, 24 May 2023 00:52:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id o9-20020adfeac9000000b0030647d1f34bsm13673489wrn.1.2023.05.24.00.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 00:52:57 -0700 (PDT)
Message-ID: <227ebd44-d65c-00ee-b53d-dd65d9a58b5f@redhat.com>
Date:   Wed, 24 May 2023 09:52:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] vfio/pci: Also demote hiding standard cap messages
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     oleksandr@natalenko.name
References: <20230523225250.1215911-1-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230523225250.1215911-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/23 00:52, Alex Williamson wrote:
> Apply the same logic as commit 912b625b4dcf ("vfio/pci: demote hiding
> ecap messages to debug level") for the less common case of hiding
> standard capabilities.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.

> ---
>   drivers/vfio/pci/vfio_pci_config.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 1d95fe435f0e..7e2e62ab0869 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1566,8 +1566,8 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
>   		}
>   
>   		if (!len) {
> -			pci_info(pdev, "%s: hiding cap %#x@%#x\n", __func__,
> -				 cap, pos);
> +			pci_dbg(pdev, "%s: hiding cap %#x@%#x\n", __func__,
> +				cap, pos);
>   			*prev = next;
>   			pos = next;
>   			continue;

