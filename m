Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F047F63DA25
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 17:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiK3QEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 11:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiK3QEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 11:04:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093D743861
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 08:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669824191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1WnbhyvSK/VspjjDCGInW4Drf7cIlYVZnl38f2WiWKM=;
        b=Winov/znInEbswTIENwfcVcXKBB5wGprwhz0YwDUZKdSIKM+DZmlwDI6oGSSEnFLEOrX4A
        g5UXahDhzlioy9xtL+MXaETqb2J0diJ1X/7pNS4T51FOd5+RJgr0z3fgQ2WQRhQJLUGxfD
        /ptgc0M0Ze5dhaGKsQfIIJRRNtaMca0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-zcCzqe5aN7ugkOOyHV0Etw-1; Wed, 30 Nov 2022 11:03:09 -0500
X-MC-Unique: zcCzqe5aN7ugkOOyHV0Etw-1
Received: by mail-ej1-f72.google.com with SMTP id oz34-20020a1709077da200b007adc8d68e90so8775392ejc.11
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 08:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1WnbhyvSK/VspjjDCGInW4Drf7cIlYVZnl38f2WiWKM=;
        b=yQK+eH6zTrvc9k8z4anZSDw3aM2zpv3xmC1log4CW/bQJA8GEza1qwYHLj4ZenWYMg
         uW2ov+70aSGEijb6r4T5t4xxl73f/8XiI6n3MDzTlTK31kRCqDujhd0l3N7NOOntXB+A
         ZZjXpkushO78k90cP+U5RRXFySyAx6xG8UMZm9xUyrEqmBfiyzmKpFntUkKgVJVH4hgg
         u4WN9EJYpGlYGVI8NSAUka4VcQnMLin2Yw3Uo0wrtX+tJQmjScI3GLEjMGw9F2ODWCVA
         gUVCiUle3mOt3Su76sIVlQLmFlgGVqAf4loC+1NN+SWj15Uppwf7qBonb+4Jmf9JP5NX
         iuyg==
X-Gm-Message-State: ANoB5pnQBClIwLV+7InZw8TlGcnYlu6MN4edAi4tFtJ0T945c2/tZQm8
        FmYO1bs4j+v4+OmKZvo7dJ202BctnqDCKZYNKd1vl4Bx7lBmx0jr6X8rsvQhvDjpPyD5lzysOyq
        b9oBjNXd9RwdF
X-Received: by 2002:a05:6402:2213:b0:46b:1d60:f60a with SMTP id cq19-20020a056402221300b0046b1d60f60amr14894940edb.193.1669824188292;
        Wed, 30 Nov 2022 08:03:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ypW3or9spduVIXWbRUCp5nNTGW0fv0wkGxs3VdrCJPwop/ewbP9pa9QibNOV5HzgMOeHLOw==
X-Received: by 2002:a05:6402:2213:b0:46b:1d60:f60a with SMTP id cq19-20020a056402221300b0046b1d60f60amr14894920edb.193.1669824188046;
        Wed, 30 Nov 2022 08:03:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id p8-20020a170906a00800b007ad69e9d34dsm803616ejy.54.2022.11.30.08.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 08:03:07 -0800 (PST)
Message-ID: <cd107b6c-ae02-8fa6-50e0-d6cbca7d88bc@redhat.com>
Date:   Wed, 30 Nov 2022 17:03:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 0/2] KVM: x86/xen: Runstate cleanups on top of
 kvm/queue
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paul Durrant <paul@xen.org>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
References: <20221127122210.248427-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221127122210.248427-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/27/22 13:22, David Woodhouse wrote:
> Clean the update code up a little bit by unifying the fast and slow
> paths as discussed, and make the update flag conditional to avoid
> confusing older guests that don't ask for it.
> 
> On top of kvm/queue as of today at commit da5f28e10aa7d.
> 
> (This is identical to what I sent a couple of minutes ago, except that
> this time I didn't forget to Cc the list)
> 
> 

Merged, thanks.

Paolo

