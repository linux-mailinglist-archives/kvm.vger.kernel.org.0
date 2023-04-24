Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67E76ED1D6
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjDXP4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 11:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDXP4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 11:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2604C2E
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682351759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSLSHCD7SAxmK5owuDwfhYyigkunahbHGav4UZb91bY=;
        b=Db9J8Y+UYbLihOPDRu86LDzsQjX2psq9rEbjEwZwr+vUaLAUIacnYNAkOfnmMV2nb0Codf
        43Mn1N6I3Yl0qdJWsgBfPhgNtVm45SrZShhippfawRRyZrcq697jFEXncqO+U25DUUuPK8
        zvecAqWKmAAQbi3LFzRA2i+lDi+Lk94=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-nq3ThAOrMr2m9N_PHkaxnw-1; Mon, 24 Apr 2023 11:55:49 -0400
X-MC-Unique: nq3ThAOrMr2m9N_PHkaxnw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2fa5d643cd8so1348580f8f.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682351748; x=1684943748;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSLSHCD7SAxmK5owuDwfhYyigkunahbHGav4UZb91bY=;
        b=T9/e+Qe6N2OJ616Wm/ZLfbisGRPIKCWrqw+ZpAACV+nvXLv9zFozKl/bs8Fgxx5KN0
         4w++KiGb1CnHsicvlWKVvEvceEWkQu0/PyoGufOGFr8yN9T8j+HuFvgFX8E+G5DAs+Ov
         KlGtCriehYmcmhsXl1hw/in1Rcd9OtoVuBQTYb5/jj/cF4CDmg+ELQ34xRYw6VXn8ezD
         rP+xfefjXTEoWWXvohdSkyJyJnOMSgM6TJ32zVDHWg6q7y+fq0OrJSnvUoKasuUsyLuE
         LT92Z+9xWFJE0j4RRwZswLi2+NiLjfM+XEl5yskExB0as5Sh7mU/emZaaML37IEgo/1t
         DsBQ==
X-Gm-Message-State: AAQBX9dX8BDv0aYBeboQriaZG6K2vhzRB7KVDn216pMdlJDtFRabD66a
        0mRePNQ9enY3NMqU51DC0+/CYFkZZP26Z3ywiAx6lrWO72beDb7t8Juwi2j0xjsqkLbedmvDvI8
        8nplMkVS0aG08
X-Received: by 2002:a5d:54c6:0:b0:2f7:f803:ebeb with SMTP id x6-20020a5d54c6000000b002f7f803ebebmr10334553wrv.52.1682351748575;
        Mon, 24 Apr 2023 08:55:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350avfcfrl6ufw+2a5Hff0ttxQl1WDs3k+JxP4zVFIseU6kPapwXjKg2V5q4Z5yikr20KaDXRhA==
X-Received: by 2002:a5d:54c6:0:b0:2f7:f803:ebeb with SMTP id x6-20020a5d54c6000000b002f7f803ebebmr10334531wrv.52.1682351748317;
        Mon, 24 Apr 2023 08:55:48 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-102.web.vodafone.de. [109.43.178.102])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d500e000000b002cff0e213ddsm10995201wrt.14.2023.04.24.08.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 08:55:47 -0700 (PDT)
Message-ID: <fa91e8cf-2240-ac81-740b-b9d8597f4f59@redhat.com>
Date:   Mon, 24 Apr 2023 17:55:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/6] update-linux-headers: sync-up header with Linux for
 KVM AIA support
Content-Language: en-US
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230424090716.15674-1-yongxuan.wang@sifive.com>
 <20230424090716.15674-2-yongxuan.wang@sifive.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230424090716.15674-2-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/2023 11.07, Yong-Xuan Wang wrote:
> Sync-up Linux header to get latest KVM RISC-V headers having AIA support.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Jim Shu <jim.shu@sifive.com>
> ---
>   linux-headers/linux/kvm.h |  2 ++
>   target/riscv/kvm_riscv.h  | 33 +++++++++++++++++++++++++++++++++

  Hi!

Please don't mix updates to linux-headers/ with updates to other files. 
linux-headers/ should only by updated via the 
scripts/update-linux-headers.sh script, and then the whole update should be 
included in the patch, not only selected files.

Thanks,
   Thomas

