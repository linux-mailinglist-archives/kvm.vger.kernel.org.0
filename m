Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167976F0E0
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 19:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbjHCRtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 13:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbjHCRtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 13:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324F81718
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 10:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691084897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8w3UIrphhKQ2XHpYcuYIqOipT2J9rUiRAVKoTRmuc0=;
        b=GO95dhYhOpMiEIYY8zMoFvgKU0Jv4ZhzVQbDSUj2fOidpktXqnoTunXQfWXcIa9yWLpF73
        OXlMSJKiIX4zJBm1bK74zgERQNdHOe8zWuC0JzxYgFswhKAJNESEECfScZBSxCNwo9BPPY
        bz7/6oDue/gmpZoDbfzHya6fh1n9h2k=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-C4yPhqvgNnejCevGL4_v2A-1; Thu, 03 Aug 2023 13:48:16 -0400
X-MC-Unique: C4yPhqvgNnejCevGL4_v2A-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-522a85b4caaso1643911a12.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 10:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691084895; x=1691689695;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k8w3UIrphhKQ2XHpYcuYIqOipT2J9rUiRAVKoTRmuc0=;
        b=ei/jsLTb4QPXndWGWpInTAP2R7jGVsKjM6wE74gBDfGDCEHjNSH9R7Z/cB8WcxQTt8
         AyO9WTEiAd+EUAua1KWjsNhuZe4YVAqLxfrB7sYK7bW10vQ4hxc9BN6az23HoyDwvMLm
         ZJQ4cLavRVIP5J/16/ETPNmR/UX1i1LC8lckwGCb+d54nrErz4aXSEz6Mge3BdGfAfJu
         DjgUtHHrAO88Hb2D0s51bsSvwCpCJWodAonI9+eXd9fmrSqrxbG40rJyilwCcn3PRhgw
         1AdqbQpdUNbfaTjyx+Gs1smkQm5Wgzwf+Ml8YKA9HupaHwD2voBeO/6oIl2ohZpRht4F
         RWPg==
X-Gm-Message-State: ABy/qLZTYrRRyzrm4akh/lrjMQdS/U3BSTGBZJgGx75IOrnrgcn5YIx9
        DflB6ItO85uCnHD5CSTtwI77VqMAo5qz6IdDePVgwSqi2EC8knMVqx/zqE39nwwqqfqaEoOEjFW
        MST42I3lwCdb5
X-Received: by 2002:aa7:ca58:0:b0:522:b876:9ef5 with SMTP id j24-20020aa7ca58000000b00522b8769ef5mr10879522edt.8.1691084895080;
        Thu, 03 Aug 2023 10:48:15 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGxuw8b/Ix8dvNkObQ9VxnrmDGH8imE0GdHZMF47iewomEpxIOxDe7YZHHPKQR6L9yUeeRRaw==
X-Received: by 2002:aa7:ca58:0:b0:522:b876:9ef5 with SMTP id j24-20020aa7ca58000000b00522b8769ef5mr10879501edt.8.1691084894707;
        Thu, 03 Aug 2023 10:48:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k20-20020a05640212d400b005228614c358sm82933edx.88.2023.08.03.10.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 10:48:13 -0700 (PDT)
Message-ID: <e55656be-2752-a317-80eb-ad40e474b62f@redhat.com>
Date:   Thu, 3 Aug 2023 19:48:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-2-mhal@rbox.co> <ZMhIlj+nUAXeL91B@google.com>
 <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co> <ZMqr/A1O4PPbKfFz@google.com>
 <38f69410-d794-6eae-387a-481417c6b323@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
In-Reply-To: <38f69410-d794-6eae-387a-481417c6b323@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 02:13, Michal Luczaj wrote:
> Anyway, while there, could you take a look at __set_sregs_common()?
> 
> 	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
> 	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
> 	vcpu->arch.cr0 = sregs->cr0;
> 
> That last assignment seems redundant as both vmx_set_cr0() and svm_set_cr0()
> take care of it, but I may be missing something (even if selftests pass with
> that line removed).

kvm_set_cr0 assumes that the static call sets vcpu->arch.cr0, so indeed 
it can be removed:

         static_call(kvm_x86_set_cr0)(vcpu, cr0);
         kvm_post_set_cr0(vcpu, old_cr0, cr0);
         return 0;

Neither __set_sregs_common nor its callers does not call 
kvm_post_set_cr0...  Not great, even though most uses of KVM_SET_SREGS 
are probably limited to reset in most "usual" VMMs.  It's probably 
enough to replace this line:

         *mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;

with a call to the function just before __set_sregs_common returns.

Paolo

