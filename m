Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBBB4B0A00
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 10:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbiBJJwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 04:52:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239080AbiBJJwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 04:52:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0E08252
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644486728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f91FCCeGq06aNvkcPfCWFTAXz7qvGKLhqYaagKj3uqI=;
        b=T5mq/BigZoI4CpYeFaMWtVE6R1jacjZN8Pp5nv/FG9qXtVu3Z19gYS1rIl2eGmA19CQWtb
        2BfPSdjHxwqIWxC2EeqpotuQ7kwlelCokYjkvwhvcFxE5BhFlIfda0jZDDp6lT36Fy0wy8
        QsWrOYxQmkzwk0AWQ4wtMaz1fEchMV0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-EL9c58Q0MxCmvAyyNKCSNw-1; Thu, 10 Feb 2022 04:52:06 -0500
X-MC-Unique: EL9c58Q0MxCmvAyyNKCSNw-1
Received: by mail-ej1-f70.google.com with SMTP id vj1-20020a170907130100b006ccc4f41d03so2459311ejb.3
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:52:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f91FCCeGq06aNvkcPfCWFTAXz7qvGKLhqYaagKj3uqI=;
        b=aNPYDqbzjvjGtt2lSfg/8ofOGJinLCh4+ktXcAeGHwiBJJZ4j4yjorrlQVv4VkAjWV
         d+w7TJ3wA0ZMdfY/DEC4YKH1g3RlEEh6TIQ78u9nWwXZFIpJVp1x/4ACaFG2Myml0d0N
         foCKWUBecG/eHXiQc3KNDm6jDhyE82YelYj178uUWcy+0/Fy/d8ShFG0MUPSDFHC0b/n
         DTzJbpYeRUaarFCVpkPhL8iBoDpnvV8oDrug86sXj7Zs8Ma/or27BNWKIMVzJEeNz5Lk
         VyCumSB7frf5qwXn3X4IBXmmT6bxLWnirGW2IHqJ0szDIrMa47Sup32L0vxWdbG2Y0Zs
         wC+A==
X-Gm-Message-State: AOAM530EY3OmKKvrkcObrH3aQjQSFKdTrk+FE+pMdJcTKr1M6pZakMLd
        vQSYEnmfs/Wa/VPOmHI+YOLiduijNg/zXy7bouxwHAG/ZCEsAqeeAYGfljzJLyeNmFep/qWxIFH
        hebv2k4dhOa8C
X-Received: by 2002:a17:907:16aa:: with SMTP id hc42mr5656296ejc.307.1644486725361;
        Thu, 10 Feb 2022 01:52:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzPiWFgV580SgcmFbsoPownArFuAX6Qoh20+/Wh5oVOlIGwlHf3OkEF/WdgZ58aQXeQy1XtA==
X-Received: by 2002:a17:907:16aa:: with SMTP id hc42mr5656283ejc.307.1644486725183;
        Thu, 10 Feb 2022 01:52:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id r3sm6926943ejd.129.2022.02.10.01.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 01:52:04 -0800 (PST)
Message-ID: <1e8c38eb-d66a-60e7-9432-eb70e7ec1dd4@redhat.com>
Date:   Thu, 10 Feb 2022 10:52:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 07/23] KVM: MMU: remove kvm_mmu_calc_root_page_role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-8-pbonzini@redhat.com> <YgRgrCxLM0Ctfwrj@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgRgrCxLM0Ctfwrj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 01:47, Sean Christopherson wrote:
> The nested mess is likely easily solved, I don't see any obvious issue with swapping
> the order.  But I still don't love the subtlety.  I do like shaving cycles, just
> not the subtlety...

Not so easily, but it's doable and it's essentially what I did in the 
other series (the one that reworks the root cache).

Quick spoiler: there's a complicated dependency between the _old_ values 
in kvm_mmu and the root cache, so that the root cache code currently 
needs both the old MMU state (especially shadow_root_level/root_level) 
and the new role.

kvm_mmu_reset_context does the expensive kvm_mmu_unload to cop out of 
having to know in advance the new role; the crux of the other series is 
to remove that need, so that kvm_mmu_reset_context does not have to cop 
out anymore.

> If we do rework things to have kvm_mmu_new_pgd() pull the role from the mmu, then
> we should first add a long overdue audit/warn that KVM never runs with a mmu_role
> that isn't consistent with respect to its root SP's role.

There's a much cheaper check that can be done to enforce the invariant 
that kvm_mmu_new_pgd must follow kvm_init_mmu: kvm_init_mmu sets a 
not_ready flag, kvm_mmu_new_pgd clears it, and kvm_mmu_reload screams if 
it sees not_ready == 1.

Paolo

