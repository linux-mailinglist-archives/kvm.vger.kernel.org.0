Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D1654B6ED
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 18:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbiFNQyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 12:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351017AbiFNQxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 12:53:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F35F326D5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 09:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655225568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejIvCfAyutrqkd8eFlaqGZsxkXobIHdQcu+odJQsnAs=;
        b=cpuQxCtMm9hGRJC3WRWVgyKrqiyzRd6P6VlMKY/hO/JZL34Wv+IGRtJFrfXmMe8KRCk8UN
        LgGaxdi5G+5rPxkc2X9HajmeAGbJcJZR/MkYdQXm86sReNPiBCrJoRSo+TVqYc4lfYvVVP
        ZvWgQHv+KIXT6gnoLZIVGuARxFe7+tU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-iL2ugXHMNWWHoo5Py1IDyQ-1; Tue, 14 Jun 2022 12:52:46 -0400
X-MC-Unique: iL2ugXHMNWWHoo5Py1IDyQ-1
Received: by mail-wm1-f69.google.com with SMTP id p6-20020a05600c358600b0039c873184b9so4608747wmq.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 09:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=ejIvCfAyutrqkd8eFlaqGZsxkXobIHdQcu+odJQsnAs=;
        b=uEsJ1qLKzJcRorXEJzBNUjqNlfHO7ZMq3I5L2id7VuWIpiFr89rt1euvmY35J/WQPH
         WKihujc0tKqA3J3KKi7Ws6/bKviMJR+29i6F9n6VsW2slipMlzC9y60w9JdZY4V7xXXX
         hM6ZvBZ9AlRsBBcJGdeakme03erfn66C0igJl2LlN2NmwmtdynpSn3Xal2hrd0I4OMwk
         1Q9HVXWlYeFZs4XyMR/0Q5MOcMyckemXjzNH8IvTqJvJWvR70a8qqxC5DcADWbK490sz
         ZHHkF+zIFZWzQIhqEnAhOuiX7HQgxUKkpp7YgtQf2kQZCHFh11YL2DOBmNXA4tJ0peIW
         zimQ==
X-Gm-Message-State: AOAM5326QCKmJx0hB0Te4/6SiRBsyiOpV4w6b03SMWbg4PGh/E4mtd5Z
        yHNZWtHii9E9/xpILzty9kVc8OsKvcTbUbH6ruXF2rdk4s6gLtZEwOHVndjfeQQJYiNHKyPd4OS
        ialS0brYp4UML
X-Received: by 2002:a05:600c:2307:b0:39c:6ce3:2a06 with SMTP id 7-20020a05600c230700b0039c6ce32a06mr5166112wmo.113.1655225565159;
        Tue, 14 Jun 2022 09:52:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5BunCVsosucWoavBDPY6lzWcSo1OiPr/mn9lfLPq4bBSKJwytnaiIeTx4+dHmxx6DFSJVrQ==
X-Received: by 2002:a05:600c:2307:b0:39c:6ce3:2a06 with SMTP id 7-20020a05600c230700b0039c6ce32a06mr5166096wmo.113.1655225564904;
        Tue, 14 Jun 2022 09:52:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i9-20020adfb649000000b0020fe35aec4bsm11994850wre.70.2022.06.14.09.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:52:44 -0700 (PDT)
Message-ID: <0265ad15-32c8-5932-9966-e4727577dd57@redhat.com>
Date:   Tue, 14 Jun 2022 18:52:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <202206132237.17DFkdFl-lkp@intel.com>
 <7a5d48d0-d1b5-91aa-8966-54d9ac986126@redhat.com>
 <Yqii3+EN1SnQYnMJ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 5/184] arch/x86/kvm/svm/avic.c:913:6: warning: shift
 count >= width of type
In-Reply-To: <Yqii3+EN1SnQYnMJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/14/22 17:01, Sean Christopherson wrote:
>> Ouch, saw this right after sending a pull request.:(
> KVM_WERROR=y is your friend.  Or in my case, my enemy for the last few days:-D
> 

I have it of course, but this one didn't reproduce on 64-bit systems as 
far as I can see.

Paolo

