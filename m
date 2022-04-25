Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE58350E1B4
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 15:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242017AbiDYNdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242013AbiDYNbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 09:31:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 195D140A33
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650893289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zia9ZkLNn3Uw1gbiJ05wW12+mUK9KGbre/JX1TEYww=;
        b=VcqWmSmKzbSBUCYVjsM1TW22nDY/k0TD1OlSSLfLBMLccu5TPw29W7AlREBKtR+ExHwL9a
        gC3H6Y+F1wnx/afqZ72oGp9llBRazdhiiruoAmLlJVWuPkZAhmCyku7p9TTN1tts5MEGUq
        02jpqKlrbZH9eaO7yyNHBIn1w+scW24=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-8d3l4E5dN4q9Rv2x2pQafA-1; Mon, 25 Apr 2022 09:28:08 -0400
X-MC-Unique: 8d3l4E5dN4q9Rv2x2pQafA-1
Received: by mail-wr1-f69.google.com with SMTP id j21-20020adfa555000000b0020adb9ac14fso805120wrb.13
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1zia9ZkLNn3Uw1gbiJ05wW12+mUK9KGbre/JX1TEYww=;
        b=v5Z2g4f9nt2gFjkvjxf+bJOSed4t6VRQVRBsMk2BN0HI86xBpFhlHVXKZh7TbGf4J+
         vfXBnePs4YA/hTHGpdR3B6lSNJRfunKBa/eE5meV5TaiyA70/hLxHaObL6C1Ibcid6wa
         8ar0KeoMZhWvi+gg8WUkWma2ff0zbLTYnBRali1SKwKi2VveYzsOITQFBsqCJ/elmbJV
         lHBnbpQoYWZWMLWbC3yp1CLvXL7A6ljSsW73JRupMRV6cjrWM9ljmeBz0JCIIB6GzOGO
         oOeqa3hn/7lXPAI6R282YiAip/Exy8T1XLqozN0ZHI1gJiEO/8sh5xO/aWc03/gG455H
         KS8w==
X-Gm-Message-State: AOAM533VK7/r+/o1UWWcsKQ9QJHpxY3/A6xUeAXHw8hrO6hWgiq8XLc5
        lwfykImP+JB8fS/Cpo00/gItwEmn4GXQdtQuI2PhTTjSqYyQmr5B6IefsStymgcN0Go7RRDRUBY
        a/ddqoCGmwGGM
X-Received: by 2002:a5d:59a5:0:b0:20a:da19:32cf with SMTP id p5-20020a5d59a5000000b0020ada1932cfmr4802854wrr.147.1650893286688;
        Mon, 25 Apr 2022 06:28:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybpiyw2AUDdzK8eie5iFirsBO1OK+mtnmEkz7wJ78OukDW7WDIUwz2HH/Vs/rM20leeO9fkQ==
X-Received: by 2002:a5d:59a5:0:b0:20a:da19:32cf with SMTP id p5-20020a5d59a5000000b0020ada1932cfmr4802842wrr.147.1650893286448;
        Mon, 25 Apr 2022 06:28:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id c3-20020a05600c148300b0038ebc8ad740sm12622635wmh.1.2022.04.25.06.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 06:28:05 -0700 (PDT)
Message-ID: <6f716388-ea25-288a-847e-c602051157b6@redhat.com>
Date:   Mon, 25 Apr 2022 15:28:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [lttng-dev] Unexport of kvm_x86_ops vs tracer modules
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        rostedt <rostedt@goodmis.org>, KVM list <kvm@vger.kernel.org>
References: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com>
 <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com>
 <1622857974.11247.1649441213797.JavaMail.zimbra@efficios.com>
 <358746537.34457.1650891622938.JavaMail.zimbra@efficios.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <358746537.34457.1650891622938.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/22 15:00, Mathieu Desnoyers wrote:
> We are at 5.18-rc4 now. Should I expect this unexport to stay in place
> for 5.18 final and go ahead with using kallsyms to find this symbol from
> lttng-modules instead ?

Yes, I don't think honestly that there's any reason to have the symbols 
in place for out-of-tree modules.  I would have hoped Steven to chime 
in, but this also does not seem to be one of the cases where using 
trace_*_enabled() is the way to go.

Paolo

