Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF9168DDC9
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 17:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjBGQSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 11:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjBGQSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 11:18:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016902917C
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 08:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675786672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MxEyheqQ0T75cQT5Y5z2FlZtN8LLkRY3F7PTyntFWDA=;
        b=ZQQNnQ0efrs364gUouyKzbomWZE0k6B7raTJ/0DsVY17WPQ9QVp0NFq/rFRkdUXwwifaXL
        H9EzYgWtBlc8x8hoG2Ht/RivvQkxp8BdkiickwYjXZjN8Band6WI6RRdoP0JruO+0rAVmr
        m0sL2qEXMEDn3lIQux1odjyulB+hDQY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-wStrpgLdMUuJ-eZAvwGTGQ-1; Tue, 07 Feb 2023 11:17:50 -0500
X-MC-Unique: wStrpgLdMUuJ-eZAvwGTGQ-1
Received: by mail-ed1-f69.google.com with SMTP id p36-20020a056402502400b004aab6614de9so3864299eda.6
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 08:17:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MxEyheqQ0T75cQT5Y5z2FlZtN8LLkRY3F7PTyntFWDA=;
        b=AIq1gbmiRlSRjhgb9JwvZkeqTn9s2fdmVjQABQxpabu46fHVlliy07JbFCelu2MzKF
         64D14gX8FPnDRrNbOYsNCytSO/Iz6ZxMVzZMFjpMXur1tFwpBGCkDcW5hitvQa7PW3ye
         rZBUrSzZLQN3bfDISICDW3/9QgZyr8nnHUbfrJ/95YsSyjPh2oput0Kk55OQMPdUeP/r
         +KyOqJj6ZoCpFme88F9vVonhkMXe5ebRH5R0wXAUqnQWVTEQUUCrn3CCixIQtpJnsWYj
         LpoJLvQ6cWZOXvjUw+orKJnIz8/pQZpEMS0kkwsHsVvh9PQye2AkKo3ZdKvq35ao0BgI
         5D6A==
X-Gm-Message-State: AO0yUKXBE8KOXWWsUMt3kLGt+5M72QK8VzvvG7hpo/zw21MSQ7fqNfVA
        KzhQh96Hko6zWZyft2GH6xBB6oEuBP+LkYh2BO/dcA+8Qje5Hc4FxCjNC1C4a1DXul8a5wo5vyz
        ED0CF4gW754nj
X-Received: by 2002:a17:906:4f83:b0:87a:542e:53b4 with SMTP id o3-20020a1709064f8300b0087a542e53b4mr4002368eju.64.1675786668676;
        Tue, 07 Feb 2023 08:17:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/RHDuqsAOeSb7INMvO7YdalIamEO653PI2leW4ESVfWsZSmriBaqw5+CfV8SJ0xuHRX+ObgQ==
X-Received: by 2002:a17:906:4f83:b0:87a:542e:53b4 with SMTP id o3-20020a1709064f8300b0087a542e53b4mr4002343eju.64.1675786668475;
        Tue, 07 Feb 2023 08:17:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h18-20020a50cdd2000000b004aacec09ca6sm926068edj.42.2023.02.07.08.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 08:17:47 -0800 (PST)
Message-ID: <d5ff098a-731c-f336-efd4-b7405c5e776e@redhat.com>
Date:   Tue, 7 Feb 2023 17:17:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V2 4/8] kvm: x86/mmu: Set mmu->sync_page as NULL for
 direct paging
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
 <20230207155735.2845-5-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230207155735.2845-5-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/23 16:57, Lai Jiangshan wrote:
> From: Lai Jiangshan<jiangshan.ljs@antgroup.com>
> 
> mmu->sync_page for direct paging is never called.
> 
> And both mmu->sync_page and mm->invlpg only make sense in shadowpaging.
> Setting mmu->sync_page as NULL for direct paging makes it consistent
> with mm->invlpg which is set NULL for the case.
> 
> Signed-off-by: Lai Jiangshan<jiangshan.ljs@antgroup.com>

I'd rather have a WARN_ON_ONCE in kvm_sync_page(), otherwise looks good.

Paolo

