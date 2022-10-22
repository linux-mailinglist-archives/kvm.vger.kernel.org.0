Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF357608929
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 10:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJVIbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 04:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiJVIau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 04:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898B42D039A
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666425666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ebXIiW1Yrr/qNgGjH/kQ+HrJ7XBx9IGzWP9027pe0Dc=;
        b=ZKnYvkPDbto6C6BpXuvBW5UN7WIE5zuyynb6XQYCjmf1LKyouUX8vafQ2hmYiWsGMpt5G0
        VM74cB/7QYt1mWJUqmII+RPbg3+d0brsentMamyLTFbID405aEOGgPfOaA+sPE5NWfUikX
        Dd6P2mP97nWNXzluUQVAO4pFK87S+nA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-79-nWEJt-fDOsGA9GleC6gbqg-1; Sat, 22 Oct 2022 03:46:08 -0400
X-MC-Unique: nWEJt-fDOsGA9GleC6gbqg-1
Received: by mail-ed1-f72.google.com with SMTP id b13-20020a056402350d00b0045d0fe2004eso4738089edd.18
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 00:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ebXIiW1Yrr/qNgGjH/kQ+HrJ7XBx9IGzWP9027pe0Dc=;
        b=uYfAuUxSBvikMtBCGN1kFLu2r4pRPGpbr0y++Gm+UHhtPOsaA2BVUO4Cm27gajaPWt
         vFohmQ/B5k7tw4xIcoKeIc7svh7qbHRWzQpm5uFq10wdQk/cjY9GT71lsMVskAIqpvG+
         IBmjSZsfE3IJTY1kwn4WmPT8P1kiDgO+VCEoPWvO2vedCT9f32L/oRrGJJWhTMPD1Ei2
         C6oFBiOu2jscyOaT0VuuhJ6LKDv0bsXiYXfIFv9GhtrYbhpEHXWzOLXNgbYAjM1GdC8V
         sl6G8EyO8NQOUonCr8kClZew3jpZI+nYpX9l9ZP3gHGNhqzWs7BN0RbJHyjauK33Fhn0
         PRRA==
X-Gm-Message-State: ACrzQf2oCT+llJQ/1Y7FimhkuUbI8yWoogszGL6xozzvMTVKsdgpuGIK
        ChoePe3aermoy9plwOIukTQ89rM0ndYN8n8bvTbtBR3xNyHRWjyAzcgN38lw/PQc6LyBx79w6Vn
        b1PHx1fxvH3UC
X-Received: by 2002:a17:906:15ca:b0:78d:b7b3:2afa with SMTP id l10-20020a17090615ca00b0078db7b32afamr19053531ejd.69.1666424766893;
        Sat, 22 Oct 2022 00:46:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6kAr92I5pdKp3ObTKLZnFdDIJSEpTIIYDr+mzB+LsUa9WEBSgGMSSskq7p6IYXK5X2pBwSlQ==
X-Received: by 2002:a17:906:15ca:b0:78d:b7b3:2afa with SMTP id l10-20020a17090615ca00b0078db7b32afamr19053521ejd.69.1666424766672;
        Sat, 22 Oct 2022 00:46:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id kz1-20020a17090777c100b0073d753759fasm12882546ejc.172.2022.10.22.00.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 00:46:05 -0700 (PDT)
Message-ID: <d64d2144-449e-0dec-6bc1-a5478a0febc0@redhat.com>
Date:   Sat, 22 Oct 2022 09:46:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Cc:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
 <dd357565-d428-499f-fa0e-e35aa043449f@amd.com> <YzxfdQ7DrT9X6t7j@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YzxfdQ7DrT9X6t7j@google.com>
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

On 10/4/22 18:29, Sean Christopherson wrote:
> If we really want to the number to have any kind of meaning without needing a pile
> of churn for every update, the best idea I can think of is to name them reserved_<offset>.
> That way only the affected reserved field needs to be modified when adding new
> legal fields.  But that has it's own flavor of maintenance burden as calculating
> and verifying the offset is a waste of everyone's time.

Finding the right offsets is usually pretty quick because they can be 
found in the manual (or something close to the offset can be found 
there) and verifying them can be done with BUILD_BUG_ON.

If Carlos prepared a patch using offsets (with BUILD_BUG_ON to ensure no 
future bitrot) I would apply it gladly.  If it's just renumbering as in 
this one, however, I'd just ignore it.

Paolo

Paolo

