Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A646D5FB
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhLHOrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhLHOq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 09:46:58 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A03CC0617A1;
        Wed,  8 Dec 2021 06:43:26 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id v1so9216551edx.2;
        Wed, 08 Dec 2021 06:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rorkq0kqbS106yCnMdxNh4H+tZeEZk4vhvZMtOx+RQ4=;
        b=T3mfDWm/XqaADQeVNwzK/X8+hI+FconPHoWo6op2K9PxyThxL1T38t2a3dx5Xh4PfW
         iLoTV9rja69gpLtgr66N21boCJeEsaM/jY3TU/FvTOIbVY+ARWnGgqXtahW/xOQceEz0
         eLoe43vh5rZ2SolOLIajqKHiLqQSH4YNiztYIm6KfhElEtSZ9hQJFJryyfWhiq3Qawy4
         YQm5eBbfTdRocGGCU8z81P7fSgxvnU5sCufQzM/jYiUoAptS/wsu62k+zo7LWQ8AmcwW
         17TOvUH9bJlBQJ1a7vm6ilUEt3K3Hbu1hYLMntw72EMbIuKovpldwpE56i+vdBMQunCy
         EWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rorkq0kqbS106yCnMdxNh4H+tZeEZk4vhvZMtOx+RQ4=;
        b=01Ki+LYCnWih4txKgmb1NiQ0Oc4+SEYHaxDbZL6FxbTeF7iAoBLUGPBKhFs6m+T8Ok
         WD4ytykjdHTUeVcL/yFcZFESPl6w39AnAMrHj/ruJwTTz/WcS4fc3Ox9r27jhMh39wX/
         KJE5WKuuwkipsYqR8gPTtHa/gyDUzA2OwI6rCI3WG45J7J/UNUMZu4irJ3h4gRe5QA8i
         qCSob6H3JbeUA0rZ/iJ+xhInJHnWPA6aXEktQbCOAiFlbZz8hkKnk/9hiuzvgDrvR5qb
         E/kYfljyB/9QeCWFk8fGcO7yBT2uHCmljkI601d4wLf2Q8zIvQpGnkfcYy9mgV3CoCBe
         QJOA==
X-Gm-Message-State: AOAM5318aNL6RjSnODyvETEU8Igsb7SfyWM9inG3KOPn/cddROY+dw5E
        ExV+SA5ajvOFCNWsvkKTIZBSUUePGoE=
X-Google-Smtp-Source: ABdhPJwfAih1UJbuG8DluPuj4Xflbizg9LMcjZmEsGKRCYoy5N5def2qOGTnZAHflDSy0OchG6cTIQ==
X-Received: by 2002:a17:906:5f94:: with SMTP id a20mr8047146eju.256.1638974601767;
        Wed, 08 Dec 2021 06:43:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id oz11sm1691246ejc.81.2021.12.08.06.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:43:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e1c4ec6a-7c1e-b96c-63e6-d07b35820def@redhat.com>
Date:   Wed, 8 Dec 2021 15:43:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 21/26] KVM: SVM: Drop AVIC's intermediate
 avic_set_running() helper
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <20211208015236.1616697-22-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208015236.1616697-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 02:52, Sean Christopherson wrote:
> +	/*
> +	 * Unload the AVIC when the vCPU is about to block,_before_  the vCPU
> +	 * actually blocks.  The vCPU needs to be marked IsRunning=0 before the
> +	 * final pass over the vIRR via kvm_vcpu_check_block().  Any IRQs that
> +	 * arrive before IsRunning=0 will not signal the doorbell, i.e. it's
> +	 * KVM's responsibility to ensure there are no pending IRQs in the vIRR
> +	 * after IsRunning is cleared, prior to scheduling out the vCPU.

I prefer to phrase this around paired memory barriers and the usual 
store/smp_mb/load lockless idiom:

	/*
	 * Unload the AVIC when the vCPU is about to block, _before_
	 * the vCPU actually blocks.
	 *
	 * Any IRQs that arrive before IsRunning=0 will not cause an
	 * incomplete IPI vmexit on the source, therefore vIRR will also
	 * be checked by kvm_vcpu_check_block() before blocking.  The
	 * memory barrier implicit in set_current_state orders writing
	 * IsRunning=0 before reading the vIRR.  The processor needs a
	 * matching memory barrier on interrupt delivery between writing
	 * IRR and reading IsRunning; the lack of this barrier might be
	 * the cause of errata #1235).
	 */

Is there any nuance that I am missing?

Paolo

> +	 */
> +	avic_vcpu_put(vcpu);
> +

