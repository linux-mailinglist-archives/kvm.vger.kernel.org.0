Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595F84D1F68
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349276AbiCHRuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349273AbiCHRuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC7845130C
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646761753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HssJmk+YZ6p3KAw12cX/6WW9ODnrbHQBJq5VfOnmOk=;
        b=M8vks5CaLxsmoMD+k71UgzlI24fiCifZEH1NGgSBw5v+KJpWmW9mD7juor+/Stb2UbpNDZ
        XPlzaESAy2GSKpojmNbKp5gCQnLNmUKf6W4Wc3Moxj3+jl2gU4awVWQJp/ecCGZUq9LBud
        ujk4dMoo2MRcnmFACOONz5ypItcNSNQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-Jr0qc5DAMVynkZO2_MjOeQ-1; Tue, 08 Mar 2022 12:49:12 -0500
X-MC-Unique: Jr0qc5DAMVynkZO2_MjOeQ-1
Received: by mail-wm1-f71.google.com with SMTP id 26-20020a05600c22da00b00388307f3503so10532wmg.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:49:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6HssJmk+YZ6p3KAw12cX/6WW9ODnrbHQBJq5VfOnmOk=;
        b=6upyL7dScbJm8HXCFzNShWJzIVrc70Xq2cZgzn/IeKnhXCwnIF9gWRWDhVgttH9bJh
         PBeJDycFACLxOK8VSG2hKv6RlKfwQg7AS+zt2IQzzQQFhQJ1ZMyScfrcX1GYxEAlkriY
         QlOZeNSt+jORY+KZfHA1iFnnFZgPKvyTkdurQersp1rZig//eHHyt5G5vhBm0mJ901P+
         t9jcYH9UX+v9wcqci9xsw7o/jZsLs4HLfP+YfmRLOb46FFxVXHcuOtDVYmQPWCflQ+5L
         jzNAx5z+4fiQPWJsGlH6bjEuThtz/k7uBWr7tv7HSJ1s4KwDyW9girGyskOAHeLuSTr3
         cc0w==
X-Gm-Message-State: AOAM532fi4LwBc3AumPh77Q5COzyDRDecEQbrpNOzT2sFR72fHgRPBUp
        J84iq9KbfnFJQiWKoHs4vwSYtxJclj8Kp3ZAaDR5RU0BEfcFNk1Plj2XDPaqt7nrN0lXFH2rLFP
        5/cD5RB9usilM
X-Received: by 2002:a05:600c:a03:b0:37b:daff:6146 with SMTP id z3-20020a05600c0a0300b0037bdaff6146mr4600291wmp.85.1646761751158;
        Tue, 08 Mar 2022 09:49:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHay2ww/NrI60fjbzAjpBoqpJxLxm9gMCWFGESxLqfRu91mGDesTPJrGXCQD+c8V7kulwgjg==
X-Received: by 2002:a05:600c:a03:b0:37b:daff:6146 with SMTP id z3-20020a05600c0a0300b0037bdaff6146mr4600269wmp.85.1646761750937;
        Tue, 08 Mar 2022 09:49:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b15-20020adfc74f000000b001e888b871a0sm14724489wrh.87.2022.03.08.09.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:49:10 -0800 (PST)
Message-ID: <19e00429-a7e6-f4fd-41be-71afdce6b056@redhat.com>
Date:   Tue, 8 Mar 2022 18:49:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 08/25] KVM: x86/mmu: split cpu_mode from mmu_role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-9-pbonzini@redhat.com> <YieUHVgFxOo3LAa8@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YieUHVgFxOo3LAa8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 18:36, Sean Christopherson wrote:
> The idea was to trigger fireworks due to a incoherent state (e.g. direct mmu_role with
> non-direct hooks) if the nested_mmu was ever used as a "real" MMU (handling faults,
> installing SPs/SPTEs, etc...).  For a walk-only MMU, "direct" has no meaning and so
> rather than arbitrarily leave it '0', I arbitrarily set it '1'.
> 
> Maybe this?
> 
>    The nested MMU now has only the CPU mode; and in fact the new function
>    kvm_calc_cpu_mode is analogous to the previous kvm_calc_nested_mmu_role,
>    except that it has role.base.direct equal to CR0.PG.  Having "direct"
>    track CR0.PG has the serendipitious side effect of being an even better
>    sentinel than arbitrarily setting direct to true for the nested MMU, as
>    KVM will run afoul of sanity checks for both direct and indirect MMUs if
>    KVM attempts to use the nested MMU as a "real" MMU, e.g. for page faults.

Hmm, actually it is set to CR0.PG *negated*, so that future patches can 
get rid of role.ext.cr0_pg.  But really anybody trying to use nested_mmu 
for real would get NULL pointer dereferences left and right in all 
likelihood.  This will be even clearer by the end of the series, when 
the function pointers are initialized at vCPU creation time.

>>
>> +	role.base.direct = !____is_cr0_pg(regs);
>> +	if (!role.base.direct) {
> 
> Can we check ____is_cr0_pg() instead of "direct"?  IMO that's more intuitive for
> understanding why the bits below are left zero.  I was scratching my head trying
> to figure out whether or not this was safe/correct for direct MMUs...

Yes, that's good.

Paolo

