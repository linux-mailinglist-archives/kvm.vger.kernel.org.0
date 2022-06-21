Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EE555288E
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 02:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239725AbiFUAQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 20:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiFUAQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 20:16:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCCF019F90
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 17:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655770558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=am4ljrsE7Ufjfmqsop2MzHsqSlEXrA5rSRIM1yT2FYE=;
        b=P5dRtsSKvV3QKbbOdEXRRj7ZY4MqanQrTt19Kdz7fCwkp/Xfa2FZdSX39CLp3blWQkHW3d
        7KY+FW18aC6fDGOA32qw5O1iep3JWnx0YZ8wdS3Fj4/vAqkTRsJNnuDPKMPmw7aI/Gq+Gt
        V2CVktJp25Zw/rUIIP/SJX0H/dqG4lM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-fwVbYFEiPpKY-GFoExwVKg-1; Mon, 20 Jun 2022 20:15:57 -0400
X-MC-Unique: fwVbYFEiPpKY-GFoExwVKg-1
Received: by mail-wr1-f70.google.com with SMTP id n5-20020adf8b05000000b00219ece7272bso2794302wra.8
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 17:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=am4ljrsE7Ufjfmqsop2MzHsqSlEXrA5rSRIM1yT2FYE=;
        b=AtVBeC7vMiA1EBJ76gKgAZU8/BxqIr5FOdxjvdLiMB/URYkK9spT2MzhQ5T3JB56tI
         p1w8mwqkUSC2wxZGw+jsVezoWSZTQGo2Akqb7mS+KleL47K09mQLbD1rUWcwm9Tj92fK
         Q8T6KyTF9KiF8u0ptHW90MHEQCWaLjkn608VdO7Llh/CC2a/YzMsldiStDJsGHRqZ+Mw
         xpwkl8MBsUO0s2S7U0m8PPnu54lSe6Gf7cwcCDAMEymG5qv/ASFqmssae1mQNOuMwDwx
         RDwVHMwN1Gd2NAQ/spBylzMK6sK0oIDRoYcuQJVgY4N2Der+F5wLsvsgciJII+ElUBak
         VJPw==
X-Gm-Message-State: AOAM533avaVQE2FFPg+JzIwOVt4VOAgXybcKrUylfx/ORGaqUGjgNoco
        VmgtzUOJCTiPYlJ2QzAwf9oWISMo7cLMDKjEWcxQZ9ujYs6FfSBd2rLLZgkilf30ZdmW5zQJgES
        m05/kx8DVbLnb
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr37343015wms.3.1655770556333;
        Mon, 20 Jun 2022 17:15:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuF9L1be7ni3J1YmYNIb9c4ZabGtFSUgGjCv0tSabp2R2QRhWX6wNq50I5/oKWe6fZHu9qDw==
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr37343003wms.3.1655770556103;
        Mon, 20 Jun 2022 17:15:56 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id e13-20020adfe7cd000000b0021b89181863sm7340790wrn.41.2022.06.20.17.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 17:15:55 -0700 (PDT)
Message-ID: <e6306933-45c4-f38a-bae1-3ad149d67e1b@redhat.com>
Date:   Tue, 21 Jun 2022 02:15:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 2/2] vfio/pci: Remove console drivers
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, corbet@lwn.net,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        deller@gmx.de, gregkh@linuxfoundation.org
Cc:     linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Gerd Hoffmann <kraxel@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>
References: <165541020563.1955826.16350888595945658159.stgit@omen>
 <165541193265.1955826.8778757616438743090.stgit@omen>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <165541193265.1955826.8778757616438743090.stgit@omen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alex,

On 6/16/22 22:38, Alex Williamson wrote:
> Console drivers can create conflicts with PCI resources resulting in
> userspace getting mmap failures to memory BARs.  This is especially
> evident when trying to re-use the system primary console for userspace
> drivers.  Use the aperture helpers to remove these conflicts.
> 
> Reported-by: Laszlo Ersek <lersek@redhat.com>
> Suggested-by: Gerd Hoffmann <kraxel@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Patch looks good to me. 

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

