Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292096F7F1E
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 10:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjEEIbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 04:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjEEIbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 04:31:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239A614939
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 01:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683275363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdGQ5Iff4ofU4lB9I6Mk/AZfuvu30ar3dTp7kzkc4Ho=;
        b=L2kOuTwf1GchblZUorjH3afkuWOknK6Gw3QyipIH4dOlpJeJymMON6Yb5uP4DnRSyHWgbc
        z4WuiBhZrGxsKXsEOjkJQDV5w9fd+kF2nKBKZDKFB27T4qZ9+A4xO9T9PVWFetBlM9lAdI
        c7pgZ7cyMJgkeOa0Yzl8cNPg4RywCwo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-WZmb7Wa-O8-tJa0Yjro3lg-1; Fri, 05 May 2023 04:29:22 -0400
X-MC-Unique: WZmb7Wa-O8-tJa0Yjro3lg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-50bc95a5051so1662218a12.1
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 01:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683275361; x=1685867361;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LdGQ5Iff4ofU4lB9I6Mk/AZfuvu30ar3dTp7kzkc4Ho=;
        b=Qtbv9htIBIzCgzBoE4v/REXnsVnD1ikQqPpmzW82gtVTrQr4kce8R4OHWudGDp5l6T
         yVx6EZRyGubIJEQtIebTprCQ0JQoUV5sBY9GCevIjRCKxfiqfTCoGJX2ENpZCxvq7WQa
         9PC+LOic/TWbLmseTZhIZosWzx4V0a5a7aOyTfUrC+6LQa6Zq5OGBWs7PHcX31xYT1Hl
         WZZxwpfyULDr8b8Y+RQml2s1MULK8YypbwmBj6jlVr2ruaJE0EIWyiDu7PQ4HHJyXo41
         /duMWxCo7tPcMdBng+V0qTFJO1kBogjfQtcQ9oEK388HjNC4BFjSR62o2IzGCIiKMSLe
         gMhw==
X-Gm-Message-State: AC+VfDy6lvhxn1KpZSEM//C2xCGH74lrWJYDUWZt8UphiQtKVuRZFr0s
        fMpxtZKp5yfqHw5SgRzt7SuIR9W4BQEyD0oCxva32tQ66H48dwx20MSvSsS2rb0MKC9Cb1BAHbh
        N2vAgDQLGSg/V
X-Received: by 2002:a17:906:ee84:b0:94a:549c:4731 with SMTP id wt4-20020a170906ee8400b0094a549c4731mr420877ejb.57.1683275361396;
        Fri, 05 May 2023 01:29:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5U+UCVItL90FHF+zyfg8PN1bCH3TUFIlIH9StNOC6NT9eBmlQEUHqwEbrzfLrxbt8GDpe2Pg==
X-Received: by 2002:a17:906:ee84:b0:94a:549c:4731 with SMTP id wt4-20020a170906ee8400b0094a549c4731mr420858ejb.57.1683275361113;
        Fri, 05 May 2023 01:29:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ig2-20020a1709072e0200b00959b810efcbsm647109ejc.36.2023.05.05.01.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 01:29:20 -0700 (PDT)
Message-ID: <4ac6c060-8655-c5df-e27b-3dfb520ad388@redhat.com>
Date:   Fri, 5 May 2023 10:29:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Babu Moger <babu.moger@amd.com>, richard.henderson@linaro.org
Cc:     weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
        paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com, berrange@redhat.com, bdas@redhat.com
References: <20230504205313.225073-1-babu.moger@amd.com>
 <20230504205313.225073-5-babu.moger@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 4/7] target/i386: Add feature bits for
 CPUID_Fn80000021_EAX
In-Reply-To: <20230504205313.225073-5-babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/23 22:53, Babu Moger wrote:
> Add the following feature bits.
> no-nested-data-bp	  : Processor ignores nested data breakpoints.

This bit is useless, unfortunately.  Another similar bit include the one 
about availability of FCS/FDS in the x87 save state.

They say that something is _not_ available, so a strict interpretation 
would prevent migrating from any old processor to Genoa, because in 
theory you never know if guests are using nested data breakpoints.

In practice, this does not really matter because no one used 
them---that's why AMD could get away with removing them---but please 
tell the architects that while they're free to deprecate and remove old 
features, adding CPUID is basically pointless.

Paolo

