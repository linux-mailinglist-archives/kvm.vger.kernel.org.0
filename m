Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05562324F28
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 12:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhBYL2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 06:28:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235260AbhBYL2V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 06:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614252414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWESMD0nckHAI0xFpXZL4oIkaF2/ZscfrAoYu7OfI+w=;
        b=LbssIS6RXN08uAPydQKG5f46Ql2Y18zrewLfWv0NgkBtqFS2GKKJzN+Yo1x0Hc9mMrHfDG
        jxLOnPvw1pDQDLeuOHs+UeX4Y8JFDAUCqzmpgmj+9q3q33B8KmO2Pjo29vL/BxpLtV4lFY
        MHmct2hw6ADJrgbjOKnI5WaaYcg++qY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-58Va3ZONOQ-mTFeMjb7-5Q-1; Thu, 25 Feb 2021 06:26:52 -0500
X-MC-Unique: 58Va3ZONOQ-mTFeMjb7-5Q-1
Received: by mail-ej1-f72.google.com with SMTP id ml13so2300133ejb.2
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 03:26:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWESMD0nckHAI0xFpXZL4oIkaF2/ZscfrAoYu7OfI+w=;
        b=VozsKQdvOpR6yjSyz/3oOQYmcnUmq6hOER5E6Qqdbj35zwc6vbDZfMpbBm89EuTp7F
         qjhE4tJi/o1+Sn/5HYUbSIgnkFd2CgF8c9jeo5OOnAAxK2jON3OK36vOpeyU5apHxXFI
         sZ56K9sbcLWLB8FUmnwbW9VCXqexe8I/XDDaDKyanUCq2Y6LhLmNsvOq7cuzxMCwNDqB
         2XWAlR7H3uzrNCqytN+nCiL9zLqkgGU2AV9v0WeuWGIHjM7TQLJNU5zXlJvzSa+UQXQ3
         DITKgQiklhCxtTbj0seblA6TcI6jdbQwVWlyDYSp6jgHX7zej1cIfkmVHgHZxBuy3G6G
         +lJQ==
X-Gm-Message-State: AOAM531oraKWOU4CyKRCnLbaIkqtLbuSF4Ic4Wi/UbhQabkpIpDfQMR/
        l7M18Kv99q20Y1byOjQ7IkZe96p9zbcZxhJbnzZ+uu6qYrM7yMKhIb64ObbRl26gWDJw3l9ZlrL
        462ugleZt7aEg
X-Received: by 2002:a17:906:2b0a:: with SMTP id a10mr2214737ejg.513.1614252411242;
        Thu, 25 Feb 2021 03:26:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+FV6cFCWq34Zp4VXzSaCx9CjsJto7qwRC97dXBeI5c95SCD9qPGVFJCozP5ss3voP39HZCA==
X-Received: by 2002:a17:906:2b0a:: with SMTP id a10mr2214723ejg.513.1614252411050;
        Thu, 25 Feb 2021 03:26:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dm20sm3237866edb.59.2021.02.25.03.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 03:26:50 -0800 (PST)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nathan Tempelman <natet@google.com>, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Ashish.Kalra@amd.com, Nathaniel McCallum <npmccallum@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>
References: <20210224085915.28751-1-natet@google.com>
 <04b37d71-c887-660b-5046-17dec4bb4115@redhat.com>
 <YDaFtRUAZ+P6Nrpy@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d01c686b-45e0-836a-e144-4330c46f4d42@redhat.com>
Date:   Thu, 25 Feb 2021 12:26:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDaFtRUAZ+P6Nrpy@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/21 17:58, Sean Christopherson wrote:
> That being said, is there a strong need to get this into 5.12?  AIUI, this hasn't
> had any meaningful testing, selftests/kvm-unit-tests or otherwise.  Pushing out
> to 5.13 might give us a good chance of getting some real testing before merging,
> depending on the readiness of SEV testing support.

Note that I don't mean including this in the merge window.  However, I 
know that there are multiple people working on alternative SEV live 
migration support, and as long as we are sure that the API is simple and 
useful, it should be okay to merge this for rc2 or rc3.

Paolo

