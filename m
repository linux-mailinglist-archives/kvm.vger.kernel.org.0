Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDF3748225
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjGEK3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjGEK3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:29:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0A41710
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 03:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688552900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FEB+aof1Pzf49zNIo1enqXQbg6MUhDXyvCon83N6zzE=;
        b=i+xcNOIoB0oXPEH9tPzcMXqt5FEfki3D1O/rRhgaNXC2vqsA8Wcd7LOEYZ9bzIiuilGwiC
        cFuVNd1TMRrW/GjoNG7LV+bx1JhDzSn+N3hBUPG0xF2S7IcjrUrNxRF0aQQL+rKG82QaZx
        XMU0J4CCCAVyrohJZUa29rpUwNflHvc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-pqugWYkIPBeT15H3MRZDhg-1; Wed, 05 Jul 2023 06:28:18 -0400
X-MC-Unique: pqugWYkIPBeT15H3MRZDhg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-63511adcf45so70371566d6.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 03:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688552898; x=1691144898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FEB+aof1Pzf49zNIo1enqXQbg6MUhDXyvCon83N6zzE=;
        b=ka1Xemt5rJ5nyeHF5ZHlSTbYf70cF5sDIzHmL3gIkxIhSt9bdOZgBhh5slK7rCZ9VX
         tkBBXx8ZojzGJqjbpxT5bsGS1dvrVUB+seSlCxvQ/MWmzU4ongj5T/yqfLYtagbZqkQq
         Gp8GotMVtmfck5B4IvF7Rw0mJRnO9GTATt1RVC+Uhtz/5F63t0+oUjOhwJirY3lxOpL+
         wdEiMlDQvVeBjJu9M7SpAxEHhCN9iJzqnZQQ+O4zadHp4ju7+jQJJ0YmM/f0Gui7509Y
         u6gIuG9kfGVv8BlhpfL1cKLMvWInC7bKZ0b5Ir0nONa51E4krwgYHDg3eC1bRsoTT89R
         0/1Q==
X-Gm-Message-State: ABy/qLY1Yn3nRQYW2FsEYbzuS6eenbazT04p1rI27kbstozuPASCgQNg
        Hw43cvG6kaxKil83dhxPKUQqNhQaNJoAP8EPP4YvOSPZyXznP/44YzElPNl1l1ufWwrqghTjxEP
        5EYAJbZ7KSR03
X-Received: by 2002:a05:6214:5296:b0:635:f23e:ef9a with SMTP id kj22-20020a056214529600b00635f23eef9amr17763003qvb.7.1688552898420;
        Wed, 05 Jul 2023 03:28:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHS/LvQu4/QXgnprYiEKj+0NdMXjNouAnzlWe4GVO4oKGSwod0uWyRnWxNAwAxfUPvuvaKoxA==
X-Received: by 2002:a05:6214:5296:b0:635:f23e:ef9a with SMTP id kj22-20020a056214529600b00635f23eef9amr17762978qvb.7.1688552898207;
        Wed, 05 Jul 2023 03:28:18 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id r15-20020a0cf80f000000b006362aac00a2sm7100753qvn.29.2023.07.05.03.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 03:28:17 -0700 (PDT)
Message-ID: <a6315330-b17c-b0fa-ed99-44ed36d47946@redhat.com>
Date:   Wed, 5 Jul 2023 12:28:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 19/20] tests/avocado: s390x cpu topology dedicated
 errors
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
 <20230630091752.67190-20-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-20-pmorel@linux.ibm.com>
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
> Let's test that QEMU refuses to setup a dedicated CPU with
> low or medium entitlement.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   tests/avocado/s390_topology.py | 48 ++++++++++++++++++++++++++++++++++
>   1 file changed, 48 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

