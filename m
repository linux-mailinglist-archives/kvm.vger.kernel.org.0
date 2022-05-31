Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC625395E8
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 20:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346839AbiEaSLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 14:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238714AbiEaSLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 14:11:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 200561E4
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654020697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMQEK/kjTo0pUfkHM6FfBJm4lgYJdNQsWtCnnztaaGk=;
        b=BNS63wpLlparUVduVTLujt35aVtR9gOce2QU0DXrz3CezDeXSEIUlI0mHCrcQjIJCmh2nW
        BoyRyrqY8LXX6OvJvyfK93/9zOLIm/qZJlD/ZMjC5bSvh3uxOI2FFkBdXKZmlE4L32Thn+
        Oo+TOJ0UOGv2WJrN79rOt0tPfmZ5qFM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-ciU5NXLuPgq4ZZQOd_NTfw-1; Tue, 31 May 2022 14:11:36 -0400
X-MC-Unique: ciU5NXLuPgq4ZZQOd_NTfw-1
Received: by mail-ed1-f70.google.com with SMTP id q29-20020a056402249d00b0042d90fd98deso7520586eda.12
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=XMQEK/kjTo0pUfkHM6FfBJm4lgYJdNQsWtCnnztaaGk=;
        b=8Og5GTARuder4Y+mZIK7QRlbYTHOc6BiIxbp0qwyfIf1jPBY6ck/SPbdH3XAmrU6kl
         N50exXsZWdjyQdVywuDHRS8bMwAWjgdalLFPFD3ZzVUHUJR5GjKGaSwqgxMHlvAR+VbB
         K6KXvtKDZIJRQs2ZQAG0MMDPe4jaHuKA75w4/9WXfAt/bLaPZ9P/Hb/mF6C52EBFR37D
         ZE4/JUCOCZkNMNBKbzhwB40ne1cdGGo6xeNERf5NlMCjy7DUmgYOJ7QErDj+DHCQQ2xX
         AHiGdPTO4ghLIbcBaErbuavmtRj8LAutclHT0VTHi08FzwhSptBcLSRl/a4DrAxAgieE
         9VWw==
X-Gm-Message-State: AOAM530rzu5c9fGx09whCZ9UUXPTePhV9Yy2djcOHqY7lHxqgq8A2YHA
        mEHzZ/atFqjfKLFr4O/bgSDeEaVdQvsbrW6HzqGdwThJcqFMCbAnKVECscgRwk6f9AefIddd0st
        fis35quF4zyXx
X-Received: by 2002:a17:906:6a0d:b0:6ff:15a8:acbf with SMTP id qw13-20020a1709066a0d00b006ff15a8acbfmr27459131ejc.143.1654020695318;
        Tue, 31 May 2022 11:11:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1ff2p+ikBQ55Lof6tEFQQIwQKvq0MZaz2IlORv4sb3mJO9fUCPL0TZ2jkvbnDaJnhq6pOwA==
X-Received: by 2002:a17:906:6a0d:b0:6ff:15a8:acbf with SMTP id qw13-20020a1709066a0d00b006ff15a8acbfmr27459105ejc.143.1654020695066;
        Tue, 31 May 2022 11:11:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z5-20020a1709060ac500b00702d8b37a03sm740362ejf.17.2022.05.31.11.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 11:11:34 -0700 (PDT)
Message-ID: <0194b22a-38a1-08a1-a576-de6463389ce4@redhat.com>
Date:   Tue, 31 May 2022 20:11:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Metin Kaya <metikaya@amazon.co.uk>, jalliste@amazon.com
Cc:     bp@alien8.de, diapop@amazon.co.uk, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <20220531105925.27676-1-jalliste@amazon.com>
 <20220531114333.29153-1-metikaya@amazon.co.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: CPU frequency scaling for intel x86_64 KVM
 guests
In-Reply-To: <20220531114333.29153-1-metikaya@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/22 13:43, Metin Kaya wrote:
> Thanks, Jack.
> 
> Reviewed-by: Metin Kaya <metikaya@amazon.co.uk>
> 

Please try a bit harder.  "Reviewed-by" is neither "this matches what's 
been forever in the Amazon kernel" nor "I guarantee that Jack is a nice 
guy and doesn't screw up".  I'm sure he is but everybody screws up, and 
in this case the patch:

- does not even *apply* to the upstream kernel, because it uses 
(presumably Amazon-specific) CAP numbers above 10000

- does not work if the vCPU is moved from one physical CPU to another

- does not work if the intel_pstate driver writes to MSR_HWP_REQUEST

- does not include documentation for the new capability

- does not include a selftest

- is unacceptable anyway because, as mentioned in the cover letter, it 
isn't undone when the process exits

Jack, please understand that I am not really blaming you in any way, and 
ask some of your colleagues with upstream kernel experience (Alex Graf, 
David Woodhouse, Filippo Sironi, Jan Schoenherr, Amit Shah are the ones 
I know) which patches could be good targets for including upstream.

Paolo

