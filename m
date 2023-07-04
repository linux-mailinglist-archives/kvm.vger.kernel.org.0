Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C7D747239
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjGDNFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 09:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjGDNFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 09:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8071718
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 06:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688475882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HiMORpNhjWVPCDQ6FrSV7sOq+24/gJC8HAOuiDX2wFs=;
        b=JX2IvpoIIymA5B6nwBSh9hIMpOsb9lXIsKCNj6lJ7scW6cflWNFFs7jEw50e6FGnrznRrP
        Ia6xQJejwjTV5d7kS+hHjpTVZ/u2u5ftnF1ebujEL0Uu7pYCPEGcRlhwV6THhf1VVG7FuI
        4+fkgGDAXF42D8YICSoNx7aCuEj8xgY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-_mIYx--xPfyU0w8L6uZQhg-1; Tue, 04 Jul 2023 09:04:41 -0400
X-MC-Unique: _mIYx--xPfyU0w8L6uZQhg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7623a751435so472440585a.2
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 06:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688475881; x=1691067881;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiMORpNhjWVPCDQ6FrSV7sOq+24/gJC8HAOuiDX2wFs=;
        b=O82mhhmRc4slz1MOZ+Vt89XSfRjWsIc8bPwV6SAXtH4boKL0pvn4C0mvEw49CKamSk
         SIbuaxfAlStx4alCPs2mYX8/5Ts2x4TCdA9kIsh+HlsgqI8pa1KpST1+Xem4KVSc22j2
         FOx13LpD9NeTP3dnB9Qna+6L/pxpMnyOCV2PloYaB8Qgx7DI5lwd9Uy42c9xqmfYAG55
         aIPcq9dYSJ4f/FAgtr066CCP3wXYrlG/cuwkMKs/az7hsoAKN/fAOPlF0B3tjI3HJHqT
         xFi08ZmQOsHem2at8hMDm+aHDiqg2KMmEwK6joZ+OBzRBVk8ReIASP/hrG3Rt8uXv6pk
         IiPg==
X-Gm-Message-State: ABy/qLbVLJIt6DJ9MYMVkXZ9TY9RjRKOi53t3w85XskCbxXuEolmKQnM
        aiO4VywCXdlHk5Ej1yFnOlT9PHBniS98V1Bxx4hroTuKFBL8yPhxfI9UQeM5+WNVGuM8Mj+Yi8I
        o9pBabLHM+hG5
X-Received: by 2002:a05:620a:2482:b0:766:a495:63f1 with SMTP id i2-20020a05620a248200b00766a49563f1mr13504733qkn.59.1688475880903;
        Tue, 04 Jul 2023 06:04:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHFHBoOkQUk9Emv4Y19561lhidPw9OK4Iv5arBEnsDeGT+T+gXIEW0yOC/CaRpq1TIu4NMGbQ==
X-Received: by 2002:a05:620a:2482:b0:766:a495:63f1 with SMTP id i2-20020a05620a248200b00766a49563f1mr13504673qkn.59.1688475880163;
        Tue, 04 Jul 2023 06:04:40 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id c20-20020a05620a135400b00767171e4eeasm7537417qkl.2.2023.07.04.06.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 06:04:39 -0700 (PDT)
Message-ID: <579d40ea-50e4-4d84-699b-25268749b138@redhat.com>
Date:   Tue, 4 Jul 2023 15:04:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 11/20] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-12-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-12-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> When the guest asks to change the polarization this change
> is forwarded to the upper layer using QAPI.
> The upper layer is supposed to take according decisions concerning
> CPU provisioning.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine-target.json | 33 +++++++++++++++++++++++++++++++++
>   hw/s390x/cpu-topology.c  |  2 ++
>   2 files changed, 35 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

