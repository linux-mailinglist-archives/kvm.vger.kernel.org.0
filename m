Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F91A66CE23
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 18:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjAPR7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 12:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbjAPR6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 12:58:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0AF4903B
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673890675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AM3cLoP8TWPmrgmRZcDwyPuhd6tlFOUEOcdOzvKctl4=;
        b=Xh1YQb7OsmRKfzgQTDrGERbDM/FqdLFdpNcDrApOYk6B4EnnlLNyb1lMTCV8yiJ1F+OGR0
        EsRqbvwScrTs18weG+uvkqSvZUFmdX1syezR1nt+b7NENp8k1LoI5/nAiRVNRHzar9l4sw
        CwOgIGgft3oNaZiWWda0FJspVML+Hm8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-673-V4-dtufWMwyy4kmN7HO6HA-1; Mon, 16 Jan 2023 12:37:54 -0500
X-MC-Unique: V4-dtufWMwyy4kmN7HO6HA-1
Received: by mail-ej1-f69.google.com with SMTP id wz4-20020a170906fe4400b0084c7e7eb6d0so20105623ejb.19
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:37:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AM3cLoP8TWPmrgmRZcDwyPuhd6tlFOUEOcdOzvKctl4=;
        b=QMrii86PQsYbugkI3c3JhRBb03S6ou2uTGJLfbN7Cg0T/wXf2+jsc4nNZl95DUk2qu
         zbTQi7BAKFed+6j4doAO2DJsy63KnkQLGPzhBS5cOc/zlg5mOAcBYtAk2mncE1WUd4s5
         d21+DVWdmCBQwQt23NPUybf3USqdvL1eC65oS1kbZBpp7fIP/LEvKMHWhHOrwpyHdH5p
         CNKeWvx1kv2VuQAfU1ffeUYRByDAr1hUdqGdD0wbmiw+JDLWQTPU7wASJqRlgsqJaK0v
         REVSQ8Mqrj/rsFn5AJA9et5iyLWvRxCRrh8OmmpG0jcSaJ/mF7b89QxG3ROGBXwWLtxA
         CAUw==
X-Gm-Message-State: AFqh2koEsPWUDW1yqI4VkBxSz6bYo/dDdAUM/MprcM8Kvv6EprDka2rG
        4KtuqJ/VbcLGPbQLYLJeqlzmdlXP/XNI8Dp0bqt6N27GXntZnMwrOXjyMQ229wvWR8SIL3W94Ys
        NfOzqXaZWZidF
X-Received: by 2002:a17:907:c11:b0:844:79b1:ab36 with SMTP id ga17-20020a1709070c1100b0084479b1ab36mr18134622ejc.25.1673890673107;
        Mon, 16 Jan 2023 09:37:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvxAktoVxqLbdOoIJzCFzA1FFlFx58XcCCbvaWacxz4nXnLR6H0c+d24xfdoV/jYoPocchgDQ==
X-Received: by 2002:a17:907:c11:b0:844:79b1:ab36 with SMTP id ga17-20020a1709070c1100b0084479b1ab36mr18134606ejc.25.1673890672894;
        Mon, 16 Jan 2023 09:37:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g17-20020a17090670d100b007bb86679a32sm12121592ejk.217.2023.01.16.09.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 09:37:52 -0800 (PST)
Message-ID: <c08f1e98-03fe-1996-bc2c-43d90ec78613@redhat.com>
Date:   Mon, 16 Jan 2023 18:37:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] Documentation: kvm: fix SRCU locking order docs
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Peter Zijlstra <peterz@infradead.org>
References: <20230111183031.2449668-1-pbonzini@redhat.com>
 <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
 <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y8EF24o932lcshKs@boqun-archlinux>
 <d1d44f07-558c-e0ed-403e-61a854c868cb@redhat.com>
 <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/23 11:33, David Woodhouse wrote:
>> It's missing an important testcase; if it passes (does not warn), then
>> it should work:
>
> I think it does.

What I'm worried about is a false positive, not a false negative, so I'm 
afraid your test may not cover this.  I replied in the thread with 
Boqun's patches.

Paolo

