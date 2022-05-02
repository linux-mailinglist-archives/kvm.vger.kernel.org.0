Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84C751740C
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 18:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386287AbiEBQUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 12:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386251AbiEBQUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 12:20:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93672E0B5
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651508197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsSALeBOA7ZWPCcmJgm1/wGrXg4q+JRs+W7rdBh5ql0=;
        b=ddC85xIe6EyqknPGRq3GtNS4EXuI15HxsJdpEO0Tl5onc3PSWV58fjxh9JHjYSDOHF1hVw
        NxwOlAb+slnI8T04sYUzBU1TlxbmKXf/9ALAOD0aoaN4606cGwnZvz0q45bGsl0v4QyfKt
        EDH3AlW6m3HF3wuoQWaEowMNEoXCNJU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-k3I802yfOLqfqo-IZ17hnw-1; Mon, 02 May 2022 12:16:36 -0400
X-MC-Unique: k3I802yfOLqfqo-IZ17hnw-1
Received: by mail-ej1-f71.google.com with SMTP id sh14-20020a1709076e8e00b006f3b7adb9ffso7015816ejc.16
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 09:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rsSALeBOA7ZWPCcmJgm1/wGrXg4q+JRs+W7rdBh5ql0=;
        b=Iln3ZBmOxAiNltFfJRDomAFRc9Kq/QU7YkpTmwx7+oMPgR32DTIj3AgrptUq4HQPCp
         R1ifUKL4gfY8XfJgg/H3eKxUFlss0D3zfHOoKBwYRV37nQqVISOpX6e7j+5u7Ngg//ry
         d3HzSd6eo/Ciq1LQE+hbjvvdPw4+URpkX1UwYmf2UUvy2mMzjrU3AxtCNj8Iw4OyqXu4
         6hA7yY7PmPgHxXWt1aG+i5FD6WtTJzrMoqTeNy1Kuo3C4EsN+SlWwD33rlFGvsuNMBDk
         8M2mSlXUUo2G5ik6+lzCHw7+OVT9Tso8+b8Wh0dCv/EsNoFZEhsmlDs7gAiXEG8TWhtY
         LtxA==
X-Gm-Message-State: AOAM5311unACfQ5LMyEMRgnn7JkjHidA0vYNT2BoJckV4K+u5vKU9XQy
        OrIpUUwwbal5WkZZDV8GeHxLPzTHubOxBDdxTJ8umepXnF+HLZmQ3WhnJcbR0AmyEzdurUCueqi
        xY3Mp21QSsBI4
X-Received: by 2002:a17:907:7243:b0:6f4:1ce5:4ac4 with SMTP id ds3-20020a170907724300b006f41ce54ac4mr10031098ejc.198.1651508195316;
        Mon, 02 May 2022 09:16:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzU+EeBkU27lcZBl76YkQuPJxEcLDXD3icDKAgpvTHo8/6jVVf/8/GP3t2VfXVkZob1OASV3A==
X-Received: by 2002:a17:907:7243:b0:6f4:1ce5:4ac4 with SMTP id ds3-20020a170907724300b006f41ce54ac4mr10031056ejc.198.1651508195058;
        Mon, 02 May 2022 09:16:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j12-20020a50ed0c000000b0042617ba63d4sm6834162eds.94.2022.05.02.09.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 09:16:34 -0700 (PDT)
Message-ID: <bcb2a90f-a2ed-94fa-985e-d7b9efe52ae4@redhat.com>
Date:   Mon, 2 May 2022 18:16:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 9/9] KVM: VMX: enable IPI virtualization
Content-Language: en-US
To:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
References: <20220419154510.11938-1-guang.zeng@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220419154510.11938-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 17:45, Zeng Guang wrote:
> +static bool vmx_can_use_pi_wakeup(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * If a blocked vCPU can be the target of posted interrupts,
> +	 * switching notification vector is needed so that kernel can
> +	 * be informed when an interrupt is posted and get the chance
> +	 * to wake up the blocked vCPU. For now, using posted interrupt
> +	 * for vCPU wakeup when IPI virtualization or VT-d PI can be
> +	 * enabled.
> +	 */
> +	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
> +}

Slightly more accurate name and comment:

static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
{
         /*
          * The default posted interrupt vector does nothing when
          * invoked outside guest mode.   Return whether a blocked vCPU
          * can be the target of posted interrupts, as is the case when
          * using either IPI virtualization or VT-d PI, so that the
          * notification vector is switched to the one that calls
          * back to the pi_wakeup_handler() function.
          */
         return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
}


Paolo

