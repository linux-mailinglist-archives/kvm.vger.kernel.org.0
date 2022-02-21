Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6274BE215
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378711AbiBUPBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 10:01:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378712AbiBUPBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 10:01:42 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D32220F2;
        Mon, 21 Feb 2022 07:01:13 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id gb39so34054496ejc.1;
        Mon, 21 Feb 2022 07:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BPtReENKQxU85jH52Zt/PBlxinx1W4smwidmo2G0UFE=;
        b=ZYjkp8GXtoEuZsbdo36X31dNE58cEe2rktTPHZPI8K7LlbRXI15qdvpryRujuzD5yW
         MdX9ot123swKKMOIRmHlnVw2I3OlHKCQdh+V6bOc4voyapFiJBSe1KzZCT7qANOMaO+Q
         kOwtN5IYE/ZM+ureSYHG2urtq303JzY7H6NemmADZPUtWEqszgXfQvnqzUmR/60GtVec
         UVuy7e64UNSgHsAs67hjzEiJZ3soH0Pbekm2OYiANrDp+oRtkz7205AR12t9jKvIp5c5
         Ke+JBjYVg/gsEk6X2kD3TYxBQue5nRPinL5dL9W0uNV3tJ0R1uXsmBaaIVlj6/yq17yP
         Cyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BPtReENKQxU85jH52Zt/PBlxinx1W4smwidmo2G0UFE=;
        b=zFcm/BBmwaAKg1tAMXHl29ag3aoP/2D7q0ka8TRkRW7gseEQHP31CNeY9rUAgYhs0C
         gz5THIYN/IUHRe0XUNc8U+gNBJiY1HE15bxXRSRdXK2Qz9M7W4nd+1FIpppv2qjIjHVN
         kMSQv4rzjXkdJkhRka1+uVtrO5sRj5C40B+SgjCyeIDjS14O7xbhwAlLqnTsY21HVlz9
         KjiqXQCtNWbB3GmVeLWh9O30EzBazs++U2mMwUhTENVpDOIpNgg/MjOoX8SbDeq7pNF3
         +N8q3fJWoviBQyVgKziLQg3QfzNvuXoczFoU6O/7GPOhGNqRiIEP2FQ+Lh07uc+Pquew
         WufQ==
X-Gm-Message-State: AOAM533GDxOJw9HZbGyy9mN00DnTlKLTQKhvULbGxowyGxTZnu9v8xAR
        QNu42iTFXSmOPEltXcT4//vMaLn1kvg=
X-Google-Smtp-Source: ABdhPJxNhaNGp2hDd0eH4fg7BlyY2bIDbqrZh0nD6r+9ifRR9vGIu7fml3FGrd4hK2xU3AwZGJWCOg==
X-Received: by 2002:a17:906:1393:b0:6ce:eac4:4ebe with SMTP id f19-20020a170906139300b006ceeac44ebemr15622997ejc.643.1645455671858;
        Mon, 21 Feb 2022 07:01:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j18sm5261552ejc.166.2022.02.21.07.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 07:01:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3863d7f1-a551-129d-d218-c4cce40041d3@redhat.com>
Date:   Mon, 21 Feb 2022 16:01:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 17/18] KVM: x86: flush TLB separately from MMU reset
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-18-pbonzini@redhat.com> <YhAyX+Bc3x4+ZMTG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YhAyX+Bc3x4+ZMTG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/22 00:57, Sean Christopherson wrote:
> I appreciate the cleverness in changing only a single like, but I think both
> pieces warrant a mention.  How 'bout this, to squeak by with two lines?
> 
> 	/*
> 	 * Reset the MMU and flush the TLB if paging was enabled (INIT only, as
> 	 * CR0 is currently guaranteed to be '0' prior to RESET).  Unlike the

Let's just make it clearer:

          * On the standard CR0/CR4/EFER modification paths, there are several
          * complex conditions determining whether the MMU has to be reset and/or
          * which PCIDs have to be flushed.  However, CR0.WP and the paging-related
          * bits in CR4 and EFER are irrelevant if CR0.PG was '0'; and a reset+flush
          * is needed anyway if CR0.PG was '1' (which can only happen for INIT, as
          * CR0 will be '0' prior to RESET).  So we only need to check CR0.PG here.

Paolo
