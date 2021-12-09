Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CE346F6F3
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 23:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhLIWiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 17:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhLIWiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 17:38:20 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94877C061746;
        Thu,  9 Dec 2021 14:34:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y13so23939251edd.13;
        Thu, 09 Dec 2021 14:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e0xWu4FRBdpcPopR+tYuIVQgtChl7uURnH22cFlaA5A=;
        b=fXFqrXO6Mqxbn1VMEeZUPYqwDn0Axi1WQoRKyIm0Wko3qi8To1yhBnzyQBnuuJpvU9
         tR9dyu+xSqUrDMvvahFuENMdiHPMXRJ4o4DKWl7ljy3Mz+Nrt/S+gISbeuWgkR+cEOle
         5HfXVZsTYOn1456X/asYJBDh/+KY3upkcOeEjnBkupzBDml+tuhSKMfrF3aI5eR2H+9m
         AxeYoRDcvdBsZd0n9yd/Xbwhp7Eyc1p3mbosWQ4yNA3IyW8kf/9iawYPt5tkAmOak1+/
         fGSMnJ7WfE0c7M44ExGyn8D0Cv6BJ1MqLcK9O6mLpBWThWXCeEb72RJR4HaLNOYG3YT4
         QWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e0xWu4FRBdpcPopR+tYuIVQgtChl7uURnH22cFlaA5A=;
        b=1MLD59EP+JVcEc5VBRs6frf/dkL0DSAfDgGS/VBbjle1HZpusBFL1uac5P9uCpCHG8
         kVMGeClQISueD2mEaaYaFNyfMcKPXF9N3UYdZW2ykJL9uCQc1St0tcGAb8gqWh5Zxo1f
         izK6npS5zGKg6KVMROtc+swwo+hx+BPmoTY46CJyyPVbYhSFHRv/ikGsoTWX/l20kY3J
         uAzxvYeYOOie6tQG9b0BIGgD7tQwaRlmBaLbRu3mn7176j5x+3K4YbF4s1QXzZ1v230u
         vB7cUPcOK0d7nL0Yjmh06ITenAF2zwzKq6NCXWsaxo7ODDkOH2IPXrMwElW9USse6ieE
         f03Q==
X-Gm-Message-State: AOAM533/zkNQl0m+RBM4espAI5CJ86WOk2IkoQLiR/EIvB8LKGZJSYZn
        xGpy5SGnHvLzv0wODrWWo7k=
X-Google-Smtp-Source: ABdhPJyxMeAJrbZymRVBb0iPORoJGZau5fLIvkWo7GHCG5UbZ3oj1yMvqn13BjVbdYGJRifVkBRRAw==
X-Received: by 2002:a17:906:b2c7:: with SMTP id cf7mr19483296ejb.303.1639089285134;
        Thu, 09 Dec 2021 14:34:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id go10sm459347ejc.115.2021.12.09.14.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 14:34:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6cb2cd57-16f3-d0ec-adf6-cb8fdcbae035@redhat.com>
Date:   Thu, 9 Dec 2021 23:34:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 08/12] KVM: Reinstate gfn_to_pfn_cache with
 invalidation support
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-9-dwmw2@infradead.org>
 <b1bacc6f-be56-4108-6e52-4315a021184b@redhat.com>
 <b614d9ae0fe7910cfa72eee0b4077776f8012e5f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b614d9ae0fe7910cfa72eee0b4077776f8012e5f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 21:40, David Woodhouse wrote:
> 
> NP, very useful fixes. Thanks. Incremental patch looks like this. It
> passes the xen_shinfo_test self-test; will test it with real Xen guests
> tomorrow and repost based on your kvm/next tree once it shows up.

Compared to the review it's missing this hunk:


@@ -265,7 +265,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
   
   	gpc->valid = false;
   
-	old_khva = gpc->khva;
+	old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
   	old_dirty = gpc->dirty;
   	old_gpa = gpc->gpa;
   	old_pfn = gpc->pfn;

Otherwise looks good, thanks!

Paolo
