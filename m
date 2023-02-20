Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D403569CA5C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 12:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjBTLzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 06:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjBTLzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 06:55:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1361A1714
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 03:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676894079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTjFVNYxtagb4cg319xliz4UCkGMGRvRsYmTyNu28k4=;
        b=VFKvk5uiQf5BTiLW+XTk/DTP0tyfZDo9ynNvSrGxE8nH/6dMXqimZvCs0pedri3uCxGnAZ
        BCXgcQtiKqLDt/UMTXBMwivvEZFozamrIxeOw428ty70s9Mdl4adXhzF+PKKdFIE3iAcCb
        0nvQKE6w69/UxWHCGd3O+tqVMil6QfY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-FZ-_8kGWO0yvV6m7BMWR_g-1; Mon, 20 Feb 2023 06:54:37 -0500
X-MC-Unique: FZ-_8kGWO0yvV6m7BMWR_g-1
Received: by mail-ed1-f72.google.com with SMTP id cy28-20020a0564021c9c00b004acc6cf6322so1639872edb.18
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 03:54:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTjFVNYxtagb4cg319xliz4UCkGMGRvRsYmTyNu28k4=;
        b=KWmwWic9ouyMKXThNIuBs4uU4elkSSDSbQrxfrD/O1oHp4W9XdHy64xNAm+fBGxogY
         tsEYsv6pyOZHPFxEJzv7CS+zEZsM73RF51/E8O1OHXR7NuI2fVhdLLdwGaFZV1KaeZkk
         SaxJ5TDBGhm6dBgs7jyfWF4qxwurFCoiiAuS7MGtXK8Fjx43smJApiX4KJ8FmDb8fiUr
         L3au1TZBRSrRVjUdjl6hWLWKodDZZixNem9TJcueL7H/Iu9y930lY9rAw5lQDpMeX9+i
         kUTuDWc+X9CPxrMy+Z2BILLBaYpQI6JdGHSmn6tsi6J92mxE/EAnQ+aT8FS2+IjFQI69
         UeKg==
X-Gm-Message-State: AO0yUKUVLnNZURANQSzTHJzcvFs0hp1XLPsRrfmeYZjTvACQEdHD9o5u
        sIiNy+pXyCGyzYa6BbFTgGrLHwQEuKVRvvgzseCU+/ARoVfiM6wqA5QoHHWWwUJoDOs7oY6lnsR
        bxpoe2Jy8CQBx
X-Received: by 2002:a17:906:f1c9:b0:877:7113:71f3 with SMTP id gx9-20020a170906f1c900b00877711371f3mr6850683ejb.25.1676894076756;
        Mon, 20 Feb 2023 03:54:36 -0800 (PST)
X-Google-Smtp-Source: AK7set+aARynCMmmEZ3mh9yR3vdePFzx+Wkn8K5DsG1GLplA256FG3LrePk1F0vxywmGZv6zPNhVlQ==
X-Received: by 2002:a17:906:f1c9:b0:877:7113:71f3 with SMTP id gx9-20020a170906f1c900b00877711371f3mr6850656ejb.25.1676894076481;
        Mon, 20 Feb 2023 03:54:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id a26-20020a170906685a00b008b1b86bf668sm4533865ejs.4.2023.02.20.03.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 03:54:35 -0800 (PST)
Message-ID: <f932e133-b5f3-6ce5-e68d-512339cc30a4@redhat.com>
Date:   Mon, 20 Feb 2023 12:54:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.3
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Akihiko Odaki <akihiko.odaki@daynix.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Gao <chao.gao@intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cornelia Huck <cohuck@redhat.com>,
        David Matlack <dmatlack@google.com>,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Eric Farman <farman@linux.ibm.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Gavin Shan <gshan@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        James Morse <james.morse@arm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Kai Huang <kai.huang@intel.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Mark Brown <broonie@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Kelley <mikelley@microsoft.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Will Deacon <will@kernel.org>, Yuan Yao <yuan.yao@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20230218142218.3816630-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230218142218.3816630-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/23 15:22, Marc Zyngier wrote:
> Paolo,
> 
> Here's the bulk of the KVM/arm64 updates for 6.3, see the tag for the
> laundry list. A couple of things to note:
> 
> - We drag two branches to avoid ugly conflicts:
> 
>    * the common KVM 'kvm-hw-enable-refactor' that you already have in
>      your tree
> 
>    * the arm64 'for-next/sme2' branch
> 
> - The whole thing has been pulled together by Oliver who has, I think,
>    done a tremendous job

Pulled, thanks Marc and Oliver!

Paolo

