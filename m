Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D6369D34E
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjBTSww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbjBTSwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:52:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC90721976
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 10:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676919016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oNEQIMEKzUu2uav8P64r69zff0c8FcvklSUxsToQk9c=;
        b=R7XSXN0XXh0DRwM/nAH9q3RKr6g4vAAswPqM2iG5HNwY8N0sK0tFTJqMGKcHLaAQz75OrO
        wCLorVR/NImiAc+bVOelVYRscu7T1luJNHWmmumtBdB7evENcLZu4CvIY4R8RzUwMNles6
        4MUn+idddbJ3XBdnRxF9wtpI7An8o0I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-p6f-UkwqNK-PyHVgnfFeeQ-1; Mon, 20 Feb 2023 13:50:13 -0500
X-MC-Unique: p6f-UkwqNK-PyHVgnfFeeQ-1
Received: by mail-ed1-f70.google.com with SMTP id da15-20020a056402176f00b004ace822b750so2823724edb.20
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 10:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oNEQIMEKzUu2uav8P64r69zff0c8FcvklSUxsToQk9c=;
        b=hSSv9U8t2EAm54kUTHG1R95on5BG+SaB4fz/DM3fdrTrP6mumBIYPKWwMoDxHcMq61
         mKET75AO/i5sRqg/gfUrXx1olHRx87bYKsQGjcZ1jhl32xkOE0b7JIUwvPXYrBHjhY2q
         kAkvYK6y8M0kJLmJOFWfnl93517Ei+ckXPkfUVE309bio/9i3/lFnrxzLkm0GMaYgZ/b
         CThLfbOzo3qeV55zf8xt65TC7XWrePKPw2JCs8sSvFIz+16jq4WoRu85JOpvcMqiWwSE
         zo79bEVBn7IbPlfNZgm6Cx4q6KHxac3Vt2WtqZatzL2zA8DtpZEPWZPOIZf6i1GNGoS1
         vzeg==
X-Gm-Message-State: AO0yUKVnwelTr1FUMOV8LOP22S5QTSZKUhUimE2cjJHGr7vrQ3DR8zsC
        H+tLqCoxvb14oSJBg2EwWOmH+rAahYhLbSPFV5hh5M8+2R7nsCS2ekUFgdEZcyxIXKFkcig0Oa3
        1NqXy7bMbZGyJ
X-Received: by 2002:a17:906:2413:b0:86c:a3ed:1442 with SMTP id z19-20020a170906241300b0086ca3ed1442mr8756816eja.4.1676919011915;
        Mon, 20 Feb 2023 10:50:11 -0800 (PST)
X-Google-Smtp-Source: AK7set/xFOW7y3n8LAi7Lq4oM1pBvG3AfNA2jHHJRrTVLW3aX4k0F1SjGK9u/iFMGDvuf2vLJ5sZqg==
X-Received: by 2002:a17:906:2413:b0:86c:a3ed:1442 with SMTP id z19-20020a170906241300b0086ca3ed1442mr8756797eja.4.1676919011664;
        Mon, 20 Feb 2023 10:50:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id fq30-20020a1709069d9e00b008ce5b426d77sm2194511ejc.13.2023.02.20.10.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 10:50:11 -0800 (PST)
Message-ID: <918d0522-56ac-49c3-6604-f44a58ddc645@redhat.com>
Date:   Mon, 20 Feb 2023 19:50:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 13/29] LoongArch: KVM: Implement misc vcpu related
 interfaces
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-14-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230220065735.1282809-14-zhaotianrui@loongson.cn>
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

On 2/20/23 07:57, Tianrui Zhao wrote:
> +
> +int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
> +				  struct kvm_translation *tr)
> +{
> +	return 0;
> +}
> +

Please return -EINVAL instead.

Paolo

